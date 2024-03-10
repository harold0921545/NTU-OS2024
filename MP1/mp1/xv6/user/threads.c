#include "kernel/types.h"
#include "user/setjmp.h"
#include "user/threads.h"
#include "user/user.h"
#define NULL 0

static struct thread* current_thread = NULL;
static int id = 1;
static jmp_buf env_st;
// static jmp_buf env_tmp;

struct thread *thread_create(void (*f)(void *), void *arg){
    fprintf(2, "thread_create\n");
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
    id++;
    return t;
}
void thread_add_runqueue(struct thread *t){
    fprintf(2, "thread_add_runqueue\n");
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
    fprintf(2, "thread_yield\n");
    //fprintf(2, "current id: %d\n", current_thread->ID);
    if (setjmp(current_thread->env) == 0){
        //fprintf(2, "yield, setjmp==0");
        current_thread->buf_set = 1;
        schedule();
        dispatch();
    }
    //fprintf(2, "yield, setjmp==1");
}
void dispatch(void){
    // TODO
    fprintf(2, "dispatch\n");
    if (current_thread->buf_set == 0){
        current_thread->fp(current_thread->arg);
        thread_exit();
    }
    else
        longjmp(current_thread->env, 1);
}
void schedule(void){
    fprintf(2, "schedule\n");
    fprintf(2, "current id: %d\n", current_thread->ID);
    current_thread = current_thread->next;
    fprintf(2, "current id: %d\n", current_thread->ID);
}
void thread_exit(void){
    fprintf(2, "thread_exit\n");
    if(current_thread->next != current_thread){
        // TODO
        (current_thread->previous)->next = current_thread->next;
        (current_thread->next)->previous = current_thread->previous;
        struct thread *tmp = current_thread;
        schedule();
        free(tmp->stack);
        free(tmp);
        dispatch();
    }
    else{
        // TODO
        // Hint: No more thread to execute
        free(current_thread->stack);
        free(current_thread);
        current_thread = NULL;
        longjmp(env_st, 1);
    }
}
void thread_start_threading(void){
    // TODO
    fprintf(2, "thread_start_threading\n");
    if (setjmp(env_st) == 0)
        dispatch();
    return;
}

// part 2
void thread_assign_task(struct thread *t, void (*f)(void *), void *arg){
    // TODO
}
