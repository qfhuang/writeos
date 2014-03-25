.code16				/* 使用16位模式汇编 */
.text				/* 代码段开始 */
	mov %cs,%ax
	mov %ax,%ds
	mov %ax,%es		/* 初始化段寄存器 */
	call DispStr		/* 调用显示字符串例程 */
	jmp .			/* 无限循环 */
DispStr:
	mov $BootMessage,%ax
	mov %ax,%bp		/* es:bp = 串地址 */
	mov $17,%cx		/* cx = 串长度 */
	mov $0x1301,%ax		/* ah = 13h, al = 01h */
	mov $0x000c,%bx		/* bh = 0 页号为0，bl = 0c 黑底红字高亮 */
	mov $0,%dl
	int $0x10		/* 10号中断 */
BootMessage:	.ascii "Hello, OS world!!"
.org 510
.word 0xaa55