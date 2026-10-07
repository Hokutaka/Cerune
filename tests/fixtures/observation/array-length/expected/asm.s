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
  subq $80, %rsp
  movq %rax, -48(%rbp)
  jmp .Lcerune_fn_0_block_0
.Lcerune_fn_0_block_0: # mir_block
  movabsq $42, %rax
  movq %rax, -8(%rbp)
  movq -8(%rbp), %rax
  movq %rax, %rdx
  leaq .Lcerune_fmt_i64(%rip), %rcx
  callq printf
  movabsq $10, %rax
  movq %rax, -16(%rbp)
  movabsq $20, %rax
  movq %rax, -24(%rbp)
  movq -16(%rbp), %rax
  movq %rax, -32(%rbp)
  movq -24(%rbp), %rax
  movq %rax, -40(%rbp)
  movq -48(%rbp), %r11
  movq -32(%rbp), %r10
  movq %r10, 0(%r11)
  movq -40(%rbp), %r10
  movq %r10, -8(%r11)
  addq $80, %rsp
  popq %rbp
  retq
.Lcerune_fn_0_block_1: # mir_block
  ud2

.globl main
.p2align 4
main:
  pushq %rbp
  movq %rsp, %rbp
  subq $112, %rsp
  jmp .Lcerune_block_0
.Lcerune_block_0: # mir_block
  leaq -8(%rbp), %rax
  callq cerune_fn_values_0
  movabsq $2, %rax
  movq %rax, -24(%rbp)
  movq -24(%rbp), %rax
  movq %rax, %rdx
  leaq .Lcerune_fmt_i64(%rip), %rcx
  callq printf
  movabsq $0, %rax
  movq %rax, -32(%rbp)
  movq -32(%rbp), %rax
  movq %rax, -40(%rbp)
  movq -32(%rbp), %rax
  testq %rax, %rax
  je .Lcerune_block_2
  jmp .Lcerune_block_1
.Lcerune_block_1: # mir_block
  leaq -48(%rbp), %rax
  callq cerune_fn_values_0
  movabsq $2, %rax
  movq %rax, -64(%rbp)
  movabsq $2, %rax
  movq %rax, -72(%rbp)
  movq -72(%rbp), %rax
  movq %rax, %rcx
  movq -64(%rbp), %rax
  cmpq %rcx, %rax
  sete %al
  movzbq %al, %rax
  movq %rax, -80(%rbp)
  movq -80(%rbp), %rax
  movq %rax, -40(%rbp)
  jmp .Lcerune_block_2
.Lcerune_block_2: # mir_block
  movq -40(%rbp), %rax
  testq %rax, %rax
  leaq .Lcerune_bool_false(%rip), %rcx
  leaq .Lcerune_bool_true(%rip), %rdx
  cmovne %rdx, %rcx
  callq puts
  jmp .Lcerune_block_3
.Lcerune_block_3: # main_exit
  xorl %eax, %eax
  addq $112, %rsp
  popq %rbp
  retq
