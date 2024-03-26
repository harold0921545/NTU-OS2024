
user/_ls:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <fmtname>:
#include "user/user.h"
#include "kernel/fs.h"

char*
fmtname(char *path)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
   e:	84aa                	mv	s1,a0
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
  10:	00000097          	auipc	ra,0x0
  14:	30c080e7          	jalr	780(ra) # 31c <strlen>
  18:	02051793          	slli	a5,a0,0x20
  1c:	9381                	srli	a5,a5,0x20
  1e:	97a6                	add	a5,a5,s1
  20:	02f00693          	li	a3,47
  24:	0097e963          	bltu	a5,s1,36 <fmtname+0x36>
  28:	0007c703          	lbu	a4,0(a5)
  2c:	00d70563          	beq	a4,a3,36 <fmtname+0x36>
  30:	17fd                	addi	a5,a5,-1
  32:	fe97fbe3          	bgeu	a5,s1,28 <fmtname+0x28>
    ;
  p++;
  36:	00178493          	addi	s1,a5,1

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  3a:	8526                	mv	a0,s1
  3c:	00000097          	auipc	ra,0x0
  40:	2e0080e7          	jalr	736(ra) # 31c <strlen>
  44:	2501                	sext.w	a0,a0
  46:	47b5                	li	a5,13
  48:	00a7fa63          	bgeu	a5,a0,5c <fmtname+0x5c>
    return p;
  memmove(buf, p, strlen(p));
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  return buf;
}
  4c:	8526                	mv	a0,s1
  4e:	70a2                	ld	ra,40(sp)
  50:	7402                	ld	s0,32(sp)
  52:	64e2                	ld	s1,24(sp)
  54:	6942                	ld	s2,16(sp)
  56:	69a2                	ld	s3,8(sp)
  58:	6145                	addi	sp,sp,48
  5a:	8082                	ret
  memmove(buf, p, strlen(p));
  5c:	8526                	mv	a0,s1
  5e:	00000097          	auipc	ra,0x0
  62:	2be080e7          	jalr	702(ra) # 31c <strlen>
  66:	00001997          	auipc	s3,0x1
  6a:	ada98993          	addi	s3,s3,-1318 # b40 <buf.1123>
  6e:	0005061b          	sext.w	a2,a0
  72:	85a6                	mv	a1,s1
  74:	854e                	mv	a0,s3
  76:	00000097          	auipc	ra,0x0
  7a:	41e080e7          	jalr	1054(ra) # 494 <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  7e:	8526                	mv	a0,s1
  80:	00000097          	auipc	ra,0x0
  84:	29c080e7          	jalr	668(ra) # 31c <strlen>
  88:	0005091b          	sext.w	s2,a0
  8c:	8526                	mv	a0,s1
  8e:	00000097          	auipc	ra,0x0
  92:	28e080e7          	jalr	654(ra) # 31c <strlen>
  96:	1902                	slli	s2,s2,0x20
  98:	02095913          	srli	s2,s2,0x20
  9c:	4639                	li	a2,14
  9e:	9e09                	subw	a2,a2,a0
  a0:	02000593          	li	a1,32
  a4:	01298533          	add	a0,s3,s2
  a8:	00000097          	auipc	ra,0x0
  ac:	29e080e7          	jalr	670(ra) # 346 <memset>
  return buf;
  b0:	84ce                	mv	s1,s3
  b2:	bf69                	j	4c <fmtname+0x4c>

00000000000000b4 <ls>:

void
ls(char *path)
{
  b4:	d9010113          	addi	sp,sp,-624
  b8:	26113423          	sd	ra,616(sp)
  bc:	26813023          	sd	s0,608(sp)
  c0:	24913c23          	sd	s1,600(sp)
  c4:	25213823          	sd	s2,592(sp)
  c8:	25313423          	sd	s3,584(sp)
  cc:	25413023          	sd	s4,576(sp)
  d0:	23513c23          	sd	s5,568(sp)
  d4:	1c80                	addi	s0,sp,624
  d6:	892a                	mv	s2,a0
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, 0)) < 0){
  d8:	4581                	li	a1,0
  da:	00000097          	auipc	ra,0x0
  de:	4c6080e7          	jalr	1222(ra) # 5a0 <open>
  e2:	06054f63          	bltz	a0,160 <ls+0xac>
  e6:	84aa                	mv	s1,a0
    fprintf(2, "ls: cannot open %s\n", path);
    return;
  }

  if(fstat(fd, &st) < 0){
  e8:	d9840593          	addi	a1,s0,-616
  ec:	00000097          	auipc	ra,0x0
  f0:	4cc080e7          	jalr	1228(ra) # 5b8 <fstat>
  f4:	08054163          	bltz	a0,176 <ls+0xc2>
    fprintf(2, "ls: cannot stat %s\n", path);
    close(fd);
    return;
  }

  switch(st.type){
  f8:	da041783          	lh	a5,-608(s0)
  fc:	0007869b          	sext.w	a3,a5
 100:	4705                	li	a4,1
 102:	08e68a63          	beq	a3,a4,196 <ls+0xe2>
 106:	4709                	li	a4,2
 108:	02e69663          	bne	a3,a4,134 <ls+0x80>
  case T_FILE:
    printf("%s %d %d %l\n", fmtname(path), st.type, st.ino, st.size);
 10c:	854a                	mv	a0,s2
 10e:	00000097          	auipc	ra,0x0
 112:	ef2080e7          	jalr	-270(ra) # 0 <fmtname>
 116:	85aa                	mv	a1,a0
 118:	da843703          	ld	a4,-600(s0)
 11c:	d9c42683          	lw	a3,-612(s0)
 120:	da041603          	lh	a2,-608(s0)
 124:	00001517          	auipc	a0,0x1
 128:	9b450513          	addi	a0,a0,-1612 # ad8 <malloc+0x116>
 12c:	00000097          	auipc	ra,0x0
 130:	7d8080e7          	jalr	2008(ra) # 904 <printf>
      }
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
    }
    break;
  }
  close(fd);
 134:	8526                	mv	a0,s1
 136:	00000097          	auipc	ra,0x0
 13a:	452080e7          	jalr	1106(ra) # 588 <close>
}
 13e:	26813083          	ld	ra,616(sp)
 142:	26013403          	ld	s0,608(sp)
 146:	25813483          	ld	s1,600(sp)
 14a:	25013903          	ld	s2,592(sp)
 14e:	24813983          	ld	s3,584(sp)
 152:	24013a03          	ld	s4,576(sp)
 156:	23813a83          	ld	s5,568(sp)
 15a:	27010113          	addi	sp,sp,624
 15e:	8082                	ret
    fprintf(2, "ls: cannot open %s\n", path);
 160:	864a                	mv	a2,s2
 162:	00001597          	auipc	a1,0x1
 166:	94658593          	addi	a1,a1,-1722 # aa8 <malloc+0xe6>
 16a:	4509                	li	a0,2
 16c:	00000097          	auipc	ra,0x0
 170:	76a080e7          	jalr	1898(ra) # 8d6 <fprintf>
    return;
 174:	b7e9                	j	13e <ls+0x8a>
    fprintf(2, "ls: cannot stat %s\n", path);
 176:	864a                	mv	a2,s2
 178:	00001597          	auipc	a1,0x1
 17c:	94858593          	addi	a1,a1,-1720 # ac0 <malloc+0xfe>
 180:	4509                	li	a0,2
 182:	00000097          	auipc	ra,0x0
 186:	754080e7          	jalr	1876(ra) # 8d6 <fprintf>
    close(fd);
 18a:	8526                	mv	a0,s1
 18c:	00000097          	auipc	ra,0x0
 190:	3fc080e7          	jalr	1020(ra) # 588 <close>
    return;
 194:	b76d                	j	13e <ls+0x8a>
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 196:	854a                	mv	a0,s2
 198:	00000097          	auipc	ra,0x0
 19c:	184080e7          	jalr	388(ra) # 31c <strlen>
 1a0:	2541                	addiw	a0,a0,16
 1a2:	20000793          	li	a5,512
 1a6:	00a7fb63          	bgeu	a5,a0,1bc <ls+0x108>
      printf("ls: path too long\n");
 1aa:	00001517          	auipc	a0,0x1
 1ae:	93e50513          	addi	a0,a0,-1730 # ae8 <malloc+0x126>
 1b2:	00000097          	auipc	ra,0x0
 1b6:	752080e7          	jalr	1874(ra) # 904 <printf>
      break;
 1ba:	bfad                	j	134 <ls+0x80>
    strcpy(buf, path);
 1bc:	85ca                	mv	a1,s2
 1be:	dc040513          	addi	a0,s0,-576
 1c2:	00000097          	auipc	ra,0x0
 1c6:	112080e7          	jalr	274(ra) # 2d4 <strcpy>
    p = buf+strlen(buf);
 1ca:	dc040513          	addi	a0,s0,-576
 1ce:	00000097          	auipc	ra,0x0
 1d2:	14e080e7          	jalr	334(ra) # 31c <strlen>
 1d6:	02051913          	slli	s2,a0,0x20
 1da:	02095913          	srli	s2,s2,0x20
 1de:	dc040793          	addi	a5,s0,-576
 1e2:	993e                	add	s2,s2,a5
    *p++ = '/';
 1e4:	00190993          	addi	s3,s2,1
 1e8:	02f00793          	li	a5,47
 1ec:	00f90023          	sb	a5,0(s2)
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 1f0:	00001a17          	auipc	s4,0x1
 1f4:	910a0a13          	addi	s4,s4,-1776 # b00 <malloc+0x13e>
        printf("ls: cannot stat %s\n", buf);
 1f8:	00001a97          	auipc	s5,0x1
 1fc:	8c8a8a93          	addi	s5,s5,-1848 # ac0 <malloc+0xfe>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 200:	a801                	j	210 <ls+0x15c>
        printf("ls: cannot stat %s\n", buf);
 202:	dc040593          	addi	a1,s0,-576
 206:	8556                	mv	a0,s5
 208:	00000097          	auipc	ra,0x0
 20c:	6fc080e7          	jalr	1788(ra) # 904 <printf>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 210:	4641                	li	a2,16
 212:	db040593          	addi	a1,s0,-592
 216:	8526                	mv	a0,s1
 218:	00000097          	auipc	ra,0x0
 21c:	360080e7          	jalr	864(ra) # 578 <read>
 220:	47c1                	li	a5,16
 222:	f0f519e3          	bne	a0,a5,134 <ls+0x80>
      if(de.inum == 0)
 226:	db045783          	lhu	a5,-592(s0)
 22a:	d3fd                	beqz	a5,210 <ls+0x15c>
      memmove(p, de.name, DIRSIZ);
 22c:	4639                	li	a2,14
 22e:	db240593          	addi	a1,s0,-590
 232:	854e                	mv	a0,s3
 234:	00000097          	auipc	ra,0x0
 238:	260080e7          	jalr	608(ra) # 494 <memmove>
      p[DIRSIZ] = 0;
 23c:	000907a3          	sb	zero,15(s2)
      if(stat(buf, &st) < 0){
 240:	d9840593          	addi	a1,s0,-616
 244:	dc040513          	addi	a0,s0,-576
 248:	00000097          	auipc	ra,0x0
 24c:	1bc080e7          	jalr	444(ra) # 404 <stat>
 250:	fa0549e3          	bltz	a0,202 <ls+0x14e>
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 254:	dc040513          	addi	a0,s0,-576
 258:	00000097          	auipc	ra,0x0
 25c:	da8080e7          	jalr	-600(ra) # 0 <fmtname>
 260:	85aa                	mv	a1,a0
 262:	da843703          	ld	a4,-600(s0)
 266:	d9c42683          	lw	a3,-612(s0)
 26a:	da041603          	lh	a2,-608(s0)
 26e:	8552                	mv	a0,s4
 270:	00000097          	auipc	ra,0x0
 274:	694080e7          	jalr	1684(ra) # 904 <printf>
 278:	bf61                	j	210 <ls+0x15c>

000000000000027a <main>:

int
main(int argc, char *argv[])
{
 27a:	1101                	addi	sp,sp,-32
 27c:	ec06                	sd	ra,24(sp)
 27e:	e822                	sd	s0,16(sp)
 280:	e426                	sd	s1,8(sp)
 282:	e04a                	sd	s2,0(sp)
 284:	1000                	addi	s0,sp,32
  int i;

  if(argc < 2){
 286:	4785                	li	a5,1
 288:	02a7d963          	bge	a5,a0,2ba <main+0x40>
 28c:	00858493          	addi	s1,a1,8
 290:	ffe5091b          	addiw	s2,a0,-2
 294:	1902                	slli	s2,s2,0x20
 296:	02095913          	srli	s2,s2,0x20
 29a:	090e                	slli	s2,s2,0x3
 29c:	05c1                	addi	a1,a1,16
 29e:	992e                	add	s2,s2,a1
    ls(".");
    exit(0);
  }
  for(i=1; i<argc; i++)
    ls(argv[i]);
 2a0:	6088                	ld	a0,0(s1)
 2a2:	00000097          	auipc	ra,0x0
 2a6:	e12080e7          	jalr	-494(ra) # b4 <ls>
  for(i=1; i<argc; i++)
 2aa:	04a1                	addi	s1,s1,8
 2ac:	ff249ae3          	bne	s1,s2,2a0 <main+0x26>
  exit(0);
 2b0:	4501                	li	a0,0
 2b2:	00000097          	auipc	ra,0x0
 2b6:	2ae080e7          	jalr	686(ra) # 560 <exit>
    ls(".");
 2ba:	00001517          	auipc	a0,0x1
 2be:	85650513          	addi	a0,a0,-1962 # b10 <malloc+0x14e>
 2c2:	00000097          	auipc	ra,0x0
 2c6:	df2080e7          	jalr	-526(ra) # b4 <ls>
    exit(0);
 2ca:	4501                	li	a0,0
 2cc:	00000097          	auipc	ra,0x0
 2d0:	294080e7          	jalr	660(ra) # 560 <exit>

00000000000002d4 <strcpy>:



char*
strcpy(char *s, const char *t)
{
 2d4:	1141                	addi	sp,sp,-16
 2d6:	e422                	sd	s0,8(sp)
 2d8:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2da:	87aa                	mv	a5,a0
 2dc:	0585                	addi	a1,a1,1
 2de:	0785                	addi	a5,a5,1
 2e0:	fff5c703          	lbu	a4,-1(a1)
 2e4:	fee78fa3          	sb	a4,-1(a5)
 2e8:	fb75                	bnez	a4,2dc <strcpy+0x8>
    ;
  return os;
}
 2ea:	6422                	ld	s0,8(sp)
 2ec:	0141                	addi	sp,sp,16
 2ee:	8082                	ret

00000000000002f0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2f0:	1141                	addi	sp,sp,-16
 2f2:	e422                	sd	s0,8(sp)
 2f4:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 2f6:	00054783          	lbu	a5,0(a0)
 2fa:	cb91                	beqz	a5,30e <strcmp+0x1e>
 2fc:	0005c703          	lbu	a4,0(a1)
 300:	00f71763          	bne	a4,a5,30e <strcmp+0x1e>
    p++, q++;
 304:	0505                	addi	a0,a0,1
 306:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 308:	00054783          	lbu	a5,0(a0)
 30c:	fbe5                	bnez	a5,2fc <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 30e:	0005c503          	lbu	a0,0(a1)
}
 312:	40a7853b          	subw	a0,a5,a0
 316:	6422                	ld	s0,8(sp)
 318:	0141                	addi	sp,sp,16
 31a:	8082                	ret

000000000000031c <strlen>:

uint
strlen(const char *s)
{
 31c:	1141                	addi	sp,sp,-16
 31e:	e422                	sd	s0,8(sp)
 320:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 322:	00054783          	lbu	a5,0(a0)
 326:	cf91                	beqz	a5,342 <strlen+0x26>
 328:	0505                	addi	a0,a0,1
 32a:	87aa                	mv	a5,a0
 32c:	4685                	li	a3,1
 32e:	9e89                	subw	a3,a3,a0
 330:	00f6853b          	addw	a0,a3,a5
 334:	0785                	addi	a5,a5,1
 336:	fff7c703          	lbu	a4,-1(a5)
 33a:	fb7d                	bnez	a4,330 <strlen+0x14>
    ;
  return n;
}
 33c:	6422                	ld	s0,8(sp)
 33e:	0141                	addi	sp,sp,16
 340:	8082                	ret
  for(n = 0; s[n]; n++)
 342:	4501                	li	a0,0
 344:	bfe5                	j	33c <strlen+0x20>

0000000000000346 <memset>:

void*
memset(void *dst, int c, uint n)
{
 346:	1141                	addi	sp,sp,-16
 348:	e422                	sd	s0,8(sp)
 34a:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 34c:	ce09                	beqz	a2,366 <memset+0x20>
 34e:	87aa                	mv	a5,a0
 350:	fff6071b          	addiw	a4,a2,-1
 354:	1702                	slli	a4,a4,0x20
 356:	9301                	srli	a4,a4,0x20
 358:	0705                	addi	a4,a4,1
 35a:	972a                	add	a4,a4,a0
    cdst[i] = c;
 35c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 360:	0785                	addi	a5,a5,1
 362:	fee79de3          	bne	a5,a4,35c <memset+0x16>
  }
  return dst;
}
 366:	6422                	ld	s0,8(sp)
 368:	0141                	addi	sp,sp,16
 36a:	8082                	ret

000000000000036c <strchr>:

char*
strchr(const char *s, char c)
{
 36c:	1141                	addi	sp,sp,-16
 36e:	e422                	sd	s0,8(sp)
 370:	0800                	addi	s0,sp,16
  for(; *s; s++)
 372:	00054783          	lbu	a5,0(a0)
 376:	cb99                	beqz	a5,38c <strchr+0x20>
    if(*s == c)
 378:	00f58763          	beq	a1,a5,386 <strchr+0x1a>
  for(; *s; s++)
 37c:	0505                	addi	a0,a0,1
 37e:	00054783          	lbu	a5,0(a0)
 382:	fbfd                	bnez	a5,378 <strchr+0xc>
      return (char*)s;
  return 0;
 384:	4501                	li	a0,0
}
 386:	6422                	ld	s0,8(sp)
 388:	0141                	addi	sp,sp,16
 38a:	8082                	ret
  return 0;
 38c:	4501                	li	a0,0
 38e:	bfe5                	j	386 <strchr+0x1a>

0000000000000390 <gets>:

char*
gets(char *buf, int max)
{
 390:	711d                	addi	sp,sp,-96
 392:	ec86                	sd	ra,88(sp)
 394:	e8a2                	sd	s0,80(sp)
 396:	e4a6                	sd	s1,72(sp)
 398:	e0ca                	sd	s2,64(sp)
 39a:	fc4e                	sd	s3,56(sp)
 39c:	f852                	sd	s4,48(sp)
 39e:	f456                	sd	s5,40(sp)
 3a0:	f05a                	sd	s6,32(sp)
 3a2:	ec5e                	sd	s7,24(sp)
 3a4:	1080                	addi	s0,sp,96
 3a6:	8baa                	mv	s7,a0
 3a8:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3aa:	892a                	mv	s2,a0
 3ac:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 3ae:	4aa9                	li	s5,10
 3b0:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 3b2:	89a6                	mv	s3,s1
 3b4:	2485                	addiw	s1,s1,1
 3b6:	0344d863          	bge	s1,s4,3e6 <gets+0x56>
    cc = read(0, &c, 1);
 3ba:	4605                	li	a2,1
 3bc:	faf40593          	addi	a1,s0,-81
 3c0:	4501                	li	a0,0
 3c2:	00000097          	auipc	ra,0x0
 3c6:	1b6080e7          	jalr	438(ra) # 578 <read>
    if(cc < 1)
 3ca:	00a05e63          	blez	a0,3e6 <gets+0x56>
    buf[i++] = c;
 3ce:	faf44783          	lbu	a5,-81(s0)
 3d2:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 3d6:	01578763          	beq	a5,s5,3e4 <gets+0x54>
 3da:	0905                	addi	s2,s2,1
 3dc:	fd679be3          	bne	a5,s6,3b2 <gets+0x22>
  for(i=0; i+1 < max; ){
 3e0:	89a6                	mv	s3,s1
 3e2:	a011                	j	3e6 <gets+0x56>
 3e4:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 3e6:	99de                	add	s3,s3,s7
 3e8:	00098023          	sb	zero,0(s3)
  return buf;
}
 3ec:	855e                	mv	a0,s7
 3ee:	60e6                	ld	ra,88(sp)
 3f0:	6446                	ld	s0,80(sp)
 3f2:	64a6                	ld	s1,72(sp)
 3f4:	6906                	ld	s2,64(sp)
 3f6:	79e2                	ld	s3,56(sp)
 3f8:	7a42                	ld	s4,48(sp)
 3fa:	7aa2                	ld	s5,40(sp)
 3fc:	7b02                	ld	s6,32(sp)
 3fe:	6be2                	ld	s7,24(sp)
 400:	6125                	addi	sp,sp,96
 402:	8082                	ret

0000000000000404 <stat>:

int
stat(const char *n, struct stat *st)
{
 404:	1101                	addi	sp,sp,-32
 406:	ec06                	sd	ra,24(sp)
 408:	e822                	sd	s0,16(sp)
 40a:	e426                	sd	s1,8(sp)
 40c:	e04a                	sd	s2,0(sp)
 40e:	1000                	addi	s0,sp,32
 410:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 412:	4581                	li	a1,0
 414:	00000097          	auipc	ra,0x0
 418:	18c080e7          	jalr	396(ra) # 5a0 <open>
  if(fd < 0)
 41c:	02054563          	bltz	a0,446 <stat+0x42>
 420:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 422:	85ca                	mv	a1,s2
 424:	00000097          	auipc	ra,0x0
 428:	194080e7          	jalr	404(ra) # 5b8 <fstat>
 42c:	892a                	mv	s2,a0
  close(fd);
 42e:	8526                	mv	a0,s1
 430:	00000097          	auipc	ra,0x0
 434:	158080e7          	jalr	344(ra) # 588 <close>
  return r;
}
 438:	854a                	mv	a0,s2
 43a:	60e2                	ld	ra,24(sp)
 43c:	6442                	ld	s0,16(sp)
 43e:	64a2                	ld	s1,8(sp)
 440:	6902                	ld	s2,0(sp)
 442:	6105                	addi	sp,sp,32
 444:	8082                	ret
    return -1;
 446:	597d                	li	s2,-1
 448:	bfc5                	j	438 <stat+0x34>

000000000000044a <atoi>:

int
atoi(const char *s)
{
 44a:	1141                	addi	sp,sp,-16
 44c:	e422                	sd	s0,8(sp)
 44e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 450:	00054603          	lbu	a2,0(a0)
 454:	fd06079b          	addiw	a5,a2,-48
 458:	0ff7f793          	andi	a5,a5,255
 45c:	4725                	li	a4,9
 45e:	02f76963          	bltu	a4,a5,490 <atoi+0x46>
 462:	86aa                	mv	a3,a0
  n = 0;
 464:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 466:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 468:	0685                	addi	a3,a3,1
 46a:	0025179b          	slliw	a5,a0,0x2
 46e:	9fa9                	addw	a5,a5,a0
 470:	0017979b          	slliw	a5,a5,0x1
 474:	9fb1                	addw	a5,a5,a2
 476:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 47a:	0006c603          	lbu	a2,0(a3)
 47e:	fd06071b          	addiw	a4,a2,-48
 482:	0ff77713          	andi	a4,a4,255
 486:	fee5f1e3          	bgeu	a1,a4,468 <atoi+0x1e>
  return n;
}
 48a:	6422                	ld	s0,8(sp)
 48c:	0141                	addi	sp,sp,16
 48e:	8082                	ret
  n = 0;
 490:	4501                	li	a0,0
 492:	bfe5                	j	48a <atoi+0x40>

0000000000000494 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 494:	1141                	addi	sp,sp,-16
 496:	e422                	sd	s0,8(sp)
 498:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 49a:	02b57663          	bgeu	a0,a1,4c6 <memmove+0x32>
    while(n-- > 0)
 49e:	02c05163          	blez	a2,4c0 <memmove+0x2c>
 4a2:	fff6079b          	addiw	a5,a2,-1
 4a6:	1782                	slli	a5,a5,0x20
 4a8:	9381                	srli	a5,a5,0x20
 4aa:	0785                	addi	a5,a5,1
 4ac:	97aa                	add	a5,a5,a0
  dst = vdst;
 4ae:	872a                	mv	a4,a0
      *dst++ = *src++;
 4b0:	0585                	addi	a1,a1,1
 4b2:	0705                	addi	a4,a4,1
 4b4:	fff5c683          	lbu	a3,-1(a1)
 4b8:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 4bc:	fee79ae3          	bne	a5,a4,4b0 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 4c0:	6422                	ld	s0,8(sp)
 4c2:	0141                	addi	sp,sp,16
 4c4:	8082                	ret
    dst += n;
 4c6:	00c50733          	add	a4,a0,a2
    src += n;
 4ca:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 4cc:	fec05ae3          	blez	a2,4c0 <memmove+0x2c>
 4d0:	fff6079b          	addiw	a5,a2,-1
 4d4:	1782                	slli	a5,a5,0x20
 4d6:	9381                	srli	a5,a5,0x20
 4d8:	fff7c793          	not	a5,a5
 4dc:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 4de:	15fd                	addi	a1,a1,-1
 4e0:	177d                	addi	a4,a4,-1
 4e2:	0005c683          	lbu	a3,0(a1)
 4e6:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 4ea:	fee79ae3          	bne	a5,a4,4de <memmove+0x4a>
 4ee:	bfc9                	j	4c0 <memmove+0x2c>

00000000000004f0 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 4f0:	1141                	addi	sp,sp,-16
 4f2:	e422                	sd	s0,8(sp)
 4f4:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 4f6:	ca05                	beqz	a2,526 <memcmp+0x36>
 4f8:	fff6069b          	addiw	a3,a2,-1
 4fc:	1682                	slli	a3,a3,0x20
 4fe:	9281                	srli	a3,a3,0x20
 500:	0685                	addi	a3,a3,1
 502:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 504:	00054783          	lbu	a5,0(a0)
 508:	0005c703          	lbu	a4,0(a1)
 50c:	00e79863          	bne	a5,a4,51c <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 510:	0505                	addi	a0,a0,1
    p2++;
 512:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 514:	fed518e3          	bne	a0,a3,504 <memcmp+0x14>
  }
  return 0;
 518:	4501                	li	a0,0
 51a:	a019                	j	520 <memcmp+0x30>
      return *p1 - *p2;
 51c:	40e7853b          	subw	a0,a5,a4
}
 520:	6422                	ld	s0,8(sp)
 522:	0141                	addi	sp,sp,16
 524:	8082                	ret
  return 0;
 526:	4501                	li	a0,0
 528:	bfe5                	j	520 <memcmp+0x30>

000000000000052a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 52a:	1141                	addi	sp,sp,-16
 52c:	e406                	sd	ra,8(sp)
 52e:	e022                	sd	s0,0(sp)
 530:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 532:	00000097          	auipc	ra,0x0
 536:	f62080e7          	jalr	-158(ra) # 494 <memmove>
}
 53a:	60a2                	ld	ra,8(sp)
 53c:	6402                	ld	s0,0(sp)
 53e:	0141                	addi	sp,sp,16
 540:	8082                	ret

0000000000000542 <ugetpid>:

#ifdef LAB_PGTBL
int
ugetpid(void)
{
 542:	1141                	addi	sp,sp,-16
 544:	e422                	sd	s0,8(sp)
 546:	0800                	addi	s0,sp,16
  struct usyscall *u = (struct usyscall *)USYSCALL;
  return u->pid;
 548:	040007b7          	lui	a5,0x4000
}
 54c:	17f5                	addi	a5,a5,-3
 54e:	07b2                	slli	a5,a5,0xc
 550:	4388                	lw	a0,0(a5)
 552:	6422                	ld	s0,8(sp)
 554:	0141                	addi	sp,sp,16
 556:	8082                	ret

0000000000000558 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 558:	4885                	li	a7,1
 ecall
 55a:	00000073          	ecall
 ret
 55e:	8082                	ret

0000000000000560 <exit>:
.global exit
exit:
 li a7, SYS_exit
 560:	4889                	li	a7,2
 ecall
 562:	00000073          	ecall
 ret
 566:	8082                	ret

0000000000000568 <wait>:
.global wait
wait:
 li a7, SYS_wait
 568:	488d                	li	a7,3
 ecall
 56a:	00000073          	ecall
 ret
 56e:	8082                	ret

0000000000000570 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 570:	4891                	li	a7,4
 ecall
 572:	00000073          	ecall
 ret
 576:	8082                	ret

0000000000000578 <read>:
.global read
read:
 li a7, SYS_read
 578:	4895                	li	a7,5
 ecall
 57a:	00000073          	ecall
 ret
 57e:	8082                	ret

0000000000000580 <write>:
.global write
write:
 li a7, SYS_write
 580:	48c1                	li	a7,16
 ecall
 582:	00000073          	ecall
 ret
 586:	8082                	ret

0000000000000588 <close>:
.global close
close:
 li a7, SYS_close
 588:	48d5                	li	a7,21
 ecall
 58a:	00000073          	ecall
 ret
 58e:	8082                	ret

0000000000000590 <kill>:
.global kill
kill:
 li a7, SYS_kill
 590:	4899                	li	a7,6
 ecall
 592:	00000073          	ecall
 ret
 596:	8082                	ret

0000000000000598 <exec>:
.global exec
exec:
 li a7, SYS_exec
 598:	489d                	li	a7,7
 ecall
 59a:	00000073          	ecall
 ret
 59e:	8082                	ret

00000000000005a0 <open>:
.global open
open:
 li a7, SYS_open
 5a0:	48bd                	li	a7,15
 ecall
 5a2:	00000073          	ecall
 ret
 5a6:	8082                	ret

00000000000005a8 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 5a8:	48c5                	li	a7,17
 ecall
 5aa:	00000073          	ecall
 ret
 5ae:	8082                	ret

00000000000005b0 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 5b0:	48c9                	li	a7,18
 ecall
 5b2:	00000073          	ecall
 ret
 5b6:	8082                	ret

00000000000005b8 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 5b8:	48a1                	li	a7,8
 ecall
 5ba:	00000073          	ecall
 ret
 5be:	8082                	ret

00000000000005c0 <link>:
.global link
link:
 li a7, SYS_link
 5c0:	48cd                	li	a7,19
 ecall
 5c2:	00000073          	ecall
 ret
 5c6:	8082                	ret

00000000000005c8 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 5c8:	48d1                	li	a7,20
 ecall
 5ca:	00000073          	ecall
 ret
 5ce:	8082                	ret

00000000000005d0 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 5d0:	48a5                	li	a7,9
 ecall
 5d2:	00000073          	ecall
 ret
 5d6:	8082                	ret

00000000000005d8 <dup>:
.global dup
dup:
 li a7, SYS_dup
 5d8:	48a9                	li	a7,10
 ecall
 5da:	00000073          	ecall
 ret
 5de:	8082                	ret

00000000000005e0 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5e0:	48ad                	li	a7,11
 ecall
 5e2:	00000073          	ecall
 ret
 5e6:	8082                	ret

00000000000005e8 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 5e8:	48b1                	li	a7,12
 ecall
 5ea:	00000073          	ecall
 ret
 5ee:	8082                	ret

00000000000005f0 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 5f0:	48b5                	li	a7,13
 ecall
 5f2:	00000073          	ecall
 ret
 5f6:	8082                	ret

00000000000005f8 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 5f8:	48b9                	li	a7,14
 ecall
 5fa:	00000073          	ecall
 ret
 5fe:	8082                	ret

0000000000000600 <connect>:
.global connect
connect:
 li a7, SYS_connect
 600:	48f5                	li	a7,29
 ecall
 602:	00000073          	ecall
 ret
 606:	8082                	ret

0000000000000608 <pgaccess>:
.global pgaccess
pgaccess:
 li a7, SYS_pgaccess
 608:	48f9                	li	a7,30
 ecall
 60a:	00000073          	ecall
 ret
 60e:	8082                	ret

0000000000000610 <vmprint>:
.global vmprint
vmprint:
 li a7, SYS_vmprint
 610:	48fd                	li	a7,31
 ecall
 612:	00000073          	ecall
 ret
 616:	8082                	ret

0000000000000618 <madvise>:
.global madvise
madvise:
 li a7, SYS_madvise
 618:	02000893          	li	a7,32
 ecall
 61c:	00000073          	ecall
 ret
 620:	8082                	ret

0000000000000622 <pgprint>:
.global pgprint
pgprint:
 li a7, SYS_pgprint
 622:	02100893          	li	a7,33
 ecall
 626:	00000073          	ecall
 ret
 62a:	8082                	ret

000000000000062c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 62c:	1101                	addi	sp,sp,-32
 62e:	ec06                	sd	ra,24(sp)
 630:	e822                	sd	s0,16(sp)
 632:	1000                	addi	s0,sp,32
 634:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 638:	4605                	li	a2,1
 63a:	fef40593          	addi	a1,s0,-17
 63e:	00000097          	auipc	ra,0x0
 642:	f42080e7          	jalr	-190(ra) # 580 <write>
}
 646:	60e2                	ld	ra,24(sp)
 648:	6442                	ld	s0,16(sp)
 64a:	6105                	addi	sp,sp,32
 64c:	8082                	ret

000000000000064e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 64e:	7139                	addi	sp,sp,-64
 650:	fc06                	sd	ra,56(sp)
 652:	f822                	sd	s0,48(sp)
 654:	f426                	sd	s1,40(sp)
 656:	f04a                	sd	s2,32(sp)
 658:	ec4e                	sd	s3,24(sp)
 65a:	0080                	addi	s0,sp,64
 65c:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 65e:	c299                	beqz	a3,664 <printint+0x16>
 660:	0805c863          	bltz	a1,6f0 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 664:	2581                	sext.w	a1,a1
  neg = 0;
 666:	4881                	li	a7,0
 668:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 66c:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 66e:	2601                	sext.w	a2,a2
 670:	00000517          	auipc	a0,0x0
 674:	4b050513          	addi	a0,a0,1200 # b20 <digits>
 678:	883a                	mv	a6,a4
 67a:	2705                	addiw	a4,a4,1
 67c:	02c5f7bb          	remuw	a5,a1,a2
 680:	1782                	slli	a5,a5,0x20
 682:	9381                	srli	a5,a5,0x20
 684:	97aa                	add	a5,a5,a0
 686:	0007c783          	lbu	a5,0(a5) # 4000000 <__global_pointer$+0x3ffeccf>
 68a:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 68e:	0005879b          	sext.w	a5,a1
 692:	02c5d5bb          	divuw	a1,a1,a2
 696:	0685                	addi	a3,a3,1
 698:	fec7f0e3          	bgeu	a5,a2,678 <printint+0x2a>
  if(neg)
 69c:	00088b63          	beqz	a7,6b2 <printint+0x64>
    buf[i++] = '-';
 6a0:	fd040793          	addi	a5,s0,-48
 6a4:	973e                	add	a4,a4,a5
 6a6:	02d00793          	li	a5,45
 6aa:	fef70823          	sb	a5,-16(a4)
 6ae:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 6b2:	02e05863          	blez	a4,6e2 <printint+0x94>
 6b6:	fc040793          	addi	a5,s0,-64
 6ba:	00e78933          	add	s2,a5,a4
 6be:	fff78993          	addi	s3,a5,-1
 6c2:	99ba                	add	s3,s3,a4
 6c4:	377d                	addiw	a4,a4,-1
 6c6:	1702                	slli	a4,a4,0x20
 6c8:	9301                	srli	a4,a4,0x20
 6ca:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 6ce:	fff94583          	lbu	a1,-1(s2)
 6d2:	8526                	mv	a0,s1
 6d4:	00000097          	auipc	ra,0x0
 6d8:	f58080e7          	jalr	-168(ra) # 62c <putc>
  while(--i >= 0)
 6dc:	197d                	addi	s2,s2,-1
 6de:	ff3918e3          	bne	s2,s3,6ce <printint+0x80>
}
 6e2:	70e2                	ld	ra,56(sp)
 6e4:	7442                	ld	s0,48(sp)
 6e6:	74a2                	ld	s1,40(sp)
 6e8:	7902                	ld	s2,32(sp)
 6ea:	69e2                	ld	s3,24(sp)
 6ec:	6121                	addi	sp,sp,64
 6ee:	8082                	ret
    x = -xx;
 6f0:	40b005bb          	negw	a1,a1
    neg = 1;
 6f4:	4885                	li	a7,1
    x = -xx;
 6f6:	bf8d                	j	668 <printint+0x1a>

00000000000006f8 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 6f8:	7119                	addi	sp,sp,-128
 6fa:	fc86                	sd	ra,120(sp)
 6fc:	f8a2                	sd	s0,112(sp)
 6fe:	f4a6                	sd	s1,104(sp)
 700:	f0ca                	sd	s2,96(sp)
 702:	ecce                	sd	s3,88(sp)
 704:	e8d2                	sd	s4,80(sp)
 706:	e4d6                	sd	s5,72(sp)
 708:	e0da                	sd	s6,64(sp)
 70a:	fc5e                	sd	s7,56(sp)
 70c:	f862                	sd	s8,48(sp)
 70e:	f466                	sd	s9,40(sp)
 710:	f06a                	sd	s10,32(sp)
 712:	ec6e                	sd	s11,24(sp)
 714:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 716:	0005c903          	lbu	s2,0(a1)
 71a:	18090f63          	beqz	s2,8b8 <vprintf+0x1c0>
 71e:	8aaa                	mv	s5,a0
 720:	8b32                	mv	s6,a2
 722:	00158493          	addi	s1,a1,1
  state = 0;
 726:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 728:	02500a13          	li	s4,37
      if(c == 'd'){
 72c:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 730:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 734:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 738:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 73c:	00000b97          	auipc	s7,0x0
 740:	3e4b8b93          	addi	s7,s7,996 # b20 <digits>
 744:	a839                	j	762 <vprintf+0x6a>
        putc(fd, c);
 746:	85ca                	mv	a1,s2
 748:	8556                	mv	a0,s5
 74a:	00000097          	auipc	ra,0x0
 74e:	ee2080e7          	jalr	-286(ra) # 62c <putc>
 752:	a019                	j	758 <vprintf+0x60>
    } else if(state == '%'){
 754:	01498f63          	beq	s3,s4,772 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 758:	0485                	addi	s1,s1,1
 75a:	fff4c903          	lbu	s2,-1(s1)
 75e:	14090d63          	beqz	s2,8b8 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 762:	0009079b          	sext.w	a5,s2
    if(state == 0){
 766:	fe0997e3          	bnez	s3,754 <vprintf+0x5c>
      if(c == '%'){
 76a:	fd479ee3          	bne	a5,s4,746 <vprintf+0x4e>
        state = '%';
 76e:	89be                	mv	s3,a5
 770:	b7e5                	j	758 <vprintf+0x60>
      if(c == 'd'){
 772:	05878063          	beq	a5,s8,7b2 <vprintf+0xba>
      } else if(c == 'l') {
 776:	05978c63          	beq	a5,s9,7ce <vprintf+0xd6>
      } else if(c == 'x') {
 77a:	07a78863          	beq	a5,s10,7ea <vprintf+0xf2>
      } else if(c == 'p') {
 77e:	09b78463          	beq	a5,s11,806 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 782:	07300713          	li	a4,115
 786:	0ce78663          	beq	a5,a4,852 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 78a:	06300713          	li	a4,99
 78e:	0ee78e63          	beq	a5,a4,88a <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 792:	11478863          	beq	a5,s4,8a2 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 796:	85d2                	mv	a1,s4
 798:	8556                	mv	a0,s5
 79a:	00000097          	auipc	ra,0x0
 79e:	e92080e7          	jalr	-366(ra) # 62c <putc>
        putc(fd, c);
 7a2:	85ca                	mv	a1,s2
 7a4:	8556                	mv	a0,s5
 7a6:	00000097          	auipc	ra,0x0
 7aa:	e86080e7          	jalr	-378(ra) # 62c <putc>
      }
      state = 0;
 7ae:	4981                	li	s3,0
 7b0:	b765                	j	758 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 7b2:	008b0913          	addi	s2,s6,8
 7b6:	4685                	li	a3,1
 7b8:	4629                	li	a2,10
 7ba:	000b2583          	lw	a1,0(s6)
 7be:	8556                	mv	a0,s5
 7c0:	00000097          	auipc	ra,0x0
 7c4:	e8e080e7          	jalr	-370(ra) # 64e <printint>
 7c8:	8b4a                	mv	s6,s2
      state = 0;
 7ca:	4981                	li	s3,0
 7cc:	b771                	j	758 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7ce:	008b0913          	addi	s2,s6,8
 7d2:	4681                	li	a3,0
 7d4:	4629                	li	a2,10
 7d6:	000b2583          	lw	a1,0(s6)
 7da:	8556                	mv	a0,s5
 7dc:	00000097          	auipc	ra,0x0
 7e0:	e72080e7          	jalr	-398(ra) # 64e <printint>
 7e4:	8b4a                	mv	s6,s2
      state = 0;
 7e6:	4981                	li	s3,0
 7e8:	bf85                	j	758 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 7ea:	008b0913          	addi	s2,s6,8
 7ee:	4681                	li	a3,0
 7f0:	4641                	li	a2,16
 7f2:	000b2583          	lw	a1,0(s6)
 7f6:	8556                	mv	a0,s5
 7f8:	00000097          	auipc	ra,0x0
 7fc:	e56080e7          	jalr	-426(ra) # 64e <printint>
 800:	8b4a                	mv	s6,s2
      state = 0;
 802:	4981                	li	s3,0
 804:	bf91                	j	758 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 806:	008b0793          	addi	a5,s6,8
 80a:	f8f43423          	sd	a5,-120(s0)
 80e:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 812:	03000593          	li	a1,48
 816:	8556                	mv	a0,s5
 818:	00000097          	auipc	ra,0x0
 81c:	e14080e7          	jalr	-492(ra) # 62c <putc>
  putc(fd, 'x');
 820:	85ea                	mv	a1,s10
 822:	8556                	mv	a0,s5
 824:	00000097          	auipc	ra,0x0
 828:	e08080e7          	jalr	-504(ra) # 62c <putc>
 82c:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 82e:	03c9d793          	srli	a5,s3,0x3c
 832:	97de                	add	a5,a5,s7
 834:	0007c583          	lbu	a1,0(a5)
 838:	8556                	mv	a0,s5
 83a:	00000097          	auipc	ra,0x0
 83e:	df2080e7          	jalr	-526(ra) # 62c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 842:	0992                	slli	s3,s3,0x4
 844:	397d                	addiw	s2,s2,-1
 846:	fe0914e3          	bnez	s2,82e <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 84a:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 84e:	4981                	li	s3,0
 850:	b721                	j	758 <vprintf+0x60>
        s = va_arg(ap, char*);
 852:	008b0993          	addi	s3,s6,8
 856:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 85a:	02090163          	beqz	s2,87c <vprintf+0x184>
        while(*s != 0){
 85e:	00094583          	lbu	a1,0(s2)
 862:	c9a1                	beqz	a1,8b2 <vprintf+0x1ba>
          putc(fd, *s);
 864:	8556                	mv	a0,s5
 866:	00000097          	auipc	ra,0x0
 86a:	dc6080e7          	jalr	-570(ra) # 62c <putc>
          s++;
 86e:	0905                	addi	s2,s2,1
        while(*s != 0){
 870:	00094583          	lbu	a1,0(s2)
 874:	f9e5                	bnez	a1,864 <vprintf+0x16c>
        s = va_arg(ap, char*);
 876:	8b4e                	mv	s6,s3
      state = 0;
 878:	4981                	li	s3,0
 87a:	bdf9                	j	758 <vprintf+0x60>
          s = "(null)";
 87c:	00000917          	auipc	s2,0x0
 880:	29c90913          	addi	s2,s2,668 # b18 <malloc+0x156>
        while(*s != 0){
 884:	02800593          	li	a1,40
 888:	bff1                	j	864 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 88a:	008b0913          	addi	s2,s6,8
 88e:	000b4583          	lbu	a1,0(s6)
 892:	8556                	mv	a0,s5
 894:	00000097          	auipc	ra,0x0
 898:	d98080e7          	jalr	-616(ra) # 62c <putc>
 89c:	8b4a                	mv	s6,s2
      state = 0;
 89e:	4981                	li	s3,0
 8a0:	bd65                	j	758 <vprintf+0x60>
        putc(fd, c);
 8a2:	85d2                	mv	a1,s4
 8a4:	8556                	mv	a0,s5
 8a6:	00000097          	auipc	ra,0x0
 8aa:	d86080e7          	jalr	-634(ra) # 62c <putc>
      state = 0;
 8ae:	4981                	li	s3,0
 8b0:	b565                	j	758 <vprintf+0x60>
        s = va_arg(ap, char*);
 8b2:	8b4e                	mv	s6,s3
      state = 0;
 8b4:	4981                	li	s3,0
 8b6:	b54d                	j	758 <vprintf+0x60>
    }
  }
}
 8b8:	70e6                	ld	ra,120(sp)
 8ba:	7446                	ld	s0,112(sp)
 8bc:	74a6                	ld	s1,104(sp)
 8be:	7906                	ld	s2,96(sp)
 8c0:	69e6                	ld	s3,88(sp)
 8c2:	6a46                	ld	s4,80(sp)
 8c4:	6aa6                	ld	s5,72(sp)
 8c6:	6b06                	ld	s6,64(sp)
 8c8:	7be2                	ld	s7,56(sp)
 8ca:	7c42                	ld	s8,48(sp)
 8cc:	7ca2                	ld	s9,40(sp)
 8ce:	7d02                	ld	s10,32(sp)
 8d0:	6de2                	ld	s11,24(sp)
 8d2:	6109                	addi	sp,sp,128
 8d4:	8082                	ret

00000000000008d6 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8d6:	715d                	addi	sp,sp,-80
 8d8:	ec06                	sd	ra,24(sp)
 8da:	e822                	sd	s0,16(sp)
 8dc:	1000                	addi	s0,sp,32
 8de:	e010                	sd	a2,0(s0)
 8e0:	e414                	sd	a3,8(s0)
 8e2:	e818                	sd	a4,16(s0)
 8e4:	ec1c                	sd	a5,24(s0)
 8e6:	03043023          	sd	a6,32(s0)
 8ea:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8ee:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 8f2:	8622                	mv	a2,s0
 8f4:	00000097          	auipc	ra,0x0
 8f8:	e04080e7          	jalr	-508(ra) # 6f8 <vprintf>
}
 8fc:	60e2                	ld	ra,24(sp)
 8fe:	6442                	ld	s0,16(sp)
 900:	6161                	addi	sp,sp,80
 902:	8082                	ret

0000000000000904 <printf>:

void
printf(const char *fmt, ...)
{
 904:	711d                	addi	sp,sp,-96
 906:	ec06                	sd	ra,24(sp)
 908:	e822                	sd	s0,16(sp)
 90a:	1000                	addi	s0,sp,32
 90c:	e40c                	sd	a1,8(s0)
 90e:	e810                	sd	a2,16(s0)
 910:	ec14                	sd	a3,24(s0)
 912:	f018                	sd	a4,32(s0)
 914:	f41c                	sd	a5,40(s0)
 916:	03043823          	sd	a6,48(s0)
 91a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 91e:	00840613          	addi	a2,s0,8
 922:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 926:	85aa                	mv	a1,a0
 928:	4505                	li	a0,1
 92a:	00000097          	auipc	ra,0x0
 92e:	dce080e7          	jalr	-562(ra) # 6f8 <vprintf>
}
 932:	60e2                	ld	ra,24(sp)
 934:	6442                	ld	s0,16(sp)
 936:	6125                	addi	sp,sp,96
 938:	8082                	ret

000000000000093a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 93a:	1141                	addi	sp,sp,-16
 93c:	e422                	sd	s0,8(sp)
 93e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 940:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 944:	00000797          	auipc	a5,0x0
 948:	1f47b783          	ld	a5,500(a5) # b38 <freep>
 94c:	a805                	j	97c <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 94e:	4618                	lw	a4,8(a2)
 950:	9db9                	addw	a1,a1,a4
 952:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 956:	6398                	ld	a4,0(a5)
 958:	6318                	ld	a4,0(a4)
 95a:	fee53823          	sd	a4,-16(a0)
 95e:	a091                	j	9a2 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 960:	ff852703          	lw	a4,-8(a0)
 964:	9e39                	addw	a2,a2,a4
 966:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 968:	ff053703          	ld	a4,-16(a0)
 96c:	e398                	sd	a4,0(a5)
 96e:	a099                	j	9b4 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 970:	6398                	ld	a4,0(a5)
 972:	00e7e463          	bltu	a5,a4,97a <free+0x40>
 976:	00e6ea63          	bltu	a3,a4,98a <free+0x50>
{
 97a:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 97c:	fed7fae3          	bgeu	a5,a3,970 <free+0x36>
 980:	6398                	ld	a4,0(a5)
 982:	00e6e463          	bltu	a3,a4,98a <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 986:	fee7eae3          	bltu	a5,a4,97a <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 98a:	ff852583          	lw	a1,-8(a0)
 98e:	6390                	ld	a2,0(a5)
 990:	02059713          	slli	a4,a1,0x20
 994:	9301                	srli	a4,a4,0x20
 996:	0712                	slli	a4,a4,0x4
 998:	9736                	add	a4,a4,a3
 99a:	fae60ae3          	beq	a2,a4,94e <free+0x14>
    bp->s.ptr = p->s.ptr;
 99e:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 9a2:	4790                	lw	a2,8(a5)
 9a4:	02061713          	slli	a4,a2,0x20
 9a8:	9301                	srli	a4,a4,0x20
 9aa:	0712                	slli	a4,a4,0x4
 9ac:	973e                	add	a4,a4,a5
 9ae:	fae689e3          	beq	a3,a4,960 <free+0x26>
  } else
    p->s.ptr = bp;
 9b2:	e394                	sd	a3,0(a5)
  freep = p;
 9b4:	00000717          	auipc	a4,0x0
 9b8:	18f73223          	sd	a5,388(a4) # b38 <freep>
}
 9bc:	6422                	ld	s0,8(sp)
 9be:	0141                	addi	sp,sp,16
 9c0:	8082                	ret

00000000000009c2 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9c2:	7139                	addi	sp,sp,-64
 9c4:	fc06                	sd	ra,56(sp)
 9c6:	f822                	sd	s0,48(sp)
 9c8:	f426                	sd	s1,40(sp)
 9ca:	f04a                	sd	s2,32(sp)
 9cc:	ec4e                	sd	s3,24(sp)
 9ce:	e852                	sd	s4,16(sp)
 9d0:	e456                	sd	s5,8(sp)
 9d2:	e05a                	sd	s6,0(sp)
 9d4:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9d6:	02051493          	slli	s1,a0,0x20
 9da:	9081                	srli	s1,s1,0x20
 9dc:	04bd                	addi	s1,s1,15
 9de:	8091                	srli	s1,s1,0x4
 9e0:	0014899b          	addiw	s3,s1,1
 9e4:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 9e6:	00000797          	auipc	a5,0x0
 9ea:	1527b783          	ld	a5,338(a5) # b38 <freep>
 9ee:	c795                	beqz	a5,a1a <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9f0:	6388                	ld	a0,0(a5)
    if(p->s.size >= nunits){
 9f2:	4518                	lw	a4,8(a0)
 9f4:	02977f63          	bgeu	a4,s1,a32 <malloc+0x70>
 9f8:	8a4e                	mv	s4,s3
 9fa:	0009879b          	sext.w	a5,s3
 9fe:	6705                	lui	a4,0x1
 a00:	00e7f363          	bgeu	a5,a4,a06 <malloc+0x44>
 a04:	6a05                	lui	s4,0x1
 a06:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a0a:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p);
    }
    if(p == freep)
 a0e:	00000917          	auipc	s2,0x0
 a12:	12a90913          	addi	s2,s2,298 # b38 <freep>
  if(p == (char*)-1)
 a16:	5afd                	li	s5,-1
 a18:	a0bd                	j	a86 <malloc+0xc4>
    base.s.ptr = freep = prevp = &base;
 a1a:	00000517          	auipc	a0,0x0
 a1e:	13650513          	addi	a0,a0,310 # b50 <base>
 a22:	00000797          	auipc	a5,0x0
 a26:	10a7bb23          	sd	a0,278(a5) # b38 <freep>
 a2a:	e108                	sd	a0,0(a0)
    base.s.size = 0;
 a2c:	00052423          	sw	zero,8(a0)
    if(p->s.size >= nunits){
 a30:	b7e1                	j	9f8 <malloc+0x36>
      if(p->s.size == nunits)
 a32:	02e48963          	beq	s1,a4,a64 <malloc+0xa2>
        p->s.size -= nunits;
 a36:	4137073b          	subw	a4,a4,s3
 a3a:	c518                	sw	a4,8(a0)
        p += p->s.size;
 a3c:	1702                	slli	a4,a4,0x20
 a3e:	9301                	srli	a4,a4,0x20
 a40:	0712                	slli	a4,a4,0x4
 a42:	953a                	add	a0,a0,a4
        p->s.size = nunits;
 a44:	01352423          	sw	s3,8(a0)
      freep = prevp;
 a48:	00000717          	auipc	a4,0x0
 a4c:	0ef73823          	sd	a5,240(a4) # b38 <freep>
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 a50:	70e2                	ld	ra,56(sp)
 a52:	7442                	ld	s0,48(sp)
 a54:	74a2                	ld	s1,40(sp)
 a56:	7902                	ld	s2,32(sp)
 a58:	69e2                	ld	s3,24(sp)
 a5a:	6a42                	ld	s4,16(sp)
 a5c:	6aa2                	ld	s5,8(sp)
 a5e:	6b02                	ld	s6,0(sp)
 a60:	6121                	addi	sp,sp,64
 a62:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 a64:	6118                	ld	a4,0(a0)
 a66:	e398                	sd	a4,0(a5)
 a68:	b7c5                	j	a48 <malloc+0x86>
  hp->s.size = nu;
 a6a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a6e:	0541                	addi	a0,a0,16
 a70:	00000097          	auipc	ra,0x0
 a74:	eca080e7          	jalr	-310(ra) # 93a <free>
  return freep;
 a78:	00093783          	ld	a5,0(s2)
      if((p = morecore(nunits)) == 0)
 a7c:	c39d                	beqz	a5,aa2 <malloc+0xe0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a7e:	6388                	ld	a0,0(a5)
    if(p->s.size >= nunits){
 a80:	4518                	lw	a4,8(a0)
 a82:	fa9778e3          	bgeu	a4,s1,a32 <malloc+0x70>
    if(p == freep)
 a86:	00093703          	ld	a4,0(s2)
 a8a:	87aa                	mv	a5,a0
 a8c:	fea719e3          	bne	a4,a0,a7e <malloc+0xbc>
  p = sbrk(nu * sizeof(Header));
 a90:	8552                	mv	a0,s4
 a92:	00000097          	auipc	ra,0x0
 a96:	b56080e7          	jalr	-1194(ra) # 5e8 <sbrk>
  if(p == (char*)-1)
 a9a:	fd5518e3          	bne	a0,s5,a6a <malloc+0xa8>
        return 0;
 a9e:	4501                	li	a0,0
 aa0:	bf45                	j	a50 <malloc+0x8e>
 aa2:	853e                	mv	a0,a5
 aa4:	b775                	j	a50 <malloc+0x8e>
