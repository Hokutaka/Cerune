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
.p2align 4
cerune_fn_value_0:
  pushq %rbp
  movq %rsp, %rbp
  subq $48, %rsp
  jmp .Lcerune_fn_0_block_0
.Lcerune_fn_0_block_0: # mir_block
  movabsq $7, %rax
  movq %rax, -8(%rbp)
  movq -8(%rbp), %rax
  movq %rax, %rdx
  leaq .Lcerune_fmt_i64(%rip), %rcx
  callq printf
  movabsq $42, %rax
  movq %rax, -16(%rbp)
  movq -16(%rbp), %rax
  addq $48, %rsp
  popq %rbp
  retq
.Lcerune_fn_0_block_1: # mir_block
  ud2

.globl main
.p2align 4
main:
  pushq %rbp
  movq %rsp, %rbp
  subq $96, %rsp
  jmp .Lcerune_block_0
.Lcerune_block_0: # mir_block
  callq cerune_fn_value_0
  movq %rax, -8(%rbp)
  movq -8(%rbp), %rax
  movq %rax, -16(%rbp)
  movq -16(%rbp), %rax
  movq %rax, -24(%rbp)
  movq -24(%rbp), %rax
  movq %rax, -32(%rbp)
  movq -32(%rbp), %rax
  movq %rax, -40(%rbp)
  movq -40(%rbp), %rax
  movq %rax, -48(%rbp)
  movq -48(%rbp), %rax
  movq %rax, -56(%rbp)
  movq -56(%rbp), %rax
  movq %rax, %rdx
  leaq .Lcerune_fmt_i64(%rip), %rcx
  callq printf
  jmp .Lcerune_block_1
.Lcerune_block_1: # main_exit
  xorl %eax, %eax
  addq $96, %rsp
  popq %rbp
  retq
