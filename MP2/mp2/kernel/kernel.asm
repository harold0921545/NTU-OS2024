
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	9c013103          	ld	sp,-1600(sp) # 800089c0 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	453050ef          	jal	ra,80005c68 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	slli	a5,a0,0x34
    8000002c:	ebb9                	bnez	a5,80000082 <kfree+0x66>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00026797          	auipc	a5,0x26
    80000034:	21078793          	addi	a5,a5,528 # 80026240 <end>
    80000038:	04f56563          	bltu	a0,a5,80000082 <kfree+0x66>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	04f57163          	bgeu	a0,a5,80000082 <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	00000097          	auipc	ra,0x0
    8000004c:	130080e7          	jalr	304(ra) # 80000178 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000050:	00009917          	auipc	s2,0x9
    80000054:	fe090913          	addi	s2,s2,-32 # 80009030 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	608080e7          	jalr	1544(ra) # 80006662 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	6a8080e7          	jalr	1704(ra) # 80006716 <release>
}
    80000076:	60e2                	ld	ra,24(sp)
    80000078:	6442                	ld	s0,16(sp)
    8000007a:	64a2                	ld	s1,8(sp)
    8000007c:	6902                	ld	s2,0(sp)
    8000007e:	6105                	addi	sp,sp,32
    80000080:	8082                	ret
    panic("kfree");
    80000082:	00008517          	auipc	a0,0x8
    80000086:	f8e50513          	addi	a0,a0,-114 # 80008010 <etext+0x10>
    8000008a:	00006097          	auipc	ra,0x6
    8000008e:	08e080e7          	jalr	142(ra) # 80006118 <panic>

0000000080000092 <freerange>:
{
    80000092:	7179                	addi	sp,sp,-48
    80000094:	f406                	sd	ra,40(sp)
    80000096:	f022                	sd	s0,32(sp)
    80000098:	ec26                	sd	s1,24(sp)
    8000009a:	e84a                	sd	s2,16(sp)
    8000009c:	e44e                	sd	s3,8(sp)
    8000009e:	e052                	sd	s4,0(sp)
    800000a0:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    800000a2:	6785                	lui	a5,0x1
    800000a4:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    800000a8:	94aa                	add	s1,s1,a0
    800000aa:	757d                	lui	a0,0xfffff
    800000ac:	8ce9                	and	s1,s1,a0
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000ae:	94be                	add	s1,s1,a5
    800000b0:	0095ee63          	bltu	a1,s1,800000cc <freerange+0x3a>
    800000b4:	892e                	mv	s2,a1
    kfree(p);
    800000b6:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000b8:	6985                	lui	s3,0x1
    kfree(p);
    800000ba:	01448533          	add	a0,s1,s4
    800000be:	00000097          	auipc	ra,0x0
    800000c2:	f5e080e7          	jalr	-162(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000c6:	94ce                	add	s1,s1,s3
    800000c8:	fe9979e3          	bgeu	s2,s1,800000ba <freerange+0x28>
}
    800000cc:	70a2                	ld	ra,40(sp)
    800000ce:	7402                	ld	s0,32(sp)
    800000d0:	64e2                	ld	s1,24(sp)
    800000d2:	6942                	ld	s2,16(sp)
    800000d4:	69a2                	ld	s3,8(sp)
    800000d6:	6a02                	ld	s4,0(sp)
    800000d8:	6145                	addi	sp,sp,48
    800000da:	8082                	ret

00000000800000dc <kinit>:
{
    800000dc:	1141                	addi	sp,sp,-16
    800000de:	e406                	sd	ra,8(sp)
    800000e0:	e022                	sd	s0,0(sp)
    800000e2:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000e4:	00008597          	auipc	a1,0x8
    800000e8:	f3458593          	addi	a1,a1,-204 # 80008018 <etext+0x18>
    800000ec:	00009517          	auipc	a0,0x9
    800000f0:	f4450513          	addi	a0,a0,-188 # 80009030 <kmem>
    800000f4:	00006097          	auipc	ra,0x6
    800000f8:	4de080e7          	jalr	1246(ra) # 800065d2 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fc:	45c5                	li	a1,17
    800000fe:	05ee                	slli	a1,a1,0x1b
    80000100:	00026517          	auipc	a0,0x26
    80000104:	14050513          	addi	a0,a0,320 # 80026240 <end>
    80000108:	00000097          	auipc	ra,0x0
    8000010c:	f8a080e7          	jalr	-118(ra) # 80000092 <freerange>
}
    80000110:	60a2                	ld	ra,8(sp)
    80000112:	6402                	ld	s0,0(sp)
    80000114:	0141                	addi	sp,sp,16
    80000116:	8082                	ret

0000000080000118 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000118:	1101                	addi	sp,sp,-32
    8000011a:	ec06                	sd	ra,24(sp)
    8000011c:	e822                	sd	s0,16(sp)
    8000011e:	e426                	sd	s1,8(sp)
    80000120:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000122:	00009497          	auipc	s1,0x9
    80000126:	f0e48493          	addi	s1,s1,-242 # 80009030 <kmem>
    8000012a:	8526                	mv	a0,s1
    8000012c:	00006097          	auipc	ra,0x6
    80000130:	536080e7          	jalr	1334(ra) # 80006662 <acquire>
  r = kmem.freelist;
    80000134:	6c84                	ld	s1,24(s1)
  if(r)
    80000136:	c885                	beqz	s1,80000166 <kalloc+0x4e>
    kmem.freelist = r->next;
    80000138:	609c                	ld	a5,0(s1)
    8000013a:	00009517          	auipc	a0,0x9
    8000013e:	ef650513          	addi	a0,a0,-266 # 80009030 <kmem>
    80000142:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000144:	00006097          	auipc	ra,0x6
    80000148:	5d2080e7          	jalr	1490(ra) # 80006716 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000014c:	6605                	lui	a2,0x1
    8000014e:	4595                	li	a1,5
    80000150:	8526                	mv	a0,s1
    80000152:	00000097          	auipc	ra,0x0
    80000156:	026080e7          	jalr	38(ra) # 80000178 <memset>
  return (void*)r;
}
    8000015a:	8526                	mv	a0,s1
    8000015c:	60e2                	ld	ra,24(sp)
    8000015e:	6442                	ld	s0,16(sp)
    80000160:	64a2                	ld	s1,8(sp)
    80000162:	6105                	addi	sp,sp,32
    80000164:	8082                	ret
  release(&kmem.lock);
    80000166:	00009517          	auipc	a0,0x9
    8000016a:	eca50513          	addi	a0,a0,-310 # 80009030 <kmem>
    8000016e:	00006097          	auipc	ra,0x6
    80000172:	5a8080e7          	jalr	1448(ra) # 80006716 <release>
  if(r)
    80000176:	b7d5                	j	8000015a <kalloc+0x42>

0000000080000178 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000178:	1141                	addi	sp,sp,-16
    8000017a:	e422                	sd	s0,8(sp)
    8000017c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    8000017e:	ce09                	beqz	a2,80000198 <memset+0x20>
    80000180:	87aa                	mv	a5,a0
    80000182:	fff6071b          	addiw	a4,a2,-1
    80000186:	1702                	slli	a4,a4,0x20
    80000188:	9301                	srli	a4,a4,0x20
    8000018a:	0705                	addi	a4,a4,1
    8000018c:	972a                	add	a4,a4,a0
    cdst[i] = c;
    8000018e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000192:	0785                	addi	a5,a5,1
    80000194:	fee79de3          	bne	a5,a4,8000018e <memset+0x16>
  }
  return dst;
}
    80000198:	6422                	ld	s0,8(sp)
    8000019a:	0141                	addi	sp,sp,16
    8000019c:	8082                	ret

000000008000019e <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    8000019e:	1141                	addi	sp,sp,-16
    800001a0:	e422                	sd	s0,8(sp)
    800001a2:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001a4:	ca05                	beqz	a2,800001d4 <memcmp+0x36>
    800001a6:	fff6069b          	addiw	a3,a2,-1
    800001aa:	1682                	slli	a3,a3,0x20
    800001ac:	9281                	srli	a3,a3,0x20
    800001ae:	0685                	addi	a3,a3,1
    800001b0:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001b2:	00054783          	lbu	a5,0(a0)
    800001b6:	0005c703          	lbu	a4,0(a1)
    800001ba:	00e79863          	bne	a5,a4,800001ca <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800001be:	0505                	addi	a0,a0,1
    800001c0:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800001c2:	fed518e3          	bne	a0,a3,800001b2 <memcmp+0x14>
  }

  return 0;
    800001c6:	4501                	li	a0,0
    800001c8:	a019                	j	800001ce <memcmp+0x30>
      return *s1 - *s2;
    800001ca:	40e7853b          	subw	a0,a5,a4
}
    800001ce:	6422                	ld	s0,8(sp)
    800001d0:	0141                	addi	sp,sp,16
    800001d2:	8082                	ret
  return 0;
    800001d4:	4501                	li	a0,0
    800001d6:	bfe5                	j	800001ce <memcmp+0x30>

00000000800001d8 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001d8:	1141                	addi	sp,sp,-16
    800001da:	e422                	sd	s0,8(sp)
    800001dc:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001de:	ca0d                	beqz	a2,80000210 <memmove+0x38>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001e0:	00a5f963          	bgeu	a1,a0,800001f2 <memmove+0x1a>
    800001e4:	02061693          	slli	a3,a2,0x20
    800001e8:	9281                	srli	a3,a3,0x20
    800001ea:	00d58733          	add	a4,a1,a3
    800001ee:	02e56463          	bltu	a0,a4,80000216 <memmove+0x3e>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001f2:	fff6079b          	addiw	a5,a2,-1
    800001f6:	1782                	slli	a5,a5,0x20
    800001f8:	9381                	srli	a5,a5,0x20
    800001fa:	0785                	addi	a5,a5,1
    800001fc:	97ae                	add	a5,a5,a1
    800001fe:	872a                	mv	a4,a0
      *d++ = *s++;
    80000200:	0585                	addi	a1,a1,1
    80000202:	0705                	addi	a4,a4,1
    80000204:	fff5c683          	lbu	a3,-1(a1)
    80000208:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    8000020c:	fef59ae3          	bne	a1,a5,80000200 <memmove+0x28>

  return dst;
}
    80000210:	6422                	ld	s0,8(sp)
    80000212:	0141                	addi	sp,sp,16
    80000214:	8082                	ret
    d += n;
    80000216:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000218:	fff6079b          	addiw	a5,a2,-1
    8000021c:	1782                	slli	a5,a5,0x20
    8000021e:	9381                	srli	a5,a5,0x20
    80000220:	fff7c793          	not	a5,a5
    80000224:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000226:	177d                	addi	a4,a4,-1
    80000228:	16fd                	addi	a3,a3,-1
    8000022a:	00074603          	lbu	a2,0(a4)
    8000022e:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000232:	fef71ae3          	bne	a4,a5,80000226 <memmove+0x4e>
    80000236:	bfe9                	j	80000210 <memmove+0x38>

0000000080000238 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000238:	1141                	addi	sp,sp,-16
    8000023a:	e406                	sd	ra,8(sp)
    8000023c:	e022                	sd	s0,0(sp)
    8000023e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000240:	00000097          	auipc	ra,0x0
    80000244:	f98080e7          	jalr	-104(ra) # 800001d8 <memmove>
}
    80000248:	60a2                	ld	ra,8(sp)
    8000024a:	6402                	ld	s0,0(sp)
    8000024c:	0141                	addi	sp,sp,16
    8000024e:	8082                	ret

0000000080000250 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000250:	1141                	addi	sp,sp,-16
    80000252:	e422                	sd	s0,8(sp)
    80000254:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000256:	ce11                	beqz	a2,80000272 <strncmp+0x22>
    80000258:	00054783          	lbu	a5,0(a0)
    8000025c:	cf89                	beqz	a5,80000276 <strncmp+0x26>
    8000025e:	0005c703          	lbu	a4,0(a1)
    80000262:	00f71a63          	bne	a4,a5,80000276 <strncmp+0x26>
    n--, p++, q++;
    80000266:	367d                	addiw	a2,a2,-1
    80000268:	0505                	addi	a0,a0,1
    8000026a:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    8000026c:	f675                	bnez	a2,80000258 <strncmp+0x8>
  if(n == 0)
    return 0;
    8000026e:	4501                	li	a0,0
    80000270:	a809                	j	80000282 <strncmp+0x32>
    80000272:	4501                	li	a0,0
    80000274:	a039                	j	80000282 <strncmp+0x32>
  if(n == 0)
    80000276:	ca09                	beqz	a2,80000288 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000278:	00054503          	lbu	a0,0(a0)
    8000027c:	0005c783          	lbu	a5,0(a1)
    80000280:	9d1d                	subw	a0,a0,a5
}
    80000282:	6422                	ld	s0,8(sp)
    80000284:	0141                	addi	sp,sp,16
    80000286:	8082                	ret
    return 0;
    80000288:	4501                	li	a0,0
    8000028a:	bfe5                	j	80000282 <strncmp+0x32>

000000008000028c <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    8000028c:	1141                	addi	sp,sp,-16
    8000028e:	e422                	sd	s0,8(sp)
    80000290:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000292:	872a                	mv	a4,a0
    80000294:	8832                	mv	a6,a2
    80000296:	367d                	addiw	a2,a2,-1
    80000298:	01005963          	blez	a6,800002aa <strncpy+0x1e>
    8000029c:	0705                	addi	a4,a4,1
    8000029e:	0005c783          	lbu	a5,0(a1)
    800002a2:	fef70fa3          	sb	a5,-1(a4)
    800002a6:	0585                	addi	a1,a1,1
    800002a8:	f7f5                	bnez	a5,80000294 <strncpy+0x8>
    ;
  while(n-- > 0)
    800002aa:	00c05d63          	blez	a2,800002c4 <strncpy+0x38>
    800002ae:	86ba                	mv	a3,a4
    *s++ = 0;
    800002b0:	0685                	addi	a3,a3,1
    800002b2:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    800002b6:	fff6c793          	not	a5,a3
    800002ba:	9fb9                	addw	a5,a5,a4
    800002bc:	010787bb          	addw	a5,a5,a6
    800002c0:	fef048e3          	bgtz	a5,800002b0 <strncpy+0x24>
  return os;
}
    800002c4:	6422                	ld	s0,8(sp)
    800002c6:	0141                	addi	sp,sp,16
    800002c8:	8082                	ret

00000000800002ca <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800002ca:	1141                	addi	sp,sp,-16
    800002cc:	e422                	sd	s0,8(sp)
    800002ce:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800002d0:	02c05363          	blez	a2,800002f6 <safestrcpy+0x2c>
    800002d4:	fff6069b          	addiw	a3,a2,-1
    800002d8:	1682                	slli	a3,a3,0x20
    800002da:	9281                	srli	a3,a3,0x20
    800002dc:	96ae                	add	a3,a3,a1
    800002de:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002e0:	00d58963          	beq	a1,a3,800002f2 <safestrcpy+0x28>
    800002e4:	0585                	addi	a1,a1,1
    800002e6:	0785                	addi	a5,a5,1
    800002e8:	fff5c703          	lbu	a4,-1(a1)
    800002ec:	fee78fa3          	sb	a4,-1(a5)
    800002f0:	fb65                	bnez	a4,800002e0 <safestrcpy+0x16>
    ;
  *s = 0;
    800002f2:	00078023          	sb	zero,0(a5)
  return os;
}
    800002f6:	6422                	ld	s0,8(sp)
    800002f8:	0141                	addi	sp,sp,16
    800002fa:	8082                	ret

00000000800002fc <strlen>:

int
strlen(const char *s)
{
    800002fc:	1141                	addi	sp,sp,-16
    800002fe:	e422                	sd	s0,8(sp)
    80000300:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000302:	00054783          	lbu	a5,0(a0)
    80000306:	cf91                	beqz	a5,80000322 <strlen+0x26>
    80000308:	0505                	addi	a0,a0,1
    8000030a:	87aa                	mv	a5,a0
    8000030c:	4685                	li	a3,1
    8000030e:	9e89                	subw	a3,a3,a0
    80000310:	00f6853b          	addw	a0,a3,a5
    80000314:	0785                	addi	a5,a5,1
    80000316:	fff7c703          	lbu	a4,-1(a5)
    8000031a:	fb7d                	bnez	a4,80000310 <strlen+0x14>
    ;
  return n;
}
    8000031c:	6422                	ld	s0,8(sp)
    8000031e:	0141                	addi	sp,sp,16
    80000320:	8082                	ret
  for(n = 0; s[n]; n++)
    80000322:	4501                	li	a0,0
    80000324:	bfe5                	j	8000031c <strlen+0x20>

0000000080000326 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000326:	1141                	addi	sp,sp,-16
    80000328:	e406                	sd	ra,8(sp)
    8000032a:	e022                	sd	s0,0(sp)
    8000032c:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    8000032e:	00001097          	auipc	ra,0x1
    80000332:	d9a080e7          	jalr	-614(ra) # 800010c8 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000336:	00009717          	auipc	a4,0x9
    8000033a:	cca70713          	addi	a4,a4,-822 # 80009000 <started>
  if(cpuid() == 0){
    8000033e:	c139                	beqz	a0,80000384 <main+0x5e>
    while(started == 0)
    80000340:	431c                	lw	a5,0(a4)
    80000342:	2781                	sext.w	a5,a5
    80000344:	dff5                	beqz	a5,80000340 <main+0x1a>
      ;
    __sync_synchronize();
    80000346:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    8000034a:	00001097          	auipc	ra,0x1
    8000034e:	d7e080e7          	jalr	-642(ra) # 800010c8 <cpuid>
    80000352:	85aa                	mv	a1,a0
    80000354:	00008517          	auipc	a0,0x8
    80000358:	ce450513          	addi	a0,a0,-796 # 80008038 <etext+0x38>
    8000035c:	00006097          	auipc	ra,0x6
    80000360:	e06080e7          	jalr	-506(ra) # 80006162 <printf>
    kvminithart();    // turn on paging
    80000364:	00000097          	auipc	ra,0x0
    80000368:	0d8080e7          	jalr	216(ra) # 8000043c <kvminithart>
    trapinithart();   // install kernel trap vector
    8000036c:	00002097          	auipc	ra,0x2
    80000370:	9d4080e7          	jalr	-1580(ra) # 80001d40 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000374:	00005097          	auipc	ra,0x5
    80000378:	17c080e7          	jalr	380(ra) # 800054f0 <plicinithart>
  }

  scheduler();
    8000037c:	00001097          	auipc	ra,0x1
    80000380:	282080e7          	jalr	642(ra) # 800015fe <scheduler>
    consoleinit();
    80000384:	00006097          	auipc	ra,0x6
    80000388:	ca6080e7          	jalr	-858(ra) # 8000602a <consoleinit>
    printfinit();
    8000038c:	00006097          	auipc	ra,0x6
    80000390:	fbc080e7          	jalr	-68(ra) # 80006348 <printfinit>
    printf("\n");
    80000394:	00008517          	auipc	a0,0x8
    80000398:	cb450513          	addi	a0,a0,-844 # 80008048 <etext+0x48>
    8000039c:	00006097          	auipc	ra,0x6
    800003a0:	dc6080e7          	jalr	-570(ra) # 80006162 <printf>
    printf("xv6 kernel is booting\n");
    800003a4:	00008517          	auipc	a0,0x8
    800003a8:	c7c50513          	addi	a0,a0,-900 # 80008020 <etext+0x20>
    800003ac:	00006097          	auipc	ra,0x6
    800003b0:	db6080e7          	jalr	-586(ra) # 80006162 <printf>
    printf("\n");
    800003b4:	00008517          	auipc	a0,0x8
    800003b8:	c9450513          	addi	a0,a0,-876 # 80008048 <etext+0x48>
    800003bc:	00006097          	auipc	ra,0x6
    800003c0:	da6080e7          	jalr	-602(ra) # 80006162 <printf>
    kinit();         // physical page allocator
    800003c4:	00000097          	auipc	ra,0x0
    800003c8:	d18080e7          	jalr	-744(ra) # 800000dc <kinit>
    kvminit();       // create kernel page table
    800003cc:	00000097          	auipc	ra,0x0
    800003d0:	322080e7          	jalr	802(ra) # 800006ee <kvminit>
    kvminithart();   // turn on paging
    800003d4:	00000097          	auipc	ra,0x0
    800003d8:	068080e7          	jalr	104(ra) # 8000043c <kvminithart>
    procinit();      // process table
    800003dc:	00001097          	auipc	ra,0x1
    800003e0:	c3e080e7          	jalr	-962(ra) # 8000101a <procinit>
    trapinit();      // trap vectors
    800003e4:	00002097          	auipc	ra,0x2
    800003e8:	934080e7          	jalr	-1740(ra) # 80001d18 <trapinit>
    trapinithart();  // install kernel trap vector
    800003ec:	00002097          	auipc	ra,0x2
    800003f0:	954080e7          	jalr	-1708(ra) # 80001d40 <trapinithart>
    plicinit();      // set up interrupt controller
    800003f4:	00005097          	auipc	ra,0x5
    800003f8:	0e6080e7          	jalr	230(ra) # 800054da <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003fc:	00005097          	auipc	ra,0x5
    80000400:	0f4080e7          	jalr	244(ra) # 800054f0 <plicinithart>
    binit();         // buffer cache
    80000404:	00002097          	auipc	ra,0x2
    80000408:	168080e7          	jalr	360(ra) # 8000256c <binit>
    iinit();         // inode table
    8000040c:	00002097          	auipc	ra,0x2
    80000410:	7e8080e7          	jalr	2024(ra) # 80002bf4 <iinit>
    fileinit();      // file table
    80000414:	00004097          	auipc	ra,0x4
    80000418:	908080e7          	jalr	-1784(ra) # 80003d1c <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000041c:	00005097          	auipc	ra,0x5
    80000420:	1f6080e7          	jalr	502(ra) # 80005612 <virtio_disk_init>
    userinit();      // first user process
    80000424:	00001097          	auipc	ra,0x1
    80000428:	fa8080e7          	jalr	-88(ra) # 800013cc <userinit>
    __sync_synchronize();
    8000042c:	0ff0000f          	fence
    started = 1;
    80000430:	4785                	li	a5,1
    80000432:	00009717          	auipc	a4,0x9
    80000436:	bcf72723          	sw	a5,-1074(a4) # 80009000 <started>
    8000043a:	b789                	j	8000037c <main+0x56>

000000008000043c <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    8000043c:	1141                	addi	sp,sp,-16
    8000043e:	e422                	sd	s0,8(sp)
    80000440:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    80000442:	00009797          	auipc	a5,0x9
    80000446:	bc67b783          	ld	a5,-1082(a5) # 80009008 <kernel_pagetable>
    8000044a:	83b1                	srli	a5,a5,0xc
    8000044c:	577d                	li	a4,-1
    8000044e:	177e                	slli	a4,a4,0x3f
    80000450:	8fd9                	or	a5,a5,a4
// supervisor address translation and protection;
// holds the address of the page table.
static inline void
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r" (x));
    80000452:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000456:	12000073          	sfence.vma
  sfence_vma();
}
    8000045a:	6422                	ld	s0,8(sp)
    8000045c:	0141                	addi	sp,sp,16
    8000045e:	8082                	ret

0000000080000460 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000460:	7139                	addi	sp,sp,-64
    80000462:	fc06                	sd	ra,56(sp)
    80000464:	f822                	sd	s0,48(sp)
    80000466:	f426                	sd	s1,40(sp)
    80000468:	f04a                	sd	s2,32(sp)
    8000046a:	ec4e                	sd	s3,24(sp)
    8000046c:	e852                	sd	s4,16(sp)
    8000046e:	e456                	sd	s5,8(sp)
    80000470:	e05a                	sd	s6,0(sp)
    80000472:	0080                	addi	s0,sp,64
    80000474:	84aa                	mv	s1,a0
    80000476:	89ae                	mv	s3,a1
    80000478:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    8000047a:	57fd                	li	a5,-1
    8000047c:	83e9                	srli	a5,a5,0x1a
    8000047e:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000480:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000482:	04b7f263          	bgeu	a5,a1,800004c6 <walk+0x66>
    panic("walk");
    80000486:	00008517          	auipc	a0,0x8
    8000048a:	bca50513          	addi	a0,a0,-1078 # 80008050 <etext+0x50>
    8000048e:	00006097          	auipc	ra,0x6
    80000492:	c8a080e7          	jalr	-886(ra) # 80006118 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000496:	060a8663          	beqz	s5,80000502 <walk+0xa2>
    8000049a:	00000097          	auipc	ra,0x0
    8000049e:	c7e080e7          	jalr	-898(ra) # 80000118 <kalloc>
    800004a2:	84aa                	mv	s1,a0
    800004a4:	c529                	beqz	a0,800004ee <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800004a6:	6605                	lui	a2,0x1
    800004a8:	4581                	li	a1,0
    800004aa:	00000097          	auipc	ra,0x0
    800004ae:	cce080e7          	jalr	-818(ra) # 80000178 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004b2:	00c4d793          	srli	a5,s1,0xc
    800004b6:	07aa                	slli	a5,a5,0xa
    800004b8:	0017e793          	ori	a5,a5,1
    800004bc:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800004c0:	3a5d                	addiw	s4,s4,-9
    800004c2:	036a0063          	beq	s4,s6,800004e2 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800004c6:	0149d933          	srl	s2,s3,s4
    800004ca:	1ff97913          	andi	s2,s2,511
    800004ce:	090e                	slli	s2,s2,0x3
    800004d0:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800004d2:	00093483          	ld	s1,0(s2)
    800004d6:	0014f793          	andi	a5,s1,1
    800004da:	dfd5                	beqz	a5,80000496 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800004dc:	80a9                	srli	s1,s1,0xa
    800004de:	04b2                	slli	s1,s1,0xc
    800004e0:	b7c5                	j	800004c0 <walk+0x60>
    }
  }

  pte_t *pte = &pagetable[PX(0, va)];
    800004e2:	00c9d513          	srli	a0,s3,0xc
    800004e6:	1ff57513          	andi	a0,a0,511
    800004ea:	050e                	slli	a0,a0,0x3
    800004ec:	9526                	add	a0,a0,s1
// TODO
#elif defined(PG_REPLACEMENT_USE_FIFO)
// TODO
#endif
  return pte;
}
    800004ee:	70e2                	ld	ra,56(sp)
    800004f0:	7442                	ld	s0,48(sp)
    800004f2:	74a2                	ld	s1,40(sp)
    800004f4:	7902                	ld	s2,32(sp)
    800004f6:	69e2                	ld	s3,24(sp)
    800004f8:	6a42                	ld	s4,16(sp)
    800004fa:	6aa2                	ld	s5,8(sp)
    800004fc:	6b02                	ld	s6,0(sp)
    800004fe:	6121                	addi	sp,sp,64
    80000500:	8082                	ret
        return 0;
    80000502:	4501                	li	a0,0
    80000504:	b7ed                	j	800004ee <walk+0x8e>

0000000080000506 <walkaddr>:
uint64
walkaddr(pagetable_t pagetable, uint64 va) {
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000506:	57fd                	li	a5,-1
    80000508:	83e9                	srli	a5,a5,0x1a
    8000050a:	00b7f463          	bgeu	a5,a1,80000512 <walkaddr+0xc>
    return 0;
    8000050e:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000510:	8082                	ret
walkaddr(pagetable_t pagetable, uint64 va) {
    80000512:	1141                	addi	sp,sp,-16
    80000514:	e406                	sd	ra,8(sp)
    80000516:	e022                	sd	s0,0(sp)
    80000518:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    8000051a:	4601                	li	a2,0
    8000051c:	00000097          	auipc	ra,0x0
    80000520:	f44080e7          	jalr	-188(ra) # 80000460 <walk>
  if(pte == 0)
    80000524:	c105                	beqz	a0,80000544 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80000526:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000528:	0117f693          	andi	a3,a5,17
    8000052c:	4745                	li	a4,17
    return 0;
    8000052e:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000530:	00e68663          	beq	a3,a4,8000053c <walkaddr+0x36>
}
    80000534:	60a2                	ld	ra,8(sp)
    80000536:	6402                	ld	s0,0(sp)
    80000538:	0141                	addi	sp,sp,16
    8000053a:	8082                	ret
  pa = PTE2PA(*pte);
    8000053c:	00a7d513          	srli	a0,a5,0xa
    80000540:	0532                	slli	a0,a0,0xc
  return pa;
    80000542:	bfcd                	j	80000534 <walkaddr+0x2e>
    return 0;
    80000544:	4501                	li	a0,0
    80000546:	b7fd                	j	80000534 <walkaddr+0x2e>

0000000080000548 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000548:	715d                	addi	sp,sp,-80
    8000054a:	e486                	sd	ra,72(sp)
    8000054c:	e0a2                	sd	s0,64(sp)
    8000054e:	fc26                	sd	s1,56(sp)
    80000550:	f84a                	sd	s2,48(sp)
    80000552:	f44e                	sd	s3,40(sp)
    80000554:	f052                	sd	s4,32(sp)
    80000556:	ec56                	sd	s5,24(sp)
    80000558:	e85a                	sd	s6,16(sp)
    8000055a:	e45e                	sd	s7,8(sp)
    8000055c:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    8000055e:	c205                	beqz	a2,8000057e <mappages+0x36>
    80000560:	8aaa                	mv	s5,a0
    80000562:	8b3a                	mv	s6,a4
    panic("mappages: size");
  a = PGROUNDDOWN(va);
    80000564:	77fd                	lui	a5,0xfffff
    80000566:	00f5fa33          	and	s4,a1,a5
  last = PGROUNDDOWN(va + size - 1);
    8000056a:	15fd                	addi	a1,a1,-1
    8000056c:	00c589b3          	add	s3,a1,a2
    80000570:	00f9f9b3          	and	s3,s3,a5
  a = PGROUNDDOWN(va);
    80000574:	8952                	mv	s2,s4
    80000576:	41468a33          	sub	s4,a3,s4
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    8000057a:	6b85                	lui	s7,0x1
    8000057c:	a015                	j	800005a0 <mappages+0x58>
    panic("mappages: size");
    8000057e:	00008517          	auipc	a0,0x8
    80000582:	ada50513          	addi	a0,a0,-1318 # 80008058 <etext+0x58>
    80000586:	00006097          	auipc	ra,0x6
    8000058a:	b92080e7          	jalr	-1134(ra) # 80006118 <panic>
      panic("mappages: remap");
    8000058e:	00008517          	auipc	a0,0x8
    80000592:	ada50513          	addi	a0,a0,-1318 # 80008068 <etext+0x68>
    80000596:	00006097          	auipc	ra,0x6
    8000059a:	b82080e7          	jalr	-1150(ra) # 80006118 <panic>
    a += PGSIZE;
    8000059e:	995e                	add	s2,s2,s7
  for(;;){
    800005a0:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    800005a4:	4605                	li	a2,1
    800005a6:	85ca                	mv	a1,s2
    800005a8:	8556                	mv	a0,s5
    800005aa:	00000097          	auipc	ra,0x0
    800005ae:	eb6080e7          	jalr	-330(ra) # 80000460 <walk>
    800005b2:	cd19                	beqz	a0,800005d0 <mappages+0x88>
    if(*pte & PTE_V)
    800005b4:	611c                	ld	a5,0(a0)
    800005b6:	8b85                	andi	a5,a5,1
    800005b8:	fbf9                	bnez	a5,8000058e <mappages+0x46>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800005ba:	80b1                	srli	s1,s1,0xc
    800005bc:	04aa                	slli	s1,s1,0xa
    800005be:	0164e4b3          	or	s1,s1,s6
    800005c2:	0014e493          	ori	s1,s1,1
    800005c6:	e104                	sd	s1,0(a0)
    if(a == last)
    800005c8:	fd391be3          	bne	s2,s3,8000059e <mappages+0x56>
    pa += PGSIZE;
  }
  return 0;
    800005cc:	4501                	li	a0,0
    800005ce:	a011                	j	800005d2 <mappages+0x8a>
      return -1;
    800005d0:	557d                	li	a0,-1
}
    800005d2:	60a6                	ld	ra,72(sp)
    800005d4:	6406                	ld	s0,64(sp)
    800005d6:	74e2                	ld	s1,56(sp)
    800005d8:	7942                	ld	s2,48(sp)
    800005da:	79a2                	ld	s3,40(sp)
    800005dc:	7a02                	ld	s4,32(sp)
    800005de:	6ae2                	ld	s5,24(sp)
    800005e0:	6b42                	ld	s6,16(sp)
    800005e2:	6ba2                	ld	s7,8(sp)
    800005e4:	6161                	addi	sp,sp,80
    800005e6:	8082                	ret

00000000800005e8 <kvmmap>:
{
    800005e8:	1141                	addi	sp,sp,-16
    800005ea:	e406                	sd	ra,8(sp)
    800005ec:	e022                	sd	s0,0(sp)
    800005ee:	0800                	addi	s0,sp,16
    800005f0:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800005f2:	86b2                	mv	a3,a2
    800005f4:	863e                	mv	a2,a5
    800005f6:	00000097          	auipc	ra,0x0
    800005fa:	f52080e7          	jalr	-174(ra) # 80000548 <mappages>
    800005fe:	e509                	bnez	a0,80000608 <kvmmap+0x20>
}
    80000600:	60a2                	ld	ra,8(sp)
    80000602:	6402                	ld	s0,0(sp)
    80000604:	0141                	addi	sp,sp,16
    80000606:	8082                	ret
    panic("kvmmap");
    80000608:	00008517          	auipc	a0,0x8
    8000060c:	a7050513          	addi	a0,a0,-1424 # 80008078 <etext+0x78>
    80000610:	00006097          	auipc	ra,0x6
    80000614:	b08080e7          	jalr	-1272(ra) # 80006118 <panic>

0000000080000618 <kvmmake>:
{
    80000618:	1101                	addi	sp,sp,-32
    8000061a:	ec06                	sd	ra,24(sp)
    8000061c:	e822                	sd	s0,16(sp)
    8000061e:	e426                	sd	s1,8(sp)
    80000620:	e04a                	sd	s2,0(sp)
    80000622:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80000624:	00000097          	auipc	ra,0x0
    80000628:	af4080e7          	jalr	-1292(ra) # 80000118 <kalloc>
    8000062c:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000062e:	6605                	lui	a2,0x1
    80000630:	4581                	li	a1,0
    80000632:	00000097          	auipc	ra,0x0
    80000636:	b46080e7          	jalr	-1210(ra) # 80000178 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000063a:	4719                	li	a4,6
    8000063c:	6685                	lui	a3,0x1
    8000063e:	10000637          	lui	a2,0x10000
    80000642:	100005b7          	lui	a1,0x10000
    80000646:	8526                	mv	a0,s1
    80000648:	00000097          	auipc	ra,0x0
    8000064c:	fa0080e7          	jalr	-96(ra) # 800005e8 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80000650:	4719                	li	a4,6
    80000652:	6685                	lui	a3,0x1
    80000654:	10001637          	lui	a2,0x10001
    80000658:	100015b7          	lui	a1,0x10001
    8000065c:	8526                	mv	a0,s1
    8000065e:	00000097          	auipc	ra,0x0
    80000662:	f8a080e7          	jalr	-118(ra) # 800005e8 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80000666:	4719                	li	a4,6
    80000668:	004006b7          	lui	a3,0x400
    8000066c:	0c000637          	lui	a2,0xc000
    80000670:	0c0005b7          	lui	a1,0xc000
    80000674:	8526                	mv	a0,s1
    80000676:	00000097          	auipc	ra,0x0
    8000067a:	f72080e7          	jalr	-142(ra) # 800005e8 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    8000067e:	00008917          	auipc	s2,0x8
    80000682:	98290913          	addi	s2,s2,-1662 # 80008000 <etext>
    80000686:	4729                	li	a4,10
    80000688:	80008697          	auipc	a3,0x80008
    8000068c:	97868693          	addi	a3,a3,-1672 # 8000 <_entry-0x7fff8000>
    80000690:	4605                	li	a2,1
    80000692:	067e                	slli	a2,a2,0x1f
    80000694:	85b2                	mv	a1,a2
    80000696:	8526                	mv	a0,s1
    80000698:	00000097          	auipc	ra,0x0
    8000069c:	f50080e7          	jalr	-176(ra) # 800005e8 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800006a0:	4719                	li	a4,6
    800006a2:	46c5                	li	a3,17
    800006a4:	06ee                	slli	a3,a3,0x1b
    800006a6:	412686b3          	sub	a3,a3,s2
    800006aa:	864a                	mv	a2,s2
    800006ac:	85ca                	mv	a1,s2
    800006ae:	8526                	mv	a0,s1
    800006b0:	00000097          	auipc	ra,0x0
    800006b4:	f38080e7          	jalr	-200(ra) # 800005e8 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800006b8:	4729                	li	a4,10
    800006ba:	6685                	lui	a3,0x1
    800006bc:	00007617          	auipc	a2,0x7
    800006c0:	94460613          	addi	a2,a2,-1724 # 80007000 <_trampoline>
    800006c4:	040005b7          	lui	a1,0x4000
    800006c8:	15fd                	addi	a1,a1,-1
    800006ca:	05b2                	slli	a1,a1,0xc
    800006cc:	8526                	mv	a0,s1
    800006ce:	00000097          	auipc	ra,0x0
    800006d2:	f1a080e7          	jalr	-230(ra) # 800005e8 <kvmmap>
  proc_mapstacks(kpgtbl);
    800006d6:	8526                	mv	a0,s1
    800006d8:	00001097          	auipc	ra,0x1
    800006dc:	8ae080e7          	jalr	-1874(ra) # 80000f86 <proc_mapstacks>
}
    800006e0:	8526                	mv	a0,s1
    800006e2:	60e2                	ld	ra,24(sp)
    800006e4:	6442                	ld	s0,16(sp)
    800006e6:	64a2                	ld	s1,8(sp)
    800006e8:	6902                	ld	s2,0(sp)
    800006ea:	6105                	addi	sp,sp,32
    800006ec:	8082                	ret

00000000800006ee <kvminit>:
{
    800006ee:	1141                	addi	sp,sp,-16
    800006f0:	e406                	sd	ra,8(sp)
    800006f2:	e022                	sd	s0,0(sp)
    800006f4:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800006f6:	00000097          	auipc	ra,0x0
    800006fa:	f22080e7          	jalr	-222(ra) # 80000618 <kvmmake>
    800006fe:	00009797          	auipc	a5,0x9
    80000702:	90a7b523          	sd	a0,-1782(a5) # 80009008 <kernel_pagetable>
}
    80000706:	60a2                	ld	ra,8(sp)
    80000708:	6402                	ld	s0,0(sp)
    8000070a:	0141                	addi	sp,sp,16
    8000070c:	8082                	ret

000000008000070e <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    8000070e:	715d                	addi	sp,sp,-80
    80000710:	e486                	sd	ra,72(sp)
    80000712:	e0a2                	sd	s0,64(sp)
    80000714:	fc26                	sd	s1,56(sp)
    80000716:	f84a                	sd	s2,48(sp)
    80000718:	f44e                	sd	s3,40(sp)
    8000071a:	f052                	sd	s4,32(sp)
    8000071c:	ec56                	sd	s5,24(sp)
    8000071e:	e85a                	sd	s6,16(sp)
    80000720:	e45e                	sd	s7,8(sp)
    80000722:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000724:	03459793          	slli	a5,a1,0x34
    80000728:	e795                	bnez	a5,80000754 <uvmunmap+0x46>
    8000072a:	8a2a                	mv	s4,a0
    8000072c:	892e                	mv	s2,a1
    8000072e:	8b36                	mv	s6,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000730:	0632                	slli	a2,a2,0xc
    80000732:	00b609b3          	add	s3,a2,a1
    }

    if((*pte & PTE_V) == 0)
      continue;

    if(PTE_FLAGS(*pte) == PTE_V)
    80000736:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000738:	6a85                	lui	s5,0x1
    8000073a:	0735e163          	bltu	a1,s3,8000079c <uvmunmap+0x8e>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    8000073e:	60a6                	ld	ra,72(sp)
    80000740:	6406                	ld	s0,64(sp)
    80000742:	74e2                	ld	s1,56(sp)
    80000744:	7942                	ld	s2,48(sp)
    80000746:	79a2                	ld	s3,40(sp)
    80000748:	7a02                	ld	s4,32(sp)
    8000074a:	6ae2                	ld	s5,24(sp)
    8000074c:	6b42                	ld	s6,16(sp)
    8000074e:	6ba2                	ld	s7,8(sp)
    80000750:	6161                	addi	sp,sp,80
    80000752:	8082                	ret
    panic("uvmunmap: not aligned");
    80000754:	00008517          	auipc	a0,0x8
    80000758:	92c50513          	addi	a0,a0,-1748 # 80008080 <etext+0x80>
    8000075c:	00006097          	auipc	ra,0x6
    80000760:	9bc080e7          	jalr	-1604(ra) # 80006118 <panic>
      panic("uvmunmap: walk");
    80000764:	00008517          	auipc	a0,0x8
    80000768:	93450513          	addi	a0,a0,-1740 # 80008098 <etext+0x98>
    8000076c:	00006097          	auipc	ra,0x6
    80000770:	9ac080e7          	jalr	-1620(ra) # 80006118 <panic>
      panic("uvmunmap: not a leaf");
    80000774:	00008517          	auipc	a0,0x8
    80000778:	93450513          	addi	a0,a0,-1740 # 800080a8 <etext+0xa8>
    8000077c:	00006097          	auipc	ra,0x6
    80000780:	99c080e7          	jalr	-1636(ra) # 80006118 <panic>
      uint64 pa = PTE2PA(*pte);
    80000784:	83a9                	srli	a5,a5,0xa
      kfree((void*)pa);
    80000786:	00c79513          	slli	a0,a5,0xc
    8000078a:	00000097          	auipc	ra,0x0
    8000078e:	892080e7          	jalr	-1902(ra) # 8000001c <kfree>
    *pte = 0;
    80000792:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000796:	9956                	add	s2,s2,s5
    80000798:	fb3973e3          	bgeu	s2,s3,8000073e <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    8000079c:	4601                	li	a2,0
    8000079e:	85ca                	mv	a1,s2
    800007a0:	8552                	mv	a0,s4
    800007a2:	00000097          	auipc	ra,0x0
    800007a6:	cbe080e7          	jalr	-834(ra) # 80000460 <walk>
    800007aa:	84aa                	mv	s1,a0
    800007ac:	dd45                	beqz	a0,80000764 <uvmunmap+0x56>
    if(*pte & PTE_S) {
    800007ae:	611c                	ld	a5,0(a0)
    800007b0:	2007f713          	andi	a4,a5,512
    800007b4:	f36d                	bnez	a4,80000796 <uvmunmap+0x88>
    if((*pte & PTE_V) == 0)
    800007b6:	0017f713          	andi	a4,a5,1
    800007ba:	df71                	beqz	a4,80000796 <uvmunmap+0x88>
    if(PTE_FLAGS(*pte) == PTE_V)
    800007bc:	3ff7f713          	andi	a4,a5,1023
    800007c0:	fb770ae3          	beq	a4,s7,80000774 <uvmunmap+0x66>
    if(do_free){
    800007c4:	fc0b07e3          	beqz	s6,80000792 <uvmunmap+0x84>
    800007c8:	bf75                	j	80000784 <uvmunmap+0x76>

00000000800007ca <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800007ca:	1101                	addi	sp,sp,-32
    800007cc:	ec06                	sd	ra,24(sp)
    800007ce:	e822                	sd	s0,16(sp)
    800007d0:	e426                	sd	s1,8(sp)
    800007d2:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800007d4:	00000097          	auipc	ra,0x0
    800007d8:	944080e7          	jalr	-1724(ra) # 80000118 <kalloc>
    800007dc:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800007de:	c519                	beqz	a0,800007ec <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800007e0:	6605                	lui	a2,0x1
    800007e2:	4581                	li	a1,0
    800007e4:	00000097          	auipc	ra,0x0
    800007e8:	994080e7          	jalr	-1644(ra) # 80000178 <memset>
  return pagetable;
}
    800007ec:	8526                	mv	a0,s1
    800007ee:	60e2                	ld	ra,24(sp)
    800007f0:	6442                	ld	s0,16(sp)
    800007f2:	64a2                	ld	s1,8(sp)
    800007f4:	6105                	addi	sp,sp,32
    800007f6:	8082                	ret

00000000800007f8 <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    800007f8:	7179                	addi	sp,sp,-48
    800007fa:	f406                	sd	ra,40(sp)
    800007fc:	f022                	sd	s0,32(sp)
    800007fe:	ec26                	sd	s1,24(sp)
    80000800:	e84a                	sd	s2,16(sp)
    80000802:	e44e                	sd	s3,8(sp)
    80000804:	e052                	sd	s4,0(sp)
    80000806:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80000808:	6785                	lui	a5,0x1
    8000080a:	04f67863          	bgeu	a2,a5,8000085a <uvminit+0x62>
    8000080e:	8a2a                	mv	s4,a0
    80000810:	89ae                	mv	s3,a1
    80000812:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    80000814:	00000097          	auipc	ra,0x0
    80000818:	904080e7          	jalr	-1788(ra) # 80000118 <kalloc>
    8000081c:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    8000081e:	6605                	lui	a2,0x1
    80000820:	4581                	li	a1,0
    80000822:	00000097          	auipc	ra,0x0
    80000826:	956080e7          	jalr	-1706(ra) # 80000178 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    8000082a:	4779                	li	a4,30
    8000082c:	86ca                	mv	a3,s2
    8000082e:	6605                	lui	a2,0x1
    80000830:	4581                	li	a1,0
    80000832:	8552                	mv	a0,s4
    80000834:	00000097          	auipc	ra,0x0
    80000838:	d14080e7          	jalr	-748(ra) # 80000548 <mappages>
  memmove(mem, src, sz);
    8000083c:	8626                	mv	a2,s1
    8000083e:	85ce                	mv	a1,s3
    80000840:	854a                	mv	a0,s2
    80000842:	00000097          	auipc	ra,0x0
    80000846:	996080e7          	jalr	-1642(ra) # 800001d8 <memmove>
}
    8000084a:	70a2                	ld	ra,40(sp)
    8000084c:	7402                	ld	s0,32(sp)
    8000084e:	64e2                	ld	s1,24(sp)
    80000850:	6942                	ld	s2,16(sp)
    80000852:	69a2                	ld	s3,8(sp)
    80000854:	6a02                	ld	s4,0(sp)
    80000856:	6145                	addi	sp,sp,48
    80000858:	8082                	ret
    panic("inituvm: more than a page");
    8000085a:	00008517          	auipc	a0,0x8
    8000085e:	86650513          	addi	a0,a0,-1946 # 800080c0 <etext+0xc0>
    80000862:	00006097          	auipc	ra,0x6
    80000866:	8b6080e7          	jalr	-1866(ra) # 80006118 <panic>

000000008000086a <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    8000086a:	1101                	addi	sp,sp,-32
    8000086c:	ec06                	sd	ra,24(sp)
    8000086e:	e822                	sd	s0,16(sp)
    80000870:	e426                	sd	s1,8(sp)
    80000872:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80000874:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80000876:	00b67d63          	bgeu	a2,a1,80000890 <uvmdealloc+0x26>
    8000087a:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    8000087c:	6785                	lui	a5,0x1
    8000087e:	17fd                	addi	a5,a5,-1
    80000880:	00f60733          	add	a4,a2,a5
    80000884:	767d                	lui	a2,0xfffff
    80000886:	8f71                	and	a4,a4,a2
    80000888:	97ae                	add	a5,a5,a1
    8000088a:	8ff1                	and	a5,a5,a2
    8000088c:	00f76863          	bltu	a4,a5,8000089c <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80000890:	8526                	mv	a0,s1
    80000892:	60e2                	ld	ra,24(sp)
    80000894:	6442                	ld	s0,16(sp)
    80000896:	64a2                	ld	s1,8(sp)
    80000898:	6105                	addi	sp,sp,32
    8000089a:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    8000089c:	8f99                	sub	a5,a5,a4
    8000089e:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008a0:	4685                	li	a3,1
    800008a2:	0007861b          	sext.w	a2,a5
    800008a6:	85ba                	mv	a1,a4
    800008a8:	00000097          	auipc	ra,0x0
    800008ac:	e66080e7          	jalr	-410(ra) # 8000070e <uvmunmap>
    800008b0:	b7c5                	j	80000890 <uvmdealloc+0x26>

00000000800008b2 <uvmalloc>:
  if(newsz < oldsz)
    800008b2:	0ab66163          	bltu	a2,a1,80000954 <uvmalloc+0xa2>
{
    800008b6:	7139                	addi	sp,sp,-64
    800008b8:	fc06                	sd	ra,56(sp)
    800008ba:	f822                	sd	s0,48(sp)
    800008bc:	f426                	sd	s1,40(sp)
    800008be:	f04a                	sd	s2,32(sp)
    800008c0:	ec4e                	sd	s3,24(sp)
    800008c2:	e852                	sd	s4,16(sp)
    800008c4:	e456                	sd	s5,8(sp)
    800008c6:	0080                	addi	s0,sp,64
    800008c8:	8aaa                	mv	s5,a0
    800008ca:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800008cc:	6985                	lui	s3,0x1
    800008ce:	19fd                	addi	s3,s3,-1
    800008d0:	95ce                	add	a1,a1,s3
    800008d2:	79fd                	lui	s3,0xfffff
    800008d4:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    800008d8:	08c9f063          	bgeu	s3,a2,80000958 <uvmalloc+0xa6>
    800008dc:	894e                	mv	s2,s3
    mem = kalloc();
    800008de:	00000097          	auipc	ra,0x0
    800008e2:	83a080e7          	jalr	-1990(ra) # 80000118 <kalloc>
    800008e6:	84aa                	mv	s1,a0
    if(mem == 0){
    800008e8:	c51d                	beqz	a0,80000916 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    800008ea:	6605                	lui	a2,0x1
    800008ec:	4581                	li	a1,0
    800008ee:	00000097          	auipc	ra,0x0
    800008f2:	88a080e7          	jalr	-1910(ra) # 80000178 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    800008f6:	4779                	li	a4,30
    800008f8:	86a6                	mv	a3,s1
    800008fa:	6605                	lui	a2,0x1
    800008fc:	85ca                	mv	a1,s2
    800008fe:	8556                	mv	a0,s5
    80000900:	00000097          	auipc	ra,0x0
    80000904:	c48080e7          	jalr	-952(ra) # 80000548 <mappages>
    80000908:	e905                	bnez	a0,80000938 <uvmalloc+0x86>
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000090a:	6785                	lui	a5,0x1
    8000090c:	993e                	add	s2,s2,a5
    8000090e:	fd4968e3          	bltu	s2,s4,800008de <uvmalloc+0x2c>
  return newsz;
    80000912:	8552                	mv	a0,s4
    80000914:	a809                	j	80000926 <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    80000916:	864e                	mv	a2,s3
    80000918:	85ca                	mv	a1,s2
    8000091a:	8556                	mv	a0,s5
    8000091c:	00000097          	auipc	ra,0x0
    80000920:	f4e080e7          	jalr	-178(ra) # 8000086a <uvmdealloc>
      return 0;
    80000924:	4501                	li	a0,0
}
    80000926:	70e2                	ld	ra,56(sp)
    80000928:	7442                	ld	s0,48(sp)
    8000092a:	74a2                	ld	s1,40(sp)
    8000092c:	7902                	ld	s2,32(sp)
    8000092e:	69e2                	ld	s3,24(sp)
    80000930:	6a42                	ld	s4,16(sp)
    80000932:	6aa2                	ld	s5,8(sp)
    80000934:	6121                	addi	sp,sp,64
    80000936:	8082                	ret
      kfree(mem);
    80000938:	8526                	mv	a0,s1
    8000093a:	fffff097          	auipc	ra,0xfffff
    8000093e:	6e2080e7          	jalr	1762(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000942:	864e                	mv	a2,s3
    80000944:	85ca                	mv	a1,s2
    80000946:	8556                	mv	a0,s5
    80000948:	00000097          	auipc	ra,0x0
    8000094c:	f22080e7          	jalr	-222(ra) # 8000086a <uvmdealloc>
      return 0;
    80000950:	4501                	li	a0,0
    80000952:	bfd1                	j	80000926 <uvmalloc+0x74>
    return oldsz;
    80000954:	852e                	mv	a0,a1
}
    80000956:	8082                	ret
  return newsz;
    80000958:	8532                	mv	a0,a2
    8000095a:	b7f1                	j	80000926 <uvmalloc+0x74>

000000008000095c <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    8000095c:	7179                	addi	sp,sp,-48
    8000095e:	f406                	sd	ra,40(sp)
    80000960:	f022                	sd	s0,32(sp)
    80000962:	ec26                	sd	s1,24(sp)
    80000964:	e84a                	sd	s2,16(sp)
    80000966:	e44e                	sd	s3,8(sp)
    80000968:	e052                	sd	s4,0(sp)
    8000096a:	1800                	addi	s0,sp,48
    8000096c:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    8000096e:	84aa                	mv	s1,a0
    80000970:	6905                	lui	s2,0x1
    80000972:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000974:	4985                	li	s3,1
    80000976:	a821                	j	8000098e <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000978:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    8000097a:	0532                	slli	a0,a0,0xc
    8000097c:	00000097          	auipc	ra,0x0
    80000980:	fe0080e7          	jalr	-32(ra) # 8000095c <freewalk>
      pagetable[i] = 0;
    80000984:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80000988:	04a1                	addi	s1,s1,8
    8000098a:	03248163          	beq	s1,s2,800009ac <freewalk+0x50>
    pte_t pte = pagetable[i];
    8000098e:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000990:	00f57793          	andi	a5,a0,15
    80000994:	ff3782e3          	beq	a5,s3,80000978 <freewalk+0x1c>
    } else if(pte & PTE_V){
    80000998:	8905                	andi	a0,a0,1
    8000099a:	d57d                	beqz	a0,80000988 <freewalk+0x2c>
      panic("freewalk: leaf");
    8000099c:	00007517          	auipc	a0,0x7
    800009a0:	74450513          	addi	a0,a0,1860 # 800080e0 <etext+0xe0>
    800009a4:	00005097          	auipc	ra,0x5
    800009a8:	774080e7          	jalr	1908(ra) # 80006118 <panic>
    }
  }
  kfree((void*)pagetable);
    800009ac:	8552                	mv	a0,s4
    800009ae:	fffff097          	auipc	ra,0xfffff
    800009b2:	66e080e7          	jalr	1646(ra) # 8000001c <kfree>
}
    800009b6:	70a2                	ld	ra,40(sp)
    800009b8:	7402                	ld	s0,32(sp)
    800009ba:	64e2                	ld	s1,24(sp)
    800009bc:	6942                	ld	s2,16(sp)
    800009be:	69a2                	ld	s3,8(sp)
    800009c0:	6a02                	ld	s4,0(sp)
    800009c2:	6145                	addi	sp,sp,48
    800009c4:	8082                	ret

00000000800009c6 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800009c6:	1101                	addi	sp,sp,-32
    800009c8:	ec06                	sd	ra,24(sp)
    800009ca:	e822                	sd	s0,16(sp)
    800009cc:	e426                	sd	s1,8(sp)
    800009ce:	1000                	addi	s0,sp,32
    800009d0:	84aa                	mv	s1,a0
  if(sz > 0)
    800009d2:	e999                	bnez	a1,800009e8 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800009d4:	8526                	mv	a0,s1
    800009d6:	00000097          	auipc	ra,0x0
    800009da:	f86080e7          	jalr	-122(ra) # 8000095c <freewalk>
}
    800009de:	60e2                	ld	ra,24(sp)
    800009e0:	6442                	ld	s0,16(sp)
    800009e2:	64a2                	ld	s1,8(sp)
    800009e4:	6105                	addi	sp,sp,32
    800009e6:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800009e8:	6605                	lui	a2,0x1
    800009ea:	167d                	addi	a2,a2,-1
    800009ec:	962e                	add	a2,a2,a1
    800009ee:	4685                	li	a3,1
    800009f0:	8231                	srli	a2,a2,0xc
    800009f2:	4581                	li	a1,0
    800009f4:	00000097          	auipc	ra,0x0
    800009f8:	d1a080e7          	jalr	-742(ra) # 8000070e <uvmunmap>
    800009fc:	bfe1                	j	800009d4 <uvmfree+0xe>

00000000800009fe <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    800009fe:	c679                	beqz	a2,80000acc <uvmcopy+0xce>
{
    80000a00:	715d                	addi	sp,sp,-80
    80000a02:	e486                	sd	ra,72(sp)
    80000a04:	e0a2                	sd	s0,64(sp)
    80000a06:	fc26                	sd	s1,56(sp)
    80000a08:	f84a                	sd	s2,48(sp)
    80000a0a:	f44e                	sd	s3,40(sp)
    80000a0c:	f052                	sd	s4,32(sp)
    80000a0e:	ec56                	sd	s5,24(sp)
    80000a10:	e85a                	sd	s6,16(sp)
    80000a12:	e45e                	sd	s7,8(sp)
    80000a14:	0880                	addi	s0,sp,80
    80000a16:	8b2a                	mv	s6,a0
    80000a18:	8aae                	mv	s5,a1
    80000a1a:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a1c:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000a1e:	4601                	li	a2,0
    80000a20:	85ce                	mv	a1,s3
    80000a22:	855a                	mv	a0,s6
    80000a24:	00000097          	auipc	ra,0x0
    80000a28:	a3c080e7          	jalr	-1476(ra) # 80000460 <walk>
    80000a2c:	c531                	beqz	a0,80000a78 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000a2e:	6118                	ld	a4,0(a0)
    80000a30:	00177793          	andi	a5,a4,1
    80000a34:	cbb1                	beqz	a5,80000a88 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a36:	00a75593          	srli	a1,a4,0xa
    80000a3a:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a3e:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000a42:	fffff097          	auipc	ra,0xfffff
    80000a46:	6d6080e7          	jalr	1750(ra) # 80000118 <kalloc>
    80000a4a:	892a                	mv	s2,a0
    80000a4c:	c939                	beqz	a0,80000aa2 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000a4e:	6605                	lui	a2,0x1
    80000a50:	85de                	mv	a1,s7
    80000a52:	fffff097          	auipc	ra,0xfffff
    80000a56:	786080e7          	jalr	1926(ra) # 800001d8 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000a5a:	8726                	mv	a4,s1
    80000a5c:	86ca                	mv	a3,s2
    80000a5e:	6605                	lui	a2,0x1
    80000a60:	85ce                	mv	a1,s3
    80000a62:	8556                	mv	a0,s5
    80000a64:	00000097          	auipc	ra,0x0
    80000a68:	ae4080e7          	jalr	-1308(ra) # 80000548 <mappages>
    80000a6c:	e515                	bnez	a0,80000a98 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000a6e:	6785                	lui	a5,0x1
    80000a70:	99be                	add	s3,s3,a5
    80000a72:	fb49e6e3          	bltu	s3,s4,80000a1e <uvmcopy+0x20>
    80000a76:	a081                	j	80000ab6 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000a78:	00007517          	auipc	a0,0x7
    80000a7c:	67850513          	addi	a0,a0,1656 # 800080f0 <etext+0xf0>
    80000a80:	00005097          	auipc	ra,0x5
    80000a84:	698080e7          	jalr	1688(ra) # 80006118 <panic>
      panic("uvmcopy: page not present");
    80000a88:	00007517          	auipc	a0,0x7
    80000a8c:	68850513          	addi	a0,a0,1672 # 80008110 <etext+0x110>
    80000a90:	00005097          	auipc	ra,0x5
    80000a94:	688080e7          	jalr	1672(ra) # 80006118 <panic>
      kfree(mem);
    80000a98:	854a                	mv	a0,s2
    80000a9a:	fffff097          	auipc	ra,0xfffff
    80000a9e:	582080e7          	jalr	1410(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000aa2:	4685                	li	a3,1
    80000aa4:	00c9d613          	srli	a2,s3,0xc
    80000aa8:	4581                	li	a1,0
    80000aaa:	8556                	mv	a0,s5
    80000aac:	00000097          	auipc	ra,0x0
    80000ab0:	c62080e7          	jalr	-926(ra) # 8000070e <uvmunmap>
  return -1;
    80000ab4:	557d                	li	a0,-1
}
    80000ab6:	60a6                	ld	ra,72(sp)
    80000ab8:	6406                	ld	s0,64(sp)
    80000aba:	74e2                	ld	s1,56(sp)
    80000abc:	7942                	ld	s2,48(sp)
    80000abe:	79a2                	ld	s3,40(sp)
    80000ac0:	7a02                	ld	s4,32(sp)
    80000ac2:	6ae2                	ld	s5,24(sp)
    80000ac4:	6b42                	ld	s6,16(sp)
    80000ac6:	6ba2                	ld	s7,8(sp)
    80000ac8:	6161                	addi	sp,sp,80
    80000aca:	8082                	ret
  return 0;
    80000acc:	4501                	li	a0,0
}
    80000ace:	8082                	ret

0000000080000ad0 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000ad0:	1141                	addi	sp,sp,-16
    80000ad2:	e406                	sd	ra,8(sp)
    80000ad4:	e022                	sd	s0,0(sp)
    80000ad6:	0800                	addi	s0,sp,16
  pte_t *pte;
  pte = walk(pagetable, va, 0);
    80000ad8:	4601                	li	a2,0
    80000ada:	00000097          	auipc	ra,0x0
    80000ade:	986080e7          	jalr	-1658(ra) # 80000460 <walk>
  if(pte == 0)
    80000ae2:	c901                	beqz	a0,80000af2 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000ae4:	611c                	ld	a5,0(a0)
    80000ae6:	9bbd                	andi	a5,a5,-17
    80000ae8:	e11c                	sd	a5,0(a0)
}
    80000aea:	60a2                	ld	ra,8(sp)
    80000aec:	6402                	ld	s0,0(sp)
    80000aee:	0141                	addi	sp,sp,16
    80000af0:	8082                	ret
    panic("uvmclear");
    80000af2:	00007517          	auipc	a0,0x7
    80000af6:	63e50513          	addi	a0,a0,1598 # 80008130 <etext+0x130>
    80000afa:	00005097          	auipc	ra,0x5
    80000afe:	61e080e7          	jalr	1566(ra) # 80006118 <panic>

0000000080000b02 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b02:	c6bd                	beqz	a3,80000b70 <copyout+0x6e>
{
    80000b04:	715d                	addi	sp,sp,-80
    80000b06:	e486                	sd	ra,72(sp)
    80000b08:	e0a2                	sd	s0,64(sp)
    80000b0a:	fc26                	sd	s1,56(sp)
    80000b0c:	f84a                	sd	s2,48(sp)
    80000b0e:	f44e                	sd	s3,40(sp)
    80000b10:	f052                	sd	s4,32(sp)
    80000b12:	ec56                	sd	s5,24(sp)
    80000b14:	e85a                	sd	s6,16(sp)
    80000b16:	e45e                	sd	s7,8(sp)
    80000b18:	e062                	sd	s8,0(sp)
    80000b1a:	0880                	addi	s0,sp,80
    80000b1c:	8b2a                	mv	s6,a0
    80000b1e:	8c2e                	mv	s8,a1
    80000b20:	8a32                	mv	s4,a2
    80000b22:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b24:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b26:	6a85                	lui	s5,0x1
    80000b28:	a015                	j	80000b4c <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b2a:	9562                	add	a0,a0,s8
    80000b2c:	0004861b          	sext.w	a2,s1
    80000b30:	85d2                	mv	a1,s4
    80000b32:	41250533          	sub	a0,a0,s2
    80000b36:	fffff097          	auipc	ra,0xfffff
    80000b3a:	6a2080e7          	jalr	1698(ra) # 800001d8 <memmove>

    len -= n;
    80000b3e:	409989b3          	sub	s3,s3,s1
    src += n;
    80000b42:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000b44:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000b48:	02098263          	beqz	s3,80000b6c <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000b4c:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000b50:	85ca                	mv	a1,s2
    80000b52:	855a                	mv	a0,s6
    80000b54:	00000097          	auipc	ra,0x0
    80000b58:	9b2080e7          	jalr	-1614(ra) # 80000506 <walkaddr>
    if(pa0 == 0)
    80000b5c:	cd01                	beqz	a0,80000b74 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000b5e:	418904b3          	sub	s1,s2,s8
    80000b62:	94d6                	add	s1,s1,s5
    if(n > len)
    80000b64:	fc99f3e3          	bgeu	s3,s1,80000b2a <copyout+0x28>
    80000b68:	84ce                	mv	s1,s3
    80000b6a:	b7c1                	j	80000b2a <copyout+0x28>
  }
  return 0;
    80000b6c:	4501                	li	a0,0
    80000b6e:	a021                	j	80000b76 <copyout+0x74>
    80000b70:	4501                	li	a0,0
}
    80000b72:	8082                	ret
      return -1;
    80000b74:	557d                	li	a0,-1
}
    80000b76:	60a6                	ld	ra,72(sp)
    80000b78:	6406                	ld	s0,64(sp)
    80000b7a:	74e2                	ld	s1,56(sp)
    80000b7c:	7942                	ld	s2,48(sp)
    80000b7e:	79a2                	ld	s3,40(sp)
    80000b80:	7a02                	ld	s4,32(sp)
    80000b82:	6ae2                	ld	s5,24(sp)
    80000b84:	6b42                	ld	s6,16(sp)
    80000b86:	6ba2                	ld	s7,8(sp)
    80000b88:	6c02                	ld	s8,0(sp)
    80000b8a:	6161                	addi	sp,sp,80
    80000b8c:	8082                	ret

0000000080000b8e <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b8e:	c6bd                	beqz	a3,80000bfc <copyin+0x6e>
{
    80000b90:	715d                	addi	sp,sp,-80
    80000b92:	e486                	sd	ra,72(sp)
    80000b94:	e0a2                	sd	s0,64(sp)
    80000b96:	fc26                	sd	s1,56(sp)
    80000b98:	f84a                	sd	s2,48(sp)
    80000b9a:	f44e                	sd	s3,40(sp)
    80000b9c:	f052                	sd	s4,32(sp)
    80000b9e:	ec56                	sd	s5,24(sp)
    80000ba0:	e85a                	sd	s6,16(sp)
    80000ba2:	e45e                	sd	s7,8(sp)
    80000ba4:	e062                	sd	s8,0(sp)
    80000ba6:	0880                	addi	s0,sp,80
    80000ba8:	8b2a                	mv	s6,a0
    80000baa:	8a2e                	mv	s4,a1
    80000bac:	8c32                	mv	s8,a2
    80000bae:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000bb0:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000bb2:	6a85                	lui	s5,0x1
    80000bb4:	a015                	j	80000bd8 <copyin+0x4a>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000bb6:	9562                	add	a0,a0,s8
    80000bb8:	0004861b          	sext.w	a2,s1
    80000bbc:	412505b3          	sub	a1,a0,s2
    80000bc0:	8552                	mv	a0,s4
    80000bc2:	fffff097          	auipc	ra,0xfffff
    80000bc6:	616080e7          	jalr	1558(ra) # 800001d8 <memmove>

    len -= n;
    80000bca:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000bce:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000bd0:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000bd4:	02098263          	beqz	s3,80000bf8 <copyin+0x6a>
    va0 = PGROUNDDOWN(srcva);
    80000bd8:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000bdc:	85ca                	mv	a1,s2
    80000bde:	855a                	mv	a0,s6
    80000be0:	00000097          	auipc	ra,0x0
    80000be4:	926080e7          	jalr	-1754(ra) # 80000506 <walkaddr>
    if(pa0 == 0)
    80000be8:	cd01                	beqz	a0,80000c00 <copyin+0x72>
    n = PGSIZE - (srcva - va0);
    80000bea:	418904b3          	sub	s1,s2,s8
    80000bee:	94d6                	add	s1,s1,s5
    if(n > len)
    80000bf0:	fc99f3e3          	bgeu	s3,s1,80000bb6 <copyin+0x28>
    80000bf4:	84ce                	mv	s1,s3
    80000bf6:	b7c1                	j	80000bb6 <copyin+0x28>
  }
  return 0;
    80000bf8:	4501                	li	a0,0
    80000bfa:	a021                	j	80000c02 <copyin+0x74>
    80000bfc:	4501                	li	a0,0
}
    80000bfe:	8082                	ret
      return -1;
    80000c00:	557d                	li	a0,-1
}
    80000c02:	60a6                	ld	ra,72(sp)
    80000c04:	6406                	ld	s0,64(sp)
    80000c06:	74e2                	ld	s1,56(sp)
    80000c08:	7942                	ld	s2,48(sp)
    80000c0a:	79a2                	ld	s3,40(sp)
    80000c0c:	7a02                	ld	s4,32(sp)
    80000c0e:	6ae2                	ld	s5,24(sp)
    80000c10:	6b42                	ld	s6,16(sp)
    80000c12:	6ba2                	ld	s7,8(sp)
    80000c14:	6c02                	ld	s8,0(sp)
    80000c16:	6161                	addi	sp,sp,80
    80000c18:	8082                	ret

0000000080000c1a <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c1a:	c6c5                	beqz	a3,80000cc2 <copyinstr+0xa8>
{
    80000c1c:	715d                	addi	sp,sp,-80
    80000c1e:	e486                	sd	ra,72(sp)
    80000c20:	e0a2                	sd	s0,64(sp)
    80000c22:	fc26                	sd	s1,56(sp)
    80000c24:	f84a                	sd	s2,48(sp)
    80000c26:	f44e                	sd	s3,40(sp)
    80000c28:	f052                	sd	s4,32(sp)
    80000c2a:	ec56                	sd	s5,24(sp)
    80000c2c:	e85a                	sd	s6,16(sp)
    80000c2e:	e45e                	sd	s7,8(sp)
    80000c30:	0880                	addi	s0,sp,80
    80000c32:	8a2a                	mv	s4,a0
    80000c34:	8b2e                	mv	s6,a1
    80000c36:	8bb2                	mv	s7,a2
    80000c38:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000c3a:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c3c:	6985                	lui	s3,0x1
    80000c3e:	a035                	j	80000c6a <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000c40:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000c44:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000c46:	0017b793          	seqz	a5,a5
    80000c4a:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000c4e:	60a6                	ld	ra,72(sp)
    80000c50:	6406                	ld	s0,64(sp)
    80000c52:	74e2                	ld	s1,56(sp)
    80000c54:	7942                	ld	s2,48(sp)
    80000c56:	79a2                	ld	s3,40(sp)
    80000c58:	7a02                	ld	s4,32(sp)
    80000c5a:	6ae2                	ld	s5,24(sp)
    80000c5c:	6b42                	ld	s6,16(sp)
    80000c5e:	6ba2                	ld	s7,8(sp)
    80000c60:	6161                	addi	sp,sp,80
    80000c62:	8082                	ret
    srcva = va0 + PGSIZE;
    80000c64:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000c68:	c8a9                	beqz	s1,80000cba <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    80000c6a:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000c6e:	85ca                	mv	a1,s2
    80000c70:	8552                	mv	a0,s4
    80000c72:	00000097          	auipc	ra,0x0
    80000c76:	894080e7          	jalr	-1900(ra) # 80000506 <walkaddr>
    if(pa0 == 0)
    80000c7a:	c131                	beqz	a0,80000cbe <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80000c7c:	41790833          	sub	a6,s2,s7
    80000c80:	984e                	add	a6,a6,s3
    if(n > max)
    80000c82:	0104f363          	bgeu	s1,a6,80000c88 <copyinstr+0x6e>
    80000c86:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000c88:	955e                	add	a0,a0,s7
    80000c8a:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000c8e:	fc080be3          	beqz	a6,80000c64 <copyinstr+0x4a>
    80000c92:	985a                	add	a6,a6,s6
    80000c94:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000c96:	41650633          	sub	a2,a0,s6
    80000c9a:	14fd                	addi	s1,s1,-1
    80000c9c:	9b26                	add	s6,s6,s1
    80000c9e:	00f60733          	add	a4,a2,a5
    80000ca2:	00074703          	lbu	a4,0(a4)
    80000ca6:	df49                	beqz	a4,80000c40 <copyinstr+0x26>
        *dst = *p;
    80000ca8:	00e78023          	sb	a4,0(a5)
      --max;
    80000cac:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80000cb0:	0785                	addi	a5,a5,1
    while(n > 0){
    80000cb2:	ff0796e3          	bne	a5,a6,80000c9e <copyinstr+0x84>
      dst++;
    80000cb6:	8b42                	mv	s6,a6
    80000cb8:	b775                	j	80000c64 <copyinstr+0x4a>
    80000cba:	4781                	li	a5,0
    80000cbc:	b769                	j	80000c46 <copyinstr+0x2c>
      return -1;
    80000cbe:	557d                	li	a0,-1
    80000cc0:	b779                	j	80000c4e <copyinstr+0x34>
  int got_null = 0;
    80000cc2:	4781                	li	a5,0
  if(got_null){
    80000cc4:	0017b793          	seqz	a5,a5
    80000cc8:	40f00533          	neg	a0,a5
}
    80000ccc:	8082                	ret

0000000080000cce <madvise>:

/* NTU OS 2024 */
/* Map pages to physical memory or swap space. */
int madvise(uint64 base, uint64 len, int advice) {
    80000cce:	7179                	addi	sp,sp,-48
    80000cd0:	f406                	sd	ra,40(sp)
    80000cd2:	f022                	sd	s0,32(sp)
    80000cd4:	ec26                	sd	s1,24(sp)
    80000cd6:	e84a                	sd	s2,16(sp)
    80000cd8:	e44e                	sd	s3,8(sp)
    80000cda:	e052                	sd	s4,0(sp)
    80000cdc:	1800                	addi	s0,sp,48
    80000cde:	84aa                	mv	s1,a0
    80000ce0:	892e                	mv	s2,a1
    80000ce2:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80000ce4:	00000097          	auipc	ra,0x0
    80000ce8:	410080e7          	jalr	1040(ra) # 800010f4 <myproc>
  pagetable_t pgtbl = p->pagetable;

  if (base > p->sz || (base + len) > p->sz) {
    80000cec:	6538                	ld	a4,72(a0)
    80000cee:	08976b63          	bltu	a4,s1,80000d84 <madvise+0xb6>
    80000cf2:	87aa                	mv	a5,a0
    80000cf4:	012486b3          	add	a3,s1,s2
    return -1;
    80000cf8:	557d                	li	a0,-1
  if (base > p->sz || (base + len) > p->sz) {
    80000cfa:	08d76663          	bltu	a4,a3,80000d86 <madvise+0xb8>
  }

  if (len == 0) {
    return 0;
    80000cfe:	4501                	li	a0,0
  if (len == 0) {
    80000d00:	08090363          	beqz	s2,80000d86 <madvise+0xb8>
  }

  uint64 begin = PGROUNDDOWN(base);
  uint64 last = PGROUNDDOWN(base + len - 1);

  if (advice == MADV_NORMAL) {
    80000d04:	0009871b          	sext.w	a4,s3
    80000d08:	4605                	li	a2,1
    80000d0a:	06e67e63          	bgeu	a2,a4,80000d86 <madvise+0xb8>
    // TODO
  } else if (advice == MADV_WILLNEED) {
    // TODO
  } else if (advice == MADV_DONTNEED) {
    80000d0e:	4609                	li	a2,2
    80000d10:	00c98663          	beq	s3,a2,80000d1c <madvise+0x4e>
    #endif

    end_op();
    return 0;

  } else if(advice == MADV_PIN) {
    80000d14:	3775                	addiw	a4,a4,-3
    80000d16:	4785                	li	a5,1
    // TODO
  } else if(advice == MADV_UNPIN) {
    // TODO
  }
  else {
    return -1;
    80000d18:	557d                	li	a0,-1
    80000d1a:	a0b5                	j	80000d86 <madvise+0xb8>
  pagetable_t pgtbl = p->pagetable;
    80000d1c:	0507b983          	ld	s3,80(a5)
  uint64 begin = PGROUNDDOWN(base);
    80000d20:	797d                	lui	s2,0xfffff
    80000d22:	0124f4b3          	and	s1,s1,s2
  uint64 last = PGROUNDDOWN(base + len - 1);
    80000d26:	16fd                	addi	a3,a3,-1
    80000d28:	0126f933          	and	s2,a3,s2
    begin_op();
    80000d2c:	00003097          	auipc	ra,0x3
    80000d30:	c08080e7          	jalr	-1016(ra) # 80003934 <begin_op>
    for (uint64 va = begin; va <= last; va += PGSIZE) {
    80000d34:	04996263          	bltu	s2,s1,80000d78 <madvise+0xaa>
    80000d38:	6a05                	lui	s4,0x1
    80000d3a:	a811                	j	80000d4e <madvise+0x80>
          end_op();
    80000d3c:	00003097          	auipc	ra,0x3
    80000d40:	c78080e7          	jalr	-904(ra) # 800039b4 <end_op>
          return -1;
    80000d44:	557d                	li	a0,-1
    80000d46:	a081                	j	80000d86 <madvise+0xb8>
    for (uint64 va = begin; va <= last; va += PGSIZE) {
    80000d48:	94d2                	add	s1,s1,s4
    80000d4a:	02996763          	bltu	s2,s1,80000d78 <madvise+0xaa>
      pte = walk(pgtbl, va, 0);
    80000d4e:	4601                	li	a2,0
    80000d50:	85a6                	mv	a1,s1
    80000d52:	854e                	mv	a0,s3
    80000d54:	fffff097          	auipc	ra,0xfffff
    80000d58:	70c080e7          	jalr	1804(ra) # 80000460 <walk>
      if (pte != 0 && (*pte & PTE_V)) {
    80000d5c:	d575                	beqz	a0,80000d48 <madvise+0x7a>
    80000d5e:	611c                	ld	a5,0(a0)
    80000d60:	8b85                	andi	a5,a5,1
    80000d62:	d3fd                	beqz	a5,80000d48 <madvise+0x7a>
        char *pa = (char*) swap_page_from_pte(pte);
    80000d64:	00005097          	auipc	ra,0x5
    80000d68:	d92080e7          	jalr	-622(ra) # 80005af6 <swap_page_from_pte>
        if (pa == 0) {
    80000d6c:	d961                	beqz	a0,80000d3c <madvise+0x6e>
        kfree(pa);
    80000d6e:	fffff097          	auipc	ra,0xfffff
    80000d72:	2ae080e7          	jalr	686(ra) # 8000001c <kfree>
    80000d76:	bfc9                	j	80000d48 <madvise+0x7a>
    end_op();
    80000d78:	00003097          	auipc	ra,0x3
    80000d7c:	c3c080e7          	jalr	-964(ra) # 800039b4 <end_op>
    return 0;
    80000d80:	4501                	li	a0,0
    80000d82:	a011                	j	80000d86 <madvise+0xb8>
    return -1;
    80000d84:	557d                	li	a0,-1
  }
}
    80000d86:	70a2                	ld	ra,40(sp)
    80000d88:	7402                	ld	s0,32(sp)
    80000d8a:	64e2                	ld	s1,24(sp)
    80000d8c:	6942                	ld	s2,16(sp)
    80000d8e:	69a2                	ld	s3,8(sp)
    80000d90:	6a02                	ld	s4,0(sp)
    80000d92:	6145                	addi	sp,sp,48
    80000d94:	8082                	ret

0000000080000d96 <dfs>:
}
#endif

/* NTU OS 2024 */
/* Print multi layer page table. */
void dfs(pagetable_t pagetable, uint64 lev, int last, int p, uint64 va){
    80000d96:	7175                	addi	sp,sp,-144
    80000d98:	e506                	sd	ra,136(sp)
    80000d9a:	e122                	sd	s0,128(sp)
    80000d9c:	fca6                	sd	s1,120(sp)
    80000d9e:	f8ca                	sd	s2,112(sp)
    80000da0:	f4ce                	sd	s3,104(sp)
    80000da2:	f0d2                	sd	s4,96(sp)
    80000da4:	ecd6                	sd	s5,88(sp)
    80000da6:	e8da                	sd	s6,80(sp)
    80000da8:	e4de                	sd	s7,72(sp)
    80000daa:	e0e2                	sd	s8,64(sp)
    80000dac:	fc66                	sd	s9,56(sp)
    80000dae:	f86a                	sd	s10,48(sp)
    80000db0:	f46e                	sd	s11,40(sp)
    80000db2:	0900                	addi	s0,sp,144
    80000db4:	8aae                	mv	s5,a1
    80000db6:	8db2                	mv	s11,a2
    80000db8:	f6d43c23          	sd	a3,-136(s0)
    80000dbc:	8bba                	mv	s7,a4
        else
          printf("    ");
        if (lev == 0)
          printf("    ");
      }
      printf("+-- %d: pte=%p va=%p pa=%p V", i, pte, va | (i << (lev * 9 + 12)), PTE2PA(*pte));
    80000dbe:	00359b1b          	slliw	s6,a1,0x3
    80000dc2:	00bb0b3b          	addw	s6,s6,a1
    80000dc6:	2b31                	addiw	s6,s6,12
    80000dc8:	89aa                	mv	s3,a0
  for (uint64 i = 0; i < 512; ++i){
    80000dca:	4901                	li	s2,0
      if (lev < 2){
    80000dcc:	4d05                	li	s10,1
      printf("+-- %d: pte=%p va=%p pa=%p V", i, pte, va | (i << (lev * 9 + 12)), PTE2PA(*pte));
    80000dce:	00007c97          	auipc	s9,0x7
    80000dd2:	382c8c93          	addi	s9,s9,898 # 80008150 <etext+0x150>
      if (*pte & PTE_R) printf(" R");
      if (*pte & PTE_W) printf(" W");
      if (*pte & PTE_X) printf(" X");
      if (*pte & PTE_U) printf(" U");
      if (*pte & PTE_D) printf(" D");
      printf("\n");
    80000dd6:	00007c17          	auipc	s8,0x7
    80000dda:	272c0c13          	addi	s8,s8,626 # 80008048 <etext+0x48>
      if ((*pte & (PTE_R|PTE_W|PTE_X)) == 0){
        uint64 ch = PTE2PA(*pte);
        dfs((pagetable_t)ch, lev - 1, last, (lev == 2 ? i : p), va | (i << (lev * 9 + 12)));
    80000dde:	fff58793          	addi	a5,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000de2:	f8f43423          	sd	a5,-120(s0)
    80000de6:	f8d43023          	sd	a3,-128(s0)
    80000dea:	a865                	j	80000ea2 <dfs+0x10c>
        if (p < last)
    80000dec:	f7843783          	ld	a5,-136(s0)
    80000df0:	03b7d563          	bge	a5,s11,80000e1a <dfs+0x84>
          printf("|   ");
    80000df4:	00007517          	auipc	a0,0x7
    80000df8:	34c50513          	addi	a0,a0,844 # 80008140 <etext+0x140>
    80000dfc:	00005097          	auipc	ra,0x5
    80000e00:	366080e7          	jalr	870(ra) # 80006162 <printf>
        if (lev == 0)
    80000e04:	0a0a9663          	bnez	s5,80000eb0 <dfs+0x11a>
          printf("    ");
    80000e08:	00007517          	auipc	a0,0x7
    80000e0c:	34050513          	addi	a0,a0,832 # 80008148 <etext+0x148>
    80000e10:	00005097          	auipc	ra,0x5
    80000e14:	352080e7          	jalr	850(ra) # 80006162 <printf>
    80000e18:	a861                	j	80000eb0 <dfs+0x11a>
          printf("    ");
    80000e1a:	00007517          	auipc	a0,0x7
    80000e1e:	32e50513          	addi	a0,a0,814 # 80008148 <etext+0x148>
    80000e22:	00005097          	auipc	ra,0x5
    80000e26:	340080e7          	jalr	832(ra) # 80006162 <printf>
    80000e2a:	bfe9                	j	80000e04 <dfs+0x6e>
      if (*pte & PTE_R) printf(" R");
    80000e2c:	00007517          	auipc	a0,0x7
    80000e30:	34450513          	addi	a0,a0,836 # 80008170 <etext+0x170>
    80000e34:	00005097          	auipc	ra,0x5
    80000e38:	32e080e7          	jalr	814(ra) # 80006162 <printf>
    80000e3c:	a861                	j	80000ed4 <dfs+0x13e>
      if (*pte & PTE_W) printf(" W");
    80000e3e:	00007517          	auipc	a0,0x7
    80000e42:	33a50513          	addi	a0,a0,826 # 80008178 <etext+0x178>
    80000e46:	00005097          	auipc	ra,0x5
    80000e4a:	31c080e7          	jalr	796(ra) # 80006162 <printf>
    80000e4e:	a071                	j	80000eda <dfs+0x144>
      if (*pte & PTE_X) printf(" X");
    80000e50:	00007517          	auipc	a0,0x7
    80000e54:	33050513          	addi	a0,a0,816 # 80008180 <etext+0x180>
    80000e58:	00005097          	auipc	ra,0x5
    80000e5c:	30a080e7          	jalr	778(ra) # 80006162 <printf>
    80000e60:	a041                	j	80000ee0 <dfs+0x14a>
      if (*pte & PTE_U) printf(" U");
    80000e62:	00007517          	auipc	a0,0x7
    80000e66:	32650513          	addi	a0,a0,806 # 80008188 <etext+0x188>
    80000e6a:	00005097          	auipc	ra,0x5
    80000e6e:	2f8080e7          	jalr	760(ra) # 80006162 <printf>
    80000e72:	a895                	j	80000ee6 <dfs+0x150>
      if (*pte & PTE_D) printf(" D");
    80000e74:	00007517          	auipc	a0,0x7
    80000e78:	31c50513          	addi	a0,a0,796 # 80008190 <etext+0x190>
    80000e7c:	00005097          	auipc	ra,0x5
    80000e80:	2e6080e7          	jalr	742(ra) # 80006162 <printf>
    80000e84:	a0ad                	j	80000eee <dfs+0x158>
        dfs((pagetable_t)ch, lev - 1, last, (lev == 2 ? i : p), va | (i << (lev * 9 + 12)));
    80000e86:	8752                	mv	a4,s4
    80000e88:	866e                	mv	a2,s11
    80000e8a:	f8843583          	ld	a1,-120(s0)
    80000e8e:	00000097          	auipc	ra,0x0
    80000e92:	f08080e7          	jalr	-248(ra) # 80000d96 <dfs>
  for (uint64 i = 0; i < 512; ++i){
    80000e96:	0905                	addi	s2,s2,1
    80000e98:	09a1                	addi	s3,s3,8
    80000e9a:	20000793          	li	a5,512
    80000e9e:	06f90b63          	beq	s2,a5,80000f14 <dfs+0x17e>
    pte_t *pte = &pagetable[i];
    80000ea2:	84ce                	mv	s1,s3
    if (*pte & PTE_V){
    80000ea4:	0009b783          	ld	a5,0(s3) # 1000 <_entry-0x7ffff000>
    80000ea8:	8b85                	andi	a5,a5,1
    80000eaa:	d7f5                	beqz	a5,80000e96 <dfs+0x100>
      if (lev < 2){
    80000eac:	f55d70e3          	bgeu	s10,s5,80000dec <dfs+0x56>
      printf("+-- %d: pte=%p va=%p pa=%p V", i, pte, va | (i << (lev * 9 + 12)), PTE2PA(*pte));
    80000eb0:	01691a33          	sll	s4,s2,s6
    80000eb4:	017a6a33          	or	s4,s4,s7
    80000eb8:	6098                	ld	a4,0(s1)
    80000eba:	8329                	srli	a4,a4,0xa
    80000ebc:	0732                	slli	a4,a4,0xc
    80000ebe:	86d2                	mv	a3,s4
    80000ec0:	8626                	mv	a2,s1
    80000ec2:	85ca                	mv	a1,s2
    80000ec4:	8566                	mv	a0,s9
    80000ec6:	00005097          	auipc	ra,0x5
    80000eca:	29c080e7          	jalr	668(ra) # 80006162 <printf>
      if (*pte & PTE_R) printf(" R");
    80000ece:	609c                	ld	a5,0(s1)
    80000ed0:	8b89                	andi	a5,a5,2
    80000ed2:	ffa9                	bnez	a5,80000e2c <dfs+0x96>
      if (*pte & PTE_W) printf(" W");
    80000ed4:	609c                	ld	a5,0(s1)
    80000ed6:	8b91                	andi	a5,a5,4
    80000ed8:	f3bd                	bnez	a5,80000e3e <dfs+0xa8>
      if (*pte & PTE_X) printf(" X");
    80000eda:	609c                	ld	a5,0(s1)
    80000edc:	8ba1                	andi	a5,a5,8
    80000ede:	fbad                	bnez	a5,80000e50 <dfs+0xba>
      if (*pte & PTE_U) printf(" U");
    80000ee0:	609c                	ld	a5,0(s1)
    80000ee2:	8bc1                	andi	a5,a5,16
    80000ee4:	ffbd                	bnez	a5,80000e62 <dfs+0xcc>
      if (*pte & PTE_D) printf(" D");
    80000ee6:	609c                	ld	a5,0(s1)
    80000ee8:	0807f793          	andi	a5,a5,128
    80000eec:	f7c1                	bnez	a5,80000e74 <dfs+0xde>
      printf("\n");
    80000eee:	8562                	mv	a0,s8
    80000ef0:	00005097          	auipc	ra,0x5
    80000ef4:	272080e7          	jalr	626(ra) # 80006162 <printf>
      if ((*pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000ef8:	6088                	ld	a0,0(s1)
    80000efa:	00e57793          	andi	a5,a0,14
    80000efe:	ffc1                	bnez	a5,80000e96 <dfs+0x100>
        uint64 ch = PTE2PA(*pte);
    80000f00:	8129                	srli	a0,a0,0xa
    80000f02:	0532                	slli	a0,a0,0xc
        dfs((pagetable_t)ch, lev - 1, last, (lev == 2 ? i : p), va | (i << (lev * 9 + 12)));
    80000f04:	f8043683          	ld	a3,-128(s0)
    80000f08:	4789                	li	a5,2
    80000f0a:	f6fa9ee3          	bne	s5,a5,80000e86 <dfs+0xf0>
    80000f0e:	0009069b          	sext.w	a3,s2
    80000f12:	bf95                	j	80000e86 <dfs+0xf0>
      }
    }
  }
}
    80000f14:	60aa                	ld	ra,136(sp)
    80000f16:	640a                	ld	s0,128(sp)
    80000f18:	74e6                	ld	s1,120(sp)
    80000f1a:	7946                	ld	s2,112(sp)
    80000f1c:	79a6                	ld	s3,104(sp)
    80000f1e:	7a06                	ld	s4,96(sp)
    80000f20:	6ae6                	ld	s5,88(sp)
    80000f22:	6b46                	ld	s6,80(sp)
    80000f24:	6ba6                	ld	s7,72(sp)
    80000f26:	6c06                	ld	s8,64(sp)
    80000f28:	7ce2                	ld	s9,56(sp)
    80000f2a:	7d42                	ld	s10,48(sp)
    80000f2c:	7da2                	ld	s11,40(sp)
    80000f2e:	6149                	addi	sp,sp,144
    80000f30:	8082                	ret

0000000080000f32 <vmprint>:
void vmprint(pagetable_t pagetable) {
    80000f32:	1101                	addi	sp,sp,-32
    80000f34:	ec06                	sd	ra,24(sp)
    80000f36:	e822                	sd	s0,16(sp)
    80000f38:	e426                	sd	s1,8(sp)
    80000f3a:	1000                	addi	s0,sp,32
    80000f3c:	84aa                	mv	s1,a0
  /* TODO */
  //panic("not implemented yet\n");
  printf("page table %p\n", pagetable);
    80000f3e:	85aa                	mv	a1,a0
    80000f40:	00007517          	auipc	a0,0x7
    80000f44:	25850513          	addi	a0,a0,600 # 80008198 <etext+0x198>
    80000f48:	00005097          	auipc	ra,0x5
    80000f4c:	21a080e7          	jalr	538(ra) # 80006162 <printf>
  int last = 0;
  for (int i = 511; i >= 0; --i){
    80000f50:	6705                	lui	a4,0x1
    80000f52:	1761                	addi	a4,a4,-8
    80000f54:	9726                	add	a4,a4,s1
    80000f56:	1ff00613          	li	a2,511
    80000f5a:	56fd                	li	a3,-1
    pte_t *pte = &pagetable[i];
    if (*pte & PTE_V){
    80000f5c:	631c                	ld	a5,0(a4)
    80000f5e:	8b85                	andi	a5,a5,1
    80000f60:	e791                	bnez	a5,80000f6c <vmprint+0x3a>
  for (int i = 511; i >= 0; --i){
    80000f62:	367d                	addiw	a2,a2,-1
    80000f64:	1761                	addi	a4,a4,-8
    80000f66:	fed61be3          	bne	a2,a3,80000f5c <vmprint+0x2a>
  int last = 0;
    80000f6a:	4601                	li	a2,0
      last = i;
      break;
    }
  }
  dfs(pagetable, 2, last, -1, 0);
    80000f6c:	4701                	li	a4,0
    80000f6e:	56fd                	li	a3,-1
    80000f70:	4589                	li	a1,2
    80000f72:	8526                	mv	a0,s1
    80000f74:	00000097          	auipc	ra,0x0
    80000f78:	e22080e7          	jalr	-478(ra) # 80000d96 <dfs>
}
    80000f7c:	60e2                	ld	ra,24(sp)
    80000f7e:	6442                	ld	s0,16(sp)
    80000f80:	64a2                	ld	s1,8(sp)
    80000f82:	6105                	addi	sp,sp,32
    80000f84:	8082                	ret

0000000080000f86 <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000f86:	7139                	addi	sp,sp,-64
    80000f88:	fc06                	sd	ra,56(sp)
    80000f8a:	f822                	sd	s0,48(sp)
    80000f8c:	f426                	sd	s1,40(sp)
    80000f8e:	f04a                	sd	s2,32(sp)
    80000f90:	ec4e                	sd	s3,24(sp)
    80000f92:	e852                	sd	s4,16(sp)
    80000f94:	e456                	sd	s5,8(sp)
    80000f96:	e05a                	sd	s6,0(sp)
    80000f98:	0080                	addi	s0,sp,64
    80000f9a:	89aa                	mv	s3,a0
  struct proc *p;
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f9c:	00008497          	auipc	s1,0x8
    80000fa0:	4e448493          	addi	s1,s1,1252 # 80009480 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000fa4:	8b26                	mv	s6,s1
    80000fa6:	00007a97          	auipc	s5,0x7
    80000faa:	05aa8a93          	addi	s5,s5,90 # 80008000 <etext>
    80000fae:	01000937          	lui	s2,0x1000
    80000fb2:	197d                	addi	s2,s2,-1
    80000fb4:	093a                	slli	s2,s2,0xe
  for(p = proc; p < &proc[NPROC]; p++) {
    80000fb6:	0000ea17          	auipc	s4,0xe
    80000fba:	ecaa0a13          	addi	s4,s4,-310 # 8000ee80 <tickslock>
    char *pa = kalloc();
    80000fbe:	fffff097          	auipc	ra,0xfffff
    80000fc2:	15a080e7          	jalr	346(ra) # 80000118 <kalloc>
    80000fc6:	862a                	mv	a2,a0
    if(pa == 0)
    80000fc8:	c129                	beqz	a0,8000100a <proc_mapstacks+0x84>
    uint64 va = KSTACK((int) (p - proc));
    80000fca:	416485b3          	sub	a1,s1,s6
    80000fce:	858d                	srai	a1,a1,0x3
    80000fd0:	000ab783          	ld	a5,0(s5)
    80000fd4:	02f585b3          	mul	a1,a1,a5
    80000fd8:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000fdc:	4719                	li	a4,6
    80000fde:	6685                	lui	a3,0x1
    80000fe0:	40b905b3          	sub	a1,s2,a1
    80000fe4:	854e                	mv	a0,s3
    80000fe6:	fffff097          	auipc	ra,0xfffff
    80000fea:	602080e7          	jalr	1538(ra) # 800005e8 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000fee:	16848493          	addi	s1,s1,360
    80000ff2:	fd4496e3          	bne	s1,s4,80000fbe <proc_mapstacks+0x38>
  }
}
    80000ff6:	70e2                	ld	ra,56(sp)
    80000ff8:	7442                	ld	s0,48(sp)
    80000ffa:	74a2                	ld	s1,40(sp)
    80000ffc:	7902                	ld	s2,32(sp)
    80000ffe:	69e2                	ld	s3,24(sp)
    80001000:	6a42                	ld	s4,16(sp)
    80001002:	6aa2                	ld	s5,8(sp)
    80001004:	6b02                	ld	s6,0(sp)
    80001006:	6121                	addi	sp,sp,64
    80001008:	8082                	ret
      panic("kalloc");
    8000100a:	00007517          	auipc	a0,0x7
    8000100e:	19e50513          	addi	a0,a0,414 # 800081a8 <etext+0x1a8>
    80001012:	00005097          	auipc	ra,0x5
    80001016:	106080e7          	jalr	262(ra) # 80006118 <panic>

000000008000101a <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    8000101a:	7139                	addi	sp,sp,-64
    8000101c:	fc06                	sd	ra,56(sp)
    8000101e:	f822                	sd	s0,48(sp)
    80001020:	f426                	sd	s1,40(sp)
    80001022:	f04a                	sd	s2,32(sp)
    80001024:	ec4e                	sd	s3,24(sp)
    80001026:	e852                	sd	s4,16(sp)
    80001028:	e456                	sd	s5,8(sp)
    8000102a:	e05a                	sd	s6,0(sp)
    8000102c:	0080                	addi	s0,sp,64
  struct proc *p;
  initlock(&pid_lock, "nextpid");
    8000102e:	00007597          	auipc	a1,0x7
    80001032:	18258593          	addi	a1,a1,386 # 800081b0 <etext+0x1b0>
    80001036:	00008517          	auipc	a0,0x8
    8000103a:	01a50513          	addi	a0,a0,26 # 80009050 <pid_lock>
    8000103e:	00005097          	auipc	ra,0x5
    80001042:	594080e7          	jalr	1428(ra) # 800065d2 <initlock>
  initlock(&wait_lock, "wait_lock");
    80001046:	00007597          	auipc	a1,0x7
    8000104a:	17258593          	addi	a1,a1,370 # 800081b8 <etext+0x1b8>
    8000104e:	00008517          	auipc	a0,0x8
    80001052:	01a50513          	addi	a0,a0,26 # 80009068 <wait_lock>
    80001056:	00005097          	auipc	ra,0x5
    8000105a:	57c080e7          	jalr	1404(ra) # 800065d2 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000105e:	00008497          	auipc	s1,0x8
    80001062:	42248493          	addi	s1,s1,1058 # 80009480 <proc>
      initlock(&p->lock, "proc");
    80001066:	00007b17          	auipc	s6,0x7
    8000106a:	162b0b13          	addi	s6,s6,354 # 800081c8 <etext+0x1c8>
      p->kstack = KSTACK((int) (p - proc));
    8000106e:	8aa6                	mv	s5,s1
    80001070:	00007a17          	auipc	s4,0x7
    80001074:	f90a0a13          	addi	s4,s4,-112 # 80008000 <etext>
    80001078:	01000937          	lui	s2,0x1000
    8000107c:	197d                	addi	s2,s2,-1
    8000107e:	093a                	slli	s2,s2,0xe
  for(p = proc; p < &proc[NPROC]; p++) {
    80001080:	0000e997          	auipc	s3,0xe
    80001084:	e0098993          	addi	s3,s3,-512 # 8000ee80 <tickslock>
      initlock(&p->lock, "proc");
    80001088:	85da                	mv	a1,s6
    8000108a:	8526                	mv	a0,s1
    8000108c:	00005097          	auipc	ra,0x5
    80001090:	546080e7          	jalr	1350(ra) # 800065d2 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80001094:	415487b3          	sub	a5,s1,s5
    80001098:	878d                	srai	a5,a5,0x3
    8000109a:	000a3703          	ld	a4,0(s4)
    8000109e:	02e787b3          	mul	a5,a5,a4
    800010a2:	00d7979b          	slliw	a5,a5,0xd
    800010a6:	40f907b3          	sub	a5,s2,a5
    800010aa:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    800010ac:	16848493          	addi	s1,s1,360
    800010b0:	fd349ce3          	bne	s1,s3,80001088 <procinit+0x6e>
  }
}
    800010b4:	70e2                	ld	ra,56(sp)
    800010b6:	7442                	ld	s0,48(sp)
    800010b8:	74a2                	ld	s1,40(sp)
    800010ba:	7902                	ld	s2,32(sp)
    800010bc:	69e2                	ld	s3,24(sp)
    800010be:	6a42                	ld	s4,16(sp)
    800010c0:	6aa2                	ld	s5,8(sp)
    800010c2:	6b02                	ld	s6,0(sp)
    800010c4:	6121                	addi	sp,sp,64
    800010c6:	8082                	ret

00000000800010c8 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    800010c8:	1141                	addi	sp,sp,-16
    800010ca:	e422                	sd	s0,8(sp)
    800010cc:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    800010ce:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    800010d0:	2501                	sext.w	a0,a0
    800010d2:	6422                	ld	s0,8(sp)
    800010d4:	0141                	addi	sp,sp,16
    800010d6:	8082                	ret

00000000800010d8 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    800010d8:	1141                	addi	sp,sp,-16
    800010da:	e422                	sd	s0,8(sp)
    800010dc:	0800                	addi	s0,sp,16
    800010de:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    800010e0:	2781                	sext.w	a5,a5
    800010e2:	079e                	slli	a5,a5,0x7
  return c;
}
    800010e4:	00008517          	auipc	a0,0x8
    800010e8:	f9c50513          	addi	a0,a0,-100 # 80009080 <cpus>
    800010ec:	953e                	add	a0,a0,a5
    800010ee:	6422                	ld	s0,8(sp)
    800010f0:	0141                	addi	sp,sp,16
    800010f2:	8082                	ret

00000000800010f4 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    800010f4:	1101                	addi	sp,sp,-32
    800010f6:	ec06                	sd	ra,24(sp)
    800010f8:	e822                	sd	s0,16(sp)
    800010fa:	e426                	sd	s1,8(sp)
    800010fc:	1000                	addi	s0,sp,32
  push_off();
    800010fe:	00005097          	auipc	ra,0x5
    80001102:	518080e7          	jalr	1304(ra) # 80006616 <push_off>
    80001106:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80001108:	2781                	sext.w	a5,a5
    8000110a:	079e                	slli	a5,a5,0x7
    8000110c:	00008717          	auipc	a4,0x8
    80001110:	f4470713          	addi	a4,a4,-188 # 80009050 <pid_lock>
    80001114:	97ba                	add	a5,a5,a4
    80001116:	7b84                	ld	s1,48(a5)
  pop_off();
    80001118:	00005097          	auipc	ra,0x5
    8000111c:	59e080e7          	jalr	1438(ra) # 800066b6 <pop_off>
  return p;
}
    80001120:	8526                	mv	a0,s1
    80001122:	60e2                	ld	ra,24(sp)
    80001124:	6442                	ld	s0,16(sp)
    80001126:	64a2                	ld	s1,8(sp)
    80001128:	6105                	addi	sp,sp,32
    8000112a:	8082                	ret

000000008000112c <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    8000112c:	1141                	addi	sp,sp,-16
    8000112e:	e406                	sd	ra,8(sp)
    80001130:	e022                	sd	s0,0(sp)
    80001132:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80001134:	00000097          	auipc	ra,0x0
    80001138:	fc0080e7          	jalr	-64(ra) # 800010f4 <myproc>
    8000113c:	00005097          	auipc	ra,0x5
    80001140:	5da080e7          	jalr	1498(ra) # 80006716 <release>

  if (first) {
    80001144:	00008797          	auipc	a5,0x8
    80001148:	82c7a783          	lw	a5,-2004(a5) # 80008970 <first.1768>
    8000114c:	eb89                	bnez	a5,8000115e <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    8000114e:	00001097          	auipc	ra,0x1
    80001152:	c0a080e7          	jalr	-1014(ra) # 80001d58 <usertrapret>
}
    80001156:	60a2                	ld	ra,8(sp)
    80001158:	6402                	ld	s0,0(sp)
    8000115a:	0141                	addi	sp,sp,16
    8000115c:	8082                	ret
    first = 0;
    8000115e:	00008797          	auipc	a5,0x8
    80001162:	8007a923          	sw	zero,-2030(a5) # 80008970 <first.1768>
    fsinit(ROOTDEV);
    80001166:	4505                	li	a0,1
    80001168:	00002097          	auipc	ra,0x2
    8000116c:	a0c080e7          	jalr	-1524(ra) # 80002b74 <fsinit>
    80001170:	bff9                	j	8000114e <forkret+0x22>

0000000080001172 <allocpid>:
allocpid() {
    80001172:	1101                	addi	sp,sp,-32
    80001174:	ec06                	sd	ra,24(sp)
    80001176:	e822                	sd	s0,16(sp)
    80001178:	e426                	sd	s1,8(sp)
    8000117a:	e04a                	sd	s2,0(sp)
    8000117c:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    8000117e:	00008917          	auipc	s2,0x8
    80001182:	ed290913          	addi	s2,s2,-302 # 80009050 <pid_lock>
    80001186:	854a                	mv	a0,s2
    80001188:	00005097          	auipc	ra,0x5
    8000118c:	4da080e7          	jalr	1242(ra) # 80006662 <acquire>
  pid = nextpid;
    80001190:	00007797          	auipc	a5,0x7
    80001194:	7e478793          	addi	a5,a5,2020 # 80008974 <nextpid>
    80001198:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    8000119a:	0014871b          	addiw	a4,s1,1
    8000119e:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    800011a0:	854a                	mv	a0,s2
    800011a2:	00005097          	auipc	ra,0x5
    800011a6:	574080e7          	jalr	1396(ra) # 80006716 <release>
}
    800011aa:	8526                	mv	a0,s1
    800011ac:	60e2                	ld	ra,24(sp)
    800011ae:	6442                	ld	s0,16(sp)
    800011b0:	64a2                	ld	s1,8(sp)
    800011b2:	6902                	ld	s2,0(sp)
    800011b4:	6105                	addi	sp,sp,32
    800011b6:	8082                	ret

00000000800011b8 <proc_pagetable>:
{
    800011b8:	1101                	addi	sp,sp,-32
    800011ba:	ec06                	sd	ra,24(sp)
    800011bc:	e822                	sd	s0,16(sp)
    800011be:	e426                	sd	s1,8(sp)
    800011c0:	e04a                	sd	s2,0(sp)
    800011c2:	1000                	addi	s0,sp,32
    800011c4:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    800011c6:	fffff097          	auipc	ra,0xfffff
    800011ca:	604080e7          	jalr	1540(ra) # 800007ca <uvmcreate>
    800011ce:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800011d0:	c121                	beqz	a0,80001210 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    800011d2:	4729                	li	a4,10
    800011d4:	00006697          	auipc	a3,0x6
    800011d8:	e2c68693          	addi	a3,a3,-468 # 80007000 <_trampoline>
    800011dc:	6605                	lui	a2,0x1
    800011de:	040005b7          	lui	a1,0x4000
    800011e2:	15fd                	addi	a1,a1,-1
    800011e4:	05b2                	slli	a1,a1,0xc
    800011e6:	fffff097          	auipc	ra,0xfffff
    800011ea:	362080e7          	jalr	866(ra) # 80000548 <mappages>
    800011ee:	02054863          	bltz	a0,8000121e <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    800011f2:	4719                	li	a4,6
    800011f4:	05893683          	ld	a3,88(s2)
    800011f8:	6605                	lui	a2,0x1
    800011fa:	020005b7          	lui	a1,0x2000
    800011fe:	15fd                	addi	a1,a1,-1
    80001200:	05b6                	slli	a1,a1,0xd
    80001202:	8526                	mv	a0,s1
    80001204:	fffff097          	auipc	ra,0xfffff
    80001208:	344080e7          	jalr	836(ra) # 80000548 <mappages>
    8000120c:	02054163          	bltz	a0,8000122e <proc_pagetable+0x76>
}
    80001210:	8526                	mv	a0,s1
    80001212:	60e2                	ld	ra,24(sp)
    80001214:	6442                	ld	s0,16(sp)
    80001216:	64a2                	ld	s1,8(sp)
    80001218:	6902                	ld	s2,0(sp)
    8000121a:	6105                	addi	sp,sp,32
    8000121c:	8082                	ret
    uvmfree(pagetable, 0);
    8000121e:	4581                	li	a1,0
    80001220:	8526                	mv	a0,s1
    80001222:	fffff097          	auipc	ra,0xfffff
    80001226:	7a4080e7          	jalr	1956(ra) # 800009c6 <uvmfree>
    return 0;
    8000122a:	4481                	li	s1,0
    8000122c:	b7d5                	j	80001210 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    8000122e:	4681                	li	a3,0
    80001230:	4605                	li	a2,1
    80001232:	040005b7          	lui	a1,0x4000
    80001236:	15fd                	addi	a1,a1,-1
    80001238:	05b2                	slli	a1,a1,0xc
    8000123a:	8526                	mv	a0,s1
    8000123c:	fffff097          	auipc	ra,0xfffff
    80001240:	4d2080e7          	jalr	1234(ra) # 8000070e <uvmunmap>
    uvmfree(pagetable, 0);
    80001244:	4581                	li	a1,0
    80001246:	8526                	mv	a0,s1
    80001248:	fffff097          	auipc	ra,0xfffff
    8000124c:	77e080e7          	jalr	1918(ra) # 800009c6 <uvmfree>
    return 0;
    80001250:	4481                	li	s1,0
    80001252:	bf7d                	j	80001210 <proc_pagetable+0x58>

0000000080001254 <proc_freepagetable>:
{
    80001254:	1101                	addi	sp,sp,-32
    80001256:	ec06                	sd	ra,24(sp)
    80001258:	e822                	sd	s0,16(sp)
    8000125a:	e426                	sd	s1,8(sp)
    8000125c:	e04a                	sd	s2,0(sp)
    8000125e:	1000                	addi	s0,sp,32
    80001260:	84aa                	mv	s1,a0
    80001262:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001264:	4681                	li	a3,0
    80001266:	4605                	li	a2,1
    80001268:	040005b7          	lui	a1,0x4000
    8000126c:	15fd                	addi	a1,a1,-1
    8000126e:	05b2                	slli	a1,a1,0xc
    80001270:	fffff097          	auipc	ra,0xfffff
    80001274:	49e080e7          	jalr	1182(ra) # 8000070e <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001278:	4681                	li	a3,0
    8000127a:	4605                	li	a2,1
    8000127c:	020005b7          	lui	a1,0x2000
    80001280:	15fd                	addi	a1,a1,-1
    80001282:	05b6                	slli	a1,a1,0xd
    80001284:	8526                	mv	a0,s1
    80001286:	fffff097          	auipc	ra,0xfffff
    8000128a:	488080e7          	jalr	1160(ra) # 8000070e <uvmunmap>
  uvmfree(pagetable, sz);
    8000128e:	85ca                	mv	a1,s2
    80001290:	8526                	mv	a0,s1
    80001292:	fffff097          	auipc	ra,0xfffff
    80001296:	734080e7          	jalr	1844(ra) # 800009c6 <uvmfree>
}
    8000129a:	60e2                	ld	ra,24(sp)
    8000129c:	6442                	ld	s0,16(sp)
    8000129e:	64a2                	ld	s1,8(sp)
    800012a0:	6902                	ld	s2,0(sp)
    800012a2:	6105                	addi	sp,sp,32
    800012a4:	8082                	ret

00000000800012a6 <freeproc>:
{
    800012a6:	1101                	addi	sp,sp,-32
    800012a8:	ec06                	sd	ra,24(sp)
    800012aa:	e822                	sd	s0,16(sp)
    800012ac:	e426                	sd	s1,8(sp)
    800012ae:	1000                	addi	s0,sp,32
    800012b0:	84aa                	mv	s1,a0
  if(p->trapframe)
    800012b2:	6d28                	ld	a0,88(a0)
    800012b4:	c509                	beqz	a0,800012be <freeproc+0x18>
    kfree((void*)p->trapframe);
    800012b6:	fffff097          	auipc	ra,0xfffff
    800012ba:	d66080e7          	jalr	-666(ra) # 8000001c <kfree>
  p->trapframe = 0;
    800012be:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    800012c2:	68a8                	ld	a0,80(s1)
    800012c4:	c511                	beqz	a0,800012d0 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    800012c6:	64ac                	ld	a1,72(s1)
    800012c8:	00000097          	auipc	ra,0x0
    800012cc:	f8c080e7          	jalr	-116(ra) # 80001254 <proc_freepagetable>
  p->pagetable = 0;
    800012d0:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    800012d4:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    800012d8:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    800012dc:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    800012e0:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    800012e4:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    800012e8:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    800012ec:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    800012f0:	0004ac23          	sw	zero,24(s1)
}
    800012f4:	60e2                	ld	ra,24(sp)
    800012f6:	6442                	ld	s0,16(sp)
    800012f8:	64a2                	ld	s1,8(sp)
    800012fa:	6105                	addi	sp,sp,32
    800012fc:	8082                	ret

00000000800012fe <allocproc>:
{
    800012fe:	1101                	addi	sp,sp,-32
    80001300:	ec06                	sd	ra,24(sp)
    80001302:	e822                	sd	s0,16(sp)
    80001304:	e426                	sd	s1,8(sp)
    80001306:	e04a                	sd	s2,0(sp)
    80001308:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    8000130a:	00008497          	auipc	s1,0x8
    8000130e:	17648493          	addi	s1,s1,374 # 80009480 <proc>
    80001312:	0000e917          	auipc	s2,0xe
    80001316:	b6e90913          	addi	s2,s2,-1170 # 8000ee80 <tickslock>
    acquire(&p->lock);
    8000131a:	8526                	mv	a0,s1
    8000131c:	00005097          	auipc	ra,0x5
    80001320:	346080e7          	jalr	838(ra) # 80006662 <acquire>
    if(p->state == UNUSED) {
    80001324:	4c9c                	lw	a5,24(s1)
    80001326:	cf81                	beqz	a5,8000133e <allocproc+0x40>
      release(&p->lock);
    80001328:	8526                	mv	a0,s1
    8000132a:	00005097          	auipc	ra,0x5
    8000132e:	3ec080e7          	jalr	1004(ra) # 80006716 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001332:	16848493          	addi	s1,s1,360
    80001336:	ff2492e3          	bne	s1,s2,8000131a <allocproc+0x1c>
  return 0;
    8000133a:	4481                	li	s1,0
    8000133c:	a889                	j	8000138e <allocproc+0x90>
  p->pid = allocpid();
    8000133e:	00000097          	auipc	ra,0x0
    80001342:	e34080e7          	jalr	-460(ra) # 80001172 <allocpid>
    80001346:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001348:	4785                	li	a5,1
    8000134a:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    8000134c:	fffff097          	auipc	ra,0xfffff
    80001350:	dcc080e7          	jalr	-564(ra) # 80000118 <kalloc>
    80001354:	892a                	mv	s2,a0
    80001356:	eca8                	sd	a0,88(s1)
    80001358:	c131                	beqz	a0,8000139c <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    8000135a:	8526                	mv	a0,s1
    8000135c:	00000097          	auipc	ra,0x0
    80001360:	e5c080e7          	jalr	-420(ra) # 800011b8 <proc_pagetable>
    80001364:	892a                	mv	s2,a0
    80001366:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001368:	c531                	beqz	a0,800013b4 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    8000136a:	07000613          	li	a2,112
    8000136e:	4581                	li	a1,0
    80001370:	06048513          	addi	a0,s1,96
    80001374:	fffff097          	auipc	ra,0xfffff
    80001378:	e04080e7          	jalr	-508(ra) # 80000178 <memset>
  p->context.ra = (uint64)forkret;
    8000137c:	00000797          	auipc	a5,0x0
    80001380:	db078793          	addi	a5,a5,-592 # 8000112c <forkret>
    80001384:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001386:	60bc                	ld	a5,64(s1)
    80001388:	6705                	lui	a4,0x1
    8000138a:	97ba                	add	a5,a5,a4
    8000138c:	f4bc                	sd	a5,104(s1)
}
    8000138e:	8526                	mv	a0,s1
    80001390:	60e2                	ld	ra,24(sp)
    80001392:	6442                	ld	s0,16(sp)
    80001394:	64a2                	ld	s1,8(sp)
    80001396:	6902                	ld	s2,0(sp)
    80001398:	6105                	addi	sp,sp,32
    8000139a:	8082                	ret
    freeproc(p);
    8000139c:	8526                	mv	a0,s1
    8000139e:	00000097          	auipc	ra,0x0
    800013a2:	f08080e7          	jalr	-248(ra) # 800012a6 <freeproc>
    release(&p->lock);
    800013a6:	8526                	mv	a0,s1
    800013a8:	00005097          	auipc	ra,0x5
    800013ac:	36e080e7          	jalr	878(ra) # 80006716 <release>
    return 0;
    800013b0:	84ca                	mv	s1,s2
    800013b2:	bff1                	j	8000138e <allocproc+0x90>
    freeproc(p);
    800013b4:	8526                	mv	a0,s1
    800013b6:	00000097          	auipc	ra,0x0
    800013ba:	ef0080e7          	jalr	-272(ra) # 800012a6 <freeproc>
    release(&p->lock);
    800013be:	8526                	mv	a0,s1
    800013c0:	00005097          	auipc	ra,0x5
    800013c4:	356080e7          	jalr	854(ra) # 80006716 <release>
    return 0;
    800013c8:	84ca                	mv	s1,s2
    800013ca:	b7d1                	j	8000138e <allocproc+0x90>

00000000800013cc <userinit>:
{
    800013cc:	1101                	addi	sp,sp,-32
    800013ce:	ec06                	sd	ra,24(sp)
    800013d0:	e822                	sd	s0,16(sp)
    800013d2:	e426                	sd	s1,8(sp)
    800013d4:	1000                	addi	s0,sp,32
  p = allocproc();
    800013d6:	00000097          	auipc	ra,0x0
    800013da:	f28080e7          	jalr	-216(ra) # 800012fe <allocproc>
    800013de:	84aa                	mv	s1,a0
  initproc = p;
    800013e0:	00008797          	auipc	a5,0x8
    800013e4:	c2a7b823          	sd	a0,-976(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    800013e8:	03400613          	li	a2,52
    800013ec:	00007597          	auipc	a1,0x7
    800013f0:	59458593          	addi	a1,a1,1428 # 80008980 <initcode>
    800013f4:	6928                	ld	a0,80(a0)
    800013f6:	fffff097          	auipc	ra,0xfffff
    800013fa:	402080e7          	jalr	1026(ra) # 800007f8 <uvminit>
  p->sz = PGSIZE;
    800013fe:	6785                	lui	a5,0x1
    80001400:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001402:	6cb8                	ld	a4,88(s1)
    80001404:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001408:	6cb8                	ld	a4,88(s1)
    8000140a:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    8000140c:	4641                	li	a2,16
    8000140e:	00007597          	auipc	a1,0x7
    80001412:	dc258593          	addi	a1,a1,-574 # 800081d0 <etext+0x1d0>
    80001416:	15848513          	addi	a0,s1,344
    8000141a:	fffff097          	auipc	ra,0xfffff
    8000141e:	eb0080e7          	jalr	-336(ra) # 800002ca <safestrcpy>
  p->cwd = namei("/");
    80001422:	00007517          	auipc	a0,0x7
    80001426:	dbe50513          	addi	a0,a0,-578 # 800081e0 <etext+0x1e0>
    8000142a:	00002097          	auipc	ra,0x2
    8000142e:	15c080e7          	jalr	348(ra) # 80003586 <namei>
    80001432:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001436:	478d                	li	a5,3
    80001438:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    8000143a:	8526                	mv	a0,s1
    8000143c:	00005097          	auipc	ra,0x5
    80001440:	2da080e7          	jalr	730(ra) # 80006716 <release>
}
    80001444:	60e2                	ld	ra,24(sp)
    80001446:	6442                	ld	s0,16(sp)
    80001448:	64a2                	ld	s1,8(sp)
    8000144a:	6105                	addi	sp,sp,32
    8000144c:	8082                	ret

000000008000144e <growproc>:
{
    8000144e:	1101                	addi	sp,sp,-32
    80001450:	ec06                	sd	ra,24(sp)
    80001452:	e822                	sd	s0,16(sp)
    80001454:	e426                	sd	s1,8(sp)
    80001456:	e04a                	sd	s2,0(sp)
    80001458:	1000                	addi	s0,sp,32
    8000145a:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    8000145c:	00000097          	auipc	ra,0x0
    80001460:	c98080e7          	jalr	-872(ra) # 800010f4 <myproc>
    80001464:	892a                	mv	s2,a0
  sz = p->sz;
    80001466:	652c                	ld	a1,72(a0)
    80001468:	0005861b          	sext.w	a2,a1
  if(n > 0){
    8000146c:	00904f63          	bgtz	s1,8000148a <growproc+0x3c>
  } else if(n < 0){
    80001470:	0204cc63          	bltz	s1,800014a8 <growproc+0x5a>
  p->sz = sz;
    80001474:	1602                	slli	a2,a2,0x20
    80001476:	9201                	srli	a2,a2,0x20
    80001478:	04c93423          	sd	a2,72(s2)
  return 0;
    8000147c:	4501                	li	a0,0
}
    8000147e:	60e2                	ld	ra,24(sp)
    80001480:	6442                	ld	s0,16(sp)
    80001482:	64a2                	ld	s1,8(sp)
    80001484:	6902                	ld	s2,0(sp)
    80001486:	6105                	addi	sp,sp,32
    80001488:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    8000148a:	9e25                	addw	a2,a2,s1
    8000148c:	1602                	slli	a2,a2,0x20
    8000148e:	9201                	srli	a2,a2,0x20
    80001490:	1582                	slli	a1,a1,0x20
    80001492:	9181                	srli	a1,a1,0x20
    80001494:	6928                	ld	a0,80(a0)
    80001496:	fffff097          	auipc	ra,0xfffff
    8000149a:	41c080e7          	jalr	1052(ra) # 800008b2 <uvmalloc>
    8000149e:	0005061b          	sext.w	a2,a0
    800014a2:	fa69                	bnez	a2,80001474 <growproc+0x26>
      return -1;
    800014a4:	557d                	li	a0,-1
    800014a6:	bfe1                	j	8000147e <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800014a8:	9e25                	addw	a2,a2,s1
    800014aa:	1602                	slli	a2,a2,0x20
    800014ac:	9201                	srli	a2,a2,0x20
    800014ae:	1582                	slli	a1,a1,0x20
    800014b0:	9181                	srli	a1,a1,0x20
    800014b2:	6928                	ld	a0,80(a0)
    800014b4:	fffff097          	auipc	ra,0xfffff
    800014b8:	3b6080e7          	jalr	950(ra) # 8000086a <uvmdealloc>
    800014bc:	0005061b          	sext.w	a2,a0
    800014c0:	bf55                	j	80001474 <growproc+0x26>

00000000800014c2 <fork>:
{
    800014c2:	7179                	addi	sp,sp,-48
    800014c4:	f406                	sd	ra,40(sp)
    800014c6:	f022                	sd	s0,32(sp)
    800014c8:	ec26                	sd	s1,24(sp)
    800014ca:	e84a                	sd	s2,16(sp)
    800014cc:	e44e                	sd	s3,8(sp)
    800014ce:	e052                	sd	s4,0(sp)
    800014d0:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800014d2:	00000097          	auipc	ra,0x0
    800014d6:	c22080e7          	jalr	-990(ra) # 800010f4 <myproc>
    800014da:	892a                	mv	s2,a0
  if((np = allocproc()) == 0){
    800014dc:	00000097          	auipc	ra,0x0
    800014e0:	e22080e7          	jalr	-478(ra) # 800012fe <allocproc>
    800014e4:	10050b63          	beqz	a0,800015fa <fork+0x138>
    800014e8:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    800014ea:	04893603          	ld	a2,72(s2)
    800014ee:	692c                	ld	a1,80(a0)
    800014f0:	05093503          	ld	a0,80(s2)
    800014f4:	fffff097          	auipc	ra,0xfffff
    800014f8:	50a080e7          	jalr	1290(ra) # 800009fe <uvmcopy>
    800014fc:	04054663          	bltz	a0,80001548 <fork+0x86>
  np->sz = p->sz;
    80001500:	04893783          	ld	a5,72(s2)
    80001504:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    80001508:	05893683          	ld	a3,88(s2)
    8000150c:	87b6                	mv	a5,a3
    8000150e:	0589b703          	ld	a4,88(s3)
    80001512:	12068693          	addi	a3,a3,288
    80001516:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    8000151a:	6788                	ld	a0,8(a5)
    8000151c:	6b8c                	ld	a1,16(a5)
    8000151e:	6f90                	ld	a2,24(a5)
    80001520:	01073023          	sd	a6,0(a4)
    80001524:	e708                	sd	a0,8(a4)
    80001526:	eb0c                	sd	a1,16(a4)
    80001528:	ef10                	sd	a2,24(a4)
    8000152a:	02078793          	addi	a5,a5,32
    8000152e:	02070713          	addi	a4,a4,32
    80001532:	fed792e3          	bne	a5,a3,80001516 <fork+0x54>
  np->trapframe->a0 = 0;
    80001536:	0589b783          	ld	a5,88(s3)
    8000153a:	0607b823          	sd	zero,112(a5)
    8000153e:	0d000493          	li	s1,208
  for(i = 0; i < NOFILE; i++)
    80001542:	15000a13          	li	s4,336
    80001546:	a03d                	j	80001574 <fork+0xb2>
    freeproc(np);
    80001548:	854e                	mv	a0,s3
    8000154a:	00000097          	auipc	ra,0x0
    8000154e:	d5c080e7          	jalr	-676(ra) # 800012a6 <freeproc>
    release(&np->lock);
    80001552:	854e                	mv	a0,s3
    80001554:	00005097          	auipc	ra,0x5
    80001558:	1c2080e7          	jalr	450(ra) # 80006716 <release>
    return -1;
    8000155c:	5a7d                	li	s4,-1
    8000155e:	a069                	j	800015e8 <fork+0x126>
      np->ofile[i] = filedup(p->ofile[i]);
    80001560:	00003097          	auipc	ra,0x3
    80001564:	84e080e7          	jalr	-1970(ra) # 80003dae <filedup>
    80001568:	009987b3          	add	a5,s3,s1
    8000156c:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    8000156e:	04a1                	addi	s1,s1,8
    80001570:	01448763          	beq	s1,s4,8000157e <fork+0xbc>
    if(p->ofile[i])
    80001574:	009907b3          	add	a5,s2,s1
    80001578:	6388                	ld	a0,0(a5)
    8000157a:	f17d                	bnez	a0,80001560 <fork+0x9e>
    8000157c:	bfcd                	j	8000156e <fork+0xac>
  np->cwd = idup(p->cwd);
    8000157e:	15093503          	ld	a0,336(s2)
    80001582:	00002097          	auipc	ra,0x2
    80001586:	81a080e7          	jalr	-2022(ra) # 80002d9c <idup>
    8000158a:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    8000158e:	4641                	li	a2,16
    80001590:	15890593          	addi	a1,s2,344
    80001594:	15898513          	addi	a0,s3,344
    80001598:	fffff097          	auipc	ra,0xfffff
    8000159c:	d32080e7          	jalr	-718(ra) # 800002ca <safestrcpy>
  pid = np->pid;
    800015a0:	0309aa03          	lw	s4,48(s3)
  release(&np->lock);
    800015a4:	854e                	mv	a0,s3
    800015a6:	00005097          	auipc	ra,0x5
    800015aa:	170080e7          	jalr	368(ra) # 80006716 <release>
  acquire(&wait_lock);
    800015ae:	00008497          	auipc	s1,0x8
    800015b2:	aba48493          	addi	s1,s1,-1350 # 80009068 <wait_lock>
    800015b6:	8526                	mv	a0,s1
    800015b8:	00005097          	auipc	ra,0x5
    800015bc:	0aa080e7          	jalr	170(ra) # 80006662 <acquire>
  np->parent = p;
    800015c0:	0329bc23          	sd	s2,56(s3)
  release(&wait_lock);
    800015c4:	8526                	mv	a0,s1
    800015c6:	00005097          	auipc	ra,0x5
    800015ca:	150080e7          	jalr	336(ra) # 80006716 <release>
  acquire(&np->lock);
    800015ce:	854e                	mv	a0,s3
    800015d0:	00005097          	auipc	ra,0x5
    800015d4:	092080e7          	jalr	146(ra) # 80006662 <acquire>
  np->state = RUNNABLE;
    800015d8:	478d                	li	a5,3
    800015da:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    800015de:	854e                	mv	a0,s3
    800015e0:	00005097          	auipc	ra,0x5
    800015e4:	136080e7          	jalr	310(ra) # 80006716 <release>
}
    800015e8:	8552                	mv	a0,s4
    800015ea:	70a2                	ld	ra,40(sp)
    800015ec:	7402                	ld	s0,32(sp)
    800015ee:	64e2                	ld	s1,24(sp)
    800015f0:	6942                	ld	s2,16(sp)
    800015f2:	69a2                	ld	s3,8(sp)
    800015f4:	6a02                	ld	s4,0(sp)
    800015f6:	6145                	addi	sp,sp,48
    800015f8:	8082                	ret
    return -1;
    800015fa:	5a7d                	li	s4,-1
    800015fc:	b7f5                	j	800015e8 <fork+0x126>

00000000800015fe <scheduler>:
{
    800015fe:	7139                	addi	sp,sp,-64
    80001600:	fc06                	sd	ra,56(sp)
    80001602:	f822                	sd	s0,48(sp)
    80001604:	f426                	sd	s1,40(sp)
    80001606:	f04a                	sd	s2,32(sp)
    80001608:	ec4e                	sd	s3,24(sp)
    8000160a:	e852                	sd	s4,16(sp)
    8000160c:	e456                	sd	s5,8(sp)
    8000160e:	e05a                	sd	s6,0(sp)
    80001610:	0080                	addi	s0,sp,64
    80001612:	8792                	mv	a5,tp
  int id = r_tp();
    80001614:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001616:	00779a93          	slli	s5,a5,0x7
    8000161a:	00008717          	auipc	a4,0x8
    8000161e:	a3670713          	addi	a4,a4,-1482 # 80009050 <pid_lock>
    80001622:	9756                	add	a4,a4,s5
    80001624:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001628:	00008717          	auipc	a4,0x8
    8000162c:	a6070713          	addi	a4,a4,-1440 # 80009088 <cpus+0x8>
    80001630:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    80001632:	498d                	li	s3,3
        p->state = RUNNING;
    80001634:	4b11                	li	s6,4
        c->proc = p;
    80001636:	079e                	slli	a5,a5,0x7
    80001638:	00008a17          	auipc	s4,0x8
    8000163c:	a18a0a13          	addi	s4,s4,-1512 # 80009050 <pid_lock>
    80001640:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001642:	0000e917          	auipc	s2,0xe
    80001646:	83e90913          	addi	s2,s2,-1986 # 8000ee80 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000164a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000164e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001652:	10079073          	csrw	sstatus,a5
    80001656:	00008497          	auipc	s1,0x8
    8000165a:	e2a48493          	addi	s1,s1,-470 # 80009480 <proc>
    8000165e:	a03d                	j	8000168c <scheduler+0x8e>
        p->state = RUNNING;
    80001660:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80001664:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001668:	06048593          	addi	a1,s1,96
    8000166c:	8556                	mv	a0,s5
    8000166e:	00000097          	auipc	ra,0x0
    80001672:	640080e7          	jalr	1600(ra) # 80001cae <swtch>
        c->proc = 0;
    80001676:	020a3823          	sd	zero,48(s4)
      release(&p->lock);
    8000167a:	8526                	mv	a0,s1
    8000167c:	00005097          	auipc	ra,0x5
    80001680:	09a080e7          	jalr	154(ra) # 80006716 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001684:	16848493          	addi	s1,s1,360
    80001688:	fd2481e3          	beq	s1,s2,8000164a <scheduler+0x4c>
      acquire(&p->lock);
    8000168c:	8526                	mv	a0,s1
    8000168e:	00005097          	auipc	ra,0x5
    80001692:	fd4080e7          	jalr	-44(ra) # 80006662 <acquire>
      if(p->state == RUNNABLE) {
    80001696:	4c9c                	lw	a5,24(s1)
    80001698:	ff3791e3          	bne	a5,s3,8000167a <scheduler+0x7c>
    8000169c:	b7d1                	j	80001660 <scheduler+0x62>

000000008000169e <sched>:
{
    8000169e:	7179                	addi	sp,sp,-48
    800016a0:	f406                	sd	ra,40(sp)
    800016a2:	f022                	sd	s0,32(sp)
    800016a4:	ec26                	sd	s1,24(sp)
    800016a6:	e84a                	sd	s2,16(sp)
    800016a8:	e44e                	sd	s3,8(sp)
    800016aa:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800016ac:	00000097          	auipc	ra,0x0
    800016b0:	a48080e7          	jalr	-1464(ra) # 800010f4 <myproc>
    800016b4:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    800016b6:	00005097          	auipc	ra,0x5
    800016ba:	f32080e7          	jalr	-206(ra) # 800065e8 <holding>
    800016be:	c93d                	beqz	a0,80001734 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    800016c0:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    800016c2:	2781                	sext.w	a5,a5
    800016c4:	079e                	slli	a5,a5,0x7
    800016c6:	00008717          	auipc	a4,0x8
    800016ca:	98a70713          	addi	a4,a4,-1654 # 80009050 <pid_lock>
    800016ce:	97ba                	add	a5,a5,a4
    800016d0:	0a87a703          	lw	a4,168(a5)
    800016d4:	4785                	li	a5,1
    800016d6:	06f71763          	bne	a4,a5,80001744 <sched+0xa6>
  if(p->state == RUNNING)
    800016da:	4c98                	lw	a4,24(s1)
    800016dc:	4791                	li	a5,4
    800016de:	06f70b63          	beq	a4,a5,80001754 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800016e2:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800016e6:	8b89                	andi	a5,a5,2
  if(intr_get())
    800016e8:	efb5                	bnez	a5,80001764 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    800016ea:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800016ec:	00008917          	auipc	s2,0x8
    800016f0:	96490913          	addi	s2,s2,-1692 # 80009050 <pid_lock>
    800016f4:	2781                	sext.w	a5,a5
    800016f6:	079e                	slli	a5,a5,0x7
    800016f8:	97ca                	add	a5,a5,s2
    800016fa:	0ac7a983          	lw	s3,172(a5)
    800016fe:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001700:	2781                	sext.w	a5,a5
    80001702:	079e                	slli	a5,a5,0x7
    80001704:	00008597          	auipc	a1,0x8
    80001708:	98458593          	addi	a1,a1,-1660 # 80009088 <cpus+0x8>
    8000170c:	95be                	add	a1,a1,a5
    8000170e:	06048513          	addi	a0,s1,96
    80001712:	00000097          	auipc	ra,0x0
    80001716:	59c080e7          	jalr	1436(ra) # 80001cae <swtch>
    8000171a:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    8000171c:	2781                	sext.w	a5,a5
    8000171e:	079e                	slli	a5,a5,0x7
    80001720:	97ca                	add	a5,a5,s2
    80001722:	0b37a623          	sw	s3,172(a5)
}
    80001726:	70a2                	ld	ra,40(sp)
    80001728:	7402                	ld	s0,32(sp)
    8000172a:	64e2                	ld	s1,24(sp)
    8000172c:	6942                	ld	s2,16(sp)
    8000172e:	69a2                	ld	s3,8(sp)
    80001730:	6145                	addi	sp,sp,48
    80001732:	8082                	ret
    panic("sched p->lock");
    80001734:	00007517          	auipc	a0,0x7
    80001738:	ab450513          	addi	a0,a0,-1356 # 800081e8 <etext+0x1e8>
    8000173c:	00005097          	auipc	ra,0x5
    80001740:	9dc080e7          	jalr	-1572(ra) # 80006118 <panic>
    panic("sched locks");
    80001744:	00007517          	auipc	a0,0x7
    80001748:	ab450513          	addi	a0,a0,-1356 # 800081f8 <etext+0x1f8>
    8000174c:	00005097          	auipc	ra,0x5
    80001750:	9cc080e7          	jalr	-1588(ra) # 80006118 <panic>
    panic("sched running");
    80001754:	00007517          	auipc	a0,0x7
    80001758:	ab450513          	addi	a0,a0,-1356 # 80008208 <etext+0x208>
    8000175c:	00005097          	auipc	ra,0x5
    80001760:	9bc080e7          	jalr	-1604(ra) # 80006118 <panic>
    panic("sched interruptible");
    80001764:	00007517          	auipc	a0,0x7
    80001768:	ab450513          	addi	a0,a0,-1356 # 80008218 <etext+0x218>
    8000176c:	00005097          	auipc	ra,0x5
    80001770:	9ac080e7          	jalr	-1620(ra) # 80006118 <panic>

0000000080001774 <yield>:
{
    80001774:	1101                	addi	sp,sp,-32
    80001776:	ec06                	sd	ra,24(sp)
    80001778:	e822                	sd	s0,16(sp)
    8000177a:	e426                	sd	s1,8(sp)
    8000177c:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    8000177e:	00000097          	auipc	ra,0x0
    80001782:	976080e7          	jalr	-1674(ra) # 800010f4 <myproc>
    80001786:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001788:	00005097          	auipc	ra,0x5
    8000178c:	eda080e7          	jalr	-294(ra) # 80006662 <acquire>
  p->state = RUNNABLE;
    80001790:	478d                	li	a5,3
    80001792:	cc9c                	sw	a5,24(s1)
  sched();
    80001794:	00000097          	auipc	ra,0x0
    80001798:	f0a080e7          	jalr	-246(ra) # 8000169e <sched>
  release(&p->lock);
    8000179c:	8526                	mv	a0,s1
    8000179e:	00005097          	auipc	ra,0x5
    800017a2:	f78080e7          	jalr	-136(ra) # 80006716 <release>
}
    800017a6:	60e2                	ld	ra,24(sp)
    800017a8:	6442                	ld	s0,16(sp)
    800017aa:	64a2                	ld	s1,8(sp)
    800017ac:	6105                	addi	sp,sp,32
    800017ae:	8082                	ret

00000000800017b0 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    800017b0:	7179                	addi	sp,sp,-48
    800017b2:	f406                	sd	ra,40(sp)
    800017b4:	f022                	sd	s0,32(sp)
    800017b6:	ec26                	sd	s1,24(sp)
    800017b8:	e84a                	sd	s2,16(sp)
    800017ba:	e44e                	sd	s3,8(sp)
    800017bc:	1800                	addi	s0,sp,48
    800017be:	89aa                	mv	s3,a0
    800017c0:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800017c2:	00000097          	auipc	ra,0x0
    800017c6:	932080e7          	jalr	-1742(ra) # 800010f4 <myproc>
    800017ca:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    800017cc:	00005097          	auipc	ra,0x5
    800017d0:	e96080e7          	jalr	-362(ra) # 80006662 <acquire>
  release(lk);
    800017d4:	854a                	mv	a0,s2
    800017d6:	00005097          	auipc	ra,0x5
    800017da:	f40080e7          	jalr	-192(ra) # 80006716 <release>

  // Go to sleep.
  p->chan = chan;
    800017de:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    800017e2:	4789                	li	a5,2
    800017e4:	cc9c                	sw	a5,24(s1)

  sched();
    800017e6:	00000097          	auipc	ra,0x0
    800017ea:	eb8080e7          	jalr	-328(ra) # 8000169e <sched>

  // Tidy up.
  p->chan = 0;
    800017ee:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    800017f2:	8526                	mv	a0,s1
    800017f4:	00005097          	auipc	ra,0x5
    800017f8:	f22080e7          	jalr	-222(ra) # 80006716 <release>
  acquire(lk);
    800017fc:	854a                	mv	a0,s2
    800017fe:	00005097          	auipc	ra,0x5
    80001802:	e64080e7          	jalr	-412(ra) # 80006662 <acquire>
}
    80001806:	70a2                	ld	ra,40(sp)
    80001808:	7402                	ld	s0,32(sp)
    8000180a:	64e2                	ld	s1,24(sp)
    8000180c:	6942                	ld	s2,16(sp)
    8000180e:	69a2                	ld	s3,8(sp)
    80001810:	6145                	addi	sp,sp,48
    80001812:	8082                	ret

0000000080001814 <wait>:
{
    80001814:	715d                	addi	sp,sp,-80
    80001816:	e486                	sd	ra,72(sp)
    80001818:	e0a2                	sd	s0,64(sp)
    8000181a:	fc26                	sd	s1,56(sp)
    8000181c:	f84a                	sd	s2,48(sp)
    8000181e:	f44e                	sd	s3,40(sp)
    80001820:	f052                	sd	s4,32(sp)
    80001822:	ec56                	sd	s5,24(sp)
    80001824:	e85a                	sd	s6,16(sp)
    80001826:	e45e                	sd	s7,8(sp)
    80001828:	e062                	sd	s8,0(sp)
    8000182a:	0880                	addi	s0,sp,80
    8000182c:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    8000182e:	00000097          	auipc	ra,0x0
    80001832:	8c6080e7          	jalr	-1850(ra) # 800010f4 <myproc>
    80001836:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001838:	00008517          	auipc	a0,0x8
    8000183c:	83050513          	addi	a0,a0,-2000 # 80009068 <wait_lock>
    80001840:	00005097          	auipc	ra,0x5
    80001844:	e22080e7          	jalr	-478(ra) # 80006662 <acquire>
    havekids = 0;
    80001848:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    8000184a:	4a15                	li	s4,5
    for(np = proc; np < &proc[NPROC]; np++){
    8000184c:	0000d997          	auipc	s3,0xd
    80001850:	63498993          	addi	s3,s3,1588 # 8000ee80 <tickslock>
        havekids = 1;
    80001854:	4a85                	li	s5,1
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001856:	00008c17          	auipc	s8,0x8
    8000185a:	812c0c13          	addi	s8,s8,-2030 # 80009068 <wait_lock>
    havekids = 0;
    8000185e:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    80001860:	00008497          	auipc	s1,0x8
    80001864:	c2048493          	addi	s1,s1,-992 # 80009480 <proc>
    80001868:	a0bd                	j	800018d6 <wait+0xc2>
          pid = np->pid;
    8000186a:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    8000186e:	000b0e63          	beqz	s6,8000188a <wait+0x76>
    80001872:	4691                	li	a3,4
    80001874:	02c48613          	addi	a2,s1,44
    80001878:	85da                	mv	a1,s6
    8000187a:	05093503          	ld	a0,80(s2)
    8000187e:	fffff097          	auipc	ra,0xfffff
    80001882:	284080e7          	jalr	644(ra) # 80000b02 <copyout>
    80001886:	02054563          	bltz	a0,800018b0 <wait+0x9c>
          freeproc(np);
    8000188a:	8526                	mv	a0,s1
    8000188c:	00000097          	auipc	ra,0x0
    80001890:	a1a080e7          	jalr	-1510(ra) # 800012a6 <freeproc>
          release(&np->lock);
    80001894:	8526                	mv	a0,s1
    80001896:	00005097          	auipc	ra,0x5
    8000189a:	e80080e7          	jalr	-384(ra) # 80006716 <release>
          release(&wait_lock);
    8000189e:	00007517          	auipc	a0,0x7
    800018a2:	7ca50513          	addi	a0,a0,1994 # 80009068 <wait_lock>
    800018a6:	00005097          	auipc	ra,0x5
    800018aa:	e70080e7          	jalr	-400(ra) # 80006716 <release>
          return pid;
    800018ae:	a09d                	j	80001914 <wait+0x100>
            release(&np->lock);
    800018b0:	8526                	mv	a0,s1
    800018b2:	00005097          	auipc	ra,0x5
    800018b6:	e64080e7          	jalr	-412(ra) # 80006716 <release>
            release(&wait_lock);
    800018ba:	00007517          	auipc	a0,0x7
    800018be:	7ae50513          	addi	a0,a0,1966 # 80009068 <wait_lock>
    800018c2:	00005097          	auipc	ra,0x5
    800018c6:	e54080e7          	jalr	-428(ra) # 80006716 <release>
            return -1;
    800018ca:	59fd                	li	s3,-1
    800018cc:	a0a1                	j	80001914 <wait+0x100>
    for(np = proc; np < &proc[NPROC]; np++){
    800018ce:	16848493          	addi	s1,s1,360
    800018d2:	03348463          	beq	s1,s3,800018fa <wait+0xe6>
      if(np->parent == p){
    800018d6:	7c9c                	ld	a5,56(s1)
    800018d8:	ff279be3          	bne	a5,s2,800018ce <wait+0xba>
        acquire(&np->lock);
    800018dc:	8526                	mv	a0,s1
    800018de:	00005097          	auipc	ra,0x5
    800018e2:	d84080e7          	jalr	-636(ra) # 80006662 <acquire>
        if(np->state == ZOMBIE){
    800018e6:	4c9c                	lw	a5,24(s1)
    800018e8:	f94781e3          	beq	a5,s4,8000186a <wait+0x56>
        release(&np->lock);
    800018ec:	8526                	mv	a0,s1
    800018ee:	00005097          	auipc	ra,0x5
    800018f2:	e28080e7          	jalr	-472(ra) # 80006716 <release>
        havekids = 1;
    800018f6:	8756                	mv	a4,s5
    800018f8:	bfd9                	j	800018ce <wait+0xba>
    if(!havekids || p->killed){
    800018fa:	c701                	beqz	a4,80001902 <wait+0xee>
    800018fc:	02892783          	lw	a5,40(s2)
    80001900:	c79d                	beqz	a5,8000192e <wait+0x11a>
      release(&wait_lock);
    80001902:	00007517          	auipc	a0,0x7
    80001906:	76650513          	addi	a0,a0,1894 # 80009068 <wait_lock>
    8000190a:	00005097          	auipc	ra,0x5
    8000190e:	e0c080e7          	jalr	-500(ra) # 80006716 <release>
      return -1;
    80001912:	59fd                	li	s3,-1
}
    80001914:	854e                	mv	a0,s3
    80001916:	60a6                	ld	ra,72(sp)
    80001918:	6406                	ld	s0,64(sp)
    8000191a:	74e2                	ld	s1,56(sp)
    8000191c:	7942                	ld	s2,48(sp)
    8000191e:	79a2                	ld	s3,40(sp)
    80001920:	7a02                	ld	s4,32(sp)
    80001922:	6ae2                	ld	s5,24(sp)
    80001924:	6b42                	ld	s6,16(sp)
    80001926:	6ba2                	ld	s7,8(sp)
    80001928:	6c02                	ld	s8,0(sp)
    8000192a:	6161                	addi	sp,sp,80
    8000192c:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000192e:	85e2                	mv	a1,s8
    80001930:	854a                	mv	a0,s2
    80001932:	00000097          	auipc	ra,0x0
    80001936:	e7e080e7          	jalr	-386(ra) # 800017b0 <sleep>
    havekids = 0;
    8000193a:	b715                	j	8000185e <wait+0x4a>

000000008000193c <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    8000193c:	7139                	addi	sp,sp,-64
    8000193e:	fc06                	sd	ra,56(sp)
    80001940:	f822                	sd	s0,48(sp)
    80001942:	f426                	sd	s1,40(sp)
    80001944:	f04a                	sd	s2,32(sp)
    80001946:	ec4e                	sd	s3,24(sp)
    80001948:	e852                	sd	s4,16(sp)
    8000194a:	e456                	sd	s5,8(sp)
    8000194c:	0080                	addi	s0,sp,64
    8000194e:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001950:	00008497          	auipc	s1,0x8
    80001954:	b3048493          	addi	s1,s1,-1232 # 80009480 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001958:	4989                	li	s3,2
        p->state = RUNNABLE;
    8000195a:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    8000195c:	0000d917          	auipc	s2,0xd
    80001960:	52490913          	addi	s2,s2,1316 # 8000ee80 <tickslock>
    80001964:	a821                	j	8000197c <wakeup+0x40>
        p->state = RUNNABLE;
    80001966:	0154ac23          	sw	s5,24(s1)
      }
      release(&p->lock);
    8000196a:	8526                	mv	a0,s1
    8000196c:	00005097          	auipc	ra,0x5
    80001970:	daa080e7          	jalr	-598(ra) # 80006716 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001974:	16848493          	addi	s1,s1,360
    80001978:	03248463          	beq	s1,s2,800019a0 <wakeup+0x64>
    if(p != myproc()){
    8000197c:	fffff097          	auipc	ra,0xfffff
    80001980:	778080e7          	jalr	1912(ra) # 800010f4 <myproc>
    80001984:	fea488e3          	beq	s1,a0,80001974 <wakeup+0x38>
      acquire(&p->lock);
    80001988:	8526                	mv	a0,s1
    8000198a:	00005097          	auipc	ra,0x5
    8000198e:	cd8080e7          	jalr	-808(ra) # 80006662 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001992:	4c9c                	lw	a5,24(s1)
    80001994:	fd379be3          	bne	a5,s3,8000196a <wakeup+0x2e>
    80001998:	709c                	ld	a5,32(s1)
    8000199a:	fd4798e3          	bne	a5,s4,8000196a <wakeup+0x2e>
    8000199e:	b7e1                	j	80001966 <wakeup+0x2a>
    }
  }
}
    800019a0:	70e2                	ld	ra,56(sp)
    800019a2:	7442                	ld	s0,48(sp)
    800019a4:	74a2                	ld	s1,40(sp)
    800019a6:	7902                	ld	s2,32(sp)
    800019a8:	69e2                	ld	s3,24(sp)
    800019aa:	6a42                	ld	s4,16(sp)
    800019ac:	6aa2                	ld	s5,8(sp)
    800019ae:	6121                	addi	sp,sp,64
    800019b0:	8082                	ret

00000000800019b2 <reparent>:
{
    800019b2:	7179                	addi	sp,sp,-48
    800019b4:	f406                	sd	ra,40(sp)
    800019b6:	f022                	sd	s0,32(sp)
    800019b8:	ec26                	sd	s1,24(sp)
    800019ba:	e84a                	sd	s2,16(sp)
    800019bc:	e44e                	sd	s3,8(sp)
    800019be:	e052                	sd	s4,0(sp)
    800019c0:	1800                	addi	s0,sp,48
    800019c2:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800019c4:	00008497          	auipc	s1,0x8
    800019c8:	abc48493          	addi	s1,s1,-1348 # 80009480 <proc>
      pp->parent = initproc;
    800019cc:	00007a17          	auipc	s4,0x7
    800019d0:	644a0a13          	addi	s4,s4,1604 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800019d4:	0000d997          	auipc	s3,0xd
    800019d8:	4ac98993          	addi	s3,s3,1196 # 8000ee80 <tickslock>
    800019dc:	a029                	j	800019e6 <reparent+0x34>
    800019de:	16848493          	addi	s1,s1,360
    800019e2:	01348d63          	beq	s1,s3,800019fc <reparent+0x4a>
    if(pp->parent == p){
    800019e6:	7c9c                	ld	a5,56(s1)
    800019e8:	ff279be3          	bne	a5,s2,800019de <reparent+0x2c>
      pp->parent = initproc;
    800019ec:	000a3503          	ld	a0,0(s4)
    800019f0:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    800019f2:	00000097          	auipc	ra,0x0
    800019f6:	f4a080e7          	jalr	-182(ra) # 8000193c <wakeup>
    800019fa:	b7d5                	j	800019de <reparent+0x2c>
}
    800019fc:	70a2                	ld	ra,40(sp)
    800019fe:	7402                	ld	s0,32(sp)
    80001a00:	64e2                	ld	s1,24(sp)
    80001a02:	6942                	ld	s2,16(sp)
    80001a04:	69a2                	ld	s3,8(sp)
    80001a06:	6a02                	ld	s4,0(sp)
    80001a08:	6145                	addi	sp,sp,48
    80001a0a:	8082                	ret

0000000080001a0c <exit>:
{
    80001a0c:	7179                	addi	sp,sp,-48
    80001a0e:	f406                	sd	ra,40(sp)
    80001a10:	f022                	sd	s0,32(sp)
    80001a12:	ec26                	sd	s1,24(sp)
    80001a14:	e84a                	sd	s2,16(sp)
    80001a16:	e44e                	sd	s3,8(sp)
    80001a18:	e052                	sd	s4,0(sp)
    80001a1a:	1800                	addi	s0,sp,48
    80001a1c:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001a1e:	fffff097          	auipc	ra,0xfffff
    80001a22:	6d6080e7          	jalr	1750(ra) # 800010f4 <myproc>
    80001a26:	89aa                	mv	s3,a0
  if(p == initproc)
    80001a28:	00007797          	auipc	a5,0x7
    80001a2c:	5e87b783          	ld	a5,1512(a5) # 80009010 <initproc>
    80001a30:	0d050493          	addi	s1,a0,208
    80001a34:	15050913          	addi	s2,a0,336
    80001a38:	02a79363          	bne	a5,a0,80001a5e <exit+0x52>
    panic("init exiting");
    80001a3c:	00006517          	auipc	a0,0x6
    80001a40:	7f450513          	addi	a0,a0,2036 # 80008230 <etext+0x230>
    80001a44:	00004097          	auipc	ra,0x4
    80001a48:	6d4080e7          	jalr	1748(ra) # 80006118 <panic>
      fileclose(f);
    80001a4c:	00002097          	auipc	ra,0x2
    80001a50:	3b4080e7          	jalr	948(ra) # 80003e00 <fileclose>
      p->ofile[fd] = 0;
    80001a54:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001a58:	04a1                	addi	s1,s1,8
    80001a5a:	01248563          	beq	s1,s2,80001a64 <exit+0x58>
    if(p->ofile[fd]){
    80001a5e:	6088                	ld	a0,0(s1)
    80001a60:	f575                	bnez	a0,80001a4c <exit+0x40>
    80001a62:	bfdd                	j	80001a58 <exit+0x4c>
  begin_op();
    80001a64:	00002097          	auipc	ra,0x2
    80001a68:	ed0080e7          	jalr	-304(ra) # 80003934 <begin_op>
  iput(p->cwd);
    80001a6c:	1509b503          	ld	a0,336(s3)
    80001a70:	00001097          	auipc	ra,0x1
    80001a74:	524080e7          	jalr	1316(ra) # 80002f94 <iput>
  end_op();
    80001a78:	00002097          	auipc	ra,0x2
    80001a7c:	f3c080e7          	jalr	-196(ra) # 800039b4 <end_op>
  p->cwd = 0;
    80001a80:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80001a84:	00007497          	auipc	s1,0x7
    80001a88:	5e448493          	addi	s1,s1,1508 # 80009068 <wait_lock>
    80001a8c:	8526                	mv	a0,s1
    80001a8e:	00005097          	auipc	ra,0x5
    80001a92:	bd4080e7          	jalr	-1068(ra) # 80006662 <acquire>
  reparent(p);
    80001a96:	854e                	mv	a0,s3
    80001a98:	00000097          	auipc	ra,0x0
    80001a9c:	f1a080e7          	jalr	-230(ra) # 800019b2 <reparent>
  wakeup(p->parent);
    80001aa0:	0389b503          	ld	a0,56(s3)
    80001aa4:	00000097          	auipc	ra,0x0
    80001aa8:	e98080e7          	jalr	-360(ra) # 8000193c <wakeup>
  acquire(&p->lock);
    80001aac:	854e                	mv	a0,s3
    80001aae:	00005097          	auipc	ra,0x5
    80001ab2:	bb4080e7          	jalr	-1100(ra) # 80006662 <acquire>
  p->xstate = status;
    80001ab6:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001aba:	4795                	li	a5,5
    80001abc:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001ac0:	8526                	mv	a0,s1
    80001ac2:	00005097          	auipc	ra,0x5
    80001ac6:	c54080e7          	jalr	-940(ra) # 80006716 <release>
  sched();
    80001aca:	00000097          	auipc	ra,0x0
    80001ace:	bd4080e7          	jalr	-1068(ra) # 8000169e <sched>
  panic("zombie exit");
    80001ad2:	00006517          	auipc	a0,0x6
    80001ad6:	76e50513          	addi	a0,a0,1902 # 80008240 <etext+0x240>
    80001ada:	00004097          	auipc	ra,0x4
    80001ade:	63e080e7          	jalr	1598(ra) # 80006118 <panic>

0000000080001ae2 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001ae2:	7179                	addi	sp,sp,-48
    80001ae4:	f406                	sd	ra,40(sp)
    80001ae6:	f022                	sd	s0,32(sp)
    80001ae8:	ec26                	sd	s1,24(sp)
    80001aea:	e84a                	sd	s2,16(sp)
    80001aec:	e44e                	sd	s3,8(sp)
    80001aee:	1800                	addi	s0,sp,48
    80001af0:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001af2:	00008497          	auipc	s1,0x8
    80001af6:	98e48493          	addi	s1,s1,-1650 # 80009480 <proc>
    80001afa:	0000d997          	auipc	s3,0xd
    80001afe:	38698993          	addi	s3,s3,902 # 8000ee80 <tickslock>
    acquire(&p->lock);
    80001b02:	8526                	mv	a0,s1
    80001b04:	00005097          	auipc	ra,0x5
    80001b08:	b5e080e7          	jalr	-1186(ra) # 80006662 <acquire>
    if(p->pid == pid){
    80001b0c:	589c                	lw	a5,48(s1)
    80001b0e:	01278d63          	beq	a5,s2,80001b28 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001b12:	8526                	mv	a0,s1
    80001b14:	00005097          	auipc	ra,0x5
    80001b18:	c02080e7          	jalr	-1022(ra) # 80006716 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001b1c:	16848493          	addi	s1,s1,360
    80001b20:	ff3491e3          	bne	s1,s3,80001b02 <kill+0x20>
  }
  return -1;
    80001b24:	557d                	li	a0,-1
    80001b26:	a829                	j	80001b40 <kill+0x5e>
      p->killed = 1;
    80001b28:	4785                	li	a5,1
    80001b2a:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001b2c:	4c98                	lw	a4,24(s1)
    80001b2e:	4789                	li	a5,2
    80001b30:	00f70f63          	beq	a4,a5,80001b4e <kill+0x6c>
      release(&p->lock);
    80001b34:	8526                	mv	a0,s1
    80001b36:	00005097          	auipc	ra,0x5
    80001b3a:	be0080e7          	jalr	-1056(ra) # 80006716 <release>
      return 0;
    80001b3e:	4501                	li	a0,0
}
    80001b40:	70a2                	ld	ra,40(sp)
    80001b42:	7402                	ld	s0,32(sp)
    80001b44:	64e2                	ld	s1,24(sp)
    80001b46:	6942                	ld	s2,16(sp)
    80001b48:	69a2                	ld	s3,8(sp)
    80001b4a:	6145                	addi	sp,sp,48
    80001b4c:	8082                	ret
        p->state = RUNNABLE;
    80001b4e:	478d                	li	a5,3
    80001b50:	cc9c                	sw	a5,24(s1)
    80001b52:	b7cd                	j	80001b34 <kill+0x52>

0000000080001b54 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001b54:	7179                	addi	sp,sp,-48
    80001b56:	f406                	sd	ra,40(sp)
    80001b58:	f022                	sd	s0,32(sp)
    80001b5a:	ec26                	sd	s1,24(sp)
    80001b5c:	e84a                	sd	s2,16(sp)
    80001b5e:	e44e                	sd	s3,8(sp)
    80001b60:	e052                	sd	s4,0(sp)
    80001b62:	1800                	addi	s0,sp,48
    80001b64:	84aa                	mv	s1,a0
    80001b66:	892e                	mv	s2,a1
    80001b68:	89b2                	mv	s3,a2
    80001b6a:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001b6c:	fffff097          	auipc	ra,0xfffff
    80001b70:	588080e7          	jalr	1416(ra) # 800010f4 <myproc>
  if(user_dst){
    80001b74:	c08d                	beqz	s1,80001b96 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001b76:	86d2                	mv	a3,s4
    80001b78:	864e                	mv	a2,s3
    80001b7a:	85ca                	mv	a1,s2
    80001b7c:	6928                	ld	a0,80(a0)
    80001b7e:	fffff097          	auipc	ra,0xfffff
    80001b82:	f84080e7          	jalr	-124(ra) # 80000b02 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001b86:	70a2                	ld	ra,40(sp)
    80001b88:	7402                	ld	s0,32(sp)
    80001b8a:	64e2                	ld	s1,24(sp)
    80001b8c:	6942                	ld	s2,16(sp)
    80001b8e:	69a2                	ld	s3,8(sp)
    80001b90:	6a02                	ld	s4,0(sp)
    80001b92:	6145                	addi	sp,sp,48
    80001b94:	8082                	ret
    memmove((char *)dst, src, len);
    80001b96:	000a061b          	sext.w	a2,s4
    80001b9a:	85ce                	mv	a1,s3
    80001b9c:	854a                	mv	a0,s2
    80001b9e:	ffffe097          	auipc	ra,0xffffe
    80001ba2:	63a080e7          	jalr	1594(ra) # 800001d8 <memmove>
    return 0;
    80001ba6:	8526                	mv	a0,s1
    80001ba8:	bff9                	j	80001b86 <either_copyout+0x32>

0000000080001baa <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001baa:	7179                	addi	sp,sp,-48
    80001bac:	f406                	sd	ra,40(sp)
    80001bae:	f022                	sd	s0,32(sp)
    80001bb0:	ec26                	sd	s1,24(sp)
    80001bb2:	e84a                	sd	s2,16(sp)
    80001bb4:	e44e                	sd	s3,8(sp)
    80001bb6:	e052                	sd	s4,0(sp)
    80001bb8:	1800                	addi	s0,sp,48
    80001bba:	892a                	mv	s2,a0
    80001bbc:	84ae                	mv	s1,a1
    80001bbe:	89b2                	mv	s3,a2
    80001bc0:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001bc2:	fffff097          	auipc	ra,0xfffff
    80001bc6:	532080e7          	jalr	1330(ra) # 800010f4 <myproc>
  if(user_src){
    80001bca:	c08d                	beqz	s1,80001bec <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001bcc:	86d2                	mv	a3,s4
    80001bce:	864e                	mv	a2,s3
    80001bd0:	85ca                	mv	a1,s2
    80001bd2:	6928                	ld	a0,80(a0)
    80001bd4:	fffff097          	auipc	ra,0xfffff
    80001bd8:	fba080e7          	jalr	-70(ra) # 80000b8e <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001bdc:	70a2                	ld	ra,40(sp)
    80001bde:	7402                	ld	s0,32(sp)
    80001be0:	64e2                	ld	s1,24(sp)
    80001be2:	6942                	ld	s2,16(sp)
    80001be4:	69a2                	ld	s3,8(sp)
    80001be6:	6a02                	ld	s4,0(sp)
    80001be8:	6145                	addi	sp,sp,48
    80001bea:	8082                	ret
    memmove(dst, (char*)src, len);
    80001bec:	000a061b          	sext.w	a2,s4
    80001bf0:	85ce                	mv	a1,s3
    80001bf2:	854a                	mv	a0,s2
    80001bf4:	ffffe097          	auipc	ra,0xffffe
    80001bf8:	5e4080e7          	jalr	1508(ra) # 800001d8 <memmove>
    return 0;
    80001bfc:	8526                	mv	a0,s1
    80001bfe:	bff9                	j	80001bdc <either_copyin+0x32>

0000000080001c00 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001c00:	715d                	addi	sp,sp,-80
    80001c02:	e486                	sd	ra,72(sp)
    80001c04:	e0a2                	sd	s0,64(sp)
    80001c06:	fc26                	sd	s1,56(sp)
    80001c08:	f84a                	sd	s2,48(sp)
    80001c0a:	f44e                	sd	s3,40(sp)
    80001c0c:	f052                	sd	s4,32(sp)
    80001c0e:	ec56                	sd	s5,24(sp)
    80001c10:	e85a                	sd	s6,16(sp)
    80001c12:	e45e                	sd	s7,8(sp)
    80001c14:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001c16:	00006517          	auipc	a0,0x6
    80001c1a:	43250513          	addi	a0,a0,1074 # 80008048 <etext+0x48>
    80001c1e:	00004097          	auipc	ra,0x4
    80001c22:	544080e7          	jalr	1348(ra) # 80006162 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001c26:	00008497          	auipc	s1,0x8
    80001c2a:	9b248493          	addi	s1,s1,-1614 # 800095d8 <proc+0x158>
    80001c2e:	0000d917          	auipc	s2,0xd
    80001c32:	3aa90913          	addi	s2,s2,938 # 8000efd8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001c36:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001c38:	00006997          	auipc	s3,0x6
    80001c3c:	61898993          	addi	s3,s3,1560 # 80008250 <etext+0x250>
    printf("%d %s %s", p->pid, state, p->name);
    80001c40:	00006a97          	auipc	s5,0x6
    80001c44:	618a8a93          	addi	s5,s5,1560 # 80008258 <etext+0x258>
    printf("\n");
    80001c48:	00006a17          	auipc	s4,0x6
    80001c4c:	400a0a13          	addi	s4,s4,1024 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001c50:	00006b97          	auipc	s7,0x6
    80001c54:	640b8b93          	addi	s7,s7,1600 # 80008290 <states.1805>
    80001c58:	a00d                	j	80001c7a <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001c5a:	ed86a583          	lw	a1,-296(a3)
    80001c5e:	8556                	mv	a0,s5
    80001c60:	00004097          	auipc	ra,0x4
    80001c64:	502080e7          	jalr	1282(ra) # 80006162 <printf>
    printf("\n");
    80001c68:	8552                	mv	a0,s4
    80001c6a:	00004097          	auipc	ra,0x4
    80001c6e:	4f8080e7          	jalr	1272(ra) # 80006162 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001c72:	16848493          	addi	s1,s1,360
    80001c76:	03248163          	beq	s1,s2,80001c98 <procdump+0x98>
    if(p->state == UNUSED)
    80001c7a:	86a6                	mv	a3,s1
    80001c7c:	ec04a783          	lw	a5,-320(s1)
    80001c80:	dbed                	beqz	a5,80001c72 <procdump+0x72>
      state = "???";
    80001c82:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001c84:	fcfb6be3          	bltu	s6,a5,80001c5a <procdump+0x5a>
    80001c88:	1782                	slli	a5,a5,0x20
    80001c8a:	9381                	srli	a5,a5,0x20
    80001c8c:	078e                	slli	a5,a5,0x3
    80001c8e:	97de                	add	a5,a5,s7
    80001c90:	6390                	ld	a2,0(a5)
    80001c92:	f661                	bnez	a2,80001c5a <procdump+0x5a>
      state = "???";
    80001c94:	864e                	mv	a2,s3
    80001c96:	b7d1                	j	80001c5a <procdump+0x5a>
  }
}
    80001c98:	60a6                	ld	ra,72(sp)
    80001c9a:	6406                	ld	s0,64(sp)
    80001c9c:	74e2                	ld	s1,56(sp)
    80001c9e:	7942                	ld	s2,48(sp)
    80001ca0:	79a2                	ld	s3,40(sp)
    80001ca2:	7a02                	ld	s4,32(sp)
    80001ca4:	6ae2                	ld	s5,24(sp)
    80001ca6:	6b42                	ld	s6,16(sp)
    80001ca8:	6ba2                	ld	s7,8(sp)
    80001caa:	6161                	addi	sp,sp,80
    80001cac:	8082                	ret

0000000080001cae <swtch>:
    80001cae:	00153023          	sd	ra,0(a0)
    80001cb2:	00253423          	sd	sp,8(a0)
    80001cb6:	e900                	sd	s0,16(a0)
    80001cb8:	ed04                	sd	s1,24(a0)
    80001cba:	03253023          	sd	s2,32(a0)
    80001cbe:	03353423          	sd	s3,40(a0)
    80001cc2:	03453823          	sd	s4,48(a0)
    80001cc6:	03553c23          	sd	s5,56(a0)
    80001cca:	05653023          	sd	s6,64(a0)
    80001cce:	05753423          	sd	s7,72(a0)
    80001cd2:	05853823          	sd	s8,80(a0)
    80001cd6:	05953c23          	sd	s9,88(a0)
    80001cda:	07a53023          	sd	s10,96(a0)
    80001cde:	07b53423          	sd	s11,104(a0)
    80001ce2:	0005b083          	ld	ra,0(a1)
    80001ce6:	0085b103          	ld	sp,8(a1)
    80001cea:	6980                	ld	s0,16(a1)
    80001cec:	6d84                	ld	s1,24(a1)
    80001cee:	0205b903          	ld	s2,32(a1)
    80001cf2:	0285b983          	ld	s3,40(a1)
    80001cf6:	0305ba03          	ld	s4,48(a1)
    80001cfa:	0385ba83          	ld	s5,56(a1)
    80001cfe:	0405bb03          	ld	s6,64(a1)
    80001d02:	0485bb83          	ld	s7,72(a1)
    80001d06:	0505bc03          	ld	s8,80(a1)
    80001d0a:	0585bc83          	ld	s9,88(a1)
    80001d0e:	0605bd03          	ld	s10,96(a1)
    80001d12:	0685bd83          	ld	s11,104(a1)
    80001d16:	8082                	ret

0000000080001d18 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001d18:	1141                	addi	sp,sp,-16
    80001d1a:	e406                	sd	ra,8(sp)
    80001d1c:	e022                	sd	s0,0(sp)
    80001d1e:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001d20:	00006597          	auipc	a1,0x6
    80001d24:	5a058593          	addi	a1,a1,1440 # 800082c0 <states.1805+0x30>
    80001d28:	0000d517          	auipc	a0,0xd
    80001d2c:	15850513          	addi	a0,a0,344 # 8000ee80 <tickslock>
    80001d30:	00005097          	auipc	ra,0x5
    80001d34:	8a2080e7          	jalr	-1886(ra) # 800065d2 <initlock>
}
    80001d38:	60a2                	ld	ra,8(sp)
    80001d3a:	6402                	ld	s0,0(sp)
    80001d3c:	0141                	addi	sp,sp,16
    80001d3e:	8082                	ret

0000000080001d40 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001d40:	1141                	addi	sp,sp,-16
    80001d42:	e422                	sd	s0,8(sp)
    80001d44:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001d46:	00003797          	auipc	a5,0x3
    80001d4a:	6da78793          	addi	a5,a5,1754 # 80005420 <kernelvec>
    80001d4e:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001d52:	6422                	ld	s0,8(sp)
    80001d54:	0141                	addi	sp,sp,16
    80001d56:	8082                	ret

0000000080001d58 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001d58:	1141                	addi	sp,sp,-16
    80001d5a:	e406                	sd	ra,8(sp)
    80001d5c:	e022                	sd	s0,0(sp)
    80001d5e:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001d60:	fffff097          	auipc	ra,0xfffff
    80001d64:	394080e7          	jalr	916(ra) # 800010f4 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d68:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001d6c:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d6e:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001d72:	00005617          	auipc	a2,0x5
    80001d76:	28e60613          	addi	a2,a2,654 # 80007000 <_trampoline>
    80001d7a:	00005697          	auipc	a3,0x5
    80001d7e:	28668693          	addi	a3,a3,646 # 80007000 <_trampoline>
    80001d82:	8e91                	sub	a3,a3,a2
    80001d84:	040007b7          	lui	a5,0x4000
    80001d88:	17fd                	addi	a5,a5,-1
    80001d8a:	07b2                	slli	a5,a5,0xc
    80001d8c:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001d8e:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001d92:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001d94:	180026f3          	csrr	a3,satp
    80001d98:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001d9a:	6d38                	ld	a4,88(a0)
    80001d9c:	6134                	ld	a3,64(a0)
    80001d9e:	6585                	lui	a1,0x1
    80001da0:	96ae                	add	a3,a3,a1
    80001da2:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001da4:	6d38                	ld	a4,88(a0)
    80001da6:	00000697          	auipc	a3,0x0
    80001daa:	13868693          	addi	a3,a3,312 # 80001ede <usertrap>
    80001dae:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001db0:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001db2:	8692                	mv	a3,tp
    80001db4:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001db6:	100026f3          	csrr	a3,sstatus

  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001dba:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001dbe:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001dc2:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001dc6:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001dc8:	6f18                	ld	a4,24(a4)
    80001dca:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001dce:	692c                	ld	a1,80(a0)
    80001dd0:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001dd2:	00005717          	auipc	a4,0x5
    80001dd6:	2be70713          	addi	a4,a4,702 # 80007090 <userret>
    80001dda:	8f11                	sub	a4,a4,a2
    80001ddc:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001dde:	577d                	li	a4,-1
    80001de0:	177e                	slli	a4,a4,0x3f
    80001de2:	8dd9                	or	a1,a1,a4
    80001de4:	02000537          	lui	a0,0x2000
    80001de8:	157d                	addi	a0,a0,-1
    80001dea:	0536                	slli	a0,a0,0xd
    80001dec:	9782                	jalr	a5
}
    80001dee:	60a2                	ld	ra,8(sp)
    80001df0:	6402                	ld	s0,0(sp)
    80001df2:	0141                	addi	sp,sp,16
    80001df4:	8082                	ret

0000000080001df6 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001df6:	1101                	addi	sp,sp,-32
    80001df8:	ec06                	sd	ra,24(sp)
    80001dfa:	e822                	sd	s0,16(sp)
    80001dfc:	e426                	sd	s1,8(sp)
    80001dfe:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001e00:	0000d497          	auipc	s1,0xd
    80001e04:	08048493          	addi	s1,s1,128 # 8000ee80 <tickslock>
    80001e08:	8526                	mv	a0,s1
    80001e0a:	00005097          	auipc	ra,0x5
    80001e0e:	858080e7          	jalr	-1960(ra) # 80006662 <acquire>
  ticks++;
    80001e12:	00007517          	auipc	a0,0x7
    80001e16:	20650513          	addi	a0,a0,518 # 80009018 <ticks>
    80001e1a:	411c                	lw	a5,0(a0)
    80001e1c:	2785                	addiw	a5,a5,1
    80001e1e:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001e20:	00000097          	auipc	ra,0x0
    80001e24:	b1c080e7          	jalr	-1252(ra) # 8000193c <wakeup>
  release(&tickslock);
    80001e28:	8526                	mv	a0,s1
    80001e2a:	00005097          	auipc	ra,0x5
    80001e2e:	8ec080e7          	jalr	-1812(ra) # 80006716 <release>
}
    80001e32:	60e2                	ld	ra,24(sp)
    80001e34:	6442                	ld	s0,16(sp)
    80001e36:	64a2                	ld	s1,8(sp)
    80001e38:	6105                	addi	sp,sp,32
    80001e3a:	8082                	ret

0000000080001e3c <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001e3c:	1101                	addi	sp,sp,-32
    80001e3e:	ec06                	sd	ra,24(sp)
    80001e40:	e822                	sd	s0,16(sp)
    80001e42:	e426                	sd	s1,8(sp)
    80001e44:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e46:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001e4a:	00074d63          	bltz	a4,80001e64 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001e4e:	57fd                	li	a5,-1
    80001e50:	17fe                	slli	a5,a5,0x3f
    80001e52:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001e54:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001e56:	06f70363          	beq	a4,a5,80001ebc <devintr+0x80>
  }
}
    80001e5a:	60e2                	ld	ra,24(sp)
    80001e5c:	6442                	ld	s0,16(sp)
    80001e5e:	64a2                	ld	s1,8(sp)
    80001e60:	6105                	addi	sp,sp,32
    80001e62:	8082                	ret
     (scause & 0xff) == 9){
    80001e64:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80001e68:	46a5                	li	a3,9
    80001e6a:	fed792e3          	bne	a5,a3,80001e4e <devintr+0x12>
    int irq = plic_claim();
    80001e6e:	00003097          	auipc	ra,0x3
    80001e72:	6ba080e7          	jalr	1722(ra) # 80005528 <plic_claim>
    80001e76:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001e78:	47a9                	li	a5,10
    80001e7a:	02f50763          	beq	a0,a5,80001ea8 <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001e7e:	4785                	li	a5,1
    80001e80:	02f50963          	beq	a0,a5,80001eb2 <devintr+0x76>
    return 1;
    80001e84:	4505                	li	a0,1
    } else if(irq){
    80001e86:	d8f1                	beqz	s1,80001e5a <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001e88:	85a6                	mv	a1,s1
    80001e8a:	00006517          	auipc	a0,0x6
    80001e8e:	43e50513          	addi	a0,a0,1086 # 800082c8 <states.1805+0x38>
    80001e92:	00004097          	auipc	ra,0x4
    80001e96:	2d0080e7          	jalr	720(ra) # 80006162 <printf>
      plic_complete(irq);
    80001e9a:	8526                	mv	a0,s1
    80001e9c:	00003097          	auipc	ra,0x3
    80001ea0:	6b0080e7          	jalr	1712(ra) # 8000554c <plic_complete>
    return 1;
    80001ea4:	4505                	li	a0,1
    80001ea6:	bf55                	j	80001e5a <devintr+0x1e>
      uartintr();
    80001ea8:	00004097          	auipc	ra,0x4
    80001eac:	6da080e7          	jalr	1754(ra) # 80006582 <uartintr>
    80001eb0:	b7ed                	j	80001e9a <devintr+0x5e>
      virtio_disk_intr();
    80001eb2:	00004097          	auipc	ra,0x4
    80001eb6:	b7a080e7          	jalr	-1158(ra) # 80005a2c <virtio_disk_intr>
    80001eba:	b7c5                	j	80001e9a <devintr+0x5e>
    if(cpuid() == 0){
    80001ebc:	fffff097          	auipc	ra,0xfffff
    80001ec0:	20c080e7          	jalr	524(ra) # 800010c8 <cpuid>
    80001ec4:	c901                	beqz	a0,80001ed4 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001ec6:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001eca:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001ecc:	14479073          	csrw	sip,a5
    return 2;
    80001ed0:	4509                	li	a0,2
    80001ed2:	b761                	j	80001e5a <devintr+0x1e>
      clockintr();
    80001ed4:	00000097          	auipc	ra,0x0
    80001ed8:	f22080e7          	jalr	-222(ra) # 80001df6 <clockintr>
    80001edc:	b7ed                	j	80001ec6 <devintr+0x8a>

0000000080001ede <usertrap>:
{
    80001ede:	1101                	addi	sp,sp,-32
    80001ee0:	ec06                	sd	ra,24(sp)
    80001ee2:	e822                	sd	s0,16(sp)
    80001ee4:	e426                	sd	s1,8(sp)
    80001ee6:	e04a                	sd	s2,0(sp)
    80001ee8:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001eea:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001eee:	1007f793          	andi	a5,a5,256
    80001ef2:	e3ad                	bnez	a5,80001f54 <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001ef4:	00003797          	auipc	a5,0x3
    80001ef8:	52c78793          	addi	a5,a5,1324 # 80005420 <kernelvec>
    80001efc:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001f00:	fffff097          	auipc	ra,0xfffff
    80001f04:	1f4080e7          	jalr	500(ra) # 800010f4 <myproc>
    80001f08:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001f0a:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f0c:	14102773          	csrr	a4,sepc
    80001f10:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001f12:	14202773          	csrr	a4,scause
  if(scause == 8) {
    80001f16:	47a1                	li	a5,8
    80001f18:	04f71c63          	bne	a4,a5,80001f70 <usertrap+0x92>
    if(p->killed)
    80001f1c:	551c                	lw	a5,40(a0)
    80001f1e:	e3b9                	bnez	a5,80001f64 <usertrap+0x86>
    p->trapframe->epc += 4;
    80001f20:	6cb8                	ld	a4,88(s1)
    80001f22:	6f1c                	ld	a5,24(a4)
    80001f24:	0791                	addi	a5,a5,4
    80001f26:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f28:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001f2c:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001f30:	10079073          	csrw	sstatus,a5
    syscall();
    80001f34:	00000097          	auipc	ra,0x0
    80001f38:	2e0080e7          	jalr	736(ra) # 80002214 <syscall>
  if(p->killed)
    80001f3c:	549c                	lw	a5,40(s1)
    80001f3e:	ebc1                	bnez	a5,80001fce <usertrap+0xf0>
  usertrapret();
    80001f40:	00000097          	auipc	ra,0x0
    80001f44:	e18080e7          	jalr	-488(ra) # 80001d58 <usertrapret>
}
    80001f48:	60e2                	ld	ra,24(sp)
    80001f4a:	6442                	ld	s0,16(sp)
    80001f4c:	64a2                	ld	s1,8(sp)
    80001f4e:	6902                	ld	s2,0(sp)
    80001f50:	6105                	addi	sp,sp,32
    80001f52:	8082                	ret
    panic("usertrap: not from user mode");
    80001f54:	00006517          	auipc	a0,0x6
    80001f58:	39450513          	addi	a0,a0,916 # 800082e8 <states.1805+0x58>
    80001f5c:	00004097          	auipc	ra,0x4
    80001f60:	1bc080e7          	jalr	444(ra) # 80006118 <panic>
      exit(-1);
    80001f64:	557d                	li	a0,-1
    80001f66:	00000097          	auipc	ra,0x0
    80001f6a:	aa6080e7          	jalr	-1370(ra) # 80001a0c <exit>
    80001f6e:	bf4d                	j	80001f20 <usertrap+0x42>
  } else if ((which_dev = devintr()) != 0) {
    80001f70:	00000097          	auipc	ra,0x0
    80001f74:	ecc080e7          	jalr	-308(ra) # 80001e3c <devintr>
    80001f78:	892a                	mv	s2,a0
    80001f7a:	c501                	beqz	a0,80001f82 <usertrap+0xa4>
  if(p->killed)
    80001f7c:	549c                	lw	a5,40(s1)
    80001f7e:	c3a1                	beqz	a5,80001fbe <usertrap+0xe0>
    80001f80:	a815                	j	80001fb4 <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001f82:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001f86:	5890                	lw	a2,48(s1)
    80001f88:	00006517          	auipc	a0,0x6
    80001f8c:	38050513          	addi	a0,a0,896 # 80008308 <states.1805+0x78>
    80001f90:	00004097          	auipc	ra,0x4
    80001f94:	1d2080e7          	jalr	466(ra) # 80006162 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f98:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001f9c:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001fa0:	00006517          	auipc	a0,0x6
    80001fa4:	39850513          	addi	a0,a0,920 # 80008338 <states.1805+0xa8>
    80001fa8:	00004097          	auipc	ra,0x4
    80001fac:	1ba080e7          	jalr	442(ra) # 80006162 <printf>
    p->killed = 1;
    80001fb0:	4785                	li	a5,1
    80001fb2:	d49c                	sw	a5,40(s1)
    exit(-1);
    80001fb4:	557d                	li	a0,-1
    80001fb6:	00000097          	auipc	ra,0x0
    80001fba:	a56080e7          	jalr	-1450(ra) # 80001a0c <exit>
  if(which_dev == 2)
    80001fbe:	4789                	li	a5,2
    80001fc0:	f8f910e3          	bne	s2,a5,80001f40 <usertrap+0x62>
    yield();
    80001fc4:	fffff097          	auipc	ra,0xfffff
    80001fc8:	7b0080e7          	jalr	1968(ra) # 80001774 <yield>
    80001fcc:	bf95                	j	80001f40 <usertrap+0x62>
  int which_dev = 0;
    80001fce:	4901                	li	s2,0
    80001fd0:	b7d5                	j	80001fb4 <usertrap+0xd6>

0000000080001fd2 <kerneltrap>:
{
    80001fd2:	7179                	addi	sp,sp,-48
    80001fd4:	f406                	sd	ra,40(sp)
    80001fd6:	f022                	sd	s0,32(sp)
    80001fd8:	ec26                	sd	s1,24(sp)
    80001fda:	e84a                	sd	s2,16(sp)
    80001fdc:	e44e                	sd	s3,8(sp)
    80001fde:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001fe0:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001fe4:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001fe8:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001fec:	1004f793          	andi	a5,s1,256
    80001ff0:	cb85                	beqz	a5,80002020 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ff2:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001ff6:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001ff8:	ef85                	bnez	a5,80002030 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001ffa:	00000097          	auipc	ra,0x0
    80001ffe:	e42080e7          	jalr	-446(ra) # 80001e3c <devintr>
    80002002:	cd1d                	beqz	a0,80002040 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002004:	4789                	li	a5,2
    80002006:	06f50a63          	beq	a0,a5,8000207a <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    8000200a:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000200e:	10049073          	csrw	sstatus,s1
}
    80002012:	70a2                	ld	ra,40(sp)
    80002014:	7402                	ld	s0,32(sp)
    80002016:	64e2                	ld	s1,24(sp)
    80002018:	6942                	ld	s2,16(sp)
    8000201a:	69a2                	ld	s3,8(sp)
    8000201c:	6145                	addi	sp,sp,48
    8000201e:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002020:	00006517          	auipc	a0,0x6
    80002024:	33850513          	addi	a0,a0,824 # 80008358 <states.1805+0xc8>
    80002028:	00004097          	auipc	ra,0x4
    8000202c:	0f0080e7          	jalr	240(ra) # 80006118 <panic>
    panic("kerneltrap: interrupts enabled");
    80002030:	00006517          	auipc	a0,0x6
    80002034:	35050513          	addi	a0,a0,848 # 80008380 <states.1805+0xf0>
    80002038:	00004097          	auipc	ra,0x4
    8000203c:	0e0080e7          	jalr	224(ra) # 80006118 <panic>
    printf("scause %p\n", scause);
    80002040:	85ce                	mv	a1,s3
    80002042:	00006517          	auipc	a0,0x6
    80002046:	35e50513          	addi	a0,a0,862 # 800083a0 <states.1805+0x110>
    8000204a:	00004097          	auipc	ra,0x4
    8000204e:	118080e7          	jalr	280(ra) # 80006162 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002052:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002056:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    8000205a:	00006517          	auipc	a0,0x6
    8000205e:	35650513          	addi	a0,a0,854 # 800083b0 <states.1805+0x120>
    80002062:	00004097          	auipc	ra,0x4
    80002066:	100080e7          	jalr	256(ra) # 80006162 <printf>
    panic("kerneltrap");
    8000206a:	00006517          	auipc	a0,0x6
    8000206e:	35e50513          	addi	a0,a0,862 # 800083c8 <states.1805+0x138>
    80002072:	00004097          	auipc	ra,0x4
    80002076:	0a6080e7          	jalr	166(ra) # 80006118 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    8000207a:	fffff097          	auipc	ra,0xfffff
    8000207e:	07a080e7          	jalr	122(ra) # 800010f4 <myproc>
    80002082:	d541                	beqz	a0,8000200a <kerneltrap+0x38>
    80002084:	fffff097          	auipc	ra,0xfffff
    80002088:	070080e7          	jalr	112(ra) # 800010f4 <myproc>
    8000208c:	4d18                	lw	a4,24(a0)
    8000208e:	4791                	li	a5,4
    80002090:	f6f71de3          	bne	a4,a5,8000200a <kerneltrap+0x38>
    yield();
    80002094:	fffff097          	auipc	ra,0xfffff
    80002098:	6e0080e7          	jalr	1760(ra) # 80001774 <yield>
    8000209c:	b7bd                	j	8000200a <kerneltrap+0x38>

000000008000209e <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    8000209e:	1101                	addi	sp,sp,-32
    800020a0:	ec06                	sd	ra,24(sp)
    800020a2:	e822                	sd	s0,16(sp)
    800020a4:	e426                	sd	s1,8(sp)
    800020a6:	1000                	addi	s0,sp,32
    800020a8:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800020aa:	fffff097          	auipc	ra,0xfffff
    800020ae:	04a080e7          	jalr	74(ra) # 800010f4 <myproc>
  switch (n) {
    800020b2:	4795                	li	a5,5
    800020b4:	0497e163          	bltu	a5,s1,800020f6 <argraw+0x58>
    800020b8:	048a                	slli	s1,s1,0x2
    800020ba:	00006717          	auipc	a4,0x6
    800020be:	34670713          	addi	a4,a4,838 # 80008400 <states.1805+0x170>
    800020c2:	94ba                	add	s1,s1,a4
    800020c4:	409c                	lw	a5,0(s1)
    800020c6:	97ba                	add	a5,a5,a4
    800020c8:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    800020ca:	6d3c                	ld	a5,88(a0)
    800020cc:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    800020ce:	60e2                	ld	ra,24(sp)
    800020d0:	6442                	ld	s0,16(sp)
    800020d2:	64a2                	ld	s1,8(sp)
    800020d4:	6105                	addi	sp,sp,32
    800020d6:	8082                	ret
    return p->trapframe->a1;
    800020d8:	6d3c                	ld	a5,88(a0)
    800020da:	7fa8                	ld	a0,120(a5)
    800020dc:	bfcd                	j	800020ce <argraw+0x30>
    return p->trapframe->a2;
    800020de:	6d3c                	ld	a5,88(a0)
    800020e0:	63c8                	ld	a0,128(a5)
    800020e2:	b7f5                	j	800020ce <argraw+0x30>
    return p->trapframe->a3;
    800020e4:	6d3c                	ld	a5,88(a0)
    800020e6:	67c8                	ld	a0,136(a5)
    800020e8:	b7dd                	j	800020ce <argraw+0x30>
    return p->trapframe->a4;
    800020ea:	6d3c                	ld	a5,88(a0)
    800020ec:	6bc8                	ld	a0,144(a5)
    800020ee:	b7c5                	j	800020ce <argraw+0x30>
    return p->trapframe->a5;
    800020f0:	6d3c                	ld	a5,88(a0)
    800020f2:	6fc8                	ld	a0,152(a5)
    800020f4:	bfe9                	j	800020ce <argraw+0x30>
  panic("argraw");
    800020f6:	00006517          	auipc	a0,0x6
    800020fa:	2e250513          	addi	a0,a0,738 # 800083d8 <states.1805+0x148>
    800020fe:	00004097          	auipc	ra,0x4
    80002102:	01a080e7          	jalr	26(ra) # 80006118 <panic>

0000000080002106 <fetchaddr>:
{
    80002106:	1101                	addi	sp,sp,-32
    80002108:	ec06                	sd	ra,24(sp)
    8000210a:	e822                	sd	s0,16(sp)
    8000210c:	e426                	sd	s1,8(sp)
    8000210e:	e04a                	sd	s2,0(sp)
    80002110:	1000                	addi	s0,sp,32
    80002112:	84aa                	mv	s1,a0
    80002114:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002116:	fffff097          	auipc	ra,0xfffff
    8000211a:	fde080e7          	jalr	-34(ra) # 800010f4 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    8000211e:	653c                	ld	a5,72(a0)
    80002120:	02f4f863          	bgeu	s1,a5,80002150 <fetchaddr+0x4a>
    80002124:	00848713          	addi	a4,s1,8
    80002128:	02e7e663          	bltu	a5,a4,80002154 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    8000212c:	46a1                	li	a3,8
    8000212e:	8626                	mv	a2,s1
    80002130:	85ca                	mv	a1,s2
    80002132:	6928                	ld	a0,80(a0)
    80002134:	fffff097          	auipc	ra,0xfffff
    80002138:	a5a080e7          	jalr	-1446(ra) # 80000b8e <copyin>
    8000213c:	00a03533          	snez	a0,a0
    80002140:	40a00533          	neg	a0,a0
}
    80002144:	60e2                	ld	ra,24(sp)
    80002146:	6442                	ld	s0,16(sp)
    80002148:	64a2                	ld	s1,8(sp)
    8000214a:	6902                	ld	s2,0(sp)
    8000214c:	6105                	addi	sp,sp,32
    8000214e:	8082                	ret
    return -1;
    80002150:	557d                	li	a0,-1
    80002152:	bfcd                	j	80002144 <fetchaddr+0x3e>
    80002154:	557d                	li	a0,-1
    80002156:	b7fd                	j	80002144 <fetchaddr+0x3e>

0000000080002158 <fetchstr>:
{
    80002158:	7179                	addi	sp,sp,-48
    8000215a:	f406                	sd	ra,40(sp)
    8000215c:	f022                	sd	s0,32(sp)
    8000215e:	ec26                	sd	s1,24(sp)
    80002160:	e84a                	sd	s2,16(sp)
    80002162:	e44e                	sd	s3,8(sp)
    80002164:	1800                	addi	s0,sp,48
    80002166:	892a                	mv	s2,a0
    80002168:	84ae                	mv	s1,a1
    8000216a:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    8000216c:	fffff097          	auipc	ra,0xfffff
    80002170:	f88080e7          	jalr	-120(ra) # 800010f4 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80002174:	86ce                	mv	a3,s3
    80002176:	864a                	mv	a2,s2
    80002178:	85a6                	mv	a1,s1
    8000217a:	6928                	ld	a0,80(a0)
    8000217c:	fffff097          	auipc	ra,0xfffff
    80002180:	a9e080e7          	jalr	-1378(ra) # 80000c1a <copyinstr>
  if(err < 0)
    80002184:	00054763          	bltz	a0,80002192 <fetchstr+0x3a>
  return strlen(buf);
    80002188:	8526                	mv	a0,s1
    8000218a:	ffffe097          	auipc	ra,0xffffe
    8000218e:	172080e7          	jalr	370(ra) # 800002fc <strlen>
}
    80002192:	70a2                	ld	ra,40(sp)
    80002194:	7402                	ld	s0,32(sp)
    80002196:	64e2                	ld	s1,24(sp)
    80002198:	6942                	ld	s2,16(sp)
    8000219a:	69a2                	ld	s3,8(sp)
    8000219c:	6145                	addi	sp,sp,48
    8000219e:	8082                	ret

00000000800021a0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    800021a0:	1101                	addi	sp,sp,-32
    800021a2:	ec06                	sd	ra,24(sp)
    800021a4:	e822                	sd	s0,16(sp)
    800021a6:	e426                	sd	s1,8(sp)
    800021a8:	1000                	addi	s0,sp,32
    800021aa:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800021ac:	00000097          	auipc	ra,0x0
    800021b0:	ef2080e7          	jalr	-270(ra) # 8000209e <argraw>
    800021b4:	c088                	sw	a0,0(s1)
  return 0;
}
    800021b6:	4501                	li	a0,0
    800021b8:	60e2                	ld	ra,24(sp)
    800021ba:	6442                	ld	s0,16(sp)
    800021bc:	64a2                	ld	s1,8(sp)
    800021be:	6105                	addi	sp,sp,32
    800021c0:	8082                	ret

00000000800021c2 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    800021c2:	1101                	addi	sp,sp,-32
    800021c4:	ec06                	sd	ra,24(sp)
    800021c6:	e822                	sd	s0,16(sp)
    800021c8:	e426                	sd	s1,8(sp)
    800021ca:	1000                	addi	s0,sp,32
    800021cc:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800021ce:	00000097          	auipc	ra,0x0
    800021d2:	ed0080e7          	jalr	-304(ra) # 8000209e <argraw>
    800021d6:	e088                	sd	a0,0(s1)
  return 0;
}
    800021d8:	4501                	li	a0,0
    800021da:	60e2                	ld	ra,24(sp)
    800021dc:	6442                	ld	s0,16(sp)
    800021de:	64a2                	ld	s1,8(sp)
    800021e0:	6105                	addi	sp,sp,32
    800021e2:	8082                	ret

00000000800021e4 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    800021e4:	1101                	addi	sp,sp,-32
    800021e6:	ec06                	sd	ra,24(sp)
    800021e8:	e822                	sd	s0,16(sp)
    800021ea:	e426                	sd	s1,8(sp)
    800021ec:	e04a                	sd	s2,0(sp)
    800021ee:	1000                	addi	s0,sp,32
    800021f0:	84ae                	mv	s1,a1
    800021f2:	8932                	mv	s2,a2
  *ip = argraw(n);
    800021f4:	00000097          	auipc	ra,0x0
    800021f8:	eaa080e7          	jalr	-342(ra) # 8000209e <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    800021fc:	864a                	mv	a2,s2
    800021fe:	85a6                	mv	a1,s1
    80002200:	00000097          	auipc	ra,0x0
    80002204:	f58080e7          	jalr	-168(ra) # 80002158 <fetchstr>
}
    80002208:	60e2                	ld	ra,24(sp)
    8000220a:	6442                	ld	s0,16(sp)
    8000220c:	64a2                	ld	s1,8(sp)
    8000220e:	6902                	ld	s2,0(sp)
    80002210:	6105                	addi	sp,sp,32
    80002212:	8082                	ret

0000000080002214 <syscall>:



void
syscall(void)
{
    80002214:	1101                	addi	sp,sp,-32
    80002216:	ec06                	sd	ra,24(sp)
    80002218:	e822                	sd	s0,16(sp)
    8000221a:	e426                	sd	s1,8(sp)
    8000221c:	e04a                	sd	s2,0(sp)
    8000221e:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002220:	fffff097          	auipc	ra,0xfffff
    80002224:	ed4080e7          	jalr	-300(ra) # 800010f4 <myproc>
    80002228:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    8000222a:	05853903          	ld	s2,88(a0)
    8000222e:	0a893783          	ld	a5,168(s2)
    80002232:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002236:	37fd                	addiw	a5,a5,-1
    80002238:	477d                	li	a4,31
    8000223a:	00f76f63          	bltu	a4,a5,80002258 <syscall+0x44>
    8000223e:	00369713          	slli	a4,a3,0x3
    80002242:	00006797          	auipc	a5,0x6
    80002246:	1d678793          	addi	a5,a5,470 # 80008418 <syscalls>
    8000224a:	97ba                	add	a5,a5,a4
    8000224c:	639c                	ld	a5,0(a5)
    8000224e:	c789                	beqz	a5,80002258 <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    80002250:	9782                	jalr	a5
    80002252:	06a93823          	sd	a0,112(s2)
    80002256:	a839                	j	80002274 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002258:	15848613          	addi	a2,s1,344
    8000225c:	588c                	lw	a1,48(s1)
    8000225e:	00006517          	auipc	a0,0x6
    80002262:	18250513          	addi	a0,a0,386 # 800083e0 <states.1805+0x150>
    80002266:	00004097          	auipc	ra,0x4
    8000226a:	efc080e7          	jalr	-260(ra) # 80006162 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    8000226e:	6cbc                	ld	a5,88(s1)
    80002270:	577d                	li	a4,-1
    80002272:	fbb8                	sd	a4,112(a5)
  }
}
    80002274:	60e2                	ld	ra,24(sp)
    80002276:	6442                	ld	s0,16(sp)
    80002278:	64a2                	ld	s1,8(sp)
    8000227a:	6902                	ld	s2,0(sp)
    8000227c:	6105                	addi	sp,sp,32
    8000227e:	8082                	ret

0000000080002280 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002280:	1101                	addi	sp,sp,-32
    80002282:	ec06                	sd	ra,24(sp)
    80002284:	e822                	sd	s0,16(sp)
    80002286:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    80002288:	fec40593          	addi	a1,s0,-20
    8000228c:	4501                	li	a0,0
    8000228e:	00000097          	auipc	ra,0x0
    80002292:	f12080e7          	jalr	-238(ra) # 800021a0 <argint>
    return -1;
    80002296:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002298:	00054963          	bltz	a0,800022aa <sys_exit+0x2a>
  exit(n);
    8000229c:	fec42503          	lw	a0,-20(s0)
    800022a0:	fffff097          	auipc	ra,0xfffff
    800022a4:	76c080e7          	jalr	1900(ra) # 80001a0c <exit>
  return 0;  // not reached
    800022a8:	4781                	li	a5,0
}
    800022aa:	853e                	mv	a0,a5
    800022ac:	60e2                	ld	ra,24(sp)
    800022ae:	6442                	ld	s0,16(sp)
    800022b0:	6105                	addi	sp,sp,32
    800022b2:	8082                	ret

00000000800022b4 <sys_getpid>:

uint64
sys_getpid(void)
{
    800022b4:	1141                	addi	sp,sp,-16
    800022b6:	e406                	sd	ra,8(sp)
    800022b8:	e022                	sd	s0,0(sp)
    800022ba:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800022bc:	fffff097          	auipc	ra,0xfffff
    800022c0:	e38080e7          	jalr	-456(ra) # 800010f4 <myproc>
}
    800022c4:	5908                	lw	a0,48(a0)
    800022c6:	60a2                	ld	ra,8(sp)
    800022c8:	6402                	ld	s0,0(sp)
    800022ca:	0141                	addi	sp,sp,16
    800022cc:	8082                	ret

00000000800022ce <sys_fork>:

uint64
sys_fork(void)
{
    800022ce:	1141                	addi	sp,sp,-16
    800022d0:	e406                	sd	ra,8(sp)
    800022d2:	e022                	sd	s0,0(sp)
    800022d4:	0800                	addi	s0,sp,16
  return fork();
    800022d6:	fffff097          	auipc	ra,0xfffff
    800022da:	1ec080e7          	jalr	492(ra) # 800014c2 <fork>
}
    800022de:	60a2                	ld	ra,8(sp)
    800022e0:	6402                	ld	s0,0(sp)
    800022e2:	0141                	addi	sp,sp,16
    800022e4:	8082                	ret

00000000800022e6 <sys_wait>:

uint64
sys_wait(void)
{
    800022e6:	1101                	addi	sp,sp,-32
    800022e8:	ec06                	sd	ra,24(sp)
    800022ea:	e822                	sd	s0,16(sp)
    800022ec:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    800022ee:	fe840593          	addi	a1,s0,-24
    800022f2:	4501                	li	a0,0
    800022f4:	00000097          	auipc	ra,0x0
    800022f8:	ece080e7          	jalr	-306(ra) # 800021c2 <argaddr>
    800022fc:	87aa                	mv	a5,a0
    return -1;
    800022fe:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    80002300:	0007c863          	bltz	a5,80002310 <sys_wait+0x2a>
  return wait(p);
    80002304:	fe843503          	ld	a0,-24(s0)
    80002308:	fffff097          	auipc	ra,0xfffff
    8000230c:	50c080e7          	jalr	1292(ra) # 80001814 <wait>
}
    80002310:	60e2                	ld	ra,24(sp)
    80002312:	6442                	ld	s0,16(sp)
    80002314:	6105                	addi	sp,sp,32
    80002316:	8082                	ret

0000000080002318 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002318:	7179                	addi	sp,sp,-48
    8000231a:	f406                	sd	ra,40(sp)
    8000231c:	f022                	sd	s0,32(sp)
    8000231e:	ec26                	sd	s1,24(sp)
    80002320:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    80002322:	fdc40593          	addi	a1,s0,-36
    80002326:	4501                	li	a0,0
    80002328:	00000097          	auipc	ra,0x0
    8000232c:	e78080e7          	jalr	-392(ra) # 800021a0 <argint>
    80002330:	87aa                	mv	a5,a0
    return -1;
    80002332:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    80002334:	0207c063          	bltz	a5,80002354 <sys_sbrk+0x3c>
  
  addr = myproc()->sz;
    80002338:	fffff097          	auipc	ra,0xfffff
    8000233c:	dbc080e7          	jalr	-580(ra) # 800010f4 <myproc>
    80002340:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    80002342:	fdc42503          	lw	a0,-36(s0)
    80002346:	fffff097          	auipc	ra,0xfffff
    8000234a:	108080e7          	jalr	264(ra) # 8000144e <growproc>
    8000234e:	00054863          	bltz	a0,8000235e <sys_sbrk+0x46>
    return -1;
  return addr;
    80002352:	8526                	mv	a0,s1
}
    80002354:	70a2                	ld	ra,40(sp)
    80002356:	7402                	ld	s0,32(sp)
    80002358:	64e2                	ld	s1,24(sp)
    8000235a:	6145                	addi	sp,sp,48
    8000235c:	8082                	ret
    return -1;
    8000235e:	557d                	li	a0,-1
    80002360:	bfd5                	j	80002354 <sys_sbrk+0x3c>

0000000080002362 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002362:	7139                	addi	sp,sp,-64
    80002364:	fc06                	sd	ra,56(sp)
    80002366:	f822                	sd	s0,48(sp)
    80002368:	f426                	sd	s1,40(sp)
    8000236a:	f04a                	sd	s2,32(sp)
    8000236c:	ec4e                	sd	s3,24(sp)
    8000236e:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;


  if(argint(0, &n) < 0)
    80002370:	fcc40593          	addi	a1,s0,-52
    80002374:	4501                	li	a0,0
    80002376:	00000097          	auipc	ra,0x0
    8000237a:	e2a080e7          	jalr	-470(ra) # 800021a0 <argint>
    return -1;
    8000237e:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002380:	06054563          	bltz	a0,800023ea <sys_sleep+0x88>
  acquire(&tickslock);
    80002384:	0000d517          	auipc	a0,0xd
    80002388:	afc50513          	addi	a0,a0,-1284 # 8000ee80 <tickslock>
    8000238c:	00004097          	auipc	ra,0x4
    80002390:	2d6080e7          	jalr	726(ra) # 80006662 <acquire>
  ticks0 = ticks;
    80002394:	00007917          	auipc	s2,0x7
    80002398:	c8492903          	lw	s2,-892(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    8000239c:	fcc42783          	lw	a5,-52(s0)
    800023a0:	cf85                	beqz	a5,800023d8 <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800023a2:	0000d997          	auipc	s3,0xd
    800023a6:	ade98993          	addi	s3,s3,-1314 # 8000ee80 <tickslock>
    800023aa:	00007497          	auipc	s1,0x7
    800023ae:	c6e48493          	addi	s1,s1,-914 # 80009018 <ticks>
    if(myproc()->killed){
    800023b2:	fffff097          	auipc	ra,0xfffff
    800023b6:	d42080e7          	jalr	-702(ra) # 800010f4 <myproc>
    800023ba:	551c                	lw	a5,40(a0)
    800023bc:	ef9d                	bnez	a5,800023fa <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    800023be:	85ce                	mv	a1,s3
    800023c0:	8526                	mv	a0,s1
    800023c2:	fffff097          	auipc	ra,0xfffff
    800023c6:	3ee080e7          	jalr	1006(ra) # 800017b0 <sleep>
  while(ticks - ticks0 < n){
    800023ca:	409c                	lw	a5,0(s1)
    800023cc:	412787bb          	subw	a5,a5,s2
    800023d0:	fcc42703          	lw	a4,-52(s0)
    800023d4:	fce7efe3          	bltu	a5,a4,800023b2 <sys_sleep+0x50>
  }
  release(&tickslock);
    800023d8:	0000d517          	auipc	a0,0xd
    800023dc:	aa850513          	addi	a0,a0,-1368 # 8000ee80 <tickslock>
    800023e0:	00004097          	auipc	ra,0x4
    800023e4:	336080e7          	jalr	822(ra) # 80006716 <release>
  return 0;
    800023e8:	4781                	li	a5,0
}
    800023ea:	853e                	mv	a0,a5
    800023ec:	70e2                	ld	ra,56(sp)
    800023ee:	7442                	ld	s0,48(sp)
    800023f0:	74a2                	ld	s1,40(sp)
    800023f2:	7902                	ld	s2,32(sp)
    800023f4:	69e2                	ld	s3,24(sp)
    800023f6:	6121                	addi	sp,sp,64
    800023f8:	8082                	ret
      release(&tickslock);
    800023fa:	0000d517          	auipc	a0,0xd
    800023fe:	a8650513          	addi	a0,a0,-1402 # 8000ee80 <tickslock>
    80002402:	00004097          	auipc	ra,0x4
    80002406:	314080e7          	jalr	788(ra) # 80006716 <release>
      return -1;
    8000240a:	57fd                	li	a5,-1
    8000240c:	bff9                	j	800023ea <sys_sleep+0x88>

000000008000240e <sys_pgaccess>:


#ifdef LAB_PGTBL
int
sys_pgaccess(void)
{
    8000240e:	1141                	addi	sp,sp,-16
    80002410:	e422                	sd	s0,8(sp)
    80002412:	0800                	addi	s0,sp,16
  // lab pgtbl: your code here.
  return 0;
}
    80002414:	4501                	li	a0,0
    80002416:	6422                	ld	s0,8(sp)
    80002418:	0141                	addi	sp,sp,16
    8000241a:	8082                	ret

000000008000241c <sys_kill>:
#endif

uint64
sys_kill(void)
{
    8000241c:	1101                	addi	sp,sp,-32
    8000241e:	ec06                	sd	ra,24(sp)
    80002420:	e822                	sd	s0,16(sp)
    80002422:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    80002424:	fec40593          	addi	a1,s0,-20
    80002428:	4501                	li	a0,0
    8000242a:	00000097          	auipc	ra,0x0
    8000242e:	d76080e7          	jalr	-650(ra) # 800021a0 <argint>
    80002432:	87aa                	mv	a5,a0
    return -1;
    80002434:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    80002436:	0007c863          	bltz	a5,80002446 <sys_kill+0x2a>
  return kill(pid);
    8000243a:	fec42503          	lw	a0,-20(s0)
    8000243e:	fffff097          	auipc	ra,0xfffff
    80002442:	6a4080e7          	jalr	1700(ra) # 80001ae2 <kill>
}
    80002446:	60e2                	ld	ra,24(sp)
    80002448:	6442                	ld	s0,16(sp)
    8000244a:	6105                	addi	sp,sp,32
    8000244c:	8082                	ret

000000008000244e <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    8000244e:	1101                	addi	sp,sp,-32
    80002450:	ec06                	sd	ra,24(sp)
    80002452:	e822                	sd	s0,16(sp)
    80002454:	e426                	sd	s1,8(sp)
    80002456:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002458:	0000d517          	auipc	a0,0xd
    8000245c:	a2850513          	addi	a0,a0,-1496 # 8000ee80 <tickslock>
    80002460:	00004097          	auipc	ra,0x4
    80002464:	202080e7          	jalr	514(ra) # 80006662 <acquire>
  xticks = ticks;
    80002468:	00007497          	auipc	s1,0x7
    8000246c:	bb04a483          	lw	s1,-1104(s1) # 80009018 <ticks>
  release(&tickslock);
    80002470:	0000d517          	auipc	a0,0xd
    80002474:	a1050513          	addi	a0,a0,-1520 # 8000ee80 <tickslock>
    80002478:	00004097          	auipc	ra,0x4
    8000247c:	29e080e7          	jalr	670(ra) # 80006716 <release>
  return xticks;
}
    80002480:	02049513          	slli	a0,s1,0x20
    80002484:	9101                	srli	a0,a0,0x20
    80002486:	60e2                	ld	ra,24(sp)
    80002488:	6442                	ld	s0,16(sp)
    8000248a:	64a2                	ld	s1,8(sp)
    8000248c:	6105                	addi	sp,sp,32
    8000248e:	8082                	ret

0000000080002490 <bget>:
// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return locked buffer.
static struct buf*
bget(uint dev, uint blockno)
{
    80002490:	7179                	addi	sp,sp,-48
    80002492:	f406                	sd	ra,40(sp)
    80002494:	f022                	sd	s0,32(sp)
    80002496:	ec26                	sd	s1,24(sp)
    80002498:	e84a                	sd	s2,16(sp)
    8000249a:	e44e                	sd	s3,8(sp)
    8000249c:	1800                	addi	s0,sp,48
    8000249e:	892a                	mv	s2,a0
    800024a0:	89ae                	mv	s3,a1
  struct buf *b;

  acquire(&bcache.lock);
    800024a2:	0000d517          	auipc	a0,0xd
    800024a6:	9f650513          	addi	a0,a0,-1546 # 8000ee98 <bcache>
    800024aa:	00004097          	auipc	ra,0x4
    800024ae:	1b8080e7          	jalr	440(ra) # 80006662 <acquire>

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800024b2:	00015497          	auipc	s1,0x15
    800024b6:	c9e4b483          	ld	s1,-866(s1) # 80017150 <bcache+0x82b8>
    800024ba:	00015797          	auipc	a5,0x15
    800024be:	c4678793          	addi	a5,a5,-954 # 80017100 <bcache+0x8268>
    800024c2:	02f48f63          	beq	s1,a5,80002500 <bget+0x70>
    800024c6:	873e                	mv	a4,a5
    800024c8:	a021                	j	800024d0 <bget+0x40>
    800024ca:	68a4                	ld	s1,80(s1)
    800024cc:	02e48a63          	beq	s1,a4,80002500 <bget+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800024d0:	449c                	lw	a5,8(s1)
    800024d2:	ff279ce3          	bne	a5,s2,800024ca <bget+0x3a>
    800024d6:	44dc                	lw	a5,12(s1)
    800024d8:	ff3799e3          	bne	a5,s3,800024ca <bget+0x3a>
      b->refcnt++;
    800024dc:	40bc                	lw	a5,64(s1)
    800024de:	2785                	addiw	a5,a5,1
    800024e0:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800024e2:	0000d517          	auipc	a0,0xd
    800024e6:	9b650513          	addi	a0,a0,-1610 # 8000ee98 <bcache>
    800024ea:	00004097          	auipc	ra,0x4
    800024ee:	22c080e7          	jalr	556(ra) # 80006716 <release>
      acquiresleep(&b->lock);
    800024f2:	01048513          	addi	a0,s1,16
    800024f6:	00001097          	auipc	ra,0x1
    800024fa:	736080e7          	jalr	1846(ra) # 80003c2c <acquiresleep>
      return b;
    800024fe:	a8b9                	j	8000255c <bget+0xcc>
    }
  }

  // Not cached.
  // Recycle the least recently used (LRU) unused buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002500:	00015497          	auipc	s1,0x15
    80002504:	c484b483          	ld	s1,-952(s1) # 80017148 <bcache+0x82b0>
    80002508:	00015797          	auipc	a5,0x15
    8000250c:	bf878793          	addi	a5,a5,-1032 # 80017100 <bcache+0x8268>
    80002510:	00f48863          	beq	s1,a5,80002520 <bget+0x90>
    80002514:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002516:	40bc                	lw	a5,64(s1)
    80002518:	cf81                	beqz	a5,80002530 <bget+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000251a:	64a4                	ld	s1,72(s1)
    8000251c:	fee49de3          	bne	s1,a4,80002516 <bget+0x86>
      release(&bcache.lock);
      acquiresleep(&b->lock);
      return b;
    }
  }
  panic("bget: no buffers");
    80002520:	00006517          	auipc	a0,0x6
    80002524:	00050513          	mv	a0,a0
    80002528:	00004097          	auipc	ra,0x4
    8000252c:	bf0080e7          	jalr	-1040(ra) # 80006118 <panic>
      b->dev = dev;
    80002530:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002534:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002538:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000253c:	4785                	li	a5,1
    8000253e:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002540:	0000d517          	auipc	a0,0xd
    80002544:	95850513          	addi	a0,a0,-1704 # 8000ee98 <bcache>
    80002548:	00004097          	auipc	ra,0x4
    8000254c:	1ce080e7          	jalr	462(ra) # 80006716 <release>
      acquiresleep(&b->lock);
    80002550:	01048513          	addi	a0,s1,16
    80002554:	00001097          	auipc	ra,0x1
    80002558:	6d8080e7          	jalr	1752(ra) # 80003c2c <acquiresleep>
}
    8000255c:	8526                	mv	a0,s1
    8000255e:	70a2                	ld	ra,40(sp)
    80002560:	7402                	ld	s0,32(sp)
    80002562:	64e2                	ld	s1,24(sp)
    80002564:	6942                	ld	s2,16(sp)
    80002566:	69a2                	ld	s3,8(sp)
    80002568:	6145                	addi	sp,sp,48
    8000256a:	8082                	ret

000000008000256c <binit>:
{
    8000256c:	7179                	addi	sp,sp,-48
    8000256e:	f406                	sd	ra,40(sp)
    80002570:	f022                	sd	s0,32(sp)
    80002572:	ec26                	sd	s1,24(sp)
    80002574:	e84a                	sd	s2,16(sp)
    80002576:	e44e                	sd	s3,8(sp)
    80002578:	e052                	sd	s4,0(sp)
    8000257a:	1800                	addi	s0,sp,48
  initlock(&bcache.lock, "bcache");
    8000257c:	00006597          	auipc	a1,0x6
    80002580:	fbc58593          	addi	a1,a1,-68 # 80008538 <syscalls+0x120>
    80002584:	0000d517          	auipc	a0,0xd
    80002588:	91450513          	addi	a0,a0,-1772 # 8000ee98 <bcache>
    8000258c:	00004097          	auipc	ra,0x4
    80002590:	046080e7          	jalr	70(ra) # 800065d2 <initlock>
  bcache.head.prev = &bcache.head;
    80002594:	00015797          	auipc	a5,0x15
    80002598:	90478793          	addi	a5,a5,-1788 # 80016e98 <bcache+0x8000>
    8000259c:	00015717          	auipc	a4,0x15
    800025a0:	b6470713          	addi	a4,a4,-1180 # 80017100 <bcache+0x8268>
    800025a4:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800025a8:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800025ac:	0000d497          	auipc	s1,0xd
    800025b0:	90448493          	addi	s1,s1,-1788 # 8000eeb0 <bcache+0x18>
    b->next = bcache.head.next;
    800025b4:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800025b6:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800025b8:	00006a17          	auipc	s4,0x6
    800025bc:	f88a0a13          	addi	s4,s4,-120 # 80008540 <syscalls+0x128>
    b->next = bcache.head.next;
    800025c0:	2b893783          	ld	a5,696(s2)
    800025c4:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800025c6:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800025ca:	85d2                	mv	a1,s4
    800025cc:	01048513          	addi	a0,s1,16
    800025d0:	00001097          	auipc	ra,0x1
    800025d4:	622080e7          	jalr	1570(ra) # 80003bf2 <initsleeplock>
    bcache.head.next->prev = b;
    800025d8:	2b893783          	ld	a5,696(s2)
    800025dc:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800025de:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800025e2:	45848493          	addi	s1,s1,1112
    800025e6:	fd349de3          	bne	s1,s3,800025c0 <binit+0x54>
}
    800025ea:	70a2                	ld	ra,40(sp)
    800025ec:	7402                	ld	s0,32(sp)
    800025ee:	64e2                	ld	s1,24(sp)
    800025f0:	6942                	ld	s2,16(sp)
    800025f2:	69a2                	ld	s3,8(sp)
    800025f4:	6a02                	ld	s4,0(sp)
    800025f6:	6145                	addi	sp,sp,48
    800025f8:	8082                	ret

00000000800025fa <bread>:

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800025fa:	1101                	addi	sp,sp,-32
    800025fc:	ec06                	sd	ra,24(sp)
    800025fe:	e822                	sd	s0,16(sp)
    80002600:	e426                	sd	s1,8(sp)
    80002602:	1000                	addi	s0,sp,32
  struct buf *b;

  b = bget(dev, blockno);
    80002604:	00000097          	auipc	ra,0x0
    80002608:	e8c080e7          	jalr	-372(ra) # 80002490 <bget>
    8000260c:	84aa                	mv	s1,a0
  if(!b->valid) {
    8000260e:	411c                	lw	a5,0(a0)
    80002610:	c799                	beqz	a5,8000261e <bread+0x24>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002612:	8526                	mv	a0,s1
    80002614:	60e2                	ld	ra,24(sp)
    80002616:	6442                	ld	s0,16(sp)
    80002618:	64a2                	ld	s1,8(sp)
    8000261a:	6105                	addi	sp,sp,32
    8000261c:	8082                	ret
    virtio_disk_rw(b, 0);
    8000261e:	4581                	li	a1,0
    80002620:	00003097          	auipc	ra,0x3
    80002624:	136080e7          	jalr	310(ra) # 80005756 <virtio_disk_rw>
    b->valid = 1;
    80002628:	4785                	li	a5,1
    8000262a:	c09c                	sw	a5,0(s1)
  return b;
    8000262c:	b7dd                	j	80002612 <bread+0x18>

000000008000262e <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    8000262e:	1101                	addi	sp,sp,-32
    80002630:	ec06                	sd	ra,24(sp)
    80002632:	e822                	sd	s0,16(sp)
    80002634:	e426                	sd	s1,8(sp)
    80002636:	1000                	addi	s0,sp,32
    80002638:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000263a:	0541                	addi	a0,a0,16
    8000263c:	00001097          	auipc	ra,0x1
    80002640:	68a080e7          	jalr	1674(ra) # 80003cc6 <holdingsleep>
    80002644:	cd01                	beqz	a0,8000265c <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002646:	4585                	li	a1,1
    80002648:	8526                	mv	a0,s1
    8000264a:	00003097          	auipc	ra,0x3
    8000264e:	10c080e7          	jalr	268(ra) # 80005756 <virtio_disk_rw>
}
    80002652:	60e2                	ld	ra,24(sp)
    80002654:	6442                	ld	s0,16(sp)
    80002656:	64a2                	ld	s1,8(sp)
    80002658:	6105                	addi	sp,sp,32
    8000265a:	8082                	ret
    panic("bwrite");
    8000265c:	00006517          	auipc	a0,0x6
    80002660:	eec50513          	addi	a0,a0,-276 # 80008548 <syscalls+0x130>
    80002664:	00004097          	auipc	ra,0x4
    80002668:	ab4080e7          	jalr	-1356(ra) # 80006118 <panic>

000000008000266c <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    8000266c:	1101                	addi	sp,sp,-32
    8000266e:	ec06                	sd	ra,24(sp)
    80002670:	e822                	sd	s0,16(sp)
    80002672:	e426                	sd	s1,8(sp)
    80002674:	e04a                	sd	s2,0(sp)
    80002676:	1000                	addi	s0,sp,32
    80002678:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000267a:	01050913          	addi	s2,a0,16
    8000267e:	854a                	mv	a0,s2
    80002680:	00001097          	auipc	ra,0x1
    80002684:	646080e7          	jalr	1606(ra) # 80003cc6 <holdingsleep>
    80002688:	c92d                	beqz	a0,800026fa <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    8000268a:	854a                	mv	a0,s2
    8000268c:	00001097          	auipc	ra,0x1
    80002690:	5f6080e7          	jalr	1526(ra) # 80003c82 <releasesleep>

  acquire(&bcache.lock);
    80002694:	0000d517          	auipc	a0,0xd
    80002698:	80450513          	addi	a0,a0,-2044 # 8000ee98 <bcache>
    8000269c:	00004097          	auipc	ra,0x4
    800026a0:	fc6080e7          	jalr	-58(ra) # 80006662 <acquire>
  b->refcnt--;
    800026a4:	40bc                	lw	a5,64(s1)
    800026a6:	37fd                	addiw	a5,a5,-1
    800026a8:	0007871b          	sext.w	a4,a5
    800026ac:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800026ae:	eb05                	bnez	a4,800026de <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800026b0:	68bc                	ld	a5,80(s1)
    800026b2:	64b8                	ld	a4,72(s1)
    800026b4:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    800026b6:	64bc                	ld	a5,72(s1)
    800026b8:	68b8                	ld	a4,80(s1)
    800026ba:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800026bc:	00014797          	auipc	a5,0x14
    800026c0:	7dc78793          	addi	a5,a5,2012 # 80016e98 <bcache+0x8000>
    800026c4:	2b87b703          	ld	a4,696(a5)
    800026c8:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800026ca:	00015717          	auipc	a4,0x15
    800026ce:	a3670713          	addi	a4,a4,-1482 # 80017100 <bcache+0x8268>
    800026d2:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800026d4:	2b87b703          	ld	a4,696(a5)
    800026d8:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800026da:	2a97bc23          	sd	s1,696(a5)
  }

  release(&bcache.lock);
    800026de:	0000c517          	auipc	a0,0xc
    800026e2:	7ba50513          	addi	a0,a0,1978 # 8000ee98 <bcache>
    800026e6:	00004097          	auipc	ra,0x4
    800026ea:	030080e7          	jalr	48(ra) # 80006716 <release>
}
    800026ee:	60e2                	ld	ra,24(sp)
    800026f0:	6442                	ld	s0,16(sp)
    800026f2:	64a2                	ld	s1,8(sp)
    800026f4:	6902                	ld	s2,0(sp)
    800026f6:	6105                	addi	sp,sp,32
    800026f8:	8082                	ret
    panic("brelse");
    800026fa:	00006517          	auipc	a0,0x6
    800026fe:	e5650513          	addi	a0,a0,-426 # 80008550 <syscalls+0x138>
    80002702:	00004097          	auipc	ra,0x4
    80002706:	a16080e7          	jalr	-1514(ra) # 80006118 <panic>

000000008000270a <bpin>:

void
bpin(struct buf *b) {
    8000270a:	1101                	addi	sp,sp,-32
    8000270c:	ec06                	sd	ra,24(sp)
    8000270e:	e822                	sd	s0,16(sp)
    80002710:	e426                	sd	s1,8(sp)
    80002712:	1000                	addi	s0,sp,32
    80002714:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002716:	0000c517          	auipc	a0,0xc
    8000271a:	78250513          	addi	a0,a0,1922 # 8000ee98 <bcache>
    8000271e:	00004097          	auipc	ra,0x4
    80002722:	f44080e7          	jalr	-188(ra) # 80006662 <acquire>
  b->refcnt++;
    80002726:	40bc                	lw	a5,64(s1)
    80002728:	2785                	addiw	a5,a5,1
    8000272a:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000272c:	0000c517          	auipc	a0,0xc
    80002730:	76c50513          	addi	a0,a0,1900 # 8000ee98 <bcache>
    80002734:	00004097          	auipc	ra,0x4
    80002738:	fe2080e7          	jalr	-30(ra) # 80006716 <release>
}
    8000273c:	60e2                	ld	ra,24(sp)
    8000273e:	6442                	ld	s0,16(sp)
    80002740:	64a2                	ld	s1,8(sp)
    80002742:	6105                	addi	sp,sp,32
    80002744:	8082                	ret

0000000080002746 <bunpin>:

void
bunpin(struct buf *b) {
    80002746:	1101                	addi	sp,sp,-32
    80002748:	ec06                	sd	ra,24(sp)
    8000274a:	e822                	sd	s0,16(sp)
    8000274c:	e426                	sd	s1,8(sp)
    8000274e:	1000                	addi	s0,sp,32
    80002750:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002752:	0000c517          	auipc	a0,0xc
    80002756:	74650513          	addi	a0,a0,1862 # 8000ee98 <bcache>
    8000275a:	00004097          	auipc	ra,0x4
    8000275e:	f08080e7          	jalr	-248(ra) # 80006662 <acquire>
  b->refcnt--;
    80002762:	40bc                	lw	a5,64(s1)
    80002764:	37fd                	addiw	a5,a5,-1
    80002766:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002768:	0000c517          	auipc	a0,0xc
    8000276c:	73050513          	addi	a0,a0,1840 # 8000ee98 <bcache>
    80002770:	00004097          	auipc	ra,0x4
    80002774:	fa6080e7          	jalr	-90(ra) # 80006716 <release>
}
    80002778:	60e2                	ld	ra,24(sp)
    8000277a:	6442                	ld	s0,16(sp)
    8000277c:	64a2                	ld	s1,8(sp)
    8000277e:	6105                	addi	sp,sp,32
    80002780:	8082                	ret

0000000080002782 <write_page_to_disk>:

/* NTU OS 2024 */
/* Write 4096 bytes page to the eight consecutive 512-byte blocks starting at blk. */
void write_page_to_disk(uint dev, char *page, uint blk) {
    80002782:	7179                	addi	sp,sp,-48
    80002784:	f406                	sd	ra,40(sp)
    80002786:	f022                	sd	s0,32(sp)
    80002788:	ec26                	sd	s1,24(sp)
    8000278a:	e84a                	sd	s2,16(sp)
    8000278c:	e44e                	sd	s3,8(sp)
    8000278e:	e052                	sd	s4,0(sp)
    80002790:	1800                	addi	s0,sp,48
    80002792:	89b2                	mv	s3,a2
  for (int i = 0; i < 8; i++) {
    80002794:	892e                	mv	s2,a1
    80002796:	6a05                	lui	s4,0x1
    80002798:	9a2e                	add	s4,s4,a1
    // disk
    int offset = i * 512;
    int blk_idx = blk + i;
    struct buf *buffer = bget(ROOTDEV, blk_idx);
    8000279a:	85ce                	mv	a1,s3
    8000279c:	4505                	li	a0,1
    8000279e:	00000097          	auipc	ra,0x0
    800027a2:	cf2080e7          	jalr	-782(ra) # 80002490 <bget>
    800027a6:	84aa                	mv	s1,a0
    memmove(buffer->data, page + offset, 512);
    800027a8:	20000613          	li	a2,512
    800027ac:	85ca                	mv	a1,s2
    800027ae:	05850513          	addi	a0,a0,88
    800027b2:	ffffe097          	auipc	ra,0xffffe
    800027b6:	a26080e7          	jalr	-1498(ra) # 800001d8 <memmove>
    bwrite(buffer);
    800027ba:	8526                	mv	a0,s1
    800027bc:	00000097          	auipc	ra,0x0
    800027c0:	e72080e7          	jalr	-398(ra) # 8000262e <bwrite>
    brelse(buffer);
    800027c4:	8526                	mv	a0,s1
    800027c6:	00000097          	auipc	ra,0x0
    800027ca:	ea6080e7          	jalr	-346(ra) # 8000266c <brelse>
  for (int i = 0; i < 8; i++) {
    800027ce:	2985                	addiw	s3,s3,1
    800027d0:	20090913          	addi	s2,s2,512
    800027d4:	fd4913e3          	bne	s2,s4,8000279a <write_page_to_disk+0x18>
  }
}
    800027d8:	70a2                	ld	ra,40(sp)
    800027da:	7402                	ld	s0,32(sp)
    800027dc:	64e2                	ld	s1,24(sp)
    800027de:	6942                	ld	s2,16(sp)
    800027e0:	69a2                	ld	s3,8(sp)
    800027e2:	6a02                	ld	s4,0(sp)
    800027e4:	6145                	addi	sp,sp,48
    800027e6:	8082                	ret

00000000800027e8 <read_page_from_disk>:

/* NTU OS 2024 */
/* Read 4096 bytes from the eight consecutive 512-byte blocks starting at blk into page. */
void read_page_from_disk(uint dev, char *page, uint blk) {
    800027e8:	7179                	addi	sp,sp,-48
    800027ea:	f406                	sd	ra,40(sp)
    800027ec:	f022                	sd	s0,32(sp)
    800027ee:	ec26                	sd	s1,24(sp)
    800027f0:	e84a                	sd	s2,16(sp)
    800027f2:	e44e                	sd	s3,8(sp)
    800027f4:	e052                	sd	s4,0(sp)
    800027f6:	1800                	addi	s0,sp,48
    800027f8:	89b2                	mv	s3,a2
  for (int i = 0; i < 8; i++) {
    800027fa:	892e                	mv	s2,a1
    800027fc:	6a05                	lui	s4,0x1
    800027fe:	9a2e                	add	s4,s4,a1
    int offset = i * 512;
    int blk_idx = blk + i;
    struct buf *buffer = bread(ROOTDEV, blk_idx);
    80002800:	85ce                	mv	a1,s3
    80002802:	4505                	li	a0,1
    80002804:	00000097          	auipc	ra,0x0
    80002808:	df6080e7          	jalr	-522(ra) # 800025fa <bread>
    8000280c:	84aa                	mv	s1,a0
    memmove(page + offset, buffer->data, 512);
    8000280e:	20000613          	li	a2,512
    80002812:	05850593          	addi	a1,a0,88
    80002816:	854a                	mv	a0,s2
    80002818:	ffffe097          	auipc	ra,0xffffe
    8000281c:	9c0080e7          	jalr	-1600(ra) # 800001d8 <memmove>
    brelse(buffer);
    80002820:	8526                	mv	a0,s1
    80002822:	00000097          	auipc	ra,0x0
    80002826:	e4a080e7          	jalr	-438(ra) # 8000266c <brelse>
  for (int i = 0; i < 8; i++) {
    8000282a:	2985                	addiw	s3,s3,1
    8000282c:	20090913          	addi	s2,s2,512
    80002830:	fd4918e3          	bne	s2,s4,80002800 <read_page_from_disk+0x18>
  }
}
    80002834:	70a2                	ld	ra,40(sp)
    80002836:	7402                	ld	s0,32(sp)
    80002838:	64e2                	ld	s1,24(sp)
    8000283a:	6942                	ld	s2,16(sp)
    8000283c:	69a2                	ld	s3,8(sp)
    8000283e:	6a02                	ld	s4,0(sp)
    80002840:	6145                	addi	sp,sp,48
    80002842:	8082                	ret

0000000080002844 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002844:	1101                	addi	sp,sp,-32
    80002846:	ec06                	sd	ra,24(sp)
    80002848:	e822                	sd	s0,16(sp)
    8000284a:	e426                	sd	s1,8(sp)
    8000284c:	1000                	addi	s0,sp,32
    8000284e:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002850:	00d5d59b          	srliw	a1,a1,0xd
    80002854:	00015797          	auipc	a5,0x15
    80002858:	d207a783          	lw	a5,-736(a5) # 80017574 <sb+0x1c>
    8000285c:	9dbd                	addw	a1,a1,a5
    8000285e:	00000097          	auipc	ra,0x0
    80002862:	d9c080e7          	jalr	-612(ra) # 800025fa <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002866:	0074f713          	andi	a4,s1,7
    8000286a:	4785                	li	a5,1
    8000286c:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002870:	14ce                	slli	s1,s1,0x33
    80002872:	90d9                	srli	s1,s1,0x36
    80002874:	00950733          	add	a4,a0,s1
    80002878:	05874703          	lbu	a4,88(a4)
    8000287c:	00e7f6b3          	and	a3,a5,a4
    80002880:	c285                	beqz	a3,800028a0 <bfree+0x5c>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002882:	94aa                	add	s1,s1,a0
    80002884:	fff7c793          	not	a5,a5
    80002888:	8ff9                	and	a5,a5,a4
    8000288a:	04f48c23          	sb	a5,88(s1)
  //log_write(bp);
  brelse(bp);
    8000288e:	00000097          	auipc	ra,0x0
    80002892:	dde080e7          	jalr	-546(ra) # 8000266c <brelse>
}
    80002896:	60e2                	ld	ra,24(sp)
    80002898:	6442                	ld	s0,16(sp)
    8000289a:	64a2                	ld	s1,8(sp)
    8000289c:	6105                	addi	sp,sp,32
    8000289e:	8082                	ret
    panic("freeing free block");
    800028a0:	00006517          	auipc	a0,0x6
    800028a4:	cb850513          	addi	a0,a0,-840 # 80008558 <syscalls+0x140>
    800028a8:	00004097          	auipc	ra,0x4
    800028ac:	870080e7          	jalr	-1936(ra) # 80006118 <panic>

00000000800028b0 <bzero>:
{
    800028b0:	1101                	addi	sp,sp,-32
    800028b2:	ec06                	sd	ra,24(sp)
    800028b4:	e822                	sd	s0,16(sp)
    800028b6:	e426                	sd	s1,8(sp)
    800028b8:	1000                	addi	s0,sp,32
  bp = bread(dev, bno);
    800028ba:	00000097          	auipc	ra,0x0
    800028be:	d40080e7          	jalr	-704(ra) # 800025fa <bread>
    800028c2:	84aa                	mv	s1,a0
  memset(bp->data, 0, BSIZE);
    800028c4:	40000613          	li	a2,1024
    800028c8:	4581                	li	a1,0
    800028ca:	05850513          	addi	a0,a0,88
    800028ce:	ffffe097          	auipc	ra,0xffffe
    800028d2:	8aa080e7          	jalr	-1878(ra) # 80000178 <memset>
  brelse(bp);
    800028d6:	8526                	mv	a0,s1
    800028d8:	00000097          	auipc	ra,0x0
    800028dc:	d94080e7          	jalr	-620(ra) # 8000266c <brelse>
}
    800028e0:	60e2                	ld	ra,24(sp)
    800028e2:	6442                	ld	s0,16(sp)
    800028e4:	64a2                	ld	s1,8(sp)
    800028e6:	6105                	addi	sp,sp,32
    800028e8:	8082                	ret

00000000800028ea <balloc>:
{
    800028ea:	711d                	addi	sp,sp,-96
    800028ec:	ec86                	sd	ra,88(sp)
    800028ee:	e8a2                	sd	s0,80(sp)
    800028f0:	e4a6                	sd	s1,72(sp)
    800028f2:	e0ca                	sd	s2,64(sp)
    800028f4:	fc4e                	sd	s3,56(sp)
    800028f6:	f852                	sd	s4,48(sp)
    800028f8:	f456                	sd	s5,40(sp)
    800028fa:	f05a                	sd	s6,32(sp)
    800028fc:	ec5e                	sd	s7,24(sp)
    800028fe:	e862                	sd	s8,16(sp)
    80002900:	e466                	sd	s9,8(sp)
    80002902:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002904:	00015797          	auipc	a5,0x15
    80002908:	c587a783          	lw	a5,-936(a5) # 8001755c <sb+0x4>
    8000290c:	cbd1                	beqz	a5,800029a0 <balloc+0xb6>
    8000290e:	8baa                	mv	s7,a0
    80002910:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002912:	00015b17          	auipc	s6,0x15
    80002916:	c46b0b13          	addi	s6,s6,-954 # 80017558 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000291a:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    8000291c:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000291e:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002920:	6c89                	lui	s9,0x2
    80002922:	a829                	j	8000293c <balloc+0x52>
    brelse(bp);
    80002924:	00000097          	auipc	ra,0x0
    80002928:	d48080e7          	jalr	-696(ra) # 8000266c <brelse>
  for(b = 0; b < sb.size; b += BPB){
    8000292c:	015c87bb          	addw	a5,s9,s5
    80002930:	00078a9b          	sext.w	s5,a5
    80002934:	004b2703          	lw	a4,4(s6)
    80002938:	06eaf463          	bgeu	s5,a4,800029a0 <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    8000293c:	41fad79b          	sraiw	a5,s5,0x1f
    80002940:	0137d79b          	srliw	a5,a5,0x13
    80002944:	015787bb          	addw	a5,a5,s5
    80002948:	40d7d79b          	sraiw	a5,a5,0xd
    8000294c:	01cb2583          	lw	a1,28(s6)
    80002950:	9dbd                	addw	a1,a1,a5
    80002952:	855e                	mv	a0,s7
    80002954:	00000097          	auipc	ra,0x0
    80002958:	ca6080e7          	jalr	-858(ra) # 800025fa <bread>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000295c:	004b2803          	lw	a6,4(s6)
    80002960:	000a849b          	sext.w	s1,s5
    80002964:	8662                	mv	a2,s8
    80002966:	0004891b          	sext.w	s2,s1
    8000296a:	fb04fde3          	bgeu	s1,a6,80002924 <balloc+0x3a>
      m = 1 << (bi % 8);
    8000296e:	41f6579b          	sraiw	a5,a2,0x1f
    80002972:	01d7d69b          	srliw	a3,a5,0x1d
    80002976:	00c6873b          	addw	a4,a3,a2
    8000297a:	00777793          	andi	a5,a4,7
    8000297e:	9f95                	subw	a5,a5,a3
    80002980:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002984:	4037571b          	sraiw	a4,a4,0x3
    80002988:	00e506b3          	add	a3,a0,a4
    8000298c:	0586c683          	lbu	a3,88(a3)
    80002990:	00d7f5b3          	and	a1,a5,a3
    80002994:	cd91                	beqz	a1,800029b0 <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002996:	2605                	addiw	a2,a2,1
    80002998:	2485                	addiw	s1,s1,1
    8000299a:	fd4616e3          	bne	a2,s4,80002966 <balloc+0x7c>
    8000299e:	b759                	j	80002924 <balloc+0x3a>
  panic("balloc: out of blocks");
    800029a0:	00006517          	auipc	a0,0x6
    800029a4:	bd050513          	addi	a0,a0,-1072 # 80008570 <syscalls+0x158>
    800029a8:	00003097          	auipc	ra,0x3
    800029ac:	770080e7          	jalr	1904(ra) # 80006118 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    800029b0:	972a                	add	a4,a4,a0
    800029b2:	8fd5                	or	a5,a5,a3
    800029b4:	04f70c23          	sb	a5,88(a4)
        brelse(bp);
    800029b8:	00000097          	auipc	ra,0x0
    800029bc:	cb4080e7          	jalr	-844(ra) # 8000266c <brelse>
        bzero(dev, b + bi);
    800029c0:	85ca                	mv	a1,s2
    800029c2:	855e                	mv	a0,s7
    800029c4:	00000097          	auipc	ra,0x0
    800029c8:	eec080e7          	jalr	-276(ra) # 800028b0 <bzero>
}
    800029cc:	8526                	mv	a0,s1
    800029ce:	60e6                	ld	ra,88(sp)
    800029d0:	6446                	ld	s0,80(sp)
    800029d2:	64a6                	ld	s1,72(sp)
    800029d4:	6906                	ld	s2,64(sp)
    800029d6:	79e2                	ld	s3,56(sp)
    800029d8:	7a42                	ld	s4,48(sp)
    800029da:	7aa2                	ld	s5,40(sp)
    800029dc:	7b02                	ld	s6,32(sp)
    800029de:	6be2                	ld	s7,24(sp)
    800029e0:	6c42                	ld	s8,16(sp)
    800029e2:	6ca2                	ld	s9,8(sp)
    800029e4:	6125                	addi	sp,sp,96
    800029e6:	8082                	ret

00000000800029e8 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    800029e8:	7179                	addi	sp,sp,-48
    800029ea:	f406                	sd	ra,40(sp)
    800029ec:	f022                	sd	s0,32(sp)
    800029ee:	ec26                	sd	s1,24(sp)
    800029f0:	e84a                	sd	s2,16(sp)
    800029f2:	e44e                	sd	s3,8(sp)
    800029f4:	e052                	sd	s4,0(sp)
    800029f6:	1800                	addi	s0,sp,48
    800029f8:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800029fa:	47ad                	li	a5,11
    800029fc:	04b7fe63          	bgeu	a5,a1,80002a58 <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    80002a00:	ff45849b          	addiw	s1,a1,-12
    80002a04:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002a08:	0ff00793          	li	a5,255
    80002a0c:	08e7ee63          	bltu	a5,a4,80002aa8 <bmap+0xc0>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    80002a10:	08052583          	lw	a1,128(a0)
    80002a14:	c5ad                	beqz	a1,80002a7e <bmap+0x96>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    80002a16:	00092503          	lw	a0,0(s2)
    80002a1a:	00000097          	auipc	ra,0x0
    80002a1e:	be0080e7          	jalr	-1056(ra) # 800025fa <bread>
    80002a22:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002a24:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002a28:	02049593          	slli	a1,s1,0x20
    80002a2c:	9181                	srli	a1,a1,0x20
    80002a2e:	058a                	slli	a1,a1,0x2
    80002a30:	00b784b3          	add	s1,a5,a1
    80002a34:	0004a983          	lw	s3,0(s1)
    80002a38:	04098d63          	beqz	s3,80002a92 <bmap+0xaa>
      a[bn] = addr = balloc(ip->dev);
      //log_write(bp);
    }
    brelse(bp);
    80002a3c:	8552                	mv	a0,s4
    80002a3e:	00000097          	auipc	ra,0x0
    80002a42:	c2e080e7          	jalr	-978(ra) # 8000266c <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80002a46:	854e                	mv	a0,s3
    80002a48:	70a2                	ld	ra,40(sp)
    80002a4a:	7402                	ld	s0,32(sp)
    80002a4c:	64e2                	ld	s1,24(sp)
    80002a4e:	6942                	ld	s2,16(sp)
    80002a50:	69a2                	ld	s3,8(sp)
    80002a52:	6a02                	ld	s4,0(sp)
    80002a54:	6145                	addi	sp,sp,48
    80002a56:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    80002a58:	02059493          	slli	s1,a1,0x20
    80002a5c:	9081                	srli	s1,s1,0x20
    80002a5e:	048a                	slli	s1,s1,0x2
    80002a60:	94aa                	add	s1,s1,a0
    80002a62:	0504a983          	lw	s3,80(s1)
    80002a66:	fe0990e3          	bnez	s3,80002a46 <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    80002a6a:	4108                	lw	a0,0(a0)
    80002a6c:	00000097          	auipc	ra,0x0
    80002a70:	e7e080e7          	jalr	-386(ra) # 800028ea <balloc>
    80002a74:	0005099b          	sext.w	s3,a0
    80002a78:	0534a823          	sw	s3,80(s1)
    80002a7c:	b7e9                	j	80002a46 <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    80002a7e:	4108                	lw	a0,0(a0)
    80002a80:	00000097          	auipc	ra,0x0
    80002a84:	e6a080e7          	jalr	-406(ra) # 800028ea <balloc>
    80002a88:	0005059b          	sext.w	a1,a0
    80002a8c:	08b92023          	sw	a1,128(s2)
    80002a90:	b759                	j	80002a16 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    80002a92:	00092503          	lw	a0,0(s2)
    80002a96:	00000097          	auipc	ra,0x0
    80002a9a:	e54080e7          	jalr	-428(ra) # 800028ea <balloc>
    80002a9e:	0005099b          	sext.w	s3,a0
    80002aa2:	0134a023          	sw	s3,0(s1)
    80002aa6:	bf59                	j	80002a3c <bmap+0x54>
  panic("bmap: out of range");
    80002aa8:	00006517          	auipc	a0,0x6
    80002aac:	ae050513          	addi	a0,a0,-1312 # 80008588 <syscalls+0x170>
    80002ab0:	00003097          	auipc	ra,0x3
    80002ab4:	668080e7          	jalr	1640(ra) # 80006118 <panic>

0000000080002ab8 <iget>:
{
    80002ab8:	7179                	addi	sp,sp,-48
    80002aba:	f406                	sd	ra,40(sp)
    80002abc:	f022                	sd	s0,32(sp)
    80002abe:	ec26                	sd	s1,24(sp)
    80002ac0:	e84a                	sd	s2,16(sp)
    80002ac2:	e44e                	sd	s3,8(sp)
    80002ac4:	e052                	sd	s4,0(sp)
    80002ac6:	1800                	addi	s0,sp,48
    80002ac8:	89aa                	mv	s3,a0
    80002aca:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002acc:	00015517          	auipc	a0,0x15
    80002ad0:	aac50513          	addi	a0,a0,-1364 # 80017578 <itable>
    80002ad4:	00004097          	auipc	ra,0x4
    80002ad8:	b8e080e7          	jalr	-1138(ra) # 80006662 <acquire>
  empty = 0;
    80002adc:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002ade:	00015497          	auipc	s1,0x15
    80002ae2:	ab248493          	addi	s1,s1,-1358 # 80017590 <itable+0x18>
    80002ae6:	00016697          	auipc	a3,0x16
    80002aea:	53a68693          	addi	a3,a3,1338 # 80019020 <log>
    80002aee:	a039                	j	80002afc <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002af0:	02090b63          	beqz	s2,80002b26 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002af4:	08848493          	addi	s1,s1,136
    80002af8:	02d48a63          	beq	s1,a3,80002b2c <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002afc:	449c                	lw	a5,8(s1)
    80002afe:	fef059e3          	blez	a5,80002af0 <iget+0x38>
    80002b02:	4098                	lw	a4,0(s1)
    80002b04:	ff3716e3          	bne	a4,s3,80002af0 <iget+0x38>
    80002b08:	40d8                	lw	a4,4(s1)
    80002b0a:	ff4713e3          	bne	a4,s4,80002af0 <iget+0x38>
      ip->ref++;
    80002b0e:	2785                	addiw	a5,a5,1
    80002b10:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002b12:	00015517          	auipc	a0,0x15
    80002b16:	a6650513          	addi	a0,a0,-1434 # 80017578 <itable>
    80002b1a:	00004097          	auipc	ra,0x4
    80002b1e:	bfc080e7          	jalr	-1028(ra) # 80006716 <release>
      return ip;
    80002b22:	8926                	mv	s2,s1
    80002b24:	a03d                	j	80002b52 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002b26:	f7f9                	bnez	a5,80002af4 <iget+0x3c>
    80002b28:	8926                	mv	s2,s1
    80002b2a:	b7e9                	j	80002af4 <iget+0x3c>
  if(empty == 0)
    80002b2c:	02090c63          	beqz	s2,80002b64 <iget+0xac>
  ip->dev = dev;
    80002b30:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002b34:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002b38:	4785                	li	a5,1
    80002b3a:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002b3e:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002b42:	00015517          	auipc	a0,0x15
    80002b46:	a3650513          	addi	a0,a0,-1482 # 80017578 <itable>
    80002b4a:	00004097          	auipc	ra,0x4
    80002b4e:	bcc080e7          	jalr	-1076(ra) # 80006716 <release>
}
    80002b52:	854a                	mv	a0,s2
    80002b54:	70a2                	ld	ra,40(sp)
    80002b56:	7402                	ld	s0,32(sp)
    80002b58:	64e2                	ld	s1,24(sp)
    80002b5a:	6942                	ld	s2,16(sp)
    80002b5c:	69a2                	ld	s3,8(sp)
    80002b5e:	6a02                	ld	s4,0(sp)
    80002b60:	6145                	addi	sp,sp,48
    80002b62:	8082                	ret
    panic("iget: no inodes");
    80002b64:	00006517          	auipc	a0,0x6
    80002b68:	a3c50513          	addi	a0,a0,-1476 # 800085a0 <syscalls+0x188>
    80002b6c:	00003097          	auipc	ra,0x3
    80002b70:	5ac080e7          	jalr	1452(ra) # 80006118 <panic>

0000000080002b74 <fsinit>:
fsinit(int dev) {
    80002b74:	7179                	addi	sp,sp,-48
    80002b76:	f406                	sd	ra,40(sp)
    80002b78:	f022                	sd	s0,32(sp)
    80002b7a:	ec26                	sd	s1,24(sp)
    80002b7c:	e84a                	sd	s2,16(sp)
    80002b7e:	e44e                	sd	s3,8(sp)
    80002b80:	1800                	addi	s0,sp,48
    80002b82:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002b84:	4585                	li	a1,1
    80002b86:	00000097          	auipc	ra,0x0
    80002b8a:	a74080e7          	jalr	-1420(ra) # 800025fa <bread>
    80002b8e:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002b90:	00015997          	auipc	s3,0x15
    80002b94:	9c898993          	addi	s3,s3,-1592 # 80017558 <sb>
    80002b98:	02000613          	li	a2,32
    80002b9c:	05850593          	addi	a1,a0,88
    80002ba0:	854e                	mv	a0,s3
    80002ba2:	ffffd097          	auipc	ra,0xffffd
    80002ba6:	636080e7          	jalr	1590(ra) # 800001d8 <memmove>
  brelse(bp);
    80002baa:	8526                	mv	a0,s1
    80002bac:	00000097          	auipc	ra,0x0
    80002bb0:	ac0080e7          	jalr	-1344(ra) # 8000266c <brelse>
  if(sb.magic != FSMAGIC)
    80002bb4:	0009a703          	lw	a4,0(s3)
    80002bb8:	102037b7          	lui	a5,0x10203
    80002bbc:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002bc0:	02f71263          	bne	a4,a5,80002be4 <fsinit+0x70>
  initlog(dev, &sb);
    80002bc4:	00015597          	auipc	a1,0x15
    80002bc8:	99458593          	addi	a1,a1,-1644 # 80017558 <sb>
    80002bcc:	854a                	mv	a0,s2
    80002bce:	00001097          	auipc	ra,0x1
    80002bd2:	cc2080e7          	jalr	-830(ra) # 80003890 <initlog>
}
    80002bd6:	70a2                	ld	ra,40(sp)
    80002bd8:	7402                	ld	s0,32(sp)
    80002bda:	64e2                	ld	s1,24(sp)
    80002bdc:	6942                	ld	s2,16(sp)
    80002bde:	69a2                	ld	s3,8(sp)
    80002be0:	6145                	addi	sp,sp,48
    80002be2:	8082                	ret
    panic("invalid file system");
    80002be4:	00006517          	auipc	a0,0x6
    80002be8:	9cc50513          	addi	a0,a0,-1588 # 800085b0 <syscalls+0x198>
    80002bec:	00003097          	auipc	ra,0x3
    80002bf0:	52c080e7          	jalr	1324(ra) # 80006118 <panic>

0000000080002bf4 <iinit>:
{
    80002bf4:	7179                	addi	sp,sp,-48
    80002bf6:	f406                	sd	ra,40(sp)
    80002bf8:	f022                	sd	s0,32(sp)
    80002bfa:	ec26                	sd	s1,24(sp)
    80002bfc:	e84a                	sd	s2,16(sp)
    80002bfe:	e44e                	sd	s3,8(sp)
    80002c00:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002c02:	00006597          	auipc	a1,0x6
    80002c06:	9c658593          	addi	a1,a1,-1594 # 800085c8 <syscalls+0x1b0>
    80002c0a:	00015517          	auipc	a0,0x15
    80002c0e:	96e50513          	addi	a0,a0,-1682 # 80017578 <itable>
    80002c12:	00004097          	auipc	ra,0x4
    80002c16:	9c0080e7          	jalr	-1600(ra) # 800065d2 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002c1a:	00015497          	auipc	s1,0x15
    80002c1e:	98648493          	addi	s1,s1,-1658 # 800175a0 <itable+0x28>
    80002c22:	00016997          	auipc	s3,0x16
    80002c26:	40e98993          	addi	s3,s3,1038 # 80019030 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002c2a:	00006917          	auipc	s2,0x6
    80002c2e:	9a690913          	addi	s2,s2,-1626 # 800085d0 <syscalls+0x1b8>
    80002c32:	85ca                	mv	a1,s2
    80002c34:	8526                	mv	a0,s1
    80002c36:	00001097          	auipc	ra,0x1
    80002c3a:	fbc080e7          	jalr	-68(ra) # 80003bf2 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002c3e:	08848493          	addi	s1,s1,136
    80002c42:	ff3498e3          	bne	s1,s3,80002c32 <iinit+0x3e>
}
    80002c46:	70a2                	ld	ra,40(sp)
    80002c48:	7402                	ld	s0,32(sp)
    80002c4a:	64e2                	ld	s1,24(sp)
    80002c4c:	6942                	ld	s2,16(sp)
    80002c4e:	69a2                	ld	s3,8(sp)
    80002c50:	6145                	addi	sp,sp,48
    80002c52:	8082                	ret

0000000080002c54 <ialloc>:
{
    80002c54:	715d                	addi	sp,sp,-80
    80002c56:	e486                	sd	ra,72(sp)
    80002c58:	e0a2                	sd	s0,64(sp)
    80002c5a:	fc26                	sd	s1,56(sp)
    80002c5c:	f84a                	sd	s2,48(sp)
    80002c5e:	f44e                	sd	s3,40(sp)
    80002c60:	f052                	sd	s4,32(sp)
    80002c62:	ec56                	sd	s5,24(sp)
    80002c64:	e85a                	sd	s6,16(sp)
    80002c66:	e45e                	sd	s7,8(sp)
    80002c68:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002c6a:	00015717          	auipc	a4,0x15
    80002c6e:	8fa72703          	lw	a4,-1798(a4) # 80017564 <sb+0xc>
    80002c72:	4785                	li	a5,1
    80002c74:	04e7fa63          	bgeu	a5,a4,80002cc8 <ialloc+0x74>
    80002c78:	8aaa                	mv	s5,a0
    80002c7a:	8bae                	mv	s7,a1
    80002c7c:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002c7e:	00015a17          	auipc	s4,0x15
    80002c82:	8daa0a13          	addi	s4,s4,-1830 # 80017558 <sb>
    80002c86:	00048b1b          	sext.w	s6,s1
    80002c8a:	0044d593          	srli	a1,s1,0x4
    80002c8e:	018a2783          	lw	a5,24(s4)
    80002c92:	9dbd                	addw	a1,a1,a5
    80002c94:	8556                	mv	a0,s5
    80002c96:	00000097          	auipc	ra,0x0
    80002c9a:	964080e7          	jalr	-1692(ra) # 800025fa <bread>
    80002c9e:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002ca0:	05850993          	addi	s3,a0,88
    80002ca4:	00f4f793          	andi	a5,s1,15
    80002ca8:	079a                	slli	a5,a5,0x6
    80002caa:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002cac:	00099783          	lh	a5,0(s3)
    80002cb0:	c785                	beqz	a5,80002cd8 <ialloc+0x84>
    brelse(bp);
    80002cb2:	00000097          	auipc	ra,0x0
    80002cb6:	9ba080e7          	jalr	-1606(ra) # 8000266c <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002cba:	0485                	addi	s1,s1,1
    80002cbc:	00ca2703          	lw	a4,12(s4)
    80002cc0:	0004879b          	sext.w	a5,s1
    80002cc4:	fce7e1e3          	bltu	a5,a4,80002c86 <ialloc+0x32>
  panic("ialloc: no inodes");
    80002cc8:	00006517          	auipc	a0,0x6
    80002ccc:	91050513          	addi	a0,a0,-1776 # 800085d8 <syscalls+0x1c0>
    80002cd0:	00003097          	auipc	ra,0x3
    80002cd4:	448080e7          	jalr	1096(ra) # 80006118 <panic>
      memset(dip, 0, sizeof(*dip));
    80002cd8:	04000613          	li	a2,64
    80002cdc:	4581                	li	a1,0
    80002cde:	854e                	mv	a0,s3
    80002ce0:	ffffd097          	auipc	ra,0xffffd
    80002ce4:	498080e7          	jalr	1176(ra) # 80000178 <memset>
      dip->type = type;
    80002ce8:	01799023          	sh	s7,0(s3)
      brelse(bp);
    80002cec:	854a                	mv	a0,s2
    80002cee:	00000097          	auipc	ra,0x0
    80002cf2:	97e080e7          	jalr	-1666(ra) # 8000266c <brelse>
      return iget(dev, inum);
    80002cf6:	85da                	mv	a1,s6
    80002cf8:	8556                	mv	a0,s5
    80002cfa:	00000097          	auipc	ra,0x0
    80002cfe:	dbe080e7          	jalr	-578(ra) # 80002ab8 <iget>
}
    80002d02:	60a6                	ld	ra,72(sp)
    80002d04:	6406                	ld	s0,64(sp)
    80002d06:	74e2                	ld	s1,56(sp)
    80002d08:	7942                	ld	s2,48(sp)
    80002d0a:	79a2                	ld	s3,40(sp)
    80002d0c:	7a02                	ld	s4,32(sp)
    80002d0e:	6ae2                	ld	s5,24(sp)
    80002d10:	6b42                	ld	s6,16(sp)
    80002d12:	6ba2                	ld	s7,8(sp)
    80002d14:	6161                	addi	sp,sp,80
    80002d16:	8082                	ret

0000000080002d18 <iupdate>:
{
    80002d18:	1101                	addi	sp,sp,-32
    80002d1a:	ec06                	sd	ra,24(sp)
    80002d1c:	e822                	sd	s0,16(sp)
    80002d1e:	e426                	sd	s1,8(sp)
    80002d20:	e04a                	sd	s2,0(sp)
    80002d22:	1000                	addi	s0,sp,32
    80002d24:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002d26:	415c                	lw	a5,4(a0)
    80002d28:	0047d79b          	srliw	a5,a5,0x4
    80002d2c:	00015597          	auipc	a1,0x15
    80002d30:	8445a583          	lw	a1,-1980(a1) # 80017570 <sb+0x18>
    80002d34:	9dbd                	addw	a1,a1,a5
    80002d36:	4108                	lw	a0,0(a0)
    80002d38:	00000097          	auipc	ra,0x0
    80002d3c:	8c2080e7          	jalr	-1854(ra) # 800025fa <bread>
    80002d40:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002d42:	05850793          	addi	a5,a0,88
    80002d46:	40d8                	lw	a4,4(s1)
    80002d48:	8b3d                	andi	a4,a4,15
    80002d4a:	071a                	slli	a4,a4,0x6
    80002d4c:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002d4e:	04449703          	lh	a4,68(s1)
    80002d52:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002d56:	04649703          	lh	a4,70(s1)
    80002d5a:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002d5e:	04849703          	lh	a4,72(s1)
    80002d62:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002d66:	04a49703          	lh	a4,74(s1)
    80002d6a:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002d6e:	44f8                	lw	a4,76(s1)
    80002d70:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002d72:	03400613          	li	a2,52
    80002d76:	05048593          	addi	a1,s1,80
    80002d7a:	00c78513          	addi	a0,a5,12
    80002d7e:	ffffd097          	auipc	ra,0xffffd
    80002d82:	45a080e7          	jalr	1114(ra) # 800001d8 <memmove>
  brelse(bp);
    80002d86:	854a                	mv	a0,s2
    80002d88:	00000097          	auipc	ra,0x0
    80002d8c:	8e4080e7          	jalr	-1820(ra) # 8000266c <brelse>
}
    80002d90:	60e2                	ld	ra,24(sp)
    80002d92:	6442                	ld	s0,16(sp)
    80002d94:	64a2                	ld	s1,8(sp)
    80002d96:	6902                	ld	s2,0(sp)
    80002d98:	6105                	addi	sp,sp,32
    80002d9a:	8082                	ret

0000000080002d9c <idup>:
{
    80002d9c:	1101                	addi	sp,sp,-32
    80002d9e:	ec06                	sd	ra,24(sp)
    80002da0:	e822                	sd	s0,16(sp)
    80002da2:	e426                	sd	s1,8(sp)
    80002da4:	1000                	addi	s0,sp,32
    80002da6:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002da8:	00014517          	auipc	a0,0x14
    80002dac:	7d050513          	addi	a0,a0,2000 # 80017578 <itable>
    80002db0:	00004097          	auipc	ra,0x4
    80002db4:	8b2080e7          	jalr	-1870(ra) # 80006662 <acquire>
  ip->ref++;
    80002db8:	449c                	lw	a5,8(s1)
    80002dba:	2785                	addiw	a5,a5,1
    80002dbc:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002dbe:	00014517          	auipc	a0,0x14
    80002dc2:	7ba50513          	addi	a0,a0,1978 # 80017578 <itable>
    80002dc6:	00004097          	auipc	ra,0x4
    80002dca:	950080e7          	jalr	-1712(ra) # 80006716 <release>
}
    80002dce:	8526                	mv	a0,s1
    80002dd0:	60e2                	ld	ra,24(sp)
    80002dd2:	6442                	ld	s0,16(sp)
    80002dd4:	64a2                	ld	s1,8(sp)
    80002dd6:	6105                	addi	sp,sp,32
    80002dd8:	8082                	ret

0000000080002dda <ilock>:
{
    80002dda:	1101                	addi	sp,sp,-32
    80002ddc:	ec06                	sd	ra,24(sp)
    80002dde:	e822                	sd	s0,16(sp)
    80002de0:	e426                	sd	s1,8(sp)
    80002de2:	e04a                	sd	s2,0(sp)
    80002de4:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002de6:	c115                	beqz	a0,80002e0a <ilock+0x30>
    80002de8:	84aa                	mv	s1,a0
    80002dea:	451c                	lw	a5,8(a0)
    80002dec:	00f05f63          	blez	a5,80002e0a <ilock+0x30>
  acquiresleep(&ip->lock);
    80002df0:	0541                	addi	a0,a0,16
    80002df2:	00001097          	auipc	ra,0x1
    80002df6:	e3a080e7          	jalr	-454(ra) # 80003c2c <acquiresleep>
  if(ip->valid == 0){
    80002dfa:	40bc                	lw	a5,64(s1)
    80002dfc:	cf99                	beqz	a5,80002e1a <ilock+0x40>
}
    80002dfe:	60e2                	ld	ra,24(sp)
    80002e00:	6442                	ld	s0,16(sp)
    80002e02:	64a2                	ld	s1,8(sp)
    80002e04:	6902                	ld	s2,0(sp)
    80002e06:	6105                	addi	sp,sp,32
    80002e08:	8082                	ret
    panic("ilock");
    80002e0a:	00005517          	auipc	a0,0x5
    80002e0e:	7e650513          	addi	a0,a0,2022 # 800085f0 <syscalls+0x1d8>
    80002e12:	00003097          	auipc	ra,0x3
    80002e16:	306080e7          	jalr	774(ra) # 80006118 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002e1a:	40dc                	lw	a5,4(s1)
    80002e1c:	0047d79b          	srliw	a5,a5,0x4
    80002e20:	00014597          	auipc	a1,0x14
    80002e24:	7505a583          	lw	a1,1872(a1) # 80017570 <sb+0x18>
    80002e28:	9dbd                	addw	a1,a1,a5
    80002e2a:	4088                	lw	a0,0(s1)
    80002e2c:	fffff097          	auipc	ra,0xfffff
    80002e30:	7ce080e7          	jalr	1998(ra) # 800025fa <bread>
    80002e34:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002e36:	05850593          	addi	a1,a0,88
    80002e3a:	40dc                	lw	a5,4(s1)
    80002e3c:	8bbd                	andi	a5,a5,15
    80002e3e:	079a                	slli	a5,a5,0x6
    80002e40:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002e42:	00059783          	lh	a5,0(a1)
    80002e46:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002e4a:	00259783          	lh	a5,2(a1)
    80002e4e:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002e52:	00459783          	lh	a5,4(a1)
    80002e56:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002e5a:	00659783          	lh	a5,6(a1)
    80002e5e:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002e62:	459c                	lw	a5,8(a1)
    80002e64:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002e66:	03400613          	li	a2,52
    80002e6a:	05b1                	addi	a1,a1,12
    80002e6c:	05048513          	addi	a0,s1,80
    80002e70:	ffffd097          	auipc	ra,0xffffd
    80002e74:	368080e7          	jalr	872(ra) # 800001d8 <memmove>
    brelse(bp);
    80002e78:	854a                	mv	a0,s2
    80002e7a:	fffff097          	auipc	ra,0xfffff
    80002e7e:	7f2080e7          	jalr	2034(ra) # 8000266c <brelse>
    ip->valid = 1;
    80002e82:	4785                	li	a5,1
    80002e84:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002e86:	04449783          	lh	a5,68(s1)
    80002e8a:	fbb5                	bnez	a5,80002dfe <ilock+0x24>
      panic("ilock: no type");
    80002e8c:	00005517          	auipc	a0,0x5
    80002e90:	76c50513          	addi	a0,a0,1900 # 800085f8 <syscalls+0x1e0>
    80002e94:	00003097          	auipc	ra,0x3
    80002e98:	284080e7          	jalr	644(ra) # 80006118 <panic>

0000000080002e9c <iunlock>:
{
    80002e9c:	1101                	addi	sp,sp,-32
    80002e9e:	ec06                	sd	ra,24(sp)
    80002ea0:	e822                	sd	s0,16(sp)
    80002ea2:	e426                	sd	s1,8(sp)
    80002ea4:	e04a                	sd	s2,0(sp)
    80002ea6:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002ea8:	c905                	beqz	a0,80002ed8 <iunlock+0x3c>
    80002eaa:	84aa                	mv	s1,a0
    80002eac:	01050913          	addi	s2,a0,16
    80002eb0:	854a                	mv	a0,s2
    80002eb2:	00001097          	auipc	ra,0x1
    80002eb6:	e14080e7          	jalr	-492(ra) # 80003cc6 <holdingsleep>
    80002eba:	cd19                	beqz	a0,80002ed8 <iunlock+0x3c>
    80002ebc:	449c                	lw	a5,8(s1)
    80002ebe:	00f05d63          	blez	a5,80002ed8 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002ec2:	854a                	mv	a0,s2
    80002ec4:	00001097          	auipc	ra,0x1
    80002ec8:	dbe080e7          	jalr	-578(ra) # 80003c82 <releasesleep>
}
    80002ecc:	60e2                	ld	ra,24(sp)
    80002ece:	6442                	ld	s0,16(sp)
    80002ed0:	64a2                	ld	s1,8(sp)
    80002ed2:	6902                	ld	s2,0(sp)
    80002ed4:	6105                	addi	sp,sp,32
    80002ed6:	8082                	ret
    panic("iunlock");
    80002ed8:	00005517          	auipc	a0,0x5
    80002edc:	73050513          	addi	a0,a0,1840 # 80008608 <syscalls+0x1f0>
    80002ee0:	00003097          	auipc	ra,0x3
    80002ee4:	238080e7          	jalr	568(ra) # 80006118 <panic>

0000000080002ee8 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002ee8:	7179                	addi	sp,sp,-48
    80002eea:	f406                	sd	ra,40(sp)
    80002eec:	f022                	sd	s0,32(sp)
    80002eee:	ec26                	sd	s1,24(sp)
    80002ef0:	e84a                	sd	s2,16(sp)
    80002ef2:	e44e                	sd	s3,8(sp)
    80002ef4:	e052                	sd	s4,0(sp)
    80002ef6:	1800                	addi	s0,sp,48
    80002ef8:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002efa:	05050493          	addi	s1,a0,80
    80002efe:	08050913          	addi	s2,a0,128
    80002f02:	a021                	j	80002f0a <itrunc+0x22>
    80002f04:	0491                	addi	s1,s1,4
    80002f06:	01248d63          	beq	s1,s2,80002f20 <itrunc+0x38>
    if(ip->addrs[i]){
    80002f0a:	408c                	lw	a1,0(s1)
    80002f0c:	dde5                	beqz	a1,80002f04 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002f0e:	0009a503          	lw	a0,0(s3)
    80002f12:	00000097          	auipc	ra,0x0
    80002f16:	932080e7          	jalr	-1742(ra) # 80002844 <bfree>
      ip->addrs[i] = 0;
    80002f1a:	0004a023          	sw	zero,0(s1)
    80002f1e:	b7dd                	j	80002f04 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002f20:	0809a583          	lw	a1,128(s3)
    80002f24:	e185                	bnez	a1,80002f44 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002f26:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002f2a:	854e                	mv	a0,s3
    80002f2c:	00000097          	auipc	ra,0x0
    80002f30:	dec080e7          	jalr	-532(ra) # 80002d18 <iupdate>
}
    80002f34:	70a2                	ld	ra,40(sp)
    80002f36:	7402                	ld	s0,32(sp)
    80002f38:	64e2                	ld	s1,24(sp)
    80002f3a:	6942                	ld	s2,16(sp)
    80002f3c:	69a2                	ld	s3,8(sp)
    80002f3e:	6a02                	ld	s4,0(sp)
    80002f40:	6145                	addi	sp,sp,48
    80002f42:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002f44:	0009a503          	lw	a0,0(s3)
    80002f48:	fffff097          	auipc	ra,0xfffff
    80002f4c:	6b2080e7          	jalr	1714(ra) # 800025fa <bread>
    80002f50:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002f52:	05850493          	addi	s1,a0,88
    80002f56:	45850913          	addi	s2,a0,1112
    80002f5a:	a811                	j	80002f6e <itrunc+0x86>
        bfree(ip->dev, a[j]);
    80002f5c:	0009a503          	lw	a0,0(s3)
    80002f60:	00000097          	auipc	ra,0x0
    80002f64:	8e4080e7          	jalr	-1820(ra) # 80002844 <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80002f68:	0491                	addi	s1,s1,4
    80002f6a:	01248563          	beq	s1,s2,80002f74 <itrunc+0x8c>
      if(a[j])
    80002f6e:	408c                	lw	a1,0(s1)
    80002f70:	dde5                	beqz	a1,80002f68 <itrunc+0x80>
    80002f72:	b7ed                	j	80002f5c <itrunc+0x74>
    brelse(bp);
    80002f74:	8552                	mv	a0,s4
    80002f76:	fffff097          	auipc	ra,0xfffff
    80002f7a:	6f6080e7          	jalr	1782(ra) # 8000266c <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002f7e:	0809a583          	lw	a1,128(s3)
    80002f82:	0009a503          	lw	a0,0(s3)
    80002f86:	00000097          	auipc	ra,0x0
    80002f8a:	8be080e7          	jalr	-1858(ra) # 80002844 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002f8e:	0809a023          	sw	zero,128(s3)
    80002f92:	bf51                	j	80002f26 <itrunc+0x3e>

0000000080002f94 <iput>:
{
    80002f94:	1101                	addi	sp,sp,-32
    80002f96:	ec06                	sd	ra,24(sp)
    80002f98:	e822                	sd	s0,16(sp)
    80002f9a:	e426                	sd	s1,8(sp)
    80002f9c:	e04a                	sd	s2,0(sp)
    80002f9e:	1000                	addi	s0,sp,32
    80002fa0:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002fa2:	00014517          	auipc	a0,0x14
    80002fa6:	5d650513          	addi	a0,a0,1494 # 80017578 <itable>
    80002faa:	00003097          	auipc	ra,0x3
    80002fae:	6b8080e7          	jalr	1720(ra) # 80006662 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002fb2:	4498                	lw	a4,8(s1)
    80002fb4:	4785                	li	a5,1
    80002fb6:	02f70363          	beq	a4,a5,80002fdc <iput+0x48>
  ip->ref--;
    80002fba:	449c                	lw	a5,8(s1)
    80002fbc:	37fd                	addiw	a5,a5,-1
    80002fbe:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002fc0:	00014517          	auipc	a0,0x14
    80002fc4:	5b850513          	addi	a0,a0,1464 # 80017578 <itable>
    80002fc8:	00003097          	auipc	ra,0x3
    80002fcc:	74e080e7          	jalr	1870(ra) # 80006716 <release>
}
    80002fd0:	60e2                	ld	ra,24(sp)
    80002fd2:	6442                	ld	s0,16(sp)
    80002fd4:	64a2                	ld	s1,8(sp)
    80002fd6:	6902                	ld	s2,0(sp)
    80002fd8:	6105                	addi	sp,sp,32
    80002fda:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002fdc:	40bc                	lw	a5,64(s1)
    80002fde:	dff1                	beqz	a5,80002fba <iput+0x26>
    80002fe0:	04a49783          	lh	a5,74(s1)
    80002fe4:	fbf9                	bnez	a5,80002fba <iput+0x26>
    acquiresleep(&ip->lock);
    80002fe6:	01048913          	addi	s2,s1,16
    80002fea:	854a                	mv	a0,s2
    80002fec:	00001097          	auipc	ra,0x1
    80002ff0:	c40080e7          	jalr	-960(ra) # 80003c2c <acquiresleep>
    release(&itable.lock);
    80002ff4:	00014517          	auipc	a0,0x14
    80002ff8:	58450513          	addi	a0,a0,1412 # 80017578 <itable>
    80002ffc:	00003097          	auipc	ra,0x3
    80003000:	71a080e7          	jalr	1818(ra) # 80006716 <release>
    itrunc(ip);
    80003004:	8526                	mv	a0,s1
    80003006:	00000097          	auipc	ra,0x0
    8000300a:	ee2080e7          	jalr	-286(ra) # 80002ee8 <itrunc>
    ip->type = 0;
    8000300e:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003012:	8526                	mv	a0,s1
    80003014:	00000097          	auipc	ra,0x0
    80003018:	d04080e7          	jalr	-764(ra) # 80002d18 <iupdate>
    ip->valid = 0;
    8000301c:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003020:	854a                	mv	a0,s2
    80003022:	00001097          	auipc	ra,0x1
    80003026:	c60080e7          	jalr	-928(ra) # 80003c82 <releasesleep>
    acquire(&itable.lock);
    8000302a:	00014517          	auipc	a0,0x14
    8000302e:	54e50513          	addi	a0,a0,1358 # 80017578 <itable>
    80003032:	00003097          	auipc	ra,0x3
    80003036:	630080e7          	jalr	1584(ra) # 80006662 <acquire>
    8000303a:	b741                	j	80002fba <iput+0x26>

000000008000303c <iunlockput>:
{
    8000303c:	1101                	addi	sp,sp,-32
    8000303e:	ec06                	sd	ra,24(sp)
    80003040:	e822                	sd	s0,16(sp)
    80003042:	e426                	sd	s1,8(sp)
    80003044:	1000                	addi	s0,sp,32
    80003046:	84aa                	mv	s1,a0
  iunlock(ip);
    80003048:	00000097          	auipc	ra,0x0
    8000304c:	e54080e7          	jalr	-428(ra) # 80002e9c <iunlock>
  iput(ip);
    80003050:	8526                	mv	a0,s1
    80003052:	00000097          	auipc	ra,0x0
    80003056:	f42080e7          	jalr	-190(ra) # 80002f94 <iput>
}
    8000305a:	60e2                	ld	ra,24(sp)
    8000305c:	6442                	ld	s0,16(sp)
    8000305e:	64a2                	ld	s1,8(sp)
    80003060:	6105                	addi	sp,sp,32
    80003062:	8082                	ret

0000000080003064 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003064:	1141                	addi	sp,sp,-16
    80003066:	e422                	sd	s0,8(sp)
    80003068:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    8000306a:	411c                	lw	a5,0(a0)
    8000306c:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    8000306e:	415c                	lw	a5,4(a0)
    80003070:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003072:	04451783          	lh	a5,68(a0)
    80003076:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    8000307a:	04a51783          	lh	a5,74(a0)
    8000307e:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003082:	04c56783          	lwu	a5,76(a0)
    80003086:	e99c                	sd	a5,16(a1)
}
    80003088:	6422                	ld	s0,8(sp)
    8000308a:	0141                	addi	sp,sp,16
    8000308c:	8082                	ret

000000008000308e <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    8000308e:	457c                	lw	a5,76(a0)
    80003090:	0ed7e963          	bltu	a5,a3,80003182 <readi+0xf4>
{
    80003094:	7159                	addi	sp,sp,-112
    80003096:	f486                	sd	ra,104(sp)
    80003098:	f0a2                	sd	s0,96(sp)
    8000309a:	eca6                	sd	s1,88(sp)
    8000309c:	e8ca                	sd	s2,80(sp)
    8000309e:	e4ce                	sd	s3,72(sp)
    800030a0:	e0d2                	sd	s4,64(sp)
    800030a2:	fc56                	sd	s5,56(sp)
    800030a4:	f85a                	sd	s6,48(sp)
    800030a6:	f45e                	sd	s7,40(sp)
    800030a8:	f062                	sd	s8,32(sp)
    800030aa:	ec66                	sd	s9,24(sp)
    800030ac:	e86a                	sd	s10,16(sp)
    800030ae:	e46e                	sd	s11,8(sp)
    800030b0:	1880                	addi	s0,sp,112
    800030b2:	8baa                	mv	s7,a0
    800030b4:	8c2e                	mv	s8,a1
    800030b6:	8ab2                	mv	s5,a2
    800030b8:	84b6                	mv	s1,a3
    800030ba:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    800030bc:	9f35                	addw	a4,a4,a3
    return 0;
    800030be:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    800030c0:	0ad76063          	bltu	a4,a3,80003160 <readi+0xd2>
  if(off + n > ip->size)
    800030c4:	00e7f463          	bgeu	a5,a4,800030cc <readi+0x3e>
    n = ip->size - off;
    800030c8:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800030cc:	0a0b0963          	beqz	s6,8000317e <readi+0xf0>
    800030d0:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    800030d2:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    800030d6:	5cfd                	li	s9,-1
    800030d8:	a82d                	j	80003112 <readi+0x84>
    800030da:	020a1d93          	slli	s11,s4,0x20
    800030de:	020ddd93          	srli	s11,s11,0x20
    800030e2:	05890613          	addi	a2,s2,88
    800030e6:	86ee                	mv	a3,s11
    800030e8:	963a                	add	a2,a2,a4
    800030ea:	85d6                	mv	a1,s5
    800030ec:	8562                	mv	a0,s8
    800030ee:	fffff097          	auipc	ra,0xfffff
    800030f2:	a66080e7          	jalr	-1434(ra) # 80001b54 <either_copyout>
    800030f6:	05950d63          	beq	a0,s9,80003150 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    800030fa:	854a                	mv	a0,s2
    800030fc:	fffff097          	auipc	ra,0xfffff
    80003100:	570080e7          	jalr	1392(ra) # 8000266c <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003104:	013a09bb          	addw	s3,s4,s3
    80003108:	009a04bb          	addw	s1,s4,s1
    8000310c:	9aee                	add	s5,s5,s11
    8000310e:	0569f763          	bgeu	s3,s6,8000315c <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003112:	000ba903          	lw	s2,0(s7)
    80003116:	00a4d59b          	srliw	a1,s1,0xa
    8000311a:	855e                	mv	a0,s7
    8000311c:	00000097          	auipc	ra,0x0
    80003120:	8cc080e7          	jalr	-1844(ra) # 800029e8 <bmap>
    80003124:	0005059b          	sext.w	a1,a0
    80003128:	854a                	mv	a0,s2
    8000312a:	fffff097          	auipc	ra,0xfffff
    8000312e:	4d0080e7          	jalr	1232(ra) # 800025fa <bread>
    80003132:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003134:	3ff4f713          	andi	a4,s1,1023
    80003138:	40ed07bb          	subw	a5,s10,a4
    8000313c:	413b06bb          	subw	a3,s6,s3
    80003140:	8a3e                	mv	s4,a5
    80003142:	2781                	sext.w	a5,a5
    80003144:	0006861b          	sext.w	a2,a3
    80003148:	f8f679e3          	bgeu	a2,a5,800030da <readi+0x4c>
    8000314c:	8a36                	mv	s4,a3
    8000314e:	b771                	j	800030da <readi+0x4c>
      brelse(bp);
    80003150:	854a                	mv	a0,s2
    80003152:	fffff097          	auipc	ra,0xfffff
    80003156:	51a080e7          	jalr	1306(ra) # 8000266c <brelse>
      tot = -1;
    8000315a:	59fd                	li	s3,-1
  }
  return tot;
    8000315c:	0009851b          	sext.w	a0,s3
}
    80003160:	70a6                	ld	ra,104(sp)
    80003162:	7406                	ld	s0,96(sp)
    80003164:	64e6                	ld	s1,88(sp)
    80003166:	6946                	ld	s2,80(sp)
    80003168:	69a6                	ld	s3,72(sp)
    8000316a:	6a06                	ld	s4,64(sp)
    8000316c:	7ae2                	ld	s5,56(sp)
    8000316e:	7b42                	ld	s6,48(sp)
    80003170:	7ba2                	ld	s7,40(sp)
    80003172:	7c02                	ld	s8,32(sp)
    80003174:	6ce2                	ld	s9,24(sp)
    80003176:	6d42                	ld	s10,16(sp)
    80003178:	6da2                	ld	s11,8(sp)
    8000317a:	6165                	addi	sp,sp,112
    8000317c:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000317e:	89da                	mv	s3,s6
    80003180:	bff1                	j	8000315c <readi+0xce>
    return 0;
    80003182:	4501                	li	a0,0
}
    80003184:	8082                	ret

0000000080003186 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003186:	457c                	lw	a5,76(a0)
    80003188:	10d7e363          	bltu	a5,a3,8000328e <writei+0x108>
{
    8000318c:	7159                	addi	sp,sp,-112
    8000318e:	f486                	sd	ra,104(sp)
    80003190:	f0a2                	sd	s0,96(sp)
    80003192:	eca6                	sd	s1,88(sp)
    80003194:	e8ca                	sd	s2,80(sp)
    80003196:	e4ce                	sd	s3,72(sp)
    80003198:	e0d2                	sd	s4,64(sp)
    8000319a:	fc56                	sd	s5,56(sp)
    8000319c:	f85a                	sd	s6,48(sp)
    8000319e:	f45e                	sd	s7,40(sp)
    800031a0:	f062                	sd	s8,32(sp)
    800031a2:	ec66                	sd	s9,24(sp)
    800031a4:	e86a                	sd	s10,16(sp)
    800031a6:	e46e                	sd	s11,8(sp)
    800031a8:	1880                	addi	s0,sp,112
    800031aa:	8b2a                	mv	s6,a0
    800031ac:	8c2e                	mv	s8,a1
    800031ae:	8ab2                	mv	s5,a2
    800031b0:	8936                	mv	s2,a3
    800031b2:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    800031b4:	00e687bb          	addw	a5,a3,a4
    800031b8:	0cd7ed63          	bltu	a5,a3,80003292 <writei+0x10c>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    800031bc:	00043737          	lui	a4,0x43
    800031c0:	0cf76b63          	bltu	a4,a5,80003296 <writei+0x110>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800031c4:	0c0b8363          	beqz	s7,8000328a <writei+0x104>
    800031c8:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    800031ca:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    800031ce:	5cfd                	li	s9,-1
    800031d0:	a82d                	j	8000320a <writei+0x84>
    800031d2:	02099d93          	slli	s11,s3,0x20
    800031d6:	020ddd93          	srli	s11,s11,0x20
    800031da:	05848513          	addi	a0,s1,88
    800031de:	86ee                	mv	a3,s11
    800031e0:	8656                	mv	a2,s5
    800031e2:	85e2                	mv	a1,s8
    800031e4:	953a                	add	a0,a0,a4
    800031e6:	fffff097          	auipc	ra,0xfffff
    800031ea:	9c4080e7          	jalr	-1596(ra) # 80001baa <either_copyin>
    800031ee:	05950d63          	beq	a0,s9,80003248 <writei+0xc2>
      brelse(bp);
      break;
    }
    //log_write(bp);
    brelse(bp);
    800031f2:	8526                	mv	a0,s1
    800031f4:	fffff097          	auipc	ra,0xfffff
    800031f8:	478080e7          	jalr	1144(ra) # 8000266c <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800031fc:	01498a3b          	addw	s4,s3,s4
    80003200:	0129893b          	addw	s2,s3,s2
    80003204:	9aee                	add	s5,s5,s11
    80003206:	057a7663          	bgeu	s4,s7,80003252 <writei+0xcc>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    8000320a:	000b2483          	lw	s1,0(s6)
    8000320e:	00a9559b          	srliw	a1,s2,0xa
    80003212:	855a                	mv	a0,s6
    80003214:	fffff097          	auipc	ra,0xfffff
    80003218:	7d4080e7          	jalr	2004(ra) # 800029e8 <bmap>
    8000321c:	0005059b          	sext.w	a1,a0
    80003220:	8526                	mv	a0,s1
    80003222:	fffff097          	auipc	ra,0xfffff
    80003226:	3d8080e7          	jalr	984(ra) # 800025fa <bread>
    8000322a:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000322c:	3ff97713          	andi	a4,s2,1023
    80003230:	40ed07bb          	subw	a5,s10,a4
    80003234:	414b86bb          	subw	a3,s7,s4
    80003238:	89be                	mv	s3,a5
    8000323a:	2781                	sext.w	a5,a5
    8000323c:	0006861b          	sext.w	a2,a3
    80003240:	f8f679e3          	bgeu	a2,a5,800031d2 <writei+0x4c>
    80003244:	89b6                	mv	s3,a3
    80003246:	b771                	j	800031d2 <writei+0x4c>
      brelse(bp);
    80003248:	8526                	mv	a0,s1
    8000324a:	fffff097          	auipc	ra,0xfffff
    8000324e:	422080e7          	jalr	1058(ra) # 8000266c <brelse>
  }

  if(off > ip->size)
    80003252:	04cb2783          	lw	a5,76(s6)
    80003256:	0127f463          	bgeu	a5,s2,8000325e <writei+0xd8>
    ip->size = off;
    8000325a:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    8000325e:	855a                	mv	a0,s6
    80003260:	00000097          	auipc	ra,0x0
    80003264:	ab8080e7          	jalr	-1352(ra) # 80002d18 <iupdate>

  return tot;
    80003268:	000a051b          	sext.w	a0,s4
}
    8000326c:	70a6                	ld	ra,104(sp)
    8000326e:	7406                	ld	s0,96(sp)
    80003270:	64e6                	ld	s1,88(sp)
    80003272:	6946                	ld	s2,80(sp)
    80003274:	69a6                	ld	s3,72(sp)
    80003276:	6a06                	ld	s4,64(sp)
    80003278:	7ae2                	ld	s5,56(sp)
    8000327a:	7b42                	ld	s6,48(sp)
    8000327c:	7ba2                	ld	s7,40(sp)
    8000327e:	7c02                	ld	s8,32(sp)
    80003280:	6ce2                	ld	s9,24(sp)
    80003282:	6d42                	ld	s10,16(sp)
    80003284:	6da2                	ld	s11,8(sp)
    80003286:	6165                	addi	sp,sp,112
    80003288:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000328a:	8a5e                	mv	s4,s7
    8000328c:	bfc9                	j	8000325e <writei+0xd8>
    return -1;
    8000328e:	557d                	li	a0,-1
}
    80003290:	8082                	ret
    return -1;
    80003292:	557d                	li	a0,-1
    80003294:	bfe1                	j	8000326c <writei+0xe6>
    return -1;
    80003296:	557d                	li	a0,-1
    80003298:	bfd1                	j	8000326c <writei+0xe6>

000000008000329a <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    8000329a:	1141                	addi	sp,sp,-16
    8000329c:	e406                	sd	ra,8(sp)
    8000329e:	e022                	sd	s0,0(sp)
    800032a0:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800032a2:	4639                	li	a2,14
    800032a4:	ffffd097          	auipc	ra,0xffffd
    800032a8:	fac080e7          	jalr	-84(ra) # 80000250 <strncmp>
}
    800032ac:	60a2                	ld	ra,8(sp)
    800032ae:	6402                	ld	s0,0(sp)
    800032b0:	0141                	addi	sp,sp,16
    800032b2:	8082                	ret

00000000800032b4 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800032b4:	7139                	addi	sp,sp,-64
    800032b6:	fc06                	sd	ra,56(sp)
    800032b8:	f822                	sd	s0,48(sp)
    800032ba:	f426                	sd	s1,40(sp)
    800032bc:	f04a                	sd	s2,32(sp)
    800032be:	ec4e                	sd	s3,24(sp)
    800032c0:	e852                	sd	s4,16(sp)
    800032c2:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800032c4:	04451703          	lh	a4,68(a0)
    800032c8:	4785                	li	a5,1
    800032ca:	00f71a63          	bne	a4,a5,800032de <dirlookup+0x2a>
    800032ce:	892a                	mv	s2,a0
    800032d0:	89ae                	mv	s3,a1
    800032d2:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800032d4:	457c                	lw	a5,76(a0)
    800032d6:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800032d8:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800032da:	e79d                	bnez	a5,80003308 <dirlookup+0x54>
    800032dc:	a8a5                	j	80003354 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    800032de:	00005517          	auipc	a0,0x5
    800032e2:	33250513          	addi	a0,a0,818 # 80008610 <syscalls+0x1f8>
    800032e6:	00003097          	auipc	ra,0x3
    800032ea:	e32080e7          	jalr	-462(ra) # 80006118 <panic>
      panic("dirlookup read");
    800032ee:	00005517          	auipc	a0,0x5
    800032f2:	33a50513          	addi	a0,a0,826 # 80008628 <syscalls+0x210>
    800032f6:	00003097          	auipc	ra,0x3
    800032fa:	e22080e7          	jalr	-478(ra) # 80006118 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800032fe:	24c1                	addiw	s1,s1,16
    80003300:	04c92783          	lw	a5,76(s2)
    80003304:	04f4f763          	bgeu	s1,a5,80003352 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003308:	4741                	li	a4,16
    8000330a:	86a6                	mv	a3,s1
    8000330c:	fc040613          	addi	a2,s0,-64
    80003310:	4581                	li	a1,0
    80003312:	854a                	mv	a0,s2
    80003314:	00000097          	auipc	ra,0x0
    80003318:	d7a080e7          	jalr	-646(ra) # 8000308e <readi>
    8000331c:	47c1                	li	a5,16
    8000331e:	fcf518e3          	bne	a0,a5,800032ee <dirlookup+0x3a>
    if(de.inum == 0)
    80003322:	fc045783          	lhu	a5,-64(s0)
    80003326:	dfe1                	beqz	a5,800032fe <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003328:	fc240593          	addi	a1,s0,-62
    8000332c:	854e                	mv	a0,s3
    8000332e:	00000097          	auipc	ra,0x0
    80003332:	f6c080e7          	jalr	-148(ra) # 8000329a <namecmp>
    80003336:	f561                	bnez	a0,800032fe <dirlookup+0x4a>
      if(poff)
    80003338:	000a0463          	beqz	s4,80003340 <dirlookup+0x8c>
        *poff = off;
    8000333c:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003340:	fc045583          	lhu	a1,-64(s0)
    80003344:	00092503          	lw	a0,0(s2)
    80003348:	fffff097          	auipc	ra,0xfffff
    8000334c:	770080e7          	jalr	1904(ra) # 80002ab8 <iget>
    80003350:	a011                	j	80003354 <dirlookup+0xa0>
  return 0;
    80003352:	4501                	li	a0,0
}
    80003354:	70e2                	ld	ra,56(sp)
    80003356:	7442                	ld	s0,48(sp)
    80003358:	74a2                	ld	s1,40(sp)
    8000335a:	7902                	ld	s2,32(sp)
    8000335c:	69e2                	ld	s3,24(sp)
    8000335e:	6a42                	ld	s4,16(sp)
    80003360:	6121                	addi	sp,sp,64
    80003362:	8082                	ret

0000000080003364 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003364:	711d                	addi	sp,sp,-96
    80003366:	ec86                	sd	ra,88(sp)
    80003368:	e8a2                	sd	s0,80(sp)
    8000336a:	e4a6                	sd	s1,72(sp)
    8000336c:	e0ca                	sd	s2,64(sp)
    8000336e:	fc4e                	sd	s3,56(sp)
    80003370:	f852                	sd	s4,48(sp)
    80003372:	f456                	sd	s5,40(sp)
    80003374:	f05a                	sd	s6,32(sp)
    80003376:	ec5e                	sd	s7,24(sp)
    80003378:	e862                	sd	s8,16(sp)
    8000337a:	e466                	sd	s9,8(sp)
    8000337c:	1080                	addi	s0,sp,96
    8000337e:	84aa                	mv	s1,a0
    80003380:	8b2e                	mv	s6,a1
    80003382:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003384:	00054703          	lbu	a4,0(a0)
    80003388:	02f00793          	li	a5,47
    8000338c:	02f70363          	beq	a4,a5,800033b2 <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003390:	ffffe097          	auipc	ra,0xffffe
    80003394:	d64080e7          	jalr	-668(ra) # 800010f4 <myproc>
    80003398:	15053503          	ld	a0,336(a0)
    8000339c:	00000097          	auipc	ra,0x0
    800033a0:	a00080e7          	jalr	-1536(ra) # 80002d9c <idup>
    800033a4:	89aa                	mv	s3,a0
  while(*path == '/')
    800033a6:	02f00913          	li	s2,47
  len = path - s;
    800033aa:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    800033ac:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800033ae:	4c05                	li	s8,1
    800033b0:	a865                	j	80003468 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    800033b2:	4585                	li	a1,1
    800033b4:	4505                	li	a0,1
    800033b6:	fffff097          	auipc	ra,0xfffff
    800033ba:	702080e7          	jalr	1794(ra) # 80002ab8 <iget>
    800033be:	89aa                	mv	s3,a0
    800033c0:	b7dd                	j	800033a6 <namex+0x42>
      iunlockput(ip);
    800033c2:	854e                	mv	a0,s3
    800033c4:	00000097          	auipc	ra,0x0
    800033c8:	c78080e7          	jalr	-904(ra) # 8000303c <iunlockput>
      return 0;
    800033cc:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800033ce:	854e                	mv	a0,s3
    800033d0:	60e6                	ld	ra,88(sp)
    800033d2:	6446                	ld	s0,80(sp)
    800033d4:	64a6                	ld	s1,72(sp)
    800033d6:	6906                	ld	s2,64(sp)
    800033d8:	79e2                	ld	s3,56(sp)
    800033da:	7a42                	ld	s4,48(sp)
    800033dc:	7aa2                	ld	s5,40(sp)
    800033de:	7b02                	ld	s6,32(sp)
    800033e0:	6be2                	ld	s7,24(sp)
    800033e2:	6c42                	ld	s8,16(sp)
    800033e4:	6ca2                	ld	s9,8(sp)
    800033e6:	6125                	addi	sp,sp,96
    800033e8:	8082                	ret
      iunlock(ip);
    800033ea:	854e                	mv	a0,s3
    800033ec:	00000097          	auipc	ra,0x0
    800033f0:	ab0080e7          	jalr	-1360(ra) # 80002e9c <iunlock>
      return ip;
    800033f4:	bfe9                	j	800033ce <namex+0x6a>
      iunlockput(ip);
    800033f6:	854e                	mv	a0,s3
    800033f8:	00000097          	auipc	ra,0x0
    800033fc:	c44080e7          	jalr	-956(ra) # 8000303c <iunlockput>
      return 0;
    80003400:	89d2                	mv	s3,s4
    80003402:	b7f1                	j	800033ce <namex+0x6a>
  len = path - s;
    80003404:	40b48633          	sub	a2,s1,a1
    80003408:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    8000340c:	094cd463          	bge	s9,s4,80003494 <namex+0x130>
    memmove(name, s, DIRSIZ);
    80003410:	4639                	li	a2,14
    80003412:	8556                	mv	a0,s5
    80003414:	ffffd097          	auipc	ra,0xffffd
    80003418:	dc4080e7          	jalr	-572(ra) # 800001d8 <memmove>
  while(*path == '/')
    8000341c:	0004c783          	lbu	a5,0(s1)
    80003420:	01279763          	bne	a5,s2,8000342e <namex+0xca>
    path++;
    80003424:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003426:	0004c783          	lbu	a5,0(s1)
    8000342a:	ff278de3          	beq	a5,s2,80003424 <namex+0xc0>
    ilock(ip);
    8000342e:	854e                	mv	a0,s3
    80003430:	00000097          	auipc	ra,0x0
    80003434:	9aa080e7          	jalr	-1622(ra) # 80002dda <ilock>
    if(ip->type != T_DIR){
    80003438:	04499783          	lh	a5,68(s3)
    8000343c:	f98793e3          	bne	a5,s8,800033c2 <namex+0x5e>
    if(nameiparent && *path == '\0'){
    80003440:	000b0563          	beqz	s6,8000344a <namex+0xe6>
    80003444:	0004c783          	lbu	a5,0(s1)
    80003448:	d3cd                	beqz	a5,800033ea <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    8000344a:	865e                	mv	a2,s7
    8000344c:	85d6                	mv	a1,s5
    8000344e:	854e                	mv	a0,s3
    80003450:	00000097          	auipc	ra,0x0
    80003454:	e64080e7          	jalr	-412(ra) # 800032b4 <dirlookup>
    80003458:	8a2a                	mv	s4,a0
    8000345a:	dd51                	beqz	a0,800033f6 <namex+0x92>
    iunlockput(ip);
    8000345c:	854e                	mv	a0,s3
    8000345e:	00000097          	auipc	ra,0x0
    80003462:	bde080e7          	jalr	-1058(ra) # 8000303c <iunlockput>
    ip = next;
    80003466:	89d2                	mv	s3,s4
  while(*path == '/')
    80003468:	0004c783          	lbu	a5,0(s1)
    8000346c:	05279763          	bne	a5,s2,800034ba <namex+0x156>
    path++;
    80003470:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003472:	0004c783          	lbu	a5,0(s1)
    80003476:	ff278de3          	beq	a5,s2,80003470 <namex+0x10c>
  if(*path == 0)
    8000347a:	c79d                	beqz	a5,800034a8 <namex+0x144>
    path++;
    8000347c:	85a6                	mv	a1,s1
  len = path - s;
    8000347e:	8a5e                	mv	s4,s7
    80003480:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    80003482:	01278963          	beq	a5,s2,80003494 <namex+0x130>
    80003486:	dfbd                	beqz	a5,80003404 <namex+0xa0>
    path++;
    80003488:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    8000348a:	0004c783          	lbu	a5,0(s1)
    8000348e:	ff279ce3          	bne	a5,s2,80003486 <namex+0x122>
    80003492:	bf8d                	j	80003404 <namex+0xa0>
    memmove(name, s, len);
    80003494:	2601                	sext.w	a2,a2
    80003496:	8556                	mv	a0,s5
    80003498:	ffffd097          	auipc	ra,0xffffd
    8000349c:	d40080e7          	jalr	-704(ra) # 800001d8 <memmove>
    name[len] = 0;
    800034a0:	9a56                	add	s4,s4,s5
    800034a2:	000a0023          	sb	zero,0(s4)
    800034a6:	bf9d                	j	8000341c <namex+0xb8>
  if(nameiparent){
    800034a8:	f20b03e3          	beqz	s6,800033ce <namex+0x6a>
    iput(ip);
    800034ac:	854e                	mv	a0,s3
    800034ae:	00000097          	auipc	ra,0x0
    800034b2:	ae6080e7          	jalr	-1306(ra) # 80002f94 <iput>
    return 0;
    800034b6:	4981                	li	s3,0
    800034b8:	bf19                	j	800033ce <namex+0x6a>
  if(*path == 0)
    800034ba:	d7fd                	beqz	a5,800034a8 <namex+0x144>
  while(*path != '/' && *path != 0)
    800034bc:	0004c783          	lbu	a5,0(s1)
    800034c0:	85a6                	mv	a1,s1
    800034c2:	b7d1                	j	80003486 <namex+0x122>

00000000800034c4 <dirlink>:
{
    800034c4:	7139                	addi	sp,sp,-64
    800034c6:	fc06                	sd	ra,56(sp)
    800034c8:	f822                	sd	s0,48(sp)
    800034ca:	f426                	sd	s1,40(sp)
    800034cc:	f04a                	sd	s2,32(sp)
    800034ce:	ec4e                	sd	s3,24(sp)
    800034d0:	e852                	sd	s4,16(sp)
    800034d2:	0080                	addi	s0,sp,64
    800034d4:	892a                	mv	s2,a0
    800034d6:	8a2e                	mv	s4,a1
    800034d8:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800034da:	4601                	li	a2,0
    800034dc:	00000097          	auipc	ra,0x0
    800034e0:	dd8080e7          	jalr	-552(ra) # 800032b4 <dirlookup>
    800034e4:	e93d                	bnez	a0,8000355a <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800034e6:	04c92483          	lw	s1,76(s2)
    800034ea:	c49d                	beqz	s1,80003518 <dirlink+0x54>
    800034ec:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800034ee:	4741                	li	a4,16
    800034f0:	86a6                	mv	a3,s1
    800034f2:	fc040613          	addi	a2,s0,-64
    800034f6:	4581                	li	a1,0
    800034f8:	854a                	mv	a0,s2
    800034fa:	00000097          	auipc	ra,0x0
    800034fe:	b94080e7          	jalr	-1132(ra) # 8000308e <readi>
    80003502:	47c1                	li	a5,16
    80003504:	06f51163          	bne	a0,a5,80003566 <dirlink+0xa2>
    if(de.inum == 0)
    80003508:	fc045783          	lhu	a5,-64(s0)
    8000350c:	c791                	beqz	a5,80003518 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000350e:	24c1                	addiw	s1,s1,16
    80003510:	04c92783          	lw	a5,76(s2)
    80003514:	fcf4ede3          	bltu	s1,a5,800034ee <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003518:	4639                	li	a2,14
    8000351a:	85d2                	mv	a1,s4
    8000351c:	fc240513          	addi	a0,s0,-62
    80003520:	ffffd097          	auipc	ra,0xffffd
    80003524:	d6c080e7          	jalr	-660(ra) # 8000028c <strncpy>
  de.inum = inum;
    80003528:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000352c:	4741                	li	a4,16
    8000352e:	86a6                	mv	a3,s1
    80003530:	fc040613          	addi	a2,s0,-64
    80003534:	4581                	li	a1,0
    80003536:	854a                	mv	a0,s2
    80003538:	00000097          	auipc	ra,0x0
    8000353c:	c4e080e7          	jalr	-946(ra) # 80003186 <writei>
    80003540:	872a                	mv	a4,a0
    80003542:	47c1                	li	a5,16
  return 0;
    80003544:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003546:	02f71863          	bne	a4,a5,80003576 <dirlink+0xb2>
}
    8000354a:	70e2                	ld	ra,56(sp)
    8000354c:	7442                	ld	s0,48(sp)
    8000354e:	74a2                	ld	s1,40(sp)
    80003550:	7902                	ld	s2,32(sp)
    80003552:	69e2                	ld	s3,24(sp)
    80003554:	6a42                	ld	s4,16(sp)
    80003556:	6121                	addi	sp,sp,64
    80003558:	8082                	ret
    iput(ip);
    8000355a:	00000097          	auipc	ra,0x0
    8000355e:	a3a080e7          	jalr	-1478(ra) # 80002f94 <iput>
    return -1;
    80003562:	557d                	li	a0,-1
    80003564:	b7dd                	j	8000354a <dirlink+0x86>
      panic("dirlink read");
    80003566:	00005517          	auipc	a0,0x5
    8000356a:	0d250513          	addi	a0,a0,210 # 80008638 <syscalls+0x220>
    8000356e:	00003097          	auipc	ra,0x3
    80003572:	baa080e7          	jalr	-1110(ra) # 80006118 <panic>
    panic("dirlink");
    80003576:	00005517          	auipc	a0,0x5
    8000357a:	26a50513          	addi	a0,a0,618 # 800087e0 <syscalls+0x3c8>
    8000357e:	00003097          	auipc	ra,0x3
    80003582:	b9a080e7          	jalr	-1126(ra) # 80006118 <panic>

0000000080003586 <namei>:

struct inode*
namei(char *path)
{
    80003586:	1101                	addi	sp,sp,-32
    80003588:	ec06                	sd	ra,24(sp)
    8000358a:	e822                	sd	s0,16(sp)
    8000358c:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    8000358e:	fe040613          	addi	a2,s0,-32
    80003592:	4581                	li	a1,0
    80003594:	00000097          	auipc	ra,0x0
    80003598:	dd0080e7          	jalr	-560(ra) # 80003364 <namex>
}
    8000359c:	60e2                	ld	ra,24(sp)
    8000359e:	6442                	ld	s0,16(sp)
    800035a0:	6105                	addi	sp,sp,32
    800035a2:	8082                	ret

00000000800035a4 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800035a4:	1141                	addi	sp,sp,-16
    800035a6:	e406                	sd	ra,8(sp)
    800035a8:	e022                	sd	s0,0(sp)
    800035aa:	0800                	addi	s0,sp,16
    800035ac:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800035ae:	4585                	li	a1,1
    800035b0:	00000097          	auipc	ra,0x0
    800035b4:	db4080e7          	jalr	-588(ra) # 80003364 <namex>
}
    800035b8:	60a2                	ld	ra,8(sp)
    800035ba:	6402                	ld	s0,0(sp)
    800035bc:	0141                	addi	sp,sp,16
    800035be:	8082                	ret

00000000800035c0 <balloc_page>:

/* NTU OS 2024 */
/* Similar to balloc, except allocates eight consecutive free blocks. */
uint balloc_page(uint dev) {
    800035c0:	715d                	addi	sp,sp,-80
    800035c2:	e486                	sd	ra,72(sp)
    800035c4:	e0a2                	sd	s0,64(sp)
    800035c6:	fc26                	sd	s1,56(sp)
    800035c8:	f84a                	sd	s2,48(sp)
    800035ca:	f44e                	sd	s3,40(sp)
    800035cc:	f052                	sd	s4,32(sp)
    800035ce:	ec56                	sd	s5,24(sp)
    800035d0:	e85a                	sd	s6,16(sp)
    800035d2:	e45e                	sd	s7,8(sp)
    800035d4:	0880                	addi	s0,sp,80
  for (int b = 0; b < sb.size; b += BPB) {
    800035d6:	00014797          	auipc	a5,0x14
    800035da:	f867a783          	lw	a5,-122(a5) # 8001755c <sb+0x4>
    800035de:	c3e9                	beqz	a5,800036a0 <balloc_page+0xe0>
    800035e0:	89aa                	mv	s3,a0
    800035e2:	4a01                	li	s4,0
    struct buf *bp = bread(dev, BBLOCK(b, sb));
    800035e4:	00014a97          	auipc	s5,0x14
    800035e8:	f74a8a93          	addi	s5,s5,-140 # 80017558 <sb>

    for (int bi = 0; bi < BPB && b + bi < sb.size; bi += 8) {
    800035ec:	4b01                	li	s6,0
    800035ee:	6909                	lui	s2,0x2
  for (int b = 0; b < sb.size; b += BPB) {
    800035f0:	6b89                	lui	s7,0x2
    800035f2:	a8b9                	j	80003650 <balloc_page+0x90>
      uchar *bits = &bp->data[bi / 8];
      if (*bits == 0) {
        *bits |= 0xff; // Mark 8 consecutive blocks in use.
    800035f4:	97aa                	add	a5,a5,a0
    800035f6:	577d                	li	a4,-1
    800035f8:	04e78c23          	sb	a4,88(a5)
        //log_write(bp);
        brelse(bp);
    800035fc:	fffff097          	auipc	ra,0xfffff
    80003600:	070080e7          	jalr	112(ra) # 8000266c <brelse>

        for (int i = 0; i < 8; i += 1) {
    80003604:	00848a1b          	addiw	s4,s1,8
        brelse(bp);
    80003608:	8926                	mv	s2,s1
          bzero(dev, b + bi + i);
    8000360a:	2981                	sext.w	s3,s3
    8000360c:	0009059b          	sext.w	a1,s2
    80003610:	854e                	mv	a0,s3
    80003612:	fffff097          	auipc	ra,0xfffff
    80003616:	29e080e7          	jalr	670(ra) # 800028b0 <bzero>
        for (int i = 0; i < 8; i += 1) {
    8000361a:	2905                	addiw	s2,s2,1
    8000361c:	ff4918e3          	bne	s2,s4,8000360c <balloc_page+0x4c>
    }

    brelse(bp);
  }
  panic("balloc_page: out of blocks");
}
    80003620:	8526                	mv	a0,s1
    80003622:	60a6                	ld	ra,72(sp)
    80003624:	6406                	ld	s0,64(sp)
    80003626:	74e2                	ld	s1,56(sp)
    80003628:	7942                	ld	s2,48(sp)
    8000362a:	79a2                	ld	s3,40(sp)
    8000362c:	7a02                	ld	s4,32(sp)
    8000362e:	6ae2                	ld	s5,24(sp)
    80003630:	6b42                	ld	s6,16(sp)
    80003632:	6ba2                	ld	s7,8(sp)
    80003634:	6161                	addi	sp,sp,80
    80003636:	8082                	ret
    brelse(bp);
    80003638:	fffff097          	auipc	ra,0xfffff
    8000363c:	034080e7          	jalr	52(ra) # 8000266c <brelse>
  for (int b = 0; b < sb.size; b += BPB) {
    80003640:	014b87bb          	addw	a5,s7,s4
    80003644:	00078a1b          	sext.w	s4,a5
    80003648:	004aa703          	lw	a4,4(s5)
    8000364c:	04ea7a63          	bgeu	s4,a4,800036a0 <balloc_page+0xe0>
    struct buf *bp = bread(dev, BBLOCK(b, sb));
    80003650:	41fa579b          	sraiw	a5,s4,0x1f
    80003654:	0137d79b          	srliw	a5,a5,0x13
    80003658:	014787bb          	addw	a5,a5,s4
    8000365c:	40d7d79b          	sraiw	a5,a5,0xd
    80003660:	01caa583          	lw	a1,28(s5)
    80003664:	9dbd                	addw	a1,a1,a5
    80003666:	854e                	mv	a0,s3
    80003668:	fffff097          	auipc	ra,0xfffff
    8000366c:	f92080e7          	jalr	-110(ra) # 800025fa <bread>
    for (int bi = 0; bi < BPB && b + bi < sb.size; bi += 8) {
    80003670:	004aa603          	lw	a2,4(s5)
    80003674:	000a049b          	sext.w	s1,s4
    80003678:	875a                	mv	a4,s6
    8000367a:	fac4ffe3          	bgeu	s1,a2,80003638 <balloc_page+0x78>
      uchar *bits = &bp->data[bi / 8];
    8000367e:	41f7579b          	sraiw	a5,a4,0x1f
    80003682:	01d7d79b          	srliw	a5,a5,0x1d
    80003686:	9fb9                	addw	a5,a5,a4
    80003688:	4037d79b          	sraiw	a5,a5,0x3
      if (*bits == 0) {
    8000368c:	00f506b3          	add	a3,a0,a5
    80003690:	0586c683          	lbu	a3,88(a3)
    80003694:	d2a5                	beqz	a3,800035f4 <balloc_page+0x34>
    for (int bi = 0; bi < BPB && b + bi < sb.size; bi += 8) {
    80003696:	2721                	addiw	a4,a4,8
    80003698:	24a1                	addiw	s1,s1,8
    8000369a:	ff2710e3          	bne	a4,s2,8000367a <balloc_page+0xba>
    8000369e:	bf69                	j	80003638 <balloc_page+0x78>
  panic("balloc_page: out of blocks");
    800036a0:	00005517          	auipc	a0,0x5
    800036a4:	fa850513          	addi	a0,a0,-88 # 80008648 <syscalls+0x230>
    800036a8:	00003097          	auipc	ra,0x3
    800036ac:	a70080e7          	jalr	-1424(ra) # 80006118 <panic>

00000000800036b0 <bfree_page>:

/* NTU OS 2024 */
/* Free 8 disk blocks allocated from balloc_page(). */
void bfree_page(int dev, uint blockno) {
    800036b0:	1101                	addi	sp,sp,-32
    800036b2:	ec06                	sd	ra,24(sp)
    800036b4:	e822                	sd	s0,16(sp)
    800036b6:	e426                	sd	s1,8(sp)
    800036b8:	1000                	addi	s0,sp,32
  if (blockno + 8 > sb.size) {
    800036ba:	0085871b          	addiw	a4,a1,8
    800036be:	00014797          	auipc	a5,0x14
    800036c2:	e9e7a783          	lw	a5,-354(a5) # 8001755c <sb+0x4>
    800036c6:	04e7ee63          	bltu	a5,a4,80003722 <bfree_page+0x72>
    panic("bfree_page: blockno out of bound");
  }

  if ((blockno % 8) != 0) {
    800036ca:	0075f793          	andi	a5,a1,7
    800036ce:	e3b5                	bnez	a5,80003732 <bfree_page+0x82>
    panic("bfree_page: blockno is not aligned");
  }

  int bi = blockno % BPB;
    800036d0:	03359493          	slli	s1,a1,0x33
    800036d4:	90cd                	srli	s1,s1,0x33
  int b = blockno - bi;
    800036d6:	9d85                	subw	a1,a1,s1
  struct buf *bp = bread(dev, BBLOCK(b, sb));
    800036d8:	41f5d79b          	sraiw	a5,a1,0x1f
    800036dc:	0137d79b          	srliw	a5,a5,0x13
    800036e0:	9dbd                	addw	a1,a1,a5
    800036e2:	40d5d59b          	sraiw	a1,a1,0xd
    800036e6:	00014797          	auipc	a5,0x14
    800036ea:	e8e7a783          	lw	a5,-370(a5) # 80017574 <sb+0x1c>
    800036ee:	9dbd                	addw	a1,a1,a5
    800036f0:	fffff097          	auipc	ra,0xfffff
    800036f4:	f0a080e7          	jalr	-246(ra) # 800025fa <bread>
  uchar *bits = &bp->data[bi / 8];
    800036f8:	808d                	srli	s1,s1,0x3

  if (*bits != 0xff) {
    800036fa:	009507b3          	add	a5,a0,s1
    800036fe:	0587c703          	lbu	a4,88(a5)
    80003702:	0ff00793          	li	a5,255
    80003706:	02f71e63          	bne	a4,a5,80003742 <bfree_page+0x92>
    panic("bfree_page: data bits are invalid");
  }

  *bits = 0;
    8000370a:	94aa                	add	s1,s1,a0
    8000370c:	04048c23          	sb	zero,88(s1)
  //log_write(bp);
  brelse(bp);
    80003710:	fffff097          	auipc	ra,0xfffff
    80003714:	f5c080e7          	jalr	-164(ra) # 8000266c <brelse>
}
    80003718:	60e2                	ld	ra,24(sp)
    8000371a:	6442                	ld	s0,16(sp)
    8000371c:	64a2                	ld	s1,8(sp)
    8000371e:	6105                	addi	sp,sp,32
    80003720:	8082                	ret
    panic("bfree_page: blockno out of bound");
    80003722:	00005517          	auipc	a0,0x5
    80003726:	f4650513          	addi	a0,a0,-186 # 80008668 <syscalls+0x250>
    8000372a:	00003097          	auipc	ra,0x3
    8000372e:	9ee080e7          	jalr	-1554(ra) # 80006118 <panic>
    panic("bfree_page: blockno is not aligned");
    80003732:	00005517          	auipc	a0,0x5
    80003736:	f5e50513          	addi	a0,a0,-162 # 80008690 <syscalls+0x278>
    8000373a:	00003097          	auipc	ra,0x3
    8000373e:	9de080e7          	jalr	-1570(ra) # 80006118 <panic>
    panic("bfree_page: data bits are invalid");
    80003742:	00005517          	auipc	a0,0x5
    80003746:	f7650513          	addi	a0,a0,-138 # 800086b8 <syscalls+0x2a0>
    8000374a:	00003097          	auipc	ra,0x3
    8000374e:	9ce080e7          	jalr	-1586(ra) # 80006118 <panic>

0000000080003752 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003752:	1101                	addi	sp,sp,-32
    80003754:	ec06                	sd	ra,24(sp)
    80003756:	e822                	sd	s0,16(sp)
    80003758:	e426                	sd	s1,8(sp)
    8000375a:	e04a                	sd	s2,0(sp)
    8000375c:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    8000375e:	00016917          	auipc	s2,0x16
    80003762:	8c290913          	addi	s2,s2,-1854 # 80019020 <log>
    80003766:	01892583          	lw	a1,24(s2)
    8000376a:	02892503          	lw	a0,40(s2)
    8000376e:	fffff097          	auipc	ra,0xfffff
    80003772:	e8c080e7          	jalr	-372(ra) # 800025fa <bread>
    80003776:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003778:	02c92683          	lw	a3,44(s2)
    8000377c:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    8000377e:	02d05763          	blez	a3,800037ac <write_head+0x5a>
    80003782:	00016797          	auipc	a5,0x16
    80003786:	8ce78793          	addi	a5,a5,-1842 # 80019050 <log+0x30>
    8000378a:	05c50713          	addi	a4,a0,92
    8000378e:	36fd                	addiw	a3,a3,-1
    80003790:	1682                	slli	a3,a3,0x20
    80003792:	9281                	srli	a3,a3,0x20
    80003794:	068a                	slli	a3,a3,0x2
    80003796:	00016617          	auipc	a2,0x16
    8000379a:	8be60613          	addi	a2,a2,-1858 # 80019054 <log+0x34>
    8000379e:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    800037a0:	4390                	lw	a2,0(a5)
    800037a2:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800037a4:	0791                	addi	a5,a5,4
    800037a6:	0711                	addi	a4,a4,4
    800037a8:	fed79ce3          	bne	a5,a3,800037a0 <write_head+0x4e>
  }
  bwrite(buf);
    800037ac:	8526                	mv	a0,s1
    800037ae:	fffff097          	auipc	ra,0xfffff
    800037b2:	e80080e7          	jalr	-384(ra) # 8000262e <bwrite>
  brelse(buf);
    800037b6:	8526                	mv	a0,s1
    800037b8:	fffff097          	auipc	ra,0xfffff
    800037bc:	eb4080e7          	jalr	-332(ra) # 8000266c <brelse>
}
    800037c0:	60e2                	ld	ra,24(sp)
    800037c2:	6442                	ld	s0,16(sp)
    800037c4:	64a2                	ld	s1,8(sp)
    800037c6:	6902                	ld	s2,0(sp)
    800037c8:	6105                	addi	sp,sp,32
    800037ca:	8082                	ret

00000000800037cc <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800037cc:	00016797          	auipc	a5,0x16
    800037d0:	8807a783          	lw	a5,-1920(a5) # 8001904c <log+0x2c>
    800037d4:	0af05d63          	blez	a5,8000388e <install_trans+0xc2>
{
    800037d8:	7139                	addi	sp,sp,-64
    800037da:	fc06                	sd	ra,56(sp)
    800037dc:	f822                	sd	s0,48(sp)
    800037de:	f426                	sd	s1,40(sp)
    800037e0:	f04a                	sd	s2,32(sp)
    800037e2:	ec4e                	sd	s3,24(sp)
    800037e4:	e852                	sd	s4,16(sp)
    800037e6:	e456                	sd	s5,8(sp)
    800037e8:	e05a                	sd	s6,0(sp)
    800037ea:	0080                	addi	s0,sp,64
    800037ec:	8b2a                	mv	s6,a0
    800037ee:	00016a97          	auipc	s5,0x16
    800037f2:	862a8a93          	addi	s5,s5,-1950 # 80019050 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800037f6:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800037f8:	00016997          	auipc	s3,0x16
    800037fc:	82898993          	addi	s3,s3,-2008 # 80019020 <log>
    80003800:	a035                	j	8000382c <install_trans+0x60>
      bunpin(dbuf);
    80003802:	8526                	mv	a0,s1
    80003804:	fffff097          	auipc	ra,0xfffff
    80003808:	f42080e7          	jalr	-190(ra) # 80002746 <bunpin>
    brelse(lbuf);
    8000380c:	854a                	mv	a0,s2
    8000380e:	fffff097          	auipc	ra,0xfffff
    80003812:	e5e080e7          	jalr	-418(ra) # 8000266c <brelse>
    brelse(dbuf);
    80003816:	8526                	mv	a0,s1
    80003818:	fffff097          	auipc	ra,0xfffff
    8000381c:	e54080e7          	jalr	-428(ra) # 8000266c <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003820:	2a05                	addiw	s4,s4,1
    80003822:	0a91                	addi	s5,s5,4
    80003824:	02c9a783          	lw	a5,44(s3)
    80003828:	04fa5963          	bge	s4,a5,8000387a <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000382c:	0189a583          	lw	a1,24(s3)
    80003830:	014585bb          	addw	a1,a1,s4
    80003834:	2585                	addiw	a1,a1,1
    80003836:	0289a503          	lw	a0,40(s3)
    8000383a:	fffff097          	auipc	ra,0xfffff
    8000383e:	dc0080e7          	jalr	-576(ra) # 800025fa <bread>
    80003842:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003844:	000aa583          	lw	a1,0(s5)
    80003848:	0289a503          	lw	a0,40(s3)
    8000384c:	fffff097          	auipc	ra,0xfffff
    80003850:	dae080e7          	jalr	-594(ra) # 800025fa <bread>
    80003854:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003856:	40000613          	li	a2,1024
    8000385a:	05890593          	addi	a1,s2,88
    8000385e:	05850513          	addi	a0,a0,88
    80003862:	ffffd097          	auipc	ra,0xffffd
    80003866:	976080e7          	jalr	-1674(ra) # 800001d8 <memmove>
    bwrite(dbuf);  // write dst to disk
    8000386a:	8526                	mv	a0,s1
    8000386c:	fffff097          	auipc	ra,0xfffff
    80003870:	dc2080e7          	jalr	-574(ra) # 8000262e <bwrite>
    if(recovering == 0)
    80003874:	f80b1ce3          	bnez	s6,8000380c <install_trans+0x40>
    80003878:	b769                	j	80003802 <install_trans+0x36>
}
    8000387a:	70e2                	ld	ra,56(sp)
    8000387c:	7442                	ld	s0,48(sp)
    8000387e:	74a2                	ld	s1,40(sp)
    80003880:	7902                	ld	s2,32(sp)
    80003882:	69e2                	ld	s3,24(sp)
    80003884:	6a42                	ld	s4,16(sp)
    80003886:	6aa2                	ld	s5,8(sp)
    80003888:	6b02                	ld	s6,0(sp)
    8000388a:	6121                	addi	sp,sp,64
    8000388c:	8082                	ret
    8000388e:	8082                	ret

0000000080003890 <initlog>:
{
    80003890:	7179                	addi	sp,sp,-48
    80003892:	f406                	sd	ra,40(sp)
    80003894:	f022                	sd	s0,32(sp)
    80003896:	ec26                	sd	s1,24(sp)
    80003898:	e84a                	sd	s2,16(sp)
    8000389a:	e44e                	sd	s3,8(sp)
    8000389c:	1800                	addi	s0,sp,48
    8000389e:	892a                	mv	s2,a0
    800038a0:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800038a2:	00015497          	auipc	s1,0x15
    800038a6:	77e48493          	addi	s1,s1,1918 # 80019020 <log>
    800038aa:	00005597          	auipc	a1,0x5
    800038ae:	e3658593          	addi	a1,a1,-458 # 800086e0 <syscalls+0x2c8>
    800038b2:	8526                	mv	a0,s1
    800038b4:	00003097          	auipc	ra,0x3
    800038b8:	d1e080e7          	jalr	-738(ra) # 800065d2 <initlock>
  log.start = sb->logstart;
    800038bc:	0149a583          	lw	a1,20(s3)
    800038c0:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800038c2:	0109a783          	lw	a5,16(s3)
    800038c6:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800038c8:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800038cc:	854a                	mv	a0,s2
    800038ce:	fffff097          	auipc	ra,0xfffff
    800038d2:	d2c080e7          	jalr	-724(ra) # 800025fa <bread>
  log.lh.n = lh->n;
    800038d6:	4d3c                	lw	a5,88(a0)
    800038d8:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800038da:	02f05563          	blez	a5,80003904 <initlog+0x74>
    800038de:	05c50713          	addi	a4,a0,92
    800038e2:	00015697          	auipc	a3,0x15
    800038e6:	76e68693          	addi	a3,a3,1902 # 80019050 <log+0x30>
    800038ea:	37fd                	addiw	a5,a5,-1
    800038ec:	1782                	slli	a5,a5,0x20
    800038ee:	9381                	srli	a5,a5,0x20
    800038f0:	078a                	slli	a5,a5,0x2
    800038f2:	06050613          	addi	a2,a0,96
    800038f6:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    800038f8:	4310                	lw	a2,0(a4)
    800038fa:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    800038fc:	0711                	addi	a4,a4,4
    800038fe:	0691                	addi	a3,a3,4
    80003900:	fef71ce3          	bne	a4,a5,800038f8 <initlog+0x68>
  brelse(buf);
    80003904:	fffff097          	auipc	ra,0xfffff
    80003908:	d68080e7          	jalr	-664(ra) # 8000266c <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    8000390c:	4505                	li	a0,1
    8000390e:	00000097          	auipc	ra,0x0
    80003912:	ebe080e7          	jalr	-322(ra) # 800037cc <install_trans>
  log.lh.n = 0;
    80003916:	00015797          	auipc	a5,0x15
    8000391a:	7207ab23          	sw	zero,1846(a5) # 8001904c <log+0x2c>
  write_head(); // clear the log
    8000391e:	00000097          	auipc	ra,0x0
    80003922:	e34080e7          	jalr	-460(ra) # 80003752 <write_head>
}
    80003926:	70a2                	ld	ra,40(sp)
    80003928:	7402                	ld	s0,32(sp)
    8000392a:	64e2                	ld	s1,24(sp)
    8000392c:	6942                	ld	s2,16(sp)
    8000392e:	69a2                	ld	s3,8(sp)
    80003930:	6145                	addi	sp,sp,48
    80003932:	8082                	ret

0000000080003934 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003934:	1101                	addi	sp,sp,-32
    80003936:	ec06                	sd	ra,24(sp)
    80003938:	e822                	sd	s0,16(sp)
    8000393a:	e426                	sd	s1,8(sp)
    8000393c:	e04a                	sd	s2,0(sp)
    8000393e:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003940:	00015517          	auipc	a0,0x15
    80003944:	6e050513          	addi	a0,a0,1760 # 80019020 <log>
    80003948:	00003097          	auipc	ra,0x3
    8000394c:	d1a080e7          	jalr	-742(ra) # 80006662 <acquire>
  while(1){
    if(log.committing){
    80003950:	00015497          	auipc	s1,0x15
    80003954:	6d048493          	addi	s1,s1,1744 # 80019020 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003958:	4979                	li	s2,30
    8000395a:	a039                	j	80003968 <begin_op+0x34>
      sleep(&log, &log.lock);
    8000395c:	85a6                	mv	a1,s1
    8000395e:	8526                	mv	a0,s1
    80003960:	ffffe097          	auipc	ra,0xffffe
    80003964:	e50080e7          	jalr	-432(ra) # 800017b0 <sleep>
    if(log.committing){
    80003968:	50dc                	lw	a5,36(s1)
    8000396a:	fbed                	bnez	a5,8000395c <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000396c:	509c                	lw	a5,32(s1)
    8000396e:	0017871b          	addiw	a4,a5,1
    80003972:	0007069b          	sext.w	a3,a4
    80003976:	0027179b          	slliw	a5,a4,0x2
    8000397a:	9fb9                	addw	a5,a5,a4
    8000397c:	0017979b          	slliw	a5,a5,0x1
    80003980:	54d8                	lw	a4,44(s1)
    80003982:	9fb9                	addw	a5,a5,a4
    80003984:	00f95963          	bge	s2,a5,80003996 <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003988:	85a6                	mv	a1,s1
    8000398a:	8526                	mv	a0,s1
    8000398c:	ffffe097          	auipc	ra,0xffffe
    80003990:	e24080e7          	jalr	-476(ra) # 800017b0 <sleep>
    80003994:	bfd1                	j	80003968 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003996:	00015517          	auipc	a0,0x15
    8000399a:	68a50513          	addi	a0,a0,1674 # 80019020 <log>
    8000399e:	d114                	sw	a3,32(a0)
      release(&log.lock);
    800039a0:	00003097          	auipc	ra,0x3
    800039a4:	d76080e7          	jalr	-650(ra) # 80006716 <release>
      break;
    }
  }
}
    800039a8:	60e2                	ld	ra,24(sp)
    800039aa:	6442                	ld	s0,16(sp)
    800039ac:	64a2                	ld	s1,8(sp)
    800039ae:	6902                	ld	s2,0(sp)
    800039b0:	6105                	addi	sp,sp,32
    800039b2:	8082                	ret

00000000800039b4 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800039b4:	7139                	addi	sp,sp,-64
    800039b6:	fc06                	sd	ra,56(sp)
    800039b8:	f822                	sd	s0,48(sp)
    800039ba:	f426                	sd	s1,40(sp)
    800039bc:	f04a                	sd	s2,32(sp)
    800039be:	ec4e                	sd	s3,24(sp)
    800039c0:	e852                	sd	s4,16(sp)
    800039c2:	e456                	sd	s5,8(sp)
    800039c4:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800039c6:	00015497          	auipc	s1,0x15
    800039ca:	65a48493          	addi	s1,s1,1626 # 80019020 <log>
    800039ce:	8526                	mv	a0,s1
    800039d0:	00003097          	auipc	ra,0x3
    800039d4:	c92080e7          	jalr	-878(ra) # 80006662 <acquire>
  log.outstanding -= 1;
    800039d8:	509c                	lw	a5,32(s1)
    800039da:	37fd                	addiw	a5,a5,-1
    800039dc:	0007891b          	sext.w	s2,a5
    800039e0:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800039e2:	50dc                	lw	a5,36(s1)
    800039e4:	efb9                	bnez	a5,80003a42 <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    800039e6:	06091663          	bnez	s2,80003a52 <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    800039ea:	00015497          	auipc	s1,0x15
    800039ee:	63648493          	addi	s1,s1,1590 # 80019020 <log>
    800039f2:	4785                	li	a5,1
    800039f4:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800039f6:	8526                	mv	a0,s1
    800039f8:	00003097          	auipc	ra,0x3
    800039fc:	d1e080e7          	jalr	-738(ra) # 80006716 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003a00:	54dc                	lw	a5,44(s1)
    80003a02:	06f04763          	bgtz	a5,80003a70 <end_op+0xbc>
    acquire(&log.lock);
    80003a06:	00015497          	auipc	s1,0x15
    80003a0a:	61a48493          	addi	s1,s1,1562 # 80019020 <log>
    80003a0e:	8526                	mv	a0,s1
    80003a10:	00003097          	auipc	ra,0x3
    80003a14:	c52080e7          	jalr	-942(ra) # 80006662 <acquire>
    log.committing = 0;
    80003a18:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003a1c:	8526                	mv	a0,s1
    80003a1e:	ffffe097          	auipc	ra,0xffffe
    80003a22:	f1e080e7          	jalr	-226(ra) # 8000193c <wakeup>
    release(&log.lock);
    80003a26:	8526                	mv	a0,s1
    80003a28:	00003097          	auipc	ra,0x3
    80003a2c:	cee080e7          	jalr	-786(ra) # 80006716 <release>
}
    80003a30:	70e2                	ld	ra,56(sp)
    80003a32:	7442                	ld	s0,48(sp)
    80003a34:	74a2                	ld	s1,40(sp)
    80003a36:	7902                	ld	s2,32(sp)
    80003a38:	69e2                	ld	s3,24(sp)
    80003a3a:	6a42                	ld	s4,16(sp)
    80003a3c:	6aa2                	ld	s5,8(sp)
    80003a3e:	6121                	addi	sp,sp,64
    80003a40:	8082                	ret
    panic("log.committing");
    80003a42:	00005517          	auipc	a0,0x5
    80003a46:	ca650513          	addi	a0,a0,-858 # 800086e8 <syscalls+0x2d0>
    80003a4a:	00002097          	auipc	ra,0x2
    80003a4e:	6ce080e7          	jalr	1742(ra) # 80006118 <panic>
    wakeup(&log);
    80003a52:	00015497          	auipc	s1,0x15
    80003a56:	5ce48493          	addi	s1,s1,1486 # 80019020 <log>
    80003a5a:	8526                	mv	a0,s1
    80003a5c:	ffffe097          	auipc	ra,0xffffe
    80003a60:	ee0080e7          	jalr	-288(ra) # 8000193c <wakeup>
  release(&log.lock);
    80003a64:	8526                	mv	a0,s1
    80003a66:	00003097          	auipc	ra,0x3
    80003a6a:	cb0080e7          	jalr	-848(ra) # 80006716 <release>
  if(do_commit){
    80003a6e:	b7c9                	j	80003a30 <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003a70:	00015a97          	auipc	s5,0x15
    80003a74:	5e0a8a93          	addi	s5,s5,1504 # 80019050 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003a78:	00015a17          	auipc	s4,0x15
    80003a7c:	5a8a0a13          	addi	s4,s4,1448 # 80019020 <log>
    80003a80:	018a2583          	lw	a1,24(s4)
    80003a84:	012585bb          	addw	a1,a1,s2
    80003a88:	2585                	addiw	a1,a1,1
    80003a8a:	028a2503          	lw	a0,40(s4)
    80003a8e:	fffff097          	auipc	ra,0xfffff
    80003a92:	b6c080e7          	jalr	-1172(ra) # 800025fa <bread>
    80003a96:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003a98:	000aa583          	lw	a1,0(s5)
    80003a9c:	028a2503          	lw	a0,40(s4)
    80003aa0:	fffff097          	auipc	ra,0xfffff
    80003aa4:	b5a080e7          	jalr	-1190(ra) # 800025fa <bread>
    80003aa8:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003aaa:	40000613          	li	a2,1024
    80003aae:	05850593          	addi	a1,a0,88
    80003ab2:	05848513          	addi	a0,s1,88
    80003ab6:	ffffc097          	auipc	ra,0xffffc
    80003aba:	722080e7          	jalr	1826(ra) # 800001d8 <memmove>
    bwrite(to);  // write the log
    80003abe:	8526                	mv	a0,s1
    80003ac0:	fffff097          	auipc	ra,0xfffff
    80003ac4:	b6e080e7          	jalr	-1170(ra) # 8000262e <bwrite>
    brelse(from);
    80003ac8:	854e                	mv	a0,s3
    80003aca:	fffff097          	auipc	ra,0xfffff
    80003ace:	ba2080e7          	jalr	-1118(ra) # 8000266c <brelse>
    brelse(to);
    80003ad2:	8526                	mv	a0,s1
    80003ad4:	fffff097          	auipc	ra,0xfffff
    80003ad8:	b98080e7          	jalr	-1128(ra) # 8000266c <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003adc:	2905                	addiw	s2,s2,1
    80003ade:	0a91                	addi	s5,s5,4
    80003ae0:	02ca2783          	lw	a5,44(s4)
    80003ae4:	f8f94ee3          	blt	s2,a5,80003a80 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003ae8:	00000097          	auipc	ra,0x0
    80003aec:	c6a080e7          	jalr	-918(ra) # 80003752 <write_head>
    install_trans(0); // Now install writes to home locations
    80003af0:	4501                	li	a0,0
    80003af2:	00000097          	auipc	ra,0x0
    80003af6:	cda080e7          	jalr	-806(ra) # 800037cc <install_trans>
    log.lh.n = 0;
    80003afa:	00015797          	auipc	a5,0x15
    80003afe:	5407a923          	sw	zero,1362(a5) # 8001904c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003b02:	00000097          	auipc	ra,0x0
    80003b06:	c50080e7          	jalr	-944(ra) # 80003752 <write_head>
    80003b0a:	bdf5                	j	80003a06 <end_op+0x52>

0000000080003b0c <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003b0c:	1101                	addi	sp,sp,-32
    80003b0e:	ec06                	sd	ra,24(sp)
    80003b10:	e822                	sd	s0,16(sp)
    80003b12:	e426                	sd	s1,8(sp)
    80003b14:	e04a                	sd	s2,0(sp)
    80003b16:	1000                	addi	s0,sp,32
    80003b18:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003b1a:	00015917          	auipc	s2,0x15
    80003b1e:	50690913          	addi	s2,s2,1286 # 80019020 <log>
    80003b22:	854a                	mv	a0,s2
    80003b24:	00003097          	auipc	ra,0x3
    80003b28:	b3e080e7          	jalr	-1218(ra) # 80006662 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003b2c:	02c92603          	lw	a2,44(s2)
    80003b30:	47f5                	li	a5,29
    80003b32:	06c7c563          	blt	a5,a2,80003b9c <log_write+0x90>
    80003b36:	00015797          	auipc	a5,0x15
    80003b3a:	5067a783          	lw	a5,1286(a5) # 8001903c <log+0x1c>
    80003b3e:	37fd                	addiw	a5,a5,-1
    80003b40:	04f65e63          	bge	a2,a5,80003b9c <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003b44:	00015797          	auipc	a5,0x15
    80003b48:	4fc7a783          	lw	a5,1276(a5) # 80019040 <log+0x20>
    80003b4c:	06f05063          	blez	a5,80003bac <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003b50:	4781                	li	a5,0
    80003b52:	06c05563          	blez	a2,80003bbc <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003b56:	44cc                	lw	a1,12(s1)
    80003b58:	00015717          	auipc	a4,0x15
    80003b5c:	4f870713          	addi	a4,a4,1272 # 80019050 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003b60:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003b62:	4314                	lw	a3,0(a4)
    80003b64:	04b68c63          	beq	a3,a1,80003bbc <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80003b68:	2785                	addiw	a5,a5,1
    80003b6a:	0711                	addi	a4,a4,4
    80003b6c:	fef61be3          	bne	a2,a5,80003b62 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003b70:	0621                	addi	a2,a2,8
    80003b72:	060a                	slli	a2,a2,0x2
    80003b74:	00015797          	auipc	a5,0x15
    80003b78:	4ac78793          	addi	a5,a5,1196 # 80019020 <log>
    80003b7c:	963e                	add	a2,a2,a5
    80003b7e:	44dc                	lw	a5,12(s1)
    80003b80:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003b82:	8526                	mv	a0,s1
    80003b84:	fffff097          	auipc	ra,0xfffff
    80003b88:	b86080e7          	jalr	-1146(ra) # 8000270a <bpin>
    log.lh.n++;
    80003b8c:	00015717          	auipc	a4,0x15
    80003b90:	49470713          	addi	a4,a4,1172 # 80019020 <log>
    80003b94:	575c                	lw	a5,44(a4)
    80003b96:	2785                	addiw	a5,a5,1
    80003b98:	d75c                	sw	a5,44(a4)
    80003b9a:	a835                	j	80003bd6 <log_write+0xca>
    panic("too big a transaction");
    80003b9c:	00005517          	auipc	a0,0x5
    80003ba0:	b5c50513          	addi	a0,a0,-1188 # 800086f8 <syscalls+0x2e0>
    80003ba4:	00002097          	auipc	ra,0x2
    80003ba8:	574080e7          	jalr	1396(ra) # 80006118 <panic>
    panic("log_write outside of trans");
    80003bac:	00005517          	auipc	a0,0x5
    80003bb0:	b6450513          	addi	a0,a0,-1180 # 80008710 <syscalls+0x2f8>
    80003bb4:	00002097          	auipc	ra,0x2
    80003bb8:	564080e7          	jalr	1380(ra) # 80006118 <panic>
  log.lh.block[i] = b->blockno;
    80003bbc:	00878713          	addi	a4,a5,8
    80003bc0:	00271693          	slli	a3,a4,0x2
    80003bc4:	00015717          	auipc	a4,0x15
    80003bc8:	45c70713          	addi	a4,a4,1116 # 80019020 <log>
    80003bcc:	9736                	add	a4,a4,a3
    80003bce:	44d4                	lw	a3,12(s1)
    80003bd0:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003bd2:	faf608e3          	beq	a2,a5,80003b82 <log_write+0x76>
  }
  release(&log.lock);
    80003bd6:	00015517          	auipc	a0,0x15
    80003bda:	44a50513          	addi	a0,a0,1098 # 80019020 <log>
    80003bde:	00003097          	auipc	ra,0x3
    80003be2:	b38080e7          	jalr	-1224(ra) # 80006716 <release>
}
    80003be6:	60e2                	ld	ra,24(sp)
    80003be8:	6442                	ld	s0,16(sp)
    80003bea:	64a2                	ld	s1,8(sp)
    80003bec:	6902                	ld	s2,0(sp)
    80003bee:	6105                	addi	sp,sp,32
    80003bf0:	8082                	ret

0000000080003bf2 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003bf2:	1101                	addi	sp,sp,-32
    80003bf4:	ec06                	sd	ra,24(sp)
    80003bf6:	e822                	sd	s0,16(sp)
    80003bf8:	e426                	sd	s1,8(sp)
    80003bfa:	e04a                	sd	s2,0(sp)
    80003bfc:	1000                	addi	s0,sp,32
    80003bfe:	84aa                	mv	s1,a0
    80003c00:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003c02:	00005597          	auipc	a1,0x5
    80003c06:	b2e58593          	addi	a1,a1,-1234 # 80008730 <syscalls+0x318>
    80003c0a:	0521                	addi	a0,a0,8
    80003c0c:	00003097          	auipc	ra,0x3
    80003c10:	9c6080e7          	jalr	-1594(ra) # 800065d2 <initlock>
  lk->name = name;
    80003c14:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003c18:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003c1c:	0204a423          	sw	zero,40(s1)
}
    80003c20:	60e2                	ld	ra,24(sp)
    80003c22:	6442                	ld	s0,16(sp)
    80003c24:	64a2                	ld	s1,8(sp)
    80003c26:	6902                	ld	s2,0(sp)
    80003c28:	6105                	addi	sp,sp,32
    80003c2a:	8082                	ret

0000000080003c2c <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003c2c:	1101                	addi	sp,sp,-32
    80003c2e:	ec06                	sd	ra,24(sp)
    80003c30:	e822                	sd	s0,16(sp)
    80003c32:	e426                	sd	s1,8(sp)
    80003c34:	e04a                	sd	s2,0(sp)
    80003c36:	1000                	addi	s0,sp,32
    80003c38:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003c3a:	00850913          	addi	s2,a0,8
    80003c3e:	854a                	mv	a0,s2
    80003c40:	00003097          	auipc	ra,0x3
    80003c44:	a22080e7          	jalr	-1502(ra) # 80006662 <acquire>
  while (lk->locked) {
    80003c48:	409c                	lw	a5,0(s1)
    80003c4a:	cb89                	beqz	a5,80003c5c <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003c4c:	85ca                	mv	a1,s2
    80003c4e:	8526                	mv	a0,s1
    80003c50:	ffffe097          	auipc	ra,0xffffe
    80003c54:	b60080e7          	jalr	-1184(ra) # 800017b0 <sleep>
  while (lk->locked) {
    80003c58:	409c                	lw	a5,0(s1)
    80003c5a:	fbed                	bnez	a5,80003c4c <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003c5c:	4785                	li	a5,1
    80003c5e:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003c60:	ffffd097          	auipc	ra,0xffffd
    80003c64:	494080e7          	jalr	1172(ra) # 800010f4 <myproc>
    80003c68:	591c                	lw	a5,48(a0)
    80003c6a:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003c6c:	854a                	mv	a0,s2
    80003c6e:	00003097          	auipc	ra,0x3
    80003c72:	aa8080e7          	jalr	-1368(ra) # 80006716 <release>
}
    80003c76:	60e2                	ld	ra,24(sp)
    80003c78:	6442                	ld	s0,16(sp)
    80003c7a:	64a2                	ld	s1,8(sp)
    80003c7c:	6902                	ld	s2,0(sp)
    80003c7e:	6105                	addi	sp,sp,32
    80003c80:	8082                	ret

0000000080003c82 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003c82:	1101                	addi	sp,sp,-32
    80003c84:	ec06                	sd	ra,24(sp)
    80003c86:	e822                	sd	s0,16(sp)
    80003c88:	e426                	sd	s1,8(sp)
    80003c8a:	e04a                	sd	s2,0(sp)
    80003c8c:	1000                	addi	s0,sp,32
    80003c8e:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003c90:	00850913          	addi	s2,a0,8
    80003c94:	854a                	mv	a0,s2
    80003c96:	00003097          	auipc	ra,0x3
    80003c9a:	9cc080e7          	jalr	-1588(ra) # 80006662 <acquire>
  lk->locked = 0;
    80003c9e:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003ca2:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003ca6:	8526                	mv	a0,s1
    80003ca8:	ffffe097          	auipc	ra,0xffffe
    80003cac:	c94080e7          	jalr	-876(ra) # 8000193c <wakeup>
  release(&lk->lk);
    80003cb0:	854a                	mv	a0,s2
    80003cb2:	00003097          	auipc	ra,0x3
    80003cb6:	a64080e7          	jalr	-1436(ra) # 80006716 <release>
}
    80003cba:	60e2                	ld	ra,24(sp)
    80003cbc:	6442                	ld	s0,16(sp)
    80003cbe:	64a2                	ld	s1,8(sp)
    80003cc0:	6902                	ld	s2,0(sp)
    80003cc2:	6105                	addi	sp,sp,32
    80003cc4:	8082                	ret

0000000080003cc6 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003cc6:	7179                	addi	sp,sp,-48
    80003cc8:	f406                	sd	ra,40(sp)
    80003cca:	f022                	sd	s0,32(sp)
    80003ccc:	ec26                	sd	s1,24(sp)
    80003cce:	e84a                	sd	s2,16(sp)
    80003cd0:	e44e                	sd	s3,8(sp)
    80003cd2:	1800                	addi	s0,sp,48
    80003cd4:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003cd6:	00850913          	addi	s2,a0,8
    80003cda:	854a                	mv	a0,s2
    80003cdc:	00003097          	auipc	ra,0x3
    80003ce0:	986080e7          	jalr	-1658(ra) # 80006662 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003ce4:	409c                	lw	a5,0(s1)
    80003ce6:	ef99                	bnez	a5,80003d04 <holdingsleep+0x3e>
    80003ce8:	4481                	li	s1,0
  release(&lk->lk);
    80003cea:	854a                	mv	a0,s2
    80003cec:	00003097          	auipc	ra,0x3
    80003cf0:	a2a080e7          	jalr	-1494(ra) # 80006716 <release>
  return r;
}
    80003cf4:	8526                	mv	a0,s1
    80003cf6:	70a2                	ld	ra,40(sp)
    80003cf8:	7402                	ld	s0,32(sp)
    80003cfa:	64e2                	ld	s1,24(sp)
    80003cfc:	6942                	ld	s2,16(sp)
    80003cfe:	69a2                	ld	s3,8(sp)
    80003d00:	6145                	addi	sp,sp,48
    80003d02:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003d04:	0284a983          	lw	s3,40(s1)
    80003d08:	ffffd097          	auipc	ra,0xffffd
    80003d0c:	3ec080e7          	jalr	1004(ra) # 800010f4 <myproc>
    80003d10:	5904                	lw	s1,48(a0)
    80003d12:	413484b3          	sub	s1,s1,s3
    80003d16:	0014b493          	seqz	s1,s1
    80003d1a:	bfc1                	j	80003cea <holdingsleep+0x24>

0000000080003d1c <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003d1c:	1141                	addi	sp,sp,-16
    80003d1e:	e406                	sd	ra,8(sp)
    80003d20:	e022                	sd	s0,0(sp)
    80003d22:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003d24:	00005597          	auipc	a1,0x5
    80003d28:	a1c58593          	addi	a1,a1,-1508 # 80008740 <syscalls+0x328>
    80003d2c:	00015517          	auipc	a0,0x15
    80003d30:	43c50513          	addi	a0,a0,1084 # 80019168 <ftable>
    80003d34:	00003097          	auipc	ra,0x3
    80003d38:	89e080e7          	jalr	-1890(ra) # 800065d2 <initlock>
}
    80003d3c:	60a2                	ld	ra,8(sp)
    80003d3e:	6402                	ld	s0,0(sp)
    80003d40:	0141                	addi	sp,sp,16
    80003d42:	8082                	ret

0000000080003d44 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003d44:	1101                	addi	sp,sp,-32
    80003d46:	ec06                	sd	ra,24(sp)
    80003d48:	e822                	sd	s0,16(sp)
    80003d4a:	e426                	sd	s1,8(sp)
    80003d4c:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003d4e:	00015517          	auipc	a0,0x15
    80003d52:	41a50513          	addi	a0,a0,1050 # 80019168 <ftable>
    80003d56:	00003097          	auipc	ra,0x3
    80003d5a:	90c080e7          	jalr	-1780(ra) # 80006662 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003d5e:	00015497          	auipc	s1,0x15
    80003d62:	42248493          	addi	s1,s1,1058 # 80019180 <ftable+0x18>
    80003d66:	00016717          	auipc	a4,0x16
    80003d6a:	3ba70713          	addi	a4,a4,954 # 8001a120 <ftable+0xfb8>
    if(f->ref == 0){
    80003d6e:	40dc                	lw	a5,4(s1)
    80003d70:	cf99                	beqz	a5,80003d8e <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003d72:	02848493          	addi	s1,s1,40
    80003d76:	fee49ce3          	bne	s1,a4,80003d6e <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003d7a:	00015517          	auipc	a0,0x15
    80003d7e:	3ee50513          	addi	a0,a0,1006 # 80019168 <ftable>
    80003d82:	00003097          	auipc	ra,0x3
    80003d86:	994080e7          	jalr	-1644(ra) # 80006716 <release>
  return 0;
    80003d8a:	4481                	li	s1,0
    80003d8c:	a819                	j	80003da2 <filealloc+0x5e>
      f->ref = 1;
    80003d8e:	4785                	li	a5,1
    80003d90:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003d92:	00015517          	auipc	a0,0x15
    80003d96:	3d650513          	addi	a0,a0,982 # 80019168 <ftable>
    80003d9a:	00003097          	auipc	ra,0x3
    80003d9e:	97c080e7          	jalr	-1668(ra) # 80006716 <release>
}
    80003da2:	8526                	mv	a0,s1
    80003da4:	60e2                	ld	ra,24(sp)
    80003da6:	6442                	ld	s0,16(sp)
    80003da8:	64a2                	ld	s1,8(sp)
    80003daa:	6105                	addi	sp,sp,32
    80003dac:	8082                	ret

0000000080003dae <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003dae:	1101                	addi	sp,sp,-32
    80003db0:	ec06                	sd	ra,24(sp)
    80003db2:	e822                	sd	s0,16(sp)
    80003db4:	e426                	sd	s1,8(sp)
    80003db6:	1000                	addi	s0,sp,32
    80003db8:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003dba:	00015517          	auipc	a0,0x15
    80003dbe:	3ae50513          	addi	a0,a0,942 # 80019168 <ftable>
    80003dc2:	00003097          	auipc	ra,0x3
    80003dc6:	8a0080e7          	jalr	-1888(ra) # 80006662 <acquire>
  if(f->ref < 1)
    80003dca:	40dc                	lw	a5,4(s1)
    80003dcc:	02f05263          	blez	a5,80003df0 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003dd0:	2785                	addiw	a5,a5,1
    80003dd2:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003dd4:	00015517          	auipc	a0,0x15
    80003dd8:	39450513          	addi	a0,a0,916 # 80019168 <ftable>
    80003ddc:	00003097          	auipc	ra,0x3
    80003de0:	93a080e7          	jalr	-1734(ra) # 80006716 <release>
  return f;
}
    80003de4:	8526                	mv	a0,s1
    80003de6:	60e2                	ld	ra,24(sp)
    80003de8:	6442                	ld	s0,16(sp)
    80003dea:	64a2                	ld	s1,8(sp)
    80003dec:	6105                	addi	sp,sp,32
    80003dee:	8082                	ret
    panic("filedup");
    80003df0:	00005517          	auipc	a0,0x5
    80003df4:	95850513          	addi	a0,a0,-1704 # 80008748 <syscalls+0x330>
    80003df8:	00002097          	auipc	ra,0x2
    80003dfc:	320080e7          	jalr	800(ra) # 80006118 <panic>

0000000080003e00 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003e00:	7139                	addi	sp,sp,-64
    80003e02:	fc06                	sd	ra,56(sp)
    80003e04:	f822                	sd	s0,48(sp)
    80003e06:	f426                	sd	s1,40(sp)
    80003e08:	f04a                	sd	s2,32(sp)
    80003e0a:	ec4e                	sd	s3,24(sp)
    80003e0c:	e852                	sd	s4,16(sp)
    80003e0e:	e456                	sd	s5,8(sp)
    80003e10:	0080                	addi	s0,sp,64
    80003e12:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003e14:	00015517          	auipc	a0,0x15
    80003e18:	35450513          	addi	a0,a0,852 # 80019168 <ftable>
    80003e1c:	00003097          	auipc	ra,0x3
    80003e20:	846080e7          	jalr	-1978(ra) # 80006662 <acquire>
  if(f->ref < 1)
    80003e24:	40dc                	lw	a5,4(s1)
    80003e26:	06f05163          	blez	a5,80003e88 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003e2a:	37fd                	addiw	a5,a5,-1
    80003e2c:	0007871b          	sext.w	a4,a5
    80003e30:	c0dc                	sw	a5,4(s1)
    80003e32:	06e04363          	bgtz	a4,80003e98 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003e36:	0004a903          	lw	s2,0(s1)
    80003e3a:	0094ca83          	lbu	s5,9(s1)
    80003e3e:	0104ba03          	ld	s4,16(s1)
    80003e42:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003e46:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003e4a:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003e4e:	00015517          	auipc	a0,0x15
    80003e52:	31a50513          	addi	a0,a0,794 # 80019168 <ftable>
    80003e56:	00003097          	auipc	ra,0x3
    80003e5a:	8c0080e7          	jalr	-1856(ra) # 80006716 <release>

  if(ff.type == FD_PIPE){
    80003e5e:	4785                	li	a5,1
    80003e60:	04f90d63          	beq	s2,a5,80003eba <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003e64:	3979                	addiw	s2,s2,-2
    80003e66:	4785                	li	a5,1
    80003e68:	0527e063          	bltu	a5,s2,80003ea8 <fileclose+0xa8>
    begin_op();
    80003e6c:	00000097          	auipc	ra,0x0
    80003e70:	ac8080e7          	jalr	-1336(ra) # 80003934 <begin_op>
    iput(ff.ip);
    80003e74:	854e                	mv	a0,s3
    80003e76:	fffff097          	auipc	ra,0xfffff
    80003e7a:	11e080e7          	jalr	286(ra) # 80002f94 <iput>
    end_op();
    80003e7e:	00000097          	auipc	ra,0x0
    80003e82:	b36080e7          	jalr	-1226(ra) # 800039b4 <end_op>
    80003e86:	a00d                	j	80003ea8 <fileclose+0xa8>
    panic("fileclose");
    80003e88:	00005517          	auipc	a0,0x5
    80003e8c:	8c850513          	addi	a0,a0,-1848 # 80008750 <syscalls+0x338>
    80003e90:	00002097          	auipc	ra,0x2
    80003e94:	288080e7          	jalr	648(ra) # 80006118 <panic>
    release(&ftable.lock);
    80003e98:	00015517          	auipc	a0,0x15
    80003e9c:	2d050513          	addi	a0,a0,720 # 80019168 <ftable>
    80003ea0:	00003097          	auipc	ra,0x3
    80003ea4:	876080e7          	jalr	-1930(ra) # 80006716 <release>
  }
}
    80003ea8:	70e2                	ld	ra,56(sp)
    80003eaa:	7442                	ld	s0,48(sp)
    80003eac:	74a2                	ld	s1,40(sp)
    80003eae:	7902                	ld	s2,32(sp)
    80003eb0:	69e2                	ld	s3,24(sp)
    80003eb2:	6a42                	ld	s4,16(sp)
    80003eb4:	6aa2                	ld	s5,8(sp)
    80003eb6:	6121                	addi	sp,sp,64
    80003eb8:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003eba:	85d6                	mv	a1,s5
    80003ebc:	8552                	mv	a0,s4
    80003ebe:	00000097          	auipc	ra,0x0
    80003ec2:	34c080e7          	jalr	844(ra) # 8000420a <pipeclose>
    80003ec6:	b7cd                	j	80003ea8 <fileclose+0xa8>

0000000080003ec8 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003ec8:	715d                	addi	sp,sp,-80
    80003eca:	e486                	sd	ra,72(sp)
    80003ecc:	e0a2                	sd	s0,64(sp)
    80003ece:	fc26                	sd	s1,56(sp)
    80003ed0:	f84a                	sd	s2,48(sp)
    80003ed2:	f44e                	sd	s3,40(sp)
    80003ed4:	0880                	addi	s0,sp,80
    80003ed6:	84aa                	mv	s1,a0
    80003ed8:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003eda:	ffffd097          	auipc	ra,0xffffd
    80003ede:	21a080e7          	jalr	538(ra) # 800010f4 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003ee2:	409c                	lw	a5,0(s1)
    80003ee4:	37f9                	addiw	a5,a5,-2
    80003ee6:	4705                	li	a4,1
    80003ee8:	04f76763          	bltu	a4,a5,80003f36 <filestat+0x6e>
    80003eec:	892a                	mv	s2,a0
    ilock(f->ip);
    80003eee:	6c88                	ld	a0,24(s1)
    80003ef0:	fffff097          	auipc	ra,0xfffff
    80003ef4:	eea080e7          	jalr	-278(ra) # 80002dda <ilock>
    stati(f->ip, &st);
    80003ef8:	fb840593          	addi	a1,s0,-72
    80003efc:	6c88                	ld	a0,24(s1)
    80003efe:	fffff097          	auipc	ra,0xfffff
    80003f02:	166080e7          	jalr	358(ra) # 80003064 <stati>
    iunlock(f->ip);
    80003f06:	6c88                	ld	a0,24(s1)
    80003f08:	fffff097          	auipc	ra,0xfffff
    80003f0c:	f94080e7          	jalr	-108(ra) # 80002e9c <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003f10:	46e1                	li	a3,24
    80003f12:	fb840613          	addi	a2,s0,-72
    80003f16:	85ce                	mv	a1,s3
    80003f18:	05093503          	ld	a0,80(s2)
    80003f1c:	ffffd097          	auipc	ra,0xffffd
    80003f20:	be6080e7          	jalr	-1050(ra) # 80000b02 <copyout>
    80003f24:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003f28:	60a6                	ld	ra,72(sp)
    80003f2a:	6406                	ld	s0,64(sp)
    80003f2c:	74e2                	ld	s1,56(sp)
    80003f2e:	7942                	ld	s2,48(sp)
    80003f30:	79a2                	ld	s3,40(sp)
    80003f32:	6161                	addi	sp,sp,80
    80003f34:	8082                	ret
  return -1;
    80003f36:	557d                	li	a0,-1
    80003f38:	bfc5                	j	80003f28 <filestat+0x60>

0000000080003f3a <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003f3a:	7179                	addi	sp,sp,-48
    80003f3c:	f406                	sd	ra,40(sp)
    80003f3e:	f022                	sd	s0,32(sp)
    80003f40:	ec26                	sd	s1,24(sp)
    80003f42:	e84a                	sd	s2,16(sp)
    80003f44:	e44e                	sd	s3,8(sp)
    80003f46:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003f48:	00854783          	lbu	a5,8(a0)
    80003f4c:	c3d5                	beqz	a5,80003ff0 <fileread+0xb6>
    80003f4e:	84aa                	mv	s1,a0
    80003f50:	89ae                	mv	s3,a1
    80003f52:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003f54:	411c                	lw	a5,0(a0)
    80003f56:	4705                	li	a4,1
    80003f58:	04e78963          	beq	a5,a4,80003faa <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003f5c:	470d                	li	a4,3
    80003f5e:	04e78d63          	beq	a5,a4,80003fb8 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003f62:	4709                	li	a4,2
    80003f64:	06e79e63          	bne	a5,a4,80003fe0 <fileread+0xa6>
    ilock(f->ip);
    80003f68:	6d08                	ld	a0,24(a0)
    80003f6a:	fffff097          	auipc	ra,0xfffff
    80003f6e:	e70080e7          	jalr	-400(ra) # 80002dda <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003f72:	874a                	mv	a4,s2
    80003f74:	5094                	lw	a3,32(s1)
    80003f76:	864e                	mv	a2,s3
    80003f78:	4585                	li	a1,1
    80003f7a:	6c88                	ld	a0,24(s1)
    80003f7c:	fffff097          	auipc	ra,0xfffff
    80003f80:	112080e7          	jalr	274(ra) # 8000308e <readi>
    80003f84:	892a                	mv	s2,a0
    80003f86:	00a05563          	blez	a0,80003f90 <fileread+0x56>
      f->off += r;
    80003f8a:	509c                	lw	a5,32(s1)
    80003f8c:	9fa9                	addw	a5,a5,a0
    80003f8e:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003f90:	6c88                	ld	a0,24(s1)
    80003f92:	fffff097          	auipc	ra,0xfffff
    80003f96:	f0a080e7          	jalr	-246(ra) # 80002e9c <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003f9a:	854a                	mv	a0,s2
    80003f9c:	70a2                	ld	ra,40(sp)
    80003f9e:	7402                	ld	s0,32(sp)
    80003fa0:	64e2                	ld	s1,24(sp)
    80003fa2:	6942                	ld	s2,16(sp)
    80003fa4:	69a2                	ld	s3,8(sp)
    80003fa6:	6145                	addi	sp,sp,48
    80003fa8:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003faa:	6908                	ld	a0,16(a0)
    80003fac:	00000097          	auipc	ra,0x0
    80003fb0:	3c8080e7          	jalr	968(ra) # 80004374 <piperead>
    80003fb4:	892a                	mv	s2,a0
    80003fb6:	b7d5                	j	80003f9a <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003fb8:	02451783          	lh	a5,36(a0)
    80003fbc:	03079693          	slli	a3,a5,0x30
    80003fc0:	92c1                	srli	a3,a3,0x30
    80003fc2:	4725                	li	a4,9
    80003fc4:	02d76863          	bltu	a4,a3,80003ff4 <fileread+0xba>
    80003fc8:	0792                	slli	a5,a5,0x4
    80003fca:	00015717          	auipc	a4,0x15
    80003fce:	0fe70713          	addi	a4,a4,254 # 800190c8 <devsw>
    80003fd2:	97ba                	add	a5,a5,a4
    80003fd4:	639c                	ld	a5,0(a5)
    80003fd6:	c38d                	beqz	a5,80003ff8 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003fd8:	4505                	li	a0,1
    80003fda:	9782                	jalr	a5
    80003fdc:	892a                	mv	s2,a0
    80003fde:	bf75                	j	80003f9a <fileread+0x60>
    panic("fileread");
    80003fe0:	00004517          	auipc	a0,0x4
    80003fe4:	78050513          	addi	a0,a0,1920 # 80008760 <syscalls+0x348>
    80003fe8:	00002097          	auipc	ra,0x2
    80003fec:	130080e7          	jalr	304(ra) # 80006118 <panic>
    return -1;
    80003ff0:	597d                	li	s2,-1
    80003ff2:	b765                	j	80003f9a <fileread+0x60>
      return -1;
    80003ff4:	597d                	li	s2,-1
    80003ff6:	b755                	j	80003f9a <fileread+0x60>
    80003ff8:	597d                	li	s2,-1
    80003ffa:	b745                	j	80003f9a <fileread+0x60>

0000000080003ffc <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003ffc:	715d                	addi	sp,sp,-80
    80003ffe:	e486                	sd	ra,72(sp)
    80004000:	e0a2                	sd	s0,64(sp)
    80004002:	fc26                	sd	s1,56(sp)
    80004004:	f84a                	sd	s2,48(sp)
    80004006:	f44e                	sd	s3,40(sp)
    80004008:	f052                	sd	s4,32(sp)
    8000400a:	ec56                	sd	s5,24(sp)
    8000400c:	e85a                	sd	s6,16(sp)
    8000400e:	e45e                	sd	s7,8(sp)
    80004010:	e062                	sd	s8,0(sp)
    80004012:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80004014:	00954783          	lbu	a5,9(a0)
    80004018:	10078663          	beqz	a5,80004124 <filewrite+0x128>
    8000401c:	892a                	mv	s2,a0
    8000401e:	8aae                	mv	s5,a1
    80004020:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80004022:	411c                	lw	a5,0(a0)
    80004024:	4705                	li	a4,1
    80004026:	02e78263          	beq	a5,a4,8000404a <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    8000402a:	470d                	li	a4,3
    8000402c:	02e78663          	beq	a5,a4,80004058 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80004030:	4709                	li	a4,2
    80004032:	0ee79163          	bne	a5,a4,80004114 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80004036:	0ac05d63          	blez	a2,800040f0 <filewrite+0xf4>
    int i = 0;
    8000403a:	4981                	li	s3,0
    8000403c:	6b05                	lui	s6,0x1
    8000403e:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80004042:	6b85                	lui	s7,0x1
    80004044:	c00b8b9b          	addiw	s7,s7,-1024
    80004048:	a861                	j	800040e0 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    8000404a:	6908                	ld	a0,16(a0)
    8000404c:	00000097          	auipc	ra,0x0
    80004050:	22e080e7          	jalr	558(ra) # 8000427a <pipewrite>
    80004054:	8a2a                	mv	s4,a0
    80004056:	a045                	j	800040f6 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80004058:	02451783          	lh	a5,36(a0)
    8000405c:	03079693          	slli	a3,a5,0x30
    80004060:	92c1                	srli	a3,a3,0x30
    80004062:	4725                	li	a4,9
    80004064:	0cd76263          	bltu	a4,a3,80004128 <filewrite+0x12c>
    80004068:	0792                	slli	a5,a5,0x4
    8000406a:	00015717          	auipc	a4,0x15
    8000406e:	05e70713          	addi	a4,a4,94 # 800190c8 <devsw>
    80004072:	97ba                	add	a5,a5,a4
    80004074:	679c                	ld	a5,8(a5)
    80004076:	cbdd                	beqz	a5,8000412c <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80004078:	4505                	li	a0,1
    8000407a:	9782                	jalr	a5
    8000407c:	8a2a                	mv	s4,a0
    8000407e:	a8a5                	j	800040f6 <filewrite+0xfa>
    80004080:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80004084:	00000097          	auipc	ra,0x0
    80004088:	8b0080e7          	jalr	-1872(ra) # 80003934 <begin_op>
      ilock(f->ip);
    8000408c:	01893503          	ld	a0,24(s2)
    80004090:	fffff097          	auipc	ra,0xfffff
    80004094:	d4a080e7          	jalr	-694(ra) # 80002dda <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004098:	8762                	mv	a4,s8
    8000409a:	02092683          	lw	a3,32(s2)
    8000409e:	01598633          	add	a2,s3,s5
    800040a2:	4585                	li	a1,1
    800040a4:	01893503          	ld	a0,24(s2)
    800040a8:	fffff097          	auipc	ra,0xfffff
    800040ac:	0de080e7          	jalr	222(ra) # 80003186 <writei>
    800040b0:	84aa                	mv	s1,a0
    800040b2:	00a05763          	blez	a0,800040c0 <filewrite+0xc4>
        f->off += r;
    800040b6:	02092783          	lw	a5,32(s2)
    800040ba:	9fa9                	addw	a5,a5,a0
    800040bc:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    800040c0:	01893503          	ld	a0,24(s2)
    800040c4:	fffff097          	auipc	ra,0xfffff
    800040c8:	dd8080e7          	jalr	-552(ra) # 80002e9c <iunlock>
      end_op();
    800040cc:	00000097          	auipc	ra,0x0
    800040d0:	8e8080e7          	jalr	-1816(ra) # 800039b4 <end_op>

      if(r != n1){
    800040d4:	009c1f63          	bne	s8,s1,800040f2 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    800040d8:	013489bb          	addw	s3,s1,s3
    while(i < n){
    800040dc:	0149db63          	bge	s3,s4,800040f2 <filewrite+0xf6>
      int n1 = n - i;
    800040e0:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    800040e4:	84be                	mv	s1,a5
    800040e6:	2781                	sext.w	a5,a5
    800040e8:	f8fb5ce3          	bge	s6,a5,80004080 <filewrite+0x84>
    800040ec:	84de                	mv	s1,s7
    800040ee:	bf49                	j	80004080 <filewrite+0x84>
    int i = 0;
    800040f0:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    800040f2:	013a1f63          	bne	s4,s3,80004110 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    800040f6:	8552                	mv	a0,s4
    800040f8:	60a6                	ld	ra,72(sp)
    800040fa:	6406                	ld	s0,64(sp)
    800040fc:	74e2                	ld	s1,56(sp)
    800040fe:	7942                	ld	s2,48(sp)
    80004100:	79a2                	ld	s3,40(sp)
    80004102:	7a02                	ld	s4,32(sp)
    80004104:	6ae2                	ld	s5,24(sp)
    80004106:	6b42                	ld	s6,16(sp)
    80004108:	6ba2                	ld	s7,8(sp)
    8000410a:	6c02                	ld	s8,0(sp)
    8000410c:	6161                	addi	sp,sp,80
    8000410e:	8082                	ret
    ret = (i == n ? n : -1);
    80004110:	5a7d                	li	s4,-1
    80004112:	b7d5                	j	800040f6 <filewrite+0xfa>
    panic("filewrite");
    80004114:	00004517          	auipc	a0,0x4
    80004118:	65c50513          	addi	a0,a0,1628 # 80008770 <syscalls+0x358>
    8000411c:	00002097          	auipc	ra,0x2
    80004120:	ffc080e7          	jalr	-4(ra) # 80006118 <panic>
    return -1;
    80004124:	5a7d                	li	s4,-1
    80004126:	bfc1                	j	800040f6 <filewrite+0xfa>
      return -1;
    80004128:	5a7d                	li	s4,-1
    8000412a:	b7f1                	j	800040f6 <filewrite+0xfa>
    8000412c:	5a7d                	li	s4,-1
    8000412e:	b7e1                	j	800040f6 <filewrite+0xfa>

0000000080004130 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80004130:	7179                	addi	sp,sp,-48
    80004132:	f406                	sd	ra,40(sp)
    80004134:	f022                	sd	s0,32(sp)
    80004136:	ec26                	sd	s1,24(sp)
    80004138:	e84a                	sd	s2,16(sp)
    8000413a:	e44e                	sd	s3,8(sp)
    8000413c:	e052                	sd	s4,0(sp)
    8000413e:	1800                	addi	s0,sp,48
    80004140:	84aa                	mv	s1,a0
    80004142:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004144:	0005b023          	sd	zero,0(a1)
    80004148:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    8000414c:	00000097          	auipc	ra,0x0
    80004150:	bf8080e7          	jalr	-1032(ra) # 80003d44 <filealloc>
    80004154:	e088                	sd	a0,0(s1)
    80004156:	c551                	beqz	a0,800041e2 <pipealloc+0xb2>
    80004158:	00000097          	auipc	ra,0x0
    8000415c:	bec080e7          	jalr	-1044(ra) # 80003d44 <filealloc>
    80004160:	00aa3023          	sd	a0,0(s4)
    80004164:	c92d                	beqz	a0,800041d6 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004166:	ffffc097          	auipc	ra,0xffffc
    8000416a:	fb2080e7          	jalr	-78(ra) # 80000118 <kalloc>
    8000416e:	892a                	mv	s2,a0
    80004170:	c125                	beqz	a0,800041d0 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80004172:	4985                	li	s3,1
    80004174:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004178:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    8000417c:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004180:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004184:	00004597          	auipc	a1,0x4
    80004188:	5fc58593          	addi	a1,a1,1532 # 80008780 <syscalls+0x368>
    8000418c:	00002097          	auipc	ra,0x2
    80004190:	446080e7          	jalr	1094(ra) # 800065d2 <initlock>
  (*f0)->type = FD_PIPE;
    80004194:	609c                	ld	a5,0(s1)
    80004196:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    8000419a:	609c                	ld	a5,0(s1)
    8000419c:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    800041a0:	609c                	ld	a5,0(s1)
    800041a2:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    800041a6:	609c                	ld	a5,0(s1)
    800041a8:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    800041ac:	000a3783          	ld	a5,0(s4)
    800041b0:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    800041b4:	000a3783          	ld	a5,0(s4)
    800041b8:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    800041bc:	000a3783          	ld	a5,0(s4)
    800041c0:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    800041c4:	000a3783          	ld	a5,0(s4)
    800041c8:	0127b823          	sd	s2,16(a5)
  return 0;
    800041cc:	4501                	li	a0,0
    800041ce:	a025                	j	800041f6 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    800041d0:	6088                	ld	a0,0(s1)
    800041d2:	e501                	bnez	a0,800041da <pipealloc+0xaa>
    800041d4:	a039                	j	800041e2 <pipealloc+0xb2>
    800041d6:	6088                	ld	a0,0(s1)
    800041d8:	c51d                	beqz	a0,80004206 <pipealloc+0xd6>
    fileclose(*f0);
    800041da:	00000097          	auipc	ra,0x0
    800041de:	c26080e7          	jalr	-986(ra) # 80003e00 <fileclose>
  if(*f1)
    800041e2:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    800041e6:	557d                	li	a0,-1
  if(*f1)
    800041e8:	c799                	beqz	a5,800041f6 <pipealloc+0xc6>
    fileclose(*f1);
    800041ea:	853e                	mv	a0,a5
    800041ec:	00000097          	auipc	ra,0x0
    800041f0:	c14080e7          	jalr	-1004(ra) # 80003e00 <fileclose>
  return -1;
    800041f4:	557d                	li	a0,-1
}
    800041f6:	70a2                	ld	ra,40(sp)
    800041f8:	7402                	ld	s0,32(sp)
    800041fa:	64e2                	ld	s1,24(sp)
    800041fc:	6942                	ld	s2,16(sp)
    800041fe:	69a2                	ld	s3,8(sp)
    80004200:	6a02                	ld	s4,0(sp)
    80004202:	6145                	addi	sp,sp,48
    80004204:	8082                	ret
  return -1;
    80004206:	557d                	li	a0,-1
    80004208:	b7fd                	j	800041f6 <pipealloc+0xc6>

000000008000420a <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    8000420a:	1101                	addi	sp,sp,-32
    8000420c:	ec06                	sd	ra,24(sp)
    8000420e:	e822                	sd	s0,16(sp)
    80004210:	e426                	sd	s1,8(sp)
    80004212:	e04a                	sd	s2,0(sp)
    80004214:	1000                	addi	s0,sp,32
    80004216:	84aa                	mv	s1,a0
    80004218:	892e                	mv	s2,a1
  acquire(&pi->lock);
    8000421a:	00002097          	auipc	ra,0x2
    8000421e:	448080e7          	jalr	1096(ra) # 80006662 <acquire>
  if(writable){
    80004222:	02090d63          	beqz	s2,8000425c <pipeclose+0x52>
    pi->writeopen = 0;
    80004226:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    8000422a:	21848513          	addi	a0,s1,536
    8000422e:	ffffd097          	auipc	ra,0xffffd
    80004232:	70e080e7          	jalr	1806(ra) # 8000193c <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004236:	2204b783          	ld	a5,544(s1)
    8000423a:	eb95                	bnez	a5,8000426e <pipeclose+0x64>
    release(&pi->lock);
    8000423c:	8526                	mv	a0,s1
    8000423e:	00002097          	auipc	ra,0x2
    80004242:	4d8080e7          	jalr	1240(ra) # 80006716 <release>
    kfree((char*)pi);
    80004246:	8526                	mv	a0,s1
    80004248:	ffffc097          	auipc	ra,0xffffc
    8000424c:	dd4080e7          	jalr	-556(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80004250:	60e2                	ld	ra,24(sp)
    80004252:	6442                	ld	s0,16(sp)
    80004254:	64a2                	ld	s1,8(sp)
    80004256:	6902                	ld	s2,0(sp)
    80004258:	6105                	addi	sp,sp,32
    8000425a:	8082                	ret
    pi->readopen = 0;
    8000425c:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004260:	21c48513          	addi	a0,s1,540
    80004264:	ffffd097          	auipc	ra,0xffffd
    80004268:	6d8080e7          	jalr	1752(ra) # 8000193c <wakeup>
    8000426c:	b7e9                	j	80004236 <pipeclose+0x2c>
    release(&pi->lock);
    8000426e:	8526                	mv	a0,s1
    80004270:	00002097          	auipc	ra,0x2
    80004274:	4a6080e7          	jalr	1190(ra) # 80006716 <release>
}
    80004278:	bfe1                	j	80004250 <pipeclose+0x46>

000000008000427a <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    8000427a:	7159                	addi	sp,sp,-112
    8000427c:	f486                	sd	ra,104(sp)
    8000427e:	f0a2                	sd	s0,96(sp)
    80004280:	eca6                	sd	s1,88(sp)
    80004282:	e8ca                	sd	s2,80(sp)
    80004284:	e4ce                	sd	s3,72(sp)
    80004286:	e0d2                	sd	s4,64(sp)
    80004288:	fc56                	sd	s5,56(sp)
    8000428a:	f85a                	sd	s6,48(sp)
    8000428c:	f45e                	sd	s7,40(sp)
    8000428e:	f062                	sd	s8,32(sp)
    80004290:	ec66                	sd	s9,24(sp)
    80004292:	1880                	addi	s0,sp,112
    80004294:	84aa                	mv	s1,a0
    80004296:	8aae                	mv	s5,a1
    80004298:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    8000429a:	ffffd097          	auipc	ra,0xffffd
    8000429e:	e5a080e7          	jalr	-422(ra) # 800010f4 <myproc>
    800042a2:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    800042a4:	8526                	mv	a0,s1
    800042a6:	00002097          	auipc	ra,0x2
    800042aa:	3bc080e7          	jalr	956(ra) # 80006662 <acquire>
  while(i < n){
    800042ae:	0d405163          	blez	s4,80004370 <pipewrite+0xf6>
    800042b2:	8ba6                	mv	s7,s1
  int i = 0;
    800042b4:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800042b6:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    800042b8:	21848c93          	addi	s9,s1,536
      sleep(&pi->nwrite, &pi->lock);
    800042bc:	21c48c13          	addi	s8,s1,540
    800042c0:	a08d                	j	80004322 <pipewrite+0xa8>
      release(&pi->lock);
    800042c2:	8526                	mv	a0,s1
    800042c4:	00002097          	auipc	ra,0x2
    800042c8:	452080e7          	jalr	1106(ra) # 80006716 <release>
      return -1;
    800042cc:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    800042ce:	854a                	mv	a0,s2
    800042d0:	70a6                	ld	ra,104(sp)
    800042d2:	7406                	ld	s0,96(sp)
    800042d4:	64e6                	ld	s1,88(sp)
    800042d6:	6946                	ld	s2,80(sp)
    800042d8:	69a6                	ld	s3,72(sp)
    800042da:	6a06                	ld	s4,64(sp)
    800042dc:	7ae2                	ld	s5,56(sp)
    800042de:	7b42                	ld	s6,48(sp)
    800042e0:	7ba2                	ld	s7,40(sp)
    800042e2:	7c02                	ld	s8,32(sp)
    800042e4:	6ce2                	ld	s9,24(sp)
    800042e6:	6165                	addi	sp,sp,112
    800042e8:	8082                	ret
      wakeup(&pi->nread);
    800042ea:	8566                	mv	a0,s9
    800042ec:	ffffd097          	auipc	ra,0xffffd
    800042f0:	650080e7          	jalr	1616(ra) # 8000193c <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    800042f4:	85de                	mv	a1,s7
    800042f6:	8562                	mv	a0,s8
    800042f8:	ffffd097          	auipc	ra,0xffffd
    800042fc:	4b8080e7          	jalr	1208(ra) # 800017b0 <sleep>
    80004300:	a839                	j	8000431e <pipewrite+0xa4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004302:	21c4a783          	lw	a5,540(s1)
    80004306:	0017871b          	addiw	a4,a5,1
    8000430a:	20e4ae23          	sw	a4,540(s1)
    8000430e:	1ff7f793          	andi	a5,a5,511
    80004312:	97a6                	add	a5,a5,s1
    80004314:	f9f44703          	lbu	a4,-97(s0)
    80004318:	00e78c23          	sb	a4,24(a5)
      i++;
    8000431c:	2905                	addiw	s2,s2,1
  while(i < n){
    8000431e:	03495d63          	bge	s2,s4,80004358 <pipewrite+0xde>
    if(pi->readopen == 0 || pr->killed){
    80004322:	2204a783          	lw	a5,544(s1)
    80004326:	dfd1                	beqz	a5,800042c2 <pipewrite+0x48>
    80004328:	0289a783          	lw	a5,40(s3)
    8000432c:	fbd9                	bnez	a5,800042c2 <pipewrite+0x48>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    8000432e:	2184a783          	lw	a5,536(s1)
    80004332:	21c4a703          	lw	a4,540(s1)
    80004336:	2007879b          	addiw	a5,a5,512
    8000433a:	faf708e3          	beq	a4,a5,800042ea <pipewrite+0x70>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000433e:	4685                	li	a3,1
    80004340:	01590633          	add	a2,s2,s5
    80004344:	f9f40593          	addi	a1,s0,-97
    80004348:	0509b503          	ld	a0,80(s3)
    8000434c:	ffffd097          	auipc	ra,0xffffd
    80004350:	842080e7          	jalr	-1982(ra) # 80000b8e <copyin>
    80004354:	fb6517e3          	bne	a0,s6,80004302 <pipewrite+0x88>
  wakeup(&pi->nread);
    80004358:	21848513          	addi	a0,s1,536
    8000435c:	ffffd097          	auipc	ra,0xffffd
    80004360:	5e0080e7          	jalr	1504(ra) # 8000193c <wakeup>
  release(&pi->lock);
    80004364:	8526                	mv	a0,s1
    80004366:	00002097          	auipc	ra,0x2
    8000436a:	3b0080e7          	jalr	944(ra) # 80006716 <release>
  return i;
    8000436e:	b785                	j	800042ce <pipewrite+0x54>
  int i = 0;
    80004370:	4901                	li	s2,0
    80004372:	b7dd                	j	80004358 <pipewrite+0xde>

0000000080004374 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004374:	715d                	addi	sp,sp,-80
    80004376:	e486                	sd	ra,72(sp)
    80004378:	e0a2                	sd	s0,64(sp)
    8000437a:	fc26                	sd	s1,56(sp)
    8000437c:	f84a                	sd	s2,48(sp)
    8000437e:	f44e                	sd	s3,40(sp)
    80004380:	f052                	sd	s4,32(sp)
    80004382:	ec56                	sd	s5,24(sp)
    80004384:	e85a                	sd	s6,16(sp)
    80004386:	0880                	addi	s0,sp,80
    80004388:	84aa                	mv	s1,a0
    8000438a:	892e                	mv	s2,a1
    8000438c:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    8000438e:	ffffd097          	auipc	ra,0xffffd
    80004392:	d66080e7          	jalr	-666(ra) # 800010f4 <myproc>
    80004396:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004398:	8b26                	mv	s6,s1
    8000439a:	8526                	mv	a0,s1
    8000439c:	00002097          	auipc	ra,0x2
    800043a0:	2c6080e7          	jalr	710(ra) # 80006662 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800043a4:	2184a703          	lw	a4,536(s1)
    800043a8:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800043ac:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800043b0:	02f71463          	bne	a4,a5,800043d8 <piperead+0x64>
    800043b4:	2244a783          	lw	a5,548(s1)
    800043b8:	c385                	beqz	a5,800043d8 <piperead+0x64>
    if(pr->killed){
    800043ba:	028a2783          	lw	a5,40(s4)
    800043be:	ebc1                	bnez	a5,8000444e <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800043c0:	85da                	mv	a1,s6
    800043c2:	854e                	mv	a0,s3
    800043c4:	ffffd097          	auipc	ra,0xffffd
    800043c8:	3ec080e7          	jalr	1004(ra) # 800017b0 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800043cc:	2184a703          	lw	a4,536(s1)
    800043d0:	21c4a783          	lw	a5,540(s1)
    800043d4:	fef700e3          	beq	a4,a5,800043b4 <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800043d8:	09505263          	blez	s5,8000445c <piperead+0xe8>
    800043dc:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800043de:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    800043e0:	2184a783          	lw	a5,536(s1)
    800043e4:	21c4a703          	lw	a4,540(s1)
    800043e8:	02f70d63          	beq	a4,a5,80004422 <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800043ec:	0017871b          	addiw	a4,a5,1
    800043f0:	20e4ac23          	sw	a4,536(s1)
    800043f4:	1ff7f793          	andi	a5,a5,511
    800043f8:	97a6                	add	a5,a5,s1
    800043fa:	0187c783          	lbu	a5,24(a5)
    800043fe:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004402:	4685                	li	a3,1
    80004404:	fbf40613          	addi	a2,s0,-65
    80004408:	85ca                	mv	a1,s2
    8000440a:	050a3503          	ld	a0,80(s4)
    8000440e:	ffffc097          	auipc	ra,0xffffc
    80004412:	6f4080e7          	jalr	1780(ra) # 80000b02 <copyout>
    80004416:	01650663          	beq	a0,s6,80004422 <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000441a:	2985                	addiw	s3,s3,1
    8000441c:	0905                	addi	s2,s2,1
    8000441e:	fd3a91e3          	bne	s5,s3,800043e0 <piperead+0x6c>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004422:	21c48513          	addi	a0,s1,540
    80004426:	ffffd097          	auipc	ra,0xffffd
    8000442a:	516080e7          	jalr	1302(ra) # 8000193c <wakeup>
  release(&pi->lock);
    8000442e:	8526                	mv	a0,s1
    80004430:	00002097          	auipc	ra,0x2
    80004434:	2e6080e7          	jalr	742(ra) # 80006716 <release>
  return i;
}
    80004438:	854e                	mv	a0,s3
    8000443a:	60a6                	ld	ra,72(sp)
    8000443c:	6406                	ld	s0,64(sp)
    8000443e:	74e2                	ld	s1,56(sp)
    80004440:	7942                	ld	s2,48(sp)
    80004442:	79a2                	ld	s3,40(sp)
    80004444:	7a02                	ld	s4,32(sp)
    80004446:	6ae2                	ld	s5,24(sp)
    80004448:	6b42                	ld	s6,16(sp)
    8000444a:	6161                	addi	sp,sp,80
    8000444c:	8082                	ret
      release(&pi->lock);
    8000444e:	8526                	mv	a0,s1
    80004450:	00002097          	auipc	ra,0x2
    80004454:	2c6080e7          	jalr	710(ra) # 80006716 <release>
      return -1;
    80004458:	59fd                	li	s3,-1
    8000445a:	bff9                	j	80004438 <piperead+0xc4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000445c:	4981                	li	s3,0
    8000445e:	b7d1                	j	80004422 <piperead+0xae>

0000000080004460 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    80004460:	df010113          	addi	sp,sp,-528
    80004464:	20113423          	sd	ra,520(sp)
    80004468:	20813023          	sd	s0,512(sp)
    8000446c:	ffa6                	sd	s1,504(sp)
    8000446e:	fbca                	sd	s2,496(sp)
    80004470:	f7ce                	sd	s3,488(sp)
    80004472:	f3d2                	sd	s4,480(sp)
    80004474:	efd6                	sd	s5,472(sp)
    80004476:	ebda                	sd	s6,464(sp)
    80004478:	e7de                	sd	s7,456(sp)
    8000447a:	e3e2                	sd	s8,448(sp)
    8000447c:	ff66                	sd	s9,440(sp)
    8000447e:	fb6a                	sd	s10,432(sp)
    80004480:	f76e                	sd	s11,424(sp)
    80004482:	0c00                	addi	s0,sp,528
    80004484:	84aa                	mv	s1,a0
    80004486:	dea43c23          	sd	a0,-520(s0)
    8000448a:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    8000448e:	ffffd097          	auipc	ra,0xffffd
    80004492:	c66080e7          	jalr	-922(ra) # 800010f4 <myproc>
    80004496:	892a                	mv	s2,a0

  begin_op();
    80004498:	fffff097          	auipc	ra,0xfffff
    8000449c:	49c080e7          	jalr	1180(ra) # 80003934 <begin_op>

  if((ip = namei(path)) == 0){
    800044a0:	8526                	mv	a0,s1
    800044a2:	fffff097          	auipc	ra,0xfffff
    800044a6:	0e4080e7          	jalr	228(ra) # 80003586 <namei>
    800044aa:	c92d                	beqz	a0,8000451c <exec+0xbc>
    800044ac:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800044ae:	fffff097          	auipc	ra,0xfffff
    800044b2:	92c080e7          	jalr	-1748(ra) # 80002dda <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800044b6:	04000713          	li	a4,64
    800044ba:	4681                	li	a3,0
    800044bc:	e5040613          	addi	a2,s0,-432
    800044c0:	4581                	li	a1,0
    800044c2:	8526                	mv	a0,s1
    800044c4:	fffff097          	auipc	ra,0xfffff
    800044c8:	bca080e7          	jalr	-1078(ra) # 8000308e <readi>
    800044cc:	04000793          	li	a5,64
    800044d0:	00f51a63          	bne	a0,a5,800044e4 <exec+0x84>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    800044d4:	e5042703          	lw	a4,-432(s0)
    800044d8:	464c47b7          	lui	a5,0x464c4
    800044dc:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800044e0:	04f70463          	beq	a4,a5,80004528 <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800044e4:	8526                	mv	a0,s1
    800044e6:	fffff097          	auipc	ra,0xfffff
    800044ea:	b56080e7          	jalr	-1194(ra) # 8000303c <iunlockput>
    end_op();
    800044ee:	fffff097          	auipc	ra,0xfffff
    800044f2:	4c6080e7          	jalr	1222(ra) # 800039b4 <end_op>
  }
  return -1;
    800044f6:	557d                	li	a0,-1
}
    800044f8:	20813083          	ld	ra,520(sp)
    800044fc:	20013403          	ld	s0,512(sp)
    80004500:	74fe                	ld	s1,504(sp)
    80004502:	795e                	ld	s2,496(sp)
    80004504:	79be                	ld	s3,488(sp)
    80004506:	7a1e                	ld	s4,480(sp)
    80004508:	6afe                	ld	s5,472(sp)
    8000450a:	6b5e                	ld	s6,464(sp)
    8000450c:	6bbe                	ld	s7,456(sp)
    8000450e:	6c1e                	ld	s8,448(sp)
    80004510:	7cfa                	ld	s9,440(sp)
    80004512:	7d5a                	ld	s10,432(sp)
    80004514:	7dba                	ld	s11,424(sp)
    80004516:	21010113          	addi	sp,sp,528
    8000451a:	8082                	ret
    end_op();
    8000451c:	fffff097          	auipc	ra,0xfffff
    80004520:	498080e7          	jalr	1176(ra) # 800039b4 <end_op>
    return -1;
    80004524:	557d                	li	a0,-1
    80004526:	bfc9                	j	800044f8 <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    80004528:	854a                	mv	a0,s2
    8000452a:	ffffd097          	auipc	ra,0xffffd
    8000452e:	c8e080e7          	jalr	-882(ra) # 800011b8 <proc_pagetable>
    80004532:	8baa                	mv	s7,a0
    80004534:	d945                	beqz	a0,800044e4 <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004536:	e7042983          	lw	s3,-400(s0)
    8000453a:	e8845783          	lhu	a5,-376(s0)
    8000453e:	c7ad                	beqz	a5,800045a8 <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004540:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004542:	4b01                	li	s6,0
    if((ph.vaddr % PGSIZE) != 0)
    80004544:	6c85                	lui	s9,0x1
    80004546:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    8000454a:	def43823          	sd	a5,-528(s0)
    8000454e:	a42d                	j	80004778 <exec+0x318>
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80004550:	00004517          	auipc	a0,0x4
    80004554:	23850513          	addi	a0,a0,568 # 80008788 <syscalls+0x370>
    80004558:	00002097          	auipc	ra,0x2
    8000455c:	bc0080e7          	jalr	-1088(ra) # 80006118 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004560:	8756                	mv	a4,s5
    80004562:	012d86bb          	addw	a3,s11,s2
    80004566:	4581                	li	a1,0
    80004568:	8526                	mv	a0,s1
    8000456a:	fffff097          	auipc	ra,0xfffff
    8000456e:	b24080e7          	jalr	-1244(ra) # 8000308e <readi>
    80004572:	2501                	sext.w	a0,a0
    80004574:	1aaa9963          	bne	s5,a0,80004726 <exec+0x2c6>
  for(i = 0; i < sz; i += PGSIZE){
    80004578:	6785                	lui	a5,0x1
    8000457a:	0127893b          	addw	s2,a5,s2
    8000457e:	77fd                	lui	a5,0xfffff
    80004580:	01478a3b          	addw	s4,a5,s4
    80004584:	1f897163          	bgeu	s2,s8,80004766 <exec+0x306>
    pa = walkaddr(pagetable, va + i);
    80004588:	02091593          	slli	a1,s2,0x20
    8000458c:	9181                	srli	a1,a1,0x20
    8000458e:	95ea                	add	a1,a1,s10
    80004590:	855e                	mv	a0,s7
    80004592:	ffffc097          	auipc	ra,0xffffc
    80004596:	f74080e7          	jalr	-140(ra) # 80000506 <walkaddr>
    8000459a:	862a                	mv	a2,a0
    if(pa == 0)
    8000459c:	d955                	beqz	a0,80004550 <exec+0xf0>
      n = PGSIZE;
    8000459e:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    800045a0:	fd9a70e3          	bgeu	s4,s9,80004560 <exec+0x100>
      n = sz - i;
    800045a4:	8ad2                	mv	s5,s4
    800045a6:	bf6d                	j	80004560 <exec+0x100>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800045a8:	4901                	li	s2,0
  iunlockput(ip);
    800045aa:	8526                	mv	a0,s1
    800045ac:	fffff097          	auipc	ra,0xfffff
    800045b0:	a90080e7          	jalr	-1392(ra) # 8000303c <iunlockput>
  end_op();
    800045b4:	fffff097          	auipc	ra,0xfffff
    800045b8:	400080e7          	jalr	1024(ra) # 800039b4 <end_op>
  p = myproc();
    800045bc:	ffffd097          	auipc	ra,0xffffd
    800045c0:	b38080e7          	jalr	-1224(ra) # 800010f4 <myproc>
    800045c4:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    800045c6:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    800045ca:	6785                	lui	a5,0x1
    800045cc:	17fd                	addi	a5,a5,-1
    800045ce:	993e                	add	s2,s2,a5
    800045d0:	757d                	lui	a0,0xfffff
    800045d2:	00a977b3          	and	a5,s2,a0
    800045d6:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    800045da:	6609                	lui	a2,0x2
    800045dc:	963e                	add	a2,a2,a5
    800045de:	85be                	mv	a1,a5
    800045e0:	855e                	mv	a0,s7
    800045e2:	ffffc097          	auipc	ra,0xffffc
    800045e6:	2d0080e7          	jalr	720(ra) # 800008b2 <uvmalloc>
    800045ea:	8b2a                	mv	s6,a0
  ip = 0;
    800045ec:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    800045ee:	12050c63          	beqz	a0,80004726 <exec+0x2c6>
  uvmclear(pagetable, sz-2*PGSIZE);
    800045f2:	75f9                	lui	a1,0xffffe
    800045f4:	95aa                	add	a1,a1,a0
    800045f6:	855e                	mv	a0,s7
    800045f8:	ffffc097          	auipc	ra,0xffffc
    800045fc:	4d8080e7          	jalr	1240(ra) # 80000ad0 <uvmclear>
  stackbase = sp - PGSIZE;
    80004600:	7c7d                	lui	s8,0xfffff
    80004602:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    80004604:	e0043783          	ld	a5,-512(s0)
    80004608:	6388                	ld	a0,0(a5)
    8000460a:	c535                	beqz	a0,80004676 <exec+0x216>
    8000460c:	e9040993          	addi	s3,s0,-368
    80004610:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80004614:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    80004616:	ffffc097          	auipc	ra,0xffffc
    8000461a:	ce6080e7          	jalr	-794(ra) # 800002fc <strlen>
    8000461e:	2505                	addiw	a0,a0,1
    80004620:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004624:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    80004628:	13896363          	bltu	s2,s8,8000474e <exec+0x2ee>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    8000462c:	e0043d83          	ld	s11,-512(s0)
    80004630:	000dba03          	ld	s4,0(s11)
    80004634:	8552                	mv	a0,s4
    80004636:	ffffc097          	auipc	ra,0xffffc
    8000463a:	cc6080e7          	jalr	-826(ra) # 800002fc <strlen>
    8000463e:	0015069b          	addiw	a3,a0,1
    80004642:	8652                	mv	a2,s4
    80004644:	85ca                	mv	a1,s2
    80004646:	855e                	mv	a0,s7
    80004648:	ffffc097          	auipc	ra,0xffffc
    8000464c:	4ba080e7          	jalr	1210(ra) # 80000b02 <copyout>
    80004650:	10054363          	bltz	a0,80004756 <exec+0x2f6>
    ustack[argc] = sp;
    80004654:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004658:	0485                	addi	s1,s1,1
    8000465a:	008d8793          	addi	a5,s11,8
    8000465e:	e0f43023          	sd	a5,-512(s0)
    80004662:	008db503          	ld	a0,8(s11)
    80004666:	c911                	beqz	a0,8000467a <exec+0x21a>
    if(argc >= MAXARG)
    80004668:	09a1                	addi	s3,s3,8
    8000466a:	fb3c96e3          	bne	s9,s3,80004616 <exec+0x1b6>
  sz = sz1;
    8000466e:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004672:	4481                	li	s1,0
    80004674:	a84d                	j	80004726 <exec+0x2c6>
  sp = sz;
    80004676:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    80004678:	4481                	li	s1,0
  ustack[argc] = 0;
    8000467a:	00349793          	slli	a5,s1,0x3
    8000467e:	f9040713          	addi	a4,s0,-112
    80004682:	97ba                	add	a5,a5,a4
    80004684:	f007b023          	sd	zero,-256(a5) # f00 <_entry-0x7ffff100>
  sp -= (argc+1) * sizeof(uint64);
    80004688:	00148693          	addi	a3,s1,1
    8000468c:	068e                	slli	a3,a3,0x3
    8000468e:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004692:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80004696:	01897663          	bgeu	s2,s8,800046a2 <exec+0x242>
  sz = sz1;
    8000469a:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000469e:	4481                	li	s1,0
    800046a0:	a059                	j	80004726 <exec+0x2c6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800046a2:	e9040613          	addi	a2,s0,-368
    800046a6:	85ca                	mv	a1,s2
    800046a8:	855e                	mv	a0,s7
    800046aa:	ffffc097          	auipc	ra,0xffffc
    800046ae:	458080e7          	jalr	1112(ra) # 80000b02 <copyout>
    800046b2:	0a054663          	bltz	a0,8000475e <exec+0x2fe>
  p->trapframe->a1 = sp;
    800046b6:	058ab783          	ld	a5,88(s5)
    800046ba:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800046be:	df843783          	ld	a5,-520(s0)
    800046c2:	0007c703          	lbu	a4,0(a5)
    800046c6:	cf11                	beqz	a4,800046e2 <exec+0x282>
    800046c8:	0785                	addi	a5,a5,1
    if(*s == '/')
    800046ca:	02f00693          	li	a3,47
    800046ce:	a039                	j	800046dc <exec+0x27c>
      last = s+1;
    800046d0:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    800046d4:	0785                	addi	a5,a5,1
    800046d6:	fff7c703          	lbu	a4,-1(a5)
    800046da:	c701                	beqz	a4,800046e2 <exec+0x282>
    if(*s == '/')
    800046dc:	fed71ce3          	bne	a4,a3,800046d4 <exec+0x274>
    800046e0:	bfc5                	j	800046d0 <exec+0x270>
  safestrcpy(p->name, last, sizeof(p->name));
    800046e2:	4641                	li	a2,16
    800046e4:	df843583          	ld	a1,-520(s0)
    800046e8:	158a8513          	addi	a0,s5,344
    800046ec:	ffffc097          	auipc	ra,0xffffc
    800046f0:	bde080e7          	jalr	-1058(ra) # 800002ca <safestrcpy>
  oldpagetable = p->pagetable;
    800046f4:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    800046f8:	057ab823          	sd	s7,80(s5)
  p->sz = sz;
    800046fc:	056ab423          	sd	s6,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004700:	058ab783          	ld	a5,88(s5)
    80004704:	e6843703          	ld	a4,-408(s0)
    80004708:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    8000470a:	058ab783          	ld	a5,88(s5)
    8000470e:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004712:	85ea                	mv	a1,s10
    80004714:	ffffd097          	auipc	ra,0xffffd
    80004718:	b40080e7          	jalr	-1216(ra) # 80001254 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    8000471c:	0004851b          	sext.w	a0,s1
    80004720:	bbe1                	j	800044f8 <exec+0x98>
    80004722:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    80004726:	e0843583          	ld	a1,-504(s0)
    8000472a:	855e                	mv	a0,s7
    8000472c:	ffffd097          	auipc	ra,0xffffd
    80004730:	b28080e7          	jalr	-1240(ra) # 80001254 <proc_freepagetable>
  if(ip){
    80004734:	da0498e3          	bnez	s1,800044e4 <exec+0x84>
  return -1;
    80004738:	557d                	li	a0,-1
    8000473a:	bb7d                	j	800044f8 <exec+0x98>
    8000473c:	e1243423          	sd	s2,-504(s0)
    80004740:	b7dd                	j	80004726 <exec+0x2c6>
    80004742:	e1243423          	sd	s2,-504(s0)
    80004746:	b7c5                	j	80004726 <exec+0x2c6>
    80004748:	e1243423          	sd	s2,-504(s0)
    8000474c:	bfe9                	j	80004726 <exec+0x2c6>
  sz = sz1;
    8000474e:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004752:	4481                	li	s1,0
    80004754:	bfc9                	j	80004726 <exec+0x2c6>
  sz = sz1;
    80004756:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000475a:	4481                	li	s1,0
    8000475c:	b7e9                	j	80004726 <exec+0x2c6>
  sz = sz1;
    8000475e:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004762:	4481                	li	s1,0
    80004764:	b7c9                	j	80004726 <exec+0x2c6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004766:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000476a:	2b05                	addiw	s6,s6,1
    8000476c:	0389899b          	addiw	s3,s3,56
    80004770:	e8845783          	lhu	a5,-376(s0)
    80004774:	e2fb5be3          	bge	s6,a5,800045aa <exec+0x14a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004778:	2981                	sext.w	s3,s3
    8000477a:	03800713          	li	a4,56
    8000477e:	86ce                	mv	a3,s3
    80004780:	e1840613          	addi	a2,s0,-488
    80004784:	4581                	li	a1,0
    80004786:	8526                	mv	a0,s1
    80004788:	fffff097          	auipc	ra,0xfffff
    8000478c:	906080e7          	jalr	-1786(ra) # 8000308e <readi>
    80004790:	03800793          	li	a5,56
    80004794:	f8f517e3          	bne	a0,a5,80004722 <exec+0x2c2>
    if(ph.type != ELF_PROG_LOAD)
    80004798:	e1842783          	lw	a5,-488(s0)
    8000479c:	4705                	li	a4,1
    8000479e:	fce796e3          	bne	a5,a4,8000476a <exec+0x30a>
    if(ph.memsz < ph.filesz)
    800047a2:	e4043603          	ld	a2,-448(s0)
    800047a6:	e3843783          	ld	a5,-456(s0)
    800047aa:	f8f669e3          	bltu	a2,a5,8000473c <exec+0x2dc>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800047ae:	e2843783          	ld	a5,-472(s0)
    800047b2:	963e                	add	a2,a2,a5
    800047b4:	f8f667e3          	bltu	a2,a5,80004742 <exec+0x2e2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800047b8:	85ca                	mv	a1,s2
    800047ba:	855e                	mv	a0,s7
    800047bc:	ffffc097          	auipc	ra,0xffffc
    800047c0:	0f6080e7          	jalr	246(ra) # 800008b2 <uvmalloc>
    800047c4:	e0a43423          	sd	a0,-504(s0)
    800047c8:	d141                	beqz	a0,80004748 <exec+0x2e8>
    if((ph.vaddr % PGSIZE) != 0)
    800047ca:	e2843d03          	ld	s10,-472(s0)
    800047ce:	df043783          	ld	a5,-528(s0)
    800047d2:	00fd77b3          	and	a5,s10,a5
    800047d6:	fba1                	bnez	a5,80004726 <exec+0x2c6>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800047d8:	e2042d83          	lw	s11,-480(s0)
    800047dc:	e3842c03          	lw	s8,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800047e0:	f80c03e3          	beqz	s8,80004766 <exec+0x306>
    800047e4:	8a62                	mv	s4,s8
    800047e6:	4901                	li	s2,0
    800047e8:	b345                	j	80004588 <exec+0x128>

00000000800047ea <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800047ea:	7179                	addi	sp,sp,-48
    800047ec:	f406                	sd	ra,40(sp)
    800047ee:	f022                	sd	s0,32(sp)
    800047f0:	ec26                	sd	s1,24(sp)
    800047f2:	e84a                	sd	s2,16(sp)
    800047f4:	1800                	addi	s0,sp,48
    800047f6:	892e                	mv	s2,a1
    800047f8:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    800047fa:	fdc40593          	addi	a1,s0,-36
    800047fe:	ffffe097          	auipc	ra,0xffffe
    80004802:	9a2080e7          	jalr	-1630(ra) # 800021a0 <argint>
    80004806:	04054063          	bltz	a0,80004846 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    8000480a:	fdc42703          	lw	a4,-36(s0)
    8000480e:	47bd                	li	a5,15
    80004810:	02e7ed63          	bltu	a5,a4,8000484a <argfd+0x60>
    80004814:	ffffd097          	auipc	ra,0xffffd
    80004818:	8e0080e7          	jalr	-1824(ra) # 800010f4 <myproc>
    8000481c:	fdc42703          	lw	a4,-36(s0)
    80004820:	01a70793          	addi	a5,a4,26
    80004824:	078e                	slli	a5,a5,0x3
    80004826:	953e                	add	a0,a0,a5
    80004828:	611c                	ld	a5,0(a0)
    8000482a:	c395                	beqz	a5,8000484e <argfd+0x64>
    return -1;
  if(pfd)
    8000482c:	00090463          	beqz	s2,80004834 <argfd+0x4a>
    *pfd = fd;
    80004830:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004834:	4501                	li	a0,0
  if(pf)
    80004836:	c091                	beqz	s1,8000483a <argfd+0x50>
    *pf = f;
    80004838:	e09c                	sd	a5,0(s1)
}
    8000483a:	70a2                	ld	ra,40(sp)
    8000483c:	7402                	ld	s0,32(sp)
    8000483e:	64e2                	ld	s1,24(sp)
    80004840:	6942                	ld	s2,16(sp)
    80004842:	6145                	addi	sp,sp,48
    80004844:	8082                	ret
    return -1;
    80004846:	557d                	li	a0,-1
    80004848:	bfcd                	j	8000483a <argfd+0x50>
    return -1;
    8000484a:	557d                	li	a0,-1
    8000484c:	b7fd                	j	8000483a <argfd+0x50>
    8000484e:	557d                	li	a0,-1
    80004850:	b7ed                	j	8000483a <argfd+0x50>

0000000080004852 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004852:	1101                	addi	sp,sp,-32
    80004854:	ec06                	sd	ra,24(sp)
    80004856:	e822                	sd	s0,16(sp)
    80004858:	e426                	sd	s1,8(sp)
    8000485a:	1000                	addi	s0,sp,32
    8000485c:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    8000485e:	ffffd097          	auipc	ra,0xffffd
    80004862:	896080e7          	jalr	-1898(ra) # 800010f4 <myproc>
    80004866:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004868:	0d050793          	addi	a5,a0,208 # fffffffffffff0d0 <end+0xffffffff7ffd8e90>
    8000486c:	4501                	li	a0,0
    8000486e:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004870:	6398                	ld	a4,0(a5)
    80004872:	cb19                	beqz	a4,80004888 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004874:	2505                	addiw	a0,a0,1
    80004876:	07a1                	addi	a5,a5,8
    80004878:	fed51ce3          	bne	a0,a3,80004870 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    8000487c:	557d                	li	a0,-1
}
    8000487e:	60e2                	ld	ra,24(sp)
    80004880:	6442                	ld	s0,16(sp)
    80004882:	64a2                	ld	s1,8(sp)
    80004884:	6105                	addi	sp,sp,32
    80004886:	8082                	ret
      p->ofile[fd] = f;
    80004888:	01a50793          	addi	a5,a0,26
    8000488c:	078e                	slli	a5,a5,0x3
    8000488e:	963e                	add	a2,a2,a5
    80004890:	e204                	sd	s1,0(a2)
      return fd;
    80004892:	b7f5                	j	8000487e <fdalloc+0x2c>

0000000080004894 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004894:	715d                	addi	sp,sp,-80
    80004896:	e486                	sd	ra,72(sp)
    80004898:	e0a2                	sd	s0,64(sp)
    8000489a:	fc26                	sd	s1,56(sp)
    8000489c:	f84a                	sd	s2,48(sp)
    8000489e:	f44e                	sd	s3,40(sp)
    800048a0:	f052                	sd	s4,32(sp)
    800048a2:	ec56                	sd	s5,24(sp)
    800048a4:	0880                	addi	s0,sp,80
    800048a6:	89ae                	mv	s3,a1
    800048a8:	8ab2                	mv	s5,a2
    800048aa:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800048ac:	fb040593          	addi	a1,s0,-80
    800048b0:	fffff097          	auipc	ra,0xfffff
    800048b4:	cf4080e7          	jalr	-780(ra) # 800035a4 <nameiparent>
    800048b8:	892a                	mv	s2,a0
    800048ba:	12050f63          	beqz	a0,800049f8 <create+0x164>
    return 0;

  ilock(dp);
    800048be:	ffffe097          	auipc	ra,0xffffe
    800048c2:	51c080e7          	jalr	1308(ra) # 80002dda <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800048c6:	4601                	li	a2,0
    800048c8:	fb040593          	addi	a1,s0,-80
    800048cc:	854a                	mv	a0,s2
    800048ce:	fffff097          	auipc	ra,0xfffff
    800048d2:	9e6080e7          	jalr	-1562(ra) # 800032b4 <dirlookup>
    800048d6:	84aa                	mv	s1,a0
    800048d8:	c921                	beqz	a0,80004928 <create+0x94>
    iunlockput(dp);
    800048da:	854a                	mv	a0,s2
    800048dc:	ffffe097          	auipc	ra,0xffffe
    800048e0:	760080e7          	jalr	1888(ra) # 8000303c <iunlockput>
    ilock(ip);
    800048e4:	8526                	mv	a0,s1
    800048e6:	ffffe097          	auipc	ra,0xffffe
    800048ea:	4f4080e7          	jalr	1268(ra) # 80002dda <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800048ee:	2981                	sext.w	s3,s3
    800048f0:	4789                	li	a5,2
    800048f2:	02f99463          	bne	s3,a5,8000491a <create+0x86>
    800048f6:	0444d783          	lhu	a5,68(s1)
    800048fa:	37f9                	addiw	a5,a5,-2
    800048fc:	17c2                	slli	a5,a5,0x30
    800048fe:	93c1                	srli	a5,a5,0x30
    80004900:	4705                	li	a4,1
    80004902:	00f76c63          	bltu	a4,a5,8000491a <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    80004906:	8526                	mv	a0,s1
    80004908:	60a6                	ld	ra,72(sp)
    8000490a:	6406                	ld	s0,64(sp)
    8000490c:	74e2                	ld	s1,56(sp)
    8000490e:	7942                	ld	s2,48(sp)
    80004910:	79a2                	ld	s3,40(sp)
    80004912:	7a02                	ld	s4,32(sp)
    80004914:	6ae2                	ld	s5,24(sp)
    80004916:	6161                	addi	sp,sp,80
    80004918:	8082                	ret
    iunlockput(ip);
    8000491a:	8526                	mv	a0,s1
    8000491c:	ffffe097          	auipc	ra,0xffffe
    80004920:	720080e7          	jalr	1824(ra) # 8000303c <iunlockput>
    return 0;
    80004924:	4481                	li	s1,0
    80004926:	b7c5                	j	80004906 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    80004928:	85ce                	mv	a1,s3
    8000492a:	00092503          	lw	a0,0(s2)
    8000492e:	ffffe097          	auipc	ra,0xffffe
    80004932:	326080e7          	jalr	806(ra) # 80002c54 <ialloc>
    80004936:	84aa                	mv	s1,a0
    80004938:	c529                	beqz	a0,80004982 <create+0xee>
  ilock(ip);
    8000493a:	ffffe097          	auipc	ra,0xffffe
    8000493e:	4a0080e7          	jalr	1184(ra) # 80002dda <ilock>
  ip->major = major;
    80004942:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    80004946:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    8000494a:	4785                	li	a5,1
    8000494c:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004950:	8526                	mv	a0,s1
    80004952:	ffffe097          	auipc	ra,0xffffe
    80004956:	3c6080e7          	jalr	966(ra) # 80002d18 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    8000495a:	2981                	sext.w	s3,s3
    8000495c:	4785                	li	a5,1
    8000495e:	02f98a63          	beq	s3,a5,80004992 <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    80004962:	40d0                	lw	a2,4(s1)
    80004964:	fb040593          	addi	a1,s0,-80
    80004968:	854a                	mv	a0,s2
    8000496a:	fffff097          	auipc	ra,0xfffff
    8000496e:	b5a080e7          	jalr	-1190(ra) # 800034c4 <dirlink>
    80004972:	06054b63          	bltz	a0,800049e8 <create+0x154>
  iunlockput(dp);
    80004976:	854a                	mv	a0,s2
    80004978:	ffffe097          	auipc	ra,0xffffe
    8000497c:	6c4080e7          	jalr	1732(ra) # 8000303c <iunlockput>
  return ip;
    80004980:	b759                	j	80004906 <create+0x72>
    panic("create: ialloc");
    80004982:	00004517          	auipc	a0,0x4
    80004986:	e2650513          	addi	a0,a0,-474 # 800087a8 <syscalls+0x390>
    8000498a:	00001097          	auipc	ra,0x1
    8000498e:	78e080e7          	jalr	1934(ra) # 80006118 <panic>
    dp->nlink++;  // for ".."
    80004992:	04a95783          	lhu	a5,74(s2)
    80004996:	2785                	addiw	a5,a5,1
    80004998:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    8000499c:	854a                	mv	a0,s2
    8000499e:	ffffe097          	auipc	ra,0xffffe
    800049a2:	37a080e7          	jalr	890(ra) # 80002d18 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800049a6:	40d0                	lw	a2,4(s1)
    800049a8:	00004597          	auipc	a1,0x4
    800049ac:	e1058593          	addi	a1,a1,-496 # 800087b8 <syscalls+0x3a0>
    800049b0:	8526                	mv	a0,s1
    800049b2:	fffff097          	auipc	ra,0xfffff
    800049b6:	b12080e7          	jalr	-1262(ra) # 800034c4 <dirlink>
    800049ba:	00054f63          	bltz	a0,800049d8 <create+0x144>
    800049be:	00492603          	lw	a2,4(s2)
    800049c2:	00004597          	auipc	a1,0x4
    800049c6:	dfe58593          	addi	a1,a1,-514 # 800087c0 <syscalls+0x3a8>
    800049ca:	8526                	mv	a0,s1
    800049cc:	fffff097          	auipc	ra,0xfffff
    800049d0:	af8080e7          	jalr	-1288(ra) # 800034c4 <dirlink>
    800049d4:	f80557e3          	bgez	a0,80004962 <create+0xce>
      panic("create dots");
    800049d8:	00004517          	auipc	a0,0x4
    800049dc:	df050513          	addi	a0,a0,-528 # 800087c8 <syscalls+0x3b0>
    800049e0:	00001097          	auipc	ra,0x1
    800049e4:	738080e7          	jalr	1848(ra) # 80006118 <panic>
    panic("create: dirlink");
    800049e8:	00004517          	auipc	a0,0x4
    800049ec:	df050513          	addi	a0,a0,-528 # 800087d8 <syscalls+0x3c0>
    800049f0:	00001097          	auipc	ra,0x1
    800049f4:	728080e7          	jalr	1832(ra) # 80006118 <panic>
    return 0;
    800049f8:	84aa                	mv	s1,a0
    800049fa:	b731                	j	80004906 <create+0x72>

00000000800049fc <sys_dup>:
{
    800049fc:	7179                	addi	sp,sp,-48
    800049fe:	f406                	sd	ra,40(sp)
    80004a00:	f022                	sd	s0,32(sp)
    80004a02:	ec26                	sd	s1,24(sp)
    80004a04:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004a06:	fd840613          	addi	a2,s0,-40
    80004a0a:	4581                	li	a1,0
    80004a0c:	4501                	li	a0,0
    80004a0e:	00000097          	auipc	ra,0x0
    80004a12:	ddc080e7          	jalr	-548(ra) # 800047ea <argfd>
    return -1;
    80004a16:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004a18:	02054363          	bltz	a0,80004a3e <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    80004a1c:	fd843503          	ld	a0,-40(s0)
    80004a20:	00000097          	auipc	ra,0x0
    80004a24:	e32080e7          	jalr	-462(ra) # 80004852 <fdalloc>
    80004a28:	84aa                	mv	s1,a0
    return -1;
    80004a2a:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004a2c:	00054963          	bltz	a0,80004a3e <sys_dup+0x42>
  filedup(f);
    80004a30:	fd843503          	ld	a0,-40(s0)
    80004a34:	fffff097          	auipc	ra,0xfffff
    80004a38:	37a080e7          	jalr	890(ra) # 80003dae <filedup>
  return fd;
    80004a3c:	87a6                	mv	a5,s1
}
    80004a3e:	853e                	mv	a0,a5
    80004a40:	70a2                	ld	ra,40(sp)
    80004a42:	7402                	ld	s0,32(sp)
    80004a44:	64e2                	ld	s1,24(sp)
    80004a46:	6145                	addi	sp,sp,48
    80004a48:	8082                	ret

0000000080004a4a <sys_read>:
{
    80004a4a:	7179                	addi	sp,sp,-48
    80004a4c:	f406                	sd	ra,40(sp)
    80004a4e:	f022                	sd	s0,32(sp)
    80004a50:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004a52:	fe840613          	addi	a2,s0,-24
    80004a56:	4581                	li	a1,0
    80004a58:	4501                	li	a0,0
    80004a5a:	00000097          	auipc	ra,0x0
    80004a5e:	d90080e7          	jalr	-624(ra) # 800047ea <argfd>
    return -1;
    80004a62:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004a64:	04054163          	bltz	a0,80004aa6 <sys_read+0x5c>
    80004a68:	fe440593          	addi	a1,s0,-28
    80004a6c:	4509                	li	a0,2
    80004a6e:	ffffd097          	auipc	ra,0xffffd
    80004a72:	732080e7          	jalr	1842(ra) # 800021a0 <argint>
    return -1;
    80004a76:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004a78:	02054763          	bltz	a0,80004aa6 <sys_read+0x5c>
    80004a7c:	fd840593          	addi	a1,s0,-40
    80004a80:	4505                	li	a0,1
    80004a82:	ffffd097          	auipc	ra,0xffffd
    80004a86:	740080e7          	jalr	1856(ra) # 800021c2 <argaddr>
    return -1;
    80004a8a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004a8c:	00054d63          	bltz	a0,80004aa6 <sys_read+0x5c>
  return fileread(f, p, n);
    80004a90:	fe442603          	lw	a2,-28(s0)
    80004a94:	fd843583          	ld	a1,-40(s0)
    80004a98:	fe843503          	ld	a0,-24(s0)
    80004a9c:	fffff097          	auipc	ra,0xfffff
    80004aa0:	49e080e7          	jalr	1182(ra) # 80003f3a <fileread>
    80004aa4:	87aa                	mv	a5,a0
}
    80004aa6:	853e                	mv	a0,a5
    80004aa8:	70a2                	ld	ra,40(sp)
    80004aaa:	7402                	ld	s0,32(sp)
    80004aac:	6145                	addi	sp,sp,48
    80004aae:	8082                	ret

0000000080004ab0 <sys_write>:
{
    80004ab0:	7179                	addi	sp,sp,-48
    80004ab2:	f406                	sd	ra,40(sp)
    80004ab4:	f022                	sd	s0,32(sp)
    80004ab6:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004ab8:	fe840613          	addi	a2,s0,-24
    80004abc:	4581                	li	a1,0
    80004abe:	4501                	li	a0,0
    80004ac0:	00000097          	auipc	ra,0x0
    80004ac4:	d2a080e7          	jalr	-726(ra) # 800047ea <argfd>
    return -1;
    80004ac8:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004aca:	04054163          	bltz	a0,80004b0c <sys_write+0x5c>
    80004ace:	fe440593          	addi	a1,s0,-28
    80004ad2:	4509                	li	a0,2
    80004ad4:	ffffd097          	auipc	ra,0xffffd
    80004ad8:	6cc080e7          	jalr	1740(ra) # 800021a0 <argint>
    return -1;
    80004adc:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004ade:	02054763          	bltz	a0,80004b0c <sys_write+0x5c>
    80004ae2:	fd840593          	addi	a1,s0,-40
    80004ae6:	4505                	li	a0,1
    80004ae8:	ffffd097          	auipc	ra,0xffffd
    80004aec:	6da080e7          	jalr	1754(ra) # 800021c2 <argaddr>
    return -1;
    80004af0:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004af2:	00054d63          	bltz	a0,80004b0c <sys_write+0x5c>
  return filewrite(f, p, n);
    80004af6:	fe442603          	lw	a2,-28(s0)
    80004afa:	fd843583          	ld	a1,-40(s0)
    80004afe:	fe843503          	ld	a0,-24(s0)
    80004b02:	fffff097          	auipc	ra,0xfffff
    80004b06:	4fa080e7          	jalr	1274(ra) # 80003ffc <filewrite>
    80004b0a:	87aa                	mv	a5,a0
}
    80004b0c:	853e                	mv	a0,a5
    80004b0e:	70a2                	ld	ra,40(sp)
    80004b10:	7402                	ld	s0,32(sp)
    80004b12:	6145                	addi	sp,sp,48
    80004b14:	8082                	ret

0000000080004b16 <sys_close>:
{
    80004b16:	1101                	addi	sp,sp,-32
    80004b18:	ec06                	sd	ra,24(sp)
    80004b1a:	e822                	sd	s0,16(sp)
    80004b1c:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004b1e:	fe040613          	addi	a2,s0,-32
    80004b22:	fec40593          	addi	a1,s0,-20
    80004b26:	4501                	li	a0,0
    80004b28:	00000097          	auipc	ra,0x0
    80004b2c:	cc2080e7          	jalr	-830(ra) # 800047ea <argfd>
    return -1;
    80004b30:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004b32:	02054463          	bltz	a0,80004b5a <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80004b36:	ffffc097          	auipc	ra,0xffffc
    80004b3a:	5be080e7          	jalr	1470(ra) # 800010f4 <myproc>
    80004b3e:	fec42783          	lw	a5,-20(s0)
    80004b42:	07e9                	addi	a5,a5,26
    80004b44:	078e                	slli	a5,a5,0x3
    80004b46:	97aa                	add	a5,a5,a0
    80004b48:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    80004b4c:	fe043503          	ld	a0,-32(s0)
    80004b50:	fffff097          	auipc	ra,0xfffff
    80004b54:	2b0080e7          	jalr	688(ra) # 80003e00 <fileclose>
  return 0;
    80004b58:	4781                	li	a5,0
}
    80004b5a:	853e                	mv	a0,a5
    80004b5c:	60e2                	ld	ra,24(sp)
    80004b5e:	6442                	ld	s0,16(sp)
    80004b60:	6105                	addi	sp,sp,32
    80004b62:	8082                	ret

0000000080004b64 <sys_fstat>:
{
    80004b64:	1101                	addi	sp,sp,-32
    80004b66:	ec06                	sd	ra,24(sp)
    80004b68:	e822                	sd	s0,16(sp)
    80004b6a:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004b6c:	fe840613          	addi	a2,s0,-24
    80004b70:	4581                	li	a1,0
    80004b72:	4501                	li	a0,0
    80004b74:	00000097          	auipc	ra,0x0
    80004b78:	c76080e7          	jalr	-906(ra) # 800047ea <argfd>
    return -1;
    80004b7c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004b7e:	02054563          	bltz	a0,80004ba8 <sys_fstat+0x44>
    80004b82:	fe040593          	addi	a1,s0,-32
    80004b86:	4505                	li	a0,1
    80004b88:	ffffd097          	auipc	ra,0xffffd
    80004b8c:	63a080e7          	jalr	1594(ra) # 800021c2 <argaddr>
    return -1;
    80004b90:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004b92:	00054b63          	bltz	a0,80004ba8 <sys_fstat+0x44>
  return filestat(f, st);
    80004b96:	fe043583          	ld	a1,-32(s0)
    80004b9a:	fe843503          	ld	a0,-24(s0)
    80004b9e:	fffff097          	auipc	ra,0xfffff
    80004ba2:	32a080e7          	jalr	810(ra) # 80003ec8 <filestat>
    80004ba6:	87aa                	mv	a5,a0
}
    80004ba8:	853e                	mv	a0,a5
    80004baa:	60e2                	ld	ra,24(sp)
    80004bac:	6442                	ld	s0,16(sp)
    80004bae:	6105                	addi	sp,sp,32
    80004bb0:	8082                	ret

0000000080004bb2 <sys_link>:
{
    80004bb2:	7169                	addi	sp,sp,-304
    80004bb4:	f606                	sd	ra,296(sp)
    80004bb6:	f222                	sd	s0,288(sp)
    80004bb8:	ee26                	sd	s1,280(sp)
    80004bba:	ea4a                	sd	s2,272(sp)
    80004bbc:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004bbe:	08000613          	li	a2,128
    80004bc2:	ed040593          	addi	a1,s0,-304
    80004bc6:	4501                	li	a0,0
    80004bc8:	ffffd097          	auipc	ra,0xffffd
    80004bcc:	61c080e7          	jalr	1564(ra) # 800021e4 <argstr>
    return -1;
    80004bd0:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004bd2:	10054e63          	bltz	a0,80004cee <sys_link+0x13c>
    80004bd6:	08000613          	li	a2,128
    80004bda:	f5040593          	addi	a1,s0,-176
    80004bde:	4505                	li	a0,1
    80004be0:	ffffd097          	auipc	ra,0xffffd
    80004be4:	604080e7          	jalr	1540(ra) # 800021e4 <argstr>
    return -1;
    80004be8:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004bea:	10054263          	bltz	a0,80004cee <sys_link+0x13c>
  begin_op();
    80004bee:	fffff097          	auipc	ra,0xfffff
    80004bf2:	d46080e7          	jalr	-698(ra) # 80003934 <begin_op>
  if((ip = namei(old)) == 0){
    80004bf6:	ed040513          	addi	a0,s0,-304
    80004bfa:	fffff097          	auipc	ra,0xfffff
    80004bfe:	98c080e7          	jalr	-1652(ra) # 80003586 <namei>
    80004c02:	84aa                	mv	s1,a0
    80004c04:	c551                	beqz	a0,80004c90 <sys_link+0xde>
  ilock(ip);
    80004c06:	ffffe097          	auipc	ra,0xffffe
    80004c0a:	1d4080e7          	jalr	468(ra) # 80002dda <ilock>
  if(ip->type == T_DIR){
    80004c0e:	04449703          	lh	a4,68(s1)
    80004c12:	4785                	li	a5,1
    80004c14:	08f70463          	beq	a4,a5,80004c9c <sys_link+0xea>
  ip->nlink++;
    80004c18:	04a4d783          	lhu	a5,74(s1)
    80004c1c:	2785                	addiw	a5,a5,1
    80004c1e:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004c22:	8526                	mv	a0,s1
    80004c24:	ffffe097          	auipc	ra,0xffffe
    80004c28:	0f4080e7          	jalr	244(ra) # 80002d18 <iupdate>
  iunlock(ip);
    80004c2c:	8526                	mv	a0,s1
    80004c2e:	ffffe097          	auipc	ra,0xffffe
    80004c32:	26e080e7          	jalr	622(ra) # 80002e9c <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004c36:	fd040593          	addi	a1,s0,-48
    80004c3a:	f5040513          	addi	a0,s0,-176
    80004c3e:	fffff097          	auipc	ra,0xfffff
    80004c42:	966080e7          	jalr	-1690(ra) # 800035a4 <nameiparent>
    80004c46:	892a                	mv	s2,a0
    80004c48:	c935                	beqz	a0,80004cbc <sys_link+0x10a>
  ilock(dp);
    80004c4a:	ffffe097          	auipc	ra,0xffffe
    80004c4e:	190080e7          	jalr	400(ra) # 80002dda <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004c52:	00092703          	lw	a4,0(s2)
    80004c56:	409c                	lw	a5,0(s1)
    80004c58:	04f71d63          	bne	a4,a5,80004cb2 <sys_link+0x100>
    80004c5c:	40d0                	lw	a2,4(s1)
    80004c5e:	fd040593          	addi	a1,s0,-48
    80004c62:	854a                	mv	a0,s2
    80004c64:	fffff097          	auipc	ra,0xfffff
    80004c68:	860080e7          	jalr	-1952(ra) # 800034c4 <dirlink>
    80004c6c:	04054363          	bltz	a0,80004cb2 <sys_link+0x100>
  iunlockput(dp);
    80004c70:	854a                	mv	a0,s2
    80004c72:	ffffe097          	auipc	ra,0xffffe
    80004c76:	3ca080e7          	jalr	970(ra) # 8000303c <iunlockput>
  iput(ip);
    80004c7a:	8526                	mv	a0,s1
    80004c7c:	ffffe097          	auipc	ra,0xffffe
    80004c80:	318080e7          	jalr	792(ra) # 80002f94 <iput>
  end_op();
    80004c84:	fffff097          	auipc	ra,0xfffff
    80004c88:	d30080e7          	jalr	-720(ra) # 800039b4 <end_op>
  return 0;
    80004c8c:	4781                	li	a5,0
    80004c8e:	a085                	j	80004cee <sys_link+0x13c>
    end_op();
    80004c90:	fffff097          	auipc	ra,0xfffff
    80004c94:	d24080e7          	jalr	-732(ra) # 800039b4 <end_op>
    return -1;
    80004c98:	57fd                	li	a5,-1
    80004c9a:	a891                	j	80004cee <sys_link+0x13c>
    iunlockput(ip);
    80004c9c:	8526                	mv	a0,s1
    80004c9e:	ffffe097          	auipc	ra,0xffffe
    80004ca2:	39e080e7          	jalr	926(ra) # 8000303c <iunlockput>
    end_op();
    80004ca6:	fffff097          	auipc	ra,0xfffff
    80004caa:	d0e080e7          	jalr	-754(ra) # 800039b4 <end_op>
    return -1;
    80004cae:	57fd                	li	a5,-1
    80004cb0:	a83d                	j	80004cee <sys_link+0x13c>
    iunlockput(dp);
    80004cb2:	854a                	mv	a0,s2
    80004cb4:	ffffe097          	auipc	ra,0xffffe
    80004cb8:	388080e7          	jalr	904(ra) # 8000303c <iunlockput>
  ilock(ip);
    80004cbc:	8526                	mv	a0,s1
    80004cbe:	ffffe097          	auipc	ra,0xffffe
    80004cc2:	11c080e7          	jalr	284(ra) # 80002dda <ilock>
  ip->nlink--;
    80004cc6:	04a4d783          	lhu	a5,74(s1)
    80004cca:	37fd                	addiw	a5,a5,-1
    80004ccc:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004cd0:	8526                	mv	a0,s1
    80004cd2:	ffffe097          	auipc	ra,0xffffe
    80004cd6:	046080e7          	jalr	70(ra) # 80002d18 <iupdate>
  iunlockput(ip);
    80004cda:	8526                	mv	a0,s1
    80004cdc:	ffffe097          	auipc	ra,0xffffe
    80004ce0:	360080e7          	jalr	864(ra) # 8000303c <iunlockput>
  end_op();
    80004ce4:	fffff097          	auipc	ra,0xfffff
    80004ce8:	cd0080e7          	jalr	-816(ra) # 800039b4 <end_op>
  return -1;
    80004cec:	57fd                	li	a5,-1
}
    80004cee:	853e                	mv	a0,a5
    80004cf0:	70b2                	ld	ra,296(sp)
    80004cf2:	7412                	ld	s0,288(sp)
    80004cf4:	64f2                	ld	s1,280(sp)
    80004cf6:	6952                	ld	s2,272(sp)
    80004cf8:	6155                	addi	sp,sp,304
    80004cfa:	8082                	ret

0000000080004cfc <sys_unlink>:
{
    80004cfc:	7151                	addi	sp,sp,-240
    80004cfe:	f586                	sd	ra,232(sp)
    80004d00:	f1a2                	sd	s0,224(sp)
    80004d02:	eda6                	sd	s1,216(sp)
    80004d04:	e9ca                	sd	s2,208(sp)
    80004d06:	e5ce                	sd	s3,200(sp)
    80004d08:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004d0a:	08000613          	li	a2,128
    80004d0e:	f3040593          	addi	a1,s0,-208
    80004d12:	4501                	li	a0,0
    80004d14:	ffffd097          	auipc	ra,0xffffd
    80004d18:	4d0080e7          	jalr	1232(ra) # 800021e4 <argstr>
    80004d1c:	18054163          	bltz	a0,80004e9e <sys_unlink+0x1a2>
  begin_op();
    80004d20:	fffff097          	auipc	ra,0xfffff
    80004d24:	c14080e7          	jalr	-1004(ra) # 80003934 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004d28:	fb040593          	addi	a1,s0,-80
    80004d2c:	f3040513          	addi	a0,s0,-208
    80004d30:	fffff097          	auipc	ra,0xfffff
    80004d34:	874080e7          	jalr	-1932(ra) # 800035a4 <nameiparent>
    80004d38:	84aa                	mv	s1,a0
    80004d3a:	c979                	beqz	a0,80004e10 <sys_unlink+0x114>
  ilock(dp);
    80004d3c:	ffffe097          	auipc	ra,0xffffe
    80004d40:	09e080e7          	jalr	158(ra) # 80002dda <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004d44:	00004597          	auipc	a1,0x4
    80004d48:	a7458593          	addi	a1,a1,-1420 # 800087b8 <syscalls+0x3a0>
    80004d4c:	fb040513          	addi	a0,s0,-80
    80004d50:	ffffe097          	auipc	ra,0xffffe
    80004d54:	54a080e7          	jalr	1354(ra) # 8000329a <namecmp>
    80004d58:	14050a63          	beqz	a0,80004eac <sys_unlink+0x1b0>
    80004d5c:	00004597          	auipc	a1,0x4
    80004d60:	a6458593          	addi	a1,a1,-1436 # 800087c0 <syscalls+0x3a8>
    80004d64:	fb040513          	addi	a0,s0,-80
    80004d68:	ffffe097          	auipc	ra,0xffffe
    80004d6c:	532080e7          	jalr	1330(ra) # 8000329a <namecmp>
    80004d70:	12050e63          	beqz	a0,80004eac <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004d74:	f2c40613          	addi	a2,s0,-212
    80004d78:	fb040593          	addi	a1,s0,-80
    80004d7c:	8526                	mv	a0,s1
    80004d7e:	ffffe097          	auipc	ra,0xffffe
    80004d82:	536080e7          	jalr	1334(ra) # 800032b4 <dirlookup>
    80004d86:	892a                	mv	s2,a0
    80004d88:	12050263          	beqz	a0,80004eac <sys_unlink+0x1b0>
  ilock(ip);
    80004d8c:	ffffe097          	auipc	ra,0xffffe
    80004d90:	04e080e7          	jalr	78(ra) # 80002dda <ilock>
  if(ip->nlink < 1)
    80004d94:	04a91783          	lh	a5,74(s2)
    80004d98:	08f05263          	blez	a5,80004e1c <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004d9c:	04491703          	lh	a4,68(s2)
    80004da0:	4785                	li	a5,1
    80004da2:	08f70563          	beq	a4,a5,80004e2c <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004da6:	4641                	li	a2,16
    80004da8:	4581                	li	a1,0
    80004daa:	fc040513          	addi	a0,s0,-64
    80004dae:	ffffb097          	auipc	ra,0xffffb
    80004db2:	3ca080e7          	jalr	970(ra) # 80000178 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004db6:	4741                	li	a4,16
    80004db8:	f2c42683          	lw	a3,-212(s0)
    80004dbc:	fc040613          	addi	a2,s0,-64
    80004dc0:	4581                	li	a1,0
    80004dc2:	8526                	mv	a0,s1
    80004dc4:	ffffe097          	auipc	ra,0xffffe
    80004dc8:	3c2080e7          	jalr	962(ra) # 80003186 <writei>
    80004dcc:	47c1                	li	a5,16
    80004dce:	0af51563          	bne	a0,a5,80004e78 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004dd2:	04491703          	lh	a4,68(s2)
    80004dd6:	4785                	li	a5,1
    80004dd8:	0af70863          	beq	a4,a5,80004e88 <sys_unlink+0x18c>
  iunlockput(dp);
    80004ddc:	8526                	mv	a0,s1
    80004dde:	ffffe097          	auipc	ra,0xffffe
    80004de2:	25e080e7          	jalr	606(ra) # 8000303c <iunlockput>
  ip->nlink--;
    80004de6:	04a95783          	lhu	a5,74(s2)
    80004dea:	37fd                	addiw	a5,a5,-1
    80004dec:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004df0:	854a                	mv	a0,s2
    80004df2:	ffffe097          	auipc	ra,0xffffe
    80004df6:	f26080e7          	jalr	-218(ra) # 80002d18 <iupdate>
  iunlockput(ip);
    80004dfa:	854a                	mv	a0,s2
    80004dfc:	ffffe097          	auipc	ra,0xffffe
    80004e00:	240080e7          	jalr	576(ra) # 8000303c <iunlockput>
  end_op();
    80004e04:	fffff097          	auipc	ra,0xfffff
    80004e08:	bb0080e7          	jalr	-1104(ra) # 800039b4 <end_op>
  return 0;
    80004e0c:	4501                	li	a0,0
    80004e0e:	a84d                	j	80004ec0 <sys_unlink+0x1c4>
    end_op();
    80004e10:	fffff097          	auipc	ra,0xfffff
    80004e14:	ba4080e7          	jalr	-1116(ra) # 800039b4 <end_op>
    return -1;
    80004e18:	557d                	li	a0,-1
    80004e1a:	a05d                	j	80004ec0 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004e1c:	00004517          	auipc	a0,0x4
    80004e20:	9cc50513          	addi	a0,a0,-1588 # 800087e8 <syscalls+0x3d0>
    80004e24:	00001097          	auipc	ra,0x1
    80004e28:	2f4080e7          	jalr	756(ra) # 80006118 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004e2c:	04c92703          	lw	a4,76(s2)
    80004e30:	02000793          	li	a5,32
    80004e34:	f6e7f9e3          	bgeu	a5,a4,80004da6 <sys_unlink+0xaa>
    80004e38:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004e3c:	4741                	li	a4,16
    80004e3e:	86ce                	mv	a3,s3
    80004e40:	f1840613          	addi	a2,s0,-232
    80004e44:	4581                	li	a1,0
    80004e46:	854a                	mv	a0,s2
    80004e48:	ffffe097          	auipc	ra,0xffffe
    80004e4c:	246080e7          	jalr	582(ra) # 8000308e <readi>
    80004e50:	47c1                	li	a5,16
    80004e52:	00f51b63          	bne	a0,a5,80004e68 <sys_unlink+0x16c>
    if(de.inum != 0)
    80004e56:	f1845783          	lhu	a5,-232(s0)
    80004e5a:	e7a1                	bnez	a5,80004ea2 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004e5c:	29c1                	addiw	s3,s3,16
    80004e5e:	04c92783          	lw	a5,76(s2)
    80004e62:	fcf9ede3          	bltu	s3,a5,80004e3c <sys_unlink+0x140>
    80004e66:	b781                	j	80004da6 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004e68:	00004517          	auipc	a0,0x4
    80004e6c:	99850513          	addi	a0,a0,-1640 # 80008800 <syscalls+0x3e8>
    80004e70:	00001097          	auipc	ra,0x1
    80004e74:	2a8080e7          	jalr	680(ra) # 80006118 <panic>
    panic("unlink: writei");
    80004e78:	00004517          	auipc	a0,0x4
    80004e7c:	9a050513          	addi	a0,a0,-1632 # 80008818 <syscalls+0x400>
    80004e80:	00001097          	auipc	ra,0x1
    80004e84:	298080e7          	jalr	664(ra) # 80006118 <panic>
    dp->nlink--;
    80004e88:	04a4d783          	lhu	a5,74(s1)
    80004e8c:	37fd                	addiw	a5,a5,-1
    80004e8e:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004e92:	8526                	mv	a0,s1
    80004e94:	ffffe097          	auipc	ra,0xffffe
    80004e98:	e84080e7          	jalr	-380(ra) # 80002d18 <iupdate>
    80004e9c:	b781                	j	80004ddc <sys_unlink+0xe0>
    return -1;
    80004e9e:	557d                	li	a0,-1
    80004ea0:	a005                	j	80004ec0 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004ea2:	854a                	mv	a0,s2
    80004ea4:	ffffe097          	auipc	ra,0xffffe
    80004ea8:	198080e7          	jalr	408(ra) # 8000303c <iunlockput>
  iunlockput(dp);
    80004eac:	8526                	mv	a0,s1
    80004eae:	ffffe097          	auipc	ra,0xffffe
    80004eb2:	18e080e7          	jalr	398(ra) # 8000303c <iunlockput>
  end_op();
    80004eb6:	fffff097          	auipc	ra,0xfffff
    80004eba:	afe080e7          	jalr	-1282(ra) # 800039b4 <end_op>
  return -1;
    80004ebe:	557d                	li	a0,-1
}
    80004ec0:	70ae                	ld	ra,232(sp)
    80004ec2:	740e                	ld	s0,224(sp)
    80004ec4:	64ee                	ld	s1,216(sp)
    80004ec6:	694e                	ld	s2,208(sp)
    80004ec8:	69ae                	ld	s3,200(sp)
    80004eca:	616d                	addi	sp,sp,240
    80004ecc:	8082                	ret

0000000080004ece <sys_open>:

uint64
sys_open(void)
{
    80004ece:	7131                	addi	sp,sp,-192
    80004ed0:	fd06                	sd	ra,184(sp)
    80004ed2:	f922                	sd	s0,176(sp)
    80004ed4:	f526                	sd	s1,168(sp)
    80004ed6:	f14a                	sd	s2,160(sp)
    80004ed8:	ed4e                	sd	s3,152(sp)
    80004eda:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004edc:	08000613          	li	a2,128
    80004ee0:	f5040593          	addi	a1,s0,-176
    80004ee4:	4501                	li	a0,0
    80004ee6:	ffffd097          	auipc	ra,0xffffd
    80004eea:	2fe080e7          	jalr	766(ra) # 800021e4 <argstr>
    return -1;
    80004eee:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004ef0:	0c054163          	bltz	a0,80004fb2 <sys_open+0xe4>
    80004ef4:	f4c40593          	addi	a1,s0,-180
    80004ef8:	4505                	li	a0,1
    80004efa:	ffffd097          	auipc	ra,0xffffd
    80004efe:	2a6080e7          	jalr	678(ra) # 800021a0 <argint>
    80004f02:	0a054863          	bltz	a0,80004fb2 <sys_open+0xe4>

  begin_op();
    80004f06:	fffff097          	auipc	ra,0xfffff
    80004f0a:	a2e080e7          	jalr	-1490(ra) # 80003934 <begin_op>

  if(omode & O_CREATE){
    80004f0e:	f4c42783          	lw	a5,-180(s0)
    80004f12:	2007f793          	andi	a5,a5,512
    80004f16:	cbdd                	beqz	a5,80004fcc <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004f18:	4681                	li	a3,0
    80004f1a:	4601                	li	a2,0
    80004f1c:	4589                	li	a1,2
    80004f1e:	f5040513          	addi	a0,s0,-176
    80004f22:	00000097          	auipc	ra,0x0
    80004f26:	972080e7          	jalr	-1678(ra) # 80004894 <create>
    80004f2a:	892a                	mv	s2,a0
    if(ip == 0){
    80004f2c:	c959                	beqz	a0,80004fc2 <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004f2e:	04491703          	lh	a4,68(s2)
    80004f32:	478d                	li	a5,3
    80004f34:	00f71763          	bne	a4,a5,80004f42 <sys_open+0x74>
    80004f38:	04695703          	lhu	a4,70(s2)
    80004f3c:	47a5                	li	a5,9
    80004f3e:	0ce7ec63          	bltu	a5,a4,80005016 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004f42:	fffff097          	auipc	ra,0xfffff
    80004f46:	e02080e7          	jalr	-510(ra) # 80003d44 <filealloc>
    80004f4a:	89aa                	mv	s3,a0
    80004f4c:	10050263          	beqz	a0,80005050 <sys_open+0x182>
    80004f50:	00000097          	auipc	ra,0x0
    80004f54:	902080e7          	jalr	-1790(ra) # 80004852 <fdalloc>
    80004f58:	84aa                	mv	s1,a0
    80004f5a:	0e054663          	bltz	a0,80005046 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004f5e:	04491703          	lh	a4,68(s2)
    80004f62:	478d                	li	a5,3
    80004f64:	0cf70463          	beq	a4,a5,8000502c <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004f68:	4789                	li	a5,2
    80004f6a:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004f6e:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004f72:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004f76:	f4c42783          	lw	a5,-180(s0)
    80004f7a:	0017c713          	xori	a4,a5,1
    80004f7e:	8b05                	andi	a4,a4,1
    80004f80:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004f84:	0037f713          	andi	a4,a5,3
    80004f88:	00e03733          	snez	a4,a4
    80004f8c:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004f90:	4007f793          	andi	a5,a5,1024
    80004f94:	c791                	beqz	a5,80004fa0 <sys_open+0xd2>
    80004f96:	04491703          	lh	a4,68(s2)
    80004f9a:	4789                	li	a5,2
    80004f9c:	08f70f63          	beq	a4,a5,8000503a <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004fa0:	854a                	mv	a0,s2
    80004fa2:	ffffe097          	auipc	ra,0xffffe
    80004fa6:	efa080e7          	jalr	-262(ra) # 80002e9c <iunlock>
  end_op();
    80004faa:	fffff097          	auipc	ra,0xfffff
    80004fae:	a0a080e7          	jalr	-1526(ra) # 800039b4 <end_op>

  return fd;
}
    80004fb2:	8526                	mv	a0,s1
    80004fb4:	70ea                	ld	ra,184(sp)
    80004fb6:	744a                	ld	s0,176(sp)
    80004fb8:	74aa                	ld	s1,168(sp)
    80004fba:	790a                	ld	s2,160(sp)
    80004fbc:	69ea                	ld	s3,152(sp)
    80004fbe:	6129                	addi	sp,sp,192
    80004fc0:	8082                	ret
      end_op();
    80004fc2:	fffff097          	auipc	ra,0xfffff
    80004fc6:	9f2080e7          	jalr	-1550(ra) # 800039b4 <end_op>
      return -1;
    80004fca:	b7e5                	j	80004fb2 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004fcc:	f5040513          	addi	a0,s0,-176
    80004fd0:	ffffe097          	auipc	ra,0xffffe
    80004fd4:	5b6080e7          	jalr	1462(ra) # 80003586 <namei>
    80004fd8:	892a                	mv	s2,a0
    80004fda:	c905                	beqz	a0,8000500a <sys_open+0x13c>
    ilock(ip);
    80004fdc:	ffffe097          	auipc	ra,0xffffe
    80004fe0:	dfe080e7          	jalr	-514(ra) # 80002dda <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004fe4:	04491703          	lh	a4,68(s2)
    80004fe8:	4785                	li	a5,1
    80004fea:	f4f712e3          	bne	a4,a5,80004f2e <sys_open+0x60>
    80004fee:	f4c42783          	lw	a5,-180(s0)
    80004ff2:	dba1                	beqz	a5,80004f42 <sys_open+0x74>
      iunlockput(ip);
    80004ff4:	854a                	mv	a0,s2
    80004ff6:	ffffe097          	auipc	ra,0xffffe
    80004ffa:	046080e7          	jalr	70(ra) # 8000303c <iunlockput>
      end_op();
    80004ffe:	fffff097          	auipc	ra,0xfffff
    80005002:	9b6080e7          	jalr	-1610(ra) # 800039b4 <end_op>
      return -1;
    80005006:	54fd                	li	s1,-1
    80005008:	b76d                	j	80004fb2 <sys_open+0xe4>
      end_op();
    8000500a:	fffff097          	auipc	ra,0xfffff
    8000500e:	9aa080e7          	jalr	-1622(ra) # 800039b4 <end_op>
      return -1;
    80005012:	54fd                	li	s1,-1
    80005014:	bf79                	j	80004fb2 <sys_open+0xe4>
    iunlockput(ip);
    80005016:	854a                	mv	a0,s2
    80005018:	ffffe097          	auipc	ra,0xffffe
    8000501c:	024080e7          	jalr	36(ra) # 8000303c <iunlockput>
    end_op();
    80005020:	fffff097          	auipc	ra,0xfffff
    80005024:	994080e7          	jalr	-1644(ra) # 800039b4 <end_op>
    return -1;
    80005028:	54fd                	li	s1,-1
    8000502a:	b761                	j	80004fb2 <sys_open+0xe4>
    f->type = FD_DEVICE;
    8000502c:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80005030:	04691783          	lh	a5,70(s2)
    80005034:	02f99223          	sh	a5,36(s3)
    80005038:	bf2d                	j	80004f72 <sys_open+0xa4>
    itrunc(ip);
    8000503a:	854a                	mv	a0,s2
    8000503c:	ffffe097          	auipc	ra,0xffffe
    80005040:	eac080e7          	jalr	-340(ra) # 80002ee8 <itrunc>
    80005044:	bfb1                	j	80004fa0 <sys_open+0xd2>
      fileclose(f);
    80005046:	854e                	mv	a0,s3
    80005048:	fffff097          	auipc	ra,0xfffff
    8000504c:	db8080e7          	jalr	-584(ra) # 80003e00 <fileclose>
    iunlockput(ip);
    80005050:	854a                	mv	a0,s2
    80005052:	ffffe097          	auipc	ra,0xffffe
    80005056:	fea080e7          	jalr	-22(ra) # 8000303c <iunlockput>
    end_op();
    8000505a:	fffff097          	auipc	ra,0xfffff
    8000505e:	95a080e7          	jalr	-1702(ra) # 800039b4 <end_op>
    return -1;
    80005062:	54fd                	li	s1,-1
    80005064:	b7b9                	j	80004fb2 <sys_open+0xe4>

0000000080005066 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005066:	7175                	addi	sp,sp,-144
    80005068:	e506                	sd	ra,136(sp)
    8000506a:	e122                	sd	s0,128(sp)
    8000506c:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    8000506e:	fffff097          	auipc	ra,0xfffff
    80005072:	8c6080e7          	jalr	-1850(ra) # 80003934 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005076:	08000613          	li	a2,128
    8000507a:	f7040593          	addi	a1,s0,-144
    8000507e:	4501                	li	a0,0
    80005080:	ffffd097          	auipc	ra,0xffffd
    80005084:	164080e7          	jalr	356(ra) # 800021e4 <argstr>
    80005088:	02054963          	bltz	a0,800050ba <sys_mkdir+0x54>
    8000508c:	4681                	li	a3,0
    8000508e:	4601                	li	a2,0
    80005090:	4585                	li	a1,1
    80005092:	f7040513          	addi	a0,s0,-144
    80005096:	fffff097          	auipc	ra,0xfffff
    8000509a:	7fe080e7          	jalr	2046(ra) # 80004894 <create>
    8000509e:	cd11                	beqz	a0,800050ba <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800050a0:	ffffe097          	auipc	ra,0xffffe
    800050a4:	f9c080e7          	jalr	-100(ra) # 8000303c <iunlockput>
  end_op();
    800050a8:	fffff097          	auipc	ra,0xfffff
    800050ac:	90c080e7          	jalr	-1780(ra) # 800039b4 <end_op>
  return 0;
    800050b0:	4501                	li	a0,0
}
    800050b2:	60aa                	ld	ra,136(sp)
    800050b4:	640a                	ld	s0,128(sp)
    800050b6:	6149                	addi	sp,sp,144
    800050b8:	8082                	ret
    end_op();
    800050ba:	fffff097          	auipc	ra,0xfffff
    800050be:	8fa080e7          	jalr	-1798(ra) # 800039b4 <end_op>
    return -1;
    800050c2:	557d                	li	a0,-1
    800050c4:	b7fd                	j	800050b2 <sys_mkdir+0x4c>

00000000800050c6 <sys_mknod>:

uint64
sys_mknod(void)
{
    800050c6:	7135                	addi	sp,sp,-160
    800050c8:	ed06                	sd	ra,152(sp)
    800050ca:	e922                	sd	s0,144(sp)
    800050cc:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    800050ce:	fffff097          	auipc	ra,0xfffff
    800050d2:	866080e7          	jalr	-1946(ra) # 80003934 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800050d6:	08000613          	li	a2,128
    800050da:	f7040593          	addi	a1,s0,-144
    800050de:	4501                	li	a0,0
    800050e0:	ffffd097          	auipc	ra,0xffffd
    800050e4:	104080e7          	jalr	260(ra) # 800021e4 <argstr>
    800050e8:	04054a63          	bltz	a0,8000513c <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    800050ec:	f6c40593          	addi	a1,s0,-148
    800050f0:	4505                	li	a0,1
    800050f2:	ffffd097          	auipc	ra,0xffffd
    800050f6:	0ae080e7          	jalr	174(ra) # 800021a0 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800050fa:	04054163          	bltz	a0,8000513c <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    800050fe:	f6840593          	addi	a1,s0,-152
    80005102:	4509                	li	a0,2
    80005104:	ffffd097          	auipc	ra,0xffffd
    80005108:	09c080e7          	jalr	156(ra) # 800021a0 <argint>
     argint(1, &major) < 0 ||
    8000510c:	02054863          	bltz	a0,8000513c <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80005110:	f6841683          	lh	a3,-152(s0)
    80005114:	f6c41603          	lh	a2,-148(s0)
    80005118:	458d                	li	a1,3
    8000511a:	f7040513          	addi	a0,s0,-144
    8000511e:	fffff097          	auipc	ra,0xfffff
    80005122:	776080e7          	jalr	1910(ra) # 80004894 <create>
     argint(2, &minor) < 0 ||
    80005126:	c919                	beqz	a0,8000513c <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005128:	ffffe097          	auipc	ra,0xffffe
    8000512c:	f14080e7          	jalr	-236(ra) # 8000303c <iunlockput>
  end_op();
    80005130:	fffff097          	auipc	ra,0xfffff
    80005134:	884080e7          	jalr	-1916(ra) # 800039b4 <end_op>
  return 0;
    80005138:	4501                	li	a0,0
    8000513a:	a031                	j	80005146 <sys_mknod+0x80>
    end_op();
    8000513c:	fffff097          	auipc	ra,0xfffff
    80005140:	878080e7          	jalr	-1928(ra) # 800039b4 <end_op>
    return -1;
    80005144:	557d                	li	a0,-1
}
    80005146:	60ea                	ld	ra,152(sp)
    80005148:	644a                	ld	s0,144(sp)
    8000514a:	610d                	addi	sp,sp,160
    8000514c:	8082                	ret

000000008000514e <sys_chdir>:

uint64
sys_chdir(void)
{
    8000514e:	7135                	addi	sp,sp,-160
    80005150:	ed06                	sd	ra,152(sp)
    80005152:	e922                	sd	s0,144(sp)
    80005154:	e526                	sd	s1,136(sp)
    80005156:	e14a                	sd	s2,128(sp)
    80005158:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    8000515a:	ffffc097          	auipc	ra,0xffffc
    8000515e:	f9a080e7          	jalr	-102(ra) # 800010f4 <myproc>
    80005162:	892a                	mv	s2,a0
  
  begin_op();
    80005164:	ffffe097          	auipc	ra,0xffffe
    80005168:	7d0080e7          	jalr	2000(ra) # 80003934 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    8000516c:	08000613          	li	a2,128
    80005170:	f6040593          	addi	a1,s0,-160
    80005174:	4501                	li	a0,0
    80005176:	ffffd097          	auipc	ra,0xffffd
    8000517a:	06e080e7          	jalr	110(ra) # 800021e4 <argstr>
    8000517e:	04054b63          	bltz	a0,800051d4 <sys_chdir+0x86>
    80005182:	f6040513          	addi	a0,s0,-160
    80005186:	ffffe097          	auipc	ra,0xffffe
    8000518a:	400080e7          	jalr	1024(ra) # 80003586 <namei>
    8000518e:	84aa                	mv	s1,a0
    80005190:	c131                	beqz	a0,800051d4 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80005192:	ffffe097          	auipc	ra,0xffffe
    80005196:	c48080e7          	jalr	-952(ra) # 80002dda <ilock>
  if(ip->type != T_DIR){
    8000519a:	04449703          	lh	a4,68(s1)
    8000519e:	4785                	li	a5,1
    800051a0:	04f71063          	bne	a4,a5,800051e0 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    800051a4:	8526                	mv	a0,s1
    800051a6:	ffffe097          	auipc	ra,0xffffe
    800051aa:	cf6080e7          	jalr	-778(ra) # 80002e9c <iunlock>
  iput(p->cwd);
    800051ae:	15093503          	ld	a0,336(s2)
    800051b2:	ffffe097          	auipc	ra,0xffffe
    800051b6:	de2080e7          	jalr	-542(ra) # 80002f94 <iput>
  end_op();
    800051ba:	ffffe097          	auipc	ra,0xffffe
    800051be:	7fa080e7          	jalr	2042(ra) # 800039b4 <end_op>
  p->cwd = ip;
    800051c2:	14993823          	sd	s1,336(s2)
  return 0;
    800051c6:	4501                	li	a0,0
}
    800051c8:	60ea                	ld	ra,152(sp)
    800051ca:	644a                	ld	s0,144(sp)
    800051cc:	64aa                	ld	s1,136(sp)
    800051ce:	690a                	ld	s2,128(sp)
    800051d0:	610d                	addi	sp,sp,160
    800051d2:	8082                	ret
    end_op();
    800051d4:	ffffe097          	auipc	ra,0xffffe
    800051d8:	7e0080e7          	jalr	2016(ra) # 800039b4 <end_op>
    return -1;
    800051dc:	557d                	li	a0,-1
    800051de:	b7ed                	j	800051c8 <sys_chdir+0x7a>
    iunlockput(ip);
    800051e0:	8526                	mv	a0,s1
    800051e2:	ffffe097          	auipc	ra,0xffffe
    800051e6:	e5a080e7          	jalr	-422(ra) # 8000303c <iunlockput>
    end_op();
    800051ea:	ffffe097          	auipc	ra,0xffffe
    800051ee:	7ca080e7          	jalr	1994(ra) # 800039b4 <end_op>
    return -1;
    800051f2:	557d                	li	a0,-1
    800051f4:	bfd1                	j	800051c8 <sys_chdir+0x7a>

00000000800051f6 <sys_exec>:

uint64
sys_exec(void)
{
    800051f6:	7145                	addi	sp,sp,-464
    800051f8:	e786                	sd	ra,456(sp)
    800051fa:	e3a2                	sd	s0,448(sp)
    800051fc:	ff26                	sd	s1,440(sp)
    800051fe:	fb4a                	sd	s2,432(sp)
    80005200:	f74e                	sd	s3,424(sp)
    80005202:	f352                	sd	s4,416(sp)
    80005204:	ef56                	sd	s5,408(sp)
    80005206:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005208:	08000613          	li	a2,128
    8000520c:	f4040593          	addi	a1,s0,-192
    80005210:	4501                	li	a0,0
    80005212:	ffffd097          	auipc	ra,0xffffd
    80005216:	fd2080e7          	jalr	-46(ra) # 800021e4 <argstr>
    return -1;
    8000521a:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    8000521c:	0c054a63          	bltz	a0,800052f0 <sys_exec+0xfa>
    80005220:	e3840593          	addi	a1,s0,-456
    80005224:	4505                	li	a0,1
    80005226:	ffffd097          	auipc	ra,0xffffd
    8000522a:	f9c080e7          	jalr	-100(ra) # 800021c2 <argaddr>
    8000522e:	0c054163          	bltz	a0,800052f0 <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80005232:	10000613          	li	a2,256
    80005236:	4581                	li	a1,0
    80005238:	e4040513          	addi	a0,s0,-448
    8000523c:	ffffb097          	auipc	ra,0xffffb
    80005240:	f3c080e7          	jalr	-196(ra) # 80000178 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005244:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80005248:	89a6                	mv	s3,s1
    8000524a:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    8000524c:	02000a13          	li	s4,32
    80005250:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005254:	00391513          	slli	a0,s2,0x3
    80005258:	e3040593          	addi	a1,s0,-464
    8000525c:	e3843783          	ld	a5,-456(s0)
    80005260:	953e                	add	a0,a0,a5
    80005262:	ffffd097          	auipc	ra,0xffffd
    80005266:	ea4080e7          	jalr	-348(ra) # 80002106 <fetchaddr>
    8000526a:	02054a63          	bltz	a0,8000529e <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    8000526e:	e3043783          	ld	a5,-464(s0)
    80005272:	c3b9                	beqz	a5,800052b8 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005274:	ffffb097          	auipc	ra,0xffffb
    80005278:	ea4080e7          	jalr	-348(ra) # 80000118 <kalloc>
    8000527c:	85aa                	mv	a1,a0
    8000527e:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005282:	cd11                	beqz	a0,8000529e <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005284:	6605                	lui	a2,0x1
    80005286:	e3043503          	ld	a0,-464(s0)
    8000528a:	ffffd097          	auipc	ra,0xffffd
    8000528e:	ece080e7          	jalr	-306(ra) # 80002158 <fetchstr>
    80005292:	00054663          	bltz	a0,8000529e <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    80005296:	0905                	addi	s2,s2,1
    80005298:	09a1                	addi	s3,s3,8
    8000529a:	fb491be3          	bne	s2,s4,80005250 <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000529e:	10048913          	addi	s2,s1,256
    800052a2:	6088                	ld	a0,0(s1)
    800052a4:	c529                	beqz	a0,800052ee <sys_exec+0xf8>
    kfree(argv[i]);
    800052a6:	ffffb097          	auipc	ra,0xffffb
    800052aa:	d76080e7          	jalr	-650(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800052ae:	04a1                	addi	s1,s1,8
    800052b0:	ff2499e3          	bne	s1,s2,800052a2 <sys_exec+0xac>
  return -1;
    800052b4:	597d                	li	s2,-1
    800052b6:	a82d                	j	800052f0 <sys_exec+0xfa>
      argv[i] = 0;
    800052b8:	0a8e                	slli	s5,s5,0x3
    800052ba:	fc040793          	addi	a5,s0,-64
    800052be:	9abe                	add	s5,s5,a5
    800052c0:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    800052c4:	e4040593          	addi	a1,s0,-448
    800052c8:	f4040513          	addi	a0,s0,-192
    800052cc:	fffff097          	auipc	ra,0xfffff
    800052d0:	194080e7          	jalr	404(ra) # 80004460 <exec>
    800052d4:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800052d6:	10048993          	addi	s3,s1,256
    800052da:	6088                	ld	a0,0(s1)
    800052dc:	c911                	beqz	a0,800052f0 <sys_exec+0xfa>
    kfree(argv[i]);
    800052de:	ffffb097          	auipc	ra,0xffffb
    800052e2:	d3e080e7          	jalr	-706(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800052e6:	04a1                	addi	s1,s1,8
    800052e8:	ff3499e3          	bne	s1,s3,800052da <sys_exec+0xe4>
    800052ec:	a011                	j	800052f0 <sys_exec+0xfa>
  return -1;
    800052ee:	597d                	li	s2,-1
}
    800052f0:	854a                	mv	a0,s2
    800052f2:	60be                	ld	ra,456(sp)
    800052f4:	641e                	ld	s0,448(sp)
    800052f6:	74fa                	ld	s1,440(sp)
    800052f8:	795a                	ld	s2,432(sp)
    800052fa:	79ba                	ld	s3,424(sp)
    800052fc:	7a1a                	ld	s4,416(sp)
    800052fe:	6afa                	ld	s5,408(sp)
    80005300:	6179                	addi	sp,sp,464
    80005302:	8082                	ret

0000000080005304 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005304:	7139                	addi	sp,sp,-64
    80005306:	fc06                	sd	ra,56(sp)
    80005308:	f822                	sd	s0,48(sp)
    8000530a:	f426                	sd	s1,40(sp)
    8000530c:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    8000530e:	ffffc097          	auipc	ra,0xffffc
    80005312:	de6080e7          	jalr	-538(ra) # 800010f4 <myproc>
    80005316:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80005318:	fd840593          	addi	a1,s0,-40
    8000531c:	4501                	li	a0,0
    8000531e:	ffffd097          	auipc	ra,0xffffd
    80005322:	ea4080e7          	jalr	-348(ra) # 800021c2 <argaddr>
    return -1;
    80005326:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80005328:	0e054063          	bltz	a0,80005408 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    8000532c:	fc840593          	addi	a1,s0,-56
    80005330:	fd040513          	addi	a0,s0,-48
    80005334:	fffff097          	auipc	ra,0xfffff
    80005338:	dfc080e7          	jalr	-516(ra) # 80004130 <pipealloc>
    return -1;
    8000533c:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    8000533e:	0c054563          	bltz	a0,80005408 <sys_pipe+0x104>
  fd0 = -1;
    80005342:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005346:	fd043503          	ld	a0,-48(s0)
    8000534a:	fffff097          	auipc	ra,0xfffff
    8000534e:	508080e7          	jalr	1288(ra) # 80004852 <fdalloc>
    80005352:	fca42223          	sw	a0,-60(s0)
    80005356:	08054c63          	bltz	a0,800053ee <sys_pipe+0xea>
    8000535a:	fc843503          	ld	a0,-56(s0)
    8000535e:	fffff097          	auipc	ra,0xfffff
    80005362:	4f4080e7          	jalr	1268(ra) # 80004852 <fdalloc>
    80005366:	fca42023          	sw	a0,-64(s0)
    8000536a:	06054863          	bltz	a0,800053da <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000536e:	4691                	li	a3,4
    80005370:	fc440613          	addi	a2,s0,-60
    80005374:	fd843583          	ld	a1,-40(s0)
    80005378:	68a8                	ld	a0,80(s1)
    8000537a:	ffffb097          	auipc	ra,0xffffb
    8000537e:	788080e7          	jalr	1928(ra) # 80000b02 <copyout>
    80005382:	02054063          	bltz	a0,800053a2 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005386:	4691                	li	a3,4
    80005388:	fc040613          	addi	a2,s0,-64
    8000538c:	fd843583          	ld	a1,-40(s0)
    80005390:	0591                	addi	a1,a1,4
    80005392:	68a8                	ld	a0,80(s1)
    80005394:	ffffb097          	auipc	ra,0xffffb
    80005398:	76e080e7          	jalr	1902(ra) # 80000b02 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    8000539c:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000539e:	06055563          	bgez	a0,80005408 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    800053a2:	fc442783          	lw	a5,-60(s0)
    800053a6:	07e9                	addi	a5,a5,26
    800053a8:	078e                	slli	a5,a5,0x3
    800053aa:	97a6                	add	a5,a5,s1
    800053ac:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800053b0:	fc042503          	lw	a0,-64(s0)
    800053b4:	0569                	addi	a0,a0,26
    800053b6:	050e                	slli	a0,a0,0x3
    800053b8:	9526                	add	a0,a0,s1
    800053ba:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    800053be:	fd043503          	ld	a0,-48(s0)
    800053c2:	fffff097          	auipc	ra,0xfffff
    800053c6:	a3e080e7          	jalr	-1474(ra) # 80003e00 <fileclose>
    fileclose(wf);
    800053ca:	fc843503          	ld	a0,-56(s0)
    800053ce:	fffff097          	auipc	ra,0xfffff
    800053d2:	a32080e7          	jalr	-1486(ra) # 80003e00 <fileclose>
    return -1;
    800053d6:	57fd                	li	a5,-1
    800053d8:	a805                	j	80005408 <sys_pipe+0x104>
    if(fd0 >= 0)
    800053da:	fc442783          	lw	a5,-60(s0)
    800053de:	0007c863          	bltz	a5,800053ee <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    800053e2:	01a78513          	addi	a0,a5,26
    800053e6:	050e                	slli	a0,a0,0x3
    800053e8:	9526                	add	a0,a0,s1
    800053ea:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    800053ee:	fd043503          	ld	a0,-48(s0)
    800053f2:	fffff097          	auipc	ra,0xfffff
    800053f6:	a0e080e7          	jalr	-1522(ra) # 80003e00 <fileclose>
    fileclose(wf);
    800053fa:	fc843503          	ld	a0,-56(s0)
    800053fe:	fffff097          	auipc	ra,0xfffff
    80005402:	a02080e7          	jalr	-1534(ra) # 80003e00 <fileclose>
    return -1;
    80005406:	57fd                	li	a5,-1
}
    80005408:	853e                	mv	a0,a5
    8000540a:	70e2                	ld	ra,56(sp)
    8000540c:	7442                	ld	s0,48(sp)
    8000540e:	74a2                	ld	s1,40(sp)
    80005410:	6121                	addi	sp,sp,64
    80005412:	8082                	ret
	...

0000000080005420 <kernelvec>:
    80005420:	7111                	addi	sp,sp,-256
    80005422:	e006                	sd	ra,0(sp)
    80005424:	e40a                	sd	sp,8(sp)
    80005426:	e80e                	sd	gp,16(sp)
    80005428:	ec12                	sd	tp,24(sp)
    8000542a:	f016                	sd	t0,32(sp)
    8000542c:	f41a                	sd	t1,40(sp)
    8000542e:	f81e                	sd	t2,48(sp)
    80005430:	fc22                	sd	s0,56(sp)
    80005432:	e0a6                	sd	s1,64(sp)
    80005434:	e4aa                	sd	a0,72(sp)
    80005436:	e8ae                	sd	a1,80(sp)
    80005438:	ecb2                	sd	a2,88(sp)
    8000543a:	f0b6                	sd	a3,96(sp)
    8000543c:	f4ba                	sd	a4,104(sp)
    8000543e:	f8be                	sd	a5,112(sp)
    80005440:	fcc2                	sd	a6,120(sp)
    80005442:	e146                	sd	a7,128(sp)
    80005444:	e54a                	sd	s2,136(sp)
    80005446:	e94e                	sd	s3,144(sp)
    80005448:	ed52                	sd	s4,152(sp)
    8000544a:	f156                	sd	s5,160(sp)
    8000544c:	f55a                	sd	s6,168(sp)
    8000544e:	f95e                	sd	s7,176(sp)
    80005450:	fd62                	sd	s8,184(sp)
    80005452:	e1e6                	sd	s9,192(sp)
    80005454:	e5ea                	sd	s10,200(sp)
    80005456:	e9ee                	sd	s11,208(sp)
    80005458:	edf2                	sd	t3,216(sp)
    8000545a:	f1f6                	sd	t4,224(sp)
    8000545c:	f5fa                	sd	t5,232(sp)
    8000545e:	f9fe                	sd	t6,240(sp)
    80005460:	b73fc0ef          	jal	ra,80001fd2 <kerneltrap>
    80005464:	6082                	ld	ra,0(sp)
    80005466:	6122                	ld	sp,8(sp)
    80005468:	61c2                	ld	gp,16(sp)
    8000546a:	7282                	ld	t0,32(sp)
    8000546c:	7322                	ld	t1,40(sp)
    8000546e:	73c2                	ld	t2,48(sp)
    80005470:	7462                	ld	s0,56(sp)
    80005472:	6486                	ld	s1,64(sp)
    80005474:	6526                	ld	a0,72(sp)
    80005476:	65c6                	ld	a1,80(sp)
    80005478:	6666                	ld	a2,88(sp)
    8000547a:	7686                	ld	a3,96(sp)
    8000547c:	7726                	ld	a4,104(sp)
    8000547e:	77c6                	ld	a5,112(sp)
    80005480:	7866                	ld	a6,120(sp)
    80005482:	688a                	ld	a7,128(sp)
    80005484:	692a                	ld	s2,136(sp)
    80005486:	69ca                	ld	s3,144(sp)
    80005488:	6a6a                	ld	s4,152(sp)
    8000548a:	7a8a                	ld	s5,160(sp)
    8000548c:	7b2a                	ld	s6,168(sp)
    8000548e:	7bca                	ld	s7,176(sp)
    80005490:	7c6a                	ld	s8,184(sp)
    80005492:	6c8e                	ld	s9,192(sp)
    80005494:	6d2e                	ld	s10,200(sp)
    80005496:	6dce                	ld	s11,208(sp)
    80005498:	6e6e                	ld	t3,216(sp)
    8000549a:	7e8e                	ld	t4,224(sp)
    8000549c:	7f2e                	ld	t5,232(sp)
    8000549e:	7fce                	ld	t6,240(sp)
    800054a0:	6111                	addi	sp,sp,256
    800054a2:	10200073          	sret
    800054a6:	00000013          	nop
    800054aa:	00000013          	nop
    800054ae:	0001                	nop

00000000800054b0 <timervec>:
    800054b0:	34051573          	csrrw	a0,mscratch,a0
    800054b4:	e10c                	sd	a1,0(a0)
    800054b6:	e510                	sd	a2,8(a0)
    800054b8:	e914                	sd	a3,16(a0)
    800054ba:	6d0c                	ld	a1,24(a0)
    800054bc:	7110                	ld	a2,32(a0)
    800054be:	6194                	ld	a3,0(a1)
    800054c0:	96b2                	add	a3,a3,a2
    800054c2:	e194                	sd	a3,0(a1)
    800054c4:	4589                	li	a1,2
    800054c6:	14459073          	csrw	sip,a1
    800054ca:	6914                	ld	a3,16(a0)
    800054cc:	6510                	ld	a2,8(a0)
    800054ce:	610c                	ld	a1,0(a0)
    800054d0:	34051573          	csrrw	a0,mscratch,a0
    800054d4:	30200073          	mret
	...

00000000800054da <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800054da:	1141                	addi	sp,sp,-16
    800054dc:	e422                	sd	s0,8(sp)
    800054de:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800054e0:	0c0007b7          	lui	a5,0xc000
    800054e4:	4705                	li	a4,1
    800054e6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800054e8:	c3d8                	sw	a4,4(a5)
}
    800054ea:	6422                	ld	s0,8(sp)
    800054ec:	0141                	addi	sp,sp,16
    800054ee:	8082                	ret

00000000800054f0 <plicinithart>:

void
plicinithart(void)
{
    800054f0:	1141                	addi	sp,sp,-16
    800054f2:	e406                	sd	ra,8(sp)
    800054f4:	e022                	sd	s0,0(sp)
    800054f6:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800054f8:	ffffc097          	auipc	ra,0xffffc
    800054fc:	bd0080e7          	jalr	-1072(ra) # 800010c8 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005500:	0085171b          	slliw	a4,a0,0x8
    80005504:	0c0027b7          	lui	a5,0xc002
    80005508:	97ba                	add	a5,a5,a4
    8000550a:	40200713          	li	a4,1026
    8000550e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005512:	00d5151b          	slliw	a0,a0,0xd
    80005516:	0c2017b7          	lui	a5,0xc201
    8000551a:	953e                	add	a0,a0,a5
    8000551c:	00052023          	sw	zero,0(a0)
}
    80005520:	60a2                	ld	ra,8(sp)
    80005522:	6402                	ld	s0,0(sp)
    80005524:	0141                	addi	sp,sp,16
    80005526:	8082                	ret

0000000080005528 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005528:	1141                	addi	sp,sp,-16
    8000552a:	e406                	sd	ra,8(sp)
    8000552c:	e022                	sd	s0,0(sp)
    8000552e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005530:	ffffc097          	auipc	ra,0xffffc
    80005534:	b98080e7          	jalr	-1128(ra) # 800010c8 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005538:	00d5179b          	slliw	a5,a0,0xd
    8000553c:	0c201537          	lui	a0,0xc201
    80005540:	953e                	add	a0,a0,a5
  return irq;
}
    80005542:	4148                	lw	a0,4(a0)
    80005544:	60a2                	ld	ra,8(sp)
    80005546:	6402                	ld	s0,0(sp)
    80005548:	0141                	addi	sp,sp,16
    8000554a:	8082                	ret

000000008000554c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000554c:	1101                	addi	sp,sp,-32
    8000554e:	ec06                	sd	ra,24(sp)
    80005550:	e822                	sd	s0,16(sp)
    80005552:	e426                	sd	s1,8(sp)
    80005554:	1000                	addi	s0,sp,32
    80005556:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005558:	ffffc097          	auipc	ra,0xffffc
    8000555c:	b70080e7          	jalr	-1168(ra) # 800010c8 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005560:	00d5151b          	slliw	a0,a0,0xd
    80005564:	0c2017b7          	lui	a5,0xc201
    80005568:	97aa                	add	a5,a5,a0
    8000556a:	c3c4                	sw	s1,4(a5)
}
    8000556c:	60e2                	ld	ra,24(sp)
    8000556e:	6442                	ld	s0,16(sp)
    80005570:	64a2                	ld	s1,8(sp)
    80005572:	6105                	addi	sp,sp,32
    80005574:	8082                	ret

0000000080005576 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005576:	1141                	addi	sp,sp,-16
    80005578:	e406                	sd	ra,8(sp)
    8000557a:	e022                	sd	s0,0(sp)
    8000557c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000557e:	479d                	li	a5,7
    80005580:	06a7c963          	blt	a5,a0,800055f2 <free_desc+0x7c>
    panic("free_desc 1");
  if(disk.free[i])
    80005584:	00016797          	auipc	a5,0x16
    80005588:	a7c78793          	addi	a5,a5,-1412 # 8001b000 <disk>
    8000558c:	00a78733          	add	a4,a5,a0
    80005590:	6789                	lui	a5,0x2
    80005592:	97ba                	add	a5,a5,a4
    80005594:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80005598:	e7ad                	bnez	a5,80005602 <free_desc+0x8c>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    8000559a:	00451793          	slli	a5,a0,0x4
    8000559e:	00018717          	auipc	a4,0x18
    800055a2:	a6270713          	addi	a4,a4,-1438 # 8001d000 <disk+0x2000>
    800055a6:	6314                	ld	a3,0(a4)
    800055a8:	96be                	add	a3,a3,a5
    800055aa:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    800055ae:	6314                	ld	a3,0(a4)
    800055b0:	96be                	add	a3,a3,a5
    800055b2:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    800055b6:	6314                	ld	a3,0(a4)
    800055b8:	96be                	add	a3,a3,a5
    800055ba:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    800055be:	6318                	ld	a4,0(a4)
    800055c0:	97ba                	add	a5,a5,a4
    800055c2:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    800055c6:	00016797          	auipc	a5,0x16
    800055ca:	a3a78793          	addi	a5,a5,-1478 # 8001b000 <disk>
    800055ce:	97aa                	add	a5,a5,a0
    800055d0:	6509                	lui	a0,0x2
    800055d2:	953e                	add	a0,a0,a5
    800055d4:	4785                	li	a5,1
    800055d6:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    800055da:	00018517          	auipc	a0,0x18
    800055de:	a3e50513          	addi	a0,a0,-1474 # 8001d018 <disk+0x2018>
    800055e2:	ffffc097          	auipc	ra,0xffffc
    800055e6:	35a080e7          	jalr	858(ra) # 8000193c <wakeup>
}
    800055ea:	60a2                	ld	ra,8(sp)
    800055ec:	6402                	ld	s0,0(sp)
    800055ee:	0141                	addi	sp,sp,16
    800055f0:	8082                	ret
    panic("free_desc 1");
    800055f2:	00003517          	auipc	a0,0x3
    800055f6:	23650513          	addi	a0,a0,566 # 80008828 <syscalls+0x410>
    800055fa:	00001097          	auipc	ra,0x1
    800055fe:	b1e080e7          	jalr	-1250(ra) # 80006118 <panic>
    panic("free_desc 2");
    80005602:	00003517          	auipc	a0,0x3
    80005606:	23650513          	addi	a0,a0,566 # 80008838 <syscalls+0x420>
    8000560a:	00001097          	auipc	ra,0x1
    8000560e:	b0e080e7          	jalr	-1266(ra) # 80006118 <panic>

0000000080005612 <virtio_disk_init>:
{
    80005612:	1101                	addi	sp,sp,-32
    80005614:	ec06                	sd	ra,24(sp)
    80005616:	e822                	sd	s0,16(sp)
    80005618:	e426                	sd	s1,8(sp)
    8000561a:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    8000561c:	00003597          	auipc	a1,0x3
    80005620:	22c58593          	addi	a1,a1,556 # 80008848 <syscalls+0x430>
    80005624:	00018517          	auipc	a0,0x18
    80005628:	b0450513          	addi	a0,a0,-1276 # 8001d128 <disk+0x2128>
    8000562c:	00001097          	auipc	ra,0x1
    80005630:	fa6080e7          	jalr	-90(ra) # 800065d2 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005634:	100017b7          	lui	a5,0x10001
    80005638:	4398                	lw	a4,0(a5)
    8000563a:	2701                	sext.w	a4,a4
    8000563c:	747277b7          	lui	a5,0x74727
    80005640:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005644:	0ef71163          	bne	a4,a5,80005726 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005648:	100017b7          	lui	a5,0x10001
    8000564c:	43dc                	lw	a5,4(a5)
    8000564e:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005650:	4705                	li	a4,1
    80005652:	0ce79a63          	bne	a5,a4,80005726 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005656:	100017b7          	lui	a5,0x10001
    8000565a:	479c                	lw	a5,8(a5)
    8000565c:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    8000565e:	4709                	li	a4,2
    80005660:	0ce79363          	bne	a5,a4,80005726 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005664:	100017b7          	lui	a5,0x10001
    80005668:	47d8                	lw	a4,12(a5)
    8000566a:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000566c:	554d47b7          	lui	a5,0x554d4
    80005670:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005674:	0af71963          	bne	a4,a5,80005726 <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005678:	100017b7          	lui	a5,0x10001
    8000567c:	4705                	li	a4,1
    8000567e:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005680:	470d                	li	a4,3
    80005682:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005684:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005686:	c7ffe737          	lui	a4,0xc7ffe
    8000568a:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd851f>
    8000568e:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005690:	2701                	sext.w	a4,a4
    80005692:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005694:	472d                	li	a4,11
    80005696:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005698:	473d                	li	a4,15
    8000569a:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    8000569c:	6705                	lui	a4,0x1
    8000569e:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800056a0:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800056a4:	5bdc                	lw	a5,52(a5)
    800056a6:	2781                	sext.w	a5,a5
  if(max == 0)
    800056a8:	c7d9                	beqz	a5,80005736 <virtio_disk_init+0x124>
  if(max < NUM)
    800056aa:	471d                	li	a4,7
    800056ac:	08f77d63          	bgeu	a4,a5,80005746 <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800056b0:	100014b7          	lui	s1,0x10001
    800056b4:	47a1                	li	a5,8
    800056b6:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    800056b8:	6609                	lui	a2,0x2
    800056ba:	4581                	li	a1,0
    800056bc:	00016517          	auipc	a0,0x16
    800056c0:	94450513          	addi	a0,a0,-1724 # 8001b000 <disk>
    800056c4:	ffffb097          	auipc	ra,0xffffb
    800056c8:	ab4080e7          	jalr	-1356(ra) # 80000178 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    800056cc:	00016717          	auipc	a4,0x16
    800056d0:	93470713          	addi	a4,a4,-1740 # 8001b000 <disk>
    800056d4:	00c75793          	srli	a5,a4,0xc
    800056d8:	2781                	sext.w	a5,a5
    800056da:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    800056dc:	00018797          	auipc	a5,0x18
    800056e0:	92478793          	addi	a5,a5,-1756 # 8001d000 <disk+0x2000>
    800056e4:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    800056e6:	00016717          	auipc	a4,0x16
    800056ea:	99a70713          	addi	a4,a4,-1638 # 8001b080 <disk+0x80>
    800056ee:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    800056f0:	00017717          	auipc	a4,0x17
    800056f4:	91070713          	addi	a4,a4,-1776 # 8001c000 <disk+0x1000>
    800056f8:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    800056fa:	4705                	li	a4,1
    800056fc:	00e78c23          	sb	a4,24(a5)
    80005700:	00e78ca3          	sb	a4,25(a5)
    80005704:	00e78d23          	sb	a4,26(a5)
    80005708:	00e78da3          	sb	a4,27(a5)
    8000570c:	00e78e23          	sb	a4,28(a5)
    80005710:	00e78ea3          	sb	a4,29(a5)
    80005714:	00e78f23          	sb	a4,30(a5)
    80005718:	00e78fa3          	sb	a4,31(a5)
}
    8000571c:	60e2                	ld	ra,24(sp)
    8000571e:	6442                	ld	s0,16(sp)
    80005720:	64a2                	ld	s1,8(sp)
    80005722:	6105                	addi	sp,sp,32
    80005724:	8082                	ret
    panic("could not find virtio disk");
    80005726:	00003517          	auipc	a0,0x3
    8000572a:	13250513          	addi	a0,a0,306 # 80008858 <syscalls+0x440>
    8000572e:	00001097          	auipc	ra,0x1
    80005732:	9ea080e7          	jalr	-1558(ra) # 80006118 <panic>
    panic("virtio disk has no queue 0");
    80005736:	00003517          	auipc	a0,0x3
    8000573a:	14250513          	addi	a0,a0,322 # 80008878 <syscalls+0x460>
    8000573e:	00001097          	auipc	ra,0x1
    80005742:	9da080e7          	jalr	-1574(ra) # 80006118 <panic>
    panic("virtio disk max queue too short");
    80005746:	00003517          	auipc	a0,0x3
    8000574a:	15250513          	addi	a0,a0,338 # 80008898 <syscalls+0x480>
    8000574e:	00001097          	auipc	ra,0x1
    80005752:	9ca080e7          	jalr	-1590(ra) # 80006118 <panic>

0000000080005756 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005756:	7159                	addi	sp,sp,-112
    80005758:	f486                	sd	ra,104(sp)
    8000575a:	f0a2                	sd	s0,96(sp)
    8000575c:	eca6                	sd	s1,88(sp)
    8000575e:	e8ca                	sd	s2,80(sp)
    80005760:	e4ce                	sd	s3,72(sp)
    80005762:	e0d2                	sd	s4,64(sp)
    80005764:	fc56                	sd	s5,56(sp)
    80005766:	f85a                	sd	s6,48(sp)
    80005768:	f45e                	sd	s7,40(sp)
    8000576a:	f062                	sd	s8,32(sp)
    8000576c:	ec66                	sd	s9,24(sp)
    8000576e:	e86a                	sd	s10,16(sp)
    80005770:	1880                	addi	s0,sp,112
    80005772:	892a                	mv	s2,a0
    80005774:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005776:	00c52c83          	lw	s9,12(a0)
    8000577a:	001c9c9b          	slliw	s9,s9,0x1
    8000577e:	1c82                	slli	s9,s9,0x20
    80005780:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005784:	00018517          	auipc	a0,0x18
    80005788:	9a450513          	addi	a0,a0,-1628 # 8001d128 <disk+0x2128>
    8000578c:	00001097          	auipc	ra,0x1
    80005790:	ed6080e7          	jalr	-298(ra) # 80006662 <acquire>
  for(int i = 0; i < 3; i++){
    80005794:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005796:	4c21                	li	s8,8
      disk.free[i] = 0;
    80005798:	00016b97          	auipc	s7,0x16
    8000579c:	868b8b93          	addi	s7,s7,-1944 # 8001b000 <disk>
    800057a0:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    800057a2:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    800057a4:	8a4e                	mv	s4,s3
    800057a6:	a051                	j	8000582a <virtio_disk_rw+0xd4>
      disk.free[i] = 0;
    800057a8:	00fb86b3          	add	a3,s7,a5
    800057ac:	96da                	add	a3,a3,s6
    800057ae:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    800057b2:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    800057b4:	0207c563          	bltz	a5,800057de <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    800057b8:	2485                	addiw	s1,s1,1
    800057ba:	0711                	addi	a4,a4,4
    800057bc:	25548063          	beq	s1,s5,800059fc <virtio_disk_rw+0x2a6>
    idx[i] = alloc_desc();
    800057c0:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    800057c2:	00018697          	auipc	a3,0x18
    800057c6:	85668693          	addi	a3,a3,-1962 # 8001d018 <disk+0x2018>
    800057ca:	87d2                	mv	a5,s4
    if(disk.free[i]){
    800057cc:	0006c583          	lbu	a1,0(a3)
    800057d0:	fde1                	bnez	a1,800057a8 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    800057d2:	2785                	addiw	a5,a5,1
    800057d4:	0685                	addi	a3,a3,1
    800057d6:	ff879be3          	bne	a5,s8,800057cc <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    800057da:	57fd                	li	a5,-1
    800057dc:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    800057de:	02905a63          	blez	s1,80005812 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    800057e2:	f9042503          	lw	a0,-112(s0)
    800057e6:	00000097          	auipc	ra,0x0
    800057ea:	d90080e7          	jalr	-624(ra) # 80005576 <free_desc>
      for(int j = 0; j < i; j++)
    800057ee:	4785                	li	a5,1
    800057f0:	0297d163          	bge	a5,s1,80005812 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    800057f4:	f9442503          	lw	a0,-108(s0)
    800057f8:	00000097          	auipc	ra,0x0
    800057fc:	d7e080e7          	jalr	-642(ra) # 80005576 <free_desc>
      for(int j = 0; j < i; j++)
    80005800:	4789                	li	a5,2
    80005802:	0097d863          	bge	a5,s1,80005812 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005806:	f9842503          	lw	a0,-104(s0)
    8000580a:	00000097          	auipc	ra,0x0
    8000580e:	d6c080e7          	jalr	-660(ra) # 80005576 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005812:	00018597          	auipc	a1,0x18
    80005816:	91658593          	addi	a1,a1,-1770 # 8001d128 <disk+0x2128>
    8000581a:	00017517          	auipc	a0,0x17
    8000581e:	7fe50513          	addi	a0,a0,2046 # 8001d018 <disk+0x2018>
    80005822:	ffffc097          	auipc	ra,0xffffc
    80005826:	f8e080e7          	jalr	-114(ra) # 800017b0 <sleep>
  for(int i = 0; i < 3; i++){
    8000582a:	f9040713          	addi	a4,s0,-112
    8000582e:	84ce                	mv	s1,s3
    80005830:	bf41                	j	800057c0 <virtio_disk_rw+0x6a>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    80005832:	20058713          	addi	a4,a1,512
    80005836:	00471693          	slli	a3,a4,0x4
    8000583a:	00015717          	auipc	a4,0x15
    8000583e:	7c670713          	addi	a4,a4,1990 # 8001b000 <disk>
    80005842:	9736                	add	a4,a4,a3
    80005844:	4685                	li	a3,1
    80005846:	0ad72423          	sw	a3,168(a4)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    8000584a:	20058713          	addi	a4,a1,512
    8000584e:	00471693          	slli	a3,a4,0x4
    80005852:	00015717          	auipc	a4,0x15
    80005856:	7ae70713          	addi	a4,a4,1966 # 8001b000 <disk>
    8000585a:	9736                	add	a4,a4,a3
    8000585c:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    80005860:	0b973823          	sd	s9,176(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005864:	7679                	lui	a2,0xffffe
    80005866:	963e                	add	a2,a2,a5
    80005868:	00017697          	auipc	a3,0x17
    8000586c:	79868693          	addi	a3,a3,1944 # 8001d000 <disk+0x2000>
    80005870:	6298                	ld	a4,0(a3)
    80005872:	9732                	add	a4,a4,a2
    80005874:	e308                	sd	a0,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005876:	6298                	ld	a4,0(a3)
    80005878:	9732                	add	a4,a4,a2
    8000587a:	4541                	li	a0,16
    8000587c:	c708                	sw	a0,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    8000587e:	6298                	ld	a4,0(a3)
    80005880:	9732                	add	a4,a4,a2
    80005882:	4505                	li	a0,1
    80005884:	00a71623          	sh	a0,12(a4)
  disk.desc[idx[0]].next = idx[1];
    80005888:	f9442703          	lw	a4,-108(s0)
    8000588c:	6288                	ld	a0,0(a3)
    8000588e:	962a                	add	a2,a2,a0
    80005890:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffd7dce>

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005894:	0712                	slli	a4,a4,0x4
    80005896:	6290                	ld	a2,0(a3)
    80005898:	963a                	add	a2,a2,a4
    8000589a:	05890513          	addi	a0,s2,88
    8000589e:	e208                	sd	a0,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    800058a0:	6294                	ld	a3,0(a3)
    800058a2:	96ba                	add	a3,a3,a4
    800058a4:	40000613          	li	a2,1024
    800058a8:	c690                	sw	a2,8(a3)
  if(write)
    800058aa:	140d0063          	beqz	s10,800059ea <virtio_disk_rw+0x294>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    800058ae:	00017697          	auipc	a3,0x17
    800058b2:	7526b683          	ld	a3,1874(a3) # 8001d000 <disk+0x2000>
    800058b6:	96ba                	add	a3,a3,a4
    800058b8:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800058bc:	00015817          	auipc	a6,0x15
    800058c0:	74480813          	addi	a6,a6,1860 # 8001b000 <disk>
    800058c4:	00017517          	auipc	a0,0x17
    800058c8:	73c50513          	addi	a0,a0,1852 # 8001d000 <disk+0x2000>
    800058cc:	6114                	ld	a3,0(a0)
    800058ce:	96ba                	add	a3,a3,a4
    800058d0:	00c6d603          	lhu	a2,12(a3)
    800058d4:	00166613          	ori	a2,a2,1
    800058d8:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    800058dc:	f9842683          	lw	a3,-104(s0)
    800058e0:	6110                	ld	a2,0(a0)
    800058e2:	9732                	add	a4,a4,a2
    800058e4:	00d71723          	sh	a3,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800058e8:	20058613          	addi	a2,a1,512
    800058ec:	0612                	slli	a2,a2,0x4
    800058ee:	9642                	add	a2,a2,a6
    800058f0:	577d                	li	a4,-1
    800058f2:	02e60823          	sb	a4,48(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800058f6:	00469713          	slli	a4,a3,0x4
    800058fa:	6114                	ld	a3,0(a0)
    800058fc:	96ba                	add	a3,a3,a4
    800058fe:	03078793          	addi	a5,a5,48
    80005902:	97c2                	add	a5,a5,a6
    80005904:	e29c                	sd	a5,0(a3)
  disk.desc[idx[2]].len = 1;
    80005906:	611c                	ld	a5,0(a0)
    80005908:	97ba                	add	a5,a5,a4
    8000590a:	4685                	li	a3,1
    8000590c:	c794                	sw	a3,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    8000590e:	611c                	ld	a5,0(a0)
    80005910:	97ba                	add	a5,a5,a4
    80005912:	4809                	li	a6,2
    80005914:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    80005918:	611c                	ld	a5,0(a0)
    8000591a:	973e                	add	a4,a4,a5
    8000591c:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005920:	00d92223          	sw	a3,4(s2)
  disk.info[idx[0]].b = b;
    80005924:	03263423          	sd	s2,40(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005928:	6518                	ld	a4,8(a0)
    8000592a:	00275783          	lhu	a5,2(a4)
    8000592e:	8b9d                	andi	a5,a5,7
    80005930:	0786                	slli	a5,a5,0x1
    80005932:	97ba                	add	a5,a5,a4
    80005934:	00b79223          	sh	a1,4(a5)

  __sync_synchronize();
    80005938:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    8000593c:	6518                	ld	a4,8(a0)
    8000593e:	00275783          	lhu	a5,2(a4)
    80005942:	2785                	addiw	a5,a5,1
    80005944:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005948:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000594c:	100017b7          	lui	a5,0x10001
    80005950:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005954:	00492703          	lw	a4,4(s2)
    80005958:	4785                	li	a5,1
    8000595a:	02f71163          	bne	a4,a5,8000597c <virtio_disk_rw+0x226>
    sleep(b, &disk.vdisk_lock);
    8000595e:	00017997          	auipc	s3,0x17
    80005962:	7ca98993          	addi	s3,s3,1994 # 8001d128 <disk+0x2128>
  while(b->disk == 1) {
    80005966:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80005968:	85ce                	mv	a1,s3
    8000596a:	854a                	mv	a0,s2
    8000596c:	ffffc097          	auipc	ra,0xffffc
    80005970:	e44080e7          	jalr	-444(ra) # 800017b0 <sleep>
  while(b->disk == 1) {
    80005974:	00492783          	lw	a5,4(s2)
    80005978:	fe9788e3          	beq	a5,s1,80005968 <virtio_disk_rw+0x212>
  }

  disk.info[idx[0]].b = 0;
    8000597c:	f9042903          	lw	s2,-112(s0)
    80005980:	20090793          	addi	a5,s2,512
    80005984:	00479713          	slli	a4,a5,0x4
    80005988:	00015797          	auipc	a5,0x15
    8000598c:	67878793          	addi	a5,a5,1656 # 8001b000 <disk>
    80005990:	97ba                	add	a5,a5,a4
    80005992:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    80005996:	00017997          	auipc	s3,0x17
    8000599a:	66a98993          	addi	s3,s3,1642 # 8001d000 <disk+0x2000>
    8000599e:	00491713          	slli	a4,s2,0x4
    800059a2:	0009b783          	ld	a5,0(s3)
    800059a6:	97ba                	add	a5,a5,a4
    800059a8:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800059ac:	854a                	mv	a0,s2
    800059ae:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800059b2:	00000097          	auipc	ra,0x0
    800059b6:	bc4080e7          	jalr	-1084(ra) # 80005576 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800059ba:	8885                	andi	s1,s1,1
    800059bc:	f0ed                	bnez	s1,8000599e <virtio_disk_rw+0x248>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800059be:	00017517          	auipc	a0,0x17
    800059c2:	76a50513          	addi	a0,a0,1898 # 8001d128 <disk+0x2128>
    800059c6:	00001097          	auipc	ra,0x1
    800059ca:	d50080e7          	jalr	-688(ra) # 80006716 <release>
}
    800059ce:	70a6                	ld	ra,104(sp)
    800059d0:	7406                	ld	s0,96(sp)
    800059d2:	64e6                	ld	s1,88(sp)
    800059d4:	6946                	ld	s2,80(sp)
    800059d6:	69a6                	ld	s3,72(sp)
    800059d8:	6a06                	ld	s4,64(sp)
    800059da:	7ae2                	ld	s5,56(sp)
    800059dc:	7b42                	ld	s6,48(sp)
    800059de:	7ba2                	ld	s7,40(sp)
    800059e0:	7c02                	ld	s8,32(sp)
    800059e2:	6ce2                	ld	s9,24(sp)
    800059e4:	6d42                	ld	s10,16(sp)
    800059e6:	6165                	addi	sp,sp,112
    800059e8:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    800059ea:	00017697          	auipc	a3,0x17
    800059ee:	6166b683          	ld	a3,1558(a3) # 8001d000 <disk+0x2000>
    800059f2:	96ba                	add	a3,a3,a4
    800059f4:	4609                	li	a2,2
    800059f6:	00c69623          	sh	a2,12(a3)
    800059fa:	b5c9                	j	800058bc <virtio_disk_rw+0x166>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800059fc:	f9042583          	lw	a1,-112(s0)
    80005a00:	20058793          	addi	a5,a1,512
    80005a04:	0792                	slli	a5,a5,0x4
    80005a06:	00015517          	auipc	a0,0x15
    80005a0a:	6a250513          	addi	a0,a0,1698 # 8001b0a8 <disk+0xa8>
    80005a0e:	953e                	add	a0,a0,a5
  if(write)
    80005a10:	e20d11e3          	bnez	s10,80005832 <virtio_disk_rw+0xdc>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    80005a14:	20058713          	addi	a4,a1,512
    80005a18:	00471693          	slli	a3,a4,0x4
    80005a1c:	00015717          	auipc	a4,0x15
    80005a20:	5e470713          	addi	a4,a4,1508 # 8001b000 <disk>
    80005a24:	9736                	add	a4,a4,a3
    80005a26:	0a072423          	sw	zero,168(a4)
    80005a2a:	b505                	j	8000584a <virtio_disk_rw+0xf4>

0000000080005a2c <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005a2c:	1101                	addi	sp,sp,-32
    80005a2e:	ec06                	sd	ra,24(sp)
    80005a30:	e822                	sd	s0,16(sp)
    80005a32:	e426                	sd	s1,8(sp)
    80005a34:	e04a                	sd	s2,0(sp)
    80005a36:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005a38:	00017517          	auipc	a0,0x17
    80005a3c:	6f050513          	addi	a0,a0,1776 # 8001d128 <disk+0x2128>
    80005a40:	00001097          	auipc	ra,0x1
    80005a44:	c22080e7          	jalr	-990(ra) # 80006662 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005a48:	10001737          	lui	a4,0x10001
    80005a4c:	533c                	lw	a5,96(a4)
    80005a4e:	8b8d                	andi	a5,a5,3
    80005a50:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80005a52:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005a56:	00017797          	auipc	a5,0x17
    80005a5a:	5aa78793          	addi	a5,a5,1450 # 8001d000 <disk+0x2000>
    80005a5e:	6b94                	ld	a3,16(a5)
    80005a60:	0207d703          	lhu	a4,32(a5)
    80005a64:	0026d783          	lhu	a5,2(a3)
    80005a68:	06f70163          	beq	a4,a5,80005aca <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005a6c:	00015917          	auipc	s2,0x15
    80005a70:	59490913          	addi	s2,s2,1428 # 8001b000 <disk>
    80005a74:	00017497          	auipc	s1,0x17
    80005a78:	58c48493          	addi	s1,s1,1420 # 8001d000 <disk+0x2000>
    __sync_synchronize();
    80005a7c:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005a80:	6898                	ld	a4,16(s1)
    80005a82:	0204d783          	lhu	a5,32(s1)
    80005a86:	8b9d                	andi	a5,a5,7
    80005a88:	078e                	slli	a5,a5,0x3
    80005a8a:	97ba                	add	a5,a5,a4
    80005a8c:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005a8e:	20078713          	addi	a4,a5,512
    80005a92:	0712                	slli	a4,a4,0x4
    80005a94:	974a                	add	a4,a4,s2
    80005a96:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    80005a9a:	e731                	bnez	a4,80005ae6 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005a9c:	20078793          	addi	a5,a5,512
    80005aa0:	0792                	slli	a5,a5,0x4
    80005aa2:	97ca                	add	a5,a5,s2
    80005aa4:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    80005aa6:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005aaa:	ffffc097          	auipc	ra,0xffffc
    80005aae:	e92080e7          	jalr	-366(ra) # 8000193c <wakeup>

    disk.used_idx += 1;
    80005ab2:	0204d783          	lhu	a5,32(s1)
    80005ab6:	2785                	addiw	a5,a5,1
    80005ab8:	17c2                	slli	a5,a5,0x30
    80005aba:	93c1                	srli	a5,a5,0x30
    80005abc:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005ac0:	6898                	ld	a4,16(s1)
    80005ac2:	00275703          	lhu	a4,2(a4)
    80005ac6:	faf71be3          	bne	a4,a5,80005a7c <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    80005aca:	00017517          	auipc	a0,0x17
    80005ace:	65e50513          	addi	a0,a0,1630 # 8001d128 <disk+0x2128>
    80005ad2:	00001097          	auipc	ra,0x1
    80005ad6:	c44080e7          	jalr	-956(ra) # 80006716 <release>
}
    80005ada:	60e2                	ld	ra,24(sp)
    80005adc:	6442                	ld	s0,16(sp)
    80005ade:	64a2                	ld	s1,8(sp)
    80005ae0:	6902                	ld	s2,0(sp)
    80005ae2:	6105                	addi	sp,sp,32
    80005ae4:	8082                	ret
      panic("virtio_disk_intr status");
    80005ae6:	00003517          	auipc	a0,0x3
    80005aea:	dd250513          	addi	a0,a0,-558 # 800088b8 <syscalls+0x4a0>
    80005aee:	00000097          	auipc	ra,0x0
    80005af2:	62a080e7          	jalr	1578(ra) # 80006118 <panic>

0000000080005af6 <swap_page_from_pte>:
/* NTU OS 2024 */
/* Allocate eight consecutive disk blocks. */
/* Save the content of the physical page in the pte */
/* to the disk blocks and save the block-id into the */
/* pte. */
char *swap_page_from_pte(pte_t *pte) {
    80005af6:	7179                	addi	sp,sp,-48
    80005af8:	f406                	sd	ra,40(sp)
    80005afa:	f022                	sd	s0,32(sp)
    80005afc:	ec26                	sd	s1,24(sp)
    80005afe:	e84a                	sd	s2,16(sp)
    80005b00:	e44e                	sd	s3,8(sp)
    80005b02:	1800                	addi	s0,sp,48
    80005b04:	89aa                	mv	s3,a0
  char *pa = (char*) PTE2PA(*pte);
    80005b06:	00053903          	ld	s2,0(a0)
    80005b0a:	00a95913          	srli	s2,s2,0xa
    80005b0e:	0932                	slli	s2,s2,0xc
  uint dp = balloc_page(ROOTDEV);
    80005b10:	4505                	li	a0,1
    80005b12:	ffffe097          	auipc	ra,0xffffe
    80005b16:	aae080e7          	jalr	-1362(ra) # 800035c0 <balloc_page>
    80005b1a:	0005049b          	sext.w	s1,a0

  write_page_to_disk(ROOTDEV, pa, dp); // write this page to disk
    80005b1e:	8626                	mv	a2,s1
    80005b20:	85ca                	mv	a1,s2
    80005b22:	4505                	li	a0,1
    80005b24:	ffffd097          	auipc	ra,0xffffd
    80005b28:	c5e080e7          	jalr	-930(ra) # 80002782 <write_page_to_disk>
  *pte = (BLOCKNO2PTE(dp) | PTE_FLAGS(*pte) | PTE_S) & ~PTE_V;
    80005b2c:	0009b783          	ld	a5,0(s3)
    80005b30:	00a4949b          	slliw	s1,s1,0xa
    80005b34:	1482                	slli	s1,s1,0x20
    80005b36:	9081                	srli	s1,s1,0x20
    80005b38:	1fe7f793          	andi	a5,a5,510
    80005b3c:	8cdd                	or	s1,s1,a5
    80005b3e:	2004e493          	ori	s1,s1,512
    80005b42:	0099b023          	sd	s1,0(s3)

  return pa;
}
    80005b46:	854a                	mv	a0,s2
    80005b48:	70a2                	ld	ra,40(sp)
    80005b4a:	7402                	ld	s0,32(sp)
    80005b4c:	64e2                	ld	s1,24(sp)
    80005b4e:	6942                	ld	s2,16(sp)
    80005b50:	69a2                	ld	s3,8(sp)
    80005b52:	6145                	addi	sp,sp,48
    80005b54:	8082                	ret

0000000080005b56 <handle_pgfault>:

/* NTU OS 2024 */
/* Page fault handler */
int handle_pgfault() {
    80005b56:	1141                	addi	sp,sp,-16
    80005b58:	e406                	sd	ra,8(sp)
    80005b5a:	e022                	sd	s0,0(sp)
    80005b5c:	0800                	addi	s0,sp,16
  /* Find the address that caused the fault */
  /* uint64 va = r_stval(); */

  /* TODO */
  panic("not implemented yet\n");
    80005b5e:	00003517          	auipc	a0,0x3
    80005b62:	d7250513          	addi	a0,a0,-654 # 800088d0 <syscalls+0x4b8>
    80005b66:	00000097          	auipc	ra,0x0
    80005b6a:	5b2080e7          	jalr	1458(ra) # 80006118 <panic>

0000000080005b6e <sys_vmprint>:

/* NTU OS 2024 */
/* Entry of vmprint() syscall. */
uint64
sys_vmprint(void)
{
    80005b6e:	1141                	addi	sp,sp,-16
    80005b70:	e406                	sd	ra,8(sp)
    80005b72:	e022                	sd	s0,0(sp)
    80005b74:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80005b76:	ffffb097          	auipc	ra,0xffffb
    80005b7a:	57e080e7          	jalr	1406(ra) # 800010f4 <myproc>
  vmprint(p->pagetable);
    80005b7e:	6928                	ld	a0,80(a0)
    80005b80:	ffffb097          	auipc	ra,0xffffb
    80005b84:	3b2080e7          	jalr	946(ra) # 80000f32 <vmprint>
  return 0;
}
    80005b88:	4501                	li	a0,0
    80005b8a:	60a2                	ld	ra,8(sp)
    80005b8c:	6402                	ld	s0,0(sp)
    80005b8e:	0141                	addi	sp,sp,16
    80005b90:	8082                	ret

0000000080005b92 <sys_madvise>:

/* NTU OS 2024 */
/* Entry of madvise() syscall. */
uint64
sys_madvise(void)
{
    80005b92:	1101                	addi	sp,sp,-32
    80005b94:	ec06                	sd	ra,24(sp)
    80005b96:	e822                	sd	s0,16(sp)
    80005b98:	1000                	addi	s0,sp,32

  uint64 addr;
  int length;
  int advise;

  if (argaddr(0, &addr) < 0) return -1;
    80005b9a:	fe840593          	addi	a1,s0,-24
    80005b9e:	4501                	li	a0,0
    80005ba0:	ffffc097          	auipc	ra,0xffffc
    80005ba4:	622080e7          	jalr	1570(ra) # 800021c2 <argaddr>
    80005ba8:	57fd                	li	a5,-1
    80005baa:	04054163          	bltz	a0,80005bec <sys_madvise+0x5a>
  if (argint(1, &length) < 0) return -1;
    80005bae:	fe440593          	addi	a1,s0,-28
    80005bb2:	4505                	li	a0,1
    80005bb4:	ffffc097          	auipc	ra,0xffffc
    80005bb8:	5ec080e7          	jalr	1516(ra) # 800021a0 <argint>
    80005bbc:	57fd                	li	a5,-1
    80005bbe:	02054763          	bltz	a0,80005bec <sys_madvise+0x5a>
  if (argint(2, &advise) < 0) return -1;
    80005bc2:	fe040593          	addi	a1,s0,-32
    80005bc6:	4509                	li	a0,2
    80005bc8:	ffffc097          	auipc	ra,0xffffc
    80005bcc:	5d8080e7          	jalr	1496(ra) # 800021a0 <argint>
    80005bd0:	57fd                	li	a5,-1
    80005bd2:	00054d63          	bltz	a0,80005bec <sys_madvise+0x5a>

  int ret = madvise(addr, length, advise);
    80005bd6:	fe042603          	lw	a2,-32(s0)
    80005bda:	fe442583          	lw	a1,-28(s0)
    80005bde:	fe843503          	ld	a0,-24(s0)
    80005be2:	ffffb097          	auipc	ra,0xffffb
    80005be6:	0ec080e7          	jalr	236(ra) # 80000cce <madvise>
  return ret;
    80005bea:	87aa                	mv	a5,a0
}
    80005bec:	853e                	mv	a0,a5
    80005bee:	60e2                	ld	ra,24(sp)
    80005bf0:	6442                	ld	s0,16(sp)
    80005bf2:	6105                	addi	sp,sp,32
    80005bf4:	8082                	ret

0000000080005bf6 <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005bf6:	1141                	addi	sp,sp,-16
    80005bf8:	e422                	sd	s0,8(sp)
    80005bfa:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005bfc:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005c00:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005c04:	0037979b          	slliw	a5,a5,0x3
    80005c08:	02004737          	lui	a4,0x2004
    80005c0c:	97ba                	add	a5,a5,a4
    80005c0e:	0200c737          	lui	a4,0x200c
    80005c12:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005c16:	000f4637          	lui	a2,0xf4
    80005c1a:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005c1e:	95b2                	add	a1,a1,a2
    80005c20:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005c22:	00269713          	slli	a4,a3,0x2
    80005c26:	9736                	add	a4,a4,a3
    80005c28:	00371693          	slli	a3,a4,0x3
    80005c2c:	00018717          	auipc	a4,0x18
    80005c30:	3d470713          	addi	a4,a4,980 # 8001e000 <timer_scratch>
    80005c34:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005c36:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005c38:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80005c3a:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005c3e:	00000797          	auipc	a5,0x0
    80005c42:	87278793          	addi	a5,a5,-1934 # 800054b0 <timervec>
    80005c46:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005c4a:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005c4e:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005c52:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005c56:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80005c5a:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80005c5e:	30479073          	csrw	mie,a5
}
    80005c62:	6422                	ld	s0,8(sp)
    80005c64:	0141                	addi	sp,sp,16
    80005c66:	8082                	ret

0000000080005c68 <start>:
{
    80005c68:	1141                	addi	sp,sp,-16
    80005c6a:	e406                	sd	ra,8(sp)
    80005c6c:	e022                	sd	s0,0(sp)
    80005c6e:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005c70:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005c74:	7779                	lui	a4,0xffffe
    80005c76:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd85bf>
    80005c7a:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005c7c:	6705                	lui	a4,0x1
    80005c7e:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005c82:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005c84:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005c88:	ffffa797          	auipc	a5,0xffffa
    80005c8c:	69e78793          	addi	a5,a5,1694 # 80000326 <main>
    80005c90:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005c94:	4781                	li	a5,0
    80005c96:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005c9a:	67c1                	lui	a5,0x10
    80005c9c:	17fd                	addi	a5,a5,-1
    80005c9e:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005ca2:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005ca6:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005caa:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005cae:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005cb2:	57fd                	li	a5,-1
    80005cb4:	83a9                	srli	a5,a5,0xa
    80005cb6:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005cba:	47bd                	li	a5,15
    80005cbc:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005cc0:	00000097          	auipc	ra,0x0
    80005cc4:	f36080e7          	jalr	-202(ra) # 80005bf6 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005cc8:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005ccc:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005cce:	823e                	mv	tp,a5
  asm volatile("mret");
    80005cd0:	30200073          	mret
}
    80005cd4:	60a2                	ld	ra,8(sp)
    80005cd6:	6402                	ld	s0,0(sp)
    80005cd8:	0141                	addi	sp,sp,16
    80005cda:	8082                	ret

0000000080005cdc <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005cdc:	715d                	addi	sp,sp,-80
    80005cde:	e486                	sd	ra,72(sp)
    80005ce0:	e0a2                	sd	s0,64(sp)
    80005ce2:	fc26                	sd	s1,56(sp)
    80005ce4:	f84a                	sd	s2,48(sp)
    80005ce6:	f44e                	sd	s3,40(sp)
    80005ce8:	f052                	sd	s4,32(sp)
    80005cea:	ec56                	sd	s5,24(sp)
    80005cec:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005cee:	04c05663          	blez	a2,80005d3a <consolewrite+0x5e>
    80005cf2:	8a2a                	mv	s4,a0
    80005cf4:	84ae                	mv	s1,a1
    80005cf6:	89b2                	mv	s3,a2
    80005cf8:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005cfa:	5afd                	li	s5,-1
    80005cfc:	4685                	li	a3,1
    80005cfe:	8626                	mv	a2,s1
    80005d00:	85d2                	mv	a1,s4
    80005d02:	fbf40513          	addi	a0,s0,-65
    80005d06:	ffffc097          	auipc	ra,0xffffc
    80005d0a:	ea4080e7          	jalr	-348(ra) # 80001baa <either_copyin>
    80005d0e:	01550c63          	beq	a0,s5,80005d26 <consolewrite+0x4a>
      break;
    uartputc(c);
    80005d12:	fbf44503          	lbu	a0,-65(s0)
    80005d16:	00000097          	auipc	ra,0x0
    80005d1a:	78e080e7          	jalr	1934(ra) # 800064a4 <uartputc>
  for(i = 0; i < n; i++){
    80005d1e:	2905                	addiw	s2,s2,1
    80005d20:	0485                	addi	s1,s1,1
    80005d22:	fd299de3          	bne	s3,s2,80005cfc <consolewrite+0x20>
  }

  return i;
}
    80005d26:	854a                	mv	a0,s2
    80005d28:	60a6                	ld	ra,72(sp)
    80005d2a:	6406                	ld	s0,64(sp)
    80005d2c:	74e2                	ld	s1,56(sp)
    80005d2e:	7942                	ld	s2,48(sp)
    80005d30:	79a2                	ld	s3,40(sp)
    80005d32:	7a02                	ld	s4,32(sp)
    80005d34:	6ae2                	ld	s5,24(sp)
    80005d36:	6161                	addi	sp,sp,80
    80005d38:	8082                	ret
  for(i = 0; i < n; i++){
    80005d3a:	4901                	li	s2,0
    80005d3c:	b7ed                	j	80005d26 <consolewrite+0x4a>

0000000080005d3e <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005d3e:	7119                	addi	sp,sp,-128
    80005d40:	fc86                	sd	ra,120(sp)
    80005d42:	f8a2                	sd	s0,112(sp)
    80005d44:	f4a6                	sd	s1,104(sp)
    80005d46:	f0ca                	sd	s2,96(sp)
    80005d48:	ecce                	sd	s3,88(sp)
    80005d4a:	e8d2                	sd	s4,80(sp)
    80005d4c:	e4d6                	sd	s5,72(sp)
    80005d4e:	e0da                	sd	s6,64(sp)
    80005d50:	fc5e                	sd	s7,56(sp)
    80005d52:	f862                	sd	s8,48(sp)
    80005d54:	f466                	sd	s9,40(sp)
    80005d56:	f06a                	sd	s10,32(sp)
    80005d58:	ec6e                	sd	s11,24(sp)
    80005d5a:	0100                	addi	s0,sp,128
    80005d5c:	8b2a                	mv	s6,a0
    80005d5e:	8aae                	mv	s5,a1
    80005d60:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005d62:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    80005d66:	00020517          	auipc	a0,0x20
    80005d6a:	3da50513          	addi	a0,a0,986 # 80026140 <cons>
    80005d6e:	00001097          	auipc	ra,0x1
    80005d72:	8f4080e7          	jalr	-1804(ra) # 80006662 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005d76:	00020497          	auipc	s1,0x20
    80005d7a:	3ca48493          	addi	s1,s1,970 # 80026140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005d7e:	89a6                	mv	s3,s1
    80005d80:	00020917          	auipc	s2,0x20
    80005d84:	45890913          	addi	s2,s2,1112 # 800261d8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    80005d88:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005d8a:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80005d8c:	4da9                	li	s11,10
  while(n > 0){
    80005d8e:	07405863          	blez	s4,80005dfe <consoleread+0xc0>
    while(cons.r == cons.w){
    80005d92:	0984a783          	lw	a5,152(s1)
    80005d96:	09c4a703          	lw	a4,156(s1)
    80005d9a:	02f71463          	bne	a4,a5,80005dc2 <consoleread+0x84>
      if(myproc()->killed){
    80005d9e:	ffffb097          	auipc	ra,0xffffb
    80005da2:	356080e7          	jalr	854(ra) # 800010f4 <myproc>
    80005da6:	551c                	lw	a5,40(a0)
    80005da8:	e7b5                	bnez	a5,80005e14 <consoleread+0xd6>
      sleep(&cons.r, &cons.lock);
    80005daa:	85ce                	mv	a1,s3
    80005dac:	854a                	mv	a0,s2
    80005dae:	ffffc097          	auipc	ra,0xffffc
    80005db2:	a02080e7          	jalr	-1534(ra) # 800017b0 <sleep>
    while(cons.r == cons.w){
    80005db6:	0984a783          	lw	a5,152(s1)
    80005dba:	09c4a703          	lw	a4,156(s1)
    80005dbe:	fef700e3          	beq	a4,a5,80005d9e <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF];
    80005dc2:	0017871b          	addiw	a4,a5,1
    80005dc6:	08e4ac23          	sw	a4,152(s1)
    80005dca:	07f7f713          	andi	a4,a5,127
    80005dce:	9726                	add	a4,a4,s1
    80005dd0:	01874703          	lbu	a4,24(a4)
    80005dd4:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    80005dd8:	079c0663          	beq	s8,s9,80005e44 <consoleread+0x106>
    cbuf = c;
    80005ddc:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005de0:	4685                	li	a3,1
    80005de2:	f8f40613          	addi	a2,s0,-113
    80005de6:	85d6                	mv	a1,s5
    80005de8:	855a                	mv	a0,s6
    80005dea:	ffffc097          	auipc	ra,0xffffc
    80005dee:	d6a080e7          	jalr	-662(ra) # 80001b54 <either_copyout>
    80005df2:	01a50663          	beq	a0,s10,80005dfe <consoleread+0xc0>
    dst++;
    80005df6:	0a85                	addi	s5,s5,1
    --n;
    80005df8:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    80005dfa:	f9bc1ae3          	bne	s8,s11,80005d8e <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005dfe:	00020517          	auipc	a0,0x20
    80005e02:	34250513          	addi	a0,a0,834 # 80026140 <cons>
    80005e06:	00001097          	auipc	ra,0x1
    80005e0a:	910080e7          	jalr	-1776(ra) # 80006716 <release>

  return target - n;
    80005e0e:	414b853b          	subw	a0,s7,s4
    80005e12:	a811                	j	80005e26 <consoleread+0xe8>
        release(&cons.lock);
    80005e14:	00020517          	auipc	a0,0x20
    80005e18:	32c50513          	addi	a0,a0,812 # 80026140 <cons>
    80005e1c:	00001097          	auipc	ra,0x1
    80005e20:	8fa080e7          	jalr	-1798(ra) # 80006716 <release>
        return -1;
    80005e24:	557d                	li	a0,-1
}
    80005e26:	70e6                	ld	ra,120(sp)
    80005e28:	7446                	ld	s0,112(sp)
    80005e2a:	74a6                	ld	s1,104(sp)
    80005e2c:	7906                	ld	s2,96(sp)
    80005e2e:	69e6                	ld	s3,88(sp)
    80005e30:	6a46                	ld	s4,80(sp)
    80005e32:	6aa6                	ld	s5,72(sp)
    80005e34:	6b06                	ld	s6,64(sp)
    80005e36:	7be2                	ld	s7,56(sp)
    80005e38:	7c42                	ld	s8,48(sp)
    80005e3a:	7ca2                	ld	s9,40(sp)
    80005e3c:	7d02                	ld	s10,32(sp)
    80005e3e:	6de2                	ld	s11,24(sp)
    80005e40:	6109                	addi	sp,sp,128
    80005e42:	8082                	ret
      if(n < target){
    80005e44:	000a071b          	sext.w	a4,s4
    80005e48:	fb777be3          	bgeu	a4,s7,80005dfe <consoleread+0xc0>
        cons.r--;
    80005e4c:	00020717          	auipc	a4,0x20
    80005e50:	38f72623          	sw	a5,908(a4) # 800261d8 <cons+0x98>
    80005e54:	b76d                	j	80005dfe <consoleread+0xc0>

0000000080005e56 <consputc>:
{
    80005e56:	1141                	addi	sp,sp,-16
    80005e58:	e406                	sd	ra,8(sp)
    80005e5a:	e022                	sd	s0,0(sp)
    80005e5c:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005e5e:	10000793          	li	a5,256
    80005e62:	00f50a63          	beq	a0,a5,80005e76 <consputc+0x20>
    uartputc_sync(c);
    80005e66:	00000097          	auipc	ra,0x0
    80005e6a:	564080e7          	jalr	1380(ra) # 800063ca <uartputc_sync>
}
    80005e6e:	60a2                	ld	ra,8(sp)
    80005e70:	6402                	ld	s0,0(sp)
    80005e72:	0141                	addi	sp,sp,16
    80005e74:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005e76:	4521                	li	a0,8
    80005e78:	00000097          	auipc	ra,0x0
    80005e7c:	552080e7          	jalr	1362(ra) # 800063ca <uartputc_sync>
    80005e80:	02000513          	li	a0,32
    80005e84:	00000097          	auipc	ra,0x0
    80005e88:	546080e7          	jalr	1350(ra) # 800063ca <uartputc_sync>
    80005e8c:	4521                	li	a0,8
    80005e8e:	00000097          	auipc	ra,0x0
    80005e92:	53c080e7          	jalr	1340(ra) # 800063ca <uartputc_sync>
    80005e96:	bfe1                	j	80005e6e <consputc+0x18>

0000000080005e98 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005e98:	1101                	addi	sp,sp,-32
    80005e9a:	ec06                	sd	ra,24(sp)
    80005e9c:	e822                	sd	s0,16(sp)
    80005e9e:	e426                	sd	s1,8(sp)
    80005ea0:	e04a                	sd	s2,0(sp)
    80005ea2:	1000                	addi	s0,sp,32
    80005ea4:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005ea6:	00020517          	auipc	a0,0x20
    80005eaa:	29a50513          	addi	a0,a0,666 # 80026140 <cons>
    80005eae:	00000097          	auipc	ra,0x0
    80005eb2:	7b4080e7          	jalr	1972(ra) # 80006662 <acquire>

  switch(c){
    80005eb6:	47d5                	li	a5,21
    80005eb8:	0af48663          	beq	s1,a5,80005f64 <consoleintr+0xcc>
    80005ebc:	0297ca63          	blt	a5,s1,80005ef0 <consoleintr+0x58>
    80005ec0:	47a1                	li	a5,8
    80005ec2:	0ef48763          	beq	s1,a5,80005fb0 <consoleintr+0x118>
    80005ec6:	47c1                	li	a5,16
    80005ec8:	10f49a63          	bne	s1,a5,80005fdc <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005ecc:	ffffc097          	auipc	ra,0xffffc
    80005ed0:	d34080e7          	jalr	-716(ra) # 80001c00 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005ed4:	00020517          	auipc	a0,0x20
    80005ed8:	26c50513          	addi	a0,a0,620 # 80026140 <cons>
    80005edc:	00001097          	auipc	ra,0x1
    80005ee0:	83a080e7          	jalr	-1990(ra) # 80006716 <release>
}
    80005ee4:	60e2                	ld	ra,24(sp)
    80005ee6:	6442                	ld	s0,16(sp)
    80005ee8:	64a2                	ld	s1,8(sp)
    80005eea:	6902                	ld	s2,0(sp)
    80005eec:	6105                	addi	sp,sp,32
    80005eee:	8082                	ret
  switch(c){
    80005ef0:	07f00793          	li	a5,127
    80005ef4:	0af48e63          	beq	s1,a5,80005fb0 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005ef8:	00020717          	auipc	a4,0x20
    80005efc:	24870713          	addi	a4,a4,584 # 80026140 <cons>
    80005f00:	0a072783          	lw	a5,160(a4)
    80005f04:	09872703          	lw	a4,152(a4)
    80005f08:	9f99                	subw	a5,a5,a4
    80005f0a:	07f00713          	li	a4,127
    80005f0e:	fcf763e3          	bltu	a4,a5,80005ed4 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005f12:	47b5                	li	a5,13
    80005f14:	0cf48763          	beq	s1,a5,80005fe2 <consoleintr+0x14a>
      consputc(c);
    80005f18:	8526                	mv	a0,s1
    80005f1a:	00000097          	auipc	ra,0x0
    80005f1e:	f3c080e7          	jalr	-196(ra) # 80005e56 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005f22:	00020797          	auipc	a5,0x20
    80005f26:	21e78793          	addi	a5,a5,542 # 80026140 <cons>
    80005f2a:	0a07a703          	lw	a4,160(a5)
    80005f2e:	0017069b          	addiw	a3,a4,1
    80005f32:	0006861b          	sext.w	a2,a3
    80005f36:	0ad7a023          	sw	a3,160(a5)
    80005f3a:	07f77713          	andi	a4,a4,127
    80005f3e:	97ba                	add	a5,a5,a4
    80005f40:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005f44:	47a9                	li	a5,10
    80005f46:	0cf48563          	beq	s1,a5,80006010 <consoleintr+0x178>
    80005f4a:	4791                	li	a5,4
    80005f4c:	0cf48263          	beq	s1,a5,80006010 <consoleintr+0x178>
    80005f50:	00020797          	auipc	a5,0x20
    80005f54:	2887a783          	lw	a5,648(a5) # 800261d8 <cons+0x98>
    80005f58:	0807879b          	addiw	a5,a5,128
    80005f5c:	f6f61ce3          	bne	a2,a5,80005ed4 <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005f60:	863e                	mv	a2,a5
    80005f62:	a07d                	j	80006010 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005f64:	00020717          	auipc	a4,0x20
    80005f68:	1dc70713          	addi	a4,a4,476 # 80026140 <cons>
    80005f6c:	0a072783          	lw	a5,160(a4)
    80005f70:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005f74:	00020497          	auipc	s1,0x20
    80005f78:	1cc48493          	addi	s1,s1,460 # 80026140 <cons>
    while(cons.e != cons.w &&
    80005f7c:	4929                	li	s2,10
    80005f7e:	f4f70be3          	beq	a4,a5,80005ed4 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005f82:	37fd                	addiw	a5,a5,-1
    80005f84:	07f7f713          	andi	a4,a5,127
    80005f88:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005f8a:	01874703          	lbu	a4,24(a4)
    80005f8e:	f52703e3          	beq	a4,s2,80005ed4 <consoleintr+0x3c>
      cons.e--;
    80005f92:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005f96:	10000513          	li	a0,256
    80005f9a:	00000097          	auipc	ra,0x0
    80005f9e:	ebc080e7          	jalr	-324(ra) # 80005e56 <consputc>
    while(cons.e != cons.w &&
    80005fa2:	0a04a783          	lw	a5,160(s1)
    80005fa6:	09c4a703          	lw	a4,156(s1)
    80005faa:	fcf71ce3          	bne	a4,a5,80005f82 <consoleintr+0xea>
    80005fae:	b71d                	j	80005ed4 <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005fb0:	00020717          	auipc	a4,0x20
    80005fb4:	19070713          	addi	a4,a4,400 # 80026140 <cons>
    80005fb8:	0a072783          	lw	a5,160(a4)
    80005fbc:	09c72703          	lw	a4,156(a4)
    80005fc0:	f0f70ae3          	beq	a4,a5,80005ed4 <consoleintr+0x3c>
      cons.e--;
    80005fc4:	37fd                	addiw	a5,a5,-1
    80005fc6:	00020717          	auipc	a4,0x20
    80005fca:	20f72d23          	sw	a5,538(a4) # 800261e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005fce:	10000513          	li	a0,256
    80005fd2:	00000097          	auipc	ra,0x0
    80005fd6:	e84080e7          	jalr	-380(ra) # 80005e56 <consputc>
    80005fda:	bded                	j	80005ed4 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005fdc:	ee048ce3          	beqz	s1,80005ed4 <consoleintr+0x3c>
    80005fe0:	bf21                	j	80005ef8 <consoleintr+0x60>
      consputc(c);
    80005fe2:	4529                	li	a0,10
    80005fe4:	00000097          	auipc	ra,0x0
    80005fe8:	e72080e7          	jalr	-398(ra) # 80005e56 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005fec:	00020797          	auipc	a5,0x20
    80005ff0:	15478793          	addi	a5,a5,340 # 80026140 <cons>
    80005ff4:	0a07a703          	lw	a4,160(a5)
    80005ff8:	0017069b          	addiw	a3,a4,1
    80005ffc:	0006861b          	sext.w	a2,a3
    80006000:	0ad7a023          	sw	a3,160(a5)
    80006004:	07f77713          	andi	a4,a4,127
    80006008:	97ba                	add	a5,a5,a4
    8000600a:	4729                	li	a4,10
    8000600c:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80006010:	00020797          	auipc	a5,0x20
    80006014:	1cc7a623          	sw	a2,460(a5) # 800261dc <cons+0x9c>
        wakeup(&cons.r);
    80006018:	00020517          	auipc	a0,0x20
    8000601c:	1c050513          	addi	a0,a0,448 # 800261d8 <cons+0x98>
    80006020:	ffffc097          	auipc	ra,0xffffc
    80006024:	91c080e7          	jalr	-1764(ra) # 8000193c <wakeup>
    80006028:	b575                	j	80005ed4 <consoleintr+0x3c>

000000008000602a <consoleinit>:

void
consoleinit(void)
{
    8000602a:	1141                	addi	sp,sp,-16
    8000602c:	e406                	sd	ra,8(sp)
    8000602e:	e022                	sd	s0,0(sp)
    80006030:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80006032:	00003597          	auipc	a1,0x3
    80006036:	8b658593          	addi	a1,a1,-1866 # 800088e8 <syscalls+0x4d0>
    8000603a:	00020517          	auipc	a0,0x20
    8000603e:	10650513          	addi	a0,a0,262 # 80026140 <cons>
    80006042:	00000097          	auipc	ra,0x0
    80006046:	590080e7          	jalr	1424(ra) # 800065d2 <initlock>

  uartinit();
    8000604a:	00000097          	auipc	ra,0x0
    8000604e:	330080e7          	jalr	816(ra) # 8000637a <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80006052:	00013797          	auipc	a5,0x13
    80006056:	07678793          	addi	a5,a5,118 # 800190c8 <devsw>
    8000605a:	00000717          	auipc	a4,0x0
    8000605e:	ce470713          	addi	a4,a4,-796 # 80005d3e <consoleread>
    80006062:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80006064:	00000717          	auipc	a4,0x0
    80006068:	c7870713          	addi	a4,a4,-904 # 80005cdc <consolewrite>
    8000606c:	ef98                	sd	a4,24(a5)
}
    8000606e:	60a2                	ld	ra,8(sp)
    80006070:	6402                	ld	s0,0(sp)
    80006072:	0141                	addi	sp,sp,16
    80006074:	8082                	ret

0000000080006076 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80006076:	7179                	addi	sp,sp,-48
    80006078:	f406                	sd	ra,40(sp)
    8000607a:	f022                	sd	s0,32(sp)
    8000607c:	ec26                	sd	s1,24(sp)
    8000607e:	e84a                	sd	s2,16(sp)
    80006080:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80006082:	c219                	beqz	a2,80006088 <printint+0x12>
    80006084:	08054663          	bltz	a0,80006110 <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80006088:	2501                	sext.w	a0,a0
    8000608a:	4881                	li	a7,0
    8000608c:	fd040693          	addi	a3,s0,-48

  i = 0;
    80006090:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80006092:	2581                	sext.w	a1,a1
    80006094:	00003617          	auipc	a2,0x3
    80006098:	88460613          	addi	a2,a2,-1916 # 80008918 <digits>
    8000609c:	883a                	mv	a6,a4
    8000609e:	2705                	addiw	a4,a4,1
    800060a0:	02b577bb          	remuw	a5,a0,a1
    800060a4:	1782                	slli	a5,a5,0x20
    800060a6:	9381                	srli	a5,a5,0x20
    800060a8:	97b2                	add	a5,a5,a2
    800060aa:	0007c783          	lbu	a5,0(a5)
    800060ae:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    800060b2:	0005079b          	sext.w	a5,a0
    800060b6:	02b5553b          	divuw	a0,a0,a1
    800060ba:	0685                	addi	a3,a3,1
    800060bc:	feb7f0e3          	bgeu	a5,a1,8000609c <printint+0x26>

  if(sign)
    800060c0:	00088b63          	beqz	a7,800060d6 <printint+0x60>
    buf[i++] = '-';
    800060c4:	fe040793          	addi	a5,s0,-32
    800060c8:	973e                	add	a4,a4,a5
    800060ca:	02d00793          	li	a5,45
    800060ce:	fef70823          	sb	a5,-16(a4)
    800060d2:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    800060d6:	02e05763          	blez	a4,80006104 <printint+0x8e>
    800060da:	fd040793          	addi	a5,s0,-48
    800060de:	00e784b3          	add	s1,a5,a4
    800060e2:	fff78913          	addi	s2,a5,-1
    800060e6:	993a                	add	s2,s2,a4
    800060e8:	377d                	addiw	a4,a4,-1
    800060ea:	1702                	slli	a4,a4,0x20
    800060ec:	9301                	srli	a4,a4,0x20
    800060ee:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    800060f2:	fff4c503          	lbu	a0,-1(s1)
    800060f6:	00000097          	auipc	ra,0x0
    800060fa:	d60080e7          	jalr	-672(ra) # 80005e56 <consputc>
  while(--i >= 0)
    800060fe:	14fd                	addi	s1,s1,-1
    80006100:	ff2499e3          	bne	s1,s2,800060f2 <printint+0x7c>
}
    80006104:	70a2                	ld	ra,40(sp)
    80006106:	7402                	ld	s0,32(sp)
    80006108:	64e2                	ld	s1,24(sp)
    8000610a:	6942                	ld	s2,16(sp)
    8000610c:	6145                	addi	sp,sp,48
    8000610e:	8082                	ret
    x = -xx;
    80006110:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80006114:	4885                	li	a7,1
    x = -xx;
    80006116:	bf9d                	j	8000608c <printint+0x16>

0000000080006118 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80006118:	1101                	addi	sp,sp,-32
    8000611a:	ec06                	sd	ra,24(sp)
    8000611c:	e822                	sd	s0,16(sp)
    8000611e:	e426                	sd	s1,8(sp)
    80006120:	1000                	addi	s0,sp,32
    80006122:	84aa                	mv	s1,a0
  pr.locking = 0;
    80006124:	00020797          	auipc	a5,0x20
    80006128:	0c07ae23          	sw	zero,220(a5) # 80026200 <pr+0x18>
  printf("panic: ");
    8000612c:	00002517          	auipc	a0,0x2
    80006130:	7c450513          	addi	a0,a0,1988 # 800088f0 <syscalls+0x4d8>
    80006134:	00000097          	auipc	ra,0x0
    80006138:	02e080e7          	jalr	46(ra) # 80006162 <printf>
  printf(s);
    8000613c:	8526                	mv	a0,s1
    8000613e:	00000097          	auipc	ra,0x0
    80006142:	024080e7          	jalr	36(ra) # 80006162 <printf>
  printf("\n");
    80006146:	00002517          	auipc	a0,0x2
    8000614a:	f0250513          	addi	a0,a0,-254 # 80008048 <etext+0x48>
    8000614e:	00000097          	auipc	ra,0x0
    80006152:	014080e7          	jalr	20(ra) # 80006162 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80006156:	4785                	li	a5,1
    80006158:	00003717          	auipc	a4,0x3
    8000615c:	ecf72223          	sw	a5,-316(a4) # 8000901c <panicked>
  for(;;)
    80006160:	a001                	j	80006160 <panic+0x48>

0000000080006162 <printf>:
{
    80006162:	7131                	addi	sp,sp,-192
    80006164:	fc86                	sd	ra,120(sp)
    80006166:	f8a2                	sd	s0,112(sp)
    80006168:	f4a6                	sd	s1,104(sp)
    8000616a:	f0ca                	sd	s2,96(sp)
    8000616c:	ecce                	sd	s3,88(sp)
    8000616e:	e8d2                	sd	s4,80(sp)
    80006170:	e4d6                	sd	s5,72(sp)
    80006172:	e0da                	sd	s6,64(sp)
    80006174:	fc5e                	sd	s7,56(sp)
    80006176:	f862                	sd	s8,48(sp)
    80006178:	f466                	sd	s9,40(sp)
    8000617a:	f06a                	sd	s10,32(sp)
    8000617c:	ec6e                	sd	s11,24(sp)
    8000617e:	0100                	addi	s0,sp,128
    80006180:	8a2a                	mv	s4,a0
    80006182:	e40c                	sd	a1,8(s0)
    80006184:	e810                	sd	a2,16(s0)
    80006186:	ec14                	sd	a3,24(s0)
    80006188:	f018                	sd	a4,32(s0)
    8000618a:	f41c                	sd	a5,40(s0)
    8000618c:	03043823          	sd	a6,48(s0)
    80006190:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80006194:	00020d97          	auipc	s11,0x20
    80006198:	06cdad83          	lw	s11,108(s11) # 80026200 <pr+0x18>
  if(locking)
    8000619c:	020d9b63          	bnez	s11,800061d2 <printf+0x70>
  if (fmt == 0)
    800061a0:	040a0263          	beqz	s4,800061e4 <printf+0x82>
  va_start(ap, fmt);
    800061a4:	00840793          	addi	a5,s0,8
    800061a8:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800061ac:	000a4503          	lbu	a0,0(s4)
    800061b0:	16050263          	beqz	a0,80006314 <printf+0x1b2>
    800061b4:	4481                	li	s1,0
    if(c != '%'){
    800061b6:	02500a93          	li	s5,37
    switch(c){
    800061ba:	07000b13          	li	s6,112
  consputc('x');
    800061be:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800061c0:	00002b97          	auipc	s7,0x2
    800061c4:	758b8b93          	addi	s7,s7,1880 # 80008918 <digits>
    switch(c){
    800061c8:	07300c93          	li	s9,115
    800061cc:	06400c13          	li	s8,100
    800061d0:	a82d                	j	8000620a <printf+0xa8>
    acquire(&pr.lock);
    800061d2:	00020517          	auipc	a0,0x20
    800061d6:	01650513          	addi	a0,a0,22 # 800261e8 <pr>
    800061da:	00000097          	auipc	ra,0x0
    800061de:	488080e7          	jalr	1160(ra) # 80006662 <acquire>
    800061e2:	bf7d                	j	800061a0 <printf+0x3e>
    panic("null fmt");
    800061e4:	00002517          	auipc	a0,0x2
    800061e8:	71c50513          	addi	a0,a0,1820 # 80008900 <syscalls+0x4e8>
    800061ec:	00000097          	auipc	ra,0x0
    800061f0:	f2c080e7          	jalr	-212(ra) # 80006118 <panic>
      consputc(c);
    800061f4:	00000097          	auipc	ra,0x0
    800061f8:	c62080e7          	jalr	-926(ra) # 80005e56 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800061fc:	2485                	addiw	s1,s1,1
    800061fe:	009a07b3          	add	a5,s4,s1
    80006202:	0007c503          	lbu	a0,0(a5)
    80006206:	10050763          	beqz	a0,80006314 <printf+0x1b2>
    if(c != '%'){
    8000620a:	ff5515e3          	bne	a0,s5,800061f4 <printf+0x92>
    c = fmt[++i] & 0xff;
    8000620e:	2485                	addiw	s1,s1,1
    80006210:	009a07b3          	add	a5,s4,s1
    80006214:	0007c783          	lbu	a5,0(a5)
    80006218:	0007891b          	sext.w	s2,a5
    if(c == 0)
    8000621c:	cfe5                	beqz	a5,80006314 <printf+0x1b2>
    switch(c){
    8000621e:	05678a63          	beq	a5,s6,80006272 <printf+0x110>
    80006222:	02fb7663          	bgeu	s6,a5,8000624e <printf+0xec>
    80006226:	09978963          	beq	a5,s9,800062b8 <printf+0x156>
    8000622a:	07800713          	li	a4,120
    8000622e:	0ce79863          	bne	a5,a4,800062fe <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    80006232:	f8843783          	ld	a5,-120(s0)
    80006236:	00878713          	addi	a4,a5,8
    8000623a:	f8e43423          	sd	a4,-120(s0)
    8000623e:	4605                	li	a2,1
    80006240:	85ea                	mv	a1,s10
    80006242:	4388                	lw	a0,0(a5)
    80006244:	00000097          	auipc	ra,0x0
    80006248:	e32080e7          	jalr	-462(ra) # 80006076 <printint>
      break;
    8000624c:	bf45                	j	800061fc <printf+0x9a>
    switch(c){
    8000624e:	0b578263          	beq	a5,s5,800062f2 <printf+0x190>
    80006252:	0b879663          	bne	a5,s8,800062fe <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    80006256:	f8843783          	ld	a5,-120(s0)
    8000625a:	00878713          	addi	a4,a5,8
    8000625e:	f8e43423          	sd	a4,-120(s0)
    80006262:	4605                	li	a2,1
    80006264:	45a9                	li	a1,10
    80006266:	4388                	lw	a0,0(a5)
    80006268:	00000097          	auipc	ra,0x0
    8000626c:	e0e080e7          	jalr	-498(ra) # 80006076 <printint>
      break;
    80006270:	b771                	j	800061fc <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80006272:	f8843783          	ld	a5,-120(s0)
    80006276:	00878713          	addi	a4,a5,8
    8000627a:	f8e43423          	sd	a4,-120(s0)
    8000627e:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80006282:	03000513          	li	a0,48
    80006286:	00000097          	auipc	ra,0x0
    8000628a:	bd0080e7          	jalr	-1072(ra) # 80005e56 <consputc>
  consputc('x');
    8000628e:	07800513          	li	a0,120
    80006292:	00000097          	auipc	ra,0x0
    80006296:	bc4080e7          	jalr	-1084(ra) # 80005e56 <consputc>
    8000629a:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    8000629c:	03c9d793          	srli	a5,s3,0x3c
    800062a0:	97de                	add	a5,a5,s7
    800062a2:	0007c503          	lbu	a0,0(a5)
    800062a6:	00000097          	auipc	ra,0x0
    800062aa:	bb0080e7          	jalr	-1104(ra) # 80005e56 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800062ae:	0992                	slli	s3,s3,0x4
    800062b0:	397d                	addiw	s2,s2,-1
    800062b2:	fe0915e3          	bnez	s2,8000629c <printf+0x13a>
    800062b6:	b799                	j	800061fc <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    800062b8:	f8843783          	ld	a5,-120(s0)
    800062bc:	00878713          	addi	a4,a5,8
    800062c0:	f8e43423          	sd	a4,-120(s0)
    800062c4:	0007b903          	ld	s2,0(a5)
    800062c8:	00090e63          	beqz	s2,800062e4 <printf+0x182>
      for(; *s; s++)
    800062cc:	00094503          	lbu	a0,0(s2)
    800062d0:	d515                	beqz	a0,800061fc <printf+0x9a>
        consputc(*s);
    800062d2:	00000097          	auipc	ra,0x0
    800062d6:	b84080e7          	jalr	-1148(ra) # 80005e56 <consputc>
      for(; *s; s++)
    800062da:	0905                	addi	s2,s2,1
    800062dc:	00094503          	lbu	a0,0(s2)
    800062e0:	f96d                	bnez	a0,800062d2 <printf+0x170>
    800062e2:	bf29                	j	800061fc <printf+0x9a>
        s = "(null)";
    800062e4:	00002917          	auipc	s2,0x2
    800062e8:	61490913          	addi	s2,s2,1556 # 800088f8 <syscalls+0x4e0>
      for(; *s; s++)
    800062ec:	02800513          	li	a0,40
    800062f0:	b7cd                	j	800062d2 <printf+0x170>
      consputc('%');
    800062f2:	8556                	mv	a0,s5
    800062f4:	00000097          	auipc	ra,0x0
    800062f8:	b62080e7          	jalr	-1182(ra) # 80005e56 <consputc>
      break;
    800062fc:	b701                	j	800061fc <printf+0x9a>
      consputc('%');
    800062fe:	8556                	mv	a0,s5
    80006300:	00000097          	auipc	ra,0x0
    80006304:	b56080e7          	jalr	-1194(ra) # 80005e56 <consputc>
      consputc(c);
    80006308:	854a                	mv	a0,s2
    8000630a:	00000097          	auipc	ra,0x0
    8000630e:	b4c080e7          	jalr	-1204(ra) # 80005e56 <consputc>
      break;
    80006312:	b5ed                	j	800061fc <printf+0x9a>
  if(locking)
    80006314:	020d9163          	bnez	s11,80006336 <printf+0x1d4>
}
    80006318:	70e6                	ld	ra,120(sp)
    8000631a:	7446                	ld	s0,112(sp)
    8000631c:	74a6                	ld	s1,104(sp)
    8000631e:	7906                	ld	s2,96(sp)
    80006320:	69e6                	ld	s3,88(sp)
    80006322:	6a46                	ld	s4,80(sp)
    80006324:	6aa6                	ld	s5,72(sp)
    80006326:	6b06                	ld	s6,64(sp)
    80006328:	7be2                	ld	s7,56(sp)
    8000632a:	7c42                	ld	s8,48(sp)
    8000632c:	7ca2                	ld	s9,40(sp)
    8000632e:	7d02                	ld	s10,32(sp)
    80006330:	6de2                	ld	s11,24(sp)
    80006332:	6129                	addi	sp,sp,192
    80006334:	8082                	ret
    release(&pr.lock);
    80006336:	00020517          	auipc	a0,0x20
    8000633a:	eb250513          	addi	a0,a0,-334 # 800261e8 <pr>
    8000633e:	00000097          	auipc	ra,0x0
    80006342:	3d8080e7          	jalr	984(ra) # 80006716 <release>
}
    80006346:	bfc9                	j	80006318 <printf+0x1b6>

0000000080006348 <printfinit>:
    ;
}

void
printfinit(void)
{
    80006348:	1101                	addi	sp,sp,-32
    8000634a:	ec06                	sd	ra,24(sp)
    8000634c:	e822                	sd	s0,16(sp)
    8000634e:	e426                	sd	s1,8(sp)
    80006350:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80006352:	00020497          	auipc	s1,0x20
    80006356:	e9648493          	addi	s1,s1,-362 # 800261e8 <pr>
    8000635a:	00002597          	auipc	a1,0x2
    8000635e:	5b658593          	addi	a1,a1,1462 # 80008910 <syscalls+0x4f8>
    80006362:	8526                	mv	a0,s1
    80006364:	00000097          	auipc	ra,0x0
    80006368:	26e080e7          	jalr	622(ra) # 800065d2 <initlock>
  pr.locking = 1;
    8000636c:	4785                	li	a5,1
    8000636e:	cc9c                	sw	a5,24(s1)
}
    80006370:	60e2                	ld	ra,24(sp)
    80006372:	6442                	ld	s0,16(sp)
    80006374:	64a2                	ld	s1,8(sp)
    80006376:	6105                	addi	sp,sp,32
    80006378:	8082                	ret

000000008000637a <uartinit>:

void uartstart();

void
uartinit(void)
{
    8000637a:	1141                	addi	sp,sp,-16
    8000637c:	e406                	sd	ra,8(sp)
    8000637e:	e022                	sd	s0,0(sp)
    80006380:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80006382:	100007b7          	lui	a5,0x10000
    80006386:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    8000638a:	f8000713          	li	a4,-128
    8000638e:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80006392:	470d                	li	a4,3
    80006394:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80006398:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    8000639c:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800063a0:	469d                	li	a3,7
    800063a2:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800063a6:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    800063aa:	00002597          	auipc	a1,0x2
    800063ae:	58658593          	addi	a1,a1,1414 # 80008930 <digits+0x18>
    800063b2:	00020517          	auipc	a0,0x20
    800063b6:	e5650513          	addi	a0,a0,-426 # 80026208 <uart_tx_lock>
    800063ba:	00000097          	auipc	ra,0x0
    800063be:	218080e7          	jalr	536(ra) # 800065d2 <initlock>
}
    800063c2:	60a2                	ld	ra,8(sp)
    800063c4:	6402                	ld	s0,0(sp)
    800063c6:	0141                	addi	sp,sp,16
    800063c8:	8082                	ret

00000000800063ca <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800063ca:	1101                	addi	sp,sp,-32
    800063cc:	ec06                	sd	ra,24(sp)
    800063ce:	e822                	sd	s0,16(sp)
    800063d0:	e426                	sd	s1,8(sp)
    800063d2:	1000                	addi	s0,sp,32
    800063d4:	84aa                	mv	s1,a0
  push_off();
    800063d6:	00000097          	auipc	ra,0x0
    800063da:	240080e7          	jalr	576(ra) # 80006616 <push_off>

  if(panicked){
    800063de:	00003797          	auipc	a5,0x3
    800063e2:	c3e7a783          	lw	a5,-962(a5) # 8000901c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800063e6:	10000737          	lui	a4,0x10000
  if(panicked){
    800063ea:	c391                	beqz	a5,800063ee <uartputc_sync+0x24>
    for(;;)
    800063ec:	a001                	j	800063ec <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800063ee:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    800063f2:	0ff7f793          	andi	a5,a5,255
    800063f6:	0207f793          	andi	a5,a5,32
    800063fa:	dbf5                	beqz	a5,800063ee <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    800063fc:	0ff4f793          	andi	a5,s1,255
    80006400:	10000737          	lui	a4,0x10000
    80006404:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    80006408:	00000097          	auipc	ra,0x0
    8000640c:	2ae080e7          	jalr	686(ra) # 800066b6 <pop_off>
}
    80006410:	60e2                	ld	ra,24(sp)
    80006412:	6442                	ld	s0,16(sp)
    80006414:	64a2                	ld	s1,8(sp)
    80006416:	6105                	addi	sp,sp,32
    80006418:	8082                	ret

000000008000641a <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    8000641a:	00003717          	auipc	a4,0x3
    8000641e:	c0673703          	ld	a4,-1018(a4) # 80009020 <uart_tx_r>
    80006422:	00003797          	auipc	a5,0x3
    80006426:	c067b783          	ld	a5,-1018(a5) # 80009028 <uart_tx_w>
    8000642a:	06e78c63          	beq	a5,a4,800064a2 <uartstart+0x88>
{
    8000642e:	7139                	addi	sp,sp,-64
    80006430:	fc06                	sd	ra,56(sp)
    80006432:	f822                	sd	s0,48(sp)
    80006434:	f426                	sd	s1,40(sp)
    80006436:	f04a                	sd	s2,32(sp)
    80006438:	ec4e                	sd	s3,24(sp)
    8000643a:	e852                	sd	s4,16(sp)
    8000643c:	e456                	sd	s5,8(sp)
    8000643e:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006440:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006444:	00020a17          	auipc	s4,0x20
    80006448:	dc4a0a13          	addi	s4,s4,-572 # 80026208 <uart_tx_lock>
    uart_tx_r += 1;
    8000644c:	00003497          	auipc	s1,0x3
    80006450:	bd448493          	addi	s1,s1,-1068 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80006454:	00003997          	auipc	s3,0x3
    80006458:	bd498993          	addi	s3,s3,-1068 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000645c:	00594783          	lbu	a5,5(s2) # 10000005 <_entry-0x6ffffffb>
    80006460:	0ff7f793          	andi	a5,a5,255
    80006464:	0207f793          	andi	a5,a5,32
    80006468:	c785                	beqz	a5,80006490 <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000646a:	01f77793          	andi	a5,a4,31
    8000646e:	97d2                	add	a5,a5,s4
    80006470:	0187ca83          	lbu	s5,24(a5)
    uart_tx_r += 1;
    80006474:	0705                	addi	a4,a4,1
    80006476:	e098                	sd	a4,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80006478:	8526                	mv	a0,s1
    8000647a:	ffffb097          	auipc	ra,0xffffb
    8000647e:	4c2080e7          	jalr	1218(ra) # 8000193c <wakeup>
    
    WriteReg(THR, c);
    80006482:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80006486:	6098                	ld	a4,0(s1)
    80006488:	0009b783          	ld	a5,0(s3)
    8000648c:	fce798e3          	bne	a5,a4,8000645c <uartstart+0x42>
  }
}
    80006490:	70e2                	ld	ra,56(sp)
    80006492:	7442                	ld	s0,48(sp)
    80006494:	74a2                	ld	s1,40(sp)
    80006496:	7902                	ld	s2,32(sp)
    80006498:	69e2                	ld	s3,24(sp)
    8000649a:	6a42                	ld	s4,16(sp)
    8000649c:	6aa2                	ld	s5,8(sp)
    8000649e:	6121                	addi	sp,sp,64
    800064a0:	8082                	ret
    800064a2:	8082                	ret

00000000800064a4 <uartputc>:
{
    800064a4:	7179                	addi	sp,sp,-48
    800064a6:	f406                	sd	ra,40(sp)
    800064a8:	f022                	sd	s0,32(sp)
    800064aa:	ec26                	sd	s1,24(sp)
    800064ac:	e84a                	sd	s2,16(sp)
    800064ae:	e44e                	sd	s3,8(sp)
    800064b0:	e052                	sd	s4,0(sp)
    800064b2:	1800                	addi	s0,sp,48
    800064b4:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    800064b6:	00020517          	auipc	a0,0x20
    800064ba:	d5250513          	addi	a0,a0,-686 # 80026208 <uart_tx_lock>
    800064be:	00000097          	auipc	ra,0x0
    800064c2:	1a4080e7          	jalr	420(ra) # 80006662 <acquire>
  if(panicked){
    800064c6:	00003797          	auipc	a5,0x3
    800064ca:	b567a783          	lw	a5,-1194(a5) # 8000901c <panicked>
    800064ce:	c391                	beqz	a5,800064d2 <uartputc+0x2e>
    for(;;)
    800064d0:	a001                	j	800064d0 <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800064d2:	00003797          	auipc	a5,0x3
    800064d6:	b567b783          	ld	a5,-1194(a5) # 80009028 <uart_tx_w>
    800064da:	00003717          	auipc	a4,0x3
    800064de:	b4673703          	ld	a4,-1210(a4) # 80009020 <uart_tx_r>
    800064e2:	02070713          	addi	a4,a4,32
    800064e6:	02f71b63          	bne	a4,a5,8000651c <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    800064ea:	00020a17          	auipc	s4,0x20
    800064ee:	d1ea0a13          	addi	s4,s4,-738 # 80026208 <uart_tx_lock>
    800064f2:	00003497          	auipc	s1,0x3
    800064f6:	b2e48493          	addi	s1,s1,-1234 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800064fa:	00003917          	auipc	s2,0x3
    800064fe:	b2e90913          	addi	s2,s2,-1234 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    80006502:	85d2                	mv	a1,s4
    80006504:	8526                	mv	a0,s1
    80006506:	ffffb097          	auipc	ra,0xffffb
    8000650a:	2aa080e7          	jalr	682(ra) # 800017b0 <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000650e:	00093783          	ld	a5,0(s2)
    80006512:	6098                	ld	a4,0(s1)
    80006514:	02070713          	addi	a4,a4,32
    80006518:	fef705e3          	beq	a4,a5,80006502 <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    8000651c:	00020497          	auipc	s1,0x20
    80006520:	cec48493          	addi	s1,s1,-788 # 80026208 <uart_tx_lock>
    80006524:	01f7f713          	andi	a4,a5,31
    80006528:	9726                	add	a4,a4,s1
    8000652a:	01370c23          	sb	s3,24(a4)
      uart_tx_w += 1;
    8000652e:	0785                	addi	a5,a5,1
    80006530:	00003717          	auipc	a4,0x3
    80006534:	aef73c23          	sd	a5,-1288(a4) # 80009028 <uart_tx_w>
      uartstart();
    80006538:	00000097          	auipc	ra,0x0
    8000653c:	ee2080e7          	jalr	-286(ra) # 8000641a <uartstart>
      release(&uart_tx_lock);
    80006540:	8526                	mv	a0,s1
    80006542:	00000097          	auipc	ra,0x0
    80006546:	1d4080e7          	jalr	468(ra) # 80006716 <release>
}
    8000654a:	70a2                	ld	ra,40(sp)
    8000654c:	7402                	ld	s0,32(sp)
    8000654e:	64e2                	ld	s1,24(sp)
    80006550:	6942                	ld	s2,16(sp)
    80006552:	69a2                	ld	s3,8(sp)
    80006554:	6a02                	ld	s4,0(sp)
    80006556:	6145                	addi	sp,sp,48
    80006558:	8082                	ret

000000008000655a <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    8000655a:	1141                	addi	sp,sp,-16
    8000655c:	e422                	sd	s0,8(sp)
    8000655e:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80006560:	100007b7          	lui	a5,0x10000
    80006564:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80006568:	8b85                	andi	a5,a5,1
    8000656a:	cb91                	beqz	a5,8000657e <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    8000656c:	100007b7          	lui	a5,0x10000
    80006570:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    80006574:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    80006578:	6422                	ld	s0,8(sp)
    8000657a:	0141                	addi	sp,sp,16
    8000657c:	8082                	ret
    return -1;
    8000657e:	557d                	li	a0,-1
    80006580:	bfe5                	j	80006578 <uartgetc+0x1e>

0000000080006582 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    80006582:	1101                	addi	sp,sp,-32
    80006584:	ec06                	sd	ra,24(sp)
    80006586:	e822                	sd	s0,16(sp)
    80006588:	e426                	sd	s1,8(sp)
    8000658a:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    8000658c:	54fd                	li	s1,-1
    int c = uartgetc();
    8000658e:	00000097          	auipc	ra,0x0
    80006592:	fcc080e7          	jalr	-52(ra) # 8000655a <uartgetc>
    if(c == -1)
    80006596:	00950763          	beq	a0,s1,800065a4 <uartintr+0x22>
      break;
    consoleintr(c);
    8000659a:	00000097          	auipc	ra,0x0
    8000659e:	8fe080e7          	jalr	-1794(ra) # 80005e98 <consoleintr>
  while(1){
    800065a2:	b7f5                	j	8000658e <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800065a4:	00020497          	auipc	s1,0x20
    800065a8:	c6448493          	addi	s1,s1,-924 # 80026208 <uart_tx_lock>
    800065ac:	8526                	mv	a0,s1
    800065ae:	00000097          	auipc	ra,0x0
    800065b2:	0b4080e7          	jalr	180(ra) # 80006662 <acquire>
  uartstart();
    800065b6:	00000097          	auipc	ra,0x0
    800065ba:	e64080e7          	jalr	-412(ra) # 8000641a <uartstart>
  release(&uart_tx_lock);
    800065be:	8526                	mv	a0,s1
    800065c0:	00000097          	auipc	ra,0x0
    800065c4:	156080e7          	jalr	342(ra) # 80006716 <release>
}
    800065c8:	60e2                	ld	ra,24(sp)
    800065ca:	6442                	ld	s0,16(sp)
    800065cc:	64a2                	ld	s1,8(sp)
    800065ce:	6105                	addi	sp,sp,32
    800065d0:	8082                	ret

00000000800065d2 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    800065d2:	1141                	addi	sp,sp,-16
    800065d4:	e422                	sd	s0,8(sp)
    800065d6:	0800                	addi	s0,sp,16
  lk->name = name;
    800065d8:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    800065da:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    800065de:	00053823          	sd	zero,16(a0)
}
    800065e2:	6422                	ld	s0,8(sp)
    800065e4:	0141                	addi	sp,sp,16
    800065e6:	8082                	ret

00000000800065e8 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    800065e8:	411c                	lw	a5,0(a0)
    800065ea:	e399                	bnez	a5,800065f0 <holding+0x8>
    800065ec:	4501                	li	a0,0
  return r;
}
    800065ee:	8082                	ret
{
    800065f0:	1101                	addi	sp,sp,-32
    800065f2:	ec06                	sd	ra,24(sp)
    800065f4:	e822                	sd	s0,16(sp)
    800065f6:	e426                	sd	s1,8(sp)
    800065f8:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    800065fa:	6904                	ld	s1,16(a0)
    800065fc:	ffffb097          	auipc	ra,0xffffb
    80006600:	adc080e7          	jalr	-1316(ra) # 800010d8 <mycpu>
    80006604:	40a48533          	sub	a0,s1,a0
    80006608:	00153513          	seqz	a0,a0
}
    8000660c:	60e2                	ld	ra,24(sp)
    8000660e:	6442                	ld	s0,16(sp)
    80006610:	64a2                	ld	s1,8(sp)
    80006612:	6105                	addi	sp,sp,32
    80006614:	8082                	ret

0000000080006616 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006616:	1101                	addi	sp,sp,-32
    80006618:	ec06                	sd	ra,24(sp)
    8000661a:	e822                	sd	s0,16(sp)
    8000661c:	e426                	sd	s1,8(sp)
    8000661e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006620:	100024f3          	csrr	s1,sstatus
    80006624:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80006628:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000662a:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    8000662e:	ffffb097          	auipc	ra,0xffffb
    80006632:	aaa080e7          	jalr	-1366(ra) # 800010d8 <mycpu>
    80006636:	5d3c                	lw	a5,120(a0)
    80006638:	cf89                	beqz	a5,80006652 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    8000663a:	ffffb097          	auipc	ra,0xffffb
    8000663e:	a9e080e7          	jalr	-1378(ra) # 800010d8 <mycpu>
    80006642:	5d3c                	lw	a5,120(a0)
    80006644:	2785                	addiw	a5,a5,1
    80006646:	dd3c                	sw	a5,120(a0)
}
    80006648:	60e2                	ld	ra,24(sp)
    8000664a:	6442                	ld	s0,16(sp)
    8000664c:	64a2                	ld	s1,8(sp)
    8000664e:	6105                	addi	sp,sp,32
    80006650:	8082                	ret
    mycpu()->intena = old;
    80006652:	ffffb097          	auipc	ra,0xffffb
    80006656:	a86080e7          	jalr	-1402(ra) # 800010d8 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    8000665a:	8085                	srli	s1,s1,0x1
    8000665c:	8885                	andi	s1,s1,1
    8000665e:	dd64                	sw	s1,124(a0)
    80006660:	bfe9                	j	8000663a <push_off+0x24>

0000000080006662 <acquire>:
{
    80006662:	1101                	addi	sp,sp,-32
    80006664:	ec06                	sd	ra,24(sp)
    80006666:	e822                	sd	s0,16(sp)
    80006668:	e426                	sd	s1,8(sp)
    8000666a:	1000                	addi	s0,sp,32
    8000666c:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    8000666e:	00000097          	auipc	ra,0x0
    80006672:	fa8080e7          	jalr	-88(ra) # 80006616 <push_off>
  if(holding(lk))
    80006676:	8526                	mv	a0,s1
    80006678:	00000097          	auipc	ra,0x0
    8000667c:	f70080e7          	jalr	-144(ra) # 800065e8 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006680:	4705                	li	a4,1
  if(holding(lk))
    80006682:	e115                	bnez	a0,800066a6 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006684:	87ba                	mv	a5,a4
    80006686:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    8000668a:	2781                	sext.w	a5,a5
    8000668c:	ffe5                	bnez	a5,80006684 <acquire+0x22>
  __sync_synchronize();
    8000668e:	0ff0000f          	fence
  lk->cpu = mycpu();
    80006692:	ffffb097          	auipc	ra,0xffffb
    80006696:	a46080e7          	jalr	-1466(ra) # 800010d8 <mycpu>
    8000669a:	e888                	sd	a0,16(s1)
}
    8000669c:	60e2                	ld	ra,24(sp)
    8000669e:	6442                	ld	s0,16(sp)
    800066a0:	64a2                	ld	s1,8(sp)
    800066a2:	6105                	addi	sp,sp,32
    800066a4:	8082                	ret
    panic("acquire");
    800066a6:	00002517          	auipc	a0,0x2
    800066aa:	29250513          	addi	a0,a0,658 # 80008938 <digits+0x20>
    800066ae:	00000097          	auipc	ra,0x0
    800066b2:	a6a080e7          	jalr	-1430(ra) # 80006118 <panic>

00000000800066b6 <pop_off>:

void
pop_off(void)
{
    800066b6:	1141                	addi	sp,sp,-16
    800066b8:	e406                	sd	ra,8(sp)
    800066ba:	e022                	sd	s0,0(sp)
    800066bc:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    800066be:	ffffb097          	auipc	ra,0xffffb
    800066c2:	a1a080e7          	jalr	-1510(ra) # 800010d8 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800066c6:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800066ca:	8b89                	andi	a5,a5,2
  if(intr_get())
    800066cc:	e78d                	bnez	a5,800066f6 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    800066ce:	5d3c                	lw	a5,120(a0)
    800066d0:	02f05b63          	blez	a5,80006706 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    800066d4:	37fd                	addiw	a5,a5,-1
    800066d6:	0007871b          	sext.w	a4,a5
    800066da:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    800066dc:	eb09                	bnez	a4,800066ee <pop_off+0x38>
    800066de:	5d7c                	lw	a5,124(a0)
    800066e0:	c799                	beqz	a5,800066ee <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800066e2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800066e6:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800066ea:	10079073          	csrw	sstatus,a5
    intr_on();
}
    800066ee:	60a2                	ld	ra,8(sp)
    800066f0:	6402                	ld	s0,0(sp)
    800066f2:	0141                	addi	sp,sp,16
    800066f4:	8082                	ret
    panic("pop_off - interruptible");
    800066f6:	00002517          	auipc	a0,0x2
    800066fa:	24a50513          	addi	a0,a0,586 # 80008940 <digits+0x28>
    800066fe:	00000097          	auipc	ra,0x0
    80006702:	a1a080e7          	jalr	-1510(ra) # 80006118 <panic>
    panic("pop_off");
    80006706:	00002517          	auipc	a0,0x2
    8000670a:	25250513          	addi	a0,a0,594 # 80008958 <digits+0x40>
    8000670e:	00000097          	auipc	ra,0x0
    80006712:	a0a080e7          	jalr	-1526(ra) # 80006118 <panic>

0000000080006716 <release>:
{
    80006716:	1101                	addi	sp,sp,-32
    80006718:	ec06                	sd	ra,24(sp)
    8000671a:	e822                	sd	s0,16(sp)
    8000671c:	e426                	sd	s1,8(sp)
    8000671e:	1000                	addi	s0,sp,32
    80006720:	84aa                	mv	s1,a0
  if(!holding(lk))
    80006722:	00000097          	auipc	ra,0x0
    80006726:	ec6080e7          	jalr	-314(ra) # 800065e8 <holding>
    8000672a:	c115                	beqz	a0,8000674e <release+0x38>
  lk->cpu = 0;
    8000672c:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80006730:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80006734:	0f50000f          	fence	iorw,ow
    80006738:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    8000673c:	00000097          	auipc	ra,0x0
    80006740:	f7a080e7          	jalr	-134(ra) # 800066b6 <pop_off>
}
    80006744:	60e2                	ld	ra,24(sp)
    80006746:	6442                	ld	s0,16(sp)
    80006748:	64a2                	ld	s1,8(sp)
    8000674a:	6105                	addi	sp,sp,32
    8000674c:	8082                	ret
    panic("release");
    8000674e:	00002517          	auipc	a0,0x2
    80006752:	21250513          	addi	a0,a0,530 # 80008960 <digits+0x48>
    80006756:	00000097          	auipc	ra,0x0
    8000675a:	9c2080e7          	jalr	-1598(ra) # 80006118 <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051573          	csrrw	a0,sscratch,a0
    80007004:	02153423          	sd	ra,40(a0)
    80007008:	02253823          	sd	sp,48(a0)
    8000700c:	02353c23          	sd	gp,56(a0)
    80007010:	04453023          	sd	tp,64(a0)
    80007014:	04553423          	sd	t0,72(a0)
    80007018:	04653823          	sd	t1,80(a0)
    8000701c:	04753c23          	sd	t2,88(a0)
    80007020:	f120                	sd	s0,96(a0)
    80007022:	f524                	sd	s1,104(a0)
    80007024:	fd2c                	sd	a1,120(a0)
    80007026:	e150                	sd	a2,128(a0)
    80007028:	e554                	sd	a3,136(a0)
    8000702a:	e958                	sd	a4,144(a0)
    8000702c:	ed5c                	sd	a5,152(a0)
    8000702e:	0b053023          	sd	a6,160(a0)
    80007032:	0b153423          	sd	a7,168(a0)
    80007036:	0b253823          	sd	s2,176(a0)
    8000703a:	0b353c23          	sd	s3,184(a0)
    8000703e:	0d453023          	sd	s4,192(a0)
    80007042:	0d553423          	sd	s5,200(a0)
    80007046:	0d653823          	sd	s6,208(a0)
    8000704a:	0d753c23          	sd	s7,216(a0)
    8000704e:	0f853023          	sd	s8,224(a0)
    80007052:	0f953423          	sd	s9,232(a0)
    80007056:	0fa53823          	sd	s10,240(a0)
    8000705a:	0fb53c23          	sd	s11,248(a0)
    8000705e:	11c53023          	sd	t3,256(a0)
    80007062:	11d53423          	sd	t4,264(a0)
    80007066:	11e53823          	sd	t5,272(a0)
    8000706a:	11f53c23          	sd	t6,280(a0)
    8000706e:	140022f3          	csrr	t0,sscratch
    80007072:	06553823          	sd	t0,112(a0)
    80007076:	00853103          	ld	sp,8(a0)
    8000707a:	02053203          	ld	tp,32(a0)
    8000707e:	01053283          	ld	t0,16(a0)
    80007082:	00053303          	ld	t1,0(a0)
    80007086:	18031073          	csrw	satp,t1
    8000708a:	12000073          	sfence.vma
    8000708e:	8282                	jr	t0

0000000080007090 <userret>:
    80007090:	18059073          	csrw	satp,a1
    80007094:	12000073          	sfence.vma
    80007098:	07053283          	ld	t0,112(a0)
    8000709c:	14029073          	csrw	sscratch,t0
    800070a0:	02853083          	ld	ra,40(a0)
    800070a4:	03053103          	ld	sp,48(a0)
    800070a8:	03853183          	ld	gp,56(a0)
    800070ac:	04053203          	ld	tp,64(a0)
    800070b0:	04853283          	ld	t0,72(a0)
    800070b4:	05053303          	ld	t1,80(a0)
    800070b8:	05853383          	ld	t2,88(a0)
    800070bc:	7120                	ld	s0,96(a0)
    800070be:	7524                	ld	s1,104(a0)
    800070c0:	7d2c                	ld	a1,120(a0)
    800070c2:	6150                	ld	a2,128(a0)
    800070c4:	6554                	ld	a3,136(a0)
    800070c6:	6958                	ld	a4,144(a0)
    800070c8:	6d5c                	ld	a5,152(a0)
    800070ca:	0a053803          	ld	a6,160(a0)
    800070ce:	0a853883          	ld	a7,168(a0)
    800070d2:	0b053903          	ld	s2,176(a0)
    800070d6:	0b853983          	ld	s3,184(a0)
    800070da:	0c053a03          	ld	s4,192(a0)
    800070de:	0c853a83          	ld	s5,200(a0)
    800070e2:	0d053b03          	ld	s6,208(a0)
    800070e6:	0d853b83          	ld	s7,216(a0)
    800070ea:	0e053c03          	ld	s8,224(a0)
    800070ee:	0e853c83          	ld	s9,232(a0)
    800070f2:	0f053d03          	ld	s10,240(a0)
    800070f6:	0f853d83          	ld	s11,248(a0)
    800070fa:	10053e03          	ld	t3,256(a0)
    800070fe:	10853e83          	ld	t4,264(a0)
    80007102:	11053f03          	ld	t5,272(a0)
    80007106:	11853f83          	ld	t6,280(a0)
    8000710a:	14051573          	csrrw	a0,sscratch,a0
    8000710e:	10200073          	sret
	...
