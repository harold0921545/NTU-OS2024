
user/_mp2_5:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
/*
 * Note that the tenth(count from index 3 from vmprint table) pte
 * will the on top of queue for LRU page replacement algorithm
 */

int main(int argc, char *argv[]) {
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	addi	s0,sp,32
  vmprint();
   c:	00000097          	auipc	ra,0x0
  10:	3da080e7          	jalr	986(ra) # 3e6 <vmprint>
  char *ptr = malloc(NR_PG * PG_SIZE);
  14:	6541                	lui	a0,0x10
  16:	00000097          	auipc	ra,0x0
  1a:	782080e7          	jalr	1922(ra) # 798 <malloc>
  1e:	84aa                	mv	s1,a0

  madvise((uint64) ptr + 9*PG_SIZE, PG_SIZE - 1,  MADV_PIN); // pin the tenth pte
  20:	460d                	li	a2,3
  22:	6905                	lui	s2,0x1
  24:	fff90593          	addi	a1,s2,-1 # fff <__BSS_END__+0x6ef>
  28:	6525                	lui	a0,0x9
  2a:	9526                	add	a0,a0,s1
  2c:	00000097          	auipc	ra,0x0
  30:	3c2080e7          	jalr	962(ra) # 3ee <madvise>
  printf("After madvise(MADV_PIN)\n");
  34:	00001517          	auipc	a0,0x1
  38:	84c50513          	addi	a0,a0,-1972 # 880 <malloc+0xe8>
  3c:	00000097          	auipc	ra,0x0
  40:	69e080e7          	jalr	1694(ra) # 6da <printf>
  vmprint();
  44:	00000097          	auipc	ra,0x0
  48:	3a2080e7          	jalr	930(ra) # 3e6 <vmprint>

  madvise((uint64) ptr + 5*PG_SIZE, PG_SIZE - 1,  MADV_DONTNEED); // sixth page are swapped out
  4c:	6515                	lui	a0,0x5
  4e:	94aa                	add	s1,s1,a0
  50:	4609                	li	a2,2
  52:	fff90593          	addi	a1,s2,-1
  56:	8526                	mv	a0,s1
  58:	00000097          	auipc	ra,0x0
  5c:	396080e7          	jalr	918(ra) # 3ee <madvise>
  printf("After madvise(MADV_DONTNEED)\n");
  60:	00001517          	auipc	a0,0x1
  64:	84050513          	addi	a0,a0,-1984 # 8a0 <malloc+0x108>
  68:	00000097          	auipc	ra,0x0
  6c:	672080e7          	jalr	1650(ra) # 6da <printf>
  vmprint();
  70:	00000097          	auipc	ra,0x0
  74:	376080e7          	jalr	886(ra) # 3e6 <vmprint>

  char *qtr = ptr + 5*PG_SIZE;
  *qtr = 'a'; // page fault and swap in, should skip tenth pte
  78:	06100793          	li	a5,97
  7c:	00f48023          	sb	a5,0(s1)
  printf("Page fault and swap in\n");
  80:	00001517          	auipc	a0,0x1
  84:	84050513          	addi	a0,a0,-1984 # 8c0 <malloc+0x128>
  88:	00000097          	auipc	ra,0x0
  8c:	652080e7          	jalr	1618(ra) # 6da <printf>
  vmprint();
  90:	00000097          	auipc	ra,0x0
  94:	356080e7          	jalr	854(ra) # 3e6 <vmprint>

  pgprint();
  98:	00000097          	auipc	ra,0x0
  9c:	360080e7          	jalr	864(ra) # 3f8 <pgprint>
  exit(0);
  a0:	4501                	li	a0,0
  a2:	00000097          	auipc	ra,0x0
  a6:	294080e7          	jalr	660(ra) # 336 <exit>

00000000000000aa <strcpy>:



char*
strcpy(char *s, const char *t)
{
  aa:	1141                	addi	sp,sp,-16
  ac:	e422                	sd	s0,8(sp)
  ae:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  b0:	87aa                	mv	a5,a0
  b2:	0585                	addi	a1,a1,1
  b4:	0785                	addi	a5,a5,1
  b6:	fff5c703          	lbu	a4,-1(a1)
  ba:	fee78fa3          	sb	a4,-1(a5)
  be:	fb75                	bnez	a4,b2 <strcpy+0x8>
    ;
  return os;
}
  c0:	6422                	ld	s0,8(sp)
  c2:	0141                	addi	sp,sp,16
  c4:	8082                	ret

00000000000000c6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  c6:	1141                	addi	sp,sp,-16
  c8:	e422                	sd	s0,8(sp)
  ca:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  cc:	00054783          	lbu	a5,0(a0)
  d0:	cb91                	beqz	a5,e4 <strcmp+0x1e>
  d2:	0005c703          	lbu	a4,0(a1)
  d6:	00f71763          	bne	a4,a5,e4 <strcmp+0x1e>
    p++, q++;
  da:	0505                	addi	a0,a0,1
  dc:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  de:	00054783          	lbu	a5,0(a0)
  e2:	fbe5                	bnez	a5,d2 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  e4:	0005c503          	lbu	a0,0(a1)
}
  e8:	40a7853b          	subw	a0,a5,a0
  ec:	6422                	ld	s0,8(sp)
  ee:	0141                	addi	sp,sp,16
  f0:	8082                	ret

00000000000000f2 <strlen>:

uint
strlen(const char *s)
{
  f2:	1141                	addi	sp,sp,-16
  f4:	e422                	sd	s0,8(sp)
  f6:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  f8:	00054783          	lbu	a5,0(a0)
  fc:	cf91                	beqz	a5,118 <strlen+0x26>
  fe:	0505                	addi	a0,a0,1
 100:	87aa                	mv	a5,a0
 102:	4685                	li	a3,1
 104:	9e89                	subw	a3,a3,a0
 106:	00f6853b          	addw	a0,a3,a5
 10a:	0785                	addi	a5,a5,1
 10c:	fff7c703          	lbu	a4,-1(a5)
 110:	fb7d                	bnez	a4,106 <strlen+0x14>
    ;
  return n;
}
 112:	6422                	ld	s0,8(sp)
 114:	0141                	addi	sp,sp,16
 116:	8082                	ret
  for(n = 0; s[n]; n++)
 118:	4501                	li	a0,0
 11a:	bfe5                	j	112 <strlen+0x20>

000000000000011c <memset>:

void*
memset(void *dst, int c, uint n)
{
 11c:	1141                	addi	sp,sp,-16
 11e:	e422                	sd	s0,8(sp)
 120:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 122:	ce09                	beqz	a2,13c <memset+0x20>
 124:	87aa                	mv	a5,a0
 126:	fff6071b          	addiw	a4,a2,-1
 12a:	1702                	slli	a4,a4,0x20
 12c:	9301                	srli	a4,a4,0x20
 12e:	0705                	addi	a4,a4,1
 130:	972a                	add	a4,a4,a0
    cdst[i] = c;
 132:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 136:	0785                	addi	a5,a5,1
 138:	fee79de3          	bne	a5,a4,132 <memset+0x16>
  }
  return dst;
}
 13c:	6422                	ld	s0,8(sp)
 13e:	0141                	addi	sp,sp,16
 140:	8082                	ret

0000000000000142 <strchr>:

char*
strchr(const char *s, char c)
{
 142:	1141                	addi	sp,sp,-16
 144:	e422                	sd	s0,8(sp)
 146:	0800                	addi	s0,sp,16
  for(; *s; s++)
 148:	00054783          	lbu	a5,0(a0)
 14c:	cb99                	beqz	a5,162 <strchr+0x20>
    if(*s == c)
 14e:	00f58763          	beq	a1,a5,15c <strchr+0x1a>
  for(; *s; s++)
 152:	0505                	addi	a0,a0,1
 154:	00054783          	lbu	a5,0(a0)
 158:	fbfd                	bnez	a5,14e <strchr+0xc>
      return (char*)s;
  return 0;
 15a:	4501                	li	a0,0
}
 15c:	6422                	ld	s0,8(sp)
 15e:	0141                	addi	sp,sp,16
 160:	8082                	ret
  return 0;
 162:	4501                	li	a0,0
 164:	bfe5                	j	15c <strchr+0x1a>

0000000000000166 <gets>:

char*
gets(char *buf, int max)
{
 166:	711d                	addi	sp,sp,-96
 168:	ec86                	sd	ra,88(sp)
 16a:	e8a2                	sd	s0,80(sp)
 16c:	e4a6                	sd	s1,72(sp)
 16e:	e0ca                	sd	s2,64(sp)
 170:	fc4e                	sd	s3,56(sp)
 172:	f852                	sd	s4,48(sp)
 174:	f456                	sd	s5,40(sp)
 176:	f05a                	sd	s6,32(sp)
 178:	ec5e                	sd	s7,24(sp)
 17a:	1080                	addi	s0,sp,96
 17c:	8baa                	mv	s7,a0
 17e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 180:	892a                	mv	s2,a0
 182:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 184:	4aa9                	li	s5,10
 186:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 188:	89a6                	mv	s3,s1
 18a:	2485                	addiw	s1,s1,1
 18c:	0344d863          	bge	s1,s4,1bc <gets+0x56>
    cc = read(0, &c, 1);
 190:	4605                	li	a2,1
 192:	faf40593          	addi	a1,s0,-81
 196:	4501                	li	a0,0
 198:	00000097          	auipc	ra,0x0
 19c:	1b6080e7          	jalr	438(ra) # 34e <read>
    if(cc < 1)
 1a0:	00a05e63          	blez	a0,1bc <gets+0x56>
    buf[i++] = c;
 1a4:	faf44783          	lbu	a5,-81(s0)
 1a8:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1ac:	01578763          	beq	a5,s5,1ba <gets+0x54>
 1b0:	0905                	addi	s2,s2,1
 1b2:	fd679be3          	bne	a5,s6,188 <gets+0x22>
  for(i=0; i+1 < max; ){
 1b6:	89a6                	mv	s3,s1
 1b8:	a011                	j	1bc <gets+0x56>
 1ba:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 1bc:	99de                	add	s3,s3,s7
 1be:	00098023          	sb	zero,0(s3)
  return buf;
}
 1c2:	855e                	mv	a0,s7
 1c4:	60e6                	ld	ra,88(sp)
 1c6:	6446                	ld	s0,80(sp)
 1c8:	64a6                	ld	s1,72(sp)
 1ca:	6906                	ld	s2,64(sp)
 1cc:	79e2                	ld	s3,56(sp)
 1ce:	7a42                	ld	s4,48(sp)
 1d0:	7aa2                	ld	s5,40(sp)
 1d2:	7b02                	ld	s6,32(sp)
 1d4:	6be2                	ld	s7,24(sp)
 1d6:	6125                	addi	sp,sp,96
 1d8:	8082                	ret

00000000000001da <stat>:

int
stat(const char *n, struct stat *st)
{
 1da:	1101                	addi	sp,sp,-32
 1dc:	ec06                	sd	ra,24(sp)
 1de:	e822                	sd	s0,16(sp)
 1e0:	e426                	sd	s1,8(sp)
 1e2:	e04a                	sd	s2,0(sp)
 1e4:	1000                	addi	s0,sp,32
 1e6:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1e8:	4581                	li	a1,0
 1ea:	00000097          	auipc	ra,0x0
 1ee:	18c080e7          	jalr	396(ra) # 376 <open>
  if(fd < 0)
 1f2:	02054563          	bltz	a0,21c <stat+0x42>
 1f6:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1f8:	85ca                	mv	a1,s2
 1fa:	00000097          	auipc	ra,0x0
 1fe:	194080e7          	jalr	404(ra) # 38e <fstat>
 202:	892a                	mv	s2,a0
  close(fd);
 204:	8526                	mv	a0,s1
 206:	00000097          	auipc	ra,0x0
 20a:	158080e7          	jalr	344(ra) # 35e <close>
  return r;
}
 20e:	854a                	mv	a0,s2
 210:	60e2                	ld	ra,24(sp)
 212:	6442                	ld	s0,16(sp)
 214:	64a2                	ld	s1,8(sp)
 216:	6902                	ld	s2,0(sp)
 218:	6105                	addi	sp,sp,32
 21a:	8082                	ret
    return -1;
 21c:	597d                	li	s2,-1
 21e:	bfc5                	j	20e <stat+0x34>

0000000000000220 <atoi>:

int
atoi(const char *s)
{
 220:	1141                	addi	sp,sp,-16
 222:	e422                	sd	s0,8(sp)
 224:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 226:	00054603          	lbu	a2,0(a0)
 22a:	fd06079b          	addiw	a5,a2,-48
 22e:	0ff7f793          	andi	a5,a5,255
 232:	4725                	li	a4,9
 234:	02f76963          	bltu	a4,a5,266 <atoi+0x46>
 238:	86aa                	mv	a3,a0
  n = 0;
 23a:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 23c:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 23e:	0685                	addi	a3,a3,1
 240:	0025179b          	slliw	a5,a0,0x2
 244:	9fa9                	addw	a5,a5,a0
 246:	0017979b          	slliw	a5,a5,0x1
 24a:	9fb1                	addw	a5,a5,a2
 24c:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 250:	0006c603          	lbu	a2,0(a3)
 254:	fd06071b          	addiw	a4,a2,-48
 258:	0ff77713          	andi	a4,a4,255
 25c:	fee5f1e3          	bgeu	a1,a4,23e <atoi+0x1e>
  return n;
}
 260:	6422                	ld	s0,8(sp)
 262:	0141                	addi	sp,sp,16
 264:	8082                	ret
  n = 0;
 266:	4501                	li	a0,0
 268:	bfe5                	j	260 <atoi+0x40>

000000000000026a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 26a:	1141                	addi	sp,sp,-16
 26c:	e422                	sd	s0,8(sp)
 26e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 270:	02b57663          	bgeu	a0,a1,29c <memmove+0x32>
    while(n-- > 0)
 274:	02c05163          	blez	a2,296 <memmove+0x2c>
 278:	fff6079b          	addiw	a5,a2,-1
 27c:	1782                	slli	a5,a5,0x20
 27e:	9381                	srli	a5,a5,0x20
 280:	0785                	addi	a5,a5,1
 282:	97aa                	add	a5,a5,a0
  dst = vdst;
 284:	872a                	mv	a4,a0
      *dst++ = *src++;
 286:	0585                	addi	a1,a1,1
 288:	0705                	addi	a4,a4,1
 28a:	fff5c683          	lbu	a3,-1(a1)
 28e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 292:	fee79ae3          	bne	a5,a4,286 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 296:	6422                	ld	s0,8(sp)
 298:	0141                	addi	sp,sp,16
 29a:	8082                	ret
    dst += n;
 29c:	00c50733          	add	a4,a0,a2
    src += n;
 2a0:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2a2:	fec05ae3          	blez	a2,296 <memmove+0x2c>
 2a6:	fff6079b          	addiw	a5,a2,-1
 2aa:	1782                	slli	a5,a5,0x20
 2ac:	9381                	srli	a5,a5,0x20
 2ae:	fff7c793          	not	a5,a5
 2b2:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2b4:	15fd                	addi	a1,a1,-1
 2b6:	177d                	addi	a4,a4,-1
 2b8:	0005c683          	lbu	a3,0(a1)
 2bc:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2c0:	fee79ae3          	bne	a5,a4,2b4 <memmove+0x4a>
 2c4:	bfc9                	j	296 <memmove+0x2c>

00000000000002c6 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2c6:	1141                	addi	sp,sp,-16
 2c8:	e422                	sd	s0,8(sp)
 2ca:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2cc:	ca05                	beqz	a2,2fc <memcmp+0x36>
 2ce:	fff6069b          	addiw	a3,a2,-1
 2d2:	1682                	slli	a3,a3,0x20
 2d4:	9281                	srli	a3,a3,0x20
 2d6:	0685                	addi	a3,a3,1
 2d8:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2da:	00054783          	lbu	a5,0(a0)
 2de:	0005c703          	lbu	a4,0(a1)
 2e2:	00e79863          	bne	a5,a4,2f2 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2e6:	0505                	addi	a0,a0,1
    p2++;
 2e8:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2ea:	fed518e3          	bne	a0,a3,2da <memcmp+0x14>
  }
  return 0;
 2ee:	4501                	li	a0,0
 2f0:	a019                	j	2f6 <memcmp+0x30>
      return *p1 - *p2;
 2f2:	40e7853b          	subw	a0,a5,a4
}
 2f6:	6422                	ld	s0,8(sp)
 2f8:	0141                	addi	sp,sp,16
 2fa:	8082                	ret
  return 0;
 2fc:	4501                	li	a0,0
 2fe:	bfe5                	j	2f6 <memcmp+0x30>

0000000000000300 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 300:	1141                	addi	sp,sp,-16
 302:	e406                	sd	ra,8(sp)
 304:	e022                	sd	s0,0(sp)
 306:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 308:	00000097          	auipc	ra,0x0
 30c:	f62080e7          	jalr	-158(ra) # 26a <memmove>
}
 310:	60a2                	ld	ra,8(sp)
 312:	6402                	ld	s0,0(sp)
 314:	0141                	addi	sp,sp,16
 316:	8082                	ret

0000000000000318 <ugetpid>:

#ifdef LAB_PGTBL
int
ugetpid(void)
{
 318:	1141                	addi	sp,sp,-16
 31a:	e422                	sd	s0,8(sp)
 31c:	0800                	addi	s0,sp,16
  struct usyscall *u = (struct usyscall *)USYSCALL;
  return u->pid;
 31e:	040007b7          	lui	a5,0x4000
}
 322:	17f5                	addi	a5,a5,-3
 324:	07b2                	slli	a5,a5,0xc
 326:	4388                	lw	a0,0(a5)
 328:	6422                	ld	s0,8(sp)
 32a:	0141                	addi	sp,sp,16
 32c:	8082                	ret

000000000000032e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 32e:	4885                	li	a7,1
 ecall
 330:	00000073          	ecall
 ret
 334:	8082                	ret

0000000000000336 <exit>:
.global exit
exit:
 li a7, SYS_exit
 336:	4889                	li	a7,2
 ecall
 338:	00000073          	ecall
 ret
 33c:	8082                	ret

000000000000033e <wait>:
.global wait
wait:
 li a7, SYS_wait
 33e:	488d                	li	a7,3
 ecall
 340:	00000073          	ecall
 ret
 344:	8082                	ret

0000000000000346 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 346:	4891                	li	a7,4
 ecall
 348:	00000073          	ecall
 ret
 34c:	8082                	ret

000000000000034e <read>:
.global read
read:
 li a7, SYS_read
 34e:	4895                	li	a7,5
 ecall
 350:	00000073          	ecall
 ret
 354:	8082                	ret

0000000000000356 <write>:
.global write
write:
 li a7, SYS_write
 356:	48c1                	li	a7,16
 ecall
 358:	00000073          	ecall
 ret
 35c:	8082                	ret

000000000000035e <close>:
.global close
close:
 li a7, SYS_close
 35e:	48d5                	li	a7,21
 ecall
 360:	00000073          	ecall
 ret
 364:	8082                	ret

0000000000000366 <kill>:
.global kill
kill:
 li a7, SYS_kill
 366:	4899                	li	a7,6
 ecall
 368:	00000073          	ecall
 ret
 36c:	8082                	ret

000000000000036e <exec>:
.global exec
exec:
 li a7, SYS_exec
 36e:	489d                	li	a7,7
 ecall
 370:	00000073          	ecall
 ret
 374:	8082                	ret

0000000000000376 <open>:
.global open
open:
 li a7, SYS_open
 376:	48bd                	li	a7,15
 ecall
 378:	00000073          	ecall
 ret
 37c:	8082                	ret

000000000000037e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 37e:	48c5                	li	a7,17
 ecall
 380:	00000073          	ecall
 ret
 384:	8082                	ret

0000000000000386 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 386:	48c9                	li	a7,18
 ecall
 388:	00000073          	ecall
 ret
 38c:	8082                	ret

000000000000038e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 38e:	48a1                	li	a7,8
 ecall
 390:	00000073          	ecall
 ret
 394:	8082                	ret

0000000000000396 <link>:
.global link
link:
 li a7, SYS_link
 396:	48cd                	li	a7,19
 ecall
 398:	00000073          	ecall
 ret
 39c:	8082                	ret

000000000000039e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 39e:	48d1                	li	a7,20
 ecall
 3a0:	00000073          	ecall
 ret
 3a4:	8082                	ret

00000000000003a6 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3a6:	48a5                	li	a7,9
 ecall
 3a8:	00000073          	ecall
 ret
 3ac:	8082                	ret

00000000000003ae <dup>:
.global dup
dup:
 li a7, SYS_dup
 3ae:	48a9                	li	a7,10
 ecall
 3b0:	00000073          	ecall
 ret
 3b4:	8082                	ret

00000000000003b6 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3b6:	48ad                	li	a7,11
 ecall
 3b8:	00000073          	ecall
 ret
 3bc:	8082                	ret

00000000000003be <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 3be:	48b1                	li	a7,12
 ecall
 3c0:	00000073          	ecall
 ret
 3c4:	8082                	ret

00000000000003c6 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3c6:	48b5                	li	a7,13
 ecall
 3c8:	00000073          	ecall
 ret
 3cc:	8082                	ret

00000000000003ce <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3ce:	48b9                	li	a7,14
 ecall
 3d0:	00000073          	ecall
 ret
 3d4:	8082                	ret

00000000000003d6 <connect>:
.global connect
connect:
 li a7, SYS_connect
 3d6:	48f5                	li	a7,29
 ecall
 3d8:	00000073          	ecall
 ret
 3dc:	8082                	ret

00000000000003de <pgaccess>:
.global pgaccess
pgaccess:
 li a7, SYS_pgaccess
 3de:	48f9                	li	a7,30
 ecall
 3e0:	00000073          	ecall
 ret
 3e4:	8082                	ret

00000000000003e6 <vmprint>:
.global vmprint
vmprint:
 li a7, SYS_vmprint
 3e6:	48fd                	li	a7,31
 ecall
 3e8:	00000073          	ecall
 ret
 3ec:	8082                	ret

00000000000003ee <madvise>:
.global madvise
madvise:
 li a7, SYS_madvise
 3ee:	02000893          	li	a7,32
 ecall
 3f2:	00000073          	ecall
 ret
 3f6:	8082                	ret

00000000000003f8 <pgprint>:
.global pgprint
pgprint:
 li a7, SYS_pgprint
 3f8:	02100893          	li	a7,33
 ecall
 3fc:	00000073          	ecall
 ret
 400:	8082                	ret

0000000000000402 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 402:	1101                	addi	sp,sp,-32
 404:	ec06                	sd	ra,24(sp)
 406:	e822                	sd	s0,16(sp)
 408:	1000                	addi	s0,sp,32
 40a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 40e:	4605                	li	a2,1
 410:	fef40593          	addi	a1,s0,-17
 414:	00000097          	auipc	ra,0x0
 418:	f42080e7          	jalr	-190(ra) # 356 <write>
}
 41c:	60e2                	ld	ra,24(sp)
 41e:	6442                	ld	s0,16(sp)
 420:	6105                	addi	sp,sp,32
 422:	8082                	ret

0000000000000424 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 424:	7139                	addi	sp,sp,-64
 426:	fc06                	sd	ra,56(sp)
 428:	f822                	sd	s0,48(sp)
 42a:	f426                	sd	s1,40(sp)
 42c:	f04a                	sd	s2,32(sp)
 42e:	ec4e                	sd	s3,24(sp)
 430:	0080                	addi	s0,sp,64
 432:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 434:	c299                	beqz	a3,43a <printint+0x16>
 436:	0805c863          	bltz	a1,4c6 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 43a:	2581                	sext.w	a1,a1
  neg = 0;
 43c:	4881                	li	a7,0
 43e:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 442:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 444:	2601                	sext.w	a2,a2
 446:	00000517          	auipc	a0,0x0
 44a:	49a50513          	addi	a0,a0,1178 # 8e0 <digits>
 44e:	883a                	mv	a6,a4
 450:	2705                	addiw	a4,a4,1
 452:	02c5f7bb          	remuw	a5,a1,a2
 456:	1782                	slli	a5,a5,0x20
 458:	9381                	srli	a5,a5,0x20
 45a:	97aa                	add	a5,a5,a0
 45c:	0007c783          	lbu	a5,0(a5) # 4000000 <__global_pointer$+0x3ffef0f>
 460:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 464:	0005879b          	sext.w	a5,a1
 468:	02c5d5bb          	divuw	a1,a1,a2
 46c:	0685                	addi	a3,a3,1
 46e:	fec7f0e3          	bgeu	a5,a2,44e <printint+0x2a>
  if(neg)
 472:	00088b63          	beqz	a7,488 <printint+0x64>
    buf[i++] = '-';
 476:	fd040793          	addi	a5,s0,-48
 47a:	973e                	add	a4,a4,a5
 47c:	02d00793          	li	a5,45
 480:	fef70823          	sb	a5,-16(a4)
 484:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 488:	02e05863          	blez	a4,4b8 <printint+0x94>
 48c:	fc040793          	addi	a5,s0,-64
 490:	00e78933          	add	s2,a5,a4
 494:	fff78993          	addi	s3,a5,-1
 498:	99ba                	add	s3,s3,a4
 49a:	377d                	addiw	a4,a4,-1
 49c:	1702                	slli	a4,a4,0x20
 49e:	9301                	srli	a4,a4,0x20
 4a0:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4a4:	fff94583          	lbu	a1,-1(s2)
 4a8:	8526                	mv	a0,s1
 4aa:	00000097          	auipc	ra,0x0
 4ae:	f58080e7          	jalr	-168(ra) # 402 <putc>
  while(--i >= 0)
 4b2:	197d                	addi	s2,s2,-1
 4b4:	ff3918e3          	bne	s2,s3,4a4 <printint+0x80>
}
 4b8:	70e2                	ld	ra,56(sp)
 4ba:	7442                	ld	s0,48(sp)
 4bc:	74a2                	ld	s1,40(sp)
 4be:	7902                	ld	s2,32(sp)
 4c0:	69e2                	ld	s3,24(sp)
 4c2:	6121                	addi	sp,sp,64
 4c4:	8082                	ret
    x = -xx;
 4c6:	40b005bb          	negw	a1,a1
    neg = 1;
 4ca:	4885                	li	a7,1
    x = -xx;
 4cc:	bf8d                	j	43e <printint+0x1a>

00000000000004ce <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4ce:	7119                	addi	sp,sp,-128
 4d0:	fc86                	sd	ra,120(sp)
 4d2:	f8a2                	sd	s0,112(sp)
 4d4:	f4a6                	sd	s1,104(sp)
 4d6:	f0ca                	sd	s2,96(sp)
 4d8:	ecce                	sd	s3,88(sp)
 4da:	e8d2                	sd	s4,80(sp)
 4dc:	e4d6                	sd	s5,72(sp)
 4de:	e0da                	sd	s6,64(sp)
 4e0:	fc5e                	sd	s7,56(sp)
 4e2:	f862                	sd	s8,48(sp)
 4e4:	f466                	sd	s9,40(sp)
 4e6:	f06a                	sd	s10,32(sp)
 4e8:	ec6e                	sd	s11,24(sp)
 4ea:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4ec:	0005c903          	lbu	s2,0(a1)
 4f0:	18090f63          	beqz	s2,68e <vprintf+0x1c0>
 4f4:	8aaa                	mv	s5,a0
 4f6:	8b32                	mv	s6,a2
 4f8:	00158493          	addi	s1,a1,1
  state = 0;
 4fc:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4fe:	02500a13          	li	s4,37
      if(c == 'd'){
 502:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 506:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 50a:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 50e:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 512:	00000b97          	auipc	s7,0x0
 516:	3ceb8b93          	addi	s7,s7,974 # 8e0 <digits>
 51a:	a839                	j	538 <vprintf+0x6a>
        putc(fd, c);
 51c:	85ca                	mv	a1,s2
 51e:	8556                	mv	a0,s5
 520:	00000097          	auipc	ra,0x0
 524:	ee2080e7          	jalr	-286(ra) # 402 <putc>
 528:	a019                	j	52e <vprintf+0x60>
    } else if(state == '%'){
 52a:	01498f63          	beq	s3,s4,548 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 52e:	0485                	addi	s1,s1,1
 530:	fff4c903          	lbu	s2,-1(s1)
 534:	14090d63          	beqz	s2,68e <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 538:	0009079b          	sext.w	a5,s2
    if(state == 0){
 53c:	fe0997e3          	bnez	s3,52a <vprintf+0x5c>
      if(c == '%'){
 540:	fd479ee3          	bne	a5,s4,51c <vprintf+0x4e>
        state = '%';
 544:	89be                	mv	s3,a5
 546:	b7e5                	j	52e <vprintf+0x60>
      if(c == 'd'){
 548:	05878063          	beq	a5,s8,588 <vprintf+0xba>
      } else if(c == 'l') {
 54c:	05978c63          	beq	a5,s9,5a4 <vprintf+0xd6>
      } else if(c == 'x') {
 550:	07a78863          	beq	a5,s10,5c0 <vprintf+0xf2>
      } else if(c == 'p') {
 554:	09b78463          	beq	a5,s11,5dc <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 558:	07300713          	li	a4,115
 55c:	0ce78663          	beq	a5,a4,628 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 560:	06300713          	li	a4,99
 564:	0ee78e63          	beq	a5,a4,660 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 568:	11478863          	beq	a5,s4,678 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 56c:	85d2                	mv	a1,s4
 56e:	8556                	mv	a0,s5
 570:	00000097          	auipc	ra,0x0
 574:	e92080e7          	jalr	-366(ra) # 402 <putc>
        putc(fd, c);
 578:	85ca                	mv	a1,s2
 57a:	8556                	mv	a0,s5
 57c:	00000097          	auipc	ra,0x0
 580:	e86080e7          	jalr	-378(ra) # 402 <putc>
      }
      state = 0;
 584:	4981                	li	s3,0
 586:	b765                	j	52e <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 588:	008b0913          	addi	s2,s6,8
 58c:	4685                	li	a3,1
 58e:	4629                	li	a2,10
 590:	000b2583          	lw	a1,0(s6)
 594:	8556                	mv	a0,s5
 596:	00000097          	auipc	ra,0x0
 59a:	e8e080e7          	jalr	-370(ra) # 424 <printint>
 59e:	8b4a                	mv	s6,s2
      state = 0;
 5a0:	4981                	li	s3,0
 5a2:	b771                	j	52e <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5a4:	008b0913          	addi	s2,s6,8
 5a8:	4681                	li	a3,0
 5aa:	4629                	li	a2,10
 5ac:	000b2583          	lw	a1,0(s6)
 5b0:	8556                	mv	a0,s5
 5b2:	00000097          	auipc	ra,0x0
 5b6:	e72080e7          	jalr	-398(ra) # 424 <printint>
 5ba:	8b4a                	mv	s6,s2
      state = 0;
 5bc:	4981                	li	s3,0
 5be:	bf85                	j	52e <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 5c0:	008b0913          	addi	s2,s6,8
 5c4:	4681                	li	a3,0
 5c6:	4641                	li	a2,16
 5c8:	000b2583          	lw	a1,0(s6)
 5cc:	8556                	mv	a0,s5
 5ce:	00000097          	auipc	ra,0x0
 5d2:	e56080e7          	jalr	-426(ra) # 424 <printint>
 5d6:	8b4a                	mv	s6,s2
      state = 0;
 5d8:	4981                	li	s3,0
 5da:	bf91                	j	52e <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 5dc:	008b0793          	addi	a5,s6,8
 5e0:	f8f43423          	sd	a5,-120(s0)
 5e4:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 5e8:	03000593          	li	a1,48
 5ec:	8556                	mv	a0,s5
 5ee:	00000097          	auipc	ra,0x0
 5f2:	e14080e7          	jalr	-492(ra) # 402 <putc>
  putc(fd, 'x');
 5f6:	85ea                	mv	a1,s10
 5f8:	8556                	mv	a0,s5
 5fa:	00000097          	auipc	ra,0x0
 5fe:	e08080e7          	jalr	-504(ra) # 402 <putc>
 602:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 604:	03c9d793          	srli	a5,s3,0x3c
 608:	97de                	add	a5,a5,s7
 60a:	0007c583          	lbu	a1,0(a5)
 60e:	8556                	mv	a0,s5
 610:	00000097          	auipc	ra,0x0
 614:	df2080e7          	jalr	-526(ra) # 402 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 618:	0992                	slli	s3,s3,0x4
 61a:	397d                	addiw	s2,s2,-1
 61c:	fe0914e3          	bnez	s2,604 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 620:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 624:	4981                	li	s3,0
 626:	b721                	j	52e <vprintf+0x60>
        s = va_arg(ap, char*);
 628:	008b0993          	addi	s3,s6,8
 62c:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 630:	02090163          	beqz	s2,652 <vprintf+0x184>
        while(*s != 0){
 634:	00094583          	lbu	a1,0(s2)
 638:	c9a1                	beqz	a1,688 <vprintf+0x1ba>
          putc(fd, *s);
 63a:	8556                	mv	a0,s5
 63c:	00000097          	auipc	ra,0x0
 640:	dc6080e7          	jalr	-570(ra) # 402 <putc>
          s++;
 644:	0905                	addi	s2,s2,1
        while(*s != 0){
 646:	00094583          	lbu	a1,0(s2)
 64a:	f9e5                	bnez	a1,63a <vprintf+0x16c>
        s = va_arg(ap, char*);
 64c:	8b4e                	mv	s6,s3
      state = 0;
 64e:	4981                	li	s3,0
 650:	bdf9                	j	52e <vprintf+0x60>
          s = "(null)";
 652:	00000917          	auipc	s2,0x0
 656:	28690913          	addi	s2,s2,646 # 8d8 <malloc+0x140>
        while(*s != 0){
 65a:	02800593          	li	a1,40
 65e:	bff1                	j	63a <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 660:	008b0913          	addi	s2,s6,8
 664:	000b4583          	lbu	a1,0(s6)
 668:	8556                	mv	a0,s5
 66a:	00000097          	auipc	ra,0x0
 66e:	d98080e7          	jalr	-616(ra) # 402 <putc>
 672:	8b4a                	mv	s6,s2
      state = 0;
 674:	4981                	li	s3,0
 676:	bd65                	j	52e <vprintf+0x60>
        putc(fd, c);
 678:	85d2                	mv	a1,s4
 67a:	8556                	mv	a0,s5
 67c:	00000097          	auipc	ra,0x0
 680:	d86080e7          	jalr	-634(ra) # 402 <putc>
      state = 0;
 684:	4981                	li	s3,0
 686:	b565                	j	52e <vprintf+0x60>
        s = va_arg(ap, char*);
 688:	8b4e                	mv	s6,s3
      state = 0;
 68a:	4981                	li	s3,0
 68c:	b54d                	j	52e <vprintf+0x60>
    }
  }
}
 68e:	70e6                	ld	ra,120(sp)
 690:	7446                	ld	s0,112(sp)
 692:	74a6                	ld	s1,104(sp)
 694:	7906                	ld	s2,96(sp)
 696:	69e6                	ld	s3,88(sp)
 698:	6a46                	ld	s4,80(sp)
 69a:	6aa6                	ld	s5,72(sp)
 69c:	6b06                	ld	s6,64(sp)
 69e:	7be2                	ld	s7,56(sp)
 6a0:	7c42                	ld	s8,48(sp)
 6a2:	7ca2                	ld	s9,40(sp)
 6a4:	7d02                	ld	s10,32(sp)
 6a6:	6de2                	ld	s11,24(sp)
 6a8:	6109                	addi	sp,sp,128
 6aa:	8082                	ret

00000000000006ac <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6ac:	715d                	addi	sp,sp,-80
 6ae:	ec06                	sd	ra,24(sp)
 6b0:	e822                	sd	s0,16(sp)
 6b2:	1000                	addi	s0,sp,32
 6b4:	e010                	sd	a2,0(s0)
 6b6:	e414                	sd	a3,8(s0)
 6b8:	e818                	sd	a4,16(s0)
 6ba:	ec1c                	sd	a5,24(s0)
 6bc:	03043023          	sd	a6,32(s0)
 6c0:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6c4:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6c8:	8622                	mv	a2,s0
 6ca:	00000097          	auipc	ra,0x0
 6ce:	e04080e7          	jalr	-508(ra) # 4ce <vprintf>
}
 6d2:	60e2                	ld	ra,24(sp)
 6d4:	6442                	ld	s0,16(sp)
 6d6:	6161                	addi	sp,sp,80
 6d8:	8082                	ret

00000000000006da <printf>:

void
printf(const char *fmt, ...)
{
 6da:	711d                	addi	sp,sp,-96
 6dc:	ec06                	sd	ra,24(sp)
 6de:	e822                	sd	s0,16(sp)
 6e0:	1000                	addi	s0,sp,32
 6e2:	e40c                	sd	a1,8(s0)
 6e4:	e810                	sd	a2,16(s0)
 6e6:	ec14                	sd	a3,24(s0)
 6e8:	f018                	sd	a4,32(s0)
 6ea:	f41c                	sd	a5,40(s0)
 6ec:	03043823          	sd	a6,48(s0)
 6f0:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6f4:	00840613          	addi	a2,s0,8
 6f8:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6fc:	85aa                	mv	a1,a0
 6fe:	4505                	li	a0,1
 700:	00000097          	auipc	ra,0x0
 704:	dce080e7          	jalr	-562(ra) # 4ce <vprintf>
}
 708:	60e2                	ld	ra,24(sp)
 70a:	6442                	ld	s0,16(sp)
 70c:	6125                	addi	sp,sp,96
 70e:	8082                	ret

0000000000000710 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 710:	1141                	addi	sp,sp,-16
 712:	e422                	sd	s0,8(sp)
 714:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 716:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 71a:	00000797          	auipc	a5,0x0
 71e:	1de7b783          	ld	a5,478(a5) # 8f8 <freep>
 722:	a805                	j	752 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 724:	4618                	lw	a4,8(a2)
 726:	9db9                	addw	a1,a1,a4
 728:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 72c:	6398                	ld	a4,0(a5)
 72e:	6318                	ld	a4,0(a4)
 730:	fee53823          	sd	a4,-16(a0)
 734:	a091                	j	778 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 736:	ff852703          	lw	a4,-8(a0)
 73a:	9e39                	addw	a2,a2,a4
 73c:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 73e:	ff053703          	ld	a4,-16(a0)
 742:	e398                	sd	a4,0(a5)
 744:	a099                	j	78a <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 746:	6398                	ld	a4,0(a5)
 748:	00e7e463          	bltu	a5,a4,750 <free+0x40>
 74c:	00e6ea63          	bltu	a3,a4,760 <free+0x50>
{
 750:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 752:	fed7fae3          	bgeu	a5,a3,746 <free+0x36>
 756:	6398                	ld	a4,0(a5)
 758:	00e6e463          	bltu	a3,a4,760 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 75c:	fee7eae3          	bltu	a5,a4,750 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 760:	ff852583          	lw	a1,-8(a0)
 764:	6390                	ld	a2,0(a5)
 766:	02059713          	slli	a4,a1,0x20
 76a:	9301                	srli	a4,a4,0x20
 76c:	0712                	slli	a4,a4,0x4
 76e:	9736                	add	a4,a4,a3
 770:	fae60ae3          	beq	a2,a4,724 <free+0x14>
    bp->s.ptr = p->s.ptr;
 774:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 778:	4790                	lw	a2,8(a5)
 77a:	02061713          	slli	a4,a2,0x20
 77e:	9301                	srli	a4,a4,0x20
 780:	0712                	slli	a4,a4,0x4
 782:	973e                	add	a4,a4,a5
 784:	fae689e3          	beq	a3,a4,736 <free+0x26>
  } else
    p->s.ptr = bp;
 788:	e394                	sd	a3,0(a5)
  freep = p;
 78a:	00000717          	auipc	a4,0x0
 78e:	16f73723          	sd	a5,366(a4) # 8f8 <freep>
}
 792:	6422                	ld	s0,8(sp)
 794:	0141                	addi	sp,sp,16
 796:	8082                	ret

0000000000000798 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 798:	7139                	addi	sp,sp,-64
 79a:	fc06                	sd	ra,56(sp)
 79c:	f822                	sd	s0,48(sp)
 79e:	f426                	sd	s1,40(sp)
 7a0:	f04a                	sd	s2,32(sp)
 7a2:	ec4e                	sd	s3,24(sp)
 7a4:	e852                	sd	s4,16(sp)
 7a6:	e456                	sd	s5,8(sp)
 7a8:	e05a                	sd	s6,0(sp)
 7aa:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7ac:	02051493          	slli	s1,a0,0x20
 7b0:	9081                	srli	s1,s1,0x20
 7b2:	04bd                	addi	s1,s1,15
 7b4:	8091                	srli	s1,s1,0x4
 7b6:	0014899b          	addiw	s3,s1,1
 7ba:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 7bc:	00000797          	auipc	a5,0x0
 7c0:	13c7b783          	ld	a5,316(a5) # 8f8 <freep>
 7c4:	c795                	beqz	a5,7f0 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7c6:	6388                	ld	a0,0(a5)
    if(p->s.size >= nunits){
 7c8:	4518                	lw	a4,8(a0)
 7ca:	02977f63          	bgeu	a4,s1,808 <malloc+0x70>
 7ce:	8a4e                	mv	s4,s3
 7d0:	0009879b          	sext.w	a5,s3
 7d4:	6705                	lui	a4,0x1
 7d6:	00e7f363          	bgeu	a5,a4,7dc <malloc+0x44>
 7da:	6a05                	lui	s4,0x1
 7dc:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7e0:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p);
    }
    if(p == freep)
 7e4:	00000917          	auipc	s2,0x0
 7e8:	11490913          	addi	s2,s2,276 # 8f8 <freep>
  if(p == (char*)-1)
 7ec:	5afd                	li	s5,-1
 7ee:	a0bd                	j	85c <malloc+0xc4>
    base.s.ptr = freep = prevp = &base;
 7f0:	00000517          	auipc	a0,0x0
 7f4:	11050513          	addi	a0,a0,272 # 900 <base>
 7f8:	00000797          	auipc	a5,0x0
 7fc:	10a7b023          	sd	a0,256(a5) # 8f8 <freep>
 800:	e108                	sd	a0,0(a0)
    base.s.size = 0;
 802:	00052423          	sw	zero,8(a0)
    if(p->s.size >= nunits){
 806:	b7e1                	j	7ce <malloc+0x36>
      if(p->s.size == nunits)
 808:	02e48963          	beq	s1,a4,83a <malloc+0xa2>
        p->s.size -= nunits;
 80c:	4137073b          	subw	a4,a4,s3
 810:	c518                	sw	a4,8(a0)
        p += p->s.size;
 812:	1702                	slli	a4,a4,0x20
 814:	9301                	srli	a4,a4,0x20
 816:	0712                	slli	a4,a4,0x4
 818:	953a                	add	a0,a0,a4
        p->s.size = nunits;
 81a:	01352423          	sw	s3,8(a0)
      freep = prevp;
 81e:	00000717          	auipc	a4,0x0
 822:	0cf73d23          	sd	a5,218(a4) # 8f8 <freep>
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 826:	70e2                	ld	ra,56(sp)
 828:	7442                	ld	s0,48(sp)
 82a:	74a2                	ld	s1,40(sp)
 82c:	7902                	ld	s2,32(sp)
 82e:	69e2                	ld	s3,24(sp)
 830:	6a42                	ld	s4,16(sp)
 832:	6aa2                	ld	s5,8(sp)
 834:	6b02                	ld	s6,0(sp)
 836:	6121                	addi	sp,sp,64
 838:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 83a:	6118                	ld	a4,0(a0)
 83c:	e398                	sd	a4,0(a5)
 83e:	b7c5                	j	81e <malloc+0x86>
  hp->s.size = nu;
 840:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 844:	0541                	addi	a0,a0,16
 846:	00000097          	auipc	ra,0x0
 84a:	eca080e7          	jalr	-310(ra) # 710 <free>
  return freep;
 84e:	00093783          	ld	a5,0(s2)
      if((p = morecore(nunits)) == 0)
 852:	c39d                	beqz	a5,878 <malloc+0xe0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 854:	6388                	ld	a0,0(a5)
    if(p->s.size >= nunits){
 856:	4518                	lw	a4,8(a0)
 858:	fa9778e3          	bgeu	a4,s1,808 <malloc+0x70>
    if(p == freep)
 85c:	00093703          	ld	a4,0(s2)
 860:	87aa                	mv	a5,a0
 862:	fea719e3          	bne	a4,a0,854 <malloc+0xbc>
  p = sbrk(nu * sizeof(Header));
 866:	8552                	mv	a0,s4
 868:	00000097          	auipc	ra,0x0
 86c:	b56080e7          	jalr	-1194(ra) # 3be <sbrk>
  if(p == (char*)-1)
 870:	fd5518e3          	bne	a0,s5,840 <malloc+0xa8>
        return 0;
 874:	4501                	li	a0,0
 876:	bf45                	j	826 <malloc+0x8e>
 878:	853e                	mv	a0,a5
 87a:	b775                	j	826 <malloc+0x8e>
