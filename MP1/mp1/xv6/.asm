
user/_mp1-part2-2:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <f1>:

static struct thread *t;
static int cnt = 0;

void f1(void *arg)
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
    printf("%s 1: %d\n", (cnt == 0)? "thread" : "task", cnt);
   8:	00001617          	auipc	a2,0x1
   c:	cd062603          	lw	a2,-816(a2) # cd8 <cnt>
  10:	00001597          	auipc	a1,0x1
  14:	c6858593          	addi	a1,a1,-920 # c78 <thread_assign_task+0x9a>
  18:	c609                	beqz	a2,22 <f1+0x22>
  1a:	00001597          	auipc	a1,0x1
  1e:	c6658593          	addi	a1,a1,-922 # c80 <thread_assign_task+0xa2>
  22:	00001517          	auipc	a0,0x1
  26:	c6650513          	addi	a0,a0,-922 # c88 <thread_assign_task+0xaa>
  2a:	00000097          	auipc	ra,0x0
  2e:	696080e7          	jalr	1686(ra) # 6c0 <printf>
    cnt++;
  32:	00001717          	auipc	a4,0x1
  36:	ca670713          	addi	a4,a4,-858 # cd8 <cnt>
  3a:	431c                	lw	a5,0(a4)
  3c:	2785                	addiw	a5,a5,1
  3e:	0007869b          	sext.w	a3,a5
  42:	c31c                	sw	a5,0(a4)

    if (cnt < 10){
  44:	47a5                	li	a5,9
  46:	00d7da63          	bge	a5,a3,5a <f1+0x5a>
        thread_assign_task(t, f1, NULL);
    }

    thread_yield();
  4a:	00001097          	auipc	ra,0x1
  4e:	b0c080e7          	jalr	-1268(ra) # b56 <thread_yield>
}
  52:	60a2                	ld	ra,8(sp)
  54:	6402                	ld	s0,0(sp)
  56:	0141                	addi	sp,sp,16
  58:	8082                	ret
        thread_assign_task(t, f1, NULL);
  5a:	4601                	li	a2,0
  5c:	00000597          	auipc	a1,0x0
  60:	fa458593          	addi	a1,a1,-92 # 0 <f1>
  64:	00001517          	auipc	a0,0x1
  68:	c7c53503          	ld	a0,-900(a0) # ce0 <t>
  6c:	00001097          	auipc	ra,0x1
  70:	b72080e7          	jalr	-1166(ra) # bde <thread_assign_task>
  74:	bfd9                	j	4a <f1+0x4a>

0000000000000076 <main>:

int main(int argc, char **argv)
{
  76:	1141                	addi	sp,sp,-16
  78:	e406                	sd	ra,8(sp)
  7a:	e022                	sd	s0,0(sp)
  7c:	0800                	addi	s0,sp,16
    printf("mp1-part2-2\n");
  7e:	00001517          	auipc	a0,0x1
  82:	c1a50513          	addi	a0,a0,-998 # c98 <thread_assign_task+0xba>
  86:	00000097          	auipc	ra,0x0
  8a:	63a080e7          	jalr	1594(ra) # 6c0 <printf>
    t = thread_create(f1, NULL);
  8e:	4581                	li	a1,0
  90:	00000517          	auipc	a0,0x0
  94:	f7050513          	addi	a0,a0,-144 # 0 <f1>
  98:	00001097          	auipc	ra,0x1
  9c:	840080e7          	jalr	-1984(ra) # 8d8 <thread_create>
  a0:	00001797          	auipc	a5,0x1
  a4:	c4a7b023          	sd	a0,-960(a5) # ce0 <t>
    thread_add_runqueue(t);
  a8:	00001097          	auipc	ra,0x1
  ac:	898080e7          	jalr	-1896(ra) # 940 <thread_add_runqueue>
    thread_start_threading();
  b0:	00001097          	auipc	ra,0x1
  b4:	b02080e7          	jalr	-1278(ra) # bb2 <thread_start_threading>
    printf("\nexited\n");
  b8:	00001517          	auipc	a0,0x1
  bc:	bf050513          	addi	a0,a0,-1040 # ca8 <thread_assign_task+0xca>
  c0:	00000097          	auipc	ra,0x0
  c4:	600080e7          	jalr	1536(ra) # 6c0 <printf>
    exit(0);
  c8:	4501                	li	a0,0
  ca:	00000097          	auipc	ra,0x0
  ce:	27e080e7          	jalr	638(ra) # 348 <exit>

00000000000000d2 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
  d2:	1141                	addi	sp,sp,-16
  d4:	e422                	sd	s0,8(sp)
  d6:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  d8:	87aa                	mv	a5,a0
  da:	0585                	addi	a1,a1,1
  dc:	0785                	addi	a5,a5,1
  de:	fff5c703          	lbu	a4,-1(a1)
  e2:	fee78fa3          	sb	a4,-1(a5)
  e6:	fb75                	bnez	a4,da <strcpy+0x8>
    ;
  return os;
}
  e8:	6422                	ld	s0,8(sp)
  ea:	0141                	addi	sp,sp,16
  ec:	8082                	ret

00000000000000ee <strcmp>:

int
strcmp(const char *p, const char *q)
{
  ee:	1141                	addi	sp,sp,-16
  f0:	e422                	sd	s0,8(sp)
  f2:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  f4:	00054783          	lbu	a5,0(a0)
  f8:	cb91                	beqz	a5,10c <strcmp+0x1e>
  fa:	0005c703          	lbu	a4,0(a1)
  fe:	00f71763          	bne	a4,a5,10c <strcmp+0x1e>
    p++, q++;
 102:	0505                	addi	a0,a0,1
 104:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 106:	00054783          	lbu	a5,0(a0)
 10a:	fbe5                	bnez	a5,fa <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 10c:	0005c503          	lbu	a0,0(a1)
}
 110:	40a7853b          	subw	a0,a5,a0
 114:	6422                	ld	s0,8(sp)
 116:	0141                	addi	sp,sp,16
 118:	8082                	ret

000000000000011a <strlen>:

uint
strlen(const char *s)
{
 11a:	1141                	addi	sp,sp,-16
 11c:	e422                	sd	s0,8(sp)
 11e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 120:	00054783          	lbu	a5,0(a0)
 124:	cf91                	beqz	a5,140 <strlen+0x26>
 126:	0505                	addi	a0,a0,1
 128:	87aa                	mv	a5,a0
 12a:	4685                	li	a3,1
 12c:	9e89                	subw	a3,a3,a0
 12e:	00f6853b          	addw	a0,a3,a5
 132:	0785                	addi	a5,a5,1
 134:	fff7c703          	lbu	a4,-1(a5)
 138:	fb7d                	bnez	a4,12e <strlen+0x14>
    ;
  return n;
}
 13a:	6422                	ld	s0,8(sp)
 13c:	0141                	addi	sp,sp,16
 13e:	8082                	ret
  for(n = 0; s[n]; n++)
 140:	4501                	li	a0,0
 142:	bfe5                	j	13a <strlen+0x20>

0000000000000144 <memset>:

void*
memset(void *dst, int c, uint n)
{
 144:	1141                	addi	sp,sp,-16
 146:	e422                	sd	s0,8(sp)
 148:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 14a:	ce09                	beqz	a2,164 <memset+0x20>
 14c:	87aa                	mv	a5,a0
 14e:	fff6071b          	addiw	a4,a2,-1
 152:	1702                	slli	a4,a4,0x20
 154:	9301                	srli	a4,a4,0x20
 156:	0705                	addi	a4,a4,1
 158:	972a                	add	a4,a4,a0
    cdst[i] = c;
 15a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 15e:	0785                	addi	a5,a5,1
 160:	fee79de3          	bne	a5,a4,15a <memset+0x16>
  }
  return dst;
}
 164:	6422                	ld	s0,8(sp)
 166:	0141                	addi	sp,sp,16
 168:	8082                	ret

000000000000016a <strchr>:

char*
strchr(const char *s, char c)
{
 16a:	1141                	addi	sp,sp,-16
 16c:	e422                	sd	s0,8(sp)
 16e:	0800                	addi	s0,sp,16
  for(; *s; s++)
 170:	00054783          	lbu	a5,0(a0)
 174:	cb99                	beqz	a5,18a <strchr+0x20>
    if(*s == c)
 176:	00f58763          	beq	a1,a5,184 <strchr+0x1a>
  for(; *s; s++)
 17a:	0505                	addi	a0,a0,1
 17c:	00054783          	lbu	a5,0(a0)
 180:	fbfd                	bnez	a5,176 <strchr+0xc>
      return (char*)s;
  return 0;
 182:	4501                	li	a0,0
}
 184:	6422                	ld	s0,8(sp)
 186:	0141                	addi	sp,sp,16
 188:	8082                	ret
  return 0;
 18a:	4501                	li	a0,0
 18c:	bfe5                	j	184 <strchr+0x1a>

000000000000018e <gets>:

char*
gets(char *buf, int max)
{
 18e:	711d                	addi	sp,sp,-96
 190:	ec86                	sd	ra,88(sp)
 192:	e8a2                	sd	s0,80(sp)
 194:	e4a6                	sd	s1,72(sp)
 196:	e0ca                	sd	s2,64(sp)
 198:	fc4e                	sd	s3,56(sp)
 19a:	f852                	sd	s4,48(sp)
 19c:	f456                	sd	s5,40(sp)
 19e:	f05a                	sd	s6,32(sp)
 1a0:	ec5e                	sd	s7,24(sp)
 1a2:	1080                	addi	s0,sp,96
 1a4:	8baa                	mv	s7,a0
 1a6:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1a8:	892a                	mv	s2,a0
 1aa:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1ac:	4aa9                	li	s5,10
 1ae:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1b0:	89a6                	mv	s3,s1
 1b2:	2485                	addiw	s1,s1,1
 1b4:	0344d863          	bge	s1,s4,1e4 <gets+0x56>
    cc = read(0, &c, 1);
 1b8:	4605                	li	a2,1
 1ba:	faf40593          	addi	a1,s0,-81
 1be:	4501                	li	a0,0
 1c0:	00000097          	auipc	ra,0x0
 1c4:	1a0080e7          	jalr	416(ra) # 360 <read>
    if(cc < 1)
 1c8:	00a05e63          	blez	a0,1e4 <gets+0x56>
    buf[i++] = c;
 1cc:	faf44783          	lbu	a5,-81(s0)
 1d0:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1d4:	01578763          	beq	a5,s5,1e2 <gets+0x54>
 1d8:	0905                	addi	s2,s2,1
 1da:	fd679be3          	bne	a5,s6,1b0 <gets+0x22>
  for(i=0; i+1 < max; ){
 1de:	89a6                	mv	s3,s1
 1e0:	a011                	j	1e4 <gets+0x56>
 1e2:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 1e4:	99de                	add	s3,s3,s7
 1e6:	00098023          	sb	zero,0(s3)
  return buf;
}
 1ea:	855e                	mv	a0,s7
 1ec:	60e6                	ld	ra,88(sp)
 1ee:	6446                	ld	s0,80(sp)
 1f0:	64a6                	ld	s1,72(sp)
 1f2:	6906                	ld	s2,64(sp)
 1f4:	79e2                	ld	s3,56(sp)
 1f6:	7a42                	ld	s4,48(sp)
 1f8:	7aa2                	ld	s5,40(sp)
 1fa:	7b02                	ld	s6,32(sp)
 1fc:	6be2                	ld	s7,24(sp)
 1fe:	6125                	addi	sp,sp,96
 200:	8082                	ret

0000000000000202 <stat>:

int
stat(const char *n, struct stat *st)
{
 202:	1101                	addi	sp,sp,-32
 204:	ec06                	sd	ra,24(sp)
 206:	e822                	sd	s0,16(sp)
 208:	e426                	sd	s1,8(sp)
 20a:	e04a                	sd	s2,0(sp)
 20c:	1000                	addi	s0,sp,32
 20e:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 210:	4581                	li	a1,0
 212:	00000097          	auipc	ra,0x0
 216:	176080e7          	jalr	374(ra) # 388 <open>
  if(fd < 0)
 21a:	02054563          	bltz	a0,244 <stat+0x42>
 21e:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 220:	85ca                	mv	a1,s2
 222:	00000097          	auipc	ra,0x0
 226:	17e080e7          	jalr	382(ra) # 3a0 <fstat>
 22a:	892a                	mv	s2,a0
  close(fd);
 22c:	8526                	mv	a0,s1
 22e:	00000097          	auipc	ra,0x0
 232:	142080e7          	jalr	322(ra) # 370 <close>
  return r;
}
 236:	854a                	mv	a0,s2
 238:	60e2                	ld	ra,24(sp)
 23a:	6442                	ld	s0,16(sp)
 23c:	64a2                	ld	s1,8(sp)
 23e:	6902                	ld	s2,0(sp)
 240:	6105                	addi	sp,sp,32
 242:	8082                	ret
    return -1;
 244:	597d                	li	s2,-1
 246:	bfc5                	j	236 <stat+0x34>

0000000000000248 <atoi>:

int
atoi(const char *s)
{
 248:	1141                	addi	sp,sp,-16
 24a:	e422                	sd	s0,8(sp)
 24c:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 24e:	00054603          	lbu	a2,0(a0)
 252:	fd06079b          	addiw	a5,a2,-48
 256:	0ff7f793          	andi	a5,a5,255
 25a:	4725                	li	a4,9
 25c:	02f76963          	bltu	a4,a5,28e <atoi+0x46>
 260:	86aa                	mv	a3,a0
  n = 0;
 262:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 264:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 266:	0685                	addi	a3,a3,1
 268:	0025179b          	slliw	a5,a0,0x2
 26c:	9fa9                	addw	a5,a5,a0
 26e:	0017979b          	slliw	a5,a5,0x1
 272:	9fb1                	addw	a5,a5,a2
 274:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 278:	0006c603          	lbu	a2,0(a3)
 27c:	fd06071b          	addiw	a4,a2,-48
 280:	0ff77713          	andi	a4,a4,255
 284:	fee5f1e3          	bgeu	a1,a4,266 <atoi+0x1e>
  return n;
}
 288:	6422                	ld	s0,8(sp)
 28a:	0141                	addi	sp,sp,16
 28c:	8082                	ret
  n = 0;
 28e:	4501                	li	a0,0
 290:	bfe5                	j	288 <atoi+0x40>

0000000000000292 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 292:	1141                	addi	sp,sp,-16
 294:	e422                	sd	s0,8(sp)
 296:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 298:	02b57663          	bgeu	a0,a1,2c4 <memmove+0x32>
    while(n-- > 0)
 29c:	02c05163          	blez	a2,2be <memmove+0x2c>
 2a0:	fff6079b          	addiw	a5,a2,-1
 2a4:	1782                	slli	a5,a5,0x20
 2a6:	9381                	srli	a5,a5,0x20
 2a8:	0785                	addi	a5,a5,1
 2aa:	97aa                	add	a5,a5,a0
  dst = vdst;
 2ac:	872a                	mv	a4,a0
      *dst++ = *src++;
 2ae:	0585                	addi	a1,a1,1
 2b0:	0705                	addi	a4,a4,1
 2b2:	fff5c683          	lbu	a3,-1(a1)
 2b6:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2ba:	fee79ae3          	bne	a5,a4,2ae <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2be:	6422                	ld	s0,8(sp)
 2c0:	0141                	addi	sp,sp,16
 2c2:	8082                	ret
    dst += n;
 2c4:	00c50733          	add	a4,a0,a2
    src += n;
 2c8:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2ca:	fec05ae3          	blez	a2,2be <memmove+0x2c>
 2ce:	fff6079b          	addiw	a5,a2,-1
 2d2:	1782                	slli	a5,a5,0x20
 2d4:	9381                	srli	a5,a5,0x20
 2d6:	fff7c793          	not	a5,a5
 2da:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2dc:	15fd                	addi	a1,a1,-1
 2de:	177d                	addi	a4,a4,-1
 2e0:	0005c683          	lbu	a3,0(a1)
 2e4:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2e8:	fee79ae3          	bne	a5,a4,2dc <memmove+0x4a>
 2ec:	bfc9                	j	2be <memmove+0x2c>

00000000000002ee <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2ee:	1141                	addi	sp,sp,-16
 2f0:	e422                	sd	s0,8(sp)
 2f2:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2f4:	ca05                	beqz	a2,324 <memcmp+0x36>
 2f6:	fff6069b          	addiw	a3,a2,-1
 2fa:	1682                	slli	a3,a3,0x20
 2fc:	9281                	srli	a3,a3,0x20
 2fe:	0685                	addi	a3,a3,1
 300:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 302:	00054783          	lbu	a5,0(a0)
 306:	0005c703          	lbu	a4,0(a1)
 30a:	00e79863          	bne	a5,a4,31a <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 30e:	0505                	addi	a0,a0,1
    p2++;
 310:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 312:	fed518e3          	bne	a0,a3,302 <memcmp+0x14>
  }
  return 0;
 316:	4501                	li	a0,0
 318:	a019                	j	31e <memcmp+0x30>
      return *p1 - *p2;
 31a:	40e7853b          	subw	a0,a5,a4
}
 31e:	6422                	ld	s0,8(sp)
 320:	0141                	addi	sp,sp,16
 322:	8082                	ret
  return 0;
 324:	4501                	li	a0,0
 326:	bfe5                	j	31e <memcmp+0x30>

0000000000000328 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 328:	1141                	addi	sp,sp,-16
 32a:	e406                	sd	ra,8(sp)
 32c:	e022                	sd	s0,0(sp)
 32e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 330:	00000097          	auipc	ra,0x0
 334:	f62080e7          	jalr	-158(ra) # 292 <memmove>
}
 338:	60a2                	ld	ra,8(sp)
 33a:	6402                	ld	s0,0(sp)
 33c:	0141                	addi	sp,sp,16
 33e:	8082                	ret

0000000000000340 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 340:	4885                	li	a7,1
 ecall
 342:	00000073          	ecall
 ret
 346:	8082                	ret

0000000000000348 <exit>:
.global exit
exit:
 li a7, SYS_exit
 348:	4889                	li	a7,2
 ecall
 34a:	00000073          	ecall
 ret
 34e:	8082                	ret

0000000000000350 <wait>:
.global wait
wait:
 li a7, SYS_wait
 350:	488d                	li	a7,3
 ecall
 352:	00000073          	ecall
 ret
 356:	8082                	ret

0000000000000358 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 358:	4891                	li	a7,4
 ecall
 35a:	00000073          	ecall
 ret
 35e:	8082                	ret

0000000000000360 <read>:
.global read
read:
 li a7, SYS_read
 360:	4895                	li	a7,5
 ecall
 362:	00000073          	ecall
 ret
 366:	8082                	ret

0000000000000368 <write>:
.global write
write:
 li a7, SYS_write
 368:	48c1                	li	a7,16
 ecall
 36a:	00000073          	ecall
 ret
 36e:	8082                	ret

0000000000000370 <close>:
.global close
close:
 li a7, SYS_close
 370:	48d5                	li	a7,21
 ecall
 372:	00000073          	ecall
 ret
 376:	8082                	ret

0000000000000378 <kill>:
.global kill
kill:
 li a7, SYS_kill
 378:	4899                	li	a7,6
 ecall
 37a:	00000073          	ecall
 ret
 37e:	8082                	ret

0000000000000380 <exec>:
.global exec
exec:
 li a7, SYS_exec
 380:	489d                	li	a7,7
 ecall
 382:	00000073          	ecall
 ret
 386:	8082                	ret

0000000000000388 <open>:
.global open
open:
 li a7, SYS_open
 388:	48bd                	li	a7,15
 ecall
 38a:	00000073          	ecall
 ret
 38e:	8082                	ret

0000000000000390 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 390:	48c5                	li	a7,17
 ecall
 392:	00000073          	ecall
 ret
 396:	8082                	ret

0000000000000398 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 398:	48c9                	li	a7,18
 ecall
 39a:	00000073          	ecall
 ret
 39e:	8082                	ret

00000000000003a0 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3a0:	48a1                	li	a7,8
 ecall
 3a2:	00000073          	ecall
 ret
 3a6:	8082                	ret

00000000000003a8 <link>:
.global link
link:
 li a7, SYS_link
 3a8:	48cd                	li	a7,19
 ecall
 3aa:	00000073          	ecall
 ret
 3ae:	8082                	ret

00000000000003b0 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3b0:	48d1                	li	a7,20
 ecall
 3b2:	00000073          	ecall
 ret
 3b6:	8082                	ret

00000000000003b8 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3b8:	48a5                	li	a7,9
 ecall
 3ba:	00000073          	ecall
 ret
 3be:	8082                	ret

00000000000003c0 <dup>:
.global dup
dup:
 li a7, SYS_dup
 3c0:	48a9                	li	a7,10
 ecall
 3c2:	00000073          	ecall
 ret
 3c6:	8082                	ret

00000000000003c8 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3c8:	48ad                	li	a7,11
 ecall
 3ca:	00000073          	ecall
 ret
 3ce:	8082                	ret

00000000000003d0 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 3d0:	48b1                	li	a7,12
 ecall
 3d2:	00000073          	ecall
 ret
 3d6:	8082                	ret

00000000000003d8 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3d8:	48b5                	li	a7,13
 ecall
 3da:	00000073          	ecall
 ret
 3de:	8082                	ret

00000000000003e0 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3e0:	48b9                	li	a7,14
 ecall
 3e2:	00000073          	ecall
 ret
 3e6:	8082                	ret

00000000000003e8 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3e8:	1101                	addi	sp,sp,-32
 3ea:	ec06                	sd	ra,24(sp)
 3ec:	e822                	sd	s0,16(sp)
 3ee:	1000                	addi	s0,sp,32
 3f0:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3f4:	4605                	li	a2,1
 3f6:	fef40593          	addi	a1,s0,-17
 3fa:	00000097          	auipc	ra,0x0
 3fe:	f6e080e7          	jalr	-146(ra) # 368 <write>
}
 402:	60e2                	ld	ra,24(sp)
 404:	6442                	ld	s0,16(sp)
 406:	6105                	addi	sp,sp,32
 408:	8082                	ret

000000000000040a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 40a:	7139                	addi	sp,sp,-64
 40c:	fc06                	sd	ra,56(sp)
 40e:	f822                	sd	s0,48(sp)
 410:	f426                	sd	s1,40(sp)
 412:	f04a                	sd	s2,32(sp)
 414:	ec4e                	sd	s3,24(sp)
 416:	0080                	addi	s0,sp,64
 418:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 41a:	c299                	beqz	a3,420 <printint+0x16>
 41c:	0805c863          	bltz	a1,4ac <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 420:	2581                	sext.w	a1,a1
  neg = 0;
 422:	4881                	li	a7,0
 424:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 428:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 42a:	2601                	sext.w	a2,a2
 42c:	00001517          	auipc	a0,0x1
 430:	89450513          	addi	a0,a0,-1900 # cc0 <digits>
 434:	883a                	mv	a6,a4
 436:	2705                	addiw	a4,a4,1
 438:	02c5f7bb          	remuw	a5,a1,a2
 43c:	1782                	slli	a5,a5,0x20
 43e:	9381                	srli	a5,a5,0x20
 440:	97aa                	add	a5,a5,a0
 442:	0007c783          	lbu	a5,0(a5)
 446:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 44a:	0005879b          	sext.w	a5,a1
 44e:	02c5d5bb          	divuw	a1,a1,a2
 452:	0685                	addi	a3,a3,1
 454:	fec7f0e3          	bgeu	a5,a2,434 <printint+0x2a>
  if(neg)
 458:	00088b63          	beqz	a7,46e <printint+0x64>
    buf[i++] = '-';
 45c:	fd040793          	addi	a5,s0,-48
 460:	973e                	add	a4,a4,a5
 462:	02d00793          	li	a5,45
 466:	fef70823          	sb	a5,-16(a4)
 46a:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 46e:	02e05863          	blez	a4,49e <printint+0x94>
 472:	fc040793          	addi	a5,s0,-64
 476:	00e78933          	add	s2,a5,a4
 47a:	fff78993          	addi	s3,a5,-1
 47e:	99ba                	add	s3,s3,a4
 480:	377d                	addiw	a4,a4,-1
 482:	1702                	slli	a4,a4,0x20
 484:	9301                	srli	a4,a4,0x20
 486:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 48a:	fff94583          	lbu	a1,-1(s2)
 48e:	8526                	mv	a0,s1
 490:	00000097          	auipc	ra,0x0
 494:	f58080e7          	jalr	-168(ra) # 3e8 <putc>
  while(--i >= 0)
 498:	197d                	addi	s2,s2,-1
 49a:	ff3918e3          	bne	s2,s3,48a <printint+0x80>
}
 49e:	70e2                	ld	ra,56(sp)
 4a0:	7442                	ld	s0,48(sp)
 4a2:	74a2                	ld	s1,40(sp)
 4a4:	7902                	ld	s2,32(sp)
 4a6:	69e2                	ld	s3,24(sp)
 4a8:	6121                	addi	sp,sp,64
 4aa:	8082                	ret
    x = -xx;
 4ac:	40b005bb          	negw	a1,a1
    neg = 1;
 4b0:	4885                	li	a7,1
    x = -xx;
 4b2:	bf8d                	j	424 <printint+0x1a>

00000000000004b4 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4b4:	7119                	addi	sp,sp,-128
 4b6:	fc86                	sd	ra,120(sp)
 4b8:	f8a2                	sd	s0,112(sp)
 4ba:	f4a6                	sd	s1,104(sp)
 4bc:	f0ca                	sd	s2,96(sp)
 4be:	ecce                	sd	s3,88(sp)
 4c0:	e8d2                	sd	s4,80(sp)
 4c2:	e4d6                	sd	s5,72(sp)
 4c4:	e0da                	sd	s6,64(sp)
 4c6:	fc5e                	sd	s7,56(sp)
 4c8:	f862                	sd	s8,48(sp)
 4ca:	f466                	sd	s9,40(sp)
 4cc:	f06a                	sd	s10,32(sp)
 4ce:	ec6e                	sd	s11,24(sp)
 4d0:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4d2:	0005c903          	lbu	s2,0(a1)
 4d6:	18090f63          	beqz	s2,674 <vprintf+0x1c0>
 4da:	8aaa                	mv	s5,a0
 4dc:	8b32                	mv	s6,a2
 4de:	00158493          	addi	s1,a1,1
  state = 0;
 4e2:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4e4:	02500a13          	li	s4,37
      if(c == 'd'){
 4e8:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 4ec:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 4f0:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 4f4:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 4f8:	00000b97          	auipc	s7,0x0
 4fc:	7c8b8b93          	addi	s7,s7,1992 # cc0 <digits>
 500:	a839                	j	51e <vprintf+0x6a>
        putc(fd, c);
 502:	85ca                	mv	a1,s2
 504:	8556                	mv	a0,s5
 506:	00000097          	auipc	ra,0x0
 50a:	ee2080e7          	jalr	-286(ra) # 3e8 <putc>
 50e:	a019                	j	514 <vprintf+0x60>
    } else if(state == '%'){
 510:	01498f63          	beq	s3,s4,52e <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 514:	0485                	addi	s1,s1,1
 516:	fff4c903          	lbu	s2,-1(s1)
 51a:	14090d63          	beqz	s2,674 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 51e:	0009079b          	sext.w	a5,s2
    if(state == 0){
 522:	fe0997e3          	bnez	s3,510 <vprintf+0x5c>
      if(c == '%'){
 526:	fd479ee3          	bne	a5,s4,502 <vprintf+0x4e>
        state = '%';
 52a:	89be                	mv	s3,a5
 52c:	b7e5                	j	514 <vprintf+0x60>
      if(c == 'd'){
 52e:	05878063          	beq	a5,s8,56e <vprintf+0xba>
      } else if(c == 'l') {
 532:	05978c63          	beq	a5,s9,58a <vprintf+0xd6>
      } else if(c == 'x') {
 536:	07a78863          	beq	a5,s10,5a6 <vprintf+0xf2>
      } else if(c == 'p') {
 53a:	09b78463          	beq	a5,s11,5c2 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 53e:	07300713          	li	a4,115
 542:	0ce78663          	beq	a5,a4,60e <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 546:	06300713          	li	a4,99
 54a:	0ee78e63          	beq	a5,a4,646 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 54e:	11478863          	beq	a5,s4,65e <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 552:	85d2                	mv	a1,s4
 554:	8556                	mv	a0,s5
 556:	00000097          	auipc	ra,0x0
 55a:	e92080e7          	jalr	-366(ra) # 3e8 <putc>
        putc(fd, c);
 55e:	85ca                	mv	a1,s2
 560:	8556                	mv	a0,s5
 562:	00000097          	auipc	ra,0x0
 566:	e86080e7          	jalr	-378(ra) # 3e8 <putc>
      }
      state = 0;
 56a:	4981                	li	s3,0
 56c:	b765                	j	514 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 56e:	008b0913          	addi	s2,s6,8
 572:	4685                	li	a3,1
 574:	4629                	li	a2,10
 576:	000b2583          	lw	a1,0(s6)
 57a:	8556                	mv	a0,s5
 57c:	00000097          	auipc	ra,0x0
 580:	e8e080e7          	jalr	-370(ra) # 40a <printint>
 584:	8b4a                	mv	s6,s2
      state = 0;
 586:	4981                	li	s3,0
 588:	b771                	j	514 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 58a:	008b0913          	addi	s2,s6,8
 58e:	4681                	li	a3,0
 590:	4629                	li	a2,10
 592:	000b2583          	lw	a1,0(s6)
 596:	8556                	mv	a0,s5
 598:	00000097          	auipc	ra,0x0
 59c:	e72080e7          	jalr	-398(ra) # 40a <printint>
 5a0:	8b4a                	mv	s6,s2
      state = 0;
 5a2:	4981                	li	s3,0
 5a4:	bf85                	j	514 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 5a6:	008b0913          	addi	s2,s6,8
 5aa:	4681                	li	a3,0
 5ac:	4641                	li	a2,16
 5ae:	000b2583          	lw	a1,0(s6)
 5b2:	8556                	mv	a0,s5
 5b4:	00000097          	auipc	ra,0x0
 5b8:	e56080e7          	jalr	-426(ra) # 40a <printint>
 5bc:	8b4a                	mv	s6,s2
      state = 0;
 5be:	4981                	li	s3,0
 5c0:	bf91                	j	514 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 5c2:	008b0793          	addi	a5,s6,8
 5c6:	f8f43423          	sd	a5,-120(s0)
 5ca:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 5ce:	03000593          	li	a1,48
 5d2:	8556                	mv	a0,s5
 5d4:	00000097          	auipc	ra,0x0
 5d8:	e14080e7          	jalr	-492(ra) # 3e8 <putc>
  putc(fd, 'x');
 5dc:	85ea                	mv	a1,s10
 5de:	8556                	mv	a0,s5
 5e0:	00000097          	auipc	ra,0x0
 5e4:	e08080e7          	jalr	-504(ra) # 3e8 <putc>
 5e8:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5ea:	03c9d793          	srli	a5,s3,0x3c
 5ee:	97de                	add	a5,a5,s7
 5f0:	0007c583          	lbu	a1,0(a5)
 5f4:	8556                	mv	a0,s5
 5f6:	00000097          	auipc	ra,0x0
 5fa:	df2080e7          	jalr	-526(ra) # 3e8 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5fe:	0992                	slli	s3,s3,0x4
 600:	397d                	addiw	s2,s2,-1
 602:	fe0914e3          	bnez	s2,5ea <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 606:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 60a:	4981                	li	s3,0
 60c:	b721                	j	514 <vprintf+0x60>
        s = va_arg(ap, char*);
 60e:	008b0993          	addi	s3,s6,8
 612:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 616:	02090163          	beqz	s2,638 <vprintf+0x184>
        while(*s != 0){
 61a:	00094583          	lbu	a1,0(s2)
 61e:	c9a1                	beqz	a1,66e <vprintf+0x1ba>
          putc(fd, *s);
 620:	8556                	mv	a0,s5
 622:	00000097          	auipc	ra,0x0
 626:	dc6080e7          	jalr	-570(ra) # 3e8 <putc>
          s++;
 62a:	0905                	addi	s2,s2,1
        while(*s != 0){
 62c:	00094583          	lbu	a1,0(s2)
 630:	f9e5                	bnez	a1,620 <vprintf+0x16c>
        s = va_arg(ap, char*);
 632:	8b4e                	mv	s6,s3
      state = 0;
 634:	4981                	li	s3,0
 636:	bdf9                	j	514 <vprintf+0x60>
          s = "(null)";
 638:	00000917          	auipc	s2,0x0
 63c:	68090913          	addi	s2,s2,1664 # cb8 <thread_assign_task+0xda>
        while(*s != 0){
 640:	02800593          	li	a1,40
 644:	bff1                	j	620 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 646:	008b0913          	addi	s2,s6,8
 64a:	000b4583          	lbu	a1,0(s6)
 64e:	8556                	mv	a0,s5
 650:	00000097          	auipc	ra,0x0
 654:	d98080e7          	jalr	-616(ra) # 3e8 <putc>
 658:	8b4a                	mv	s6,s2
      state = 0;
 65a:	4981                	li	s3,0
 65c:	bd65                	j	514 <vprintf+0x60>
        putc(fd, c);
 65e:	85d2                	mv	a1,s4
 660:	8556                	mv	a0,s5
 662:	00000097          	auipc	ra,0x0
 666:	d86080e7          	jalr	-634(ra) # 3e8 <putc>
      state = 0;
 66a:	4981                	li	s3,0
 66c:	b565                	j	514 <vprintf+0x60>
        s = va_arg(ap, char*);
 66e:	8b4e                	mv	s6,s3
      state = 0;
 670:	4981                	li	s3,0
 672:	b54d                	j	514 <vprintf+0x60>
    }
  }
}
 674:	70e6                	ld	ra,120(sp)
 676:	7446                	ld	s0,112(sp)
 678:	74a6                	ld	s1,104(sp)
 67a:	7906                	ld	s2,96(sp)
 67c:	69e6                	ld	s3,88(sp)
 67e:	6a46                	ld	s4,80(sp)
 680:	6aa6                	ld	s5,72(sp)
 682:	6b06                	ld	s6,64(sp)
 684:	7be2                	ld	s7,56(sp)
 686:	7c42                	ld	s8,48(sp)
 688:	7ca2                	ld	s9,40(sp)
 68a:	7d02                	ld	s10,32(sp)
 68c:	6de2                	ld	s11,24(sp)
 68e:	6109                	addi	sp,sp,128
 690:	8082                	ret

0000000000000692 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 692:	715d                	addi	sp,sp,-80
 694:	ec06                	sd	ra,24(sp)
 696:	e822                	sd	s0,16(sp)
 698:	1000                	addi	s0,sp,32
 69a:	e010                	sd	a2,0(s0)
 69c:	e414                	sd	a3,8(s0)
 69e:	e818                	sd	a4,16(s0)
 6a0:	ec1c                	sd	a5,24(s0)
 6a2:	03043023          	sd	a6,32(s0)
 6a6:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6aa:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6ae:	8622                	mv	a2,s0
 6b0:	00000097          	auipc	ra,0x0
 6b4:	e04080e7          	jalr	-508(ra) # 4b4 <vprintf>
}
 6b8:	60e2                	ld	ra,24(sp)
 6ba:	6442                	ld	s0,16(sp)
 6bc:	6161                	addi	sp,sp,80
 6be:	8082                	ret

00000000000006c0 <printf>:

void
printf(const char *fmt, ...)
{
 6c0:	711d                	addi	sp,sp,-96
 6c2:	ec06                	sd	ra,24(sp)
 6c4:	e822                	sd	s0,16(sp)
 6c6:	1000                	addi	s0,sp,32
 6c8:	e40c                	sd	a1,8(s0)
 6ca:	e810                	sd	a2,16(s0)
 6cc:	ec14                	sd	a3,24(s0)
 6ce:	f018                	sd	a4,32(s0)
 6d0:	f41c                	sd	a5,40(s0)
 6d2:	03043823          	sd	a6,48(s0)
 6d6:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6da:	00840613          	addi	a2,s0,8
 6de:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6e2:	85aa                	mv	a1,a0
 6e4:	4505                	li	a0,1
 6e6:	00000097          	auipc	ra,0x0
 6ea:	dce080e7          	jalr	-562(ra) # 4b4 <vprintf>
}
 6ee:	60e2                	ld	ra,24(sp)
 6f0:	6442                	ld	s0,16(sp)
 6f2:	6125                	addi	sp,sp,96
 6f4:	8082                	ret

00000000000006f6 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6f6:	1141                	addi	sp,sp,-16
 6f8:	e422                	sd	s0,8(sp)
 6fa:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6fc:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 700:	00000797          	auipc	a5,0x0
 704:	5e87b783          	ld	a5,1512(a5) # ce8 <freep>
 708:	a805                	j	738 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 70a:	4618                	lw	a4,8(a2)
 70c:	9db9                	addw	a1,a1,a4
 70e:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 712:	6398                	ld	a4,0(a5)
 714:	6318                	ld	a4,0(a4)
 716:	fee53823          	sd	a4,-16(a0)
 71a:	a091                	j	75e <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 71c:	ff852703          	lw	a4,-8(a0)
 720:	9e39                	addw	a2,a2,a4
 722:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 724:	ff053703          	ld	a4,-16(a0)
 728:	e398                	sd	a4,0(a5)
 72a:	a099                	j	770 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 72c:	6398                	ld	a4,0(a5)
 72e:	00e7e463          	bltu	a5,a4,736 <free+0x40>
 732:	00e6ea63          	bltu	a3,a4,746 <free+0x50>
{
 736:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 738:	fed7fae3          	bgeu	a5,a3,72c <free+0x36>
 73c:	6398                	ld	a4,0(a5)
 73e:	00e6e463          	bltu	a3,a4,746 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 742:	fee7eae3          	bltu	a5,a4,736 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 746:	ff852583          	lw	a1,-8(a0)
 74a:	6390                	ld	a2,0(a5)
 74c:	02059713          	slli	a4,a1,0x20
 750:	9301                	srli	a4,a4,0x20
 752:	0712                	slli	a4,a4,0x4
 754:	9736                	add	a4,a4,a3
 756:	fae60ae3          	beq	a2,a4,70a <free+0x14>
    bp->s.ptr = p->s.ptr;
 75a:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 75e:	4790                	lw	a2,8(a5)
 760:	02061713          	slli	a4,a2,0x20
 764:	9301                	srli	a4,a4,0x20
 766:	0712                	slli	a4,a4,0x4
 768:	973e                	add	a4,a4,a5
 76a:	fae689e3          	beq	a3,a4,71c <free+0x26>
  } else
    p->s.ptr = bp;
 76e:	e394                	sd	a3,0(a5)
  freep = p;
 770:	00000717          	auipc	a4,0x0
 774:	56f73c23          	sd	a5,1400(a4) # ce8 <freep>
}
 778:	6422                	ld	s0,8(sp)
 77a:	0141                	addi	sp,sp,16
 77c:	8082                	ret

000000000000077e <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 77e:	7139                	addi	sp,sp,-64
 780:	fc06                	sd	ra,56(sp)
 782:	f822                	sd	s0,48(sp)
 784:	f426                	sd	s1,40(sp)
 786:	f04a                	sd	s2,32(sp)
 788:	ec4e                	sd	s3,24(sp)
 78a:	e852                	sd	s4,16(sp)
 78c:	e456                	sd	s5,8(sp)
 78e:	e05a                	sd	s6,0(sp)
 790:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 792:	02051493          	slli	s1,a0,0x20
 796:	9081                	srli	s1,s1,0x20
 798:	04bd                	addi	s1,s1,15
 79a:	8091                	srli	s1,s1,0x4
 79c:	0014899b          	addiw	s3,s1,1
 7a0:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 7a2:	00000517          	auipc	a0,0x0
 7a6:	54653503          	ld	a0,1350(a0) # ce8 <freep>
 7aa:	c515                	beqz	a0,7d6 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7ac:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7ae:	4798                	lw	a4,8(a5)
 7b0:	02977f63          	bgeu	a4,s1,7ee <malloc+0x70>
 7b4:	8a4e                	mv	s4,s3
 7b6:	0009871b          	sext.w	a4,s3
 7ba:	6685                	lui	a3,0x1
 7bc:	00d77363          	bgeu	a4,a3,7c2 <malloc+0x44>
 7c0:	6a05                	lui	s4,0x1
 7c2:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7c6:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7ca:	00000917          	auipc	s2,0x0
 7ce:	51e90913          	addi	s2,s2,1310 # ce8 <freep>
  if(p == (char*)-1)
 7d2:	5afd                	li	s5,-1
 7d4:	a88d                	j	846 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 7d6:	00000797          	auipc	a5,0x0
 7da:	52278793          	addi	a5,a5,1314 # cf8 <base>
 7de:	00000717          	auipc	a4,0x0
 7e2:	50f73523          	sd	a5,1290(a4) # ce8 <freep>
 7e6:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7e8:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7ec:	b7e1                	j	7b4 <malloc+0x36>
      if(p->s.size == nunits)
 7ee:	02e48b63          	beq	s1,a4,824 <malloc+0xa6>
        p->s.size -= nunits;
 7f2:	4137073b          	subw	a4,a4,s3
 7f6:	c798                	sw	a4,8(a5)
        p += p->s.size;
 7f8:	1702                	slli	a4,a4,0x20
 7fa:	9301                	srli	a4,a4,0x20
 7fc:	0712                	slli	a4,a4,0x4
 7fe:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 800:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 804:	00000717          	auipc	a4,0x0
 808:	4ea73223          	sd	a0,1252(a4) # ce8 <freep>
      return (void*)(p + 1);
 80c:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 810:	70e2                	ld	ra,56(sp)
 812:	7442                	ld	s0,48(sp)
 814:	74a2                	ld	s1,40(sp)
 816:	7902                	ld	s2,32(sp)
 818:	69e2                	ld	s3,24(sp)
 81a:	6a42                	ld	s4,16(sp)
 81c:	6aa2                	ld	s5,8(sp)
 81e:	6b02                	ld	s6,0(sp)
 820:	6121                	addi	sp,sp,64
 822:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 824:	6398                	ld	a4,0(a5)
 826:	e118                	sd	a4,0(a0)
 828:	bff1                	j	804 <malloc+0x86>
  hp->s.size = nu;
 82a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 82e:	0541                	addi	a0,a0,16
 830:	00000097          	auipc	ra,0x0
 834:	ec6080e7          	jalr	-314(ra) # 6f6 <free>
  return freep;
 838:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 83c:	d971                	beqz	a0,810 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 83e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 840:	4798                	lw	a4,8(a5)
 842:	fa9776e3          	bgeu	a4,s1,7ee <malloc+0x70>
    if(p == freep)
 846:	00093703          	ld	a4,0(s2)
 84a:	853e                	mv	a0,a5
 84c:	fef719e3          	bne	a4,a5,83e <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 850:	8552                	mv	a0,s4
 852:	00000097          	auipc	ra,0x0
 856:	b7e080e7          	jalr	-1154(ra) # 3d0 <sbrk>
  if(p == (char*)-1)
 85a:	fd5518e3          	bne	a0,s5,82a <malloc+0xac>
        return 0;
 85e:	4501                	li	a0,0
 860:	bf45                	j	810 <malloc+0x92>

0000000000000862 <setjmp>:
 862:	e100                	sd	s0,0(a0)
 864:	e504                	sd	s1,8(a0)
 866:	01253823          	sd	s2,16(a0)
 86a:	01353c23          	sd	s3,24(a0)
 86e:	03453023          	sd	s4,32(a0)
 872:	03553423          	sd	s5,40(a0)
 876:	03653823          	sd	s6,48(a0)
 87a:	03753c23          	sd	s7,56(a0)
 87e:	05853023          	sd	s8,64(a0)
 882:	05953423          	sd	s9,72(a0)
 886:	05a53823          	sd	s10,80(a0)
 88a:	05b53c23          	sd	s11,88(a0)
 88e:	06153023          	sd	ra,96(a0)
 892:	06253423          	sd	sp,104(a0)
 896:	4501                	li	a0,0
 898:	8082                	ret

000000000000089a <longjmp>:
 89a:	6100                	ld	s0,0(a0)
 89c:	6504                	ld	s1,8(a0)
 89e:	01053903          	ld	s2,16(a0)
 8a2:	01853983          	ld	s3,24(a0)
 8a6:	02053a03          	ld	s4,32(a0)
 8aa:	02853a83          	ld	s5,40(a0)
 8ae:	03053b03          	ld	s6,48(a0)
 8b2:	03853b83          	ld	s7,56(a0)
 8b6:	04053c03          	ld	s8,64(a0)
 8ba:	04853c83          	ld	s9,72(a0)
 8be:	05053d03          	ld	s10,80(a0)
 8c2:	05853d83          	ld	s11,88(a0)
 8c6:	06053083          	ld	ra,96(a0)
 8ca:	06853103          	ld	sp,104(a0)
 8ce:	c199                	beqz	a1,8d4 <longjmp_1>
 8d0:	852e                	mv	a0,a1
 8d2:	8082                	ret

00000000000008d4 <longjmp_1>:
 8d4:	4505                	li	a0,1
 8d6:	8082                	ret

00000000000008d8 <thread_create>:
static struct thread* current_thread = NULL;
static int id = 1;
static jmp_buf env_st;
// static jmp_buf env_tmp;

struct thread *thread_create(void (*f)(void *), void *arg){
 8d8:	7179                	addi	sp,sp,-48
 8da:	f406                	sd	ra,40(sp)
 8dc:	f022                	sd	s0,32(sp)
 8de:	ec26                	sd	s1,24(sp)
 8e0:	e84a                	sd	s2,16(sp)
 8e2:	e44e                	sd	s3,8(sp)
 8e4:	1800                	addi	s0,sp,48
 8e6:	89aa                	mv	s3,a0
 8e8:	892e                	mv	s2,a1
    //fprintf(2, "thread_create\n");
    struct thread *t = (struct thread*) malloc(sizeof(struct thread));
 8ea:	0b000513          	li	a0,176
 8ee:	00000097          	auipc	ra,0x0
 8f2:	e90080e7          	jalr	-368(ra) # 77e <malloc>
 8f6:	84aa                	mv	s1,a0
    unsigned long new_stack_p;
    unsigned long new_stack;
    new_stack = (unsigned long) malloc(sizeof(unsigned long)*0x100);
 8f8:	6505                	lui	a0,0x1
 8fa:	80050513          	addi	a0,a0,-2048 # 800 <malloc+0x82>
 8fe:	00000097          	auipc	ra,0x0
 902:	e80080e7          	jalr	-384(ra) # 77e <malloc>
    new_stack_p = new_stack +0x100*8-0x2*8;
    t->fp = f;
 906:	0134b023          	sd	s3,0(s1)
    t->arg = arg;
 90a:	0124b423          	sd	s2,8(s1)
    t->ID  = id;
 90e:	00000717          	auipc	a4,0x0
 912:	3c670713          	addi	a4,a4,966 # cd4 <id>
 916:	431c                	lw	a5,0(a4)
 918:	08f4aa23          	sw	a5,148(s1)
    t->buf_set = 0;
 91c:	0804a823          	sw	zero,144(s1)
    t->stack = (void*) new_stack;
 920:	e888                	sd	a0,16(s1)
    new_stack_p = new_stack +0x100*8-0x2*8;
 922:	7f050513          	addi	a0,a0,2032
    t->stack_p = (void*) new_stack_p;
 926:	ec88                	sd	a0,24(s1)
    t->top = NULL;
 928:	0a04b423          	sd	zero,168(s1)
    id++;
 92c:	2785                	addiw	a5,a5,1
 92e:	c31c                	sw	a5,0(a4)
    return t;
}
 930:	8526                	mv	a0,s1
 932:	70a2                	ld	ra,40(sp)
 934:	7402                	ld	s0,32(sp)
 936:	64e2                	ld	s1,24(sp)
 938:	6942                	ld	s2,16(sp)
 93a:	69a2                	ld	s3,8(sp)
 93c:	6145                	addi	sp,sp,48
 93e:	8082                	ret

0000000000000940 <thread_add_runqueue>:
void thread_add_runqueue(struct thread *t){
 940:	1141                	addi	sp,sp,-16
 942:	e422                	sd	s0,8(sp)
 944:	0800                	addi	s0,sp,16
    //fprintf(2, "thread_add_runqueue\n");
    if(current_thread == NULL){
 946:	00000797          	auipc	a5,0x0
 94a:	3aa7b783          	ld	a5,938(a5) # cf0 <current_thread>
 94e:	cb89                	beqz	a5,960 <thread_add_runqueue+0x20>
        current_thread = t;
        current_thread->previous = current_thread->next = current_thread;
    }
    else{
        t->previous = current_thread->previous;
 950:	6fd8                	ld	a4,152(a5)
 952:	ed58                	sd	a4,152(a0)
        (current_thread->previous)->next = t;
 954:	f348                	sd	a0,160(a4)
        t->next = current_thread;
 956:	f15c                	sd	a5,160(a0)
        current_thread->previous = t;
 958:	efc8                	sd	a0,152(a5)
    }
}
 95a:	6422                	ld	s0,8(sp)
 95c:	0141                	addi	sp,sp,16
 95e:	8082                	ret
        current_thread = t;
 960:	00000797          	auipc	a5,0x0
 964:	38a7b823          	sd	a0,912(a5) # cf0 <current_thread>
        current_thread->previous = current_thread->next = current_thread;
 968:	f148                	sd	a0,160(a0)
 96a:	ed48                	sd	a0,152(a0)
 96c:	b7fd                	j	95a <thread_add_runqueue+0x1a>

000000000000096e <task_exit>:
            schedule();
            dispatch();
        }
    }
}
void task_exit(){
 96e:	1101                	addi	sp,sp,-32
 970:	ec06                	sd	ra,24(sp)
 972:	e822                	sd	s0,16(sp)
 974:	e426                	sd	s1,8(sp)
 976:	1000                	addi	s0,sp,32
    //fprintf(2, "task_exit\n");
    struct task *tsk = current_thread->top;
 978:	00000797          	auipc	a5,0x0
 97c:	3787b783          	ld	a5,888(a5) # cf0 <current_thread>
 980:	77c4                	ld	s1,168(a5)
    current_thread->top = tsk->prev;
 982:	6cd8                	ld	a4,152(s1)
 984:	f7d8                	sd	a4,168(a5)
    free(tsk->stack);
 986:	6888                	ld	a0,16(s1)
 988:	00000097          	auipc	ra,0x0
 98c:	d6e080e7          	jalr	-658(ra) # 6f6 <free>
    free(tsk);
 990:	8526                	mv	a0,s1
 992:	00000097          	auipc	ra,0x0
 996:	d64080e7          	jalr	-668(ra) # 6f6 <free>
}
 99a:	60e2                	ld	ra,24(sp)
 99c:	6442                	ld	s0,16(sp)
 99e:	64a2                	ld	s1,8(sp)
 9a0:	6105                	addi	sp,sp,32
 9a2:	8082                	ret

00000000000009a4 <schedule>:
        thread_exit();
    }
    else
        longjmp(current_thread->env, 1);
}
void schedule(void){
 9a4:	1141                	addi	sp,sp,-16
 9a6:	e422                	sd	s0,8(sp)
 9a8:	0800                	addi	s0,sp,16
    //fprintf(2, "schedule\n");
    current_thread = current_thread->next;
 9aa:	00000797          	auipc	a5,0x0
 9ae:	34678793          	addi	a5,a5,838 # cf0 <current_thread>
 9b2:	6398                	ld	a4,0(a5)
 9b4:	7358                	ld	a4,160(a4)
 9b6:	e398                	sd	a4,0(a5)
}
 9b8:	6422                	ld	s0,8(sp)
 9ba:	0141                	addi	sp,sp,16
 9bc:	8082                	ret

00000000000009be <thread_exit>:
void thread_exit(void){
 9be:	1101                	addi	sp,sp,-32
 9c0:	ec06                	sd	ra,24(sp)
 9c2:	e822                	sd	s0,16(sp)
 9c4:	e426                	sd	s1,8(sp)
 9c6:	e04a                	sd	s2,0(sp)
 9c8:	1000                	addi	s0,sp,32
    //fprintf(2, "thread_exit\n");
    if(current_thread->next != current_thread){
 9ca:	00000917          	auipc	s2,0x0
 9ce:	32693903          	ld	s2,806(s2) # cf0 <current_thread>
 9d2:	0a093783          	ld	a5,160(s2)
 9d6:	04f90b63          	beq	s2,a5,a2c <thread_exit+0x6e>
        // TODO
        (current_thread->previous)->next = current_thread->next;
 9da:	09893703          	ld	a4,152(s2)
 9de:	f35c                	sd	a5,160(a4)
        (current_thread->next)->previous = current_thread->previous;
 9e0:	09893703          	ld	a4,152(s2)
 9e4:	efd8                	sd	a4,152(a5)
        struct thread *tmp = current_thread;
        schedule();
 9e6:	00000097          	auipc	ra,0x0
 9ea:	fbe080e7          	jalr	-66(ra) # 9a4 <schedule>
        struct task *tsk = tmp->top;
 9ee:	0a893483          	ld	s1,168(s2)
        while (tsk != NULL){
 9f2:	c881                	beqz	s1,a02 <thread_exit+0x44>
            struct task *tp = tsk->prev;
 9f4:	8526                	mv	a0,s1
 9f6:	6cc4                	ld	s1,152(s1)
            free(tsk);
 9f8:	00000097          	auipc	ra,0x0
 9fc:	cfe080e7          	jalr	-770(ra) # 6f6 <free>
        while (tsk != NULL){
 a00:	f8f5                	bnez	s1,9f4 <thread_exit+0x36>
            tsk = tp;
        }
        free(tmp->stack);
 a02:	01093503          	ld	a0,16(s2)
 a06:	00000097          	auipc	ra,0x0
 a0a:	cf0080e7          	jalr	-784(ra) # 6f6 <free>
        free(tmp);
 a0e:	854a                	mv	a0,s2
 a10:	00000097          	auipc	ra,0x0
 a14:	ce6080e7          	jalr	-794(ra) # 6f6 <free>
        dispatch();
 a18:	00000097          	auipc	ra,0x0
 a1c:	05a080e7          	jalr	90(ra) # a72 <dispatch>
        }
        free(current_thread->stack);
        free(current_thread);
        longjmp(env_st, 1);
    }
}
 a20:	60e2                	ld	ra,24(sp)
 a22:	6442                	ld	s0,16(sp)
 a24:	64a2                	ld	s1,8(sp)
 a26:	6902                	ld	s2,0(sp)
 a28:	6105                	addi	sp,sp,32
 a2a:	8082                	ret
        struct task *tsk = current_thread->top;
 a2c:	0a893483          	ld	s1,168(s2)
        while (tsk != NULL){
 a30:	c881                	beqz	s1,a40 <thread_exit+0x82>
            struct task *tp = tsk->prev;
 a32:	8526                	mv	a0,s1
 a34:	6cc4                	ld	s1,152(s1)
            free(tsk);
 a36:	00000097          	auipc	ra,0x0
 a3a:	cc0080e7          	jalr	-832(ra) # 6f6 <free>
        while (tsk != NULL){
 a3e:	f8f5                	bnez	s1,a32 <thread_exit+0x74>
        free(current_thread->stack);
 a40:	00000497          	auipc	s1,0x0
 a44:	2b048493          	addi	s1,s1,688 # cf0 <current_thread>
 a48:	609c                	ld	a5,0(s1)
 a4a:	6b88                	ld	a0,16(a5)
 a4c:	00000097          	auipc	ra,0x0
 a50:	caa080e7          	jalr	-854(ra) # 6f6 <free>
        free(current_thread);
 a54:	6088                	ld	a0,0(s1)
 a56:	00000097          	auipc	ra,0x0
 a5a:	ca0080e7          	jalr	-864(ra) # 6f6 <free>
        longjmp(env_st, 1);
 a5e:	4585                	li	a1,1
 a60:	00000517          	auipc	a0,0x0
 a64:	2a850513          	addi	a0,a0,680 # d08 <env_st>
 a68:	00000097          	auipc	ra,0x0
 a6c:	e32080e7          	jalr	-462(ra) # 89a <longjmp>
}
 a70:	bf45                	j	a20 <thread_exit+0x62>

0000000000000a72 <dispatch>:
void dispatch(void){
 a72:	1141                	addi	sp,sp,-16
 a74:	e406                	sd	ra,8(sp)
 a76:	e022                	sd	s0,0(sp)
 a78:	0800                	addi	s0,sp,16
    while (current_thread->top != NULL){
 a7a:	a831                	j	a96 <dispatch+0x24>
            current_thread->top->fp(current_thread->top->arg);
 a7c:	00000797          	auipc	a5,0x0
 a80:	27478793          	addi	a5,a5,628 # cf0 <current_thread>
 a84:	639c                	ld	a5,0(a5)
 a86:	77dc                	ld	a5,168(a5)
 a88:	6398                	ld	a4,0(a5)
 a8a:	6788                	ld	a0,8(a5)
 a8c:	9702                	jalr	a4
            task_exit();
 a8e:	00000097          	auipc	ra,0x0
 a92:	ee0080e7          	jalr	-288(ra) # 96e <task_exit>
    while (current_thread->top != NULL){
 a96:	00000797          	auipc	a5,0x0
 a9a:	25a78793          	addi	a5,a5,602 # cf0 <current_thread>
 a9e:	6388                	ld	a0,0(a5)
 aa0:	755c                	ld	a5,168(a0)
 aa2:	cba1                	beqz	a5,af2 <dispatch+0x80>
        if (current_thread->top->buf_set == 0){
 aa4:	0907a703          	lw	a4,144(a5)
 aa8:	ef0d                	bnez	a4,ae2 <dispatch+0x70>
            current_thread->top->buf_set = 1;
 aaa:	4705                	li	a4,1
 aac:	08e7a823          	sw	a4,144(a5)
            if (setjmp(current_thread->top->env) == 0){
 ab0:	7548                	ld	a0,168(a0)
 ab2:	02050513          	addi	a0,a0,32
 ab6:	00000097          	auipc	ra,0x0
 aba:	dac080e7          	jalr	-596(ra) # 862 <setjmp>
 abe:	fd5d                	bnez	a0,a7c <dispatch+0xa>
                current_thread->top->env->sp = (unsigned long)current_thread->top->stack_p;
 ac0:	00000797          	auipc	a5,0x0
 ac4:	23078793          	addi	a5,a5,560 # cf0 <current_thread>
 ac8:	639c                	ld	a5,0(a5)
 aca:	77d8                	ld	a4,168(a5)
 acc:	6f14                	ld	a3,24(a4)
 ace:	e754                	sd	a3,136(a4)
                longjmp(current_thread->top->env, 1);
 ad0:	77c8                	ld	a0,168(a5)
 ad2:	4585                	li	a1,1
 ad4:	02050513          	addi	a0,a0,32
 ad8:	00000097          	auipc	ra,0x0
 adc:	dc2080e7          	jalr	-574(ra) # 89a <longjmp>
 ae0:	bf71                	j	a7c <dispatch+0xa>
            longjmp(current_thread->top->env, 1);
 ae2:	4585                	li	a1,1
 ae4:	02078513          	addi	a0,a5,32
 ae8:	00000097          	auipc	ra,0x0
 aec:	db2080e7          	jalr	-590(ra) # 89a <longjmp>
 af0:	b75d                	j	a96 <dispatch+0x24>
    if (current_thread->buf_set == 0){
 af2:	09052783          	lw	a5,144(a0)
 af6:	eba1                	bnez	a5,b46 <dispatch+0xd4>
        current_thread->buf_set = 1;
 af8:	4785                	li	a5,1
 afa:	08f52823          	sw	a5,144(a0)
        if (setjmp(current_thread->env) == 0){
 afe:	02050513          	addi	a0,a0,32
 b02:	00000097          	auipc	ra,0x0
 b06:	d60080e7          	jalr	-672(ra) # 862 <setjmp>
 b0a:	c105                	beqz	a0,b2a <dispatch+0xb8>
        current_thread->fp(current_thread->arg);
 b0c:	00000797          	auipc	a5,0x0
 b10:	1e47b783          	ld	a5,484(a5) # cf0 <current_thread>
 b14:	6398                	ld	a4,0(a5)
 b16:	6788                	ld	a0,8(a5)
 b18:	9702                	jalr	a4
        thread_exit();
 b1a:	00000097          	auipc	ra,0x0
 b1e:	ea4080e7          	jalr	-348(ra) # 9be <thread_exit>
}
 b22:	60a2                	ld	ra,8(sp)
 b24:	6402                	ld	s0,0(sp)
 b26:	0141                	addi	sp,sp,16
 b28:	8082                	ret
            current_thread->env->sp = (unsigned long)current_thread->stack_p;
 b2a:	00000517          	auipc	a0,0x0
 b2e:	1c653503          	ld	a0,454(a0) # cf0 <current_thread>
 b32:	6d1c                	ld	a5,24(a0)
 b34:	e55c                	sd	a5,136(a0)
            longjmp(current_thread->env, 1);
 b36:	4585                	li	a1,1
 b38:	02050513          	addi	a0,a0,32
 b3c:	00000097          	auipc	ra,0x0
 b40:	d5e080e7          	jalr	-674(ra) # 89a <longjmp>
 b44:	b7e1                	j	b0c <dispatch+0x9a>
        longjmp(current_thread->env, 1);
 b46:	4585                	li	a1,1
 b48:	02050513          	addi	a0,a0,32
 b4c:	00000097          	auipc	ra,0x0
 b50:	d4e080e7          	jalr	-690(ra) # 89a <longjmp>
}
 b54:	b7f9                	j	b22 <dispatch+0xb0>

0000000000000b56 <thread_yield>:
void thread_yield(void){
 b56:	1141                	addi	sp,sp,-16
 b58:	e406                	sd	ra,8(sp)
 b5a:	e022                	sd	s0,0(sp)
 b5c:	0800                	addi	s0,sp,16
    if (current_thread->top == NULL){
 b5e:	00000797          	auipc	a5,0x0
 b62:	1927b783          	ld	a5,402(a5) # cf0 <current_thread>
 b66:	77c8                	ld	a0,168(a5)
 b68:	cd01                	beqz	a0,b80 <thread_yield+0x2a>
        if (setjmp(current_thread->top->env) == 0){
 b6a:	02050513          	addi	a0,a0,32
 b6e:	00000097          	auipc	ra,0x0
 b72:	cf4080e7          	jalr	-780(ra) # 862 <setjmp>
 b76:	c50d                	beqz	a0,ba0 <thread_yield+0x4a>
}
 b78:	60a2                	ld	ra,8(sp)
 b7a:	6402                	ld	s0,0(sp)
 b7c:	0141                	addi	sp,sp,16
 b7e:	8082                	ret
        if (setjmp(current_thread->env) == 0){
 b80:	02078513          	addi	a0,a5,32
 b84:	00000097          	auipc	ra,0x0
 b88:	cde080e7          	jalr	-802(ra) # 862 <setjmp>
 b8c:	f575                	bnez	a0,b78 <thread_yield+0x22>
            schedule();
 b8e:	00000097          	auipc	ra,0x0
 b92:	e16080e7          	jalr	-490(ra) # 9a4 <schedule>
            dispatch();
 b96:	00000097          	auipc	ra,0x0
 b9a:	edc080e7          	jalr	-292(ra) # a72 <dispatch>
 b9e:	bfe9                	j	b78 <thread_yield+0x22>
            schedule();
 ba0:	00000097          	auipc	ra,0x0
 ba4:	e04080e7          	jalr	-508(ra) # 9a4 <schedule>
            dispatch();
 ba8:	00000097          	auipc	ra,0x0
 bac:	eca080e7          	jalr	-310(ra) # a72 <dispatch>
}
 bb0:	b7e1                	j	b78 <thread_yield+0x22>

0000000000000bb2 <thread_start_threading>:
void thread_start_threading(void){
 bb2:	1141                	addi	sp,sp,-16
 bb4:	e406                	sd	ra,8(sp)
 bb6:	e022                	sd	s0,0(sp)
 bb8:	0800                	addi	s0,sp,16
    // TODO
    //fprintf(2, "thread_start_threading\n");
    if (setjmp(env_st) == 0)
 bba:	00000517          	auipc	a0,0x0
 bbe:	14e50513          	addi	a0,a0,334 # d08 <env_st>
 bc2:	00000097          	auipc	ra,0x0
 bc6:	ca0080e7          	jalr	-864(ra) # 862 <setjmp>
 bca:	c509                	beqz	a0,bd4 <thread_start_threading+0x22>
        dispatch();
    return;
}
 bcc:	60a2                	ld	ra,8(sp)
 bce:	6402                	ld	s0,0(sp)
 bd0:	0141                	addi	sp,sp,16
 bd2:	8082                	ret
        dispatch();
 bd4:	00000097          	auipc	ra,0x0
 bd8:	e9e080e7          	jalr	-354(ra) # a72 <dispatch>
    return;
 bdc:	bfc5                	j	bcc <thread_start_threading+0x1a>

0000000000000bde <thread_assign_task>:

// part 2
void thread_assign_task(struct thread *t, void (*f)(void *), void *arg){
 bde:	7179                	addi	sp,sp,-48
 be0:	f406                	sd	ra,40(sp)
 be2:	f022                	sd	s0,32(sp)
 be4:	ec26                	sd	s1,24(sp)
 be6:	e84a                	sd	s2,16(sp)
 be8:	e44e                	sd	s3,8(sp)
 bea:	e052                	sd	s4,0(sp)
 bec:	1800                	addi	s0,sp,48
 bee:	892a                	mv	s2,a0
 bf0:	8a2e                	mv	s4,a1
 bf2:	89b2                	mv	s3,a2
    // TODO
    // fprintf(2, "assign_task\n");
    struct task *tsk = (struct task *)malloc(sizeof(struct task));
 bf4:	0a000513          	li	a0,160
 bf8:	00000097          	auipc	ra,0x0
 bfc:	b86080e7          	jalr	-1146(ra) # 77e <malloc>
 c00:	84aa                	mv	s1,a0
    unsigned long new_stack_p;
    unsigned long new_stack;
    new_stack = (unsigned long) malloc(sizeof(unsigned long)*0x100);
 c02:	6505                	lui	a0,0x1
 c04:	80050513          	addi	a0,a0,-2048 # 800 <malloc+0x82>
 c08:	00000097          	auipc	ra,0x0
 c0c:	b76080e7          	jalr	-1162(ra) # 77e <malloc>
    new_stack_p = new_stack +0x100*8-0x2*8;
    tsk->fp = f;
 c10:	0144b023          	sd	s4,0(s1)
    tsk->arg = arg;
 c14:	0134b423          	sd	s3,8(s1)
    tsk->buf_set = 0;
 c18:	0804a823          	sw	zero,144(s1)
    tsk->stack = (void*) new_stack;
 c1c:	e888                	sd	a0,16(s1)
    new_stack_p = new_stack +0x100*8-0x2*8;
 c1e:	7f050793          	addi	a5,a0,2032
    tsk->stack_p = (void*) new_stack_p;
 c22:	ec9c                	sd	a5,24(s1)
    tsk->prev = t->top;
 c24:	0a893783          	ld	a5,168(s2)
 c28:	ecdc                	sd	a5,152(s1)
    t->top = tsk;
 c2a:	0a993423          	sd	s1,168(s2)
    if (t == current_thread){
 c2e:	00000797          	auipc	a5,0x0
 c32:	0c27b783          	ld	a5,194(a5) # cf0 <current_thread>
 c36:	01278a63          	beq	a5,s2,c4a <thread_assign_task+0x6c>
        else{
            if (t->buf_set != 0)
                setjmp(t->env);
        }
    }
}
 c3a:	70a2                	ld	ra,40(sp)
 c3c:	7402                	ld	s0,32(sp)
 c3e:	64e2                	ld	s1,24(sp)
 c40:	6942                	ld	s2,16(sp)
 c42:	69a2                	ld	s3,8(sp)
 c44:	6a02                	ld	s4,0(sp)
 c46:	6145                	addi	sp,sp,48
 c48:	8082                	ret
        if (tsk->prev != NULL){
 c4a:	6cc8                	ld	a0,152(s1)
 c4c:	c919                	beqz	a0,c62 <thread_assign_task+0x84>
            if (tsk->prev->buf_set != 0)
 c4e:	09052783          	lw	a5,144(a0)
 c52:	d7e5                	beqz	a5,c3a <thread_assign_task+0x5c>
                setjmp(tsk->prev->env);
 c54:	02050513          	addi	a0,a0,32
 c58:	00000097          	auipc	ra,0x0
 c5c:	c0a080e7          	jalr	-1014(ra) # 862 <setjmp>
 c60:	bfe9                	j	c3a <thread_assign_task+0x5c>
            if (t->buf_set != 0)
 c62:	09092783          	lw	a5,144(s2)
 c66:	dbf1                	beqz	a5,c3a <thread_assign_task+0x5c>
                setjmp(t->env);
 c68:	02090513          	addi	a0,s2,32
 c6c:	00000097          	auipc	ra,0x0
 c70:	bf6080e7          	jalr	-1034(ra) # 862 <setjmp>
}
 c74:	b7d9                	j	c3a <thread_assign_task+0x5c>
