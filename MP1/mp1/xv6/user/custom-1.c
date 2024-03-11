#include "kernel/types.h"
#include "user/threads.h"
#include "user/user.h"

#define NULL 0

static struct thread *t;
static int thread_cnt = 0;
static int cnt = 0;


void f1(void *arg) {
    while (cnt < 1000000) {
        struct thread* t2 = thread_create(f1, (void*)(unsigned long)(cnt));
        thread_cnt++;
        cnt++;
        if(cnt % 10000 == 0){
            printf("f1: %d, %d\n", cnt, thread_cnt);
        }
        thread_add_runqueue(t2);
        thread_yield();
        if(thread_cnt >= 100){
            thread_cnt--;
            return;
        }
    }
    thread_cnt--;
}

int main(int argc, char **argv) {
    printf("custom-1\n");
    t = thread_create(f1, NULL);
    thread_cnt++;
    thread_add_runqueue(t);
    thread_start_threading();
    printf("\nexited\n");
    exit(0);
}
