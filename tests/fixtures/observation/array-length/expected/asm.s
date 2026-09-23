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

.text
.p2align 4
cerune_fn_values_0:
  pushq %rbp
  movq %rsp, %rbp
  subq $96, %rsp
  movq %rax, -40(%rbp)
  movabsq $42, %rax
  movq %rax, %rdx
  leaq .Lcerune_fmt_i64(%rip), %rcx
  callq printf
  movabsq $10, %rax
  movq %rax, -48(%rbp)
  movabsq $20, %rax
  movq %rax, -56(%rbp)
  movq -40(%rbp), %r11
  movq -48(%rbp), %r10
  movq %r10, 0(%r11)
  movq -56(%rbp), %r10
  movq %r10, -8(%r11)
  addq $96, %rsp
  popq %rbp
  retq

.globl main
.p2align 4
main:
  pushq %rbp
  movq %rsp, %rbp
  subq $128, %rsp
  leaq -72(%rbp), %rax
  callq cerune_fn_values_0
  movabsq $2, %rax
  movq %rax, %rdx
  leaq .Lcerune_fmt_i64(%rip), %rcx
  callq printf
  movabsq $0, %rax
  testq %rax, %rax
  je .Lcerune_block_0
  leaq -88(%rbp), %rax
  callq cerune_fn_values_0
  movabsq $2, %rax
  movq %rax, -8(%rbp)
  movabsq $2, %rax
  movq %rax, %rcx
  movq -8(%rbp), %rax
  cmpq %rcx, %rax
  sete %al
  movzbq %al, %rax
  jmp .Lcerune_block_1
.Lcerune_block_0: # logical_false
.Lcerune_block_1: # logical_end
  testq %rax, %rax
  leaq .Lcerune_bool_false(%rip), %rcx
  leaq .Lcerune_bool_true(%rip), %rdx
  cmovne %rdx, %rcx
  callq puts
  xorl %eax, %eax
  addq $128, %rsp
  popq %rbp
  retq
