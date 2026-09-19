.section .rdata,"dr"
.Lcerune_fmt_i64:
  .asciz "%lld\n"
.Lcerune_fmt_f32:
  .asciz "%.9g\n"
.Lcerune_fmt_f64:
  .asciz "%.17g\n"
.p2align 4
.Lcerune_sign_f32:
  .long 0x80000000
  .long 0
  .long 0
  .long 0
.p2align 4
.Lcerune_sign_f64:
  .quad 0x8000000000000000
  .quad 0

.text
.globl main
.p2align 4
main:
  pushq %rbp
  movq %rsp, %rbp
  subq $80, %rsp
  movabsq $1, %rax
  movq %rax, -16(%rbp)
  movabsq $2, %rax
  movq %rax, %rcx
  movq -16(%rbp), %rax
  addq %rcx, %rax
  jno .Lcerune_main_integer_ok_0
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_0(%rip), %rdx
  movl $60, %r8d
  callq _write
  ud2
.Lcerune_main_integer_ok_0:
  movq %rax, -8(%rbp)
  movq -8(%rbp), %rax
  movq %rax, %rdx
  leaq .Lcerune_fmt_i64(%rip), %rcx
  callq printf
  xorl %eax, %eax
  addq $80, %rsp
  popq %rbp
  retq

.section .rdata,"dr"
.Lcerune_failure_0:
  .asciz "cerune: runtime-v1 code=integer-overflow node=1 bytes=9..14\n"
