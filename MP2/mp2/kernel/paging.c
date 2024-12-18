#include "param.h"
#include "types.h"
#include "memlayout.h"
#include "riscv.h"
#include "spinlock.h"
#include "defs.h"
#include "proc.h"

/* NTU OS 2024 */
/* Allocate eight consecutive disk blocks. */
/* Save the content of the physical page in the pte */
/* to the disk blocks and save the block-id into the */
/* pte. */
char *swap_page_from_pte(pte_t *pte) {
  char *pa = (char*) PTE2PA(*pte);
  uint dp = balloc_page(ROOTDEV);

  write_page_to_disk(ROOTDEV, pa, dp); // write this page to disk
  *pte = (BLOCKNO2PTE(dp) | PTE_FLAGS(*pte) | PTE_S) & ~PTE_V;

  return pa;
}

/* NTU OS 2024 */
/* Page fault handler */
int handle_pgfault() {
  /* Find the address that caused the fault */
  uint64 va = r_stval();
  struct proc *p = myproc();
  pagetable_t pagetable = p->pagetable;
  pte_t *pte = walk(pagetable, va, 0);
  uint64 flags = PTE_FLAGS(*pte) & ~PTE_S;

  char *pa = kalloc();
  memset(pa, 0, PGSIZE);
  if(mappages(pagetable, PGROUNDDOWN(va), PGSIZE, (uint64)pa, flags | PTE_U | PTE_R | PTE_W | PTE_X) != 0)
    kfree(pa);
  return 0;
}