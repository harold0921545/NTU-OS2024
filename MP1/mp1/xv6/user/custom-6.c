#include "kernel/types.h"
#include "user/threads.h"
#include "user/user.h"

#define NULL 0

static struct thread *t;
static int cnt = 0;

void fib(void *arg) {
    cnt++;
    int k2 = (unsigned long)arg;
    int l = k2/1000;
    int k = k2%1000;
    printf("fib %d %d %d\n", l, cnt, k);

    if (k == 0 || k == 1) {
        printf("owo\n");
        return;
    } else {
        register void *k1 = (void *)(unsigned long)(k - 1 + 1000 * l);
        register void *k2 = (void *)(unsigned long)(k - 2 + 1000 * l);
        thread_yield();
        fib(k1);
        thread_yield();
        fib(k2);
        thread_yield();
    }
}

int main(int argc, char **argv) {
    printf("custom-6\n");
    for (int i = 0; i < 13; i++) {
        printf("calc %d\n", i);
        t = thread_create(fib, (void *)(unsigned long)(i + 1000 * i));
        thread_add_runqueue(t);
    }
    thread_start_threading();
    printf("\nexited\n");
    exit(0);
}
