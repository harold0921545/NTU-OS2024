
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	a1013103          	ld	sp,-1520(sp) # 80008a10 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	75b050ef          	jal	ra,80005f70 <start>

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
    8000005a:	00007097          	auipc	ra,0x7
    8000005e:	910080e7          	jalr	-1776(ra) # 8000696a <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00007097          	auipc	ra,0x7
    80000072:	9b0080e7          	jalr	-1616(ra) # 80006a1e <release>
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
    8000008e:	396080e7          	jalr	918(ra) # 80006420 <panic>

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
    800000f8:	7e6080e7          	jalr	2022(ra) # 800068da <initlock>
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
    8000012c:	00007097          	auipc	ra,0x7
    80000130:	83e080e7          	jalr	-1986(ra) # 8000696a <acquire>
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
    80000144:	00007097          	auipc	ra,0x7
    80000148:	8da080e7          	jalr	-1830(ra) # 80006a1e <release>

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
    8000016e:	00007097          	auipc	ra,0x7
    80000172:	8b0080e7          	jalr	-1872(ra) # 80006a1e <release>
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
    80000332:	f7c080e7          	jalr	-132(ra) # 800012aa <cpuid>
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
    8000034e:	f60080e7          	jalr	-160(ra) # 800012aa <cpuid>
    80000352:	85aa                	mv	a1,a0
    80000354:	00008517          	auipc	a0,0x8
    80000358:	ce450513          	addi	a0,a0,-796 # 80008038 <etext+0x38>
    8000035c:	00006097          	auipc	ra,0x6
    80000360:	10e080e7          	jalr	270(ra) # 8000646a <printf>
    kvminithart();    // turn on paging
    80000364:	00000097          	auipc	ra,0x0
    80000368:	0d8080e7          	jalr	216(ra) # 8000043c <kvminithart>
    trapinithart();   // install kernel trap vector
    8000036c:	00002097          	auipc	ra,0x2
    80000370:	bb6080e7          	jalr	-1098(ra) # 80001f22 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000374:	00005097          	auipc	ra,0x5
    80000378:	36c080e7          	jalr	876(ra) # 800056e0 <plicinithart>
  }

  scheduler();
    8000037c:	00001097          	auipc	ra,0x1
    80000380:	464080e7          	jalr	1124(ra) # 800017e0 <scheduler>
    consoleinit();
    80000384:	00006097          	auipc	ra,0x6
    80000388:	fae080e7          	jalr	-82(ra) # 80006332 <consoleinit>
    printfinit();
    8000038c:	00006097          	auipc	ra,0x6
    80000390:	2c4080e7          	jalr	708(ra) # 80006650 <printfinit>
    printf("\n");
    80000394:	00008517          	auipc	a0,0x8
    80000398:	cb450513          	addi	a0,a0,-844 # 80008048 <etext+0x48>
    8000039c:	00006097          	auipc	ra,0x6
    800003a0:	0ce080e7          	jalr	206(ra) # 8000646a <printf>
    printf("xv6 kernel is booting\n");
    800003a4:	00008517          	auipc	a0,0x8
    800003a8:	c7c50513          	addi	a0,a0,-900 # 80008020 <etext+0x20>
    800003ac:	00006097          	auipc	ra,0x6
    800003b0:	0be080e7          	jalr	190(ra) # 8000646a <printf>
    printf("\n");
    800003b4:	00008517          	auipc	a0,0x8
    800003b8:	c9450513          	addi	a0,a0,-876 # 80008048 <etext+0x48>
    800003bc:	00006097          	auipc	ra,0x6
    800003c0:	0ae080e7          	jalr	174(ra) # 8000646a <printf>
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
    800003e0:	e20080e7          	jalr	-480(ra) # 800011fc <procinit>
    trapinit();      // trap vectors
    800003e4:	00002097          	auipc	ra,0x2
    800003e8:	b16080e7          	jalr	-1258(ra) # 80001efa <trapinit>
    trapinithart();  // install kernel trap vector
    800003ec:	00002097          	auipc	ra,0x2
    800003f0:	b36080e7          	jalr	-1226(ra) # 80001f22 <trapinithart>
    plicinit();      // set up interrupt controller
    800003f4:	00005097          	auipc	ra,0x5
    800003f8:	2d6080e7          	jalr	726(ra) # 800056ca <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003fc:	00005097          	auipc	ra,0x5
    80000400:	2e4080e7          	jalr	740(ra) # 800056e0 <plicinithart>
    binit();         // buffer cache
    80000404:	00002097          	auipc	ra,0x2
    80000408:	360080e7          	jalr	864(ra) # 80002764 <binit>
    iinit();         // inode table
    8000040c:	00003097          	auipc	ra,0x3
    80000410:	9e0080e7          	jalr	-1568(ra) # 80002dec <iinit>
    fileinit();      // file table
    80000414:	00004097          	auipc	ra,0x4
    80000418:	b00080e7          	jalr	-1280(ra) # 80003f14 <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000041c:	00005097          	auipc	ra,0x5
    80000420:	3e6080e7          	jalr	998(ra) # 80005802 <virtio_disk_init>
    userinit();      // first user process
    80000424:	00001097          	auipc	ra,0x1
    80000428:	18a080e7          	jalr	394(ra) # 800015ae <userinit>
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
    80000492:	f92080e7          	jalr	-110(ra) # 80006420 <panic>
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
    8000058a:	e9a080e7          	jalr	-358(ra) # 80006420 <panic>
      panic("mappages: remap");
    8000058e:	00008517          	auipc	a0,0x8
    80000592:	ada50513          	addi	a0,a0,-1318 # 80008068 <etext+0x68>
    80000596:	00006097          	auipc	ra,0x6
    8000059a:	e8a080e7          	jalr	-374(ra) # 80006420 <panic>
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
    80000614:	e10080e7          	jalr	-496(ra) # 80006420 <panic>

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
    800006dc:	a90080e7          	jalr	-1392(ra) # 80001168 <proc_mapstacks>
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
    80000760:	cc4080e7          	jalr	-828(ra) # 80006420 <panic>
      panic("uvmunmap: walk");
    80000764:	00008517          	auipc	a0,0x8
    80000768:	93450513          	addi	a0,a0,-1740 # 80008098 <etext+0x98>
    8000076c:	00006097          	auipc	ra,0x6
    80000770:	cb4080e7          	jalr	-844(ra) # 80006420 <panic>
      panic("uvmunmap: not a leaf");
    80000774:	00008517          	auipc	a0,0x8
    80000778:	93450513          	addi	a0,a0,-1740 # 800080a8 <etext+0xa8>
    8000077c:	00006097          	auipc	ra,0x6
    80000780:	ca4080e7          	jalr	-860(ra) # 80006420 <panic>
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
    80000866:	bbe080e7          	jalr	-1090(ra) # 80006420 <panic>

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
    800009a4:	00006097          	auipc	ra,0x6
    800009a8:	a7c080e7          	jalr	-1412(ra) # 80006420 <panic>
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
    80000a80:	00006097          	auipc	ra,0x6
    80000a84:	9a0080e7          	jalr	-1632(ra) # 80006420 <panic>
      panic("uvmcopy: page not present");
    80000a88:	00007517          	auipc	a0,0x7
    80000a8c:	68850513          	addi	a0,a0,1672 # 80008110 <etext+0x110>
    80000a90:	00006097          	auipc	ra,0x6
    80000a94:	990080e7          	jalr	-1648(ra) # 80006420 <panic>
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
    80000afa:	00006097          	auipc	ra,0x6
    80000afe:	926080e7          	jalr	-1754(ra) # 80006420 <panic>

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
    80000cce:	715d                	addi	sp,sp,-80
    80000cd0:	e486                	sd	ra,72(sp)
    80000cd2:	e0a2                	sd	s0,64(sp)
    80000cd4:	fc26                	sd	s1,56(sp)
    80000cd6:	f84a                	sd	s2,48(sp)
    80000cd8:	f44e                	sd	s3,40(sp)
    80000cda:	f052                	sd	s4,32(sp)
    80000cdc:	ec56                	sd	s5,24(sp)
    80000cde:	e85a                	sd	s6,16(sp)
    80000ce0:	e45e                	sd	s7,8(sp)
    80000ce2:	0880                	addi	s0,sp,80
    80000ce4:	84aa                	mv	s1,a0
    80000ce6:	892e                	mv	s2,a1
    80000ce8:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80000cea:	00000097          	auipc	ra,0x0
    80000cee:	5ec080e7          	jalr	1516(ra) # 800012d6 <myproc>
  pagetable_t pgtbl = p->pagetable;

  if (base > p->sz || (base + len) > p->sz) {
    80000cf2:	6538                	ld	a4,72(a0)
    80000cf4:	12976963          	bltu	a4,s1,80000e26 <madvise+0x158>
    80000cf8:	87aa                	mv	a5,a0
    80000cfa:	012486b3          	add	a3,s1,s2
    return -1;
    80000cfe:	557d                	li	a0,-1
  if (base > p->sz || (base + len) > p->sz) {
    80000d00:	12d76463          	bltu	a4,a3,80000e28 <madvise+0x15a>
  }

  if (len == 0) {
    return 0;
    80000d04:	4501                	li	a0,0
  if (len == 0) {
    80000d06:	12090163          	beqz	s2,80000e28 <madvise+0x15a>
  pagetable_t pgtbl = p->pagetable;
    80000d0a:	0507ba03          	ld	s4,80(a5)
  }

  uint64 begin = PGROUNDDOWN(base);
    80000d0e:	7afd                	lui	s5,0xfffff
    80000d10:	0154f4b3          	and	s1,s1,s5
  uint64 last = PGROUNDDOWN(base + len - 1);
    80000d14:	16fd                	addi	a3,a3,-1
    80000d16:	0156fab3          	and	s5,a3,s5

  if (advice == MADV_NORMAL) {
    80000d1a:	02099763          	bnez	s3,80000d48 <madvise+0x7a>
    pte_t *pte;
    for (uint64 va = begin; va <= last; va += PGSIZE) {
    80000d1e:	129ae063          	bltu	s5,s1,80000e3e <madvise+0x170>
    80000d22:	6905                	lui	s2,0x1
      pte = walk(pgtbl, va, 0);
    80000d24:	4601                	li	a2,0
    80000d26:	85a6                	mv	a1,s1
    80000d28:	8552                	mv	a0,s4
    80000d2a:	fffff097          	auipc	ra,0xfffff
    80000d2e:	736080e7          	jalr	1846(ra) # 80000460 <walk>
      if (pte == 0 || (*pte & PTE_V) == 0)
    80000d32:	10050863          	beqz	a0,80000e42 <madvise+0x174>
    80000d36:	611c                	ld	a5,0(a0)
    80000d38:	8b85                	andi	a5,a5,1
    80000d3a:	10078663          	beqz	a5,80000e46 <madvise+0x178>
    for (uint64 va = begin; va <= last; va += PGSIZE) {
    80000d3e:	94ca                	add	s1,s1,s2
    80000d40:	fe9af2e3          	bgeu	s5,s1,80000d24 <madvise+0x56>
        return -1;
    }
    return 0;
    80000d44:	854e                	mv	a0,s3
    80000d46:	a0cd                	j	80000e28 <madvise+0x15a>
  } else if (advice == MADV_WILLNEED) {
    80000d48:	4785                	li	a5,1
    80000d4a:	00f98963          	beq	s3,a5,80000d5c <madvise+0x8e>
        bfree_page(ROOTDEV, blockno);

        *pte = (PA2PTE(pa) | PTE_FLAGS(*pte) | PTE_V) & ~PTE_S;
      }
    }
  } else if (advice == MADV_DONTNEED) {
    80000d4e:	4789                	li	a5,2
    80000d50:	06f98f63          	beq	s3,a5,80000dce <madvise+0x100>
    #endif

    end_op();
    return 0;

  } else if(advice == MADV_PIN) {
    80000d54:	39f5                	addiw	s3,s3,-3
    80000d56:	4785                	li	a5,1
    // TODO
  } else if(advice == MADV_UNPIN) {
    // TODO
  }
  else {
    return -1;
    80000d58:	557d                	li	a0,-1
    80000d5a:	a0f9                	j	80000e28 <madvise+0x15a>
    for (uint64 va = begin; va <= last; va += PGSIZE) {
    80000d5c:	0c9ae663          	bltu	s5,s1,80000e28 <madvise+0x15a>
    80000d60:	6b05                	lui	s6,0x1
    80000d62:	a881                	j	80000db2 <madvise+0xe4>
        char *pa = kalloc();
    80000d64:	fffff097          	auipc	ra,0xfffff
    80000d68:	3b4080e7          	jalr	948(ra) # 80000118 <kalloc>
    80000d6c:	89aa                	mv	s3,a0
        uint blockno = PTE2BLOCKNO(*pte);
    80000d6e:	00093b83          	ld	s7,0(s2) # 1000 <_entry-0x7ffff000>
    80000d72:	00abdb93          	srli	s7,s7,0xa
    80000d76:	2b81                	sext.w	s7,s7
        read_page_from_disk(ROOTDEV, pa, blockno);
    80000d78:	865e                	mv	a2,s7
    80000d7a:	85aa                	mv	a1,a0
    80000d7c:	4505                	li	a0,1
    80000d7e:	00002097          	auipc	ra,0x2
    80000d82:	c62080e7          	jalr	-926(ra) # 800029e0 <read_page_from_disk>
        bfree_page(ROOTDEV, blockno);
    80000d86:	85de                	mv	a1,s7
    80000d88:	4505                	li	a0,1
    80000d8a:	00003097          	auipc	ra,0x3
    80000d8e:	b1e080e7          	jalr	-1250(ra) # 800038a8 <bfree_page>
        *pte = (PA2PTE(pa) | PTE_FLAGS(*pte) | PTE_V) & ~PTE_S;
    80000d92:	00c9d993          	srli	s3,s3,0xc
    80000d96:	09aa                	slli	s3,s3,0xa
    80000d98:	00093783          	ld	a5,0(s2)
    80000d9c:	1fe7f793          	andi	a5,a5,510
    80000da0:	0137e9b3          	or	s3,a5,s3
    80000da4:	0019e993          	ori	s3,s3,1
    80000da8:	01393023          	sd	s3,0(s2)
    for (uint64 va = begin; va <= last; va += PGSIZE) {
    80000dac:	94da                	add	s1,s1,s6
    80000dae:	069aed63          	bltu	s5,s1,80000e28 <madvise+0x15a>
      pte = walk(pgtbl, va, 0);
    80000db2:	4601                	li	a2,0
    80000db4:	85a6                	mv	a1,s1
    80000db6:	8552                	mv	a0,s4
    80000db8:	fffff097          	auipc	ra,0xfffff
    80000dbc:	6a8080e7          	jalr	1704(ra) # 80000460 <walk>
    80000dc0:	892a                	mv	s2,a0
      if (pte != 0 && (*pte & PTE_S)) {
    80000dc2:	d56d                	beqz	a0,80000dac <madvise+0xde>
    80000dc4:	611c                	ld	a5,0(a0)
    80000dc6:	2007f793          	andi	a5,a5,512
    80000dca:	d3ed                	beqz	a5,80000dac <madvise+0xde>
    80000dcc:	bf61                	j	80000d64 <madvise+0x96>
    begin_op();
    80000dce:	00003097          	auipc	ra,0x3
    80000dd2:	d5e080e7          	jalr	-674(ra) # 80003b2c <begin_op>
    for (uint64 va = begin; va <= last; va += PGSIZE) {
    80000dd6:	049ae263          	bltu	s5,s1,80000e1a <madvise+0x14c>
    80000dda:	6905                	lui	s2,0x1
    80000ddc:	a811                	j	80000df0 <madvise+0x122>
          end_op();
    80000dde:	00003097          	auipc	ra,0x3
    80000de2:	dce080e7          	jalr	-562(ra) # 80003bac <end_op>
          return -1;
    80000de6:	557d                	li	a0,-1
    80000de8:	a081                	j	80000e28 <madvise+0x15a>
    for (uint64 va = begin; va <= last; va += PGSIZE) {
    80000dea:	94ca                	add	s1,s1,s2
    80000dec:	029ae763          	bltu	s5,s1,80000e1a <madvise+0x14c>
      pte = walk(pgtbl, va, 0);
    80000df0:	4601                	li	a2,0
    80000df2:	85a6                	mv	a1,s1
    80000df4:	8552                	mv	a0,s4
    80000df6:	fffff097          	auipc	ra,0xfffff
    80000dfa:	66a080e7          	jalr	1642(ra) # 80000460 <walk>
      if (pte != 0 && (*pte & PTE_V)) {
    80000dfe:	d575                	beqz	a0,80000dea <madvise+0x11c>
    80000e00:	611c                	ld	a5,0(a0)
    80000e02:	8b85                	andi	a5,a5,1
    80000e04:	d3fd                	beqz	a5,80000dea <madvise+0x11c>
        char *pa = (char*) swap_page_from_pte(pte);
    80000e06:	00005097          	auipc	ra,0x5
    80000e0a:	ee0080e7          	jalr	-288(ra) # 80005ce6 <swap_page_from_pte>
        if (pa == 0) {
    80000e0e:	d961                	beqz	a0,80000dde <madvise+0x110>
        kfree(pa);
    80000e10:	fffff097          	auipc	ra,0xfffff
    80000e14:	20c080e7          	jalr	524(ra) # 8000001c <kfree>
    80000e18:	bfc9                	j	80000dea <madvise+0x11c>
    end_op();
    80000e1a:	00003097          	auipc	ra,0x3
    80000e1e:	d92080e7          	jalr	-622(ra) # 80003bac <end_op>
    return 0;
    80000e22:	4501                	li	a0,0
    80000e24:	a011                	j	80000e28 <madvise+0x15a>
    return -1;
    80000e26:	557d                	li	a0,-1
  }
}
    80000e28:	60a6                	ld	ra,72(sp)
    80000e2a:	6406                	ld	s0,64(sp)
    80000e2c:	74e2                	ld	s1,56(sp)
    80000e2e:	7942                	ld	s2,48(sp)
    80000e30:	79a2                	ld	s3,40(sp)
    80000e32:	7a02                	ld	s4,32(sp)
    80000e34:	6ae2                	ld	s5,24(sp)
    80000e36:	6b42                	ld	s6,16(sp)
    80000e38:	6ba2                	ld	s7,8(sp)
    80000e3a:	6161                	addi	sp,sp,80
    80000e3c:	8082                	ret
    return 0;
    80000e3e:	854e                	mv	a0,s3
    80000e40:	b7e5                	j	80000e28 <madvise+0x15a>
        return -1;
    80000e42:	557d                	li	a0,-1
    80000e44:	b7d5                	j	80000e28 <madvise+0x15a>
    80000e46:	557d                	li	a0,-1
    80000e48:	b7c5                	j	80000e28 <madvise+0x15a>

0000000080000e4a <pgprint>:

/* NTU OS 2024 */
/* print pages from page replacement buffers */
#if defined(PG_REPLACEMENT_USE_LRU) || defined(PG_REPLACEMENT_USE_FIFO)
void pgprint() {
    80000e4a:	1141                	addi	sp,sp,-16
    80000e4c:	e406                	sd	ra,8(sp)
    80000e4e:	e022                	sd	s0,0(sp)
    80000e50:	0800                	addi	s0,sp,16
  #ifdef PG_REPLACEMENT_USE_LRU
  // TODO
  #elif defined(PG_REPLACEMENT_USE_FIFO)
  // TODO
  #endif
  panic("not implemented yet\n");
    80000e52:	00007517          	auipc	a0,0x7
    80000e56:	2ee50513          	addi	a0,a0,750 # 80008140 <etext+0x140>
    80000e5a:	00005097          	auipc	ra,0x5
    80000e5e:	5c6080e7          	jalr	1478(ra) # 80006420 <panic>

0000000080000e62 <_vmprint>:
}
#endif

/* NTU OS 2024 */
/* Print multi layer page table. */
void _vmprint(pagetable_t pagetable, uint64 lev, uint64 va, int p1, int p2, int l1, int l2){
    80000e62:	7135                	addi	sp,sp,-160
    80000e64:	ed06                	sd	ra,152(sp)
    80000e66:	e922                	sd	s0,144(sp)
    80000e68:	e526                	sd	s1,136(sp)
    80000e6a:	e14a                	sd	s2,128(sp)
    80000e6c:	fcce                	sd	s3,120(sp)
    80000e6e:	f8d2                	sd	s4,112(sp)
    80000e70:	f4d6                	sd	s5,104(sp)
    80000e72:	f0da                	sd	s6,96(sp)
    80000e74:	ecde                	sd	s7,88(sp)
    80000e76:	e8e2                	sd	s8,80(sp)
    80000e78:	e4e6                	sd	s9,72(sp)
    80000e7a:	e0ea                	sd	s10,64(sp)
    80000e7c:	fc6e                	sd	s11,56(sp)
    80000e7e:	1100                	addi	s0,sp,160
    80000e80:	892a                	mv	s2,a0
    80000e82:	f6b43423          	sd	a1,-152(s0)
    80000e86:	f8c43023          	sd	a2,-128(s0)
    80000e8a:	8b36                	mv	s6,a3
    80000e8c:	8d3a                	mv	s10,a4
    80000e8e:	8bbe                	mv	s7,a5
    80000e90:	8dc2                	mv	s11,a6
  int last = -1;
    80000e92:	57fd                	li	a5,-1
    80000e94:	f6f43823          	sd	a5,-144(s0)
  if (lev > 0){
    80000e98:	c585                	beqz	a1,80000ec0 <_vmprint+0x5e>
    80000e9a:	6705                	lui	a4,0x1
    80000e9c:	1761                	addi	a4,a4,-8
    80000e9e:	972a                	add	a4,a4,a0
    for (int i = 511; i >= 0; --i){
    80000ea0:	1ff00793          	li	a5,511
    80000ea4:	f6f43823          	sd	a5,-144(s0)
    80000ea8:	56fd                	li	a3,-1
      pte_t *pte = &pagetable[i];
      if (*pte & PTE_V){
    80000eaa:	631c                	ld	a5,0(a4)
    80000eac:	8b85                	andi	a5,a5,1
    80000eae:	eb89                	bnez	a5,80000ec0 <_vmprint+0x5e>
    for (int i = 511; i >= 0; --i){
    80000eb0:	f7043783          	ld	a5,-144(s0)
    80000eb4:	37fd                	addiw	a5,a5,-1
    80000eb6:	f6f43823          	sd	a5,-144(s0)
    80000eba:	1761                	addi	a4,a4,-8
    80000ebc:	fed797e3          	bne	a5,a3,80000eaa <_vmprint+0x48>
        }
      }
      if (*pte & PTE_V)
        printf("+-- %d: pte=%p va=%p pa=%p", i, pte, va | (i << (lev * 9 + 12)), PTE2PA(*pte));
      else
        printf("+-- %d: pte=%p va=%p blockno=%p", i, pte, va | (i << (lev * 9 + 12)), PTE2BLOCKNO(*pte));
    80000ec0:	f6843703          	ld	a4,-152(s0)
    80000ec4:	0037179b          	slliw	a5,a4,0x3
    80000ec8:	9fb9                	addw	a5,a5,a4
    80000eca:	27b1                	addiw	a5,a5,12
    80000ecc:	f8f43423          	sd	a5,-120(s0)
  for (uint64 i = 0; i < 512; ++i){
    80000ed0:	4a01                	li	s4,0
      for (int i = 0; i < (2 - lev); ++i){
    80000ed2:	4789                	li	a5,2
    80000ed4:	8f99                	sub	a5,a5,a4
    80000ed6:	f6f43c23          	sd	a5,-136(s0)
      if ((*pte & PTE_S) == 0 && (*pte & PTE_P)) printf(" P");
      if (*pte & PTE_S) printf(" S");
      printf("\n");
      if ((*pte & (PTE_R|PTE_W|PTE_X)) == 0){
        uint64 ch = PTE2PA(*pte);
        _vmprint((pagetable_t)ch, lev - 1, va | (i << (lev * 9 + 12)), (lev == 2 ? i : p1), (lev == 1 ? i : p2), (lev == 2 ? last : l1), (lev == 1 ? last : l2));
    80000eda:	177d                	addi	a4,a4,-1
    80000edc:	f6e43023          	sd	a4,-160(s0)
    80000ee0:	4c05                	li	s8,1
    80000ee2:	00078a9b          	sext.w	s5,a5
            printf("    ");
    80000ee6:	00007c97          	auipc	s9,0x7
    80000eea:	27ac8c93          	addi	s9,s9,634 # 80008160 <etext+0x160>
    80000eee:	aaf5                	j	800010ea <_vmprint+0x288>
            printf("    ");
    80000ef0:	8566                	mv	a0,s9
    80000ef2:	00005097          	auipc	ra,0x5
    80000ef6:	578080e7          	jalr	1400(ra) # 8000646a <printf>
      for (int i = 0; i < (2 - lev); ++i){
    80000efa:	2485                	addiw	s1,s1,1
    80000efc:	049a8163          	beq	s5,s1,80000f3e <_vmprint+0xdc>
        if (i == 0){
    80000f00:	ec81                	bnez	s1,80000f18 <_vmprint+0xb6>
          if (p1 < l1)
    80000f02:	ff7b57e3          	bge	s6,s7,80000ef0 <_vmprint+0x8e>
            printf("|   ");
    80000f06:	00007517          	auipc	a0,0x7
    80000f0a:	25250513          	addi	a0,a0,594 # 80008158 <etext+0x158>
    80000f0e:	00005097          	auipc	ra,0x5
    80000f12:	55c080e7          	jalr	1372(ra) # 8000646a <printf>
    80000f16:	b7d5                	j	80000efa <_vmprint+0x98>
        if (i == 1){
    80000f18:	ff8491e3          	bne	s1,s8,80000efa <_vmprint+0x98>
          if (p2 < l2)
    80000f1c:	01bd5b63          	bge	s10,s11,80000f32 <_vmprint+0xd0>
            printf("|   ");
    80000f20:	00007517          	auipc	a0,0x7
    80000f24:	23850513          	addi	a0,a0,568 # 80008158 <etext+0x158>
    80000f28:	00005097          	auipc	ra,0x5
    80000f2c:	542080e7          	jalr	1346(ra) # 8000646a <printf>
    80000f30:	b7e9                	j	80000efa <_vmprint+0x98>
            printf("    ");
    80000f32:	8566                	mv	a0,s9
    80000f34:	00005097          	auipc	ra,0x5
    80000f38:	536080e7          	jalr	1334(ra) # 8000646a <printf>
    80000f3c:	bf7d                	j	80000efa <_vmprint+0x98>
      if (*pte & PTE_V)
    80000f3e:	0009b703          	ld	a4,0(s3) # 1000 <_entry-0x7ffff000>
    80000f42:	00177793          	andi	a5,a4,1
    80000f46:	c7e9                	beqz	a5,80001010 <_vmprint+0x1ae>
        printf("+-- %d: pte=%p va=%p pa=%p", i, pte, va | (i << (lev * 9 + 12)), PTE2PA(*pte));
    80000f48:	8329                	srli	a4,a4,0xa
    80000f4a:	f8843783          	ld	a5,-120(s0)
    80000f4e:	00fa16b3          	sll	a3,s4,a5
    80000f52:	0732                	slli	a4,a4,0xc
    80000f54:	f8043783          	ld	a5,-128(s0)
    80000f58:	8edd                	or	a3,a3,a5
    80000f5a:	864e                	mv	a2,s3
    80000f5c:	85d2                	mv	a1,s4
    80000f5e:	00007517          	auipc	a0,0x7
    80000f62:	20a50513          	addi	a0,a0,522 # 80008168 <etext+0x168>
    80000f66:	00005097          	auipc	ra,0x5
    80000f6a:	504080e7          	jalr	1284(ra) # 8000646a <printf>
      if (*pte & PTE_V) printf(" V");
    80000f6e:	0009b783          	ld	a5,0(s3)
    80000f72:	8b85                	andi	a5,a5,1
    80000f74:	e3e9                	bnez	a5,80001036 <_vmprint+0x1d4>
      if (*pte & PTE_R) printf(" R");
    80000f76:	0009b783          	ld	a5,0(s3)
    80000f7a:	8b89                	andi	a5,a5,2
    80000f7c:	e7f1                	bnez	a5,80001048 <_vmprint+0x1e6>
      if (*pte & PTE_W) printf(" W");
    80000f7e:	0009b783          	ld	a5,0(s3)
    80000f82:	8b91                	andi	a5,a5,4
    80000f84:	ebf9                	bnez	a5,8000105a <_vmprint+0x1f8>
      if (*pte & PTE_X) printf(" X");
    80000f86:	0009b783          	ld	a5,0(s3)
    80000f8a:	8ba1                	andi	a5,a5,8
    80000f8c:	e3e5                	bnez	a5,8000106c <_vmprint+0x20a>
      if (*pte & PTE_U) printf(" U");
    80000f8e:	0009b783          	ld	a5,0(s3)
    80000f92:	8bc1                	andi	a5,a5,16
    80000f94:	e7ed                	bnez	a5,8000107e <_vmprint+0x21c>
      if ((*pte & PTE_S) == 0 && (*pte & PTE_D)) printf(" D");
    80000f96:	0009b783          	ld	a5,0(s3)
    80000f9a:	2807f793          	andi	a5,a5,640
    80000f9e:	08000713          	li	a4,128
    80000fa2:	0ee78763          	beq	a5,a4,80001090 <_vmprint+0x22e>
      if ((*pte & PTE_S) == 0 && (*pte & PTE_P)) printf(" P");
    80000fa6:	0009b783          	ld	a5,0(s3)
    80000faa:	3007f793          	andi	a5,a5,768
    80000fae:	10000713          	li	a4,256
    80000fb2:	0ee78863          	beq	a5,a4,800010a2 <_vmprint+0x240>
      if (*pte & PTE_S) printf(" S");
    80000fb6:	0009b783          	ld	a5,0(s3)
    80000fba:	2007f793          	andi	a5,a5,512
    80000fbe:	ebfd                	bnez	a5,800010b4 <_vmprint+0x252>
      printf("\n");
    80000fc0:	00007517          	auipc	a0,0x7
    80000fc4:	08850513          	addi	a0,a0,136 # 80008048 <etext+0x48>
    80000fc8:	00005097          	auipc	ra,0x5
    80000fcc:	4a2080e7          	jalr	1186(ra) # 8000646a <printf>
      if ((*pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000fd0:	0009b783          	ld	a5,0(s3)
    80000fd4:	00e7f713          	andi	a4,a5,14
    80000fd8:	10071363          	bnez	a4,800010de <_vmprint+0x27c>
        uint64 ch = PTE2PA(*pte);
    80000fdc:	83a9                	srli	a5,a5,0xa
    80000fde:	00c79513          	slli	a0,a5,0xc
        _vmprint((pagetable_t)ch, lev - 1, va | (i << (lev * 9 + 12)), (lev == 2 ? i : p1), (lev == 1 ? i : p2), (lev == 2 ? last : l1), (lev == 1 ? last : l2));
    80000fe2:	f8843783          	ld	a5,-120(s0)
    80000fe6:	00fa1633          	sll	a2,s4,a5
    80000fea:	f8043783          	ld	a5,-128(s0)
    80000fee:	8e5d                	or	a2,a2,a5
    80000ff0:	f6843783          	ld	a5,-152(s0)
    80000ff4:	4709                	li	a4,2
    80000ff6:	0ce78863          	beq	a5,a4,800010c6 <_vmprint+0x264>
    80000ffa:	f6843783          	ld	a5,-152(s0)
    80000ffe:	11879263          	bne	a5,s8,80001102 <_vmprint+0x2a0>
    80001002:	000a071b          	sext.w	a4,s4
    80001006:	87de                	mv	a5,s7
    80001008:	86da                	mv	a3,s6
    8000100a:	f7043803          	ld	a6,-144(s0)
    8000100e:	a0d1                	j	800010d2 <_vmprint+0x270>
        printf("+-- %d: pte=%p va=%p blockno=%p", i, pte, va | (i << (lev * 9 + 12)), PTE2BLOCKNO(*pte));
    80001010:	f8843783          	ld	a5,-120(s0)
    80001014:	00fa16b3          	sll	a3,s4,a5
    80001018:	8329                	srli	a4,a4,0xa
    8000101a:	f8043783          	ld	a5,-128(s0)
    8000101e:	8edd                	or	a3,a3,a5
    80001020:	864e                	mv	a2,s3
    80001022:	85d2                	mv	a1,s4
    80001024:	00007517          	auipc	a0,0x7
    80001028:	16450513          	addi	a0,a0,356 # 80008188 <etext+0x188>
    8000102c:	00005097          	auipc	ra,0x5
    80001030:	43e080e7          	jalr	1086(ra) # 8000646a <printf>
    80001034:	bf2d                	j	80000f6e <_vmprint+0x10c>
      if (*pte & PTE_V) printf(" V");
    80001036:	00007517          	auipc	a0,0x7
    8000103a:	17250513          	addi	a0,a0,370 # 800081a8 <etext+0x1a8>
    8000103e:	00005097          	auipc	ra,0x5
    80001042:	42c080e7          	jalr	1068(ra) # 8000646a <printf>
    80001046:	bf05                	j	80000f76 <_vmprint+0x114>
      if (*pte & PTE_R) printf(" R");
    80001048:	00007517          	auipc	a0,0x7
    8000104c:	16850513          	addi	a0,a0,360 # 800081b0 <etext+0x1b0>
    80001050:	00005097          	auipc	ra,0x5
    80001054:	41a080e7          	jalr	1050(ra) # 8000646a <printf>
    80001058:	b71d                	j	80000f7e <_vmprint+0x11c>
      if (*pte & PTE_W) printf(" W");
    8000105a:	00007517          	auipc	a0,0x7
    8000105e:	15e50513          	addi	a0,a0,350 # 800081b8 <etext+0x1b8>
    80001062:	00005097          	auipc	ra,0x5
    80001066:	408080e7          	jalr	1032(ra) # 8000646a <printf>
    8000106a:	bf31                	j	80000f86 <_vmprint+0x124>
      if (*pte & PTE_X) printf(" X");
    8000106c:	00007517          	auipc	a0,0x7
    80001070:	15450513          	addi	a0,a0,340 # 800081c0 <etext+0x1c0>
    80001074:	00005097          	auipc	ra,0x5
    80001078:	3f6080e7          	jalr	1014(ra) # 8000646a <printf>
    8000107c:	bf09                	j	80000f8e <_vmprint+0x12c>
      if (*pte & PTE_U) printf(" U");
    8000107e:	00007517          	auipc	a0,0x7
    80001082:	14a50513          	addi	a0,a0,330 # 800081c8 <etext+0x1c8>
    80001086:	00005097          	auipc	ra,0x5
    8000108a:	3e4080e7          	jalr	996(ra) # 8000646a <printf>
    8000108e:	b721                	j	80000f96 <_vmprint+0x134>
      if ((*pte & PTE_S) == 0 && (*pte & PTE_D)) printf(" D");
    80001090:	00007517          	auipc	a0,0x7
    80001094:	14050513          	addi	a0,a0,320 # 800081d0 <etext+0x1d0>
    80001098:	00005097          	auipc	ra,0x5
    8000109c:	3d2080e7          	jalr	978(ra) # 8000646a <printf>
    800010a0:	b719                	j	80000fa6 <_vmprint+0x144>
      if ((*pte & PTE_S) == 0 && (*pte & PTE_P)) printf(" P");
    800010a2:	00007517          	auipc	a0,0x7
    800010a6:	13650513          	addi	a0,a0,310 # 800081d8 <etext+0x1d8>
    800010aa:	00005097          	auipc	ra,0x5
    800010ae:	3c0080e7          	jalr	960(ra) # 8000646a <printf>
    800010b2:	b711                	j	80000fb6 <_vmprint+0x154>
      if (*pte & PTE_S) printf(" S");
    800010b4:	00007517          	auipc	a0,0x7
    800010b8:	12c50513          	addi	a0,a0,300 # 800081e0 <etext+0x1e0>
    800010bc:	00005097          	auipc	ra,0x5
    800010c0:	3ae080e7          	jalr	942(ra) # 8000646a <printf>
    800010c4:	bdf5                	j	80000fc0 <_vmprint+0x15e>
        _vmprint((pagetable_t)ch, lev - 1, va | (i << (lev * 9 + 12)), (lev == 2 ? i : p1), (lev == 1 ? i : p2), (lev == 2 ? last : l1), (lev == 1 ? last : l2));
    800010c6:	000a069b          	sext.w	a3,s4
    800010ca:	f7043783          	ld	a5,-144(s0)
    800010ce:	876a                	mv	a4,s10
    800010d0:	886e                	mv	a6,s11
    800010d2:	f6043583          	ld	a1,-160(s0)
    800010d6:	00000097          	auipc	ra,0x0
    800010da:	d8c080e7          	jalr	-628(ra) # 80000e62 <_vmprint>
  for (uint64 i = 0; i < 512; ++i){
    800010de:	0a05                	addi	s4,s4,1
    800010e0:	0921                	addi	s2,s2,8
    800010e2:	20000793          	li	a5,512
    800010e6:	02fa0363          	beq	s4,a5,8000110c <_vmprint+0x2aa>
    pte_t *pte = &pagetable[i];
    800010ea:	89ca                	mv	s3,s2
    if ((*pte & PTE_V) || (*pte & PTE_S)){
    800010ec:	00093783          	ld	a5,0(s2) # 1000 <_entry-0x7ffff000>
    800010f0:	2017f793          	andi	a5,a5,513
    800010f4:	d7ed                	beqz	a5,800010de <_vmprint+0x27c>
      for (int i = 0; i < (2 - lev); ++i){
    800010f6:	f7843783          	ld	a5,-136(s0)
    800010fa:	e40782e3          	beqz	a5,80000f3e <_vmprint+0xdc>
    800010fe:	4481                	li	s1,0
    80001100:	b501                	j	80000f00 <_vmprint+0x9e>
        _vmprint((pagetable_t)ch, lev - 1, va | (i << (lev * 9 + 12)), (lev == 2 ? i : p1), (lev == 1 ? i : p2), (lev == 2 ? last : l1), (lev == 1 ? last : l2));
    80001102:	87de                	mv	a5,s7
    80001104:	876a                	mv	a4,s10
    80001106:	86da                	mv	a3,s6
    80001108:	886e                	mv	a6,s11
    8000110a:	b7e1                	j	800010d2 <_vmprint+0x270>
      }
    }
  }
}
    8000110c:	60ea                	ld	ra,152(sp)
    8000110e:	644a                	ld	s0,144(sp)
    80001110:	64aa                	ld	s1,136(sp)
    80001112:	690a                	ld	s2,128(sp)
    80001114:	79e6                	ld	s3,120(sp)
    80001116:	7a46                	ld	s4,112(sp)
    80001118:	7aa6                	ld	s5,104(sp)
    8000111a:	7b06                	ld	s6,96(sp)
    8000111c:	6be6                	ld	s7,88(sp)
    8000111e:	6c46                	ld	s8,80(sp)
    80001120:	6ca6                	ld	s9,72(sp)
    80001122:	6d06                	ld	s10,64(sp)
    80001124:	7de2                	ld	s11,56(sp)
    80001126:	610d                	addi	sp,sp,160
    80001128:	8082                	ret

000000008000112a <vmprint>:
void vmprint(pagetable_t pagetable) {
    8000112a:	1101                	addi	sp,sp,-32
    8000112c:	ec06                	sd	ra,24(sp)
    8000112e:	e822                	sd	s0,16(sp)
    80001130:	e426                	sd	s1,8(sp)
    80001132:	1000                	addi	s0,sp,32
    80001134:	84aa                	mv	s1,a0
  /* TODO */
  printf("page table %p\n", pagetable);
    80001136:	85aa                	mv	a1,a0
    80001138:	00007517          	auipc	a0,0x7
    8000113c:	0b050513          	addi	a0,a0,176 # 800081e8 <etext+0x1e8>
    80001140:	00005097          	auipc	ra,0x5
    80001144:	32a080e7          	jalr	810(ra) # 8000646a <printf>
  _vmprint(pagetable, 2, 0, -1, -1, -1, -1);
    80001148:	587d                	li	a6,-1
    8000114a:	57fd                	li	a5,-1
    8000114c:	577d                	li	a4,-1
    8000114e:	56fd                	li	a3,-1
    80001150:	4601                	li	a2,0
    80001152:	4589                	li	a1,2
    80001154:	8526                	mv	a0,s1
    80001156:	00000097          	auipc	ra,0x0
    8000115a:	d0c080e7          	jalr	-756(ra) # 80000e62 <_vmprint>
}
    8000115e:	60e2                	ld	ra,24(sp)
    80001160:	6442                	ld	s0,16(sp)
    80001162:	64a2                	ld	s1,8(sp)
    80001164:	6105                	addi	sp,sp,32
    80001166:	8082                	ret

0000000080001168 <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80001168:	7139                	addi	sp,sp,-64
    8000116a:	fc06                	sd	ra,56(sp)
    8000116c:	f822                	sd	s0,48(sp)
    8000116e:	f426                	sd	s1,40(sp)
    80001170:	f04a                	sd	s2,32(sp)
    80001172:	ec4e                	sd	s3,24(sp)
    80001174:	e852                	sd	s4,16(sp)
    80001176:	e456                	sd	s5,8(sp)
    80001178:	e05a                	sd	s6,0(sp)
    8000117a:	0080                	addi	s0,sp,64
    8000117c:	89aa                	mv	s3,a0
  struct proc *p;
  for(p = proc; p < &proc[NPROC]; p++) {
    8000117e:	00008497          	auipc	s1,0x8
    80001182:	30248493          	addi	s1,s1,770 # 80009480 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80001186:	8b26                	mv	s6,s1
    80001188:	00007a97          	auipc	s5,0x7
    8000118c:	e78a8a93          	addi	s5,s5,-392 # 80008000 <etext>
    80001190:	01000937          	lui	s2,0x1000
    80001194:	197d                	addi	s2,s2,-1
    80001196:	093a                	slli	s2,s2,0xe
  for(p = proc; p < &proc[NPROC]; p++) {
    80001198:	0000ea17          	auipc	s4,0xe
    8000119c:	ce8a0a13          	addi	s4,s4,-792 # 8000ee80 <tickslock>
    char *pa = kalloc();
    800011a0:	fffff097          	auipc	ra,0xfffff
    800011a4:	f78080e7          	jalr	-136(ra) # 80000118 <kalloc>
    800011a8:	862a                	mv	a2,a0
    if(pa == 0)
    800011aa:	c129                	beqz	a0,800011ec <proc_mapstacks+0x84>
    uint64 va = KSTACK((int) (p - proc));
    800011ac:	416485b3          	sub	a1,s1,s6
    800011b0:	858d                	srai	a1,a1,0x3
    800011b2:	000ab783          	ld	a5,0(s5)
    800011b6:	02f585b3          	mul	a1,a1,a5
    800011ba:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    800011be:	4719                	li	a4,6
    800011c0:	6685                	lui	a3,0x1
    800011c2:	40b905b3          	sub	a1,s2,a1
    800011c6:	854e                	mv	a0,s3
    800011c8:	fffff097          	auipc	ra,0xfffff
    800011cc:	420080e7          	jalr	1056(ra) # 800005e8 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    800011d0:	16848493          	addi	s1,s1,360
    800011d4:	fd4496e3          	bne	s1,s4,800011a0 <proc_mapstacks+0x38>
  }
}
    800011d8:	70e2                	ld	ra,56(sp)
    800011da:	7442                	ld	s0,48(sp)
    800011dc:	74a2                	ld	s1,40(sp)
    800011de:	7902                	ld	s2,32(sp)
    800011e0:	69e2                	ld	s3,24(sp)
    800011e2:	6a42                	ld	s4,16(sp)
    800011e4:	6aa2                	ld	s5,8(sp)
    800011e6:	6b02                	ld	s6,0(sp)
    800011e8:	6121                	addi	sp,sp,64
    800011ea:	8082                	ret
      panic("kalloc");
    800011ec:	00007517          	auipc	a0,0x7
    800011f0:	00c50513          	addi	a0,a0,12 # 800081f8 <etext+0x1f8>
    800011f4:	00005097          	auipc	ra,0x5
    800011f8:	22c080e7          	jalr	556(ra) # 80006420 <panic>

00000000800011fc <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    800011fc:	7139                	addi	sp,sp,-64
    800011fe:	fc06                	sd	ra,56(sp)
    80001200:	f822                	sd	s0,48(sp)
    80001202:	f426                	sd	s1,40(sp)
    80001204:	f04a                	sd	s2,32(sp)
    80001206:	ec4e                	sd	s3,24(sp)
    80001208:	e852                	sd	s4,16(sp)
    8000120a:	e456                	sd	s5,8(sp)
    8000120c:	e05a                	sd	s6,0(sp)
    8000120e:	0080                	addi	s0,sp,64
  struct proc *p;
  initlock(&pid_lock, "nextpid");
    80001210:	00007597          	auipc	a1,0x7
    80001214:	ff058593          	addi	a1,a1,-16 # 80008200 <etext+0x200>
    80001218:	00008517          	auipc	a0,0x8
    8000121c:	e3850513          	addi	a0,a0,-456 # 80009050 <pid_lock>
    80001220:	00005097          	auipc	ra,0x5
    80001224:	6ba080e7          	jalr	1722(ra) # 800068da <initlock>
  initlock(&wait_lock, "wait_lock");
    80001228:	00007597          	auipc	a1,0x7
    8000122c:	fe058593          	addi	a1,a1,-32 # 80008208 <etext+0x208>
    80001230:	00008517          	auipc	a0,0x8
    80001234:	e3850513          	addi	a0,a0,-456 # 80009068 <wait_lock>
    80001238:	00005097          	auipc	ra,0x5
    8000123c:	6a2080e7          	jalr	1698(ra) # 800068da <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001240:	00008497          	auipc	s1,0x8
    80001244:	24048493          	addi	s1,s1,576 # 80009480 <proc>
      initlock(&p->lock, "proc");
    80001248:	00007b17          	auipc	s6,0x7
    8000124c:	fd0b0b13          	addi	s6,s6,-48 # 80008218 <etext+0x218>
      p->kstack = KSTACK((int) (p - proc));
    80001250:	8aa6                	mv	s5,s1
    80001252:	00007a17          	auipc	s4,0x7
    80001256:	daea0a13          	addi	s4,s4,-594 # 80008000 <etext>
    8000125a:	01000937          	lui	s2,0x1000
    8000125e:	197d                	addi	s2,s2,-1
    80001260:	093a                	slli	s2,s2,0xe
  for(p = proc; p < &proc[NPROC]; p++) {
    80001262:	0000e997          	auipc	s3,0xe
    80001266:	c1e98993          	addi	s3,s3,-994 # 8000ee80 <tickslock>
      initlock(&p->lock, "proc");
    8000126a:	85da                	mv	a1,s6
    8000126c:	8526                	mv	a0,s1
    8000126e:	00005097          	auipc	ra,0x5
    80001272:	66c080e7          	jalr	1644(ra) # 800068da <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80001276:	415487b3          	sub	a5,s1,s5
    8000127a:	878d                	srai	a5,a5,0x3
    8000127c:	000a3703          	ld	a4,0(s4)
    80001280:	02e787b3          	mul	a5,a5,a4
    80001284:	00d7979b          	slliw	a5,a5,0xd
    80001288:	40f907b3          	sub	a5,s2,a5
    8000128c:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    8000128e:	16848493          	addi	s1,s1,360
    80001292:	fd349ce3          	bne	s1,s3,8000126a <procinit+0x6e>
  }
}
    80001296:	70e2                	ld	ra,56(sp)
    80001298:	7442                	ld	s0,48(sp)
    8000129a:	74a2                	ld	s1,40(sp)
    8000129c:	7902                	ld	s2,32(sp)
    8000129e:	69e2                	ld	s3,24(sp)
    800012a0:	6a42                	ld	s4,16(sp)
    800012a2:	6aa2                	ld	s5,8(sp)
    800012a4:	6b02                	ld	s6,0(sp)
    800012a6:	6121                	addi	sp,sp,64
    800012a8:	8082                	ret

00000000800012aa <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    800012aa:	1141                	addi	sp,sp,-16
    800012ac:	e422                	sd	s0,8(sp)
    800012ae:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    800012b0:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    800012b2:	2501                	sext.w	a0,a0
    800012b4:	6422                	ld	s0,8(sp)
    800012b6:	0141                	addi	sp,sp,16
    800012b8:	8082                	ret

00000000800012ba <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    800012ba:	1141                	addi	sp,sp,-16
    800012bc:	e422                	sd	s0,8(sp)
    800012be:	0800                	addi	s0,sp,16
    800012c0:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    800012c2:	2781                	sext.w	a5,a5
    800012c4:	079e                	slli	a5,a5,0x7
  return c;
}
    800012c6:	00008517          	auipc	a0,0x8
    800012ca:	dba50513          	addi	a0,a0,-582 # 80009080 <cpus>
    800012ce:	953e                	add	a0,a0,a5
    800012d0:	6422                	ld	s0,8(sp)
    800012d2:	0141                	addi	sp,sp,16
    800012d4:	8082                	ret

00000000800012d6 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    800012d6:	1101                	addi	sp,sp,-32
    800012d8:	ec06                	sd	ra,24(sp)
    800012da:	e822                	sd	s0,16(sp)
    800012dc:	e426                	sd	s1,8(sp)
    800012de:	1000                	addi	s0,sp,32
  push_off();
    800012e0:	00005097          	auipc	ra,0x5
    800012e4:	63e080e7          	jalr	1598(ra) # 8000691e <push_off>
    800012e8:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    800012ea:	2781                	sext.w	a5,a5
    800012ec:	079e                	slli	a5,a5,0x7
    800012ee:	00008717          	auipc	a4,0x8
    800012f2:	d6270713          	addi	a4,a4,-670 # 80009050 <pid_lock>
    800012f6:	97ba                	add	a5,a5,a4
    800012f8:	7b84                	ld	s1,48(a5)
  pop_off();
    800012fa:	00005097          	auipc	ra,0x5
    800012fe:	6c4080e7          	jalr	1732(ra) # 800069be <pop_off>
  return p;
}
    80001302:	8526                	mv	a0,s1
    80001304:	60e2                	ld	ra,24(sp)
    80001306:	6442                	ld	s0,16(sp)
    80001308:	64a2                	ld	s1,8(sp)
    8000130a:	6105                	addi	sp,sp,32
    8000130c:	8082                	ret

000000008000130e <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    8000130e:	1141                	addi	sp,sp,-16
    80001310:	e406                	sd	ra,8(sp)
    80001312:	e022                	sd	s0,0(sp)
    80001314:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80001316:	00000097          	auipc	ra,0x0
    8000131a:	fc0080e7          	jalr	-64(ra) # 800012d6 <myproc>
    8000131e:	00005097          	auipc	ra,0x5
    80001322:	700080e7          	jalr	1792(ra) # 80006a1e <release>

  if (first) {
    80001326:	00007797          	auipc	a5,0x7
    8000132a:	69a7a783          	lw	a5,1690(a5) # 800089c0 <first.1768>
    8000132e:	eb89                	bnez	a5,80001340 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80001330:	00001097          	auipc	ra,0x1
    80001334:	c0a080e7          	jalr	-1014(ra) # 80001f3a <usertrapret>
}
    80001338:	60a2                	ld	ra,8(sp)
    8000133a:	6402                	ld	s0,0(sp)
    8000133c:	0141                	addi	sp,sp,16
    8000133e:	8082                	ret
    first = 0;
    80001340:	00007797          	auipc	a5,0x7
    80001344:	6807a023          	sw	zero,1664(a5) # 800089c0 <first.1768>
    fsinit(ROOTDEV);
    80001348:	4505                	li	a0,1
    8000134a:	00002097          	auipc	ra,0x2
    8000134e:	a22080e7          	jalr	-1502(ra) # 80002d6c <fsinit>
    80001352:	bff9                	j	80001330 <forkret+0x22>

0000000080001354 <allocpid>:
allocpid() {
    80001354:	1101                	addi	sp,sp,-32
    80001356:	ec06                	sd	ra,24(sp)
    80001358:	e822                	sd	s0,16(sp)
    8000135a:	e426                	sd	s1,8(sp)
    8000135c:	e04a                	sd	s2,0(sp)
    8000135e:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001360:	00008917          	auipc	s2,0x8
    80001364:	cf090913          	addi	s2,s2,-784 # 80009050 <pid_lock>
    80001368:	854a                	mv	a0,s2
    8000136a:	00005097          	auipc	ra,0x5
    8000136e:	600080e7          	jalr	1536(ra) # 8000696a <acquire>
  pid = nextpid;
    80001372:	00007797          	auipc	a5,0x7
    80001376:	65278793          	addi	a5,a5,1618 # 800089c4 <nextpid>
    8000137a:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    8000137c:	0014871b          	addiw	a4,s1,1
    80001380:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001382:	854a                	mv	a0,s2
    80001384:	00005097          	auipc	ra,0x5
    80001388:	69a080e7          	jalr	1690(ra) # 80006a1e <release>
}
    8000138c:	8526                	mv	a0,s1
    8000138e:	60e2                	ld	ra,24(sp)
    80001390:	6442                	ld	s0,16(sp)
    80001392:	64a2                	ld	s1,8(sp)
    80001394:	6902                	ld	s2,0(sp)
    80001396:	6105                	addi	sp,sp,32
    80001398:	8082                	ret

000000008000139a <proc_pagetable>:
{
    8000139a:	1101                	addi	sp,sp,-32
    8000139c:	ec06                	sd	ra,24(sp)
    8000139e:	e822                	sd	s0,16(sp)
    800013a0:	e426                	sd	s1,8(sp)
    800013a2:	e04a                	sd	s2,0(sp)
    800013a4:	1000                	addi	s0,sp,32
    800013a6:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    800013a8:	fffff097          	auipc	ra,0xfffff
    800013ac:	422080e7          	jalr	1058(ra) # 800007ca <uvmcreate>
    800013b0:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800013b2:	c121                	beqz	a0,800013f2 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    800013b4:	4729                	li	a4,10
    800013b6:	00006697          	auipc	a3,0x6
    800013ba:	c4a68693          	addi	a3,a3,-950 # 80007000 <_trampoline>
    800013be:	6605                	lui	a2,0x1
    800013c0:	040005b7          	lui	a1,0x4000
    800013c4:	15fd                	addi	a1,a1,-1
    800013c6:	05b2                	slli	a1,a1,0xc
    800013c8:	fffff097          	auipc	ra,0xfffff
    800013cc:	180080e7          	jalr	384(ra) # 80000548 <mappages>
    800013d0:	02054863          	bltz	a0,80001400 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    800013d4:	4719                	li	a4,6
    800013d6:	05893683          	ld	a3,88(s2)
    800013da:	6605                	lui	a2,0x1
    800013dc:	020005b7          	lui	a1,0x2000
    800013e0:	15fd                	addi	a1,a1,-1
    800013e2:	05b6                	slli	a1,a1,0xd
    800013e4:	8526                	mv	a0,s1
    800013e6:	fffff097          	auipc	ra,0xfffff
    800013ea:	162080e7          	jalr	354(ra) # 80000548 <mappages>
    800013ee:	02054163          	bltz	a0,80001410 <proc_pagetable+0x76>
}
    800013f2:	8526                	mv	a0,s1
    800013f4:	60e2                	ld	ra,24(sp)
    800013f6:	6442                	ld	s0,16(sp)
    800013f8:	64a2                	ld	s1,8(sp)
    800013fa:	6902                	ld	s2,0(sp)
    800013fc:	6105                	addi	sp,sp,32
    800013fe:	8082                	ret
    uvmfree(pagetable, 0);
    80001400:	4581                	li	a1,0
    80001402:	8526                	mv	a0,s1
    80001404:	fffff097          	auipc	ra,0xfffff
    80001408:	5c2080e7          	jalr	1474(ra) # 800009c6 <uvmfree>
    return 0;
    8000140c:	4481                	li	s1,0
    8000140e:	b7d5                	j	800013f2 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001410:	4681                	li	a3,0
    80001412:	4605                	li	a2,1
    80001414:	040005b7          	lui	a1,0x4000
    80001418:	15fd                	addi	a1,a1,-1
    8000141a:	05b2                	slli	a1,a1,0xc
    8000141c:	8526                	mv	a0,s1
    8000141e:	fffff097          	auipc	ra,0xfffff
    80001422:	2f0080e7          	jalr	752(ra) # 8000070e <uvmunmap>
    uvmfree(pagetable, 0);
    80001426:	4581                	li	a1,0
    80001428:	8526                	mv	a0,s1
    8000142a:	fffff097          	auipc	ra,0xfffff
    8000142e:	59c080e7          	jalr	1436(ra) # 800009c6 <uvmfree>
    return 0;
    80001432:	4481                	li	s1,0
    80001434:	bf7d                	j	800013f2 <proc_pagetable+0x58>

0000000080001436 <proc_freepagetable>:
{
    80001436:	1101                	addi	sp,sp,-32
    80001438:	ec06                	sd	ra,24(sp)
    8000143a:	e822                	sd	s0,16(sp)
    8000143c:	e426                	sd	s1,8(sp)
    8000143e:	e04a                	sd	s2,0(sp)
    80001440:	1000                	addi	s0,sp,32
    80001442:	84aa                	mv	s1,a0
    80001444:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001446:	4681                	li	a3,0
    80001448:	4605                	li	a2,1
    8000144a:	040005b7          	lui	a1,0x4000
    8000144e:	15fd                	addi	a1,a1,-1
    80001450:	05b2                	slli	a1,a1,0xc
    80001452:	fffff097          	auipc	ra,0xfffff
    80001456:	2bc080e7          	jalr	700(ra) # 8000070e <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    8000145a:	4681                	li	a3,0
    8000145c:	4605                	li	a2,1
    8000145e:	020005b7          	lui	a1,0x2000
    80001462:	15fd                	addi	a1,a1,-1
    80001464:	05b6                	slli	a1,a1,0xd
    80001466:	8526                	mv	a0,s1
    80001468:	fffff097          	auipc	ra,0xfffff
    8000146c:	2a6080e7          	jalr	678(ra) # 8000070e <uvmunmap>
  uvmfree(pagetable, sz);
    80001470:	85ca                	mv	a1,s2
    80001472:	8526                	mv	a0,s1
    80001474:	fffff097          	auipc	ra,0xfffff
    80001478:	552080e7          	jalr	1362(ra) # 800009c6 <uvmfree>
}
    8000147c:	60e2                	ld	ra,24(sp)
    8000147e:	6442                	ld	s0,16(sp)
    80001480:	64a2                	ld	s1,8(sp)
    80001482:	6902                	ld	s2,0(sp)
    80001484:	6105                	addi	sp,sp,32
    80001486:	8082                	ret

0000000080001488 <freeproc>:
{
    80001488:	1101                	addi	sp,sp,-32
    8000148a:	ec06                	sd	ra,24(sp)
    8000148c:	e822                	sd	s0,16(sp)
    8000148e:	e426                	sd	s1,8(sp)
    80001490:	1000                	addi	s0,sp,32
    80001492:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001494:	6d28                	ld	a0,88(a0)
    80001496:	c509                	beqz	a0,800014a0 <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001498:	fffff097          	auipc	ra,0xfffff
    8000149c:	b84080e7          	jalr	-1148(ra) # 8000001c <kfree>
  p->trapframe = 0;
    800014a0:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    800014a4:	68a8                	ld	a0,80(s1)
    800014a6:	c511                	beqz	a0,800014b2 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    800014a8:	64ac                	ld	a1,72(s1)
    800014aa:	00000097          	auipc	ra,0x0
    800014ae:	f8c080e7          	jalr	-116(ra) # 80001436 <proc_freepagetable>
  p->pagetable = 0;
    800014b2:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    800014b6:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    800014ba:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    800014be:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    800014c2:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    800014c6:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    800014ca:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    800014ce:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    800014d2:	0004ac23          	sw	zero,24(s1)
}
    800014d6:	60e2                	ld	ra,24(sp)
    800014d8:	6442                	ld	s0,16(sp)
    800014da:	64a2                	ld	s1,8(sp)
    800014dc:	6105                	addi	sp,sp,32
    800014de:	8082                	ret

00000000800014e0 <allocproc>:
{
    800014e0:	1101                	addi	sp,sp,-32
    800014e2:	ec06                	sd	ra,24(sp)
    800014e4:	e822                	sd	s0,16(sp)
    800014e6:	e426                	sd	s1,8(sp)
    800014e8:	e04a                	sd	s2,0(sp)
    800014ea:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    800014ec:	00008497          	auipc	s1,0x8
    800014f0:	f9448493          	addi	s1,s1,-108 # 80009480 <proc>
    800014f4:	0000e917          	auipc	s2,0xe
    800014f8:	98c90913          	addi	s2,s2,-1652 # 8000ee80 <tickslock>
    acquire(&p->lock);
    800014fc:	8526                	mv	a0,s1
    800014fe:	00005097          	auipc	ra,0x5
    80001502:	46c080e7          	jalr	1132(ra) # 8000696a <acquire>
    if(p->state == UNUSED) {
    80001506:	4c9c                	lw	a5,24(s1)
    80001508:	cf81                	beqz	a5,80001520 <allocproc+0x40>
      release(&p->lock);
    8000150a:	8526                	mv	a0,s1
    8000150c:	00005097          	auipc	ra,0x5
    80001510:	512080e7          	jalr	1298(ra) # 80006a1e <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001514:	16848493          	addi	s1,s1,360
    80001518:	ff2492e3          	bne	s1,s2,800014fc <allocproc+0x1c>
  return 0;
    8000151c:	4481                	li	s1,0
    8000151e:	a889                	j	80001570 <allocproc+0x90>
  p->pid = allocpid();
    80001520:	00000097          	auipc	ra,0x0
    80001524:	e34080e7          	jalr	-460(ra) # 80001354 <allocpid>
    80001528:	d888                	sw	a0,48(s1)
  p->state = USED;
    8000152a:	4785                	li	a5,1
    8000152c:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    8000152e:	fffff097          	auipc	ra,0xfffff
    80001532:	bea080e7          	jalr	-1046(ra) # 80000118 <kalloc>
    80001536:	892a                	mv	s2,a0
    80001538:	eca8                	sd	a0,88(s1)
    8000153a:	c131                	beqz	a0,8000157e <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    8000153c:	8526                	mv	a0,s1
    8000153e:	00000097          	auipc	ra,0x0
    80001542:	e5c080e7          	jalr	-420(ra) # 8000139a <proc_pagetable>
    80001546:	892a                	mv	s2,a0
    80001548:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    8000154a:	c531                	beqz	a0,80001596 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    8000154c:	07000613          	li	a2,112
    80001550:	4581                	li	a1,0
    80001552:	06048513          	addi	a0,s1,96
    80001556:	fffff097          	auipc	ra,0xfffff
    8000155a:	c22080e7          	jalr	-990(ra) # 80000178 <memset>
  p->context.ra = (uint64)forkret;
    8000155e:	00000797          	auipc	a5,0x0
    80001562:	db078793          	addi	a5,a5,-592 # 8000130e <forkret>
    80001566:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001568:	60bc                	ld	a5,64(s1)
    8000156a:	6705                	lui	a4,0x1
    8000156c:	97ba                	add	a5,a5,a4
    8000156e:	f4bc                	sd	a5,104(s1)
}
    80001570:	8526                	mv	a0,s1
    80001572:	60e2                	ld	ra,24(sp)
    80001574:	6442                	ld	s0,16(sp)
    80001576:	64a2                	ld	s1,8(sp)
    80001578:	6902                	ld	s2,0(sp)
    8000157a:	6105                	addi	sp,sp,32
    8000157c:	8082                	ret
    freeproc(p);
    8000157e:	8526                	mv	a0,s1
    80001580:	00000097          	auipc	ra,0x0
    80001584:	f08080e7          	jalr	-248(ra) # 80001488 <freeproc>
    release(&p->lock);
    80001588:	8526                	mv	a0,s1
    8000158a:	00005097          	auipc	ra,0x5
    8000158e:	494080e7          	jalr	1172(ra) # 80006a1e <release>
    return 0;
    80001592:	84ca                	mv	s1,s2
    80001594:	bff1                	j	80001570 <allocproc+0x90>
    freeproc(p);
    80001596:	8526                	mv	a0,s1
    80001598:	00000097          	auipc	ra,0x0
    8000159c:	ef0080e7          	jalr	-272(ra) # 80001488 <freeproc>
    release(&p->lock);
    800015a0:	8526                	mv	a0,s1
    800015a2:	00005097          	auipc	ra,0x5
    800015a6:	47c080e7          	jalr	1148(ra) # 80006a1e <release>
    return 0;
    800015aa:	84ca                	mv	s1,s2
    800015ac:	b7d1                	j	80001570 <allocproc+0x90>

00000000800015ae <userinit>:
{
    800015ae:	1101                	addi	sp,sp,-32
    800015b0:	ec06                	sd	ra,24(sp)
    800015b2:	e822                	sd	s0,16(sp)
    800015b4:	e426                	sd	s1,8(sp)
    800015b6:	1000                	addi	s0,sp,32
  p = allocproc();
    800015b8:	00000097          	auipc	ra,0x0
    800015bc:	f28080e7          	jalr	-216(ra) # 800014e0 <allocproc>
    800015c0:	84aa                	mv	s1,a0
  initproc = p;
    800015c2:	00008797          	auipc	a5,0x8
    800015c6:	a4a7b723          	sd	a0,-1458(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    800015ca:	03400613          	li	a2,52
    800015ce:	00007597          	auipc	a1,0x7
    800015d2:	40258593          	addi	a1,a1,1026 # 800089d0 <initcode>
    800015d6:	6928                	ld	a0,80(a0)
    800015d8:	fffff097          	auipc	ra,0xfffff
    800015dc:	220080e7          	jalr	544(ra) # 800007f8 <uvminit>
  p->sz = PGSIZE;
    800015e0:	6785                	lui	a5,0x1
    800015e2:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    800015e4:	6cb8                	ld	a4,88(s1)
    800015e6:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    800015ea:	6cb8                	ld	a4,88(s1)
    800015ec:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    800015ee:	4641                	li	a2,16
    800015f0:	00007597          	auipc	a1,0x7
    800015f4:	c3058593          	addi	a1,a1,-976 # 80008220 <etext+0x220>
    800015f8:	15848513          	addi	a0,s1,344
    800015fc:	fffff097          	auipc	ra,0xfffff
    80001600:	cce080e7          	jalr	-818(ra) # 800002ca <safestrcpy>
  p->cwd = namei("/");
    80001604:	00007517          	auipc	a0,0x7
    80001608:	c2c50513          	addi	a0,a0,-980 # 80008230 <etext+0x230>
    8000160c:	00002097          	auipc	ra,0x2
    80001610:	172080e7          	jalr	370(ra) # 8000377e <namei>
    80001614:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001618:	478d                	li	a5,3
    8000161a:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    8000161c:	8526                	mv	a0,s1
    8000161e:	00005097          	auipc	ra,0x5
    80001622:	400080e7          	jalr	1024(ra) # 80006a1e <release>
}
    80001626:	60e2                	ld	ra,24(sp)
    80001628:	6442                	ld	s0,16(sp)
    8000162a:	64a2                	ld	s1,8(sp)
    8000162c:	6105                	addi	sp,sp,32
    8000162e:	8082                	ret

0000000080001630 <growproc>:
{
    80001630:	1101                	addi	sp,sp,-32
    80001632:	ec06                	sd	ra,24(sp)
    80001634:	e822                	sd	s0,16(sp)
    80001636:	e426                	sd	s1,8(sp)
    80001638:	e04a                	sd	s2,0(sp)
    8000163a:	1000                	addi	s0,sp,32
    8000163c:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    8000163e:	00000097          	auipc	ra,0x0
    80001642:	c98080e7          	jalr	-872(ra) # 800012d6 <myproc>
    80001646:	892a                	mv	s2,a0
  sz = p->sz;
    80001648:	652c                	ld	a1,72(a0)
    8000164a:	0005861b          	sext.w	a2,a1
  if(n > 0){
    8000164e:	00904f63          	bgtz	s1,8000166c <growproc+0x3c>
  } else if(n < 0){
    80001652:	0204cc63          	bltz	s1,8000168a <growproc+0x5a>
  p->sz = sz;
    80001656:	1602                	slli	a2,a2,0x20
    80001658:	9201                	srli	a2,a2,0x20
    8000165a:	04c93423          	sd	a2,72(s2)
  return 0;
    8000165e:	4501                	li	a0,0
}
    80001660:	60e2                	ld	ra,24(sp)
    80001662:	6442                	ld	s0,16(sp)
    80001664:	64a2                	ld	s1,8(sp)
    80001666:	6902                	ld	s2,0(sp)
    80001668:	6105                	addi	sp,sp,32
    8000166a:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    8000166c:	9e25                	addw	a2,a2,s1
    8000166e:	1602                	slli	a2,a2,0x20
    80001670:	9201                	srli	a2,a2,0x20
    80001672:	1582                	slli	a1,a1,0x20
    80001674:	9181                	srli	a1,a1,0x20
    80001676:	6928                	ld	a0,80(a0)
    80001678:	fffff097          	auipc	ra,0xfffff
    8000167c:	23a080e7          	jalr	570(ra) # 800008b2 <uvmalloc>
    80001680:	0005061b          	sext.w	a2,a0
    80001684:	fa69                	bnez	a2,80001656 <growproc+0x26>
      return -1;
    80001686:	557d                	li	a0,-1
    80001688:	bfe1                	j	80001660 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    8000168a:	9e25                	addw	a2,a2,s1
    8000168c:	1602                	slli	a2,a2,0x20
    8000168e:	9201                	srli	a2,a2,0x20
    80001690:	1582                	slli	a1,a1,0x20
    80001692:	9181                	srli	a1,a1,0x20
    80001694:	6928                	ld	a0,80(a0)
    80001696:	fffff097          	auipc	ra,0xfffff
    8000169a:	1d4080e7          	jalr	468(ra) # 8000086a <uvmdealloc>
    8000169e:	0005061b          	sext.w	a2,a0
    800016a2:	bf55                	j	80001656 <growproc+0x26>

00000000800016a4 <fork>:
{
    800016a4:	7179                	addi	sp,sp,-48
    800016a6:	f406                	sd	ra,40(sp)
    800016a8:	f022                	sd	s0,32(sp)
    800016aa:	ec26                	sd	s1,24(sp)
    800016ac:	e84a                	sd	s2,16(sp)
    800016ae:	e44e                	sd	s3,8(sp)
    800016b0:	e052                	sd	s4,0(sp)
    800016b2:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800016b4:	00000097          	auipc	ra,0x0
    800016b8:	c22080e7          	jalr	-990(ra) # 800012d6 <myproc>
    800016bc:	892a                	mv	s2,a0
  if((np = allocproc()) == 0){
    800016be:	00000097          	auipc	ra,0x0
    800016c2:	e22080e7          	jalr	-478(ra) # 800014e0 <allocproc>
    800016c6:	10050b63          	beqz	a0,800017dc <fork+0x138>
    800016ca:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    800016cc:	04893603          	ld	a2,72(s2)
    800016d0:	692c                	ld	a1,80(a0)
    800016d2:	05093503          	ld	a0,80(s2)
    800016d6:	fffff097          	auipc	ra,0xfffff
    800016da:	328080e7          	jalr	808(ra) # 800009fe <uvmcopy>
    800016de:	04054663          	bltz	a0,8000172a <fork+0x86>
  np->sz = p->sz;
    800016e2:	04893783          	ld	a5,72(s2)
    800016e6:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    800016ea:	05893683          	ld	a3,88(s2)
    800016ee:	87b6                	mv	a5,a3
    800016f0:	0589b703          	ld	a4,88(s3)
    800016f4:	12068693          	addi	a3,a3,288
    800016f8:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800016fc:	6788                	ld	a0,8(a5)
    800016fe:	6b8c                	ld	a1,16(a5)
    80001700:	6f90                	ld	a2,24(a5)
    80001702:	01073023          	sd	a6,0(a4)
    80001706:	e708                	sd	a0,8(a4)
    80001708:	eb0c                	sd	a1,16(a4)
    8000170a:	ef10                	sd	a2,24(a4)
    8000170c:	02078793          	addi	a5,a5,32
    80001710:	02070713          	addi	a4,a4,32
    80001714:	fed792e3          	bne	a5,a3,800016f8 <fork+0x54>
  np->trapframe->a0 = 0;
    80001718:	0589b783          	ld	a5,88(s3)
    8000171c:	0607b823          	sd	zero,112(a5)
    80001720:	0d000493          	li	s1,208
  for(i = 0; i < NOFILE; i++)
    80001724:	15000a13          	li	s4,336
    80001728:	a03d                	j	80001756 <fork+0xb2>
    freeproc(np);
    8000172a:	854e                	mv	a0,s3
    8000172c:	00000097          	auipc	ra,0x0
    80001730:	d5c080e7          	jalr	-676(ra) # 80001488 <freeproc>
    release(&np->lock);
    80001734:	854e                	mv	a0,s3
    80001736:	00005097          	auipc	ra,0x5
    8000173a:	2e8080e7          	jalr	744(ra) # 80006a1e <release>
    return -1;
    8000173e:	5a7d                	li	s4,-1
    80001740:	a069                	j	800017ca <fork+0x126>
      np->ofile[i] = filedup(p->ofile[i]);
    80001742:	00003097          	auipc	ra,0x3
    80001746:	864080e7          	jalr	-1948(ra) # 80003fa6 <filedup>
    8000174a:	009987b3          	add	a5,s3,s1
    8000174e:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    80001750:	04a1                	addi	s1,s1,8
    80001752:	01448763          	beq	s1,s4,80001760 <fork+0xbc>
    if(p->ofile[i])
    80001756:	009907b3          	add	a5,s2,s1
    8000175a:	6388                	ld	a0,0(a5)
    8000175c:	f17d                	bnez	a0,80001742 <fork+0x9e>
    8000175e:	bfcd                	j	80001750 <fork+0xac>
  np->cwd = idup(p->cwd);
    80001760:	15093503          	ld	a0,336(s2)
    80001764:	00002097          	auipc	ra,0x2
    80001768:	830080e7          	jalr	-2000(ra) # 80002f94 <idup>
    8000176c:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001770:	4641                	li	a2,16
    80001772:	15890593          	addi	a1,s2,344
    80001776:	15898513          	addi	a0,s3,344
    8000177a:	fffff097          	auipc	ra,0xfffff
    8000177e:	b50080e7          	jalr	-1200(ra) # 800002ca <safestrcpy>
  pid = np->pid;
    80001782:	0309aa03          	lw	s4,48(s3)
  release(&np->lock);
    80001786:	854e                	mv	a0,s3
    80001788:	00005097          	auipc	ra,0x5
    8000178c:	296080e7          	jalr	662(ra) # 80006a1e <release>
  acquire(&wait_lock);
    80001790:	00008497          	auipc	s1,0x8
    80001794:	8d848493          	addi	s1,s1,-1832 # 80009068 <wait_lock>
    80001798:	8526                	mv	a0,s1
    8000179a:	00005097          	auipc	ra,0x5
    8000179e:	1d0080e7          	jalr	464(ra) # 8000696a <acquire>
  np->parent = p;
    800017a2:	0329bc23          	sd	s2,56(s3)
  release(&wait_lock);
    800017a6:	8526                	mv	a0,s1
    800017a8:	00005097          	auipc	ra,0x5
    800017ac:	276080e7          	jalr	630(ra) # 80006a1e <release>
  acquire(&np->lock);
    800017b0:	854e                	mv	a0,s3
    800017b2:	00005097          	auipc	ra,0x5
    800017b6:	1b8080e7          	jalr	440(ra) # 8000696a <acquire>
  np->state = RUNNABLE;
    800017ba:	478d                	li	a5,3
    800017bc:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    800017c0:	854e                	mv	a0,s3
    800017c2:	00005097          	auipc	ra,0x5
    800017c6:	25c080e7          	jalr	604(ra) # 80006a1e <release>
}
    800017ca:	8552                	mv	a0,s4
    800017cc:	70a2                	ld	ra,40(sp)
    800017ce:	7402                	ld	s0,32(sp)
    800017d0:	64e2                	ld	s1,24(sp)
    800017d2:	6942                	ld	s2,16(sp)
    800017d4:	69a2                	ld	s3,8(sp)
    800017d6:	6a02                	ld	s4,0(sp)
    800017d8:	6145                	addi	sp,sp,48
    800017da:	8082                	ret
    return -1;
    800017dc:	5a7d                	li	s4,-1
    800017de:	b7f5                	j	800017ca <fork+0x126>

00000000800017e0 <scheduler>:
{
    800017e0:	7139                	addi	sp,sp,-64
    800017e2:	fc06                	sd	ra,56(sp)
    800017e4:	f822                	sd	s0,48(sp)
    800017e6:	f426                	sd	s1,40(sp)
    800017e8:	f04a                	sd	s2,32(sp)
    800017ea:	ec4e                	sd	s3,24(sp)
    800017ec:	e852                	sd	s4,16(sp)
    800017ee:	e456                	sd	s5,8(sp)
    800017f0:	e05a                	sd	s6,0(sp)
    800017f2:	0080                	addi	s0,sp,64
    800017f4:	8792                	mv	a5,tp
  int id = r_tp();
    800017f6:	2781                	sext.w	a5,a5
  c->proc = 0;
    800017f8:	00779a93          	slli	s5,a5,0x7
    800017fc:	00008717          	auipc	a4,0x8
    80001800:	85470713          	addi	a4,a4,-1964 # 80009050 <pid_lock>
    80001804:	9756                	add	a4,a4,s5
    80001806:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    8000180a:	00008717          	auipc	a4,0x8
    8000180e:	87e70713          	addi	a4,a4,-1922 # 80009088 <cpus+0x8>
    80001812:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    80001814:	498d                	li	s3,3
        p->state = RUNNING;
    80001816:	4b11                	li	s6,4
        c->proc = p;
    80001818:	079e                	slli	a5,a5,0x7
    8000181a:	00008a17          	auipc	s4,0x8
    8000181e:	836a0a13          	addi	s4,s4,-1994 # 80009050 <pid_lock>
    80001822:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001824:	0000d917          	auipc	s2,0xd
    80001828:	65c90913          	addi	s2,s2,1628 # 8000ee80 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000182c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001830:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001834:	10079073          	csrw	sstatus,a5
    80001838:	00008497          	auipc	s1,0x8
    8000183c:	c4848493          	addi	s1,s1,-952 # 80009480 <proc>
    80001840:	a03d                	j	8000186e <scheduler+0x8e>
        p->state = RUNNING;
    80001842:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80001846:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    8000184a:	06048593          	addi	a1,s1,96
    8000184e:	8556                	mv	a0,s5
    80001850:	00000097          	auipc	ra,0x0
    80001854:	640080e7          	jalr	1600(ra) # 80001e90 <swtch>
        c->proc = 0;
    80001858:	020a3823          	sd	zero,48(s4)
      release(&p->lock);
    8000185c:	8526                	mv	a0,s1
    8000185e:	00005097          	auipc	ra,0x5
    80001862:	1c0080e7          	jalr	448(ra) # 80006a1e <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001866:	16848493          	addi	s1,s1,360
    8000186a:	fd2481e3          	beq	s1,s2,8000182c <scheduler+0x4c>
      acquire(&p->lock);
    8000186e:	8526                	mv	a0,s1
    80001870:	00005097          	auipc	ra,0x5
    80001874:	0fa080e7          	jalr	250(ra) # 8000696a <acquire>
      if(p->state == RUNNABLE) {
    80001878:	4c9c                	lw	a5,24(s1)
    8000187a:	ff3791e3          	bne	a5,s3,8000185c <scheduler+0x7c>
    8000187e:	b7d1                	j	80001842 <scheduler+0x62>

0000000080001880 <sched>:
{
    80001880:	7179                	addi	sp,sp,-48
    80001882:	f406                	sd	ra,40(sp)
    80001884:	f022                	sd	s0,32(sp)
    80001886:	ec26                	sd	s1,24(sp)
    80001888:	e84a                	sd	s2,16(sp)
    8000188a:	e44e                	sd	s3,8(sp)
    8000188c:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000188e:	00000097          	auipc	ra,0x0
    80001892:	a48080e7          	jalr	-1464(ra) # 800012d6 <myproc>
    80001896:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001898:	00005097          	auipc	ra,0x5
    8000189c:	058080e7          	jalr	88(ra) # 800068f0 <holding>
    800018a0:	c93d                	beqz	a0,80001916 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    800018a2:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    800018a4:	2781                	sext.w	a5,a5
    800018a6:	079e                	slli	a5,a5,0x7
    800018a8:	00007717          	auipc	a4,0x7
    800018ac:	7a870713          	addi	a4,a4,1960 # 80009050 <pid_lock>
    800018b0:	97ba                	add	a5,a5,a4
    800018b2:	0a87a703          	lw	a4,168(a5)
    800018b6:	4785                	li	a5,1
    800018b8:	06f71763          	bne	a4,a5,80001926 <sched+0xa6>
  if(p->state == RUNNING)
    800018bc:	4c98                	lw	a4,24(s1)
    800018be:	4791                	li	a5,4
    800018c0:	06f70b63          	beq	a4,a5,80001936 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800018c4:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800018c8:	8b89                	andi	a5,a5,2
  if(intr_get())
    800018ca:	efb5                	bnez	a5,80001946 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    800018cc:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800018ce:	00007917          	auipc	s2,0x7
    800018d2:	78290913          	addi	s2,s2,1922 # 80009050 <pid_lock>
    800018d6:	2781                	sext.w	a5,a5
    800018d8:	079e                	slli	a5,a5,0x7
    800018da:	97ca                	add	a5,a5,s2
    800018dc:	0ac7a983          	lw	s3,172(a5)
    800018e0:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800018e2:	2781                	sext.w	a5,a5
    800018e4:	079e                	slli	a5,a5,0x7
    800018e6:	00007597          	auipc	a1,0x7
    800018ea:	7a258593          	addi	a1,a1,1954 # 80009088 <cpus+0x8>
    800018ee:	95be                	add	a1,a1,a5
    800018f0:	06048513          	addi	a0,s1,96
    800018f4:	00000097          	auipc	ra,0x0
    800018f8:	59c080e7          	jalr	1436(ra) # 80001e90 <swtch>
    800018fc:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800018fe:	2781                	sext.w	a5,a5
    80001900:	079e                	slli	a5,a5,0x7
    80001902:	97ca                	add	a5,a5,s2
    80001904:	0b37a623          	sw	s3,172(a5)
}
    80001908:	70a2                	ld	ra,40(sp)
    8000190a:	7402                	ld	s0,32(sp)
    8000190c:	64e2                	ld	s1,24(sp)
    8000190e:	6942                	ld	s2,16(sp)
    80001910:	69a2                	ld	s3,8(sp)
    80001912:	6145                	addi	sp,sp,48
    80001914:	8082                	ret
    panic("sched p->lock");
    80001916:	00007517          	auipc	a0,0x7
    8000191a:	92250513          	addi	a0,a0,-1758 # 80008238 <etext+0x238>
    8000191e:	00005097          	auipc	ra,0x5
    80001922:	b02080e7          	jalr	-1278(ra) # 80006420 <panic>
    panic("sched locks");
    80001926:	00007517          	auipc	a0,0x7
    8000192a:	92250513          	addi	a0,a0,-1758 # 80008248 <etext+0x248>
    8000192e:	00005097          	auipc	ra,0x5
    80001932:	af2080e7          	jalr	-1294(ra) # 80006420 <panic>
    panic("sched running");
    80001936:	00007517          	auipc	a0,0x7
    8000193a:	92250513          	addi	a0,a0,-1758 # 80008258 <etext+0x258>
    8000193e:	00005097          	auipc	ra,0x5
    80001942:	ae2080e7          	jalr	-1310(ra) # 80006420 <panic>
    panic("sched interruptible");
    80001946:	00007517          	auipc	a0,0x7
    8000194a:	92250513          	addi	a0,a0,-1758 # 80008268 <etext+0x268>
    8000194e:	00005097          	auipc	ra,0x5
    80001952:	ad2080e7          	jalr	-1326(ra) # 80006420 <panic>

0000000080001956 <yield>:
{
    80001956:	1101                	addi	sp,sp,-32
    80001958:	ec06                	sd	ra,24(sp)
    8000195a:	e822                	sd	s0,16(sp)
    8000195c:	e426                	sd	s1,8(sp)
    8000195e:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001960:	00000097          	auipc	ra,0x0
    80001964:	976080e7          	jalr	-1674(ra) # 800012d6 <myproc>
    80001968:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000196a:	00005097          	auipc	ra,0x5
    8000196e:	000080e7          	jalr	ra # 8000696a <acquire>
  p->state = RUNNABLE;
    80001972:	478d                	li	a5,3
    80001974:	cc9c                	sw	a5,24(s1)
  sched();
    80001976:	00000097          	auipc	ra,0x0
    8000197a:	f0a080e7          	jalr	-246(ra) # 80001880 <sched>
  release(&p->lock);
    8000197e:	8526                	mv	a0,s1
    80001980:	00005097          	auipc	ra,0x5
    80001984:	09e080e7          	jalr	158(ra) # 80006a1e <release>
}
    80001988:	60e2                	ld	ra,24(sp)
    8000198a:	6442                	ld	s0,16(sp)
    8000198c:	64a2                	ld	s1,8(sp)
    8000198e:	6105                	addi	sp,sp,32
    80001990:	8082                	ret

0000000080001992 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001992:	7179                	addi	sp,sp,-48
    80001994:	f406                	sd	ra,40(sp)
    80001996:	f022                	sd	s0,32(sp)
    80001998:	ec26                	sd	s1,24(sp)
    8000199a:	e84a                	sd	s2,16(sp)
    8000199c:	e44e                	sd	s3,8(sp)
    8000199e:	1800                	addi	s0,sp,48
    800019a0:	89aa                	mv	s3,a0
    800019a2:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800019a4:	00000097          	auipc	ra,0x0
    800019a8:	932080e7          	jalr	-1742(ra) # 800012d6 <myproc>
    800019ac:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    800019ae:	00005097          	auipc	ra,0x5
    800019b2:	fbc080e7          	jalr	-68(ra) # 8000696a <acquire>
  release(lk);
    800019b6:	854a                	mv	a0,s2
    800019b8:	00005097          	auipc	ra,0x5
    800019bc:	066080e7          	jalr	102(ra) # 80006a1e <release>

  // Go to sleep.
  p->chan = chan;
    800019c0:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    800019c4:	4789                	li	a5,2
    800019c6:	cc9c                	sw	a5,24(s1)

  sched();
    800019c8:	00000097          	auipc	ra,0x0
    800019cc:	eb8080e7          	jalr	-328(ra) # 80001880 <sched>

  // Tidy up.
  p->chan = 0;
    800019d0:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    800019d4:	8526                	mv	a0,s1
    800019d6:	00005097          	auipc	ra,0x5
    800019da:	048080e7          	jalr	72(ra) # 80006a1e <release>
  acquire(lk);
    800019de:	854a                	mv	a0,s2
    800019e0:	00005097          	auipc	ra,0x5
    800019e4:	f8a080e7          	jalr	-118(ra) # 8000696a <acquire>
}
    800019e8:	70a2                	ld	ra,40(sp)
    800019ea:	7402                	ld	s0,32(sp)
    800019ec:	64e2                	ld	s1,24(sp)
    800019ee:	6942                	ld	s2,16(sp)
    800019f0:	69a2                	ld	s3,8(sp)
    800019f2:	6145                	addi	sp,sp,48
    800019f4:	8082                	ret

00000000800019f6 <wait>:
{
    800019f6:	715d                	addi	sp,sp,-80
    800019f8:	e486                	sd	ra,72(sp)
    800019fa:	e0a2                	sd	s0,64(sp)
    800019fc:	fc26                	sd	s1,56(sp)
    800019fe:	f84a                	sd	s2,48(sp)
    80001a00:	f44e                	sd	s3,40(sp)
    80001a02:	f052                	sd	s4,32(sp)
    80001a04:	ec56                	sd	s5,24(sp)
    80001a06:	e85a                	sd	s6,16(sp)
    80001a08:	e45e                	sd	s7,8(sp)
    80001a0a:	e062                	sd	s8,0(sp)
    80001a0c:	0880                	addi	s0,sp,80
    80001a0e:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80001a10:	00000097          	auipc	ra,0x0
    80001a14:	8c6080e7          	jalr	-1850(ra) # 800012d6 <myproc>
    80001a18:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001a1a:	00007517          	auipc	a0,0x7
    80001a1e:	64e50513          	addi	a0,a0,1614 # 80009068 <wait_lock>
    80001a22:	00005097          	auipc	ra,0x5
    80001a26:	f48080e7          	jalr	-184(ra) # 8000696a <acquire>
    havekids = 0;
    80001a2a:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    80001a2c:	4a15                	li	s4,5
    for(np = proc; np < &proc[NPROC]; np++){
    80001a2e:	0000d997          	auipc	s3,0xd
    80001a32:	45298993          	addi	s3,s3,1106 # 8000ee80 <tickslock>
        havekids = 1;
    80001a36:	4a85                	li	s5,1
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001a38:	00007c17          	auipc	s8,0x7
    80001a3c:	630c0c13          	addi	s8,s8,1584 # 80009068 <wait_lock>
    havekids = 0;
    80001a40:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    80001a42:	00008497          	auipc	s1,0x8
    80001a46:	a3e48493          	addi	s1,s1,-1474 # 80009480 <proc>
    80001a4a:	a0bd                	j	80001ab8 <wait+0xc2>
          pid = np->pid;
    80001a4c:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    80001a50:	000b0e63          	beqz	s6,80001a6c <wait+0x76>
    80001a54:	4691                	li	a3,4
    80001a56:	02c48613          	addi	a2,s1,44
    80001a5a:	85da                	mv	a1,s6
    80001a5c:	05093503          	ld	a0,80(s2)
    80001a60:	fffff097          	auipc	ra,0xfffff
    80001a64:	0a2080e7          	jalr	162(ra) # 80000b02 <copyout>
    80001a68:	02054563          	bltz	a0,80001a92 <wait+0x9c>
          freeproc(np);
    80001a6c:	8526                	mv	a0,s1
    80001a6e:	00000097          	auipc	ra,0x0
    80001a72:	a1a080e7          	jalr	-1510(ra) # 80001488 <freeproc>
          release(&np->lock);
    80001a76:	8526                	mv	a0,s1
    80001a78:	00005097          	auipc	ra,0x5
    80001a7c:	fa6080e7          	jalr	-90(ra) # 80006a1e <release>
          release(&wait_lock);
    80001a80:	00007517          	auipc	a0,0x7
    80001a84:	5e850513          	addi	a0,a0,1512 # 80009068 <wait_lock>
    80001a88:	00005097          	auipc	ra,0x5
    80001a8c:	f96080e7          	jalr	-106(ra) # 80006a1e <release>
          return pid;
    80001a90:	a09d                	j	80001af6 <wait+0x100>
            release(&np->lock);
    80001a92:	8526                	mv	a0,s1
    80001a94:	00005097          	auipc	ra,0x5
    80001a98:	f8a080e7          	jalr	-118(ra) # 80006a1e <release>
            release(&wait_lock);
    80001a9c:	00007517          	auipc	a0,0x7
    80001aa0:	5cc50513          	addi	a0,a0,1484 # 80009068 <wait_lock>
    80001aa4:	00005097          	auipc	ra,0x5
    80001aa8:	f7a080e7          	jalr	-134(ra) # 80006a1e <release>
            return -1;
    80001aac:	59fd                	li	s3,-1
    80001aae:	a0a1                	j	80001af6 <wait+0x100>
    for(np = proc; np < &proc[NPROC]; np++){
    80001ab0:	16848493          	addi	s1,s1,360
    80001ab4:	03348463          	beq	s1,s3,80001adc <wait+0xe6>
      if(np->parent == p){
    80001ab8:	7c9c                	ld	a5,56(s1)
    80001aba:	ff279be3          	bne	a5,s2,80001ab0 <wait+0xba>
        acquire(&np->lock);
    80001abe:	8526                	mv	a0,s1
    80001ac0:	00005097          	auipc	ra,0x5
    80001ac4:	eaa080e7          	jalr	-342(ra) # 8000696a <acquire>
        if(np->state == ZOMBIE){
    80001ac8:	4c9c                	lw	a5,24(s1)
    80001aca:	f94781e3          	beq	a5,s4,80001a4c <wait+0x56>
        release(&np->lock);
    80001ace:	8526                	mv	a0,s1
    80001ad0:	00005097          	auipc	ra,0x5
    80001ad4:	f4e080e7          	jalr	-178(ra) # 80006a1e <release>
        havekids = 1;
    80001ad8:	8756                	mv	a4,s5
    80001ada:	bfd9                	j	80001ab0 <wait+0xba>
    if(!havekids || p->killed){
    80001adc:	c701                	beqz	a4,80001ae4 <wait+0xee>
    80001ade:	02892783          	lw	a5,40(s2)
    80001ae2:	c79d                	beqz	a5,80001b10 <wait+0x11a>
      release(&wait_lock);
    80001ae4:	00007517          	auipc	a0,0x7
    80001ae8:	58450513          	addi	a0,a0,1412 # 80009068 <wait_lock>
    80001aec:	00005097          	auipc	ra,0x5
    80001af0:	f32080e7          	jalr	-206(ra) # 80006a1e <release>
      return -1;
    80001af4:	59fd                	li	s3,-1
}
    80001af6:	854e                	mv	a0,s3
    80001af8:	60a6                	ld	ra,72(sp)
    80001afa:	6406                	ld	s0,64(sp)
    80001afc:	74e2                	ld	s1,56(sp)
    80001afe:	7942                	ld	s2,48(sp)
    80001b00:	79a2                	ld	s3,40(sp)
    80001b02:	7a02                	ld	s4,32(sp)
    80001b04:	6ae2                	ld	s5,24(sp)
    80001b06:	6b42                	ld	s6,16(sp)
    80001b08:	6ba2                	ld	s7,8(sp)
    80001b0a:	6c02                	ld	s8,0(sp)
    80001b0c:	6161                	addi	sp,sp,80
    80001b0e:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001b10:	85e2                	mv	a1,s8
    80001b12:	854a                	mv	a0,s2
    80001b14:	00000097          	auipc	ra,0x0
    80001b18:	e7e080e7          	jalr	-386(ra) # 80001992 <sleep>
    havekids = 0;
    80001b1c:	b715                	j	80001a40 <wait+0x4a>

0000000080001b1e <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80001b1e:	7139                	addi	sp,sp,-64
    80001b20:	fc06                	sd	ra,56(sp)
    80001b22:	f822                	sd	s0,48(sp)
    80001b24:	f426                	sd	s1,40(sp)
    80001b26:	f04a                	sd	s2,32(sp)
    80001b28:	ec4e                	sd	s3,24(sp)
    80001b2a:	e852                	sd	s4,16(sp)
    80001b2c:	e456                	sd	s5,8(sp)
    80001b2e:	0080                	addi	s0,sp,64
    80001b30:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001b32:	00008497          	auipc	s1,0x8
    80001b36:	94e48493          	addi	s1,s1,-1714 # 80009480 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001b3a:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001b3c:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001b3e:	0000d917          	auipc	s2,0xd
    80001b42:	34290913          	addi	s2,s2,834 # 8000ee80 <tickslock>
    80001b46:	a821                	j	80001b5e <wakeup+0x40>
        p->state = RUNNABLE;
    80001b48:	0154ac23          	sw	s5,24(s1)
      }
      release(&p->lock);
    80001b4c:	8526                	mv	a0,s1
    80001b4e:	00005097          	auipc	ra,0x5
    80001b52:	ed0080e7          	jalr	-304(ra) # 80006a1e <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001b56:	16848493          	addi	s1,s1,360
    80001b5a:	03248463          	beq	s1,s2,80001b82 <wakeup+0x64>
    if(p != myproc()){
    80001b5e:	fffff097          	auipc	ra,0xfffff
    80001b62:	778080e7          	jalr	1912(ra) # 800012d6 <myproc>
    80001b66:	fea488e3          	beq	s1,a0,80001b56 <wakeup+0x38>
      acquire(&p->lock);
    80001b6a:	8526                	mv	a0,s1
    80001b6c:	00005097          	auipc	ra,0x5
    80001b70:	dfe080e7          	jalr	-514(ra) # 8000696a <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001b74:	4c9c                	lw	a5,24(s1)
    80001b76:	fd379be3          	bne	a5,s3,80001b4c <wakeup+0x2e>
    80001b7a:	709c                	ld	a5,32(s1)
    80001b7c:	fd4798e3          	bne	a5,s4,80001b4c <wakeup+0x2e>
    80001b80:	b7e1                	j	80001b48 <wakeup+0x2a>
    }
  }
}
    80001b82:	70e2                	ld	ra,56(sp)
    80001b84:	7442                	ld	s0,48(sp)
    80001b86:	74a2                	ld	s1,40(sp)
    80001b88:	7902                	ld	s2,32(sp)
    80001b8a:	69e2                	ld	s3,24(sp)
    80001b8c:	6a42                	ld	s4,16(sp)
    80001b8e:	6aa2                	ld	s5,8(sp)
    80001b90:	6121                	addi	sp,sp,64
    80001b92:	8082                	ret

0000000080001b94 <reparent>:
{
    80001b94:	7179                	addi	sp,sp,-48
    80001b96:	f406                	sd	ra,40(sp)
    80001b98:	f022                	sd	s0,32(sp)
    80001b9a:	ec26                	sd	s1,24(sp)
    80001b9c:	e84a                	sd	s2,16(sp)
    80001b9e:	e44e                	sd	s3,8(sp)
    80001ba0:	e052                	sd	s4,0(sp)
    80001ba2:	1800                	addi	s0,sp,48
    80001ba4:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001ba6:	00008497          	auipc	s1,0x8
    80001baa:	8da48493          	addi	s1,s1,-1830 # 80009480 <proc>
      pp->parent = initproc;
    80001bae:	00007a17          	auipc	s4,0x7
    80001bb2:	462a0a13          	addi	s4,s4,1122 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001bb6:	0000d997          	auipc	s3,0xd
    80001bba:	2ca98993          	addi	s3,s3,714 # 8000ee80 <tickslock>
    80001bbe:	a029                	j	80001bc8 <reparent+0x34>
    80001bc0:	16848493          	addi	s1,s1,360
    80001bc4:	01348d63          	beq	s1,s3,80001bde <reparent+0x4a>
    if(pp->parent == p){
    80001bc8:	7c9c                	ld	a5,56(s1)
    80001bca:	ff279be3          	bne	a5,s2,80001bc0 <reparent+0x2c>
      pp->parent = initproc;
    80001bce:	000a3503          	ld	a0,0(s4)
    80001bd2:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001bd4:	00000097          	auipc	ra,0x0
    80001bd8:	f4a080e7          	jalr	-182(ra) # 80001b1e <wakeup>
    80001bdc:	b7d5                	j	80001bc0 <reparent+0x2c>
}
    80001bde:	70a2                	ld	ra,40(sp)
    80001be0:	7402                	ld	s0,32(sp)
    80001be2:	64e2                	ld	s1,24(sp)
    80001be4:	6942                	ld	s2,16(sp)
    80001be6:	69a2                	ld	s3,8(sp)
    80001be8:	6a02                	ld	s4,0(sp)
    80001bea:	6145                	addi	sp,sp,48
    80001bec:	8082                	ret

0000000080001bee <exit>:
{
    80001bee:	7179                	addi	sp,sp,-48
    80001bf0:	f406                	sd	ra,40(sp)
    80001bf2:	f022                	sd	s0,32(sp)
    80001bf4:	ec26                	sd	s1,24(sp)
    80001bf6:	e84a                	sd	s2,16(sp)
    80001bf8:	e44e                	sd	s3,8(sp)
    80001bfa:	e052                	sd	s4,0(sp)
    80001bfc:	1800                	addi	s0,sp,48
    80001bfe:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001c00:	fffff097          	auipc	ra,0xfffff
    80001c04:	6d6080e7          	jalr	1750(ra) # 800012d6 <myproc>
    80001c08:	89aa                	mv	s3,a0
  if(p == initproc)
    80001c0a:	00007797          	auipc	a5,0x7
    80001c0e:	4067b783          	ld	a5,1030(a5) # 80009010 <initproc>
    80001c12:	0d050493          	addi	s1,a0,208
    80001c16:	15050913          	addi	s2,a0,336
    80001c1a:	02a79363          	bne	a5,a0,80001c40 <exit+0x52>
    panic("init exiting");
    80001c1e:	00006517          	auipc	a0,0x6
    80001c22:	66250513          	addi	a0,a0,1634 # 80008280 <etext+0x280>
    80001c26:	00004097          	auipc	ra,0x4
    80001c2a:	7fa080e7          	jalr	2042(ra) # 80006420 <panic>
      fileclose(f);
    80001c2e:	00002097          	auipc	ra,0x2
    80001c32:	3ca080e7          	jalr	970(ra) # 80003ff8 <fileclose>
      p->ofile[fd] = 0;
    80001c36:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001c3a:	04a1                	addi	s1,s1,8
    80001c3c:	01248563          	beq	s1,s2,80001c46 <exit+0x58>
    if(p->ofile[fd]){
    80001c40:	6088                	ld	a0,0(s1)
    80001c42:	f575                	bnez	a0,80001c2e <exit+0x40>
    80001c44:	bfdd                	j	80001c3a <exit+0x4c>
  begin_op();
    80001c46:	00002097          	auipc	ra,0x2
    80001c4a:	ee6080e7          	jalr	-282(ra) # 80003b2c <begin_op>
  iput(p->cwd);
    80001c4e:	1509b503          	ld	a0,336(s3)
    80001c52:	00001097          	auipc	ra,0x1
    80001c56:	53a080e7          	jalr	1338(ra) # 8000318c <iput>
  end_op();
    80001c5a:	00002097          	auipc	ra,0x2
    80001c5e:	f52080e7          	jalr	-174(ra) # 80003bac <end_op>
  p->cwd = 0;
    80001c62:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80001c66:	00007497          	auipc	s1,0x7
    80001c6a:	40248493          	addi	s1,s1,1026 # 80009068 <wait_lock>
    80001c6e:	8526                	mv	a0,s1
    80001c70:	00005097          	auipc	ra,0x5
    80001c74:	cfa080e7          	jalr	-774(ra) # 8000696a <acquire>
  reparent(p);
    80001c78:	854e                	mv	a0,s3
    80001c7a:	00000097          	auipc	ra,0x0
    80001c7e:	f1a080e7          	jalr	-230(ra) # 80001b94 <reparent>
  wakeup(p->parent);
    80001c82:	0389b503          	ld	a0,56(s3)
    80001c86:	00000097          	auipc	ra,0x0
    80001c8a:	e98080e7          	jalr	-360(ra) # 80001b1e <wakeup>
  acquire(&p->lock);
    80001c8e:	854e                	mv	a0,s3
    80001c90:	00005097          	auipc	ra,0x5
    80001c94:	cda080e7          	jalr	-806(ra) # 8000696a <acquire>
  p->xstate = status;
    80001c98:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001c9c:	4795                	li	a5,5
    80001c9e:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001ca2:	8526                	mv	a0,s1
    80001ca4:	00005097          	auipc	ra,0x5
    80001ca8:	d7a080e7          	jalr	-646(ra) # 80006a1e <release>
  sched();
    80001cac:	00000097          	auipc	ra,0x0
    80001cb0:	bd4080e7          	jalr	-1068(ra) # 80001880 <sched>
  panic("zombie exit");
    80001cb4:	00006517          	auipc	a0,0x6
    80001cb8:	5dc50513          	addi	a0,a0,1500 # 80008290 <etext+0x290>
    80001cbc:	00004097          	auipc	ra,0x4
    80001cc0:	764080e7          	jalr	1892(ra) # 80006420 <panic>

0000000080001cc4 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001cc4:	7179                	addi	sp,sp,-48
    80001cc6:	f406                	sd	ra,40(sp)
    80001cc8:	f022                	sd	s0,32(sp)
    80001cca:	ec26                	sd	s1,24(sp)
    80001ccc:	e84a                	sd	s2,16(sp)
    80001cce:	e44e                	sd	s3,8(sp)
    80001cd0:	1800                	addi	s0,sp,48
    80001cd2:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001cd4:	00007497          	auipc	s1,0x7
    80001cd8:	7ac48493          	addi	s1,s1,1964 # 80009480 <proc>
    80001cdc:	0000d997          	auipc	s3,0xd
    80001ce0:	1a498993          	addi	s3,s3,420 # 8000ee80 <tickslock>
    acquire(&p->lock);
    80001ce4:	8526                	mv	a0,s1
    80001ce6:	00005097          	auipc	ra,0x5
    80001cea:	c84080e7          	jalr	-892(ra) # 8000696a <acquire>
    if(p->pid == pid){
    80001cee:	589c                	lw	a5,48(s1)
    80001cf0:	01278d63          	beq	a5,s2,80001d0a <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001cf4:	8526                	mv	a0,s1
    80001cf6:	00005097          	auipc	ra,0x5
    80001cfa:	d28080e7          	jalr	-728(ra) # 80006a1e <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001cfe:	16848493          	addi	s1,s1,360
    80001d02:	ff3491e3          	bne	s1,s3,80001ce4 <kill+0x20>
  }
  return -1;
    80001d06:	557d                	li	a0,-1
    80001d08:	a829                	j	80001d22 <kill+0x5e>
      p->killed = 1;
    80001d0a:	4785                	li	a5,1
    80001d0c:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001d0e:	4c98                	lw	a4,24(s1)
    80001d10:	4789                	li	a5,2
    80001d12:	00f70f63          	beq	a4,a5,80001d30 <kill+0x6c>
      release(&p->lock);
    80001d16:	8526                	mv	a0,s1
    80001d18:	00005097          	auipc	ra,0x5
    80001d1c:	d06080e7          	jalr	-762(ra) # 80006a1e <release>
      return 0;
    80001d20:	4501                	li	a0,0
}
    80001d22:	70a2                	ld	ra,40(sp)
    80001d24:	7402                	ld	s0,32(sp)
    80001d26:	64e2                	ld	s1,24(sp)
    80001d28:	6942                	ld	s2,16(sp)
    80001d2a:	69a2                	ld	s3,8(sp)
    80001d2c:	6145                	addi	sp,sp,48
    80001d2e:	8082                	ret
        p->state = RUNNABLE;
    80001d30:	478d                	li	a5,3
    80001d32:	cc9c                	sw	a5,24(s1)
    80001d34:	b7cd                	j	80001d16 <kill+0x52>

0000000080001d36 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001d36:	7179                	addi	sp,sp,-48
    80001d38:	f406                	sd	ra,40(sp)
    80001d3a:	f022                	sd	s0,32(sp)
    80001d3c:	ec26                	sd	s1,24(sp)
    80001d3e:	e84a                	sd	s2,16(sp)
    80001d40:	e44e                	sd	s3,8(sp)
    80001d42:	e052                	sd	s4,0(sp)
    80001d44:	1800                	addi	s0,sp,48
    80001d46:	84aa                	mv	s1,a0
    80001d48:	892e                	mv	s2,a1
    80001d4a:	89b2                	mv	s3,a2
    80001d4c:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001d4e:	fffff097          	auipc	ra,0xfffff
    80001d52:	588080e7          	jalr	1416(ra) # 800012d6 <myproc>
  if(user_dst){
    80001d56:	c08d                	beqz	s1,80001d78 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001d58:	86d2                	mv	a3,s4
    80001d5a:	864e                	mv	a2,s3
    80001d5c:	85ca                	mv	a1,s2
    80001d5e:	6928                	ld	a0,80(a0)
    80001d60:	fffff097          	auipc	ra,0xfffff
    80001d64:	da2080e7          	jalr	-606(ra) # 80000b02 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001d68:	70a2                	ld	ra,40(sp)
    80001d6a:	7402                	ld	s0,32(sp)
    80001d6c:	64e2                	ld	s1,24(sp)
    80001d6e:	6942                	ld	s2,16(sp)
    80001d70:	69a2                	ld	s3,8(sp)
    80001d72:	6a02                	ld	s4,0(sp)
    80001d74:	6145                	addi	sp,sp,48
    80001d76:	8082                	ret
    memmove((char *)dst, src, len);
    80001d78:	000a061b          	sext.w	a2,s4
    80001d7c:	85ce                	mv	a1,s3
    80001d7e:	854a                	mv	a0,s2
    80001d80:	ffffe097          	auipc	ra,0xffffe
    80001d84:	458080e7          	jalr	1112(ra) # 800001d8 <memmove>
    return 0;
    80001d88:	8526                	mv	a0,s1
    80001d8a:	bff9                	j	80001d68 <either_copyout+0x32>

0000000080001d8c <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001d8c:	7179                	addi	sp,sp,-48
    80001d8e:	f406                	sd	ra,40(sp)
    80001d90:	f022                	sd	s0,32(sp)
    80001d92:	ec26                	sd	s1,24(sp)
    80001d94:	e84a                	sd	s2,16(sp)
    80001d96:	e44e                	sd	s3,8(sp)
    80001d98:	e052                	sd	s4,0(sp)
    80001d9a:	1800                	addi	s0,sp,48
    80001d9c:	892a                	mv	s2,a0
    80001d9e:	84ae                	mv	s1,a1
    80001da0:	89b2                	mv	s3,a2
    80001da2:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001da4:	fffff097          	auipc	ra,0xfffff
    80001da8:	532080e7          	jalr	1330(ra) # 800012d6 <myproc>
  if(user_src){
    80001dac:	c08d                	beqz	s1,80001dce <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001dae:	86d2                	mv	a3,s4
    80001db0:	864e                	mv	a2,s3
    80001db2:	85ca                	mv	a1,s2
    80001db4:	6928                	ld	a0,80(a0)
    80001db6:	fffff097          	auipc	ra,0xfffff
    80001dba:	dd8080e7          	jalr	-552(ra) # 80000b8e <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001dbe:	70a2                	ld	ra,40(sp)
    80001dc0:	7402                	ld	s0,32(sp)
    80001dc2:	64e2                	ld	s1,24(sp)
    80001dc4:	6942                	ld	s2,16(sp)
    80001dc6:	69a2                	ld	s3,8(sp)
    80001dc8:	6a02                	ld	s4,0(sp)
    80001dca:	6145                	addi	sp,sp,48
    80001dcc:	8082                	ret
    memmove(dst, (char*)src, len);
    80001dce:	000a061b          	sext.w	a2,s4
    80001dd2:	85ce                	mv	a1,s3
    80001dd4:	854a                	mv	a0,s2
    80001dd6:	ffffe097          	auipc	ra,0xffffe
    80001dda:	402080e7          	jalr	1026(ra) # 800001d8 <memmove>
    return 0;
    80001dde:	8526                	mv	a0,s1
    80001de0:	bff9                	j	80001dbe <either_copyin+0x32>

0000000080001de2 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001de2:	715d                	addi	sp,sp,-80
    80001de4:	e486                	sd	ra,72(sp)
    80001de6:	e0a2                	sd	s0,64(sp)
    80001de8:	fc26                	sd	s1,56(sp)
    80001dea:	f84a                	sd	s2,48(sp)
    80001dec:	f44e                	sd	s3,40(sp)
    80001dee:	f052                	sd	s4,32(sp)
    80001df0:	ec56                	sd	s5,24(sp)
    80001df2:	e85a                	sd	s6,16(sp)
    80001df4:	e45e                	sd	s7,8(sp)
    80001df6:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001df8:	00006517          	auipc	a0,0x6
    80001dfc:	25050513          	addi	a0,a0,592 # 80008048 <etext+0x48>
    80001e00:	00004097          	auipc	ra,0x4
    80001e04:	66a080e7          	jalr	1642(ra) # 8000646a <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001e08:	00007497          	auipc	s1,0x7
    80001e0c:	7d048493          	addi	s1,s1,2000 # 800095d8 <proc+0x158>
    80001e10:	0000d917          	auipc	s2,0xd
    80001e14:	1c890913          	addi	s2,s2,456 # 8000efd8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001e18:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001e1a:	00006997          	auipc	s3,0x6
    80001e1e:	48698993          	addi	s3,s3,1158 # 800082a0 <etext+0x2a0>
    printf("%d %s %s", p->pid, state, p->name);
    80001e22:	00006a97          	auipc	s5,0x6
    80001e26:	486a8a93          	addi	s5,s5,1158 # 800082a8 <etext+0x2a8>
    printf("\n");
    80001e2a:	00006a17          	auipc	s4,0x6
    80001e2e:	21ea0a13          	addi	s4,s4,542 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001e32:	00006b97          	auipc	s7,0x6
    80001e36:	4aeb8b93          	addi	s7,s7,1198 # 800082e0 <states.1805>
    80001e3a:	a00d                	j	80001e5c <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001e3c:	ed86a583          	lw	a1,-296(a3)
    80001e40:	8556                	mv	a0,s5
    80001e42:	00004097          	auipc	ra,0x4
    80001e46:	628080e7          	jalr	1576(ra) # 8000646a <printf>
    printf("\n");
    80001e4a:	8552                	mv	a0,s4
    80001e4c:	00004097          	auipc	ra,0x4
    80001e50:	61e080e7          	jalr	1566(ra) # 8000646a <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001e54:	16848493          	addi	s1,s1,360
    80001e58:	03248163          	beq	s1,s2,80001e7a <procdump+0x98>
    if(p->state == UNUSED)
    80001e5c:	86a6                	mv	a3,s1
    80001e5e:	ec04a783          	lw	a5,-320(s1)
    80001e62:	dbed                	beqz	a5,80001e54 <procdump+0x72>
      state = "???";
    80001e64:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001e66:	fcfb6be3          	bltu	s6,a5,80001e3c <procdump+0x5a>
    80001e6a:	1782                	slli	a5,a5,0x20
    80001e6c:	9381                	srli	a5,a5,0x20
    80001e6e:	078e                	slli	a5,a5,0x3
    80001e70:	97de                	add	a5,a5,s7
    80001e72:	6390                	ld	a2,0(a5)
    80001e74:	f661                	bnez	a2,80001e3c <procdump+0x5a>
      state = "???";
    80001e76:	864e                	mv	a2,s3
    80001e78:	b7d1                	j	80001e3c <procdump+0x5a>
  }
}
    80001e7a:	60a6                	ld	ra,72(sp)
    80001e7c:	6406                	ld	s0,64(sp)
    80001e7e:	74e2                	ld	s1,56(sp)
    80001e80:	7942                	ld	s2,48(sp)
    80001e82:	79a2                	ld	s3,40(sp)
    80001e84:	7a02                	ld	s4,32(sp)
    80001e86:	6ae2                	ld	s5,24(sp)
    80001e88:	6b42                	ld	s6,16(sp)
    80001e8a:	6ba2                	ld	s7,8(sp)
    80001e8c:	6161                	addi	sp,sp,80
    80001e8e:	8082                	ret

0000000080001e90 <swtch>:
    80001e90:	00153023          	sd	ra,0(a0)
    80001e94:	00253423          	sd	sp,8(a0)
    80001e98:	e900                	sd	s0,16(a0)
    80001e9a:	ed04                	sd	s1,24(a0)
    80001e9c:	03253023          	sd	s2,32(a0)
    80001ea0:	03353423          	sd	s3,40(a0)
    80001ea4:	03453823          	sd	s4,48(a0)
    80001ea8:	03553c23          	sd	s5,56(a0)
    80001eac:	05653023          	sd	s6,64(a0)
    80001eb0:	05753423          	sd	s7,72(a0)
    80001eb4:	05853823          	sd	s8,80(a0)
    80001eb8:	05953c23          	sd	s9,88(a0)
    80001ebc:	07a53023          	sd	s10,96(a0)
    80001ec0:	07b53423          	sd	s11,104(a0)
    80001ec4:	0005b083          	ld	ra,0(a1)
    80001ec8:	0085b103          	ld	sp,8(a1)
    80001ecc:	6980                	ld	s0,16(a1)
    80001ece:	6d84                	ld	s1,24(a1)
    80001ed0:	0205b903          	ld	s2,32(a1)
    80001ed4:	0285b983          	ld	s3,40(a1)
    80001ed8:	0305ba03          	ld	s4,48(a1)
    80001edc:	0385ba83          	ld	s5,56(a1)
    80001ee0:	0405bb03          	ld	s6,64(a1)
    80001ee4:	0485bb83          	ld	s7,72(a1)
    80001ee8:	0505bc03          	ld	s8,80(a1)
    80001eec:	0585bc83          	ld	s9,88(a1)
    80001ef0:	0605bd03          	ld	s10,96(a1)
    80001ef4:	0685bd83          	ld	s11,104(a1)
    80001ef8:	8082                	ret

0000000080001efa <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001efa:	1141                	addi	sp,sp,-16
    80001efc:	e406                	sd	ra,8(sp)
    80001efe:	e022                	sd	s0,0(sp)
    80001f00:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001f02:	00006597          	auipc	a1,0x6
    80001f06:	40e58593          	addi	a1,a1,1038 # 80008310 <states.1805+0x30>
    80001f0a:	0000d517          	auipc	a0,0xd
    80001f0e:	f7650513          	addi	a0,a0,-138 # 8000ee80 <tickslock>
    80001f12:	00005097          	auipc	ra,0x5
    80001f16:	9c8080e7          	jalr	-1592(ra) # 800068da <initlock>
}
    80001f1a:	60a2                	ld	ra,8(sp)
    80001f1c:	6402                	ld	s0,0(sp)
    80001f1e:	0141                	addi	sp,sp,16
    80001f20:	8082                	ret

0000000080001f22 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001f22:	1141                	addi	sp,sp,-16
    80001f24:	e422                	sd	s0,8(sp)
    80001f26:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001f28:	00003797          	auipc	a5,0x3
    80001f2c:	6e878793          	addi	a5,a5,1768 # 80005610 <kernelvec>
    80001f30:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001f34:	6422                	ld	s0,8(sp)
    80001f36:	0141                	addi	sp,sp,16
    80001f38:	8082                	ret

0000000080001f3a <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001f3a:	1141                	addi	sp,sp,-16
    80001f3c:	e406                	sd	ra,8(sp)
    80001f3e:	e022                	sd	s0,0(sp)
    80001f40:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001f42:	fffff097          	auipc	ra,0xfffff
    80001f46:	394080e7          	jalr	916(ra) # 800012d6 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f4a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001f4e:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001f50:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001f54:	00005617          	auipc	a2,0x5
    80001f58:	0ac60613          	addi	a2,a2,172 # 80007000 <_trampoline>
    80001f5c:	00005697          	auipc	a3,0x5
    80001f60:	0a468693          	addi	a3,a3,164 # 80007000 <_trampoline>
    80001f64:	8e91                	sub	a3,a3,a2
    80001f66:	040007b7          	lui	a5,0x4000
    80001f6a:	17fd                	addi	a5,a5,-1
    80001f6c:	07b2                	slli	a5,a5,0xc
    80001f6e:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001f70:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001f74:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001f76:	180026f3          	csrr	a3,satp
    80001f7a:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001f7c:	6d38                	ld	a4,88(a0)
    80001f7e:	6134                	ld	a3,64(a0)
    80001f80:	6585                	lui	a1,0x1
    80001f82:	96ae                	add	a3,a3,a1
    80001f84:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001f86:	6d38                	ld	a4,88(a0)
    80001f88:	00000697          	auipc	a3,0x0
    80001f8c:	13868693          	addi	a3,a3,312 # 800020c0 <usertrap>
    80001f90:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001f92:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001f94:	8692                	mv	a3,tp
    80001f96:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f98:	100026f3          	csrr	a3,sstatus

  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001f9c:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001fa0:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001fa4:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001fa8:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001faa:	6f18                	ld	a4,24(a4)
    80001fac:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001fb0:	692c                	ld	a1,80(a0)
    80001fb2:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001fb4:	00005717          	auipc	a4,0x5
    80001fb8:	0dc70713          	addi	a4,a4,220 # 80007090 <userret>
    80001fbc:	8f11                	sub	a4,a4,a2
    80001fbe:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001fc0:	577d                	li	a4,-1
    80001fc2:	177e                	slli	a4,a4,0x3f
    80001fc4:	8dd9                	or	a1,a1,a4
    80001fc6:	02000537          	lui	a0,0x2000
    80001fca:	157d                	addi	a0,a0,-1
    80001fcc:	0536                	slli	a0,a0,0xd
    80001fce:	9782                	jalr	a5
}
    80001fd0:	60a2                	ld	ra,8(sp)
    80001fd2:	6402                	ld	s0,0(sp)
    80001fd4:	0141                	addi	sp,sp,16
    80001fd6:	8082                	ret

0000000080001fd8 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001fd8:	1101                	addi	sp,sp,-32
    80001fda:	ec06                	sd	ra,24(sp)
    80001fdc:	e822                	sd	s0,16(sp)
    80001fde:	e426                	sd	s1,8(sp)
    80001fe0:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001fe2:	0000d497          	auipc	s1,0xd
    80001fe6:	e9e48493          	addi	s1,s1,-354 # 8000ee80 <tickslock>
    80001fea:	8526                	mv	a0,s1
    80001fec:	00005097          	auipc	ra,0x5
    80001ff0:	97e080e7          	jalr	-1666(ra) # 8000696a <acquire>
  ticks++;
    80001ff4:	00007517          	auipc	a0,0x7
    80001ff8:	02450513          	addi	a0,a0,36 # 80009018 <ticks>
    80001ffc:	411c                	lw	a5,0(a0)
    80001ffe:	2785                	addiw	a5,a5,1
    80002000:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80002002:	00000097          	auipc	ra,0x0
    80002006:	b1c080e7          	jalr	-1252(ra) # 80001b1e <wakeup>
  release(&tickslock);
    8000200a:	8526                	mv	a0,s1
    8000200c:	00005097          	auipc	ra,0x5
    80002010:	a12080e7          	jalr	-1518(ra) # 80006a1e <release>
}
    80002014:	60e2                	ld	ra,24(sp)
    80002016:	6442                	ld	s0,16(sp)
    80002018:	64a2                	ld	s1,8(sp)
    8000201a:	6105                	addi	sp,sp,32
    8000201c:	8082                	ret

000000008000201e <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    8000201e:	1101                	addi	sp,sp,-32
    80002020:	ec06                	sd	ra,24(sp)
    80002022:	e822                	sd	s0,16(sp)
    80002024:	e426                	sd	s1,8(sp)
    80002026:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002028:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    8000202c:	00074d63          	bltz	a4,80002046 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80002030:	57fd                	li	a5,-1
    80002032:	17fe                	slli	a5,a5,0x3f
    80002034:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80002036:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80002038:	06f70363          	beq	a4,a5,8000209e <devintr+0x80>
  }
}
    8000203c:	60e2                	ld	ra,24(sp)
    8000203e:	6442                	ld	s0,16(sp)
    80002040:	64a2                	ld	s1,8(sp)
    80002042:	6105                	addi	sp,sp,32
    80002044:	8082                	ret
     (scause & 0xff) == 9){
    80002046:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    8000204a:	46a5                	li	a3,9
    8000204c:	fed792e3          	bne	a5,a3,80002030 <devintr+0x12>
    int irq = plic_claim();
    80002050:	00003097          	auipc	ra,0x3
    80002054:	6c8080e7          	jalr	1736(ra) # 80005718 <plic_claim>
    80002058:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    8000205a:	47a9                	li	a5,10
    8000205c:	02f50763          	beq	a0,a5,8000208a <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80002060:	4785                	li	a5,1
    80002062:	02f50963          	beq	a0,a5,80002094 <devintr+0x76>
    return 1;
    80002066:	4505                	li	a0,1
    } else if(irq){
    80002068:	d8f1                	beqz	s1,8000203c <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    8000206a:	85a6                	mv	a1,s1
    8000206c:	00006517          	auipc	a0,0x6
    80002070:	2ac50513          	addi	a0,a0,684 # 80008318 <states.1805+0x38>
    80002074:	00004097          	auipc	ra,0x4
    80002078:	3f6080e7          	jalr	1014(ra) # 8000646a <printf>
      plic_complete(irq);
    8000207c:	8526                	mv	a0,s1
    8000207e:	00003097          	auipc	ra,0x3
    80002082:	6be080e7          	jalr	1726(ra) # 8000573c <plic_complete>
    return 1;
    80002086:	4505                	li	a0,1
    80002088:	bf55                	j	8000203c <devintr+0x1e>
      uartintr();
    8000208a:	00005097          	auipc	ra,0x5
    8000208e:	800080e7          	jalr	-2048(ra) # 8000688a <uartintr>
    80002092:	b7ed                	j	8000207c <devintr+0x5e>
      virtio_disk_intr();
    80002094:	00004097          	auipc	ra,0x4
    80002098:	b88080e7          	jalr	-1144(ra) # 80005c1c <virtio_disk_intr>
    8000209c:	b7c5                	j	8000207c <devintr+0x5e>
    if(cpuid() == 0){
    8000209e:	fffff097          	auipc	ra,0xfffff
    800020a2:	20c080e7          	jalr	524(ra) # 800012aa <cpuid>
    800020a6:	c901                	beqz	a0,800020b6 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    800020a8:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    800020ac:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    800020ae:	14479073          	csrw	sip,a5
    return 2;
    800020b2:	4509                	li	a0,2
    800020b4:	b761                	j	8000203c <devintr+0x1e>
      clockintr();
    800020b6:	00000097          	auipc	ra,0x0
    800020ba:	f22080e7          	jalr	-222(ra) # 80001fd8 <clockintr>
    800020be:	b7ed                	j	800020a8 <devintr+0x8a>

00000000800020c0 <usertrap>:
{
    800020c0:	1101                	addi	sp,sp,-32
    800020c2:	ec06                	sd	ra,24(sp)
    800020c4:	e822                	sd	s0,16(sp)
    800020c6:	e426                	sd	s1,8(sp)
    800020c8:	e04a                	sd	s2,0(sp)
    800020ca:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800020cc:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    800020d0:	1007f793          	andi	a5,a5,256
    800020d4:	ebb9                	bnez	a5,8000212a <usertrap+0x6a>
  asm volatile("csrw stvec, %0" : : "r" (x));
    800020d6:	00003797          	auipc	a5,0x3
    800020da:	53a78793          	addi	a5,a5,1338 # 80005610 <kernelvec>
    800020de:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    800020e2:	fffff097          	auipc	ra,0xfffff
    800020e6:	1f4080e7          	jalr	500(ra) # 800012d6 <myproc>
    800020ea:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    800020ec:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800020ee:	14102773          	csrr	a4,sepc
    800020f2:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    800020f4:	142027f3          	csrr	a5,scause
  if(scause == 13 || scause == 15){
    800020f8:	ffd7f693          	andi	a3,a5,-3
    800020fc:	4735                	li	a4,13
    800020fe:	02e68e63          	beq	a3,a4,8000213a <usertrap+0x7a>
  else if(scause == 8) {
    80002102:	4721                	li	a4,8
    80002104:	06e79163          	bne	a5,a4,80002166 <usertrap+0xa6>
    if(p->killed)
    80002108:	551c                	lw	a5,40(a0)
    8000210a:	eba1                	bnez	a5,8000215a <usertrap+0x9a>
    p->trapframe->epc += 4;
    8000210c:	6cb8                	ld	a4,88(s1)
    8000210e:	6f1c                	ld	a5,24(a4)
    80002110:	0791                	addi	a5,a5,4
    80002112:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002114:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002118:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000211c:	10079073          	csrw	sstatus,a5
    syscall();
    80002120:	00000097          	auipc	ra,0x0
    80002124:	2ea080e7          	jalr	746(ra) # 8000240a <syscall>
    80002128:	a829                	j	80002142 <usertrap+0x82>
    panic("usertrap: not from user mode");
    8000212a:	00006517          	auipc	a0,0x6
    8000212e:	20e50513          	addi	a0,a0,526 # 80008338 <states.1805+0x58>
    80002132:	00004097          	auipc	ra,0x4
    80002136:	2ee080e7          	jalr	750(ra) # 80006420 <panic>
    handle_pgfault();
    8000213a:	00004097          	auipc	ra,0x4
    8000213e:	c0c080e7          	jalr	-1012(ra) # 80005d46 <handle_pgfault>
  if(p->killed)
    80002142:	549c                	lw	a5,40(s1)
    80002144:	e7a5                	bnez	a5,800021ac <usertrap+0xec>
  usertrapret();
    80002146:	00000097          	auipc	ra,0x0
    8000214a:	df4080e7          	jalr	-524(ra) # 80001f3a <usertrapret>
}
    8000214e:	60e2                	ld	ra,24(sp)
    80002150:	6442                	ld	s0,16(sp)
    80002152:	64a2                	ld	s1,8(sp)
    80002154:	6902                	ld	s2,0(sp)
    80002156:	6105                	addi	sp,sp,32
    80002158:	8082                	ret
      exit(-1);
    8000215a:	557d                	li	a0,-1
    8000215c:	00000097          	auipc	ra,0x0
    80002160:	a92080e7          	jalr	-1390(ra) # 80001bee <exit>
    80002164:	b765                	j	8000210c <usertrap+0x4c>
  } else if ((which_dev = devintr()) != 0) {
    80002166:	00000097          	auipc	ra,0x0
    8000216a:	eb8080e7          	jalr	-328(ra) # 8000201e <devintr>
    8000216e:	892a                	mv	s2,a0
    80002170:	c501                	beqz	a0,80002178 <usertrap+0xb8>
  if(p->killed)
    80002172:	549c                	lw	a5,40(s1)
    80002174:	c3b1                	beqz	a5,800021b8 <usertrap+0xf8>
    80002176:	a825                	j	800021ae <usertrap+0xee>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002178:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    8000217c:	5890                	lw	a2,48(s1)
    8000217e:	00006517          	auipc	a0,0x6
    80002182:	1da50513          	addi	a0,a0,474 # 80008358 <states.1805+0x78>
    80002186:	00004097          	auipc	ra,0x4
    8000218a:	2e4080e7          	jalr	740(ra) # 8000646a <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000218e:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002192:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002196:	00006517          	auipc	a0,0x6
    8000219a:	1f250513          	addi	a0,a0,498 # 80008388 <states.1805+0xa8>
    8000219e:	00004097          	auipc	ra,0x4
    800021a2:	2cc080e7          	jalr	716(ra) # 8000646a <printf>
    p->killed = 1;
    800021a6:	4785                	li	a5,1
    800021a8:	d49c                	sw	a5,40(s1)
  if(p->killed)
    800021aa:	a011                	j	800021ae <usertrap+0xee>
    800021ac:	4901                	li	s2,0
    exit(-1);
    800021ae:	557d                	li	a0,-1
    800021b0:	00000097          	auipc	ra,0x0
    800021b4:	a3e080e7          	jalr	-1474(ra) # 80001bee <exit>
  if(which_dev == 2)
    800021b8:	4789                	li	a5,2
    800021ba:	f8f916e3          	bne	s2,a5,80002146 <usertrap+0x86>
    yield();
    800021be:	fffff097          	auipc	ra,0xfffff
    800021c2:	798080e7          	jalr	1944(ra) # 80001956 <yield>
    800021c6:	b741                	j	80002146 <usertrap+0x86>

00000000800021c8 <kerneltrap>:
{
    800021c8:	7179                	addi	sp,sp,-48
    800021ca:	f406                	sd	ra,40(sp)
    800021cc:	f022                	sd	s0,32(sp)
    800021ce:	ec26                	sd	s1,24(sp)
    800021d0:	e84a                	sd	s2,16(sp)
    800021d2:	e44e                	sd	s3,8(sp)
    800021d4:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800021d6:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800021da:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    800021de:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    800021e2:	1004f793          	andi	a5,s1,256
    800021e6:	cb85                	beqz	a5,80002216 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800021e8:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800021ec:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    800021ee:	ef85                	bnez	a5,80002226 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    800021f0:	00000097          	auipc	ra,0x0
    800021f4:	e2e080e7          	jalr	-466(ra) # 8000201e <devintr>
    800021f8:	cd1d                	beqz	a0,80002236 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    800021fa:	4789                	li	a5,2
    800021fc:	06f50a63          	beq	a0,a5,80002270 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002200:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002204:	10049073          	csrw	sstatus,s1
}
    80002208:	70a2                	ld	ra,40(sp)
    8000220a:	7402                	ld	s0,32(sp)
    8000220c:	64e2                	ld	s1,24(sp)
    8000220e:	6942                	ld	s2,16(sp)
    80002210:	69a2                	ld	s3,8(sp)
    80002212:	6145                	addi	sp,sp,48
    80002214:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002216:	00006517          	auipc	a0,0x6
    8000221a:	19250513          	addi	a0,a0,402 # 800083a8 <states.1805+0xc8>
    8000221e:	00004097          	auipc	ra,0x4
    80002222:	202080e7          	jalr	514(ra) # 80006420 <panic>
    panic("kerneltrap: interrupts enabled");
    80002226:	00006517          	auipc	a0,0x6
    8000222a:	1aa50513          	addi	a0,a0,426 # 800083d0 <states.1805+0xf0>
    8000222e:	00004097          	auipc	ra,0x4
    80002232:	1f2080e7          	jalr	498(ra) # 80006420 <panic>
    printf("scause %p\n", scause);
    80002236:	85ce                	mv	a1,s3
    80002238:	00006517          	auipc	a0,0x6
    8000223c:	1b850513          	addi	a0,a0,440 # 800083f0 <states.1805+0x110>
    80002240:	00004097          	auipc	ra,0x4
    80002244:	22a080e7          	jalr	554(ra) # 8000646a <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002248:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    8000224c:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002250:	00006517          	auipc	a0,0x6
    80002254:	1b050513          	addi	a0,a0,432 # 80008400 <states.1805+0x120>
    80002258:	00004097          	auipc	ra,0x4
    8000225c:	212080e7          	jalr	530(ra) # 8000646a <printf>
    panic("kerneltrap");
    80002260:	00006517          	auipc	a0,0x6
    80002264:	1b850513          	addi	a0,a0,440 # 80008418 <states.1805+0x138>
    80002268:	00004097          	auipc	ra,0x4
    8000226c:	1b8080e7          	jalr	440(ra) # 80006420 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002270:	fffff097          	auipc	ra,0xfffff
    80002274:	066080e7          	jalr	102(ra) # 800012d6 <myproc>
    80002278:	d541                	beqz	a0,80002200 <kerneltrap+0x38>
    8000227a:	fffff097          	auipc	ra,0xfffff
    8000227e:	05c080e7          	jalr	92(ra) # 800012d6 <myproc>
    80002282:	4d18                	lw	a4,24(a0)
    80002284:	4791                	li	a5,4
    80002286:	f6f71de3          	bne	a4,a5,80002200 <kerneltrap+0x38>
    yield();
    8000228a:	fffff097          	auipc	ra,0xfffff
    8000228e:	6cc080e7          	jalr	1740(ra) # 80001956 <yield>
    80002292:	b7bd                	j	80002200 <kerneltrap+0x38>

0000000080002294 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002294:	1101                	addi	sp,sp,-32
    80002296:	ec06                	sd	ra,24(sp)
    80002298:	e822                	sd	s0,16(sp)
    8000229a:	e426                	sd	s1,8(sp)
    8000229c:	1000                	addi	s0,sp,32
    8000229e:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800022a0:	fffff097          	auipc	ra,0xfffff
    800022a4:	036080e7          	jalr	54(ra) # 800012d6 <myproc>
  switch (n) {
    800022a8:	4795                	li	a5,5
    800022aa:	0497e163          	bltu	a5,s1,800022ec <argraw+0x58>
    800022ae:	048a                	slli	s1,s1,0x2
    800022b0:	00006717          	auipc	a4,0x6
    800022b4:	1a070713          	addi	a4,a4,416 # 80008450 <states.1805+0x170>
    800022b8:	94ba                	add	s1,s1,a4
    800022ba:	409c                	lw	a5,0(s1)
    800022bc:	97ba                	add	a5,a5,a4
    800022be:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    800022c0:	6d3c                	ld	a5,88(a0)
    800022c2:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    800022c4:	60e2                	ld	ra,24(sp)
    800022c6:	6442                	ld	s0,16(sp)
    800022c8:	64a2                	ld	s1,8(sp)
    800022ca:	6105                	addi	sp,sp,32
    800022cc:	8082                	ret
    return p->trapframe->a1;
    800022ce:	6d3c                	ld	a5,88(a0)
    800022d0:	7fa8                	ld	a0,120(a5)
    800022d2:	bfcd                	j	800022c4 <argraw+0x30>
    return p->trapframe->a2;
    800022d4:	6d3c                	ld	a5,88(a0)
    800022d6:	63c8                	ld	a0,128(a5)
    800022d8:	b7f5                	j	800022c4 <argraw+0x30>
    return p->trapframe->a3;
    800022da:	6d3c                	ld	a5,88(a0)
    800022dc:	67c8                	ld	a0,136(a5)
    800022de:	b7dd                	j	800022c4 <argraw+0x30>
    return p->trapframe->a4;
    800022e0:	6d3c                	ld	a5,88(a0)
    800022e2:	6bc8                	ld	a0,144(a5)
    800022e4:	b7c5                	j	800022c4 <argraw+0x30>
    return p->trapframe->a5;
    800022e6:	6d3c                	ld	a5,88(a0)
    800022e8:	6fc8                	ld	a0,152(a5)
    800022ea:	bfe9                	j	800022c4 <argraw+0x30>
  panic("argraw");
    800022ec:	00006517          	auipc	a0,0x6
    800022f0:	13c50513          	addi	a0,a0,316 # 80008428 <states.1805+0x148>
    800022f4:	00004097          	auipc	ra,0x4
    800022f8:	12c080e7          	jalr	300(ra) # 80006420 <panic>

00000000800022fc <fetchaddr>:
{
    800022fc:	1101                	addi	sp,sp,-32
    800022fe:	ec06                	sd	ra,24(sp)
    80002300:	e822                	sd	s0,16(sp)
    80002302:	e426                	sd	s1,8(sp)
    80002304:	e04a                	sd	s2,0(sp)
    80002306:	1000                	addi	s0,sp,32
    80002308:	84aa                	mv	s1,a0
    8000230a:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000230c:	fffff097          	auipc	ra,0xfffff
    80002310:	fca080e7          	jalr	-54(ra) # 800012d6 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80002314:	653c                	ld	a5,72(a0)
    80002316:	02f4f863          	bgeu	s1,a5,80002346 <fetchaddr+0x4a>
    8000231a:	00848713          	addi	a4,s1,8
    8000231e:	02e7e663          	bltu	a5,a4,8000234a <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002322:	46a1                	li	a3,8
    80002324:	8626                	mv	a2,s1
    80002326:	85ca                	mv	a1,s2
    80002328:	6928                	ld	a0,80(a0)
    8000232a:	fffff097          	auipc	ra,0xfffff
    8000232e:	864080e7          	jalr	-1948(ra) # 80000b8e <copyin>
    80002332:	00a03533          	snez	a0,a0
    80002336:	40a00533          	neg	a0,a0
}
    8000233a:	60e2                	ld	ra,24(sp)
    8000233c:	6442                	ld	s0,16(sp)
    8000233e:	64a2                	ld	s1,8(sp)
    80002340:	6902                	ld	s2,0(sp)
    80002342:	6105                	addi	sp,sp,32
    80002344:	8082                	ret
    return -1;
    80002346:	557d                	li	a0,-1
    80002348:	bfcd                	j	8000233a <fetchaddr+0x3e>
    8000234a:	557d                	li	a0,-1
    8000234c:	b7fd                	j	8000233a <fetchaddr+0x3e>

000000008000234e <fetchstr>:
{
    8000234e:	7179                	addi	sp,sp,-48
    80002350:	f406                	sd	ra,40(sp)
    80002352:	f022                	sd	s0,32(sp)
    80002354:	ec26                	sd	s1,24(sp)
    80002356:	e84a                	sd	s2,16(sp)
    80002358:	e44e                	sd	s3,8(sp)
    8000235a:	1800                	addi	s0,sp,48
    8000235c:	892a                	mv	s2,a0
    8000235e:	84ae                	mv	s1,a1
    80002360:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002362:	fffff097          	auipc	ra,0xfffff
    80002366:	f74080e7          	jalr	-140(ra) # 800012d6 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    8000236a:	86ce                	mv	a3,s3
    8000236c:	864a                	mv	a2,s2
    8000236e:	85a6                	mv	a1,s1
    80002370:	6928                	ld	a0,80(a0)
    80002372:	fffff097          	auipc	ra,0xfffff
    80002376:	8a8080e7          	jalr	-1880(ra) # 80000c1a <copyinstr>
  if(err < 0)
    8000237a:	00054763          	bltz	a0,80002388 <fetchstr+0x3a>
  return strlen(buf);
    8000237e:	8526                	mv	a0,s1
    80002380:	ffffe097          	auipc	ra,0xffffe
    80002384:	f7c080e7          	jalr	-132(ra) # 800002fc <strlen>
}
    80002388:	70a2                	ld	ra,40(sp)
    8000238a:	7402                	ld	s0,32(sp)
    8000238c:	64e2                	ld	s1,24(sp)
    8000238e:	6942                	ld	s2,16(sp)
    80002390:	69a2                	ld	s3,8(sp)
    80002392:	6145                	addi	sp,sp,48
    80002394:	8082                	ret

0000000080002396 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80002396:	1101                	addi	sp,sp,-32
    80002398:	ec06                	sd	ra,24(sp)
    8000239a:	e822                	sd	s0,16(sp)
    8000239c:	e426                	sd	s1,8(sp)
    8000239e:	1000                	addi	s0,sp,32
    800023a0:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800023a2:	00000097          	auipc	ra,0x0
    800023a6:	ef2080e7          	jalr	-270(ra) # 80002294 <argraw>
    800023aa:	c088                	sw	a0,0(s1)
  return 0;
}
    800023ac:	4501                	li	a0,0
    800023ae:	60e2                	ld	ra,24(sp)
    800023b0:	6442                	ld	s0,16(sp)
    800023b2:	64a2                	ld	s1,8(sp)
    800023b4:	6105                	addi	sp,sp,32
    800023b6:	8082                	ret

00000000800023b8 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    800023b8:	1101                	addi	sp,sp,-32
    800023ba:	ec06                	sd	ra,24(sp)
    800023bc:	e822                	sd	s0,16(sp)
    800023be:	e426                	sd	s1,8(sp)
    800023c0:	1000                	addi	s0,sp,32
    800023c2:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800023c4:	00000097          	auipc	ra,0x0
    800023c8:	ed0080e7          	jalr	-304(ra) # 80002294 <argraw>
    800023cc:	e088                	sd	a0,0(s1)
  return 0;
}
    800023ce:	4501                	li	a0,0
    800023d0:	60e2                	ld	ra,24(sp)
    800023d2:	6442                	ld	s0,16(sp)
    800023d4:	64a2                	ld	s1,8(sp)
    800023d6:	6105                	addi	sp,sp,32
    800023d8:	8082                	ret

00000000800023da <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    800023da:	1101                	addi	sp,sp,-32
    800023dc:	ec06                	sd	ra,24(sp)
    800023de:	e822                	sd	s0,16(sp)
    800023e0:	e426                	sd	s1,8(sp)
    800023e2:	e04a                	sd	s2,0(sp)
    800023e4:	1000                	addi	s0,sp,32
    800023e6:	84ae                	mv	s1,a1
    800023e8:	8932                	mv	s2,a2
  *ip = argraw(n);
    800023ea:	00000097          	auipc	ra,0x0
    800023ee:	eaa080e7          	jalr	-342(ra) # 80002294 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    800023f2:	864a                	mv	a2,s2
    800023f4:	85a6                	mv	a1,s1
    800023f6:	00000097          	auipc	ra,0x0
    800023fa:	f58080e7          	jalr	-168(ra) # 8000234e <fetchstr>
}
    800023fe:	60e2                	ld	ra,24(sp)
    80002400:	6442                	ld	s0,16(sp)
    80002402:	64a2                	ld	s1,8(sp)
    80002404:	6902                	ld	s2,0(sp)
    80002406:	6105                	addi	sp,sp,32
    80002408:	8082                	ret

000000008000240a <syscall>:



void
syscall(void)
{
    8000240a:	1101                	addi	sp,sp,-32
    8000240c:	ec06                	sd	ra,24(sp)
    8000240e:	e822                	sd	s0,16(sp)
    80002410:	e426                	sd	s1,8(sp)
    80002412:	e04a                	sd	s2,0(sp)
    80002414:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002416:	fffff097          	auipc	ra,0xfffff
    8000241a:	ec0080e7          	jalr	-320(ra) # 800012d6 <myproc>
    8000241e:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002420:	05853903          	ld	s2,88(a0)
    80002424:	0a893783          	ld	a5,168(s2)
    80002428:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    8000242c:	37fd                	addiw	a5,a5,-1
    8000242e:	02000713          	li	a4,32
    80002432:	00f76f63          	bltu	a4,a5,80002450 <syscall+0x46>
    80002436:	00369713          	slli	a4,a3,0x3
    8000243a:	00006797          	auipc	a5,0x6
    8000243e:	02e78793          	addi	a5,a5,46 # 80008468 <syscalls>
    80002442:	97ba                	add	a5,a5,a4
    80002444:	639c                	ld	a5,0(a5)
    80002446:	c789                	beqz	a5,80002450 <syscall+0x46>
    p->trapframe->a0 = syscalls[num]();
    80002448:	9782                	jalr	a5
    8000244a:	06a93823          	sd	a0,112(s2)
    8000244e:	a839                	j	8000246c <syscall+0x62>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002450:	15848613          	addi	a2,s1,344
    80002454:	588c                	lw	a1,48(s1)
    80002456:	00006517          	auipc	a0,0x6
    8000245a:	fda50513          	addi	a0,a0,-38 # 80008430 <states.1805+0x150>
    8000245e:	00004097          	auipc	ra,0x4
    80002462:	00c080e7          	jalr	12(ra) # 8000646a <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002466:	6cbc                	ld	a5,88(s1)
    80002468:	577d                	li	a4,-1
    8000246a:	fbb8                	sd	a4,112(a5)
  }
}
    8000246c:	60e2                	ld	ra,24(sp)
    8000246e:	6442                	ld	s0,16(sp)
    80002470:	64a2                	ld	s1,8(sp)
    80002472:	6902                	ld	s2,0(sp)
    80002474:	6105                	addi	sp,sp,32
    80002476:	8082                	ret

0000000080002478 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002478:	1101                	addi	sp,sp,-32
    8000247a:	ec06                	sd	ra,24(sp)
    8000247c:	e822                	sd	s0,16(sp)
    8000247e:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    80002480:	fec40593          	addi	a1,s0,-20
    80002484:	4501                	li	a0,0
    80002486:	00000097          	auipc	ra,0x0
    8000248a:	f10080e7          	jalr	-240(ra) # 80002396 <argint>
    return -1;
    8000248e:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002490:	00054963          	bltz	a0,800024a2 <sys_exit+0x2a>
  exit(n);
    80002494:	fec42503          	lw	a0,-20(s0)
    80002498:	fffff097          	auipc	ra,0xfffff
    8000249c:	756080e7          	jalr	1878(ra) # 80001bee <exit>
  return 0;  // not reached
    800024a0:	4781                	li	a5,0
}
    800024a2:	853e                	mv	a0,a5
    800024a4:	60e2                	ld	ra,24(sp)
    800024a6:	6442                	ld	s0,16(sp)
    800024a8:	6105                	addi	sp,sp,32
    800024aa:	8082                	ret

00000000800024ac <sys_getpid>:

uint64
sys_getpid(void)
{
    800024ac:	1141                	addi	sp,sp,-16
    800024ae:	e406                	sd	ra,8(sp)
    800024b0:	e022                	sd	s0,0(sp)
    800024b2:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800024b4:	fffff097          	auipc	ra,0xfffff
    800024b8:	e22080e7          	jalr	-478(ra) # 800012d6 <myproc>
}
    800024bc:	5908                	lw	a0,48(a0)
    800024be:	60a2                	ld	ra,8(sp)
    800024c0:	6402                	ld	s0,0(sp)
    800024c2:	0141                	addi	sp,sp,16
    800024c4:	8082                	ret

00000000800024c6 <sys_fork>:

uint64
sys_fork(void)
{
    800024c6:	1141                	addi	sp,sp,-16
    800024c8:	e406                	sd	ra,8(sp)
    800024ca:	e022                	sd	s0,0(sp)
    800024cc:	0800                	addi	s0,sp,16
  return fork();
    800024ce:	fffff097          	auipc	ra,0xfffff
    800024d2:	1d6080e7          	jalr	470(ra) # 800016a4 <fork>
}
    800024d6:	60a2                	ld	ra,8(sp)
    800024d8:	6402                	ld	s0,0(sp)
    800024da:	0141                	addi	sp,sp,16
    800024dc:	8082                	ret

00000000800024de <sys_wait>:

uint64
sys_wait(void)
{
    800024de:	1101                	addi	sp,sp,-32
    800024e0:	ec06                	sd	ra,24(sp)
    800024e2:	e822                	sd	s0,16(sp)
    800024e4:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    800024e6:	fe840593          	addi	a1,s0,-24
    800024ea:	4501                	li	a0,0
    800024ec:	00000097          	auipc	ra,0x0
    800024f0:	ecc080e7          	jalr	-308(ra) # 800023b8 <argaddr>
    800024f4:	87aa                	mv	a5,a0
    return -1;
    800024f6:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    800024f8:	0007c863          	bltz	a5,80002508 <sys_wait+0x2a>
  return wait(p);
    800024fc:	fe843503          	ld	a0,-24(s0)
    80002500:	fffff097          	auipc	ra,0xfffff
    80002504:	4f6080e7          	jalr	1270(ra) # 800019f6 <wait>
}
    80002508:	60e2                	ld	ra,24(sp)
    8000250a:	6442                	ld	s0,16(sp)
    8000250c:	6105                	addi	sp,sp,32
    8000250e:	8082                	ret

0000000080002510 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002510:	7179                	addi	sp,sp,-48
    80002512:	f406                	sd	ra,40(sp)
    80002514:	f022                	sd	s0,32(sp)
    80002516:	ec26                	sd	s1,24(sp)
    80002518:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    8000251a:	fdc40593          	addi	a1,s0,-36
    8000251e:	4501                	li	a0,0
    80002520:	00000097          	auipc	ra,0x0
    80002524:	e76080e7          	jalr	-394(ra) # 80002396 <argint>
    80002528:	87aa                	mv	a5,a0
    return -1;
    8000252a:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    8000252c:	0207c063          	bltz	a5,8000254c <sys_sbrk+0x3c>
  
  addr = myproc()->sz;
    80002530:	fffff097          	auipc	ra,0xfffff
    80002534:	da6080e7          	jalr	-602(ra) # 800012d6 <myproc>
    80002538:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    8000253a:	fdc42503          	lw	a0,-36(s0)
    8000253e:	fffff097          	auipc	ra,0xfffff
    80002542:	0f2080e7          	jalr	242(ra) # 80001630 <growproc>
    80002546:	00054863          	bltz	a0,80002556 <sys_sbrk+0x46>
    return -1;
  return addr;
    8000254a:	8526                	mv	a0,s1
}
    8000254c:	70a2                	ld	ra,40(sp)
    8000254e:	7402                	ld	s0,32(sp)
    80002550:	64e2                	ld	s1,24(sp)
    80002552:	6145                	addi	sp,sp,48
    80002554:	8082                	ret
    return -1;
    80002556:	557d                	li	a0,-1
    80002558:	bfd5                	j	8000254c <sys_sbrk+0x3c>

000000008000255a <sys_sleep>:

uint64
sys_sleep(void)
{
    8000255a:	7139                	addi	sp,sp,-64
    8000255c:	fc06                	sd	ra,56(sp)
    8000255e:	f822                	sd	s0,48(sp)
    80002560:	f426                	sd	s1,40(sp)
    80002562:	f04a                	sd	s2,32(sp)
    80002564:	ec4e                	sd	s3,24(sp)
    80002566:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;


  if(argint(0, &n) < 0)
    80002568:	fcc40593          	addi	a1,s0,-52
    8000256c:	4501                	li	a0,0
    8000256e:	00000097          	auipc	ra,0x0
    80002572:	e28080e7          	jalr	-472(ra) # 80002396 <argint>
    return -1;
    80002576:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002578:	06054563          	bltz	a0,800025e2 <sys_sleep+0x88>
  acquire(&tickslock);
    8000257c:	0000d517          	auipc	a0,0xd
    80002580:	90450513          	addi	a0,a0,-1788 # 8000ee80 <tickslock>
    80002584:	00004097          	auipc	ra,0x4
    80002588:	3e6080e7          	jalr	998(ra) # 8000696a <acquire>
  ticks0 = ticks;
    8000258c:	00007917          	auipc	s2,0x7
    80002590:	a8c92903          	lw	s2,-1396(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    80002594:	fcc42783          	lw	a5,-52(s0)
    80002598:	cf85                	beqz	a5,800025d0 <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    8000259a:	0000d997          	auipc	s3,0xd
    8000259e:	8e698993          	addi	s3,s3,-1818 # 8000ee80 <tickslock>
    800025a2:	00007497          	auipc	s1,0x7
    800025a6:	a7648493          	addi	s1,s1,-1418 # 80009018 <ticks>
    if(myproc()->killed){
    800025aa:	fffff097          	auipc	ra,0xfffff
    800025ae:	d2c080e7          	jalr	-724(ra) # 800012d6 <myproc>
    800025b2:	551c                	lw	a5,40(a0)
    800025b4:	ef9d                	bnez	a5,800025f2 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    800025b6:	85ce                	mv	a1,s3
    800025b8:	8526                	mv	a0,s1
    800025ba:	fffff097          	auipc	ra,0xfffff
    800025be:	3d8080e7          	jalr	984(ra) # 80001992 <sleep>
  while(ticks - ticks0 < n){
    800025c2:	409c                	lw	a5,0(s1)
    800025c4:	412787bb          	subw	a5,a5,s2
    800025c8:	fcc42703          	lw	a4,-52(s0)
    800025cc:	fce7efe3          	bltu	a5,a4,800025aa <sys_sleep+0x50>
  }
  release(&tickslock);
    800025d0:	0000d517          	auipc	a0,0xd
    800025d4:	8b050513          	addi	a0,a0,-1872 # 8000ee80 <tickslock>
    800025d8:	00004097          	auipc	ra,0x4
    800025dc:	446080e7          	jalr	1094(ra) # 80006a1e <release>
  return 0;
    800025e0:	4781                	li	a5,0
}
    800025e2:	853e                	mv	a0,a5
    800025e4:	70e2                	ld	ra,56(sp)
    800025e6:	7442                	ld	s0,48(sp)
    800025e8:	74a2                	ld	s1,40(sp)
    800025ea:	7902                	ld	s2,32(sp)
    800025ec:	69e2                	ld	s3,24(sp)
    800025ee:	6121                	addi	sp,sp,64
    800025f0:	8082                	ret
      release(&tickslock);
    800025f2:	0000d517          	auipc	a0,0xd
    800025f6:	88e50513          	addi	a0,a0,-1906 # 8000ee80 <tickslock>
    800025fa:	00004097          	auipc	ra,0x4
    800025fe:	424080e7          	jalr	1060(ra) # 80006a1e <release>
      return -1;
    80002602:	57fd                	li	a5,-1
    80002604:	bff9                	j	800025e2 <sys_sleep+0x88>

0000000080002606 <sys_pgaccess>:


#ifdef LAB_PGTBL
int
sys_pgaccess(void)
{
    80002606:	1141                	addi	sp,sp,-16
    80002608:	e422                	sd	s0,8(sp)
    8000260a:	0800                	addi	s0,sp,16
  // lab pgtbl: your code here.
  return 0;
}
    8000260c:	4501                	li	a0,0
    8000260e:	6422                	ld	s0,8(sp)
    80002610:	0141                	addi	sp,sp,16
    80002612:	8082                	ret

0000000080002614 <sys_kill>:
#endif

uint64
sys_kill(void)
{
    80002614:	1101                	addi	sp,sp,-32
    80002616:	ec06                	sd	ra,24(sp)
    80002618:	e822                	sd	s0,16(sp)
    8000261a:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    8000261c:	fec40593          	addi	a1,s0,-20
    80002620:	4501                	li	a0,0
    80002622:	00000097          	auipc	ra,0x0
    80002626:	d74080e7          	jalr	-652(ra) # 80002396 <argint>
    8000262a:	87aa                	mv	a5,a0
    return -1;
    8000262c:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    8000262e:	0007c863          	bltz	a5,8000263e <sys_kill+0x2a>
  return kill(pid);
    80002632:	fec42503          	lw	a0,-20(s0)
    80002636:	fffff097          	auipc	ra,0xfffff
    8000263a:	68e080e7          	jalr	1678(ra) # 80001cc4 <kill>
}
    8000263e:	60e2                	ld	ra,24(sp)
    80002640:	6442                	ld	s0,16(sp)
    80002642:	6105                	addi	sp,sp,32
    80002644:	8082                	ret

0000000080002646 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002646:	1101                	addi	sp,sp,-32
    80002648:	ec06                	sd	ra,24(sp)
    8000264a:	e822                	sd	s0,16(sp)
    8000264c:	e426                	sd	s1,8(sp)
    8000264e:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002650:	0000d517          	auipc	a0,0xd
    80002654:	83050513          	addi	a0,a0,-2000 # 8000ee80 <tickslock>
    80002658:	00004097          	auipc	ra,0x4
    8000265c:	312080e7          	jalr	786(ra) # 8000696a <acquire>
  xticks = ticks;
    80002660:	00007497          	auipc	s1,0x7
    80002664:	9b84a483          	lw	s1,-1608(s1) # 80009018 <ticks>
  release(&tickslock);
    80002668:	0000d517          	auipc	a0,0xd
    8000266c:	81850513          	addi	a0,a0,-2024 # 8000ee80 <tickslock>
    80002670:	00004097          	auipc	ra,0x4
    80002674:	3ae080e7          	jalr	942(ra) # 80006a1e <release>
  return xticks;
}
    80002678:	02049513          	slli	a0,s1,0x20
    8000267c:	9101                	srli	a0,a0,0x20
    8000267e:	60e2                	ld	ra,24(sp)
    80002680:	6442                	ld	s0,16(sp)
    80002682:	64a2                	ld	s1,8(sp)
    80002684:	6105                	addi	sp,sp,32
    80002686:	8082                	ret

0000000080002688 <bget>:
// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return locked buffer.
static struct buf*
bget(uint dev, uint blockno)
{
    80002688:	7179                	addi	sp,sp,-48
    8000268a:	f406                	sd	ra,40(sp)
    8000268c:	f022                	sd	s0,32(sp)
    8000268e:	ec26                	sd	s1,24(sp)
    80002690:	e84a                	sd	s2,16(sp)
    80002692:	e44e                	sd	s3,8(sp)
    80002694:	1800                	addi	s0,sp,48
    80002696:	892a                	mv	s2,a0
    80002698:	89ae                	mv	s3,a1
  struct buf *b;

  acquire(&bcache.lock);
    8000269a:	0000c517          	auipc	a0,0xc
    8000269e:	7fe50513          	addi	a0,a0,2046 # 8000ee98 <bcache>
    800026a2:	00004097          	auipc	ra,0x4
    800026a6:	2c8080e7          	jalr	712(ra) # 8000696a <acquire>

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800026aa:	00015497          	auipc	s1,0x15
    800026ae:	aa64b483          	ld	s1,-1370(s1) # 80017150 <bcache+0x82b8>
    800026b2:	00015797          	auipc	a5,0x15
    800026b6:	a4e78793          	addi	a5,a5,-1458 # 80017100 <bcache+0x8268>
    800026ba:	02f48f63          	beq	s1,a5,800026f8 <bget+0x70>
    800026be:	873e                	mv	a4,a5
    800026c0:	a021                	j	800026c8 <bget+0x40>
    800026c2:	68a4                	ld	s1,80(s1)
    800026c4:	02e48a63          	beq	s1,a4,800026f8 <bget+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800026c8:	449c                	lw	a5,8(s1)
    800026ca:	ff279ce3          	bne	a5,s2,800026c2 <bget+0x3a>
    800026ce:	44dc                	lw	a5,12(s1)
    800026d0:	ff3799e3          	bne	a5,s3,800026c2 <bget+0x3a>
      b->refcnt++;
    800026d4:	40bc                	lw	a5,64(s1)
    800026d6:	2785                	addiw	a5,a5,1
    800026d8:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800026da:	0000c517          	auipc	a0,0xc
    800026de:	7be50513          	addi	a0,a0,1982 # 8000ee98 <bcache>
    800026e2:	00004097          	auipc	ra,0x4
    800026e6:	33c080e7          	jalr	828(ra) # 80006a1e <release>
      acquiresleep(&b->lock);
    800026ea:	01048513          	addi	a0,s1,16
    800026ee:	00001097          	auipc	ra,0x1
    800026f2:	736080e7          	jalr	1846(ra) # 80003e24 <acquiresleep>
      return b;
    800026f6:	a8b9                	j	80002754 <bget+0xcc>
    }
  }

  // Not cached.
  // Recycle the least recently used (LRU) unused buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800026f8:	00015497          	auipc	s1,0x15
    800026fc:	a504b483          	ld	s1,-1456(s1) # 80017148 <bcache+0x82b0>
    80002700:	00015797          	auipc	a5,0x15
    80002704:	a0078793          	addi	a5,a5,-1536 # 80017100 <bcache+0x8268>
    80002708:	00f48863          	beq	s1,a5,80002718 <bget+0x90>
    8000270c:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    8000270e:	40bc                	lw	a5,64(s1)
    80002710:	cf81                	beqz	a5,80002728 <bget+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002712:	64a4                	ld	s1,72(s1)
    80002714:	fee49de3          	bne	s1,a4,8000270e <bget+0x86>
      release(&bcache.lock);
      acquiresleep(&b->lock);
      return b;
    }
  }
  panic("bget: no buffers");
    80002718:	00006517          	auipc	a0,0x6
    8000271c:	e6050513          	addi	a0,a0,-416 # 80008578 <syscalls+0x110>
    80002720:	00004097          	auipc	ra,0x4
    80002724:	d00080e7          	jalr	-768(ra) # 80006420 <panic>
      b->dev = dev;
    80002728:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    8000272c:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002730:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002734:	4785                	li	a5,1
    80002736:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002738:	0000c517          	auipc	a0,0xc
    8000273c:	76050513          	addi	a0,a0,1888 # 8000ee98 <bcache>
    80002740:	00004097          	auipc	ra,0x4
    80002744:	2de080e7          	jalr	734(ra) # 80006a1e <release>
      acquiresleep(&b->lock);
    80002748:	01048513          	addi	a0,s1,16
    8000274c:	00001097          	auipc	ra,0x1
    80002750:	6d8080e7          	jalr	1752(ra) # 80003e24 <acquiresleep>
}
    80002754:	8526                	mv	a0,s1
    80002756:	70a2                	ld	ra,40(sp)
    80002758:	7402                	ld	s0,32(sp)
    8000275a:	64e2                	ld	s1,24(sp)
    8000275c:	6942                	ld	s2,16(sp)
    8000275e:	69a2                	ld	s3,8(sp)
    80002760:	6145                	addi	sp,sp,48
    80002762:	8082                	ret

0000000080002764 <binit>:
{
    80002764:	7179                	addi	sp,sp,-48
    80002766:	f406                	sd	ra,40(sp)
    80002768:	f022                	sd	s0,32(sp)
    8000276a:	ec26                	sd	s1,24(sp)
    8000276c:	e84a                	sd	s2,16(sp)
    8000276e:	e44e                	sd	s3,8(sp)
    80002770:	e052                	sd	s4,0(sp)
    80002772:	1800                	addi	s0,sp,48
  initlock(&bcache.lock, "bcache");
    80002774:	00006597          	auipc	a1,0x6
    80002778:	e1c58593          	addi	a1,a1,-484 # 80008590 <syscalls+0x128>
    8000277c:	0000c517          	auipc	a0,0xc
    80002780:	71c50513          	addi	a0,a0,1820 # 8000ee98 <bcache>
    80002784:	00004097          	auipc	ra,0x4
    80002788:	156080e7          	jalr	342(ra) # 800068da <initlock>
  bcache.head.prev = &bcache.head;
    8000278c:	00014797          	auipc	a5,0x14
    80002790:	70c78793          	addi	a5,a5,1804 # 80016e98 <bcache+0x8000>
    80002794:	00015717          	auipc	a4,0x15
    80002798:	96c70713          	addi	a4,a4,-1684 # 80017100 <bcache+0x8268>
    8000279c:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800027a0:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800027a4:	0000c497          	auipc	s1,0xc
    800027a8:	70c48493          	addi	s1,s1,1804 # 8000eeb0 <bcache+0x18>
    b->next = bcache.head.next;
    800027ac:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800027ae:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800027b0:	00006a17          	auipc	s4,0x6
    800027b4:	de8a0a13          	addi	s4,s4,-536 # 80008598 <syscalls+0x130>
    b->next = bcache.head.next;
    800027b8:	2b893783          	ld	a5,696(s2)
    800027bc:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800027be:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800027c2:	85d2                	mv	a1,s4
    800027c4:	01048513          	addi	a0,s1,16
    800027c8:	00001097          	auipc	ra,0x1
    800027cc:	622080e7          	jalr	1570(ra) # 80003dea <initsleeplock>
    bcache.head.next->prev = b;
    800027d0:	2b893783          	ld	a5,696(s2)
    800027d4:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800027d6:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800027da:	45848493          	addi	s1,s1,1112
    800027de:	fd349de3          	bne	s1,s3,800027b8 <binit+0x54>
}
    800027e2:	70a2                	ld	ra,40(sp)
    800027e4:	7402                	ld	s0,32(sp)
    800027e6:	64e2                	ld	s1,24(sp)
    800027e8:	6942                	ld	s2,16(sp)
    800027ea:	69a2                	ld	s3,8(sp)
    800027ec:	6a02                	ld	s4,0(sp)
    800027ee:	6145                	addi	sp,sp,48
    800027f0:	8082                	ret

00000000800027f2 <bread>:

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800027f2:	1101                	addi	sp,sp,-32
    800027f4:	ec06                	sd	ra,24(sp)
    800027f6:	e822                	sd	s0,16(sp)
    800027f8:	e426                	sd	s1,8(sp)
    800027fa:	1000                	addi	s0,sp,32
  struct buf *b;

  b = bget(dev, blockno);
    800027fc:	00000097          	auipc	ra,0x0
    80002800:	e8c080e7          	jalr	-372(ra) # 80002688 <bget>
    80002804:	84aa                	mv	s1,a0
  if(!b->valid) {
    80002806:	411c                	lw	a5,0(a0)
    80002808:	c799                	beqz	a5,80002816 <bread+0x24>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    8000280a:	8526                	mv	a0,s1
    8000280c:	60e2                	ld	ra,24(sp)
    8000280e:	6442                	ld	s0,16(sp)
    80002810:	64a2                	ld	s1,8(sp)
    80002812:	6105                	addi	sp,sp,32
    80002814:	8082                	ret
    virtio_disk_rw(b, 0);
    80002816:	4581                	li	a1,0
    80002818:	00003097          	auipc	ra,0x3
    8000281c:	12e080e7          	jalr	302(ra) # 80005946 <virtio_disk_rw>
    b->valid = 1;
    80002820:	4785                	li	a5,1
    80002822:	c09c                	sw	a5,0(s1)
  return b;
    80002824:	b7dd                	j	8000280a <bread+0x18>

0000000080002826 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002826:	1101                	addi	sp,sp,-32
    80002828:	ec06                	sd	ra,24(sp)
    8000282a:	e822                	sd	s0,16(sp)
    8000282c:	e426                	sd	s1,8(sp)
    8000282e:	1000                	addi	s0,sp,32
    80002830:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002832:	0541                	addi	a0,a0,16
    80002834:	00001097          	auipc	ra,0x1
    80002838:	68a080e7          	jalr	1674(ra) # 80003ebe <holdingsleep>
    8000283c:	cd01                	beqz	a0,80002854 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    8000283e:	4585                	li	a1,1
    80002840:	8526                	mv	a0,s1
    80002842:	00003097          	auipc	ra,0x3
    80002846:	104080e7          	jalr	260(ra) # 80005946 <virtio_disk_rw>
}
    8000284a:	60e2                	ld	ra,24(sp)
    8000284c:	6442                	ld	s0,16(sp)
    8000284e:	64a2                	ld	s1,8(sp)
    80002850:	6105                	addi	sp,sp,32
    80002852:	8082                	ret
    panic("bwrite");
    80002854:	00006517          	auipc	a0,0x6
    80002858:	d4c50513          	addi	a0,a0,-692 # 800085a0 <syscalls+0x138>
    8000285c:	00004097          	auipc	ra,0x4
    80002860:	bc4080e7          	jalr	-1084(ra) # 80006420 <panic>

0000000080002864 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002864:	1101                	addi	sp,sp,-32
    80002866:	ec06                	sd	ra,24(sp)
    80002868:	e822                	sd	s0,16(sp)
    8000286a:	e426                	sd	s1,8(sp)
    8000286c:	e04a                	sd	s2,0(sp)
    8000286e:	1000                	addi	s0,sp,32
    80002870:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002872:	01050913          	addi	s2,a0,16
    80002876:	854a                	mv	a0,s2
    80002878:	00001097          	auipc	ra,0x1
    8000287c:	646080e7          	jalr	1606(ra) # 80003ebe <holdingsleep>
    80002880:	c92d                	beqz	a0,800028f2 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    80002882:	854a                	mv	a0,s2
    80002884:	00001097          	auipc	ra,0x1
    80002888:	5f6080e7          	jalr	1526(ra) # 80003e7a <releasesleep>

  acquire(&bcache.lock);
    8000288c:	0000c517          	auipc	a0,0xc
    80002890:	60c50513          	addi	a0,a0,1548 # 8000ee98 <bcache>
    80002894:	00004097          	auipc	ra,0x4
    80002898:	0d6080e7          	jalr	214(ra) # 8000696a <acquire>
  b->refcnt--;
    8000289c:	40bc                	lw	a5,64(s1)
    8000289e:	37fd                	addiw	a5,a5,-1
    800028a0:	0007871b          	sext.w	a4,a5
    800028a4:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800028a6:	eb05                	bnez	a4,800028d6 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800028a8:	68bc                	ld	a5,80(s1)
    800028aa:	64b8                	ld	a4,72(s1)
    800028ac:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    800028ae:	64bc                	ld	a5,72(s1)
    800028b0:	68b8                	ld	a4,80(s1)
    800028b2:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800028b4:	00014797          	auipc	a5,0x14
    800028b8:	5e478793          	addi	a5,a5,1508 # 80016e98 <bcache+0x8000>
    800028bc:	2b87b703          	ld	a4,696(a5)
    800028c0:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800028c2:	00015717          	auipc	a4,0x15
    800028c6:	83e70713          	addi	a4,a4,-1986 # 80017100 <bcache+0x8268>
    800028ca:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800028cc:	2b87b703          	ld	a4,696(a5)
    800028d0:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800028d2:	2a97bc23          	sd	s1,696(a5)
  }

  release(&bcache.lock);
    800028d6:	0000c517          	auipc	a0,0xc
    800028da:	5c250513          	addi	a0,a0,1474 # 8000ee98 <bcache>
    800028de:	00004097          	auipc	ra,0x4
    800028e2:	140080e7          	jalr	320(ra) # 80006a1e <release>
}
    800028e6:	60e2                	ld	ra,24(sp)
    800028e8:	6442                	ld	s0,16(sp)
    800028ea:	64a2                	ld	s1,8(sp)
    800028ec:	6902                	ld	s2,0(sp)
    800028ee:	6105                	addi	sp,sp,32
    800028f0:	8082                	ret
    panic("brelse");
    800028f2:	00006517          	auipc	a0,0x6
    800028f6:	cb650513          	addi	a0,a0,-842 # 800085a8 <syscalls+0x140>
    800028fa:	00004097          	auipc	ra,0x4
    800028fe:	b26080e7          	jalr	-1242(ra) # 80006420 <panic>

0000000080002902 <bpin>:

void
bpin(struct buf *b) {
    80002902:	1101                	addi	sp,sp,-32
    80002904:	ec06                	sd	ra,24(sp)
    80002906:	e822                	sd	s0,16(sp)
    80002908:	e426                	sd	s1,8(sp)
    8000290a:	1000                	addi	s0,sp,32
    8000290c:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000290e:	0000c517          	auipc	a0,0xc
    80002912:	58a50513          	addi	a0,a0,1418 # 8000ee98 <bcache>
    80002916:	00004097          	auipc	ra,0x4
    8000291a:	054080e7          	jalr	84(ra) # 8000696a <acquire>
  b->refcnt++;
    8000291e:	40bc                	lw	a5,64(s1)
    80002920:	2785                	addiw	a5,a5,1
    80002922:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002924:	0000c517          	auipc	a0,0xc
    80002928:	57450513          	addi	a0,a0,1396 # 8000ee98 <bcache>
    8000292c:	00004097          	auipc	ra,0x4
    80002930:	0f2080e7          	jalr	242(ra) # 80006a1e <release>
}
    80002934:	60e2                	ld	ra,24(sp)
    80002936:	6442                	ld	s0,16(sp)
    80002938:	64a2                	ld	s1,8(sp)
    8000293a:	6105                	addi	sp,sp,32
    8000293c:	8082                	ret

000000008000293e <bunpin>:

void
bunpin(struct buf *b) {
    8000293e:	1101                	addi	sp,sp,-32
    80002940:	ec06                	sd	ra,24(sp)
    80002942:	e822                	sd	s0,16(sp)
    80002944:	e426                	sd	s1,8(sp)
    80002946:	1000                	addi	s0,sp,32
    80002948:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000294a:	0000c517          	auipc	a0,0xc
    8000294e:	54e50513          	addi	a0,a0,1358 # 8000ee98 <bcache>
    80002952:	00004097          	auipc	ra,0x4
    80002956:	018080e7          	jalr	24(ra) # 8000696a <acquire>
  b->refcnt--;
    8000295a:	40bc                	lw	a5,64(s1)
    8000295c:	37fd                	addiw	a5,a5,-1
    8000295e:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002960:	0000c517          	auipc	a0,0xc
    80002964:	53850513          	addi	a0,a0,1336 # 8000ee98 <bcache>
    80002968:	00004097          	auipc	ra,0x4
    8000296c:	0b6080e7          	jalr	182(ra) # 80006a1e <release>
}
    80002970:	60e2                	ld	ra,24(sp)
    80002972:	6442                	ld	s0,16(sp)
    80002974:	64a2                	ld	s1,8(sp)
    80002976:	6105                	addi	sp,sp,32
    80002978:	8082                	ret

000000008000297a <write_page_to_disk>:

/* NTU OS 2024 */
/* Write 4096 bytes page to the eight consecutive 512-byte blocks starting at blk. */
void write_page_to_disk(uint dev, char *page, uint blk) {
    8000297a:	7179                	addi	sp,sp,-48
    8000297c:	f406                	sd	ra,40(sp)
    8000297e:	f022                	sd	s0,32(sp)
    80002980:	ec26                	sd	s1,24(sp)
    80002982:	e84a                	sd	s2,16(sp)
    80002984:	e44e                	sd	s3,8(sp)
    80002986:	e052                	sd	s4,0(sp)
    80002988:	1800                	addi	s0,sp,48
    8000298a:	89b2                	mv	s3,a2
  for (int i = 0; i < 8; i++) {
    8000298c:	892e                	mv	s2,a1
    8000298e:	6a05                	lui	s4,0x1
    80002990:	9a2e                	add	s4,s4,a1
    // disk
    int offset = i * 512;
    int blk_idx = blk + i;
    struct buf *buffer = bget(ROOTDEV, blk_idx);
    80002992:	85ce                	mv	a1,s3
    80002994:	4505                	li	a0,1
    80002996:	00000097          	auipc	ra,0x0
    8000299a:	cf2080e7          	jalr	-782(ra) # 80002688 <bget>
    8000299e:	84aa                	mv	s1,a0
    memmove(buffer->data, page + offset, 512);
    800029a0:	20000613          	li	a2,512
    800029a4:	85ca                	mv	a1,s2
    800029a6:	05850513          	addi	a0,a0,88
    800029aa:	ffffe097          	auipc	ra,0xffffe
    800029ae:	82e080e7          	jalr	-2002(ra) # 800001d8 <memmove>
    bwrite(buffer);
    800029b2:	8526                	mv	a0,s1
    800029b4:	00000097          	auipc	ra,0x0
    800029b8:	e72080e7          	jalr	-398(ra) # 80002826 <bwrite>
    brelse(buffer);
    800029bc:	8526                	mv	a0,s1
    800029be:	00000097          	auipc	ra,0x0
    800029c2:	ea6080e7          	jalr	-346(ra) # 80002864 <brelse>
  for (int i = 0; i < 8; i++) {
    800029c6:	2985                	addiw	s3,s3,1
    800029c8:	20090913          	addi	s2,s2,512
    800029cc:	fd4913e3          	bne	s2,s4,80002992 <write_page_to_disk+0x18>
  }
}
    800029d0:	70a2                	ld	ra,40(sp)
    800029d2:	7402                	ld	s0,32(sp)
    800029d4:	64e2                	ld	s1,24(sp)
    800029d6:	6942                	ld	s2,16(sp)
    800029d8:	69a2                	ld	s3,8(sp)
    800029da:	6a02                	ld	s4,0(sp)
    800029dc:	6145                	addi	sp,sp,48
    800029de:	8082                	ret

00000000800029e0 <read_page_from_disk>:

/* NTU OS 2024 */
/* Read 4096 bytes from the eight consecutive 512-byte blocks starting at blk into page. */
void read_page_from_disk(uint dev, char *page, uint blk) {
    800029e0:	7179                	addi	sp,sp,-48
    800029e2:	f406                	sd	ra,40(sp)
    800029e4:	f022                	sd	s0,32(sp)
    800029e6:	ec26                	sd	s1,24(sp)
    800029e8:	e84a                	sd	s2,16(sp)
    800029ea:	e44e                	sd	s3,8(sp)
    800029ec:	e052                	sd	s4,0(sp)
    800029ee:	1800                	addi	s0,sp,48
    800029f0:	89b2                	mv	s3,a2
  for (int i = 0; i < 8; i++) {
    800029f2:	892e                	mv	s2,a1
    800029f4:	6a05                	lui	s4,0x1
    800029f6:	9a2e                	add	s4,s4,a1
    int offset = i * 512;
    int blk_idx = blk + i;
    struct buf *buffer = bread(ROOTDEV, blk_idx);
    800029f8:	85ce                	mv	a1,s3
    800029fa:	4505                	li	a0,1
    800029fc:	00000097          	auipc	ra,0x0
    80002a00:	df6080e7          	jalr	-522(ra) # 800027f2 <bread>
    80002a04:	84aa                	mv	s1,a0
    memmove(page + offset, buffer->data, 512);
    80002a06:	20000613          	li	a2,512
    80002a0a:	05850593          	addi	a1,a0,88
    80002a0e:	854a                	mv	a0,s2
    80002a10:	ffffd097          	auipc	ra,0xffffd
    80002a14:	7c8080e7          	jalr	1992(ra) # 800001d8 <memmove>
    brelse(buffer);
    80002a18:	8526                	mv	a0,s1
    80002a1a:	00000097          	auipc	ra,0x0
    80002a1e:	e4a080e7          	jalr	-438(ra) # 80002864 <brelse>
  for (int i = 0; i < 8; i++) {
    80002a22:	2985                	addiw	s3,s3,1
    80002a24:	20090913          	addi	s2,s2,512
    80002a28:	fd4918e3          	bne	s2,s4,800029f8 <read_page_from_disk+0x18>
  }
}
    80002a2c:	70a2                	ld	ra,40(sp)
    80002a2e:	7402                	ld	s0,32(sp)
    80002a30:	64e2                	ld	s1,24(sp)
    80002a32:	6942                	ld	s2,16(sp)
    80002a34:	69a2                	ld	s3,8(sp)
    80002a36:	6a02                	ld	s4,0(sp)
    80002a38:	6145                	addi	sp,sp,48
    80002a3a:	8082                	ret

0000000080002a3c <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002a3c:	1101                	addi	sp,sp,-32
    80002a3e:	ec06                	sd	ra,24(sp)
    80002a40:	e822                	sd	s0,16(sp)
    80002a42:	e426                	sd	s1,8(sp)
    80002a44:	1000                	addi	s0,sp,32
    80002a46:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002a48:	00d5d59b          	srliw	a1,a1,0xd
    80002a4c:	00015797          	auipc	a5,0x15
    80002a50:	b287a783          	lw	a5,-1240(a5) # 80017574 <sb+0x1c>
    80002a54:	9dbd                	addw	a1,a1,a5
    80002a56:	00000097          	auipc	ra,0x0
    80002a5a:	d9c080e7          	jalr	-612(ra) # 800027f2 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002a5e:	0074f713          	andi	a4,s1,7
    80002a62:	4785                	li	a5,1
    80002a64:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002a68:	14ce                	slli	s1,s1,0x33
    80002a6a:	90d9                	srli	s1,s1,0x36
    80002a6c:	00950733          	add	a4,a0,s1
    80002a70:	05874703          	lbu	a4,88(a4)
    80002a74:	00e7f6b3          	and	a3,a5,a4
    80002a78:	c285                	beqz	a3,80002a98 <bfree+0x5c>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002a7a:	94aa                	add	s1,s1,a0
    80002a7c:	fff7c793          	not	a5,a5
    80002a80:	8ff9                	and	a5,a5,a4
    80002a82:	04f48c23          	sb	a5,88(s1)
  //log_write(bp);
  brelse(bp);
    80002a86:	00000097          	auipc	ra,0x0
    80002a8a:	dde080e7          	jalr	-546(ra) # 80002864 <brelse>
}
    80002a8e:	60e2                	ld	ra,24(sp)
    80002a90:	6442                	ld	s0,16(sp)
    80002a92:	64a2                	ld	s1,8(sp)
    80002a94:	6105                	addi	sp,sp,32
    80002a96:	8082                	ret
    panic("freeing free block");
    80002a98:	00006517          	auipc	a0,0x6
    80002a9c:	b1850513          	addi	a0,a0,-1256 # 800085b0 <syscalls+0x148>
    80002aa0:	00004097          	auipc	ra,0x4
    80002aa4:	980080e7          	jalr	-1664(ra) # 80006420 <panic>

0000000080002aa8 <bzero>:
{
    80002aa8:	1101                	addi	sp,sp,-32
    80002aaa:	ec06                	sd	ra,24(sp)
    80002aac:	e822                	sd	s0,16(sp)
    80002aae:	e426                	sd	s1,8(sp)
    80002ab0:	1000                	addi	s0,sp,32
  bp = bread(dev, bno);
    80002ab2:	00000097          	auipc	ra,0x0
    80002ab6:	d40080e7          	jalr	-704(ra) # 800027f2 <bread>
    80002aba:	84aa                	mv	s1,a0
  memset(bp->data, 0, BSIZE);
    80002abc:	40000613          	li	a2,1024
    80002ac0:	4581                	li	a1,0
    80002ac2:	05850513          	addi	a0,a0,88
    80002ac6:	ffffd097          	auipc	ra,0xffffd
    80002aca:	6b2080e7          	jalr	1714(ra) # 80000178 <memset>
  brelse(bp);
    80002ace:	8526                	mv	a0,s1
    80002ad0:	00000097          	auipc	ra,0x0
    80002ad4:	d94080e7          	jalr	-620(ra) # 80002864 <brelse>
}
    80002ad8:	60e2                	ld	ra,24(sp)
    80002ada:	6442                	ld	s0,16(sp)
    80002adc:	64a2                	ld	s1,8(sp)
    80002ade:	6105                	addi	sp,sp,32
    80002ae0:	8082                	ret

0000000080002ae2 <balloc>:
{
    80002ae2:	711d                	addi	sp,sp,-96
    80002ae4:	ec86                	sd	ra,88(sp)
    80002ae6:	e8a2                	sd	s0,80(sp)
    80002ae8:	e4a6                	sd	s1,72(sp)
    80002aea:	e0ca                	sd	s2,64(sp)
    80002aec:	fc4e                	sd	s3,56(sp)
    80002aee:	f852                	sd	s4,48(sp)
    80002af0:	f456                	sd	s5,40(sp)
    80002af2:	f05a                	sd	s6,32(sp)
    80002af4:	ec5e                	sd	s7,24(sp)
    80002af6:	e862                	sd	s8,16(sp)
    80002af8:	e466                	sd	s9,8(sp)
    80002afa:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002afc:	00015797          	auipc	a5,0x15
    80002b00:	a607a783          	lw	a5,-1440(a5) # 8001755c <sb+0x4>
    80002b04:	cbd1                	beqz	a5,80002b98 <balloc+0xb6>
    80002b06:	8baa                	mv	s7,a0
    80002b08:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002b0a:	00015b17          	auipc	s6,0x15
    80002b0e:	a4eb0b13          	addi	s6,s6,-1458 # 80017558 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002b12:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002b14:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002b16:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002b18:	6c89                	lui	s9,0x2
    80002b1a:	a829                	j	80002b34 <balloc+0x52>
    brelse(bp);
    80002b1c:	00000097          	auipc	ra,0x0
    80002b20:	d48080e7          	jalr	-696(ra) # 80002864 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002b24:	015c87bb          	addw	a5,s9,s5
    80002b28:	00078a9b          	sext.w	s5,a5
    80002b2c:	004b2703          	lw	a4,4(s6)
    80002b30:	06eaf463          	bgeu	s5,a4,80002b98 <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    80002b34:	41fad79b          	sraiw	a5,s5,0x1f
    80002b38:	0137d79b          	srliw	a5,a5,0x13
    80002b3c:	015787bb          	addw	a5,a5,s5
    80002b40:	40d7d79b          	sraiw	a5,a5,0xd
    80002b44:	01cb2583          	lw	a1,28(s6)
    80002b48:	9dbd                	addw	a1,a1,a5
    80002b4a:	855e                	mv	a0,s7
    80002b4c:	00000097          	auipc	ra,0x0
    80002b50:	ca6080e7          	jalr	-858(ra) # 800027f2 <bread>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002b54:	004b2803          	lw	a6,4(s6)
    80002b58:	000a849b          	sext.w	s1,s5
    80002b5c:	8662                	mv	a2,s8
    80002b5e:	0004891b          	sext.w	s2,s1
    80002b62:	fb04fde3          	bgeu	s1,a6,80002b1c <balloc+0x3a>
      m = 1 << (bi % 8);
    80002b66:	41f6579b          	sraiw	a5,a2,0x1f
    80002b6a:	01d7d69b          	srliw	a3,a5,0x1d
    80002b6e:	00c6873b          	addw	a4,a3,a2
    80002b72:	00777793          	andi	a5,a4,7
    80002b76:	9f95                	subw	a5,a5,a3
    80002b78:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002b7c:	4037571b          	sraiw	a4,a4,0x3
    80002b80:	00e506b3          	add	a3,a0,a4
    80002b84:	0586c683          	lbu	a3,88(a3)
    80002b88:	00d7f5b3          	and	a1,a5,a3
    80002b8c:	cd91                	beqz	a1,80002ba8 <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002b8e:	2605                	addiw	a2,a2,1
    80002b90:	2485                	addiw	s1,s1,1
    80002b92:	fd4616e3          	bne	a2,s4,80002b5e <balloc+0x7c>
    80002b96:	b759                	j	80002b1c <balloc+0x3a>
  panic("balloc: out of blocks");
    80002b98:	00006517          	auipc	a0,0x6
    80002b9c:	a3050513          	addi	a0,a0,-1488 # 800085c8 <syscalls+0x160>
    80002ba0:	00004097          	auipc	ra,0x4
    80002ba4:	880080e7          	jalr	-1920(ra) # 80006420 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002ba8:	972a                	add	a4,a4,a0
    80002baa:	8fd5                	or	a5,a5,a3
    80002bac:	04f70c23          	sb	a5,88(a4)
        brelse(bp);
    80002bb0:	00000097          	auipc	ra,0x0
    80002bb4:	cb4080e7          	jalr	-844(ra) # 80002864 <brelse>
        bzero(dev, b + bi);
    80002bb8:	85ca                	mv	a1,s2
    80002bba:	855e                	mv	a0,s7
    80002bbc:	00000097          	auipc	ra,0x0
    80002bc0:	eec080e7          	jalr	-276(ra) # 80002aa8 <bzero>
}
    80002bc4:	8526                	mv	a0,s1
    80002bc6:	60e6                	ld	ra,88(sp)
    80002bc8:	6446                	ld	s0,80(sp)
    80002bca:	64a6                	ld	s1,72(sp)
    80002bcc:	6906                	ld	s2,64(sp)
    80002bce:	79e2                	ld	s3,56(sp)
    80002bd0:	7a42                	ld	s4,48(sp)
    80002bd2:	7aa2                	ld	s5,40(sp)
    80002bd4:	7b02                	ld	s6,32(sp)
    80002bd6:	6be2                	ld	s7,24(sp)
    80002bd8:	6c42                	ld	s8,16(sp)
    80002bda:	6ca2                	ld	s9,8(sp)
    80002bdc:	6125                	addi	sp,sp,96
    80002bde:	8082                	ret

0000000080002be0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    80002be0:	7179                	addi	sp,sp,-48
    80002be2:	f406                	sd	ra,40(sp)
    80002be4:	f022                	sd	s0,32(sp)
    80002be6:	ec26                	sd	s1,24(sp)
    80002be8:	e84a                	sd	s2,16(sp)
    80002bea:	e44e                	sd	s3,8(sp)
    80002bec:	e052                	sd	s4,0(sp)
    80002bee:	1800                	addi	s0,sp,48
    80002bf0:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002bf2:	47ad                	li	a5,11
    80002bf4:	04b7fe63          	bgeu	a5,a1,80002c50 <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    80002bf8:	ff45849b          	addiw	s1,a1,-12
    80002bfc:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002c00:	0ff00793          	li	a5,255
    80002c04:	08e7ee63          	bltu	a5,a4,80002ca0 <bmap+0xc0>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    80002c08:	08052583          	lw	a1,128(a0)
    80002c0c:	c5ad                	beqz	a1,80002c76 <bmap+0x96>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    80002c0e:	00092503          	lw	a0,0(s2)
    80002c12:	00000097          	auipc	ra,0x0
    80002c16:	be0080e7          	jalr	-1056(ra) # 800027f2 <bread>
    80002c1a:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002c1c:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002c20:	02049593          	slli	a1,s1,0x20
    80002c24:	9181                	srli	a1,a1,0x20
    80002c26:	058a                	slli	a1,a1,0x2
    80002c28:	00b784b3          	add	s1,a5,a1
    80002c2c:	0004a983          	lw	s3,0(s1)
    80002c30:	04098d63          	beqz	s3,80002c8a <bmap+0xaa>
      a[bn] = addr = balloc(ip->dev);
      //log_write(bp);
    }
    brelse(bp);
    80002c34:	8552                	mv	a0,s4
    80002c36:	00000097          	auipc	ra,0x0
    80002c3a:	c2e080e7          	jalr	-978(ra) # 80002864 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80002c3e:	854e                	mv	a0,s3
    80002c40:	70a2                	ld	ra,40(sp)
    80002c42:	7402                	ld	s0,32(sp)
    80002c44:	64e2                	ld	s1,24(sp)
    80002c46:	6942                	ld	s2,16(sp)
    80002c48:	69a2                	ld	s3,8(sp)
    80002c4a:	6a02                	ld	s4,0(sp)
    80002c4c:	6145                	addi	sp,sp,48
    80002c4e:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    80002c50:	02059493          	slli	s1,a1,0x20
    80002c54:	9081                	srli	s1,s1,0x20
    80002c56:	048a                	slli	s1,s1,0x2
    80002c58:	94aa                	add	s1,s1,a0
    80002c5a:	0504a983          	lw	s3,80(s1)
    80002c5e:	fe0990e3          	bnez	s3,80002c3e <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    80002c62:	4108                	lw	a0,0(a0)
    80002c64:	00000097          	auipc	ra,0x0
    80002c68:	e7e080e7          	jalr	-386(ra) # 80002ae2 <balloc>
    80002c6c:	0005099b          	sext.w	s3,a0
    80002c70:	0534a823          	sw	s3,80(s1)
    80002c74:	b7e9                	j	80002c3e <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    80002c76:	4108                	lw	a0,0(a0)
    80002c78:	00000097          	auipc	ra,0x0
    80002c7c:	e6a080e7          	jalr	-406(ra) # 80002ae2 <balloc>
    80002c80:	0005059b          	sext.w	a1,a0
    80002c84:	08b92023          	sw	a1,128(s2)
    80002c88:	b759                	j	80002c0e <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    80002c8a:	00092503          	lw	a0,0(s2)
    80002c8e:	00000097          	auipc	ra,0x0
    80002c92:	e54080e7          	jalr	-428(ra) # 80002ae2 <balloc>
    80002c96:	0005099b          	sext.w	s3,a0
    80002c9a:	0134a023          	sw	s3,0(s1)
    80002c9e:	bf59                	j	80002c34 <bmap+0x54>
  panic("bmap: out of range");
    80002ca0:	00006517          	auipc	a0,0x6
    80002ca4:	94050513          	addi	a0,a0,-1728 # 800085e0 <syscalls+0x178>
    80002ca8:	00003097          	auipc	ra,0x3
    80002cac:	778080e7          	jalr	1912(ra) # 80006420 <panic>

0000000080002cb0 <iget>:
{
    80002cb0:	7179                	addi	sp,sp,-48
    80002cb2:	f406                	sd	ra,40(sp)
    80002cb4:	f022                	sd	s0,32(sp)
    80002cb6:	ec26                	sd	s1,24(sp)
    80002cb8:	e84a                	sd	s2,16(sp)
    80002cba:	e44e                	sd	s3,8(sp)
    80002cbc:	e052                	sd	s4,0(sp)
    80002cbe:	1800                	addi	s0,sp,48
    80002cc0:	89aa                	mv	s3,a0
    80002cc2:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002cc4:	00015517          	auipc	a0,0x15
    80002cc8:	8b450513          	addi	a0,a0,-1868 # 80017578 <itable>
    80002ccc:	00004097          	auipc	ra,0x4
    80002cd0:	c9e080e7          	jalr	-866(ra) # 8000696a <acquire>
  empty = 0;
    80002cd4:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002cd6:	00015497          	auipc	s1,0x15
    80002cda:	8ba48493          	addi	s1,s1,-1862 # 80017590 <itable+0x18>
    80002cde:	00016697          	auipc	a3,0x16
    80002ce2:	34268693          	addi	a3,a3,834 # 80019020 <log>
    80002ce6:	a039                	j	80002cf4 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002ce8:	02090b63          	beqz	s2,80002d1e <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002cec:	08848493          	addi	s1,s1,136
    80002cf0:	02d48a63          	beq	s1,a3,80002d24 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002cf4:	449c                	lw	a5,8(s1)
    80002cf6:	fef059e3          	blez	a5,80002ce8 <iget+0x38>
    80002cfa:	4098                	lw	a4,0(s1)
    80002cfc:	ff3716e3          	bne	a4,s3,80002ce8 <iget+0x38>
    80002d00:	40d8                	lw	a4,4(s1)
    80002d02:	ff4713e3          	bne	a4,s4,80002ce8 <iget+0x38>
      ip->ref++;
    80002d06:	2785                	addiw	a5,a5,1
    80002d08:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002d0a:	00015517          	auipc	a0,0x15
    80002d0e:	86e50513          	addi	a0,a0,-1938 # 80017578 <itable>
    80002d12:	00004097          	auipc	ra,0x4
    80002d16:	d0c080e7          	jalr	-756(ra) # 80006a1e <release>
      return ip;
    80002d1a:	8926                	mv	s2,s1
    80002d1c:	a03d                	j	80002d4a <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002d1e:	f7f9                	bnez	a5,80002cec <iget+0x3c>
    80002d20:	8926                	mv	s2,s1
    80002d22:	b7e9                	j	80002cec <iget+0x3c>
  if(empty == 0)
    80002d24:	02090c63          	beqz	s2,80002d5c <iget+0xac>
  ip->dev = dev;
    80002d28:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002d2c:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002d30:	4785                	li	a5,1
    80002d32:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002d36:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002d3a:	00015517          	auipc	a0,0x15
    80002d3e:	83e50513          	addi	a0,a0,-1986 # 80017578 <itable>
    80002d42:	00004097          	auipc	ra,0x4
    80002d46:	cdc080e7          	jalr	-804(ra) # 80006a1e <release>
}
    80002d4a:	854a                	mv	a0,s2
    80002d4c:	70a2                	ld	ra,40(sp)
    80002d4e:	7402                	ld	s0,32(sp)
    80002d50:	64e2                	ld	s1,24(sp)
    80002d52:	6942                	ld	s2,16(sp)
    80002d54:	69a2                	ld	s3,8(sp)
    80002d56:	6a02                	ld	s4,0(sp)
    80002d58:	6145                	addi	sp,sp,48
    80002d5a:	8082                	ret
    panic("iget: no inodes");
    80002d5c:	00006517          	auipc	a0,0x6
    80002d60:	89c50513          	addi	a0,a0,-1892 # 800085f8 <syscalls+0x190>
    80002d64:	00003097          	auipc	ra,0x3
    80002d68:	6bc080e7          	jalr	1724(ra) # 80006420 <panic>

0000000080002d6c <fsinit>:
fsinit(int dev) {
    80002d6c:	7179                	addi	sp,sp,-48
    80002d6e:	f406                	sd	ra,40(sp)
    80002d70:	f022                	sd	s0,32(sp)
    80002d72:	ec26                	sd	s1,24(sp)
    80002d74:	e84a                	sd	s2,16(sp)
    80002d76:	e44e                	sd	s3,8(sp)
    80002d78:	1800                	addi	s0,sp,48
    80002d7a:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002d7c:	4585                	li	a1,1
    80002d7e:	00000097          	auipc	ra,0x0
    80002d82:	a74080e7          	jalr	-1420(ra) # 800027f2 <bread>
    80002d86:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002d88:	00014997          	auipc	s3,0x14
    80002d8c:	7d098993          	addi	s3,s3,2000 # 80017558 <sb>
    80002d90:	02000613          	li	a2,32
    80002d94:	05850593          	addi	a1,a0,88
    80002d98:	854e                	mv	a0,s3
    80002d9a:	ffffd097          	auipc	ra,0xffffd
    80002d9e:	43e080e7          	jalr	1086(ra) # 800001d8 <memmove>
  brelse(bp);
    80002da2:	8526                	mv	a0,s1
    80002da4:	00000097          	auipc	ra,0x0
    80002da8:	ac0080e7          	jalr	-1344(ra) # 80002864 <brelse>
  if(sb.magic != FSMAGIC)
    80002dac:	0009a703          	lw	a4,0(s3)
    80002db0:	102037b7          	lui	a5,0x10203
    80002db4:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002db8:	02f71263          	bne	a4,a5,80002ddc <fsinit+0x70>
  initlog(dev, &sb);
    80002dbc:	00014597          	auipc	a1,0x14
    80002dc0:	79c58593          	addi	a1,a1,1948 # 80017558 <sb>
    80002dc4:	854a                	mv	a0,s2
    80002dc6:	00001097          	auipc	ra,0x1
    80002dca:	cc2080e7          	jalr	-830(ra) # 80003a88 <initlog>
}
    80002dce:	70a2                	ld	ra,40(sp)
    80002dd0:	7402                	ld	s0,32(sp)
    80002dd2:	64e2                	ld	s1,24(sp)
    80002dd4:	6942                	ld	s2,16(sp)
    80002dd6:	69a2                	ld	s3,8(sp)
    80002dd8:	6145                	addi	sp,sp,48
    80002dda:	8082                	ret
    panic("invalid file system");
    80002ddc:	00006517          	auipc	a0,0x6
    80002de0:	82c50513          	addi	a0,a0,-2004 # 80008608 <syscalls+0x1a0>
    80002de4:	00003097          	auipc	ra,0x3
    80002de8:	63c080e7          	jalr	1596(ra) # 80006420 <panic>

0000000080002dec <iinit>:
{
    80002dec:	7179                	addi	sp,sp,-48
    80002dee:	f406                	sd	ra,40(sp)
    80002df0:	f022                	sd	s0,32(sp)
    80002df2:	ec26                	sd	s1,24(sp)
    80002df4:	e84a                	sd	s2,16(sp)
    80002df6:	e44e                	sd	s3,8(sp)
    80002df8:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002dfa:	00006597          	auipc	a1,0x6
    80002dfe:	82658593          	addi	a1,a1,-2010 # 80008620 <syscalls+0x1b8>
    80002e02:	00014517          	auipc	a0,0x14
    80002e06:	77650513          	addi	a0,a0,1910 # 80017578 <itable>
    80002e0a:	00004097          	auipc	ra,0x4
    80002e0e:	ad0080e7          	jalr	-1328(ra) # 800068da <initlock>
  for(i = 0; i < NINODE; i++) {
    80002e12:	00014497          	auipc	s1,0x14
    80002e16:	78e48493          	addi	s1,s1,1934 # 800175a0 <itable+0x28>
    80002e1a:	00016997          	auipc	s3,0x16
    80002e1e:	21698993          	addi	s3,s3,534 # 80019030 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002e22:	00006917          	auipc	s2,0x6
    80002e26:	80690913          	addi	s2,s2,-2042 # 80008628 <syscalls+0x1c0>
    80002e2a:	85ca                	mv	a1,s2
    80002e2c:	8526                	mv	a0,s1
    80002e2e:	00001097          	auipc	ra,0x1
    80002e32:	fbc080e7          	jalr	-68(ra) # 80003dea <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002e36:	08848493          	addi	s1,s1,136
    80002e3a:	ff3498e3          	bne	s1,s3,80002e2a <iinit+0x3e>
}
    80002e3e:	70a2                	ld	ra,40(sp)
    80002e40:	7402                	ld	s0,32(sp)
    80002e42:	64e2                	ld	s1,24(sp)
    80002e44:	6942                	ld	s2,16(sp)
    80002e46:	69a2                	ld	s3,8(sp)
    80002e48:	6145                	addi	sp,sp,48
    80002e4a:	8082                	ret

0000000080002e4c <ialloc>:
{
    80002e4c:	715d                	addi	sp,sp,-80
    80002e4e:	e486                	sd	ra,72(sp)
    80002e50:	e0a2                	sd	s0,64(sp)
    80002e52:	fc26                	sd	s1,56(sp)
    80002e54:	f84a                	sd	s2,48(sp)
    80002e56:	f44e                	sd	s3,40(sp)
    80002e58:	f052                	sd	s4,32(sp)
    80002e5a:	ec56                	sd	s5,24(sp)
    80002e5c:	e85a                	sd	s6,16(sp)
    80002e5e:	e45e                	sd	s7,8(sp)
    80002e60:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002e62:	00014717          	auipc	a4,0x14
    80002e66:	70272703          	lw	a4,1794(a4) # 80017564 <sb+0xc>
    80002e6a:	4785                	li	a5,1
    80002e6c:	04e7fa63          	bgeu	a5,a4,80002ec0 <ialloc+0x74>
    80002e70:	8aaa                	mv	s5,a0
    80002e72:	8bae                	mv	s7,a1
    80002e74:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002e76:	00014a17          	auipc	s4,0x14
    80002e7a:	6e2a0a13          	addi	s4,s4,1762 # 80017558 <sb>
    80002e7e:	00048b1b          	sext.w	s6,s1
    80002e82:	0044d593          	srli	a1,s1,0x4
    80002e86:	018a2783          	lw	a5,24(s4)
    80002e8a:	9dbd                	addw	a1,a1,a5
    80002e8c:	8556                	mv	a0,s5
    80002e8e:	00000097          	auipc	ra,0x0
    80002e92:	964080e7          	jalr	-1692(ra) # 800027f2 <bread>
    80002e96:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002e98:	05850993          	addi	s3,a0,88
    80002e9c:	00f4f793          	andi	a5,s1,15
    80002ea0:	079a                	slli	a5,a5,0x6
    80002ea2:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002ea4:	00099783          	lh	a5,0(s3)
    80002ea8:	c785                	beqz	a5,80002ed0 <ialloc+0x84>
    brelse(bp);
    80002eaa:	00000097          	auipc	ra,0x0
    80002eae:	9ba080e7          	jalr	-1606(ra) # 80002864 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002eb2:	0485                	addi	s1,s1,1
    80002eb4:	00ca2703          	lw	a4,12(s4)
    80002eb8:	0004879b          	sext.w	a5,s1
    80002ebc:	fce7e1e3          	bltu	a5,a4,80002e7e <ialloc+0x32>
  panic("ialloc: no inodes");
    80002ec0:	00005517          	auipc	a0,0x5
    80002ec4:	77050513          	addi	a0,a0,1904 # 80008630 <syscalls+0x1c8>
    80002ec8:	00003097          	auipc	ra,0x3
    80002ecc:	558080e7          	jalr	1368(ra) # 80006420 <panic>
      memset(dip, 0, sizeof(*dip));
    80002ed0:	04000613          	li	a2,64
    80002ed4:	4581                	li	a1,0
    80002ed6:	854e                	mv	a0,s3
    80002ed8:	ffffd097          	auipc	ra,0xffffd
    80002edc:	2a0080e7          	jalr	672(ra) # 80000178 <memset>
      dip->type = type;
    80002ee0:	01799023          	sh	s7,0(s3)
      brelse(bp);
    80002ee4:	854a                	mv	a0,s2
    80002ee6:	00000097          	auipc	ra,0x0
    80002eea:	97e080e7          	jalr	-1666(ra) # 80002864 <brelse>
      return iget(dev, inum);
    80002eee:	85da                	mv	a1,s6
    80002ef0:	8556                	mv	a0,s5
    80002ef2:	00000097          	auipc	ra,0x0
    80002ef6:	dbe080e7          	jalr	-578(ra) # 80002cb0 <iget>
}
    80002efa:	60a6                	ld	ra,72(sp)
    80002efc:	6406                	ld	s0,64(sp)
    80002efe:	74e2                	ld	s1,56(sp)
    80002f00:	7942                	ld	s2,48(sp)
    80002f02:	79a2                	ld	s3,40(sp)
    80002f04:	7a02                	ld	s4,32(sp)
    80002f06:	6ae2                	ld	s5,24(sp)
    80002f08:	6b42                	ld	s6,16(sp)
    80002f0a:	6ba2                	ld	s7,8(sp)
    80002f0c:	6161                	addi	sp,sp,80
    80002f0e:	8082                	ret

0000000080002f10 <iupdate>:
{
    80002f10:	1101                	addi	sp,sp,-32
    80002f12:	ec06                	sd	ra,24(sp)
    80002f14:	e822                	sd	s0,16(sp)
    80002f16:	e426                	sd	s1,8(sp)
    80002f18:	e04a                	sd	s2,0(sp)
    80002f1a:	1000                	addi	s0,sp,32
    80002f1c:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002f1e:	415c                	lw	a5,4(a0)
    80002f20:	0047d79b          	srliw	a5,a5,0x4
    80002f24:	00014597          	auipc	a1,0x14
    80002f28:	64c5a583          	lw	a1,1612(a1) # 80017570 <sb+0x18>
    80002f2c:	9dbd                	addw	a1,a1,a5
    80002f2e:	4108                	lw	a0,0(a0)
    80002f30:	00000097          	auipc	ra,0x0
    80002f34:	8c2080e7          	jalr	-1854(ra) # 800027f2 <bread>
    80002f38:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002f3a:	05850793          	addi	a5,a0,88
    80002f3e:	40d8                	lw	a4,4(s1)
    80002f40:	8b3d                	andi	a4,a4,15
    80002f42:	071a                	slli	a4,a4,0x6
    80002f44:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002f46:	04449703          	lh	a4,68(s1)
    80002f4a:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002f4e:	04649703          	lh	a4,70(s1)
    80002f52:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002f56:	04849703          	lh	a4,72(s1)
    80002f5a:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002f5e:	04a49703          	lh	a4,74(s1)
    80002f62:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002f66:	44f8                	lw	a4,76(s1)
    80002f68:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002f6a:	03400613          	li	a2,52
    80002f6e:	05048593          	addi	a1,s1,80
    80002f72:	00c78513          	addi	a0,a5,12
    80002f76:	ffffd097          	auipc	ra,0xffffd
    80002f7a:	262080e7          	jalr	610(ra) # 800001d8 <memmove>
  brelse(bp);
    80002f7e:	854a                	mv	a0,s2
    80002f80:	00000097          	auipc	ra,0x0
    80002f84:	8e4080e7          	jalr	-1820(ra) # 80002864 <brelse>
}
    80002f88:	60e2                	ld	ra,24(sp)
    80002f8a:	6442                	ld	s0,16(sp)
    80002f8c:	64a2                	ld	s1,8(sp)
    80002f8e:	6902                	ld	s2,0(sp)
    80002f90:	6105                	addi	sp,sp,32
    80002f92:	8082                	ret

0000000080002f94 <idup>:
{
    80002f94:	1101                	addi	sp,sp,-32
    80002f96:	ec06                	sd	ra,24(sp)
    80002f98:	e822                	sd	s0,16(sp)
    80002f9a:	e426                	sd	s1,8(sp)
    80002f9c:	1000                	addi	s0,sp,32
    80002f9e:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002fa0:	00014517          	auipc	a0,0x14
    80002fa4:	5d850513          	addi	a0,a0,1496 # 80017578 <itable>
    80002fa8:	00004097          	auipc	ra,0x4
    80002fac:	9c2080e7          	jalr	-1598(ra) # 8000696a <acquire>
  ip->ref++;
    80002fb0:	449c                	lw	a5,8(s1)
    80002fb2:	2785                	addiw	a5,a5,1
    80002fb4:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002fb6:	00014517          	auipc	a0,0x14
    80002fba:	5c250513          	addi	a0,a0,1474 # 80017578 <itable>
    80002fbe:	00004097          	auipc	ra,0x4
    80002fc2:	a60080e7          	jalr	-1440(ra) # 80006a1e <release>
}
    80002fc6:	8526                	mv	a0,s1
    80002fc8:	60e2                	ld	ra,24(sp)
    80002fca:	6442                	ld	s0,16(sp)
    80002fcc:	64a2                	ld	s1,8(sp)
    80002fce:	6105                	addi	sp,sp,32
    80002fd0:	8082                	ret

0000000080002fd2 <ilock>:
{
    80002fd2:	1101                	addi	sp,sp,-32
    80002fd4:	ec06                	sd	ra,24(sp)
    80002fd6:	e822                	sd	s0,16(sp)
    80002fd8:	e426                	sd	s1,8(sp)
    80002fda:	e04a                	sd	s2,0(sp)
    80002fdc:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002fde:	c115                	beqz	a0,80003002 <ilock+0x30>
    80002fe0:	84aa                	mv	s1,a0
    80002fe2:	451c                	lw	a5,8(a0)
    80002fe4:	00f05f63          	blez	a5,80003002 <ilock+0x30>
  acquiresleep(&ip->lock);
    80002fe8:	0541                	addi	a0,a0,16
    80002fea:	00001097          	auipc	ra,0x1
    80002fee:	e3a080e7          	jalr	-454(ra) # 80003e24 <acquiresleep>
  if(ip->valid == 0){
    80002ff2:	40bc                	lw	a5,64(s1)
    80002ff4:	cf99                	beqz	a5,80003012 <ilock+0x40>
}
    80002ff6:	60e2                	ld	ra,24(sp)
    80002ff8:	6442                	ld	s0,16(sp)
    80002ffa:	64a2                	ld	s1,8(sp)
    80002ffc:	6902                	ld	s2,0(sp)
    80002ffe:	6105                	addi	sp,sp,32
    80003000:	8082                	ret
    panic("ilock");
    80003002:	00005517          	auipc	a0,0x5
    80003006:	64650513          	addi	a0,a0,1606 # 80008648 <syscalls+0x1e0>
    8000300a:	00003097          	auipc	ra,0x3
    8000300e:	416080e7          	jalr	1046(ra) # 80006420 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003012:	40dc                	lw	a5,4(s1)
    80003014:	0047d79b          	srliw	a5,a5,0x4
    80003018:	00014597          	auipc	a1,0x14
    8000301c:	5585a583          	lw	a1,1368(a1) # 80017570 <sb+0x18>
    80003020:	9dbd                	addw	a1,a1,a5
    80003022:	4088                	lw	a0,0(s1)
    80003024:	fffff097          	auipc	ra,0xfffff
    80003028:	7ce080e7          	jalr	1998(ra) # 800027f2 <bread>
    8000302c:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    8000302e:	05850593          	addi	a1,a0,88
    80003032:	40dc                	lw	a5,4(s1)
    80003034:	8bbd                	andi	a5,a5,15
    80003036:	079a                	slli	a5,a5,0x6
    80003038:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    8000303a:	00059783          	lh	a5,0(a1)
    8000303e:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003042:	00259783          	lh	a5,2(a1)
    80003046:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    8000304a:	00459783          	lh	a5,4(a1)
    8000304e:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003052:	00659783          	lh	a5,6(a1)
    80003056:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    8000305a:	459c                	lw	a5,8(a1)
    8000305c:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    8000305e:	03400613          	li	a2,52
    80003062:	05b1                	addi	a1,a1,12
    80003064:	05048513          	addi	a0,s1,80
    80003068:	ffffd097          	auipc	ra,0xffffd
    8000306c:	170080e7          	jalr	368(ra) # 800001d8 <memmove>
    brelse(bp);
    80003070:	854a                	mv	a0,s2
    80003072:	fffff097          	auipc	ra,0xfffff
    80003076:	7f2080e7          	jalr	2034(ra) # 80002864 <brelse>
    ip->valid = 1;
    8000307a:	4785                	li	a5,1
    8000307c:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    8000307e:	04449783          	lh	a5,68(s1)
    80003082:	fbb5                	bnez	a5,80002ff6 <ilock+0x24>
      panic("ilock: no type");
    80003084:	00005517          	auipc	a0,0x5
    80003088:	5cc50513          	addi	a0,a0,1484 # 80008650 <syscalls+0x1e8>
    8000308c:	00003097          	auipc	ra,0x3
    80003090:	394080e7          	jalr	916(ra) # 80006420 <panic>

0000000080003094 <iunlock>:
{
    80003094:	1101                	addi	sp,sp,-32
    80003096:	ec06                	sd	ra,24(sp)
    80003098:	e822                	sd	s0,16(sp)
    8000309a:	e426                	sd	s1,8(sp)
    8000309c:	e04a                	sd	s2,0(sp)
    8000309e:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    800030a0:	c905                	beqz	a0,800030d0 <iunlock+0x3c>
    800030a2:	84aa                	mv	s1,a0
    800030a4:	01050913          	addi	s2,a0,16
    800030a8:	854a                	mv	a0,s2
    800030aa:	00001097          	auipc	ra,0x1
    800030ae:	e14080e7          	jalr	-492(ra) # 80003ebe <holdingsleep>
    800030b2:	cd19                	beqz	a0,800030d0 <iunlock+0x3c>
    800030b4:	449c                	lw	a5,8(s1)
    800030b6:	00f05d63          	blez	a5,800030d0 <iunlock+0x3c>
  releasesleep(&ip->lock);
    800030ba:	854a                	mv	a0,s2
    800030bc:	00001097          	auipc	ra,0x1
    800030c0:	dbe080e7          	jalr	-578(ra) # 80003e7a <releasesleep>
}
    800030c4:	60e2                	ld	ra,24(sp)
    800030c6:	6442                	ld	s0,16(sp)
    800030c8:	64a2                	ld	s1,8(sp)
    800030ca:	6902                	ld	s2,0(sp)
    800030cc:	6105                	addi	sp,sp,32
    800030ce:	8082                	ret
    panic("iunlock");
    800030d0:	00005517          	auipc	a0,0x5
    800030d4:	59050513          	addi	a0,a0,1424 # 80008660 <syscalls+0x1f8>
    800030d8:	00003097          	auipc	ra,0x3
    800030dc:	348080e7          	jalr	840(ra) # 80006420 <panic>

00000000800030e0 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    800030e0:	7179                	addi	sp,sp,-48
    800030e2:	f406                	sd	ra,40(sp)
    800030e4:	f022                	sd	s0,32(sp)
    800030e6:	ec26                	sd	s1,24(sp)
    800030e8:	e84a                	sd	s2,16(sp)
    800030ea:	e44e                	sd	s3,8(sp)
    800030ec:	e052                	sd	s4,0(sp)
    800030ee:	1800                	addi	s0,sp,48
    800030f0:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    800030f2:	05050493          	addi	s1,a0,80
    800030f6:	08050913          	addi	s2,a0,128
    800030fa:	a021                	j	80003102 <itrunc+0x22>
    800030fc:	0491                	addi	s1,s1,4
    800030fe:	01248d63          	beq	s1,s2,80003118 <itrunc+0x38>
    if(ip->addrs[i]){
    80003102:	408c                	lw	a1,0(s1)
    80003104:	dde5                	beqz	a1,800030fc <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80003106:	0009a503          	lw	a0,0(s3)
    8000310a:	00000097          	auipc	ra,0x0
    8000310e:	932080e7          	jalr	-1742(ra) # 80002a3c <bfree>
      ip->addrs[i] = 0;
    80003112:	0004a023          	sw	zero,0(s1)
    80003116:	b7dd                	j	800030fc <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003118:	0809a583          	lw	a1,128(s3)
    8000311c:	e185                	bnez	a1,8000313c <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    8000311e:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80003122:	854e                	mv	a0,s3
    80003124:	00000097          	auipc	ra,0x0
    80003128:	dec080e7          	jalr	-532(ra) # 80002f10 <iupdate>
}
    8000312c:	70a2                	ld	ra,40(sp)
    8000312e:	7402                	ld	s0,32(sp)
    80003130:	64e2                	ld	s1,24(sp)
    80003132:	6942                	ld	s2,16(sp)
    80003134:	69a2                	ld	s3,8(sp)
    80003136:	6a02                	ld	s4,0(sp)
    80003138:	6145                	addi	sp,sp,48
    8000313a:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    8000313c:	0009a503          	lw	a0,0(s3)
    80003140:	fffff097          	auipc	ra,0xfffff
    80003144:	6b2080e7          	jalr	1714(ra) # 800027f2 <bread>
    80003148:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    8000314a:	05850493          	addi	s1,a0,88
    8000314e:	45850913          	addi	s2,a0,1112
    80003152:	a811                	j	80003166 <itrunc+0x86>
        bfree(ip->dev, a[j]);
    80003154:	0009a503          	lw	a0,0(s3)
    80003158:	00000097          	auipc	ra,0x0
    8000315c:	8e4080e7          	jalr	-1820(ra) # 80002a3c <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80003160:	0491                	addi	s1,s1,4
    80003162:	01248563          	beq	s1,s2,8000316c <itrunc+0x8c>
      if(a[j])
    80003166:	408c                	lw	a1,0(s1)
    80003168:	dde5                	beqz	a1,80003160 <itrunc+0x80>
    8000316a:	b7ed                	j	80003154 <itrunc+0x74>
    brelse(bp);
    8000316c:	8552                	mv	a0,s4
    8000316e:	fffff097          	auipc	ra,0xfffff
    80003172:	6f6080e7          	jalr	1782(ra) # 80002864 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003176:	0809a583          	lw	a1,128(s3)
    8000317a:	0009a503          	lw	a0,0(s3)
    8000317e:	00000097          	auipc	ra,0x0
    80003182:	8be080e7          	jalr	-1858(ra) # 80002a3c <bfree>
    ip->addrs[NDIRECT] = 0;
    80003186:	0809a023          	sw	zero,128(s3)
    8000318a:	bf51                	j	8000311e <itrunc+0x3e>

000000008000318c <iput>:
{
    8000318c:	1101                	addi	sp,sp,-32
    8000318e:	ec06                	sd	ra,24(sp)
    80003190:	e822                	sd	s0,16(sp)
    80003192:	e426                	sd	s1,8(sp)
    80003194:	e04a                	sd	s2,0(sp)
    80003196:	1000                	addi	s0,sp,32
    80003198:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    8000319a:	00014517          	auipc	a0,0x14
    8000319e:	3de50513          	addi	a0,a0,990 # 80017578 <itable>
    800031a2:	00003097          	auipc	ra,0x3
    800031a6:	7c8080e7          	jalr	1992(ra) # 8000696a <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800031aa:	4498                	lw	a4,8(s1)
    800031ac:	4785                	li	a5,1
    800031ae:	02f70363          	beq	a4,a5,800031d4 <iput+0x48>
  ip->ref--;
    800031b2:	449c                	lw	a5,8(s1)
    800031b4:	37fd                	addiw	a5,a5,-1
    800031b6:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800031b8:	00014517          	auipc	a0,0x14
    800031bc:	3c050513          	addi	a0,a0,960 # 80017578 <itable>
    800031c0:	00004097          	auipc	ra,0x4
    800031c4:	85e080e7          	jalr	-1954(ra) # 80006a1e <release>
}
    800031c8:	60e2                	ld	ra,24(sp)
    800031ca:	6442                	ld	s0,16(sp)
    800031cc:	64a2                	ld	s1,8(sp)
    800031ce:	6902                	ld	s2,0(sp)
    800031d0:	6105                	addi	sp,sp,32
    800031d2:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800031d4:	40bc                	lw	a5,64(s1)
    800031d6:	dff1                	beqz	a5,800031b2 <iput+0x26>
    800031d8:	04a49783          	lh	a5,74(s1)
    800031dc:	fbf9                	bnez	a5,800031b2 <iput+0x26>
    acquiresleep(&ip->lock);
    800031de:	01048913          	addi	s2,s1,16
    800031e2:	854a                	mv	a0,s2
    800031e4:	00001097          	auipc	ra,0x1
    800031e8:	c40080e7          	jalr	-960(ra) # 80003e24 <acquiresleep>
    release(&itable.lock);
    800031ec:	00014517          	auipc	a0,0x14
    800031f0:	38c50513          	addi	a0,a0,908 # 80017578 <itable>
    800031f4:	00004097          	auipc	ra,0x4
    800031f8:	82a080e7          	jalr	-2006(ra) # 80006a1e <release>
    itrunc(ip);
    800031fc:	8526                	mv	a0,s1
    800031fe:	00000097          	auipc	ra,0x0
    80003202:	ee2080e7          	jalr	-286(ra) # 800030e0 <itrunc>
    ip->type = 0;
    80003206:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    8000320a:	8526                	mv	a0,s1
    8000320c:	00000097          	auipc	ra,0x0
    80003210:	d04080e7          	jalr	-764(ra) # 80002f10 <iupdate>
    ip->valid = 0;
    80003214:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003218:	854a                	mv	a0,s2
    8000321a:	00001097          	auipc	ra,0x1
    8000321e:	c60080e7          	jalr	-928(ra) # 80003e7a <releasesleep>
    acquire(&itable.lock);
    80003222:	00014517          	auipc	a0,0x14
    80003226:	35650513          	addi	a0,a0,854 # 80017578 <itable>
    8000322a:	00003097          	auipc	ra,0x3
    8000322e:	740080e7          	jalr	1856(ra) # 8000696a <acquire>
    80003232:	b741                	j	800031b2 <iput+0x26>

0000000080003234 <iunlockput>:
{
    80003234:	1101                	addi	sp,sp,-32
    80003236:	ec06                	sd	ra,24(sp)
    80003238:	e822                	sd	s0,16(sp)
    8000323a:	e426                	sd	s1,8(sp)
    8000323c:	1000                	addi	s0,sp,32
    8000323e:	84aa                	mv	s1,a0
  iunlock(ip);
    80003240:	00000097          	auipc	ra,0x0
    80003244:	e54080e7          	jalr	-428(ra) # 80003094 <iunlock>
  iput(ip);
    80003248:	8526                	mv	a0,s1
    8000324a:	00000097          	auipc	ra,0x0
    8000324e:	f42080e7          	jalr	-190(ra) # 8000318c <iput>
}
    80003252:	60e2                	ld	ra,24(sp)
    80003254:	6442                	ld	s0,16(sp)
    80003256:	64a2                	ld	s1,8(sp)
    80003258:	6105                	addi	sp,sp,32
    8000325a:	8082                	ret

000000008000325c <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    8000325c:	1141                	addi	sp,sp,-16
    8000325e:	e422                	sd	s0,8(sp)
    80003260:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003262:	411c                	lw	a5,0(a0)
    80003264:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003266:	415c                	lw	a5,4(a0)
    80003268:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    8000326a:	04451783          	lh	a5,68(a0)
    8000326e:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003272:	04a51783          	lh	a5,74(a0)
    80003276:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    8000327a:	04c56783          	lwu	a5,76(a0)
    8000327e:	e99c                	sd	a5,16(a1)
}
    80003280:	6422                	ld	s0,8(sp)
    80003282:	0141                	addi	sp,sp,16
    80003284:	8082                	ret

0000000080003286 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003286:	457c                	lw	a5,76(a0)
    80003288:	0ed7e963          	bltu	a5,a3,8000337a <readi+0xf4>
{
    8000328c:	7159                	addi	sp,sp,-112
    8000328e:	f486                	sd	ra,104(sp)
    80003290:	f0a2                	sd	s0,96(sp)
    80003292:	eca6                	sd	s1,88(sp)
    80003294:	e8ca                	sd	s2,80(sp)
    80003296:	e4ce                	sd	s3,72(sp)
    80003298:	e0d2                	sd	s4,64(sp)
    8000329a:	fc56                	sd	s5,56(sp)
    8000329c:	f85a                	sd	s6,48(sp)
    8000329e:	f45e                	sd	s7,40(sp)
    800032a0:	f062                	sd	s8,32(sp)
    800032a2:	ec66                	sd	s9,24(sp)
    800032a4:	e86a                	sd	s10,16(sp)
    800032a6:	e46e                	sd	s11,8(sp)
    800032a8:	1880                	addi	s0,sp,112
    800032aa:	8baa                	mv	s7,a0
    800032ac:	8c2e                	mv	s8,a1
    800032ae:	8ab2                	mv	s5,a2
    800032b0:	84b6                	mv	s1,a3
    800032b2:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    800032b4:	9f35                	addw	a4,a4,a3
    return 0;
    800032b6:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    800032b8:	0ad76063          	bltu	a4,a3,80003358 <readi+0xd2>
  if(off + n > ip->size)
    800032bc:	00e7f463          	bgeu	a5,a4,800032c4 <readi+0x3e>
    n = ip->size - off;
    800032c0:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800032c4:	0a0b0963          	beqz	s6,80003376 <readi+0xf0>
    800032c8:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    800032ca:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    800032ce:	5cfd                	li	s9,-1
    800032d0:	a82d                	j	8000330a <readi+0x84>
    800032d2:	020a1d93          	slli	s11,s4,0x20
    800032d6:	020ddd93          	srli	s11,s11,0x20
    800032da:	05890613          	addi	a2,s2,88
    800032de:	86ee                	mv	a3,s11
    800032e0:	963a                	add	a2,a2,a4
    800032e2:	85d6                	mv	a1,s5
    800032e4:	8562                	mv	a0,s8
    800032e6:	fffff097          	auipc	ra,0xfffff
    800032ea:	a50080e7          	jalr	-1456(ra) # 80001d36 <either_copyout>
    800032ee:	05950d63          	beq	a0,s9,80003348 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    800032f2:	854a                	mv	a0,s2
    800032f4:	fffff097          	auipc	ra,0xfffff
    800032f8:	570080e7          	jalr	1392(ra) # 80002864 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800032fc:	013a09bb          	addw	s3,s4,s3
    80003300:	009a04bb          	addw	s1,s4,s1
    80003304:	9aee                	add	s5,s5,s11
    80003306:	0569f763          	bgeu	s3,s6,80003354 <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    8000330a:	000ba903          	lw	s2,0(s7)
    8000330e:	00a4d59b          	srliw	a1,s1,0xa
    80003312:	855e                	mv	a0,s7
    80003314:	00000097          	auipc	ra,0x0
    80003318:	8cc080e7          	jalr	-1844(ra) # 80002be0 <bmap>
    8000331c:	0005059b          	sext.w	a1,a0
    80003320:	854a                	mv	a0,s2
    80003322:	fffff097          	auipc	ra,0xfffff
    80003326:	4d0080e7          	jalr	1232(ra) # 800027f2 <bread>
    8000332a:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000332c:	3ff4f713          	andi	a4,s1,1023
    80003330:	40ed07bb          	subw	a5,s10,a4
    80003334:	413b06bb          	subw	a3,s6,s3
    80003338:	8a3e                	mv	s4,a5
    8000333a:	2781                	sext.w	a5,a5
    8000333c:	0006861b          	sext.w	a2,a3
    80003340:	f8f679e3          	bgeu	a2,a5,800032d2 <readi+0x4c>
    80003344:	8a36                	mv	s4,a3
    80003346:	b771                	j	800032d2 <readi+0x4c>
      brelse(bp);
    80003348:	854a                	mv	a0,s2
    8000334a:	fffff097          	auipc	ra,0xfffff
    8000334e:	51a080e7          	jalr	1306(ra) # 80002864 <brelse>
      tot = -1;
    80003352:	59fd                	li	s3,-1
  }
  return tot;
    80003354:	0009851b          	sext.w	a0,s3
}
    80003358:	70a6                	ld	ra,104(sp)
    8000335a:	7406                	ld	s0,96(sp)
    8000335c:	64e6                	ld	s1,88(sp)
    8000335e:	6946                	ld	s2,80(sp)
    80003360:	69a6                	ld	s3,72(sp)
    80003362:	6a06                	ld	s4,64(sp)
    80003364:	7ae2                	ld	s5,56(sp)
    80003366:	7b42                	ld	s6,48(sp)
    80003368:	7ba2                	ld	s7,40(sp)
    8000336a:	7c02                	ld	s8,32(sp)
    8000336c:	6ce2                	ld	s9,24(sp)
    8000336e:	6d42                	ld	s10,16(sp)
    80003370:	6da2                	ld	s11,8(sp)
    80003372:	6165                	addi	sp,sp,112
    80003374:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003376:	89da                	mv	s3,s6
    80003378:	bff1                	j	80003354 <readi+0xce>
    return 0;
    8000337a:	4501                	li	a0,0
}
    8000337c:	8082                	ret

000000008000337e <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    8000337e:	457c                	lw	a5,76(a0)
    80003380:	10d7e363          	bltu	a5,a3,80003486 <writei+0x108>
{
    80003384:	7159                	addi	sp,sp,-112
    80003386:	f486                	sd	ra,104(sp)
    80003388:	f0a2                	sd	s0,96(sp)
    8000338a:	eca6                	sd	s1,88(sp)
    8000338c:	e8ca                	sd	s2,80(sp)
    8000338e:	e4ce                	sd	s3,72(sp)
    80003390:	e0d2                	sd	s4,64(sp)
    80003392:	fc56                	sd	s5,56(sp)
    80003394:	f85a                	sd	s6,48(sp)
    80003396:	f45e                	sd	s7,40(sp)
    80003398:	f062                	sd	s8,32(sp)
    8000339a:	ec66                	sd	s9,24(sp)
    8000339c:	e86a                	sd	s10,16(sp)
    8000339e:	e46e                	sd	s11,8(sp)
    800033a0:	1880                	addi	s0,sp,112
    800033a2:	8b2a                	mv	s6,a0
    800033a4:	8c2e                	mv	s8,a1
    800033a6:	8ab2                	mv	s5,a2
    800033a8:	8936                	mv	s2,a3
    800033aa:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    800033ac:	00e687bb          	addw	a5,a3,a4
    800033b0:	0cd7ed63          	bltu	a5,a3,8000348a <writei+0x10c>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    800033b4:	00043737          	lui	a4,0x43
    800033b8:	0cf76b63          	bltu	a4,a5,8000348e <writei+0x110>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800033bc:	0c0b8363          	beqz	s7,80003482 <writei+0x104>
    800033c0:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    800033c2:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    800033c6:	5cfd                	li	s9,-1
    800033c8:	a82d                	j	80003402 <writei+0x84>
    800033ca:	02099d93          	slli	s11,s3,0x20
    800033ce:	020ddd93          	srli	s11,s11,0x20
    800033d2:	05848513          	addi	a0,s1,88
    800033d6:	86ee                	mv	a3,s11
    800033d8:	8656                	mv	a2,s5
    800033da:	85e2                	mv	a1,s8
    800033dc:	953a                	add	a0,a0,a4
    800033de:	fffff097          	auipc	ra,0xfffff
    800033e2:	9ae080e7          	jalr	-1618(ra) # 80001d8c <either_copyin>
    800033e6:	05950d63          	beq	a0,s9,80003440 <writei+0xc2>
      brelse(bp);
      break;
    }
    //log_write(bp);
    brelse(bp);
    800033ea:	8526                	mv	a0,s1
    800033ec:	fffff097          	auipc	ra,0xfffff
    800033f0:	478080e7          	jalr	1144(ra) # 80002864 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800033f4:	01498a3b          	addw	s4,s3,s4
    800033f8:	0129893b          	addw	s2,s3,s2
    800033fc:	9aee                	add	s5,s5,s11
    800033fe:	057a7663          	bgeu	s4,s7,8000344a <writei+0xcc>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003402:	000b2483          	lw	s1,0(s6)
    80003406:	00a9559b          	srliw	a1,s2,0xa
    8000340a:	855a                	mv	a0,s6
    8000340c:	fffff097          	auipc	ra,0xfffff
    80003410:	7d4080e7          	jalr	2004(ra) # 80002be0 <bmap>
    80003414:	0005059b          	sext.w	a1,a0
    80003418:	8526                	mv	a0,s1
    8000341a:	fffff097          	auipc	ra,0xfffff
    8000341e:	3d8080e7          	jalr	984(ra) # 800027f2 <bread>
    80003422:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003424:	3ff97713          	andi	a4,s2,1023
    80003428:	40ed07bb          	subw	a5,s10,a4
    8000342c:	414b86bb          	subw	a3,s7,s4
    80003430:	89be                	mv	s3,a5
    80003432:	2781                	sext.w	a5,a5
    80003434:	0006861b          	sext.w	a2,a3
    80003438:	f8f679e3          	bgeu	a2,a5,800033ca <writei+0x4c>
    8000343c:	89b6                	mv	s3,a3
    8000343e:	b771                	j	800033ca <writei+0x4c>
      brelse(bp);
    80003440:	8526                	mv	a0,s1
    80003442:	fffff097          	auipc	ra,0xfffff
    80003446:	422080e7          	jalr	1058(ra) # 80002864 <brelse>
  }

  if(off > ip->size)
    8000344a:	04cb2783          	lw	a5,76(s6)
    8000344e:	0127f463          	bgeu	a5,s2,80003456 <writei+0xd8>
    ip->size = off;
    80003452:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003456:	855a                	mv	a0,s6
    80003458:	00000097          	auipc	ra,0x0
    8000345c:	ab8080e7          	jalr	-1352(ra) # 80002f10 <iupdate>

  return tot;
    80003460:	000a051b          	sext.w	a0,s4
}
    80003464:	70a6                	ld	ra,104(sp)
    80003466:	7406                	ld	s0,96(sp)
    80003468:	64e6                	ld	s1,88(sp)
    8000346a:	6946                	ld	s2,80(sp)
    8000346c:	69a6                	ld	s3,72(sp)
    8000346e:	6a06                	ld	s4,64(sp)
    80003470:	7ae2                	ld	s5,56(sp)
    80003472:	7b42                	ld	s6,48(sp)
    80003474:	7ba2                	ld	s7,40(sp)
    80003476:	7c02                	ld	s8,32(sp)
    80003478:	6ce2                	ld	s9,24(sp)
    8000347a:	6d42                	ld	s10,16(sp)
    8000347c:	6da2                	ld	s11,8(sp)
    8000347e:	6165                	addi	sp,sp,112
    80003480:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003482:	8a5e                	mv	s4,s7
    80003484:	bfc9                	j	80003456 <writei+0xd8>
    return -1;
    80003486:	557d                	li	a0,-1
}
    80003488:	8082                	ret
    return -1;
    8000348a:	557d                	li	a0,-1
    8000348c:	bfe1                	j	80003464 <writei+0xe6>
    return -1;
    8000348e:	557d                	li	a0,-1
    80003490:	bfd1                	j	80003464 <writei+0xe6>

0000000080003492 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003492:	1141                	addi	sp,sp,-16
    80003494:	e406                	sd	ra,8(sp)
    80003496:	e022                	sd	s0,0(sp)
    80003498:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    8000349a:	4639                	li	a2,14
    8000349c:	ffffd097          	auipc	ra,0xffffd
    800034a0:	db4080e7          	jalr	-588(ra) # 80000250 <strncmp>
}
    800034a4:	60a2                	ld	ra,8(sp)
    800034a6:	6402                	ld	s0,0(sp)
    800034a8:	0141                	addi	sp,sp,16
    800034aa:	8082                	ret

00000000800034ac <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800034ac:	7139                	addi	sp,sp,-64
    800034ae:	fc06                	sd	ra,56(sp)
    800034b0:	f822                	sd	s0,48(sp)
    800034b2:	f426                	sd	s1,40(sp)
    800034b4:	f04a                	sd	s2,32(sp)
    800034b6:	ec4e                	sd	s3,24(sp)
    800034b8:	e852                	sd	s4,16(sp)
    800034ba:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800034bc:	04451703          	lh	a4,68(a0)
    800034c0:	4785                	li	a5,1
    800034c2:	00f71a63          	bne	a4,a5,800034d6 <dirlookup+0x2a>
    800034c6:	892a                	mv	s2,a0
    800034c8:	89ae                	mv	s3,a1
    800034ca:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800034cc:	457c                	lw	a5,76(a0)
    800034ce:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800034d0:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800034d2:	e79d                	bnez	a5,80003500 <dirlookup+0x54>
    800034d4:	a8a5                	j	8000354c <dirlookup+0xa0>
    panic("dirlookup not DIR");
    800034d6:	00005517          	auipc	a0,0x5
    800034da:	19250513          	addi	a0,a0,402 # 80008668 <syscalls+0x200>
    800034de:	00003097          	auipc	ra,0x3
    800034e2:	f42080e7          	jalr	-190(ra) # 80006420 <panic>
      panic("dirlookup read");
    800034e6:	00005517          	auipc	a0,0x5
    800034ea:	19a50513          	addi	a0,a0,410 # 80008680 <syscalls+0x218>
    800034ee:	00003097          	auipc	ra,0x3
    800034f2:	f32080e7          	jalr	-206(ra) # 80006420 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800034f6:	24c1                	addiw	s1,s1,16
    800034f8:	04c92783          	lw	a5,76(s2)
    800034fc:	04f4f763          	bgeu	s1,a5,8000354a <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003500:	4741                	li	a4,16
    80003502:	86a6                	mv	a3,s1
    80003504:	fc040613          	addi	a2,s0,-64
    80003508:	4581                	li	a1,0
    8000350a:	854a                	mv	a0,s2
    8000350c:	00000097          	auipc	ra,0x0
    80003510:	d7a080e7          	jalr	-646(ra) # 80003286 <readi>
    80003514:	47c1                	li	a5,16
    80003516:	fcf518e3          	bne	a0,a5,800034e6 <dirlookup+0x3a>
    if(de.inum == 0)
    8000351a:	fc045783          	lhu	a5,-64(s0)
    8000351e:	dfe1                	beqz	a5,800034f6 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003520:	fc240593          	addi	a1,s0,-62
    80003524:	854e                	mv	a0,s3
    80003526:	00000097          	auipc	ra,0x0
    8000352a:	f6c080e7          	jalr	-148(ra) # 80003492 <namecmp>
    8000352e:	f561                	bnez	a0,800034f6 <dirlookup+0x4a>
      if(poff)
    80003530:	000a0463          	beqz	s4,80003538 <dirlookup+0x8c>
        *poff = off;
    80003534:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003538:	fc045583          	lhu	a1,-64(s0)
    8000353c:	00092503          	lw	a0,0(s2)
    80003540:	fffff097          	auipc	ra,0xfffff
    80003544:	770080e7          	jalr	1904(ra) # 80002cb0 <iget>
    80003548:	a011                	j	8000354c <dirlookup+0xa0>
  return 0;
    8000354a:	4501                	li	a0,0
}
    8000354c:	70e2                	ld	ra,56(sp)
    8000354e:	7442                	ld	s0,48(sp)
    80003550:	74a2                	ld	s1,40(sp)
    80003552:	7902                	ld	s2,32(sp)
    80003554:	69e2                	ld	s3,24(sp)
    80003556:	6a42                	ld	s4,16(sp)
    80003558:	6121                	addi	sp,sp,64
    8000355a:	8082                	ret

000000008000355c <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    8000355c:	711d                	addi	sp,sp,-96
    8000355e:	ec86                	sd	ra,88(sp)
    80003560:	e8a2                	sd	s0,80(sp)
    80003562:	e4a6                	sd	s1,72(sp)
    80003564:	e0ca                	sd	s2,64(sp)
    80003566:	fc4e                	sd	s3,56(sp)
    80003568:	f852                	sd	s4,48(sp)
    8000356a:	f456                	sd	s5,40(sp)
    8000356c:	f05a                	sd	s6,32(sp)
    8000356e:	ec5e                	sd	s7,24(sp)
    80003570:	e862                	sd	s8,16(sp)
    80003572:	e466                	sd	s9,8(sp)
    80003574:	1080                	addi	s0,sp,96
    80003576:	84aa                	mv	s1,a0
    80003578:	8b2e                	mv	s6,a1
    8000357a:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    8000357c:	00054703          	lbu	a4,0(a0)
    80003580:	02f00793          	li	a5,47
    80003584:	02f70363          	beq	a4,a5,800035aa <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003588:	ffffe097          	auipc	ra,0xffffe
    8000358c:	d4e080e7          	jalr	-690(ra) # 800012d6 <myproc>
    80003590:	15053503          	ld	a0,336(a0)
    80003594:	00000097          	auipc	ra,0x0
    80003598:	a00080e7          	jalr	-1536(ra) # 80002f94 <idup>
    8000359c:	89aa                	mv	s3,a0
  while(*path == '/')
    8000359e:	02f00913          	li	s2,47
  len = path - s;
    800035a2:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    800035a4:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800035a6:	4c05                	li	s8,1
    800035a8:	a865                	j	80003660 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    800035aa:	4585                	li	a1,1
    800035ac:	4505                	li	a0,1
    800035ae:	fffff097          	auipc	ra,0xfffff
    800035b2:	702080e7          	jalr	1794(ra) # 80002cb0 <iget>
    800035b6:	89aa                	mv	s3,a0
    800035b8:	b7dd                	j	8000359e <namex+0x42>
      iunlockput(ip);
    800035ba:	854e                	mv	a0,s3
    800035bc:	00000097          	auipc	ra,0x0
    800035c0:	c78080e7          	jalr	-904(ra) # 80003234 <iunlockput>
      return 0;
    800035c4:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800035c6:	854e                	mv	a0,s3
    800035c8:	60e6                	ld	ra,88(sp)
    800035ca:	6446                	ld	s0,80(sp)
    800035cc:	64a6                	ld	s1,72(sp)
    800035ce:	6906                	ld	s2,64(sp)
    800035d0:	79e2                	ld	s3,56(sp)
    800035d2:	7a42                	ld	s4,48(sp)
    800035d4:	7aa2                	ld	s5,40(sp)
    800035d6:	7b02                	ld	s6,32(sp)
    800035d8:	6be2                	ld	s7,24(sp)
    800035da:	6c42                	ld	s8,16(sp)
    800035dc:	6ca2                	ld	s9,8(sp)
    800035de:	6125                	addi	sp,sp,96
    800035e0:	8082                	ret
      iunlock(ip);
    800035e2:	854e                	mv	a0,s3
    800035e4:	00000097          	auipc	ra,0x0
    800035e8:	ab0080e7          	jalr	-1360(ra) # 80003094 <iunlock>
      return ip;
    800035ec:	bfe9                	j	800035c6 <namex+0x6a>
      iunlockput(ip);
    800035ee:	854e                	mv	a0,s3
    800035f0:	00000097          	auipc	ra,0x0
    800035f4:	c44080e7          	jalr	-956(ra) # 80003234 <iunlockput>
      return 0;
    800035f8:	89d2                	mv	s3,s4
    800035fa:	b7f1                	j	800035c6 <namex+0x6a>
  len = path - s;
    800035fc:	40b48633          	sub	a2,s1,a1
    80003600:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    80003604:	094cd463          	bge	s9,s4,8000368c <namex+0x130>
    memmove(name, s, DIRSIZ);
    80003608:	4639                	li	a2,14
    8000360a:	8556                	mv	a0,s5
    8000360c:	ffffd097          	auipc	ra,0xffffd
    80003610:	bcc080e7          	jalr	-1076(ra) # 800001d8 <memmove>
  while(*path == '/')
    80003614:	0004c783          	lbu	a5,0(s1)
    80003618:	01279763          	bne	a5,s2,80003626 <namex+0xca>
    path++;
    8000361c:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000361e:	0004c783          	lbu	a5,0(s1)
    80003622:	ff278de3          	beq	a5,s2,8000361c <namex+0xc0>
    ilock(ip);
    80003626:	854e                	mv	a0,s3
    80003628:	00000097          	auipc	ra,0x0
    8000362c:	9aa080e7          	jalr	-1622(ra) # 80002fd2 <ilock>
    if(ip->type != T_DIR){
    80003630:	04499783          	lh	a5,68(s3)
    80003634:	f98793e3          	bne	a5,s8,800035ba <namex+0x5e>
    if(nameiparent && *path == '\0'){
    80003638:	000b0563          	beqz	s6,80003642 <namex+0xe6>
    8000363c:	0004c783          	lbu	a5,0(s1)
    80003640:	d3cd                	beqz	a5,800035e2 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003642:	865e                	mv	a2,s7
    80003644:	85d6                	mv	a1,s5
    80003646:	854e                	mv	a0,s3
    80003648:	00000097          	auipc	ra,0x0
    8000364c:	e64080e7          	jalr	-412(ra) # 800034ac <dirlookup>
    80003650:	8a2a                	mv	s4,a0
    80003652:	dd51                	beqz	a0,800035ee <namex+0x92>
    iunlockput(ip);
    80003654:	854e                	mv	a0,s3
    80003656:	00000097          	auipc	ra,0x0
    8000365a:	bde080e7          	jalr	-1058(ra) # 80003234 <iunlockput>
    ip = next;
    8000365e:	89d2                	mv	s3,s4
  while(*path == '/')
    80003660:	0004c783          	lbu	a5,0(s1)
    80003664:	05279763          	bne	a5,s2,800036b2 <namex+0x156>
    path++;
    80003668:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000366a:	0004c783          	lbu	a5,0(s1)
    8000366e:	ff278de3          	beq	a5,s2,80003668 <namex+0x10c>
  if(*path == 0)
    80003672:	c79d                	beqz	a5,800036a0 <namex+0x144>
    path++;
    80003674:	85a6                	mv	a1,s1
  len = path - s;
    80003676:	8a5e                	mv	s4,s7
    80003678:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    8000367a:	01278963          	beq	a5,s2,8000368c <namex+0x130>
    8000367e:	dfbd                	beqz	a5,800035fc <namex+0xa0>
    path++;
    80003680:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    80003682:	0004c783          	lbu	a5,0(s1)
    80003686:	ff279ce3          	bne	a5,s2,8000367e <namex+0x122>
    8000368a:	bf8d                	j	800035fc <namex+0xa0>
    memmove(name, s, len);
    8000368c:	2601                	sext.w	a2,a2
    8000368e:	8556                	mv	a0,s5
    80003690:	ffffd097          	auipc	ra,0xffffd
    80003694:	b48080e7          	jalr	-1208(ra) # 800001d8 <memmove>
    name[len] = 0;
    80003698:	9a56                	add	s4,s4,s5
    8000369a:	000a0023          	sb	zero,0(s4)
    8000369e:	bf9d                	j	80003614 <namex+0xb8>
  if(nameiparent){
    800036a0:	f20b03e3          	beqz	s6,800035c6 <namex+0x6a>
    iput(ip);
    800036a4:	854e                	mv	a0,s3
    800036a6:	00000097          	auipc	ra,0x0
    800036aa:	ae6080e7          	jalr	-1306(ra) # 8000318c <iput>
    return 0;
    800036ae:	4981                	li	s3,0
    800036b0:	bf19                	j	800035c6 <namex+0x6a>
  if(*path == 0)
    800036b2:	d7fd                	beqz	a5,800036a0 <namex+0x144>
  while(*path != '/' && *path != 0)
    800036b4:	0004c783          	lbu	a5,0(s1)
    800036b8:	85a6                	mv	a1,s1
    800036ba:	b7d1                	j	8000367e <namex+0x122>

00000000800036bc <dirlink>:
{
    800036bc:	7139                	addi	sp,sp,-64
    800036be:	fc06                	sd	ra,56(sp)
    800036c0:	f822                	sd	s0,48(sp)
    800036c2:	f426                	sd	s1,40(sp)
    800036c4:	f04a                	sd	s2,32(sp)
    800036c6:	ec4e                	sd	s3,24(sp)
    800036c8:	e852                	sd	s4,16(sp)
    800036ca:	0080                	addi	s0,sp,64
    800036cc:	892a                	mv	s2,a0
    800036ce:	8a2e                	mv	s4,a1
    800036d0:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800036d2:	4601                	li	a2,0
    800036d4:	00000097          	auipc	ra,0x0
    800036d8:	dd8080e7          	jalr	-552(ra) # 800034ac <dirlookup>
    800036dc:	e93d                	bnez	a0,80003752 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800036de:	04c92483          	lw	s1,76(s2)
    800036e2:	c49d                	beqz	s1,80003710 <dirlink+0x54>
    800036e4:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800036e6:	4741                	li	a4,16
    800036e8:	86a6                	mv	a3,s1
    800036ea:	fc040613          	addi	a2,s0,-64
    800036ee:	4581                	li	a1,0
    800036f0:	854a                	mv	a0,s2
    800036f2:	00000097          	auipc	ra,0x0
    800036f6:	b94080e7          	jalr	-1132(ra) # 80003286 <readi>
    800036fa:	47c1                	li	a5,16
    800036fc:	06f51163          	bne	a0,a5,8000375e <dirlink+0xa2>
    if(de.inum == 0)
    80003700:	fc045783          	lhu	a5,-64(s0)
    80003704:	c791                	beqz	a5,80003710 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003706:	24c1                	addiw	s1,s1,16
    80003708:	04c92783          	lw	a5,76(s2)
    8000370c:	fcf4ede3          	bltu	s1,a5,800036e6 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003710:	4639                	li	a2,14
    80003712:	85d2                	mv	a1,s4
    80003714:	fc240513          	addi	a0,s0,-62
    80003718:	ffffd097          	auipc	ra,0xffffd
    8000371c:	b74080e7          	jalr	-1164(ra) # 8000028c <strncpy>
  de.inum = inum;
    80003720:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003724:	4741                	li	a4,16
    80003726:	86a6                	mv	a3,s1
    80003728:	fc040613          	addi	a2,s0,-64
    8000372c:	4581                	li	a1,0
    8000372e:	854a                	mv	a0,s2
    80003730:	00000097          	auipc	ra,0x0
    80003734:	c4e080e7          	jalr	-946(ra) # 8000337e <writei>
    80003738:	872a                	mv	a4,a0
    8000373a:	47c1                	li	a5,16
  return 0;
    8000373c:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000373e:	02f71863          	bne	a4,a5,8000376e <dirlink+0xb2>
}
    80003742:	70e2                	ld	ra,56(sp)
    80003744:	7442                	ld	s0,48(sp)
    80003746:	74a2                	ld	s1,40(sp)
    80003748:	7902                	ld	s2,32(sp)
    8000374a:	69e2                	ld	s3,24(sp)
    8000374c:	6a42                	ld	s4,16(sp)
    8000374e:	6121                	addi	sp,sp,64
    80003750:	8082                	ret
    iput(ip);
    80003752:	00000097          	auipc	ra,0x0
    80003756:	a3a080e7          	jalr	-1478(ra) # 8000318c <iput>
    return -1;
    8000375a:	557d                	li	a0,-1
    8000375c:	b7dd                	j	80003742 <dirlink+0x86>
      panic("dirlink read");
    8000375e:	00005517          	auipc	a0,0x5
    80003762:	f3250513          	addi	a0,a0,-206 # 80008690 <syscalls+0x228>
    80003766:	00003097          	auipc	ra,0x3
    8000376a:	cba080e7          	jalr	-838(ra) # 80006420 <panic>
    panic("dirlink");
    8000376e:	00005517          	auipc	a0,0x5
    80003772:	0ca50513          	addi	a0,a0,202 # 80008838 <syscalls+0x3d0>
    80003776:	00003097          	auipc	ra,0x3
    8000377a:	caa080e7          	jalr	-854(ra) # 80006420 <panic>

000000008000377e <namei>:

struct inode*
namei(char *path)
{
    8000377e:	1101                	addi	sp,sp,-32
    80003780:	ec06                	sd	ra,24(sp)
    80003782:	e822                	sd	s0,16(sp)
    80003784:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003786:	fe040613          	addi	a2,s0,-32
    8000378a:	4581                	li	a1,0
    8000378c:	00000097          	auipc	ra,0x0
    80003790:	dd0080e7          	jalr	-560(ra) # 8000355c <namex>
}
    80003794:	60e2                	ld	ra,24(sp)
    80003796:	6442                	ld	s0,16(sp)
    80003798:	6105                	addi	sp,sp,32
    8000379a:	8082                	ret

000000008000379c <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    8000379c:	1141                	addi	sp,sp,-16
    8000379e:	e406                	sd	ra,8(sp)
    800037a0:	e022                	sd	s0,0(sp)
    800037a2:	0800                	addi	s0,sp,16
    800037a4:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800037a6:	4585                	li	a1,1
    800037a8:	00000097          	auipc	ra,0x0
    800037ac:	db4080e7          	jalr	-588(ra) # 8000355c <namex>
}
    800037b0:	60a2                	ld	ra,8(sp)
    800037b2:	6402                	ld	s0,0(sp)
    800037b4:	0141                	addi	sp,sp,16
    800037b6:	8082                	ret

00000000800037b8 <balloc_page>:

/* NTU OS 2024 */
/* Similar to balloc, except allocates eight consecutive free blocks. */
uint balloc_page(uint dev) {
    800037b8:	715d                	addi	sp,sp,-80
    800037ba:	e486                	sd	ra,72(sp)
    800037bc:	e0a2                	sd	s0,64(sp)
    800037be:	fc26                	sd	s1,56(sp)
    800037c0:	f84a                	sd	s2,48(sp)
    800037c2:	f44e                	sd	s3,40(sp)
    800037c4:	f052                	sd	s4,32(sp)
    800037c6:	ec56                	sd	s5,24(sp)
    800037c8:	e85a                	sd	s6,16(sp)
    800037ca:	e45e                	sd	s7,8(sp)
    800037cc:	0880                	addi	s0,sp,80
  for (int b = 0; b < sb.size; b += BPB) {
    800037ce:	00014797          	auipc	a5,0x14
    800037d2:	d8e7a783          	lw	a5,-626(a5) # 8001755c <sb+0x4>
    800037d6:	c3e9                	beqz	a5,80003898 <balloc_page+0xe0>
    800037d8:	89aa                	mv	s3,a0
    800037da:	4a01                	li	s4,0
    struct buf *bp = bread(dev, BBLOCK(b, sb));
    800037dc:	00014a97          	auipc	s5,0x14
    800037e0:	d7ca8a93          	addi	s5,s5,-644 # 80017558 <sb>

    for (int bi = 0; bi < BPB && b + bi < sb.size; bi += 8) {
    800037e4:	4b01                	li	s6,0
    800037e6:	6909                	lui	s2,0x2
  for (int b = 0; b < sb.size; b += BPB) {
    800037e8:	6b89                	lui	s7,0x2
    800037ea:	a8b9                	j	80003848 <balloc_page+0x90>
      uchar *bits = &bp->data[bi / 8];
      if (*bits == 0) {
        *bits |= 0xff; // Mark 8 consecutive blocks in use.
    800037ec:	97aa                	add	a5,a5,a0
    800037ee:	577d                	li	a4,-1
    800037f0:	04e78c23          	sb	a4,88(a5)
        //log_write(bp);
        brelse(bp);
    800037f4:	fffff097          	auipc	ra,0xfffff
    800037f8:	070080e7          	jalr	112(ra) # 80002864 <brelse>

        for (int i = 0; i < 8; i += 1) {
    800037fc:	00848a1b          	addiw	s4,s1,8
        brelse(bp);
    80003800:	8926                	mv	s2,s1
          bzero(dev, b + bi + i);
    80003802:	2981                	sext.w	s3,s3
    80003804:	0009059b          	sext.w	a1,s2
    80003808:	854e                	mv	a0,s3
    8000380a:	fffff097          	auipc	ra,0xfffff
    8000380e:	29e080e7          	jalr	670(ra) # 80002aa8 <bzero>
        for (int i = 0; i < 8; i += 1) {
    80003812:	2905                	addiw	s2,s2,1
    80003814:	ff4918e3          	bne	s2,s4,80003804 <balloc_page+0x4c>
    }

    brelse(bp);
  }
  panic("balloc_page: out of blocks");
}
    80003818:	8526                	mv	a0,s1
    8000381a:	60a6                	ld	ra,72(sp)
    8000381c:	6406                	ld	s0,64(sp)
    8000381e:	74e2                	ld	s1,56(sp)
    80003820:	7942                	ld	s2,48(sp)
    80003822:	79a2                	ld	s3,40(sp)
    80003824:	7a02                	ld	s4,32(sp)
    80003826:	6ae2                	ld	s5,24(sp)
    80003828:	6b42                	ld	s6,16(sp)
    8000382a:	6ba2                	ld	s7,8(sp)
    8000382c:	6161                	addi	sp,sp,80
    8000382e:	8082                	ret
    brelse(bp);
    80003830:	fffff097          	auipc	ra,0xfffff
    80003834:	034080e7          	jalr	52(ra) # 80002864 <brelse>
  for (int b = 0; b < sb.size; b += BPB) {
    80003838:	014b87bb          	addw	a5,s7,s4
    8000383c:	00078a1b          	sext.w	s4,a5
    80003840:	004aa703          	lw	a4,4(s5)
    80003844:	04ea7a63          	bgeu	s4,a4,80003898 <balloc_page+0xe0>
    struct buf *bp = bread(dev, BBLOCK(b, sb));
    80003848:	41fa579b          	sraiw	a5,s4,0x1f
    8000384c:	0137d79b          	srliw	a5,a5,0x13
    80003850:	014787bb          	addw	a5,a5,s4
    80003854:	40d7d79b          	sraiw	a5,a5,0xd
    80003858:	01caa583          	lw	a1,28(s5)
    8000385c:	9dbd                	addw	a1,a1,a5
    8000385e:	854e                	mv	a0,s3
    80003860:	fffff097          	auipc	ra,0xfffff
    80003864:	f92080e7          	jalr	-110(ra) # 800027f2 <bread>
    for (int bi = 0; bi < BPB && b + bi < sb.size; bi += 8) {
    80003868:	004aa603          	lw	a2,4(s5)
    8000386c:	000a049b          	sext.w	s1,s4
    80003870:	875a                	mv	a4,s6
    80003872:	fac4ffe3          	bgeu	s1,a2,80003830 <balloc_page+0x78>
      uchar *bits = &bp->data[bi / 8];
    80003876:	41f7579b          	sraiw	a5,a4,0x1f
    8000387a:	01d7d79b          	srliw	a5,a5,0x1d
    8000387e:	9fb9                	addw	a5,a5,a4
    80003880:	4037d79b          	sraiw	a5,a5,0x3
      if (*bits == 0) {
    80003884:	00f506b3          	add	a3,a0,a5
    80003888:	0586c683          	lbu	a3,88(a3)
    8000388c:	d2a5                	beqz	a3,800037ec <balloc_page+0x34>
    for (int bi = 0; bi < BPB && b + bi < sb.size; bi += 8) {
    8000388e:	2721                	addiw	a4,a4,8
    80003890:	24a1                	addiw	s1,s1,8
    80003892:	ff2710e3          	bne	a4,s2,80003872 <balloc_page+0xba>
    80003896:	bf69                	j	80003830 <balloc_page+0x78>
  panic("balloc_page: out of blocks");
    80003898:	00005517          	auipc	a0,0x5
    8000389c:	e0850513          	addi	a0,a0,-504 # 800086a0 <syscalls+0x238>
    800038a0:	00003097          	auipc	ra,0x3
    800038a4:	b80080e7          	jalr	-1152(ra) # 80006420 <panic>

00000000800038a8 <bfree_page>:

/* NTU OS 2024 */
/* Free 8 disk blocks allocated from balloc_page(). */
void bfree_page(int dev, uint blockno) {
    800038a8:	1101                	addi	sp,sp,-32
    800038aa:	ec06                	sd	ra,24(sp)
    800038ac:	e822                	sd	s0,16(sp)
    800038ae:	e426                	sd	s1,8(sp)
    800038b0:	1000                	addi	s0,sp,32
  if (blockno + 8 > sb.size) {
    800038b2:	0085871b          	addiw	a4,a1,8
    800038b6:	00014797          	auipc	a5,0x14
    800038ba:	ca67a783          	lw	a5,-858(a5) # 8001755c <sb+0x4>
    800038be:	04e7ee63          	bltu	a5,a4,8000391a <bfree_page+0x72>
    panic("bfree_page: blockno out of bound");
  }

  if ((blockno % 8) != 0) {
    800038c2:	0075f793          	andi	a5,a1,7
    800038c6:	e3b5                	bnez	a5,8000392a <bfree_page+0x82>
    panic("bfree_page: blockno is not aligned");
  }

  int bi = blockno % BPB;
    800038c8:	03359493          	slli	s1,a1,0x33
    800038cc:	90cd                	srli	s1,s1,0x33
  int b = blockno - bi;
    800038ce:	9d85                	subw	a1,a1,s1
  struct buf *bp = bread(dev, BBLOCK(b, sb));
    800038d0:	41f5d79b          	sraiw	a5,a1,0x1f
    800038d4:	0137d79b          	srliw	a5,a5,0x13
    800038d8:	9dbd                	addw	a1,a1,a5
    800038da:	40d5d59b          	sraiw	a1,a1,0xd
    800038de:	00014797          	auipc	a5,0x14
    800038e2:	c967a783          	lw	a5,-874(a5) # 80017574 <sb+0x1c>
    800038e6:	9dbd                	addw	a1,a1,a5
    800038e8:	fffff097          	auipc	ra,0xfffff
    800038ec:	f0a080e7          	jalr	-246(ra) # 800027f2 <bread>
  uchar *bits = &bp->data[bi / 8];
    800038f0:	808d                	srli	s1,s1,0x3

  if (*bits != 0xff) {
    800038f2:	009507b3          	add	a5,a0,s1
    800038f6:	0587c703          	lbu	a4,88(a5)
    800038fa:	0ff00793          	li	a5,255
    800038fe:	02f71e63          	bne	a4,a5,8000393a <bfree_page+0x92>
    panic("bfree_page: data bits are invalid");
  }

  *bits = 0;
    80003902:	94aa                	add	s1,s1,a0
    80003904:	04048c23          	sb	zero,88(s1)
  //log_write(bp);
  brelse(bp);
    80003908:	fffff097          	auipc	ra,0xfffff
    8000390c:	f5c080e7          	jalr	-164(ra) # 80002864 <brelse>
}
    80003910:	60e2                	ld	ra,24(sp)
    80003912:	6442                	ld	s0,16(sp)
    80003914:	64a2                	ld	s1,8(sp)
    80003916:	6105                	addi	sp,sp,32
    80003918:	8082                	ret
    panic("bfree_page: blockno out of bound");
    8000391a:	00005517          	auipc	a0,0x5
    8000391e:	da650513          	addi	a0,a0,-602 # 800086c0 <syscalls+0x258>
    80003922:	00003097          	auipc	ra,0x3
    80003926:	afe080e7          	jalr	-1282(ra) # 80006420 <panic>
    panic("bfree_page: blockno is not aligned");
    8000392a:	00005517          	auipc	a0,0x5
    8000392e:	dbe50513          	addi	a0,a0,-578 # 800086e8 <syscalls+0x280>
    80003932:	00003097          	auipc	ra,0x3
    80003936:	aee080e7          	jalr	-1298(ra) # 80006420 <panic>
    panic("bfree_page: data bits are invalid");
    8000393a:	00005517          	auipc	a0,0x5
    8000393e:	dd650513          	addi	a0,a0,-554 # 80008710 <syscalls+0x2a8>
    80003942:	00003097          	auipc	ra,0x3
    80003946:	ade080e7          	jalr	-1314(ra) # 80006420 <panic>

000000008000394a <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    8000394a:	1101                	addi	sp,sp,-32
    8000394c:	ec06                	sd	ra,24(sp)
    8000394e:	e822                	sd	s0,16(sp)
    80003950:	e426                	sd	s1,8(sp)
    80003952:	e04a                	sd	s2,0(sp)
    80003954:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003956:	00015917          	auipc	s2,0x15
    8000395a:	6ca90913          	addi	s2,s2,1738 # 80019020 <log>
    8000395e:	01892583          	lw	a1,24(s2)
    80003962:	02892503          	lw	a0,40(s2)
    80003966:	fffff097          	auipc	ra,0xfffff
    8000396a:	e8c080e7          	jalr	-372(ra) # 800027f2 <bread>
    8000396e:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003970:	02c92683          	lw	a3,44(s2)
    80003974:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003976:	02d05763          	blez	a3,800039a4 <write_head+0x5a>
    8000397a:	00015797          	auipc	a5,0x15
    8000397e:	6d678793          	addi	a5,a5,1750 # 80019050 <log+0x30>
    80003982:	05c50713          	addi	a4,a0,92
    80003986:	36fd                	addiw	a3,a3,-1
    80003988:	1682                	slli	a3,a3,0x20
    8000398a:	9281                	srli	a3,a3,0x20
    8000398c:	068a                	slli	a3,a3,0x2
    8000398e:	00015617          	auipc	a2,0x15
    80003992:	6c660613          	addi	a2,a2,1734 # 80019054 <log+0x34>
    80003996:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80003998:	4390                	lw	a2,0(a5)
    8000399a:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000399c:	0791                	addi	a5,a5,4
    8000399e:	0711                	addi	a4,a4,4
    800039a0:	fed79ce3          	bne	a5,a3,80003998 <write_head+0x4e>
  }
  bwrite(buf);
    800039a4:	8526                	mv	a0,s1
    800039a6:	fffff097          	auipc	ra,0xfffff
    800039aa:	e80080e7          	jalr	-384(ra) # 80002826 <bwrite>
  brelse(buf);
    800039ae:	8526                	mv	a0,s1
    800039b0:	fffff097          	auipc	ra,0xfffff
    800039b4:	eb4080e7          	jalr	-332(ra) # 80002864 <brelse>
}
    800039b8:	60e2                	ld	ra,24(sp)
    800039ba:	6442                	ld	s0,16(sp)
    800039bc:	64a2                	ld	s1,8(sp)
    800039be:	6902                	ld	s2,0(sp)
    800039c0:	6105                	addi	sp,sp,32
    800039c2:	8082                	ret

00000000800039c4 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800039c4:	00015797          	auipc	a5,0x15
    800039c8:	6887a783          	lw	a5,1672(a5) # 8001904c <log+0x2c>
    800039cc:	0af05d63          	blez	a5,80003a86 <install_trans+0xc2>
{
    800039d0:	7139                	addi	sp,sp,-64
    800039d2:	fc06                	sd	ra,56(sp)
    800039d4:	f822                	sd	s0,48(sp)
    800039d6:	f426                	sd	s1,40(sp)
    800039d8:	f04a                	sd	s2,32(sp)
    800039da:	ec4e                	sd	s3,24(sp)
    800039dc:	e852                	sd	s4,16(sp)
    800039de:	e456                	sd	s5,8(sp)
    800039e0:	e05a                	sd	s6,0(sp)
    800039e2:	0080                	addi	s0,sp,64
    800039e4:	8b2a                	mv	s6,a0
    800039e6:	00015a97          	auipc	s5,0x15
    800039ea:	66aa8a93          	addi	s5,s5,1642 # 80019050 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800039ee:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800039f0:	00015997          	auipc	s3,0x15
    800039f4:	63098993          	addi	s3,s3,1584 # 80019020 <log>
    800039f8:	a035                	j	80003a24 <install_trans+0x60>
      bunpin(dbuf);
    800039fa:	8526                	mv	a0,s1
    800039fc:	fffff097          	auipc	ra,0xfffff
    80003a00:	f42080e7          	jalr	-190(ra) # 8000293e <bunpin>
    brelse(lbuf);
    80003a04:	854a                	mv	a0,s2
    80003a06:	fffff097          	auipc	ra,0xfffff
    80003a0a:	e5e080e7          	jalr	-418(ra) # 80002864 <brelse>
    brelse(dbuf);
    80003a0e:	8526                	mv	a0,s1
    80003a10:	fffff097          	auipc	ra,0xfffff
    80003a14:	e54080e7          	jalr	-428(ra) # 80002864 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003a18:	2a05                	addiw	s4,s4,1
    80003a1a:	0a91                	addi	s5,s5,4
    80003a1c:	02c9a783          	lw	a5,44(s3)
    80003a20:	04fa5963          	bge	s4,a5,80003a72 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003a24:	0189a583          	lw	a1,24(s3)
    80003a28:	014585bb          	addw	a1,a1,s4
    80003a2c:	2585                	addiw	a1,a1,1
    80003a2e:	0289a503          	lw	a0,40(s3)
    80003a32:	fffff097          	auipc	ra,0xfffff
    80003a36:	dc0080e7          	jalr	-576(ra) # 800027f2 <bread>
    80003a3a:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003a3c:	000aa583          	lw	a1,0(s5)
    80003a40:	0289a503          	lw	a0,40(s3)
    80003a44:	fffff097          	auipc	ra,0xfffff
    80003a48:	dae080e7          	jalr	-594(ra) # 800027f2 <bread>
    80003a4c:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003a4e:	40000613          	li	a2,1024
    80003a52:	05890593          	addi	a1,s2,88
    80003a56:	05850513          	addi	a0,a0,88
    80003a5a:	ffffc097          	auipc	ra,0xffffc
    80003a5e:	77e080e7          	jalr	1918(ra) # 800001d8 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003a62:	8526                	mv	a0,s1
    80003a64:	fffff097          	auipc	ra,0xfffff
    80003a68:	dc2080e7          	jalr	-574(ra) # 80002826 <bwrite>
    if(recovering == 0)
    80003a6c:	f80b1ce3          	bnez	s6,80003a04 <install_trans+0x40>
    80003a70:	b769                	j	800039fa <install_trans+0x36>
}
    80003a72:	70e2                	ld	ra,56(sp)
    80003a74:	7442                	ld	s0,48(sp)
    80003a76:	74a2                	ld	s1,40(sp)
    80003a78:	7902                	ld	s2,32(sp)
    80003a7a:	69e2                	ld	s3,24(sp)
    80003a7c:	6a42                	ld	s4,16(sp)
    80003a7e:	6aa2                	ld	s5,8(sp)
    80003a80:	6b02                	ld	s6,0(sp)
    80003a82:	6121                	addi	sp,sp,64
    80003a84:	8082                	ret
    80003a86:	8082                	ret

0000000080003a88 <initlog>:
{
    80003a88:	7179                	addi	sp,sp,-48
    80003a8a:	f406                	sd	ra,40(sp)
    80003a8c:	f022                	sd	s0,32(sp)
    80003a8e:	ec26                	sd	s1,24(sp)
    80003a90:	e84a                	sd	s2,16(sp)
    80003a92:	e44e                	sd	s3,8(sp)
    80003a94:	1800                	addi	s0,sp,48
    80003a96:	892a                	mv	s2,a0
    80003a98:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003a9a:	00015497          	auipc	s1,0x15
    80003a9e:	58648493          	addi	s1,s1,1414 # 80019020 <log>
    80003aa2:	00005597          	auipc	a1,0x5
    80003aa6:	c9658593          	addi	a1,a1,-874 # 80008738 <syscalls+0x2d0>
    80003aaa:	8526                	mv	a0,s1
    80003aac:	00003097          	auipc	ra,0x3
    80003ab0:	e2e080e7          	jalr	-466(ra) # 800068da <initlock>
  log.start = sb->logstart;
    80003ab4:	0149a583          	lw	a1,20(s3)
    80003ab8:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003aba:	0109a783          	lw	a5,16(s3)
    80003abe:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003ac0:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003ac4:	854a                	mv	a0,s2
    80003ac6:	fffff097          	auipc	ra,0xfffff
    80003aca:	d2c080e7          	jalr	-724(ra) # 800027f2 <bread>
  log.lh.n = lh->n;
    80003ace:	4d3c                	lw	a5,88(a0)
    80003ad0:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003ad2:	02f05563          	blez	a5,80003afc <initlog+0x74>
    80003ad6:	05c50713          	addi	a4,a0,92
    80003ada:	00015697          	auipc	a3,0x15
    80003ade:	57668693          	addi	a3,a3,1398 # 80019050 <log+0x30>
    80003ae2:	37fd                	addiw	a5,a5,-1
    80003ae4:	1782                	slli	a5,a5,0x20
    80003ae6:	9381                	srli	a5,a5,0x20
    80003ae8:	078a                	slli	a5,a5,0x2
    80003aea:	06050613          	addi	a2,a0,96
    80003aee:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    80003af0:	4310                	lw	a2,0(a4)
    80003af2:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    80003af4:	0711                	addi	a4,a4,4
    80003af6:	0691                	addi	a3,a3,4
    80003af8:	fef71ce3          	bne	a4,a5,80003af0 <initlog+0x68>
  brelse(buf);
    80003afc:	fffff097          	auipc	ra,0xfffff
    80003b00:	d68080e7          	jalr	-664(ra) # 80002864 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003b04:	4505                	li	a0,1
    80003b06:	00000097          	auipc	ra,0x0
    80003b0a:	ebe080e7          	jalr	-322(ra) # 800039c4 <install_trans>
  log.lh.n = 0;
    80003b0e:	00015797          	auipc	a5,0x15
    80003b12:	5207af23          	sw	zero,1342(a5) # 8001904c <log+0x2c>
  write_head(); // clear the log
    80003b16:	00000097          	auipc	ra,0x0
    80003b1a:	e34080e7          	jalr	-460(ra) # 8000394a <write_head>
}
    80003b1e:	70a2                	ld	ra,40(sp)
    80003b20:	7402                	ld	s0,32(sp)
    80003b22:	64e2                	ld	s1,24(sp)
    80003b24:	6942                	ld	s2,16(sp)
    80003b26:	69a2                	ld	s3,8(sp)
    80003b28:	6145                	addi	sp,sp,48
    80003b2a:	8082                	ret

0000000080003b2c <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003b2c:	1101                	addi	sp,sp,-32
    80003b2e:	ec06                	sd	ra,24(sp)
    80003b30:	e822                	sd	s0,16(sp)
    80003b32:	e426                	sd	s1,8(sp)
    80003b34:	e04a                	sd	s2,0(sp)
    80003b36:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003b38:	00015517          	auipc	a0,0x15
    80003b3c:	4e850513          	addi	a0,a0,1256 # 80019020 <log>
    80003b40:	00003097          	auipc	ra,0x3
    80003b44:	e2a080e7          	jalr	-470(ra) # 8000696a <acquire>
  while(1){
    if(log.committing){
    80003b48:	00015497          	auipc	s1,0x15
    80003b4c:	4d848493          	addi	s1,s1,1240 # 80019020 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003b50:	4979                	li	s2,30
    80003b52:	a039                	j	80003b60 <begin_op+0x34>
      sleep(&log, &log.lock);
    80003b54:	85a6                	mv	a1,s1
    80003b56:	8526                	mv	a0,s1
    80003b58:	ffffe097          	auipc	ra,0xffffe
    80003b5c:	e3a080e7          	jalr	-454(ra) # 80001992 <sleep>
    if(log.committing){
    80003b60:	50dc                	lw	a5,36(s1)
    80003b62:	fbed                	bnez	a5,80003b54 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003b64:	509c                	lw	a5,32(s1)
    80003b66:	0017871b          	addiw	a4,a5,1
    80003b6a:	0007069b          	sext.w	a3,a4
    80003b6e:	0027179b          	slliw	a5,a4,0x2
    80003b72:	9fb9                	addw	a5,a5,a4
    80003b74:	0017979b          	slliw	a5,a5,0x1
    80003b78:	54d8                	lw	a4,44(s1)
    80003b7a:	9fb9                	addw	a5,a5,a4
    80003b7c:	00f95963          	bge	s2,a5,80003b8e <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003b80:	85a6                	mv	a1,s1
    80003b82:	8526                	mv	a0,s1
    80003b84:	ffffe097          	auipc	ra,0xffffe
    80003b88:	e0e080e7          	jalr	-498(ra) # 80001992 <sleep>
    80003b8c:	bfd1                	j	80003b60 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003b8e:	00015517          	auipc	a0,0x15
    80003b92:	49250513          	addi	a0,a0,1170 # 80019020 <log>
    80003b96:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80003b98:	00003097          	auipc	ra,0x3
    80003b9c:	e86080e7          	jalr	-378(ra) # 80006a1e <release>
      break;
    }
  }
}
    80003ba0:	60e2                	ld	ra,24(sp)
    80003ba2:	6442                	ld	s0,16(sp)
    80003ba4:	64a2                	ld	s1,8(sp)
    80003ba6:	6902                	ld	s2,0(sp)
    80003ba8:	6105                	addi	sp,sp,32
    80003baa:	8082                	ret

0000000080003bac <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003bac:	7139                	addi	sp,sp,-64
    80003bae:	fc06                	sd	ra,56(sp)
    80003bb0:	f822                	sd	s0,48(sp)
    80003bb2:	f426                	sd	s1,40(sp)
    80003bb4:	f04a                	sd	s2,32(sp)
    80003bb6:	ec4e                	sd	s3,24(sp)
    80003bb8:	e852                	sd	s4,16(sp)
    80003bba:	e456                	sd	s5,8(sp)
    80003bbc:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003bbe:	00015497          	auipc	s1,0x15
    80003bc2:	46248493          	addi	s1,s1,1122 # 80019020 <log>
    80003bc6:	8526                	mv	a0,s1
    80003bc8:	00003097          	auipc	ra,0x3
    80003bcc:	da2080e7          	jalr	-606(ra) # 8000696a <acquire>
  log.outstanding -= 1;
    80003bd0:	509c                	lw	a5,32(s1)
    80003bd2:	37fd                	addiw	a5,a5,-1
    80003bd4:	0007891b          	sext.w	s2,a5
    80003bd8:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003bda:	50dc                	lw	a5,36(s1)
    80003bdc:	efb9                	bnez	a5,80003c3a <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    80003bde:	06091663          	bnez	s2,80003c4a <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    80003be2:	00015497          	auipc	s1,0x15
    80003be6:	43e48493          	addi	s1,s1,1086 # 80019020 <log>
    80003bea:	4785                	li	a5,1
    80003bec:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003bee:	8526                	mv	a0,s1
    80003bf0:	00003097          	auipc	ra,0x3
    80003bf4:	e2e080e7          	jalr	-466(ra) # 80006a1e <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003bf8:	54dc                	lw	a5,44(s1)
    80003bfa:	06f04763          	bgtz	a5,80003c68 <end_op+0xbc>
    acquire(&log.lock);
    80003bfe:	00015497          	auipc	s1,0x15
    80003c02:	42248493          	addi	s1,s1,1058 # 80019020 <log>
    80003c06:	8526                	mv	a0,s1
    80003c08:	00003097          	auipc	ra,0x3
    80003c0c:	d62080e7          	jalr	-670(ra) # 8000696a <acquire>
    log.committing = 0;
    80003c10:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003c14:	8526                	mv	a0,s1
    80003c16:	ffffe097          	auipc	ra,0xffffe
    80003c1a:	f08080e7          	jalr	-248(ra) # 80001b1e <wakeup>
    release(&log.lock);
    80003c1e:	8526                	mv	a0,s1
    80003c20:	00003097          	auipc	ra,0x3
    80003c24:	dfe080e7          	jalr	-514(ra) # 80006a1e <release>
}
    80003c28:	70e2                	ld	ra,56(sp)
    80003c2a:	7442                	ld	s0,48(sp)
    80003c2c:	74a2                	ld	s1,40(sp)
    80003c2e:	7902                	ld	s2,32(sp)
    80003c30:	69e2                	ld	s3,24(sp)
    80003c32:	6a42                	ld	s4,16(sp)
    80003c34:	6aa2                	ld	s5,8(sp)
    80003c36:	6121                	addi	sp,sp,64
    80003c38:	8082                	ret
    panic("log.committing");
    80003c3a:	00005517          	auipc	a0,0x5
    80003c3e:	b0650513          	addi	a0,a0,-1274 # 80008740 <syscalls+0x2d8>
    80003c42:	00002097          	auipc	ra,0x2
    80003c46:	7de080e7          	jalr	2014(ra) # 80006420 <panic>
    wakeup(&log);
    80003c4a:	00015497          	auipc	s1,0x15
    80003c4e:	3d648493          	addi	s1,s1,982 # 80019020 <log>
    80003c52:	8526                	mv	a0,s1
    80003c54:	ffffe097          	auipc	ra,0xffffe
    80003c58:	eca080e7          	jalr	-310(ra) # 80001b1e <wakeup>
  release(&log.lock);
    80003c5c:	8526                	mv	a0,s1
    80003c5e:	00003097          	auipc	ra,0x3
    80003c62:	dc0080e7          	jalr	-576(ra) # 80006a1e <release>
  if(do_commit){
    80003c66:	b7c9                	j	80003c28 <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003c68:	00015a97          	auipc	s5,0x15
    80003c6c:	3e8a8a93          	addi	s5,s5,1000 # 80019050 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003c70:	00015a17          	auipc	s4,0x15
    80003c74:	3b0a0a13          	addi	s4,s4,944 # 80019020 <log>
    80003c78:	018a2583          	lw	a1,24(s4)
    80003c7c:	012585bb          	addw	a1,a1,s2
    80003c80:	2585                	addiw	a1,a1,1
    80003c82:	028a2503          	lw	a0,40(s4)
    80003c86:	fffff097          	auipc	ra,0xfffff
    80003c8a:	b6c080e7          	jalr	-1172(ra) # 800027f2 <bread>
    80003c8e:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003c90:	000aa583          	lw	a1,0(s5)
    80003c94:	028a2503          	lw	a0,40(s4)
    80003c98:	fffff097          	auipc	ra,0xfffff
    80003c9c:	b5a080e7          	jalr	-1190(ra) # 800027f2 <bread>
    80003ca0:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003ca2:	40000613          	li	a2,1024
    80003ca6:	05850593          	addi	a1,a0,88
    80003caa:	05848513          	addi	a0,s1,88
    80003cae:	ffffc097          	auipc	ra,0xffffc
    80003cb2:	52a080e7          	jalr	1322(ra) # 800001d8 <memmove>
    bwrite(to);  // write the log
    80003cb6:	8526                	mv	a0,s1
    80003cb8:	fffff097          	auipc	ra,0xfffff
    80003cbc:	b6e080e7          	jalr	-1170(ra) # 80002826 <bwrite>
    brelse(from);
    80003cc0:	854e                	mv	a0,s3
    80003cc2:	fffff097          	auipc	ra,0xfffff
    80003cc6:	ba2080e7          	jalr	-1118(ra) # 80002864 <brelse>
    brelse(to);
    80003cca:	8526                	mv	a0,s1
    80003ccc:	fffff097          	auipc	ra,0xfffff
    80003cd0:	b98080e7          	jalr	-1128(ra) # 80002864 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003cd4:	2905                	addiw	s2,s2,1
    80003cd6:	0a91                	addi	s5,s5,4
    80003cd8:	02ca2783          	lw	a5,44(s4)
    80003cdc:	f8f94ee3          	blt	s2,a5,80003c78 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003ce0:	00000097          	auipc	ra,0x0
    80003ce4:	c6a080e7          	jalr	-918(ra) # 8000394a <write_head>
    install_trans(0); // Now install writes to home locations
    80003ce8:	4501                	li	a0,0
    80003cea:	00000097          	auipc	ra,0x0
    80003cee:	cda080e7          	jalr	-806(ra) # 800039c4 <install_trans>
    log.lh.n = 0;
    80003cf2:	00015797          	auipc	a5,0x15
    80003cf6:	3407ad23          	sw	zero,858(a5) # 8001904c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003cfa:	00000097          	auipc	ra,0x0
    80003cfe:	c50080e7          	jalr	-944(ra) # 8000394a <write_head>
    80003d02:	bdf5                	j	80003bfe <end_op+0x52>

0000000080003d04 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003d04:	1101                	addi	sp,sp,-32
    80003d06:	ec06                	sd	ra,24(sp)
    80003d08:	e822                	sd	s0,16(sp)
    80003d0a:	e426                	sd	s1,8(sp)
    80003d0c:	e04a                	sd	s2,0(sp)
    80003d0e:	1000                	addi	s0,sp,32
    80003d10:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003d12:	00015917          	auipc	s2,0x15
    80003d16:	30e90913          	addi	s2,s2,782 # 80019020 <log>
    80003d1a:	854a                	mv	a0,s2
    80003d1c:	00003097          	auipc	ra,0x3
    80003d20:	c4e080e7          	jalr	-946(ra) # 8000696a <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003d24:	02c92603          	lw	a2,44(s2)
    80003d28:	47f5                	li	a5,29
    80003d2a:	06c7c563          	blt	a5,a2,80003d94 <log_write+0x90>
    80003d2e:	00015797          	auipc	a5,0x15
    80003d32:	30e7a783          	lw	a5,782(a5) # 8001903c <log+0x1c>
    80003d36:	37fd                	addiw	a5,a5,-1
    80003d38:	04f65e63          	bge	a2,a5,80003d94 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003d3c:	00015797          	auipc	a5,0x15
    80003d40:	3047a783          	lw	a5,772(a5) # 80019040 <log+0x20>
    80003d44:	06f05063          	blez	a5,80003da4 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003d48:	4781                	li	a5,0
    80003d4a:	06c05563          	blez	a2,80003db4 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003d4e:	44cc                	lw	a1,12(s1)
    80003d50:	00015717          	auipc	a4,0x15
    80003d54:	30070713          	addi	a4,a4,768 # 80019050 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003d58:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003d5a:	4314                	lw	a3,0(a4)
    80003d5c:	04b68c63          	beq	a3,a1,80003db4 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80003d60:	2785                	addiw	a5,a5,1
    80003d62:	0711                	addi	a4,a4,4
    80003d64:	fef61be3          	bne	a2,a5,80003d5a <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003d68:	0621                	addi	a2,a2,8
    80003d6a:	060a                	slli	a2,a2,0x2
    80003d6c:	00015797          	auipc	a5,0x15
    80003d70:	2b478793          	addi	a5,a5,692 # 80019020 <log>
    80003d74:	963e                	add	a2,a2,a5
    80003d76:	44dc                	lw	a5,12(s1)
    80003d78:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003d7a:	8526                	mv	a0,s1
    80003d7c:	fffff097          	auipc	ra,0xfffff
    80003d80:	b86080e7          	jalr	-1146(ra) # 80002902 <bpin>
    log.lh.n++;
    80003d84:	00015717          	auipc	a4,0x15
    80003d88:	29c70713          	addi	a4,a4,668 # 80019020 <log>
    80003d8c:	575c                	lw	a5,44(a4)
    80003d8e:	2785                	addiw	a5,a5,1
    80003d90:	d75c                	sw	a5,44(a4)
    80003d92:	a835                	j	80003dce <log_write+0xca>
    panic("too big a transaction");
    80003d94:	00005517          	auipc	a0,0x5
    80003d98:	9bc50513          	addi	a0,a0,-1604 # 80008750 <syscalls+0x2e8>
    80003d9c:	00002097          	auipc	ra,0x2
    80003da0:	684080e7          	jalr	1668(ra) # 80006420 <panic>
    panic("log_write outside of trans");
    80003da4:	00005517          	auipc	a0,0x5
    80003da8:	9c450513          	addi	a0,a0,-1596 # 80008768 <syscalls+0x300>
    80003dac:	00002097          	auipc	ra,0x2
    80003db0:	674080e7          	jalr	1652(ra) # 80006420 <panic>
  log.lh.block[i] = b->blockno;
    80003db4:	00878713          	addi	a4,a5,8
    80003db8:	00271693          	slli	a3,a4,0x2
    80003dbc:	00015717          	auipc	a4,0x15
    80003dc0:	26470713          	addi	a4,a4,612 # 80019020 <log>
    80003dc4:	9736                	add	a4,a4,a3
    80003dc6:	44d4                	lw	a3,12(s1)
    80003dc8:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003dca:	faf608e3          	beq	a2,a5,80003d7a <log_write+0x76>
  }
  release(&log.lock);
    80003dce:	00015517          	auipc	a0,0x15
    80003dd2:	25250513          	addi	a0,a0,594 # 80019020 <log>
    80003dd6:	00003097          	auipc	ra,0x3
    80003dda:	c48080e7          	jalr	-952(ra) # 80006a1e <release>
}
    80003dde:	60e2                	ld	ra,24(sp)
    80003de0:	6442                	ld	s0,16(sp)
    80003de2:	64a2                	ld	s1,8(sp)
    80003de4:	6902                	ld	s2,0(sp)
    80003de6:	6105                	addi	sp,sp,32
    80003de8:	8082                	ret

0000000080003dea <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003dea:	1101                	addi	sp,sp,-32
    80003dec:	ec06                	sd	ra,24(sp)
    80003dee:	e822                	sd	s0,16(sp)
    80003df0:	e426                	sd	s1,8(sp)
    80003df2:	e04a                	sd	s2,0(sp)
    80003df4:	1000                	addi	s0,sp,32
    80003df6:	84aa                	mv	s1,a0
    80003df8:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003dfa:	00005597          	auipc	a1,0x5
    80003dfe:	98e58593          	addi	a1,a1,-1650 # 80008788 <syscalls+0x320>
    80003e02:	0521                	addi	a0,a0,8
    80003e04:	00003097          	auipc	ra,0x3
    80003e08:	ad6080e7          	jalr	-1322(ra) # 800068da <initlock>
  lk->name = name;
    80003e0c:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003e10:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003e14:	0204a423          	sw	zero,40(s1)
}
    80003e18:	60e2                	ld	ra,24(sp)
    80003e1a:	6442                	ld	s0,16(sp)
    80003e1c:	64a2                	ld	s1,8(sp)
    80003e1e:	6902                	ld	s2,0(sp)
    80003e20:	6105                	addi	sp,sp,32
    80003e22:	8082                	ret

0000000080003e24 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003e24:	1101                	addi	sp,sp,-32
    80003e26:	ec06                	sd	ra,24(sp)
    80003e28:	e822                	sd	s0,16(sp)
    80003e2a:	e426                	sd	s1,8(sp)
    80003e2c:	e04a                	sd	s2,0(sp)
    80003e2e:	1000                	addi	s0,sp,32
    80003e30:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003e32:	00850913          	addi	s2,a0,8
    80003e36:	854a                	mv	a0,s2
    80003e38:	00003097          	auipc	ra,0x3
    80003e3c:	b32080e7          	jalr	-1230(ra) # 8000696a <acquire>
  while (lk->locked) {
    80003e40:	409c                	lw	a5,0(s1)
    80003e42:	cb89                	beqz	a5,80003e54 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003e44:	85ca                	mv	a1,s2
    80003e46:	8526                	mv	a0,s1
    80003e48:	ffffe097          	auipc	ra,0xffffe
    80003e4c:	b4a080e7          	jalr	-1206(ra) # 80001992 <sleep>
  while (lk->locked) {
    80003e50:	409c                	lw	a5,0(s1)
    80003e52:	fbed                	bnez	a5,80003e44 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003e54:	4785                	li	a5,1
    80003e56:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003e58:	ffffd097          	auipc	ra,0xffffd
    80003e5c:	47e080e7          	jalr	1150(ra) # 800012d6 <myproc>
    80003e60:	591c                	lw	a5,48(a0)
    80003e62:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003e64:	854a                	mv	a0,s2
    80003e66:	00003097          	auipc	ra,0x3
    80003e6a:	bb8080e7          	jalr	-1096(ra) # 80006a1e <release>
}
    80003e6e:	60e2                	ld	ra,24(sp)
    80003e70:	6442                	ld	s0,16(sp)
    80003e72:	64a2                	ld	s1,8(sp)
    80003e74:	6902                	ld	s2,0(sp)
    80003e76:	6105                	addi	sp,sp,32
    80003e78:	8082                	ret

0000000080003e7a <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003e7a:	1101                	addi	sp,sp,-32
    80003e7c:	ec06                	sd	ra,24(sp)
    80003e7e:	e822                	sd	s0,16(sp)
    80003e80:	e426                	sd	s1,8(sp)
    80003e82:	e04a                	sd	s2,0(sp)
    80003e84:	1000                	addi	s0,sp,32
    80003e86:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003e88:	00850913          	addi	s2,a0,8
    80003e8c:	854a                	mv	a0,s2
    80003e8e:	00003097          	auipc	ra,0x3
    80003e92:	adc080e7          	jalr	-1316(ra) # 8000696a <acquire>
  lk->locked = 0;
    80003e96:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003e9a:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003e9e:	8526                	mv	a0,s1
    80003ea0:	ffffe097          	auipc	ra,0xffffe
    80003ea4:	c7e080e7          	jalr	-898(ra) # 80001b1e <wakeup>
  release(&lk->lk);
    80003ea8:	854a                	mv	a0,s2
    80003eaa:	00003097          	auipc	ra,0x3
    80003eae:	b74080e7          	jalr	-1164(ra) # 80006a1e <release>
}
    80003eb2:	60e2                	ld	ra,24(sp)
    80003eb4:	6442                	ld	s0,16(sp)
    80003eb6:	64a2                	ld	s1,8(sp)
    80003eb8:	6902                	ld	s2,0(sp)
    80003eba:	6105                	addi	sp,sp,32
    80003ebc:	8082                	ret

0000000080003ebe <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003ebe:	7179                	addi	sp,sp,-48
    80003ec0:	f406                	sd	ra,40(sp)
    80003ec2:	f022                	sd	s0,32(sp)
    80003ec4:	ec26                	sd	s1,24(sp)
    80003ec6:	e84a                	sd	s2,16(sp)
    80003ec8:	e44e                	sd	s3,8(sp)
    80003eca:	1800                	addi	s0,sp,48
    80003ecc:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003ece:	00850913          	addi	s2,a0,8
    80003ed2:	854a                	mv	a0,s2
    80003ed4:	00003097          	auipc	ra,0x3
    80003ed8:	a96080e7          	jalr	-1386(ra) # 8000696a <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003edc:	409c                	lw	a5,0(s1)
    80003ede:	ef99                	bnez	a5,80003efc <holdingsleep+0x3e>
    80003ee0:	4481                	li	s1,0
  release(&lk->lk);
    80003ee2:	854a                	mv	a0,s2
    80003ee4:	00003097          	auipc	ra,0x3
    80003ee8:	b3a080e7          	jalr	-1222(ra) # 80006a1e <release>
  return r;
}
    80003eec:	8526                	mv	a0,s1
    80003eee:	70a2                	ld	ra,40(sp)
    80003ef0:	7402                	ld	s0,32(sp)
    80003ef2:	64e2                	ld	s1,24(sp)
    80003ef4:	6942                	ld	s2,16(sp)
    80003ef6:	69a2                	ld	s3,8(sp)
    80003ef8:	6145                	addi	sp,sp,48
    80003efa:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003efc:	0284a983          	lw	s3,40(s1)
    80003f00:	ffffd097          	auipc	ra,0xffffd
    80003f04:	3d6080e7          	jalr	982(ra) # 800012d6 <myproc>
    80003f08:	5904                	lw	s1,48(a0)
    80003f0a:	413484b3          	sub	s1,s1,s3
    80003f0e:	0014b493          	seqz	s1,s1
    80003f12:	bfc1                	j	80003ee2 <holdingsleep+0x24>

0000000080003f14 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003f14:	1141                	addi	sp,sp,-16
    80003f16:	e406                	sd	ra,8(sp)
    80003f18:	e022                	sd	s0,0(sp)
    80003f1a:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003f1c:	00005597          	auipc	a1,0x5
    80003f20:	87c58593          	addi	a1,a1,-1924 # 80008798 <syscalls+0x330>
    80003f24:	00015517          	auipc	a0,0x15
    80003f28:	24450513          	addi	a0,a0,580 # 80019168 <ftable>
    80003f2c:	00003097          	auipc	ra,0x3
    80003f30:	9ae080e7          	jalr	-1618(ra) # 800068da <initlock>
}
    80003f34:	60a2                	ld	ra,8(sp)
    80003f36:	6402                	ld	s0,0(sp)
    80003f38:	0141                	addi	sp,sp,16
    80003f3a:	8082                	ret

0000000080003f3c <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003f3c:	1101                	addi	sp,sp,-32
    80003f3e:	ec06                	sd	ra,24(sp)
    80003f40:	e822                	sd	s0,16(sp)
    80003f42:	e426                	sd	s1,8(sp)
    80003f44:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003f46:	00015517          	auipc	a0,0x15
    80003f4a:	22250513          	addi	a0,a0,546 # 80019168 <ftable>
    80003f4e:	00003097          	auipc	ra,0x3
    80003f52:	a1c080e7          	jalr	-1508(ra) # 8000696a <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003f56:	00015497          	auipc	s1,0x15
    80003f5a:	22a48493          	addi	s1,s1,554 # 80019180 <ftable+0x18>
    80003f5e:	00016717          	auipc	a4,0x16
    80003f62:	1c270713          	addi	a4,a4,450 # 8001a120 <ftable+0xfb8>
    if(f->ref == 0){
    80003f66:	40dc                	lw	a5,4(s1)
    80003f68:	cf99                	beqz	a5,80003f86 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003f6a:	02848493          	addi	s1,s1,40
    80003f6e:	fee49ce3          	bne	s1,a4,80003f66 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003f72:	00015517          	auipc	a0,0x15
    80003f76:	1f650513          	addi	a0,a0,502 # 80019168 <ftable>
    80003f7a:	00003097          	auipc	ra,0x3
    80003f7e:	aa4080e7          	jalr	-1372(ra) # 80006a1e <release>
  return 0;
    80003f82:	4481                	li	s1,0
    80003f84:	a819                	j	80003f9a <filealloc+0x5e>
      f->ref = 1;
    80003f86:	4785                	li	a5,1
    80003f88:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003f8a:	00015517          	auipc	a0,0x15
    80003f8e:	1de50513          	addi	a0,a0,478 # 80019168 <ftable>
    80003f92:	00003097          	auipc	ra,0x3
    80003f96:	a8c080e7          	jalr	-1396(ra) # 80006a1e <release>
}
    80003f9a:	8526                	mv	a0,s1
    80003f9c:	60e2                	ld	ra,24(sp)
    80003f9e:	6442                	ld	s0,16(sp)
    80003fa0:	64a2                	ld	s1,8(sp)
    80003fa2:	6105                	addi	sp,sp,32
    80003fa4:	8082                	ret

0000000080003fa6 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003fa6:	1101                	addi	sp,sp,-32
    80003fa8:	ec06                	sd	ra,24(sp)
    80003faa:	e822                	sd	s0,16(sp)
    80003fac:	e426                	sd	s1,8(sp)
    80003fae:	1000                	addi	s0,sp,32
    80003fb0:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003fb2:	00015517          	auipc	a0,0x15
    80003fb6:	1b650513          	addi	a0,a0,438 # 80019168 <ftable>
    80003fba:	00003097          	auipc	ra,0x3
    80003fbe:	9b0080e7          	jalr	-1616(ra) # 8000696a <acquire>
  if(f->ref < 1)
    80003fc2:	40dc                	lw	a5,4(s1)
    80003fc4:	02f05263          	blez	a5,80003fe8 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003fc8:	2785                	addiw	a5,a5,1
    80003fca:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003fcc:	00015517          	auipc	a0,0x15
    80003fd0:	19c50513          	addi	a0,a0,412 # 80019168 <ftable>
    80003fd4:	00003097          	auipc	ra,0x3
    80003fd8:	a4a080e7          	jalr	-1462(ra) # 80006a1e <release>
  return f;
}
    80003fdc:	8526                	mv	a0,s1
    80003fde:	60e2                	ld	ra,24(sp)
    80003fe0:	6442                	ld	s0,16(sp)
    80003fe2:	64a2                	ld	s1,8(sp)
    80003fe4:	6105                	addi	sp,sp,32
    80003fe6:	8082                	ret
    panic("filedup");
    80003fe8:	00004517          	auipc	a0,0x4
    80003fec:	7b850513          	addi	a0,a0,1976 # 800087a0 <syscalls+0x338>
    80003ff0:	00002097          	auipc	ra,0x2
    80003ff4:	430080e7          	jalr	1072(ra) # 80006420 <panic>

0000000080003ff8 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003ff8:	7139                	addi	sp,sp,-64
    80003ffa:	fc06                	sd	ra,56(sp)
    80003ffc:	f822                	sd	s0,48(sp)
    80003ffe:	f426                	sd	s1,40(sp)
    80004000:	f04a                	sd	s2,32(sp)
    80004002:	ec4e                	sd	s3,24(sp)
    80004004:	e852                	sd	s4,16(sp)
    80004006:	e456                	sd	s5,8(sp)
    80004008:	0080                	addi	s0,sp,64
    8000400a:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    8000400c:	00015517          	auipc	a0,0x15
    80004010:	15c50513          	addi	a0,a0,348 # 80019168 <ftable>
    80004014:	00003097          	auipc	ra,0x3
    80004018:	956080e7          	jalr	-1706(ra) # 8000696a <acquire>
  if(f->ref < 1)
    8000401c:	40dc                	lw	a5,4(s1)
    8000401e:	06f05163          	blez	a5,80004080 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80004022:	37fd                	addiw	a5,a5,-1
    80004024:	0007871b          	sext.w	a4,a5
    80004028:	c0dc                	sw	a5,4(s1)
    8000402a:	06e04363          	bgtz	a4,80004090 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    8000402e:	0004a903          	lw	s2,0(s1)
    80004032:	0094ca83          	lbu	s5,9(s1)
    80004036:	0104ba03          	ld	s4,16(s1)
    8000403a:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    8000403e:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80004042:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80004046:	00015517          	auipc	a0,0x15
    8000404a:	12250513          	addi	a0,a0,290 # 80019168 <ftable>
    8000404e:	00003097          	auipc	ra,0x3
    80004052:	9d0080e7          	jalr	-1584(ra) # 80006a1e <release>

  if(ff.type == FD_PIPE){
    80004056:	4785                	li	a5,1
    80004058:	04f90d63          	beq	s2,a5,800040b2 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    8000405c:	3979                	addiw	s2,s2,-2
    8000405e:	4785                	li	a5,1
    80004060:	0527e063          	bltu	a5,s2,800040a0 <fileclose+0xa8>
    begin_op();
    80004064:	00000097          	auipc	ra,0x0
    80004068:	ac8080e7          	jalr	-1336(ra) # 80003b2c <begin_op>
    iput(ff.ip);
    8000406c:	854e                	mv	a0,s3
    8000406e:	fffff097          	auipc	ra,0xfffff
    80004072:	11e080e7          	jalr	286(ra) # 8000318c <iput>
    end_op();
    80004076:	00000097          	auipc	ra,0x0
    8000407a:	b36080e7          	jalr	-1226(ra) # 80003bac <end_op>
    8000407e:	a00d                	j	800040a0 <fileclose+0xa8>
    panic("fileclose");
    80004080:	00004517          	auipc	a0,0x4
    80004084:	72850513          	addi	a0,a0,1832 # 800087a8 <syscalls+0x340>
    80004088:	00002097          	auipc	ra,0x2
    8000408c:	398080e7          	jalr	920(ra) # 80006420 <panic>
    release(&ftable.lock);
    80004090:	00015517          	auipc	a0,0x15
    80004094:	0d850513          	addi	a0,a0,216 # 80019168 <ftable>
    80004098:	00003097          	auipc	ra,0x3
    8000409c:	986080e7          	jalr	-1658(ra) # 80006a1e <release>
  }
}
    800040a0:	70e2                	ld	ra,56(sp)
    800040a2:	7442                	ld	s0,48(sp)
    800040a4:	74a2                	ld	s1,40(sp)
    800040a6:	7902                	ld	s2,32(sp)
    800040a8:	69e2                	ld	s3,24(sp)
    800040aa:	6a42                	ld	s4,16(sp)
    800040ac:	6aa2                	ld	s5,8(sp)
    800040ae:	6121                	addi	sp,sp,64
    800040b0:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    800040b2:	85d6                	mv	a1,s5
    800040b4:	8552                	mv	a0,s4
    800040b6:	00000097          	auipc	ra,0x0
    800040ba:	34c080e7          	jalr	844(ra) # 80004402 <pipeclose>
    800040be:	b7cd                	j	800040a0 <fileclose+0xa8>

00000000800040c0 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    800040c0:	715d                	addi	sp,sp,-80
    800040c2:	e486                	sd	ra,72(sp)
    800040c4:	e0a2                	sd	s0,64(sp)
    800040c6:	fc26                	sd	s1,56(sp)
    800040c8:	f84a                	sd	s2,48(sp)
    800040ca:	f44e                	sd	s3,40(sp)
    800040cc:	0880                	addi	s0,sp,80
    800040ce:	84aa                	mv	s1,a0
    800040d0:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    800040d2:	ffffd097          	auipc	ra,0xffffd
    800040d6:	204080e7          	jalr	516(ra) # 800012d6 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    800040da:	409c                	lw	a5,0(s1)
    800040dc:	37f9                	addiw	a5,a5,-2
    800040de:	4705                	li	a4,1
    800040e0:	04f76763          	bltu	a4,a5,8000412e <filestat+0x6e>
    800040e4:	892a                	mv	s2,a0
    ilock(f->ip);
    800040e6:	6c88                	ld	a0,24(s1)
    800040e8:	fffff097          	auipc	ra,0xfffff
    800040ec:	eea080e7          	jalr	-278(ra) # 80002fd2 <ilock>
    stati(f->ip, &st);
    800040f0:	fb840593          	addi	a1,s0,-72
    800040f4:	6c88                	ld	a0,24(s1)
    800040f6:	fffff097          	auipc	ra,0xfffff
    800040fa:	166080e7          	jalr	358(ra) # 8000325c <stati>
    iunlock(f->ip);
    800040fe:	6c88                	ld	a0,24(s1)
    80004100:	fffff097          	auipc	ra,0xfffff
    80004104:	f94080e7          	jalr	-108(ra) # 80003094 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80004108:	46e1                	li	a3,24
    8000410a:	fb840613          	addi	a2,s0,-72
    8000410e:	85ce                	mv	a1,s3
    80004110:	05093503          	ld	a0,80(s2)
    80004114:	ffffd097          	auipc	ra,0xffffd
    80004118:	9ee080e7          	jalr	-1554(ra) # 80000b02 <copyout>
    8000411c:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80004120:	60a6                	ld	ra,72(sp)
    80004122:	6406                	ld	s0,64(sp)
    80004124:	74e2                	ld	s1,56(sp)
    80004126:	7942                	ld	s2,48(sp)
    80004128:	79a2                	ld	s3,40(sp)
    8000412a:	6161                	addi	sp,sp,80
    8000412c:	8082                	ret
  return -1;
    8000412e:	557d                	li	a0,-1
    80004130:	bfc5                	j	80004120 <filestat+0x60>

0000000080004132 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80004132:	7179                	addi	sp,sp,-48
    80004134:	f406                	sd	ra,40(sp)
    80004136:	f022                	sd	s0,32(sp)
    80004138:	ec26                	sd	s1,24(sp)
    8000413a:	e84a                	sd	s2,16(sp)
    8000413c:	e44e                	sd	s3,8(sp)
    8000413e:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80004140:	00854783          	lbu	a5,8(a0)
    80004144:	c3d5                	beqz	a5,800041e8 <fileread+0xb6>
    80004146:	84aa                	mv	s1,a0
    80004148:	89ae                	mv	s3,a1
    8000414a:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    8000414c:	411c                	lw	a5,0(a0)
    8000414e:	4705                	li	a4,1
    80004150:	04e78963          	beq	a5,a4,800041a2 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004154:	470d                	li	a4,3
    80004156:	04e78d63          	beq	a5,a4,800041b0 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    8000415a:	4709                	li	a4,2
    8000415c:	06e79e63          	bne	a5,a4,800041d8 <fileread+0xa6>
    ilock(f->ip);
    80004160:	6d08                	ld	a0,24(a0)
    80004162:	fffff097          	auipc	ra,0xfffff
    80004166:	e70080e7          	jalr	-400(ra) # 80002fd2 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    8000416a:	874a                	mv	a4,s2
    8000416c:	5094                	lw	a3,32(s1)
    8000416e:	864e                	mv	a2,s3
    80004170:	4585                	li	a1,1
    80004172:	6c88                	ld	a0,24(s1)
    80004174:	fffff097          	auipc	ra,0xfffff
    80004178:	112080e7          	jalr	274(ra) # 80003286 <readi>
    8000417c:	892a                	mv	s2,a0
    8000417e:	00a05563          	blez	a0,80004188 <fileread+0x56>
      f->off += r;
    80004182:	509c                	lw	a5,32(s1)
    80004184:	9fa9                	addw	a5,a5,a0
    80004186:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004188:	6c88                	ld	a0,24(s1)
    8000418a:	fffff097          	auipc	ra,0xfffff
    8000418e:	f0a080e7          	jalr	-246(ra) # 80003094 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80004192:	854a                	mv	a0,s2
    80004194:	70a2                	ld	ra,40(sp)
    80004196:	7402                	ld	s0,32(sp)
    80004198:	64e2                	ld	s1,24(sp)
    8000419a:	6942                	ld	s2,16(sp)
    8000419c:	69a2                	ld	s3,8(sp)
    8000419e:	6145                	addi	sp,sp,48
    800041a0:	8082                	ret
    r = piperead(f->pipe, addr, n);
    800041a2:	6908                	ld	a0,16(a0)
    800041a4:	00000097          	auipc	ra,0x0
    800041a8:	3c8080e7          	jalr	968(ra) # 8000456c <piperead>
    800041ac:	892a                	mv	s2,a0
    800041ae:	b7d5                	j	80004192 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    800041b0:	02451783          	lh	a5,36(a0)
    800041b4:	03079693          	slli	a3,a5,0x30
    800041b8:	92c1                	srli	a3,a3,0x30
    800041ba:	4725                	li	a4,9
    800041bc:	02d76863          	bltu	a4,a3,800041ec <fileread+0xba>
    800041c0:	0792                	slli	a5,a5,0x4
    800041c2:	00015717          	auipc	a4,0x15
    800041c6:	f0670713          	addi	a4,a4,-250 # 800190c8 <devsw>
    800041ca:	97ba                	add	a5,a5,a4
    800041cc:	639c                	ld	a5,0(a5)
    800041ce:	c38d                	beqz	a5,800041f0 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    800041d0:	4505                	li	a0,1
    800041d2:	9782                	jalr	a5
    800041d4:	892a                	mv	s2,a0
    800041d6:	bf75                	j	80004192 <fileread+0x60>
    panic("fileread");
    800041d8:	00004517          	auipc	a0,0x4
    800041dc:	5e050513          	addi	a0,a0,1504 # 800087b8 <syscalls+0x350>
    800041e0:	00002097          	auipc	ra,0x2
    800041e4:	240080e7          	jalr	576(ra) # 80006420 <panic>
    return -1;
    800041e8:	597d                	li	s2,-1
    800041ea:	b765                	j	80004192 <fileread+0x60>
      return -1;
    800041ec:	597d                	li	s2,-1
    800041ee:	b755                	j	80004192 <fileread+0x60>
    800041f0:	597d                	li	s2,-1
    800041f2:	b745                	j	80004192 <fileread+0x60>

00000000800041f4 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    800041f4:	715d                	addi	sp,sp,-80
    800041f6:	e486                	sd	ra,72(sp)
    800041f8:	e0a2                	sd	s0,64(sp)
    800041fa:	fc26                	sd	s1,56(sp)
    800041fc:	f84a                	sd	s2,48(sp)
    800041fe:	f44e                	sd	s3,40(sp)
    80004200:	f052                	sd	s4,32(sp)
    80004202:	ec56                	sd	s5,24(sp)
    80004204:	e85a                	sd	s6,16(sp)
    80004206:	e45e                	sd	s7,8(sp)
    80004208:	e062                	sd	s8,0(sp)
    8000420a:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    8000420c:	00954783          	lbu	a5,9(a0)
    80004210:	10078663          	beqz	a5,8000431c <filewrite+0x128>
    80004214:	892a                	mv	s2,a0
    80004216:	8aae                	mv	s5,a1
    80004218:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    8000421a:	411c                	lw	a5,0(a0)
    8000421c:	4705                	li	a4,1
    8000421e:	02e78263          	beq	a5,a4,80004242 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004222:	470d                	li	a4,3
    80004224:	02e78663          	beq	a5,a4,80004250 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80004228:	4709                	li	a4,2
    8000422a:	0ee79163          	bne	a5,a4,8000430c <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    8000422e:	0ac05d63          	blez	a2,800042e8 <filewrite+0xf4>
    int i = 0;
    80004232:	4981                	li	s3,0
    80004234:	6b05                	lui	s6,0x1
    80004236:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    8000423a:	6b85                	lui	s7,0x1
    8000423c:	c00b8b9b          	addiw	s7,s7,-1024
    80004240:	a861                	j	800042d8 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80004242:	6908                	ld	a0,16(a0)
    80004244:	00000097          	auipc	ra,0x0
    80004248:	22e080e7          	jalr	558(ra) # 80004472 <pipewrite>
    8000424c:	8a2a                	mv	s4,a0
    8000424e:	a045                	j	800042ee <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80004250:	02451783          	lh	a5,36(a0)
    80004254:	03079693          	slli	a3,a5,0x30
    80004258:	92c1                	srli	a3,a3,0x30
    8000425a:	4725                	li	a4,9
    8000425c:	0cd76263          	bltu	a4,a3,80004320 <filewrite+0x12c>
    80004260:	0792                	slli	a5,a5,0x4
    80004262:	00015717          	auipc	a4,0x15
    80004266:	e6670713          	addi	a4,a4,-410 # 800190c8 <devsw>
    8000426a:	97ba                	add	a5,a5,a4
    8000426c:	679c                	ld	a5,8(a5)
    8000426e:	cbdd                	beqz	a5,80004324 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80004270:	4505                	li	a0,1
    80004272:	9782                	jalr	a5
    80004274:	8a2a                	mv	s4,a0
    80004276:	a8a5                	j	800042ee <filewrite+0xfa>
    80004278:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    8000427c:	00000097          	auipc	ra,0x0
    80004280:	8b0080e7          	jalr	-1872(ra) # 80003b2c <begin_op>
      ilock(f->ip);
    80004284:	01893503          	ld	a0,24(s2)
    80004288:	fffff097          	auipc	ra,0xfffff
    8000428c:	d4a080e7          	jalr	-694(ra) # 80002fd2 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004290:	8762                	mv	a4,s8
    80004292:	02092683          	lw	a3,32(s2)
    80004296:	01598633          	add	a2,s3,s5
    8000429a:	4585                	li	a1,1
    8000429c:	01893503          	ld	a0,24(s2)
    800042a0:	fffff097          	auipc	ra,0xfffff
    800042a4:	0de080e7          	jalr	222(ra) # 8000337e <writei>
    800042a8:	84aa                	mv	s1,a0
    800042aa:	00a05763          	blez	a0,800042b8 <filewrite+0xc4>
        f->off += r;
    800042ae:	02092783          	lw	a5,32(s2)
    800042b2:	9fa9                	addw	a5,a5,a0
    800042b4:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    800042b8:	01893503          	ld	a0,24(s2)
    800042bc:	fffff097          	auipc	ra,0xfffff
    800042c0:	dd8080e7          	jalr	-552(ra) # 80003094 <iunlock>
      end_op();
    800042c4:	00000097          	auipc	ra,0x0
    800042c8:	8e8080e7          	jalr	-1816(ra) # 80003bac <end_op>

      if(r != n1){
    800042cc:	009c1f63          	bne	s8,s1,800042ea <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    800042d0:	013489bb          	addw	s3,s1,s3
    while(i < n){
    800042d4:	0149db63          	bge	s3,s4,800042ea <filewrite+0xf6>
      int n1 = n - i;
    800042d8:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    800042dc:	84be                	mv	s1,a5
    800042de:	2781                	sext.w	a5,a5
    800042e0:	f8fb5ce3          	bge	s6,a5,80004278 <filewrite+0x84>
    800042e4:	84de                	mv	s1,s7
    800042e6:	bf49                	j	80004278 <filewrite+0x84>
    int i = 0;
    800042e8:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    800042ea:	013a1f63          	bne	s4,s3,80004308 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    800042ee:	8552                	mv	a0,s4
    800042f0:	60a6                	ld	ra,72(sp)
    800042f2:	6406                	ld	s0,64(sp)
    800042f4:	74e2                	ld	s1,56(sp)
    800042f6:	7942                	ld	s2,48(sp)
    800042f8:	79a2                	ld	s3,40(sp)
    800042fa:	7a02                	ld	s4,32(sp)
    800042fc:	6ae2                	ld	s5,24(sp)
    800042fe:	6b42                	ld	s6,16(sp)
    80004300:	6ba2                	ld	s7,8(sp)
    80004302:	6c02                	ld	s8,0(sp)
    80004304:	6161                	addi	sp,sp,80
    80004306:	8082                	ret
    ret = (i == n ? n : -1);
    80004308:	5a7d                	li	s4,-1
    8000430a:	b7d5                	j	800042ee <filewrite+0xfa>
    panic("filewrite");
    8000430c:	00004517          	auipc	a0,0x4
    80004310:	4bc50513          	addi	a0,a0,1212 # 800087c8 <syscalls+0x360>
    80004314:	00002097          	auipc	ra,0x2
    80004318:	10c080e7          	jalr	268(ra) # 80006420 <panic>
    return -1;
    8000431c:	5a7d                	li	s4,-1
    8000431e:	bfc1                	j	800042ee <filewrite+0xfa>
      return -1;
    80004320:	5a7d                	li	s4,-1
    80004322:	b7f1                	j	800042ee <filewrite+0xfa>
    80004324:	5a7d                	li	s4,-1
    80004326:	b7e1                	j	800042ee <filewrite+0xfa>

0000000080004328 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80004328:	7179                	addi	sp,sp,-48
    8000432a:	f406                	sd	ra,40(sp)
    8000432c:	f022                	sd	s0,32(sp)
    8000432e:	ec26                	sd	s1,24(sp)
    80004330:	e84a                	sd	s2,16(sp)
    80004332:	e44e                	sd	s3,8(sp)
    80004334:	e052                	sd	s4,0(sp)
    80004336:	1800                	addi	s0,sp,48
    80004338:	84aa                	mv	s1,a0
    8000433a:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    8000433c:	0005b023          	sd	zero,0(a1)
    80004340:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004344:	00000097          	auipc	ra,0x0
    80004348:	bf8080e7          	jalr	-1032(ra) # 80003f3c <filealloc>
    8000434c:	e088                	sd	a0,0(s1)
    8000434e:	c551                	beqz	a0,800043da <pipealloc+0xb2>
    80004350:	00000097          	auipc	ra,0x0
    80004354:	bec080e7          	jalr	-1044(ra) # 80003f3c <filealloc>
    80004358:	00aa3023          	sd	a0,0(s4)
    8000435c:	c92d                	beqz	a0,800043ce <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    8000435e:	ffffc097          	auipc	ra,0xffffc
    80004362:	dba080e7          	jalr	-582(ra) # 80000118 <kalloc>
    80004366:	892a                	mv	s2,a0
    80004368:	c125                	beqz	a0,800043c8 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    8000436a:	4985                	li	s3,1
    8000436c:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004370:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004374:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004378:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    8000437c:	00004597          	auipc	a1,0x4
    80004380:	45c58593          	addi	a1,a1,1116 # 800087d8 <syscalls+0x370>
    80004384:	00002097          	auipc	ra,0x2
    80004388:	556080e7          	jalr	1366(ra) # 800068da <initlock>
  (*f0)->type = FD_PIPE;
    8000438c:	609c                	ld	a5,0(s1)
    8000438e:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004392:	609c                	ld	a5,0(s1)
    80004394:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004398:	609c                	ld	a5,0(s1)
    8000439a:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    8000439e:	609c                	ld	a5,0(s1)
    800043a0:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    800043a4:	000a3783          	ld	a5,0(s4)
    800043a8:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    800043ac:	000a3783          	ld	a5,0(s4)
    800043b0:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    800043b4:	000a3783          	ld	a5,0(s4)
    800043b8:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    800043bc:	000a3783          	ld	a5,0(s4)
    800043c0:	0127b823          	sd	s2,16(a5)
  return 0;
    800043c4:	4501                	li	a0,0
    800043c6:	a025                	j	800043ee <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    800043c8:	6088                	ld	a0,0(s1)
    800043ca:	e501                	bnez	a0,800043d2 <pipealloc+0xaa>
    800043cc:	a039                	j	800043da <pipealloc+0xb2>
    800043ce:	6088                	ld	a0,0(s1)
    800043d0:	c51d                	beqz	a0,800043fe <pipealloc+0xd6>
    fileclose(*f0);
    800043d2:	00000097          	auipc	ra,0x0
    800043d6:	c26080e7          	jalr	-986(ra) # 80003ff8 <fileclose>
  if(*f1)
    800043da:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    800043de:	557d                	li	a0,-1
  if(*f1)
    800043e0:	c799                	beqz	a5,800043ee <pipealloc+0xc6>
    fileclose(*f1);
    800043e2:	853e                	mv	a0,a5
    800043e4:	00000097          	auipc	ra,0x0
    800043e8:	c14080e7          	jalr	-1004(ra) # 80003ff8 <fileclose>
  return -1;
    800043ec:	557d                	li	a0,-1
}
    800043ee:	70a2                	ld	ra,40(sp)
    800043f0:	7402                	ld	s0,32(sp)
    800043f2:	64e2                	ld	s1,24(sp)
    800043f4:	6942                	ld	s2,16(sp)
    800043f6:	69a2                	ld	s3,8(sp)
    800043f8:	6a02                	ld	s4,0(sp)
    800043fa:	6145                	addi	sp,sp,48
    800043fc:	8082                	ret
  return -1;
    800043fe:	557d                	li	a0,-1
    80004400:	b7fd                	j	800043ee <pipealloc+0xc6>

0000000080004402 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004402:	1101                	addi	sp,sp,-32
    80004404:	ec06                	sd	ra,24(sp)
    80004406:	e822                	sd	s0,16(sp)
    80004408:	e426                	sd	s1,8(sp)
    8000440a:	e04a                	sd	s2,0(sp)
    8000440c:	1000                	addi	s0,sp,32
    8000440e:	84aa                	mv	s1,a0
    80004410:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004412:	00002097          	auipc	ra,0x2
    80004416:	558080e7          	jalr	1368(ra) # 8000696a <acquire>
  if(writable){
    8000441a:	02090d63          	beqz	s2,80004454 <pipeclose+0x52>
    pi->writeopen = 0;
    8000441e:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004422:	21848513          	addi	a0,s1,536
    80004426:	ffffd097          	auipc	ra,0xffffd
    8000442a:	6f8080e7          	jalr	1784(ra) # 80001b1e <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    8000442e:	2204b783          	ld	a5,544(s1)
    80004432:	eb95                	bnez	a5,80004466 <pipeclose+0x64>
    release(&pi->lock);
    80004434:	8526                	mv	a0,s1
    80004436:	00002097          	auipc	ra,0x2
    8000443a:	5e8080e7          	jalr	1512(ra) # 80006a1e <release>
    kfree((char*)pi);
    8000443e:	8526                	mv	a0,s1
    80004440:	ffffc097          	auipc	ra,0xffffc
    80004444:	bdc080e7          	jalr	-1060(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80004448:	60e2                	ld	ra,24(sp)
    8000444a:	6442                	ld	s0,16(sp)
    8000444c:	64a2                	ld	s1,8(sp)
    8000444e:	6902                	ld	s2,0(sp)
    80004450:	6105                	addi	sp,sp,32
    80004452:	8082                	ret
    pi->readopen = 0;
    80004454:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004458:	21c48513          	addi	a0,s1,540
    8000445c:	ffffd097          	auipc	ra,0xffffd
    80004460:	6c2080e7          	jalr	1730(ra) # 80001b1e <wakeup>
    80004464:	b7e9                	j	8000442e <pipeclose+0x2c>
    release(&pi->lock);
    80004466:	8526                	mv	a0,s1
    80004468:	00002097          	auipc	ra,0x2
    8000446c:	5b6080e7          	jalr	1462(ra) # 80006a1e <release>
}
    80004470:	bfe1                	j	80004448 <pipeclose+0x46>

0000000080004472 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004472:	7159                	addi	sp,sp,-112
    80004474:	f486                	sd	ra,104(sp)
    80004476:	f0a2                	sd	s0,96(sp)
    80004478:	eca6                	sd	s1,88(sp)
    8000447a:	e8ca                	sd	s2,80(sp)
    8000447c:	e4ce                	sd	s3,72(sp)
    8000447e:	e0d2                	sd	s4,64(sp)
    80004480:	fc56                	sd	s5,56(sp)
    80004482:	f85a                	sd	s6,48(sp)
    80004484:	f45e                	sd	s7,40(sp)
    80004486:	f062                	sd	s8,32(sp)
    80004488:	ec66                	sd	s9,24(sp)
    8000448a:	1880                	addi	s0,sp,112
    8000448c:	84aa                	mv	s1,a0
    8000448e:	8aae                	mv	s5,a1
    80004490:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004492:	ffffd097          	auipc	ra,0xffffd
    80004496:	e44080e7          	jalr	-444(ra) # 800012d6 <myproc>
    8000449a:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    8000449c:	8526                	mv	a0,s1
    8000449e:	00002097          	auipc	ra,0x2
    800044a2:	4cc080e7          	jalr	1228(ra) # 8000696a <acquire>
  while(i < n){
    800044a6:	0d405163          	blez	s4,80004568 <pipewrite+0xf6>
    800044aa:	8ba6                	mv	s7,s1
  int i = 0;
    800044ac:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800044ae:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    800044b0:	21848c93          	addi	s9,s1,536
      sleep(&pi->nwrite, &pi->lock);
    800044b4:	21c48c13          	addi	s8,s1,540
    800044b8:	a08d                	j	8000451a <pipewrite+0xa8>
      release(&pi->lock);
    800044ba:	8526                	mv	a0,s1
    800044bc:	00002097          	auipc	ra,0x2
    800044c0:	562080e7          	jalr	1378(ra) # 80006a1e <release>
      return -1;
    800044c4:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    800044c6:	854a                	mv	a0,s2
    800044c8:	70a6                	ld	ra,104(sp)
    800044ca:	7406                	ld	s0,96(sp)
    800044cc:	64e6                	ld	s1,88(sp)
    800044ce:	6946                	ld	s2,80(sp)
    800044d0:	69a6                	ld	s3,72(sp)
    800044d2:	6a06                	ld	s4,64(sp)
    800044d4:	7ae2                	ld	s5,56(sp)
    800044d6:	7b42                	ld	s6,48(sp)
    800044d8:	7ba2                	ld	s7,40(sp)
    800044da:	7c02                	ld	s8,32(sp)
    800044dc:	6ce2                	ld	s9,24(sp)
    800044de:	6165                	addi	sp,sp,112
    800044e0:	8082                	ret
      wakeup(&pi->nread);
    800044e2:	8566                	mv	a0,s9
    800044e4:	ffffd097          	auipc	ra,0xffffd
    800044e8:	63a080e7          	jalr	1594(ra) # 80001b1e <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    800044ec:	85de                	mv	a1,s7
    800044ee:	8562                	mv	a0,s8
    800044f0:	ffffd097          	auipc	ra,0xffffd
    800044f4:	4a2080e7          	jalr	1186(ra) # 80001992 <sleep>
    800044f8:	a839                	j	80004516 <pipewrite+0xa4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    800044fa:	21c4a783          	lw	a5,540(s1)
    800044fe:	0017871b          	addiw	a4,a5,1
    80004502:	20e4ae23          	sw	a4,540(s1)
    80004506:	1ff7f793          	andi	a5,a5,511
    8000450a:	97a6                	add	a5,a5,s1
    8000450c:	f9f44703          	lbu	a4,-97(s0)
    80004510:	00e78c23          	sb	a4,24(a5)
      i++;
    80004514:	2905                	addiw	s2,s2,1
  while(i < n){
    80004516:	03495d63          	bge	s2,s4,80004550 <pipewrite+0xde>
    if(pi->readopen == 0 || pr->killed){
    8000451a:	2204a783          	lw	a5,544(s1)
    8000451e:	dfd1                	beqz	a5,800044ba <pipewrite+0x48>
    80004520:	0289a783          	lw	a5,40(s3)
    80004524:	fbd9                	bnez	a5,800044ba <pipewrite+0x48>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004526:	2184a783          	lw	a5,536(s1)
    8000452a:	21c4a703          	lw	a4,540(s1)
    8000452e:	2007879b          	addiw	a5,a5,512
    80004532:	faf708e3          	beq	a4,a5,800044e2 <pipewrite+0x70>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004536:	4685                	li	a3,1
    80004538:	01590633          	add	a2,s2,s5
    8000453c:	f9f40593          	addi	a1,s0,-97
    80004540:	0509b503          	ld	a0,80(s3)
    80004544:	ffffc097          	auipc	ra,0xffffc
    80004548:	64a080e7          	jalr	1610(ra) # 80000b8e <copyin>
    8000454c:	fb6517e3          	bne	a0,s6,800044fa <pipewrite+0x88>
  wakeup(&pi->nread);
    80004550:	21848513          	addi	a0,s1,536
    80004554:	ffffd097          	auipc	ra,0xffffd
    80004558:	5ca080e7          	jalr	1482(ra) # 80001b1e <wakeup>
  release(&pi->lock);
    8000455c:	8526                	mv	a0,s1
    8000455e:	00002097          	auipc	ra,0x2
    80004562:	4c0080e7          	jalr	1216(ra) # 80006a1e <release>
  return i;
    80004566:	b785                	j	800044c6 <pipewrite+0x54>
  int i = 0;
    80004568:	4901                	li	s2,0
    8000456a:	b7dd                	j	80004550 <pipewrite+0xde>

000000008000456c <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    8000456c:	715d                	addi	sp,sp,-80
    8000456e:	e486                	sd	ra,72(sp)
    80004570:	e0a2                	sd	s0,64(sp)
    80004572:	fc26                	sd	s1,56(sp)
    80004574:	f84a                	sd	s2,48(sp)
    80004576:	f44e                	sd	s3,40(sp)
    80004578:	f052                	sd	s4,32(sp)
    8000457a:	ec56                	sd	s5,24(sp)
    8000457c:	e85a                	sd	s6,16(sp)
    8000457e:	0880                	addi	s0,sp,80
    80004580:	84aa                	mv	s1,a0
    80004582:	892e                	mv	s2,a1
    80004584:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004586:	ffffd097          	auipc	ra,0xffffd
    8000458a:	d50080e7          	jalr	-688(ra) # 800012d6 <myproc>
    8000458e:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004590:	8b26                	mv	s6,s1
    80004592:	8526                	mv	a0,s1
    80004594:	00002097          	auipc	ra,0x2
    80004598:	3d6080e7          	jalr	982(ra) # 8000696a <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000459c:	2184a703          	lw	a4,536(s1)
    800045a0:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800045a4:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800045a8:	02f71463          	bne	a4,a5,800045d0 <piperead+0x64>
    800045ac:	2244a783          	lw	a5,548(s1)
    800045b0:	c385                	beqz	a5,800045d0 <piperead+0x64>
    if(pr->killed){
    800045b2:	028a2783          	lw	a5,40(s4)
    800045b6:	ebc1                	bnez	a5,80004646 <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800045b8:	85da                	mv	a1,s6
    800045ba:	854e                	mv	a0,s3
    800045bc:	ffffd097          	auipc	ra,0xffffd
    800045c0:	3d6080e7          	jalr	982(ra) # 80001992 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800045c4:	2184a703          	lw	a4,536(s1)
    800045c8:	21c4a783          	lw	a5,540(s1)
    800045cc:	fef700e3          	beq	a4,a5,800045ac <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800045d0:	09505263          	blez	s5,80004654 <piperead+0xe8>
    800045d4:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800045d6:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    800045d8:	2184a783          	lw	a5,536(s1)
    800045dc:	21c4a703          	lw	a4,540(s1)
    800045e0:	02f70d63          	beq	a4,a5,8000461a <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800045e4:	0017871b          	addiw	a4,a5,1
    800045e8:	20e4ac23          	sw	a4,536(s1)
    800045ec:	1ff7f793          	andi	a5,a5,511
    800045f0:	97a6                	add	a5,a5,s1
    800045f2:	0187c783          	lbu	a5,24(a5)
    800045f6:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800045fa:	4685                	li	a3,1
    800045fc:	fbf40613          	addi	a2,s0,-65
    80004600:	85ca                	mv	a1,s2
    80004602:	050a3503          	ld	a0,80(s4)
    80004606:	ffffc097          	auipc	ra,0xffffc
    8000460a:	4fc080e7          	jalr	1276(ra) # 80000b02 <copyout>
    8000460e:	01650663          	beq	a0,s6,8000461a <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004612:	2985                	addiw	s3,s3,1
    80004614:	0905                	addi	s2,s2,1
    80004616:	fd3a91e3          	bne	s5,s3,800045d8 <piperead+0x6c>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    8000461a:	21c48513          	addi	a0,s1,540
    8000461e:	ffffd097          	auipc	ra,0xffffd
    80004622:	500080e7          	jalr	1280(ra) # 80001b1e <wakeup>
  release(&pi->lock);
    80004626:	8526                	mv	a0,s1
    80004628:	00002097          	auipc	ra,0x2
    8000462c:	3f6080e7          	jalr	1014(ra) # 80006a1e <release>
  return i;
}
    80004630:	854e                	mv	a0,s3
    80004632:	60a6                	ld	ra,72(sp)
    80004634:	6406                	ld	s0,64(sp)
    80004636:	74e2                	ld	s1,56(sp)
    80004638:	7942                	ld	s2,48(sp)
    8000463a:	79a2                	ld	s3,40(sp)
    8000463c:	7a02                	ld	s4,32(sp)
    8000463e:	6ae2                	ld	s5,24(sp)
    80004640:	6b42                	ld	s6,16(sp)
    80004642:	6161                	addi	sp,sp,80
    80004644:	8082                	ret
      release(&pi->lock);
    80004646:	8526                	mv	a0,s1
    80004648:	00002097          	auipc	ra,0x2
    8000464c:	3d6080e7          	jalr	982(ra) # 80006a1e <release>
      return -1;
    80004650:	59fd                	li	s3,-1
    80004652:	bff9                	j	80004630 <piperead+0xc4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004654:	4981                	li	s3,0
    80004656:	b7d1                	j	8000461a <piperead+0xae>

0000000080004658 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    80004658:	df010113          	addi	sp,sp,-528
    8000465c:	20113423          	sd	ra,520(sp)
    80004660:	20813023          	sd	s0,512(sp)
    80004664:	ffa6                	sd	s1,504(sp)
    80004666:	fbca                	sd	s2,496(sp)
    80004668:	f7ce                	sd	s3,488(sp)
    8000466a:	f3d2                	sd	s4,480(sp)
    8000466c:	efd6                	sd	s5,472(sp)
    8000466e:	ebda                	sd	s6,464(sp)
    80004670:	e7de                	sd	s7,456(sp)
    80004672:	e3e2                	sd	s8,448(sp)
    80004674:	ff66                	sd	s9,440(sp)
    80004676:	fb6a                	sd	s10,432(sp)
    80004678:	f76e                	sd	s11,424(sp)
    8000467a:	0c00                	addi	s0,sp,528
    8000467c:	84aa                	mv	s1,a0
    8000467e:	dea43c23          	sd	a0,-520(s0)
    80004682:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004686:	ffffd097          	auipc	ra,0xffffd
    8000468a:	c50080e7          	jalr	-944(ra) # 800012d6 <myproc>
    8000468e:	892a                	mv	s2,a0

  begin_op();
    80004690:	fffff097          	auipc	ra,0xfffff
    80004694:	49c080e7          	jalr	1180(ra) # 80003b2c <begin_op>

  if((ip = namei(path)) == 0){
    80004698:	8526                	mv	a0,s1
    8000469a:	fffff097          	auipc	ra,0xfffff
    8000469e:	0e4080e7          	jalr	228(ra) # 8000377e <namei>
    800046a2:	c92d                	beqz	a0,80004714 <exec+0xbc>
    800046a4:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800046a6:	fffff097          	auipc	ra,0xfffff
    800046aa:	92c080e7          	jalr	-1748(ra) # 80002fd2 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800046ae:	04000713          	li	a4,64
    800046b2:	4681                	li	a3,0
    800046b4:	e5040613          	addi	a2,s0,-432
    800046b8:	4581                	li	a1,0
    800046ba:	8526                	mv	a0,s1
    800046bc:	fffff097          	auipc	ra,0xfffff
    800046c0:	bca080e7          	jalr	-1078(ra) # 80003286 <readi>
    800046c4:	04000793          	li	a5,64
    800046c8:	00f51a63          	bne	a0,a5,800046dc <exec+0x84>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    800046cc:	e5042703          	lw	a4,-432(s0)
    800046d0:	464c47b7          	lui	a5,0x464c4
    800046d4:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800046d8:	04f70463          	beq	a4,a5,80004720 <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800046dc:	8526                	mv	a0,s1
    800046de:	fffff097          	auipc	ra,0xfffff
    800046e2:	b56080e7          	jalr	-1194(ra) # 80003234 <iunlockput>
    end_op();
    800046e6:	fffff097          	auipc	ra,0xfffff
    800046ea:	4c6080e7          	jalr	1222(ra) # 80003bac <end_op>
  }
  return -1;
    800046ee:	557d                	li	a0,-1
}
    800046f0:	20813083          	ld	ra,520(sp)
    800046f4:	20013403          	ld	s0,512(sp)
    800046f8:	74fe                	ld	s1,504(sp)
    800046fa:	795e                	ld	s2,496(sp)
    800046fc:	79be                	ld	s3,488(sp)
    800046fe:	7a1e                	ld	s4,480(sp)
    80004700:	6afe                	ld	s5,472(sp)
    80004702:	6b5e                	ld	s6,464(sp)
    80004704:	6bbe                	ld	s7,456(sp)
    80004706:	6c1e                	ld	s8,448(sp)
    80004708:	7cfa                	ld	s9,440(sp)
    8000470a:	7d5a                	ld	s10,432(sp)
    8000470c:	7dba                	ld	s11,424(sp)
    8000470e:	21010113          	addi	sp,sp,528
    80004712:	8082                	ret
    end_op();
    80004714:	fffff097          	auipc	ra,0xfffff
    80004718:	498080e7          	jalr	1176(ra) # 80003bac <end_op>
    return -1;
    8000471c:	557d                	li	a0,-1
    8000471e:	bfc9                	j	800046f0 <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    80004720:	854a                	mv	a0,s2
    80004722:	ffffd097          	auipc	ra,0xffffd
    80004726:	c78080e7          	jalr	-904(ra) # 8000139a <proc_pagetable>
    8000472a:	8baa                	mv	s7,a0
    8000472c:	d945                	beqz	a0,800046dc <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000472e:	e7042983          	lw	s3,-400(s0)
    80004732:	e8845783          	lhu	a5,-376(s0)
    80004736:	c7ad                	beqz	a5,800047a0 <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004738:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000473a:	4b01                	li	s6,0
    if((ph.vaddr % PGSIZE) != 0)
    8000473c:	6c85                	lui	s9,0x1
    8000473e:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004742:	def43823          	sd	a5,-528(s0)
    80004746:	a42d                	j	80004970 <exec+0x318>
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80004748:	00004517          	auipc	a0,0x4
    8000474c:	09850513          	addi	a0,a0,152 # 800087e0 <syscalls+0x378>
    80004750:	00002097          	auipc	ra,0x2
    80004754:	cd0080e7          	jalr	-816(ra) # 80006420 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004758:	8756                	mv	a4,s5
    8000475a:	012d86bb          	addw	a3,s11,s2
    8000475e:	4581                	li	a1,0
    80004760:	8526                	mv	a0,s1
    80004762:	fffff097          	auipc	ra,0xfffff
    80004766:	b24080e7          	jalr	-1244(ra) # 80003286 <readi>
    8000476a:	2501                	sext.w	a0,a0
    8000476c:	1aaa9963          	bne	s5,a0,8000491e <exec+0x2c6>
  for(i = 0; i < sz; i += PGSIZE){
    80004770:	6785                	lui	a5,0x1
    80004772:	0127893b          	addw	s2,a5,s2
    80004776:	77fd                	lui	a5,0xfffff
    80004778:	01478a3b          	addw	s4,a5,s4
    8000477c:	1f897163          	bgeu	s2,s8,8000495e <exec+0x306>
    pa = walkaddr(pagetable, va + i);
    80004780:	02091593          	slli	a1,s2,0x20
    80004784:	9181                	srli	a1,a1,0x20
    80004786:	95ea                	add	a1,a1,s10
    80004788:	855e                	mv	a0,s7
    8000478a:	ffffc097          	auipc	ra,0xffffc
    8000478e:	d7c080e7          	jalr	-644(ra) # 80000506 <walkaddr>
    80004792:	862a                	mv	a2,a0
    if(pa == 0)
    80004794:	d955                	beqz	a0,80004748 <exec+0xf0>
      n = PGSIZE;
    80004796:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    80004798:	fd9a70e3          	bgeu	s4,s9,80004758 <exec+0x100>
      n = sz - i;
    8000479c:	8ad2                	mv	s5,s4
    8000479e:	bf6d                	j	80004758 <exec+0x100>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800047a0:	4901                	li	s2,0
  iunlockput(ip);
    800047a2:	8526                	mv	a0,s1
    800047a4:	fffff097          	auipc	ra,0xfffff
    800047a8:	a90080e7          	jalr	-1392(ra) # 80003234 <iunlockput>
  end_op();
    800047ac:	fffff097          	auipc	ra,0xfffff
    800047b0:	400080e7          	jalr	1024(ra) # 80003bac <end_op>
  p = myproc();
    800047b4:	ffffd097          	auipc	ra,0xffffd
    800047b8:	b22080e7          	jalr	-1246(ra) # 800012d6 <myproc>
    800047bc:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    800047be:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    800047c2:	6785                	lui	a5,0x1
    800047c4:	17fd                	addi	a5,a5,-1
    800047c6:	993e                	add	s2,s2,a5
    800047c8:	757d                	lui	a0,0xfffff
    800047ca:	00a977b3          	and	a5,s2,a0
    800047ce:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    800047d2:	6609                	lui	a2,0x2
    800047d4:	963e                	add	a2,a2,a5
    800047d6:	85be                	mv	a1,a5
    800047d8:	855e                	mv	a0,s7
    800047da:	ffffc097          	auipc	ra,0xffffc
    800047de:	0d8080e7          	jalr	216(ra) # 800008b2 <uvmalloc>
    800047e2:	8b2a                	mv	s6,a0
  ip = 0;
    800047e4:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    800047e6:	12050c63          	beqz	a0,8000491e <exec+0x2c6>
  uvmclear(pagetable, sz-2*PGSIZE);
    800047ea:	75f9                	lui	a1,0xffffe
    800047ec:	95aa                	add	a1,a1,a0
    800047ee:	855e                	mv	a0,s7
    800047f0:	ffffc097          	auipc	ra,0xffffc
    800047f4:	2e0080e7          	jalr	736(ra) # 80000ad0 <uvmclear>
  stackbase = sp - PGSIZE;
    800047f8:	7c7d                	lui	s8,0xfffff
    800047fa:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    800047fc:	e0043783          	ld	a5,-512(s0)
    80004800:	6388                	ld	a0,0(a5)
    80004802:	c535                	beqz	a0,8000486e <exec+0x216>
    80004804:	e9040993          	addi	s3,s0,-368
    80004808:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    8000480c:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    8000480e:	ffffc097          	auipc	ra,0xffffc
    80004812:	aee080e7          	jalr	-1298(ra) # 800002fc <strlen>
    80004816:	2505                	addiw	a0,a0,1
    80004818:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    8000481c:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    80004820:	13896363          	bltu	s2,s8,80004946 <exec+0x2ee>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004824:	e0043d83          	ld	s11,-512(s0)
    80004828:	000dba03          	ld	s4,0(s11)
    8000482c:	8552                	mv	a0,s4
    8000482e:	ffffc097          	auipc	ra,0xffffc
    80004832:	ace080e7          	jalr	-1330(ra) # 800002fc <strlen>
    80004836:	0015069b          	addiw	a3,a0,1
    8000483a:	8652                	mv	a2,s4
    8000483c:	85ca                	mv	a1,s2
    8000483e:	855e                	mv	a0,s7
    80004840:	ffffc097          	auipc	ra,0xffffc
    80004844:	2c2080e7          	jalr	706(ra) # 80000b02 <copyout>
    80004848:	10054363          	bltz	a0,8000494e <exec+0x2f6>
    ustack[argc] = sp;
    8000484c:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004850:	0485                	addi	s1,s1,1
    80004852:	008d8793          	addi	a5,s11,8
    80004856:	e0f43023          	sd	a5,-512(s0)
    8000485a:	008db503          	ld	a0,8(s11)
    8000485e:	c911                	beqz	a0,80004872 <exec+0x21a>
    if(argc >= MAXARG)
    80004860:	09a1                	addi	s3,s3,8
    80004862:	fb3c96e3          	bne	s9,s3,8000480e <exec+0x1b6>
  sz = sz1;
    80004866:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000486a:	4481                	li	s1,0
    8000486c:	a84d                	j	8000491e <exec+0x2c6>
  sp = sz;
    8000486e:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    80004870:	4481                	li	s1,0
  ustack[argc] = 0;
    80004872:	00349793          	slli	a5,s1,0x3
    80004876:	f9040713          	addi	a4,s0,-112
    8000487a:	97ba                	add	a5,a5,a4
    8000487c:	f007b023          	sd	zero,-256(a5) # f00 <_entry-0x7ffff100>
  sp -= (argc+1) * sizeof(uint64);
    80004880:	00148693          	addi	a3,s1,1
    80004884:	068e                	slli	a3,a3,0x3
    80004886:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    8000488a:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    8000488e:	01897663          	bgeu	s2,s8,8000489a <exec+0x242>
  sz = sz1;
    80004892:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004896:	4481                	li	s1,0
    80004898:	a059                	j	8000491e <exec+0x2c6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    8000489a:	e9040613          	addi	a2,s0,-368
    8000489e:	85ca                	mv	a1,s2
    800048a0:	855e                	mv	a0,s7
    800048a2:	ffffc097          	auipc	ra,0xffffc
    800048a6:	260080e7          	jalr	608(ra) # 80000b02 <copyout>
    800048aa:	0a054663          	bltz	a0,80004956 <exec+0x2fe>
  p->trapframe->a1 = sp;
    800048ae:	058ab783          	ld	a5,88(s5)
    800048b2:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800048b6:	df843783          	ld	a5,-520(s0)
    800048ba:	0007c703          	lbu	a4,0(a5)
    800048be:	cf11                	beqz	a4,800048da <exec+0x282>
    800048c0:	0785                	addi	a5,a5,1
    if(*s == '/')
    800048c2:	02f00693          	li	a3,47
    800048c6:	a039                	j	800048d4 <exec+0x27c>
      last = s+1;
    800048c8:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    800048cc:	0785                	addi	a5,a5,1
    800048ce:	fff7c703          	lbu	a4,-1(a5)
    800048d2:	c701                	beqz	a4,800048da <exec+0x282>
    if(*s == '/')
    800048d4:	fed71ce3          	bne	a4,a3,800048cc <exec+0x274>
    800048d8:	bfc5                	j	800048c8 <exec+0x270>
  safestrcpy(p->name, last, sizeof(p->name));
    800048da:	4641                	li	a2,16
    800048dc:	df843583          	ld	a1,-520(s0)
    800048e0:	158a8513          	addi	a0,s5,344
    800048e4:	ffffc097          	auipc	ra,0xffffc
    800048e8:	9e6080e7          	jalr	-1562(ra) # 800002ca <safestrcpy>
  oldpagetable = p->pagetable;
    800048ec:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    800048f0:	057ab823          	sd	s7,80(s5)
  p->sz = sz;
    800048f4:	056ab423          	sd	s6,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800048f8:	058ab783          	ld	a5,88(s5)
    800048fc:	e6843703          	ld	a4,-408(s0)
    80004900:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004902:	058ab783          	ld	a5,88(s5)
    80004906:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    8000490a:	85ea                	mv	a1,s10
    8000490c:	ffffd097          	auipc	ra,0xffffd
    80004910:	b2a080e7          	jalr	-1238(ra) # 80001436 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004914:	0004851b          	sext.w	a0,s1
    80004918:	bbe1                	j	800046f0 <exec+0x98>
    8000491a:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    8000491e:	e0843583          	ld	a1,-504(s0)
    80004922:	855e                	mv	a0,s7
    80004924:	ffffd097          	auipc	ra,0xffffd
    80004928:	b12080e7          	jalr	-1262(ra) # 80001436 <proc_freepagetable>
  if(ip){
    8000492c:	da0498e3          	bnez	s1,800046dc <exec+0x84>
  return -1;
    80004930:	557d                	li	a0,-1
    80004932:	bb7d                	j	800046f0 <exec+0x98>
    80004934:	e1243423          	sd	s2,-504(s0)
    80004938:	b7dd                	j	8000491e <exec+0x2c6>
    8000493a:	e1243423          	sd	s2,-504(s0)
    8000493e:	b7c5                	j	8000491e <exec+0x2c6>
    80004940:	e1243423          	sd	s2,-504(s0)
    80004944:	bfe9                	j	8000491e <exec+0x2c6>
  sz = sz1;
    80004946:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000494a:	4481                	li	s1,0
    8000494c:	bfc9                	j	8000491e <exec+0x2c6>
  sz = sz1;
    8000494e:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004952:	4481                	li	s1,0
    80004954:	b7e9                	j	8000491e <exec+0x2c6>
  sz = sz1;
    80004956:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000495a:	4481                	li	s1,0
    8000495c:	b7c9                	j	8000491e <exec+0x2c6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    8000495e:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004962:	2b05                	addiw	s6,s6,1
    80004964:	0389899b          	addiw	s3,s3,56
    80004968:	e8845783          	lhu	a5,-376(s0)
    8000496c:	e2fb5be3          	bge	s6,a5,800047a2 <exec+0x14a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004970:	2981                	sext.w	s3,s3
    80004972:	03800713          	li	a4,56
    80004976:	86ce                	mv	a3,s3
    80004978:	e1840613          	addi	a2,s0,-488
    8000497c:	4581                	li	a1,0
    8000497e:	8526                	mv	a0,s1
    80004980:	fffff097          	auipc	ra,0xfffff
    80004984:	906080e7          	jalr	-1786(ra) # 80003286 <readi>
    80004988:	03800793          	li	a5,56
    8000498c:	f8f517e3          	bne	a0,a5,8000491a <exec+0x2c2>
    if(ph.type != ELF_PROG_LOAD)
    80004990:	e1842783          	lw	a5,-488(s0)
    80004994:	4705                	li	a4,1
    80004996:	fce796e3          	bne	a5,a4,80004962 <exec+0x30a>
    if(ph.memsz < ph.filesz)
    8000499a:	e4043603          	ld	a2,-448(s0)
    8000499e:	e3843783          	ld	a5,-456(s0)
    800049a2:	f8f669e3          	bltu	a2,a5,80004934 <exec+0x2dc>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800049a6:	e2843783          	ld	a5,-472(s0)
    800049aa:	963e                	add	a2,a2,a5
    800049ac:	f8f667e3          	bltu	a2,a5,8000493a <exec+0x2e2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800049b0:	85ca                	mv	a1,s2
    800049b2:	855e                	mv	a0,s7
    800049b4:	ffffc097          	auipc	ra,0xffffc
    800049b8:	efe080e7          	jalr	-258(ra) # 800008b2 <uvmalloc>
    800049bc:	e0a43423          	sd	a0,-504(s0)
    800049c0:	d141                	beqz	a0,80004940 <exec+0x2e8>
    if((ph.vaddr % PGSIZE) != 0)
    800049c2:	e2843d03          	ld	s10,-472(s0)
    800049c6:	df043783          	ld	a5,-528(s0)
    800049ca:	00fd77b3          	and	a5,s10,a5
    800049ce:	fba1                	bnez	a5,8000491e <exec+0x2c6>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800049d0:	e2042d83          	lw	s11,-480(s0)
    800049d4:	e3842c03          	lw	s8,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800049d8:	f80c03e3          	beqz	s8,8000495e <exec+0x306>
    800049dc:	8a62                	mv	s4,s8
    800049de:	4901                	li	s2,0
    800049e0:	b345                	j	80004780 <exec+0x128>

00000000800049e2 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800049e2:	7179                	addi	sp,sp,-48
    800049e4:	f406                	sd	ra,40(sp)
    800049e6:	f022                	sd	s0,32(sp)
    800049e8:	ec26                	sd	s1,24(sp)
    800049ea:	e84a                	sd	s2,16(sp)
    800049ec:	1800                	addi	s0,sp,48
    800049ee:	892e                	mv	s2,a1
    800049f0:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    800049f2:	fdc40593          	addi	a1,s0,-36
    800049f6:	ffffe097          	auipc	ra,0xffffe
    800049fa:	9a0080e7          	jalr	-1632(ra) # 80002396 <argint>
    800049fe:	04054063          	bltz	a0,80004a3e <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004a02:	fdc42703          	lw	a4,-36(s0)
    80004a06:	47bd                	li	a5,15
    80004a08:	02e7ed63          	bltu	a5,a4,80004a42 <argfd+0x60>
    80004a0c:	ffffd097          	auipc	ra,0xffffd
    80004a10:	8ca080e7          	jalr	-1846(ra) # 800012d6 <myproc>
    80004a14:	fdc42703          	lw	a4,-36(s0)
    80004a18:	01a70793          	addi	a5,a4,26
    80004a1c:	078e                	slli	a5,a5,0x3
    80004a1e:	953e                	add	a0,a0,a5
    80004a20:	611c                	ld	a5,0(a0)
    80004a22:	c395                	beqz	a5,80004a46 <argfd+0x64>
    return -1;
  if(pfd)
    80004a24:	00090463          	beqz	s2,80004a2c <argfd+0x4a>
    *pfd = fd;
    80004a28:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004a2c:	4501                	li	a0,0
  if(pf)
    80004a2e:	c091                	beqz	s1,80004a32 <argfd+0x50>
    *pf = f;
    80004a30:	e09c                	sd	a5,0(s1)
}
    80004a32:	70a2                	ld	ra,40(sp)
    80004a34:	7402                	ld	s0,32(sp)
    80004a36:	64e2                	ld	s1,24(sp)
    80004a38:	6942                	ld	s2,16(sp)
    80004a3a:	6145                	addi	sp,sp,48
    80004a3c:	8082                	ret
    return -1;
    80004a3e:	557d                	li	a0,-1
    80004a40:	bfcd                	j	80004a32 <argfd+0x50>
    return -1;
    80004a42:	557d                	li	a0,-1
    80004a44:	b7fd                	j	80004a32 <argfd+0x50>
    80004a46:	557d                	li	a0,-1
    80004a48:	b7ed                	j	80004a32 <argfd+0x50>

0000000080004a4a <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004a4a:	1101                	addi	sp,sp,-32
    80004a4c:	ec06                	sd	ra,24(sp)
    80004a4e:	e822                	sd	s0,16(sp)
    80004a50:	e426                	sd	s1,8(sp)
    80004a52:	1000                	addi	s0,sp,32
    80004a54:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004a56:	ffffd097          	auipc	ra,0xffffd
    80004a5a:	880080e7          	jalr	-1920(ra) # 800012d6 <myproc>
    80004a5e:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004a60:	0d050793          	addi	a5,a0,208 # fffffffffffff0d0 <end+0xffffffff7ffd8e90>
    80004a64:	4501                	li	a0,0
    80004a66:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004a68:	6398                	ld	a4,0(a5)
    80004a6a:	cb19                	beqz	a4,80004a80 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004a6c:	2505                	addiw	a0,a0,1
    80004a6e:	07a1                	addi	a5,a5,8
    80004a70:	fed51ce3          	bne	a0,a3,80004a68 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004a74:	557d                	li	a0,-1
}
    80004a76:	60e2                	ld	ra,24(sp)
    80004a78:	6442                	ld	s0,16(sp)
    80004a7a:	64a2                	ld	s1,8(sp)
    80004a7c:	6105                	addi	sp,sp,32
    80004a7e:	8082                	ret
      p->ofile[fd] = f;
    80004a80:	01a50793          	addi	a5,a0,26
    80004a84:	078e                	slli	a5,a5,0x3
    80004a86:	963e                	add	a2,a2,a5
    80004a88:	e204                	sd	s1,0(a2)
      return fd;
    80004a8a:	b7f5                	j	80004a76 <fdalloc+0x2c>

0000000080004a8c <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004a8c:	715d                	addi	sp,sp,-80
    80004a8e:	e486                	sd	ra,72(sp)
    80004a90:	e0a2                	sd	s0,64(sp)
    80004a92:	fc26                	sd	s1,56(sp)
    80004a94:	f84a                	sd	s2,48(sp)
    80004a96:	f44e                	sd	s3,40(sp)
    80004a98:	f052                	sd	s4,32(sp)
    80004a9a:	ec56                	sd	s5,24(sp)
    80004a9c:	0880                	addi	s0,sp,80
    80004a9e:	89ae                	mv	s3,a1
    80004aa0:	8ab2                	mv	s5,a2
    80004aa2:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004aa4:	fb040593          	addi	a1,s0,-80
    80004aa8:	fffff097          	auipc	ra,0xfffff
    80004aac:	cf4080e7          	jalr	-780(ra) # 8000379c <nameiparent>
    80004ab0:	892a                	mv	s2,a0
    80004ab2:	12050f63          	beqz	a0,80004bf0 <create+0x164>
    return 0;

  ilock(dp);
    80004ab6:	ffffe097          	auipc	ra,0xffffe
    80004aba:	51c080e7          	jalr	1308(ra) # 80002fd2 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004abe:	4601                	li	a2,0
    80004ac0:	fb040593          	addi	a1,s0,-80
    80004ac4:	854a                	mv	a0,s2
    80004ac6:	fffff097          	auipc	ra,0xfffff
    80004aca:	9e6080e7          	jalr	-1562(ra) # 800034ac <dirlookup>
    80004ace:	84aa                	mv	s1,a0
    80004ad0:	c921                	beqz	a0,80004b20 <create+0x94>
    iunlockput(dp);
    80004ad2:	854a                	mv	a0,s2
    80004ad4:	ffffe097          	auipc	ra,0xffffe
    80004ad8:	760080e7          	jalr	1888(ra) # 80003234 <iunlockput>
    ilock(ip);
    80004adc:	8526                	mv	a0,s1
    80004ade:	ffffe097          	auipc	ra,0xffffe
    80004ae2:	4f4080e7          	jalr	1268(ra) # 80002fd2 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004ae6:	2981                	sext.w	s3,s3
    80004ae8:	4789                	li	a5,2
    80004aea:	02f99463          	bne	s3,a5,80004b12 <create+0x86>
    80004aee:	0444d783          	lhu	a5,68(s1)
    80004af2:	37f9                	addiw	a5,a5,-2
    80004af4:	17c2                	slli	a5,a5,0x30
    80004af6:	93c1                	srli	a5,a5,0x30
    80004af8:	4705                	li	a4,1
    80004afa:	00f76c63          	bltu	a4,a5,80004b12 <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    80004afe:	8526                	mv	a0,s1
    80004b00:	60a6                	ld	ra,72(sp)
    80004b02:	6406                	ld	s0,64(sp)
    80004b04:	74e2                	ld	s1,56(sp)
    80004b06:	7942                	ld	s2,48(sp)
    80004b08:	79a2                	ld	s3,40(sp)
    80004b0a:	7a02                	ld	s4,32(sp)
    80004b0c:	6ae2                	ld	s5,24(sp)
    80004b0e:	6161                	addi	sp,sp,80
    80004b10:	8082                	ret
    iunlockput(ip);
    80004b12:	8526                	mv	a0,s1
    80004b14:	ffffe097          	auipc	ra,0xffffe
    80004b18:	720080e7          	jalr	1824(ra) # 80003234 <iunlockput>
    return 0;
    80004b1c:	4481                	li	s1,0
    80004b1e:	b7c5                	j	80004afe <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    80004b20:	85ce                	mv	a1,s3
    80004b22:	00092503          	lw	a0,0(s2)
    80004b26:	ffffe097          	auipc	ra,0xffffe
    80004b2a:	326080e7          	jalr	806(ra) # 80002e4c <ialloc>
    80004b2e:	84aa                	mv	s1,a0
    80004b30:	c529                	beqz	a0,80004b7a <create+0xee>
  ilock(ip);
    80004b32:	ffffe097          	auipc	ra,0xffffe
    80004b36:	4a0080e7          	jalr	1184(ra) # 80002fd2 <ilock>
  ip->major = major;
    80004b3a:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    80004b3e:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    80004b42:	4785                	li	a5,1
    80004b44:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004b48:	8526                	mv	a0,s1
    80004b4a:	ffffe097          	auipc	ra,0xffffe
    80004b4e:	3c6080e7          	jalr	966(ra) # 80002f10 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004b52:	2981                	sext.w	s3,s3
    80004b54:	4785                	li	a5,1
    80004b56:	02f98a63          	beq	s3,a5,80004b8a <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    80004b5a:	40d0                	lw	a2,4(s1)
    80004b5c:	fb040593          	addi	a1,s0,-80
    80004b60:	854a                	mv	a0,s2
    80004b62:	fffff097          	auipc	ra,0xfffff
    80004b66:	b5a080e7          	jalr	-1190(ra) # 800036bc <dirlink>
    80004b6a:	06054b63          	bltz	a0,80004be0 <create+0x154>
  iunlockput(dp);
    80004b6e:	854a                	mv	a0,s2
    80004b70:	ffffe097          	auipc	ra,0xffffe
    80004b74:	6c4080e7          	jalr	1732(ra) # 80003234 <iunlockput>
  return ip;
    80004b78:	b759                	j	80004afe <create+0x72>
    panic("create: ialloc");
    80004b7a:	00004517          	auipc	a0,0x4
    80004b7e:	c8650513          	addi	a0,a0,-890 # 80008800 <syscalls+0x398>
    80004b82:	00002097          	auipc	ra,0x2
    80004b86:	89e080e7          	jalr	-1890(ra) # 80006420 <panic>
    dp->nlink++;  // for ".."
    80004b8a:	04a95783          	lhu	a5,74(s2)
    80004b8e:	2785                	addiw	a5,a5,1
    80004b90:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    80004b94:	854a                	mv	a0,s2
    80004b96:	ffffe097          	auipc	ra,0xffffe
    80004b9a:	37a080e7          	jalr	890(ra) # 80002f10 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004b9e:	40d0                	lw	a2,4(s1)
    80004ba0:	00004597          	auipc	a1,0x4
    80004ba4:	c7058593          	addi	a1,a1,-912 # 80008810 <syscalls+0x3a8>
    80004ba8:	8526                	mv	a0,s1
    80004baa:	fffff097          	auipc	ra,0xfffff
    80004bae:	b12080e7          	jalr	-1262(ra) # 800036bc <dirlink>
    80004bb2:	00054f63          	bltz	a0,80004bd0 <create+0x144>
    80004bb6:	00492603          	lw	a2,4(s2)
    80004bba:	00004597          	auipc	a1,0x4
    80004bbe:	c5e58593          	addi	a1,a1,-930 # 80008818 <syscalls+0x3b0>
    80004bc2:	8526                	mv	a0,s1
    80004bc4:	fffff097          	auipc	ra,0xfffff
    80004bc8:	af8080e7          	jalr	-1288(ra) # 800036bc <dirlink>
    80004bcc:	f80557e3          	bgez	a0,80004b5a <create+0xce>
      panic("create dots");
    80004bd0:	00004517          	auipc	a0,0x4
    80004bd4:	c5050513          	addi	a0,a0,-944 # 80008820 <syscalls+0x3b8>
    80004bd8:	00002097          	auipc	ra,0x2
    80004bdc:	848080e7          	jalr	-1976(ra) # 80006420 <panic>
    panic("create: dirlink");
    80004be0:	00004517          	auipc	a0,0x4
    80004be4:	c5050513          	addi	a0,a0,-944 # 80008830 <syscalls+0x3c8>
    80004be8:	00002097          	auipc	ra,0x2
    80004bec:	838080e7          	jalr	-1992(ra) # 80006420 <panic>
    return 0;
    80004bf0:	84aa                	mv	s1,a0
    80004bf2:	b731                	j	80004afe <create+0x72>

0000000080004bf4 <sys_dup>:
{
    80004bf4:	7179                	addi	sp,sp,-48
    80004bf6:	f406                	sd	ra,40(sp)
    80004bf8:	f022                	sd	s0,32(sp)
    80004bfa:	ec26                	sd	s1,24(sp)
    80004bfc:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004bfe:	fd840613          	addi	a2,s0,-40
    80004c02:	4581                	li	a1,0
    80004c04:	4501                	li	a0,0
    80004c06:	00000097          	auipc	ra,0x0
    80004c0a:	ddc080e7          	jalr	-548(ra) # 800049e2 <argfd>
    return -1;
    80004c0e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004c10:	02054363          	bltz	a0,80004c36 <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    80004c14:	fd843503          	ld	a0,-40(s0)
    80004c18:	00000097          	auipc	ra,0x0
    80004c1c:	e32080e7          	jalr	-462(ra) # 80004a4a <fdalloc>
    80004c20:	84aa                	mv	s1,a0
    return -1;
    80004c22:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004c24:	00054963          	bltz	a0,80004c36 <sys_dup+0x42>
  filedup(f);
    80004c28:	fd843503          	ld	a0,-40(s0)
    80004c2c:	fffff097          	auipc	ra,0xfffff
    80004c30:	37a080e7          	jalr	890(ra) # 80003fa6 <filedup>
  return fd;
    80004c34:	87a6                	mv	a5,s1
}
    80004c36:	853e                	mv	a0,a5
    80004c38:	70a2                	ld	ra,40(sp)
    80004c3a:	7402                	ld	s0,32(sp)
    80004c3c:	64e2                	ld	s1,24(sp)
    80004c3e:	6145                	addi	sp,sp,48
    80004c40:	8082                	ret

0000000080004c42 <sys_read>:
{
    80004c42:	7179                	addi	sp,sp,-48
    80004c44:	f406                	sd	ra,40(sp)
    80004c46:	f022                	sd	s0,32(sp)
    80004c48:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004c4a:	fe840613          	addi	a2,s0,-24
    80004c4e:	4581                	li	a1,0
    80004c50:	4501                	li	a0,0
    80004c52:	00000097          	auipc	ra,0x0
    80004c56:	d90080e7          	jalr	-624(ra) # 800049e2 <argfd>
    return -1;
    80004c5a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004c5c:	04054163          	bltz	a0,80004c9e <sys_read+0x5c>
    80004c60:	fe440593          	addi	a1,s0,-28
    80004c64:	4509                	li	a0,2
    80004c66:	ffffd097          	auipc	ra,0xffffd
    80004c6a:	730080e7          	jalr	1840(ra) # 80002396 <argint>
    return -1;
    80004c6e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004c70:	02054763          	bltz	a0,80004c9e <sys_read+0x5c>
    80004c74:	fd840593          	addi	a1,s0,-40
    80004c78:	4505                	li	a0,1
    80004c7a:	ffffd097          	auipc	ra,0xffffd
    80004c7e:	73e080e7          	jalr	1854(ra) # 800023b8 <argaddr>
    return -1;
    80004c82:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004c84:	00054d63          	bltz	a0,80004c9e <sys_read+0x5c>
  return fileread(f, p, n);
    80004c88:	fe442603          	lw	a2,-28(s0)
    80004c8c:	fd843583          	ld	a1,-40(s0)
    80004c90:	fe843503          	ld	a0,-24(s0)
    80004c94:	fffff097          	auipc	ra,0xfffff
    80004c98:	49e080e7          	jalr	1182(ra) # 80004132 <fileread>
    80004c9c:	87aa                	mv	a5,a0
}
    80004c9e:	853e                	mv	a0,a5
    80004ca0:	70a2                	ld	ra,40(sp)
    80004ca2:	7402                	ld	s0,32(sp)
    80004ca4:	6145                	addi	sp,sp,48
    80004ca6:	8082                	ret

0000000080004ca8 <sys_write>:
{
    80004ca8:	7179                	addi	sp,sp,-48
    80004caa:	f406                	sd	ra,40(sp)
    80004cac:	f022                	sd	s0,32(sp)
    80004cae:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004cb0:	fe840613          	addi	a2,s0,-24
    80004cb4:	4581                	li	a1,0
    80004cb6:	4501                	li	a0,0
    80004cb8:	00000097          	auipc	ra,0x0
    80004cbc:	d2a080e7          	jalr	-726(ra) # 800049e2 <argfd>
    return -1;
    80004cc0:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004cc2:	04054163          	bltz	a0,80004d04 <sys_write+0x5c>
    80004cc6:	fe440593          	addi	a1,s0,-28
    80004cca:	4509                	li	a0,2
    80004ccc:	ffffd097          	auipc	ra,0xffffd
    80004cd0:	6ca080e7          	jalr	1738(ra) # 80002396 <argint>
    return -1;
    80004cd4:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004cd6:	02054763          	bltz	a0,80004d04 <sys_write+0x5c>
    80004cda:	fd840593          	addi	a1,s0,-40
    80004cde:	4505                	li	a0,1
    80004ce0:	ffffd097          	auipc	ra,0xffffd
    80004ce4:	6d8080e7          	jalr	1752(ra) # 800023b8 <argaddr>
    return -1;
    80004ce8:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004cea:	00054d63          	bltz	a0,80004d04 <sys_write+0x5c>
  return filewrite(f, p, n);
    80004cee:	fe442603          	lw	a2,-28(s0)
    80004cf2:	fd843583          	ld	a1,-40(s0)
    80004cf6:	fe843503          	ld	a0,-24(s0)
    80004cfa:	fffff097          	auipc	ra,0xfffff
    80004cfe:	4fa080e7          	jalr	1274(ra) # 800041f4 <filewrite>
    80004d02:	87aa                	mv	a5,a0
}
    80004d04:	853e                	mv	a0,a5
    80004d06:	70a2                	ld	ra,40(sp)
    80004d08:	7402                	ld	s0,32(sp)
    80004d0a:	6145                	addi	sp,sp,48
    80004d0c:	8082                	ret

0000000080004d0e <sys_close>:
{
    80004d0e:	1101                	addi	sp,sp,-32
    80004d10:	ec06                	sd	ra,24(sp)
    80004d12:	e822                	sd	s0,16(sp)
    80004d14:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004d16:	fe040613          	addi	a2,s0,-32
    80004d1a:	fec40593          	addi	a1,s0,-20
    80004d1e:	4501                	li	a0,0
    80004d20:	00000097          	auipc	ra,0x0
    80004d24:	cc2080e7          	jalr	-830(ra) # 800049e2 <argfd>
    return -1;
    80004d28:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004d2a:	02054463          	bltz	a0,80004d52 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80004d2e:	ffffc097          	auipc	ra,0xffffc
    80004d32:	5a8080e7          	jalr	1448(ra) # 800012d6 <myproc>
    80004d36:	fec42783          	lw	a5,-20(s0)
    80004d3a:	07e9                	addi	a5,a5,26
    80004d3c:	078e                	slli	a5,a5,0x3
    80004d3e:	97aa                	add	a5,a5,a0
    80004d40:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    80004d44:	fe043503          	ld	a0,-32(s0)
    80004d48:	fffff097          	auipc	ra,0xfffff
    80004d4c:	2b0080e7          	jalr	688(ra) # 80003ff8 <fileclose>
  return 0;
    80004d50:	4781                	li	a5,0
}
    80004d52:	853e                	mv	a0,a5
    80004d54:	60e2                	ld	ra,24(sp)
    80004d56:	6442                	ld	s0,16(sp)
    80004d58:	6105                	addi	sp,sp,32
    80004d5a:	8082                	ret

0000000080004d5c <sys_fstat>:
{
    80004d5c:	1101                	addi	sp,sp,-32
    80004d5e:	ec06                	sd	ra,24(sp)
    80004d60:	e822                	sd	s0,16(sp)
    80004d62:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004d64:	fe840613          	addi	a2,s0,-24
    80004d68:	4581                	li	a1,0
    80004d6a:	4501                	li	a0,0
    80004d6c:	00000097          	auipc	ra,0x0
    80004d70:	c76080e7          	jalr	-906(ra) # 800049e2 <argfd>
    return -1;
    80004d74:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004d76:	02054563          	bltz	a0,80004da0 <sys_fstat+0x44>
    80004d7a:	fe040593          	addi	a1,s0,-32
    80004d7e:	4505                	li	a0,1
    80004d80:	ffffd097          	auipc	ra,0xffffd
    80004d84:	638080e7          	jalr	1592(ra) # 800023b8 <argaddr>
    return -1;
    80004d88:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004d8a:	00054b63          	bltz	a0,80004da0 <sys_fstat+0x44>
  return filestat(f, st);
    80004d8e:	fe043583          	ld	a1,-32(s0)
    80004d92:	fe843503          	ld	a0,-24(s0)
    80004d96:	fffff097          	auipc	ra,0xfffff
    80004d9a:	32a080e7          	jalr	810(ra) # 800040c0 <filestat>
    80004d9e:	87aa                	mv	a5,a0
}
    80004da0:	853e                	mv	a0,a5
    80004da2:	60e2                	ld	ra,24(sp)
    80004da4:	6442                	ld	s0,16(sp)
    80004da6:	6105                	addi	sp,sp,32
    80004da8:	8082                	ret

0000000080004daa <sys_link>:
{
    80004daa:	7169                	addi	sp,sp,-304
    80004dac:	f606                	sd	ra,296(sp)
    80004dae:	f222                	sd	s0,288(sp)
    80004db0:	ee26                	sd	s1,280(sp)
    80004db2:	ea4a                	sd	s2,272(sp)
    80004db4:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004db6:	08000613          	li	a2,128
    80004dba:	ed040593          	addi	a1,s0,-304
    80004dbe:	4501                	li	a0,0
    80004dc0:	ffffd097          	auipc	ra,0xffffd
    80004dc4:	61a080e7          	jalr	1562(ra) # 800023da <argstr>
    return -1;
    80004dc8:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004dca:	10054e63          	bltz	a0,80004ee6 <sys_link+0x13c>
    80004dce:	08000613          	li	a2,128
    80004dd2:	f5040593          	addi	a1,s0,-176
    80004dd6:	4505                	li	a0,1
    80004dd8:	ffffd097          	auipc	ra,0xffffd
    80004ddc:	602080e7          	jalr	1538(ra) # 800023da <argstr>
    return -1;
    80004de0:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004de2:	10054263          	bltz	a0,80004ee6 <sys_link+0x13c>
  begin_op();
    80004de6:	fffff097          	auipc	ra,0xfffff
    80004dea:	d46080e7          	jalr	-698(ra) # 80003b2c <begin_op>
  if((ip = namei(old)) == 0){
    80004dee:	ed040513          	addi	a0,s0,-304
    80004df2:	fffff097          	auipc	ra,0xfffff
    80004df6:	98c080e7          	jalr	-1652(ra) # 8000377e <namei>
    80004dfa:	84aa                	mv	s1,a0
    80004dfc:	c551                	beqz	a0,80004e88 <sys_link+0xde>
  ilock(ip);
    80004dfe:	ffffe097          	auipc	ra,0xffffe
    80004e02:	1d4080e7          	jalr	468(ra) # 80002fd2 <ilock>
  if(ip->type == T_DIR){
    80004e06:	04449703          	lh	a4,68(s1)
    80004e0a:	4785                	li	a5,1
    80004e0c:	08f70463          	beq	a4,a5,80004e94 <sys_link+0xea>
  ip->nlink++;
    80004e10:	04a4d783          	lhu	a5,74(s1)
    80004e14:	2785                	addiw	a5,a5,1
    80004e16:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004e1a:	8526                	mv	a0,s1
    80004e1c:	ffffe097          	auipc	ra,0xffffe
    80004e20:	0f4080e7          	jalr	244(ra) # 80002f10 <iupdate>
  iunlock(ip);
    80004e24:	8526                	mv	a0,s1
    80004e26:	ffffe097          	auipc	ra,0xffffe
    80004e2a:	26e080e7          	jalr	622(ra) # 80003094 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004e2e:	fd040593          	addi	a1,s0,-48
    80004e32:	f5040513          	addi	a0,s0,-176
    80004e36:	fffff097          	auipc	ra,0xfffff
    80004e3a:	966080e7          	jalr	-1690(ra) # 8000379c <nameiparent>
    80004e3e:	892a                	mv	s2,a0
    80004e40:	c935                	beqz	a0,80004eb4 <sys_link+0x10a>
  ilock(dp);
    80004e42:	ffffe097          	auipc	ra,0xffffe
    80004e46:	190080e7          	jalr	400(ra) # 80002fd2 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004e4a:	00092703          	lw	a4,0(s2)
    80004e4e:	409c                	lw	a5,0(s1)
    80004e50:	04f71d63          	bne	a4,a5,80004eaa <sys_link+0x100>
    80004e54:	40d0                	lw	a2,4(s1)
    80004e56:	fd040593          	addi	a1,s0,-48
    80004e5a:	854a                	mv	a0,s2
    80004e5c:	fffff097          	auipc	ra,0xfffff
    80004e60:	860080e7          	jalr	-1952(ra) # 800036bc <dirlink>
    80004e64:	04054363          	bltz	a0,80004eaa <sys_link+0x100>
  iunlockput(dp);
    80004e68:	854a                	mv	a0,s2
    80004e6a:	ffffe097          	auipc	ra,0xffffe
    80004e6e:	3ca080e7          	jalr	970(ra) # 80003234 <iunlockput>
  iput(ip);
    80004e72:	8526                	mv	a0,s1
    80004e74:	ffffe097          	auipc	ra,0xffffe
    80004e78:	318080e7          	jalr	792(ra) # 8000318c <iput>
  end_op();
    80004e7c:	fffff097          	auipc	ra,0xfffff
    80004e80:	d30080e7          	jalr	-720(ra) # 80003bac <end_op>
  return 0;
    80004e84:	4781                	li	a5,0
    80004e86:	a085                	j	80004ee6 <sys_link+0x13c>
    end_op();
    80004e88:	fffff097          	auipc	ra,0xfffff
    80004e8c:	d24080e7          	jalr	-732(ra) # 80003bac <end_op>
    return -1;
    80004e90:	57fd                	li	a5,-1
    80004e92:	a891                	j	80004ee6 <sys_link+0x13c>
    iunlockput(ip);
    80004e94:	8526                	mv	a0,s1
    80004e96:	ffffe097          	auipc	ra,0xffffe
    80004e9a:	39e080e7          	jalr	926(ra) # 80003234 <iunlockput>
    end_op();
    80004e9e:	fffff097          	auipc	ra,0xfffff
    80004ea2:	d0e080e7          	jalr	-754(ra) # 80003bac <end_op>
    return -1;
    80004ea6:	57fd                	li	a5,-1
    80004ea8:	a83d                	j	80004ee6 <sys_link+0x13c>
    iunlockput(dp);
    80004eaa:	854a                	mv	a0,s2
    80004eac:	ffffe097          	auipc	ra,0xffffe
    80004eb0:	388080e7          	jalr	904(ra) # 80003234 <iunlockput>
  ilock(ip);
    80004eb4:	8526                	mv	a0,s1
    80004eb6:	ffffe097          	auipc	ra,0xffffe
    80004eba:	11c080e7          	jalr	284(ra) # 80002fd2 <ilock>
  ip->nlink--;
    80004ebe:	04a4d783          	lhu	a5,74(s1)
    80004ec2:	37fd                	addiw	a5,a5,-1
    80004ec4:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004ec8:	8526                	mv	a0,s1
    80004eca:	ffffe097          	auipc	ra,0xffffe
    80004ece:	046080e7          	jalr	70(ra) # 80002f10 <iupdate>
  iunlockput(ip);
    80004ed2:	8526                	mv	a0,s1
    80004ed4:	ffffe097          	auipc	ra,0xffffe
    80004ed8:	360080e7          	jalr	864(ra) # 80003234 <iunlockput>
  end_op();
    80004edc:	fffff097          	auipc	ra,0xfffff
    80004ee0:	cd0080e7          	jalr	-816(ra) # 80003bac <end_op>
  return -1;
    80004ee4:	57fd                	li	a5,-1
}
    80004ee6:	853e                	mv	a0,a5
    80004ee8:	70b2                	ld	ra,296(sp)
    80004eea:	7412                	ld	s0,288(sp)
    80004eec:	64f2                	ld	s1,280(sp)
    80004eee:	6952                	ld	s2,272(sp)
    80004ef0:	6155                	addi	sp,sp,304
    80004ef2:	8082                	ret

0000000080004ef4 <sys_unlink>:
{
    80004ef4:	7151                	addi	sp,sp,-240
    80004ef6:	f586                	sd	ra,232(sp)
    80004ef8:	f1a2                	sd	s0,224(sp)
    80004efa:	eda6                	sd	s1,216(sp)
    80004efc:	e9ca                	sd	s2,208(sp)
    80004efe:	e5ce                	sd	s3,200(sp)
    80004f00:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004f02:	08000613          	li	a2,128
    80004f06:	f3040593          	addi	a1,s0,-208
    80004f0a:	4501                	li	a0,0
    80004f0c:	ffffd097          	auipc	ra,0xffffd
    80004f10:	4ce080e7          	jalr	1230(ra) # 800023da <argstr>
    80004f14:	18054163          	bltz	a0,80005096 <sys_unlink+0x1a2>
  begin_op();
    80004f18:	fffff097          	auipc	ra,0xfffff
    80004f1c:	c14080e7          	jalr	-1004(ra) # 80003b2c <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004f20:	fb040593          	addi	a1,s0,-80
    80004f24:	f3040513          	addi	a0,s0,-208
    80004f28:	fffff097          	auipc	ra,0xfffff
    80004f2c:	874080e7          	jalr	-1932(ra) # 8000379c <nameiparent>
    80004f30:	84aa                	mv	s1,a0
    80004f32:	c979                	beqz	a0,80005008 <sys_unlink+0x114>
  ilock(dp);
    80004f34:	ffffe097          	auipc	ra,0xffffe
    80004f38:	09e080e7          	jalr	158(ra) # 80002fd2 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004f3c:	00004597          	auipc	a1,0x4
    80004f40:	8d458593          	addi	a1,a1,-1836 # 80008810 <syscalls+0x3a8>
    80004f44:	fb040513          	addi	a0,s0,-80
    80004f48:	ffffe097          	auipc	ra,0xffffe
    80004f4c:	54a080e7          	jalr	1354(ra) # 80003492 <namecmp>
    80004f50:	14050a63          	beqz	a0,800050a4 <sys_unlink+0x1b0>
    80004f54:	00004597          	auipc	a1,0x4
    80004f58:	8c458593          	addi	a1,a1,-1852 # 80008818 <syscalls+0x3b0>
    80004f5c:	fb040513          	addi	a0,s0,-80
    80004f60:	ffffe097          	auipc	ra,0xffffe
    80004f64:	532080e7          	jalr	1330(ra) # 80003492 <namecmp>
    80004f68:	12050e63          	beqz	a0,800050a4 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004f6c:	f2c40613          	addi	a2,s0,-212
    80004f70:	fb040593          	addi	a1,s0,-80
    80004f74:	8526                	mv	a0,s1
    80004f76:	ffffe097          	auipc	ra,0xffffe
    80004f7a:	536080e7          	jalr	1334(ra) # 800034ac <dirlookup>
    80004f7e:	892a                	mv	s2,a0
    80004f80:	12050263          	beqz	a0,800050a4 <sys_unlink+0x1b0>
  ilock(ip);
    80004f84:	ffffe097          	auipc	ra,0xffffe
    80004f88:	04e080e7          	jalr	78(ra) # 80002fd2 <ilock>
  if(ip->nlink < 1)
    80004f8c:	04a91783          	lh	a5,74(s2)
    80004f90:	08f05263          	blez	a5,80005014 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004f94:	04491703          	lh	a4,68(s2)
    80004f98:	4785                	li	a5,1
    80004f9a:	08f70563          	beq	a4,a5,80005024 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004f9e:	4641                	li	a2,16
    80004fa0:	4581                	li	a1,0
    80004fa2:	fc040513          	addi	a0,s0,-64
    80004fa6:	ffffb097          	auipc	ra,0xffffb
    80004faa:	1d2080e7          	jalr	466(ra) # 80000178 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004fae:	4741                	li	a4,16
    80004fb0:	f2c42683          	lw	a3,-212(s0)
    80004fb4:	fc040613          	addi	a2,s0,-64
    80004fb8:	4581                	li	a1,0
    80004fba:	8526                	mv	a0,s1
    80004fbc:	ffffe097          	auipc	ra,0xffffe
    80004fc0:	3c2080e7          	jalr	962(ra) # 8000337e <writei>
    80004fc4:	47c1                	li	a5,16
    80004fc6:	0af51563          	bne	a0,a5,80005070 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004fca:	04491703          	lh	a4,68(s2)
    80004fce:	4785                	li	a5,1
    80004fd0:	0af70863          	beq	a4,a5,80005080 <sys_unlink+0x18c>
  iunlockput(dp);
    80004fd4:	8526                	mv	a0,s1
    80004fd6:	ffffe097          	auipc	ra,0xffffe
    80004fda:	25e080e7          	jalr	606(ra) # 80003234 <iunlockput>
  ip->nlink--;
    80004fde:	04a95783          	lhu	a5,74(s2)
    80004fe2:	37fd                	addiw	a5,a5,-1
    80004fe4:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004fe8:	854a                	mv	a0,s2
    80004fea:	ffffe097          	auipc	ra,0xffffe
    80004fee:	f26080e7          	jalr	-218(ra) # 80002f10 <iupdate>
  iunlockput(ip);
    80004ff2:	854a                	mv	a0,s2
    80004ff4:	ffffe097          	auipc	ra,0xffffe
    80004ff8:	240080e7          	jalr	576(ra) # 80003234 <iunlockput>
  end_op();
    80004ffc:	fffff097          	auipc	ra,0xfffff
    80005000:	bb0080e7          	jalr	-1104(ra) # 80003bac <end_op>
  return 0;
    80005004:	4501                	li	a0,0
    80005006:	a84d                	j	800050b8 <sys_unlink+0x1c4>
    end_op();
    80005008:	fffff097          	auipc	ra,0xfffff
    8000500c:	ba4080e7          	jalr	-1116(ra) # 80003bac <end_op>
    return -1;
    80005010:	557d                	li	a0,-1
    80005012:	a05d                	j	800050b8 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80005014:	00004517          	auipc	a0,0x4
    80005018:	82c50513          	addi	a0,a0,-2004 # 80008840 <syscalls+0x3d8>
    8000501c:	00001097          	auipc	ra,0x1
    80005020:	404080e7          	jalr	1028(ra) # 80006420 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005024:	04c92703          	lw	a4,76(s2)
    80005028:	02000793          	li	a5,32
    8000502c:	f6e7f9e3          	bgeu	a5,a4,80004f9e <sys_unlink+0xaa>
    80005030:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005034:	4741                	li	a4,16
    80005036:	86ce                	mv	a3,s3
    80005038:	f1840613          	addi	a2,s0,-232
    8000503c:	4581                	li	a1,0
    8000503e:	854a                	mv	a0,s2
    80005040:	ffffe097          	auipc	ra,0xffffe
    80005044:	246080e7          	jalr	582(ra) # 80003286 <readi>
    80005048:	47c1                	li	a5,16
    8000504a:	00f51b63          	bne	a0,a5,80005060 <sys_unlink+0x16c>
    if(de.inum != 0)
    8000504e:	f1845783          	lhu	a5,-232(s0)
    80005052:	e7a1                	bnez	a5,8000509a <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005054:	29c1                	addiw	s3,s3,16
    80005056:	04c92783          	lw	a5,76(s2)
    8000505a:	fcf9ede3          	bltu	s3,a5,80005034 <sys_unlink+0x140>
    8000505e:	b781                	j	80004f9e <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80005060:	00003517          	auipc	a0,0x3
    80005064:	7f850513          	addi	a0,a0,2040 # 80008858 <syscalls+0x3f0>
    80005068:	00001097          	auipc	ra,0x1
    8000506c:	3b8080e7          	jalr	952(ra) # 80006420 <panic>
    panic("unlink: writei");
    80005070:	00004517          	auipc	a0,0x4
    80005074:	80050513          	addi	a0,a0,-2048 # 80008870 <syscalls+0x408>
    80005078:	00001097          	auipc	ra,0x1
    8000507c:	3a8080e7          	jalr	936(ra) # 80006420 <panic>
    dp->nlink--;
    80005080:	04a4d783          	lhu	a5,74(s1)
    80005084:	37fd                	addiw	a5,a5,-1
    80005086:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    8000508a:	8526                	mv	a0,s1
    8000508c:	ffffe097          	auipc	ra,0xffffe
    80005090:	e84080e7          	jalr	-380(ra) # 80002f10 <iupdate>
    80005094:	b781                	j	80004fd4 <sys_unlink+0xe0>
    return -1;
    80005096:	557d                	li	a0,-1
    80005098:	a005                	j	800050b8 <sys_unlink+0x1c4>
    iunlockput(ip);
    8000509a:	854a                	mv	a0,s2
    8000509c:	ffffe097          	auipc	ra,0xffffe
    800050a0:	198080e7          	jalr	408(ra) # 80003234 <iunlockput>
  iunlockput(dp);
    800050a4:	8526                	mv	a0,s1
    800050a6:	ffffe097          	auipc	ra,0xffffe
    800050aa:	18e080e7          	jalr	398(ra) # 80003234 <iunlockput>
  end_op();
    800050ae:	fffff097          	auipc	ra,0xfffff
    800050b2:	afe080e7          	jalr	-1282(ra) # 80003bac <end_op>
  return -1;
    800050b6:	557d                	li	a0,-1
}
    800050b8:	70ae                	ld	ra,232(sp)
    800050ba:	740e                	ld	s0,224(sp)
    800050bc:	64ee                	ld	s1,216(sp)
    800050be:	694e                	ld	s2,208(sp)
    800050c0:	69ae                	ld	s3,200(sp)
    800050c2:	616d                	addi	sp,sp,240
    800050c4:	8082                	ret

00000000800050c6 <sys_open>:

uint64
sys_open(void)
{
    800050c6:	7131                	addi	sp,sp,-192
    800050c8:	fd06                	sd	ra,184(sp)
    800050ca:	f922                	sd	s0,176(sp)
    800050cc:	f526                	sd	s1,168(sp)
    800050ce:	f14a                	sd	s2,160(sp)
    800050d0:	ed4e                	sd	s3,152(sp)
    800050d2:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    800050d4:	08000613          	li	a2,128
    800050d8:	f5040593          	addi	a1,s0,-176
    800050dc:	4501                	li	a0,0
    800050de:	ffffd097          	auipc	ra,0xffffd
    800050e2:	2fc080e7          	jalr	764(ra) # 800023da <argstr>
    return -1;
    800050e6:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    800050e8:	0c054163          	bltz	a0,800051aa <sys_open+0xe4>
    800050ec:	f4c40593          	addi	a1,s0,-180
    800050f0:	4505                	li	a0,1
    800050f2:	ffffd097          	auipc	ra,0xffffd
    800050f6:	2a4080e7          	jalr	676(ra) # 80002396 <argint>
    800050fa:	0a054863          	bltz	a0,800051aa <sys_open+0xe4>

  begin_op();
    800050fe:	fffff097          	auipc	ra,0xfffff
    80005102:	a2e080e7          	jalr	-1490(ra) # 80003b2c <begin_op>

  if(omode & O_CREATE){
    80005106:	f4c42783          	lw	a5,-180(s0)
    8000510a:	2007f793          	andi	a5,a5,512
    8000510e:	cbdd                	beqz	a5,800051c4 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80005110:	4681                	li	a3,0
    80005112:	4601                	li	a2,0
    80005114:	4589                	li	a1,2
    80005116:	f5040513          	addi	a0,s0,-176
    8000511a:	00000097          	auipc	ra,0x0
    8000511e:	972080e7          	jalr	-1678(ra) # 80004a8c <create>
    80005122:	892a                	mv	s2,a0
    if(ip == 0){
    80005124:	c959                	beqz	a0,800051ba <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80005126:	04491703          	lh	a4,68(s2)
    8000512a:	478d                	li	a5,3
    8000512c:	00f71763          	bne	a4,a5,8000513a <sys_open+0x74>
    80005130:	04695703          	lhu	a4,70(s2)
    80005134:	47a5                	li	a5,9
    80005136:	0ce7ec63          	bltu	a5,a4,8000520e <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    8000513a:	fffff097          	auipc	ra,0xfffff
    8000513e:	e02080e7          	jalr	-510(ra) # 80003f3c <filealloc>
    80005142:	89aa                	mv	s3,a0
    80005144:	10050263          	beqz	a0,80005248 <sys_open+0x182>
    80005148:	00000097          	auipc	ra,0x0
    8000514c:	902080e7          	jalr	-1790(ra) # 80004a4a <fdalloc>
    80005150:	84aa                	mv	s1,a0
    80005152:	0e054663          	bltz	a0,8000523e <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80005156:	04491703          	lh	a4,68(s2)
    8000515a:	478d                	li	a5,3
    8000515c:	0cf70463          	beq	a4,a5,80005224 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005160:	4789                	li	a5,2
    80005162:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80005166:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    8000516a:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    8000516e:	f4c42783          	lw	a5,-180(s0)
    80005172:	0017c713          	xori	a4,a5,1
    80005176:	8b05                	andi	a4,a4,1
    80005178:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    8000517c:	0037f713          	andi	a4,a5,3
    80005180:	00e03733          	snez	a4,a4
    80005184:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80005188:	4007f793          	andi	a5,a5,1024
    8000518c:	c791                	beqz	a5,80005198 <sys_open+0xd2>
    8000518e:	04491703          	lh	a4,68(s2)
    80005192:	4789                	li	a5,2
    80005194:	08f70f63          	beq	a4,a5,80005232 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80005198:	854a                	mv	a0,s2
    8000519a:	ffffe097          	auipc	ra,0xffffe
    8000519e:	efa080e7          	jalr	-262(ra) # 80003094 <iunlock>
  end_op();
    800051a2:	fffff097          	auipc	ra,0xfffff
    800051a6:	a0a080e7          	jalr	-1526(ra) # 80003bac <end_op>

  return fd;
}
    800051aa:	8526                	mv	a0,s1
    800051ac:	70ea                	ld	ra,184(sp)
    800051ae:	744a                	ld	s0,176(sp)
    800051b0:	74aa                	ld	s1,168(sp)
    800051b2:	790a                	ld	s2,160(sp)
    800051b4:	69ea                	ld	s3,152(sp)
    800051b6:	6129                	addi	sp,sp,192
    800051b8:	8082                	ret
      end_op();
    800051ba:	fffff097          	auipc	ra,0xfffff
    800051be:	9f2080e7          	jalr	-1550(ra) # 80003bac <end_op>
      return -1;
    800051c2:	b7e5                	j	800051aa <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    800051c4:	f5040513          	addi	a0,s0,-176
    800051c8:	ffffe097          	auipc	ra,0xffffe
    800051cc:	5b6080e7          	jalr	1462(ra) # 8000377e <namei>
    800051d0:	892a                	mv	s2,a0
    800051d2:	c905                	beqz	a0,80005202 <sys_open+0x13c>
    ilock(ip);
    800051d4:	ffffe097          	auipc	ra,0xffffe
    800051d8:	dfe080e7          	jalr	-514(ra) # 80002fd2 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    800051dc:	04491703          	lh	a4,68(s2)
    800051e0:	4785                	li	a5,1
    800051e2:	f4f712e3          	bne	a4,a5,80005126 <sys_open+0x60>
    800051e6:	f4c42783          	lw	a5,-180(s0)
    800051ea:	dba1                	beqz	a5,8000513a <sys_open+0x74>
      iunlockput(ip);
    800051ec:	854a                	mv	a0,s2
    800051ee:	ffffe097          	auipc	ra,0xffffe
    800051f2:	046080e7          	jalr	70(ra) # 80003234 <iunlockput>
      end_op();
    800051f6:	fffff097          	auipc	ra,0xfffff
    800051fa:	9b6080e7          	jalr	-1610(ra) # 80003bac <end_op>
      return -1;
    800051fe:	54fd                	li	s1,-1
    80005200:	b76d                	j	800051aa <sys_open+0xe4>
      end_op();
    80005202:	fffff097          	auipc	ra,0xfffff
    80005206:	9aa080e7          	jalr	-1622(ra) # 80003bac <end_op>
      return -1;
    8000520a:	54fd                	li	s1,-1
    8000520c:	bf79                	j	800051aa <sys_open+0xe4>
    iunlockput(ip);
    8000520e:	854a                	mv	a0,s2
    80005210:	ffffe097          	auipc	ra,0xffffe
    80005214:	024080e7          	jalr	36(ra) # 80003234 <iunlockput>
    end_op();
    80005218:	fffff097          	auipc	ra,0xfffff
    8000521c:	994080e7          	jalr	-1644(ra) # 80003bac <end_op>
    return -1;
    80005220:	54fd                	li	s1,-1
    80005222:	b761                	j	800051aa <sys_open+0xe4>
    f->type = FD_DEVICE;
    80005224:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80005228:	04691783          	lh	a5,70(s2)
    8000522c:	02f99223          	sh	a5,36(s3)
    80005230:	bf2d                	j	8000516a <sys_open+0xa4>
    itrunc(ip);
    80005232:	854a                	mv	a0,s2
    80005234:	ffffe097          	auipc	ra,0xffffe
    80005238:	eac080e7          	jalr	-340(ra) # 800030e0 <itrunc>
    8000523c:	bfb1                	j	80005198 <sys_open+0xd2>
      fileclose(f);
    8000523e:	854e                	mv	a0,s3
    80005240:	fffff097          	auipc	ra,0xfffff
    80005244:	db8080e7          	jalr	-584(ra) # 80003ff8 <fileclose>
    iunlockput(ip);
    80005248:	854a                	mv	a0,s2
    8000524a:	ffffe097          	auipc	ra,0xffffe
    8000524e:	fea080e7          	jalr	-22(ra) # 80003234 <iunlockput>
    end_op();
    80005252:	fffff097          	auipc	ra,0xfffff
    80005256:	95a080e7          	jalr	-1702(ra) # 80003bac <end_op>
    return -1;
    8000525a:	54fd                	li	s1,-1
    8000525c:	b7b9                	j	800051aa <sys_open+0xe4>

000000008000525e <sys_mkdir>:

uint64
sys_mkdir(void)
{
    8000525e:	7175                	addi	sp,sp,-144
    80005260:	e506                	sd	ra,136(sp)
    80005262:	e122                	sd	s0,128(sp)
    80005264:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005266:	fffff097          	auipc	ra,0xfffff
    8000526a:	8c6080e7          	jalr	-1850(ra) # 80003b2c <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    8000526e:	08000613          	li	a2,128
    80005272:	f7040593          	addi	a1,s0,-144
    80005276:	4501                	li	a0,0
    80005278:	ffffd097          	auipc	ra,0xffffd
    8000527c:	162080e7          	jalr	354(ra) # 800023da <argstr>
    80005280:	02054963          	bltz	a0,800052b2 <sys_mkdir+0x54>
    80005284:	4681                	li	a3,0
    80005286:	4601                	li	a2,0
    80005288:	4585                	li	a1,1
    8000528a:	f7040513          	addi	a0,s0,-144
    8000528e:	fffff097          	auipc	ra,0xfffff
    80005292:	7fe080e7          	jalr	2046(ra) # 80004a8c <create>
    80005296:	cd11                	beqz	a0,800052b2 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005298:	ffffe097          	auipc	ra,0xffffe
    8000529c:	f9c080e7          	jalr	-100(ra) # 80003234 <iunlockput>
  end_op();
    800052a0:	fffff097          	auipc	ra,0xfffff
    800052a4:	90c080e7          	jalr	-1780(ra) # 80003bac <end_op>
  return 0;
    800052a8:	4501                	li	a0,0
}
    800052aa:	60aa                	ld	ra,136(sp)
    800052ac:	640a                	ld	s0,128(sp)
    800052ae:	6149                	addi	sp,sp,144
    800052b0:	8082                	ret
    end_op();
    800052b2:	fffff097          	auipc	ra,0xfffff
    800052b6:	8fa080e7          	jalr	-1798(ra) # 80003bac <end_op>
    return -1;
    800052ba:	557d                	li	a0,-1
    800052bc:	b7fd                	j	800052aa <sys_mkdir+0x4c>

00000000800052be <sys_mknod>:

uint64
sys_mknod(void)
{
    800052be:	7135                	addi	sp,sp,-160
    800052c0:	ed06                	sd	ra,152(sp)
    800052c2:	e922                	sd	s0,144(sp)
    800052c4:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    800052c6:	fffff097          	auipc	ra,0xfffff
    800052ca:	866080e7          	jalr	-1946(ra) # 80003b2c <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800052ce:	08000613          	li	a2,128
    800052d2:	f7040593          	addi	a1,s0,-144
    800052d6:	4501                	li	a0,0
    800052d8:	ffffd097          	auipc	ra,0xffffd
    800052dc:	102080e7          	jalr	258(ra) # 800023da <argstr>
    800052e0:	04054a63          	bltz	a0,80005334 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    800052e4:	f6c40593          	addi	a1,s0,-148
    800052e8:	4505                	li	a0,1
    800052ea:	ffffd097          	auipc	ra,0xffffd
    800052ee:	0ac080e7          	jalr	172(ra) # 80002396 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800052f2:	04054163          	bltz	a0,80005334 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    800052f6:	f6840593          	addi	a1,s0,-152
    800052fa:	4509                	li	a0,2
    800052fc:	ffffd097          	auipc	ra,0xffffd
    80005300:	09a080e7          	jalr	154(ra) # 80002396 <argint>
     argint(1, &major) < 0 ||
    80005304:	02054863          	bltz	a0,80005334 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80005308:	f6841683          	lh	a3,-152(s0)
    8000530c:	f6c41603          	lh	a2,-148(s0)
    80005310:	458d                	li	a1,3
    80005312:	f7040513          	addi	a0,s0,-144
    80005316:	fffff097          	auipc	ra,0xfffff
    8000531a:	776080e7          	jalr	1910(ra) # 80004a8c <create>
     argint(2, &minor) < 0 ||
    8000531e:	c919                	beqz	a0,80005334 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005320:	ffffe097          	auipc	ra,0xffffe
    80005324:	f14080e7          	jalr	-236(ra) # 80003234 <iunlockput>
  end_op();
    80005328:	fffff097          	auipc	ra,0xfffff
    8000532c:	884080e7          	jalr	-1916(ra) # 80003bac <end_op>
  return 0;
    80005330:	4501                	li	a0,0
    80005332:	a031                	j	8000533e <sys_mknod+0x80>
    end_op();
    80005334:	fffff097          	auipc	ra,0xfffff
    80005338:	878080e7          	jalr	-1928(ra) # 80003bac <end_op>
    return -1;
    8000533c:	557d                	li	a0,-1
}
    8000533e:	60ea                	ld	ra,152(sp)
    80005340:	644a                	ld	s0,144(sp)
    80005342:	610d                	addi	sp,sp,160
    80005344:	8082                	ret

0000000080005346 <sys_chdir>:

uint64
sys_chdir(void)
{
    80005346:	7135                	addi	sp,sp,-160
    80005348:	ed06                	sd	ra,152(sp)
    8000534a:	e922                	sd	s0,144(sp)
    8000534c:	e526                	sd	s1,136(sp)
    8000534e:	e14a                	sd	s2,128(sp)
    80005350:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80005352:	ffffc097          	auipc	ra,0xffffc
    80005356:	f84080e7          	jalr	-124(ra) # 800012d6 <myproc>
    8000535a:	892a                	mv	s2,a0
  
  begin_op();
    8000535c:	ffffe097          	auipc	ra,0xffffe
    80005360:	7d0080e7          	jalr	2000(ra) # 80003b2c <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005364:	08000613          	li	a2,128
    80005368:	f6040593          	addi	a1,s0,-160
    8000536c:	4501                	li	a0,0
    8000536e:	ffffd097          	auipc	ra,0xffffd
    80005372:	06c080e7          	jalr	108(ra) # 800023da <argstr>
    80005376:	04054b63          	bltz	a0,800053cc <sys_chdir+0x86>
    8000537a:	f6040513          	addi	a0,s0,-160
    8000537e:	ffffe097          	auipc	ra,0xffffe
    80005382:	400080e7          	jalr	1024(ra) # 8000377e <namei>
    80005386:	84aa                	mv	s1,a0
    80005388:	c131                	beqz	a0,800053cc <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    8000538a:	ffffe097          	auipc	ra,0xffffe
    8000538e:	c48080e7          	jalr	-952(ra) # 80002fd2 <ilock>
  if(ip->type != T_DIR){
    80005392:	04449703          	lh	a4,68(s1)
    80005396:	4785                	li	a5,1
    80005398:	04f71063          	bne	a4,a5,800053d8 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    8000539c:	8526                	mv	a0,s1
    8000539e:	ffffe097          	auipc	ra,0xffffe
    800053a2:	cf6080e7          	jalr	-778(ra) # 80003094 <iunlock>
  iput(p->cwd);
    800053a6:	15093503          	ld	a0,336(s2)
    800053aa:	ffffe097          	auipc	ra,0xffffe
    800053ae:	de2080e7          	jalr	-542(ra) # 8000318c <iput>
  end_op();
    800053b2:	ffffe097          	auipc	ra,0xffffe
    800053b6:	7fa080e7          	jalr	2042(ra) # 80003bac <end_op>
  p->cwd = ip;
    800053ba:	14993823          	sd	s1,336(s2)
  return 0;
    800053be:	4501                	li	a0,0
}
    800053c0:	60ea                	ld	ra,152(sp)
    800053c2:	644a                	ld	s0,144(sp)
    800053c4:	64aa                	ld	s1,136(sp)
    800053c6:	690a                	ld	s2,128(sp)
    800053c8:	610d                	addi	sp,sp,160
    800053ca:	8082                	ret
    end_op();
    800053cc:	ffffe097          	auipc	ra,0xffffe
    800053d0:	7e0080e7          	jalr	2016(ra) # 80003bac <end_op>
    return -1;
    800053d4:	557d                	li	a0,-1
    800053d6:	b7ed                	j	800053c0 <sys_chdir+0x7a>
    iunlockput(ip);
    800053d8:	8526                	mv	a0,s1
    800053da:	ffffe097          	auipc	ra,0xffffe
    800053de:	e5a080e7          	jalr	-422(ra) # 80003234 <iunlockput>
    end_op();
    800053e2:	ffffe097          	auipc	ra,0xffffe
    800053e6:	7ca080e7          	jalr	1994(ra) # 80003bac <end_op>
    return -1;
    800053ea:	557d                	li	a0,-1
    800053ec:	bfd1                	j	800053c0 <sys_chdir+0x7a>

00000000800053ee <sys_exec>:

uint64
sys_exec(void)
{
    800053ee:	7145                	addi	sp,sp,-464
    800053f0:	e786                	sd	ra,456(sp)
    800053f2:	e3a2                	sd	s0,448(sp)
    800053f4:	ff26                	sd	s1,440(sp)
    800053f6:	fb4a                	sd	s2,432(sp)
    800053f8:	f74e                	sd	s3,424(sp)
    800053fa:	f352                	sd	s4,416(sp)
    800053fc:	ef56                	sd	s5,408(sp)
    800053fe:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005400:	08000613          	li	a2,128
    80005404:	f4040593          	addi	a1,s0,-192
    80005408:	4501                	li	a0,0
    8000540a:	ffffd097          	auipc	ra,0xffffd
    8000540e:	fd0080e7          	jalr	-48(ra) # 800023da <argstr>
    return -1;
    80005412:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005414:	0c054a63          	bltz	a0,800054e8 <sys_exec+0xfa>
    80005418:	e3840593          	addi	a1,s0,-456
    8000541c:	4505                	li	a0,1
    8000541e:	ffffd097          	auipc	ra,0xffffd
    80005422:	f9a080e7          	jalr	-102(ra) # 800023b8 <argaddr>
    80005426:	0c054163          	bltz	a0,800054e8 <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    8000542a:	10000613          	li	a2,256
    8000542e:	4581                	li	a1,0
    80005430:	e4040513          	addi	a0,s0,-448
    80005434:	ffffb097          	auipc	ra,0xffffb
    80005438:	d44080e7          	jalr	-700(ra) # 80000178 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    8000543c:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80005440:	89a6                	mv	s3,s1
    80005442:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005444:	02000a13          	li	s4,32
    80005448:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    8000544c:	00391513          	slli	a0,s2,0x3
    80005450:	e3040593          	addi	a1,s0,-464
    80005454:	e3843783          	ld	a5,-456(s0)
    80005458:	953e                	add	a0,a0,a5
    8000545a:	ffffd097          	auipc	ra,0xffffd
    8000545e:	ea2080e7          	jalr	-350(ra) # 800022fc <fetchaddr>
    80005462:	02054a63          	bltz	a0,80005496 <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    80005466:	e3043783          	ld	a5,-464(s0)
    8000546a:	c3b9                	beqz	a5,800054b0 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    8000546c:	ffffb097          	auipc	ra,0xffffb
    80005470:	cac080e7          	jalr	-852(ra) # 80000118 <kalloc>
    80005474:	85aa                	mv	a1,a0
    80005476:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    8000547a:	cd11                	beqz	a0,80005496 <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    8000547c:	6605                	lui	a2,0x1
    8000547e:	e3043503          	ld	a0,-464(s0)
    80005482:	ffffd097          	auipc	ra,0xffffd
    80005486:	ecc080e7          	jalr	-308(ra) # 8000234e <fetchstr>
    8000548a:	00054663          	bltz	a0,80005496 <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    8000548e:	0905                	addi	s2,s2,1
    80005490:	09a1                	addi	s3,s3,8
    80005492:	fb491be3          	bne	s2,s4,80005448 <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005496:	10048913          	addi	s2,s1,256
    8000549a:	6088                	ld	a0,0(s1)
    8000549c:	c529                	beqz	a0,800054e6 <sys_exec+0xf8>
    kfree(argv[i]);
    8000549e:	ffffb097          	auipc	ra,0xffffb
    800054a2:	b7e080e7          	jalr	-1154(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800054a6:	04a1                	addi	s1,s1,8
    800054a8:	ff2499e3          	bne	s1,s2,8000549a <sys_exec+0xac>
  return -1;
    800054ac:	597d                	li	s2,-1
    800054ae:	a82d                	j	800054e8 <sys_exec+0xfa>
      argv[i] = 0;
    800054b0:	0a8e                	slli	s5,s5,0x3
    800054b2:	fc040793          	addi	a5,s0,-64
    800054b6:	9abe                	add	s5,s5,a5
    800054b8:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    800054bc:	e4040593          	addi	a1,s0,-448
    800054c0:	f4040513          	addi	a0,s0,-192
    800054c4:	fffff097          	auipc	ra,0xfffff
    800054c8:	194080e7          	jalr	404(ra) # 80004658 <exec>
    800054cc:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800054ce:	10048993          	addi	s3,s1,256
    800054d2:	6088                	ld	a0,0(s1)
    800054d4:	c911                	beqz	a0,800054e8 <sys_exec+0xfa>
    kfree(argv[i]);
    800054d6:	ffffb097          	auipc	ra,0xffffb
    800054da:	b46080e7          	jalr	-1210(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800054de:	04a1                	addi	s1,s1,8
    800054e0:	ff3499e3          	bne	s1,s3,800054d2 <sys_exec+0xe4>
    800054e4:	a011                	j	800054e8 <sys_exec+0xfa>
  return -1;
    800054e6:	597d                	li	s2,-1
}
    800054e8:	854a                	mv	a0,s2
    800054ea:	60be                	ld	ra,456(sp)
    800054ec:	641e                	ld	s0,448(sp)
    800054ee:	74fa                	ld	s1,440(sp)
    800054f0:	795a                	ld	s2,432(sp)
    800054f2:	79ba                	ld	s3,424(sp)
    800054f4:	7a1a                	ld	s4,416(sp)
    800054f6:	6afa                	ld	s5,408(sp)
    800054f8:	6179                	addi	sp,sp,464
    800054fa:	8082                	ret

00000000800054fc <sys_pipe>:

uint64
sys_pipe(void)
{
    800054fc:	7139                	addi	sp,sp,-64
    800054fe:	fc06                	sd	ra,56(sp)
    80005500:	f822                	sd	s0,48(sp)
    80005502:	f426                	sd	s1,40(sp)
    80005504:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005506:	ffffc097          	auipc	ra,0xffffc
    8000550a:	dd0080e7          	jalr	-560(ra) # 800012d6 <myproc>
    8000550e:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80005510:	fd840593          	addi	a1,s0,-40
    80005514:	4501                	li	a0,0
    80005516:	ffffd097          	auipc	ra,0xffffd
    8000551a:	ea2080e7          	jalr	-350(ra) # 800023b8 <argaddr>
    return -1;
    8000551e:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80005520:	0e054063          	bltz	a0,80005600 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80005524:	fc840593          	addi	a1,s0,-56
    80005528:	fd040513          	addi	a0,s0,-48
    8000552c:	fffff097          	auipc	ra,0xfffff
    80005530:	dfc080e7          	jalr	-516(ra) # 80004328 <pipealloc>
    return -1;
    80005534:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005536:	0c054563          	bltz	a0,80005600 <sys_pipe+0x104>
  fd0 = -1;
    8000553a:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    8000553e:	fd043503          	ld	a0,-48(s0)
    80005542:	fffff097          	auipc	ra,0xfffff
    80005546:	508080e7          	jalr	1288(ra) # 80004a4a <fdalloc>
    8000554a:	fca42223          	sw	a0,-60(s0)
    8000554e:	08054c63          	bltz	a0,800055e6 <sys_pipe+0xea>
    80005552:	fc843503          	ld	a0,-56(s0)
    80005556:	fffff097          	auipc	ra,0xfffff
    8000555a:	4f4080e7          	jalr	1268(ra) # 80004a4a <fdalloc>
    8000555e:	fca42023          	sw	a0,-64(s0)
    80005562:	06054863          	bltz	a0,800055d2 <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005566:	4691                	li	a3,4
    80005568:	fc440613          	addi	a2,s0,-60
    8000556c:	fd843583          	ld	a1,-40(s0)
    80005570:	68a8                	ld	a0,80(s1)
    80005572:	ffffb097          	auipc	ra,0xffffb
    80005576:	590080e7          	jalr	1424(ra) # 80000b02 <copyout>
    8000557a:	02054063          	bltz	a0,8000559a <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    8000557e:	4691                	li	a3,4
    80005580:	fc040613          	addi	a2,s0,-64
    80005584:	fd843583          	ld	a1,-40(s0)
    80005588:	0591                	addi	a1,a1,4
    8000558a:	68a8                	ld	a0,80(s1)
    8000558c:	ffffb097          	auipc	ra,0xffffb
    80005590:	576080e7          	jalr	1398(ra) # 80000b02 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005594:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005596:	06055563          	bgez	a0,80005600 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    8000559a:	fc442783          	lw	a5,-60(s0)
    8000559e:	07e9                	addi	a5,a5,26
    800055a0:	078e                	slli	a5,a5,0x3
    800055a2:	97a6                	add	a5,a5,s1
    800055a4:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800055a8:	fc042503          	lw	a0,-64(s0)
    800055ac:	0569                	addi	a0,a0,26
    800055ae:	050e                	slli	a0,a0,0x3
    800055b0:	9526                	add	a0,a0,s1
    800055b2:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    800055b6:	fd043503          	ld	a0,-48(s0)
    800055ba:	fffff097          	auipc	ra,0xfffff
    800055be:	a3e080e7          	jalr	-1474(ra) # 80003ff8 <fileclose>
    fileclose(wf);
    800055c2:	fc843503          	ld	a0,-56(s0)
    800055c6:	fffff097          	auipc	ra,0xfffff
    800055ca:	a32080e7          	jalr	-1486(ra) # 80003ff8 <fileclose>
    return -1;
    800055ce:	57fd                	li	a5,-1
    800055d0:	a805                	j	80005600 <sys_pipe+0x104>
    if(fd0 >= 0)
    800055d2:	fc442783          	lw	a5,-60(s0)
    800055d6:	0007c863          	bltz	a5,800055e6 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    800055da:	01a78513          	addi	a0,a5,26
    800055de:	050e                	slli	a0,a0,0x3
    800055e0:	9526                	add	a0,a0,s1
    800055e2:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    800055e6:	fd043503          	ld	a0,-48(s0)
    800055ea:	fffff097          	auipc	ra,0xfffff
    800055ee:	a0e080e7          	jalr	-1522(ra) # 80003ff8 <fileclose>
    fileclose(wf);
    800055f2:	fc843503          	ld	a0,-56(s0)
    800055f6:	fffff097          	auipc	ra,0xfffff
    800055fa:	a02080e7          	jalr	-1534(ra) # 80003ff8 <fileclose>
    return -1;
    800055fe:	57fd                	li	a5,-1
}
    80005600:	853e                	mv	a0,a5
    80005602:	70e2                	ld	ra,56(sp)
    80005604:	7442                	ld	s0,48(sp)
    80005606:	74a2                	ld	s1,40(sp)
    80005608:	6121                	addi	sp,sp,64
    8000560a:	8082                	ret
    8000560c:	0000                	unimp
	...

0000000080005610 <kernelvec>:
    80005610:	7111                	addi	sp,sp,-256
    80005612:	e006                	sd	ra,0(sp)
    80005614:	e40a                	sd	sp,8(sp)
    80005616:	e80e                	sd	gp,16(sp)
    80005618:	ec12                	sd	tp,24(sp)
    8000561a:	f016                	sd	t0,32(sp)
    8000561c:	f41a                	sd	t1,40(sp)
    8000561e:	f81e                	sd	t2,48(sp)
    80005620:	fc22                	sd	s0,56(sp)
    80005622:	e0a6                	sd	s1,64(sp)
    80005624:	e4aa                	sd	a0,72(sp)
    80005626:	e8ae                	sd	a1,80(sp)
    80005628:	ecb2                	sd	a2,88(sp)
    8000562a:	f0b6                	sd	a3,96(sp)
    8000562c:	f4ba                	sd	a4,104(sp)
    8000562e:	f8be                	sd	a5,112(sp)
    80005630:	fcc2                	sd	a6,120(sp)
    80005632:	e146                	sd	a7,128(sp)
    80005634:	e54a                	sd	s2,136(sp)
    80005636:	e94e                	sd	s3,144(sp)
    80005638:	ed52                	sd	s4,152(sp)
    8000563a:	f156                	sd	s5,160(sp)
    8000563c:	f55a                	sd	s6,168(sp)
    8000563e:	f95e                	sd	s7,176(sp)
    80005640:	fd62                	sd	s8,184(sp)
    80005642:	e1e6                	sd	s9,192(sp)
    80005644:	e5ea                	sd	s10,200(sp)
    80005646:	e9ee                	sd	s11,208(sp)
    80005648:	edf2                	sd	t3,216(sp)
    8000564a:	f1f6                	sd	t4,224(sp)
    8000564c:	f5fa                	sd	t5,232(sp)
    8000564e:	f9fe                	sd	t6,240(sp)
    80005650:	b79fc0ef          	jal	ra,800021c8 <kerneltrap>
    80005654:	6082                	ld	ra,0(sp)
    80005656:	6122                	ld	sp,8(sp)
    80005658:	61c2                	ld	gp,16(sp)
    8000565a:	7282                	ld	t0,32(sp)
    8000565c:	7322                	ld	t1,40(sp)
    8000565e:	73c2                	ld	t2,48(sp)
    80005660:	7462                	ld	s0,56(sp)
    80005662:	6486                	ld	s1,64(sp)
    80005664:	6526                	ld	a0,72(sp)
    80005666:	65c6                	ld	a1,80(sp)
    80005668:	6666                	ld	a2,88(sp)
    8000566a:	7686                	ld	a3,96(sp)
    8000566c:	7726                	ld	a4,104(sp)
    8000566e:	77c6                	ld	a5,112(sp)
    80005670:	7866                	ld	a6,120(sp)
    80005672:	688a                	ld	a7,128(sp)
    80005674:	692a                	ld	s2,136(sp)
    80005676:	69ca                	ld	s3,144(sp)
    80005678:	6a6a                	ld	s4,152(sp)
    8000567a:	7a8a                	ld	s5,160(sp)
    8000567c:	7b2a                	ld	s6,168(sp)
    8000567e:	7bca                	ld	s7,176(sp)
    80005680:	7c6a                	ld	s8,184(sp)
    80005682:	6c8e                	ld	s9,192(sp)
    80005684:	6d2e                	ld	s10,200(sp)
    80005686:	6dce                	ld	s11,208(sp)
    80005688:	6e6e                	ld	t3,216(sp)
    8000568a:	7e8e                	ld	t4,224(sp)
    8000568c:	7f2e                	ld	t5,232(sp)
    8000568e:	7fce                	ld	t6,240(sp)
    80005690:	6111                	addi	sp,sp,256
    80005692:	10200073          	sret
    80005696:	00000013          	nop
    8000569a:	00000013          	nop
    8000569e:	0001                	nop

00000000800056a0 <timervec>:
    800056a0:	34051573          	csrrw	a0,mscratch,a0
    800056a4:	e10c                	sd	a1,0(a0)
    800056a6:	e510                	sd	a2,8(a0)
    800056a8:	e914                	sd	a3,16(a0)
    800056aa:	6d0c                	ld	a1,24(a0)
    800056ac:	7110                	ld	a2,32(a0)
    800056ae:	6194                	ld	a3,0(a1)
    800056b0:	96b2                	add	a3,a3,a2
    800056b2:	e194                	sd	a3,0(a1)
    800056b4:	4589                	li	a1,2
    800056b6:	14459073          	csrw	sip,a1
    800056ba:	6914                	ld	a3,16(a0)
    800056bc:	6510                	ld	a2,8(a0)
    800056be:	610c                	ld	a1,0(a0)
    800056c0:	34051573          	csrrw	a0,mscratch,a0
    800056c4:	30200073          	mret
	...

00000000800056ca <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800056ca:	1141                	addi	sp,sp,-16
    800056cc:	e422                	sd	s0,8(sp)
    800056ce:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800056d0:	0c0007b7          	lui	a5,0xc000
    800056d4:	4705                	li	a4,1
    800056d6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800056d8:	c3d8                	sw	a4,4(a5)
}
    800056da:	6422                	ld	s0,8(sp)
    800056dc:	0141                	addi	sp,sp,16
    800056de:	8082                	ret

00000000800056e0 <plicinithart>:

void
plicinithart(void)
{
    800056e0:	1141                	addi	sp,sp,-16
    800056e2:	e406                	sd	ra,8(sp)
    800056e4:	e022                	sd	s0,0(sp)
    800056e6:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800056e8:	ffffc097          	auipc	ra,0xffffc
    800056ec:	bc2080e7          	jalr	-1086(ra) # 800012aa <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800056f0:	0085171b          	slliw	a4,a0,0x8
    800056f4:	0c0027b7          	lui	a5,0xc002
    800056f8:	97ba                	add	a5,a5,a4
    800056fa:	40200713          	li	a4,1026
    800056fe:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005702:	00d5151b          	slliw	a0,a0,0xd
    80005706:	0c2017b7          	lui	a5,0xc201
    8000570a:	953e                	add	a0,a0,a5
    8000570c:	00052023          	sw	zero,0(a0)
}
    80005710:	60a2                	ld	ra,8(sp)
    80005712:	6402                	ld	s0,0(sp)
    80005714:	0141                	addi	sp,sp,16
    80005716:	8082                	ret

0000000080005718 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005718:	1141                	addi	sp,sp,-16
    8000571a:	e406                	sd	ra,8(sp)
    8000571c:	e022                	sd	s0,0(sp)
    8000571e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005720:	ffffc097          	auipc	ra,0xffffc
    80005724:	b8a080e7          	jalr	-1142(ra) # 800012aa <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005728:	00d5179b          	slliw	a5,a0,0xd
    8000572c:	0c201537          	lui	a0,0xc201
    80005730:	953e                	add	a0,a0,a5
  return irq;
}
    80005732:	4148                	lw	a0,4(a0)
    80005734:	60a2                	ld	ra,8(sp)
    80005736:	6402                	ld	s0,0(sp)
    80005738:	0141                	addi	sp,sp,16
    8000573a:	8082                	ret

000000008000573c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000573c:	1101                	addi	sp,sp,-32
    8000573e:	ec06                	sd	ra,24(sp)
    80005740:	e822                	sd	s0,16(sp)
    80005742:	e426                	sd	s1,8(sp)
    80005744:	1000                	addi	s0,sp,32
    80005746:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005748:	ffffc097          	auipc	ra,0xffffc
    8000574c:	b62080e7          	jalr	-1182(ra) # 800012aa <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005750:	00d5151b          	slliw	a0,a0,0xd
    80005754:	0c2017b7          	lui	a5,0xc201
    80005758:	97aa                	add	a5,a5,a0
    8000575a:	c3c4                	sw	s1,4(a5)
}
    8000575c:	60e2                	ld	ra,24(sp)
    8000575e:	6442                	ld	s0,16(sp)
    80005760:	64a2                	ld	s1,8(sp)
    80005762:	6105                	addi	sp,sp,32
    80005764:	8082                	ret

0000000080005766 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005766:	1141                	addi	sp,sp,-16
    80005768:	e406                	sd	ra,8(sp)
    8000576a:	e022                	sd	s0,0(sp)
    8000576c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000576e:	479d                	li	a5,7
    80005770:	06a7c963          	blt	a5,a0,800057e2 <free_desc+0x7c>
    panic("free_desc 1");
  if(disk.free[i])
    80005774:	00016797          	auipc	a5,0x16
    80005778:	88c78793          	addi	a5,a5,-1908 # 8001b000 <disk>
    8000577c:	00a78733          	add	a4,a5,a0
    80005780:	6789                	lui	a5,0x2
    80005782:	97ba                	add	a5,a5,a4
    80005784:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80005788:	e7ad                	bnez	a5,800057f2 <free_desc+0x8c>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    8000578a:	00451793          	slli	a5,a0,0x4
    8000578e:	00018717          	auipc	a4,0x18
    80005792:	87270713          	addi	a4,a4,-1934 # 8001d000 <disk+0x2000>
    80005796:	6314                	ld	a3,0(a4)
    80005798:	96be                	add	a3,a3,a5
    8000579a:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    8000579e:	6314                	ld	a3,0(a4)
    800057a0:	96be                	add	a3,a3,a5
    800057a2:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    800057a6:	6314                	ld	a3,0(a4)
    800057a8:	96be                	add	a3,a3,a5
    800057aa:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    800057ae:	6318                	ld	a4,0(a4)
    800057b0:	97ba                	add	a5,a5,a4
    800057b2:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    800057b6:	00016797          	auipc	a5,0x16
    800057ba:	84a78793          	addi	a5,a5,-1974 # 8001b000 <disk>
    800057be:	97aa                	add	a5,a5,a0
    800057c0:	6509                	lui	a0,0x2
    800057c2:	953e                	add	a0,a0,a5
    800057c4:	4785                	li	a5,1
    800057c6:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    800057ca:	00018517          	auipc	a0,0x18
    800057ce:	84e50513          	addi	a0,a0,-1970 # 8001d018 <disk+0x2018>
    800057d2:	ffffc097          	auipc	ra,0xffffc
    800057d6:	34c080e7          	jalr	844(ra) # 80001b1e <wakeup>
}
    800057da:	60a2                	ld	ra,8(sp)
    800057dc:	6402                	ld	s0,0(sp)
    800057de:	0141                	addi	sp,sp,16
    800057e0:	8082                	ret
    panic("free_desc 1");
    800057e2:	00003517          	auipc	a0,0x3
    800057e6:	09e50513          	addi	a0,a0,158 # 80008880 <syscalls+0x418>
    800057ea:	00001097          	auipc	ra,0x1
    800057ee:	c36080e7          	jalr	-970(ra) # 80006420 <panic>
    panic("free_desc 2");
    800057f2:	00003517          	auipc	a0,0x3
    800057f6:	09e50513          	addi	a0,a0,158 # 80008890 <syscalls+0x428>
    800057fa:	00001097          	auipc	ra,0x1
    800057fe:	c26080e7          	jalr	-986(ra) # 80006420 <panic>

0000000080005802 <virtio_disk_init>:
{
    80005802:	1101                	addi	sp,sp,-32
    80005804:	ec06                	sd	ra,24(sp)
    80005806:	e822                	sd	s0,16(sp)
    80005808:	e426                	sd	s1,8(sp)
    8000580a:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    8000580c:	00003597          	auipc	a1,0x3
    80005810:	09458593          	addi	a1,a1,148 # 800088a0 <syscalls+0x438>
    80005814:	00018517          	auipc	a0,0x18
    80005818:	91450513          	addi	a0,a0,-1772 # 8001d128 <disk+0x2128>
    8000581c:	00001097          	auipc	ra,0x1
    80005820:	0be080e7          	jalr	190(ra) # 800068da <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005824:	100017b7          	lui	a5,0x10001
    80005828:	4398                	lw	a4,0(a5)
    8000582a:	2701                	sext.w	a4,a4
    8000582c:	747277b7          	lui	a5,0x74727
    80005830:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005834:	0ef71163          	bne	a4,a5,80005916 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005838:	100017b7          	lui	a5,0x10001
    8000583c:	43dc                	lw	a5,4(a5)
    8000583e:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005840:	4705                	li	a4,1
    80005842:	0ce79a63          	bne	a5,a4,80005916 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005846:	100017b7          	lui	a5,0x10001
    8000584a:	479c                	lw	a5,8(a5)
    8000584c:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    8000584e:	4709                	li	a4,2
    80005850:	0ce79363          	bne	a5,a4,80005916 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005854:	100017b7          	lui	a5,0x10001
    80005858:	47d8                	lw	a4,12(a5)
    8000585a:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000585c:	554d47b7          	lui	a5,0x554d4
    80005860:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005864:	0af71963          	bne	a4,a5,80005916 <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005868:	100017b7          	lui	a5,0x10001
    8000586c:	4705                	li	a4,1
    8000586e:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005870:	470d                	li	a4,3
    80005872:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005874:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005876:	c7ffe737          	lui	a4,0xc7ffe
    8000587a:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd851f>
    8000587e:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005880:	2701                	sext.w	a4,a4
    80005882:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005884:	472d                	li	a4,11
    80005886:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005888:	473d                	li	a4,15
    8000588a:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    8000588c:	6705                	lui	a4,0x1
    8000588e:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005890:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005894:	5bdc                	lw	a5,52(a5)
    80005896:	2781                	sext.w	a5,a5
  if(max == 0)
    80005898:	c7d9                	beqz	a5,80005926 <virtio_disk_init+0x124>
  if(max < NUM)
    8000589a:	471d                	li	a4,7
    8000589c:	08f77d63          	bgeu	a4,a5,80005936 <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800058a0:	100014b7          	lui	s1,0x10001
    800058a4:	47a1                	li	a5,8
    800058a6:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    800058a8:	6609                	lui	a2,0x2
    800058aa:	4581                	li	a1,0
    800058ac:	00015517          	auipc	a0,0x15
    800058b0:	75450513          	addi	a0,a0,1876 # 8001b000 <disk>
    800058b4:	ffffb097          	auipc	ra,0xffffb
    800058b8:	8c4080e7          	jalr	-1852(ra) # 80000178 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    800058bc:	00015717          	auipc	a4,0x15
    800058c0:	74470713          	addi	a4,a4,1860 # 8001b000 <disk>
    800058c4:	00c75793          	srli	a5,a4,0xc
    800058c8:	2781                	sext.w	a5,a5
    800058ca:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    800058cc:	00017797          	auipc	a5,0x17
    800058d0:	73478793          	addi	a5,a5,1844 # 8001d000 <disk+0x2000>
    800058d4:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    800058d6:	00015717          	auipc	a4,0x15
    800058da:	7aa70713          	addi	a4,a4,1962 # 8001b080 <disk+0x80>
    800058de:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    800058e0:	00016717          	auipc	a4,0x16
    800058e4:	72070713          	addi	a4,a4,1824 # 8001c000 <disk+0x1000>
    800058e8:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    800058ea:	4705                	li	a4,1
    800058ec:	00e78c23          	sb	a4,24(a5)
    800058f0:	00e78ca3          	sb	a4,25(a5)
    800058f4:	00e78d23          	sb	a4,26(a5)
    800058f8:	00e78da3          	sb	a4,27(a5)
    800058fc:	00e78e23          	sb	a4,28(a5)
    80005900:	00e78ea3          	sb	a4,29(a5)
    80005904:	00e78f23          	sb	a4,30(a5)
    80005908:	00e78fa3          	sb	a4,31(a5)
}
    8000590c:	60e2                	ld	ra,24(sp)
    8000590e:	6442                	ld	s0,16(sp)
    80005910:	64a2                	ld	s1,8(sp)
    80005912:	6105                	addi	sp,sp,32
    80005914:	8082                	ret
    panic("could not find virtio disk");
    80005916:	00003517          	auipc	a0,0x3
    8000591a:	f9a50513          	addi	a0,a0,-102 # 800088b0 <syscalls+0x448>
    8000591e:	00001097          	auipc	ra,0x1
    80005922:	b02080e7          	jalr	-1278(ra) # 80006420 <panic>
    panic("virtio disk has no queue 0");
    80005926:	00003517          	auipc	a0,0x3
    8000592a:	faa50513          	addi	a0,a0,-86 # 800088d0 <syscalls+0x468>
    8000592e:	00001097          	auipc	ra,0x1
    80005932:	af2080e7          	jalr	-1294(ra) # 80006420 <panic>
    panic("virtio disk max queue too short");
    80005936:	00003517          	auipc	a0,0x3
    8000593a:	fba50513          	addi	a0,a0,-70 # 800088f0 <syscalls+0x488>
    8000593e:	00001097          	auipc	ra,0x1
    80005942:	ae2080e7          	jalr	-1310(ra) # 80006420 <panic>

0000000080005946 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005946:	7159                	addi	sp,sp,-112
    80005948:	f486                	sd	ra,104(sp)
    8000594a:	f0a2                	sd	s0,96(sp)
    8000594c:	eca6                	sd	s1,88(sp)
    8000594e:	e8ca                	sd	s2,80(sp)
    80005950:	e4ce                	sd	s3,72(sp)
    80005952:	e0d2                	sd	s4,64(sp)
    80005954:	fc56                	sd	s5,56(sp)
    80005956:	f85a                	sd	s6,48(sp)
    80005958:	f45e                	sd	s7,40(sp)
    8000595a:	f062                	sd	s8,32(sp)
    8000595c:	ec66                	sd	s9,24(sp)
    8000595e:	e86a                	sd	s10,16(sp)
    80005960:	1880                	addi	s0,sp,112
    80005962:	892a                	mv	s2,a0
    80005964:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005966:	00c52c83          	lw	s9,12(a0)
    8000596a:	001c9c9b          	slliw	s9,s9,0x1
    8000596e:	1c82                	slli	s9,s9,0x20
    80005970:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005974:	00017517          	auipc	a0,0x17
    80005978:	7b450513          	addi	a0,a0,1972 # 8001d128 <disk+0x2128>
    8000597c:	00001097          	auipc	ra,0x1
    80005980:	fee080e7          	jalr	-18(ra) # 8000696a <acquire>
  for(int i = 0; i < 3; i++){
    80005984:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005986:	4c21                	li	s8,8
      disk.free[i] = 0;
    80005988:	00015b97          	auipc	s7,0x15
    8000598c:	678b8b93          	addi	s7,s7,1656 # 8001b000 <disk>
    80005990:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    80005992:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    80005994:	8a4e                	mv	s4,s3
    80005996:	a051                	j	80005a1a <virtio_disk_rw+0xd4>
      disk.free[i] = 0;
    80005998:	00fb86b3          	add	a3,s7,a5
    8000599c:	96da                	add	a3,a3,s6
    8000599e:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    800059a2:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    800059a4:	0207c563          	bltz	a5,800059ce <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    800059a8:	2485                	addiw	s1,s1,1
    800059aa:	0711                	addi	a4,a4,4
    800059ac:	25548063          	beq	s1,s5,80005bec <virtio_disk_rw+0x2a6>
    idx[i] = alloc_desc();
    800059b0:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    800059b2:	00017697          	auipc	a3,0x17
    800059b6:	66668693          	addi	a3,a3,1638 # 8001d018 <disk+0x2018>
    800059ba:	87d2                	mv	a5,s4
    if(disk.free[i]){
    800059bc:	0006c583          	lbu	a1,0(a3)
    800059c0:	fde1                	bnez	a1,80005998 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    800059c2:	2785                	addiw	a5,a5,1
    800059c4:	0685                	addi	a3,a3,1
    800059c6:	ff879be3          	bne	a5,s8,800059bc <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    800059ca:	57fd                	li	a5,-1
    800059cc:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    800059ce:	02905a63          	blez	s1,80005a02 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    800059d2:	f9042503          	lw	a0,-112(s0)
    800059d6:	00000097          	auipc	ra,0x0
    800059da:	d90080e7          	jalr	-624(ra) # 80005766 <free_desc>
      for(int j = 0; j < i; j++)
    800059de:	4785                	li	a5,1
    800059e0:	0297d163          	bge	a5,s1,80005a02 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    800059e4:	f9442503          	lw	a0,-108(s0)
    800059e8:	00000097          	auipc	ra,0x0
    800059ec:	d7e080e7          	jalr	-642(ra) # 80005766 <free_desc>
      for(int j = 0; j < i; j++)
    800059f0:	4789                	li	a5,2
    800059f2:	0097d863          	bge	a5,s1,80005a02 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    800059f6:	f9842503          	lw	a0,-104(s0)
    800059fa:	00000097          	auipc	ra,0x0
    800059fe:	d6c080e7          	jalr	-660(ra) # 80005766 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005a02:	00017597          	auipc	a1,0x17
    80005a06:	72658593          	addi	a1,a1,1830 # 8001d128 <disk+0x2128>
    80005a0a:	00017517          	auipc	a0,0x17
    80005a0e:	60e50513          	addi	a0,a0,1550 # 8001d018 <disk+0x2018>
    80005a12:	ffffc097          	auipc	ra,0xffffc
    80005a16:	f80080e7          	jalr	-128(ra) # 80001992 <sleep>
  for(int i = 0; i < 3; i++){
    80005a1a:	f9040713          	addi	a4,s0,-112
    80005a1e:	84ce                	mv	s1,s3
    80005a20:	bf41                	j	800059b0 <virtio_disk_rw+0x6a>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    80005a22:	20058713          	addi	a4,a1,512
    80005a26:	00471693          	slli	a3,a4,0x4
    80005a2a:	00015717          	auipc	a4,0x15
    80005a2e:	5d670713          	addi	a4,a4,1494 # 8001b000 <disk>
    80005a32:	9736                	add	a4,a4,a3
    80005a34:	4685                	li	a3,1
    80005a36:	0ad72423          	sw	a3,168(a4)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80005a3a:	20058713          	addi	a4,a1,512
    80005a3e:	00471693          	slli	a3,a4,0x4
    80005a42:	00015717          	auipc	a4,0x15
    80005a46:	5be70713          	addi	a4,a4,1470 # 8001b000 <disk>
    80005a4a:	9736                	add	a4,a4,a3
    80005a4c:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    80005a50:	0b973823          	sd	s9,176(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005a54:	7679                	lui	a2,0xffffe
    80005a56:	963e                	add	a2,a2,a5
    80005a58:	00017697          	auipc	a3,0x17
    80005a5c:	5a868693          	addi	a3,a3,1448 # 8001d000 <disk+0x2000>
    80005a60:	6298                	ld	a4,0(a3)
    80005a62:	9732                	add	a4,a4,a2
    80005a64:	e308                	sd	a0,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005a66:	6298                	ld	a4,0(a3)
    80005a68:	9732                	add	a4,a4,a2
    80005a6a:	4541                	li	a0,16
    80005a6c:	c708                	sw	a0,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005a6e:	6298                	ld	a4,0(a3)
    80005a70:	9732                	add	a4,a4,a2
    80005a72:	4505                	li	a0,1
    80005a74:	00a71623          	sh	a0,12(a4)
  disk.desc[idx[0]].next = idx[1];
    80005a78:	f9442703          	lw	a4,-108(s0)
    80005a7c:	6288                	ld	a0,0(a3)
    80005a7e:	962a                	add	a2,a2,a0
    80005a80:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffd7dce>

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005a84:	0712                	slli	a4,a4,0x4
    80005a86:	6290                	ld	a2,0(a3)
    80005a88:	963a                	add	a2,a2,a4
    80005a8a:	05890513          	addi	a0,s2,88
    80005a8e:	e208                	sd	a0,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005a90:	6294                	ld	a3,0(a3)
    80005a92:	96ba                	add	a3,a3,a4
    80005a94:	40000613          	li	a2,1024
    80005a98:	c690                	sw	a2,8(a3)
  if(write)
    80005a9a:	140d0063          	beqz	s10,80005bda <virtio_disk_rw+0x294>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    80005a9e:	00017697          	auipc	a3,0x17
    80005aa2:	5626b683          	ld	a3,1378(a3) # 8001d000 <disk+0x2000>
    80005aa6:	96ba                	add	a3,a3,a4
    80005aa8:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005aac:	00015817          	auipc	a6,0x15
    80005ab0:	55480813          	addi	a6,a6,1364 # 8001b000 <disk>
    80005ab4:	00017517          	auipc	a0,0x17
    80005ab8:	54c50513          	addi	a0,a0,1356 # 8001d000 <disk+0x2000>
    80005abc:	6114                	ld	a3,0(a0)
    80005abe:	96ba                	add	a3,a3,a4
    80005ac0:	00c6d603          	lhu	a2,12(a3)
    80005ac4:	00166613          	ori	a2,a2,1
    80005ac8:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    80005acc:	f9842683          	lw	a3,-104(s0)
    80005ad0:	6110                	ld	a2,0(a0)
    80005ad2:	9732                	add	a4,a4,a2
    80005ad4:	00d71723          	sh	a3,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005ad8:	20058613          	addi	a2,a1,512
    80005adc:	0612                	slli	a2,a2,0x4
    80005ade:	9642                	add	a2,a2,a6
    80005ae0:	577d                	li	a4,-1
    80005ae2:	02e60823          	sb	a4,48(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005ae6:	00469713          	slli	a4,a3,0x4
    80005aea:	6114                	ld	a3,0(a0)
    80005aec:	96ba                	add	a3,a3,a4
    80005aee:	03078793          	addi	a5,a5,48
    80005af2:	97c2                	add	a5,a5,a6
    80005af4:	e29c                	sd	a5,0(a3)
  disk.desc[idx[2]].len = 1;
    80005af6:	611c                	ld	a5,0(a0)
    80005af8:	97ba                	add	a5,a5,a4
    80005afa:	4685                	li	a3,1
    80005afc:	c794                	sw	a3,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005afe:	611c                	ld	a5,0(a0)
    80005b00:	97ba                	add	a5,a5,a4
    80005b02:	4809                	li	a6,2
    80005b04:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    80005b08:	611c                	ld	a5,0(a0)
    80005b0a:	973e                	add	a4,a4,a5
    80005b0c:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005b10:	00d92223          	sw	a3,4(s2)
  disk.info[idx[0]].b = b;
    80005b14:	03263423          	sd	s2,40(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005b18:	6518                	ld	a4,8(a0)
    80005b1a:	00275783          	lhu	a5,2(a4)
    80005b1e:	8b9d                	andi	a5,a5,7
    80005b20:	0786                	slli	a5,a5,0x1
    80005b22:	97ba                	add	a5,a5,a4
    80005b24:	00b79223          	sh	a1,4(a5)

  __sync_synchronize();
    80005b28:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005b2c:	6518                	ld	a4,8(a0)
    80005b2e:	00275783          	lhu	a5,2(a4)
    80005b32:	2785                	addiw	a5,a5,1
    80005b34:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005b38:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005b3c:	100017b7          	lui	a5,0x10001
    80005b40:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005b44:	00492703          	lw	a4,4(s2)
    80005b48:	4785                	li	a5,1
    80005b4a:	02f71163          	bne	a4,a5,80005b6c <virtio_disk_rw+0x226>
    sleep(b, &disk.vdisk_lock);
    80005b4e:	00017997          	auipc	s3,0x17
    80005b52:	5da98993          	addi	s3,s3,1498 # 8001d128 <disk+0x2128>
  while(b->disk == 1) {
    80005b56:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80005b58:	85ce                	mv	a1,s3
    80005b5a:	854a                	mv	a0,s2
    80005b5c:	ffffc097          	auipc	ra,0xffffc
    80005b60:	e36080e7          	jalr	-458(ra) # 80001992 <sleep>
  while(b->disk == 1) {
    80005b64:	00492783          	lw	a5,4(s2)
    80005b68:	fe9788e3          	beq	a5,s1,80005b58 <virtio_disk_rw+0x212>
  }

  disk.info[idx[0]].b = 0;
    80005b6c:	f9042903          	lw	s2,-112(s0)
    80005b70:	20090793          	addi	a5,s2,512
    80005b74:	00479713          	slli	a4,a5,0x4
    80005b78:	00015797          	auipc	a5,0x15
    80005b7c:	48878793          	addi	a5,a5,1160 # 8001b000 <disk>
    80005b80:	97ba                	add	a5,a5,a4
    80005b82:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    80005b86:	00017997          	auipc	s3,0x17
    80005b8a:	47a98993          	addi	s3,s3,1146 # 8001d000 <disk+0x2000>
    80005b8e:	00491713          	slli	a4,s2,0x4
    80005b92:	0009b783          	ld	a5,0(s3)
    80005b96:	97ba                	add	a5,a5,a4
    80005b98:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005b9c:	854a                	mv	a0,s2
    80005b9e:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005ba2:	00000097          	auipc	ra,0x0
    80005ba6:	bc4080e7          	jalr	-1084(ra) # 80005766 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005baa:	8885                	andi	s1,s1,1
    80005bac:	f0ed                	bnez	s1,80005b8e <virtio_disk_rw+0x248>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005bae:	00017517          	auipc	a0,0x17
    80005bb2:	57a50513          	addi	a0,a0,1402 # 8001d128 <disk+0x2128>
    80005bb6:	00001097          	auipc	ra,0x1
    80005bba:	e68080e7          	jalr	-408(ra) # 80006a1e <release>
}
    80005bbe:	70a6                	ld	ra,104(sp)
    80005bc0:	7406                	ld	s0,96(sp)
    80005bc2:	64e6                	ld	s1,88(sp)
    80005bc4:	6946                	ld	s2,80(sp)
    80005bc6:	69a6                	ld	s3,72(sp)
    80005bc8:	6a06                	ld	s4,64(sp)
    80005bca:	7ae2                	ld	s5,56(sp)
    80005bcc:	7b42                	ld	s6,48(sp)
    80005bce:	7ba2                	ld	s7,40(sp)
    80005bd0:	7c02                	ld	s8,32(sp)
    80005bd2:	6ce2                	ld	s9,24(sp)
    80005bd4:	6d42                	ld	s10,16(sp)
    80005bd6:	6165                	addi	sp,sp,112
    80005bd8:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    80005bda:	00017697          	auipc	a3,0x17
    80005bde:	4266b683          	ld	a3,1062(a3) # 8001d000 <disk+0x2000>
    80005be2:	96ba                	add	a3,a3,a4
    80005be4:	4609                	li	a2,2
    80005be6:	00c69623          	sh	a2,12(a3)
    80005bea:	b5c9                	j	80005aac <virtio_disk_rw+0x166>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005bec:	f9042583          	lw	a1,-112(s0)
    80005bf0:	20058793          	addi	a5,a1,512
    80005bf4:	0792                	slli	a5,a5,0x4
    80005bf6:	00015517          	auipc	a0,0x15
    80005bfa:	4b250513          	addi	a0,a0,1202 # 8001b0a8 <disk+0xa8>
    80005bfe:	953e                	add	a0,a0,a5
  if(write)
    80005c00:	e20d11e3          	bnez	s10,80005a22 <virtio_disk_rw+0xdc>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    80005c04:	20058713          	addi	a4,a1,512
    80005c08:	00471693          	slli	a3,a4,0x4
    80005c0c:	00015717          	auipc	a4,0x15
    80005c10:	3f470713          	addi	a4,a4,1012 # 8001b000 <disk>
    80005c14:	9736                	add	a4,a4,a3
    80005c16:	0a072423          	sw	zero,168(a4)
    80005c1a:	b505                	j	80005a3a <virtio_disk_rw+0xf4>

0000000080005c1c <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005c1c:	1101                	addi	sp,sp,-32
    80005c1e:	ec06                	sd	ra,24(sp)
    80005c20:	e822                	sd	s0,16(sp)
    80005c22:	e426                	sd	s1,8(sp)
    80005c24:	e04a                	sd	s2,0(sp)
    80005c26:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005c28:	00017517          	auipc	a0,0x17
    80005c2c:	50050513          	addi	a0,a0,1280 # 8001d128 <disk+0x2128>
    80005c30:	00001097          	auipc	ra,0x1
    80005c34:	d3a080e7          	jalr	-710(ra) # 8000696a <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005c38:	10001737          	lui	a4,0x10001
    80005c3c:	533c                	lw	a5,96(a4)
    80005c3e:	8b8d                	andi	a5,a5,3
    80005c40:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80005c42:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005c46:	00017797          	auipc	a5,0x17
    80005c4a:	3ba78793          	addi	a5,a5,954 # 8001d000 <disk+0x2000>
    80005c4e:	6b94                	ld	a3,16(a5)
    80005c50:	0207d703          	lhu	a4,32(a5)
    80005c54:	0026d783          	lhu	a5,2(a3)
    80005c58:	06f70163          	beq	a4,a5,80005cba <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005c5c:	00015917          	auipc	s2,0x15
    80005c60:	3a490913          	addi	s2,s2,932 # 8001b000 <disk>
    80005c64:	00017497          	auipc	s1,0x17
    80005c68:	39c48493          	addi	s1,s1,924 # 8001d000 <disk+0x2000>
    __sync_synchronize();
    80005c6c:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005c70:	6898                	ld	a4,16(s1)
    80005c72:	0204d783          	lhu	a5,32(s1)
    80005c76:	8b9d                	andi	a5,a5,7
    80005c78:	078e                	slli	a5,a5,0x3
    80005c7a:	97ba                	add	a5,a5,a4
    80005c7c:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005c7e:	20078713          	addi	a4,a5,512
    80005c82:	0712                	slli	a4,a4,0x4
    80005c84:	974a                	add	a4,a4,s2
    80005c86:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    80005c8a:	e731                	bnez	a4,80005cd6 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005c8c:	20078793          	addi	a5,a5,512
    80005c90:	0792                	slli	a5,a5,0x4
    80005c92:	97ca                	add	a5,a5,s2
    80005c94:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    80005c96:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005c9a:	ffffc097          	auipc	ra,0xffffc
    80005c9e:	e84080e7          	jalr	-380(ra) # 80001b1e <wakeup>

    disk.used_idx += 1;
    80005ca2:	0204d783          	lhu	a5,32(s1)
    80005ca6:	2785                	addiw	a5,a5,1
    80005ca8:	17c2                	slli	a5,a5,0x30
    80005caa:	93c1                	srli	a5,a5,0x30
    80005cac:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005cb0:	6898                	ld	a4,16(s1)
    80005cb2:	00275703          	lhu	a4,2(a4)
    80005cb6:	faf71be3          	bne	a4,a5,80005c6c <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    80005cba:	00017517          	auipc	a0,0x17
    80005cbe:	46e50513          	addi	a0,a0,1134 # 8001d128 <disk+0x2128>
    80005cc2:	00001097          	auipc	ra,0x1
    80005cc6:	d5c080e7          	jalr	-676(ra) # 80006a1e <release>
}
    80005cca:	60e2                	ld	ra,24(sp)
    80005ccc:	6442                	ld	s0,16(sp)
    80005cce:	64a2                	ld	s1,8(sp)
    80005cd0:	6902                	ld	s2,0(sp)
    80005cd2:	6105                	addi	sp,sp,32
    80005cd4:	8082                	ret
      panic("virtio_disk_intr status");
    80005cd6:	00003517          	auipc	a0,0x3
    80005cda:	c3a50513          	addi	a0,a0,-966 # 80008910 <syscalls+0x4a8>
    80005cde:	00000097          	auipc	ra,0x0
    80005ce2:	742080e7          	jalr	1858(ra) # 80006420 <panic>

0000000080005ce6 <swap_page_from_pte>:
/* NTU OS 2024 */
/* Allocate eight consecutive disk blocks. */
/* Save the content of the physical page in the pte */
/* to the disk blocks and save the block-id into the */
/* pte. */
char *swap_page_from_pte(pte_t *pte) {
    80005ce6:	7179                	addi	sp,sp,-48
    80005ce8:	f406                	sd	ra,40(sp)
    80005cea:	f022                	sd	s0,32(sp)
    80005cec:	ec26                	sd	s1,24(sp)
    80005cee:	e84a                	sd	s2,16(sp)
    80005cf0:	e44e                	sd	s3,8(sp)
    80005cf2:	1800                	addi	s0,sp,48
    80005cf4:	89aa                	mv	s3,a0
  char *pa = (char*) PTE2PA(*pte);
    80005cf6:	00053903          	ld	s2,0(a0)
    80005cfa:	00a95913          	srli	s2,s2,0xa
    80005cfe:	0932                	slli	s2,s2,0xc
  uint dp = balloc_page(ROOTDEV);
    80005d00:	4505                	li	a0,1
    80005d02:	ffffe097          	auipc	ra,0xffffe
    80005d06:	ab6080e7          	jalr	-1354(ra) # 800037b8 <balloc_page>
    80005d0a:	0005049b          	sext.w	s1,a0

  write_page_to_disk(ROOTDEV, pa, dp); // write this page to disk
    80005d0e:	8626                	mv	a2,s1
    80005d10:	85ca                	mv	a1,s2
    80005d12:	4505                	li	a0,1
    80005d14:	ffffd097          	auipc	ra,0xffffd
    80005d18:	c66080e7          	jalr	-922(ra) # 8000297a <write_page_to_disk>
  *pte = (BLOCKNO2PTE(dp) | PTE_FLAGS(*pte) | PTE_S) & ~PTE_V;
    80005d1c:	0009b783          	ld	a5,0(s3)
    80005d20:	00a4949b          	slliw	s1,s1,0xa
    80005d24:	1482                	slli	s1,s1,0x20
    80005d26:	9081                	srli	s1,s1,0x20
    80005d28:	1fe7f793          	andi	a5,a5,510
    80005d2c:	8cdd                	or	s1,s1,a5
    80005d2e:	2004e493          	ori	s1,s1,512
    80005d32:	0099b023          	sd	s1,0(s3)

  return pa;
}
    80005d36:	854a                	mv	a0,s2
    80005d38:	70a2                	ld	ra,40(sp)
    80005d3a:	7402                	ld	s0,32(sp)
    80005d3c:	64e2                	ld	s1,24(sp)
    80005d3e:	6942                	ld	s2,16(sp)
    80005d40:	69a2                	ld	s3,8(sp)
    80005d42:	6145                	addi	sp,sp,48
    80005d44:	8082                	ret

0000000080005d46 <handle_pgfault>:

/* NTU OS 2024 */
/* Page fault handler */
int handle_pgfault() {
    80005d46:	7179                	addi	sp,sp,-48
    80005d48:	f406                	sd	ra,40(sp)
    80005d4a:	f022                	sd	s0,32(sp)
    80005d4c:	ec26                	sd	s1,24(sp)
    80005d4e:	e84a                	sd	s2,16(sp)
    80005d50:	e44e                	sd	s3,8(sp)
    80005d52:	1800                	addi	s0,sp,48
    80005d54:	143029f3          	csrr	s3,stval
  /* Find the address that caused the fault */
  uint64 va = r_stval();
  struct proc *p = myproc();
    80005d58:	ffffb097          	auipc	ra,0xffffb
    80005d5c:	57e080e7          	jalr	1406(ra) # 800012d6 <myproc>
  pagetable_t pagetable = p->pagetable;
    80005d60:	05053903          	ld	s2,80(a0)
  // pte_t *pte = walk(pagetable, PGROUNDDOWN(va), 0); ???

  char *pa = kalloc();
    80005d64:	ffffa097          	auipc	ra,0xffffa
    80005d68:	3b4080e7          	jalr	948(ra) # 80000118 <kalloc>
    80005d6c:	84aa                	mv	s1,a0
  memset(pa, 0, PGSIZE);
    80005d6e:	6605                	lui	a2,0x1
    80005d70:	4581                	li	a1,0
    80005d72:	ffffa097          	auipc	ra,0xffffa
    80005d76:	406080e7          	jalr	1030(ra) # 80000178 <memset>
  if(mappages(pagetable, PGROUNDDOWN(va), PGSIZE, (uint64)pa, PTE_U | PTE_R | PTE_W | PTE_X) != 0)
    80005d7a:	4779                	li	a4,30
    80005d7c:	86a6                	mv	a3,s1
    80005d7e:	6605                	lui	a2,0x1
    80005d80:	75fd                	lui	a1,0xfffff
    80005d82:	00b9f5b3          	and	a1,s3,a1
    80005d86:	854a                	mv	a0,s2
    80005d88:	ffffa097          	auipc	ra,0xffffa
    80005d8c:	7c0080e7          	jalr	1984(ra) # 80000548 <mappages>
    80005d90:	e901                	bnez	a0,80005da0 <handle_pgfault+0x5a>
    kfree(pa);
}
    80005d92:	70a2                	ld	ra,40(sp)
    80005d94:	7402                	ld	s0,32(sp)
    80005d96:	64e2                	ld	s1,24(sp)
    80005d98:	6942                	ld	s2,16(sp)
    80005d9a:	69a2                	ld	s3,8(sp)
    80005d9c:	6145                	addi	sp,sp,48
    80005d9e:	8082                	ret
    kfree(pa);
    80005da0:	8526                	mv	a0,s1
    80005da2:	ffffa097          	auipc	ra,0xffffa
    80005da6:	27a080e7          	jalr	634(ra) # 8000001c <kfree>
    80005daa:	b7e5                	j	80005d92 <handle_pgfault+0x4c>

0000000080005dac <sys_vmprint>:

/* NTU OS 2024 */
/* Entry of vmprint() syscall. */
uint64
sys_vmprint(void)
{
    80005dac:	1141                	addi	sp,sp,-16
    80005dae:	e406                	sd	ra,8(sp)
    80005db0:	e022                	sd	s0,0(sp)
    80005db2:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80005db4:	ffffb097          	auipc	ra,0xffffb
    80005db8:	522080e7          	jalr	1314(ra) # 800012d6 <myproc>
  vmprint(p->pagetable);
    80005dbc:	6928                	ld	a0,80(a0)
    80005dbe:	ffffb097          	auipc	ra,0xffffb
    80005dc2:	36c080e7          	jalr	876(ra) # 8000112a <vmprint>
  return 0;
}
    80005dc6:	4501                	li	a0,0
    80005dc8:	60a2                	ld	ra,8(sp)
    80005dca:	6402                	ld	s0,0(sp)
    80005dcc:	0141                	addi	sp,sp,16
    80005dce:	8082                	ret

0000000080005dd0 <sys_madvise>:

/* NTU OS 2024 */
/* Entry of madvise() syscall. */
uint64
sys_madvise(void)
{
    80005dd0:	1101                	addi	sp,sp,-32
    80005dd2:	ec06                	sd	ra,24(sp)
    80005dd4:	e822                	sd	s0,16(sp)
    80005dd6:	1000                	addi	s0,sp,32

  uint64 addr;
  int length;
  int advise;

  if (argaddr(0, &addr) < 0) return -1;
    80005dd8:	fe840593          	addi	a1,s0,-24
    80005ddc:	4501                	li	a0,0
    80005dde:	ffffc097          	auipc	ra,0xffffc
    80005de2:	5da080e7          	jalr	1498(ra) # 800023b8 <argaddr>
    80005de6:	57fd                	li	a5,-1
    80005de8:	04054163          	bltz	a0,80005e2a <sys_madvise+0x5a>
  if (argint(1, &length) < 0) return -1;
    80005dec:	fe440593          	addi	a1,s0,-28
    80005df0:	4505                	li	a0,1
    80005df2:	ffffc097          	auipc	ra,0xffffc
    80005df6:	5a4080e7          	jalr	1444(ra) # 80002396 <argint>
    80005dfa:	57fd                	li	a5,-1
    80005dfc:	02054763          	bltz	a0,80005e2a <sys_madvise+0x5a>
  if (argint(2, &advise) < 0) return -1;
    80005e00:	fe040593          	addi	a1,s0,-32
    80005e04:	4509                	li	a0,2
    80005e06:	ffffc097          	auipc	ra,0xffffc
    80005e0a:	590080e7          	jalr	1424(ra) # 80002396 <argint>
    80005e0e:	57fd                	li	a5,-1
    80005e10:	00054d63          	bltz	a0,80005e2a <sys_madvise+0x5a>

  int ret = madvise(addr, length, advise);
    80005e14:	fe042603          	lw	a2,-32(s0)
    80005e18:	fe442583          	lw	a1,-28(s0)
    80005e1c:	fe843503          	ld	a0,-24(s0)
    80005e20:	ffffb097          	auipc	ra,0xffffb
    80005e24:	eae080e7          	jalr	-338(ra) # 80000cce <madvise>
  return ret;
    80005e28:	87aa                	mv	a5,a0
}
    80005e2a:	853e                	mv	a0,a5
    80005e2c:	60e2                	ld	ra,24(sp)
    80005e2e:	6442                	ld	s0,16(sp)
    80005e30:	6105                	addi	sp,sp,32
    80005e32:	8082                	ret

0000000080005e34 <sys_pgprint>:
#if defined(PG_REPLACEMENT_USE_FIFO) || defined(PG_REPLACEMENT_USE_LRU)
/* NTU OS 2024 */
/* Entry of pgprint() syscall. */
uint64
sys_pgprint(void)
{
    80005e34:	1141                	addi	sp,sp,-16
    80005e36:	e406                	sd	ra,8(sp)
    80005e38:	e022                	sd	s0,0(sp)
    80005e3a:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80005e3c:	ffffb097          	auipc	ra,0xffffb
    80005e40:	49a080e7          	jalr	1178(ra) # 800012d6 <myproc>
  pgprint();
    80005e44:	ffffb097          	auipc	ra,0xffffb
    80005e48:	006080e7          	jalr	6(ra) # 80000e4a <pgprint>
  return 0;
}
    80005e4c:	4501                	li	a0,0
    80005e4e:	60a2                	ld	ra,8(sp)
    80005e50:	6402                	ld	s0,0(sp)
    80005e52:	0141                	addi	sp,sp,16
    80005e54:	8082                	ret

0000000080005e56 <q_init>:
#include "riscv.h"
#include "spinlock.h"
#include "defs.h"
#include "proc.h"

void q_init(queue_t *q){
    80005e56:	1141                	addi	sp,sp,-16
    80005e58:	e406                	sd	ra,8(sp)
    80005e5a:	e022                	sd	s0,0(sp)
    80005e5c:	0800                	addi	s0,sp,16
	panic("Not implemented yet\n");
    80005e5e:	00003517          	auipc	a0,0x3
    80005e62:	aca50513          	addi	a0,a0,-1334 # 80008928 <syscalls+0x4c0>
    80005e66:	00000097          	auipc	ra,0x0
    80005e6a:	5ba080e7          	jalr	1466(ra) # 80006420 <panic>

0000000080005e6e <q_push>:
}

int q_push(queue_t *q, uint64 e){
    80005e6e:	1141                	addi	sp,sp,-16
    80005e70:	e406                	sd	ra,8(sp)
    80005e72:	e022                	sd	s0,0(sp)
    80005e74:	0800                	addi	s0,sp,16
	panic("Not implemented yet\n");
    80005e76:	00003517          	auipc	a0,0x3
    80005e7a:	ab250513          	addi	a0,a0,-1358 # 80008928 <syscalls+0x4c0>
    80005e7e:	00000097          	auipc	ra,0x0
    80005e82:	5a2080e7          	jalr	1442(ra) # 80006420 <panic>

0000000080005e86 <q_pop_idx>:
}

uint64 q_pop_idx(queue_t *q, int idx){
    80005e86:	1141                	addi	sp,sp,-16
    80005e88:	e406                	sd	ra,8(sp)
    80005e8a:	e022                	sd	s0,0(sp)
    80005e8c:	0800                	addi	s0,sp,16
	panic("Not implemented yet\n");
    80005e8e:	00003517          	auipc	a0,0x3
    80005e92:	a9a50513          	addi	a0,a0,-1382 # 80008928 <syscalls+0x4c0>
    80005e96:	00000097          	auipc	ra,0x0
    80005e9a:	58a080e7          	jalr	1418(ra) # 80006420 <panic>

0000000080005e9e <q_empty>:
}

int q_empty(queue_t *q){
    80005e9e:	1141                	addi	sp,sp,-16
    80005ea0:	e406                	sd	ra,8(sp)
    80005ea2:	e022                	sd	s0,0(sp)
    80005ea4:	0800                	addi	s0,sp,16
	panic("Not implemented yet\n");
    80005ea6:	00003517          	auipc	a0,0x3
    80005eaa:	a8250513          	addi	a0,a0,-1406 # 80008928 <syscalls+0x4c0>
    80005eae:	00000097          	auipc	ra,0x0
    80005eb2:	572080e7          	jalr	1394(ra) # 80006420 <panic>

0000000080005eb6 <q_full>:
}

int q_full(queue_t *q){
    80005eb6:	1141                	addi	sp,sp,-16
    80005eb8:	e406                	sd	ra,8(sp)
    80005eba:	e022                	sd	s0,0(sp)
    80005ebc:	0800                	addi	s0,sp,16
	panic("Not implemented yet\n");
    80005ebe:	00003517          	auipc	a0,0x3
    80005ec2:	a6a50513          	addi	a0,a0,-1430 # 80008928 <syscalls+0x4c0>
    80005ec6:	00000097          	auipc	ra,0x0
    80005eca:	55a080e7          	jalr	1370(ra) # 80006420 <panic>

0000000080005ece <q_clear>:
}

int q_clear(queue_t *q){
    80005ece:	1141                	addi	sp,sp,-16
    80005ed0:	e406                	sd	ra,8(sp)
    80005ed2:	e022                	sd	s0,0(sp)
    80005ed4:	0800                	addi	s0,sp,16
	panic("Not implemented yet\n");
    80005ed6:	00003517          	auipc	a0,0x3
    80005eda:	a5250513          	addi	a0,a0,-1454 # 80008928 <syscalls+0x4c0>
    80005ede:	00000097          	auipc	ra,0x0
    80005ee2:	542080e7          	jalr	1346(ra) # 80006420 <panic>

0000000080005ee6 <q_find>:
}

int q_find(queue_t *q, uint64 e){
    80005ee6:	1141                	addi	sp,sp,-16
    80005ee8:	e406                	sd	ra,8(sp)
    80005eea:	e022                	sd	s0,0(sp)
    80005eec:	0800                	addi	s0,sp,16
	panic("Not implemented yet\n");
    80005eee:	00003517          	auipc	a0,0x3
    80005ef2:	a3a50513          	addi	a0,a0,-1478 # 80008928 <syscalls+0x4c0>
    80005ef6:	00000097          	auipc	ra,0x0
    80005efa:	52a080e7          	jalr	1322(ra) # 80006420 <panic>

0000000080005efe <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005efe:	1141                	addi	sp,sp,-16
    80005f00:	e422                	sd	s0,8(sp)
    80005f02:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005f04:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005f08:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005f0c:	0037979b          	slliw	a5,a5,0x3
    80005f10:	02004737          	lui	a4,0x2004
    80005f14:	97ba                	add	a5,a5,a4
    80005f16:	0200c737          	lui	a4,0x200c
    80005f1a:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005f1e:	000f4637          	lui	a2,0xf4
    80005f22:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005f26:	95b2                	add	a1,a1,a2
    80005f28:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005f2a:	00269713          	slli	a4,a3,0x2
    80005f2e:	9736                	add	a4,a4,a3
    80005f30:	00371693          	slli	a3,a4,0x3
    80005f34:	00018717          	auipc	a4,0x18
    80005f38:	0cc70713          	addi	a4,a4,204 # 8001e000 <timer_scratch>
    80005f3c:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005f3e:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005f40:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80005f42:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005f46:	fffff797          	auipc	a5,0xfffff
    80005f4a:	75a78793          	addi	a5,a5,1882 # 800056a0 <timervec>
    80005f4e:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005f52:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005f56:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005f5a:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005f5e:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80005f62:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80005f66:	30479073          	csrw	mie,a5
}
    80005f6a:	6422                	ld	s0,8(sp)
    80005f6c:	0141                	addi	sp,sp,16
    80005f6e:	8082                	ret

0000000080005f70 <start>:
{
    80005f70:	1141                	addi	sp,sp,-16
    80005f72:	e406                	sd	ra,8(sp)
    80005f74:	e022                	sd	s0,0(sp)
    80005f76:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005f78:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005f7c:	7779                	lui	a4,0xffffe
    80005f7e:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd85bf>
    80005f82:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005f84:	6705                	lui	a4,0x1
    80005f86:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005f8a:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005f8c:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005f90:	ffffa797          	auipc	a5,0xffffa
    80005f94:	39678793          	addi	a5,a5,918 # 80000326 <main>
    80005f98:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005f9c:	4781                	li	a5,0
    80005f9e:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005fa2:	67c1                	lui	a5,0x10
    80005fa4:	17fd                	addi	a5,a5,-1
    80005fa6:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005faa:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005fae:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005fb2:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005fb6:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005fba:	57fd                	li	a5,-1
    80005fbc:	83a9                	srli	a5,a5,0xa
    80005fbe:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005fc2:	47bd                	li	a5,15
    80005fc4:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005fc8:	00000097          	auipc	ra,0x0
    80005fcc:	f36080e7          	jalr	-202(ra) # 80005efe <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005fd0:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005fd4:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005fd6:	823e                	mv	tp,a5
  asm volatile("mret");
    80005fd8:	30200073          	mret
}
    80005fdc:	60a2                	ld	ra,8(sp)
    80005fde:	6402                	ld	s0,0(sp)
    80005fe0:	0141                	addi	sp,sp,16
    80005fe2:	8082                	ret

0000000080005fe4 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005fe4:	715d                	addi	sp,sp,-80
    80005fe6:	e486                	sd	ra,72(sp)
    80005fe8:	e0a2                	sd	s0,64(sp)
    80005fea:	fc26                	sd	s1,56(sp)
    80005fec:	f84a                	sd	s2,48(sp)
    80005fee:	f44e                	sd	s3,40(sp)
    80005ff0:	f052                	sd	s4,32(sp)
    80005ff2:	ec56                	sd	s5,24(sp)
    80005ff4:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005ff6:	04c05663          	blez	a2,80006042 <consolewrite+0x5e>
    80005ffa:	8a2a                	mv	s4,a0
    80005ffc:	84ae                	mv	s1,a1
    80005ffe:	89b2                	mv	s3,a2
    80006000:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80006002:	5afd                	li	s5,-1
    80006004:	4685                	li	a3,1
    80006006:	8626                	mv	a2,s1
    80006008:	85d2                	mv	a1,s4
    8000600a:	fbf40513          	addi	a0,s0,-65
    8000600e:	ffffc097          	auipc	ra,0xffffc
    80006012:	d7e080e7          	jalr	-642(ra) # 80001d8c <either_copyin>
    80006016:	01550c63          	beq	a0,s5,8000602e <consolewrite+0x4a>
      break;
    uartputc(c);
    8000601a:	fbf44503          	lbu	a0,-65(s0)
    8000601e:	00000097          	auipc	ra,0x0
    80006022:	78e080e7          	jalr	1934(ra) # 800067ac <uartputc>
  for(i = 0; i < n; i++){
    80006026:	2905                	addiw	s2,s2,1
    80006028:	0485                	addi	s1,s1,1
    8000602a:	fd299de3          	bne	s3,s2,80006004 <consolewrite+0x20>
  }

  return i;
}
    8000602e:	854a                	mv	a0,s2
    80006030:	60a6                	ld	ra,72(sp)
    80006032:	6406                	ld	s0,64(sp)
    80006034:	74e2                	ld	s1,56(sp)
    80006036:	7942                	ld	s2,48(sp)
    80006038:	79a2                	ld	s3,40(sp)
    8000603a:	7a02                	ld	s4,32(sp)
    8000603c:	6ae2                	ld	s5,24(sp)
    8000603e:	6161                	addi	sp,sp,80
    80006040:	8082                	ret
  for(i = 0; i < n; i++){
    80006042:	4901                	li	s2,0
    80006044:	b7ed                	j	8000602e <consolewrite+0x4a>

0000000080006046 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80006046:	7119                	addi	sp,sp,-128
    80006048:	fc86                	sd	ra,120(sp)
    8000604a:	f8a2                	sd	s0,112(sp)
    8000604c:	f4a6                	sd	s1,104(sp)
    8000604e:	f0ca                	sd	s2,96(sp)
    80006050:	ecce                	sd	s3,88(sp)
    80006052:	e8d2                	sd	s4,80(sp)
    80006054:	e4d6                	sd	s5,72(sp)
    80006056:	e0da                	sd	s6,64(sp)
    80006058:	fc5e                	sd	s7,56(sp)
    8000605a:	f862                	sd	s8,48(sp)
    8000605c:	f466                	sd	s9,40(sp)
    8000605e:	f06a                	sd	s10,32(sp)
    80006060:	ec6e                	sd	s11,24(sp)
    80006062:	0100                	addi	s0,sp,128
    80006064:	8b2a                	mv	s6,a0
    80006066:	8aae                	mv	s5,a1
    80006068:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    8000606a:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    8000606e:	00020517          	auipc	a0,0x20
    80006072:	0d250513          	addi	a0,a0,210 # 80026140 <cons>
    80006076:	00001097          	auipc	ra,0x1
    8000607a:	8f4080e7          	jalr	-1804(ra) # 8000696a <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    8000607e:	00020497          	auipc	s1,0x20
    80006082:	0c248493          	addi	s1,s1,194 # 80026140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80006086:	89a6                	mv	s3,s1
    80006088:	00020917          	auipc	s2,0x20
    8000608c:	15090913          	addi	s2,s2,336 # 800261d8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    80006090:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80006092:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80006094:	4da9                	li	s11,10
  while(n > 0){
    80006096:	07405863          	blez	s4,80006106 <consoleread+0xc0>
    while(cons.r == cons.w){
    8000609a:	0984a783          	lw	a5,152(s1)
    8000609e:	09c4a703          	lw	a4,156(s1)
    800060a2:	02f71463          	bne	a4,a5,800060ca <consoleread+0x84>
      if(myproc()->killed){
    800060a6:	ffffb097          	auipc	ra,0xffffb
    800060aa:	230080e7          	jalr	560(ra) # 800012d6 <myproc>
    800060ae:	551c                	lw	a5,40(a0)
    800060b0:	e7b5                	bnez	a5,8000611c <consoleread+0xd6>
      sleep(&cons.r, &cons.lock);
    800060b2:	85ce                	mv	a1,s3
    800060b4:	854a                	mv	a0,s2
    800060b6:	ffffc097          	auipc	ra,0xffffc
    800060ba:	8dc080e7          	jalr	-1828(ra) # 80001992 <sleep>
    while(cons.r == cons.w){
    800060be:	0984a783          	lw	a5,152(s1)
    800060c2:	09c4a703          	lw	a4,156(s1)
    800060c6:	fef700e3          	beq	a4,a5,800060a6 <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF];
    800060ca:	0017871b          	addiw	a4,a5,1
    800060ce:	08e4ac23          	sw	a4,152(s1)
    800060d2:	07f7f713          	andi	a4,a5,127
    800060d6:	9726                	add	a4,a4,s1
    800060d8:	01874703          	lbu	a4,24(a4)
    800060dc:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    800060e0:	079c0663          	beq	s8,s9,8000614c <consoleread+0x106>
    cbuf = c;
    800060e4:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800060e8:	4685                	li	a3,1
    800060ea:	f8f40613          	addi	a2,s0,-113
    800060ee:	85d6                	mv	a1,s5
    800060f0:	855a                	mv	a0,s6
    800060f2:	ffffc097          	auipc	ra,0xffffc
    800060f6:	c44080e7          	jalr	-956(ra) # 80001d36 <either_copyout>
    800060fa:	01a50663          	beq	a0,s10,80006106 <consoleread+0xc0>
    dst++;
    800060fe:	0a85                	addi	s5,s5,1
    --n;
    80006100:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    80006102:	f9bc1ae3          	bne	s8,s11,80006096 <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80006106:	00020517          	auipc	a0,0x20
    8000610a:	03a50513          	addi	a0,a0,58 # 80026140 <cons>
    8000610e:	00001097          	auipc	ra,0x1
    80006112:	910080e7          	jalr	-1776(ra) # 80006a1e <release>

  return target - n;
    80006116:	414b853b          	subw	a0,s7,s4
    8000611a:	a811                	j	8000612e <consoleread+0xe8>
        release(&cons.lock);
    8000611c:	00020517          	auipc	a0,0x20
    80006120:	02450513          	addi	a0,a0,36 # 80026140 <cons>
    80006124:	00001097          	auipc	ra,0x1
    80006128:	8fa080e7          	jalr	-1798(ra) # 80006a1e <release>
        return -1;
    8000612c:	557d                	li	a0,-1
}
    8000612e:	70e6                	ld	ra,120(sp)
    80006130:	7446                	ld	s0,112(sp)
    80006132:	74a6                	ld	s1,104(sp)
    80006134:	7906                	ld	s2,96(sp)
    80006136:	69e6                	ld	s3,88(sp)
    80006138:	6a46                	ld	s4,80(sp)
    8000613a:	6aa6                	ld	s5,72(sp)
    8000613c:	6b06                	ld	s6,64(sp)
    8000613e:	7be2                	ld	s7,56(sp)
    80006140:	7c42                	ld	s8,48(sp)
    80006142:	7ca2                	ld	s9,40(sp)
    80006144:	7d02                	ld	s10,32(sp)
    80006146:	6de2                	ld	s11,24(sp)
    80006148:	6109                	addi	sp,sp,128
    8000614a:	8082                	ret
      if(n < target){
    8000614c:	000a071b          	sext.w	a4,s4
    80006150:	fb777be3          	bgeu	a4,s7,80006106 <consoleread+0xc0>
        cons.r--;
    80006154:	00020717          	auipc	a4,0x20
    80006158:	08f72223          	sw	a5,132(a4) # 800261d8 <cons+0x98>
    8000615c:	b76d                	j	80006106 <consoleread+0xc0>

000000008000615e <consputc>:
{
    8000615e:	1141                	addi	sp,sp,-16
    80006160:	e406                	sd	ra,8(sp)
    80006162:	e022                	sd	s0,0(sp)
    80006164:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80006166:	10000793          	li	a5,256
    8000616a:	00f50a63          	beq	a0,a5,8000617e <consputc+0x20>
    uartputc_sync(c);
    8000616e:	00000097          	auipc	ra,0x0
    80006172:	564080e7          	jalr	1380(ra) # 800066d2 <uartputc_sync>
}
    80006176:	60a2                	ld	ra,8(sp)
    80006178:	6402                	ld	s0,0(sp)
    8000617a:	0141                	addi	sp,sp,16
    8000617c:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    8000617e:	4521                	li	a0,8
    80006180:	00000097          	auipc	ra,0x0
    80006184:	552080e7          	jalr	1362(ra) # 800066d2 <uartputc_sync>
    80006188:	02000513          	li	a0,32
    8000618c:	00000097          	auipc	ra,0x0
    80006190:	546080e7          	jalr	1350(ra) # 800066d2 <uartputc_sync>
    80006194:	4521                	li	a0,8
    80006196:	00000097          	auipc	ra,0x0
    8000619a:	53c080e7          	jalr	1340(ra) # 800066d2 <uartputc_sync>
    8000619e:	bfe1                	j	80006176 <consputc+0x18>

00000000800061a0 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800061a0:	1101                	addi	sp,sp,-32
    800061a2:	ec06                	sd	ra,24(sp)
    800061a4:	e822                	sd	s0,16(sp)
    800061a6:	e426                	sd	s1,8(sp)
    800061a8:	e04a                	sd	s2,0(sp)
    800061aa:	1000                	addi	s0,sp,32
    800061ac:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800061ae:	00020517          	auipc	a0,0x20
    800061b2:	f9250513          	addi	a0,a0,-110 # 80026140 <cons>
    800061b6:	00000097          	auipc	ra,0x0
    800061ba:	7b4080e7          	jalr	1972(ra) # 8000696a <acquire>

  switch(c){
    800061be:	47d5                	li	a5,21
    800061c0:	0af48663          	beq	s1,a5,8000626c <consoleintr+0xcc>
    800061c4:	0297ca63          	blt	a5,s1,800061f8 <consoleintr+0x58>
    800061c8:	47a1                	li	a5,8
    800061ca:	0ef48763          	beq	s1,a5,800062b8 <consoleintr+0x118>
    800061ce:	47c1                	li	a5,16
    800061d0:	10f49a63          	bne	s1,a5,800062e4 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    800061d4:	ffffc097          	auipc	ra,0xffffc
    800061d8:	c0e080e7          	jalr	-1010(ra) # 80001de2 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800061dc:	00020517          	auipc	a0,0x20
    800061e0:	f6450513          	addi	a0,a0,-156 # 80026140 <cons>
    800061e4:	00001097          	auipc	ra,0x1
    800061e8:	83a080e7          	jalr	-1990(ra) # 80006a1e <release>
}
    800061ec:	60e2                	ld	ra,24(sp)
    800061ee:	6442                	ld	s0,16(sp)
    800061f0:	64a2                	ld	s1,8(sp)
    800061f2:	6902                	ld	s2,0(sp)
    800061f4:	6105                	addi	sp,sp,32
    800061f6:	8082                	ret
  switch(c){
    800061f8:	07f00793          	li	a5,127
    800061fc:	0af48e63          	beq	s1,a5,800062b8 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80006200:	00020717          	auipc	a4,0x20
    80006204:	f4070713          	addi	a4,a4,-192 # 80026140 <cons>
    80006208:	0a072783          	lw	a5,160(a4)
    8000620c:	09872703          	lw	a4,152(a4)
    80006210:	9f99                	subw	a5,a5,a4
    80006212:	07f00713          	li	a4,127
    80006216:	fcf763e3          	bltu	a4,a5,800061dc <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    8000621a:	47b5                	li	a5,13
    8000621c:	0cf48763          	beq	s1,a5,800062ea <consoleintr+0x14a>
      consputc(c);
    80006220:	8526                	mv	a0,s1
    80006222:	00000097          	auipc	ra,0x0
    80006226:	f3c080e7          	jalr	-196(ra) # 8000615e <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    8000622a:	00020797          	auipc	a5,0x20
    8000622e:	f1678793          	addi	a5,a5,-234 # 80026140 <cons>
    80006232:	0a07a703          	lw	a4,160(a5)
    80006236:	0017069b          	addiw	a3,a4,1
    8000623a:	0006861b          	sext.w	a2,a3
    8000623e:	0ad7a023          	sw	a3,160(a5)
    80006242:	07f77713          	andi	a4,a4,127
    80006246:	97ba                	add	a5,a5,a4
    80006248:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    8000624c:	47a9                	li	a5,10
    8000624e:	0cf48563          	beq	s1,a5,80006318 <consoleintr+0x178>
    80006252:	4791                	li	a5,4
    80006254:	0cf48263          	beq	s1,a5,80006318 <consoleintr+0x178>
    80006258:	00020797          	auipc	a5,0x20
    8000625c:	f807a783          	lw	a5,-128(a5) # 800261d8 <cons+0x98>
    80006260:	0807879b          	addiw	a5,a5,128
    80006264:	f6f61ce3          	bne	a2,a5,800061dc <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80006268:	863e                	mv	a2,a5
    8000626a:	a07d                	j	80006318 <consoleintr+0x178>
    while(cons.e != cons.w &&
    8000626c:	00020717          	auipc	a4,0x20
    80006270:	ed470713          	addi	a4,a4,-300 # 80026140 <cons>
    80006274:	0a072783          	lw	a5,160(a4)
    80006278:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    8000627c:	00020497          	auipc	s1,0x20
    80006280:	ec448493          	addi	s1,s1,-316 # 80026140 <cons>
    while(cons.e != cons.w &&
    80006284:	4929                	li	s2,10
    80006286:	f4f70be3          	beq	a4,a5,800061dc <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    8000628a:	37fd                	addiw	a5,a5,-1
    8000628c:	07f7f713          	andi	a4,a5,127
    80006290:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80006292:	01874703          	lbu	a4,24(a4)
    80006296:	f52703e3          	beq	a4,s2,800061dc <consoleintr+0x3c>
      cons.e--;
    8000629a:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    8000629e:	10000513          	li	a0,256
    800062a2:	00000097          	auipc	ra,0x0
    800062a6:	ebc080e7          	jalr	-324(ra) # 8000615e <consputc>
    while(cons.e != cons.w &&
    800062aa:	0a04a783          	lw	a5,160(s1)
    800062ae:	09c4a703          	lw	a4,156(s1)
    800062b2:	fcf71ce3          	bne	a4,a5,8000628a <consoleintr+0xea>
    800062b6:	b71d                	j	800061dc <consoleintr+0x3c>
    if(cons.e != cons.w){
    800062b8:	00020717          	auipc	a4,0x20
    800062bc:	e8870713          	addi	a4,a4,-376 # 80026140 <cons>
    800062c0:	0a072783          	lw	a5,160(a4)
    800062c4:	09c72703          	lw	a4,156(a4)
    800062c8:	f0f70ae3          	beq	a4,a5,800061dc <consoleintr+0x3c>
      cons.e--;
    800062cc:	37fd                	addiw	a5,a5,-1
    800062ce:	00020717          	auipc	a4,0x20
    800062d2:	f0f72923          	sw	a5,-238(a4) # 800261e0 <cons+0xa0>
      consputc(BACKSPACE);
    800062d6:	10000513          	li	a0,256
    800062da:	00000097          	auipc	ra,0x0
    800062de:	e84080e7          	jalr	-380(ra) # 8000615e <consputc>
    800062e2:	bded                	j	800061dc <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    800062e4:	ee048ce3          	beqz	s1,800061dc <consoleintr+0x3c>
    800062e8:	bf21                	j	80006200 <consoleintr+0x60>
      consputc(c);
    800062ea:	4529                	li	a0,10
    800062ec:	00000097          	auipc	ra,0x0
    800062f0:	e72080e7          	jalr	-398(ra) # 8000615e <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    800062f4:	00020797          	auipc	a5,0x20
    800062f8:	e4c78793          	addi	a5,a5,-436 # 80026140 <cons>
    800062fc:	0a07a703          	lw	a4,160(a5)
    80006300:	0017069b          	addiw	a3,a4,1
    80006304:	0006861b          	sext.w	a2,a3
    80006308:	0ad7a023          	sw	a3,160(a5)
    8000630c:	07f77713          	andi	a4,a4,127
    80006310:	97ba                	add	a5,a5,a4
    80006312:	4729                	li	a4,10
    80006314:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80006318:	00020797          	auipc	a5,0x20
    8000631c:	ecc7a223          	sw	a2,-316(a5) # 800261dc <cons+0x9c>
        wakeup(&cons.r);
    80006320:	00020517          	auipc	a0,0x20
    80006324:	eb850513          	addi	a0,a0,-328 # 800261d8 <cons+0x98>
    80006328:	ffffb097          	auipc	ra,0xffffb
    8000632c:	7f6080e7          	jalr	2038(ra) # 80001b1e <wakeup>
    80006330:	b575                	j	800061dc <consoleintr+0x3c>

0000000080006332 <consoleinit>:

void
consoleinit(void)
{
    80006332:	1141                	addi	sp,sp,-16
    80006334:	e406                	sd	ra,8(sp)
    80006336:	e022                	sd	s0,0(sp)
    80006338:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    8000633a:	00002597          	auipc	a1,0x2
    8000633e:	60658593          	addi	a1,a1,1542 # 80008940 <syscalls+0x4d8>
    80006342:	00020517          	auipc	a0,0x20
    80006346:	dfe50513          	addi	a0,a0,-514 # 80026140 <cons>
    8000634a:	00000097          	auipc	ra,0x0
    8000634e:	590080e7          	jalr	1424(ra) # 800068da <initlock>

  uartinit();
    80006352:	00000097          	auipc	ra,0x0
    80006356:	330080e7          	jalr	816(ra) # 80006682 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    8000635a:	00013797          	auipc	a5,0x13
    8000635e:	d6e78793          	addi	a5,a5,-658 # 800190c8 <devsw>
    80006362:	00000717          	auipc	a4,0x0
    80006366:	ce470713          	addi	a4,a4,-796 # 80006046 <consoleread>
    8000636a:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    8000636c:	00000717          	auipc	a4,0x0
    80006370:	c7870713          	addi	a4,a4,-904 # 80005fe4 <consolewrite>
    80006374:	ef98                	sd	a4,24(a5)
}
    80006376:	60a2                	ld	ra,8(sp)
    80006378:	6402                	ld	s0,0(sp)
    8000637a:	0141                	addi	sp,sp,16
    8000637c:	8082                	ret

000000008000637e <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    8000637e:	7179                	addi	sp,sp,-48
    80006380:	f406                	sd	ra,40(sp)
    80006382:	f022                	sd	s0,32(sp)
    80006384:	ec26                	sd	s1,24(sp)
    80006386:	e84a                	sd	s2,16(sp)
    80006388:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    8000638a:	c219                	beqz	a2,80006390 <printint+0x12>
    8000638c:	08054663          	bltz	a0,80006418 <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80006390:	2501                	sext.w	a0,a0
    80006392:	4881                	li	a7,0
    80006394:	fd040693          	addi	a3,s0,-48

  i = 0;
    80006398:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    8000639a:	2581                	sext.w	a1,a1
    8000639c:	00002617          	auipc	a2,0x2
    800063a0:	5d460613          	addi	a2,a2,1492 # 80008970 <digits>
    800063a4:	883a                	mv	a6,a4
    800063a6:	2705                	addiw	a4,a4,1
    800063a8:	02b577bb          	remuw	a5,a0,a1
    800063ac:	1782                	slli	a5,a5,0x20
    800063ae:	9381                	srli	a5,a5,0x20
    800063b0:	97b2                	add	a5,a5,a2
    800063b2:	0007c783          	lbu	a5,0(a5)
    800063b6:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    800063ba:	0005079b          	sext.w	a5,a0
    800063be:	02b5553b          	divuw	a0,a0,a1
    800063c2:	0685                	addi	a3,a3,1
    800063c4:	feb7f0e3          	bgeu	a5,a1,800063a4 <printint+0x26>

  if(sign)
    800063c8:	00088b63          	beqz	a7,800063de <printint+0x60>
    buf[i++] = '-';
    800063cc:	fe040793          	addi	a5,s0,-32
    800063d0:	973e                	add	a4,a4,a5
    800063d2:	02d00793          	li	a5,45
    800063d6:	fef70823          	sb	a5,-16(a4)
    800063da:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    800063de:	02e05763          	blez	a4,8000640c <printint+0x8e>
    800063e2:	fd040793          	addi	a5,s0,-48
    800063e6:	00e784b3          	add	s1,a5,a4
    800063ea:	fff78913          	addi	s2,a5,-1
    800063ee:	993a                	add	s2,s2,a4
    800063f0:	377d                	addiw	a4,a4,-1
    800063f2:	1702                	slli	a4,a4,0x20
    800063f4:	9301                	srli	a4,a4,0x20
    800063f6:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    800063fa:	fff4c503          	lbu	a0,-1(s1)
    800063fe:	00000097          	auipc	ra,0x0
    80006402:	d60080e7          	jalr	-672(ra) # 8000615e <consputc>
  while(--i >= 0)
    80006406:	14fd                	addi	s1,s1,-1
    80006408:	ff2499e3          	bne	s1,s2,800063fa <printint+0x7c>
}
    8000640c:	70a2                	ld	ra,40(sp)
    8000640e:	7402                	ld	s0,32(sp)
    80006410:	64e2                	ld	s1,24(sp)
    80006412:	6942                	ld	s2,16(sp)
    80006414:	6145                	addi	sp,sp,48
    80006416:	8082                	ret
    x = -xx;
    80006418:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    8000641c:	4885                	li	a7,1
    x = -xx;
    8000641e:	bf9d                	j	80006394 <printint+0x16>

0000000080006420 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80006420:	1101                	addi	sp,sp,-32
    80006422:	ec06                	sd	ra,24(sp)
    80006424:	e822                	sd	s0,16(sp)
    80006426:	e426                	sd	s1,8(sp)
    80006428:	1000                	addi	s0,sp,32
    8000642a:	84aa                	mv	s1,a0
  pr.locking = 0;
    8000642c:	00020797          	auipc	a5,0x20
    80006430:	dc07aa23          	sw	zero,-556(a5) # 80026200 <pr+0x18>
  printf("panic: ");
    80006434:	00002517          	auipc	a0,0x2
    80006438:	51450513          	addi	a0,a0,1300 # 80008948 <syscalls+0x4e0>
    8000643c:	00000097          	auipc	ra,0x0
    80006440:	02e080e7          	jalr	46(ra) # 8000646a <printf>
  printf(s);
    80006444:	8526                	mv	a0,s1
    80006446:	00000097          	auipc	ra,0x0
    8000644a:	024080e7          	jalr	36(ra) # 8000646a <printf>
  printf("\n");
    8000644e:	00002517          	auipc	a0,0x2
    80006452:	bfa50513          	addi	a0,a0,-1030 # 80008048 <etext+0x48>
    80006456:	00000097          	auipc	ra,0x0
    8000645a:	014080e7          	jalr	20(ra) # 8000646a <printf>
  panicked = 1; // freeze uart output from other CPUs
    8000645e:	4785                	li	a5,1
    80006460:	00003717          	auipc	a4,0x3
    80006464:	baf72e23          	sw	a5,-1092(a4) # 8000901c <panicked>
  for(;;)
    80006468:	a001                	j	80006468 <panic+0x48>

000000008000646a <printf>:
{
    8000646a:	7131                	addi	sp,sp,-192
    8000646c:	fc86                	sd	ra,120(sp)
    8000646e:	f8a2                	sd	s0,112(sp)
    80006470:	f4a6                	sd	s1,104(sp)
    80006472:	f0ca                	sd	s2,96(sp)
    80006474:	ecce                	sd	s3,88(sp)
    80006476:	e8d2                	sd	s4,80(sp)
    80006478:	e4d6                	sd	s5,72(sp)
    8000647a:	e0da                	sd	s6,64(sp)
    8000647c:	fc5e                	sd	s7,56(sp)
    8000647e:	f862                	sd	s8,48(sp)
    80006480:	f466                	sd	s9,40(sp)
    80006482:	f06a                	sd	s10,32(sp)
    80006484:	ec6e                	sd	s11,24(sp)
    80006486:	0100                	addi	s0,sp,128
    80006488:	8a2a                	mv	s4,a0
    8000648a:	e40c                	sd	a1,8(s0)
    8000648c:	e810                	sd	a2,16(s0)
    8000648e:	ec14                	sd	a3,24(s0)
    80006490:	f018                	sd	a4,32(s0)
    80006492:	f41c                	sd	a5,40(s0)
    80006494:	03043823          	sd	a6,48(s0)
    80006498:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    8000649c:	00020d97          	auipc	s11,0x20
    800064a0:	d64dad83          	lw	s11,-668(s11) # 80026200 <pr+0x18>
  if(locking)
    800064a4:	020d9b63          	bnez	s11,800064da <printf+0x70>
  if (fmt == 0)
    800064a8:	040a0263          	beqz	s4,800064ec <printf+0x82>
  va_start(ap, fmt);
    800064ac:	00840793          	addi	a5,s0,8
    800064b0:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800064b4:	000a4503          	lbu	a0,0(s4)
    800064b8:	16050263          	beqz	a0,8000661c <printf+0x1b2>
    800064bc:	4481                	li	s1,0
    if(c != '%'){
    800064be:	02500a93          	li	s5,37
    switch(c){
    800064c2:	07000b13          	li	s6,112
  consputc('x');
    800064c6:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800064c8:	00002b97          	auipc	s7,0x2
    800064cc:	4a8b8b93          	addi	s7,s7,1192 # 80008970 <digits>
    switch(c){
    800064d0:	07300c93          	li	s9,115
    800064d4:	06400c13          	li	s8,100
    800064d8:	a82d                	j	80006512 <printf+0xa8>
    acquire(&pr.lock);
    800064da:	00020517          	auipc	a0,0x20
    800064de:	d0e50513          	addi	a0,a0,-754 # 800261e8 <pr>
    800064e2:	00000097          	auipc	ra,0x0
    800064e6:	488080e7          	jalr	1160(ra) # 8000696a <acquire>
    800064ea:	bf7d                	j	800064a8 <printf+0x3e>
    panic("null fmt");
    800064ec:	00002517          	auipc	a0,0x2
    800064f0:	46c50513          	addi	a0,a0,1132 # 80008958 <syscalls+0x4f0>
    800064f4:	00000097          	auipc	ra,0x0
    800064f8:	f2c080e7          	jalr	-212(ra) # 80006420 <panic>
      consputc(c);
    800064fc:	00000097          	auipc	ra,0x0
    80006500:	c62080e7          	jalr	-926(ra) # 8000615e <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80006504:	2485                	addiw	s1,s1,1
    80006506:	009a07b3          	add	a5,s4,s1
    8000650a:	0007c503          	lbu	a0,0(a5)
    8000650e:	10050763          	beqz	a0,8000661c <printf+0x1b2>
    if(c != '%'){
    80006512:	ff5515e3          	bne	a0,s5,800064fc <printf+0x92>
    c = fmt[++i] & 0xff;
    80006516:	2485                	addiw	s1,s1,1
    80006518:	009a07b3          	add	a5,s4,s1
    8000651c:	0007c783          	lbu	a5,0(a5)
    80006520:	0007891b          	sext.w	s2,a5
    if(c == 0)
    80006524:	cfe5                	beqz	a5,8000661c <printf+0x1b2>
    switch(c){
    80006526:	05678a63          	beq	a5,s6,8000657a <printf+0x110>
    8000652a:	02fb7663          	bgeu	s6,a5,80006556 <printf+0xec>
    8000652e:	09978963          	beq	a5,s9,800065c0 <printf+0x156>
    80006532:	07800713          	li	a4,120
    80006536:	0ce79863          	bne	a5,a4,80006606 <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    8000653a:	f8843783          	ld	a5,-120(s0)
    8000653e:	00878713          	addi	a4,a5,8
    80006542:	f8e43423          	sd	a4,-120(s0)
    80006546:	4605                	li	a2,1
    80006548:	85ea                	mv	a1,s10
    8000654a:	4388                	lw	a0,0(a5)
    8000654c:	00000097          	auipc	ra,0x0
    80006550:	e32080e7          	jalr	-462(ra) # 8000637e <printint>
      break;
    80006554:	bf45                	j	80006504 <printf+0x9a>
    switch(c){
    80006556:	0b578263          	beq	a5,s5,800065fa <printf+0x190>
    8000655a:	0b879663          	bne	a5,s8,80006606 <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    8000655e:	f8843783          	ld	a5,-120(s0)
    80006562:	00878713          	addi	a4,a5,8
    80006566:	f8e43423          	sd	a4,-120(s0)
    8000656a:	4605                	li	a2,1
    8000656c:	45a9                	li	a1,10
    8000656e:	4388                	lw	a0,0(a5)
    80006570:	00000097          	auipc	ra,0x0
    80006574:	e0e080e7          	jalr	-498(ra) # 8000637e <printint>
      break;
    80006578:	b771                	j	80006504 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    8000657a:	f8843783          	ld	a5,-120(s0)
    8000657e:	00878713          	addi	a4,a5,8
    80006582:	f8e43423          	sd	a4,-120(s0)
    80006586:	0007b983          	ld	s3,0(a5)
  consputc('0');
    8000658a:	03000513          	li	a0,48
    8000658e:	00000097          	auipc	ra,0x0
    80006592:	bd0080e7          	jalr	-1072(ra) # 8000615e <consputc>
  consputc('x');
    80006596:	07800513          	li	a0,120
    8000659a:	00000097          	auipc	ra,0x0
    8000659e:	bc4080e7          	jalr	-1084(ra) # 8000615e <consputc>
    800065a2:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800065a4:	03c9d793          	srli	a5,s3,0x3c
    800065a8:	97de                	add	a5,a5,s7
    800065aa:	0007c503          	lbu	a0,0(a5)
    800065ae:	00000097          	auipc	ra,0x0
    800065b2:	bb0080e7          	jalr	-1104(ra) # 8000615e <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800065b6:	0992                	slli	s3,s3,0x4
    800065b8:	397d                	addiw	s2,s2,-1
    800065ba:	fe0915e3          	bnez	s2,800065a4 <printf+0x13a>
    800065be:	b799                	j	80006504 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    800065c0:	f8843783          	ld	a5,-120(s0)
    800065c4:	00878713          	addi	a4,a5,8
    800065c8:	f8e43423          	sd	a4,-120(s0)
    800065cc:	0007b903          	ld	s2,0(a5)
    800065d0:	00090e63          	beqz	s2,800065ec <printf+0x182>
      for(; *s; s++)
    800065d4:	00094503          	lbu	a0,0(s2)
    800065d8:	d515                	beqz	a0,80006504 <printf+0x9a>
        consputc(*s);
    800065da:	00000097          	auipc	ra,0x0
    800065de:	b84080e7          	jalr	-1148(ra) # 8000615e <consputc>
      for(; *s; s++)
    800065e2:	0905                	addi	s2,s2,1
    800065e4:	00094503          	lbu	a0,0(s2)
    800065e8:	f96d                	bnez	a0,800065da <printf+0x170>
    800065ea:	bf29                	j	80006504 <printf+0x9a>
        s = "(null)";
    800065ec:	00002917          	auipc	s2,0x2
    800065f0:	36490913          	addi	s2,s2,868 # 80008950 <syscalls+0x4e8>
      for(; *s; s++)
    800065f4:	02800513          	li	a0,40
    800065f8:	b7cd                	j	800065da <printf+0x170>
      consputc('%');
    800065fa:	8556                	mv	a0,s5
    800065fc:	00000097          	auipc	ra,0x0
    80006600:	b62080e7          	jalr	-1182(ra) # 8000615e <consputc>
      break;
    80006604:	b701                	j	80006504 <printf+0x9a>
      consputc('%');
    80006606:	8556                	mv	a0,s5
    80006608:	00000097          	auipc	ra,0x0
    8000660c:	b56080e7          	jalr	-1194(ra) # 8000615e <consputc>
      consputc(c);
    80006610:	854a                	mv	a0,s2
    80006612:	00000097          	auipc	ra,0x0
    80006616:	b4c080e7          	jalr	-1204(ra) # 8000615e <consputc>
      break;
    8000661a:	b5ed                	j	80006504 <printf+0x9a>
  if(locking)
    8000661c:	020d9163          	bnez	s11,8000663e <printf+0x1d4>
}
    80006620:	70e6                	ld	ra,120(sp)
    80006622:	7446                	ld	s0,112(sp)
    80006624:	74a6                	ld	s1,104(sp)
    80006626:	7906                	ld	s2,96(sp)
    80006628:	69e6                	ld	s3,88(sp)
    8000662a:	6a46                	ld	s4,80(sp)
    8000662c:	6aa6                	ld	s5,72(sp)
    8000662e:	6b06                	ld	s6,64(sp)
    80006630:	7be2                	ld	s7,56(sp)
    80006632:	7c42                	ld	s8,48(sp)
    80006634:	7ca2                	ld	s9,40(sp)
    80006636:	7d02                	ld	s10,32(sp)
    80006638:	6de2                	ld	s11,24(sp)
    8000663a:	6129                	addi	sp,sp,192
    8000663c:	8082                	ret
    release(&pr.lock);
    8000663e:	00020517          	auipc	a0,0x20
    80006642:	baa50513          	addi	a0,a0,-1110 # 800261e8 <pr>
    80006646:	00000097          	auipc	ra,0x0
    8000664a:	3d8080e7          	jalr	984(ra) # 80006a1e <release>
}
    8000664e:	bfc9                	j	80006620 <printf+0x1b6>

0000000080006650 <printfinit>:
    ;
}

void
printfinit(void)
{
    80006650:	1101                	addi	sp,sp,-32
    80006652:	ec06                	sd	ra,24(sp)
    80006654:	e822                	sd	s0,16(sp)
    80006656:	e426                	sd	s1,8(sp)
    80006658:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    8000665a:	00020497          	auipc	s1,0x20
    8000665e:	b8e48493          	addi	s1,s1,-1138 # 800261e8 <pr>
    80006662:	00002597          	auipc	a1,0x2
    80006666:	30658593          	addi	a1,a1,774 # 80008968 <syscalls+0x500>
    8000666a:	8526                	mv	a0,s1
    8000666c:	00000097          	auipc	ra,0x0
    80006670:	26e080e7          	jalr	622(ra) # 800068da <initlock>
  pr.locking = 1;
    80006674:	4785                	li	a5,1
    80006676:	cc9c                	sw	a5,24(s1)
}
    80006678:	60e2                	ld	ra,24(sp)
    8000667a:	6442                	ld	s0,16(sp)
    8000667c:	64a2                	ld	s1,8(sp)
    8000667e:	6105                	addi	sp,sp,32
    80006680:	8082                	ret

0000000080006682 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80006682:	1141                	addi	sp,sp,-16
    80006684:	e406                	sd	ra,8(sp)
    80006686:	e022                	sd	s0,0(sp)
    80006688:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    8000668a:	100007b7          	lui	a5,0x10000
    8000668e:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80006692:	f8000713          	li	a4,-128
    80006696:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    8000669a:	470d                	li	a4,3
    8000669c:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800066a0:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800066a4:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800066a8:	469d                	li	a3,7
    800066aa:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800066ae:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    800066b2:	00002597          	auipc	a1,0x2
    800066b6:	2d658593          	addi	a1,a1,726 # 80008988 <digits+0x18>
    800066ba:	00020517          	auipc	a0,0x20
    800066be:	b4e50513          	addi	a0,a0,-1202 # 80026208 <uart_tx_lock>
    800066c2:	00000097          	auipc	ra,0x0
    800066c6:	218080e7          	jalr	536(ra) # 800068da <initlock>
}
    800066ca:	60a2                	ld	ra,8(sp)
    800066cc:	6402                	ld	s0,0(sp)
    800066ce:	0141                	addi	sp,sp,16
    800066d0:	8082                	ret

00000000800066d2 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800066d2:	1101                	addi	sp,sp,-32
    800066d4:	ec06                	sd	ra,24(sp)
    800066d6:	e822                	sd	s0,16(sp)
    800066d8:	e426                	sd	s1,8(sp)
    800066da:	1000                	addi	s0,sp,32
    800066dc:	84aa                	mv	s1,a0
  push_off();
    800066de:	00000097          	auipc	ra,0x0
    800066e2:	240080e7          	jalr	576(ra) # 8000691e <push_off>

  if(panicked){
    800066e6:	00003797          	auipc	a5,0x3
    800066ea:	9367a783          	lw	a5,-1738(a5) # 8000901c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800066ee:	10000737          	lui	a4,0x10000
  if(panicked){
    800066f2:	c391                	beqz	a5,800066f6 <uartputc_sync+0x24>
    for(;;)
    800066f4:	a001                	j	800066f4 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800066f6:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    800066fa:	0ff7f793          	andi	a5,a5,255
    800066fe:	0207f793          	andi	a5,a5,32
    80006702:	dbf5                	beqz	a5,800066f6 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80006704:	0ff4f793          	andi	a5,s1,255
    80006708:	10000737          	lui	a4,0x10000
    8000670c:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    80006710:	00000097          	auipc	ra,0x0
    80006714:	2ae080e7          	jalr	686(ra) # 800069be <pop_off>
}
    80006718:	60e2                	ld	ra,24(sp)
    8000671a:	6442                	ld	s0,16(sp)
    8000671c:	64a2                	ld	s1,8(sp)
    8000671e:	6105                	addi	sp,sp,32
    80006720:	8082                	ret

0000000080006722 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80006722:	00003717          	auipc	a4,0x3
    80006726:	8fe73703          	ld	a4,-1794(a4) # 80009020 <uart_tx_r>
    8000672a:	00003797          	auipc	a5,0x3
    8000672e:	8fe7b783          	ld	a5,-1794(a5) # 80009028 <uart_tx_w>
    80006732:	06e78c63          	beq	a5,a4,800067aa <uartstart+0x88>
{
    80006736:	7139                	addi	sp,sp,-64
    80006738:	fc06                	sd	ra,56(sp)
    8000673a:	f822                	sd	s0,48(sp)
    8000673c:	f426                	sd	s1,40(sp)
    8000673e:	f04a                	sd	s2,32(sp)
    80006740:	ec4e                	sd	s3,24(sp)
    80006742:	e852                	sd	s4,16(sp)
    80006744:	e456                	sd	s5,8(sp)
    80006746:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006748:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000674c:	00020a17          	auipc	s4,0x20
    80006750:	abca0a13          	addi	s4,s4,-1348 # 80026208 <uart_tx_lock>
    uart_tx_r += 1;
    80006754:	00003497          	auipc	s1,0x3
    80006758:	8cc48493          	addi	s1,s1,-1844 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    8000675c:	00003997          	auipc	s3,0x3
    80006760:	8cc98993          	addi	s3,s3,-1844 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006764:	00594783          	lbu	a5,5(s2) # 10000005 <_entry-0x6ffffffb>
    80006768:	0ff7f793          	andi	a5,a5,255
    8000676c:	0207f793          	andi	a5,a5,32
    80006770:	c785                	beqz	a5,80006798 <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006772:	01f77793          	andi	a5,a4,31
    80006776:	97d2                	add	a5,a5,s4
    80006778:	0187ca83          	lbu	s5,24(a5)
    uart_tx_r += 1;
    8000677c:	0705                	addi	a4,a4,1
    8000677e:	e098                	sd	a4,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80006780:	8526                	mv	a0,s1
    80006782:	ffffb097          	auipc	ra,0xffffb
    80006786:	39c080e7          	jalr	924(ra) # 80001b1e <wakeup>
    
    WriteReg(THR, c);
    8000678a:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    8000678e:	6098                	ld	a4,0(s1)
    80006790:	0009b783          	ld	a5,0(s3)
    80006794:	fce798e3          	bne	a5,a4,80006764 <uartstart+0x42>
  }
}
    80006798:	70e2                	ld	ra,56(sp)
    8000679a:	7442                	ld	s0,48(sp)
    8000679c:	74a2                	ld	s1,40(sp)
    8000679e:	7902                	ld	s2,32(sp)
    800067a0:	69e2                	ld	s3,24(sp)
    800067a2:	6a42                	ld	s4,16(sp)
    800067a4:	6aa2                	ld	s5,8(sp)
    800067a6:	6121                	addi	sp,sp,64
    800067a8:	8082                	ret
    800067aa:	8082                	ret

00000000800067ac <uartputc>:
{
    800067ac:	7179                	addi	sp,sp,-48
    800067ae:	f406                	sd	ra,40(sp)
    800067b0:	f022                	sd	s0,32(sp)
    800067b2:	ec26                	sd	s1,24(sp)
    800067b4:	e84a                	sd	s2,16(sp)
    800067b6:	e44e                	sd	s3,8(sp)
    800067b8:	e052                	sd	s4,0(sp)
    800067ba:	1800                	addi	s0,sp,48
    800067bc:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    800067be:	00020517          	auipc	a0,0x20
    800067c2:	a4a50513          	addi	a0,a0,-1462 # 80026208 <uart_tx_lock>
    800067c6:	00000097          	auipc	ra,0x0
    800067ca:	1a4080e7          	jalr	420(ra) # 8000696a <acquire>
  if(panicked){
    800067ce:	00003797          	auipc	a5,0x3
    800067d2:	84e7a783          	lw	a5,-1970(a5) # 8000901c <panicked>
    800067d6:	c391                	beqz	a5,800067da <uartputc+0x2e>
    for(;;)
    800067d8:	a001                	j	800067d8 <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800067da:	00003797          	auipc	a5,0x3
    800067de:	84e7b783          	ld	a5,-1970(a5) # 80009028 <uart_tx_w>
    800067e2:	00003717          	auipc	a4,0x3
    800067e6:	83e73703          	ld	a4,-1986(a4) # 80009020 <uart_tx_r>
    800067ea:	02070713          	addi	a4,a4,32
    800067ee:	02f71b63          	bne	a4,a5,80006824 <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    800067f2:	00020a17          	auipc	s4,0x20
    800067f6:	a16a0a13          	addi	s4,s4,-1514 # 80026208 <uart_tx_lock>
    800067fa:	00003497          	auipc	s1,0x3
    800067fe:	82648493          	addi	s1,s1,-2010 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006802:	00003917          	auipc	s2,0x3
    80006806:	82690913          	addi	s2,s2,-2010 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    8000680a:	85d2                	mv	a1,s4
    8000680c:	8526                	mv	a0,s1
    8000680e:	ffffb097          	auipc	ra,0xffffb
    80006812:	184080e7          	jalr	388(ra) # 80001992 <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006816:	00093783          	ld	a5,0(s2)
    8000681a:	6098                	ld	a4,0(s1)
    8000681c:	02070713          	addi	a4,a4,32
    80006820:	fef705e3          	beq	a4,a5,8000680a <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80006824:	00020497          	auipc	s1,0x20
    80006828:	9e448493          	addi	s1,s1,-1564 # 80026208 <uart_tx_lock>
    8000682c:	01f7f713          	andi	a4,a5,31
    80006830:	9726                	add	a4,a4,s1
    80006832:	01370c23          	sb	s3,24(a4)
      uart_tx_w += 1;
    80006836:	0785                	addi	a5,a5,1
    80006838:	00002717          	auipc	a4,0x2
    8000683c:	7ef73823          	sd	a5,2032(a4) # 80009028 <uart_tx_w>
      uartstart();
    80006840:	00000097          	auipc	ra,0x0
    80006844:	ee2080e7          	jalr	-286(ra) # 80006722 <uartstart>
      release(&uart_tx_lock);
    80006848:	8526                	mv	a0,s1
    8000684a:	00000097          	auipc	ra,0x0
    8000684e:	1d4080e7          	jalr	468(ra) # 80006a1e <release>
}
    80006852:	70a2                	ld	ra,40(sp)
    80006854:	7402                	ld	s0,32(sp)
    80006856:	64e2                	ld	s1,24(sp)
    80006858:	6942                	ld	s2,16(sp)
    8000685a:	69a2                	ld	s3,8(sp)
    8000685c:	6a02                	ld	s4,0(sp)
    8000685e:	6145                	addi	sp,sp,48
    80006860:	8082                	ret

0000000080006862 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80006862:	1141                	addi	sp,sp,-16
    80006864:	e422                	sd	s0,8(sp)
    80006866:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80006868:	100007b7          	lui	a5,0x10000
    8000686c:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80006870:	8b85                	andi	a5,a5,1
    80006872:	cb91                	beqz	a5,80006886 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    80006874:	100007b7          	lui	a5,0x10000
    80006878:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    8000687c:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    80006880:	6422                	ld	s0,8(sp)
    80006882:	0141                	addi	sp,sp,16
    80006884:	8082                	ret
    return -1;
    80006886:	557d                	li	a0,-1
    80006888:	bfe5                	j	80006880 <uartgetc+0x1e>

000000008000688a <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    8000688a:	1101                	addi	sp,sp,-32
    8000688c:	ec06                	sd	ra,24(sp)
    8000688e:	e822                	sd	s0,16(sp)
    80006890:	e426                	sd	s1,8(sp)
    80006892:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80006894:	54fd                	li	s1,-1
    int c = uartgetc();
    80006896:	00000097          	auipc	ra,0x0
    8000689a:	fcc080e7          	jalr	-52(ra) # 80006862 <uartgetc>
    if(c == -1)
    8000689e:	00950763          	beq	a0,s1,800068ac <uartintr+0x22>
      break;
    consoleintr(c);
    800068a2:	00000097          	auipc	ra,0x0
    800068a6:	8fe080e7          	jalr	-1794(ra) # 800061a0 <consoleintr>
  while(1){
    800068aa:	b7f5                	j	80006896 <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800068ac:	00020497          	auipc	s1,0x20
    800068b0:	95c48493          	addi	s1,s1,-1700 # 80026208 <uart_tx_lock>
    800068b4:	8526                	mv	a0,s1
    800068b6:	00000097          	auipc	ra,0x0
    800068ba:	0b4080e7          	jalr	180(ra) # 8000696a <acquire>
  uartstart();
    800068be:	00000097          	auipc	ra,0x0
    800068c2:	e64080e7          	jalr	-412(ra) # 80006722 <uartstart>
  release(&uart_tx_lock);
    800068c6:	8526                	mv	a0,s1
    800068c8:	00000097          	auipc	ra,0x0
    800068cc:	156080e7          	jalr	342(ra) # 80006a1e <release>
}
    800068d0:	60e2                	ld	ra,24(sp)
    800068d2:	6442                	ld	s0,16(sp)
    800068d4:	64a2                	ld	s1,8(sp)
    800068d6:	6105                	addi	sp,sp,32
    800068d8:	8082                	ret

00000000800068da <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    800068da:	1141                	addi	sp,sp,-16
    800068dc:	e422                	sd	s0,8(sp)
    800068de:	0800                	addi	s0,sp,16
  lk->name = name;
    800068e0:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    800068e2:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    800068e6:	00053823          	sd	zero,16(a0)
}
    800068ea:	6422                	ld	s0,8(sp)
    800068ec:	0141                	addi	sp,sp,16
    800068ee:	8082                	ret

00000000800068f0 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    800068f0:	411c                	lw	a5,0(a0)
    800068f2:	e399                	bnez	a5,800068f8 <holding+0x8>
    800068f4:	4501                	li	a0,0
  return r;
}
    800068f6:	8082                	ret
{
    800068f8:	1101                	addi	sp,sp,-32
    800068fa:	ec06                	sd	ra,24(sp)
    800068fc:	e822                	sd	s0,16(sp)
    800068fe:	e426                	sd	s1,8(sp)
    80006900:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80006902:	6904                	ld	s1,16(a0)
    80006904:	ffffb097          	auipc	ra,0xffffb
    80006908:	9b6080e7          	jalr	-1610(ra) # 800012ba <mycpu>
    8000690c:	40a48533          	sub	a0,s1,a0
    80006910:	00153513          	seqz	a0,a0
}
    80006914:	60e2                	ld	ra,24(sp)
    80006916:	6442                	ld	s0,16(sp)
    80006918:	64a2                	ld	s1,8(sp)
    8000691a:	6105                	addi	sp,sp,32
    8000691c:	8082                	ret

000000008000691e <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    8000691e:	1101                	addi	sp,sp,-32
    80006920:	ec06                	sd	ra,24(sp)
    80006922:	e822                	sd	s0,16(sp)
    80006924:	e426                	sd	s1,8(sp)
    80006926:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006928:	100024f3          	csrr	s1,sstatus
    8000692c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80006930:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006932:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80006936:	ffffb097          	auipc	ra,0xffffb
    8000693a:	984080e7          	jalr	-1660(ra) # 800012ba <mycpu>
    8000693e:	5d3c                	lw	a5,120(a0)
    80006940:	cf89                	beqz	a5,8000695a <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80006942:	ffffb097          	auipc	ra,0xffffb
    80006946:	978080e7          	jalr	-1672(ra) # 800012ba <mycpu>
    8000694a:	5d3c                	lw	a5,120(a0)
    8000694c:	2785                	addiw	a5,a5,1
    8000694e:	dd3c                	sw	a5,120(a0)
}
    80006950:	60e2                	ld	ra,24(sp)
    80006952:	6442                	ld	s0,16(sp)
    80006954:	64a2                	ld	s1,8(sp)
    80006956:	6105                	addi	sp,sp,32
    80006958:	8082                	ret
    mycpu()->intena = old;
    8000695a:	ffffb097          	auipc	ra,0xffffb
    8000695e:	960080e7          	jalr	-1696(ra) # 800012ba <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80006962:	8085                	srli	s1,s1,0x1
    80006964:	8885                	andi	s1,s1,1
    80006966:	dd64                	sw	s1,124(a0)
    80006968:	bfe9                	j	80006942 <push_off+0x24>

000000008000696a <acquire>:
{
    8000696a:	1101                	addi	sp,sp,-32
    8000696c:	ec06                	sd	ra,24(sp)
    8000696e:	e822                	sd	s0,16(sp)
    80006970:	e426                	sd	s1,8(sp)
    80006972:	1000                	addi	s0,sp,32
    80006974:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80006976:	00000097          	auipc	ra,0x0
    8000697a:	fa8080e7          	jalr	-88(ra) # 8000691e <push_off>
  if(holding(lk))
    8000697e:	8526                	mv	a0,s1
    80006980:	00000097          	auipc	ra,0x0
    80006984:	f70080e7          	jalr	-144(ra) # 800068f0 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006988:	4705                	li	a4,1
  if(holding(lk))
    8000698a:	e115                	bnez	a0,800069ae <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000698c:	87ba                	mv	a5,a4
    8000698e:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80006992:	2781                	sext.w	a5,a5
    80006994:	ffe5                	bnez	a5,8000698c <acquire+0x22>
  __sync_synchronize();
    80006996:	0ff0000f          	fence
  lk->cpu = mycpu();
    8000699a:	ffffb097          	auipc	ra,0xffffb
    8000699e:	920080e7          	jalr	-1760(ra) # 800012ba <mycpu>
    800069a2:	e888                	sd	a0,16(s1)
}
    800069a4:	60e2                	ld	ra,24(sp)
    800069a6:	6442                	ld	s0,16(sp)
    800069a8:	64a2                	ld	s1,8(sp)
    800069aa:	6105                	addi	sp,sp,32
    800069ac:	8082                	ret
    panic("acquire");
    800069ae:	00002517          	auipc	a0,0x2
    800069b2:	fe250513          	addi	a0,a0,-30 # 80008990 <digits+0x20>
    800069b6:	00000097          	auipc	ra,0x0
    800069ba:	a6a080e7          	jalr	-1430(ra) # 80006420 <panic>

00000000800069be <pop_off>:

void
pop_off(void)
{
    800069be:	1141                	addi	sp,sp,-16
    800069c0:	e406                	sd	ra,8(sp)
    800069c2:	e022                	sd	s0,0(sp)
    800069c4:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    800069c6:	ffffb097          	auipc	ra,0xffffb
    800069ca:	8f4080e7          	jalr	-1804(ra) # 800012ba <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800069ce:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800069d2:	8b89                	andi	a5,a5,2
  if(intr_get())
    800069d4:	e78d                	bnez	a5,800069fe <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    800069d6:	5d3c                	lw	a5,120(a0)
    800069d8:	02f05b63          	blez	a5,80006a0e <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    800069dc:	37fd                	addiw	a5,a5,-1
    800069de:	0007871b          	sext.w	a4,a5
    800069e2:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    800069e4:	eb09                	bnez	a4,800069f6 <pop_off+0x38>
    800069e6:	5d7c                	lw	a5,124(a0)
    800069e8:	c799                	beqz	a5,800069f6 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800069ea:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800069ee:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800069f2:	10079073          	csrw	sstatus,a5
    intr_on();
}
    800069f6:	60a2                	ld	ra,8(sp)
    800069f8:	6402                	ld	s0,0(sp)
    800069fa:	0141                	addi	sp,sp,16
    800069fc:	8082                	ret
    panic("pop_off - interruptible");
    800069fe:	00002517          	auipc	a0,0x2
    80006a02:	f9a50513          	addi	a0,a0,-102 # 80008998 <digits+0x28>
    80006a06:	00000097          	auipc	ra,0x0
    80006a0a:	a1a080e7          	jalr	-1510(ra) # 80006420 <panic>
    panic("pop_off");
    80006a0e:	00002517          	auipc	a0,0x2
    80006a12:	fa250513          	addi	a0,a0,-94 # 800089b0 <digits+0x40>
    80006a16:	00000097          	auipc	ra,0x0
    80006a1a:	a0a080e7          	jalr	-1526(ra) # 80006420 <panic>

0000000080006a1e <release>:
{
    80006a1e:	1101                	addi	sp,sp,-32
    80006a20:	ec06                	sd	ra,24(sp)
    80006a22:	e822                	sd	s0,16(sp)
    80006a24:	e426                	sd	s1,8(sp)
    80006a26:	1000                	addi	s0,sp,32
    80006a28:	84aa                	mv	s1,a0
  if(!holding(lk))
    80006a2a:	00000097          	auipc	ra,0x0
    80006a2e:	ec6080e7          	jalr	-314(ra) # 800068f0 <holding>
    80006a32:	c115                	beqz	a0,80006a56 <release+0x38>
  lk->cpu = 0;
    80006a34:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80006a38:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80006a3c:	0f50000f          	fence	iorw,ow
    80006a40:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80006a44:	00000097          	auipc	ra,0x0
    80006a48:	f7a080e7          	jalr	-134(ra) # 800069be <pop_off>
}
    80006a4c:	60e2                	ld	ra,24(sp)
    80006a4e:	6442                	ld	s0,16(sp)
    80006a50:	64a2                	ld	s1,8(sp)
    80006a52:	6105                	addi	sp,sp,32
    80006a54:	8082                	ret
    panic("release");
    80006a56:	00002517          	auipc	a0,0x2
    80006a5a:	f6250513          	addi	a0,a0,-158 # 800089b8 <digits+0x48>
    80006a5e:	00000097          	auipc	ra,0x0
    80006a62:	9c2080e7          	jalr	-1598(ra) # 80006420 <panic>
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
