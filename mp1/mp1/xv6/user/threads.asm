
user/_threads:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <thread_create>:
static struct task* current_task = NULL;
static int id = 1;
static jmp_buf env_st;
// static jmp_buf env_tmp;

struct thread *thread_create(void (*f)(void *), void *arg){
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
   e:	89aa                	mv	s3,a0
  10:	892e                	mv	s2,a1
    //fprintf(2, "thread_create\n");
    struct thread *t = (struct thread*) malloc(sizeof(struct thread));
  12:	0b000513          	li	a0,176
  16:	00001097          	auipc	ra,0x1
  1a:	a7a080e7          	jalr	-1414(ra) # a90 <malloc>
  1e:	84aa                	mv	s1,a0
    unsigned long new_stack_p;
    unsigned long new_stack;
    new_stack = (unsigned long) malloc(sizeof(unsigned long)*0x100);
  20:	6505                	lui	a0,0x1
  22:	80050513          	addi	a0,a0,-2048 # 800 <vprintf+0x3a>
  26:	00001097          	auipc	ra,0x1
  2a:	a6a080e7          	jalr	-1430(ra) # a90 <malloc>
    new_stack_p = new_stack +0x100*8-0x2*8;
    t->fp = f;
  2e:	0134b023          	sd	s3,0(s1)
    t->arg = arg;
  32:	0124b423          	sd	s2,8(s1)
    t->ID  = id;
  36:	00001717          	auipc	a4,0x1
  3a:	bd670713          	addi	a4,a4,-1066 # c0c <id>
  3e:	431c                	lw	a5,0(a4)
  40:	08f4aa23          	sw	a5,148(s1)
    t->buf_set = 0;
  44:	0804a823          	sw	zero,144(s1)
    t->stack = (void*) new_stack;
  48:	e888                	sd	a0,16(s1)
    new_stack_p = new_stack +0x100*8-0x2*8;
  4a:	7f050513          	addi	a0,a0,2032
    t->stack_p = (void*) new_stack_p;
  4e:	ec88                	sd	a0,24(s1)
    t->top = NULL;
  50:	0a04b423          	sd	zero,168(s1)
    id++;
  54:	2785                	addiw	a5,a5,1
  56:	c31c                	sw	a5,0(a4)
    return t;
}
  58:	8526                	mv	a0,s1
  5a:	70a2                	ld	ra,40(sp)
  5c:	7402                	ld	s0,32(sp)
  5e:	64e2                	ld	s1,24(sp)
  60:	6942                	ld	s2,16(sp)
  62:	69a2                	ld	s3,8(sp)
  64:	6145                	addi	sp,sp,48
  66:	8082                	ret

0000000000000068 <thread_add_runqueue>:
void thread_add_runqueue(struct thread *t){
  68:	1141                	addi	sp,sp,-16
  6a:	e422                	sd	s0,8(sp)
  6c:	0800                	addi	s0,sp,16
    //fprintf(2, "thread_add_runqueue\n");
    if(current_thread == NULL){
  6e:	00001797          	auipc	a5,0x1
  72:	baa7b783          	ld	a5,-1110(a5) # c18 <current_thread>
  76:	cb89                	beqz	a5,88 <thread_add_runqueue+0x20>
        current_thread = t;
        current_thread->previous = current_thread->next = current_thread;
    }
    else{
        t->previous = current_thread->previous;
  78:	6fd8                	ld	a4,152(a5)
  7a:	ed58                	sd	a4,152(a0)
        current_thread->previous->next = t;
  7c:	f348                	sd	a0,160(a4)
        t->next = current_thread;
  7e:	f15c                	sd	a5,160(a0)
        current_thread->previous = t;
  80:	efc8                	sd	a0,152(a5)
    }
}
  82:	6422                	ld	s0,8(sp)
  84:	0141                	addi	sp,sp,16
  86:	8082                	ret
        current_thread = t;
  88:	00001797          	auipc	a5,0x1
  8c:	b8a7b823          	sd	a0,-1136(a5) # c18 <current_thread>
        current_thread->previous = current_thread->next = current_thread;
  90:	f148                	sd	a0,160(a0)
  92:	ed48                	sd	a0,152(a0)
  94:	b7fd                	j	82 <thread_add_runqueue+0x1a>

0000000000000096 <task_exit>:
            schedule();
            dispatch();
        }
    }
}
void task_exit(){
  96:	1101                	addi	sp,sp,-32
  98:	ec06                	sd	ra,24(sp)
  9a:	e822                	sd	s0,16(sp)
  9c:	e426                	sd	s1,8(sp)
  9e:	1000                	addi	s0,sp,32
    //fprintf(2, "task_exit\n");
    if (current_task->prev != NULL)
  a0:	00001797          	auipc	a5,0x1
  a4:	b707b783          	ld	a5,-1168(a5) # c10 <current_task>
  a8:	6fd8                	ld	a4,152(a5)
  aa:	c319                	beqz	a4,b0 <task_exit+0x1a>
        current_task->prev->nxt = current_task->nxt;
  ac:	73d4                	ld	a3,160(a5)
  ae:	f354                	sd	a3,160(a4)
    if (current_task->nxt != NULL)
  b0:	73d8                	ld	a4,160(a5)
  b2:	c319                	beqz	a4,b8 <task_exit+0x22>
        current_task->nxt->prev = current_task->prev;
  b4:	6fd4                	ld	a3,152(a5)
  b6:	ef54                	sd	a3,152(a4)
    if (current_thread->top == current_task)
  b8:	00001717          	auipc	a4,0x1
  bc:	b6073703          	ld	a4,-1184(a4) # c18 <current_thread>
  c0:	7754                	ld	a3,168(a4)
  c2:	02d78763          	beq	a5,a3,f0 <task_exit+0x5a>
        current_thread->top = current_task->prev;
    free(current_task->stack);
  c6:	6b88                	ld	a0,16(a5)
  c8:	00001097          	auipc	ra,0x1
  cc:	940080e7          	jalr	-1728(ra) # a08 <free>
    free(current_task);
  d0:	00001497          	auipc	s1,0x1
  d4:	b4048493          	addi	s1,s1,-1216 # c10 <current_task>
  d8:	6088                	ld	a0,0(s1)
  da:	00001097          	auipc	ra,0x1
  de:	92e080e7          	jalr	-1746(ra) # a08 <free>
    current_task = NULL;
  e2:	0004b023          	sd	zero,0(s1)
}
  e6:	60e2                	ld	ra,24(sp)
  e8:	6442                	ld	s0,16(sp)
  ea:	64a2                	ld	s1,8(sp)
  ec:	6105                	addi	sp,sp,32
  ee:	8082                	ret
        current_thread->top = current_task->prev;
  f0:	6fd4                	ld	a3,152(a5)
  f2:	f754                	sd	a3,168(a4)
  f4:	bfc9                	j	c6 <task_exit+0x30>

00000000000000f6 <schedule>:
        thread_exit();
    }
    else
        longjmp(current_thread->env, 1);
}
void schedule(void){
  f6:	1141                	addi	sp,sp,-16
  f8:	e422                	sd	s0,8(sp)
  fa:	0800                	addi	s0,sp,16
    //fprintf(2, "schedule\n");
    current_thread = current_thread->next;
  fc:	00001797          	auipc	a5,0x1
 100:	b1c78793          	addi	a5,a5,-1252 # c18 <current_thread>
 104:	6398                	ld	a4,0(a5)
 106:	7358                	ld	a4,160(a4)
 108:	e398                	sd	a4,0(a5)
    current_task = NULL;
 10a:	00001797          	auipc	a5,0x1
 10e:	b007b323          	sd	zero,-1274(a5) # c10 <current_task>
}
 112:	6422                	ld	s0,8(sp)
 114:	0141                	addi	sp,sp,16
 116:	8082                	ret

0000000000000118 <thread_exit>:
void thread_exit(void){
 118:	7179                	addi	sp,sp,-48
 11a:	f406                	sd	ra,40(sp)
 11c:	f022                	sd	s0,32(sp)
 11e:	ec26                	sd	s1,24(sp)
 120:	e84a                	sd	s2,16(sp)
 122:	e44e                	sd	s3,8(sp)
 124:	1800                	addi	s0,sp,48
    //fprintf(2, "thread_exit\n");
    if(current_thread->next != current_thread){
 126:	00001997          	auipc	s3,0x1
 12a:	af29b983          	ld	s3,-1294(s3) # c18 <current_thread>
 12e:	0a09b783          	ld	a5,160(s3)
 132:	06f98363          	beq	s3,a5,198 <thread_exit+0x80>
        // TODO
        current_thread->previous->next = current_thread->next;
 136:	0989b703          	ld	a4,152(s3)
 13a:	f35c                	sd	a5,160(a4)
        current_thread->next->previous = current_thread->previous;
 13c:	0989b703          	ld	a4,152(s3)
 140:	efd8                	sd	a4,152(a5)
        struct thread *tmp = current_thread;
        schedule();
 142:	00000097          	auipc	ra,0x0
 146:	fb4080e7          	jalr	-76(ra) # f6 <schedule>
        struct task *tsk = tmp->top;
 14a:	0a89b483          	ld	s1,168(s3)
        while (tsk != NULL){
 14e:	cc99                	beqz	s1,16c <thread_exit+0x54>
            struct task *tp = tsk->prev;
 150:	8926                	mv	s2,s1
 152:	6cc4                	ld	s1,152(s1)
            free(tsk->stack);
 154:	01093503          	ld	a0,16(s2)
 158:	00001097          	auipc	ra,0x1
 15c:	8b0080e7          	jalr	-1872(ra) # a08 <free>
            free(tsk);
 160:	854a                	mv	a0,s2
 162:	00001097          	auipc	ra,0x1
 166:	8a6080e7          	jalr	-1882(ra) # a08 <free>
        while (tsk != NULL){
 16a:	f0fd                	bnez	s1,150 <thread_exit+0x38>
            tsk = tp;
        }
        free(tmp->stack);
 16c:	0109b503          	ld	a0,16(s3)
 170:	00001097          	auipc	ra,0x1
 174:	898080e7          	jalr	-1896(ra) # a08 <free>
        free(tmp);
 178:	854e                	mv	a0,s3
 17a:	00001097          	auipc	ra,0x1
 17e:	88e080e7          	jalr	-1906(ra) # a08 <free>
        dispatch();
 182:	00000097          	auipc	ra,0x0
 186:	06e080e7          	jalr	110(ra) # 1f0 <dispatch>
        free(current_thread->stack);
        free(current_thread);
        current_thread = NULL;
        longjmp(env_st, 1);
    }
}
 18a:	70a2                	ld	ra,40(sp)
 18c:	7402                	ld	s0,32(sp)
 18e:	64e2                	ld	s1,24(sp)
 190:	6942                	ld	s2,16(sp)
 192:	69a2                	ld	s3,8(sp)
 194:	6145                	addi	sp,sp,48
 196:	8082                	ret
        struct task *tsk = current_thread->top;
 198:	0a89b483          	ld	s1,168(s3)
        while (tsk != NULL){
 19c:	cc99                	beqz	s1,1ba <thread_exit+0xa2>
            struct task *tp = tsk->prev;
 19e:	8926                	mv	s2,s1
 1a0:	6cc4                	ld	s1,152(s1)
            free(tsk->stack);
 1a2:	01093503          	ld	a0,16(s2)
 1a6:	00001097          	auipc	ra,0x1
 1aa:	862080e7          	jalr	-1950(ra) # a08 <free>
            free(tsk);
 1ae:	854a                	mv	a0,s2
 1b0:	00001097          	auipc	ra,0x1
 1b4:	858080e7          	jalr	-1960(ra) # a08 <free>
        while (tsk != NULL){
 1b8:	f0fd                	bnez	s1,19e <thread_exit+0x86>
        free(current_thread->stack);
 1ba:	00001497          	auipc	s1,0x1
 1be:	a5e48493          	addi	s1,s1,-1442 # c18 <current_thread>
 1c2:	609c                	ld	a5,0(s1)
 1c4:	6b88                	ld	a0,16(a5)
 1c6:	00001097          	auipc	ra,0x1
 1ca:	842080e7          	jalr	-1982(ra) # a08 <free>
        free(current_thread);
 1ce:	6088                	ld	a0,0(s1)
 1d0:	00001097          	auipc	ra,0x1
 1d4:	838080e7          	jalr	-1992(ra) # a08 <free>
        current_thread = NULL;
 1d8:	0004b023          	sd	zero,0(s1)
        longjmp(env_st, 1);
 1dc:	4585                	li	a1,1
 1de:	00001517          	auipc	a0,0x1
 1e2:	a4a50513          	addi	a0,a0,-1462 # c28 <env_st>
 1e6:	00001097          	auipc	ra,0x1
 1ea:	9c6080e7          	jalr	-1594(ra) # bac <longjmp>
}
 1ee:	bf71                	j	18a <thread_exit+0x72>

00000000000001f0 <dispatch>:
void dispatch(void){
 1f0:	1141                	addi	sp,sp,-16
 1f2:	e406                	sd	ra,8(sp)
 1f4:	e022                	sd	s0,0(sp)
 1f6:	0800                	addi	s0,sp,16
    while (current_thread->top != NULL){
 1f8:	a829                	j	212 <dispatch+0x22>
            current_task->fp(current_task->arg);
 1fa:	00001797          	auipc	a5,0x1
 1fe:	a1678793          	addi	a5,a5,-1514 # c10 <current_task>
 202:	639c                	ld	a5,0(a5)
 204:	6398                	ld	a4,0(a5)
 206:	6788                	ld	a0,8(a5)
 208:	9702                	jalr	a4
            task_exit();
 20a:	00000097          	auipc	ra,0x0
 20e:	e8c080e7          	jalr	-372(ra) # 96 <task_exit>
    while (current_thread->top != NULL){
 212:	00001797          	auipc	a5,0x1
 216:	a0678793          	addi	a5,a5,-1530 # c18 <current_thread>
 21a:	639c                	ld	a5,0(a5)
 21c:	77c8                	ld	a0,168(a5)
 21e:	c931                	beqz	a0,272 <dispatch+0x82>
        current_task = current_thread->top;
 220:	00001797          	auipc	a5,0x1
 224:	9f078793          	addi	a5,a5,-1552 # c10 <current_task>
 228:	e388                	sd	a0,0(a5)
        if (current_task->buf_set == 0){
 22a:	09052783          	lw	a5,144(a0)
 22e:	eb95                	bnez	a5,262 <dispatch+0x72>
            current_task->buf_set = 1;
 230:	4785                	li	a5,1
 232:	08f52823          	sw	a5,144(a0)
            if (setjmp(current_task->env) == 0){
 236:	02050513          	addi	a0,a0,32
 23a:	00001097          	auipc	ra,0x1
 23e:	93a080e7          	jalr	-1734(ra) # b74 <setjmp>
 242:	fd45                	bnez	a0,1fa <dispatch+0xa>
                current_task->env->sp = (unsigned long)current_task->stack_p;
 244:	00001797          	auipc	a5,0x1
 248:	9cc78793          	addi	a5,a5,-1588 # c10 <current_task>
 24c:	6388                	ld	a0,0(a5)
 24e:	6d1c                	ld	a5,24(a0)
 250:	e55c                	sd	a5,136(a0)
                longjmp(current_task->env, 1);
 252:	4585                	li	a1,1
 254:	02050513          	addi	a0,a0,32
 258:	00001097          	auipc	ra,0x1
 25c:	954080e7          	jalr	-1708(ra) # bac <longjmp>
 260:	bf69                	j	1fa <dispatch+0xa>
            longjmp(current_task->env, 1);
 262:	4585                	li	a1,1
 264:	02050513          	addi	a0,a0,32
 268:	00001097          	auipc	ra,0x1
 26c:	944080e7          	jalr	-1724(ra) # bac <longjmp>
 270:	b74d                	j	212 <dispatch+0x22>
    current_task = NULL;
 272:	00001717          	auipc	a4,0x1
 276:	98073f23          	sd	zero,-1634(a4) # c10 <current_task>
    if (current_thread->buf_set == 0){
 27a:	0907a703          	lw	a4,144(a5)
 27e:	eb21                	bnez	a4,2ce <dispatch+0xde>
        current_thread->buf_set = 1;
 280:	4705                	li	a4,1
 282:	08e7a823          	sw	a4,144(a5)
        if (setjmp(current_thread->env) == 0){
 286:	02078513          	addi	a0,a5,32
 28a:	00001097          	auipc	ra,0x1
 28e:	8ea080e7          	jalr	-1814(ra) # b74 <setjmp>
 292:	c105                	beqz	a0,2b2 <dispatch+0xc2>
        current_thread->fp(current_thread->arg);
 294:	00001797          	auipc	a5,0x1
 298:	9847b783          	ld	a5,-1660(a5) # c18 <current_thread>
 29c:	6398                	ld	a4,0(a5)
 29e:	6788                	ld	a0,8(a5)
 2a0:	9702                	jalr	a4
        thread_exit();
 2a2:	00000097          	auipc	ra,0x0
 2a6:	e76080e7          	jalr	-394(ra) # 118 <thread_exit>
}
 2aa:	60a2                	ld	ra,8(sp)
 2ac:	6402                	ld	s0,0(sp)
 2ae:	0141                	addi	sp,sp,16
 2b0:	8082                	ret
            current_thread->env->sp = (unsigned long)current_thread->stack_p;
 2b2:	00001517          	auipc	a0,0x1
 2b6:	96653503          	ld	a0,-1690(a0) # c18 <current_thread>
 2ba:	6d1c                	ld	a5,24(a0)
 2bc:	e55c                	sd	a5,136(a0)
            longjmp(current_thread->env, 1);
 2be:	4585                	li	a1,1
 2c0:	02050513          	addi	a0,a0,32
 2c4:	00001097          	auipc	ra,0x1
 2c8:	8e8080e7          	jalr	-1816(ra) # bac <longjmp>
 2cc:	b7e1                	j	294 <dispatch+0xa4>
        longjmp(current_thread->env, 1);
 2ce:	4585                	li	a1,1
 2d0:	02078513          	addi	a0,a5,32
 2d4:	00001097          	auipc	ra,0x1
 2d8:	8d8080e7          	jalr	-1832(ra) # bac <longjmp>
}
 2dc:	b7f9                	j	2aa <dispatch+0xba>

00000000000002de <thread_yield>:
void thread_yield(void){
 2de:	1141                	addi	sp,sp,-16
 2e0:	e406                	sd	ra,8(sp)
 2e2:	e022                	sd	s0,0(sp)
 2e4:	0800                	addi	s0,sp,16
    if (current_task == NULL){
 2e6:	00001517          	auipc	a0,0x1
 2ea:	92a53503          	ld	a0,-1750(a0) # c10 <current_task>
 2ee:	cd01                	beqz	a0,306 <thread_yield+0x28>
        if (setjmp(current_task->env) == 0){
 2f0:	02050513          	addi	a0,a0,32
 2f4:	00001097          	auipc	ra,0x1
 2f8:	880080e7          	jalr	-1920(ra) # b74 <setjmp>
 2fc:	c90d                	beqz	a0,32e <thread_yield+0x50>
}
 2fe:	60a2                	ld	ra,8(sp)
 300:	6402                	ld	s0,0(sp)
 302:	0141                	addi	sp,sp,16
 304:	8082                	ret
        if (setjmp(current_thread->env) == 0){
 306:	00001517          	auipc	a0,0x1
 30a:	91253503          	ld	a0,-1774(a0) # c18 <current_thread>
 30e:	02050513          	addi	a0,a0,32
 312:	00001097          	auipc	ra,0x1
 316:	862080e7          	jalr	-1950(ra) # b74 <setjmp>
 31a:	f175                	bnez	a0,2fe <thread_yield+0x20>
            schedule();
 31c:	00000097          	auipc	ra,0x0
 320:	dda080e7          	jalr	-550(ra) # f6 <schedule>
            dispatch();
 324:	00000097          	auipc	ra,0x0
 328:	ecc080e7          	jalr	-308(ra) # 1f0 <dispatch>
 32c:	bfc9                	j	2fe <thread_yield+0x20>
            schedule();
 32e:	00000097          	auipc	ra,0x0
 332:	dc8080e7          	jalr	-568(ra) # f6 <schedule>
            dispatch();
 336:	00000097          	auipc	ra,0x0
 33a:	eba080e7          	jalr	-326(ra) # 1f0 <dispatch>
}
 33e:	b7c1                	j	2fe <thread_yield+0x20>

0000000000000340 <thread_start_threading>:
void thread_start_threading(void){
    // TODO
    //fprintf(2, "thread_start_threading\n");
    if (current_thread == NULL) return;
 340:	00001797          	auipc	a5,0x1
 344:	8d87b783          	ld	a5,-1832(a5) # c18 <current_thread>
 348:	c79d                	beqz	a5,376 <thread_start_threading+0x36>
void thread_start_threading(void){
 34a:	1141                	addi	sp,sp,-16
 34c:	e406                	sd	ra,8(sp)
 34e:	e022                	sd	s0,0(sp)
 350:	0800                	addi	s0,sp,16
    if (setjmp(env_st) == 0)
 352:	00001517          	auipc	a0,0x1
 356:	8d650513          	addi	a0,a0,-1834 # c28 <env_st>
 35a:	00001097          	auipc	ra,0x1
 35e:	81a080e7          	jalr	-2022(ra) # b74 <setjmp>
 362:	c509                	beqz	a0,36c <thread_start_threading+0x2c>
        dispatch();
}
 364:	60a2                	ld	ra,8(sp)
 366:	6402                	ld	s0,0(sp)
 368:	0141                	addi	sp,sp,16
 36a:	8082                	ret
        dispatch();
 36c:	00000097          	auipc	ra,0x0
 370:	e84080e7          	jalr	-380(ra) # 1f0 <dispatch>
 374:	bfc5                	j	364 <thread_start_threading+0x24>
 376:	8082                	ret

0000000000000378 <thread_assign_task>:

// part 2
void thread_assign_task(struct thread *t, void (*f)(void *), void *arg){
 378:	7179                	addi	sp,sp,-48
 37a:	f406                	sd	ra,40(sp)
 37c:	f022                	sd	s0,32(sp)
 37e:	ec26                	sd	s1,24(sp)
 380:	e84a                	sd	s2,16(sp)
 382:	e44e                	sd	s3,8(sp)
 384:	e052                	sd	s4,0(sp)
 386:	1800                	addi	s0,sp,48
 388:	892a                	mv	s2,a0
 38a:	8a2e                	mv	s4,a1
 38c:	89b2                	mv	s3,a2
    // TODO
    // fprintf(2, "assign_task\n");
    struct task *tsk = (struct task *)malloc(sizeof(struct task));
 38e:	0a800513          	li	a0,168
 392:	00000097          	auipc	ra,0x0
 396:	6fe080e7          	jalr	1790(ra) # a90 <malloc>
 39a:	84aa                	mv	s1,a0
    unsigned long new_stack_p;
    unsigned long new_stack;
    new_stack = (unsigned long) malloc(sizeof(unsigned long)*0x100);
 39c:	6505                	lui	a0,0x1
 39e:	80050513          	addi	a0,a0,-2048 # 800 <vprintf+0x3a>
 3a2:	00000097          	auipc	ra,0x0
 3a6:	6ee080e7          	jalr	1774(ra) # a90 <malloc>
    new_stack_p = new_stack +0x100*8-0x2*8;
    tsk->fp = f;
 3aa:	0144b023          	sd	s4,0(s1)
    tsk->arg = arg;
 3ae:	0134b423          	sd	s3,8(s1)
    tsk->buf_set = 0;
 3b2:	0804a823          	sw	zero,144(s1)
    tsk->stack = (void*) new_stack;
 3b6:	e888                	sd	a0,16(s1)
    new_stack_p = new_stack +0x100*8-0x2*8;
 3b8:	7f050793          	addi	a5,a0,2032
    tsk->stack_p = (void*) new_stack_p;
 3bc:	ec9c                	sd	a5,24(s1)
    tsk->prev = t->top;
 3be:	0a893783          	ld	a5,168(s2)
 3c2:	ecdc                	sd	a5,152(s1)
    tsk->nxt = NULL;
 3c4:	0a04b023          	sd	zero,160(s1)
    if (t->top != NULL) t->top->nxt = tsk;
 3c8:	0a893783          	ld	a5,168(s2)
 3cc:	c391                	beqz	a5,3d0 <thread_assign_task+0x58>
 3ce:	f3c4                	sd	s1,160(a5)
    t->top = tsk;
 3d0:	0a993423          	sd	s1,168(s2)
 3d4:	70a2                	ld	ra,40(sp)
 3d6:	7402                	ld	s0,32(sp)
 3d8:	64e2                	ld	s1,24(sp)
 3da:	6942                	ld	s2,16(sp)
 3dc:	69a2                	ld	s3,8(sp)
 3de:	6a02                	ld	s4,0(sp)
 3e0:	6145                	addi	sp,sp,48
 3e2:	8082                	ret

00000000000003e4 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 3e4:	1141                	addi	sp,sp,-16
 3e6:	e422                	sd	s0,8(sp)
 3e8:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 3ea:	87aa                	mv	a5,a0
 3ec:	0585                	addi	a1,a1,1
 3ee:	0785                	addi	a5,a5,1
 3f0:	fff5c703          	lbu	a4,-1(a1)
 3f4:	fee78fa3          	sb	a4,-1(a5)
 3f8:	fb75                	bnez	a4,3ec <strcpy+0x8>
    ;
  return os;
}
 3fa:	6422                	ld	s0,8(sp)
 3fc:	0141                	addi	sp,sp,16
 3fe:	8082                	ret

0000000000000400 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 400:	1141                	addi	sp,sp,-16
 402:	e422                	sd	s0,8(sp)
 404:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 406:	00054783          	lbu	a5,0(a0)
 40a:	cb91                	beqz	a5,41e <strcmp+0x1e>
 40c:	0005c703          	lbu	a4,0(a1)
 410:	00f71763          	bne	a4,a5,41e <strcmp+0x1e>
    p++, q++;
 414:	0505                	addi	a0,a0,1
 416:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 418:	00054783          	lbu	a5,0(a0)
 41c:	fbe5                	bnez	a5,40c <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 41e:	0005c503          	lbu	a0,0(a1)
}
 422:	40a7853b          	subw	a0,a5,a0
 426:	6422                	ld	s0,8(sp)
 428:	0141                	addi	sp,sp,16
 42a:	8082                	ret

000000000000042c <strlen>:

uint
strlen(const char *s)
{
 42c:	1141                	addi	sp,sp,-16
 42e:	e422                	sd	s0,8(sp)
 430:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 432:	00054783          	lbu	a5,0(a0)
 436:	cf91                	beqz	a5,452 <strlen+0x26>
 438:	0505                	addi	a0,a0,1
 43a:	87aa                	mv	a5,a0
 43c:	4685                	li	a3,1
 43e:	9e89                	subw	a3,a3,a0
 440:	00f6853b          	addw	a0,a3,a5
 444:	0785                	addi	a5,a5,1
 446:	fff7c703          	lbu	a4,-1(a5)
 44a:	fb7d                	bnez	a4,440 <strlen+0x14>
    ;
  return n;
}
 44c:	6422                	ld	s0,8(sp)
 44e:	0141                	addi	sp,sp,16
 450:	8082                	ret
  for(n = 0; s[n]; n++)
 452:	4501                	li	a0,0
 454:	bfe5                	j	44c <strlen+0x20>

0000000000000456 <memset>:

void*
memset(void *dst, int c, uint n)
{
 456:	1141                	addi	sp,sp,-16
 458:	e422                	sd	s0,8(sp)
 45a:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 45c:	ce09                	beqz	a2,476 <memset+0x20>
 45e:	87aa                	mv	a5,a0
 460:	fff6071b          	addiw	a4,a2,-1
 464:	1702                	slli	a4,a4,0x20
 466:	9301                	srli	a4,a4,0x20
 468:	0705                	addi	a4,a4,1
 46a:	972a                	add	a4,a4,a0
    cdst[i] = c;
 46c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 470:	0785                	addi	a5,a5,1
 472:	fee79de3          	bne	a5,a4,46c <memset+0x16>
  }
  return dst;
}
 476:	6422                	ld	s0,8(sp)
 478:	0141                	addi	sp,sp,16
 47a:	8082                	ret

000000000000047c <strchr>:

char*
strchr(const char *s, char c)
{
 47c:	1141                	addi	sp,sp,-16
 47e:	e422                	sd	s0,8(sp)
 480:	0800                	addi	s0,sp,16
  for(; *s; s++)
 482:	00054783          	lbu	a5,0(a0)
 486:	cb99                	beqz	a5,49c <strchr+0x20>
    if(*s == c)
 488:	00f58763          	beq	a1,a5,496 <strchr+0x1a>
  for(; *s; s++)
 48c:	0505                	addi	a0,a0,1
 48e:	00054783          	lbu	a5,0(a0)
 492:	fbfd                	bnez	a5,488 <strchr+0xc>
      return (char*)s;
  return 0;
 494:	4501                	li	a0,0
}
 496:	6422                	ld	s0,8(sp)
 498:	0141                	addi	sp,sp,16
 49a:	8082                	ret
  return 0;
 49c:	4501                	li	a0,0
 49e:	bfe5                	j	496 <strchr+0x1a>

00000000000004a0 <gets>:

char*
gets(char *buf, int max)
{
 4a0:	711d                	addi	sp,sp,-96
 4a2:	ec86                	sd	ra,88(sp)
 4a4:	e8a2                	sd	s0,80(sp)
 4a6:	e4a6                	sd	s1,72(sp)
 4a8:	e0ca                	sd	s2,64(sp)
 4aa:	fc4e                	sd	s3,56(sp)
 4ac:	f852                	sd	s4,48(sp)
 4ae:	f456                	sd	s5,40(sp)
 4b0:	f05a                	sd	s6,32(sp)
 4b2:	ec5e                	sd	s7,24(sp)
 4b4:	1080                	addi	s0,sp,96
 4b6:	8baa                	mv	s7,a0
 4b8:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 4ba:	892a                	mv	s2,a0
 4bc:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 4be:	4aa9                	li	s5,10
 4c0:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 4c2:	89a6                	mv	s3,s1
 4c4:	2485                	addiw	s1,s1,1
 4c6:	0344d863          	bge	s1,s4,4f6 <gets+0x56>
    cc = read(0, &c, 1);
 4ca:	4605                	li	a2,1
 4cc:	faf40593          	addi	a1,s0,-81
 4d0:	4501                	li	a0,0
 4d2:	00000097          	auipc	ra,0x0
 4d6:	1a0080e7          	jalr	416(ra) # 672 <read>
    if(cc < 1)
 4da:	00a05e63          	blez	a0,4f6 <gets+0x56>
    buf[i++] = c;
 4de:	faf44783          	lbu	a5,-81(s0)
 4e2:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 4e6:	01578763          	beq	a5,s5,4f4 <gets+0x54>
 4ea:	0905                	addi	s2,s2,1
 4ec:	fd679be3          	bne	a5,s6,4c2 <gets+0x22>
  for(i=0; i+1 < max; ){
 4f0:	89a6                	mv	s3,s1
 4f2:	a011                	j	4f6 <gets+0x56>
 4f4:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 4f6:	99de                	add	s3,s3,s7
 4f8:	00098023          	sb	zero,0(s3)
  return buf;
}
 4fc:	855e                	mv	a0,s7
 4fe:	60e6                	ld	ra,88(sp)
 500:	6446                	ld	s0,80(sp)
 502:	64a6                	ld	s1,72(sp)
 504:	6906                	ld	s2,64(sp)
 506:	79e2                	ld	s3,56(sp)
 508:	7a42                	ld	s4,48(sp)
 50a:	7aa2                	ld	s5,40(sp)
 50c:	7b02                	ld	s6,32(sp)
 50e:	6be2                	ld	s7,24(sp)
 510:	6125                	addi	sp,sp,96
 512:	8082                	ret

0000000000000514 <stat>:

int
stat(const char *n, struct stat *st)
{
 514:	1101                	addi	sp,sp,-32
 516:	ec06                	sd	ra,24(sp)
 518:	e822                	sd	s0,16(sp)
 51a:	e426                	sd	s1,8(sp)
 51c:	e04a                	sd	s2,0(sp)
 51e:	1000                	addi	s0,sp,32
 520:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 522:	4581                	li	a1,0
 524:	00000097          	auipc	ra,0x0
 528:	176080e7          	jalr	374(ra) # 69a <open>
  if(fd < 0)
 52c:	02054563          	bltz	a0,556 <stat+0x42>
 530:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 532:	85ca                	mv	a1,s2
 534:	00000097          	auipc	ra,0x0
 538:	17e080e7          	jalr	382(ra) # 6b2 <fstat>
 53c:	892a                	mv	s2,a0
  close(fd);
 53e:	8526                	mv	a0,s1
 540:	00000097          	auipc	ra,0x0
 544:	142080e7          	jalr	322(ra) # 682 <close>
  return r;
}
 548:	854a                	mv	a0,s2
 54a:	60e2                	ld	ra,24(sp)
 54c:	6442                	ld	s0,16(sp)
 54e:	64a2                	ld	s1,8(sp)
 550:	6902                	ld	s2,0(sp)
 552:	6105                	addi	sp,sp,32
 554:	8082                	ret
    return -1;
 556:	597d                	li	s2,-1
 558:	bfc5                	j	548 <stat+0x34>

000000000000055a <atoi>:

int
atoi(const char *s)
{
 55a:	1141                	addi	sp,sp,-16
 55c:	e422                	sd	s0,8(sp)
 55e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 560:	00054603          	lbu	a2,0(a0)
 564:	fd06079b          	addiw	a5,a2,-48
 568:	0ff7f793          	andi	a5,a5,255
 56c:	4725                	li	a4,9
 56e:	02f76963          	bltu	a4,a5,5a0 <atoi+0x46>
 572:	86aa                	mv	a3,a0
  n = 0;
 574:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 576:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 578:	0685                	addi	a3,a3,1
 57a:	0025179b          	slliw	a5,a0,0x2
 57e:	9fa9                	addw	a5,a5,a0
 580:	0017979b          	slliw	a5,a5,0x1
 584:	9fb1                	addw	a5,a5,a2
 586:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 58a:	0006c603          	lbu	a2,0(a3)
 58e:	fd06071b          	addiw	a4,a2,-48
 592:	0ff77713          	andi	a4,a4,255
 596:	fee5f1e3          	bgeu	a1,a4,578 <atoi+0x1e>
  return n;
}
 59a:	6422                	ld	s0,8(sp)
 59c:	0141                	addi	sp,sp,16
 59e:	8082                	ret
  n = 0;
 5a0:	4501                	li	a0,0
 5a2:	bfe5                	j	59a <atoi+0x40>

00000000000005a4 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 5a4:	1141                	addi	sp,sp,-16
 5a6:	e422                	sd	s0,8(sp)
 5a8:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 5aa:	02b57663          	bgeu	a0,a1,5d6 <memmove+0x32>
    while(n-- > 0)
 5ae:	02c05163          	blez	a2,5d0 <memmove+0x2c>
 5b2:	fff6079b          	addiw	a5,a2,-1
 5b6:	1782                	slli	a5,a5,0x20
 5b8:	9381                	srli	a5,a5,0x20
 5ba:	0785                	addi	a5,a5,1
 5bc:	97aa                	add	a5,a5,a0
  dst = vdst;
 5be:	872a                	mv	a4,a0
      *dst++ = *src++;
 5c0:	0585                	addi	a1,a1,1
 5c2:	0705                	addi	a4,a4,1
 5c4:	fff5c683          	lbu	a3,-1(a1)
 5c8:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 5cc:	fee79ae3          	bne	a5,a4,5c0 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 5d0:	6422                	ld	s0,8(sp)
 5d2:	0141                	addi	sp,sp,16
 5d4:	8082                	ret
    dst += n;
 5d6:	00c50733          	add	a4,a0,a2
    src += n;
 5da:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 5dc:	fec05ae3          	blez	a2,5d0 <memmove+0x2c>
 5e0:	fff6079b          	addiw	a5,a2,-1
 5e4:	1782                	slli	a5,a5,0x20
 5e6:	9381                	srli	a5,a5,0x20
 5e8:	fff7c793          	not	a5,a5
 5ec:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 5ee:	15fd                	addi	a1,a1,-1
 5f0:	177d                	addi	a4,a4,-1
 5f2:	0005c683          	lbu	a3,0(a1)
 5f6:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 5fa:	fee79ae3          	bne	a5,a4,5ee <memmove+0x4a>
 5fe:	bfc9                	j	5d0 <memmove+0x2c>

0000000000000600 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 600:	1141                	addi	sp,sp,-16
 602:	e422                	sd	s0,8(sp)
 604:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 606:	ca05                	beqz	a2,636 <memcmp+0x36>
 608:	fff6069b          	addiw	a3,a2,-1
 60c:	1682                	slli	a3,a3,0x20
 60e:	9281                	srli	a3,a3,0x20
 610:	0685                	addi	a3,a3,1
 612:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 614:	00054783          	lbu	a5,0(a0)
 618:	0005c703          	lbu	a4,0(a1)
 61c:	00e79863          	bne	a5,a4,62c <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 620:	0505                	addi	a0,a0,1
    p2++;
 622:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 624:	fed518e3          	bne	a0,a3,614 <memcmp+0x14>
  }
  return 0;
 628:	4501                	li	a0,0
 62a:	a019                	j	630 <memcmp+0x30>
      return *p1 - *p2;
 62c:	40e7853b          	subw	a0,a5,a4
}
 630:	6422                	ld	s0,8(sp)
 632:	0141                	addi	sp,sp,16
 634:	8082                	ret
  return 0;
 636:	4501                	li	a0,0
 638:	bfe5                	j	630 <memcmp+0x30>

000000000000063a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 63a:	1141                	addi	sp,sp,-16
 63c:	e406                	sd	ra,8(sp)
 63e:	e022                	sd	s0,0(sp)
 640:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 642:	00000097          	auipc	ra,0x0
 646:	f62080e7          	jalr	-158(ra) # 5a4 <memmove>
}
 64a:	60a2                	ld	ra,8(sp)
 64c:	6402                	ld	s0,0(sp)
 64e:	0141                	addi	sp,sp,16
 650:	8082                	ret

0000000000000652 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 652:	4885                	li	a7,1
 ecall
 654:	00000073          	ecall
 ret
 658:	8082                	ret

000000000000065a <exit>:
.global exit
exit:
 li a7, SYS_exit
 65a:	4889                	li	a7,2
 ecall
 65c:	00000073          	ecall
 ret
 660:	8082                	ret

0000000000000662 <wait>:
.global wait
wait:
 li a7, SYS_wait
 662:	488d                	li	a7,3
 ecall
 664:	00000073          	ecall
 ret
 668:	8082                	ret

000000000000066a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 66a:	4891                	li	a7,4
 ecall
 66c:	00000073          	ecall
 ret
 670:	8082                	ret

0000000000000672 <read>:
.global read
read:
 li a7, SYS_read
 672:	4895                	li	a7,5
 ecall
 674:	00000073          	ecall
 ret
 678:	8082                	ret

000000000000067a <write>:
.global write
write:
 li a7, SYS_write
 67a:	48c1                	li	a7,16
 ecall
 67c:	00000073          	ecall
 ret
 680:	8082                	ret

0000000000000682 <close>:
.global close
close:
 li a7, SYS_close
 682:	48d5                	li	a7,21
 ecall
 684:	00000073          	ecall
 ret
 688:	8082                	ret

000000000000068a <kill>:
.global kill
kill:
 li a7, SYS_kill
 68a:	4899                	li	a7,6
 ecall
 68c:	00000073          	ecall
 ret
 690:	8082                	ret

0000000000000692 <exec>:
.global exec
exec:
 li a7, SYS_exec
 692:	489d                	li	a7,7
 ecall
 694:	00000073          	ecall
 ret
 698:	8082                	ret

000000000000069a <open>:
.global open
open:
 li a7, SYS_open
 69a:	48bd                	li	a7,15
 ecall
 69c:	00000073          	ecall
 ret
 6a0:	8082                	ret

00000000000006a2 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 6a2:	48c5                	li	a7,17
 ecall
 6a4:	00000073          	ecall
 ret
 6a8:	8082                	ret

00000000000006aa <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 6aa:	48c9                	li	a7,18
 ecall
 6ac:	00000073          	ecall
 ret
 6b0:	8082                	ret

00000000000006b2 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 6b2:	48a1                	li	a7,8
 ecall
 6b4:	00000073          	ecall
 ret
 6b8:	8082                	ret

00000000000006ba <link>:
.global link
link:
 li a7, SYS_link
 6ba:	48cd                	li	a7,19
 ecall
 6bc:	00000073          	ecall
 ret
 6c0:	8082                	ret

00000000000006c2 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 6c2:	48d1                	li	a7,20
 ecall
 6c4:	00000073          	ecall
 ret
 6c8:	8082                	ret

00000000000006ca <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 6ca:	48a5                	li	a7,9
 ecall
 6cc:	00000073          	ecall
 ret
 6d0:	8082                	ret

00000000000006d2 <dup>:
.global dup
dup:
 li a7, SYS_dup
 6d2:	48a9                	li	a7,10
 ecall
 6d4:	00000073          	ecall
 ret
 6d8:	8082                	ret

00000000000006da <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 6da:	48ad                	li	a7,11
 ecall
 6dc:	00000073          	ecall
 ret
 6e0:	8082                	ret

00000000000006e2 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 6e2:	48b1                	li	a7,12
 ecall
 6e4:	00000073          	ecall
 ret
 6e8:	8082                	ret

00000000000006ea <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 6ea:	48b5                	li	a7,13
 ecall
 6ec:	00000073          	ecall
 ret
 6f0:	8082                	ret

00000000000006f2 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 6f2:	48b9                	li	a7,14
 ecall
 6f4:	00000073          	ecall
 ret
 6f8:	8082                	ret

00000000000006fa <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 6fa:	1101                	addi	sp,sp,-32
 6fc:	ec06                	sd	ra,24(sp)
 6fe:	e822                	sd	s0,16(sp)
 700:	1000                	addi	s0,sp,32
 702:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 706:	4605                	li	a2,1
 708:	fef40593          	addi	a1,s0,-17
 70c:	00000097          	auipc	ra,0x0
 710:	f6e080e7          	jalr	-146(ra) # 67a <write>
}
 714:	60e2                	ld	ra,24(sp)
 716:	6442                	ld	s0,16(sp)
 718:	6105                	addi	sp,sp,32
 71a:	8082                	ret

000000000000071c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 71c:	7139                	addi	sp,sp,-64
 71e:	fc06                	sd	ra,56(sp)
 720:	f822                	sd	s0,48(sp)
 722:	f426                	sd	s1,40(sp)
 724:	f04a                	sd	s2,32(sp)
 726:	ec4e                	sd	s3,24(sp)
 728:	0080                	addi	s0,sp,64
 72a:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 72c:	c299                	beqz	a3,732 <printint+0x16>
 72e:	0805c863          	bltz	a1,7be <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 732:	2581                	sext.w	a1,a1
  neg = 0;
 734:	4881                	li	a7,0
 736:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 73a:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 73c:	2601                	sext.w	a2,a2
 73e:	00000517          	auipc	a0,0x0
 742:	4ba50513          	addi	a0,a0,1210 # bf8 <digits>
 746:	883a                	mv	a6,a4
 748:	2705                	addiw	a4,a4,1
 74a:	02c5f7bb          	remuw	a5,a1,a2
 74e:	1782                	slli	a5,a5,0x20
 750:	9381                	srli	a5,a5,0x20
 752:	97aa                	add	a5,a5,a0
 754:	0007c783          	lbu	a5,0(a5)
 758:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 75c:	0005879b          	sext.w	a5,a1
 760:	02c5d5bb          	divuw	a1,a1,a2
 764:	0685                	addi	a3,a3,1
 766:	fec7f0e3          	bgeu	a5,a2,746 <printint+0x2a>
  if(neg)
 76a:	00088b63          	beqz	a7,780 <printint+0x64>
    buf[i++] = '-';
 76e:	fd040793          	addi	a5,s0,-48
 772:	973e                	add	a4,a4,a5
 774:	02d00793          	li	a5,45
 778:	fef70823          	sb	a5,-16(a4)
 77c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 780:	02e05863          	blez	a4,7b0 <printint+0x94>
 784:	fc040793          	addi	a5,s0,-64
 788:	00e78933          	add	s2,a5,a4
 78c:	fff78993          	addi	s3,a5,-1
 790:	99ba                	add	s3,s3,a4
 792:	377d                	addiw	a4,a4,-1
 794:	1702                	slli	a4,a4,0x20
 796:	9301                	srli	a4,a4,0x20
 798:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 79c:	fff94583          	lbu	a1,-1(s2)
 7a0:	8526                	mv	a0,s1
 7a2:	00000097          	auipc	ra,0x0
 7a6:	f58080e7          	jalr	-168(ra) # 6fa <putc>
  while(--i >= 0)
 7aa:	197d                	addi	s2,s2,-1
 7ac:	ff3918e3          	bne	s2,s3,79c <printint+0x80>
}
 7b0:	70e2                	ld	ra,56(sp)
 7b2:	7442                	ld	s0,48(sp)
 7b4:	74a2                	ld	s1,40(sp)
 7b6:	7902                	ld	s2,32(sp)
 7b8:	69e2                	ld	s3,24(sp)
 7ba:	6121                	addi	sp,sp,64
 7bc:	8082                	ret
    x = -xx;
 7be:	40b005bb          	negw	a1,a1
    neg = 1;
 7c2:	4885                	li	a7,1
    x = -xx;
 7c4:	bf8d                	j	736 <printint+0x1a>

00000000000007c6 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 7c6:	7119                	addi	sp,sp,-128
 7c8:	fc86                	sd	ra,120(sp)
 7ca:	f8a2                	sd	s0,112(sp)
 7cc:	f4a6                	sd	s1,104(sp)
 7ce:	f0ca                	sd	s2,96(sp)
 7d0:	ecce                	sd	s3,88(sp)
 7d2:	e8d2                	sd	s4,80(sp)
 7d4:	e4d6                	sd	s5,72(sp)
 7d6:	e0da                	sd	s6,64(sp)
 7d8:	fc5e                	sd	s7,56(sp)
 7da:	f862                	sd	s8,48(sp)
 7dc:	f466                	sd	s9,40(sp)
 7de:	f06a                	sd	s10,32(sp)
 7e0:	ec6e                	sd	s11,24(sp)
 7e2:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 7e4:	0005c903          	lbu	s2,0(a1)
 7e8:	18090f63          	beqz	s2,986 <vprintf+0x1c0>
 7ec:	8aaa                	mv	s5,a0
 7ee:	8b32                	mv	s6,a2
 7f0:	00158493          	addi	s1,a1,1
  state = 0;
 7f4:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 7f6:	02500a13          	li	s4,37
      if(c == 'd'){
 7fa:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 7fe:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 802:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 806:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 80a:	00000b97          	auipc	s7,0x0
 80e:	3eeb8b93          	addi	s7,s7,1006 # bf8 <digits>
 812:	a839                	j	830 <vprintf+0x6a>
        putc(fd, c);
 814:	85ca                	mv	a1,s2
 816:	8556                	mv	a0,s5
 818:	00000097          	auipc	ra,0x0
 81c:	ee2080e7          	jalr	-286(ra) # 6fa <putc>
 820:	a019                	j	826 <vprintf+0x60>
    } else if(state == '%'){
 822:	01498f63          	beq	s3,s4,840 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 826:	0485                	addi	s1,s1,1
 828:	fff4c903          	lbu	s2,-1(s1)
 82c:	14090d63          	beqz	s2,986 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 830:	0009079b          	sext.w	a5,s2
    if(state == 0){
 834:	fe0997e3          	bnez	s3,822 <vprintf+0x5c>
      if(c == '%'){
 838:	fd479ee3          	bne	a5,s4,814 <vprintf+0x4e>
        state = '%';
 83c:	89be                	mv	s3,a5
 83e:	b7e5                	j	826 <vprintf+0x60>
      if(c == 'd'){
 840:	05878063          	beq	a5,s8,880 <vprintf+0xba>
      } else if(c == 'l') {
 844:	05978c63          	beq	a5,s9,89c <vprintf+0xd6>
      } else if(c == 'x') {
 848:	07a78863          	beq	a5,s10,8b8 <vprintf+0xf2>
      } else if(c == 'p') {
 84c:	09b78463          	beq	a5,s11,8d4 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 850:	07300713          	li	a4,115
 854:	0ce78663          	beq	a5,a4,920 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 858:	06300713          	li	a4,99
 85c:	0ee78e63          	beq	a5,a4,958 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 860:	11478863          	beq	a5,s4,970 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 864:	85d2                	mv	a1,s4
 866:	8556                	mv	a0,s5
 868:	00000097          	auipc	ra,0x0
 86c:	e92080e7          	jalr	-366(ra) # 6fa <putc>
        putc(fd, c);
 870:	85ca                	mv	a1,s2
 872:	8556                	mv	a0,s5
 874:	00000097          	auipc	ra,0x0
 878:	e86080e7          	jalr	-378(ra) # 6fa <putc>
      }
      state = 0;
 87c:	4981                	li	s3,0
 87e:	b765                	j	826 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 880:	008b0913          	addi	s2,s6,8
 884:	4685                	li	a3,1
 886:	4629                	li	a2,10
 888:	000b2583          	lw	a1,0(s6)
 88c:	8556                	mv	a0,s5
 88e:	00000097          	auipc	ra,0x0
 892:	e8e080e7          	jalr	-370(ra) # 71c <printint>
 896:	8b4a                	mv	s6,s2
      state = 0;
 898:	4981                	li	s3,0
 89a:	b771                	j	826 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 89c:	008b0913          	addi	s2,s6,8
 8a0:	4681                	li	a3,0
 8a2:	4629                	li	a2,10
 8a4:	000b2583          	lw	a1,0(s6)
 8a8:	8556                	mv	a0,s5
 8aa:	00000097          	auipc	ra,0x0
 8ae:	e72080e7          	jalr	-398(ra) # 71c <printint>
 8b2:	8b4a                	mv	s6,s2
      state = 0;
 8b4:	4981                	li	s3,0
 8b6:	bf85                	j	826 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 8b8:	008b0913          	addi	s2,s6,8
 8bc:	4681                	li	a3,0
 8be:	4641                	li	a2,16
 8c0:	000b2583          	lw	a1,0(s6)
 8c4:	8556                	mv	a0,s5
 8c6:	00000097          	auipc	ra,0x0
 8ca:	e56080e7          	jalr	-426(ra) # 71c <printint>
 8ce:	8b4a                	mv	s6,s2
      state = 0;
 8d0:	4981                	li	s3,0
 8d2:	bf91                	j	826 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 8d4:	008b0793          	addi	a5,s6,8
 8d8:	f8f43423          	sd	a5,-120(s0)
 8dc:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 8e0:	03000593          	li	a1,48
 8e4:	8556                	mv	a0,s5
 8e6:	00000097          	auipc	ra,0x0
 8ea:	e14080e7          	jalr	-492(ra) # 6fa <putc>
  putc(fd, 'x');
 8ee:	85ea                	mv	a1,s10
 8f0:	8556                	mv	a0,s5
 8f2:	00000097          	auipc	ra,0x0
 8f6:	e08080e7          	jalr	-504(ra) # 6fa <putc>
 8fa:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 8fc:	03c9d793          	srli	a5,s3,0x3c
 900:	97de                	add	a5,a5,s7
 902:	0007c583          	lbu	a1,0(a5)
 906:	8556                	mv	a0,s5
 908:	00000097          	auipc	ra,0x0
 90c:	df2080e7          	jalr	-526(ra) # 6fa <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 910:	0992                	slli	s3,s3,0x4
 912:	397d                	addiw	s2,s2,-1
 914:	fe0914e3          	bnez	s2,8fc <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 918:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 91c:	4981                	li	s3,0
 91e:	b721                	j	826 <vprintf+0x60>
        s = va_arg(ap, char*);
 920:	008b0993          	addi	s3,s6,8
 924:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 928:	02090163          	beqz	s2,94a <vprintf+0x184>
        while(*s != 0){
 92c:	00094583          	lbu	a1,0(s2)
 930:	c9a1                	beqz	a1,980 <vprintf+0x1ba>
          putc(fd, *s);
 932:	8556                	mv	a0,s5
 934:	00000097          	auipc	ra,0x0
 938:	dc6080e7          	jalr	-570(ra) # 6fa <putc>
          s++;
 93c:	0905                	addi	s2,s2,1
        while(*s != 0){
 93e:	00094583          	lbu	a1,0(s2)
 942:	f9e5                	bnez	a1,932 <vprintf+0x16c>
        s = va_arg(ap, char*);
 944:	8b4e                	mv	s6,s3
      state = 0;
 946:	4981                	li	s3,0
 948:	bdf9                	j	826 <vprintf+0x60>
          s = "(null)";
 94a:	00000917          	auipc	s2,0x0
 94e:	2a690913          	addi	s2,s2,678 # bf0 <longjmp_1+0xa>
        while(*s != 0){
 952:	02800593          	li	a1,40
 956:	bff1                	j	932 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 958:	008b0913          	addi	s2,s6,8
 95c:	000b4583          	lbu	a1,0(s6)
 960:	8556                	mv	a0,s5
 962:	00000097          	auipc	ra,0x0
 966:	d98080e7          	jalr	-616(ra) # 6fa <putc>
 96a:	8b4a                	mv	s6,s2
      state = 0;
 96c:	4981                	li	s3,0
 96e:	bd65                	j	826 <vprintf+0x60>
        putc(fd, c);
 970:	85d2                	mv	a1,s4
 972:	8556                	mv	a0,s5
 974:	00000097          	auipc	ra,0x0
 978:	d86080e7          	jalr	-634(ra) # 6fa <putc>
      state = 0;
 97c:	4981                	li	s3,0
 97e:	b565                	j	826 <vprintf+0x60>
        s = va_arg(ap, char*);
 980:	8b4e                	mv	s6,s3
      state = 0;
 982:	4981                	li	s3,0
 984:	b54d                	j	826 <vprintf+0x60>
    }
  }
}
 986:	70e6                	ld	ra,120(sp)
 988:	7446                	ld	s0,112(sp)
 98a:	74a6                	ld	s1,104(sp)
 98c:	7906                	ld	s2,96(sp)
 98e:	69e6                	ld	s3,88(sp)
 990:	6a46                	ld	s4,80(sp)
 992:	6aa6                	ld	s5,72(sp)
 994:	6b06                	ld	s6,64(sp)
 996:	7be2                	ld	s7,56(sp)
 998:	7c42                	ld	s8,48(sp)
 99a:	7ca2                	ld	s9,40(sp)
 99c:	7d02                	ld	s10,32(sp)
 99e:	6de2                	ld	s11,24(sp)
 9a0:	6109                	addi	sp,sp,128
 9a2:	8082                	ret

00000000000009a4 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 9a4:	715d                	addi	sp,sp,-80
 9a6:	ec06                	sd	ra,24(sp)
 9a8:	e822                	sd	s0,16(sp)
 9aa:	1000                	addi	s0,sp,32
 9ac:	e010                	sd	a2,0(s0)
 9ae:	e414                	sd	a3,8(s0)
 9b0:	e818                	sd	a4,16(s0)
 9b2:	ec1c                	sd	a5,24(s0)
 9b4:	03043023          	sd	a6,32(s0)
 9b8:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 9bc:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 9c0:	8622                	mv	a2,s0
 9c2:	00000097          	auipc	ra,0x0
 9c6:	e04080e7          	jalr	-508(ra) # 7c6 <vprintf>
}
 9ca:	60e2                	ld	ra,24(sp)
 9cc:	6442                	ld	s0,16(sp)
 9ce:	6161                	addi	sp,sp,80
 9d0:	8082                	ret

00000000000009d2 <printf>:

void
printf(const char *fmt, ...)
{
 9d2:	711d                	addi	sp,sp,-96
 9d4:	ec06                	sd	ra,24(sp)
 9d6:	e822                	sd	s0,16(sp)
 9d8:	1000                	addi	s0,sp,32
 9da:	e40c                	sd	a1,8(s0)
 9dc:	e810                	sd	a2,16(s0)
 9de:	ec14                	sd	a3,24(s0)
 9e0:	f018                	sd	a4,32(s0)
 9e2:	f41c                	sd	a5,40(s0)
 9e4:	03043823          	sd	a6,48(s0)
 9e8:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 9ec:	00840613          	addi	a2,s0,8
 9f0:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 9f4:	85aa                	mv	a1,a0
 9f6:	4505                	li	a0,1
 9f8:	00000097          	auipc	ra,0x0
 9fc:	dce080e7          	jalr	-562(ra) # 7c6 <vprintf>
}
 a00:	60e2                	ld	ra,24(sp)
 a02:	6442                	ld	s0,16(sp)
 a04:	6125                	addi	sp,sp,96
 a06:	8082                	ret

0000000000000a08 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a08:	1141                	addi	sp,sp,-16
 a0a:	e422                	sd	s0,8(sp)
 a0c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 a0e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a12:	00000797          	auipc	a5,0x0
 a16:	20e7b783          	ld	a5,526(a5) # c20 <freep>
 a1a:	a805                	j	a4a <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 a1c:	4618                	lw	a4,8(a2)
 a1e:	9db9                	addw	a1,a1,a4
 a20:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 a24:	6398                	ld	a4,0(a5)
 a26:	6318                	ld	a4,0(a4)
 a28:	fee53823          	sd	a4,-16(a0)
 a2c:	a091                	j	a70 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 a2e:	ff852703          	lw	a4,-8(a0)
 a32:	9e39                	addw	a2,a2,a4
 a34:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 a36:	ff053703          	ld	a4,-16(a0)
 a3a:	e398                	sd	a4,0(a5)
 a3c:	a099                	j	a82 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a3e:	6398                	ld	a4,0(a5)
 a40:	00e7e463          	bltu	a5,a4,a48 <free+0x40>
 a44:	00e6ea63          	bltu	a3,a4,a58 <free+0x50>
{
 a48:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a4a:	fed7fae3          	bgeu	a5,a3,a3e <free+0x36>
 a4e:	6398                	ld	a4,0(a5)
 a50:	00e6e463          	bltu	a3,a4,a58 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a54:	fee7eae3          	bltu	a5,a4,a48 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 a58:	ff852583          	lw	a1,-8(a0)
 a5c:	6390                	ld	a2,0(a5)
 a5e:	02059713          	slli	a4,a1,0x20
 a62:	9301                	srli	a4,a4,0x20
 a64:	0712                	slli	a4,a4,0x4
 a66:	9736                	add	a4,a4,a3
 a68:	fae60ae3          	beq	a2,a4,a1c <free+0x14>
    bp->s.ptr = p->s.ptr;
 a6c:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 a70:	4790                	lw	a2,8(a5)
 a72:	02061713          	slli	a4,a2,0x20
 a76:	9301                	srli	a4,a4,0x20
 a78:	0712                	slli	a4,a4,0x4
 a7a:	973e                	add	a4,a4,a5
 a7c:	fae689e3          	beq	a3,a4,a2e <free+0x26>
  } else
    p->s.ptr = bp;
 a80:	e394                	sd	a3,0(a5)
  freep = p;
 a82:	00000717          	auipc	a4,0x0
 a86:	18f73f23          	sd	a5,414(a4) # c20 <freep>
}
 a8a:	6422                	ld	s0,8(sp)
 a8c:	0141                	addi	sp,sp,16
 a8e:	8082                	ret

0000000000000a90 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 a90:	7139                	addi	sp,sp,-64
 a92:	fc06                	sd	ra,56(sp)
 a94:	f822                	sd	s0,48(sp)
 a96:	f426                	sd	s1,40(sp)
 a98:	f04a                	sd	s2,32(sp)
 a9a:	ec4e                	sd	s3,24(sp)
 a9c:	e852                	sd	s4,16(sp)
 a9e:	e456                	sd	s5,8(sp)
 aa0:	e05a                	sd	s6,0(sp)
 aa2:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 aa4:	02051493          	slli	s1,a0,0x20
 aa8:	9081                	srli	s1,s1,0x20
 aaa:	04bd                	addi	s1,s1,15
 aac:	8091                	srli	s1,s1,0x4
 aae:	0014899b          	addiw	s3,s1,1
 ab2:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 ab4:	00000517          	auipc	a0,0x0
 ab8:	16c53503          	ld	a0,364(a0) # c20 <freep>
 abc:	c515                	beqz	a0,ae8 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 abe:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 ac0:	4798                	lw	a4,8(a5)
 ac2:	02977f63          	bgeu	a4,s1,b00 <malloc+0x70>
 ac6:	8a4e                	mv	s4,s3
 ac8:	0009871b          	sext.w	a4,s3
 acc:	6685                	lui	a3,0x1
 ace:	00d77363          	bgeu	a4,a3,ad4 <malloc+0x44>
 ad2:	6a05                	lui	s4,0x1
 ad4:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 ad8:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 adc:	00000917          	auipc	s2,0x0
 ae0:	14490913          	addi	s2,s2,324 # c20 <freep>
  if(p == (char*)-1)
 ae4:	5afd                	li	s5,-1
 ae6:	a88d                	j	b58 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 ae8:	00000797          	auipc	a5,0x0
 aec:	1b078793          	addi	a5,a5,432 # c98 <base>
 af0:	00000717          	auipc	a4,0x0
 af4:	12f73823          	sd	a5,304(a4) # c20 <freep>
 af8:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 afa:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 afe:	b7e1                	j	ac6 <malloc+0x36>
      if(p->s.size == nunits)
 b00:	02e48b63          	beq	s1,a4,b36 <malloc+0xa6>
        p->s.size -= nunits;
 b04:	4137073b          	subw	a4,a4,s3
 b08:	c798                	sw	a4,8(a5)
        p += p->s.size;
 b0a:	1702                	slli	a4,a4,0x20
 b0c:	9301                	srli	a4,a4,0x20
 b0e:	0712                	slli	a4,a4,0x4
 b10:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 b12:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 b16:	00000717          	auipc	a4,0x0
 b1a:	10a73523          	sd	a0,266(a4) # c20 <freep>
      return (void*)(p + 1);
 b1e:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 b22:	70e2                	ld	ra,56(sp)
 b24:	7442                	ld	s0,48(sp)
 b26:	74a2                	ld	s1,40(sp)
 b28:	7902                	ld	s2,32(sp)
 b2a:	69e2                	ld	s3,24(sp)
 b2c:	6a42                	ld	s4,16(sp)
 b2e:	6aa2                	ld	s5,8(sp)
 b30:	6b02                	ld	s6,0(sp)
 b32:	6121                	addi	sp,sp,64
 b34:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 b36:	6398                	ld	a4,0(a5)
 b38:	e118                	sd	a4,0(a0)
 b3a:	bff1                	j	b16 <malloc+0x86>
  hp->s.size = nu;
 b3c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 b40:	0541                	addi	a0,a0,16
 b42:	00000097          	auipc	ra,0x0
 b46:	ec6080e7          	jalr	-314(ra) # a08 <free>
  return freep;
 b4a:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 b4e:	d971                	beqz	a0,b22 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b50:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b52:	4798                	lw	a4,8(a5)
 b54:	fa9776e3          	bgeu	a4,s1,b00 <malloc+0x70>
    if(p == freep)
 b58:	00093703          	ld	a4,0(s2)
 b5c:	853e                	mv	a0,a5
 b5e:	fef719e3          	bne	a4,a5,b50 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 b62:	8552                	mv	a0,s4
 b64:	00000097          	auipc	ra,0x0
 b68:	b7e080e7          	jalr	-1154(ra) # 6e2 <sbrk>
  if(p == (char*)-1)
 b6c:	fd5518e3          	bne	a0,s5,b3c <malloc+0xac>
        return 0;
 b70:	4501                	li	a0,0
 b72:	bf45                	j	b22 <malloc+0x92>

0000000000000b74 <setjmp>:
 b74:	e100                	sd	s0,0(a0)
 b76:	e504                	sd	s1,8(a0)
 b78:	01253823          	sd	s2,16(a0)
 b7c:	01353c23          	sd	s3,24(a0)
 b80:	03453023          	sd	s4,32(a0)
 b84:	03553423          	sd	s5,40(a0)
 b88:	03653823          	sd	s6,48(a0)
 b8c:	03753c23          	sd	s7,56(a0)
 b90:	05853023          	sd	s8,64(a0)
 b94:	05953423          	sd	s9,72(a0)
 b98:	05a53823          	sd	s10,80(a0)
 b9c:	05b53c23          	sd	s11,88(a0)
 ba0:	06153023          	sd	ra,96(a0)
 ba4:	06253423          	sd	sp,104(a0)
 ba8:	4501                	li	a0,0
 baa:	8082                	ret

0000000000000bac <longjmp>:
 bac:	6100                	ld	s0,0(a0)
 bae:	6504                	ld	s1,8(a0)
 bb0:	01053903          	ld	s2,16(a0)
 bb4:	01853983          	ld	s3,24(a0)
 bb8:	02053a03          	ld	s4,32(a0)
 bbc:	02853a83          	ld	s5,40(a0)
 bc0:	03053b03          	ld	s6,48(a0)
 bc4:	03853b83          	ld	s7,56(a0)
 bc8:	04053c03          	ld	s8,64(a0)
 bcc:	04853c83          	ld	s9,72(a0)
 bd0:	05053d03          	ld	s10,80(a0)
 bd4:	05853d83          	ld	s11,88(a0)
 bd8:	06053083          	ld	ra,96(a0)
 bdc:	06853103          	ld	sp,104(a0)
 be0:	c199                	beqz	a1,be6 <longjmp_1>
 be2:	852e                	mv	a0,a1
 be4:	8082                	ret

0000000000000be6 <longjmp_1>:
 be6:	4505                	li	a0,1
 be8:	8082                	ret
