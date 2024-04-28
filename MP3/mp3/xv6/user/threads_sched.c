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
    struct thread *th = list_entry((args.run_queue)->next, struct thread, thread_list);
    // printf("th: id: %d, ptime: %d, weight: %d\n", th->ID, th->processing_time, th->weight);

    if (th != NULL){
        r.scheduled_thread_list_member = &th->thread_list;
        if (args.time_quantum * th->weight > th->remaining_time)
            r.allocated_time = th->remaining_time;
        else
            r.allocated_time = args.time_quantum * th->weight;
    }
    else{
        r.scheduled_thread_list_member = args.run_queue;
        r.allocated_time = 1;
    }
    return r;
}

/* Shortest-Job-First Scheduling */

    /*
struct threads_sched_result schedule_sjf(struct threads_sched_args args)
{
    struct threads_sched_result r;
    // TODO: implement the shortest-job-first scheduling algorithm
    struct thread *thread_with_shortest_job = NULL;
    struct thread *th = NULL;
    list_for_each_entry(th, args.run_queue, thread_list) {
        if (thread_with_shortest_job == NULL || th->processing_time < thread_with_shortest_job->processing_time)
            thread_with_shortest_job = th;
    }

    return r;
}
    */

/* MP3 Part 2 - Real-Time Scheduling*/
/* Least-Slack-Time Scheduling */
    /*
struct threads_sched_result schedule_lst(struct threads_sched_args args)
{
    struct threads_sched_result r;
    // TODO: implement the least-slack-time scheduling algorithm

    return r;
}
    */

/* Deadline-Monotonic Scheduling */
    /*
struct threads_sched_result schedule_dm(struct threads_sched_args args)
{
    struct threads_sched_result r;
    // TODO: implement the deadline-monotonic scheduling algorithm

    return r;
}

    */