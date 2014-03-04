	#include "pm.h"

	.code16
	.text
	jmp LABEL_START

	/* 数据段 */
	/* 描述符表                   段基址　　　　            　段界限　　　　 		段属性　　　 */
LABEL_GDT:		Descriptor	0,	                 0,		 	0 	/* 空描述符 */
LABEL_DESC_CODE32:	Descriptor	0,	(SegCode32Len - 1),          DA_C + DA_32 	/* ３２位非一致代码段 */
LABEL_DESC_VIDEO:	Descriptor	0xB8000,             0xffff,          DA_DRW             /* 数据段（读写） */

	.set GDTLen, (. - LABEL_GDT) /* GDT长度 */
GDTPtr:	.2byte (GDTLen - 1) 	/* GDT界限 */
	.4byte 0		/* GDT基址 */

        /* 选择子 */
	.set SelectorCode32, (LABEL_DESC_CODE32 - LABEL_GDT)
	.set SelectorVideo, (LABEL_DESC_VIDEO - LABEL_GDT)

LABEL_START:
	mov %cs, %ax
	mov %ax, %ds
	mov %ax, %es
	mov %ax, %ss		/* 初始化段寄存器，使数据段与代码段的基地址一致 */

	mov $0x100,%sp
	
	/* 初始化32位代码段描述符基地址(运行时) */
	xor %eax, %eax
	mov %cs, %ax
	shl $4, %eax
	addl $(LABEL_SEG_CODE32), %eax /* seg >> 4 + offset 求出段基址 */
	movw %ax,(LABEL_DESC_CODE32 + 2)
	shr $16, %eax
	movb %al, (LABEL_DESC_CODE32 + 4)
	movb %ah, (LABEL_DESC_CODE32 + 7)
	
	/* 为加载gdtr作准备 */
	xor %eax, %eax
	mov %cs, %ax
	shl $4, %eax
	addl $(LABEL_GDT), %eax /* seg >> 4 + offset 求ＧＤＴ基址 */
	movl %eax, (GDTPtr + 2)

	/* 加载gdtr */
	lgdtw GDTPtr
	
	/* 关中断 */
	cli

	/* 打开A20地址线 */
	inb $0x92, %al
	orb $0b00000010, %al 	/* 置Ａ２０地址线位 */
	outb %al, $0x92

	/* 打开CR0保护模式位 */
	movl %cr0, %eax
	orl $1, %eax
	movl %eax, %cr0

	/* 装载段选择子和偏移，跳入32位代码 */
	ljmpl $SelectorCode32, $0  

	.code32
	.data
LABEL_SEG_CODE32:
	/* 直接写显存 */
	mov $SelectorVideo, %ax
	mov %ax, %gs		/* 设置数据段寄存器 */

	movl $((80 * 10 + 0) * 2), %edi	/* 目标 */
	movb $0xC, %ah			/* 0000 黑色背景色 1100 红色前景色 */
	movb 'P', %al
        mov %ax, %gs:(%edi)

	jmp .
	
.set SegCode32Len, . - LABEL_SEG_CODE32
	
	
	

	


	
	
