#include "kernel/types.h"
#include "user/user.h"
#include "user/list.h"
#include "user/threads.h"
#include "user/threads_sched.h"

#define NULL 0

/* default scheduling algorithm */
struct threads_sched_result schedule_default(struct threads_sched_args args)
{
    struct thread *thread_with_smallest_id = NULL;
    struct thread *th = NULL;
    list_for_each_entry(th, args.run_queue, thread_list) {
        if (thread_with_smallest_id == NULL || th->ID < thread_with_smallest_id->ID)
            thread_with_smallest_id = th;
    }

    struct threads_sched_result r;
    if (thread_with_smallest_id != NULL) {
        r.scheduled_thread_list_member = &thread_with_smallest_id->thread_list;
        r.allocated_time = thread_with_smallest_id->remaining_time;
    } else {
        r.scheduled_thread_list_member = args.run_queue;
        r.allocated_time = 1;
    }

    return r;
}

/* MP3 Part 1 - Non-Real-Time Scheduling */
/* Weighted-Round-Robin Scheduling */
struct threads_sched_result schedule_wrr(struct threads_sched_args args)
{
    struct threads_sched_result r;
    // TODO: implement the weighted round-robin scheduling algorithm
    // struct thread *th = list_entry(args.run_queue, struct thread, thread_list);
    struct thread *th = NULL;
    if ((args.run_queue)->next != args.run_queue)
        th = list_entry((args.run_queue)->next, struct thread, thread_list);
    // printf("th: id: %d, ptime: %d, weight: %d\n", th->ID, th->processing_time, th->weight);
    
    if (th != NULL){
        r.scheduled_thread_list_member = &th->thread_list;
        if (args.time_quantum * th->weight > th->remaining_time)
            r.allocated_time = th->remaining_time;
        else
            r.allocated_time = args.time_quantum * th->weight;
        //printf("remain: %d t*w %d\n", th->remaining_time, args.time_quantum * th->weight);
    }
    else{
        r.scheduled_thread_list_member = args.run_queue;
        struct release_queue_entry* rqe = NULL;
        int mn = 100000;
        list_for_each_entry(rqe, args.release_queue, thread_list){
            if (rqe->release_time < mn)
                mn = rqe->release_time;
        }
        r.allocated_time = mn - args.current_time;
    }
    return r;
}

/* Shortest-Job-First Scheduling */

struct threads_sched_result schedule_sjf(struct threads_sched_args args)
{
    struct threads_sched_result r;
    // TODO: implement the shortest-job-first scheduling algorithm
    struct thread *thread_with_shortest_job = NULL;
    struct thread *th = NULL;
    struct release_queue_entry* rqe = NULL;
    int mn = 10000000;
    list_for_each_entry(th, args.run_queue, thread_list) {
        if (thread_with_shortest_job == NULL || th->remaining_time < thread_with_shortest_job->remaining_time || (th->remaining_time == thread_with_shortest_job->remaining_time && th->ID < thread_with_shortest_job->ID))
            thread_with_shortest_job = th;
    }
    list_for_each_entry(rqe, args.release_queue, thread_list){
        if (rqe == NULL || (rqe->release_time >= args.current_time && rqe->release_time < mn)){
            th = rqe->thrd;
            if (th->processing_time < thread_with_shortest_job->remaining_time - (rqe->release_time - args.current_time) || (th->processing_time == thread_with_shortest_job->remaining_time - (rqe->release_time - args.current_time) && th->ID < thread_with_shortest_job->ID))
                mn = rqe->release_time;
        }
    }
    if (thread_with_shortest_job != NULL){
        r.scheduled_thread_list_member = &thread_with_shortest_job->thread_list;
        if (thread_with_shortest_job->remaining_time > mn - args.current_time)
            r.allocated_time = mn - args.current_time;
        else
            r.allocated_time = thread_with_shortest_job->remaining_time;
    }
    else{
        r.scheduled_thread_list_member = args.run_queue;
        struct release_queue_entry* rqe = NULL;
        int mn = 100000;
        list_for_each_entry(rqe, args.release_queue, thread_list){
            if (rqe->release_time < mn)
                mn = rqe->release_time;
        }
        r.allocated_time = mn - args.current_time;
    }
    return r;
}

/* MP3 Part 2 - Real-Time Scheduling*/
/* Least-Slack-Time Scheduling */

struct threads_sched_result schedule_lst(struct threads_sched_args args)
{
    struct threads_sched_result r;
    // TODO: implement the least-slack-time scheduling algorithm
    struct thread *th = NULL;
    struct thread *lst = NULL, *ms = NULL;
    int miss = 0;
    list_for_each_entry(th, args.run_queue, thread_list) {
        if (th->current_deadline <= args.current_time){
            miss = 1;
            if (ms == NULL || th->ID < ms->ID)
                ms = th;
        }
        if (!miss){
            if (lst == NULL || (th->current_deadline - args.current_time - th->remaining_time) < (lst->current_deadline - args.current_time - lst->remaining_time) || ((th->current_deadline - args.current_time - th->remaining_time) == (lst->current_deadline - args.current_time - lst->remaining_time) && th->ID < lst->ID))
                lst = th;
        }
    }
    if (miss){
        r.scheduled_thread_list_member = &ms->thread_list;
        r.allocated_time = 0;
    }
    else if (lst == NULL){
        r.scheduled_thread_list_member = args.run_queue;
        struct release_queue_entry* rqe = NULL;
        r.allocated_time = 1000000;
        list_for_each_entry(rqe, args.release_queue, thread_list){
            if (rqe->release_time - args.current_time < r.allocated_time)
                r.allocated_time = rqe->release_time - args.current_time;
        }
    }
    else{
        r.scheduled_thread_list_member = &lst->thread_list;
        int mn = 100000;
        struct release_queue_entry* rqe = NULL;
        list_for_each_entry(rqe, args.release_queue, thread_list){
            th = rqe->thrd;
            //printf("id: %d %d\n", th->ID,(th->current_deadline - rqe->release_time - th->remaining_time));
            if (rqe->release_time < mn && rqe->release_time >= args.current_time){
                //printf("th: d: %d r: %d lst: %d\n", th->deadline, th->processing_time, (lst->current_deadline - args.current_time - lst->remaining_time));
                if (((th->deadline - th->processing_time) < (lst->current_deadline - args.current_time - lst->remaining_time) || ((th->deadline - th->processing_time) == (lst->current_deadline - args.current_time - lst->remaining_time) && th->ID < lst->ID)))
                    mn = rqe->release_time;
            }
        }
        int x = (lst->current_deadline - lst->remaining_time - args.current_time >= 0 ? lst->remaining_time : lst->current_deadline - args.current_time);
        if (x > mn - args.current_time)
            r.allocated_time = mn - args.current_time;
        else
            r.allocated_time = x;
    }
    return r;
}

/* Deadline-Monotonic Scheduling */
struct threads_sched_result schedule_dm(struct threads_sched_args args)
{
    struct threads_sched_result r;
    // TODO: implement the deadline-monotonic scheduling algorithm
    struct thread *th = NULL;
    struct thread *dm = NULL, *ms = NULL;
    int miss = 0;
    list_for_each_entry(th, args.run_queue, thread_list) {
        if (th->current_deadline <= args.current_time){
            miss = 1;
            if (ms == NULL || th->ID < ms->ID)
                ms = th;
        }
        if (!miss){
            if (dm == NULL || th->deadline < dm->deadline || (th->deadline == dm->deadline && th->ID < dm->ID))
                dm = th;
        }
    }
    if (miss){
        r.scheduled_thread_list_member = &ms->thread_list;
        r.allocated_time = 0;
    }
    else if (dm == NULL){
        r.scheduled_thread_list_member = args.run_queue;
        struct release_queue_entry* rqe = NULL;
        r.allocated_time = 1000000;
        list_for_each_entry(rqe, args.release_queue, thread_list){
            if (rqe->release_time - args.current_time < r.allocated_time)
                r.allocated_time = rqe->release_time - args.current_time;
        }
    }
    else{
        r.scheduled_thread_list_member = &dm->thread_list;
        struct release_queue_entry* rqe = NULL; 
        int mn = 1000000;
        list_for_each_entry(rqe, args.release_queue, thread_list){
            th = rqe->thrd;
            if ((th->deadline < dm->deadline || (th->deadline == dm->deadline && th->ID < dm->ID)) && rqe->release_time < mn)
                mn = rqe->release_time;
        }
        int x = (dm->current_deadline - dm->remaining_time - args.current_time >= 0 ? dm->remaining_time : dm->current_deadline - dm->remaining_time);
        if (x < mn - args.current_time)
            r.allocated_time = x;
        else
            r.allocated_time = mn - args.current_time;
    
    }
    return r;
}