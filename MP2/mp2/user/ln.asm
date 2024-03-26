
user/_ln:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	1000                	addi	s0,sp,32
  if(argc != 3){
   a:	478d                	li	a5,3
   c:	02f50063          	beq	a0,a5,2c <main+0x2c>
    fprintf(2, "Usage: ln old new\n");
  10:	00001597          	auipc	a1,0x1
  14:	82858593          	addi	a1,a1,-2008 # 838 <malloc+0xea>
  18:	4509                	li	a0,2
  1a:	00000097          	auipc	ra,0x0
  1e:	648080e7          	jalr	1608(ra) # 662 <fprintf>
    exit(1);
  22:	4505                	li	a0,1
  24:	00000097          	auipc	ra,0x0
  28:	2c8080e7          	jalr	712(ra) # 2ec <exit>
  2c:	84ae                	mv	s1,a1
  }
  if(link(argv[1], argv[2]) < 0)
  2e:	698c                	ld	a1,16(a1)
  30:	6488                	ld	a0,8(s1)
  32:	00000097          	auipc	ra,0x0
  36:	31a080e7          	jalr	794(ra) # 34c <link>
  3a:	00054763          	bltz	a0,48 <main+0x48>
    fprintf(2, "link %s %s: failed\n", argv[1], argv[2]);
  exit(0);
  3e:	4501                	li	a0,0
  40:	00000097          	auipc	ra,0x0
  44:	2ac080e7          	jalr	684(ra) # 2ec <exit>
    fprintf(2, "link %s %s: failed\n", argv[1], argv[2]);
  48:	6894                	ld	a3,16(s1)
  4a:	6490                	ld	a2,8(s1)
  4c:	00001597          	auipc	a1,0x1
  50:	80458593          	addi	a1,a1,-2044 # 850 <malloc+0x102>
  54:	4509                	li	a0,2
  56:	00000097          	auipc	ra,0x0
  5a:	60c080e7          	jalr	1548(ra) # 662 <fprintf>
  5e:	b7c5                	j	3e <main+0x3e>

0000000000000060 <strcpy>:



char*
strcpy(char *s, const char *t)
{
  60:	1141                	addi	sp,sp,-16
  62:	e422                	sd	s0,8(sp)
  64:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  66:	87aa                	mv	a5,a0
  68:	0585                	addi	a1,a1,1
  6a:	0785                	addi	a5,a5,1
  6c:	fff5c703          	lbu	a4,-1(a1)
  70:	fee78fa3          	sb	a4,-1(a5)
  74:	fb75                	bnez	a4,68 <strcpy+0x8>
    ;
  return os;
}
  76:	6422                	ld	s0,8(sp)
  78:	0141                	addi	sp,sp,16
  7a:	8082                	ret

000000000000007c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  7c:	1141                	addi	sp,sp,-16
  7e:	e422                	sd	s0,8(sp)
  80:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  82:	00054783          	lbu	a5,0(a0)
  86:	cb91                	beqz	a5,9a <strcmp+0x1e>
  88:	0005c703          	lbu	a4,0(a1)
  8c:	00f71763          	bne	a4,a5,9a <strcmp+0x1e>
    p++, q++;
  90:	0505                	addi	a0,a0,1
  92:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  94:	00054783          	lbu	a5,0(a0)
  98:	fbe5                	bnez	a5,88 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  9a:	0005c503          	lbu	a0,0(a1)
}
  9e:	40a7853b          	subw	a0,a5,a0
  a2:	6422                	ld	s0,8(sp)
  a4:	0141                	addi	sp,sp,16
  a6:	8082                	ret

00000000000000a8 <strlen>:

uint
strlen(const char *s)
{
  a8:	1141                	addi	sp,sp,-16
  aa:	e422                	sd	s0,8(sp)
  ac:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  ae:	00054783          	lbu	a5,0(a0)
  b2:	cf91                	beqz	a5,ce <strlen+0x26>
  b4:	0505                	addi	a0,a0,1
  b6:	87aa                	mv	a5,a0
  b8:	4685                	li	a3,1
  ba:	9e89                	subw	a3,a3,a0
  bc:	00f6853b          	addw	a0,a3,a5
  c0:	0785                	addi	a5,a5,1
  c2:	fff7c703          	lbu	a4,-1(a5)
  c6:	fb7d                	bnez	a4,bc <strlen+0x14>
    ;
  return n;
}
  c8:	6422                	ld	s0,8(sp)
  ca:	0141                	addi	sp,sp,16
  cc:	8082                	ret
  for(n = 0; s[n]; n++)
  ce:	4501                	li	a0,0
  d0:	bfe5                	j	c8 <strlen+0x20>

00000000000000d2 <memset>:

void*
memset(void *dst, int c, uint n)
{
  d2:	1141                	addi	sp,sp,-16
  d4:	e422                	sd	s0,8(sp)
  d6:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  d8:	ce09                	beqz	a2,f2 <memset+0x20>
  da:	87aa                	mv	a5,a0
  dc:	fff6071b          	addiw	a4,a2,-1
  e0:	1702                	slli	a4,a4,0x20
  e2:	9301                	srli	a4,a4,0x20
  e4:	0705                	addi	a4,a4,1
  e6:	972a                	add	a4,a4,a0
    cdst[i] = c;
  e8:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  ec:	0785                	addi	a5,a5,1
  ee:	fee79de3          	bne	a5,a4,e8 <memset+0x16>
  }
  return dst;
}
  f2:	6422                	ld	s0,8(sp)
  f4:	0141                	addi	sp,sp,16
  f6:	8082                	ret

00000000000000f8 <strchr>:

char*
strchr(const char *s, char c)
{
  f8:	1141                	addi	sp,sp,-16
  fa:	e422                	sd	s0,8(sp)
  fc:	0800                	addi	s0,sp,16
  for(; *s; s++)
  fe:	00054783          	lbu	a5,0(a0)
 102:	cb99                	beqz	a5,118 <strchr+0x20>
    if(*s == c)
 104:	00f58763          	beq	a1,a5,112 <strchr+0x1a>
  for(; *s; s++)
 108:	0505                	addi	a0,a0,1
 10a:	00054783          	lbu	a5,0(a0)
 10e:	fbfd                	bnez	a5,104 <strchr+0xc>
      return (char*)s;
  return 0;
 110:	4501                	li	a0,0
}
 112:	6422                	ld	s0,8(sp)
 114:	0141                	addi	sp,sp,16
 116:	8082                	ret
  return 0;
 118:	4501                	li	a0,0
 11a:	bfe5                	j	112 <strchr+0x1a>

000000000000011c <gets>:

char*
gets(char *buf, int max)
{
 11c:	711d                	addi	sp,sp,-96
 11e:	ec86                	sd	ra,88(sp)
 120:	e8a2                	sd	s0,80(sp)
 122:	e4a6                	sd	s1,72(sp)
 124:	e0ca                	sd	s2,64(sp)
 126:	fc4e                	sd	s3,56(sp)
 128:	f852                	sd	s4,48(sp)
 12a:	f456                	sd	s5,40(sp)
 12c:	f05a                	sd	s6,32(sp)
 12e:	ec5e                	sd	s7,24(sp)
 130:	1080                	addi	s0,sp,96
 132:	8baa                	mv	s7,a0
 134:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 136:	892a                	mv	s2,a0
 138:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 13a:	4aa9                	li	s5,10
 13c:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 13e:	89a6                	mv	s3,s1
 140:	2485                	addiw	s1,s1,1
 142:	0344d863          	bge	s1,s4,172 <gets+0x56>
    cc = read(0, &c, 1);
 146:	4605                	li	a2,1
 148:	faf40593          	addi	a1,s0,-81
 14c:	4501                	li	a0,0
 14e:	00000097          	auipc	ra,0x0
 152:	1b6080e7          	jalr	438(ra) # 304 <read>
    if(cc < 1)
 156:	00a05e63          	blez	a0,172 <gets+0x56>
    buf[i++] = c;
 15a:	faf44783          	lbu	a5,-81(s0)
 15e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 162:	01578763          	beq	a5,s5,170 <gets+0x54>
 166:	0905                	addi	s2,s2,1
 168:	fd679be3          	bne	a5,s6,13e <gets+0x22>
  for(i=0; i+1 < max; ){
 16c:	89a6                	mv	s3,s1
 16e:	a011                	j	172 <gets+0x56>
 170:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 172:	99de                	add	s3,s3,s7
 174:	00098023          	sb	zero,0(s3)
  return buf;
}
 178:	855e                	mv	a0,s7
 17a:	60e6                	ld	ra,88(sp)
 17c:	6446                	ld	s0,80(sp)
 17e:	64a6                	ld	s1,72(sp)
 180:	6906                	ld	s2,64(sp)
 182:	79e2                	ld	s3,56(sp)
 184:	7a42                	ld	s4,48(sp)
 186:	7aa2                	ld	s5,40(sp)
 188:	7b02                	ld	s6,32(sp)
 18a:	6be2                	ld	s7,24(sp)
 18c:	6125                	addi	sp,sp,96
 18e:	8082                	ret

0000000000000190 <stat>:

int
stat(const char *n, struct stat *st)
{
 190:	1101                	addi	sp,sp,-32
 192:	ec06                	sd	ra,24(sp)
 194:	e822                	sd	s0,16(sp)
 196:	e426                	sd	s1,8(sp)
 198:	e04a                	sd	s2,0(sp)
 19a:	1000                	addi	s0,sp,32
 19c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 19e:	4581                	li	a1,0
 1a0:	00000097          	auipc	ra,0x0
 1a4:	18c080e7          	jalr	396(ra) # 32c <open>
  if(fd < 0)
 1a8:	02054563          	bltz	a0,1d2 <stat+0x42>
 1ac:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1ae:	85ca                	mv	a1,s2
 1b0:	00000097          	auipc	ra,0x0
 1b4:	194080e7          	jalr	404(ra) # 344 <fstat>
 1b8:	892a                	mv	s2,a0
  close(fd);
 1ba:	8526                	mv	a0,s1
 1bc:	00000097          	auipc	ra,0x0
 1c0:	158080e7          	jalr	344(ra) # 314 <close>
  return r;
}
 1c4:	854a                	mv	a0,s2
 1c6:	60e2                	ld	ra,24(sp)
 1c8:	6442                	ld	s0,16(sp)
 1ca:	64a2                	ld	s1,8(sp)
 1cc:	6902                	ld	s2,0(sp)
 1ce:	6105                	addi	sp,sp,32
 1d0:	8082                	ret
    return -1;
 1d2:	597d                	li	s2,-1
 1d4:	bfc5                	j	1c4 <stat+0x34>

00000000000001d6 <atoi>:

int
atoi(const char *s)
{
 1d6:	1141                	addi	sp,sp,-16
 1d8:	e422                	sd	s0,8(sp)
 1da:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1dc:	00054603          	lbu	a2,0(a0)
 1e0:	fd06079b          	addiw	a5,a2,-48
 1e4:	0ff7f793          	andi	a5,a5,255
 1e8:	4725                	li	a4,9
 1ea:	02f76963          	bltu	a4,a5,21c <atoi+0x46>
 1ee:	86aa                	mv	a3,a0
  n = 0;
 1f0:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 1f2:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 1f4:	0685                	addi	a3,a3,1
 1f6:	0025179b          	slliw	a5,a0,0x2
 1fa:	9fa9                	addw	a5,a5,a0
 1fc:	0017979b          	slliw	a5,a5,0x1
 200:	9fb1                	addw	a5,a5,a2
 202:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 206:	0006c603          	lbu	a2,0(a3)
 20a:	fd06071b          	addiw	a4,a2,-48
 20e:	0ff77713          	andi	a4,a4,255
 212:	fee5f1e3          	bgeu	a1,a4,1f4 <atoi+0x1e>
  return n;
}
 216:	6422                	ld	s0,8(sp)
 218:	0141                	addi	sp,sp,16
 21a:	8082                	ret
  n = 0;
 21c:	4501                	li	a0,0
 21e:	bfe5                	j	216 <atoi+0x40>

0000000000000220 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 220:	1141                	addi	sp,sp,-16
 222:	e422                	sd	s0,8(sp)
 224:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 226:	02b57663          	bgeu	a0,a1,252 <memmove+0x32>
    while(n-- > 0)
 22a:	02c05163          	blez	a2,24c <memmove+0x2c>
 22e:	fff6079b          	addiw	a5,a2,-1
 232:	1782                	slli	a5,a5,0x20
 234:	9381                	srli	a5,a5,0x20
 236:	0785                	addi	a5,a5,1
 238:	97aa                	add	a5,a5,a0
  dst = vdst;
 23a:	872a                	mv	a4,a0
      *dst++ = *src++;
 23c:	0585                	addi	a1,a1,1
 23e:	0705                	addi	a4,a4,1
 240:	fff5c683          	lbu	a3,-1(a1)
 244:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 248:	fee79ae3          	bne	a5,a4,23c <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 24c:	6422                	ld	s0,8(sp)
 24e:	0141                	addi	sp,sp,16
 250:	8082                	ret
    dst += n;
 252:	00c50733          	add	a4,a0,a2
    src += n;
 256:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 258:	fec05ae3          	blez	a2,24c <memmove+0x2c>
 25c:	fff6079b          	addiw	a5,a2,-1
 260:	1782                	slli	a5,a5,0x20
 262:	9381                	srli	a5,a5,0x20
 264:	fff7c793          	not	a5,a5
 268:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 26a:	15fd                	addi	a1,a1,-1
 26c:	177d                	addi	a4,a4,-1
 26e:	0005c683          	lbu	a3,0(a1)
 272:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 276:	fee79ae3          	bne	a5,a4,26a <memmove+0x4a>
 27a:	bfc9                	j	24c <memmove+0x2c>

000000000000027c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 27c:	1141                	addi	sp,sp,-16
 27e:	e422                	sd	s0,8(sp)
 280:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 282:	ca05                	beqz	a2,2b2 <memcmp+0x36>
 284:	fff6069b          	addiw	a3,a2,-1
 288:	1682                	slli	a3,a3,0x20
 28a:	9281                	srli	a3,a3,0x20
 28c:	0685                	addi	a3,a3,1
 28e:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 290:	00054783          	lbu	a5,0(a0)
 294:	0005c703          	lbu	a4,0(a1)
 298:	00e79863          	bne	a5,a4,2a8 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 29c:	0505                	addi	a0,a0,1
    p2++;
 29e:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2a0:	fed518e3          	bne	a0,a3,290 <memcmp+0x14>
  }
  return 0;
 2a4:	4501                	li	a0,0
 2a6:	a019                	j	2ac <memcmp+0x30>
      return *p1 - *p2;
 2a8:	40e7853b          	subw	a0,a5,a4
}
 2ac:	6422                	ld	s0,8(sp)
 2ae:	0141                	addi	sp,sp,16
 2b0:	8082                	ret
  return 0;
 2b2:	4501                	li	a0,0
 2b4:	bfe5                	j	2ac <memcmp+0x30>

00000000000002b6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2b6:	1141                	addi	sp,sp,-16
 2b8:	e406                	sd	ra,8(sp)
 2ba:	e022                	sd	s0,0(sp)
 2bc:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2be:	00000097          	auipc	ra,0x0
 2c2:	f62080e7          	jalr	-158(ra) # 220 <memmove>
}
 2c6:	60a2                	ld	ra,8(sp)
 2c8:	6402                	ld	s0,0(sp)
 2ca:	0141                	addi	sp,sp,16
 2cc:	8082                	ret

00000000000002ce <ugetpid>:

#ifdef LAB_PGTBL
int
ugetpid(void)
{
 2ce:	1141                	addi	sp,sp,-16
 2d0:	e422                	sd	s0,8(sp)
 2d2:	0800                	addi	s0,sp,16
  struct usyscall *u = (struct usyscall *)USYSCALL;
  return u->pid;
 2d4:	040007b7          	lui	a5,0x4000
}
 2d8:	17f5                	addi	a5,a5,-3
 2da:	07b2                	slli	a5,a5,0xc
 2dc:	4388                	lw	a0,0(a5)
 2de:	6422                	ld	s0,8(sp)
 2e0:	0141                	addi	sp,sp,16
 2e2:	8082                	ret

00000000000002e4 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2e4:	4885                	li	a7,1
 ecall
 2e6:	00000073          	ecall
 ret
 2ea:	8082                	ret

00000000000002ec <exit>:
.global exit
exit:
 li a7, SYS_exit
 2ec:	4889                	li	a7,2
 ecall
 2ee:	00000073          	ecall
 ret
 2f2:	8082                	ret

00000000000002f4 <wait>:
.global wait
wait:
 li a7, SYS_wait
 2f4:	488d                	li	a7,3
 ecall
 2f6:	00000073          	ecall
 ret
 2fa:	8082                	ret

00000000000002fc <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2fc:	4891                	li	a7,4
 ecall
 2fe:	00000073          	ecall
 ret
 302:	8082                	ret

0000000000000304 <read>:
.global read
read:
 li a7, SYS_read
 304:	4895                	li	a7,5
 ecall
 306:	00000073          	ecall
 ret
 30a:	8082                	ret

000000000000030c <write>:
.global write
write:
 li a7, SYS_write
 30c:	48c1                	li	a7,16
 ecall
 30e:	00000073          	ecall
 ret
 312:	8082                	ret

0000000000000314 <close>:
.global close
close:
 li a7, SYS_close
 314:	48d5                	li	a7,21
 ecall
 316:	00000073          	ecall
 ret
 31a:	8082                	ret

000000000000031c <kill>:
.global kill
kill:
 li a7, SYS_kill
 31c:	4899                	li	a7,6
 ecall
 31e:	00000073          	ecall
 ret
 322:	8082                	ret

0000000000000324 <exec>:
.global exec
exec:
 li a7, SYS_exec
 324:	489d                	li	a7,7
 ecall
 326:	00000073          	ecall
 ret
 32a:	8082                	ret

000000000000032c <open>:
.global open
open:
 li a7, SYS_open
 32c:	48bd                	li	a7,15
 ecall
 32e:	00000073          	ecall
 ret
 332:	8082                	ret

0000000000000334 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 334:	48c5                	li	a7,17
 ecall
 336:	00000073          	ecall
 ret
 33a:	8082                	ret

000000000000033c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 33c:	48c9                	li	a7,18
 ecall
 33e:	00000073          	ecall
 ret
 342:	8082                	ret

0000000000000344 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 344:	48a1                	li	a7,8
 ecall
 346:	00000073          	ecall
 ret
 34a:	8082                	ret

000000000000034c <link>:
.global link
link:
 li a7, SYS_link
 34c:	48cd                	li	a7,19
 ecall
 34e:	00000073          	ecall
 ret
 352:	8082                	ret

0000000000000354 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 354:	48d1                	li	a7,20
 ecall
 356:	00000073          	ecall
 ret
 35a:	8082                	ret

000000000000035c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 35c:	48a5                	li	a7,9
 ecall
 35e:	00000073          	ecall
 ret
 362:	8082                	ret

0000000000000364 <dup>:
.global dup
dup:
 li a7, SYS_dup
 364:	48a9                	li	a7,10
 ecall
 366:	00000073          	ecall
 ret
 36a:	8082                	ret

000000000000036c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 36c:	48ad                	li	a7,11
 ecall
 36e:	00000073          	ecall
 ret
 372:	8082                	ret

0000000000000374 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 374:	48b1                	li	a7,12
 ecall
 376:	00000073          	ecall
 ret
 37a:	8082                	ret

000000000000037c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 37c:	48b5                	li	a7,13
 ecall
 37e:	00000073          	ecall
 ret
 382:	8082                	ret

0000000000000384 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 384:	48b9                	li	a7,14
 ecall
 386:	00000073          	ecall
 ret
 38a:	8082                	ret

000000000000038c <connect>:
.global connect
connect:
 li a7, SYS_connect
 38c:	48f5                	li	a7,29
 ecall
 38e:	00000073          	ecall
 ret
 392:	8082                	ret

0000000000000394 <pgaccess>:
.global pgaccess
pgaccess:
 li a7, SYS_pgaccess
 394:	48f9                	li	a7,30
 ecall
 396:	00000073          	ecall
 ret
 39a:	8082                	ret

000000000000039c <vmprint>:
.global vmprint
vmprint:
 li a7, SYS_vmprint
 39c:	48fd                	li	a7,31
 ecall
 39e:	00000073          	ecall
 ret
 3a2:	8082                	ret

00000000000003a4 <madvise>:
.global madvise
madvise:
 li a7, SYS_madvise
 3a4:	02000893          	li	a7,32
 ecall
 3a8:	00000073          	ecall
 ret
 3ac:	8082                	ret

00000000000003ae <pgprint>:
.global pgprint
pgprint:
 li a7, SYS_pgprint
 3ae:	02100893          	li	a7,33
 ecall
 3b2:	00000073          	ecall
 ret
 3b6:	8082                	ret

00000000000003b8 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3b8:	1101                	addi	sp,sp,-32
 3ba:	ec06                	sd	ra,24(sp)
 3bc:	e822                	sd	s0,16(sp)
 3be:	1000                	addi	s0,sp,32
 3c0:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3c4:	4605                	li	a2,1
 3c6:	fef40593          	addi	a1,s0,-17
 3ca:	00000097          	auipc	ra,0x0
 3ce:	f42080e7          	jalr	-190(ra) # 30c <write>
}
 3d2:	60e2                	ld	ra,24(sp)
 3d4:	6442                	ld	s0,16(sp)
 3d6:	6105                	addi	sp,sp,32
 3d8:	8082                	ret

00000000000003da <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3da:	7139                	addi	sp,sp,-64
 3dc:	fc06                	sd	ra,56(sp)
 3de:	f822                	sd	s0,48(sp)
 3e0:	f426                	sd	s1,40(sp)
 3e2:	f04a                	sd	s2,32(sp)
 3e4:	ec4e                	sd	s3,24(sp)
 3e6:	0080                	addi	s0,sp,64
 3e8:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3ea:	c299                	beqz	a3,3f0 <printint+0x16>
 3ec:	0805c863          	bltz	a1,47c <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3f0:	2581                	sext.w	a1,a1
  neg = 0;
 3f2:	4881                	li	a7,0
 3f4:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 3f8:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3fa:	2601                	sext.w	a2,a2
 3fc:	00000517          	auipc	a0,0x0
 400:	47450513          	addi	a0,a0,1140 # 870 <digits>
 404:	883a                	mv	a6,a4
 406:	2705                	addiw	a4,a4,1
 408:	02c5f7bb          	remuw	a5,a1,a2
 40c:	1782                	slli	a5,a5,0x20
 40e:	9381                	srli	a5,a5,0x20
 410:	97aa                	add	a5,a5,a0
 412:	0007c783          	lbu	a5,0(a5) # 4000000 <__global_pointer$+0x3ffef7f>
 416:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 41a:	0005879b          	sext.w	a5,a1
 41e:	02c5d5bb          	divuw	a1,a1,a2
 422:	0685                	addi	a3,a3,1
 424:	fec7f0e3          	bgeu	a5,a2,404 <printint+0x2a>
  if(neg)
 428:	00088b63          	beqz	a7,43e <printint+0x64>
    buf[i++] = '-';
 42c:	fd040793          	addi	a5,s0,-48
 430:	973e                	add	a4,a4,a5
 432:	02d00793          	li	a5,45
 436:	fef70823          	sb	a5,-16(a4)
 43a:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 43e:	02e05863          	blez	a4,46e <printint+0x94>
 442:	fc040793          	addi	a5,s0,-64
 446:	00e78933          	add	s2,a5,a4
 44a:	fff78993          	addi	s3,a5,-1
 44e:	99ba                	add	s3,s3,a4
 450:	377d                	addiw	a4,a4,-1
 452:	1702                	slli	a4,a4,0x20
 454:	9301                	srli	a4,a4,0x20
 456:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 45a:	fff94583          	lbu	a1,-1(s2)
 45e:	8526                	mv	a0,s1
 460:	00000097          	auipc	ra,0x0
 464:	f58080e7          	jalr	-168(ra) # 3b8 <putc>
  while(--i >= 0)
 468:	197d                	addi	s2,s2,-1
 46a:	ff3918e3          	bne	s2,s3,45a <printint+0x80>
}
 46e:	70e2                	ld	ra,56(sp)
 470:	7442                	ld	s0,48(sp)
 472:	74a2                	ld	s1,40(sp)
 474:	7902                	ld	s2,32(sp)
 476:	69e2                	ld	s3,24(sp)
 478:	6121                	addi	sp,sp,64
 47a:	8082                	ret
    x = -xx;
 47c:	40b005bb          	negw	a1,a1
    neg = 1;
 480:	4885                	li	a7,1
    x = -xx;
 482:	bf8d                	j	3f4 <printint+0x1a>

0000000000000484 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 484:	7119                	addi	sp,sp,-128
 486:	fc86                	sd	ra,120(sp)
 488:	f8a2                	sd	s0,112(sp)
 48a:	f4a6                	sd	s1,104(sp)
 48c:	f0ca                	sd	s2,96(sp)
 48e:	ecce                	sd	s3,88(sp)
 490:	e8d2                	sd	s4,80(sp)
 492:	e4d6                	sd	s5,72(sp)
 494:	e0da                	sd	s6,64(sp)
 496:	fc5e                	sd	s7,56(sp)
 498:	f862                	sd	s8,48(sp)
 49a:	f466                	sd	s9,40(sp)
 49c:	f06a                	sd	s10,32(sp)
 49e:	ec6e                	sd	s11,24(sp)
 4a0:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4a2:	0005c903          	lbu	s2,0(a1)
 4a6:	18090f63          	beqz	s2,644 <vprintf+0x1c0>
 4aa:	8aaa                	mv	s5,a0
 4ac:	8b32                	mv	s6,a2
 4ae:	00158493          	addi	s1,a1,1
  state = 0;
 4b2:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4b4:	02500a13          	li	s4,37
      if(c == 'd'){
 4b8:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 4bc:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 4c0:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 4c4:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 4c8:	00000b97          	auipc	s7,0x0
 4cc:	3a8b8b93          	addi	s7,s7,936 # 870 <digits>
 4d0:	a839                	j	4ee <vprintf+0x6a>
        putc(fd, c);
 4d2:	85ca                	mv	a1,s2
 4d4:	8556                	mv	a0,s5
 4d6:	00000097          	auipc	ra,0x0
 4da:	ee2080e7          	jalr	-286(ra) # 3b8 <putc>
 4de:	a019                	j	4e4 <vprintf+0x60>
    } else if(state == '%'){
 4e0:	01498f63          	beq	s3,s4,4fe <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 4e4:	0485                	addi	s1,s1,1
 4e6:	fff4c903          	lbu	s2,-1(s1)
 4ea:	14090d63          	beqz	s2,644 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 4ee:	0009079b          	sext.w	a5,s2
    if(state == 0){
 4f2:	fe0997e3          	bnez	s3,4e0 <vprintf+0x5c>
      if(c == '%'){
 4f6:	fd479ee3          	bne	a5,s4,4d2 <vprintf+0x4e>
        state = '%';
 4fa:	89be                	mv	s3,a5
 4fc:	b7e5                	j	4e4 <vprintf+0x60>
      if(c == 'd'){
 4fe:	05878063          	beq	a5,s8,53e <vprintf+0xba>
      } else if(c == 'l') {
 502:	05978c63          	beq	a5,s9,55a <vprintf+0xd6>
      } else if(c == 'x') {
 506:	07a78863          	beq	a5,s10,576 <vprintf+0xf2>
      } else if(c == 'p') {
 50a:	09b78463          	beq	a5,s11,592 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 50e:	07300713          	li	a4,115
 512:	0ce78663          	beq	a5,a4,5de <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 516:	06300713          	li	a4,99
 51a:	0ee78e63          	beq	a5,a4,616 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 51e:	11478863          	beq	a5,s4,62e <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 522:	85d2                	mv	a1,s4
 524:	8556                	mv	a0,s5
 526:	00000097          	auipc	ra,0x0
 52a:	e92080e7          	jalr	-366(ra) # 3b8 <putc>
        putc(fd, c);
 52e:	85ca                	mv	a1,s2
 530:	8556                	mv	a0,s5
 532:	00000097          	auipc	ra,0x0
 536:	e86080e7          	jalr	-378(ra) # 3b8 <putc>
      }
      state = 0;
 53a:	4981                	li	s3,0
 53c:	b765                	j	4e4 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 53e:	008b0913          	addi	s2,s6,8
 542:	4685                	li	a3,1
 544:	4629                	li	a2,10
 546:	000b2583          	lw	a1,0(s6)
 54a:	8556                	mv	a0,s5
 54c:	00000097          	auipc	ra,0x0
 550:	e8e080e7          	jalr	-370(ra) # 3da <printint>
 554:	8b4a                	mv	s6,s2
      state = 0;
 556:	4981                	li	s3,0
 558:	b771                	j	4e4 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 55a:	008b0913          	addi	s2,s6,8
 55e:	4681                	li	a3,0
 560:	4629                	li	a2,10
 562:	000b2583          	lw	a1,0(s6)
 566:	8556                	mv	a0,s5
 568:	00000097          	auipc	ra,0x0
 56c:	e72080e7          	jalr	-398(ra) # 3da <printint>
 570:	8b4a                	mv	s6,s2
      state = 0;
 572:	4981                	li	s3,0
 574:	bf85                	j	4e4 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 576:	008b0913          	addi	s2,s6,8
 57a:	4681                	li	a3,0
 57c:	4641                	li	a2,16
 57e:	000b2583          	lw	a1,0(s6)
 582:	8556                	mv	a0,s5
 584:	00000097          	auipc	ra,0x0
 588:	e56080e7          	jalr	-426(ra) # 3da <printint>
 58c:	8b4a                	mv	s6,s2
      state = 0;
 58e:	4981                	li	s3,0
 590:	bf91                	j	4e4 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 592:	008b0793          	addi	a5,s6,8
 596:	f8f43423          	sd	a5,-120(s0)
 59a:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 59e:	03000593          	li	a1,48
 5a2:	8556                	mv	a0,s5
 5a4:	00000097          	auipc	ra,0x0
 5a8:	e14080e7          	jalr	-492(ra) # 3b8 <putc>
  putc(fd, 'x');
 5ac:	85ea                	mv	a1,s10
 5ae:	8556                	mv	a0,s5
 5b0:	00000097          	auipc	ra,0x0
 5b4:	e08080e7          	jalr	-504(ra) # 3b8 <putc>
 5b8:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5ba:	03c9d793          	srli	a5,s3,0x3c
 5be:	97de                	add	a5,a5,s7
 5c0:	0007c583          	lbu	a1,0(a5)
 5c4:	8556                	mv	a0,s5
 5c6:	00000097          	auipc	ra,0x0
 5ca:	df2080e7          	jalr	-526(ra) # 3b8 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5ce:	0992                	slli	s3,s3,0x4
 5d0:	397d                	addiw	s2,s2,-1
 5d2:	fe0914e3          	bnez	s2,5ba <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 5d6:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 5da:	4981                	li	s3,0
 5dc:	b721                	j	4e4 <vprintf+0x60>
        s = va_arg(ap, char*);
 5de:	008b0993          	addi	s3,s6,8
 5e2:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 5e6:	02090163          	beqz	s2,608 <vprintf+0x184>
        while(*s != 0){
 5ea:	00094583          	lbu	a1,0(s2)
 5ee:	c9a1                	beqz	a1,63e <vprintf+0x1ba>
          putc(fd, *s);
 5f0:	8556                	mv	a0,s5
 5f2:	00000097          	auipc	ra,0x0
 5f6:	dc6080e7          	jalr	-570(ra) # 3b8 <putc>
          s++;
 5fa:	0905                	addi	s2,s2,1
        while(*s != 0){
 5fc:	00094583          	lbu	a1,0(s2)
 600:	f9e5                	bnez	a1,5f0 <vprintf+0x16c>
        s = va_arg(ap, char*);
 602:	8b4e                	mv	s6,s3
      state = 0;
 604:	4981                	li	s3,0
 606:	bdf9                	j	4e4 <vprintf+0x60>
          s = "(null)";
 608:	00000917          	auipc	s2,0x0
 60c:	26090913          	addi	s2,s2,608 # 868 <malloc+0x11a>
        while(*s != 0){
 610:	02800593          	li	a1,40
 614:	bff1                	j	5f0 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 616:	008b0913          	addi	s2,s6,8
 61a:	000b4583          	lbu	a1,0(s6)
 61e:	8556                	mv	a0,s5
 620:	00000097          	auipc	ra,0x0
 624:	d98080e7          	jalr	-616(ra) # 3b8 <putc>
 628:	8b4a                	mv	s6,s2
      state = 0;
 62a:	4981                	li	s3,0
 62c:	bd65                	j	4e4 <vprintf+0x60>
        putc(fd, c);
 62e:	85d2                	mv	a1,s4
 630:	8556                	mv	a0,s5
 632:	00000097          	auipc	ra,0x0
 636:	d86080e7          	jalr	-634(ra) # 3b8 <putc>
      state = 0;
 63a:	4981                	li	s3,0
 63c:	b565                	j	4e4 <vprintf+0x60>
        s = va_arg(ap, char*);
 63e:	8b4e                	mv	s6,s3
      state = 0;
 640:	4981                	li	s3,0
 642:	b54d                	j	4e4 <vprintf+0x60>
    }
  }
}
 644:	70e6                	ld	ra,120(sp)
 646:	7446                	ld	s0,112(sp)
 648:	74a6                	ld	s1,104(sp)
 64a:	7906                	ld	s2,96(sp)
 64c:	69e6                	ld	s3,88(sp)
 64e:	6a46                	ld	s4,80(sp)
 650:	6aa6                	ld	s5,72(sp)
 652:	6b06                	ld	s6,64(sp)
 654:	7be2                	ld	s7,56(sp)
 656:	7c42                	ld	s8,48(sp)
 658:	7ca2                	ld	s9,40(sp)
 65a:	7d02                	ld	s10,32(sp)
 65c:	6de2                	ld	s11,24(sp)
 65e:	6109                	addi	sp,sp,128
 660:	8082                	ret

0000000000000662 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 662:	715d                	addi	sp,sp,-80
 664:	ec06                	sd	ra,24(sp)
 666:	e822                	sd	s0,16(sp)
 668:	1000                	addi	s0,sp,32
 66a:	e010                	sd	a2,0(s0)
 66c:	e414                	sd	a3,8(s0)
 66e:	e818                	sd	a4,16(s0)
 670:	ec1c                	sd	a5,24(s0)
 672:	03043023          	sd	a6,32(s0)
 676:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 67a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 67e:	8622                	mv	a2,s0
 680:	00000097          	auipc	ra,0x0
 684:	e04080e7          	jalr	-508(ra) # 484 <vprintf>
}
 688:	60e2                	ld	ra,24(sp)
 68a:	6442                	ld	s0,16(sp)
 68c:	6161                	addi	sp,sp,80
 68e:	8082                	ret

0000000000000690 <printf>:

void
printf(const char *fmt, ...)
{
 690:	711d                	addi	sp,sp,-96
 692:	ec06                	sd	ra,24(sp)
 694:	e822                	sd	s0,16(sp)
 696:	1000                	addi	s0,sp,32
 698:	e40c                	sd	a1,8(s0)
 69a:	e810                	sd	a2,16(s0)
 69c:	ec14                	sd	a3,24(s0)
 69e:	f018                	sd	a4,32(s0)
 6a0:	f41c                	sd	a5,40(s0)
 6a2:	03043823          	sd	a6,48(s0)
 6a6:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6aa:	00840613          	addi	a2,s0,8
 6ae:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6b2:	85aa                	mv	a1,a0
 6b4:	4505                	li	a0,1
 6b6:	00000097          	auipc	ra,0x0
 6ba:	dce080e7          	jalr	-562(ra) # 484 <vprintf>
}
 6be:	60e2                	ld	ra,24(sp)
 6c0:	6442                	ld	s0,16(sp)
 6c2:	6125                	addi	sp,sp,96
 6c4:	8082                	ret

00000000000006c6 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6c6:	1141                	addi	sp,sp,-16
 6c8:	e422                	sd	s0,8(sp)
 6ca:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6cc:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6d0:	00000797          	auipc	a5,0x0
 6d4:	1b87b783          	ld	a5,440(a5) # 888 <freep>
 6d8:	a805                	j	708 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6da:	4618                	lw	a4,8(a2)
 6dc:	9db9                	addw	a1,a1,a4
 6de:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 6e2:	6398                	ld	a4,0(a5)
 6e4:	6318                	ld	a4,0(a4)
 6e6:	fee53823          	sd	a4,-16(a0)
 6ea:	a091                	j	72e <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 6ec:	ff852703          	lw	a4,-8(a0)
 6f0:	9e39                	addw	a2,a2,a4
 6f2:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 6f4:	ff053703          	ld	a4,-16(a0)
 6f8:	e398                	sd	a4,0(a5)
 6fa:	a099                	j	740 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6fc:	6398                	ld	a4,0(a5)
 6fe:	00e7e463          	bltu	a5,a4,706 <free+0x40>
 702:	00e6ea63          	bltu	a3,a4,716 <free+0x50>
{
 706:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 708:	fed7fae3          	bgeu	a5,a3,6fc <free+0x36>
 70c:	6398                	ld	a4,0(a5)
 70e:	00e6e463          	bltu	a3,a4,716 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 712:	fee7eae3          	bltu	a5,a4,706 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 716:	ff852583          	lw	a1,-8(a0)
 71a:	6390                	ld	a2,0(a5)
 71c:	02059713          	slli	a4,a1,0x20
 720:	9301                	srli	a4,a4,0x20
 722:	0712                	slli	a4,a4,0x4
 724:	9736                	add	a4,a4,a3
 726:	fae60ae3          	beq	a2,a4,6da <free+0x14>
    bp->s.ptr = p->s.ptr;
 72a:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 72e:	4790                	lw	a2,8(a5)
 730:	02061713          	slli	a4,a2,0x20
 734:	9301                	srli	a4,a4,0x20
 736:	0712                	slli	a4,a4,0x4
 738:	973e                	add	a4,a4,a5
 73a:	fae689e3          	beq	a3,a4,6ec <free+0x26>
  } else
    p->s.ptr = bp;
 73e:	e394                	sd	a3,0(a5)
  freep = p;
 740:	00000717          	auipc	a4,0x0
 744:	14f73423          	sd	a5,328(a4) # 888 <freep>
}
 748:	6422                	ld	s0,8(sp)
 74a:	0141                	addi	sp,sp,16
 74c:	8082                	ret

000000000000074e <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 74e:	7139                	addi	sp,sp,-64
 750:	fc06                	sd	ra,56(sp)
 752:	f822                	sd	s0,48(sp)
 754:	f426                	sd	s1,40(sp)
 756:	f04a                	sd	s2,32(sp)
 758:	ec4e                	sd	s3,24(sp)
 75a:	e852                	sd	s4,16(sp)
 75c:	e456                	sd	s5,8(sp)
 75e:	e05a                	sd	s6,0(sp)
 760:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 762:	02051493          	slli	s1,a0,0x20
 766:	9081                	srli	s1,s1,0x20
 768:	04bd                	addi	s1,s1,15
 76a:	8091                	srli	s1,s1,0x4
 76c:	0014899b          	addiw	s3,s1,1
 770:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 772:	00000797          	auipc	a5,0x0
 776:	1167b783          	ld	a5,278(a5) # 888 <freep>
 77a:	c795                	beqz	a5,7a6 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 77c:	6388                	ld	a0,0(a5)
    if(p->s.size >= nunits){
 77e:	4518                	lw	a4,8(a0)
 780:	02977f63          	bgeu	a4,s1,7be <malloc+0x70>
 784:	8a4e                	mv	s4,s3
 786:	0009879b          	sext.w	a5,s3
 78a:	6705                	lui	a4,0x1
 78c:	00e7f363          	bgeu	a5,a4,792 <malloc+0x44>
 790:	6a05                	lui	s4,0x1
 792:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 796:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p);
    }
    if(p == freep)
 79a:	00000917          	auipc	s2,0x0
 79e:	0ee90913          	addi	s2,s2,238 # 888 <freep>
  if(p == (char*)-1)
 7a2:	5afd                	li	s5,-1
 7a4:	a0bd                	j	812 <malloc+0xc4>
    base.s.ptr = freep = prevp = &base;
 7a6:	00000517          	auipc	a0,0x0
 7aa:	0ea50513          	addi	a0,a0,234 # 890 <base>
 7ae:	00000797          	auipc	a5,0x0
 7b2:	0ca7bd23          	sd	a0,218(a5) # 888 <freep>
 7b6:	e108                	sd	a0,0(a0)
    base.s.size = 0;
 7b8:	00052423          	sw	zero,8(a0)
    if(p->s.size >= nunits){
 7bc:	b7e1                	j	784 <malloc+0x36>
      if(p->s.size == nunits)
 7be:	02e48963          	beq	s1,a4,7f0 <malloc+0xa2>
        p->s.size -= nunits;
 7c2:	4137073b          	subw	a4,a4,s3
 7c6:	c518                	sw	a4,8(a0)
        p += p->s.size;
 7c8:	1702                	slli	a4,a4,0x20
 7ca:	9301                	srli	a4,a4,0x20
 7cc:	0712                	slli	a4,a4,0x4
 7ce:	953a                	add	a0,a0,a4
        p->s.size = nunits;
 7d0:	01352423          	sw	s3,8(a0)
      freep = prevp;
 7d4:	00000717          	auipc	a4,0x0
 7d8:	0af73a23          	sd	a5,180(a4) # 888 <freep>
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 7dc:	70e2                	ld	ra,56(sp)
 7de:	7442                	ld	s0,48(sp)
 7e0:	74a2                	ld	s1,40(sp)
 7e2:	7902                	ld	s2,32(sp)
 7e4:	69e2                	ld	s3,24(sp)
 7e6:	6a42                	ld	s4,16(sp)
 7e8:	6aa2                	ld	s5,8(sp)
 7ea:	6b02                	ld	s6,0(sp)
 7ec:	6121                	addi	sp,sp,64
 7ee:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 7f0:	6118                	ld	a4,0(a0)
 7f2:	e398                	sd	a4,0(a5)
 7f4:	b7c5                	j	7d4 <malloc+0x86>
  hp->s.size = nu;
 7f6:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 7fa:	0541                	addi	a0,a0,16
 7fc:	00000097          	auipc	ra,0x0
 800:	eca080e7          	jalr	-310(ra) # 6c6 <free>
  return freep;
 804:	00093783          	ld	a5,0(s2)
      if((p = morecore(nunits)) == 0)
 808:	c39d                	beqz	a5,82e <malloc+0xe0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 80a:	6388                	ld	a0,0(a5)
    if(p->s.size >= nunits){
 80c:	4518                	lw	a4,8(a0)
 80e:	fa9778e3          	bgeu	a4,s1,7be <malloc+0x70>
    if(p == freep)
 812:	00093703          	ld	a4,0(s2)
 816:	87aa                	mv	a5,a0
 818:	fea719e3          	bne	a4,a0,80a <malloc+0xbc>
  p = sbrk(nu * sizeof(Header));
 81c:	8552                	mv	a0,s4
 81e:	00000097          	auipc	ra,0x0
 822:	b56080e7          	jalr	-1194(ra) # 374 <sbrk>
  if(p == (char*)-1)
 826:	fd5518e3          	bne	a0,s5,7f6 <malloc+0xa8>
        return 0;
 82a:	4501                	li	a0,0
 82c:	bf45                	j	7dc <malloc+0x8e>
 82e:	853e                	mv	a0,a5
 830:	b775                	j	7dc <malloc+0x8e>
