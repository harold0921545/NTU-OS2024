#include "lru.h"

#include "param.h"
#include "types.h"
#include "memlayout.h"
#include "riscv.h"
#include "spinlock.h"
#include "defs.h"
#include "proc.h"

void lru_init(lru_t *lru){
	// do nothing
}
int lru_push(lru_t *lru, uint64 e){
	int f;
	if ((f = lru_find(lru, e)) != -1){
		for (int i = f; i + 1 < lru->size; ++i)
			lru->bucket[i] = lru->bucket[i + 1];
		lru->bucket[lru->size - 1] = e;
		return 1;
	}
	if (lru_full(lru)){
		int ok = 0;
		for (int i = 0; i < lru->size; ++i){
			pte_t *pte = lru->bucket[i];
			if ((*pte & PTE_P) == 0){
				lru_pop(lru, i);
				ok = 1;
				break;
			}
		}
		if (!ok)
			return 0;
	}
	lru->bucket[lru->size++] = e;
	return 1;
}

uint64 lru_pop(lru_t *lru, int idx){
	uint64 res = lru->bucket[idx];
	for (int i = idx; i + 1 < lru->size; ++i)
		lru->bucket[i] = lru->bucket[i + 1];
	lru->size--;
	return res;
}

int lru_empty(lru_t *lru){
	return (lru->size == 0);
}

int lru_full(lru_t *lru){
	return (lru->size == PG_BUF_SIZE);
}

int lru_clear(lru_t *lru){
	while (lru->size)
		lru->bucket[lru->size--] = 0;
	return 0;
}

int lru_find(lru_t *lru, uint64 e){
	for (int i = 0; i < lru->size; ++i){
		// printf("find i: %d\n", i);
		if (lru->bucket[i] == e)
			return i;
	}
	return -1;
}
