
user/_threads:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <thread_create>:
static struct thread* current_thread = NULL;
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
    fprintf(2, "thread_create\n");
  12:	00001597          	auipc	a1,0x1
  16:	ab658593          	addi	a1,a1,-1354 # ac8 <longjmp_1+0x6>
  1a:	4509                	li	a0,2
  1c:	00001097          	auipc	ra,0x1
  20:	864080e7          	jalr	-1948(ra) # 880 <fprintf>
    struct thread *t = (struct thread*) malloc(sizeof(struct thread));
  24:	0a800513          	li	a0,168
  28:	00001097          	auipc	ra,0x1
  2c:	944080e7          	jalr	-1724(ra) # 96c <malloc>
  30:	84aa                	mv	s1,a0
    unsigned long new_stack_p;
    unsigned long new_stack;
    new_stack = (unsigned long) malloc(sizeof(unsigned long)*0x100);
  32:	6505                	lui	a0,0x1
  34:	80050513          	addi	a0,a0,-2048 # 800 <vprintf+0x15e>
  38:	00001097          	auipc	ra,0x1
  3c:	934080e7          	jalr	-1740(ra) # 96c <malloc>
    new_stack_p = new_stack +0x100*8-0x2*8;
    t->fp = f;
  40:	0134b023          	sd	s3,0(s1)
    t->arg = arg;
  44:	0124b423          	sd	s2,8(s1)
    t->ID  = id;
  48:	00001717          	auipc	a4,0x1
  4c:	b2c70713          	addi	a4,a4,-1236 # b74 <id>
  50:	431c                	lw	a5,0(a4)
  52:	08f4aa23          	sw	a5,148(s1)
    t->buf_set = 0;
  56:	0804a823          	sw	zero,144(s1)
    t->stack = (void*) new_stack;
  5a:	e888                	sd	a0,16(s1)
    new_stack_p = new_stack +0x100*8-0x2*8;
  5c:	7f050513          	addi	a0,a0,2032
    t->stack_p = (void*) new_stack_p;
  60:	ec88                	sd	a0,24(s1)
    id++;
  62:	2785                	addiw	a5,a5,1
  64:	c31c                	sw	a5,0(a4)
    return t;
}
  66:	8526                	mv	a0,s1
  68:	70a2                	ld	ra,40(sp)
  6a:	7402                	ld	s0,32(sp)
  6c:	64e2                	ld	s1,24(sp)
  6e:	6942                	ld	s2,16(sp)
  70:	69a2                	ld	s3,8(sp)
  72:	6145                	addi	sp,sp,48
  74:	8082                	ret

0000000000000076 <thread_add_runqueue>:
void thread_add_runqueue(struct thread *t){
  76:	1101                	addi	sp,sp,-32
  78:	ec06                	sd	ra,24(sp)
  7a:	e822                	sd	s0,16(sp)
  7c:	e426                	sd	s1,8(sp)
  7e:	1000                	addi	s0,sp,32
  80:	84aa                	mv	s1,a0
    fprintf(2, "thread_add_runqueue\n");
  82:	00001597          	auipc	a1,0x1
  86:	a5658593          	addi	a1,a1,-1450 # ad8 <longjmp_1+0x16>
  8a:	4509                	li	a0,2
  8c:	00000097          	auipc	ra,0x0
  90:	7f4080e7          	jalr	2036(ra) # 880 <fprintf>
    if(current_thread == NULL){
  94:	00001797          	auipc	a5,0x1
  98:	ae47b783          	ld	a5,-1308(a5) # b78 <current_thread>
  9c:	cb99                	beqz	a5,b2 <thread_add_runqueue+0x3c>
        current_thread = t;
        current_thread->previous = current_thread->next = current_thread;
    }
    else{
        t->previous = current_thread->previous;
  9e:	6fd8                	ld	a4,152(a5)
  a0:	ecd8                	sd	a4,152(s1)
        (current_thread->previous)->next = t;
  a2:	f344                	sd	s1,160(a4)
        t->next = current_thread;
  a4:	f0dc                	sd	a5,160(s1)
        current_thread->previous = t;
  a6:	efc4                	sd	s1,152(a5)
    }
}
  a8:	60e2                	ld	ra,24(sp)
  aa:	6442                	ld	s0,16(sp)
  ac:	64a2                	ld	s1,8(sp)
  ae:	6105                	addi	sp,sp,32
  b0:	8082                	ret
        current_thread = t;
  b2:	00001797          	auipc	a5,0x1
  b6:	ac97b323          	sd	s1,-1338(a5) # b78 <current_thread>
        current_thread->previous = current_thread->next = current_thread;
  ba:	f0c4                	sd	s1,160(s1)
  bc:	ecc4                	sd	s1,152(s1)
  be:	b7ed                	j	a8 <thread_add_runqueue+0x32>

00000000000000c0 <schedule>:
        thread_exit();
    }
    else
        longjmp(current_thread->env, 1);
}
void schedule(void){
  c0:	1101                	addi	sp,sp,-32
  c2:	ec06                	sd	ra,24(sp)
  c4:	e822                	sd	s0,16(sp)
  c6:	e426                	sd	s1,8(sp)
  c8:	1000                	addi	s0,sp,32
    fprintf(2, "schedule\n");
  ca:	00001597          	auipc	a1,0x1
  ce:	a2658593          	addi	a1,a1,-1498 # af0 <longjmp_1+0x2e>
  d2:	4509                	li	a0,2
  d4:	00000097          	auipc	ra,0x0
  d8:	7ac080e7          	jalr	1964(ra) # 880 <fprintf>
    fprintf(2, "current id: %d\n", current_thread->ID);
  dc:	00001497          	auipc	s1,0x1
  e0:	a9c48493          	addi	s1,s1,-1380 # b78 <current_thread>
  e4:	609c                	ld	a5,0(s1)
  e6:	0947a603          	lw	a2,148(a5)
  ea:	00001597          	auipc	a1,0x1
  ee:	a1658593          	addi	a1,a1,-1514 # b00 <longjmp_1+0x3e>
  f2:	4509                	li	a0,2
  f4:	00000097          	auipc	ra,0x0
  f8:	78c080e7          	jalr	1932(ra) # 880 <fprintf>
    current_thread = current_thread->next;
  fc:	609c                	ld	a5,0(s1)
  fe:	73dc                	ld	a5,160(a5)
 100:	e09c                	sd	a5,0(s1)
    fprintf(2, "current id: %d\n", current_thread->ID);
 102:	0947a603          	lw	a2,148(a5)
 106:	00001597          	auipc	a1,0x1
 10a:	9fa58593          	addi	a1,a1,-1542 # b00 <longjmp_1+0x3e>
 10e:	4509                	li	a0,2
 110:	00000097          	auipc	ra,0x0
 114:	770080e7          	jalr	1904(ra) # 880 <fprintf>
}
 118:	60e2                	ld	ra,24(sp)
 11a:	6442                	ld	s0,16(sp)
 11c:	64a2                	ld	s1,8(sp)
 11e:	6105                	addi	sp,sp,32
 120:	8082                	ret

0000000000000122 <thread_exit>:
void thread_exit(void){
 122:	1101                	addi	sp,sp,-32
 124:	ec06                	sd	ra,24(sp)
 126:	e822                	sd	s0,16(sp)
 128:	e426                	sd	s1,8(sp)
 12a:	1000                	addi	s0,sp,32
    fprintf(2, "thread_exit\n");
 12c:	00001597          	auipc	a1,0x1
 130:	9e458593          	addi	a1,a1,-1564 # b10 <longjmp_1+0x4e>
 134:	4509                	li	a0,2
 136:	00000097          	auipc	ra,0x0
 13a:	74a080e7          	jalr	1866(ra) # 880 <fprintf>
    if(current_thread->next != current_thread){
 13e:	00001497          	auipc	s1,0x1
 142:	a3a4b483          	ld	s1,-1478(s1) # b78 <current_thread>
 146:	70dc                	ld	a5,160(s1)
 148:	02f48d63          	beq	s1,a5,182 <thread_exit+0x60>
        // TODO
        (current_thread->previous)->next = current_thread->next;
 14c:	6cd8                	ld	a4,152(s1)
 14e:	f35c                	sd	a5,160(a4)
        (current_thread->next)->previous = current_thread->previous;
 150:	6cd8                	ld	a4,152(s1)
 152:	efd8                	sd	a4,152(a5)
        struct thread *tmp = current_thread;
        schedule();
 154:	00000097          	auipc	ra,0x0
 158:	f6c080e7          	jalr	-148(ra) # c0 <schedule>
        free(tmp->stack);
 15c:	6888                	ld	a0,16(s1)
 15e:	00000097          	auipc	ra,0x0
 162:	786080e7          	jalr	1926(ra) # 8e4 <free>
        free(tmp);
 166:	8526                	mv	a0,s1
 168:	00000097          	auipc	ra,0x0
 16c:	77c080e7          	jalr	1916(ra) # 8e4 <free>
        dispatch();
 170:	00000097          	auipc	ra,0x0
 174:	046080e7          	jalr	70(ra) # 1b6 <dispatch>
        free(current_thread->stack);
        free(current_thread);
        current_thread = NULL;
        longjmp(env_st, 1);
    }
}
 178:	60e2                	ld	ra,24(sp)
 17a:	6442                	ld	s0,16(sp)
 17c:	64a2                	ld	s1,8(sp)
 17e:	6105                	addi	sp,sp,32
 180:	8082                	ret
        free(current_thread->stack);
 182:	6888                	ld	a0,16(s1)
 184:	00000097          	auipc	ra,0x0
 188:	760080e7          	jalr	1888(ra) # 8e4 <free>
        free(current_thread);
 18c:	00001497          	auipc	s1,0x1
 190:	9ec48493          	addi	s1,s1,-1556 # b78 <current_thread>
 194:	6088                	ld	a0,0(s1)
 196:	00000097          	auipc	ra,0x0
 19a:	74e080e7          	jalr	1870(ra) # 8e4 <free>
        current_thread = NULL;
 19e:	0004b023          	sd	zero,0(s1)
        longjmp(env_st, 1);
 1a2:	4585                	li	a1,1
 1a4:	00001517          	auipc	a0,0x1
 1a8:	9e450513          	addi	a0,a0,-1564 # b88 <env_st>
 1ac:	00001097          	auipc	ra,0x1
 1b0:	8dc080e7          	jalr	-1828(ra) # a88 <longjmp>
}
 1b4:	b7d1                	j	178 <thread_exit+0x56>

00000000000001b6 <dispatch>:
void dispatch(void){
 1b6:	1141                	addi	sp,sp,-16
 1b8:	e406                	sd	ra,8(sp)
 1ba:	e022                	sd	s0,0(sp)
 1bc:	0800                	addi	s0,sp,16
    fprintf(2, "dispatch\n");
 1be:	00001597          	auipc	a1,0x1
 1c2:	96258593          	addi	a1,a1,-1694 # b20 <longjmp_1+0x5e>
 1c6:	4509                	li	a0,2
 1c8:	00000097          	auipc	ra,0x0
 1cc:	6b8080e7          	jalr	1720(ra) # 880 <fprintf>
    if (current_thread->buf_set == 0){
 1d0:	00001517          	auipc	a0,0x1
 1d4:	9a853503          	ld	a0,-1624(a0) # b78 <current_thread>
 1d8:	09052783          	lw	a5,144(a0)
 1dc:	eb8d                	bnez	a5,20e <dispatch+0x58>
        current_thread->buf_set = 1;
 1de:	4785                	li	a5,1
 1e0:	08f52823          	sw	a5,144(a0)
        setjmp(current_thread->env);
 1e4:	02050513          	addi	a0,a0,32
 1e8:	00001097          	auipc	ra,0x1
 1ec:	868080e7          	jalr	-1944(ra) # a50 <setjmp>
        current_thread->fp(current_thread->arg);
 1f0:	00001797          	auipc	a5,0x1
 1f4:	9887b783          	ld	a5,-1656(a5) # b78 <current_thread>
 1f8:	6398                	ld	a4,0(a5)
 1fa:	6788                	ld	a0,8(a5)
 1fc:	9702                	jalr	a4
        thread_exit();
 1fe:	00000097          	auipc	ra,0x0
 202:	f24080e7          	jalr	-220(ra) # 122 <thread_exit>
}
 206:	60a2                	ld	ra,8(sp)
 208:	6402                	ld	s0,0(sp)
 20a:	0141                	addi	sp,sp,16
 20c:	8082                	ret
        longjmp(current_thread->env, 1);
 20e:	4585                	li	a1,1
 210:	02050513          	addi	a0,a0,32
 214:	00001097          	auipc	ra,0x1
 218:	874080e7          	jalr	-1932(ra) # a88 <longjmp>
}
 21c:	b7ed                	j	206 <dispatch+0x50>

000000000000021e <thread_yield>:
void thread_yield(void){
 21e:	1141                	addi	sp,sp,-16
 220:	e406                	sd	ra,8(sp)
 222:	e022                	sd	s0,0(sp)
 224:	0800                	addi	s0,sp,16
    fprintf(2, "thread_yield\n");
 226:	00001597          	auipc	a1,0x1
 22a:	90a58593          	addi	a1,a1,-1782 # b30 <longjmp_1+0x6e>
 22e:	4509                	li	a0,2
 230:	00000097          	auipc	ra,0x0
 234:	650080e7          	jalr	1616(ra) # 880 <fprintf>
    if (setjmp(current_thread->env) == 0){
 238:	00001517          	auipc	a0,0x1
 23c:	94053503          	ld	a0,-1728(a0) # b78 <current_thread>
 240:	02050513          	addi	a0,a0,32
 244:	00001097          	auipc	ra,0x1
 248:	80c080e7          	jalr	-2036(ra) # a50 <setjmp>
 24c:	c509                	beqz	a0,256 <thread_yield+0x38>
}
 24e:	60a2                	ld	ra,8(sp)
 250:	6402                	ld	s0,0(sp)
 252:	0141                	addi	sp,sp,16
 254:	8082                	ret
        current_thread->buf_set = 1;
 256:	00001797          	auipc	a5,0x1
 25a:	9227b783          	ld	a5,-1758(a5) # b78 <current_thread>
 25e:	4705                	li	a4,1
 260:	08e7a823          	sw	a4,144(a5)
        schedule();
 264:	00000097          	auipc	ra,0x0
 268:	e5c080e7          	jalr	-420(ra) # c0 <schedule>
        dispatch();
 26c:	00000097          	auipc	ra,0x0
 270:	f4a080e7          	jalr	-182(ra) # 1b6 <dispatch>
}
 274:	bfe9                	j	24e <thread_yield+0x30>

0000000000000276 <thread_start_threading>:
void thread_start_threading(void){
 276:	1141                	addi	sp,sp,-16
 278:	e406                	sd	ra,8(sp)
 27a:	e022                	sd	s0,0(sp)
 27c:	0800                	addi	s0,sp,16
    // TODO
    fprintf(2, "thread_start_threading\n");
 27e:	00001597          	auipc	a1,0x1
 282:	8c258593          	addi	a1,a1,-1854 # b40 <longjmp_1+0x7e>
 286:	4509                	li	a0,2
 288:	00000097          	auipc	ra,0x0
 28c:	5f8080e7          	jalr	1528(ra) # 880 <fprintf>
    if (setjmp(env_st) == 0)
 290:	00001517          	auipc	a0,0x1
 294:	8f850513          	addi	a0,a0,-1800 # b88 <env_st>
 298:	00000097          	auipc	ra,0x0
 29c:	7b8080e7          	jalr	1976(ra) # a50 <setjmp>
 2a0:	c509                	beqz	a0,2aa <thread_start_threading+0x34>
        dispatch();
    return;
}
 2a2:	60a2                	ld	ra,8(sp)
 2a4:	6402                	ld	s0,0(sp)
 2a6:	0141                	addi	sp,sp,16
 2a8:	8082                	ret
        dispatch();
 2aa:	00000097          	auipc	ra,0x0
 2ae:	f0c080e7          	jalr	-244(ra) # 1b6 <dispatch>
    return;
 2b2:	bfc5                	j	2a2 <thread_start_threading+0x2c>

00000000000002b4 <thread_assign_task>:

// part 2
void thread_assign_task(struct thread *t, void (*f)(void *), void *arg){
 2b4:	1141                	addi	sp,sp,-16
 2b6:	e422                	sd	s0,8(sp)
 2b8:	0800                	addi	s0,sp,16
    // TODO
}
 2ba:	6422                	ld	s0,8(sp)
 2bc:	0141                	addi	sp,sp,16
 2be:	8082                	ret

00000000000002c0 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 2c0:	1141                	addi	sp,sp,-16
 2c2:	e422                	sd	s0,8(sp)
 2c4:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2c6:	87aa                	mv	a5,a0
 2c8:	0585                	addi	a1,a1,1
 2ca:	0785                	addi	a5,a5,1
 2cc:	fff5c703          	lbu	a4,-1(a1)
 2d0:	fee78fa3          	sb	a4,-1(a5)
 2d4:	fb75                	bnez	a4,2c8 <strcpy+0x8>
    ;
  return os;
}
 2d6:	6422                	ld	s0,8(sp)
 2d8:	0141                	addi	sp,sp,16
 2da:	8082                	ret

00000000000002dc <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2dc:	1141                	addi	sp,sp,-16
 2de:	e422                	sd	s0,8(sp)
 2e0:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 2e2:	00054783          	lbu	a5,0(a0)
 2e6:	cb91                	beqz	a5,2fa <strcmp+0x1e>
 2e8:	0005c703          	lbu	a4,0(a1)
 2ec:	00f71763          	bne	a4,a5,2fa <strcmp+0x1e>
    p++, q++;
 2f0:	0505                	addi	a0,a0,1
 2f2:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 2f4:	00054783          	lbu	a5,0(a0)
 2f8:	fbe5                	bnez	a5,2e8 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 2fa:	0005c503          	lbu	a0,0(a1)
}
 2fe:	40a7853b          	subw	a0,a5,a0
 302:	6422                	ld	s0,8(sp)
 304:	0141                	addi	sp,sp,16
 306:	8082                	ret

0000000000000308 <strlen>:

uint
strlen(const char *s)
{
 308:	1141                	addi	sp,sp,-16
 30a:	e422                	sd	s0,8(sp)
 30c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 30e:	00054783          	lbu	a5,0(a0)
 312:	cf91                	beqz	a5,32e <strlen+0x26>
 314:	0505                	addi	a0,a0,1
 316:	87aa                	mv	a5,a0
 318:	4685                	li	a3,1
 31a:	9e89                	subw	a3,a3,a0
 31c:	00f6853b          	addw	a0,a3,a5
 320:	0785                	addi	a5,a5,1
 322:	fff7c703          	lbu	a4,-1(a5)
 326:	fb7d                	bnez	a4,31c <strlen+0x14>
    ;
  return n;
}
 328:	6422                	ld	s0,8(sp)
 32a:	0141                	addi	sp,sp,16
 32c:	8082                	ret
  for(n = 0; s[n]; n++)
 32e:	4501                	li	a0,0
 330:	bfe5                	j	328 <strlen+0x20>

0000000000000332 <memset>:

void*
memset(void *dst, int c, uint n)
{
 332:	1141                	addi	sp,sp,-16
 334:	e422                	sd	s0,8(sp)
 336:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 338:	ce09                	beqz	a2,352 <memset+0x20>
 33a:	87aa                	mv	a5,a0
 33c:	fff6071b          	addiw	a4,a2,-1
 340:	1702                	slli	a4,a4,0x20
 342:	9301                	srli	a4,a4,0x20
 344:	0705                	addi	a4,a4,1
 346:	972a                	add	a4,a4,a0
    cdst[i] = c;
 348:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 34c:	0785                	addi	a5,a5,1
 34e:	fee79de3          	bne	a5,a4,348 <memset+0x16>
  }
  return dst;
}
 352:	6422                	ld	s0,8(sp)
 354:	0141                	addi	sp,sp,16
 356:	8082                	ret

0000000000000358 <strchr>:

char*
strchr(const char *s, char c)
{
 358:	1141                	addi	sp,sp,-16
 35a:	e422                	sd	s0,8(sp)
 35c:	0800                	addi	s0,sp,16
  for(; *s; s++)
 35e:	00054783          	lbu	a5,0(a0)
 362:	cb99                	beqz	a5,378 <strchr+0x20>
    if(*s == c)
 364:	00f58763          	beq	a1,a5,372 <strchr+0x1a>
  for(; *s; s++)
 368:	0505                	addi	a0,a0,1
 36a:	00054783          	lbu	a5,0(a0)
 36e:	fbfd                	bnez	a5,364 <strchr+0xc>
      return (char*)s;
  return 0;
 370:	4501                	li	a0,0
}
 372:	6422                	ld	s0,8(sp)
 374:	0141                	addi	sp,sp,16
 376:	8082                	ret
  return 0;
 378:	4501                	li	a0,0
 37a:	bfe5                	j	372 <strchr+0x1a>

000000000000037c <gets>:

char*
gets(char *buf, int max)
{
 37c:	711d                	addi	sp,sp,-96
 37e:	ec86                	sd	ra,88(sp)
 380:	e8a2                	sd	s0,80(sp)
 382:	e4a6                	sd	s1,72(sp)
 384:	e0ca                	sd	s2,64(sp)
 386:	fc4e                	sd	s3,56(sp)
 388:	f852                	sd	s4,48(sp)
 38a:	f456                	sd	s5,40(sp)
 38c:	f05a                	sd	s6,32(sp)
 38e:	ec5e                	sd	s7,24(sp)
 390:	1080                	addi	s0,sp,96
 392:	8baa                	mv	s7,a0
 394:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 396:	892a                	mv	s2,a0
 398:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 39a:	4aa9                	li	s5,10
 39c:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 39e:	89a6                	mv	s3,s1
 3a0:	2485                	addiw	s1,s1,1
 3a2:	0344d863          	bge	s1,s4,3d2 <gets+0x56>
    cc = read(0, &c, 1);
 3a6:	4605                	li	a2,1
 3a8:	faf40593          	addi	a1,s0,-81
 3ac:	4501                	li	a0,0
 3ae:	00000097          	auipc	ra,0x0
 3b2:	1a0080e7          	jalr	416(ra) # 54e <read>
    if(cc < 1)
 3b6:	00a05e63          	blez	a0,3d2 <gets+0x56>
    buf[i++] = c;
 3ba:	faf44783          	lbu	a5,-81(s0)
 3be:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 3c2:	01578763          	beq	a5,s5,3d0 <gets+0x54>
 3c6:	0905                	addi	s2,s2,1
 3c8:	fd679be3          	bne	a5,s6,39e <gets+0x22>
  for(i=0; i+1 < max; ){
 3cc:	89a6                	mv	s3,s1
 3ce:	a011                	j	3d2 <gets+0x56>
 3d0:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 3d2:	99de                	add	s3,s3,s7
 3d4:	00098023          	sb	zero,0(s3)
  return buf;
}
 3d8:	855e                	mv	a0,s7
 3da:	60e6                	ld	ra,88(sp)
 3dc:	6446                	ld	s0,80(sp)
 3de:	64a6                	ld	s1,72(sp)
 3e0:	6906                	ld	s2,64(sp)
 3e2:	79e2                	ld	s3,56(sp)
 3e4:	7a42                	ld	s4,48(sp)
 3e6:	7aa2                	ld	s5,40(sp)
 3e8:	7b02                	ld	s6,32(sp)
 3ea:	6be2                	ld	s7,24(sp)
 3ec:	6125                	addi	sp,sp,96
 3ee:	8082                	ret

00000000000003f0 <stat>:

int
stat(const char *n, struct stat *st)
{
 3f0:	1101                	addi	sp,sp,-32
 3f2:	ec06                	sd	ra,24(sp)
 3f4:	e822                	sd	s0,16(sp)
 3f6:	e426                	sd	s1,8(sp)
 3f8:	e04a                	sd	s2,0(sp)
 3fa:	1000                	addi	s0,sp,32
 3fc:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3fe:	4581                	li	a1,0
 400:	00000097          	auipc	ra,0x0
 404:	176080e7          	jalr	374(ra) # 576 <open>
  if(fd < 0)
 408:	02054563          	bltz	a0,432 <stat+0x42>
 40c:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 40e:	85ca                	mv	a1,s2
 410:	00000097          	auipc	ra,0x0
 414:	17e080e7          	jalr	382(ra) # 58e <fstat>
 418:	892a                	mv	s2,a0
  close(fd);
 41a:	8526                	mv	a0,s1
 41c:	00000097          	auipc	ra,0x0
 420:	142080e7          	jalr	322(ra) # 55e <close>
  return r;
}
 424:	854a                	mv	a0,s2
 426:	60e2                	ld	ra,24(sp)
 428:	6442                	ld	s0,16(sp)
 42a:	64a2                	ld	s1,8(sp)
 42c:	6902                	ld	s2,0(sp)
 42e:	6105                	addi	sp,sp,32
 430:	8082                	ret
    return -1;
 432:	597d                	li	s2,-1
 434:	bfc5                	j	424 <stat+0x34>

0000000000000436 <atoi>:

int
atoi(const char *s)
{
 436:	1141                	addi	sp,sp,-16
 438:	e422                	sd	s0,8(sp)
 43a:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 43c:	00054603          	lbu	a2,0(a0)
 440:	fd06079b          	addiw	a5,a2,-48
 444:	0ff7f793          	andi	a5,a5,255
 448:	4725                	li	a4,9
 44a:	02f76963          	bltu	a4,a5,47c <atoi+0x46>
 44e:	86aa                	mv	a3,a0
  n = 0;
 450:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 452:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 454:	0685                	addi	a3,a3,1
 456:	0025179b          	slliw	a5,a0,0x2
 45a:	9fa9                	addw	a5,a5,a0
 45c:	0017979b          	slliw	a5,a5,0x1
 460:	9fb1                	addw	a5,a5,a2
 462:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 466:	0006c603          	lbu	a2,0(a3)
 46a:	fd06071b          	addiw	a4,a2,-48
 46e:	0ff77713          	andi	a4,a4,255
 472:	fee5f1e3          	bgeu	a1,a4,454 <atoi+0x1e>
  return n;
}
 476:	6422                	ld	s0,8(sp)
 478:	0141                	addi	sp,sp,16
 47a:	8082                	ret
  n = 0;
 47c:	4501                	li	a0,0
 47e:	bfe5                	j	476 <atoi+0x40>

0000000000000480 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 480:	1141                	addi	sp,sp,-16
 482:	e422                	sd	s0,8(sp)
 484:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 486:	02b57663          	bgeu	a0,a1,4b2 <memmove+0x32>
    while(n-- > 0)
 48a:	02c05163          	blez	a2,4ac <memmove+0x2c>
 48e:	fff6079b          	addiw	a5,a2,-1
 492:	1782                	slli	a5,a5,0x20
 494:	9381                	srli	a5,a5,0x20
 496:	0785                	addi	a5,a5,1
 498:	97aa                	add	a5,a5,a0
  dst = vdst;
 49a:	872a                	mv	a4,a0
      *dst++ = *src++;
 49c:	0585                	addi	a1,a1,1
 49e:	0705                	addi	a4,a4,1
 4a0:	fff5c683          	lbu	a3,-1(a1)
 4a4:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 4a8:	fee79ae3          	bne	a5,a4,49c <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 4ac:	6422                	ld	s0,8(sp)
 4ae:	0141                	addi	sp,sp,16
 4b0:	8082                	ret
    dst += n;
 4b2:	00c50733          	add	a4,a0,a2
    src += n;
 4b6:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 4b8:	fec05ae3          	blez	a2,4ac <memmove+0x2c>
 4bc:	fff6079b          	addiw	a5,a2,-1
 4c0:	1782                	slli	a5,a5,0x20
 4c2:	9381                	srli	a5,a5,0x20
 4c4:	fff7c793          	not	a5,a5
 4c8:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 4ca:	15fd                	addi	a1,a1,-1
 4cc:	177d                	addi	a4,a4,-1
 4ce:	0005c683          	lbu	a3,0(a1)
 4d2:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 4d6:	fee79ae3          	bne	a5,a4,4ca <memmove+0x4a>
 4da:	bfc9                	j	4ac <memmove+0x2c>

00000000000004dc <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 4dc:	1141                	addi	sp,sp,-16
 4de:	e422                	sd	s0,8(sp)
 4e0:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 4e2:	ca05                	beqz	a2,512 <memcmp+0x36>
 4e4:	fff6069b          	addiw	a3,a2,-1
 4e8:	1682                	slli	a3,a3,0x20
 4ea:	9281                	srli	a3,a3,0x20
 4ec:	0685                	addi	a3,a3,1
 4ee:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 4f0:	00054783          	lbu	a5,0(a0)
 4f4:	0005c703          	lbu	a4,0(a1)
 4f8:	00e79863          	bne	a5,a4,508 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 4fc:	0505                	addi	a0,a0,1
    p2++;
 4fe:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 500:	fed518e3          	bne	a0,a3,4f0 <memcmp+0x14>
  }
  return 0;
 504:	4501                	li	a0,0
 506:	a019                	j	50c <memcmp+0x30>
      return *p1 - *p2;
 508:	40e7853b          	subw	a0,a5,a4
}
 50c:	6422                	ld	s0,8(sp)
 50e:	0141                	addi	sp,sp,16
 510:	8082                	ret
  return 0;
 512:	4501                	li	a0,0
 514:	bfe5                	j	50c <memcmp+0x30>

0000000000000516 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 516:	1141                	addi	sp,sp,-16
 518:	e406                	sd	ra,8(sp)
 51a:	e022                	sd	s0,0(sp)
 51c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 51e:	00000097          	auipc	ra,0x0
 522:	f62080e7          	jalr	-158(ra) # 480 <memmove>
}
 526:	60a2                	ld	ra,8(sp)
 528:	6402                	ld	s0,0(sp)
 52a:	0141                	addi	sp,sp,16
 52c:	8082                	ret

000000000000052e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 52e:	4885                	li	a7,1
 ecall
 530:	00000073          	ecall
 ret
 534:	8082                	ret

0000000000000536 <exit>:
.global exit
exit:
 li a7, SYS_exit
 536:	4889                	li	a7,2
 ecall
 538:	00000073          	ecall
 ret
 53c:	8082                	ret

000000000000053e <wait>:
.global wait
wait:
 li a7, SYS_wait
 53e:	488d                	li	a7,3
 ecall
 540:	00000073          	ecall
 ret
 544:	8082                	ret

0000000000000546 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 546:	4891                	li	a7,4
 ecall
 548:	00000073          	ecall
 ret
 54c:	8082                	ret

000000000000054e <read>:
.global read
read:
 li a7, SYS_read
 54e:	4895                	li	a7,5
 ecall
 550:	00000073          	ecall
 ret
 554:	8082                	ret

0000000000000556 <write>:
.global write
write:
 li a7, SYS_write
 556:	48c1                	li	a7,16
 ecall
 558:	00000073          	ecall
 ret
 55c:	8082                	ret

000000000000055e <close>:
.global close
close:
 li a7, SYS_close
 55e:	48d5                	li	a7,21
 ecall
 560:	00000073          	ecall
 ret
 564:	8082                	ret

0000000000000566 <kill>:
.global kill
kill:
 li a7, SYS_kill
 566:	4899                	li	a7,6
 ecall
 568:	00000073          	ecall
 ret
 56c:	8082                	ret

000000000000056e <exec>:
.global exec
exec:
 li a7, SYS_exec
 56e:	489d                	li	a7,7
 ecall
 570:	00000073          	ecall
 ret
 574:	8082                	ret

0000000000000576 <open>:
.global open
open:
 li a7, SYS_open
 576:	48bd                	li	a7,15
 ecall
 578:	00000073          	ecall
 ret
 57c:	8082                	ret

000000000000057e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 57e:	48c5                	li	a7,17
 ecall
 580:	00000073          	ecall
 ret
 584:	8082                	ret

0000000000000586 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 586:	48c9                	li	a7,18
 ecall
 588:	00000073          	ecall
 ret
 58c:	8082                	ret

000000000000058e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 58e:	48a1                	li	a7,8
 ecall
 590:	00000073          	ecall
 ret
 594:	8082                	ret

0000000000000596 <link>:
.global link
link:
 li a7, SYS_link
 596:	48cd                	li	a7,19
 ecall
 598:	00000073          	ecall
 ret
 59c:	8082                	ret

000000000000059e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 59e:	48d1                	li	a7,20
 ecall
 5a0:	00000073          	ecall
 ret
 5a4:	8082                	ret

00000000000005a6 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 5a6:	48a5                	li	a7,9
 ecall
 5a8:	00000073          	ecall
 ret
 5ac:	8082                	ret

00000000000005ae <dup>:
.global dup
dup:
 li a7, SYS_dup
 5ae:	48a9                	li	a7,10
 ecall
 5b0:	00000073          	ecall
 ret
 5b4:	8082                	ret

00000000000005b6 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5b6:	48ad                	li	a7,11
 ecall
 5b8:	00000073          	ecall
 ret
 5bc:	8082                	ret

00000000000005be <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 5be:	48b1                	li	a7,12
 ecall
 5c0:	00000073          	ecall
 ret
 5c4:	8082                	ret

00000000000005c6 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 5c6:	48b5                	li	a7,13
 ecall
 5c8:	00000073          	ecall
 ret
 5cc:	8082                	ret

00000000000005ce <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 5ce:	48b9                	li	a7,14
 ecall
 5d0:	00000073          	ecall
 ret
 5d4:	8082                	ret

00000000000005d6 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5d6:	1101                	addi	sp,sp,-32
 5d8:	ec06                	sd	ra,24(sp)
 5da:	e822                	sd	s0,16(sp)
 5dc:	1000                	addi	s0,sp,32
 5de:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 5e2:	4605                	li	a2,1
 5e4:	fef40593          	addi	a1,s0,-17
 5e8:	00000097          	auipc	ra,0x0
 5ec:	f6e080e7          	jalr	-146(ra) # 556 <write>
}
 5f0:	60e2                	ld	ra,24(sp)
 5f2:	6442                	ld	s0,16(sp)
 5f4:	6105                	addi	sp,sp,32
 5f6:	8082                	ret

00000000000005f8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5f8:	7139                	addi	sp,sp,-64
 5fa:	fc06                	sd	ra,56(sp)
 5fc:	f822                	sd	s0,48(sp)
 5fe:	f426                	sd	s1,40(sp)
 600:	f04a                	sd	s2,32(sp)
 602:	ec4e                	sd	s3,24(sp)
 604:	0080                	addi	s0,sp,64
 606:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 608:	c299                	beqz	a3,60e <printint+0x16>
 60a:	0805c863          	bltz	a1,69a <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 60e:	2581                	sext.w	a1,a1
  neg = 0;
 610:	4881                	li	a7,0
 612:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 616:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 618:	2601                	sext.w	a2,a2
 61a:	00000517          	auipc	a0,0x0
 61e:	54650513          	addi	a0,a0,1350 # b60 <digits>
 622:	883a                	mv	a6,a4
 624:	2705                	addiw	a4,a4,1
 626:	02c5f7bb          	remuw	a5,a1,a2
 62a:	1782                	slli	a5,a5,0x20
 62c:	9381                	srli	a5,a5,0x20
 62e:	97aa                	add	a5,a5,a0
 630:	0007c783          	lbu	a5,0(a5)
 634:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 638:	0005879b          	sext.w	a5,a1
 63c:	02c5d5bb          	divuw	a1,a1,a2
 640:	0685                	addi	a3,a3,1
 642:	fec7f0e3          	bgeu	a5,a2,622 <printint+0x2a>
  if(neg)
 646:	00088b63          	beqz	a7,65c <printint+0x64>
    buf[i++] = '-';
 64a:	fd040793          	addi	a5,s0,-48
 64e:	973e                	add	a4,a4,a5
 650:	02d00793          	li	a5,45
 654:	fef70823          	sb	a5,-16(a4)
 658:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 65c:	02e05863          	blez	a4,68c <printint+0x94>
 660:	fc040793          	addi	a5,s0,-64
 664:	00e78933          	add	s2,a5,a4
 668:	fff78993          	addi	s3,a5,-1
 66c:	99ba                	add	s3,s3,a4
 66e:	377d                	addiw	a4,a4,-1
 670:	1702                	slli	a4,a4,0x20
 672:	9301                	srli	a4,a4,0x20
 674:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 678:	fff94583          	lbu	a1,-1(s2)
 67c:	8526                	mv	a0,s1
 67e:	00000097          	auipc	ra,0x0
 682:	f58080e7          	jalr	-168(ra) # 5d6 <putc>
  while(--i >= 0)
 686:	197d                	addi	s2,s2,-1
 688:	ff3918e3          	bne	s2,s3,678 <printint+0x80>
}
 68c:	70e2                	ld	ra,56(sp)
 68e:	7442                	ld	s0,48(sp)
 690:	74a2                	ld	s1,40(sp)
 692:	7902                	ld	s2,32(sp)
 694:	69e2                	ld	s3,24(sp)
 696:	6121                	addi	sp,sp,64
 698:	8082                	ret
    x = -xx;
 69a:	40b005bb          	negw	a1,a1
    neg = 1;
 69e:	4885                	li	a7,1
    x = -xx;
 6a0:	bf8d                	j	612 <printint+0x1a>

00000000000006a2 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 6a2:	7119                	addi	sp,sp,-128
 6a4:	fc86                	sd	ra,120(sp)
 6a6:	f8a2                	sd	s0,112(sp)
 6a8:	f4a6                	sd	s1,104(sp)
 6aa:	f0ca                	sd	s2,96(sp)
 6ac:	ecce                	sd	s3,88(sp)
 6ae:	e8d2                	sd	s4,80(sp)
 6b0:	e4d6                	sd	s5,72(sp)
 6b2:	e0da                	sd	s6,64(sp)
 6b4:	fc5e                	sd	s7,56(sp)
 6b6:	f862                	sd	s8,48(sp)
 6b8:	f466                	sd	s9,40(sp)
 6ba:	f06a                	sd	s10,32(sp)
 6bc:	ec6e                	sd	s11,24(sp)
 6be:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 6c0:	0005c903          	lbu	s2,0(a1)
 6c4:	18090f63          	beqz	s2,862 <vprintf+0x1c0>
 6c8:	8aaa                	mv	s5,a0
 6ca:	8b32                	mv	s6,a2
 6cc:	00158493          	addi	s1,a1,1
  state = 0;
 6d0:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 6d2:	02500a13          	li	s4,37
      if(c == 'd'){
 6d6:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 6da:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 6de:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 6e2:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6e6:	00000b97          	auipc	s7,0x0
 6ea:	47ab8b93          	addi	s7,s7,1146 # b60 <digits>
 6ee:	a839                	j	70c <vprintf+0x6a>
        putc(fd, c);
 6f0:	85ca                	mv	a1,s2
 6f2:	8556                	mv	a0,s5
 6f4:	00000097          	auipc	ra,0x0
 6f8:	ee2080e7          	jalr	-286(ra) # 5d6 <putc>
 6fc:	a019                	j	702 <vprintf+0x60>
    } else if(state == '%'){
 6fe:	01498f63          	beq	s3,s4,71c <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 702:	0485                	addi	s1,s1,1
 704:	fff4c903          	lbu	s2,-1(s1)
 708:	14090d63          	beqz	s2,862 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 70c:	0009079b          	sext.w	a5,s2
    if(state == 0){
 710:	fe0997e3          	bnez	s3,6fe <vprintf+0x5c>
      if(c == '%'){
 714:	fd479ee3          	bne	a5,s4,6f0 <vprintf+0x4e>
        state = '%';
 718:	89be                	mv	s3,a5
 71a:	b7e5                	j	702 <vprintf+0x60>
      if(c == 'd'){
 71c:	05878063          	beq	a5,s8,75c <vprintf+0xba>
      } else if(c == 'l') {
 720:	05978c63          	beq	a5,s9,778 <vprintf+0xd6>
      } else if(c == 'x') {
 724:	07a78863          	beq	a5,s10,794 <vprintf+0xf2>
      } else if(c == 'p') {
 728:	09b78463          	beq	a5,s11,7b0 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 72c:	07300713          	li	a4,115
 730:	0ce78663          	beq	a5,a4,7fc <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 734:	06300713          	li	a4,99
 738:	0ee78e63          	beq	a5,a4,834 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 73c:	11478863          	beq	a5,s4,84c <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 740:	85d2                	mv	a1,s4
 742:	8556                	mv	a0,s5
 744:	00000097          	auipc	ra,0x0
 748:	e92080e7          	jalr	-366(ra) # 5d6 <putc>
        putc(fd, c);
 74c:	85ca                	mv	a1,s2
 74e:	8556                	mv	a0,s5
 750:	00000097          	auipc	ra,0x0
 754:	e86080e7          	jalr	-378(ra) # 5d6 <putc>
      }
      state = 0;
 758:	4981                	li	s3,0
 75a:	b765                	j	702 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 75c:	008b0913          	addi	s2,s6,8
 760:	4685                	li	a3,1
 762:	4629                	li	a2,10
 764:	000b2583          	lw	a1,0(s6)
 768:	8556                	mv	a0,s5
 76a:	00000097          	auipc	ra,0x0
 76e:	e8e080e7          	jalr	-370(ra) # 5f8 <printint>
 772:	8b4a                	mv	s6,s2
      state = 0;
 774:	4981                	li	s3,0
 776:	b771                	j	702 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 778:	008b0913          	addi	s2,s6,8
 77c:	4681                	li	a3,0
 77e:	4629                	li	a2,10
 780:	000b2583          	lw	a1,0(s6)
 784:	8556                	mv	a0,s5
 786:	00000097          	auipc	ra,0x0
 78a:	e72080e7          	jalr	-398(ra) # 5f8 <printint>
 78e:	8b4a                	mv	s6,s2
      state = 0;
 790:	4981                	li	s3,0
 792:	bf85                	j	702 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 794:	008b0913          	addi	s2,s6,8
 798:	4681                	li	a3,0
 79a:	4641                	li	a2,16
 79c:	000b2583          	lw	a1,0(s6)
 7a0:	8556                	mv	a0,s5
 7a2:	00000097          	auipc	ra,0x0
 7a6:	e56080e7          	jalr	-426(ra) # 5f8 <printint>
 7aa:	8b4a                	mv	s6,s2
      state = 0;
 7ac:	4981                	li	s3,0
 7ae:	bf91                	j	702 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 7b0:	008b0793          	addi	a5,s6,8
 7b4:	f8f43423          	sd	a5,-120(s0)
 7b8:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 7bc:	03000593          	li	a1,48
 7c0:	8556                	mv	a0,s5
 7c2:	00000097          	auipc	ra,0x0
 7c6:	e14080e7          	jalr	-492(ra) # 5d6 <putc>
  putc(fd, 'x');
 7ca:	85ea                	mv	a1,s10
 7cc:	8556                	mv	a0,s5
 7ce:	00000097          	auipc	ra,0x0
 7d2:	e08080e7          	jalr	-504(ra) # 5d6 <putc>
 7d6:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7d8:	03c9d793          	srli	a5,s3,0x3c
 7dc:	97de                	add	a5,a5,s7
 7de:	0007c583          	lbu	a1,0(a5)
 7e2:	8556                	mv	a0,s5
 7e4:	00000097          	auipc	ra,0x0
 7e8:	df2080e7          	jalr	-526(ra) # 5d6 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7ec:	0992                	slli	s3,s3,0x4
 7ee:	397d                	addiw	s2,s2,-1
 7f0:	fe0914e3          	bnez	s2,7d8 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 7f4:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 7f8:	4981                	li	s3,0
 7fa:	b721                	j	702 <vprintf+0x60>
        s = va_arg(ap, char*);
 7fc:	008b0993          	addi	s3,s6,8
 800:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 804:	02090163          	beqz	s2,826 <vprintf+0x184>
        while(*s != 0){
 808:	00094583          	lbu	a1,0(s2)
 80c:	c9a1                	beqz	a1,85c <vprintf+0x1ba>
          putc(fd, *s);
 80e:	8556                	mv	a0,s5
 810:	00000097          	auipc	ra,0x0
 814:	dc6080e7          	jalr	-570(ra) # 5d6 <putc>
          s++;
 818:	0905                	addi	s2,s2,1
        while(*s != 0){
 81a:	00094583          	lbu	a1,0(s2)
 81e:	f9e5                	bnez	a1,80e <vprintf+0x16c>
        s = va_arg(ap, char*);
 820:	8b4e                	mv	s6,s3
      state = 0;
 822:	4981                	li	s3,0
 824:	bdf9                	j	702 <vprintf+0x60>
          s = "(null)";
 826:	00000917          	auipc	s2,0x0
 82a:	33290913          	addi	s2,s2,818 # b58 <longjmp_1+0x96>
        while(*s != 0){
 82e:	02800593          	li	a1,40
 832:	bff1                	j	80e <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 834:	008b0913          	addi	s2,s6,8
 838:	000b4583          	lbu	a1,0(s6)
 83c:	8556                	mv	a0,s5
 83e:	00000097          	auipc	ra,0x0
 842:	d98080e7          	jalr	-616(ra) # 5d6 <putc>
 846:	8b4a                	mv	s6,s2
      state = 0;
 848:	4981                	li	s3,0
 84a:	bd65                	j	702 <vprintf+0x60>
        putc(fd, c);
 84c:	85d2                	mv	a1,s4
 84e:	8556                	mv	a0,s5
 850:	00000097          	auipc	ra,0x0
 854:	d86080e7          	jalr	-634(ra) # 5d6 <putc>
      state = 0;
 858:	4981                	li	s3,0
 85a:	b565                	j	702 <vprintf+0x60>
        s = va_arg(ap, char*);
 85c:	8b4e                	mv	s6,s3
      state = 0;
 85e:	4981                	li	s3,0
 860:	b54d                	j	702 <vprintf+0x60>
    }
  }
}
 862:	70e6                	ld	ra,120(sp)
 864:	7446                	ld	s0,112(sp)
 866:	74a6                	ld	s1,104(sp)
 868:	7906                	ld	s2,96(sp)
 86a:	69e6                	ld	s3,88(sp)
 86c:	6a46                	ld	s4,80(sp)
 86e:	6aa6                	ld	s5,72(sp)
 870:	6b06                	ld	s6,64(sp)
 872:	7be2                	ld	s7,56(sp)
 874:	7c42                	ld	s8,48(sp)
 876:	7ca2                	ld	s9,40(sp)
 878:	7d02                	ld	s10,32(sp)
 87a:	6de2                	ld	s11,24(sp)
 87c:	6109                	addi	sp,sp,128
 87e:	8082                	ret

0000000000000880 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 880:	715d                	addi	sp,sp,-80
 882:	ec06                	sd	ra,24(sp)
 884:	e822                	sd	s0,16(sp)
 886:	1000                	addi	s0,sp,32
 888:	e010                	sd	a2,0(s0)
 88a:	e414                	sd	a3,8(s0)
 88c:	e818                	sd	a4,16(s0)
 88e:	ec1c                	sd	a5,24(s0)
 890:	03043023          	sd	a6,32(s0)
 894:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 898:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 89c:	8622                	mv	a2,s0
 89e:	00000097          	auipc	ra,0x0
 8a2:	e04080e7          	jalr	-508(ra) # 6a2 <vprintf>
}
 8a6:	60e2                	ld	ra,24(sp)
 8a8:	6442                	ld	s0,16(sp)
 8aa:	6161                	addi	sp,sp,80
 8ac:	8082                	ret

00000000000008ae <printf>:

void
printf(const char *fmt, ...)
{
 8ae:	711d                	addi	sp,sp,-96
 8b0:	ec06                	sd	ra,24(sp)
 8b2:	e822                	sd	s0,16(sp)
 8b4:	1000                	addi	s0,sp,32
 8b6:	e40c                	sd	a1,8(s0)
 8b8:	e810                	sd	a2,16(s0)
 8ba:	ec14                	sd	a3,24(s0)
 8bc:	f018                	sd	a4,32(s0)
 8be:	f41c                	sd	a5,40(s0)
 8c0:	03043823          	sd	a6,48(s0)
 8c4:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 8c8:	00840613          	addi	a2,s0,8
 8cc:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 8d0:	85aa                	mv	a1,a0
 8d2:	4505                	li	a0,1
 8d4:	00000097          	auipc	ra,0x0
 8d8:	dce080e7          	jalr	-562(ra) # 6a2 <vprintf>
}
 8dc:	60e2                	ld	ra,24(sp)
 8de:	6442                	ld	s0,16(sp)
 8e0:	6125                	addi	sp,sp,96
 8e2:	8082                	ret

00000000000008e4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8e4:	1141                	addi	sp,sp,-16
 8e6:	e422                	sd	s0,8(sp)
 8e8:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8ea:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8ee:	00000797          	auipc	a5,0x0
 8f2:	2927b783          	ld	a5,658(a5) # b80 <freep>
 8f6:	a805                	j	926 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 8f8:	4618                	lw	a4,8(a2)
 8fa:	9db9                	addw	a1,a1,a4
 8fc:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 900:	6398                	ld	a4,0(a5)
 902:	6318                	ld	a4,0(a4)
 904:	fee53823          	sd	a4,-16(a0)
 908:	a091                	j	94c <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 90a:	ff852703          	lw	a4,-8(a0)
 90e:	9e39                	addw	a2,a2,a4
 910:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 912:	ff053703          	ld	a4,-16(a0)
 916:	e398                	sd	a4,0(a5)
 918:	a099                	j	95e <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 91a:	6398                	ld	a4,0(a5)
 91c:	00e7e463          	bltu	a5,a4,924 <free+0x40>
 920:	00e6ea63          	bltu	a3,a4,934 <free+0x50>
{
 924:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 926:	fed7fae3          	bgeu	a5,a3,91a <free+0x36>
 92a:	6398                	ld	a4,0(a5)
 92c:	00e6e463          	bltu	a3,a4,934 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 930:	fee7eae3          	bltu	a5,a4,924 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 934:	ff852583          	lw	a1,-8(a0)
 938:	6390                	ld	a2,0(a5)
 93a:	02059713          	slli	a4,a1,0x20
 93e:	9301                	srli	a4,a4,0x20
 940:	0712                	slli	a4,a4,0x4
 942:	9736                	add	a4,a4,a3
 944:	fae60ae3          	beq	a2,a4,8f8 <free+0x14>
    bp->s.ptr = p->s.ptr;
 948:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 94c:	4790                	lw	a2,8(a5)
 94e:	02061713          	slli	a4,a2,0x20
 952:	9301                	srli	a4,a4,0x20
 954:	0712                	slli	a4,a4,0x4
 956:	973e                	add	a4,a4,a5
 958:	fae689e3          	beq	a3,a4,90a <free+0x26>
  } else
    p->s.ptr = bp;
 95c:	e394                	sd	a3,0(a5)
  freep = p;
 95e:	00000717          	auipc	a4,0x0
 962:	22f73123          	sd	a5,546(a4) # b80 <freep>
}
 966:	6422                	ld	s0,8(sp)
 968:	0141                	addi	sp,sp,16
 96a:	8082                	ret

000000000000096c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 96c:	7139                	addi	sp,sp,-64
 96e:	fc06                	sd	ra,56(sp)
 970:	f822                	sd	s0,48(sp)
 972:	f426                	sd	s1,40(sp)
 974:	f04a                	sd	s2,32(sp)
 976:	ec4e                	sd	s3,24(sp)
 978:	e852                	sd	s4,16(sp)
 97a:	e456                	sd	s5,8(sp)
 97c:	e05a                	sd	s6,0(sp)
 97e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 980:	02051493          	slli	s1,a0,0x20
 984:	9081                	srli	s1,s1,0x20
 986:	04bd                	addi	s1,s1,15
 988:	8091                	srli	s1,s1,0x4
 98a:	0014899b          	addiw	s3,s1,1
 98e:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 990:	00000517          	auipc	a0,0x0
 994:	1f053503          	ld	a0,496(a0) # b80 <freep>
 998:	c515                	beqz	a0,9c4 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 99a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 99c:	4798                	lw	a4,8(a5)
 99e:	02977f63          	bgeu	a4,s1,9dc <malloc+0x70>
 9a2:	8a4e                	mv	s4,s3
 9a4:	0009871b          	sext.w	a4,s3
 9a8:	6685                	lui	a3,0x1
 9aa:	00d77363          	bgeu	a4,a3,9b0 <malloc+0x44>
 9ae:	6a05                	lui	s4,0x1
 9b0:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 9b4:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9b8:	00000917          	auipc	s2,0x0
 9bc:	1c890913          	addi	s2,s2,456 # b80 <freep>
  if(p == (char*)-1)
 9c0:	5afd                	li	s5,-1
 9c2:	a88d                	j	a34 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 9c4:	00000797          	auipc	a5,0x0
 9c8:	23478793          	addi	a5,a5,564 # bf8 <base>
 9cc:	00000717          	auipc	a4,0x0
 9d0:	1af73a23          	sd	a5,436(a4) # b80 <freep>
 9d4:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 9d6:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 9da:	b7e1                	j	9a2 <malloc+0x36>
      if(p->s.size == nunits)
 9dc:	02e48b63          	beq	s1,a4,a12 <malloc+0xa6>
        p->s.size -= nunits;
 9e0:	4137073b          	subw	a4,a4,s3
 9e4:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9e6:	1702                	slli	a4,a4,0x20
 9e8:	9301                	srli	a4,a4,0x20
 9ea:	0712                	slli	a4,a4,0x4
 9ec:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9ee:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9f2:	00000717          	auipc	a4,0x0
 9f6:	18a73723          	sd	a0,398(a4) # b80 <freep>
      return (void*)(p + 1);
 9fa:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 9fe:	70e2                	ld	ra,56(sp)
 a00:	7442                	ld	s0,48(sp)
 a02:	74a2                	ld	s1,40(sp)
 a04:	7902                	ld	s2,32(sp)
 a06:	69e2                	ld	s3,24(sp)
 a08:	6a42                	ld	s4,16(sp)
 a0a:	6aa2                	ld	s5,8(sp)
 a0c:	6b02                	ld	s6,0(sp)
 a0e:	6121                	addi	sp,sp,64
 a10:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 a12:	6398                	ld	a4,0(a5)
 a14:	e118                	sd	a4,0(a0)
 a16:	bff1                	j	9f2 <malloc+0x86>
  hp->s.size = nu;
 a18:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a1c:	0541                	addi	a0,a0,16
 a1e:	00000097          	auipc	ra,0x0
 a22:	ec6080e7          	jalr	-314(ra) # 8e4 <free>
  return freep;
 a26:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a2a:	d971                	beqz	a0,9fe <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a2c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a2e:	4798                	lw	a4,8(a5)
 a30:	fa9776e3          	bgeu	a4,s1,9dc <malloc+0x70>
    if(p == freep)
 a34:	00093703          	ld	a4,0(s2)
 a38:	853e                	mv	a0,a5
 a3a:	fef719e3          	bne	a4,a5,a2c <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 a3e:	8552                	mv	a0,s4
 a40:	00000097          	auipc	ra,0x0
 a44:	b7e080e7          	jalr	-1154(ra) # 5be <sbrk>
  if(p == (char*)-1)
 a48:	fd5518e3          	bne	a0,s5,a18 <malloc+0xac>
        return 0;
 a4c:	4501                	li	a0,0
 a4e:	bf45                	j	9fe <malloc+0x92>

0000000000000a50 <setjmp>:
 a50:	e100                	sd	s0,0(a0)
 a52:	e504                	sd	s1,8(a0)
 a54:	01253823          	sd	s2,16(a0)
 a58:	01353c23          	sd	s3,24(a0)
 a5c:	03453023          	sd	s4,32(a0)
 a60:	03553423          	sd	s5,40(a0)
 a64:	03653823          	sd	s6,48(a0)
 a68:	03753c23          	sd	s7,56(a0)
 a6c:	05853023          	sd	s8,64(a0)
 a70:	05953423          	sd	s9,72(a0)
 a74:	05a53823          	sd	s10,80(a0)
 a78:	05b53c23          	sd	s11,88(a0)
 a7c:	06153023          	sd	ra,96(a0)
 a80:	06253423          	sd	sp,104(a0)
 a84:	4501                	li	a0,0
 a86:	8082                	ret

0000000000000a88 <longjmp>:
 a88:	6100                	ld	s0,0(a0)
 a8a:	6504                	ld	s1,8(a0)
 a8c:	01053903          	ld	s2,16(a0)
 a90:	01853983          	ld	s3,24(a0)
 a94:	02053a03          	ld	s4,32(a0)
 a98:	02853a83          	ld	s5,40(a0)
 a9c:	03053b03          	ld	s6,48(a0)
 aa0:	03853b83          	ld	s7,56(a0)
 aa4:	04053c03          	ld	s8,64(a0)
 aa8:	04853c83          	ld	s9,72(a0)
 aac:	05053d03          	ld	s10,80(a0)
 ab0:	05853d83          	ld	s11,88(a0)
 ab4:	06053083          	ld	ra,96(a0)
 ab8:	06853103          	ld	sp,104(a0)
 abc:	c199                	beqz	a1,ac2 <longjmp_1>
 abe:	852e                	mv	a0,a1
 ac0:	8082                	ret

0000000000000ac2 <longjmp_1>:
 ac2:	4505                	li	a0,1
 ac4:	8082                	ret
