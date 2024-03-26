
user/_pgtbltest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <err>:

char *testname = "???";

void
err(char *why)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	addi	s0,sp,32
   c:	84aa                	mv	s1,a0
  printf("pgtbltest: %s failed: %s, pid=%d\n", testname, why, getpid());
   e:	00001917          	auipc	s2,0x1
  12:	afa93903          	ld	s2,-1286(s2) # b08 <testname>
  16:	00000097          	auipc	ra,0x0
  1a:	4fa080e7          	jalr	1274(ra) # 510 <getpid>
  1e:	86aa                	mv	a3,a0
  20:	8626                	mv	a2,s1
  22:	85ca                	mv	a1,s2
  24:	00001517          	auipc	a0,0x1
  28:	9b450513          	addi	a0,a0,-1612 # 9d8 <malloc+0xe6>
  2c:	00001097          	auipc	ra,0x1
  30:	808080e7          	jalr	-2040(ra) # 834 <printf>
  exit(1);
  34:	4505                	li	a0,1
  36:	00000097          	auipc	ra,0x0
  3a:	45a080e7          	jalr	1114(ra) # 490 <exit>

000000000000003e <ugetpid_test>:
}

void
ugetpid_test()
{
  3e:	7179                	addi	sp,sp,-48
  40:	f406                	sd	ra,40(sp)
  42:	f022                	sd	s0,32(sp)
  44:	ec26                	sd	s1,24(sp)
  46:	1800                	addi	s0,sp,48
  int i;

  printf("ugetpid_test starting\n");
  48:	00001517          	auipc	a0,0x1
  4c:	9b850513          	addi	a0,a0,-1608 # a00 <malloc+0x10e>
  50:	00000097          	auipc	ra,0x0
  54:	7e4080e7          	jalr	2020(ra) # 834 <printf>
  testname = "ugetpid_test";
  58:	00001797          	auipc	a5,0x1
  5c:	9c078793          	addi	a5,a5,-1600 # a18 <malloc+0x126>
  60:	00001717          	auipc	a4,0x1
  64:	aaf73423          	sd	a5,-1368(a4) # b08 <testname>
  68:	04000493          	li	s1,64

  for (i = 0; i < 64; i++) {
    int ret = fork();
  6c:	00000097          	auipc	ra,0x0
  70:	41c080e7          	jalr	1052(ra) # 488 <fork>
  74:	fca42e23          	sw	a0,-36(s0)
    if (ret != 0) {
  78:	cd15                	beqz	a0,b4 <ugetpid_test+0x76>
      wait(&ret);
  7a:	fdc40513          	addi	a0,s0,-36
  7e:	00000097          	auipc	ra,0x0
  82:	41a080e7          	jalr	1050(ra) # 498 <wait>
      if (ret != 0)
  86:	fdc42783          	lw	a5,-36(s0)
  8a:	e385                	bnez	a5,aa <ugetpid_test+0x6c>
  for (i = 0; i < 64; i++) {
  8c:	34fd                	addiw	s1,s1,-1
  8e:	fcf9                	bnez	s1,6c <ugetpid_test+0x2e>
    }
    if (getpid() != ugetpid())
      err("missmatched PID");
    exit(0);
  }
  printf("ugetpid_test: OK\n");
  90:	00001517          	auipc	a0,0x1
  94:	9a850513          	addi	a0,a0,-1624 # a38 <malloc+0x146>
  98:	00000097          	auipc	ra,0x0
  9c:	79c080e7          	jalr	1948(ra) # 834 <printf>
}
  a0:	70a2                	ld	ra,40(sp)
  a2:	7402                	ld	s0,32(sp)
  a4:	64e2                	ld	s1,24(sp)
  a6:	6145                	addi	sp,sp,48
  a8:	8082                	ret
        exit(1);
  aa:	4505                	li	a0,1
  ac:	00000097          	auipc	ra,0x0
  b0:	3e4080e7          	jalr	996(ra) # 490 <exit>
    if (getpid() != ugetpid())
  b4:	00000097          	auipc	ra,0x0
  b8:	45c080e7          	jalr	1116(ra) # 510 <getpid>
  bc:	84aa                	mv	s1,a0
  be:	00000097          	auipc	ra,0x0
  c2:	3b4080e7          	jalr	948(ra) # 472 <ugetpid>
  c6:	00a48a63          	beq	s1,a0,da <ugetpid_test+0x9c>
      err("missmatched PID");
  ca:	00001517          	auipc	a0,0x1
  ce:	95e50513          	addi	a0,a0,-1698 # a28 <malloc+0x136>
  d2:	00000097          	auipc	ra,0x0
  d6:	f2e080e7          	jalr	-210(ra) # 0 <err>
    exit(0);
  da:	4501                	li	a0,0
  dc:	00000097          	auipc	ra,0x0
  e0:	3b4080e7          	jalr	948(ra) # 490 <exit>

00000000000000e4 <pgaccess_test>:

void
pgaccess_test()
{
  e4:	7179                	addi	sp,sp,-48
  e6:	f406                	sd	ra,40(sp)
  e8:	f022                	sd	s0,32(sp)
  ea:	ec26                	sd	s1,24(sp)
  ec:	1800                	addi	s0,sp,48
  char *buf;
  unsigned int abits;
  printf("pgaccess_test starting\n");
  ee:	00001517          	auipc	a0,0x1
  f2:	96250513          	addi	a0,a0,-1694 # a50 <malloc+0x15e>
  f6:	00000097          	auipc	ra,0x0
  fa:	73e080e7          	jalr	1854(ra) # 834 <printf>
  testname = "pgaccess_test";
  fe:	00001797          	auipc	a5,0x1
 102:	96a78793          	addi	a5,a5,-1686 # a68 <malloc+0x176>
 106:	00001717          	auipc	a4,0x1
 10a:	a0f73123          	sd	a5,-1534(a4) # b08 <testname>
  buf = malloc(32 * PGSIZE);
 10e:	00020537          	lui	a0,0x20
 112:	00000097          	auipc	ra,0x0
 116:	7e0080e7          	jalr	2016(ra) # 8f2 <malloc>
 11a:	84aa                	mv	s1,a0
  if (pgaccess(buf, 32, &abits) < 0)
 11c:	fdc40613          	addi	a2,s0,-36
 120:	02000593          	li	a1,32
 124:	00000097          	auipc	ra,0x0
 128:	414080e7          	jalr	1044(ra) # 538 <pgaccess>
 12c:	06054b63          	bltz	a0,1a2 <pgaccess_test+0xbe>
    err("pgaccess failed");
  buf[PGSIZE * 1] += 1;
 130:	6785                	lui	a5,0x1
 132:	97a6                	add	a5,a5,s1
 134:	0007c703          	lbu	a4,0(a5) # 1000 <__BSS_END__+0x4d8>
 138:	2705                	addiw	a4,a4,1
 13a:	00e78023          	sb	a4,0(a5)
  buf[PGSIZE * 2] += 1;
 13e:	6789                	lui	a5,0x2
 140:	97a6                	add	a5,a5,s1
 142:	0007c703          	lbu	a4,0(a5) # 2000 <__global_pointer$+0xcff>
 146:	2705                	addiw	a4,a4,1
 148:	00e78023          	sb	a4,0(a5)
  buf[PGSIZE * 30] += 1;
 14c:	67f9                	lui	a5,0x1e
 14e:	97a6                	add	a5,a5,s1
 150:	0007c703          	lbu	a4,0(a5) # 1e000 <__global_pointer$+0x1ccff>
 154:	2705                	addiw	a4,a4,1
 156:	00e78023          	sb	a4,0(a5)
  if (pgaccess(buf, 32, &abits) < 0)
 15a:	fdc40613          	addi	a2,s0,-36
 15e:	02000593          	li	a1,32
 162:	8526                	mv	a0,s1
 164:	00000097          	auipc	ra,0x0
 168:	3d4080e7          	jalr	980(ra) # 538 <pgaccess>
 16c:	04054363          	bltz	a0,1b2 <pgaccess_test+0xce>
    err("pgaccess failed");
  if (abits != ((1 << 1) | (1 << 2) | (1 << 30)))
 170:	fdc42703          	lw	a4,-36(s0)
 174:	400007b7          	lui	a5,0x40000
 178:	0799                	addi	a5,a5,6
 17a:	04f71463          	bne	a4,a5,1c2 <pgaccess_test+0xde>
    err("incorrect access bits set");
  free(buf);
 17e:	8526                	mv	a0,s1
 180:	00000097          	auipc	ra,0x0
 184:	6ea080e7          	jalr	1770(ra) # 86a <free>
  printf("pgaccess_test: OK\n");
 188:	00001517          	auipc	a0,0x1
 18c:	92050513          	addi	a0,a0,-1760 # aa8 <malloc+0x1b6>
 190:	00000097          	auipc	ra,0x0
 194:	6a4080e7          	jalr	1700(ra) # 834 <printf>
}
 198:	70a2                	ld	ra,40(sp)
 19a:	7402                	ld	s0,32(sp)
 19c:	64e2                	ld	s1,24(sp)
 19e:	6145                	addi	sp,sp,48
 1a0:	8082                	ret
    err("pgaccess failed");
 1a2:	00001517          	auipc	a0,0x1
 1a6:	8d650513          	addi	a0,a0,-1834 # a78 <malloc+0x186>
 1aa:	00000097          	auipc	ra,0x0
 1ae:	e56080e7          	jalr	-426(ra) # 0 <err>
    err("pgaccess failed");
 1b2:	00001517          	auipc	a0,0x1
 1b6:	8c650513          	addi	a0,a0,-1850 # a78 <malloc+0x186>
 1ba:	00000097          	auipc	ra,0x0
 1be:	e46080e7          	jalr	-442(ra) # 0 <err>
    err("incorrect access bits set");
 1c2:	00001517          	auipc	a0,0x1
 1c6:	8c650513          	addi	a0,a0,-1850 # a88 <malloc+0x196>
 1ca:	00000097          	auipc	ra,0x0
 1ce:	e36080e7          	jalr	-458(ra) # 0 <err>

00000000000001d2 <main>:
{
 1d2:	1141                	addi	sp,sp,-16
 1d4:	e406                	sd	ra,8(sp)
 1d6:	e022                	sd	s0,0(sp)
 1d8:	0800                	addi	s0,sp,16
  ugetpid_test();
 1da:	00000097          	auipc	ra,0x0
 1de:	e64080e7          	jalr	-412(ra) # 3e <ugetpid_test>
  pgaccess_test();
 1e2:	00000097          	auipc	ra,0x0
 1e6:	f02080e7          	jalr	-254(ra) # e4 <pgaccess_test>
  printf("pgtbltest: all tests succeeded\n");
 1ea:	00001517          	auipc	a0,0x1
 1ee:	8d650513          	addi	a0,a0,-1834 # ac0 <malloc+0x1ce>
 1f2:	00000097          	auipc	ra,0x0
 1f6:	642080e7          	jalr	1602(ra) # 834 <printf>
  exit(0);
 1fa:	4501                	li	a0,0
 1fc:	00000097          	auipc	ra,0x0
 200:	294080e7          	jalr	660(ra) # 490 <exit>

0000000000000204 <strcpy>:



char*
strcpy(char *s, const char *t)
{
 204:	1141                	addi	sp,sp,-16
 206:	e422                	sd	s0,8(sp)
 208:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 20a:	87aa                	mv	a5,a0
 20c:	0585                	addi	a1,a1,1
 20e:	0785                	addi	a5,a5,1
 210:	fff5c703          	lbu	a4,-1(a1)
 214:	fee78fa3          	sb	a4,-1(a5) # 3fffffff <__global_pointer$+0x3fffecfe>
 218:	fb75                	bnez	a4,20c <strcpy+0x8>
    ;
  return os;
}
 21a:	6422                	ld	s0,8(sp)
 21c:	0141                	addi	sp,sp,16
 21e:	8082                	ret

0000000000000220 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 220:	1141                	addi	sp,sp,-16
 222:	e422                	sd	s0,8(sp)
 224:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 226:	00054783          	lbu	a5,0(a0)
 22a:	cb91                	beqz	a5,23e <strcmp+0x1e>
 22c:	0005c703          	lbu	a4,0(a1)
 230:	00f71763          	bne	a4,a5,23e <strcmp+0x1e>
    p++, q++;
 234:	0505                	addi	a0,a0,1
 236:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 238:	00054783          	lbu	a5,0(a0)
 23c:	fbe5                	bnez	a5,22c <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 23e:	0005c503          	lbu	a0,0(a1)
}
 242:	40a7853b          	subw	a0,a5,a0
 246:	6422                	ld	s0,8(sp)
 248:	0141                	addi	sp,sp,16
 24a:	8082                	ret

000000000000024c <strlen>:

uint
strlen(const char *s)
{
 24c:	1141                	addi	sp,sp,-16
 24e:	e422                	sd	s0,8(sp)
 250:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 252:	00054783          	lbu	a5,0(a0)
 256:	cf91                	beqz	a5,272 <strlen+0x26>
 258:	0505                	addi	a0,a0,1
 25a:	87aa                	mv	a5,a0
 25c:	4685                	li	a3,1
 25e:	9e89                	subw	a3,a3,a0
 260:	00f6853b          	addw	a0,a3,a5
 264:	0785                	addi	a5,a5,1
 266:	fff7c703          	lbu	a4,-1(a5)
 26a:	fb7d                	bnez	a4,260 <strlen+0x14>
    ;
  return n;
}
 26c:	6422                	ld	s0,8(sp)
 26e:	0141                	addi	sp,sp,16
 270:	8082                	ret
  for(n = 0; s[n]; n++)
 272:	4501                	li	a0,0
 274:	bfe5                	j	26c <strlen+0x20>

0000000000000276 <memset>:

void*
memset(void *dst, int c, uint n)
{
 276:	1141                	addi	sp,sp,-16
 278:	e422                	sd	s0,8(sp)
 27a:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 27c:	ce09                	beqz	a2,296 <memset+0x20>
 27e:	87aa                	mv	a5,a0
 280:	fff6071b          	addiw	a4,a2,-1
 284:	1702                	slli	a4,a4,0x20
 286:	9301                	srli	a4,a4,0x20
 288:	0705                	addi	a4,a4,1
 28a:	972a                	add	a4,a4,a0
    cdst[i] = c;
 28c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 290:	0785                	addi	a5,a5,1
 292:	fee79de3          	bne	a5,a4,28c <memset+0x16>
  }
  return dst;
}
 296:	6422                	ld	s0,8(sp)
 298:	0141                	addi	sp,sp,16
 29a:	8082                	ret

000000000000029c <strchr>:

char*
strchr(const char *s, char c)
{
 29c:	1141                	addi	sp,sp,-16
 29e:	e422                	sd	s0,8(sp)
 2a0:	0800                	addi	s0,sp,16
  for(; *s; s++)
 2a2:	00054783          	lbu	a5,0(a0)
 2a6:	cb99                	beqz	a5,2bc <strchr+0x20>
    if(*s == c)
 2a8:	00f58763          	beq	a1,a5,2b6 <strchr+0x1a>
  for(; *s; s++)
 2ac:	0505                	addi	a0,a0,1
 2ae:	00054783          	lbu	a5,0(a0)
 2b2:	fbfd                	bnez	a5,2a8 <strchr+0xc>
      return (char*)s;
  return 0;
 2b4:	4501                	li	a0,0
}
 2b6:	6422                	ld	s0,8(sp)
 2b8:	0141                	addi	sp,sp,16
 2ba:	8082                	ret
  return 0;
 2bc:	4501                	li	a0,0
 2be:	bfe5                	j	2b6 <strchr+0x1a>

00000000000002c0 <gets>:

char*
gets(char *buf, int max)
{
 2c0:	711d                	addi	sp,sp,-96
 2c2:	ec86                	sd	ra,88(sp)
 2c4:	e8a2                	sd	s0,80(sp)
 2c6:	e4a6                	sd	s1,72(sp)
 2c8:	e0ca                	sd	s2,64(sp)
 2ca:	fc4e                	sd	s3,56(sp)
 2cc:	f852                	sd	s4,48(sp)
 2ce:	f456                	sd	s5,40(sp)
 2d0:	f05a                	sd	s6,32(sp)
 2d2:	ec5e                	sd	s7,24(sp)
 2d4:	1080                	addi	s0,sp,96
 2d6:	8baa                	mv	s7,a0
 2d8:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2da:	892a                	mv	s2,a0
 2dc:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 2de:	4aa9                	li	s5,10
 2e0:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 2e2:	89a6                	mv	s3,s1
 2e4:	2485                	addiw	s1,s1,1
 2e6:	0344d863          	bge	s1,s4,316 <gets+0x56>
    cc = read(0, &c, 1);
 2ea:	4605                	li	a2,1
 2ec:	faf40593          	addi	a1,s0,-81
 2f0:	4501                	li	a0,0
 2f2:	00000097          	auipc	ra,0x0
 2f6:	1b6080e7          	jalr	438(ra) # 4a8 <read>
    if(cc < 1)
 2fa:	00a05e63          	blez	a0,316 <gets+0x56>
    buf[i++] = c;
 2fe:	faf44783          	lbu	a5,-81(s0)
 302:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 306:	01578763          	beq	a5,s5,314 <gets+0x54>
 30a:	0905                	addi	s2,s2,1
 30c:	fd679be3          	bne	a5,s6,2e2 <gets+0x22>
  for(i=0; i+1 < max; ){
 310:	89a6                	mv	s3,s1
 312:	a011                	j	316 <gets+0x56>
 314:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 316:	99de                	add	s3,s3,s7
 318:	00098023          	sb	zero,0(s3)
  return buf;
}
 31c:	855e                	mv	a0,s7
 31e:	60e6                	ld	ra,88(sp)
 320:	6446                	ld	s0,80(sp)
 322:	64a6                	ld	s1,72(sp)
 324:	6906                	ld	s2,64(sp)
 326:	79e2                	ld	s3,56(sp)
 328:	7a42                	ld	s4,48(sp)
 32a:	7aa2                	ld	s5,40(sp)
 32c:	7b02                	ld	s6,32(sp)
 32e:	6be2                	ld	s7,24(sp)
 330:	6125                	addi	sp,sp,96
 332:	8082                	ret

0000000000000334 <stat>:

int
stat(const char *n, struct stat *st)
{
 334:	1101                	addi	sp,sp,-32
 336:	ec06                	sd	ra,24(sp)
 338:	e822                	sd	s0,16(sp)
 33a:	e426                	sd	s1,8(sp)
 33c:	e04a                	sd	s2,0(sp)
 33e:	1000                	addi	s0,sp,32
 340:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 342:	4581                	li	a1,0
 344:	00000097          	auipc	ra,0x0
 348:	18c080e7          	jalr	396(ra) # 4d0 <open>
  if(fd < 0)
 34c:	02054563          	bltz	a0,376 <stat+0x42>
 350:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 352:	85ca                	mv	a1,s2
 354:	00000097          	auipc	ra,0x0
 358:	194080e7          	jalr	404(ra) # 4e8 <fstat>
 35c:	892a                	mv	s2,a0
  close(fd);
 35e:	8526                	mv	a0,s1
 360:	00000097          	auipc	ra,0x0
 364:	158080e7          	jalr	344(ra) # 4b8 <close>
  return r;
}
 368:	854a                	mv	a0,s2
 36a:	60e2                	ld	ra,24(sp)
 36c:	6442                	ld	s0,16(sp)
 36e:	64a2                	ld	s1,8(sp)
 370:	6902                	ld	s2,0(sp)
 372:	6105                	addi	sp,sp,32
 374:	8082                	ret
    return -1;
 376:	597d                	li	s2,-1
 378:	bfc5                	j	368 <stat+0x34>

000000000000037a <atoi>:

int
atoi(const char *s)
{
 37a:	1141                	addi	sp,sp,-16
 37c:	e422                	sd	s0,8(sp)
 37e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 380:	00054603          	lbu	a2,0(a0)
 384:	fd06079b          	addiw	a5,a2,-48
 388:	0ff7f793          	andi	a5,a5,255
 38c:	4725                	li	a4,9
 38e:	02f76963          	bltu	a4,a5,3c0 <atoi+0x46>
 392:	86aa                	mv	a3,a0
  n = 0;
 394:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 396:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 398:	0685                	addi	a3,a3,1
 39a:	0025179b          	slliw	a5,a0,0x2
 39e:	9fa9                	addw	a5,a5,a0
 3a0:	0017979b          	slliw	a5,a5,0x1
 3a4:	9fb1                	addw	a5,a5,a2
 3a6:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 3aa:	0006c603          	lbu	a2,0(a3)
 3ae:	fd06071b          	addiw	a4,a2,-48
 3b2:	0ff77713          	andi	a4,a4,255
 3b6:	fee5f1e3          	bgeu	a1,a4,398 <atoi+0x1e>
  return n;
}
 3ba:	6422                	ld	s0,8(sp)
 3bc:	0141                	addi	sp,sp,16
 3be:	8082                	ret
  n = 0;
 3c0:	4501                	li	a0,0
 3c2:	bfe5                	j	3ba <atoi+0x40>

00000000000003c4 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3c4:	1141                	addi	sp,sp,-16
 3c6:	e422                	sd	s0,8(sp)
 3c8:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 3ca:	02b57663          	bgeu	a0,a1,3f6 <memmove+0x32>
    while(n-- > 0)
 3ce:	02c05163          	blez	a2,3f0 <memmove+0x2c>
 3d2:	fff6079b          	addiw	a5,a2,-1
 3d6:	1782                	slli	a5,a5,0x20
 3d8:	9381                	srli	a5,a5,0x20
 3da:	0785                	addi	a5,a5,1
 3dc:	97aa                	add	a5,a5,a0
  dst = vdst;
 3de:	872a                	mv	a4,a0
      *dst++ = *src++;
 3e0:	0585                	addi	a1,a1,1
 3e2:	0705                	addi	a4,a4,1
 3e4:	fff5c683          	lbu	a3,-1(a1)
 3e8:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 3ec:	fee79ae3          	bne	a5,a4,3e0 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 3f0:	6422                	ld	s0,8(sp)
 3f2:	0141                	addi	sp,sp,16
 3f4:	8082                	ret
    dst += n;
 3f6:	00c50733          	add	a4,a0,a2
    src += n;
 3fa:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 3fc:	fec05ae3          	blez	a2,3f0 <memmove+0x2c>
 400:	fff6079b          	addiw	a5,a2,-1
 404:	1782                	slli	a5,a5,0x20
 406:	9381                	srli	a5,a5,0x20
 408:	fff7c793          	not	a5,a5
 40c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 40e:	15fd                	addi	a1,a1,-1
 410:	177d                	addi	a4,a4,-1
 412:	0005c683          	lbu	a3,0(a1)
 416:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 41a:	fee79ae3          	bne	a5,a4,40e <memmove+0x4a>
 41e:	bfc9                	j	3f0 <memmove+0x2c>

0000000000000420 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 420:	1141                	addi	sp,sp,-16
 422:	e422                	sd	s0,8(sp)
 424:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 426:	ca05                	beqz	a2,456 <memcmp+0x36>
 428:	fff6069b          	addiw	a3,a2,-1
 42c:	1682                	slli	a3,a3,0x20
 42e:	9281                	srli	a3,a3,0x20
 430:	0685                	addi	a3,a3,1
 432:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 434:	00054783          	lbu	a5,0(a0)
 438:	0005c703          	lbu	a4,0(a1)
 43c:	00e79863          	bne	a5,a4,44c <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 440:	0505                	addi	a0,a0,1
    p2++;
 442:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 444:	fed518e3          	bne	a0,a3,434 <memcmp+0x14>
  }
  return 0;
 448:	4501                	li	a0,0
 44a:	a019                	j	450 <memcmp+0x30>
      return *p1 - *p2;
 44c:	40e7853b          	subw	a0,a5,a4
}
 450:	6422                	ld	s0,8(sp)
 452:	0141                	addi	sp,sp,16
 454:	8082                	ret
  return 0;
 456:	4501                	li	a0,0
 458:	bfe5                	j	450 <memcmp+0x30>

000000000000045a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 45a:	1141                	addi	sp,sp,-16
 45c:	e406                	sd	ra,8(sp)
 45e:	e022                	sd	s0,0(sp)
 460:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 462:	00000097          	auipc	ra,0x0
 466:	f62080e7          	jalr	-158(ra) # 3c4 <memmove>
}
 46a:	60a2                	ld	ra,8(sp)
 46c:	6402                	ld	s0,0(sp)
 46e:	0141                	addi	sp,sp,16
 470:	8082                	ret

0000000000000472 <ugetpid>:

#ifdef LAB_PGTBL
int
ugetpid(void)
{
 472:	1141                	addi	sp,sp,-16
 474:	e422                	sd	s0,8(sp)
 476:	0800                	addi	s0,sp,16
  struct usyscall *u = (struct usyscall *)USYSCALL;
  return u->pid;
 478:	040007b7          	lui	a5,0x4000
}
 47c:	17f5                	addi	a5,a5,-3
 47e:	07b2                	slli	a5,a5,0xc
 480:	4388                	lw	a0,0(a5)
 482:	6422                	ld	s0,8(sp)
 484:	0141                	addi	sp,sp,16
 486:	8082                	ret

0000000000000488 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 488:	4885                	li	a7,1
 ecall
 48a:	00000073          	ecall
 ret
 48e:	8082                	ret

0000000000000490 <exit>:
.global exit
exit:
 li a7, SYS_exit
 490:	4889                	li	a7,2
 ecall
 492:	00000073          	ecall
 ret
 496:	8082                	ret

0000000000000498 <wait>:
.global wait
wait:
 li a7, SYS_wait
 498:	488d                	li	a7,3
 ecall
 49a:	00000073          	ecall
 ret
 49e:	8082                	ret

00000000000004a0 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 4a0:	4891                	li	a7,4
 ecall
 4a2:	00000073          	ecall
 ret
 4a6:	8082                	ret

00000000000004a8 <read>:
.global read
read:
 li a7, SYS_read
 4a8:	4895                	li	a7,5
 ecall
 4aa:	00000073          	ecall
 ret
 4ae:	8082                	ret

00000000000004b0 <write>:
.global write
write:
 li a7, SYS_write
 4b0:	48c1                	li	a7,16
 ecall
 4b2:	00000073          	ecall
 ret
 4b6:	8082                	ret

00000000000004b8 <close>:
.global close
close:
 li a7, SYS_close
 4b8:	48d5                	li	a7,21
 ecall
 4ba:	00000073          	ecall
 ret
 4be:	8082                	ret

00000000000004c0 <kill>:
.global kill
kill:
 li a7, SYS_kill
 4c0:	4899                	li	a7,6
 ecall
 4c2:	00000073          	ecall
 ret
 4c6:	8082                	ret

00000000000004c8 <exec>:
.global exec
exec:
 li a7, SYS_exec
 4c8:	489d                	li	a7,7
 ecall
 4ca:	00000073          	ecall
 ret
 4ce:	8082                	ret

00000000000004d0 <open>:
.global open
open:
 li a7, SYS_open
 4d0:	48bd                	li	a7,15
 ecall
 4d2:	00000073          	ecall
 ret
 4d6:	8082                	ret

00000000000004d8 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 4d8:	48c5                	li	a7,17
 ecall
 4da:	00000073          	ecall
 ret
 4de:	8082                	ret

00000000000004e0 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 4e0:	48c9                	li	a7,18
 ecall
 4e2:	00000073          	ecall
 ret
 4e6:	8082                	ret

00000000000004e8 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 4e8:	48a1                	li	a7,8
 ecall
 4ea:	00000073          	ecall
 ret
 4ee:	8082                	ret

00000000000004f0 <link>:
.global link
link:
 li a7, SYS_link
 4f0:	48cd                	li	a7,19
 ecall
 4f2:	00000073          	ecall
 ret
 4f6:	8082                	ret

00000000000004f8 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4f8:	48d1                	li	a7,20
 ecall
 4fa:	00000073          	ecall
 ret
 4fe:	8082                	ret

0000000000000500 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 500:	48a5                	li	a7,9
 ecall
 502:	00000073          	ecall
 ret
 506:	8082                	ret

0000000000000508 <dup>:
.global dup
dup:
 li a7, SYS_dup
 508:	48a9                	li	a7,10
 ecall
 50a:	00000073          	ecall
 ret
 50e:	8082                	ret

0000000000000510 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 510:	48ad                	li	a7,11
 ecall
 512:	00000073          	ecall
 ret
 516:	8082                	ret

0000000000000518 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 518:	48b1                	li	a7,12
 ecall
 51a:	00000073          	ecall
 ret
 51e:	8082                	ret

0000000000000520 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 520:	48b5                	li	a7,13
 ecall
 522:	00000073          	ecall
 ret
 526:	8082                	ret

0000000000000528 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 528:	48b9                	li	a7,14
 ecall
 52a:	00000073          	ecall
 ret
 52e:	8082                	ret

0000000000000530 <connect>:
.global connect
connect:
 li a7, SYS_connect
 530:	48f5                	li	a7,29
 ecall
 532:	00000073          	ecall
 ret
 536:	8082                	ret

0000000000000538 <pgaccess>:
.global pgaccess
pgaccess:
 li a7, SYS_pgaccess
 538:	48f9                	li	a7,30
 ecall
 53a:	00000073          	ecall
 ret
 53e:	8082                	ret

0000000000000540 <vmprint>:
.global vmprint
vmprint:
 li a7, SYS_vmprint
 540:	48fd                	li	a7,31
 ecall
 542:	00000073          	ecall
 ret
 546:	8082                	ret

0000000000000548 <madvise>:
.global madvise
madvise:
 li a7, SYS_madvise
 548:	02000893          	li	a7,32
 ecall
 54c:	00000073          	ecall
 ret
 550:	8082                	ret

0000000000000552 <pgprint>:
.global pgprint
pgprint:
 li a7, SYS_pgprint
 552:	02100893          	li	a7,33
 ecall
 556:	00000073          	ecall
 ret
 55a:	8082                	ret

000000000000055c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 55c:	1101                	addi	sp,sp,-32
 55e:	ec06                	sd	ra,24(sp)
 560:	e822                	sd	s0,16(sp)
 562:	1000                	addi	s0,sp,32
 564:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 568:	4605                	li	a2,1
 56a:	fef40593          	addi	a1,s0,-17
 56e:	00000097          	auipc	ra,0x0
 572:	f42080e7          	jalr	-190(ra) # 4b0 <write>
}
 576:	60e2                	ld	ra,24(sp)
 578:	6442                	ld	s0,16(sp)
 57a:	6105                	addi	sp,sp,32
 57c:	8082                	ret

000000000000057e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 57e:	7139                	addi	sp,sp,-64
 580:	fc06                	sd	ra,56(sp)
 582:	f822                	sd	s0,48(sp)
 584:	f426                	sd	s1,40(sp)
 586:	f04a                	sd	s2,32(sp)
 588:	ec4e                	sd	s3,24(sp)
 58a:	0080                	addi	s0,sp,64
 58c:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 58e:	c299                	beqz	a3,594 <printint+0x16>
 590:	0805c863          	bltz	a1,620 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 594:	2581                	sext.w	a1,a1
  neg = 0;
 596:	4881                	li	a7,0
 598:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 59c:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 59e:	2601                	sext.w	a2,a2
 5a0:	00000517          	auipc	a0,0x0
 5a4:	55050513          	addi	a0,a0,1360 # af0 <digits>
 5a8:	883a                	mv	a6,a4
 5aa:	2705                	addiw	a4,a4,1
 5ac:	02c5f7bb          	remuw	a5,a1,a2
 5b0:	1782                	slli	a5,a5,0x20
 5b2:	9381                	srli	a5,a5,0x20
 5b4:	97aa                	add	a5,a5,a0
 5b6:	0007c783          	lbu	a5,0(a5) # 4000000 <__global_pointer$+0x3ffecff>
 5ba:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 5be:	0005879b          	sext.w	a5,a1
 5c2:	02c5d5bb          	divuw	a1,a1,a2
 5c6:	0685                	addi	a3,a3,1
 5c8:	fec7f0e3          	bgeu	a5,a2,5a8 <printint+0x2a>
  if(neg)
 5cc:	00088b63          	beqz	a7,5e2 <printint+0x64>
    buf[i++] = '-';
 5d0:	fd040793          	addi	a5,s0,-48
 5d4:	973e                	add	a4,a4,a5
 5d6:	02d00793          	li	a5,45
 5da:	fef70823          	sb	a5,-16(a4)
 5de:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 5e2:	02e05863          	blez	a4,612 <printint+0x94>
 5e6:	fc040793          	addi	a5,s0,-64
 5ea:	00e78933          	add	s2,a5,a4
 5ee:	fff78993          	addi	s3,a5,-1
 5f2:	99ba                	add	s3,s3,a4
 5f4:	377d                	addiw	a4,a4,-1
 5f6:	1702                	slli	a4,a4,0x20
 5f8:	9301                	srli	a4,a4,0x20
 5fa:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 5fe:	fff94583          	lbu	a1,-1(s2)
 602:	8526                	mv	a0,s1
 604:	00000097          	auipc	ra,0x0
 608:	f58080e7          	jalr	-168(ra) # 55c <putc>
  while(--i >= 0)
 60c:	197d                	addi	s2,s2,-1
 60e:	ff3918e3          	bne	s2,s3,5fe <printint+0x80>
}
 612:	70e2                	ld	ra,56(sp)
 614:	7442                	ld	s0,48(sp)
 616:	74a2                	ld	s1,40(sp)
 618:	7902                	ld	s2,32(sp)
 61a:	69e2                	ld	s3,24(sp)
 61c:	6121                	addi	sp,sp,64
 61e:	8082                	ret
    x = -xx;
 620:	40b005bb          	negw	a1,a1
    neg = 1;
 624:	4885                	li	a7,1
    x = -xx;
 626:	bf8d                	j	598 <printint+0x1a>

0000000000000628 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 628:	7119                	addi	sp,sp,-128
 62a:	fc86                	sd	ra,120(sp)
 62c:	f8a2                	sd	s0,112(sp)
 62e:	f4a6                	sd	s1,104(sp)
 630:	f0ca                	sd	s2,96(sp)
 632:	ecce                	sd	s3,88(sp)
 634:	e8d2                	sd	s4,80(sp)
 636:	e4d6                	sd	s5,72(sp)
 638:	e0da                	sd	s6,64(sp)
 63a:	fc5e                	sd	s7,56(sp)
 63c:	f862                	sd	s8,48(sp)
 63e:	f466                	sd	s9,40(sp)
 640:	f06a                	sd	s10,32(sp)
 642:	ec6e                	sd	s11,24(sp)
 644:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 646:	0005c903          	lbu	s2,0(a1)
 64a:	18090f63          	beqz	s2,7e8 <vprintf+0x1c0>
 64e:	8aaa                	mv	s5,a0
 650:	8b32                	mv	s6,a2
 652:	00158493          	addi	s1,a1,1
  state = 0;
 656:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 658:	02500a13          	li	s4,37
      if(c == 'd'){
 65c:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 660:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 664:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 668:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 66c:	00000b97          	auipc	s7,0x0
 670:	484b8b93          	addi	s7,s7,1156 # af0 <digits>
 674:	a839                	j	692 <vprintf+0x6a>
        putc(fd, c);
 676:	85ca                	mv	a1,s2
 678:	8556                	mv	a0,s5
 67a:	00000097          	auipc	ra,0x0
 67e:	ee2080e7          	jalr	-286(ra) # 55c <putc>
 682:	a019                	j	688 <vprintf+0x60>
    } else if(state == '%'){
 684:	01498f63          	beq	s3,s4,6a2 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 688:	0485                	addi	s1,s1,1
 68a:	fff4c903          	lbu	s2,-1(s1)
 68e:	14090d63          	beqz	s2,7e8 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 692:	0009079b          	sext.w	a5,s2
    if(state == 0){
 696:	fe0997e3          	bnez	s3,684 <vprintf+0x5c>
      if(c == '%'){
 69a:	fd479ee3          	bne	a5,s4,676 <vprintf+0x4e>
        state = '%';
 69e:	89be                	mv	s3,a5
 6a0:	b7e5                	j	688 <vprintf+0x60>
      if(c == 'd'){
 6a2:	05878063          	beq	a5,s8,6e2 <vprintf+0xba>
      } else if(c == 'l') {
 6a6:	05978c63          	beq	a5,s9,6fe <vprintf+0xd6>
      } else if(c == 'x') {
 6aa:	07a78863          	beq	a5,s10,71a <vprintf+0xf2>
      } else if(c == 'p') {
 6ae:	09b78463          	beq	a5,s11,736 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 6b2:	07300713          	li	a4,115
 6b6:	0ce78663          	beq	a5,a4,782 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6ba:	06300713          	li	a4,99
 6be:	0ee78e63          	beq	a5,a4,7ba <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 6c2:	11478863          	beq	a5,s4,7d2 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6c6:	85d2                	mv	a1,s4
 6c8:	8556                	mv	a0,s5
 6ca:	00000097          	auipc	ra,0x0
 6ce:	e92080e7          	jalr	-366(ra) # 55c <putc>
        putc(fd, c);
 6d2:	85ca                	mv	a1,s2
 6d4:	8556                	mv	a0,s5
 6d6:	00000097          	auipc	ra,0x0
 6da:	e86080e7          	jalr	-378(ra) # 55c <putc>
      }
      state = 0;
 6de:	4981                	li	s3,0
 6e0:	b765                	j	688 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 6e2:	008b0913          	addi	s2,s6,8
 6e6:	4685                	li	a3,1
 6e8:	4629                	li	a2,10
 6ea:	000b2583          	lw	a1,0(s6)
 6ee:	8556                	mv	a0,s5
 6f0:	00000097          	auipc	ra,0x0
 6f4:	e8e080e7          	jalr	-370(ra) # 57e <printint>
 6f8:	8b4a                	mv	s6,s2
      state = 0;
 6fa:	4981                	li	s3,0
 6fc:	b771                	j	688 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6fe:	008b0913          	addi	s2,s6,8
 702:	4681                	li	a3,0
 704:	4629                	li	a2,10
 706:	000b2583          	lw	a1,0(s6)
 70a:	8556                	mv	a0,s5
 70c:	00000097          	auipc	ra,0x0
 710:	e72080e7          	jalr	-398(ra) # 57e <printint>
 714:	8b4a                	mv	s6,s2
      state = 0;
 716:	4981                	li	s3,0
 718:	bf85                	j	688 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 71a:	008b0913          	addi	s2,s6,8
 71e:	4681                	li	a3,0
 720:	4641                	li	a2,16
 722:	000b2583          	lw	a1,0(s6)
 726:	8556                	mv	a0,s5
 728:	00000097          	auipc	ra,0x0
 72c:	e56080e7          	jalr	-426(ra) # 57e <printint>
 730:	8b4a                	mv	s6,s2
      state = 0;
 732:	4981                	li	s3,0
 734:	bf91                	j	688 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 736:	008b0793          	addi	a5,s6,8
 73a:	f8f43423          	sd	a5,-120(s0)
 73e:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 742:	03000593          	li	a1,48
 746:	8556                	mv	a0,s5
 748:	00000097          	auipc	ra,0x0
 74c:	e14080e7          	jalr	-492(ra) # 55c <putc>
  putc(fd, 'x');
 750:	85ea                	mv	a1,s10
 752:	8556                	mv	a0,s5
 754:	00000097          	auipc	ra,0x0
 758:	e08080e7          	jalr	-504(ra) # 55c <putc>
 75c:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 75e:	03c9d793          	srli	a5,s3,0x3c
 762:	97de                	add	a5,a5,s7
 764:	0007c583          	lbu	a1,0(a5)
 768:	8556                	mv	a0,s5
 76a:	00000097          	auipc	ra,0x0
 76e:	df2080e7          	jalr	-526(ra) # 55c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 772:	0992                	slli	s3,s3,0x4
 774:	397d                	addiw	s2,s2,-1
 776:	fe0914e3          	bnez	s2,75e <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 77a:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 77e:	4981                	li	s3,0
 780:	b721                	j	688 <vprintf+0x60>
        s = va_arg(ap, char*);
 782:	008b0993          	addi	s3,s6,8
 786:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 78a:	02090163          	beqz	s2,7ac <vprintf+0x184>
        while(*s != 0){
 78e:	00094583          	lbu	a1,0(s2)
 792:	c9a1                	beqz	a1,7e2 <vprintf+0x1ba>
          putc(fd, *s);
 794:	8556                	mv	a0,s5
 796:	00000097          	auipc	ra,0x0
 79a:	dc6080e7          	jalr	-570(ra) # 55c <putc>
          s++;
 79e:	0905                	addi	s2,s2,1
        while(*s != 0){
 7a0:	00094583          	lbu	a1,0(s2)
 7a4:	f9e5                	bnez	a1,794 <vprintf+0x16c>
        s = va_arg(ap, char*);
 7a6:	8b4e                	mv	s6,s3
      state = 0;
 7a8:	4981                	li	s3,0
 7aa:	bdf9                	j	688 <vprintf+0x60>
          s = "(null)";
 7ac:	00000917          	auipc	s2,0x0
 7b0:	33c90913          	addi	s2,s2,828 # ae8 <malloc+0x1f6>
        while(*s != 0){
 7b4:	02800593          	li	a1,40
 7b8:	bff1                	j	794 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 7ba:	008b0913          	addi	s2,s6,8
 7be:	000b4583          	lbu	a1,0(s6)
 7c2:	8556                	mv	a0,s5
 7c4:	00000097          	auipc	ra,0x0
 7c8:	d98080e7          	jalr	-616(ra) # 55c <putc>
 7cc:	8b4a                	mv	s6,s2
      state = 0;
 7ce:	4981                	li	s3,0
 7d0:	bd65                	j	688 <vprintf+0x60>
        putc(fd, c);
 7d2:	85d2                	mv	a1,s4
 7d4:	8556                	mv	a0,s5
 7d6:	00000097          	auipc	ra,0x0
 7da:	d86080e7          	jalr	-634(ra) # 55c <putc>
      state = 0;
 7de:	4981                	li	s3,0
 7e0:	b565                	j	688 <vprintf+0x60>
        s = va_arg(ap, char*);
 7e2:	8b4e                	mv	s6,s3
      state = 0;
 7e4:	4981                	li	s3,0
 7e6:	b54d                	j	688 <vprintf+0x60>
    }
  }
}
 7e8:	70e6                	ld	ra,120(sp)
 7ea:	7446                	ld	s0,112(sp)
 7ec:	74a6                	ld	s1,104(sp)
 7ee:	7906                	ld	s2,96(sp)
 7f0:	69e6                	ld	s3,88(sp)
 7f2:	6a46                	ld	s4,80(sp)
 7f4:	6aa6                	ld	s5,72(sp)
 7f6:	6b06                	ld	s6,64(sp)
 7f8:	7be2                	ld	s7,56(sp)
 7fa:	7c42                	ld	s8,48(sp)
 7fc:	7ca2                	ld	s9,40(sp)
 7fe:	7d02                	ld	s10,32(sp)
 800:	6de2                	ld	s11,24(sp)
 802:	6109                	addi	sp,sp,128
 804:	8082                	ret

0000000000000806 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 806:	715d                	addi	sp,sp,-80
 808:	ec06                	sd	ra,24(sp)
 80a:	e822                	sd	s0,16(sp)
 80c:	1000                	addi	s0,sp,32
 80e:	e010                	sd	a2,0(s0)
 810:	e414                	sd	a3,8(s0)
 812:	e818                	sd	a4,16(s0)
 814:	ec1c                	sd	a5,24(s0)
 816:	03043023          	sd	a6,32(s0)
 81a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 81e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 822:	8622                	mv	a2,s0
 824:	00000097          	auipc	ra,0x0
 828:	e04080e7          	jalr	-508(ra) # 628 <vprintf>
}
 82c:	60e2                	ld	ra,24(sp)
 82e:	6442                	ld	s0,16(sp)
 830:	6161                	addi	sp,sp,80
 832:	8082                	ret

0000000000000834 <printf>:

void
printf(const char *fmt, ...)
{
 834:	711d                	addi	sp,sp,-96
 836:	ec06                	sd	ra,24(sp)
 838:	e822                	sd	s0,16(sp)
 83a:	1000                	addi	s0,sp,32
 83c:	e40c                	sd	a1,8(s0)
 83e:	e810                	sd	a2,16(s0)
 840:	ec14                	sd	a3,24(s0)
 842:	f018                	sd	a4,32(s0)
 844:	f41c                	sd	a5,40(s0)
 846:	03043823          	sd	a6,48(s0)
 84a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 84e:	00840613          	addi	a2,s0,8
 852:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 856:	85aa                	mv	a1,a0
 858:	4505                	li	a0,1
 85a:	00000097          	auipc	ra,0x0
 85e:	dce080e7          	jalr	-562(ra) # 628 <vprintf>
}
 862:	60e2                	ld	ra,24(sp)
 864:	6442                	ld	s0,16(sp)
 866:	6125                	addi	sp,sp,96
 868:	8082                	ret

000000000000086a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 86a:	1141                	addi	sp,sp,-16
 86c:	e422                	sd	s0,8(sp)
 86e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 870:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 874:	00000797          	auipc	a5,0x0
 878:	29c7b783          	ld	a5,668(a5) # b10 <freep>
 87c:	a805                	j	8ac <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 87e:	4618                	lw	a4,8(a2)
 880:	9db9                	addw	a1,a1,a4
 882:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 886:	6398                	ld	a4,0(a5)
 888:	6318                	ld	a4,0(a4)
 88a:	fee53823          	sd	a4,-16(a0)
 88e:	a091                	j	8d2 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 890:	ff852703          	lw	a4,-8(a0)
 894:	9e39                	addw	a2,a2,a4
 896:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 898:	ff053703          	ld	a4,-16(a0)
 89c:	e398                	sd	a4,0(a5)
 89e:	a099                	j	8e4 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8a0:	6398                	ld	a4,0(a5)
 8a2:	00e7e463          	bltu	a5,a4,8aa <free+0x40>
 8a6:	00e6ea63          	bltu	a3,a4,8ba <free+0x50>
{
 8aa:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8ac:	fed7fae3          	bgeu	a5,a3,8a0 <free+0x36>
 8b0:	6398                	ld	a4,0(a5)
 8b2:	00e6e463          	bltu	a3,a4,8ba <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8b6:	fee7eae3          	bltu	a5,a4,8aa <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 8ba:	ff852583          	lw	a1,-8(a0)
 8be:	6390                	ld	a2,0(a5)
 8c0:	02059713          	slli	a4,a1,0x20
 8c4:	9301                	srli	a4,a4,0x20
 8c6:	0712                	slli	a4,a4,0x4
 8c8:	9736                	add	a4,a4,a3
 8ca:	fae60ae3          	beq	a2,a4,87e <free+0x14>
    bp->s.ptr = p->s.ptr;
 8ce:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 8d2:	4790                	lw	a2,8(a5)
 8d4:	02061713          	slli	a4,a2,0x20
 8d8:	9301                	srli	a4,a4,0x20
 8da:	0712                	slli	a4,a4,0x4
 8dc:	973e                	add	a4,a4,a5
 8de:	fae689e3          	beq	a3,a4,890 <free+0x26>
  } else
    p->s.ptr = bp;
 8e2:	e394                	sd	a3,0(a5)
  freep = p;
 8e4:	00000717          	auipc	a4,0x0
 8e8:	22f73623          	sd	a5,556(a4) # b10 <freep>
}
 8ec:	6422                	ld	s0,8(sp)
 8ee:	0141                	addi	sp,sp,16
 8f0:	8082                	ret

00000000000008f2 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8f2:	7139                	addi	sp,sp,-64
 8f4:	fc06                	sd	ra,56(sp)
 8f6:	f822                	sd	s0,48(sp)
 8f8:	f426                	sd	s1,40(sp)
 8fa:	f04a                	sd	s2,32(sp)
 8fc:	ec4e                	sd	s3,24(sp)
 8fe:	e852                	sd	s4,16(sp)
 900:	e456                	sd	s5,8(sp)
 902:	e05a                	sd	s6,0(sp)
 904:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 906:	02051493          	slli	s1,a0,0x20
 90a:	9081                	srli	s1,s1,0x20
 90c:	04bd                	addi	s1,s1,15
 90e:	8091                	srli	s1,s1,0x4
 910:	0014899b          	addiw	s3,s1,1
 914:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 916:	00000797          	auipc	a5,0x0
 91a:	1fa7b783          	ld	a5,506(a5) # b10 <freep>
 91e:	c795                	beqz	a5,94a <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 920:	6388                	ld	a0,0(a5)
    if(p->s.size >= nunits){
 922:	4518                	lw	a4,8(a0)
 924:	02977f63          	bgeu	a4,s1,962 <malloc+0x70>
 928:	8a4e                	mv	s4,s3
 92a:	0009879b          	sext.w	a5,s3
 92e:	6705                	lui	a4,0x1
 930:	00e7f363          	bgeu	a5,a4,936 <malloc+0x44>
 934:	6a05                	lui	s4,0x1
 936:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 93a:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p);
    }
    if(p == freep)
 93e:	00000917          	auipc	s2,0x0
 942:	1d290913          	addi	s2,s2,466 # b10 <freep>
  if(p == (char*)-1)
 946:	5afd                	li	s5,-1
 948:	a0bd                	j	9b6 <malloc+0xc4>
    base.s.ptr = freep = prevp = &base;
 94a:	00000517          	auipc	a0,0x0
 94e:	1ce50513          	addi	a0,a0,462 # b18 <base>
 952:	00000797          	auipc	a5,0x0
 956:	1aa7bf23          	sd	a0,446(a5) # b10 <freep>
 95a:	e108                	sd	a0,0(a0)
    base.s.size = 0;
 95c:	00052423          	sw	zero,8(a0)
    if(p->s.size >= nunits){
 960:	b7e1                	j	928 <malloc+0x36>
      if(p->s.size == nunits)
 962:	02e48963          	beq	s1,a4,994 <malloc+0xa2>
        p->s.size -= nunits;
 966:	4137073b          	subw	a4,a4,s3
 96a:	c518                	sw	a4,8(a0)
        p += p->s.size;
 96c:	1702                	slli	a4,a4,0x20
 96e:	9301                	srli	a4,a4,0x20
 970:	0712                	slli	a4,a4,0x4
 972:	953a                	add	a0,a0,a4
        p->s.size = nunits;
 974:	01352423          	sw	s3,8(a0)
      freep = prevp;
 978:	00000717          	auipc	a4,0x0
 97c:	18f73c23          	sd	a5,408(a4) # b10 <freep>
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 980:	70e2                	ld	ra,56(sp)
 982:	7442                	ld	s0,48(sp)
 984:	74a2                	ld	s1,40(sp)
 986:	7902                	ld	s2,32(sp)
 988:	69e2                	ld	s3,24(sp)
 98a:	6a42                	ld	s4,16(sp)
 98c:	6aa2                	ld	s5,8(sp)
 98e:	6b02                	ld	s6,0(sp)
 990:	6121                	addi	sp,sp,64
 992:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 994:	6118                	ld	a4,0(a0)
 996:	e398                	sd	a4,0(a5)
 998:	b7c5                	j	978 <malloc+0x86>
  hp->s.size = nu;
 99a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 99e:	0541                	addi	a0,a0,16
 9a0:	00000097          	auipc	ra,0x0
 9a4:	eca080e7          	jalr	-310(ra) # 86a <free>
  return freep;
 9a8:	00093783          	ld	a5,0(s2)
      if((p = morecore(nunits)) == 0)
 9ac:	c39d                	beqz	a5,9d2 <malloc+0xe0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9ae:	6388                	ld	a0,0(a5)
    if(p->s.size >= nunits){
 9b0:	4518                	lw	a4,8(a0)
 9b2:	fa9778e3          	bgeu	a4,s1,962 <malloc+0x70>
    if(p == freep)
 9b6:	00093703          	ld	a4,0(s2)
 9ba:	87aa                	mv	a5,a0
 9bc:	fea719e3          	bne	a4,a0,9ae <malloc+0xbc>
  p = sbrk(nu * sizeof(Header));
 9c0:	8552                	mv	a0,s4
 9c2:	00000097          	auipc	ra,0x0
 9c6:	b56080e7          	jalr	-1194(ra) # 518 <sbrk>
  if(p == (char*)-1)
 9ca:	fd5518e3          	bne	a0,s5,99a <malloc+0xa8>
        return 0;
 9ce:	4501                	li	a0,0
 9d0:	bf45                	j	980 <malloc+0x8e>
 9d2:	853e                	mv	a0,a5
 9d4:	b775                	j	980 <malloc+0x8e>
