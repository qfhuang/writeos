	#include "pm.h"

	.code16
	.text
	jmp LABEL_START

	/* 数据段 */
	/* 描述符表                   段基址　　　　            　段界限　　　　 		段属性　　　 */
LABEL_GDT:		Descriptor	0,	                 0,		 	0 	/* 空描述符 */
LABEL_DESC_CODE32:	Descriptor	0,	(SegCode32Len - 1),          DA_C + DA_32 	/* ３２位非一致代码段 */
LABEL_DESC_VIDEO:	Descriptor	0x8b00,             0xffff,          DA_DRW             /* 数据段（读写） */

	.set GDTLen, (. - LABLE_GDT) /* GDT长度 */
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

	mov $0x100, %sp

	/* 初始化32位代码段描述符基地址 */
	xor eax, eax
	mov %ds, %ax
	shl $4, %eax
	addl  $(LABEL_SEG_CODE32), %eax
	

	/* 初始化GDTPtr基址，为加载gdtr作准备 */

	/* 加载gdtr */
	
	/* 关中断 */

	/* 打开A20地址线 */

	/* 打开CR0保护模式位 */

	/* 装载段选择子和偏移，跳入32位代码 */

	.code32
	.data
LABEL_SEG_CODE32:
	/* 直接写显存 */
	
	

	


	
	
