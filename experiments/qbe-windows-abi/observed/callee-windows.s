.text
.balign 16
.globl check
check:
	endbr64
	movq 40(%rsp), %rax
	ucomiss "Lfp0"(%rip), %rax
	setz %al
	movzbl %al, %eax
	setnp %cl
	movzbl %cl, %ecx
	andl %ecx, %eax
	ret
/* end function check */

/* floating point constants */
.section .rodata
.p2align 2
Lfp0:
	.int 1069547520 /* 1.500000 */
