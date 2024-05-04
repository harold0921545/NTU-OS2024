
user/_rttask4:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <f>:
#define NULL 0

int k = 0;

void f(void *arg)
{
       0:	1101                	addi	sp,sp,-32
       2:	ec22                	sd	s0,24(sp)
       4:	1000                	addi	s0,sp,32
       6:	fea43423          	sd	a0,-24(s0)
    while (1) {
        k++;
       a:	00002797          	auipc	a5,0x2
       e:	5e678793          	addi	a5,a5,1510 # 25f0 <k>
      12:	439c                	lw	a5,0(a5)
      14:	2785                	addiw	a5,a5,1
      16:	0007871b          	sext.w	a4,a5
      1a:	00002797          	auipc	a5,0x2
      1e:	5d678793          	addi	a5,a5,1494 # 25f0 <k>
      22:	c398                	sw	a4,0(a5)
      24:	b7dd                	j	a <f+0xa>

0000000000000026 <main>:
    }
}

int main(int argc, char **argv)
{
      26:	7139                	addi	sp,sp,-64
      28:	fc06                	sd	ra,56(sp)
      2a:	f822                	sd	s0,48(sp)
      2c:	0080                	addi	s0,sp,64
      2e:	87aa                	mv	a5,a0
      30:	fcb43023          	sd	a1,-64(s0)
      34:	fcf42623          	sw	a5,-52(s0)
    struct thread *t1 = thread_create(f, NULL, 1, 1, 10, 2);
      38:	4789                	li	a5,2
      3a:	4729                	li	a4,10
      3c:	4685                	li	a3,1
      3e:	4605                	li	a2,1
      40:	4581                	li	a1,0
      42:	00000517          	auipc	a0,0x0
      46:	fbe50513          	addi	a0,a0,-66 # 0 <f>
      4a:	00001097          	auipc	ra,0x1
      4e:	f4e080e7          	jalr	-178(ra) # f98 <thread_create>
      52:	fea43423          	sd	a0,-24(s0)
    thread_add_at(t1, 3);
      56:	458d                	li	a1,3
      58:	fe843503          	ld	a0,-24(s0)
      5c:	00001097          	auipc	ra,0x1
      60:	068080e7          	jalr	104(ra) # 10c4 <thread_add_at>

    struct thread *t2 = thread_create(f, NULL, 1, 2, 10, 2);
      64:	4789                	li	a5,2
      66:	4729                	li	a4,10
      68:	4689                	li	a3,2
      6a:	4605                	li	a2,1
      6c:	4581                	li	a1,0
      6e:	00000517          	auipc	a0,0x0
      72:	f9250513          	addi	a0,a0,-110 # 0 <f>
      76:	00001097          	auipc	ra,0x1
      7a:	f22080e7          	jalr	-222(ra) # f98 <thread_create>
      7e:	fea43023          	sd	a0,-32(s0)
    thread_add_at(t2, 2);
      82:	4589                	li	a1,2
      84:	fe043503          	ld	a0,-32(s0)
      88:	00001097          	auipc	ra,0x1
      8c:	03c080e7          	jalr	60(ra) # 10c4 <thread_add_at>

    struct thread *t3 = thread_create(f, NULL, 1, 3, 10, 2);
      90:	4789                	li	a5,2
      92:	4729                	li	a4,10
      94:	468d                	li	a3,3
      96:	4605                	li	a2,1
      98:	4581                	li	a1,0
      9a:	00000517          	auipc	a0,0x0
      9e:	f6650513          	addi	a0,a0,-154 # 0 <f>
      a2:	00001097          	auipc	ra,0x1
      a6:	ef6080e7          	jalr	-266(ra) # f98 <thread_create>
      aa:	fca43c23          	sd	a0,-40(s0)
    thread_add_at(t3, 1);
      ae:	4585                	li	a1,1
      b0:	fd843503          	ld	a0,-40(s0)
      b4:	00001097          	auipc	ra,0x1
      b8:	010080e7          	jalr	16(ra) # 10c4 <thread_add_at>

    struct thread *t4 = thread_create(f, NULL, 1, 4, 10, 2);
      bc:	4789                	li	a5,2
      be:	4729                	li	a4,10
      c0:	4691                	li	a3,4
      c2:	4605                	li	a2,1
      c4:	4581                	li	a1,0
      c6:	00000517          	auipc	a0,0x0
      ca:	f3a50513          	addi	a0,a0,-198 # 0 <f>
      ce:	00001097          	auipc	ra,0x1
      d2:	eca080e7          	jalr	-310(ra) # f98 <thread_create>
      d6:	fca43823          	sd	a0,-48(s0)
    thread_add_at(t4, 0);
      da:	4581                	li	a1,0
      dc:	fd043503          	ld	a0,-48(s0)
      e0:	00001097          	auipc	ra,0x1
      e4:	fe4080e7          	jalr	-28(ra) # 10c4 <thread_add_at>

    thread_start_threading();
      e8:	00001097          	auipc	ra,0x1
      ec:	7ea080e7          	jalr	2026(ra) # 18d2 <thread_start_threading>
    printf("\nexited\n");
      f0:	00002517          	auipc	a0,0x2
      f4:	36850513          	addi	a0,a0,872 # 2458 <schedule_dm+0x2ac>
      f8:	00001097          	auipc	ra,0x1
      fc:	9e8080e7          	jalr	-1560(ra) # ae0 <printf>
    exit(0);
     100:	4501                	li	a0,0
     102:	00000097          	auipc	ra,0x0
     106:	498080e7          	jalr	1176(ra) # 59a <exit>

000000000000010a <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
     10a:	7179                	addi	sp,sp,-48
     10c:	f422                	sd	s0,40(sp)
     10e:	1800                	addi	s0,sp,48
     110:	fca43c23          	sd	a0,-40(s0)
     114:	fcb43823          	sd	a1,-48(s0)
  char *os;

  os = s;
     118:	fd843783          	ld	a5,-40(s0)
     11c:	fef43423          	sd	a5,-24(s0)
  while((*s++ = *t++) != 0)
     120:	0001                	nop
     122:	fd043703          	ld	a4,-48(s0)
     126:	00170793          	addi	a5,a4,1
     12a:	fcf43823          	sd	a5,-48(s0)
     12e:	fd843783          	ld	a5,-40(s0)
     132:	00178693          	addi	a3,a5,1
     136:	fcd43c23          	sd	a3,-40(s0)
     13a:	00074703          	lbu	a4,0(a4)
     13e:	00e78023          	sb	a4,0(a5)
     142:	0007c783          	lbu	a5,0(a5)
     146:	fff1                	bnez	a5,122 <strcpy+0x18>
    ;
  return os;
     148:	fe843783          	ld	a5,-24(s0)
}
     14c:	853e                	mv	a0,a5
     14e:	7422                	ld	s0,40(sp)
     150:	6145                	addi	sp,sp,48
     152:	8082                	ret

0000000000000154 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     154:	1101                	addi	sp,sp,-32
     156:	ec22                	sd	s0,24(sp)
     158:	1000                	addi	s0,sp,32
     15a:	fea43423          	sd	a0,-24(s0)
     15e:	feb43023          	sd	a1,-32(s0)
  while(*p && *p == *q)
     162:	a819                	j	178 <strcmp+0x24>
    p++, q++;
     164:	fe843783          	ld	a5,-24(s0)
     168:	0785                	addi	a5,a5,1
     16a:	fef43423          	sd	a5,-24(s0)
     16e:	fe043783          	ld	a5,-32(s0)
     172:	0785                	addi	a5,a5,1
     174:	fef43023          	sd	a5,-32(s0)
  while(*p && *p == *q)
     178:	fe843783          	ld	a5,-24(s0)
     17c:	0007c783          	lbu	a5,0(a5)
     180:	cb99                	beqz	a5,196 <strcmp+0x42>
     182:	fe843783          	ld	a5,-24(s0)
     186:	0007c703          	lbu	a4,0(a5)
     18a:	fe043783          	ld	a5,-32(s0)
     18e:	0007c783          	lbu	a5,0(a5)
     192:	fcf709e3          	beq	a4,a5,164 <strcmp+0x10>
  return (uchar)*p - (uchar)*q;
     196:	fe843783          	ld	a5,-24(s0)
     19a:	0007c783          	lbu	a5,0(a5)
     19e:	0007871b          	sext.w	a4,a5
     1a2:	fe043783          	ld	a5,-32(s0)
     1a6:	0007c783          	lbu	a5,0(a5)
     1aa:	2781                	sext.w	a5,a5
     1ac:	40f707bb          	subw	a5,a4,a5
     1b0:	2781                	sext.w	a5,a5
}
     1b2:	853e                	mv	a0,a5
     1b4:	6462                	ld	s0,24(sp)
     1b6:	6105                	addi	sp,sp,32
     1b8:	8082                	ret

00000000000001ba <strlen>:

uint
strlen(const char *s)
{
     1ba:	7179                	addi	sp,sp,-48
     1bc:	f422                	sd	s0,40(sp)
     1be:	1800                	addi	s0,sp,48
     1c0:	fca43c23          	sd	a0,-40(s0)
  int n;

  for(n = 0; s[n]; n++)
     1c4:	fe042623          	sw	zero,-20(s0)
     1c8:	a031                	j	1d4 <strlen+0x1a>
     1ca:	fec42783          	lw	a5,-20(s0)
     1ce:	2785                	addiw	a5,a5,1
     1d0:	fef42623          	sw	a5,-20(s0)
     1d4:	fec42783          	lw	a5,-20(s0)
     1d8:	fd843703          	ld	a4,-40(s0)
     1dc:	97ba                	add	a5,a5,a4
     1de:	0007c783          	lbu	a5,0(a5)
     1e2:	f7e5                	bnez	a5,1ca <strlen+0x10>
    ;
  return n;
     1e4:	fec42783          	lw	a5,-20(s0)
}
     1e8:	853e                	mv	a0,a5
     1ea:	7422                	ld	s0,40(sp)
     1ec:	6145                	addi	sp,sp,48
     1ee:	8082                	ret

00000000000001f0 <memset>:

void*
memset(void *dst, int c, uint n)
{
     1f0:	7179                	addi	sp,sp,-48
     1f2:	f422                	sd	s0,40(sp)
     1f4:	1800                	addi	s0,sp,48
     1f6:	fca43c23          	sd	a0,-40(s0)
     1fa:	87ae                	mv	a5,a1
     1fc:	8732                	mv	a4,a2
     1fe:	fcf42a23          	sw	a5,-44(s0)
     202:	87ba                	mv	a5,a4
     204:	fcf42823          	sw	a5,-48(s0)
  char *cdst = (char *) dst;
     208:	fd843783          	ld	a5,-40(s0)
     20c:	fef43023          	sd	a5,-32(s0)
  int i;
  for(i = 0; i < n; i++){
     210:	fe042623          	sw	zero,-20(s0)
     214:	a00d                	j	236 <memset+0x46>
    cdst[i] = c;
     216:	fec42783          	lw	a5,-20(s0)
     21a:	fe043703          	ld	a4,-32(s0)
     21e:	97ba                	add	a5,a5,a4
     220:	fd442703          	lw	a4,-44(s0)
     224:	0ff77713          	andi	a4,a4,255
     228:	00e78023          	sb	a4,0(a5)
  for(i = 0; i < n; i++){
     22c:	fec42783          	lw	a5,-20(s0)
     230:	2785                	addiw	a5,a5,1
     232:	fef42623          	sw	a5,-20(s0)
     236:	fec42703          	lw	a4,-20(s0)
     23a:	fd042783          	lw	a5,-48(s0)
     23e:	2781                	sext.w	a5,a5
     240:	fcf76be3          	bltu	a4,a5,216 <memset+0x26>
  }
  return dst;
     244:	fd843783          	ld	a5,-40(s0)
}
     248:	853e                	mv	a0,a5
     24a:	7422                	ld	s0,40(sp)
     24c:	6145                	addi	sp,sp,48
     24e:	8082                	ret

0000000000000250 <strchr>:

char*
strchr(const char *s, char c)
{
     250:	1101                	addi	sp,sp,-32
     252:	ec22                	sd	s0,24(sp)
     254:	1000                	addi	s0,sp,32
     256:	fea43423          	sd	a0,-24(s0)
     25a:	87ae                	mv	a5,a1
     25c:	fef403a3          	sb	a5,-25(s0)
  for(; *s; s++)
     260:	a01d                	j	286 <strchr+0x36>
    if(*s == c)
     262:	fe843783          	ld	a5,-24(s0)
     266:	0007c703          	lbu	a4,0(a5)
     26a:	fe744783          	lbu	a5,-25(s0)
     26e:	0ff7f793          	andi	a5,a5,255
     272:	00e79563          	bne	a5,a4,27c <strchr+0x2c>
      return (char*)s;
     276:	fe843783          	ld	a5,-24(s0)
     27a:	a821                	j	292 <strchr+0x42>
  for(; *s; s++)
     27c:	fe843783          	ld	a5,-24(s0)
     280:	0785                	addi	a5,a5,1
     282:	fef43423          	sd	a5,-24(s0)
     286:	fe843783          	ld	a5,-24(s0)
     28a:	0007c783          	lbu	a5,0(a5)
     28e:	fbf1                	bnez	a5,262 <strchr+0x12>
  return 0;
     290:	4781                	li	a5,0
}
     292:	853e                	mv	a0,a5
     294:	6462                	ld	s0,24(sp)
     296:	6105                	addi	sp,sp,32
     298:	8082                	ret

000000000000029a <gets>:

char*
gets(char *buf, int max)
{
     29a:	7179                	addi	sp,sp,-48
     29c:	f406                	sd	ra,40(sp)
     29e:	f022                	sd	s0,32(sp)
     2a0:	1800                	addi	s0,sp,48
     2a2:	fca43c23          	sd	a0,-40(s0)
     2a6:	87ae                	mv	a5,a1
     2a8:	fcf42a23          	sw	a5,-44(s0)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     2ac:	fe042623          	sw	zero,-20(s0)
     2b0:	a8a1                	j	308 <gets+0x6e>
    cc = read(0, &c, 1);
     2b2:	fe740793          	addi	a5,s0,-25
     2b6:	4605                	li	a2,1
     2b8:	85be                	mv	a1,a5
     2ba:	4501                	li	a0,0
     2bc:	00000097          	auipc	ra,0x0
     2c0:	2f6080e7          	jalr	758(ra) # 5b2 <read>
     2c4:	87aa                	mv	a5,a0
     2c6:	fef42423          	sw	a5,-24(s0)
    if(cc < 1)
     2ca:	fe842783          	lw	a5,-24(s0)
     2ce:	2781                	sext.w	a5,a5
     2d0:	04f05763          	blez	a5,31e <gets+0x84>
      break;
    buf[i++] = c;
     2d4:	fec42783          	lw	a5,-20(s0)
     2d8:	0017871b          	addiw	a4,a5,1
     2dc:	fee42623          	sw	a4,-20(s0)
     2e0:	873e                	mv	a4,a5
     2e2:	fd843783          	ld	a5,-40(s0)
     2e6:	97ba                	add	a5,a5,a4
     2e8:	fe744703          	lbu	a4,-25(s0)
     2ec:	00e78023          	sb	a4,0(a5)
    if(c == '\n' || c == '\r')
     2f0:	fe744783          	lbu	a5,-25(s0)
     2f4:	873e                	mv	a4,a5
     2f6:	47a9                	li	a5,10
     2f8:	02f70463          	beq	a4,a5,320 <gets+0x86>
     2fc:	fe744783          	lbu	a5,-25(s0)
     300:	873e                	mv	a4,a5
     302:	47b5                	li	a5,13
     304:	00f70e63          	beq	a4,a5,320 <gets+0x86>
  for(i=0; i+1 < max; ){
     308:	fec42783          	lw	a5,-20(s0)
     30c:	2785                	addiw	a5,a5,1
     30e:	0007871b          	sext.w	a4,a5
     312:	fd442783          	lw	a5,-44(s0)
     316:	2781                	sext.w	a5,a5
     318:	f8f74de3          	blt	a4,a5,2b2 <gets+0x18>
     31c:	a011                	j	320 <gets+0x86>
      break;
     31e:	0001                	nop
      break;
  }
  buf[i] = '\0';
     320:	fec42783          	lw	a5,-20(s0)
     324:	fd843703          	ld	a4,-40(s0)
     328:	97ba                	add	a5,a5,a4
     32a:	00078023          	sb	zero,0(a5)
  return buf;
     32e:	fd843783          	ld	a5,-40(s0)
}
     332:	853e                	mv	a0,a5
     334:	70a2                	ld	ra,40(sp)
     336:	7402                	ld	s0,32(sp)
     338:	6145                	addi	sp,sp,48
     33a:	8082                	ret

000000000000033c <stat>:

int
stat(const char *n, struct stat *st)
{
     33c:	7179                	addi	sp,sp,-48
     33e:	f406                	sd	ra,40(sp)
     340:	f022                	sd	s0,32(sp)
     342:	1800                	addi	s0,sp,48
     344:	fca43c23          	sd	a0,-40(s0)
     348:	fcb43823          	sd	a1,-48(s0)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     34c:	4581                	li	a1,0
     34e:	fd843503          	ld	a0,-40(s0)
     352:	00000097          	auipc	ra,0x0
     356:	288080e7          	jalr	648(ra) # 5da <open>
     35a:	87aa                	mv	a5,a0
     35c:	fef42623          	sw	a5,-20(s0)
  if(fd < 0)
     360:	fec42783          	lw	a5,-20(s0)
     364:	2781                	sext.w	a5,a5
     366:	0007d463          	bgez	a5,36e <stat+0x32>
    return -1;
     36a:	57fd                	li	a5,-1
     36c:	a035                	j	398 <stat+0x5c>
  r = fstat(fd, st);
     36e:	fec42783          	lw	a5,-20(s0)
     372:	fd043583          	ld	a1,-48(s0)
     376:	853e                	mv	a0,a5
     378:	00000097          	auipc	ra,0x0
     37c:	27a080e7          	jalr	634(ra) # 5f2 <fstat>
     380:	87aa                	mv	a5,a0
     382:	fef42423          	sw	a5,-24(s0)
  close(fd);
     386:	fec42783          	lw	a5,-20(s0)
     38a:	853e                	mv	a0,a5
     38c:	00000097          	auipc	ra,0x0
     390:	236080e7          	jalr	566(ra) # 5c2 <close>
  return r;
     394:	fe842783          	lw	a5,-24(s0)
}
     398:	853e                	mv	a0,a5
     39a:	70a2                	ld	ra,40(sp)
     39c:	7402                	ld	s0,32(sp)
     39e:	6145                	addi	sp,sp,48
     3a0:	8082                	ret

00000000000003a2 <atoi>:

int
atoi(const char *s)
{
     3a2:	7179                	addi	sp,sp,-48
     3a4:	f422                	sd	s0,40(sp)
     3a6:	1800                	addi	s0,sp,48
     3a8:	fca43c23          	sd	a0,-40(s0)
  int n;

  n = 0;
     3ac:	fe042623          	sw	zero,-20(s0)
  while('0' <= *s && *s <= '9')
     3b0:	a815                	j	3e4 <atoi+0x42>
    n = n*10 + *s++ - '0';
     3b2:	fec42703          	lw	a4,-20(s0)
     3b6:	87ba                	mv	a5,a4
     3b8:	0027979b          	slliw	a5,a5,0x2
     3bc:	9fb9                	addw	a5,a5,a4
     3be:	0017979b          	slliw	a5,a5,0x1
     3c2:	0007871b          	sext.w	a4,a5
     3c6:	fd843783          	ld	a5,-40(s0)
     3ca:	00178693          	addi	a3,a5,1
     3ce:	fcd43c23          	sd	a3,-40(s0)
     3d2:	0007c783          	lbu	a5,0(a5)
     3d6:	2781                	sext.w	a5,a5
     3d8:	9fb9                	addw	a5,a5,a4
     3da:	2781                	sext.w	a5,a5
     3dc:	fd07879b          	addiw	a5,a5,-48
     3e0:	fef42623          	sw	a5,-20(s0)
  while('0' <= *s && *s <= '9')
     3e4:	fd843783          	ld	a5,-40(s0)
     3e8:	0007c783          	lbu	a5,0(a5)
     3ec:	873e                	mv	a4,a5
     3ee:	02f00793          	li	a5,47
     3f2:	00e7fb63          	bgeu	a5,a4,408 <atoi+0x66>
     3f6:	fd843783          	ld	a5,-40(s0)
     3fa:	0007c783          	lbu	a5,0(a5)
     3fe:	873e                	mv	a4,a5
     400:	03900793          	li	a5,57
     404:	fae7f7e3          	bgeu	a5,a4,3b2 <atoi+0x10>
  return n;
     408:	fec42783          	lw	a5,-20(s0)
}
     40c:	853e                	mv	a0,a5
     40e:	7422                	ld	s0,40(sp)
     410:	6145                	addi	sp,sp,48
     412:	8082                	ret

0000000000000414 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     414:	7139                	addi	sp,sp,-64
     416:	fc22                	sd	s0,56(sp)
     418:	0080                	addi	s0,sp,64
     41a:	fca43c23          	sd	a0,-40(s0)
     41e:	fcb43823          	sd	a1,-48(s0)
     422:	87b2                	mv	a5,a2
     424:	fcf42623          	sw	a5,-52(s0)
  char *dst;
  const char *src;

  dst = vdst;
     428:	fd843783          	ld	a5,-40(s0)
     42c:	fef43423          	sd	a5,-24(s0)
  src = vsrc;
     430:	fd043783          	ld	a5,-48(s0)
     434:	fef43023          	sd	a5,-32(s0)
  if (src > dst) {
     438:	fe043703          	ld	a4,-32(s0)
     43c:	fe843783          	ld	a5,-24(s0)
     440:	02e7fc63          	bgeu	a5,a4,478 <memmove+0x64>
    while(n-- > 0)
     444:	a00d                	j	466 <memmove+0x52>
      *dst++ = *src++;
     446:	fe043703          	ld	a4,-32(s0)
     44a:	00170793          	addi	a5,a4,1
     44e:	fef43023          	sd	a5,-32(s0)
     452:	fe843783          	ld	a5,-24(s0)
     456:	00178693          	addi	a3,a5,1
     45a:	fed43423          	sd	a3,-24(s0)
     45e:	00074703          	lbu	a4,0(a4)
     462:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
     466:	fcc42783          	lw	a5,-52(s0)
     46a:	fff7871b          	addiw	a4,a5,-1
     46e:	fce42623          	sw	a4,-52(s0)
     472:	fcf04ae3          	bgtz	a5,446 <memmove+0x32>
     476:	a891                	j	4ca <memmove+0xb6>
  } else {
    dst += n;
     478:	fcc42783          	lw	a5,-52(s0)
     47c:	fe843703          	ld	a4,-24(s0)
     480:	97ba                	add	a5,a5,a4
     482:	fef43423          	sd	a5,-24(s0)
    src += n;
     486:	fcc42783          	lw	a5,-52(s0)
     48a:	fe043703          	ld	a4,-32(s0)
     48e:	97ba                	add	a5,a5,a4
     490:	fef43023          	sd	a5,-32(s0)
    while(n-- > 0)
     494:	a01d                	j	4ba <memmove+0xa6>
      *--dst = *--src;
     496:	fe043783          	ld	a5,-32(s0)
     49a:	17fd                	addi	a5,a5,-1
     49c:	fef43023          	sd	a5,-32(s0)
     4a0:	fe843783          	ld	a5,-24(s0)
     4a4:	17fd                	addi	a5,a5,-1
     4a6:	fef43423          	sd	a5,-24(s0)
     4aa:	fe043783          	ld	a5,-32(s0)
     4ae:	0007c703          	lbu	a4,0(a5)
     4b2:	fe843783          	ld	a5,-24(s0)
     4b6:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
     4ba:	fcc42783          	lw	a5,-52(s0)
     4be:	fff7871b          	addiw	a4,a5,-1
     4c2:	fce42623          	sw	a4,-52(s0)
     4c6:	fcf048e3          	bgtz	a5,496 <memmove+0x82>
  }
  return vdst;
     4ca:	fd843783          	ld	a5,-40(s0)
}
     4ce:	853e                	mv	a0,a5
     4d0:	7462                	ld	s0,56(sp)
     4d2:	6121                	addi	sp,sp,64
     4d4:	8082                	ret

00000000000004d6 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     4d6:	7139                	addi	sp,sp,-64
     4d8:	fc22                	sd	s0,56(sp)
     4da:	0080                	addi	s0,sp,64
     4dc:	fca43c23          	sd	a0,-40(s0)
     4e0:	fcb43823          	sd	a1,-48(s0)
     4e4:	87b2                	mv	a5,a2
     4e6:	fcf42623          	sw	a5,-52(s0)
  const char *p1 = s1, *p2 = s2;
     4ea:	fd843783          	ld	a5,-40(s0)
     4ee:	fef43423          	sd	a5,-24(s0)
     4f2:	fd043783          	ld	a5,-48(s0)
     4f6:	fef43023          	sd	a5,-32(s0)
  while (n-- > 0) {
     4fa:	a0a1                	j	542 <memcmp+0x6c>
    if (*p1 != *p2) {
     4fc:	fe843783          	ld	a5,-24(s0)
     500:	0007c703          	lbu	a4,0(a5)
     504:	fe043783          	ld	a5,-32(s0)
     508:	0007c783          	lbu	a5,0(a5)
     50c:	02f70163          	beq	a4,a5,52e <memcmp+0x58>
      return *p1 - *p2;
     510:	fe843783          	ld	a5,-24(s0)
     514:	0007c783          	lbu	a5,0(a5)
     518:	0007871b          	sext.w	a4,a5
     51c:	fe043783          	ld	a5,-32(s0)
     520:	0007c783          	lbu	a5,0(a5)
     524:	2781                	sext.w	a5,a5
     526:	40f707bb          	subw	a5,a4,a5
     52a:	2781                	sext.w	a5,a5
     52c:	a01d                	j	552 <memcmp+0x7c>
    }
    p1++;
     52e:	fe843783          	ld	a5,-24(s0)
     532:	0785                	addi	a5,a5,1
     534:	fef43423          	sd	a5,-24(s0)
    p2++;
     538:	fe043783          	ld	a5,-32(s0)
     53c:	0785                	addi	a5,a5,1
     53e:	fef43023          	sd	a5,-32(s0)
  while (n-- > 0) {
     542:	fcc42783          	lw	a5,-52(s0)
     546:	fff7871b          	addiw	a4,a5,-1
     54a:	fce42623          	sw	a4,-52(s0)
     54e:	f7dd                	bnez	a5,4fc <memcmp+0x26>
  }
  return 0;
     550:	4781                	li	a5,0
}
     552:	853e                	mv	a0,a5
     554:	7462                	ld	s0,56(sp)
     556:	6121                	addi	sp,sp,64
     558:	8082                	ret

000000000000055a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     55a:	7179                	addi	sp,sp,-48
     55c:	f406                	sd	ra,40(sp)
     55e:	f022                	sd	s0,32(sp)
     560:	1800                	addi	s0,sp,48
     562:	fea43423          	sd	a0,-24(s0)
     566:	feb43023          	sd	a1,-32(s0)
     56a:	87b2                	mv	a5,a2
     56c:	fcf42e23          	sw	a5,-36(s0)
  return memmove(dst, src, n);
     570:	fdc42783          	lw	a5,-36(s0)
     574:	863e                	mv	a2,a5
     576:	fe043583          	ld	a1,-32(s0)
     57a:	fe843503          	ld	a0,-24(s0)
     57e:	00000097          	auipc	ra,0x0
     582:	e96080e7          	jalr	-362(ra) # 414 <memmove>
     586:	87aa                	mv	a5,a0
}
     588:	853e                	mv	a0,a5
     58a:	70a2                	ld	ra,40(sp)
     58c:	7402                	ld	s0,32(sp)
     58e:	6145                	addi	sp,sp,48
     590:	8082                	ret

0000000000000592 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     592:	4885                	li	a7,1
 ecall
     594:	00000073          	ecall
 ret
     598:	8082                	ret

000000000000059a <exit>:
.global exit
exit:
 li a7, SYS_exit
     59a:	4889                	li	a7,2
 ecall
     59c:	00000073          	ecall
 ret
     5a0:	8082                	ret

00000000000005a2 <wait>:
.global wait
wait:
 li a7, SYS_wait
     5a2:	488d                	li	a7,3
 ecall
     5a4:	00000073          	ecall
 ret
     5a8:	8082                	ret

00000000000005aa <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     5aa:	4891                	li	a7,4
 ecall
     5ac:	00000073          	ecall
 ret
     5b0:	8082                	ret

00000000000005b2 <read>:
.global read
read:
 li a7, SYS_read
     5b2:	4895                	li	a7,5
 ecall
     5b4:	00000073          	ecall
 ret
     5b8:	8082                	ret

00000000000005ba <write>:
.global write
write:
 li a7, SYS_write
     5ba:	48c1                	li	a7,16
 ecall
     5bc:	00000073          	ecall
 ret
     5c0:	8082                	ret

00000000000005c2 <close>:
.global close
close:
 li a7, SYS_close
     5c2:	48d5                	li	a7,21
 ecall
     5c4:	00000073          	ecall
 ret
     5c8:	8082                	ret

00000000000005ca <kill>:
.global kill
kill:
 li a7, SYS_kill
     5ca:	4899                	li	a7,6
 ecall
     5cc:	00000073          	ecall
 ret
     5d0:	8082                	ret

00000000000005d2 <exec>:
.global exec
exec:
 li a7, SYS_exec
     5d2:	489d                	li	a7,7
 ecall
     5d4:	00000073          	ecall
 ret
     5d8:	8082                	ret

00000000000005da <open>:
.global open
open:
 li a7, SYS_open
     5da:	48bd                	li	a7,15
 ecall
     5dc:	00000073          	ecall
 ret
     5e0:	8082                	ret

00000000000005e2 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     5e2:	48c5                	li	a7,17
 ecall
     5e4:	00000073          	ecall
 ret
     5e8:	8082                	ret

00000000000005ea <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     5ea:	48c9                	li	a7,18
 ecall
     5ec:	00000073          	ecall
 ret
     5f0:	8082                	ret

00000000000005f2 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     5f2:	48a1                	li	a7,8
 ecall
     5f4:	00000073          	ecall
 ret
     5f8:	8082                	ret

00000000000005fa <link>:
.global link
link:
 li a7, SYS_link
     5fa:	48cd                	li	a7,19
 ecall
     5fc:	00000073          	ecall
 ret
     600:	8082                	ret

0000000000000602 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     602:	48d1                	li	a7,20
 ecall
     604:	00000073          	ecall
 ret
     608:	8082                	ret

000000000000060a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     60a:	48a5                	li	a7,9
 ecall
     60c:	00000073          	ecall
 ret
     610:	8082                	ret

0000000000000612 <dup>:
.global dup
dup:
 li a7, SYS_dup
     612:	48a9                	li	a7,10
 ecall
     614:	00000073          	ecall
 ret
     618:	8082                	ret

000000000000061a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     61a:	48ad                	li	a7,11
 ecall
     61c:	00000073          	ecall
 ret
     620:	8082                	ret

0000000000000622 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     622:	48b1                	li	a7,12
 ecall
     624:	00000073          	ecall
 ret
     628:	8082                	ret

000000000000062a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     62a:	48b5                	li	a7,13
 ecall
     62c:	00000073          	ecall
 ret
     630:	8082                	ret

0000000000000632 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     632:	48b9                	li	a7,14
 ecall
     634:	00000073          	ecall
 ret
     638:	8082                	ret

000000000000063a <thrdstop>:
.global thrdstop
thrdstop:
 li a7, SYS_thrdstop
     63a:	48d9                	li	a7,22
 ecall
     63c:	00000073          	ecall
 ret
     640:	8082                	ret

0000000000000642 <thrdresume>:
.global thrdresume
thrdresume:
 li a7, SYS_thrdresume
     642:	48dd                	li	a7,23
 ecall
     644:	00000073          	ecall
 ret
     648:	8082                	ret

000000000000064a <cancelthrdstop>:
.global cancelthrdstop
cancelthrdstop:
 li a7, SYS_cancelthrdstop
     64a:	48e1                	li	a7,24
 ecall
     64c:	00000073          	ecall
 ret
     650:	8082                	ret

0000000000000652 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     652:	1101                	addi	sp,sp,-32
     654:	ec06                	sd	ra,24(sp)
     656:	e822                	sd	s0,16(sp)
     658:	1000                	addi	s0,sp,32
     65a:	87aa                	mv	a5,a0
     65c:	872e                	mv	a4,a1
     65e:	fef42623          	sw	a5,-20(s0)
     662:	87ba                	mv	a5,a4
     664:	fef405a3          	sb	a5,-21(s0)
  write(fd, &c, 1);
     668:	feb40713          	addi	a4,s0,-21
     66c:	fec42783          	lw	a5,-20(s0)
     670:	4605                	li	a2,1
     672:	85ba                	mv	a1,a4
     674:	853e                	mv	a0,a5
     676:	00000097          	auipc	ra,0x0
     67a:	f44080e7          	jalr	-188(ra) # 5ba <write>
}
     67e:	0001                	nop
     680:	60e2                	ld	ra,24(sp)
     682:	6442                	ld	s0,16(sp)
     684:	6105                	addi	sp,sp,32
     686:	8082                	ret

0000000000000688 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     688:	7139                	addi	sp,sp,-64
     68a:	fc06                	sd	ra,56(sp)
     68c:	f822                	sd	s0,48(sp)
     68e:	0080                	addi	s0,sp,64
     690:	87aa                	mv	a5,a0
     692:	8736                	mv	a4,a3
     694:	fcf42623          	sw	a5,-52(s0)
     698:	87ae                	mv	a5,a1
     69a:	fcf42423          	sw	a5,-56(s0)
     69e:	87b2                	mv	a5,a2
     6a0:	fcf42223          	sw	a5,-60(s0)
     6a4:	87ba                	mv	a5,a4
     6a6:	fcf42023          	sw	a5,-64(s0)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
     6aa:	fe042423          	sw	zero,-24(s0)
  if(sgn && xx < 0){
     6ae:	fc042783          	lw	a5,-64(s0)
     6b2:	2781                	sext.w	a5,a5
     6b4:	c38d                	beqz	a5,6d6 <printint+0x4e>
     6b6:	fc842783          	lw	a5,-56(s0)
     6ba:	2781                	sext.w	a5,a5
     6bc:	0007dd63          	bgez	a5,6d6 <printint+0x4e>
    neg = 1;
     6c0:	4785                	li	a5,1
     6c2:	fef42423          	sw	a5,-24(s0)
    x = -xx;
     6c6:	fc842783          	lw	a5,-56(s0)
     6ca:	40f007bb          	negw	a5,a5
     6ce:	2781                	sext.w	a5,a5
     6d0:	fef42223          	sw	a5,-28(s0)
     6d4:	a029                	j	6de <printint+0x56>
  } else {
    x = xx;
     6d6:	fc842783          	lw	a5,-56(s0)
     6da:	fef42223          	sw	a5,-28(s0)
  }

  i = 0;
     6de:	fe042623          	sw	zero,-20(s0)
  do{
    buf[i++] = digits[x % base];
     6e2:	fc442783          	lw	a5,-60(s0)
     6e6:	fe442703          	lw	a4,-28(s0)
     6ea:	02f777bb          	remuw	a5,a4,a5
     6ee:	0007861b          	sext.w	a2,a5
     6f2:	fec42783          	lw	a5,-20(s0)
     6f6:	0017871b          	addiw	a4,a5,1
     6fa:	fee42623          	sw	a4,-20(s0)
     6fe:	00002697          	auipc	a3,0x2
     702:	eb268693          	addi	a3,a3,-334 # 25b0 <digits>
     706:	02061713          	slli	a4,a2,0x20
     70a:	9301                	srli	a4,a4,0x20
     70c:	9736                	add	a4,a4,a3
     70e:	00074703          	lbu	a4,0(a4)
     712:	ff040693          	addi	a3,s0,-16
     716:	97b6                	add	a5,a5,a3
     718:	fee78023          	sb	a4,-32(a5)
  }while((x /= base) != 0);
     71c:	fc442783          	lw	a5,-60(s0)
     720:	fe442703          	lw	a4,-28(s0)
     724:	02f757bb          	divuw	a5,a4,a5
     728:	fef42223          	sw	a5,-28(s0)
     72c:	fe442783          	lw	a5,-28(s0)
     730:	2781                	sext.w	a5,a5
     732:	fbc5                	bnez	a5,6e2 <printint+0x5a>
  if(neg)
     734:	fe842783          	lw	a5,-24(s0)
     738:	2781                	sext.w	a5,a5
     73a:	cf95                	beqz	a5,776 <printint+0xee>
    buf[i++] = '-';
     73c:	fec42783          	lw	a5,-20(s0)
     740:	0017871b          	addiw	a4,a5,1
     744:	fee42623          	sw	a4,-20(s0)
     748:	ff040713          	addi	a4,s0,-16
     74c:	97ba                	add	a5,a5,a4
     74e:	02d00713          	li	a4,45
     752:	fee78023          	sb	a4,-32(a5)

  while(--i >= 0)
     756:	a005                	j	776 <printint+0xee>
    putc(fd, buf[i]);
     758:	fec42783          	lw	a5,-20(s0)
     75c:	ff040713          	addi	a4,s0,-16
     760:	97ba                	add	a5,a5,a4
     762:	fe07c703          	lbu	a4,-32(a5)
     766:	fcc42783          	lw	a5,-52(s0)
     76a:	85ba                	mv	a1,a4
     76c:	853e                	mv	a0,a5
     76e:	00000097          	auipc	ra,0x0
     772:	ee4080e7          	jalr	-284(ra) # 652 <putc>
  while(--i >= 0)
     776:	fec42783          	lw	a5,-20(s0)
     77a:	37fd                	addiw	a5,a5,-1
     77c:	fef42623          	sw	a5,-20(s0)
     780:	fec42783          	lw	a5,-20(s0)
     784:	2781                	sext.w	a5,a5
     786:	fc07d9e3          	bgez	a5,758 <printint+0xd0>
}
     78a:	0001                	nop
     78c:	0001                	nop
     78e:	70e2                	ld	ra,56(sp)
     790:	7442                	ld	s0,48(sp)
     792:	6121                	addi	sp,sp,64
     794:	8082                	ret

0000000000000796 <printptr>:

static void
printptr(int fd, uint64 x) {
     796:	7179                	addi	sp,sp,-48
     798:	f406                	sd	ra,40(sp)
     79a:	f022                	sd	s0,32(sp)
     79c:	1800                	addi	s0,sp,48
     79e:	87aa                	mv	a5,a0
     7a0:	fcb43823          	sd	a1,-48(s0)
     7a4:	fcf42e23          	sw	a5,-36(s0)
  int i;
  putc(fd, '0');
     7a8:	fdc42783          	lw	a5,-36(s0)
     7ac:	03000593          	li	a1,48
     7b0:	853e                	mv	a0,a5
     7b2:	00000097          	auipc	ra,0x0
     7b6:	ea0080e7          	jalr	-352(ra) # 652 <putc>
  putc(fd, 'x');
     7ba:	fdc42783          	lw	a5,-36(s0)
     7be:	07800593          	li	a1,120
     7c2:	853e                	mv	a0,a5
     7c4:	00000097          	auipc	ra,0x0
     7c8:	e8e080e7          	jalr	-370(ra) # 652 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
     7cc:	fe042623          	sw	zero,-20(s0)
     7d0:	a82d                	j	80a <printptr+0x74>
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     7d2:	fd043783          	ld	a5,-48(s0)
     7d6:	93f1                	srli	a5,a5,0x3c
     7d8:	00002717          	auipc	a4,0x2
     7dc:	dd870713          	addi	a4,a4,-552 # 25b0 <digits>
     7e0:	97ba                	add	a5,a5,a4
     7e2:	0007c703          	lbu	a4,0(a5)
     7e6:	fdc42783          	lw	a5,-36(s0)
     7ea:	85ba                	mv	a1,a4
     7ec:	853e                	mv	a0,a5
     7ee:	00000097          	auipc	ra,0x0
     7f2:	e64080e7          	jalr	-412(ra) # 652 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
     7f6:	fec42783          	lw	a5,-20(s0)
     7fa:	2785                	addiw	a5,a5,1
     7fc:	fef42623          	sw	a5,-20(s0)
     800:	fd043783          	ld	a5,-48(s0)
     804:	0792                	slli	a5,a5,0x4
     806:	fcf43823          	sd	a5,-48(s0)
     80a:	fec42783          	lw	a5,-20(s0)
     80e:	873e                	mv	a4,a5
     810:	47bd                	li	a5,15
     812:	fce7f0e3          	bgeu	a5,a4,7d2 <printptr+0x3c>
}
     816:	0001                	nop
     818:	0001                	nop
     81a:	70a2                	ld	ra,40(sp)
     81c:	7402                	ld	s0,32(sp)
     81e:	6145                	addi	sp,sp,48
     820:	8082                	ret

0000000000000822 <vprintf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     822:	715d                	addi	sp,sp,-80
     824:	e486                	sd	ra,72(sp)
     826:	e0a2                	sd	s0,64(sp)
     828:	0880                	addi	s0,sp,80
     82a:	87aa                	mv	a5,a0
     82c:	fcb43023          	sd	a1,-64(s0)
     830:	fac43c23          	sd	a2,-72(s0)
     834:	fcf42623          	sw	a5,-52(s0)
  char *s;
  int c, i, state;

  state = 0;
     838:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
     83c:	fe042223          	sw	zero,-28(s0)
     840:	a42d                	j	a6a <vprintf+0x248>
    c = fmt[i] & 0xff;
     842:	fe442783          	lw	a5,-28(s0)
     846:	fc043703          	ld	a4,-64(s0)
     84a:	97ba                	add	a5,a5,a4
     84c:	0007c783          	lbu	a5,0(a5)
     850:	fcf42e23          	sw	a5,-36(s0)
    if(state == 0){
     854:	fe042783          	lw	a5,-32(s0)
     858:	2781                	sext.w	a5,a5
     85a:	eb9d                	bnez	a5,890 <vprintf+0x6e>
      if(c == '%'){
     85c:	fdc42783          	lw	a5,-36(s0)
     860:	0007871b          	sext.w	a4,a5
     864:	02500793          	li	a5,37
     868:	00f71763          	bne	a4,a5,876 <vprintf+0x54>
        state = '%';
     86c:	02500793          	li	a5,37
     870:	fef42023          	sw	a5,-32(s0)
     874:	a2f5                	j	a60 <vprintf+0x23e>
      } else {
        putc(fd, c);
     876:	fdc42783          	lw	a5,-36(s0)
     87a:	0ff7f713          	andi	a4,a5,255
     87e:	fcc42783          	lw	a5,-52(s0)
     882:	85ba                	mv	a1,a4
     884:	853e                	mv	a0,a5
     886:	00000097          	auipc	ra,0x0
     88a:	dcc080e7          	jalr	-564(ra) # 652 <putc>
     88e:	aac9                	j	a60 <vprintf+0x23e>
      }
    } else if(state == '%'){
     890:	fe042783          	lw	a5,-32(s0)
     894:	0007871b          	sext.w	a4,a5
     898:	02500793          	li	a5,37
     89c:	1cf71263          	bne	a4,a5,a60 <vprintf+0x23e>
      if(c == 'd'){
     8a0:	fdc42783          	lw	a5,-36(s0)
     8a4:	0007871b          	sext.w	a4,a5
     8a8:	06400793          	li	a5,100
     8ac:	02f71463          	bne	a4,a5,8d4 <vprintf+0xb2>
        printint(fd, va_arg(ap, int), 10, 1);
     8b0:	fb843783          	ld	a5,-72(s0)
     8b4:	00878713          	addi	a4,a5,8
     8b8:	fae43c23          	sd	a4,-72(s0)
     8bc:	4398                	lw	a4,0(a5)
     8be:	fcc42783          	lw	a5,-52(s0)
     8c2:	4685                	li	a3,1
     8c4:	4629                	li	a2,10
     8c6:	85ba                	mv	a1,a4
     8c8:	853e                	mv	a0,a5
     8ca:	00000097          	auipc	ra,0x0
     8ce:	dbe080e7          	jalr	-578(ra) # 688 <printint>
     8d2:	a269                	j	a5c <vprintf+0x23a>
      } else if(c == 'l') {
     8d4:	fdc42783          	lw	a5,-36(s0)
     8d8:	0007871b          	sext.w	a4,a5
     8dc:	06c00793          	li	a5,108
     8e0:	02f71663          	bne	a4,a5,90c <vprintf+0xea>
        printint(fd, va_arg(ap, uint64), 10, 0);
     8e4:	fb843783          	ld	a5,-72(s0)
     8e8:	00878713          	addi	a4,a5,8
     8ec:	fae43c23          	sd	a4,-72(s0)
     8f0:	639c                	ld	a5,0(a5)
     8f2:	0007871b          	sext.w	a4,a5
     8f6:	fcc42783          	lw	a5,-52(s0)
     8fa:	4681                	li	a3,0
     8fc:	4629                	li	a2,10
     8fe:	85ba                	mv	a1,a4
     900:	853e                	mv	a0,a5
     902:	00000097          	auipc	ra,0x0
     906:	d86080e7          	jalr	-634(ra) # 688 <printint>
     90a:	aa89                	j	a5c <vprintf+0x23a>
      } else if(c == 'x') {
     90c:	fdc42783          	lw	a5,-36(s0)
     910:	0007871b          	sext.w	a4,a5
     914:	07800793          	li	a5,120
     918:	02f71463          	bne	a4,a5,940 <vprintf+0x11e>
        printint(fd, va_arg(ap, int), 16, 0);
     91c:	fb843783          	ld	a5,-72(s0)
     920:	00878713          	addi	a4,a5,8
     924:	fae43c23          	sd	a4,-72(s0)
     928:	4398                	lw	a4,0(a5)
     92a:	fcc42783          	lw	a5,-52(s0)
     92e:	4681                	li	a3,0
     930:	4641                	li	a2,16
     932:	85ba                	mv	a1,a4
     934:	853e                	mv	a0,a5
     936:	00000097          	auipc	ra,0x0
     93a:	d52080e7          	jalr	-686(ra) # 688 <printint>
     93e:	aa39                	j	a5c <vprintf+0x23a>
      } else if(c == 'p') {
     940:	fdc42783          	lw	a5,-36(s0)
     944:	0007871b          	sext.w	a4,a5
     948:	07000793          	li	a5,112
     94c:	02f71263          	bne	a4,a5,970 <vprintf+0x14e>
        printptr(fd, va_arg(ap, uint64));
     950:	fb843783          	ld	a5,-72(s0)
     954:	00878713          	addi	a4,a5,8
     958:	fae43c23          	sd	a4,-72(s0)
     95c:	6398                	ld	a4,0(a5)
     95e:	fcc42783          	lw	a5,-52(s0)
     962:	85ba                	mv	a1,a4
     964:	853e                	mv	a0,a5
     966:	00000097          	auipc	ra,0x0
     96a:	e30080e7          	jalr	-464(ra) # 796 <printptr>
     96e:	a0fd                	j	a5c <vprintf+0x23a>
      } else if(c == 's'){
     970:	fdc42783          	lw	a5,-36(s0)
     974:	0007871b          	sext.w	a4,a5
     978:	07300793          	li	a5,115
     97c:	04f71c63          	bne	a4,a5,9d4 <vprintf+0x1b2>
        s = va_arg(ap, char*);
     980:	fb843783          	ld	a5,-72(s0)
     984:	00878713          	addi	a4,a5,8
     988:	fae43c23          	sd	a4,-72(s0)
     98c:	639c                	ld	a5,0(a5)
     98e:	fef43423          	sd	a5,-24(s0)
        if(s == 0)
     992:	fe843783          	ld	a5,-24(s0)
     996:	eb8d                	bnez	a5,9c8 <vprintf+0x1a6>
          s = "(null)";
     998:	00002797          	auipc	a5,0x2
     99c:	ad078793          	addi	a5,a5,-1328 # 2468 <schedule_dm+0x2bc>
     9a0:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
     9a4:	a015                	j	9c8 <vprintf+0x1a6>
          putc(fd, *s);
     9a6:	fe843783          	ld	a5,-24(s0)
     9aa:	0007c703          	lbu	a4,0(a5)
     9ae:	fcc42783          	lw	a5,-52(s0)
     9b2:	85ba                	mv	a1,a4
     9b4:	853e                	mv	a0,a5
     9b6:	00000097          	auipc	ra,0x0
     9ba:	c9c080e7          	jalr	-868(ra) # 652 <putc>
          s++;
     9be:	fe843783          	ld	a5,-24(s0)
     9c2:	0785                	addi	a5,a5,1
     9c4:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
     9c8:	fe843783          	ld	a5,-24(s0)
     9cc:	0007c783          	lbu	a5,0(a5)
     9d0:	fbf9                	bnez	a5,9a6 <vprintf+0x184>
     9d2:	a069                	j	a5c <vprintf+0x23a>
        }
      } else if(c == 'c'){
     9d4:	fdc42783          	lw	a5,-36(s0)
     9d8:	0007871b          	sext.w	a4,a5
     9dc:	06300793          	li	a5,99
     9e0:	02f71463          	bne	a4,a5,a08 <vprintf+0x1e6>
        putc(fd, va_arg(ap, uint));
     9e4:	fb843783          	ld	a5,-72(s0)
     9e8:	00878713          	addi	a4,a5,8
     9ec:	fae43c23          	sd	a4,-72(s0)
     9f0:	439c                	lw	a5,0(a5)
     9f2:	0ff7f713          	andi	a4,a5,255
     9f6:	fcc42783          	lw	a5,-52(s0)
     9fa:	85ba                	mv	a1,a4
     9fc:	853e                	mv	a0,a5
     9fe:	00000097          	auipc	ra,0x0
     a02:	c54080e7          	jalr	-940(ra) # 652 <putc>
     a06:	a899                	j	a5c <vprintf+0x23a>
      } else if(c == '%'){
     a08:	fdc42783          	lw	a5,-36(s0)
     a0c:	0007871b          	sext.w	a4,a5
     a10:	02500793          	li	a5,37
     a14:	00f71f63          	bne	a4,a5,a32 <vprintf+0x210>
        putc(fd, c);
     a18:	fdc42783          	lw	a5,-36(s0)
     a1c:	0ff7f713          	andi	a4,a5,255
     a20:	fcc42783          	lw	a5,-52(s0)
     a24:	85ba                	mv	a1,a4
     a26:	853e                	mv	a0,a5
     a28:	00000097          	auipc	ra,0x0
     a2c:	c2a080e7          	jalr	-982(ra) # 652 <putc>
     a30:	a035                	j	a5c <vprintf+0x23a>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
     a32:	fcc42783          	lw	a5,-52(s0)
     a36:	02500593          	li	a1,37
     a3a:	853e                	mv	a0,a5
     a3c:	00000097          	auipc	ra,0x0
     a40:	c16080e7          	jalr	-1002(ra) # 652 <putc>
        putc(fd, c);
     a44:	fdc42783          	lw	a5,-36(s0)
     a48:	0ff7f713          	andi	a4,a5,255
     a4c:	fcc42783          	lw	a5,-52(s0)
     a50:	85ba                	mv	a1,a4
     a52:	853e                	mv	a0,a5
     a54:	00000097          	auipc	ra,0x0
     a58:	bfe080e7          	jalr	-1026(ra) # 652 <putc>
      }
      state = 0;
     a5c:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
     a60:	fe442783          	lw	a5,-28(s0)
     a64:	2785                	addiw	a5,a5,1
     a66:	fef42223          	sw	a5,-28(s0)
     a6a:	fe442783          	lw	a5,-28(s0)
     a6e:	fc043703          	ld	a4,-64(s0)
     a72:	97ba                	add	a5,a5,a4
     a74:	0007c783          	lbu	a5,0(a5)
     a78:	dc0795e3          	bnez	a5,842 <vprintf+0x20>
    }
  }
}
     a7c:	0001                	nop
     a7e:	0001                	nop
     a80:	60a6                	ld	ra,72(sp)
     a82:	6406                	ld	s0,64(sp)
     a84:	6161                	addi	sp,sp,80
     a86:	8082                	ret

0000000000000a88 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
     a88:	7159                	addi	sp,sp,-112
     a8a:	fc06                	sd	ra,56(sp)
     a8c:	f822                	sd	s0,48(sp)
     a8e:	0080                	addi	s0,sp,64
     a90:	fcb43823          	sd	a1,-48(s0)
     a94:	e010                	sd	a2,0(s0)
     a96:	e414                	sd	a3,8(s0)
     a98:	e818                	sd	a4,16(s0)
     a9a:	ec1c                	sd	a5,24(s0)
     a9c:	03043023          	sd	a6,32(s0)
     aa0:	03143423          	sd	a7,40(s0)
     aa4:	87aa                	mv	a5,a0
     aa6:	fcf42e23          	sw	a5,-36(s0)
  va_list ap;

  va_start(ap, fmt);
     aaa:	03040793          	addi	a5,s0,48
     aae:	fcf43423          	sd	a5,-56(s0)
     ab2:	fc843783          	ld	a5,-56(s0)
     ab6:	fd078793          	addi	a5,a5,-48
     aba:	fef43423          	sd	a5,-24(s0)
  vprintf(fd, fmt, ap);
     abe:	fe843703          	ld	a4,-24(s0)
     ac2:	fdc42783          	lw	a5,-36(s0)
     ac6:	863a                	mv	a2,a4
     ac8:	fd043583          	ld	a1,-48(s0)
     acc:	853e                	mv	a0,a5
     ace:	00000097          	auipc	ra,0x0
     ad2:	d54080e7          	jalr	-684(ra) # 822 <vprintf>
}
     ad6:	0001                	nop
     ad8:	70e2                	ld	ra,56(sp)
     ada:	7442                	ld	s0,48(sp)
     adc:	6165                	addi	sp,sp,112
     ade:	8082                	ret

0000000000000ae0 <printf>:

void
printf(const char *fmt, ...)
{
     ae0:	7159                	addi	sp,sp,-112
     ae2:	f406                	sd	ra,40(sp)
     ae4:	f022                	sd	s0,32(sp)
     ae6:	1800                	addi	s0,sp,48
     ae8:	fca43c23          	sd	a0,-40(s0)
     aec:	e40c                	sd	a1,8(s0)
     aee:	e810                	sd	a2,16(s0)
     af0:	ec14                	sd	a3,24(s0)
     af2:	f018                	sd	a4,32(s0)
     af4:	f41c                	sd	a5,40(s0)
     af6:	03043823          	sd	a6,48(s0)
     afa:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
     afe:	04040793          	addi	a5,s0,64
     b02:	fcf43823          	sd	a5,-48(s0)
     b06:	fd043783          	ld	a5,-48(s0)
     b0a:	fc878793          	addi	a5,a5,-56
     b0e:	fef43423          	sd	a5,-24(s0)
  vprintf(1, fmt, ap);
     b12:	fe843783          	ld	a5,-24(s0)
     b16:	863e                	mv	a2,a5
     b18:	fd843583          	ld	a1,-40(s0)
     b1c:	4505                	li	a0,1
     b1e:	00000097          	auipc	ra,0x0
     b22:	d04080e7          	jalr	-764(ra) # 822 <vprintf>
}
     b26:	0001                	nop
     b28:	70a2                	ld	ra,40(sp)
     b2a:	7402                	ld	s0,32(sp)
     b2c:	6165                	addi	sp,sp,112
     b2e:	8082                	ret

0000000000000b30 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
     b30:	7179                	addi	sp,sp,-48
     b32:	f422                	sd	s0,40(sp)
     b34:	1800                	addi	s0,sp,48
     b36:	fca43c23          	sd	a0,-40(s0)
  Header *bp, *p;

  bp = (Header*)ap - 1;
     b3a:	fd843783          	ld	a5,-40(s0)
     b3e:	17c1                	addi	a5,a5,-16
     b40:	fef43023          	sd	a5,-32(s0)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     b44:	00002797          	auipc	a5,0x2
     b48:	ac478793          	addi	a5,a5,-1340 # 2608 <freep>
     b4c:	639c                	ld	a5,0(a5)
     b4e:	fef43423          	sd	a5,-24(s0)
     b52:	a815                	j	b86 <free+0x56>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     b54:	fe843783          	ld	a5,-24(s0)
     b58:	639c                	ld	a5,0(a5)
     b5a:	fe843703          	ld	a4,-24(s0)
     b5e:	00f76f63          	bltu	a4,a5,b7c <free+0x4c>
     b62:	fe043703          	ld	a4,-32(s0)
     b66:	fe843783          	ld	a5,-24(s0)
     b6a:	02e7eb63          	bltu	a5,a4,ba0 <free+0x70>
     b6e:	fe843783          	ld	a5,-24(s0)
     b72:	639c                	ld	a5,0(a5)
     b74:	fe043703          	ld	a4,-32(s0)
     b78:	02f76463          	bltu	a4,a5,ba0 <free+0x70>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     b7c:	fe843783          	ld	a5,-24(s0)
     b80:	639c                	ld	a5,0(a5)
     b82:	fef43423          	sd	a5,-24(s0)
     b86:	fe043703          	ld	a4,-32(s0)
     b8a:	fe843783          	ld	a5,-24(s0)
     b8e:	fce7f3e3          	bgeu	a5,a4,b54 <free+0x24>
     b92:	fe843783          	ld	a5,-24(s0)
     b96:	639c                	ld	a5,0(a5)
     b98:	fe043703          	ld	a4,-32(s0)
     b9c:	faf77ce3          	bgeu	a4,a5,b54 <free+0x24>
      break;
  if(bp + bp->s.size == p->s.ptr){
     ba0:	fe043783          	ld	a5,-32(s0)
     ba4:	479c                	lw	a5,8(a5)
     ba6:	1782                	slli	a5,a5,0x20
     ba8:	9381                	srli	a5,a5,0x20
     baa:	0792                	slli	a5,a5,0x4
     bac:	fe043703          	ld	a4,-32(s0)
     bb0:	973e                	add	a4,a4,a5
     bb2:	fe843783          	ld	a5,-24(s0)
     bb6:	639c                	ld	a5,0(a5)
     bb8:	02f71763          	bne	a4,a5,be6 <free+0xb6>
    bp->s.size += p->s.ptr->s.size;
     bbc:	fe043783          	ld	a5,-32(s0)
     bc0:	4798                	lw	a4,8(a5)
     bc2:	fe843783          	ld	a5,-24(s0)
     bc6:	639c                	ld	a5,0(a5)
     bc8:	479c                	lw	a5,8(a5)
     bca:	9fb9                	addw	a5,a5,a4
     bcc:	0007871b          	sext.w	a4,a5
     bd0:	fe043783          	ld	a5,-32(s0)
     bd4:	c798                	sw	a4,8(a5)
    bp->s.ptr = p->s.ptr->s.ptr;
     bd6:	fe843783          	ld	a5,-24(s0)
     bda:	639c                	ld	a5,0(a5)
     bdc:	6398                	ld	a4,0(a5)
     bde:	fe043783          	ld	a5,-32(s0)
     be2:	e398                	sd	a4,0(a5)
     be4:	a039                	j	bf2 <free+0xc2>
  } else
    bp->s.ptr = p->s.ptr;
     be6:	fe843783          	ld	a5,-24(s0)
     bea:	6398                	ld	a4,0(a5)
     bec:	fe043783          	ld	a5,-32(s0)
     bf0:	e398                	sd	a4,0(a5)
  if(p + p->s.size == bp){
     bf2:	fe843783          	ld	a5,-24(s0)
     bf6:	479c                	lw	a5,8(a5)
     bf8:	1782                	slli	a5,a5,0x20
     bfa:	9381                	srli	a5,a5,0x20
     bfc:	0792                	slli	a5,a5,0x4
     bfe:	fe843703          	ld	a4,-24(s0)
     c02:	97ba                	add	a5,a5,a4
     c04:	fe043703          	ld	a4,-32(s0)
     c08:	02f71563          	bne	a4,a5,c32 <free+0x102>
    p->s.size += bp->s.size;
     c0c:	fe843783          	ld	a5,-24(s0)
     c10:	4798                	lw	a4,8(a5)
     c12:	fe043783          	ld	a5,-32(s0)
     c16:	479c                	lw	a5,8(a5)
     c18:	9fb9                	addw	a5,a5,a4
     c1a:	0007871b          	sext.w	a4,a5
     c1e:	fe843783          	ld	a5,-24(s0)
     c22:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
     c24:	fe043783          	ld	a5,-32(s0)
     c28:	6398                	ld	a4,0(a5)
     c2a:	fe843783          	ld	a5,-24(s0)
     c2e:	e398                	sd	a4,0(a5)
     c30:	a031                	j	c3c <free+0x10c>
  } else
    p->s.ptr = bp;
     c32:	fe843783          	ld	a5,-24(s0)
     c36:	fe043703          	ld	a4,-32(s0)
     c3a:	e398                	sd	a4,0(a5)
  freep = p;
     c3c:	00002797          	auipc	a5,0x2
     c40:	9cc78793          	addi	a5,a5,-1588 # 2608 <freep>
     c44:	fe843703          	ld	a4,-24(s0)
     c48:	e398                	sd	a4,0(a5)
}
     c4a:	0001                	nop
     c4c:	7422                	ld	s0,40(sp)
     c4e:	6145                	addi	sp,sp,48
     c50:	8082                	ret

0000000000000c52 <morecore>:

static Header*
morecore(uint nu)
{
     c52:	7179                	addi	sp,sp,-48
     c54:	f406                	sd	ra,40(sp)
     c56:	f022                	sd	s0,32(sp)
     c58:	1800                	addi	s0,sp,48
     c5a:	87aa                	mv	a5,a0
     c5c:	fcf42e23          	sw	a5,-36(s0)
  char *p;
  Header *hp;

  if(nu < 4096)
     c60:	fdc42783          	lw	a5,-36(s0)
     c64:	0007871b          	sext.w	a4,a5
     c68:	6785                	lui	a5,0x1
     c6a:	00f77563          	bgeu	a4,a5,c74 <morecore+0x22>
    nu = 4096;
     c6e:	6785                	lui	a5,0x1
     c70:	fcf42e23          	sw	a5,-36(s0)
  p = sbrk(nu * sizeof(Header));
     c74:	fdc42783          	lw	a5,-36(s0)
     c78:	0047979b          	slliw	a5,a5,0x4
     c7c:	2781                	sext.w	a5,a5
     c7e:	2781                	sext.w	a5,a5
     c80:	853e                	mv	a0,a5
     c82:	00000097          	auipc	ra,0x0
     c86:	9a0080e7          	jalr	-1632(ra) # 622 <sbrk>
     c8a:	fea43423          	sd	a0,-24(s0)
  if(p == (char*)-1)
     c8e:	fe843703          	ld	a4,-24(s0)
     c92:	57fd                	li	a5,-1
     c94:	00f71463          	bne	a4,a5,c9c <morecore+0x4a>
    return 0;
     c98:	4781                	li	a5,0
     c9a:	a03d                	j	cc8 <morecore+0x76>
  hp = (Header*)p;
     c9c:	fe843783          	ld	a5,-24(s0)
     ca0:	fef43023          	sd	a5,-32(s0)
  hp->s.size = nu;
     ca4:	fe043783          	ld	a5,-32(s0)
     ca8:	fdc42703          	lw	a4,-36(s0)
     cac:	c798                	sw	a4,8(a5)
  free((void*)(hp + 1));
     cae:	fe043783          	ld	a5,-32(s0)
     cb2:	07c1                	addi	a5,a5,16
     cb4:	853e                	mv	a0,a5
     cb6:	00000097          	auipc	ra,0x0
     cba:	e7a080e7          	jalr	-390(ra) # b30 <free>
  return freep;
     cbe:	00002797          	auipc	a5,0x2
     cc2:	94a78793          	addi	a5,a5,-1718 # 2608 <freep>
     cc6:	639c                	ld	a5,0(a5)
}
     cc8:	853e                	mv	a0,a5
     cca:	70a2                	ld	ra,40(sp)
     ccc:	7402                	ld	s0,32(sp)
     cce:	6145                	addi	sp,sp,48
     cd0:	8082                	ret

0000000000000cd2 <malloc>:

void*
malloc(uint nbytes)
{
     cd2:	7139                	addi	sp,sp,-64
     cd4:	fc06                	sd	ra,56(sp)
     cd6:	f822                	sd	s0,48(sp)
     cd8:	0080                	addi	s0,sp,64
     cda:	87aa                	mv	a5,a0
     cdc:	fcf42623          	sw	a5,-52(s0)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
     ce0:	fcc46783          	lwu	a5,-52(s0)
     ce4:	07bd                	addi	a5,a5,15
     ce6:	8391                	srli	a5,a5,0x4
     ce8:	2781                	sext.w	a5,a5
     cea:	2785                	addiw	a5,a5,1
     cec:	fcf42e23          	sw	a5,-36(s0)
  if((prevp = freep) == 0){
     cf0:	00002797          	auipc	a5,0x2
     cf4:	91878793          	addi	a5,a5,-1768 # 2608 <freep>
     cf8:	639c                	ld	a5,0(a5)
     cfa:	fef43023          	sd	a5,-32(s0)
     cfe:	fe043783          	ld	a5,-32(s0)
     d02:	ef95                	bnez	a5,d3e <malloc+0x6c>
    base.s.ptr = freep = prevp = &base;
     d04:	00002797          	auipc	a5,0x2
     d08:	8f478793          	addi	a5,a5,-1804 # 25f8 <base>
     d0c:	fef43023          	sd	a5,-32(s0)
     d10:	00002797          	auipc	a5,0x2
     d14:	8f878793          	addi	a5,a5,-1800 # 2608 <freep>
     d18:	fe043703          	ld	a4,-32(s0)
     d1c:	e398                	sd	a4,0(a5)
     d1e:	00002797          	auipc	a5,0x2
     d22:	8ea78793          	addi	a5,a5,-1814 # 2608 <freep>
     d26:	6398                	ld	a4,0(a5)
     d28:	00002797          	auipc	a5,0x2
     d2c:	8d078793          	addi	a5,a5,-1840 # 25f8 <base>
     d30:	e398                	sd	a4,0(a5)
    base.s.size = 0;
     d32:	00002797          	auipc	a5,0x2
     d36:	8c678793          	addi	a5,a5,-1850 # 25f8 <base>
     d3a:	0007a423          	sw	zero,8(a5)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     d3e:	fe043783          	ld	a5,-32(s0)
     d42:	639c                	ld	a5,0(a5)
     d44:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
     d48:	fe843783          	ld	a5,-24(s0)
     d4c:	4798                	lw	a4,8(a5)
     d4e:	fdc42783          	lw	a5,-36(s0)
     d52:	2781                	sext.w	a5,a5
     d54:	06f76863          	bltu	a4,a5,dc4 <malloc+0xf2>
      if(p->s.size == nunits)
     d58:	fe843783          	ld	a5,-24(s0)
     d5c:	4798                	lw	a4,8(a5)
     d5e:	fdc42783          	lw	a5,-36(s0)
     d62:	2781                	sext.w	a5,a5
     d64:	00e79963          	bne	a5,a4,d76 <malloc+0xa4>
        prevp->s.ptr = p->s.ptr;
     d68:	fe843783          	ld	a5,-24(s0)
     d6c:	6398                	ld	a4,0(a5)
     d6e:	fe043783          	ld	a5,-32(s0)
     d72:	e398                	sd	a4,0(a5)
     d74:	a82d                	j	dae <malloc+0xdc>
      else {
        p->s.size -= nunits;
     d76:	fe843783          	ld	a5,-24(s0)
     d7a:	4798                	lw	a4,8(a5)
     d7c:	fdc42783          	lw	a5,-36(s0)
     d80:	40f707bb          	subw	a5,a4,a5
     d84:	0007871b          	sext.w	a4,a5
     d88:	fe843783          	ld	a5,-24(s0)
     d8c:	c798                	sw	a4,8(a5)
        p += p->s.size;
     d8e:	fe843783          	ld	a5,-24(s0)
     d92:	479c                	lw	a5,8(a5)
     d94:	1782                	slli	a5,a5,0x20
     d96:	9381                	srli	a5,a5,0x20
     d98:	0792                	slli	a5,a5,0x4
     d9a:	fe843703          	ld	a4,-24(s0)
     d9e:	97ba                	add	a5,a5,a4
     da0:	fef43423          	sd	a5,-24(s0)
        p->s.size = nunits;
     da4:	fe843783          	ld	a5,-24(s0)
     da8:	fdc42703          	lw	a4,-36(s0)
     dac:	c798                	sw	a4,8(a5)
      }
      freep = prevp;
     dae:	00002797          	auipc	a5,0x2
     db2:	85a78793          	addi	a5,a5,-1958 # 2608 <freep>
     db6:	fe043703          	ld	a4,-32(s0)
     dba:	e398                	sd	a4,0(a5)
      return (void*)(p + 1);
     dbc:	fe843783          	ld	a5,-24(s0)
     dc0:	07c1                	addi	a5,a5,16
     dc2:	a091                	j	e06 <malloc+0x134>
    }
    if(p == freep)
     dc4:	00002797          	auipc	a5,0x2
     dc8:	84478793          	addi	a5,a5,-1980 # 2608 <freep>
     dcc:	639c                	ld	a5,0(a5)
     dce:	fe843703          	ld	a4,-24(s0)
     dd2:	02f71063          	bne	a4,a5,df2 <malloc+0x120>
      if((p = morecore(nunits)) == 0)
     dd6:	fdc42783          	lw	a5,-36(s0)
     dda:	853e                	mv	a0,a5
     ddc:	00000097          	auipc	ra,0x0
     de0:	e76080e7          	jalr	-394(ra) # c52 <morecore>
     de4:	fea43423          	sd	a0,-24(s0)
     de8:	fe843783          	ld	a5,-24(s0)
     dec:	e399                	bnez	a5,df2 <malloc+0x120>
        return 0;
     dee:	4781                	li	a5,0
     df0:	a819                	j	e06 <malloc+0x134>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     df2:	fe843783          	ld	a5,-24(s0)
     df6:	fef43023          	sd	a5,-32(s0)
     dfa:	fe843783          	ld	a5,-24(s0)
     dfe:	639c                	ld	a5,0(a5)
     e00:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
     e04:	b791                	j	d48 <malloc+0x76>
  }
}
     e06:	853e                	mv	a0,a5
     e08:	70e2                	ld	ra,56(sp)
     e0a:	7442                	ld	s0,48(sp)
     e0c:	6121                	addi	sp,sp,64
     e0e:	8082                	ret

0000000000000e10 <setjmp>:
     e10:	e100                	sd	s0,0(a0)
     e12:	e504                	sd	s1,8(a0)
     e14:	01253823          	sd	s2,16(a0)
     e18:	01353c23          	sd	s3,24(a0)
     e1c:	03453023          	sd	s4,32(a0)
     e20:	03553423          	sd	s5,40(a0)
     e24:	03653823          	sd	s6,48(a0)
     e28:	03753c23          	sd	s7,56(a0)
     e2c:	05853023          	sd	s8,64(a0)
     e30:	05953423          	sd	s9,72(a0)
     e34:	05a53823          	sd	s10,80(a0)
     e38:	05b53c23          	sd	s11,88(a0)
     e3c:	06153023          	sd	ra,96(a0)
     e40:	06253423          	sd	sp,104(a0)
     e44:	4501                	li	a0,0
     e46:	8082                	ret

0000000000000e48 <longjmp>:
     e48:	6100                	ld	s0,0(a0)
     e4a:	6504                	ld	s1,8(a0)
     e4c:	01053903          	ld	s2,16(a0)
     e50:	01853983          	ld	s3,24(a0)
     e54:	02053a03          	ld	s4,32(a0)
     e58:	02853a83          	ld	s5,40(a0)
     e5c:	03053b03          	ld	s6,48(a0)
     e60:	03853b83          	ld	s7,56(a0)
     e64:	04053c03          	ld	s8,64(a0)
     e68:	04853c83          	ld	s9,72(a0)
     e6c:	05053d03          	ld	s10,80(a0)
     e70:	05853d83          	ld	s11,88(a0)
     e74:	06053083          	ld	ra,96(a0)
     e78:	06853103          	ld	sp,104(a0)
     e7c:	c199                	beqz	a1,e82 <longjmp_1>
     e7e:	852e                	mv	a0,a1
     e80:	8082                	ret

0000000000000e82 <longjmp_1>:
     e82:	4505                	li	a0,1
     e84:	8082                	ret

0000000000000e86 <__list_add>:
 * the prev/next entries already!
 */
static inline void __list_add(struct list_head *new_entry,
                              struct list_head *prev,
                              struct list_head *next)
{
     e86:	7179                	addi	sp,sp,-48
     e88:	f422                	sd	s0,40(sp)
     e8a:	1800                	addi	s0,sp,48
     e8c:	fea43423          	sd	a0,-24(s0)
     e90:	feb43023          	sd	a1,-32(s0)
     e94:	fcc43c23          	sd	a2,-40(s0)
    next->prev = new_entry;
     e98:	fd843783          	ld	a5,-40(s0)
     e9c:	fe843703          	ld	a4,-24(s0)
     ea0:	e798                	sd	a4,8(a5)
    new_entry->next = next;
     ea2:	fe843783          	ld	a5,-24(s0)
     ea6:	fd843703          	ld	a4,-40(s0)
     eaa:	e398                	sd	a4,0(a5)
    new_entry->prev = prev;
     eac:	fe843783          	ld	a5,-24(s0)
     eb0:	fe043703          	ld	a4,-32(s0)
     eb4:	e798                	sd	a4,8(a5)
    prev->next = new_entry;
     eb6:	fe043783          	ld	a5,-32(s0)
     eba:	fe843703          	ld	a4,-24(s0)
     ebe:	e398                	sd	a4,0(a5)
}
     ec0:	0001                	nop
     ec2:	7422                	ld	s0,40(sp)
     ec4:	6145                	addi	sp,sp,48
     ec6:	8082                	ret

0000000000000ec8 <list_add_tail>:
 *
 * Insert a new entry before the specified head.
 * This is useful for implementing queues.
 */
static inline void list_add_tail(struct list_head *new_entry, struct list_head *head)
{
     ec8:	1101                	addi	sp,sp,-32
     eca:	ec06                	sd	ra,24(sp)
     ecc:	e822                	sd	s0,16(sp)
     ece:	1000                	addi	s0,sp,32
     ed0:	fea43423          	sd	a0,-24(s0)
     ed4:	feb43023          	sd	a1,-32(s0)
    __list_add(new_entry, head->prev, head);
     ed8:	fe043783          	ld	a5,-32(s0)
     edc:	679c                	ld	a5,8(a5)
     ede:	fe043603          	ld	a2,-32(s0)
     ee2:	85be                	mv	a1,a5
     ee4:	fe843503          	ld	a0,-24(s0)
     ee8:	00000097          	auipc	ra,0x0
     eec:	f9e080e7          	jalr	-98(ra) # e86 <__list_add>
}
     ef0:	0001                	nop
     ef2:	60e2                	ld	ra,24(sp)
     ef4:	6442                	ld	s0,16(sp)
     ef6:	6105                	addi	sp,sp,32
     ef8:	8082                	ret

0000000000000efa <__list_del>:
 *
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 */
static inline void __list_del(struct list_head *prev, struct list_head *next)
{
     efa:	1101                	addi	sp,sp,-32
     efc:	ec22                	sd	s0,24(sp)
     efe:	1000                	addi	s0,sp,32
     f00:	fea43423          	sd	a0,-24(s0)
     f04:	feb43023          	sd	a1,-32(s0)
    next->prev = prev;
     f08:	fe043783          	ld	a5,-32(s0)
     f0c:	fe843703          	ld	a4,-24(s0)
     f10:	e798                	sd	a4,8(a5)
    prev->next = next;
     f12:	fe843783          	ld	a5,-24(s0)
     f16:	fe043703          	ld	a4,-32(s0)
     f1a:	e398                	sd	a4,0(a5)
}
     f1c:	0001                	nop
     f1e:	6462                	ld	s0,24(sp)
     f20:	6105                	addi	sp,sp,32
     f22:	8082                	ret

0000000000000f24 <list_del>:
 * @entry: the element to delete from the list.
 * Note: list_empty on entry does not return true after this, the entry is
 * in an undefined state.
 */
static inline void list_del(struct list_head *entry)
{
     f24:	1101                	addi	sp,sp,-32
     f26:	ec06                	sd	ra,24(sp)
     f28:	e822                	sd	s0,16(sp)
     f2a:	1000                	addi	s0,sp,32
     f2c:	fea43423          	sd	a0,-24(s0)
    __list_del(entry->prev, entry->next);
     f30:	fe843783          	ld	a5,-24(s0)
     f34:	6798                	ld	a4,8(a5)
     f36:	fe843783          	ld	a5,-24(s0)
     f3a:	639c                	ld	a5,0(a5)
     f3c:	85be                	mv	a1,a5
     f3e:	853a                	mv	a0,a4
     f40:	00000097          	auipc	ra,0x0
     f44:	fba080e7          	jalr	-70(ra) # efa <__list_del>
    entry->next = LIST_POISON1;
     f48:	fe843783          	ld	a5,-24(s0)
     f4c:	00100737          	lui	a4,0x100
     f50:	10070713          	addi	a4,a4,256 # 100100 <__global_pointer$+0xfd350>
     f54:	e398                	sd	a4,0(a5)
    entry->prev = LIST_POISON2;
     f56:	fe843783          	ld	a5,-24(s0)
     f5a:	00200737          	lui	a4,0x200
     f5e:	20070713          	addi	a4,a4,512 # 200200 <__global_pointer$+0x1fd450>
     f62:	e798                	sd	a4,8(a5)
}
     f64:	0001                	nop
     f66:	60e2                	ld	ra,24(sp)
     f68:	6442                	ld	s0,16(sp)
     f6a:	6105                	addi	sp,sp,32
     f6c:	8082                	ret

0000000000000f6e <list_empty>:
/**
 * list_empty - tests whether a list is empty
 * @head: the list to test.
 */
static inline int list_empty(const struct list_head *head)
{
     f6e:	1101                	addi	sp,sp,-32
     f70:	ec22                	sd	s0,24(sp)
     f72:	1000                	addi	s0,sp,32
     f74:	fea43423          	sd	a0,-24(s0)
    return head->next == head;
     f78:	fe843783          	ld	a5,-24(s0)
     f7c:	639c                	ld	a5,0(a5)
     f7e:	fe843703          	ld	a4,-24(s0)
     f82:	40f707b3          	sub	a5,a4,a5
     f86:	0017b793          	seqz	a5,a5
     f8a:	0ff7f793          	andi	a5,a5,255
     f8e:	2781                	sext.w	a5,a5
}
     f90:	853e                	mv	a0,a5
     f92:	6462                	ld	s0,24(sp)
     f94:	6105                	addi	sp,sp,32
     f96:	8082                	ret

0000000000000f98 <thread_create>:

void __dispatch(void);
void __schedule(void);

struct thread *thread_create(void (*f)(void *), void *arg, int is_real_time, int processing_time, int period, int n)
{
     f98:	715d                	addi	sp,sp,-80
     f9a:	e486                	sd	ra,72(sp)
     f9c:	e0a2                	sd	s0,64(sp)
     f9e:	0880                	addi	s0,sp,80
     fa0:	fca43423          	sd	a0,-56(s0)
     fa4:	fcb43023          	sd	a1,-64(s0)
     fa8:	85b2                	mv	a1,a2
     faa:	8636                	mv	a2,a3
     fac:	86ba                	mv	a3,a4
     fae:	873e                	mv	a4,a5
     fb0:	87ae                	mv	a5,a1
     fb2:	faf42e23          	sw	a5,-68(s0)
     fb6:	87b2                	mv	a5,a2
     fb8:	faf42c23          	sw	a5,-72(s0)
     fbc:	87b6                	mv	a5,a3
     fbe:	faf42a23          	sw	a5,-76(s0)
     fc2:	87ba                	mv	a5,a4
     fc4:	faf42823          	sw	a5,-80(s0)
    static int _id = 1;
    struct thread *t = (struct thread *)malloc(sizeof(struct thread));
     fc8:	06000513          	li	a0,96
     fcc:	00000097          	auipc	ra,0x0
     fd0:	d06080e7          	jalr	-762(ra) # cd2 <malloc>
     fd4:	fea43423          	sd	a0,-24(s0)
    unsigned long new_stack_p;
    unsigned long new_stack;
    new_stack = (unsigned long)malloc(sizeof(unsigned long) * 0x200);
     fd8:	6505                	lui	a0,0x1
     fda:	00000097          	auipc	ra,0x0
     fde:	cf8080e7          	jalr	-776(ra) # cd2 <malloc>
     fe2:	87aa                	mv	a5,a0
     fe4:	fef43023          	sd	a5,-32(s0)
    new_stack_p = new_stack + 0x200 * 8 - 0x2 * 8;
     fe8:	fe043703          	ld	a4,-32(s0)
     fec:	6785                	lui	a5,0x1
     fee:	17c1                	addi	a5,a5,-16
     ff0:	97ba                	add	a5,a5,a4
     ff2:	fcf43c23          	sd	a5,-40(s0)
    t->fp = f;
     ff6:	fe843783          	ld	a5,-24(s0)
     ffa:	fc843703          	ld	a4,-56(s0)
     ffe:	e398                	sd	a4,0(a5)
    t->arg = arg;
    1000:	fe843783          	ld	a5,-24(s0)
    1004:	fc043703          	ld	a4,-64(s0)
    1008:	e798                	sd	a4,8(a5)
    t->ID = _id++;
    100a:	00001797          	auipc	a5,0x1
    100e:	5e278793          	addi	a5,a5,1506 # 25ec <_id.1229>
    1012:	439c                	lw	a5,0(a5)
    1014:	0017871b          	addiw	a4,a5,1
    1018:	0007069b          	sext.w	a3,a4
    101c:	00001717          	auipc	a4,0x1
    1020:	5d070713          	addi	a4,a4,1488 # 25ec <_id.1229>
    1024:	c314                	sw	a3,0(a4)
    1026:	fe843703          	ld	a4,-24(s0)
    102a:	df5c                	sw	a5,60(a4)
    t->buf_set = 0;
    102c:	fe843783          	ld	a5,-24(s0)
    1030:	0207a023          	sw	zero,32(a5)
    t->stack = (void *)new_stack;
    1034:	fe043703          	ld	a4,-32(s0)
    1038:	fe843783          	ld	a5,-24(s0)
    103c:	eb98                	sd	a4,16(a5)
    t->stack_p = (void *)new_stack_p;
    103e:	fd843703          	ld	a4,-40(s0)
    1042:	fe843783          	ld	a5,-24(s0)
    1046:	ef98                	sd	a4,24(a5)

    t->processing_time = processing_time;
    1048:	fe843783          	ld	a5,-24(s0)
    104c:	fb842703          	lw	a4,-72(s0)
    1050:	c3f8                	sw	a4,68(a5)
    t->period = period;
    1052:	fe843783          	ld	a5,-24(s0)
    1056:	fb442703          	lw	a4,-76(s0)
    105a:	cbb8                	sw	a4,80(a5)
    t->deadline = period;
    105c:	fe843783          	ld	a5,-24(s0)
    1060:	fb442703          	lw	a4,-76(s0)
    1064:	c7f8                	sw	a4,76(a5)
    t->n = n;
    1066:	fe843783          	ld	a5,-24(s0)
    106a:	fb042703          	lw	a4,-80(s0)
    106e:	cbf8                	sw	a4,84(a5)
    t->is_real_time = is_real_time;
    1070:	fe843783          	ld	a5,-24(s0)
    1074:	fbc42703          	lw	a4,-68(s0)
    1078:	c3b8                	sw	a4,64(a5)
    t->weight = 1;
    107a:	fe843783          	ld	a5,-24(s0)
    107e:	4705                	li	a4,1
    1080:	c7b8                	sw	a4,72(a5)
    t->remaining_time = processing_time;
    1082:	fe843783          	ld	a5,-24(s0)
    1086:	fb842703          	lw	a4,-72(s0)
    108a:	cfb8                	sw	a4,88(a5)
    t->current_deadline = 0;
    108c:	fe843783          	ld	a5,-24(s0)
    1090:	0407ae23          	sw	zero,92(a5)
    return t;
    1094:	fe843783          	ld	a5,-24(s0)
}
    1098:	853e                	mv	a0,a5
    109a:	60a6                	ld	ra,72(sp)
    109c:	6406                	ld	s0,64(sp)
    109e:	6161                	addi	sp,sp,80
    10a0:	8082                	ret

00000000000010a2 <thread_set_weight>:

void thread_set_weight(struct thread *t, int weight)
{
    10a2:	1101                	addi	sp,sp,-32
    10a4:	ec22                	sd	s0,24(sp)
    10a6:	1000                	addi	s0,sp,32
    10a8:	fea43423          	sd	a0,-24(s0)
    10ac:	87ae                	mv	a5,a1
    10ae:	fef42223          	sw	a5,-28(s0)
    t->weight = weight;
    10b2:	fe843783          	ld	a5,-24(s0)
    10b6:	fe442703          	lw	a4,-28(s0)
    10ba:	c7b8                	sw	a4,72(a5)
}
    10bc:	0001                	nop
    10be:	6462                	ld	s0,24(sp)
    10c0:	6105                	addi	sp,sp,32
    10c2:	8082                	ret

00000000000010c4 <thread_add_at>:

void thread_add_at(struct thread *t, int arrival_time)
{
    10c4:	7179                	addi	sp,sp,-48
    10c6:	f406                	sd	ra,40(sp)
    10c8:	f022                	sd	s0,32(sp)
    10ca:	1800                	addi	s0,sp,48
    10cc:	fca43c23          	sd	a0,-40(s0)
    10d0:	87ae                	mv	a5,a1
    10d2:	fcf42a23          	sw	a5,-44(s0)
    struct release_queue_entry *new_entry = (struct release_queue_entry *)malloc(sizeof(struct release_queue_entry));
    10d6:	02000513          	li	a0,32
    10da:	00000097          	auipc	ra,0x0
    10de:	bf8080e7          	jalr	-1032(ra) # cd2 <malloc>
    10e2:	fea43423          	sd	a0,-24(s0)
    new_entry->thrd = t;
    10e6:	fe843783          	ld	a5,-24(s0)
    10ea:	fd843703          	ld	a4,-40(s0)
    10ee:	e398                	sd	a4,0(a5)
    new_entry->release_time = arrival_time;
    10f0:	fe843783          	ld	a5,-24(s0)
    10f4:	fd442703          	lw	a4,-44(s0)
    10f8:	cf98                	sw	a4,24(a5)
    if (t->is_real_time) {
    10fa:	fd843783          	ld	a5,-40(s0)
    10fe:	43bc                	lw	a5,64(a5)
    1100:	c38d                	beqz	a5,1122 <thread_add_at+0x5e>
        t->current_deadline = arrival_time;
    1102:	fd843783          	ld	a5,-40(s0)
    1106:	fd442703          	lw	a4,-44(s0)
    110a:	cff8                	sw	a4,92(a5)
        t->current_deadline = arrival_time + t->deadline;
    110c:	fd843783          	ld	a5,-40(s0)
    1110:	47fc                	lw	a5,76(a5)
    1112:	fd442703          	lw	a4,-44(s0)
    1116:	9fb9                	addw	a5,a5,a4
    1118:	0007871b          	sext.w	a4,a5
    111c:	fd843783          	ld	a5,-40(s0)
    1120:	cff8                	sw	a4,92(a5)
    }
    list_add_tail(&new_entry->thread_list, &release_queue);
    1122:	fe843783          	ld	a5,-24(s0)
    1126:	07a1                	addi	a5,a5,8
    1128:	00001597          	auipc	a1,0x1
    112c:	4b058593          	addi	a1,a1,1200 # 25d8 <release_queue>
    1130:	853e                	mv	a0,a5
    1132:	00000097          	auipc	ra,0x0
    1136:	d96080e7          	jalr	-618(ra) # ec8 <list_add_tail>
}
    113a:	0001                	nop
    113c:	70a2                	ld	ra,40(sp)
    113e:	7402                	ld	s0,32(sp)
    1140:	6145                	addi	sp,sp,48
    1142:	8082                	ret

0000000000001144 <__release>:

void __release()
{
    1144:	7139                	addi	sp,sp,-64
    1146:	fc06                	sd	ra,56(sp)
    1148:	f822                	sd	s0,48(sp)
    114a:	0080                	addi	s0,sp,64
    struct release_queue_entry *cur, *nxt;
    list_for_each_entry_safe(cur, nxt, &release_queue, thread_list) {
    114c:	00001797          	auipc	a5,0x1
    1150:	48c78793          	addi	a5,a5,1164 # 25d8 <release_queue>
    1154:	639c                	ld	a5,0(a5)
    1156:	fcf43c23          	sd	a5,-40(s0)
    115a:	fd843783          	ld	a5,-40(s0)
    115e:	17e1                	addi	a5,a5,-8
    1160:	fef43423          	sd	a5,-24(s0)
    1164:	fe843783          	ld	a5,-24(s0)
    1168:	679c                	ld	a5,8(a5)
    116a:	fcf43823          	sd	a5,-48(s0)
    116e:	fd043783          	ld	a5,-48(s0)
    1172:	17e1                	addi	a5,a5,-8
    1174:	fef43023          	sd	a5,-32(s0)
    1178:	a851                	j	120c <__release+0xc8>
        if (threading_system_time >= cur->release_time) {
    117a:	fe843783          	ld	a5,-24(s0)
    117e:	4f98                	lw	a4,24(a5)
    1180:	00001797          	auipc	a5,0x1
    1184:	49878793          	addi	a5,a5,1176 # 2618 <threading_system_time>
    1188:	439c                	lw	a5,0(a5)
    118a:	06e7c363          	blt	a5,a4,11f0 <__release+0xac>
            cur->thrd->remaining_time = cur->thrd->processing_time;
    118e:	fe843783          	ld	a5,-24(s0)
    1192:	6398                	ld	a4,0(a5)
    1194:	fe843783          	ld	a5,-24(s0)
    1198:	639c                	ld	a5,0(a5)
    119a:	4378                	lw	a4,68(a4)
    119c:	cfb8                	sw	a4,88(a5)
            cur->thrd->current_deadline = cur->release_time + cur->thrd->deadline;
    119e:	fe843783          	ld	a5,-24(s0)
    11a2:	4f94                	lw	a3,24(a5)
    11a4:	fe843783          	ld	a5,-24(s0)
    11a8:	639c                	ld	a5,0(a5)
    11aa:	47f8                	lw	a4,76(a5)
    11ac:	fe843783          	ld	a5,-24(s0)
    11b0:	639c                	ld	a5,0(a5)
    11b2:	9f35                	addw	a4,a4,a3
    11b4:	2701                	sext.w	a4,a4
    11b6:	cff8                	sw	a4,92(a5)
            list_add_tail(&cur->thrd->thread_list, &run_queue);
    11b8:	fe843783          	ld	a5,-24(s0)
    11bc:	639c                	ld	a5,0(a5)
    11be:	02878793          	addi	a5,a5,40
    11c2:	00001597          	auipc	a1,0x1
    11c6:	40658593          	addi	a1,a1,1030 # 25c8 <run_queue>
    11ca:	853e                	mv	a0,a5
    11cc:	00000097          	auipc	ra,0x0
    11d0:	cfc080e7          	jalr	-772(ra) # ec8 <list_add_tail>
            list_del(&cur->thread_list);
    11d4:	fe843783          	ld	a5,-24(s0)
    11d8:	07a1                	addi	a5,a5,8
    11da:	853e                	mv	a0,a5
    11dc:	00000097          	auipc	ra,0x0
    11e0:	d48080e7          	jalr	-696(ra) # f24 <list_del>
            free(cur);
    11e4:	fe843503          	ld	a0,-24(s0)
    11e8:	00000097          	auipc	ra,0x0
    11ec:	948080e7          	jalr	-1720(ra) # b30 <free>
    list_for_each_entry_safe(cur, nxt, &release_queue, thread_list) {
    11f0:	fe043783          	ld	a5,-32(s0)
    11f4:	fef43423          	sd	a5,-24(s0)
    11f8:	fe043783          	ld	a5,-32(s0)
    11fc:	679c                	ld	a5,8(a5)
    11fe:	fcf43423          	sd	a5,-56(s0)
    1202:	fc843783          	ld	a5,-56(s0)
    1206:	17e1                	addi	a5,a5,-8
    1208:	fef43023          	sd	a5,-32(s0)
    120c:	fe843783          	ld	a5,-24(s0)
    1210:	00878713          	addi	a4,a5,8
    1214:	00001797          	auipc	a5,0x1
    1218:	3c478793          	addi	a5,a5,964 # 25d8 <release_queue>
    121c:	f4f71fe3          	bne	a4,a5,117a <__release+0x36>
        }
    }
}
    1220:	0001                	nop
    1222:	0001                	nop
    1224:	70e2                	ld	ra,56(sp)
    1226:	7442                	ld	s0,48(sp)
    1228:	6121                	addi	sp,sp,64
    122a:	8082                	ret

000000000000122c <__thread_exit>:

void __thread_exit(struct thread *to_remove)
{
    122c:	1101                	addi	sp,sp,-32
    122e:	ec06                	sd	ra,24(sp)
    1230:	e822                	sd	s0,16(sp)
    1232:	1000                	addi	s0,sp,32
    1234:	fea43423          	sd	a0,-24(s0)
    current = to_remove->thread_list.prev;
    1238:	fe843783          	ld	a5,-24(s0)
    123c:	7b98                	ld	a4,48(a5)
    123e:	00001797          	auipc	a5,0x1
    1242:	3d278793          	addi	a5,a5,978 # 2610 <current>
    1246:	e398                	sd	a4,0(a5)
    list_del(&to_remove->thread_list);
    1248:	fe843783          	ld	a5,-24(s0)
    124c:	02878793          	addi	a5,a5,40
    1250:	853e                	mv	a0,a5
    1252:	00000097          	auipc	ra,0x0
    1256:	cd2080e7          	jalr	-814(ra) # f24 <list_del>

    free(to_remove->stack);
    125a:	fe843783          	ld	a5,-24(s0)
    125e:	6b9c                	ld	a5,16(a5)
    1260:	853e                	mv	a0,a5
    1262:	00000097          	auipc	ra,0x0
    1266:	8ce080e7          	jalr	-1842(ra) # b30 <free>
    free(to_remove);
    126a:	fe843503          	ld	a0,-24(s0)
    126e:	00000097          	auipc	ra,0x0
    1272:	8c2080e7          	jalr	-1854(ra) # b30 <free>

    __schedule();
    1276:	00000097          	auipc	ra,0x0
    127a:	572080e7          	jalr	1394(ra) # 17e8 <__schedule>
    __dispatch();
    127e:	00000097          	auipc	ra,0x0
    1282:	3da080e7          	jalr	986(ra) # 1658 <__dispatch>
    thrdresume(main_thrd_id);
    1286:	00001797          	auipc	a5,0x1
    128a:	36278793          	addi	a5,a5,866 # 25e8 <main_thrd_id>
    128e:	439c                	lw	a5,0(a5)
    1290:	853e                	mv	a0,a5
    1292:	fffff097          	auipc	ra,0xfffff
    1296:	3b0080e7          	jalr	944(ra) # 642 <thrdresume>
}
    129a:	0001                	nop
    129c:	60e2                	ld	ra,24(sp)
    129e:	6442                	ld	s0,16(sp)
    12a0:	6105                	addi	sp,sp,32
    12a2:	8082                	ret

00000000000012a4 <thread_exit>:

void thread_exit(void)
{
    12a4:	7179                	addi	sp,sp,-48
    12a6:	f406                	sd	ra,40(sp)
    12a8:	f022                	sd	s0,32(sp)
    12aa:	1800                	addi	s0,sp,48
    if (current == &run_queue) {
    12ac:	00001797          	auipc	a5,0x1
    12b0:	36478793          	addi	a5,a5,868 # 2610 <current>
    12b4:	6398                	ld	a4,0(a5)
    12b6:	00001797          	auipc	a5,0x1
    12ba:	31278793          	addi	a5,a5,786 # 25c8 <run_queue>
    12be:	02f71063          	bne	a4,a5,12de <thread_exit+0x3a>
        fprintf(2, "[FATAL] thread_exit is called on a nonexistent thread\n");
    12c2:	00001597          	auipc	a1,0x1
    12c6:	1ae58593          	addi	a1,a1,430 # 2470 <schedule_dm+0x2c4>
    12ca:	4509                	li	a0,2
    12cc:	fffff097          	auipc	ra,0xfffff
    12d0:	7bc080e7          	jalr	1980(ra) # a88 <fprintf>
        exit(1);
    12d4:	4505                	li	a0,1
    12d6:	fffff097          	auipc	ra,0xfffff
    12da:	2c4080e7          	jalr	708(ra) # 59a <exit>
    }

    struct thread *to_remove = list_entry(current, struct thread, thread_list);
    12de:	00001797          	auipc	a5,0x1
    12e2:	33278793          	addi	a5,a5,818 # 2610 <current>
    12e6:	639c                	ld	a5,0(a5)
    12e8:	fef43423          	sd	a5,-24(s0)
    12ec:	fe843783          	ld	a5,-24(s0)
    12f0:	fd878793          	addi	a5,a5,-40
    12f4:	fef43023          	sd	a5,-32(s0)
    int consume_ticks = cancelthrdstop(to_remove->thrdstop_context_id, 1);
    12f8:	fe043783          	ld	a5,-32(s0)
    12fc:	5f9c                	lw	a5,56(a5)
    12fe:	4585                	li	a1,1
    1300:	853e                	mv	a0,a5
    1302:	fffff097          	auipc	ra,0xfffff
    1306:	348080e7          	jalr	840(ra) # 64a <cancelthrdstop>
    130a:	87aa                	mv	a5,a0
    130c:	fcf42e23          	sw	a5,-36(s0)
    threading_system_time += consume_ticks;
    1310:	00001797          	auipc	a5,0x1
    1314:	30878793          	addi	a5,a5,776 # 2618 <threading_system_time>
    1318:	439c                	lw	a5,0(a5)
    131a:	fdc42703          	lw	a4,-36(s0)
    131e:	9fb9                	addw	a5,a5,a4
    1320:	0007871b          	sext.w	a4,a5
    1324:	00001797          	auipc	a5,0x1
    1328:	2f478793          	addi	a5,a5,756 # 2618 <threading_system_time>
    132c:	c398                	sw	a4,0(a5)

    __release();
    132e:	00000097          	auipc	ra,0x0
    1332:	e16080e7          	jalr	-490(ra) # 1144 <__release>
    __thread_exit(to_remove);
    1336:	fe043503          	ld	a0,-32(s0)
    133a:	00000097          	auipc	ra,0x0
    133e:	ef2080e7          	jalr	-270(ra) # 122c <__thread_exit>
}
    1342:	0001                	nop
    1344:	70a2                	ld	ra,40(sp)
    1346:	7402                	ld	s0,32(sp)
    1348:	6145                	addi	sp,sp,48
    134a:	8082                	ret

000000000000134c <__finish_current>:

void __finish_current()
{
    134c:	7179                	addi	sp,sp,-48
    134e:	f406                	sd	ra,40(sp)
    1350:	f022                	sd	s0,32(sp)
    1352:	1800                	addi	s0,sp,48
    struct thread *current_thread = list_entry(current, struct thread, thread_list);
    1354:	00001797          	auipc	a5,0x1
    1358:	2bc78793          	addi	a5,a5,700 # 2610 <current>
    135c:	639c                	ld	a5,0(a5)
    135e:	fef43423          	sd	a5,-24(s0)
    1362:	fe843783          	ld	a5,-24(s0)
    1366:	fd878793          	addi	a5,a5,-40
    136a:	fef43023          	sd	a5,-32(s0)
    --current_thread->n;
    136e:	fe043783          	ld	a5,-32(s0)
    1372:	4bfc                	lw	a5,84(a5)
    1374:	37fd                	addiw	a5,a5,-1
    1376:	0007871b          	sext.w	a4,a5
    137a:	fe043783          	ld	a5,-32(s0)
    137e:	cbf8                	sw	a4,84(a5)

    printf("thread#%d finish at %d\n",
    1380:	fe043783          	ld	a5,-32(s0)
    1384:	5fd8                	lw	a4,60(a5)
    1386:	00001797          	auipc	a5,0x1
    138a:	29278793          	addi	a5,a5,658 # 2618 <threading_system_time>
    138e:	4390                	lw	a2,0(a5)
    1390:	fe043783          	ld	a5,-32(s0)
    1394:	4bfc                	lw	a5,84(a5)
    1396:	86be                	mv	a3,a5
    1398:	85ba                	mv	a1,a4
    139a:	00001517          	auipc	a0,0x1
    139e:	10e50513          	addi	a0,a0,270 # 24a8 <schedule_dm+0x2fc>
    13a2:	fffff097          	auipc	ra,0xfffff
    13a6:	73e080e7          	jalr	1854(ra) # ae0 <printf>
           current_thread->ID, threading_system_time, current_thread->n);

    if (current_thread->n > 0) {
    13aa:	fe043783          	ld	a5,-32(s0)
    13ae:	4bfc                	lw	a5,84(a5)
    13b0:	04f05563          	blez	a5,13fa <__finish_current+0xae>
        struct list_head *to_remove = current;
    13b4:	00001797          	auipc	a5,0x1
    13b8:	25c78793          	addi	a5,a5,604 # 2610 <current>
    13bc:	639c                	ld	a5,0(a5)
    13be:	fcf43c23          	sd	a5,-40(s0)
        current = current->prev;
    13c2:	00001797          	auipc	a5,0x1
    13c6:	24e78793          	addi	a5,a5,590 # 2610 <current>
    13ca:	639c                	ld	a5,0(a5)
    13cc:	6798                	ld	a4,8(a5)
    13ce:	00001797          	auipc	a5,0x1
    13d2:	24278793          	addi	a5,a5,578 # 2610 <current>
    13d6:	e398                	sd	a4,0(a5)
        list_del(to_remove);
    13d8:	fd843503          	ld	a0,-40(s0)
    13dc:	00000097          	auipc	ra,0x0
    13e0:	b48080e7          	jalr	-1208(ra) # f24 <list_del>
        thread_add_at(current_thread, current_thread->current_deadline);
    13e4:	fe043783          	ld	a5,-32(s0)
    13e8:	4ffc                	lw	a5,92(a5)
    13ea:	85be                	mv	a1,a5
    13ec:	fe043503          	ld	a0,-32(s0)
    13f0:	00000097          	auipc	ra,0x0
    13f4:	cd4080e7          	jalr	-812(ra) # 10c4 <thread_add_at>
    } else {
        __thread_exit(current_thread);
    }
}
    13f8:	a039                	j	1406 <__finish_current+0xba>
        __thread_exit(current_thread);
    13fa:	fe043503          	ld	a0,-32(s0)
    13fe:	00000097          	auipc	ra,0x0
    1402:	e2e080e7          	jalr	-466(ra) # 122c <__thread_exit>
}
    1406:	0001                	nop
    1408:	70a2                	ld	ra,40(sp)
    140a:	7402                	ld	s0,32(sp)
    140c:	6145                	addi	sp,sp,48
    140e:	8082                	ret

0000000000001410 <__rt_finish_current>:
void __rt_finish_current()
{
    1410:	7179                	addi	sp,sp,-48
    1412:	f406                	sd	ra,40(sp)
    1414:	f022                	sd	s0,32(sp)
    1416:	1800                	addi	s0,sp,48
    struct thread *current_thread = list_entry(current, struct thread, thread_list);
    1418:	00001797          	auipc	a5,0x1
    141c:	1f878793          	addi	a5,a5,504 # 2610 <current>
    1420:	639c                	ld	a5,0(a5)
    1422:	fef43423          	sd	a5,-24(s0)
    1426:	fe843783          	ld	a5,-24(s0)
    142a:	fd878793          	addi	a5,a5,-40
    142e:	fef43023          	sd	a5,-32(s0)
    --current_thread->n;
    1432:	fe043783          	ld	a5,-32(s0)
    1436:	4bfc                	lw	a5,84(a5)
    1438:	37fd                	addiw	a5,a5,-1
    143a:	0007871b          	sext.w	a4,a5
    143e:	fe043783          	ld	a5,-32(s0)
    1442:	cbf8                	sw	a4,84(a5)

    printf("thread#%d finish one cycle at %d: %d cycles left\n",
    1444:	fe043783          	ld	a5,-32(s0)
    1448:	5fd8                	lw	a4,60(a5)
    144a:	00001797          	auipc	a5,0x1
    144e:	1ce78793          	addi	a5,a5,462 # 2618 <threading_system_time>
    1452:	4390                	lw	a2,0(a5)
    1454:	fe043783          	ld	a5,-32(s0)
    1458:	4bfc                	lw	a5,84(a5)
    145a:	86be                	mv	a3,a5
    145c:	85ba                	mv	a1,a4
    145e:	00001517          	auipc	a0,0x1
    1462:	06250513          	addi	a0,a0,98 # 24c0 <schedule_dm+0x314>
    1466:	fffff097          	auipc	ra,0xfffff
    146a:	67a080e7          	jalr	1658(ra) # ae0 <printf>
           current_thread->ID, threading_system_time, current_thread->n);

    if (current_thread->n > 0) {
    146e:	fe043783          	ld	a5,-32(s0)
    1472:	4bfc                	lw	a5,84(a5)
    1474:	04f05563          	blez	a5,14be <__rt_finish_current+0xae>
        struct list_head *to_remove = current;
    1478:	00001797          	auipc	a5,0x1
    147c:	19878793          	addi	a5,a5,408 # 2610 <current>
    1480:	639c                	ld	a5,0(a5)
    1482:	fcf43c23          	sd	a5,-40(s0)
        current = current->prev;
    1486:	00001797          	auipc	a5,0x1
    148a:	18a78793          	addi	a5,a5,394 # 2610 <current>
    148e:	639c                	ld	a5,0(a5)
    1490:	6798                	ld	a4,8(a5)
    1492:	00001797          	auipc	a5,0x1
    1496:	17e78793          	addi	a5,a5,382 # 2610 <current>
    149a:	e398                	sd	a4,0(a5)
        list_del(to_remove);
    149c:	fd843503          	ld	a0,-40(s0)
    14a0:	00000097          	auipc	ra,0x0
    14a4:	a84080e7          	jalr	-1404(ra) # f24 <list_del>
        thread_add_at(current_thread, current_thread->current_deadline);
    14a8:	fe043783          	ld	a5,-32(s0)
    14ac:	4ffc                	lw	a5,92(a5)
    14ae:	85be                	mv	a1,a5
    14b0:	fe043503          	ld	a0,-32(s0)
    14b4:	00000097          	auipc	ra,0x0
    14b8:	c10080e7          	jalr	-1008(ra) # 10c4 <thread_add_at>
    } else {
        __thread_exit(current_thread);
    }
}
    14bc:	a039                	j	14ca <__rt_finish_current+0xba>
        __thread_exit(current_thread);
    14be:	fe043503          	ld	a0,-32(s0)
    14c2:	00000097          	auipc	ra,0x0
    14c6:	d6a080e7          	jalr	-662(ra) # 122c <__thread_exit>
}
    14ca:	0001                	nop
    14cc:	70a2                	ld	ra,40(sp)
    14ce:	7402                	ld	s0,32(sp)
    14d0:	6145                	addi	sp,sp,48
    14d2:	8082                	ret

00000000000014d4 <switch_handler>:

void switch_handler(void *arg)
{
    14d4:	7139                	addi	sp,sp,-64
    14d6:	fc06                	sd	ra,56(sp)
    14d8:	f822                	sd	s0,48(sp)
    14da:	0080                	addi	s0,sp,64
    14dc:	fca43423          	sd	a0,-56(s0)
    uint64 elapsed_time = (uint64)arg;
    14e0:	fc843783          	ld	a5,-56(s0)
    14e4:	fef43423          	sd	a5,-24(s0)
    struct thread *current_thread = list_entry(current, struct thread, thread_list);
    14e8:	00001797          	auipc	a5,0x1
    14ec:	12878793          	addi	a5,a5,296 # 2610 <current>
    14f0:	639c                	ld	a5,0(a5)
    14f2:	fef43023          	sd	a5,-32(s0)
    14f6:	fe043783          	ld	a5,-32(s0)
    14fa:	fd878793          	addi	a5,a5,-40
    14fe:	fcf43c23          	sd	a5,-40(s0)

    threading_system_time += elapsed_time;
    1502:	fe843783          	ld	a5,-24(s0)
    1506:	0007871b          	sext.w	a4,a5
    150a:	00001797          	auipc	a5,0x1
    150e:	10e78793          	addi	a5,a5,270 # 2618 <threading_system_time>
    1512:	439c                	lw	a5,0(a5)
    1514:	2781                	sext.w	a5,a5
    1516:	9fb9                	addw	a5,a5,a4
    1518:	2781                	sext.w	a5,a5
    151a:	0007871b          	sext.w	a4,a5
    151e:	00001797          	auipc	a5,0x1
    1522:	0fa78793          	addi	a5,a5,250 # 2618 <threading_system_time>
    1526:	c398                	sw	a4,0(a5)
     __release();
    1528:	00000097          	auipc	ra,0x0
    152c:	c1c080e7          	jalr	-996(ra) # 1144 <__release>
    current_thread->remaining_time -= elapsed_time;
    1530:	fd843783          	ld	a5,-40(s0)
    1534:	4fbc                	lw	a5,88(a5)
    1536:	0007871b          	sext.w	a4,a5
    153a:	fe843783          	ld	a5,-24(s0)
    153e:	2781                	sext.w	a5,a5
    1540:	40f707bb          	subw	a5,a4,a5
    1544:	2781                	sext.w	a5,a5
    1546:	0007871b          	sext.w	a4,a5
    154a:	fd843783          	ld	a5,-40(s0)
    154e:	cfb8                	sw	a4,88(a5)

    if (current_thread->is_real_time)
    1550:	fd843783          	ld	a5,-40(s0)
    1554:	43bc                	lw	a5,64(a5)
    1556:	c3ad                	beqz	a5,15b8 <switch_handler+0xe4>
        if (threading_system_time > current_thread->current_deadline || 
    1558:	fd843783          	ld	a5,-40(s0)
    155c:	4ff8                	lw	a4,92(a5)
    155e:	00001797          	auipc	a5,0x1
    1562:	0ba78793          	addi	a5,a5,186 # 2618 <threading_system_time>
    1566:	439c                	lw	a5,0(a5)
    1568:	02f74163          	blt	a4,a5,158a <switch_handler+0xb6>
            (threading_system_time == current_thread->current_deadline && current_thread->remaining_time > 0)) {
    156c:	fd843783          	ld	a5,-40(s0)
    1570:	4ff8                	lw	a4,92(a5)
    1572:	00001797          	auipc	a5,0x1
    1576:	0a678793          	addi	a5,a5,166 # 2618 <threading_system_time>
    157a:	439c                	lw	a5,0(a5)
        if (threading_system_time > current_thread->current_deadline || 
    157c:	02f71e63          	bne	a4,a5,15b8 <switch_handler+0xe4>
            (threading_system_time == current_thread->current_deadline && current_thread->remaining_time > 0)) {
    1580:	fd843783          	ld	a5,-40(s0)
    1584:	4fbc                	lw	a5,88(a5)
    1586:	02f05963          	blez	a5,15b8 <switch_handler+0xe4>
            printf("thread#%d misses a deadline at %d\n", current_thread->ID, threading_system_time);
    158a:	fd843783          	ld	a5,-40(s0)
    158e:	5fd8                	lw	a4,60(a5)
    1590:	00001797          	auipc	a5,0x1
    1594:	08878793          	addi	a5,a5,136 # 2618 <threading_system_time>
    1598:	439c                	lw	a5,0(a5)
    159a:	863e                	mv	a2,a5
    159c:	85ba                	mv	a1,a4
    159e:	00001517          	auipc	a0,0x1
    15a2:	f5a50513          	addi	a0,a0,-166 # 24f8 <schedule_dm+0x34c>
    15a6:	fffff097          	auipc	ra,0xfffff
    15aa:	53a080e7          	jalr	1338(ra) # ae0 <printf>
            exit(0);
    15ae:	4501                	li	a0,0
    15b0:	fffff097          	auipc	ra,0xfffff
    15b4:	fea080e7          	jalr	-22(ra) # 59a <exit>
        }

    if (current_thread->remaining_time <= 0) {
    15b8:	fd843783          	ld	a5,-40(s0)
    15bc:	4fbc                	lw	a5,88(a5)
    15be:	02f04063          	bgtz	a5,15de <switch_handler+0x10a>
        if (current_thread->is_real_time)
    15c2:	fd843783          	ld	a5,-40(s0)
    15c6:	43bc                	lw	a5,64(a5)
    15c8:	c791                	beqz	a5,15d4 <switch_handler+0x100>
            __rt_finish_current();
    15ca:	00000097          	auipc	ra,0x0
    15ce:	e46080e7          	jalr	-442(ra) # 1410 <__rt_finish_current>
    15d2:	a881                	j	1622 <switch_handler+0x14e>
        else
            __finish_current();
    15d4:	00000097          	auipc	ra,0x0
    15d8:	d78080e7          	jalr	-648(ra) # 134c <__finish_current>
    15dc:	a099                	j	1622 <switch_handler+0x14e>
    } else {
        // move the current thread to the end of the run_queue
        struct list_head *to_remove = current;
    15de:	00001797          	auipc	a5,0x1
    15e2:	03278793          	addi	a5,a5,50 # 2610 <current>
    15e6:	639c                	ld	a5,0(a5)
    15e8:	fcf43823          	sd	a5,-48(s0)
        current = current->prev;
    15ec:	00001797          	auipc	a5,0x1
    15f0:	02478793          	addi	a5,a5,36 # 2610 <current>
    15f4:	639c                	ld	a5,0(a5)
    15f6:	6798                	ld	a4,8(a5)
    15f8:	00001797          	auipc	a5,0x1
    15fc:	01878793          	addi	a5,a5,24 # 2610 <current>
    1600:	e398                	sd	a4,0(a5)
        list_del(to_remove);
    1602:	fd043503          	ld	a0,-48(s0)
    1606:	00000097          	auipc	ra,0x0
    160a:	91e080e7          	jalr	-1762(ra) # f24 <list_del>
        list_add_tail(to_remove, &run_queue);
    160e:	00001597          	auipc	a1,0x1
    1612:	fba58593          	addi	a1,a1,-70 # 25c8 <run_queue>
    1616:	fd043503          	ld	a0,-48(s0)
    161a:	00000097          	auipc	ra,0x0
    161e:	8ae080e7          	jalr	-1874(ra) # ec8 <list_add_tail>
    }

    __release();
    1622:	00000097          	auipc	ra,0x0
    1626:	b22080e7          	jalr	-1246(ra) # 1144 <__release>
    __schedule();
    162a:	00000097          	auipc	ra,0x0
    162e:	1be080e7          	jalr	446(ra) # 17e8 <__schedule>
    __dispatch();
    1632:	00000097          	auipc	ra,0x0
    1636:	026080e7          	jalr	38(ra) # 1658 <__dispatch>
    thrdresume(main_thrd_id);
    163a:	00001797          	auipc	a5,0x1
    163e:	fae78793          	addi	a5,a5,-82 # 25e8 <main_thrd_id>
    1642:	439c                	lw	a5,0(a5)
    1644:	853e                	mv	a0,a5
    1646:	fffff097          	auipc	ra,0xfffff
    164a:	ffc080e7          	jalr	-4(ra) # 642 <thrdresume>
}
    164e:	0001                	nop
    1650:	70e2                	ld	ra,56(sp)
    1652:	7442                	ld	s0,48(sp)
    1654:	6121                	addi	sp,sp,64
    1656:	8082                	ret

0000000000001658 <__dispatch>:

void __dispatch()
{
    1658:	7179                	addi	sp,sp,-48
    165a:	f406                	sd	ra,40(sp)
    165c:	f022                	sd	s0,32(sp)
    165e:	1800                	addi	s0,sp,48
    if (current == &run_queue) {
    1660:	00001797          	auipc	a5,0x1
    1664:	fb078793          	addi	a5,a5,-80 # 2610 <current>
    1668:	6398                	ld	a4,0(a5)
    166a:	00001797          	auipc	a5,0x1
    166e:	f5e78793          	addi	a5,a5,-162 # 25c8 <run_queue>
    1672:	16f70663          	beq	a4,a5,17de <__dispatch+0x186>
    if (allocated_time < 0) {
        fprintf(2, "[FATAL] allocated_time is negative\n");
        exit(1);
    }

    struct thread *current_thread = list_entry(current, struct thread, thread_list);
    1676:	00001797          	auipc	a5,0x1
    167a:	f9a78793          	addi	a5,a5,-102 # 2610 <current>
    167e:	639c                	ld	a5,0(a5)
    1680:	fef43423          	sd	a5,-24(s0)
    1684:	fe843783          	ld	a5,-24(s0)
    1688:	fd878793          	addi	a5,a5,-40
    168c:	fef43023          	sd	a5,-32(s0)
    if (current_thread->is_real_time && allocated_time == 0) { // miss deadline, abort
    1690:	fe043783          	ld	a5,-32(s0)
    1694:	43bc                	lw	a5,64(a5)
    1696:	cf85                	beqz	a5,16ce <__dispatch+0x76>
    1698:	00001797          	auipc	a5,0x1
    169c:	f8878793          	addi	a5,a5,-120 # 2620 <allocated_time>
    16a0:	639c                	ld	a5,0(a5)
    16a2:	e795                	bnez	a5,16ce <__dispatch+0x76>
        printf("thread#%d misses a deadline at %d\n", current_thread->ID, current_thread->current_deadline);
    16a4:	fe043783          	ld	a5,-32(s0)
    16a8:	5fd8                	lw	a4,60(a5)
    16aa:	fe043783          	ld	a5,-32(s0)
    16ae:	4ffc                	lw	a5,92(a5)
    16b0:	863e                	mv	a2,a5
    16b2:	85ba                	mv	a1,a4
    16b4:	00001517          	auipc	a0,0x1
    16b8:	e4450513          	addi	a0,a0,-444 # 24f8 <schedule_dm+0x34c>
    16bc:	fffff097          	auipc	ra,0xfffff
    16c0:	424080e7          	jalr	1060(ra) # ae0 <printf>
        exit(0);
    16c4:	4501                	li	a0,0
    16c6:	fffff097          	auipc	ra,0xfffff
    16ca:	ed4080e7          	jalr	-300(ra) # 59a <exit>
    }

    printf("dispatch thread#%d at %d: allocated_time=%d\n", current_thread->ID, threading_system_time, allocated_time);
    16ce:	fe043783          	ld	a5,-32(s0)
    16d2:	5fd8                	lw	a4,60(a5)
    16d4:	00001797          	auipc	a5,0x1
    16d8:	f4478793          	addi	a5,a5,-188 # 2618 <threading_system_time>
    16dc:	4390                	lw	a2,0(a5)
    16de:	00001797          	auipc	a5,0x1
    16e2:	f4278793          	addi	a5,a5,-190 # 2620 <allocated_time>
    16e6:	639c                	ld	a5,0(a5)
    16e8:	86be                	mv	a3,a5
    16ea:	85ba                	mv	a1,a4
    16ec:	00001517          	auipc	a0,0x1
    16f0:	e3450513          	addi	a0,a0,-460 # 2520 <schedule_dm+0x374>
    16f4:	fffff097          	auipc	ra,0xfffff
    16f8:	3ec080e7          	jalr	1004(ra) # ae0 <printf>

    if (current_thread->buf_set) {
    16fc:	fe043783          	ld	a5,-32(s0)
    1700:	539c                	lw	a5,32(a5)
    1702:	c7a1                	beqz	a5,174a <__dispatch+0xf2>
        thrdstop(allocated_time, &(current_thread->thrdstop_context_id), switch_handler, (void *)allocated_time);
    1704:	00001797          	auipc	a5,0x1
    1708:	f1c78793          	addi	a5,a5,-228 # 2620 <allocated_time>
    170c:	639c                	ld	a5,0(a5)
    170e:	0007871b          	sext.w	a4,a5
    1712:	fe043783          	ld	a5,-32(s0)
    1716:	03878593          	addi	a1,a5,56
    171a:	00001797          	auipc	a5,0x1
    171e:	f0678793          	addi	a5,a5,-250 # 2620 <allocated_time>
    1722:	639c                	ld	a5,0(a5)
    1724:	86be                	mv	a3,a5
    1726:	00000617          	auipc	a2,0x0
    172a:	dae60613          	addi	a2,a2,-594 # 14d4 <switch_handler>
    172e:	853a                	mv	a0,a4
    1730:	fffff097          	auipc	ra,0xfffff
    1734:	f0a080e7          	jalr	-246(ra) # 63a <thrdstop>
        thrdresume(current_thread->thrdstop_context_id);
    1738:	fe043783          	ld	a5,-32(s0)
    173c:	5f9c                	lw	a5,56(a5)
    173e:	853e                	mv	a0,a5
    1740:	fffff097          	auipc	ra,0xfffff
    1744:	f02080e7          	jalr	-254(ra) # 642 <thrdresume>
    1748:	a071                	j	17d4 <__dispatch+0x17c>
    } else {
        current_thread->buf_set = 1;
    174a:	fe043783          	ld	a5,-32(s0)
    174e:	4705                	li	a4,1
    1750:	d398                	sw	a4,32(a5)
        unsigned long new_stack_p = (unsigned long)current_thread->stack_p;
    1752:	fe043783          	ld	a5,-32(s0)
    1756:	6f9c                	ld	a5,24(a5)
    1758:	fcf43c23          	sd	a5,-40(s0)
        current_thread->thrdstop_context_id = -1;
    175c:	fe043783          	ld	a5,-32(s0)
    1760:	577d                	li	a4,-1
    1762:	df98                	sw	a4,56(a5)
        thrdstop(allocated_time, &(current_thread->thrdstop_context_id), switch_handler, (void *)allocated_time);
    1764:	00001797          	auipc	a5,0x1
    1768:	ebc78793          	addi	a5,a5,-324 # 2620 <allocated_time>
    176c:	639c                	ld	a5,0(a5)
    176e:	0007871b          	sext.w	a4,a5
    1772:	fe043783          	ld	a5,-32(s0)
    1776:	03878593          	addi	a1,a5,56
    177a:	00001797          	auipc	a5,0x1
    177e:	ea678793          	addi	a5,a5,-346 # 2620 <allocated_time>
    1782:	639c                	ld	a5,0(a5)
    1784:	86be                	mv	a3,a5
    1786:	00000617          	auipc	a2,0x0
    178a:	d4e60613          	addi	a2,a2,-690 # 14d4 <switch_handler>
    178e:	853a                	mv	a0,a4
    1790:	fffff097          	auipc	ra,0xfffff
    1794:	eaa080e7          	jalr	-342(ra) # 63a <thrdstop>
        if (current_thread->thrdstop_context_id < 0) {
    1798:	fe043783          	ld	a5,-32(s0)
    179c:	5f9c                	lw	a5,56(a5)
    179e:	0207d063          	bgez	a5,17be <__dispatch+0x166>
            fprintf(2, "[ERROR] number of threads may exceed MAX_THRD_NUM\n");
    17a2:	00001597          	auipc	a1,0x1
    17a6:	dae58593          	addi	a1,a1,-594 # 2550 <schedule_dm+0x3a4>
    17aa:	4509                	li	a0,2
    17ac:	fffff097          	auipc	ra,0xfffff
    17b0:	2dc080e7          	jalr	732(ra) # a88 <fprintf>
            exit(1);
    17b4:	4505                	li	a0,1
    17b6:	fffff097          	auipc	ra,0xfffff
    17ba:	de4080e7          	jalr	-540(ra) # 59a <exit>
        }

        // set sp to stack pointer of current thread.
        asm volatile("mv sp, %0"
    17be:	fd843783          	ld	a5,-40(s0)
    17c2:	813e                	mv	sp,a5
                     :
                     : "r"(new_stack_p));
        current_thread->fp(current_thread->arg);
    17c4:	fe043783          	ld	a5,-32(s0)
    17c8:	6398                	ld	a4,0(a5)
    17ca:	fe043783          	ld	a5,-32(s0)
    17ce:	679c                	ld	a5,8(a5)
    17d0:	853e                	mv	a0,a5
    17d2:	9702                	jalr	a4
    }
    thread_exit();
    17d4:	00000097          	auipc	ra,0x0
    17d8:	ad0080e7          	jalr	-1328(ra) # 12a4 <thread_exit>
    17dc:	a011                	j	17e0 <__dispatch+0x188>
        return;
    17de:	0001                	nop
}
    17e0:	70a2                	ld	ra,40(sp)
    17e2:	7402                	ld	s0,32(sp)
    17e4:	6145                	addi	sp,sp,48
    17e6:	8082                	ret

00000000000017e8 <__schedule>:

void __schedule()
{
    17e8:	711d                	addi	sp,sp,-96
    17ea:	ec86                	sd	ra,88(sp)
    17ec:	e8a2                	sd	s0,80(sp)
    17ee:	1080                	addi	s0,sp,96
    struct threads_sched_args args = {
    17f0:	00001797          	auipc	a5,0x1
    17f4:	e2878793          	addi	a5,a5,-472 # 2618 <threading_system_time>
    17f8:	439c                	lw	a5,0(a5)
    17fa:	fcf42c23          	sw	a5,-40(s0)
    17fe:	4789                	li	a5,2
    1800:	fcf42e23          	sw	a5,-36(s0)
    1804:	00001797          	auipc	a5,0x1
    1808:	dc478793          	addi	a5,a5,-572 # 25c8 <run_queue>
    180c:	fef43023          	sd	a5,-32(s0)
    1810:	00001797          	auipc	a5,0x1
    1814:	dc878793          	addi	a5,a5,-568 # 25d8 <release_queue>
    1818:	fef43423          	sd	a5,-24(s0)
#ifdef THREAD_SCHEDULER_WRR
    r = schedule_wrr(args);
#endif

#ifdef THREAD_SCHEDULER_SJF
    r = schedule_sjf(args);
    181c:	fd843783          	ld	a5,-40(s0)
    1820:	faf43023          	sd	a5,-96(s0)
    1824:	fe043783          	ld	a5,-32(s0)
    1828:	faf43423          	sd	a5,-88(s0)
    182c:	fe843783          	ld	a5,-24(s0)
    1830:	faf43823          	sd	a5,-80(s0)
    1834:	fa040793          	addi	a5,s0,-96
    1838:	853e                	mv	a0,a5
    183a:	00000097          	auipc	ra,0x0
    183e:	3ca080e7          	jalr	970(ra) # 1c04 <schedule_sjf>
    1842:	872a                	mv	a4,a0
    1844:	87ae                	mv	a5,a1
    1846:	fce43423          	sd	a4,-56(s0)
    184a:	fcf43823          	sd	a5,-48(s0)

#ifdef THREAD_SCHEDULER_DM
    r = schedule_dm(args);
#endif

    current = r.scheduled_thread_list_member;
    184e:	fc843703          	ld	a4,-56(s0)
    1852:	00001797          	auipc	a5,0x1
    1856:	dbe78793          	addi	a5,a5,-578 # 2610 <current>
    185a:	e398                	sd	a4,0(a5)
    allocated_time = r.allocated_time;
    185c:	fd042783          	lw	a5,-48(s0)
    1860:	873e                	mv	a4,a5
    1862:	00001797          	auipc	a5,0x1
    1866:	dbe78793          	addi	a5,a5,-578 # 2620 <allocated_time>
    186a:	e398                	sd	a4,0(a5)
}
    186c:	0001                	nop
    186e:	60e6                	ld	ra,88(sp)
    1870:	6446                	ld	s0,80(sp)
    1872:	6125                	addi	sp,sp,96
    1874:	8082                	ret

0000000000001876 <back_to_main_handler>:

void back_to_main_handler(void *arg)
{
    1876:	1101                	addi	sp,sp,-32
    1878:	ec06                	sd	ra,24(sp)
    187a:	e822                	sd	s0,16(sp)
    187c:	1000                	addi	s0,sp,32
    187e:	fea43423          	sd	a0,-24(s0)
    sleeping = 0;
    1882:	00001797          	auipc	a5,0x1
    1886:	d9a78793          	addi	a5,a5,-614 # 261c <sleeping>
    188a:	0007a023          	sw	zero,0(a5)
    threading_system_time += (uint64)arg;
    188e:	fe843783          	ld	a5,-24(s0)
    1892:	0007871b          	sext.w	a4,a5
    1896:	00001797          	auipc	a5,0x1
    189a:	d8278793          	addi	a5,a5,-638 # 2618 <threading_system_time>
    189e:	439c                	lw	a5,0(a5)
    18a0:	2781                	sext.w	a5,a5
    18a2:	9fb9                	addw	a5,a5,a4
    18a4:	2781                	sext.w	a5,a5
    18a6:	0007871b          	sext.w	a4,a5
    18aa:	00001797          	auipc	a5,0x1
    18ae:	d6e78793          	addi	a5,a5,-658 # 2618 <threading_system_time>
    18b2:	c398                	sw	a4,0(a5)
    thrdresume(main_thrd_id);
    18b4:	00001797          	auipc	a5,0x1
    18b8:	d3478793          	addi	a5,a5,-716 # 25e8 <main_thrd_id>
    18bc:	439c                	lw	a5,0(a5)
    18be:	853e                	mv	a0,a5
    18c0:	fffff097          	auipc	ra,0xfffff
    18c4:	d82080e7          	jalr	-638(ra) # 642 <thrdresume>
}
    18c8:	0001                	nop
    18ca:	60e2                	ld	ra,24(sp)
    18cc:	6442                	ld	s0,16(sp)
    18ce:	6105                	addi	sp,sp,32
    18d0:	8082                	ret

00000000000018d2 <thread_start_threading>:

void thread_start_threading()
{
    18d2:	1141                	addi	sp,sp,-16
    18d4:	e406                	sd	ra,8(sp)
    18d6:	e022                	sd	s0,0(sp)
    18d8:	0800                	addi	s0,sp,16
    threading_system_time = 0;
    18da:	00001797          	auipc	a5,0x1
    18de:	d3e78793          	addi	a5,a5,-706 # 2618 <threading_system_time>
    18e2:	0007a023          	sw	zero,0(a5)
    current = &run_queue;
    18e6:	00001797          	auipc	a5,0x1
    18ea:	d2a78793          	addi	a5,a5,-726 # 2610 <current>
    18ee:	00001717          	auipc	a4,0x1
    18f2:	cda70713          	addi	a4,a4,-806 # 25c8 <run_queue>
    18f6:	e398                	sd	a4,0(a5)

    // call thrdstop just for obtain an ID
    thrdstop(1000, &main_thrd_id, back_to_main_handler, (void *)0);
    18f8:	4681                	li	a3,0
    18fa:	00000617          	auipc	a2,0x0
    18fe:	f7c60613          	addi	a2,a2,-132 # 1876 <back_to_main_handler>
    1902:	00001597          	auipc	a1,0x1
    1906:	ce658593          	addi	a1,a1,-794 # 25e8 <main_thrd_id>
    190a:	3e800513          	li	a0,1000
    190e:	fffff097          	auipc	ra,0xfffff
    1912:	d2c080e7          	jalr	-724(ra) # 63a <thrdstop>
    cancelthrdstop(main_thrd_id, 0);
    1916:	00001797          	auipc	a5,0x1
    191a:	cd278793          	addi	a5,a5,-814 # 25e8 <main_thrd_id>
    191e:	439c                	lw	a5,0(a5)
    1920:	4581                	li	a1,0
    1922:	853e                	mv	a0,a5
    1924:	fffff097          	auipc	ra,0xfffff
    1928:	d26080e7          	jalr	-730(ra) # 64a <cancelthrdstop>

    while (!list_empty(&run_queue) || !list_empty(&release_queue)) {
    192c:	a0c9                	j	19ee <thread_start_threading+0x11c>
        __release();
    192e:	00000097          	auipc	ra,0x0
    1932:	816080e7          	jalr	-2026(ra) # 1144 <__release>
        __schedule();
    1936:	00000097          	auipc	ra,0x0
    193a:	eb2080e7          	jalr	-334(ra) # 17e8 <__schedule>
        cancelthrdstop(main_thrd_id, 0);
    193e:	00001797          	auipc	a5,0x1
    1942:	caa78793          	addi	a5,a5,-854 # 25e8 <main_thrd_id>
    1946:	439c                	lw	a5,0(a5)
    1948:	4581                	li	a1,0
    194a:	853e                	mv	a0,a5
    194c:	fffff097          	auipc	ra,0xfffff
    1950:	cfe080e7          	jalr	-770(ra) # 64a <cancelthrdstop>
        __dispatch();
    1954:	00000097          	auipc	ra,0x0
    1958:	d04080e7          	jalr	-764(ra) # 1658 <__dispatch>

        if (list_empty(&run_queue) && list_empty(&release_queue)) {
    195c:	00001517          	auipc	a0,0x1
    1960:	c6c50513          	addi	a0,a0,-916 # 25c8 <run_queue>
    1964:	fffff097          	auipc	ra,0xfffff
    1968:	60a080e7          	jalr	1546(ra) # f6e <list_empty>
    196c:	87aa                	mv	a5,a0
    196e:	cb99                	beqz	a5,1984 <thread_start_threading+0xb2>
    1970:	00001517          	auipc	a0,0x1
    1974:	c6850513          	addi	a0,a0,-920 # 25d8 <release_queue>
    1978:	fffff097          	auipc	ra,0xfffff
    197c:	5f6080e7          	jalr	1526(ra) # f6e <list_empty>
    1980:	87aa                	mv	a5,a0
    1982:	ebd9                	bnez	a5,1a18 <thread_start_threading+0x146>
            break;
        }

        // no thread in run_queue, release_queue not empty
        printf("run_queue is empty, sleep for %d ticks\n", allocated_time);
    1984:	00001797          	auipc	a5,0x1
    1988:	c9c78793          	addi	a5,a5,-868 # 2620 <allocated_time>
    198c:	639c                	ld	a5,0(a5)
    198e:	85be                	mv	a1,a5
    1990:	00001517          	auipc	a0,0x1
    1994:	bf850513          	addi	a0,a0,-1032 # 2588 <schedule_dm+0x3dc>
    1998:	fffff097          	auipc	ra,0xfffff
    199c:	148080e7          	jalr	328(ra) # ae0 <printf>
        sleeping = 1;
    19a0:	00001797          	auipc	a5,0x1
    19a4:	c7c78793          	addi	a5,a5,-900 # 261c <sleeping>
    19a8:	4705                	li	a4,1
    19aa:	c398                	sw	a4,0(a5)
        thrdstop(allocated_time, &main_thrd_id, back_to_main_handler, (void *)allocated_time);
    19ac:	00001797          	auipc	a5,0x1
    19b0:	c7478793          	addi	a5,a5,-908 # 2620 <allocated_time>
    19b4:	639c                	ld	a5,0(a5)
    19b6:	0007871b          	sext.w	a4,a5
    19ba:	00001797          	auipc	a5,0x1
    19be:	c6678793          	addi	a5,a5,-922 # 2620 <allocated_time>
    19c2:	639c                	ld	a5,0(a5)
    19c4:	86be                	mv	a3,a5
    19c6:	00000617          	auipc	a2,0x0
    19ca:	eb060613          	addi	a2,a2,-336 # 1876 <back_to_main_handler>
    19ce:	00001597          	auipc	a1,0x1
    19d2:	c1a58593          	addi	a1,a1,-998 # 25e8 <main_thrd_id>
    19d6:	853a                	mv	a0,a4
    19d8:	fffff097          	auipc	ra,0xfffff
    19dc:	c62080e7          	jalr	-926(ra) # 63a <thrdstop>
        while (sleeping) {
    19e0:	0001                	nop
    19e2:	00001797          	auipc	a5,0x1
    19e6:	c3a78793          	addi	a5,a5,-966 # 261c <sleeping>
    19ea:	439c                	lw	a5,0(a5)
    19ec:	fbfd                	bnez	a5,19e2 <thread_start_threading+0x110>
    while (!list_empty(&run_queue) || !list_empty(&release_queue)) {
    19ee:	00001517          	auipc	a0,0x1
    19f2:	bda50513          	addi	a0,a0,-1062 # 25c8 <run_queue>
    19f6:	fffff097          	auipc	ra,0xfffff
    19fa:	578080e7          	jalr	1400(ra) # f6e <list_empty>
    19fe:	87aa                	mv	a5,a0
    1a00:	d79d                	beqz	a5,192e <thread_start_threading+0x5c>
    1a02:	00001517          	auipc	a0,0x1
    1a06:	bd650513          	addi	a0,a0,-1066 # 25d8 <release_queue>
    1a0a:	fffff097          	auipc	ra,0xfffff
    1a0e:	564080e7          	jalr	1380(ra) # f6e <list_empty>
    1a12:	87aa                	mv	a5,a0
    1a14:	df89                	beqz	a5,192e <thread_start_threading+0x5c>
            // zzz...
        }
    }
}
    1a16:	a011                	j	1a1a <thread_start_threading+0x148>
            break;
    1a18:	0001                	nop
}
    1a1a:	0001                	nop
    1a1c:	60a2                	ld	ra,8(sp)
    1a1e:	6402                	ld	s0,0(sp)
    1a20:	0141                	addi	sp,sp,16
    1a22:	8082                	ret

0000000000001a24 <schedule_default>:

#define NULL 0

/* default scheduling algorithm */
struct threads_sched_result schedule_default(struct threads_sched_args args)
{
    1a24:	715d                	addi	sp,sp,-80
    1a26:	e4a2                	sd	s0,72(sp)
    1a28:	e0a6                	sd	s1,64(sp)
    1a2a:	0880                	addi	s0,sp,80
    1a2c:	84aa                	mv	s1,a0
    struct thread *thread_with_smallest_id = NULL;
    1a2e:	fe043423          	sd	zero,-24(s0)
    struct thread *th = NULL;
    1a32:	fe043023          	sd	zero,-32(s0)
    list_for_each_entry(th, args.run_queue, thread_list) {
    1a36:	649c                	ld	a5,8(s1)
    1a38:	639c                	ld	a5,0(a5)
    1a3a:	fcf43c23          	sd	a5,-40(s0)
    1a3e:	fd843783          	ld	a5,-40(s0)
    1a42:	fd878793          	addi	a5,a5,-40
    1a46:	fef43023          	sd	a5,-32(s0)
    1a4a:	a81d                	j	1a80 <schedule_default+0x5c>
        if (thread_with_smallest_id == NULL || th->ID < thread_with_smallest_id->ID)
    1a4c:	fe843783          	ld	a5,-24(s0)
    1a50:	cb89                	beqz	a5,1a62 <schedule_default+0x3e>
    1a52:	fe043783          	ld	a5,-32(s0)
    1a56:	5fd8                	lw	a4,60(a5)
    1a58:	fe843783          	ld	a5,-24(s0)
    1a5c:	5fdc                	lw	a5,60(a5)
    1a5e:	00f75663          	bge	a4,a5,1a6a <schedule_default+0x46>
            thread_with_smallest_id = th;
    1a62:	fe043783          	ld	a5,-32(s0)
    1a66:	fef43423          	sd	a5,-24(s0)
    list_for_each_entry(th, args.run_queue, thread_list) {
    1a6a:	fe043783          	ld	a5,-32(s0)
    1a6e:	779c                	ld	a5,40(a5)
    1a70:	fcf43823          	sd	a5,-48(s0)
    1a74:	fd043783          	ld	a5,-48(s0)
    1a78:	fd878793          	addi	a5,a5,-40
    1a7c:	fef43023          	sd	a5,-32(s0)
    1a80:	fe043783          	ld	a5,-32(s0)
    1a84:	02878713          	addi	a4,a5,40
    1a88:	649c                	ld	a5,8(s1)
    1a8a:	fcf711e3          	bne	a4,a5,1a4c <schedule_default+0x28>
    }

    struct threads_sched_result r;
    if (thread_with_smallest_id != NULL) {
    1a8e:	fe843783          	ld	a5,-24(s0)
    1a92:	cf89                	beqz	a5,1aac <schedule_default+0x88>
        r.scheduled_thread_list_member = &thread_with_smallest_id->thread_list;
    1a94:	fe843783          	ld	a5,-24(s0)
    1a98:	02878793          	addi	a5,a5,40
    1a9c:	faf43823          	sd	a5,-80(s0)
        r.allocated_time = thread_with_smallest_id->remaining_time;
    1aa0:	fe843783          	ld	a5,-24(s0)
    1aa4:	4fbc                	lw	a5,88(a5)
    1aa6:	faf42c23          	sw	a5,-72(s0)
    1aaa:	a039                	j	1ab8 <schedule_default+0x94>
    } else {
        r.scheduled_thread_list_member = args.run_queue;
    1aac:	649c                	ld	a5,8(s1)
    1aae:	faf43823          	sd	a5,-80(s0)
        r.allocated_time = 1;
    1ab2:	4785                	li	a5,1
    1ab4:	faf42c23          	sw	a5,-72(s0)
    }

    return r;
    1ab8:	fb043783          	ld	a5,-80(s0)
    1abc:	fcf43023          	sd	a5,-64(s0)
    1ac0:	fb843783          	ld	a5,-72(s0)
    1ac4:	fcf43423          	sd	a5,-56(s0)
    1ac8:	4701                	li	a4,0
    1aca:	fc043703          	ld	a4,-64(s0)
    1ace:	4781                	li	a5,0
    1ad0:	fc843783          	ld	a5,-56(s0)
    1ad4:	863a                	mv	a2,a4
    1ad6:	86be                	mv	a3,a5
    1ad8:	8732                	mv	a4,a2
    1ada:	87b6                	mv	a5,a3
}
    1adc:	853a                	mv	a0,a4
    1ade:	85be                	mv	a1,a5
    1ae0:	6426                	ld	s0,72(sp)
    1ae2:	6486                	ld	s1,64(sp)
    1ae4:	6161                	addi	sp,sp,80
    1ae6:	8082                	ret

0000000000001ae8 <schedule_wrr>:

/* MP3 Part 1 - Non-Real-Time Scheduling */
/* Weighted-Round-Robin Scheduling */
struct threads_sched_result schedule_wrr(struct threads_sched_args args)
{
    1ae8:	711d                	addi	sp,sp,-96
    1aea:	eca2                	sd	s0,88(sp)
    1aec:	e8a6                	sd	s1,80(sp)
    1aee:	1080                	addi	s0,sp,96
    1af0:	84aa                	mv	s1,a0
    struct threads_sched_result r;
    // TODO: implement the weighted round-robin scheduling algorithm
    // struct thread *th = list_entry(args.run_queue, struct thread, thread_list);
    struct thread *th = NULL;
    1af2:	fe043423          	sd	zero,-24(s0)
    if ((args.run_queue)->next != args.run_queue)
    1af6:	649c                	ld	a5,8(s1)
    1af8:	6398                	ld	a4,0(a5)
    1afa:	649c                	ld	a5,8(s1)
    1afc:	00f70c63          	beq	a4,a5,1b14 <schedule_wrr+0x2c>
        th = list_entry((args.run_queue)->next, struct thread, thread_list);
    1b00:	649c                	ld	a5,8(s1)
    1b02:	639c                	ld	a5,0(a5)
    1b04:	fcf43823          	sd	a5,-48(s0)
    1b08:	fd043783          	ld	a5,-48(s0)
    1b0c:	fd878793          	addi	a5,a5,-40
    1b10:	fef43423          	sd	a5,-24(s0)
    // printf("th: id: %d, ptime: %d, weight: %d\n", th->ID, th->processing_time, th->weight);
    
    if (th != NULL){
    1b14:	fe843783          	ld	a5,-24(s0)
    1b18:	c7a1                	beqz	a5,1b60 <schedule_wrr+0x78>
        r.scheduled_thread_list_member = &th->thread_list;
    1b1a:	fe843783          	ld	a5,-24(s0)
    1b1e:	02878793          	addi	a5,a5,40
    1b22:	faf43023          	sd	a5,-96(s0)
        if (args.time_quantum * th->weight > th->remaining_time)
    1b26:	40d8                	lw	a4,4(s1)
    1b28:	fe843783          	ld	a5,-24(s0)
    1b2c:	47bc                	lw	a5,72(a5)
    1b2e:	02f707bb          	mulw	a5,a4,a5
    1b32:	0007871b          	sext.w	a4,a5
    1b36:	fe843783          	ld	a5,-24(s0)
    1b3a:	4fbc                	lw	a5,88(a5)
    1b3c:	00e7d863          	bge	a5,a4,1b4c <schedule_wrr+0x64>
            r.allocated_time = th->remaining_time;
    1b40:	fe843783          	ld	a5,-24(s0)
    1b44:	4fbc                	lw	a5,88(a5)
    1b46:	faf42423          	sw	a5,-88(s0)
    1b4a:	a069                	j	1bd4 <schedule_wrr+0xec>
        else
            r.allocated_time = args.time_quantum * th->weight;
    1b4c:	40d8                	lw	a4,4(s1)
    1b4e:	fe843783          	ld	a5,-24(s0)
    1b52:	47bc                	lw	a5,72(a5)
    1b54:	02f707bb          	mulw	a5,a4,a5
    1b58:	2781                	sext.w	a5,a5
    1b5a:	faf42423          	sw	a5,-88(s0)
    1b5e:	a89d                	j	1bd4 <schedule_wrr+0xec>
        //printf("remain: %d t*w %d\n", th->remaining_time, args.time_quantum * th->weight);
    }
    else{
        r.scheduled_thread_list_member = args.run_queue;
    1b60:	649c                	ld	a5,8(s1)
    1b62:	faf43023          	sd	a5,-96(s0)
        struct release_queue_entry* rqe = NULL;
    1b66:	fe043023          	sd	zero,-32(s0)
        int mn = 100000;
    1b6a:	67e1                	lui	a5,0x18
    1b6c:	6a07879b          	addiw	a5,a5,1696
    1b70:	fcf42e23          	sw	a5,-36(s0)
        list_for_each_entry(rqe, args.release_queue, thread_list){
    1b74:	689c                	ld	a5,16(s1)
    1b76:	639c                	ld	a5,0(a5)
    1b78:	fcf43423          	sd	a5,-56(s0)
    1b7c:	fc843783          	ld	a5,-56(s0)
    1b80:	17e1                	addi	a5,a5,-8
    1b82:	fef43023          	sd	a5,-32(s0)
    1b86:	a805                	j	1bb6 <schedule_wrr+0xce>
            if (rqe->release_time < mn)
    1b88:	fe043783          	ld	a5,-32(s0)
    1b8c:	4f98                	lw	a4,24(a5)
    1b8e:	fdc42783          	lw	a5,-36(s0)
    1b92:	2781                	sext.w	a5,a5
    1b94:	00f75763          	bge	a4,a5,1ba2 <schedule_wrr+0xba>
                mn = rqe->release_time;
    1b98:	fe043783          	ld	a5,-32(s0)
    1b9c:	4f9c                	lw	a5,24(a5)
    1b9e:	fcf42e23          	sw	a5,-36(s0)
        list_for_each_entry(rqe, args.release_queue, thread_list){
    1ba2:	fe043783          	ld	a5,-32(s0)
    1ba6:	679c                	ld	a5,8(a5)
    1ba8:	fcf43023          	sd	a5,-64(s0)
    1bac:	fc043783          	ld	a5,-64(s0)
    1bb0:	17e1                	addi	a5,a5,-8
    1bb2:	fef43023          	sd	a5,-32(s0)
    1bb6:	fe043783          	ld	a5,-32(s0)
    1bba:	00878713          	addi	a4,a5,8 # 18008 <__global_pointer$+0x15258>
    1bbe:	689c                	ld	a5,16(s1)
    1bc0:	fcf714e3          	bne	a4,a5,1b88 <schedule_wrr+0xa0>
        }
        r.allocated_time = mn - args.current_time;
    1bc4:	409c                	lw	a5,0(s1)
    1bc6:	fdc42703          	lw	a4,-36(s0)
    1bca:	40f707bb          	subw	a5,a4,a5
    1bce:	2781                	sext.w	a5,a5
    1bd0:	faf42423          	sw	a5,-88(s0)
    }
    return r;
    1bd4:	fa043783          	ld	a5,-96(s0)
    1bd8:	faf43823          	sd	a5,-80(s0)
    1bdc:	fa843783          	ld	a5,-88(s0)
    1be0:	faf43c23          	sd	a5,-72(s0)
    1be4:	4701                	li	a4,0
    1be6:	fb043703          	ld	a4,-80(s0)
    1bea:	4781                	li	a5,0
    1bec:	fb843783          	ld	a5,-72(s0)
    1bf0:	863a                	mv	a2,a4
    1bf2:	86be                	mv	a3,a5
    1bf4:	8732                	mv	a4,a2
    1bf6:	87b6                	mv	a5,a3
}
    1bf8:	853a                	mv	a0,a4
    1bfa:	85be                	mv	a1,a5
    1bfc:	6466                	ld	s0,88(sp)
    1bfe:	64c6                	ld	s1,80(sp)
    1c00:	6125                	addi	sp,sp,96
    1c02:	8082                	ret

0000000000001c04 <schedule_sjf>:

/* Shortest-Job-First Scheduling */

struct threads_sched_result schedule_sjf(struct threads_sched_args args)
{
    1c04:	7175                	addi	sp,sp,-144
    1c06:	e522                	sd	s0,136(sp)
    1c08:	e126                	sd	s1,128(sp)
    1c0a:	0900                	addi	s0,sp,144
    1c0c:	84aa                	mv	s1,a0
    struct threads_sched_result r;
    // TODO: implement the shortest-job-first scheduling algorithm
    struct thread *thread_with_shortest_job = NULL;
    1c0e:	fe043423          	sd	zero,-24(s0)
    struct thread *th = NULL;
    1c12:	fe043023          	sd	zero,-32(s0)
    struct release_queue_entry* rqe = NULL;
    1c16:	fc043c23          	sd	zero,-40(s0)
    int mn = 10000000;
    1c1a:	009897b7          	lui	a5,0x989
    1c1e:	6807879b          	addiw	a5,a5,1664
    1c22:	fcf42a23          	sw	a5,-44(s0)
    list_for_each_entry(th, args.run_queue, thread_list) {
    1c26:	649c                	ld	a5,8(s1)
    1c28:	639c                	ld	a5,0(a5)
    1c2a:	faf43c23          	sd	a5,-72(s0)
    1c2e:	fb843783          	ld	a5,-72(s0)
    1c32:	fd878793          	addi	a5,a5,-40 # 988fd8 <__global_pointer$+0x986228>
    1c36:	fef43023          	sd	a5,-32(s0)
    1c3a:	a899                	j	1c90 <schedule_sjf+0x8c>
        if (thread_with_shortest_job == NULL || th->remaining_time < thread_with_shortest_job->remaining_time || (th->remaining_time == thread_with_shortest_job->remaining_time && th->ID < thread_with_shortest_job->ID))
    1c3c:	fe843783          	ld	a5,-24(s0)
    1c40:	cb8d                	beqz	a5,1c72 <schedule_sjf+0x6e>
    1c42:	fe043783          	ld	a5,-32(s0)
    1c46:	4fb8                	lw	a4,88(a5)
    1c48:	fe843783          	ld	a5,-24(s0)
    1c4c:	4fbc                	lw	a5,88(a5)
    1c4e:	02f74263          	blt	a4,a5,1c72 <schedule_sjf+0x6e>
    1c52:	fe043783          	ld	a5,-32(s0)
    1c56:	4fb8                	lw	a4,88(a5)
    1c58:	fe843783          	ld	a5,-24(s0)
    1c5c:	4fbc                	lw	a5,88(a5)
    1c5e:	00f71e63          	bne	a4,a5,1c7a <schedule_sjf+0x76>
    1c62:	fe043783          	ld	a5,-32(s0)
    1c66:	5fd8                	lw	a4,60(a5)
    1c68:	fe843783          	ld	a5,-24(s0)
    1c6c:	5fdc                	lw	a5,60(a5)
    1c6e:	00f75663          	bge	a4,a5,1c7a <schedule_sjf+0x76>
            thread_with_shortest_job = th;
    1c72:	fe043783          	ld	a5,-32(s0)
    1c76:	fef43423          	sd	a5,-24(s0)
    list_for_each_entry(th, args.run_queue, thread_list) {
    1c7a:	fe043783          	ld	a5,-32(s0)
    1c7e:	779c                	ld	a5,40(a5)
    1c80:	f8f43823          	sd	a5,-112(s0)
    1c84:	f9043783          	ld	a5,-112(s0)
    1c88:	fd878793          	addi	a5,a5,-40
    1c8c:	fef43023          	sd	a5,-32(s0)
    1c90:	fe043783          	ld	a5,-32(s0)
    1c94:	02878713          	addi	a4,a5,40
    1c98:	649c                	ld	a5,8(s1)
    1c9a:	faf711e3          	bne	a4,a5,1c3c <schedule_sjf+0x38>
    }
    list_for_each_entry(rqe, args.release_queue, thread_list){
    1c9e:	689c                	ld	a5,16(s1)
    1ca0:	639c                	ld	a5,0(a5)
    1ca2:	faf43823          	sd	a5,-80(s0)
    1ca6:	fb043783          	ld	a5,-80(s0)
    1caa:	17e1                	addi	a5,a5,-8
    1cac:	fcf43c23          	sd	a5,-40(s0)
    1cb0:	a065                	j	1d58 <schedule_sjf+0x154>
        if (rqe == NULL || (rqe->release_time >= args.current_time && rqe->release_time < mn)){
    1cb2:	fd843783          	ld	a5,-40(s0)
    1cb6:	cf99                	beqz	a5,1cd4 <schedule_sjf+0xd0>
    1cb8:	fd843783          	ld	a5,-40(s0)
    1cbc:	4f98                	lw	a4,24(a5)
    1cbe:	409c                	lw	a5,0(s1)
    1cc0:	08f74263          	blt	a4,a5,1d44 <schedule_sjf+0x140>
    1cc4:	fd843783          	ld	a5,-40(s0)
    1cc8:	4f98                	lw	a4,24(a5)
    1cca:	fd442783          	lw	a5,-44(s0)
    1cce:	2781                	sext.w	a5,a5
    1cd0:	06f75a63          	bge	a4,a5,1d44 <schedule_sjf+0x140>
            th = rqe->thrd;
    1cd4:	fd843783          	ld	a5,-40(s0)
    1cd8:	639c                	ld	a5,0(a5)
    1cda:	fef43023          	sd	a5,-32(s0)
            if (th->processing_time < thread_with_shortest_job->remaining_time - (rqe->release_time - args.current_time) || (th->processing_time == thread_with_shortest_job->remaining_time - (rqe->release_time - args.current_time) && th->ID < thread_with_shortest_job->ID))
    1cde:	fe043783          	ld	a5,-32(s0)
    1ce2:	43e8                	lw	a0,68(a5)
    1ce4:	fe843783          	ld	a5,-24(s0)
    1ce8:	4fb8                	lw	a4,88(a5)
    1cea:	fd843783          	ld	a5,-40(s0)
    1cee:	4f8c                	lw	a1,24(a5)
    1cf0:	409c                	lw	a5,0(s1)
    1cf2:	40f587bb          	subw	a5,a1,a5
    1cf6:	2781                	sext.w	a5,a5
    1cf8:	40f707bb          	subw	a5,a4,a5
    1cfc:	2781                	sext.w	a5,a5
    1cfe:	872a                	mv	a4,a0
    1d00:	02f74d63          	blt	a4,a5,1d3a <schedule_sjf+0x136>
    1d04:	fe043783          	ld	a5,-32(s0)
    1d08:	43e8                	lw	a0,68(a5)
    1d0a:	fe843783          	ld	a5,-24(s0)
    1d0e:	4fb8                	lw	a4,88(a5)
    1d10:	fd843783          	ld	a5,-40(s0)
    1d14:	4f8c                	lw	a1,24(a5)
    1d16:	409c                	lw	a5,0(s1)
    1d18:	40f587bb          	subw	a5,a1,a5
    1d1c:	2781                	sext.w	a5,a5
    1d1e:	40f707bb          	subw	a5,a4,a5
    1d22:	2781                	sext.w	a5,a5
    1d24:	872a                	mv	a4,a0
    1d26:	00f71f63          	bne	a4,a5,1d44 <schedule_sjf+0x140>
    1d2a:	fe043783          	ld	a5,-32(s0)
    1d2e:	5fd8                	lw	a4,60(a5)
    1d30:	fe843783          	ld	a5,-24(s0)
    1d34:	5fdc                	lw	a5,60(a5)
    1d36:	00f75763          	bge	a4,a5,1d44 <schedule_sjf+0x140>
                mn = rqe->release_time;
    1d3a:	fd843783          	ld	a5,-40(s0)
    1d3e:	4f9c                	lw	a5,24(a5)
    1d40:	fcf42a23          	sw	a5,-44(s0)
    list_for_each_entry(rqe, args.release_queue, thread_list){
    1d44:	fd843783          	ld	a5,-40(s0)
    1d48:	679c                	ld	a5,8(a5)
    1d4a:	f8f43c23          	sd	a5,-104(s0)
    1d4e:	f9843783          	ld	a5,-104(s0)
    1d52:	17e1                	addi	a5,a5,-8
    1d54:	fcf43c23          	sd	a5,-40(s0)
    1d58:	fd843783          	ld	a5,-40(s0)
    1d5c:	00878713          	addi	a4,a5,8
    1d60:	689c                	ld	a5,16(s1)
    1d62:	f4f718e3          	bne	a4,a5,1cb2 <schedule_sjf+0xae>
        }
    }
    if (thread_with_shortest_job != NULL){
    1d66:	fe843783          	ld	a5,-24(s0)
    1d6a:	c3b1                	beqz	a5,1dae <schedule_sjf+0x1aa>
        r.scheduled_thread_list_member = &thread_with_shortest_job->thread_list;
    1d6c:	fe843783          	ld	a5,-24(s0)
    1d70:	02878793          	addi	a5,a5,40
    1d74:	f6f43823          	sd	a5,-144(s0)
        if (thread_with_shortest_job->remaining_time > mn - args.current_time)
    1d78:	fe843783          	ld	a5,-24(s0)
    1d7c:	4fac                	lw	a1,88(a5)
    1d7e:	409c                	lw	a5,0(s1)
    1d80:	fd442703          	lw	a4,-44(s0)
    1d84:	40f707bb          	subw	a5,a4,a5
    1d88:	2781                	sext.w	a5,a5
    1d8a:	872e                	mv	a4,a1
    1d8c:	00e7db63          	bge	a5,a4,1da2 <schedule_sjf+0x19e>
            r.allocated_time = mn - args.current_time;
    1d90:	409c                	lw	a5,0(s1)
    1d92:	fd442703          	lw	a4,-44(s0)
    1d96:	40f707bb          	subw	a5,a4,a5
    1d9a:	2781                	sext.w	a5,a5
    1d9c:	f6f42c23          	sw	a5,-136(s0)
    1da0:	a049                	j	1e22 <schedule_sjf+0x21e>
        else
            r.allocated_time = thread_with_shortest_job->remaining_time;
    1da2:	fe843783          	ld	a5,-24(s0)
    1da6:	4fbc                	lw	a5,88(a5)
    1da8:	f6f42c23          	sw	a5,-136(s0)
    1dac:	a89d                	j	1e22 <schedule_sjf+0x21e>
    }
    else{
        r.scheduled_thread_list_member = args.run_queue;
    1dae:	649c                	ld	a5,8(s1)
    1db0:	f6f43823          	sd	a5,-144(s0)
        struct release_queue_entry* rqe = NULL;
    1db4:	fc043423          	sd	zero,-56(s0)
        int mn = 100000;
    1db8:	67e1                	lui	a5,0x18
    1dba:	6a07879b          	addiw	a5,a5,1696
    1dbe:	fcf42223          	sw	a5,-60(s0)
        list_for_each_entry(rqe, args.release_queue, thread_list){
    1dc2:	689c                	ld	a5,16(s1)
    1dc4:	639c                	ld	a5,0(a5)
    1dc6:	faf43423          	sd	a5,-88(s0)
    1dca:	fa843783          	ld	a5,-88(s0)
    1dce:	17e1                	addi	a5,a5,-8
    1dd0:	fcf43423          	sd	a5,-56(s0)
    1dd4:	a805                	j	1e04 <schedule_sjf+0x200>
            if (rqe->release_time < mn)
    1dd6:	fc843783          	ld	a5,-56(s0)
    1dda:	4f98                	lw	a4,24(a5)
    1ddc:	fc442783          	lw	a5,-60(s0)
    1de0:	2781                	sext.w	a5,a5
    1de2:	00f75763          	bge	a4,a5,1df0 <schedule_sjf+0x1ec>
                mn = rqe->release_time;
    1de6:	fc843783          	ld	a5,-56(s0)
    1dea:	4f9c                	lw	a5,24(a5)
    1dec:	fcf42223          	sw	a5,-60(s0)
        list_for_each_entry(rqe, args.release_queue, thread_list){
    1df0:	fc843783          	ld	a5,-56(s0)
    1df4:	679c                	ld	a5,8(a5)
    1df6:	faf43023          	sd	a5,-96(s0)
    1dfa:	fa043783          	ld	a5,-96(s0)
    1dfe:	17e1                	addi	a5,a5,-8
    1e00:	fcf43423          	sd	a5,-56(s0)
    1e04:	fc843783          	ld	a5,-56(s0)
    1e08:	00878713          	addi	a4,a5,8 # 18008 <__global_pointer$+0x15258>
    1e0c:	689c                	ld	a5,16(s1)
    1e0e:	fcf714e3          	bne	a4,a5,1dd6 <schedule_sjf+0x1d2>
        }
        r.allocated_time = mn - args.current_time;
    1e12:	409c                	lw	a5,0(s1)
    1e14:	fc442703          	lw	a4,-60(s0)
    1e18:	40f707bb          	subw	a5,a4,a5
    1e1c:	2781                	sext.w	a5,a5
    1e1e:	f6f42c23          	sw	a5,-136(s0)
    }
    return r;
    1e22:	f7043783          	ld	a5,-144(s0)
    1e26:	f8f43023          	sd	a5,-128(s0)
    1e2a:	f7843783          	ld	a5,-136(s0)
    1e2e:	f8f43423          	sd	a5,-120(s0)
    1e32:	4701                	li	a4,0
    1e34:	f8043703          	ld	a4,-128(s0)
    1e38:	4781                	li	a5,0
    1e3a:	f8843783          	ld	a5,-120(s0)
    1e3e:	863a                	mv	a2,a4
    1e40:	86be                	mv	a3,a5
    1e42:	8732                	mv	a4,a2
    1e44:	87b6                	mv	a5,a3
}
    1e46:	853a                	mv	a0,a4
    1e48:	85be                	mv	a1,a5
    1e4a:	642a                	ld	s0,136(sp)
    1e4c:	648a                	ld	s1,128(sp)
    1e4e:	6149                	addi	sp,sp,144
    1e50:	8082                	ret

0000000000001e52 <schedule_lst>:

/* MP3 Part 2 - Real-Time Scheduling*/
/* Least-Slack-Time Scheduling */

struct threads_sched_result schedule_lst(struct threads_sched_args args)
{
    1e52:	7135                	addi	sp,sp,-160
    1e54:	ed22                	sd	s0,152(sp)
    1e56:	e926                	sd	s1,144(sp)
    1e58:	1100                	addi	s0,sp,160
    1e5a:	84aa                	mv	s1,a0
    struct threads_sched_result r;
    // TODO: implement the least-slack-time scheduling algorithm
    struct thread *th = NULL;
    1e5c:	fe043423          	sd	zero,-24(s0)
    struct thread *lst = NULL, *ms = NULL;
    1e60:	fe043023          	sd	zero,-32(s0)
    1e64:	fc043c23          	sd	zero,-40(s0)
    int miss = 0;
    1e68:	fc042a23          	sw	zero,-44(s0)
    list_for_each_entry(th, args.run_queue, thread_list) {
    1e6c:	649c                	ld	a5,8(s1)
    1e6e:	639c                	ld	a5,0(a5)
    1e70:	faf43823          	sd	a5,-80(s0)
    1e74:	fb043783          	ld	a5,-80(s0)
    1e78:	fd878793          	addi	a5,a5,-40
    1e7c:	fef43423          	sd	a5,-24(s0)
    1e80:	a0fd                	j	1f6e <schedule_lst+0x11c>
        if (th->current_deadline <= args.current_time){
    1e82:	fe843783          	ld	a5,-24(s0)
    1e86:	4ff8                	lw	a4,92(a5)
    1e88:	409c                	lw	a5,0(s1)
    1e8a:	02e7c463          	blt	a5,a4,1eb2 <schedule_lst+0x60>
            miss = 1;
    1e8e:	4785                	li	a5,1
    1e90:	fcf42a23          	sw	a5,-44(s0)
            if (ms == NULL || th->ID < ms->ID)
    1e94:	fd843783          	ld	a5,-40(s0)
    1e98:	cb89                	beqz	a5,1eaa <schedule_lst+0x58>
    1e9a:	fe843783          	ld	a5,-24(s0)
    1e9e:	5fd8                	lw	a4,60(a5)
    1ea0:	fd843783          	ld	a5,-40(s0)
    1ea4:	5fdc                	lw	a5,60(a5)
    1ea6:	00f75663          	bge	a4,a5,1eb2 <schedule_lst+0x60>
                ms = th;
    1eaa:	fe843783          	ld	a5,-24(s0)
    1eae:	fcf43c23          	sd	a5,-40(s0)
        }
        if (!miss){
    1eb2:	fd442783          	lw	a5,-44(s0)
    1eb6:	2781                	sext.w	a5,a5
    1eb8:	e3c5                	bnez	a5,1f58 <schedule_lst+0x106>
            if (lst == NULL || (th->current_deadline - args.current_time - th->remaining_time) < (lst->current_deadline - args.current_time - lst->remaining_time) || ((th->current_deadline - args.current_time - th->remaining_time) == (lst->current_deadline - args.current_time - lst->remaining_time) && th->ID < lst->ID))
    1eba:	fe043783          	ld	a5,-32(s0)
    1ebe:	cbc9                	beqz	a5,1f50 <schedule_lst+0xfe>
    1ec0:	fe843783          	ld	a5,-24(s0)
    1ec4:	4ff8                	lw	a4,92(a5)
    1ec6:	409c                	lw	a5,0(s1)
    1ec8:	40f707bb          	subw	a5,a4,a5
    1ecc:	0007871b          	sext.w	a4,a5
    1ed0:	fe843783          	ld	a5,-24(s0)
    1ed4:	4fbc                	lw	a5,88(a5)
    1ed6:	40f707bb          	subw	a5,a4,a5
    1eda:	0007859b          	sext.w	a1,a5
    1ede:	fe043783          	ld	a5,-32(s0)
    1ee2:	4ff8                	lw	a4,92(a5)
    1ee4:	409c                	lw	a5,0(s1)
    1ee6:	40f707bb          	subw	a5,a4,a5
    1eea:	0007871b          	sext.w	a4,a5
    1eee:	fe043783          	ld	a5,-32(s0)
    1ef2:	4fbc                	lw	a5,88(a5)
    1ef4:	40f707bb          	subw	a5,a4,a5
    1ef8:	2781                	sext.w	a5,a5
    1efa:	872e                	mv	a4,a1
    1efc:	04f74a63          	blt	a4,a5,1f50 <schedule_lst+0xfe>
    1f00:	fe843783          	ld	a5,-24(s0)
    1f04:	4ff8                	lw	a4,92(a5)
    1f06:	409c                	lw	a5,0(s1)
    1f08:	40f707bb          	subw	a5,a4,a5
    1f0c:	0007871b          	sext.w	a4,a5
    1f10:	fe843783          	ld	a5,-24(s0)
    1f14:	4fbc                	lw	a5,88(a5)
    1f16:	40f707bb          	subw	a5,a4,a5
    1f1a:	0007859b          	sext.w	a1,a5
    1f1e:	fe043783          	ld	a5,-32(s0)
    1f22:	4ff8                	lw	a4,92(a5)
    1f24:	409c                	lw	a5,0(s1)
    1f26:	40f707bb          	subw	a5,a4,a5
    1f2a:	0007871b          	sext.w	a4,a5
    1f2e:	fe043783          	ld	a5,-32(s0)
    1f32:	4fbc                	lw	a5,88(a5)
    1f34:	40f707bb          	subw	a5,a4,a5
    1f38:	2781                	sext.w	a5,a5
    1f3a:	872e                	mv	a4,a1
    1f3c:	00f71e63          	bne	a4,a5,1f58 <schedule_lst+0x106>
    1f40:	fe843783          	ld	a5,-24(s0)
    1f44:	5fd8                	lw	a4,60(a5)
    1f46:	fe043783          	ld	a5,-32(s0)
    1f4a:	5fdc                	lw	a5,60(a5)
    1f4c:	00f75663          	bge	a4,a5,1f58 <schedule_lst+0x106>
                lst = th;
    1f50:	fe843783          	ld	a5,-24(s0)
    1f54:	fef43023          	sd	a5,-32(s0)
    list_for_each_entry(th, args.run_queue, thread_list) {
    1f58:	fe843783          	ld	a5,-24(s0)
    1f5c:	779c                	ld	a5,40(a5)
    1f5e:	f8f43023          	sd	a5,-128(s0)
    1f62:	f8043783          	ld	a5,-128(s0)
    1f66:	fd878793          	addi	a5,a5,-40
    1f6a:	fef43423          	sd	a5,-24(s0)
    1f6e:	fe843783          	ld	a5,-24(s0)
    1f72:	02878713          	addi	a4,a5,40
    1f76:	649c                	ld	a5,8(s1)
    1f78:	f0f715e3          	bne	a4,a5,1e82 <schedule_lst+0x30>
        }
    }
    if (miss){
    1f7c:	fd442783          	lw	a5,-44(s0)
    1f80:	2781                	sext.w	a5,a5
    1f82:	cb91                	beqz	a5,1f96 <schedule_lst+0x144>
        r.scheduled_thread_list_member = &ms->thread_list;
    1f84:	fd843783          	ld	a5,-40(s0)
    1f88:	02878793          	addi	a5,a5,40
    1f8c:	f6f43023          	sd	a5,-160(s0)
        r.allocated_time = 0;
    1f90:	f6042423          	sw	zero,-152(s0)
    1f94:	a2e5                	j	217c <schedule_lst+0x32a>
    }
    else if (lst == NULL){
    1f96:	fe043783          	ld	a5,-32(s0)
    1f9a:	efad                	bnez	a5,2014 <schedule_lst+0x1c2>
        r.scheduled_thread_list_member = args.run_queue;
    1f9c:	649c                	ld	a5,8(s1)
    1f9e:	f6f43023          	sd	a5,-160(s0)
        struct release_queue_entry* rqe = NULL;
    1fa2:	fc043423          	sd	zero,-56(s0)
        r.allocated_time = 1000000;
    1fa6:	000f47b7          	lui	a5,0xf4
    1faa:	2407879b          	addiw	a5,a5,576
    1fae:	f6f42423          	sw	a5,-152(s0)
        list_for_each_entry(rqe, args.release_queue, thread_list){
    1fb2:	689c                	ld	a5,16(s1)
    1fb4:	639c                	ld	a5,0(a5)
    1fb6:	f8f43823          	sd	a5,-112(s0)
    1fba:	f9043783          	ld	a5,-112(s0)
    1fbe:	17e1                	addi	a5,a5,-8
    1fc0:	fcf43423          	sd	a5,-56(s0)
    1fc4:	a081                	j	2004 <schedule_lst+0x1b2>
            if (rqe->release_time - args.current_time < r.allocated_time)
    1fc6:	fc843783          	ld	a5,-56(s0)
    1fca:	4f98                	lw	a4,24(a5)
    1fcc:	409c                	lw	a5,0(s1)
    1fce:	40f707bb          	subw	a5,a4,a5
    1fd2:	0007871b          	sext.w	a4,a5
    1fd6:	f6842783          	lw	a5,-152(s0)
    1fda:	00f75b63          	bge	a4,a5,1ff0 <schedule_lst+0x19e>
                r.allocated_time = rqe->release_time - args.current_time;
    1fde:	fc843783          	ld	a5,-56(s0)
    1fe2:	4f98                	lw	a4,24(a5)
    1fe4:	409c                	lw	a5,0(s1)
    1fe6:	40f707bb          	subw	a5,a4,a5
    1fea:	2781                	sext.w	a5,a5
    1fec:	f6f42423          	sw	a5,-152(s0)
        list_for_each_entry(rqe, args.release_queue, thread_list){
    1ff0:	fc843783          	ld	a5,-56(s0)
    1ff4:	679c                	ld	a5,8(a5)
    1ff6:	f8f43423          	sd	a5,-120(s0)
    1ffa:	f8843783          	ld	a5,-120(s0)
    1ffe:	17e1                	addi	a5,a5,-8
    2000:	fcf43423          	sd	a5,-56(s0)
    2004:	fc843783          	ld	a5,-56(s0)
    2008:	00878713          	addi	a4,a5,8 # f4008 <__global_pointer$+0xf1258>
    200c:	689c                	ld	a5,16(s1)
    200e:	faf71ce3          	bne	a4,a5,1fc6 <schedule_lst+0x174>
    2012:	a2ad                	j	217c <schedule_lst+0x32a>
        }
    }
    else{
        r.scheduled_thread_list_member = &lst->thread_list;
    2014:	fe043783          	ld	a5,-32(s0)
    2018:	02878793          	addi	a5,a5,40
    201c:	f6f43023          	sd	a5,-160(s0)
        int mn = 100000;
    2020:	67e1                	lui	a5,0x18
    2022:	6a07879b          	addiw	a5,a5,1696
    2026:	fcf42223          	sw	a5,-60(s0)
        struct release_queue_entry* rqe = NULL;
    202a:	fa043c23          	sd	zero,-72(s0)
        list_for_each_entry(rqe, args.release_queue, thread_list){
    202e:	689c                	ld	a5,16(s1)
    2030:	639c                	ld	a5,0(a5)
    2032:	faf43423          	sd	a5,-88(s0)
    2036:	fa843783          	ld	a5,-88(s0)
    203a:	17e1                	addi	a5,a5,-8
    203c:	faf43c23          	sd	a5,-72(s0)
    2040:	a0c9                	j	2102 <schedule_lst+0x2b0>
            th = rqe->thrd;
    2042:	fb843783          	ld	a5,-72(s0)
    2046:	639c                	ld	a5,0(a5)
    2048:	fef43423          	sd	a5,-24(s0)
            //printf("id: %d %d\n", th->ID,(th->current_deadline - rqe->release_time - th->remaining_time));
            if (rqe->release_time < mn && rqe->release_time >= args.current_time){
    204c:	fb843783          	ld	a5,-72(s0)
    2050:	4f98                	lw	a4,24(a5)
    2052:	fc442783          	lw	a5,-60(s0)
    2056:	2781                	sext.w	a5,a5
    2058:	08f75b63          	bge	a4,a5,20ee <schedule_lst+0x29c>
    205c:	fb843783          	ld	a5,-72(s0)
    2060:	4f98                	lw	a4,24(a5)
    2062:	409c                	lw	a5,0(s1)
    2064:	08f74563          	blt	a4,a5,20ee <schedule_lst+0x29c>
                //printf("th: d: %d r: %d lst: %d\n", th->deadline, th->processing_time, (lst->current_deadline - args.current_time - lst->remaining_time));
                if (((th->deadline - th->processing_time) < (lst->current_deadline - args.current_time - lst->remaining_time) || ((th->deadline - th->processing_time) == (lst->current_deadline - args.current_time - lst->remaining_time) && th->ID < lst->ID)))
    2068:	fe843783          	ld	a5,-24(s0)
    206c:	47f8                	lw	a4,76(a5)
    206e:	fe843783          	ld	a5,-24(s0)
    2072:	43fc                	lw	a5,68(a5)
    2074:	40f707bb          	subw	a5,a4,a5
    2078:	0007859b          	sext.w	a1,a5
    207c:	fe043783          	ld	a5,-32(s0)
    2080:	4ff8                	lw	a4,92(a5)
    2082:	409c                	lw	a5,0(s1)
    2084:	40f707bb          	subw	a5,a4,a5
    2088:	0007871b          	sext.w	a4,a5
    208c:	fe043783          	ld	a5,-32(s0)
    2090:	4fbc                	lw	a5,88(a5)
    2092:	40f707bb          	subw	a5,a4,a5
    2096:	2781                	sext.w	a5,a5
    2098:	872e                	mv	a4,a1
    209a:	04f74563          	blt	a4,a5,20e4 <schedule_lst+0x292>
    209e:	fe843783          	ld	a5,-24(s0)
    20a2:	47f8                	lw	a4,76(a5)
    20a4:	fe843783          	ld	a5,-24(s0)
    20a8:	43fc                	lw	a5,68(a5)
    20aa:	40f707bb          	subw	a5,a4,a5
    20ae:	0007859b          	sext.w	a1,a5
    20b2:	fe043783          	ld	a5,-32(s0)
    20b6:	4ff8                	lw	a4,92(a5)
    20b8:	409c                	lw	a5,0(s1)
    20ba:	40f707bb          	subw	a5,a4,a5
    20be:	0007871b          	sext.w	a4,a5
    20c2:	fe043783          	ld	a5,-32(s0)
    20c6:	4fbc                	lw	a5,88(a5)
    20c8:	40f707bb          	subw	a5,a4,a5
    20cc:	2781                	sext.w	a5,a5
    20ce:	872e                	mv	a4,a1
    20d0:	00f71f63          	bne	a4,a5,20ee <schedule_lst+0x29c>
    20d4:	fe843783          	ld	a5,-24(s0)
    20d8:	5fd8                	lw	a4,60(a5)
    20da:	fe043783          	ld	a5,-32(s0)
    20de:	5fdc                	lw	a5,60(a5)
    20e0:	00f75763          	bge	a4,a5,20ee <schedule_lst+0x29c>
                    mn = rqe->release_time;
    20e4:	fb843783          	ld	a5,-72(s0)
    20e8:	4f9c                	lw	a5,24(a5)
    20ea:	fcf42223          	sw	a5,-60(s0)
        list_for_each_entry(rqe, args.release_queue, thread_list){
    20ee:	fb843783          	ld	a5,-72(s0)
    20f2:	679c                	ld	a5,8(a5)
    20f4:	f8f43c23          	sd	a5,-104(s0)
    20f8:	f9843783          	ld	a5,-104(s0)
    20fc:	17e1                	addi	a5,a5,-8
    20fe:	faf43c23          	sd	a5,-72(s0)
    2102:	fb843783          	ld	a5,-72(s0)
    2106:	00878713          	addi	a4,a5,8 # 18008 <__global_pointer$+0x15258>
    210a:	689c                	ld	a5,16(s1)
    210c:	f2f71be3          	bne	a4,a5,2042 <schedule_lst+0x1f0>
            }
        }
        int x = (lst->current_deadline - lst->remaining_time - args.current_time >= 0 ? lst->remaining_time : lst->current_deadline - args.current_time);
    2110:	fe043783          	ld	a5,-32(s0)
    2114:	4ff8                	lw	a4,92(a5)
    2116:	fe043783          	ld	a5,-32(s0)
    211a:	4fbc                	lw	a5,88(a5)
    211c:	40f707bb          	subw	a5,a4,a5
    2120:	0007871b          	sext.w	a4,a5
    2124:	409c                	lw	a5,0(s1)
    2126:	40f707bb          	subw	a5,a4,a5
    212a:	2781                	sext.w	a5,a5
    212c:	0007c663          	bltz	a5,2138 <schedule_lst+0x2e6>
    2130:	fe043783          	ld	a5,-32(s0)
    2134:	4fbc                	lw	a5,88(a5)
    2136:	a801                	j	2146 <schedule_lst+0x2f4>
    2138:	fe043783          	ld	a5,-32(s0)
    213c:	4ff8                	lw	a4,92(a5)
    213e:	409c                	lw	a5,0(s1)
    2140:	40f707bb          	subw	a5,a4,a5
    2144:	2781                	sext.w	a5,a5
    2146:	faf42223          	sw	a5,-92(s0)
        if (x > mn - args.current_time)
    214a:	409c                	lw	a5,0(s1)
    214c:	fc442703          	lw	a4,-60(s0)
    2150:	40f707bb          	subw	a5,a4,a5
    2154:	0007871b          	sext.w	a4,a5
    2158:	fa442783          	lw	a5,-92(s0)
    215c:	2781                	sext.w	a5,a5
    215e:	00f75b63          	bge	a4,a5,2174 <schedule_lst+0x322>
            r.allocated_time = mn - args.current_time;
    2162:	409c                	lw	a5,0(s1)
    2164:	fc442703          	lw	a4,-60(s0)
    2168:	40f707bb          	subw	a5,a4,a5
    216c:	2781                	sext.w	a5,a5
    216e:	f6f42423          	sw	a5,-152(s0)
    2172:	a029                	j	217c <schedule_lst+0x32a>
        else
            r.allocated_time = x;
    2174:	fa442783          	lw	a5,-92(s0)
    2178:	f6f42423          	sw	a5,-152(s0)
    }
    return r;
    217c:	f6043783          	ld	a5,-160(s0)
    2180:	f6f43823          	sd	a5,-144(s0)
    2184:	f6843783          	ld	a5,-152(s0)
    2188:	f6f43c23          	sd	a5,-136(s0)
    218c:	4701                	li	a4,0
    218e:	f7043703          	ld	a4,-144(s0)
    2192:	4781                	li	a5,0
    2194:	f7843783          	ld	a5,-136(s0)
    2198:	863a                	mv	a2,a4
    219a:	86be                	mv	a3,a5
    219c:	8732                	mv	a4,a2
    219e:	87b6                	mv	a5,a3
}
    21a0:	853a                	mv	a0,a4
    21a2:	85be                	mv	a1,a5
    21a4:	646a                	ld	s0,152(sp)
    21a6:	64ca                	ld	s1,144(sp)
    21a8:	610d                	addi	sp,sp,160
    21aa:	8082                	ret

00000000000021ac <schedule_dm>:

/* Deadline-Monotonic Scheduling */
struct threads_sched_result schedule_dm(struct threads_sched_args args)
{
    21ac:	7135                	addi	sp,sp,-160
    21ae:	ed22                	sd	s0,152(sp)
    21b0:	e926                	sd	s1,144(sp)
    21b2:	1100                	addi	s0,sp,160
    21b4:	84aa                	mv	s1,a0
    struct threads_sched_result r;
    // TODO: implement the deadline-monotonic scheduling algorithm
    struct thread *th = NULL;
    21b6:	fe043423          	sd	zero,-24(s0)
    struct thread *dm = NULL, *ms = NULL;
    21ba:	fe043023          	sd	zero,-32(s0)
    21be:	fc043c23          	sd	zero,-40(s0)
    int miss = 0;
    21c2:	fc042a23          	sw	zero,-44(s0)
    list_for_each_entry(th, args.run_queue, thread_list) {
    21c6:	649c                	ld	a5,8(s1)
    21c8:	639c                	ld	a5,0(a5)
    21ca:	faf43823          	sd	a5,-80(s0)
    21ce:	fb043783          	ld	a5,-80(s0)
    21d2:	fd878793          	addi	a5,a5,-40
    21d6:	fef43423          	sd	a5,-24(s0)
    21da:	a079                	j	2268 <schedule_dm+0xbc>
        if (th->current_deadline <= args.current_time){
    21dc:	fe843783          	ld	a5,-24(s0)
    21e0:	4ff8                	lw	a4,92(a5)
    21e2:	409c                	lw	a5,0(s1)
    21e4:	02e7c463          	blt	a5,a4,220c <schedule_dm+0x60>
            miss = 1;
    21e8:	4785                	li	a5,1
    21ea:	fcf42a23          	sw	a5,-44(s0)
            if (ms == NULL || th->ID < ms->ID)
    21ee:	fd843783          	ld	a5,-40(s0)
    21f2:	cb89                	beqz	a5,2204 <schedule_dm+0x58>
    21f4:	fe843783          	ld	a5,-24(s0)
    21f8:	5fd8                	lw	a4,60(a5)
    21fa:	fd843783          	ld	a5,-40(s0)
    21fe:	5fdc                	lw	a5,60(a5)
    2200:	00f75663          	bge	a4,a5,220c <schedule_dm+0x60>
                ms = th;
    2204:	fe843783          	ld	a5,-24(s0)
    2208:	fcf43c23          	sd	a5,-40(s0)
        }
        if (!miss){
    220c:	fd442783          	lw	a5,-44(s0)
    2210:	2781                	sext.w	a5,a5
    2212:	e3a1                	bnez	a5,2252 <schedule_dm+0xa6>
            if (dm == NULL || th->deadline < dm->deadline || (th->deadline == dm->deadline && th->ID < dm->ID))
    2214:	fe043783          	ld	a5,-32(s0)
    2218:	cb8d                	beqz	a5,224a <schedule_dm+0x9e>
    221a:	fe843783          	ld	a5,-24(s0)
    221e:	47f8                	lw	a4,76(a5)
    2220:	fe043783          	ld	a5,-32(s0)
    2224:	47fc                	lw	a5,76(a5)
    2226:	02f74263          	blt	a4,a5,224a <schedule_dm+0x9e>
    222a:	fe843783          	ld	a5,-24(s0)
    222e:	47f8                	lw	a4,76(a5)
    2230:	fe043783          	ld	a5,-32(s0)
    2234:	47fc                	lw	a5,76(a5)
    2236:	00f71e63          	bne	a4,a5,2252 <schedule_dm+0xa6>
    223a:	fe843783          	ld	a5,-24(s0)
    223e:	5fd8                	lw	a4,60(a5)
    2240:	fe043783          	ld	a5,-32(s0)
    2244:	5fdc                	lw	a5,60(a5)
    2246:	00f75663          	bge	a4,a5,2252 <schedule_dm+0xa6>
                dm = th;
    224a:	fe843783          	ld	a5,-24(s0)
    224e:	fef43023          	sd	a5,-32(s0)
    list_for_each_entry(th, args.run_queue, thread_list) {
    2252:	fe843783          	ld	a5,-24(s0)
    2256:	779c                	ld	a5,40(a5)
    2258:	f8f43023          	sd	a5,-128(s0)
    225c:	f8043783          	ld	a5,-128(s0)
    2260:	fd878793          	addi	a5,a5,-40
    2264:	fef43423          	sd	a5,-24(s0)
    2268:	fe843783          	ld	a5,-24(s0)
    226c:	02878713          	addi	a4,a5,40
    2270:	649c                	ld	a5,8(s1)
    2272:	f6f715e3          	bne	a4,a5,21dc <schedule_dm+0x30>
        }
    }
    if (miss){
    2276:	fd442783          	lw	a5,-44(s0)
    227a:	2781                	sext.w	a5,a5
    227c:	cb91                	beqz	a5,2290 <schedule_dm+0xe4>
        r.scheduled_thread_list_member = &ms->thread_list;
    227e:	fd843783          	ld	a5,-40(s0)
    2282:	02878793          	addi	a5,a5,40
    2286:	f6f43023          	sd	a5,-160(s0)
        r.allocated_time = 0;
    228a:	f6042423          	sw	zero,-152(s0)
    228e:	aa59                	j	2424 <schedule_dm+0x278>
    }
    else if (dm == NULL){
    2290:	fe043783          	ld	a5,-32(s0)
    2294:	efad                	bnez	a5,230e <schedule_dm+0x162>
        r.scheduled_thread_list_member = args.run_queue;
    2296:	649c                	ld	a5,8(s1)
    2298:	f6f43023          	sd	a5,-160(s0)
        struct release_queue_entry* rqe = NULL;
    229c:	fc043423          	sd	zero,-56(s0)
        r.allocated_time = 1000000;
    22a0:	000f47b7          	lui	a5,0xf4
    22a4:	2407879b          	addiw	a5,a5,576
    22a8:	f6f42423          	sw	a5,-152(s0)
        list_for_each_entry(rqe, args.release_queue, thread_list){
    22ac:	689c                	ld	a5,16(s1)
    22ae:	639c                	ld	a5,0(a5)
    22b0:	f8f43823          	sd	a5,-112(s0)
    22b4:	f9043783          	ld	a5,-112(s0)
    22b8:	17e1                	addi	a5,a5,-8
    22ba:	fcf43423          	sd	a5,-56(s0)
    22be:	a081                	j	22fe <schedule_dm+0x152>
            if (rqe->release_time - args.current_time < r.allocated_time)
    22c0:	fc843783          	ld	a5,-56(s0)
    22c4:	4f98                	lw	a4,24(a5)
    22c6:	409c                	lw	a5,0(s1)
    22c8:	40f707bb          	subw	a5,a4,a5
    22cc:	0007871b          	sext.w	a4,a5
    22d0:	f6842783          	lw	a5,-152(s0)
    22d4:	00f75b63          	bge	a4,a5,22ea <schedule_dm+0x13e>
                r.allocated_time = rqe->release_time - args.current_time;
    22d8:	fc843783          	ld	a5,-56(s0)
    22dc:	4f98                	lw	a4,24(a5)
    22de:	409c                	lw	a5,0(s1)
    22e0:	40f707bb          	subw	a5,a4,a5
    22e4:	2781                	sext.w	a5,a5
    22e6:	f6f42423          	sw	a5,-152(s0)
        list_for_each_entry(rqe, args.release_queue, thread_list){
    22ea:	fc843783          	ld	a5,-56(s0)
    22ee:	679c                	ld	a5,8(a5)
    22f0:	f8f43423          	sd	a5,-120(s0)
    22f4:	f8843783          	ld	a5,-120(s0)
    22f8:	17e1                	addi	a5,a5,-8
    22fa:	fcf43423          	sd	a5,-56(s0)
    22fe:	fc843783          	ld	a5,-56(s0)
    2302:	00878713          	addi	a4,a5,8 # f4008 <__global_pointer$+0xf1258>
    2306:	689c                	ld	a5,16(s1)
    2308:	faf71ce3          	bne	a4,a5,22c0 <schedule_dm+0x114>
    230c:	aa21                	j	2424 <schedule_dm+0x278>
        }
    }
    else{
        r.scheduled_thread_list_member = &dm->thread_list;
    230e:	fe043783          	ld	a5,-32(s0)
    2312:	02878793          	addi	a5,a5,40
    2316:	f6f43023          	sd	a5,-160(s0)
        struct release_queue_entry* rqe = NULL; 
    231a:	fc043023          	sd	zero,-64(s0)
        int mn = 1000000;
    231e:	000f47b7          	lui	a5,0xf4
    2322:	2407879b          	addiw	a5,a5,576
    2326:	faf42e23          	sw	a5,-68(s0)
        list_for_each_entry(rqe, args.release_queue, thread_list){
    232a:	689c                	ld	a5,16(s1)
    232c:	639c                	ld	a5,0(a5)
    232e:	faf43423          	sd	a5,-88(s0)
    2332:	fa843783          	ld	a5,-88(s0)
    2336:	17e1                	addi	a5,a5,-8
    2338:	fcf43023          	sd	a5,-64(s0)
    233c:	a0ad                	j	23a6 <schedule_dm+0x1fa>
            th = rqe->thrd;
    233e:	fc043783          	ld	a5,-64(s0)
    2342:	639c                	ld	a5,0(a5)
    2344:	fef43423          	sd	a5,-24(s0)
            if ((th->deadline < dm->deadline || (th->deadline == dm->deadline && th->ID < dm->ID)) && rqe->release_time < mn)
    2348:	fe843783          	ld	a5,-24(s0)
    234c:	47f8                	lw	a4,76(a5)
    234e:	fe043783          	ld	a5,-32(s0)
    2352:	47fc                	lw	a5,76(a5)
    2354:	02f74263          	blt	a4,a5,2378 <schedule_dm+0x1cc>
    2358:	fe843783          	ld	a5,-24(s0)
    235c:	47f8                	lw	a4,76(a5)
    235e:	fe043783          	ld	a5,-32(s0)
    2362:	47fc                	lw	a5,76(a5)
    2364:	02f71763          	bne	a4,a5,2392 <schedule_dm+0x1e6>
    2368:	fe843783          	ld	a5,-24(s0)
    236c:	5fd8                	lw	a4,60(a5)
    236e:	fe043783          	ld	a5,-32(s0)
    2372:	5fdc                	lw	a5,60(a5)
    2374:	00f75f63          	bge	a4,a5,2392 <schedule_dm+0x1e6>
    2378:	fc043783          	ld	a5,-64(s0)
    237c:	4f98                	lw	a4,24(a5)
    237e:	fbc42783          	lw	a5,-68(s0)
    2382:	2781                	sext.w	a5,a5
    2384:	00f75763          	bge	a4,a5,2392 <schedule_dm+0x1e6>
                mn = rqe->release_time;
    2388:	fc043783          	ld	a5,-64(s0)
    238c:	4f9c                	lw	a5,24(a5)
    238e:	faf42e23          	sw	a5,-68(s0)
        list_for_each_entry(rqe, args.release_queue, thread_list){
    2392:	fc043783          	ld	a5,-64(s0)
    2396:	679c                	ld	a5,8(a5)
    2398:	f8f43c23          	sd	a5,-104(s0)
    239c:	f9843783          	ld	a5,-104(s0)
    23a0:	17e1                	addi	a5,a5,-8
    23a2:	fcf43023          	sd	a5,-64(s0)
    23a6:	fc043783          	ld	a5,-64(s0)
    23aa:	00878713          	addi	a4,a5,8 # f4008 <__global_pointer$+0xf1258>
    23ae:	689c                	ld	a5,16(s1)
    23b0:	f8f717e3          	bne	a4,a5,233e <schedule_dm+0x192>
        }
        int x = (dm->current_deadline - dm->remaining_time - args.current_time >= 0 ? dm->remaining_time : dm->current_deadline - dm->remaining_time);
    23b4:	fe043783          	ld	a5,-32(s0)
    23b8:	4ff8                	lw	a4,92(a5)
    23ba:	fe043783          	ld	a5,-32(s0)
    23be:	4fbc                	lw	a5,88(a5)
    23c0:	40f707bb          	subw	a5,a4,a5
    23c4:	0007871b          	sext.w	a4,a5
    23c8:	409c                	lw	a5,0(s1)
    23ca:	40f707bb          	subw	a5,a4,a5
    23ce:	2781                	sext.w	a5,a5
    23d0:	0007c663          	bltz	a5,23dc <schedule_dm+0x230>
    23d4:	fe043783          	ld	a5,-32(s0)
    23d8:	4fbc                	lw	a5,88(a5)
    23da:	a811                	j	23ee <schedule_dm+0x242>
    23dc:	fe043783          	ld	a5,-32(s0)
    23e0:	4ff8                	lw	a4,92(a5)
    23e2:	fe043783          	ld	a5,-32(s0)
    23e6:	4fbc                	lw	a5,88(a5)
    23e8:	40f707bb          	subw	a5,a4,a5
    23ec:	2781                	sext.w	a5,a5
    23ee:	faf42223          	sw	a5,-92(s0)
        if (x < mn - args.current_time)
    23f2:	409c                	lw	a5,0(s1)
    23f4:	fbc42703          	lw	a4,-68(s0)
    23f8:	40f707bb          	subw	a5,a4,a5
    23fc:	0007871b          	sext.w	a4,a5
    2400:	fa442783          	lw	a5,-92(s0)
    2404:	2781                	sext.w	a5,a5
    2406:	00e7d763          	bge	a5,a4,2414 <schedule_dm+0x268>
            r.allocated_time = x;
    240a:	fa442783          	lw	a5,-92(s0)
    240e:	f6f42423          	sw	a5,-152(s0)
    2412:	a809                	j	2424 <schedule_dm+0x278>
        else
            r.allocated_time = mn - args.current_time;
    2414:	409c                	lw	a5,0(s1)
    2416:	fbc42703          	lw	a4,-68(s0)
    241a:	40f707bb          	subw	a5,a4,a5
    241e:	2781                	sext.w	a5,a5
    2420:	f6f42423          	sw	a5,-152(s0)
    
    }
    return r;
    2424:	f6043783          	ld	a5,-160(s0)
    2428:	f6f43823          	sd	a5,-144(s0)
    242c:	f6843783          	ld	a5,-152(s0)
    2430:	f6f43c23          	sd	a5,-136(s0)
    2434:	4701                	li	a4,0
    2436:	f7043703          	ld	a4,-144(s0)
    243a:	4781                	li	a5,0
    243c:	f7843783          	ld	a5,-136(s0)
    2440:	863a                	mv	a2,a4
    2442:	86be                	mv	a3,a5
    2444:	8732                	mv	a4,a2
    2446:	87b6                	mv	a5,a3
    2448:	853a                	mv	a0,a4
    244a:	85be                	mv	a1,a5
    244c:	646a                	ld	s0,152(sp)
    244e:	64ca                	ld	s1,144(sp)
    2450:	610d                	addi	sp,sp,160
    2452:	8082                	ret
