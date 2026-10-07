.section .rdata,"dr"
.Lcerune_fmt_i64:
  .asciz "%lld\n"
.Lcerune_fmt_f32:
  .asciz "%.9g\n"
.Lcerune_fmt_f64:
  .asciz "%.17g\n"
.Lcerune_bool_false:
  .asciz "false"
.Lcerune_bool_true:
  .asciz "true"
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
  .long 0x3DCCCCCD
.p2align 2
.Lcerune_f32_1:
  .long 0x3E4CCCCD

.text
.globl main
.p2align 4
main:
  pushq %rbp
  movq %rsp, %rbp
  subq $224, %rsp
  jmp .Lcerune_block_0
.Lcerune_block_0: # mir_block
  movabsq $1, %rax
  movq %rax, -8(%rbp)
  movq -8(%rbp), %rax
  movq %rax, -16(%rbp)
  movq -16(%rbp), %rax
  movq %rax, -24(%rbp)
  movq -24(%rbp), %rax
  xorq $1, %rax
  movq %rax, -32(%rbp)
  movq -32(%rbp), %rax
  movq %rax, -40(%rbp)
  movq -16(%rbp), %rax
  movq %rax, -48(%rbp)
  movabsq $1, %rax
  movq %rax, -56(%rbp)
  movq -56(%rbp), %rax
  movq %rax, %rcx
  movq -48(%rbp), %rax
  cmpq %rcx, %rax
  sete %al
  movzbq %al, %rax
  movq %rax, -64(%rbp)
  movq -64(%rbp), %rax
  movq %rax, -72(%rbp)
  movabsq $1, %rax
  movq %rax, -80(%rbp)
  movabsq $2, %rax
  movq %rax, -88(%rbp)
  movq -88(%rbp), %rax
  movq %rax, %rcx
  movq -80(%rbp), %rax
  addq %rcx, %rax
  jno .Lcerune_main_integer_ok_2
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_0(%rip), %rdx
  movl $62, %r8d
  callq _write
  movl $7, %ecx
  int $0x29
.Lcerune_main_integer_ok_2:
  movq %rax, -96(%rbp)
  movabsq $4, %rax
  movq %rax, -104(%rbp)
  movq -104(%rbp), %rax
  movq %rax, %rcx
  movq -96(%rbp), %rax
  cmpq %rcx, %rax
  setl %al
  movzbq %al, %rax
  movq %rax, -112(%rbp)
  movq -112(%rbp), %rax
  movq %rax, -120(%rbp)
  movss .Lcerune_f32_0(%rip), %xmm0
  movss %xmm0, -128(%rbp)
  movss .Lcerune_f32_1(%rip), %xmm0
  movss %xmm0, -136(%rbp)
  movss -136(%rbp), %xmm0
  movaps %xmm0, %xmm1
  movss -128(%rbp), %xmm0
  ucomiss %xmm1, %xmm0
  setne %al
  setp %cl
  orb %cl, %al
  movzbq %al, %rax
  movq %rax, -144(%rbp)
  movq -144(%rbp), %rax
  movq %rax, -152(%rbp)
  movq -16(%rbp), %rax
  movq %rax, -160(%rbp)
  movq -160(%rbp), %rax
  testq %rax, %rax
  leaq .Lcerune_bool_false(%rip), %rcx
  leaq .Lcerune_bool_true(%rip), %rdx
  cmovne %rdx, %rcx
  callq puts
  movq -40(%rbp), %rax
  movq %rax, -168(%rbp)
  movq -168(%rbp), %rax
  testq %rax, %rax
  leaq .Lcerune_bool_false(%rip), %rcx
  leaq .Lcerune_bool_true(%rip), %rdx
  cmovne %rdx, %rcx
  callq puts
  movq -72(%rbp), %rax
  movq %rax, -176(%rbp)
  movq -176(%rbp), %rax
  testq %rax, %rax
  leaq .Lcerune_bool_false(%rip), %rcx
  leaq .Lcerune_bool_true(%rip), %rdx
  cmovne %rdx, %rcx
  callq puts
  movq -120(%rbp), %rax
  movq %rax, -184(%rbp)
  movq -184(%rbp), %rax
  testq %rax, %rax
  leaq .Lcerune_bool_false(%rip), %rcx
  leaq .Lcerune_bool_true(%rip), %rdx
  cmovne %rdx, %rcx
  callq puts
  movq -152(%rbp), %rax
  movq %rax, -192(%rbp)
  movq -192(%rbp), %rax
  testq %rax, %rax
  leaq .Lcerune_bool_false(%rip), %rcx
  leaq .Lcerune_bool_true(%rip), %rdx
  cmovne %rdx, %rcx
  callq puts
  jmp .Lcerune_block_1
.Lcerune_block_1: # main_exit
  xorl %eax, %eax
  addq $224, %rsp
  popq %rbp
  retq

.section .rdata,"dr"
.Lcerune_failure_0:
  .asciz "cerune: runtime-v1 code=integer-overflow node=11 bytes=94..99\n"
