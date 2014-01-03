SECTIONS
{
	. = 0x7c00;
	.text :
	{
	_ftest = .;
	} = 0	/* 程序加载到内存0x7c00处 */
}