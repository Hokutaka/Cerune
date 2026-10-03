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

.text
.balign 16
.globl main
main:
	endbr64
	pushq %rbp
	movq %rsp, %rbp
	subq $48, %rsp
	movq %rsp, %rax
	movq $1069547520, 32(%rax)
	movl $4, %r9d
	movl $3, %r8d
	movl $2, %edx
	movl $1, %ecx
	callq check
	subq $-48, %rsp
	negl %eax
	addl $1, %eax
	leave
	ret
/* end function main */

/* floating point constants */
.section .rodata
.p2align 2
Lfp0:
	.int 1069547520 /* 1.500000 */
