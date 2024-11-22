#include "fifo.h"

#include "param.h"
#include "types.h"
#include "memlayout.h"
#include "riscv.h"
#include "spinlock.h"
#include "defs.h"
#include "proc.h"

void q_init(queue_t *q){
	// do nothing
}

int q_push(queue_t *q, uint64 e){
	// printf("push: %p\n", e);
	if (q_find(q, e) != -1)
		return 1;
	//printf("q_push\n");
	if (q_full(q)){
		// printf("q_full\n");
		int ok = 0;
		for (int i = 0; i < q->size; ++i){
			pte_t *pte = q->bucket[i];
			if ((*pte & PTE_P) == 0){
				q_pop_idx(q, i);
				ok = 1;
				break;
			}
		}
		if (!ok)
			return 0;
	}
	q->bucket[q->size++] = e;
	return 1;
}

uint64 q_pop_idx(queue_t *q, int idx){
	uint64 res = q->bucket[idx];
	for (int i = idx; i + 1 < q->size; ++i)
		q->bucket[i] = q->bucket[i + 1];
	q->size--;
	return res;
}

int q_empty(queue_t *q){
	return (q->size == 0);
}

int q_full(queue_t *q){
	return (q->size == PG_BUF_SIZE);
}

int q_clear(queue_t *q){
	while (q->size)
		q->bucket[q->size--] = 0;
	return 0;
}

int q_find(queue_t *q, uint64 e){
	for (int i = 0; i < q->size; ++i){
		// printf("find i: %d\n", i);
		if (q->bucket[i] == e)
			return i;
	}
	return -1;
}
