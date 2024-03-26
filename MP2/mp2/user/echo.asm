
user/_echo:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	e052                	sd	s4,0(sp)
   e:	1800                	addi	s0,sp,48
  int i;

  for(i = 1; i < argc; i++){
  10:	4785                	li	a5,1
  12:	06a7d463          	bge	a5,a0,7a <main+0x7a>
  16:	00858493          	addi	s1,a1,8
  1a:	ffe5099b          	addiw	s3,a0,-2
  1e:	1982                	slli	s3,s3,0x20
  20:	0209d993          	srli	s3,s3,0x20
  24:	098e                	slli	s3,s3,0x3
  26:	05c1                	addi	a1,a1,16
  28:	99ae                	add	s3,s3,a1
    write(1, argv[i], strlen(argv[i]));
    if(i + 1 < argc){
      write(1, " ", 1);
  2a:	00001a17          	auipc	s4,0x1
  2e:	82ea0a13          	addi	s4,s4,-2002 # 858 <malloc+0xe6>
    write(1, argv[i], strlen(argv[i]));
  32:	0004b903          	ld	s2,0(s1)
  36:	854a                	mv	a0,s2
  38:	00000097          	auipc	ra,0x0
  3c:	094080e7          	jalr	148(ra) # cc <strlen>
  40:	0005061b          	sext.w	a2,a0
  44:	85ca                	mv	a1,s2
  46:	4505                	li	a0,1
  48:	00000097          	auipc	ra,0x0
  4c:	2e8080e7          	jalr	744(ra) # 330 <write>
    if(i + 1 < argc){
  50:	04a1                	addi	s1,s1,8
  52:	01348a63          	beq	s1,s3,66 <main+0x66>
      write(1, " ", 1);
  56:	4605                	li	a2,1
  58:	85d2                	mv	a1,s4
  5a:	4505                	li	a0,1
  5c:	00000097          	auipc	ra,0x0
  60:	2d4080e7          	jalr	724(ra) # 330 <write>
  for(i = 1; i < argc; i++){
  64:	b7f9                	j	32 <main+0x32>
    } else {
      write(1, "\n", 1);
  66:	4605                	li	a2,1
  68:	00000597          	auipc	a1,0x0
  6c:	7f858593          	addi	a1,a1,2040 # 860 <malloc+0xee>
  70:	4505                	li	a0,1
  72:	00000097          	auipc	ra,0x0
  76:	2be080e7          	jalr	702(ra) # 330 <write>
    }
  }
  exit(0);
  7a:	4501                	li	a0,0
  7c:	00000097          	auipc	ra,0x0
  80:	294080e7          	jalr	660(ra) # 310 <exit>

0000000000000084 <strcpy>:



char*
strcpy(char *s, const char *t)
{
  84:	1141                	addi	sp,sp,-16
  86:	e422                	sd	s0,8(sp)
  88:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  8a:	87aa                	mv	a5,a0
  8c:	0585                	addi	a1,a1,1
  8e:	0785                	addi	a5,a5,1
  90:	fff5c703          	lbu	a4,-1(a1)
  94:	fee78fa3          	sb	a4,-1(a5)
  98:	fb75                	bnez	a4,8c <strcpy+0x8>
    ;
  return os;
}
  9a:	6422                	ld	s0,8(sp)
  9c:	0141                	addi	sp,sp,16
  9e:	8082                	ret

00000000000000a0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  a0:	1141                	addi	sp,sp,-16
  a2:	e422                	sd	s0,8(sp)
  a4:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  a6:	00054783          	lbu	a5,0(a0)
  aa:	cb91                	beqz	a5,be <strcmp+0x1e>
  ac:	0005c703          	lbu	a4,0(a1)
  b0:	00f71763          	bne	a4,a5,be <strcmp+0x1e>
    p++, q++;
  b4:	0505                	addi	a0,a0,1
  b6:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  b8:	00054783          	lbu	a5,0(a0)
  bc:	fbe5                	bnez	a5,ac <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  be:	0005c503          	lbu	a0,0(a1)
}
  c2:	40a7853b          	subw	a0,a5,a0
  c6:	6422                	ld	s0,8(sp)
  c8:	0141                	addi	sp,sp,16
  ca:	8082                	ret

00000000000000cc <strlen>:

uint
strlen(const char *s)
{
  cc:	1141                	addi	sp,sp,-16
  ce:	e422                	sd	s0,8(sp)
  d0:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  d2:	00054783          	lbu	a5,0(a0)
  d6:	cf91                	beqz	a5,f2 <strlen+0x26>
  d8:	0505                	addi	a0,a0,1
  da:	87aa                	mv	a5,a0
  dc:	4685                	li	a3,1
  de:	9e89                	subw	a3,a3,a0
  e0:	00f6853b          	addw	a0,a3,a5
  e4:	0785                	addi	a5,a5,1
  e6:	fff7c703          	lbu	a4,-1(a5)
  ea:	fb7d                	bnez	a4,e0 <strlen+0x14>
    ;
  return n;
}
  ec:	6422                	ld	s0,8(sp)
  ee:	0141                	addi	sp,sp,16
  f0:	8082                	ret
  for(n = 0; s[n]; n++)
  f2:	4501                	li	a0,0
  f4:	bfe5                	j	ec <strlen+0x20>

00000000000000f6 <memset>:

void*
memset(void *dst, int c, uint n)
{
  f6:	1141                	addi	sp,sp,-16
  f8:	e422                	sd	s0,8(sp)
  fa:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  fc:	ce09                	beqz	a2,116 <memset+0x20>
  fe:	87aa                	mv	a5,a0
 100:	fff6071b          	addiw	a4,a2,-1
 104:	1702                	slli	a4,a4,0x20
 106:	9301                	srli	a4,a4,0x20
 108:	0705                	addi	a4,a4,1
 10a:	972a                	add	a4,a4,a0
    cdst[i] = c;
 10c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 110:	0785                	addi	a5,a5,1
 112:	fee79de3          	bne	a5,a4,10c <memset+0x16>
  }
  return dst;
}
 116:	6422                	ld	s0,8(sp)
 118:	0141                	addi	sp,sp,16
 11a:	8082                	ret

000000000000011c <strchr>:

char*
strchr(const char *s, char c)
{
 11c:	1141                	addi	sp,sp,-16
 11e:	e422                	sd	s0,8(sp)
 120:	0800                	addi	s0,sp,16
  for(; *s; s++)
 122:	00054783          	lbu	a5,0(a0)
 126:	cb99                	beqz	a5,13c <strchr+0x20>
    if(*s == c)
 128:	00f58763          	beq	a1,a5,136 <strchr+0x1a>
  for(; *s; s++)
 12c:	0505                	addi	a0,a0,1
 12e:	00054783          	lbu	a5,0(a0)
 132:	fbfd                	bnez	a5,128 <strchr+0xc>
      return (char*)s;
  return 0;
 134:	4501                	li	a0,0
}
 136:	6422                	ld	s0,8(sp)
 138:	0141                	addi	sp,sp,16
 13a:	8082                	ret
  return 0;
 13c:	4501                	li	a0,0
 13e:	bfe5                	j	136 <strchr+0x1a>

0000000000000140 <gets>:

char*
gets(char *buf, int max)
{
 140:	711d                	addi	sp,sp,-96
 142:	ec86                	sd	ra,88(sp)
 144:	e8a2                	sd	s0,80(sp)
 146:	e4a6                	sd	s1,72(sp)
 148:	e0ca                	sd	s2,64(sp)
 14a:	fc4e                	sd	s3,56(sp)
 14c:	f852                	sd	s4,48(sp)
 14e:	f456                	sd	s5,40(sp)
 150:	f05a                	sd	s6,32(sp)
 152:	ec5e                	sd	s7,24(sp)
 154:	1080                	addi	s0,sp,96
 156:	8baa                	mv	s7,a0
 158:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 15a:	892a                	mv	s2,a0
 15c:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 15e:	4aa9                	li	s5,10
 160:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 162:	89a6                	mv	s3,s1
 164:	2485                	addiw	s1,s1,1
 166:	0344d863          	bge	s1,s4,196 <gets+0x56>
    cc = read(0, &c, 1);
 16a:	4605                	li	a2,1
 16c:	faf40593          	addi	a1,s0,-81
 170:	4501                	li	a0,0
 172:	00000097          	auipc	ra,0x0
 176:	1b6080e7          	jalr	438(ra) # 328 <read>
    if(cc < 1)
 17a:	00a05e63          	blez	a0,196 <gets+0x56>
    buf[i++] = c;
 17e:	faf44783          	lbu	a5,-81(s0)
 182:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 186:	01578763          	beq	a5,s5,194 <gets+0x54>
 18a:	0905                	addi	s2,s2,1
 18c:	fd679be3          	bne	a5,s6,162 <gets+0x22>
  for(i=0; i+1 < max; ){
 190:	89a6                	mv	s3,s1
 192:	a011                	j	196 <gets+0x56>
 194:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 196:	99de                	add	s3,s3,s7
 198:	00098023          	sb	zero,0(s3)
  return buf;
}
 19c:	855e                	mv	a0,s7
 19e:	60e6                	ld	ra,88(sp)
 1a0:	6446                	ld	s0,80(sp)
 1a2:	64a6                	ld	s1,72(sp)
 1a4:	6906                	ld	s2,64(sp)
 1a6:	79e2                	ld	s3,56(sp)
 1a8:	7a42                	ld	s4,48(sp)
 1aa:	7aa2                	ld	s5,40(sp)
 1ac:	7b02                	ld	s6,32(sp)
 1ae:	6be2                	ld	s7,24(sp)
 1b0:	6125                	addi	sp,sp,96
 1b2:	8082                	ret

00000000000001b4 <stat>:

int
stat(const char *n, struct stat *st)
{
 1b4:	1101                	addi	sp,sp,-32
 1b6:	ec06                	sd	ra,24(sp)
 1b8:	e822                	sd	s0,16(sp)
 1ba:	e426                	sd	s1,8(sp)
 1bc:	e04a                	sd	s2,0(sp)
 1be:	1000                	addi	s0,sp,32
 1c0:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1c2:	4581                	li	a1,0
 1c4:	00000097          	auipc	ra,0x0
 1c8:	18c080e7          	jalr	396(ra) # 350 <open>
  if(fd < 0)
 1cc:	02054563          	bltz	a0,1f6 <stat+0x42>
 1d0:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1d2:	85ca                	mv	a1,s2
 1d4:	00000097          	auipc	ra,0x0
 1d8:	194080e7          	jalr	404(ra) # 368 <fstat>
 1dc:	892a                	mv	s2,a0
  close(fd);
 1de:	8526                	mv	a0,s1
 1e0:	00000097          	auipc	ra,0x0
 1e4:	158080e7          	jalr	344(ra) # 338 <close>
  return r;
}
 1e8:	854a                	mv	a0,s2
 1ea:	60e2                	ld	ra,24(sp)
 1ec:	6442                	ld	s0,16(sp)
 1ee:	64a2                	ld	s1,8(sp)
 1f0:	6902                	ld	s2,0(sp)
 1f2:	6105                	addi	sp,sp,32
 1f4:	8082                	ret
    return -1;
 1f6:	597d                	li	s2,-1
 1f8:	bfc5                	j	1e8 <stat+0x34>

00000000000001fa <atoi>:

int
atoi(const char *s)
{
 1fa:	1141                	addi	sp,sp,-16
 1fc:	e422                	sd	s0,8(sp)
 1fe:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 200:	00054603          	lbu	a2,0(a0)
 204:	fd06079b          	addiw	a5,a2,-48
 208:	0ff7f793          	andi	a5,a5,255
 20c:	4725                	li	a4,9
 20e:	02f76963          	bltu	a4,a5,240 <atoi+0x46>
 212:	86aa                	mv	a3,a0
  n = 0;
 214:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 216:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 218:	0685                	addi	a3,a3,1
 21a:	0025179b          	slliw	a5,a0,0x2
 21e:	9fa9                	addw	a5,a5,a0
 220:	0017979b          	slliw	a5,a5,0x1
 224:	9fb1                	addw	a5,a5,a2
 226:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 22a:	0006c603          	lbu	a2,0(a3)
 22e:	fd06071b          	addiw	a4,a2,-48
 232:	0ff77713          	andi	a4,a4,255
 236:	fee5f1e3          	bgeu	a1,a4,218 <atoi+0x1e>
  return n;
}
 23a:	6422                	ld	s0,8(sp)
 23c:	0141                	addi	sp,sp,16
 23e:	8082                	ret
  n = 0;
 240:	4501                	li	a0,0
 242:	bfe5                	j	23a <atoi+0x40>

0000000000000244 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 244:	1141                	addi	sp,sp,-16
 246:	e422                	sd	s0,8(sp)
 248:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 24a:	02b57663          	bgeu	a0,a1,276 <memmove+0x32>
    while(n-- > 0)
 24e:	02c05163          	blez	a2,270 <memmove+0x2c>
 252:	fff6079b          	addiw	a5,a2,-1
 256:	1782                	slli	a5,a5,0x20
 258:	9381                	srli	a5,a5,0x20
 25a:	0785                	addi	a5,a5,1
 25c:	97aa                	add	a5,a5,a0
  dst = vdst;
 25e:	872a                	mv	a4,a0
      *dst++ = *src++;
 260:	0585                	addi	a1,a1,1
 262:	0705                	addi	a4,a4,1
 264:	fff5c683          	lbu	a3,-1(a1)
 268:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 26c:	fee79ae3          	bne	a5,a4,260 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 270:	6422                	ld	s0,8(sp)
 272:	0141                	addi	sp,sp,16
 274:	8082                	ret
    dst += n;
 276:	00c50733          	add	a4,a0,a2
    src += n;
 27a:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 27c:	fec05ae3          	blez	a2,270 <memmove+0x2c>
 280:	fff6079b          	addiw	a5,a2,-1
 284:	1782                	slli	a5,a5,0x20
 286:	9381                	srli	a5,a5,0x20
 288:	fff7c793          	not	a5,a5
 28c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 28e:	15fd                	addi	a1,a1,-1
 290:	177d                	addi	a4,a4,-1
 292:	0005c683          	lbu	a3,0(a1)
 296:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 29a:	fee79ae3          	bne	a5,a4,28e <memmove+0x4a>
 29e:	bfc9                	j	270 <memmove+0x2c>

00000000000002a0 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2a0:	1141                	addi	sp,sp,-16
 2a2:	e422                	sd	s0,8(sp)
 2a4:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2a6:	ca05                	beqz	a2,2d6 <memcmp+0x36>
 2a8:	fff6069b          	addiw	a3,a2,-1
 2ac:	1682                	slli	a3,a3,0x20
 2ae:	9281                	srli	a3,a3,0x20
 2b0:	0685                	addi	a3,a3,1
 2b2:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2b4:	00054783          	lbu	a5,0(a0)
 2b8:	0005c703          	lbu	a4,0(a1)
 2bc:	00e79863          	bne	a5,a4,2cc <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2c0:	0505                	addi	a0,a0,1
    p2++;
 2c2:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2c4:	fed518e3          	bne	a0,a3,2b4 <memcmp+0x14>
  }
  return 0;
 2c8:	4501                	li	a0,0
 2ca:	a019                	j	2d0 <memcmp+0x30>
      return *p1 - *p2;
 2cc:	40e7853b          	subw	a0,a5,a4
}
 2d0:	6422                	ld	s0,8(sp)
 2d2:	0141                	addi	sp,sp,16
 2d4:	8082                	ret
  return 0;
 2d6:	4501                	li	a0,0
 2d8:	bfe5                	j	2d0 <memcmp+0x30>

00000000000002da <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2da:	1141                	addi	sp,sp,-16
 2dc:	e406                	sd	ra,8(sp)
 2de:	e022                	sd	s0,0(sp)
 2e0:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2e2:	00000097          	auipc	ra,0x0
 2e6:	f62080e7          	jalr	-158(ra) # 244 <memmove>
}
 2ea:	60a2                	ld	ra,8(sp)
 2ec:	6402                	ld	s0,0(sp)
 2ee:	0141                	addi	sp,sp,16
 2f0:	8082                	ret

00000000000002f2 <ugetpid>:

#ifdef LAB_PGTBL
int
ugetpid(void)
{
 2f2:	1141                	addi	sp,sp,-16
 2f4:	e422                	sd	s0,8(sp)
 2f6:	0800                	addi	s0,sp,16
  struct usyscall *u = (struct usyscall *)USYSCALL;
  return u->pid;
 2f8:	040007b7          	lui	a5,0x4000
}
 2fc:	17f5                	addi	a5,a5,-3
 2fe:	07b2                	slli	a5,a5,0xc
 300:	4388                	lw	a0,0(a5)
 302:	6422                	ld	s0,8(sp)
 304:	0141                	addi	sp,sp,16
 306:	8082                	ret

0000000000000308 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 308:	4885                	li	a7,1
 ecall
 30a:	00000073          	ecall
 ret
 30e:	8082                	ret

0000000000000310 <exit>:
.global exit
exit:
 li a7, SYS_exit
 310:	4889                	li	a7,2
 ecall
 312:	00000073          	ecall
 ret
 316:	8082                	ret

0000000000000318 <wait>:
.global wait
wait:
 li a7, SYS_wait
 318:	488d                	li	a7,3
 ecall
 31a:	00000073          	ecall
 ret
 31e:	8082                	ret

0000000000000320 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 320:	4891                	li	a7,4
 ecall
 322:	00000073          	ecall
 ret
 326:	8082                	ret

0000000000000328 <read>:
.global read
read:
 li a7, SYS_read
 328:	4895                	li	a7,5
 ecall
 32a:	00000073          	ecall
 ret
 32e:	8082                	ret

0000000000000330 <write>:
.global write
write:
 li a7, SYS_write
 330:	48c1                	li	a7,16
 ecall
 332:	00000073          	ecall
 ret
 336:	8082                	ret

0000000000000338 <close>:
.global close
close:
 li a7, SYS_close
 338:	48d5                	li	a7,21
 ecall
 33a:	00000073          	ecall
 ret
 33e:	8082                	ret

0000000000000340 <kill>:
.global kill
kill:
 li a7, SYS_kill
 340:	4899                	li	a7,6
 ecall
 342:	00000073          	ecall
 ret
 346:	8082                	ret

0000000000000348 <exec>:
.global exec
exec:
 li a7, SYS_exec
 348:	489d                	li	a7,7
 ecall
 34a:	00000073          	ecall
 ret
 34e:	8082                	ret

0000000000000350 <open>:
.global open
open:
 li a7, SYS_open
 350:	48bd                	li	a7,15
 ecall
 352:	00000073          	ecall
 ret
 356:	8082                	ret

0000000000000358 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 358:	48c5                	li	a7,17
 ecall
 35a:	00000073          	ecall
 ret
 35e:	8082                	ret

0000000000000360 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 360:	48c9                	li	a7,18
 ecall
 362:	00000073          	ecall
 ret
 366:	8082                	ret

0000000000000368 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 368:	48a1                	li	a7,8
 ecall
 36a:	00000073          	ecall
 ret
 36e:	8082                	ret

0000000000000370 <link>:
.global link
link:
 li a7, SYS_link
 370:	48cd                	li	a7,19
 ecall
 372:	00000073          	ecall
 ret
 376:	8082                	ret

0000000000000378 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 378:	48d1                	li	a7,20
 ecall
 37a:	00000073          	ecall
 ret
 37e:	8082                	ret

0000000000000380 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 380:	48a5                	li	a7,9
 ecall
 382:	00000073          	ecall
 ret
 386:	8082                	ret

0000000000000388 <dup>:
.global dup
dup:
 li a7, SYS_dup
 388:	48a9                	li	a7,10
 ecall
 38a:	00000073          	ecall
 ret
 38e:	8082                	ret

0000000000000390 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 390:	48ad                	li	a7,11
 ecall
 392:	00000073          	ecall
 ret
 396:	8082                	ret

0000000000000398 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 398:	48b1                	li	a7,12
 ecall
 39a:	00000073          	ecall
 ret
 39e:	8082                	ret

00000000000003a0 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3a0:	48b5                	li	a7,13
 ecall
 3a2:	00000073          	ecall
 ret
 3a6:	8082                	ret

00000000000003a8 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3a8:	48b9                	li	a7,14
 ecall
 3aa:	00000073          	ecall
 ret
 3ae:	8082                	ret

00000000000003b0 <connect>:
.global connect
connect:
 li a7, SYS_connect
 3b0:	48f5                	li	a7,29
 ecall
 3b2:	00000073          	ecall
 ret
 3b6:	8082                	ret

00000000000003b8 <pgaccess>:
.global pgaccess
pgaccess:
 li a7, SYS_pgaccess
 3b8:	48f9                	li	a7,30
 ecall
 3ba:	00000073          	ecall
 ret
 3be:	8082                	ret

00000000000003c0 <vmprint>:
.global vmprint
vmprint:
 li a7, SYS_vmprint
 3c0:	48fd                	li	a7,31
 ecall
 3c2:	00000073          	ecall
 ret
 3c6:	8082                	ret

00000000000003c8 <madvise>:
.global madvise
madvise:
 li a7, SYS_madvise
 3c8:	02000893          	li	a7,32
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <pgprint>:
.global pgprint
pgprint:
 li a7, SYS_pgprint
 3d2:	02100893          	li	a7,33
 ecall
 3d6:	00000073          	ecall
 ret
 3da:	8082                	ret

00000000000003dc <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3dc:	1101                	addi	sp,sp,-32
 3de:	ec06                	sd	ra,24(sp)
 3e0:	e822                	sd	s0,16(sp)
 3e2:	1000                	addi	s0,sp,32
 3e4:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3e8:	4605                	li	a2,1
 3ea:	fef40593          	addi	a1,s0,-17
 3ee:	00000097          	auipc	ra,0x0
 3f2:	f42080e7          	jalr	-190(ra) # 330 <write>
}
 3f6:	60e2                	ld	ra,24(sp)
 3f8:	6442                	ld	s0,16(sp)
 3fa:	6105                	addi	sp,sp,32
 3fc:	8082                	ret

00000000000003fe <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3fe:	7139                	addi	sp,sp,-64
 400:	fc06                	sd	ra,56(sp)
 402:	f822                	sd	s0,48(sp)
 404:	f426                	sd	s1,40(sp)
 406:	f04a                	sd	s2,32(sp)
 408:	ec4e                	sd	s3,24(sp)
 40a:	0080                	addi	s0,sp,64
 40c:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 40e:	c299                	beqz	a3,414 <printint+0x16>
 410:	0805c863          	bltz	a1,4a0 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 414:	2581                	sext.w	a1,a1
  neg = 0;
 416:	4881                	li	a7,0
 418:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 41c:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 41e:	2601                	sext.w	a2,a2
 420:	00000517          	auipc	a0,0x0
 424:	45050513          	addi	a0,a0,1104 # 870 <digits>
 428:	883a                	mv	a6,a4
 42a:	2705                	addiw	a4,a4,1
 42c:	02c5f7bb          	remuw	a5,a1,a2
 430:	1782                	slli	a5,a5,0x20
 432:	9381                	srli	a5,a5,0x20
 434:	97aa                	add	a5,a5,a0
 436:	0007c783          	lbu	a5,0(a5) # 4000000 <__global_pointer$+0x3ffef7f>
 43a:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 43e:	0005879b          	sext.w	a5,a1
 442:	02c5d5bb          	divuw	a1,a1,a2
 446:	0685                	addi	a3,a3,1
 448:	fec7f0e3          	bgeu	a5,a2,428 <printint+0x2a>
  if(neg)
 44c:	00088b63          	beqz	a7,462 <printint+0x64>
    buf[i++] = '-';
 450:	fd040793          	addi	a5,s0,-48
 454:	973e                	add	a4,a4,a5
 456:	02d00793          	li	a5,45
 45a:	fef70823          	sb	a5,-16(a4)
 45e:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 462:	02e05863          	blez	a4,492 <printint+0x94>
 466:	fc040793          	addi	a5,s0,-64
 46a:	00e78933          	add	s2,a5,a4
 46e:	fff78993          	addi	s3,a5,-1
 472:	99ba                	add	s3,s3,a4
 474:	377d                	addiw	a4,a4,-1
 476:	1702                	slli	a4,a4,0x20
 478:	9301                	srli	a4,a4,0x20
 47a:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 47e:	fff94583          	lbu	a1,-1(s2)
 482:	8526                	mv	a0,s1
 484:	00000097          	auipc	ra,0x0
 488:	f58080e7          	jalr	-168(ra) # 3dc <putc>
  while(--i >= 0)
 48c:	197d                	addi	s2,s2,-1
 48e:	ff3918e3          	bne	s2,s3,47e <printint+0x80>
}
 492:	70e2                	ld	ra,56(sp)
 494:	7442                	ld	s0,48(sp)
 496:	74a2                	ld	s1,40(sp)
 498:	7902                	ld	s2,32(sp)
 49a:	69e2                	ld	s3,24(sp)
 49c:	6121                	addi	sp,sp,64
 49e:	8082                	ret
    x = -xx;
 4a0:	40b005bb          	negw	a1,a1
    neg = 1;
 4a4:	4885                	li	a7,1
    x = -xx;
 4a6:	bf8d                	j	418 <printint+0x1a>

00000000000004a8 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4a8:	7119                	addi	sp,sp,-128
 4aa:	fc86                	sd	ra,120(sp)
 4ac:	f8a2                	sd	s0,112(sp)
 4ae:	f4a6                	sd	s1,104(sp)
 4b0:	f0ca                	sd	s2,96(sp)
 4b2:	ecce                	sd	s3,88(sp)
 4b4:	e8d2                	sd	s4,80(sp)
 4b6:	e4d6                	sd	s5,72(sp)
 4b8:	e0da                	sd	s6,64(sp)
 4ba:	fc5e                	sd	s7,56(sp)
 4bc:	f862                	sd	s8,48(sp)
 4be:	f466                	sd	s9,40(sp)
 4c0:	f06a                	sd	s10,32(sp)
 4c2:	ec6e                	sd	s11,24(sp)
 4c4:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4c6:	0005c903          	lbu	s2,0(a1)
 4ca:	18090f63          	beqz	s2,668 <vprintf+0x1c0>
 4ce:	8aaa                	mv	s5,a0
 4d0:	8b32                	mv	s6,a2
 4d2:	00158493          	addi	s1,a1,1
  state = 0;
 4d6:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4d8:	02500a13          	li	s4,37
      if(c == 'd'){
 4dc:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 4e0:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 4e4:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 4e8:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 4ec:	00000b97          	auipc	s7,0x0
 4f0:	384b8b93          	addi	s7,s7,900 # 870 <digits>
 4f4:	a839                	j	512 <vprintf+0x6a>
        putc(fd, c);
 4f6:	85ca                	mv	a1,s2
 4f8:	8556                	mv	a0,s5
 4fa:	00000097          	auipc	ra,0x0
 4fe:	ee2080e7          	jalr	-286(ra) # 3dc <putc>
 502:	a019                	j	508 <vprintf+0x60>
    } else if(state == '%'){
 504:	01498f63          	beq	s3,s4,522 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 508:	0485                	addi	s1,s1,1
 50a:	fff4c903          	lbu	s2,-1(s1)
 50e:	14090d63          	beqz	s2,668 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 512:	0009079b          	sext.w	a5,s2
    if(state == 0){
 516:	fe0997e3          	bnez	s3,504 <vprintf+0x5c>
      if(c == '%'){
 51a:	fd479ee3          	bne	a5,s4,4f6 <vprintf+0x4e>
        state = '%';
 51e:	89be                	mv	s3,a5
 520:	b7e5                	j	508 <vprintf+0x60>
      if(c == 'd'){
 522:	05878063          	beq	a5,s8,562 <vprintf+0xba>
      } else if(c == 'l') {
 526:	05978c63          	beq	a5,s9,57e <vprintf+0xd6>
      } else if(c == 'x') {
 52a:	07a78863          	beq	a5,s10,59a <vprintf+0xf2>
      } else if(c == 'p') {
 52e:	09b78463          	beq	a5,s11,5b6 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 532:	07300713          	li	a4,115
 536:	0ce78663          	beq	a5,a4,602 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 53a:	06300713          	li	a4,99
 53e:	0ee78e63          	beq	a5,a4,63a <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 542:	11478863          	beq	a5,s4,652 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 546:	85d2                	mv	a1,s4
 548:	8556                	mv	a0,s5
 54a:	00000097          	auipc	ra,0x0
 54e:	e92080e7          	jalr	-366(ra) # 3dc <putc>
        putc(fd, c);
 552:	85ca                	mv	a1,s2
 554:	8556                	mv	a0,s5
 556:	00000097          	auipc	ra,0x0
 55a:	e86080e7          	jalr	-378(ra) # 3dc <putc>
      }
      state = 0;
 55e:	4981                	li	s3,0
 560:	b765                	j	508 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 562:	008b0913          	addi	s2,s6,8
 566:	4685                	li	a3,1
 568:	4629                	li	a2,10
 56a:	000b2583          	lw	a1,0(s6)
 56e:	8556                	mv	a0,s5
 570:	00000097          	auipc	ra,0x0
 574:	e8e080e7          	jalr	-370(ra) # 3fe <printint>
 578:	8b4a                	mv	s6,s2
      state = 0;
 57a:	4981                	li	s3,0
 57c:	b771                	j	508 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 57e:	008b0913          	addi	s2,s6,8
 582:	4681                	li	a3,0
 584:	4629                	li	a2,10
 586:	000b2583          	lw	a1,0(s6)
 58a:	8556                	mv	a0,s5
 58c:	00000097          	auipc	ra,0x0
 590:	e72080e7          	jalr	-398(ra) # 3fe <printint>
 594:	8b4a                	mv	s6,s2
      state = 0;
 596:	4981                	li	s3,0
 598:	bf85                	j	508 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 59a:	008b0913          	addi	s2,s6,8
 59e:	4681                	li	a3,0
 5a0:	4641                	li	a2,16
 5a2:	000b2583          	lw	a1,0(s6)
 5a6:	8556                	mv	a0,s5
 5a8:	00000097          	auipc	ra,0x0
 5ac:	e56080e7          	jalr	-426(ra) # 3fe <printint>
 5b0:	8b4a                	mv	s6,s2
      state = 0;
 5b2:	4981                	li	s3,0
 5b4:	bf91                	j	508 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 5b6:	008b0793          	addi	a5,s6,8
 5ba:	f8f43423          	sd	a5,-120(s0)
 5be:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 5c2:	03000593          	li	a1,48
 5c6:	8556                	mv	a0,s5
 5c8:	00000097          	auipc	ra,0x0
 5cc:	e14080e7          	jalr	-492(ra) # 3dc <putc>
  putc(fd, 'x');
 5d0:	85ea                	mv	a1,s10
 5d2:	8556                	mv	a0,s5
 5d4:	00000097          	auipc	ra,0x0
 5d8:	e08080e7          	jalr	-504(ra) # 3dc <putc>
 5dc:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5de:	03c9d793          	srli	a5,s3,0x3c
 5e2:	97de                	add	a5,a5,s7
 5e4:	0007c583          	lbu	a1,0(a5)
 5e8:	8556                	mv	a0,s5
 5ea:	00000097          	auipc	ra,0x0
 5ee:	df2080e7          	jalr	-526(ra) # 3dc <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5f2:	0992                	slli	s3,s3,0x4
 5f4:	397d                	addiw	s2,s2,-1
 5f6:	fe0914e3          	bnez	s2,5de <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 5fa:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 5fe:	4981                	li	s3,0
 600:	b721                	j	508 <vprintf+0x60>
        s = va_arg(ap, char*);
 602:	008b0993          	addi	s3,s6,8
 606:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 60a:	02090163          	beqz	s2,62c <vprintf+0x184>
        while(*s != 0){
 60e:	00094583          	lbu	a1,0(s2)
 612:	c9a1                	beqz	a1,662 <vprintf+0x1ba>
          putc(fd, *s);
 614:	8556                	mv	a0,s5
 616:	00000097          	auipc	ra,0x0
 61a:	dc6080e7          	jalr	-570(ra) # 3dc <putc>
          s++;
 61e:	0905                	addi	s2,s2,1
        while(*s != 0){
 620:	00094583          	lbu	a1,0(s2)
 624:	f9e5                	bnez	a1,614 <vprintf+0x16c>
        s = va_arg(ap, char*);
 626:	8b4e                	mv	s6,s3
      state = 0;
 628:	4981                	li	s3,0
 62a:	bdf9                	j	508 <vprintf+0x60>
          s = "(null)";
 62c:	00000917          	auipc	s2,0x0
 630:	23c90913          	addi	s2,s2,572 # 868 <malloc+0xf6>
        while(*s != 0){
 634:	02800593          	li	a1,40
 638:	bff1                	j	614 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 63a:	008b0913          	addi	s2,s6,8
 63e:	000b4583          	lbu	a1,0(s6)
 642:	8556                	mv	a0,s5
 644:	00000097          	auipc	ra,0x0
 648:	d98080e7          	jalr	-616(ra) # 3dc <putc>
 64c:	8b4a                	mv	s6,s2
      state = 0;
 64e:	4981                	li	s3,0
 650:	bd65                	j	508 <vprintf+0x60>
        putc(fd, c);
 652:	85d2                	mv	a1,s4
 654:	8556                	mv	a0,s5
 656:	00000097          	auipc	ra,0x0
 65a:	d86080e7          	jalr	-634(ra) # 3dc <putc>
      state = 0;
 65e:	4981                	li	s3,0
 660:	b565                	j	508 <vprintf+0x60>
        s = va_arg(ap, char*);
 662:	8b4e                	mv	s6,s3
      state = 0;
 664:	4981                	li	s3,0
 666:	b54d                	j	508 <vprintf+0x60>
    }
  }
}
 668:	70e6                	ld	ra,120(sp)
 66a:	7446                	ld	s0,112(sp)
 66c:	74a6                	ld	s1,104(sp)
 66e:	7906                	ld	s2,96(sp)
 670:	69e6                	ld	s3,88(sp)
 672:	6a46                	ld	s4,80(sp)
 674:	6aa6                	ld	s5,72(sp)
 676:	6b06                	ld	s6,64(sp)
 678:	7be2                	ld	s7,56(sp)
 67a:	7c42                	ld	s8,48(sp)
 67c:	7ca2                	ld	s9,40(sp)
 67e:	7d02                	ld	s10,32(sp)
 680:	6de2                	ld	s11,24(sp)
 682:	6109                	addi	sp,sp,128
 684:	8082                	ret

0000000000000686 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 686:	715d                	addi	sp,sp,-80
 688:	ec06                	sd	ra,24(sp)
 68a:	e822                	sd	s0,16(sp)
 68c:	1000                	addi	s0,sp,32
 68e:	e010                	sd	a2,0(s0)
 690:	e414                	sd	a3,8(s0)
 692:	e818                	sd	a4,16(s0)
 694:	ec1c                	sd	a5,24(s0)
 696:	03043023          	sd	a6,32(s0)
 69a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 69e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6a2:	8622                	mv	a2,s0
 6a4:	00000097          	auipc	ra,0x0
 6a8:	e04080e7          	jalr	-508(ra) # 4a8 <vprintf>
}
 6ac:	60e2                	ld	ra,24(sp)
 6ae:	6442                	ld	s0,16(sp)
 6b0:	6161                	addi	sp,sp,80
 6b2:	8082                	ret

00000000000006b4 <printf>:

void
printf(const char *fmt, ...)
{
 6b4:	711d                	addi	sp,sp,-96
 6b6:	ec06                	sd	ra,24(sp)
 6b8:	e822                	sd	s0,16(sp)
 6ba:	1000                	addi	s0,sp,32
 6bc:	e40c                	sd	a1,8(s0)
 6be:	e810                	sd	a2,16(s0)
 6c0:	ec14                	sd	a3,24(s0)
 6c2:	f018                	sd	a4,32(s0)
 6c4:	f41c                	sd	a5,40(s0)
 6c6:	03043823          	sd	a6,48(s0)
 6ca:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6ce:	00840613          	addi	a2,s0,8
 6d2:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6d6:	85aa                	mv	a1,a0
 6d8:	4505                	li	a0,1
 6da:	00000097          	auipc	ra,0x0
 6de:	dce080e7          	jalr	-562(ra) # 4a8 <vprintf>
}
 6e2:	60e2                	ld	ra,24(sp)
 6e4:	6442                	ld	s0,16(sp)
 6e6:	6125                	addi	sp,sp,96
 6e8:	8082                	ret

00000000000006ea <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6ea:	1141                	addi	sp,sp,-16
 6ec:	e422                	sd	s0,8(sp)
 6ee:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6f0:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6f4:	00000797          	auipc	a5,0x0
 6f8:	1947b783          	ld	a5,404(a5) # 888 <freep>
 6fc:	a805                	j	72c <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6fe:	4618                	lw	a4,8(a2)
 700:	9db9                	addw	a1,a1,a4
 702:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 706:	6398                	ld	a4,0(a5)
 708:	6318                	ld	a4,0(a4)
 70a:	fee53823          	sd	a4,-16(a0)
 70e:	a091                	j	752 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 710:	ff852703          	lw	a4,-8(a0)
 714:	9e39                	addw	a2,a2,a4
 716:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 718:	ff053703          	ld	a4,-16(a0)
 71c:	e398                	sd	a4,0(a5)
 71e:	a099                	j	764 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 720:	6398                	ld	a4,0(a5)
 722:	00e7e463          	bltu	a5,a4,72a <free+0x40>
 726:	00e6ea63          	bltu	a3,a4,73a <free+0x50>
{
 72a:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 72c:	fed7fae3          	bgeu	a5,a3,720 <free+0x36>
 730:	6398                	ld	a4,0(a5)
 732:	00e6e463          	bltu	a3,a4,73a <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 736:	fee7eae3          	bltu	a5,a4,72a <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 73a:	ff852583          	lw	a1,-8(a0)
 73e:	6390                	ld	a2,0(a5)
 740:	02059713          	slli	a4,a1,0x20
 744:	9301                	srli	a4,a4,0x20
 746:	0712                	slli	a4,a4,0x4
 748:	9736                	add	a4,a4,a3
 74a:	fae60ae3          	beq	a2,a4,6fe <free+0x14>
    bp->s.ptr = p->s.ptr;
 74e:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 752:	4790                	lw	a2,8(a5)
 754:	02061713          	slli	a4,a2,0x20
 758:	9301                	srli	a4,a4,0x20
 75a:	0712                	slli	a4,a4,0x4
 75c:	973e                	add	a4,a4,a5
 75e:	fae689e3          	beq	a3,a4,710 <free+0x26>
  } else
    p->s.ptr = bp;
 762:	e394                	sd	a3,0(a5)
  freep = p;
 764:	00000717          	auipc	a4,0x0
 768:	12f73223          	sd	a5,292(a4) # 888 <freep>
}
 76c:	6422                	ld	s0,8(sp)
 76e:	0141                	addi	sp,sp,16
 770:	8082                	ret

0000000000000772 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 772:	7139                	addi	sp,sp,-64
 774:	fc06                	sd	ra,56(sp)
 776:	f822                	sd	s0,48(sp)
 778:	f426                	sd	s1,40(sp)
 77a:	f04a                	sd	s2,32(sp)
 77c:	ec4e                	sd	s3,24(sp)
 77e:	e852                	sd	s4,16(sp)
 780:	e456                	sd	s5,8(sp)
 782:	e05a                	sd	s6,0(sp)
 784:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 786:	02051493          	slli	s1,a0,0x20
 78a:	9081                	srli	s1,s1,0x20
 78c:	04bd                	addi	s1,s1,15
 78e:	8091                	srli	s1,s1,0x4
 790:	0014899b          	addiw	s3,s1,1
 794:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 796:	00000797          	auipc	a5,0x0
 79a:	0f27b783          	ld	a5,242(a5) # 888 <freep>
 79e:	c795                	beqz	a5,7ca <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7a0:	6388                	ld	a0,0(a5)
    if(p->s.size >= nunits){
 7a2:	4518                	lw	a4,8(a0)
 7a4:	02977f63          	bgeu	a4,s1,7e2 <malloc+0x70>
 7a8:	8a4e                	mv	s4,s3
 7aa:	0009879b          	sext.w	a5,s3
 7ae:	6705                	lui	a4,0x1
 7b0:	00e7f363          	bgeu	a5,a4,7b6 <malloc+0x44>
 7b4:	6a05                	lui	s4,0x1
 7b6:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7ba:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p);
    }
    if(p == freep)
 7be:	00000917          	auipc	s2,0x0
 7c2:	0ca90913          	addi	s2,s2,202 # 888 <freep>
  if(p == (char*)-1)
 7c6:	5afd                	li	s5,-1
 7c8:	a0bd                	j	836 <malloc+0xc4>
    base.s.ptr = freep = prevp = &base;
 7ca:	00000517          	auipc	a0,0x0
 7ce:	0c650513          	addi	a0,a0,198 # 890 <base>
 7d2:	00000797          	auipc	a5,0x0
 7d6:	0aa7bb23          	sd	a0,182(a5) # 888 <freep>
 7da:	e108                	sd	a0,0(a0)
    base.s.size = 0;
 7dc:	00052423          	sw	zero,8(a0)
    if(p->s.size >= nunits){
 7e0:	b7e1                	j	7a8 <malloc+0x36>
      if(p->s.size == nunits)
 7e2:	02e48963          	beq	s1,a4,814 <malloc+0xa2>
        p->s.size -= nunits;
 7e6:	4137073b          	subw	a4,a4,s3
 7ea:	c518                	sw	a4,8(a0)
        p += p->s.size;
 7ec:	1702                	slli	a4,a4,0x20
 7ee:	9301                	srli	a4,a4,0x20
 7f0:	0712                	slli	a4,a4,0x4
 7f2:	953a                	add	a0,a0,a4
        p->s.size = nunits;
 7f4:	01352423          	sw	s3,8(a0)
      freep = prevp;
 7f8:	00000717          	auipc	a4,0x0
 7fc:	08f73823          	sd	a5,144(a4) # 888 <freep>
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 800:	70e2                	ld	ra,56(sp)
 802:	7442                	ld	s0,48(sp)
 804:	74a2                	ld	s1,40(sp)
 806:	7902                	ld	s2,32(sp)
 808:	69e2                	ld	s3,24(sp)
 80a:	6a42                	ld	s4,16(sp)
 80c:	6aa2                	ld	s5,8(sp)
 80e:	6b02                	ld	s6,0(sp)
 810:	6121                	addi	sp,sp,64
 812:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 814:	6118                	ld	a4,0(a0)
 816:	e398                	sd	a4,0(a5)
 818:	b7c5                	j	7f8 <malloc+0x86>
  hp->s.size = nu;
 81a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 81e:	0541                	addi	a0,a0,16
 820:	00000097          	auipc	ra,0x0
 824:	eca080e7          	jalr	-310(ra) # 6ea <free>
  return freep;
 828:	00093783          	ld	a5,0(s2)
      if((p = morecore(nunits)) == 0)
 82c:	c39d                	beqz	a5,852 <malloc+0xe0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 82e:	6388                	ld	a0,0(a5)
    if(p->s.size >= nunits){
 830:	4518                	lw	a4,8(a0)
 832:	fa9778e3          	bgeu	a4,s1,7e2 <malloc+0x70>
    if(p == freep)
 836:	00093703          	ld	a4,0(s2)
 83a:	87aa                	mv	a5,a0
 83c:	fea719e3          	bne	a4,a0,82e <malloc+0xbc>
  p = sbrk(nu * sizeof(Header));
 840:	8552                	mv	a0,s4
 842:	00000097          	auipc	ra,0x0
 846:	b56080e7          	jalr	-1194(ra) # 398 <sbrk>
  if(p == (char*)-1)
 84a:	fd5518e3          	bne	a0,s5,81a <malloc+0xa8>
        return 0;
 84e:	4501                	li	a0,0
 850:	bf45                	j	800 <malloc+0x8e>
 852:	853e                	mv	a0,a5
 854:	b775                	j	800 <malloc+0x8e>
