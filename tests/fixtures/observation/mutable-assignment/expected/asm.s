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
.p2align 2
.Lcerune_f32_0:
  .long 0x3E800000
.p2align 2
.Lcerune_f32_1:
  .long 0x40000000

.text
.globl main
.p2align 4
main:
  pushq %rbp
  movq %rsp, %rbp
  subq $128, %rsp
  jmp .Lcerune_block_0
.Lcerune_block_0: # mir_block
  movabsq $40, %rax
  movq %rax, -8(%rbp)
  movq -8(%rbp), %rax
  movq %rax, -16(%rbp)
  movq -16(%rbp), %rax
  movq %rax, -24(%rbp)
  movabsq $2, %rax
  movq %rax, -32(%rbp)
  movq -32(%rbp), %rax
  movq %rax, %rcx
  movq -24(%rbp), %rax
  addq %rcx, %rax
  jno .Lcerune_main_integer_ok_2
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_0(%rip), %rdx
  movl $61, %r8d
  callq _write
  movl $7, %ecx
  int $0x29
.Lcerune_main_integer_ok_2:
  movq %rax, -40(%rbp)
  movq -40(%rbp), %rax
  movq %rax, -16(%rbp)
  movss .Lcerune_f32_0(%rip), %xmm0
  movss %xmm0, -48(%rbp)
  movss -48(%rbp), %xmm0
  movss %xmm0, -56(%rbp)
  movss -56(%rbp), %xmm0
  movss %xmm0, -64(%rbp)
  movss .Lcerune_f32_1(%rip), %xmm0
  movss %xmm0, -72(%rbp)
  movss -72(%rbp), %xmm0
  movaps %xmm0, %xmm1
  movss -64(%rbp), %xmm0
  mulss %xmm1, %xmm0
  movss %xmm0, -80(%rbp)
  movss -80(%rbp), %xmm0
  movss %xmm0, -56(%rbp)
  movq -16(%rbp), %rax
  movq %rax, -88(%rbp)
  movq -88(%rbp), %rax
  movq %rax, %rdx
  leaq .Lcerune_fmt_i64(%rip), %rcx
  callq printf
  movss -56(%rbp), %xmm0
  movss %xmm0, -96(%rbp)
  movss -96(%rbp), %xmm0
  cvtss2sd %xmm0, %xmm1
  movq %xmm1, %rdx
  leaq .Lcerune_fmt_f32(%rip), %rcx
  callq printf
  jmp .Lcerune_block_1
.Lcerune_block_1: # main_exit
  xorl %eax, %eax
  addq $128, %rsp
  popq %rbp
  retq

.section .rdata,"dr"
.Lcerune_failure_0:
  .asciz "cerune: runtime-v1 code=integer-overflow node=3 bytes=29..38\n"
