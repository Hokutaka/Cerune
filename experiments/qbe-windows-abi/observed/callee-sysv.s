.text
.balign 16
.globl check
check:
	endbr64
	ucomiss ".Lfp0"(%rip), %xmm0
	setz %al
	movzbl %al, %eax
	setnp %cl
	movzbl %cl, %ecx
	andl %ecx, %eax
	ret
.type check, @function
.size check, .-check
/* end function check */

/* floating point constants */
.section .rodata
.p2align 2
.Lfp0:
	.int 1069547520 /* 1.500000 */

.section .note.GNU-stack,"",@progbits
