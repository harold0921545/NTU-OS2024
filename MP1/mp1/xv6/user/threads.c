#include "kernel/types.h"
#include "user/setjmp.h"
#include "user/threads.h"
#include "user/user.h"
#define NULL 0

static struct thread* current_thread = NULL;
static struct task* current_task = NULL;
static int id = 1;
static jmp_buf env_st;
// static jmp_buf env_tmp;

struct thread *thread_create(void (*f)(void *), void *arg){
    //fprintf(2, "thread_create\n");
    struct thread *t = (struct thread*) malloc(sizeof(struct thread));
    unsigned long new_stack_p;
    unsigned long new_stack;
    new_stack = (unsigned long) malloc(sizeof(unsigned long)*0x100);
    new_stack_p = new_stack +0x100*8-0x2*8;
    t->fp = f;
    t->arg = arg;
    t->ID  = id;
    t->buf_set = 0;
    t->stack = (void*) new_stack;
    t->stack_p = (void*) new_stack_p;
    t->top = NULL;
    id++;
    return t;
}
void thread_add_runqueue(struct thread *t){
    //fprintf(2, "thread_add_runqueue\n");
    if(current_thread == NULL){
        current_thread = t;
        current_thread->previous = current_thread->next = current_thread;
    }
    else{
        t->previous = current_thread->previous;
        (current_thread->previous)->next = t;
        t->next = current_thread;
        current_thread->previous = t;
    }
}
void thread_yield(void){
    //fprintf(2, "thread_yield\n");
    if (current_task == NULL){
        if (setjmp(current_thread->env) == 0){
            schedule();
            dispatch();
        }
    }
    else{
        if (setjmp(current_task->env) == 0){
            schedule();
            dispatch();
        }
    }
}
void task_exit(){
    //fprintf(2, "task_exit\n");
    if (current_task->prev != NULL)
        current_task->prev->nxt = current_task->nxt;
    if (current_task->nxt != NULL)
        current_task->nxt->prev = current_task->prev;
    if (current_thread->top == current_task)
        current_thread->top = current_task->prev;
    free(current_task->stack);
    free(current_task);
    current_task = NULL;
}
void dispatch(void){
    // TODO
    //fprintf(2, "dispatch\n");
    while (current_thread->top != NULL){
        current_task = current_thread->top;
        if (current_task->buf_set == 0){
            current_task->buf_set = 1;
            if (setjmp(current_task->env) == 0){
                current_task->env->sp = (unsigned long)current_task->stack_p;
                longjmp(current_task->env, 1);
            }
            current_task->fp(current_task->arg);
            task_exit();
        }
        else
            longjmp(current_task->env, 1);
    }
    // thread doesn't have task
    if (current_thread->buf_set == 0){
        current_thread->buf_set = 1;
        if (setjmp(current_thread->env) == 0){
            current_thread->env->sp = (unsigned long)current_thread->stack_p;
            longjmp(current_thread->env, 1);
        }
        current_thread->fp(current_thread->arg);
        thread_exit();
    }
    else
        longjmp(current_thread->env, 1);
}
void schedule(void){
    //fprintf(2, "schedule\n");
    current_thread = current_thread->next;
    current_task = NULL;
}
void thread_exit(void){
    //fprintf(2, "thread_exit\n");
    if(current_thread->next != current_thread){
        // TODO
        current_thread->previous->next = current_thread->next;
        current_thread->next->previous = current_thread->previous;
        struct thread *tmp = current_thread;
        schedule();
        struct task *tsk = tmp->top;
        while (tsk != NULL){
            struct task *tp = tsk->prev;
            free(tsk->stack);
            free(tsk);
            tsk = tp;
        }
        free(tmp->stack);
        free(tmp);
        dispatch();
    }
    else{
        // TODO
        // Hint: No more thread to execute
        struct task *tsk = current_thread->top;
        while (tsk != NULL){
            struct task *tp = tsk->prev;
            free(tsk->stack);
            free(tsk);
            tsk = tp;
        }
        free(current_thread->stack);
        free(current_thread);
        current_thread = NULL;
        longjmp(env_st, 1);
    }
}
void thread_start_threading(void){
    // TODO
    //fprintf(2, "thread_start_threading\n");
    if (current_thread == NULL)
        return;
    if (setjmp(env_st) == 0)
        dispatch();
}

// part 2
void thread_assign_task(struct thread *t, void (*f)(void *), void *arg){
    // TODO
    // fprintf(2, "assign_task\n");
    struct task *tsk = (struct task *)malloc(sizeof(struct task));
    unsigned long new_stack_p;
    unsigned long new_stack;
    new_stack = (unsigned long) malloc(sizeof(unsigned long)*0x100);
    new_stack_p = new_stack +0x100*8-0x2*8;
    tsk->fp = f;
    tsk->arg = arg;
    tsk->buf_set = 0;
    tsk->stack = (void*) new_stack;
    tsk->stack_p = (void*) new_stack_p;
    tsk->prev = t->top;
    if (t->top != NULL) t->top->nxt = tsk;
    t->top = tsk;
}