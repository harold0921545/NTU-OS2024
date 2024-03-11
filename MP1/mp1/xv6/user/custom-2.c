#include "kernel/types.h"
#include "user/threads.h"
#include "user/user.h"

#define NULL 0

static struct thread *t;
static int cnt = 0;

void f2(void *arg) {
    int k = (unsigned long)arg;
    printf("task %d\n", k);

    if (k % 3 == 0) {
        return;
    } else if (k % 3 == 1) {
        thread_exit();
    } else {
        thread_yield();
    }
}

void f1(void *arg) {
    while (cnt < 30) {
        printf("thread 1: %d\n", cnt);
        struct thread *t2 = thread_create(f2, (void *)(unsigned long)(cnt));
        thread_add_runqueue(t2);
        cnt++;
        thread_yield();
    }
}

int main(int argc, char **argv) {
    printf("custom-2\n");
    t = thread_create(f1, NULL);
    thread_add_runqueue(t);
    thread_start_threading();
    printf("\nexited\n");
    exit(0);
}
