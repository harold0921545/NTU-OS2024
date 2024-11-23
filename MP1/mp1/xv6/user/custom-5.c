#include "kernel/types.h"
#include "user/threads.h"
#include "user/user.h"

#define NULL 0

static struct thread *t;
static int cnt = 0;

void fib(void *arg) {
    cnt++;
    int k = (unsigned long)arg; 
    printf("fib %d %d\n", cnt, k);

    if(k == 0 || k == 1){
        printf("owo\n");
        return;
    }else{
        void* k1 = (void*)(unsigned long)(k - 1);
        void* k2 = (void*)(unsigned long)(k - 2);
        fib(k1);
        fib(k2);
    }
}

int main(int argc, char **argv) {
    printf("custom-5\n");
    for (int i = 0; i < 13; i++) {
        printf("calc %d\n", i);
        t = thread_create(fib, (void *)(unsigned long)i);
        thread_add_runqueue(t);
        thread_start_threading();
    }
    printf("\nexited\n");
    exit(0);
}
