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
cerune_fn_add_0:
  pushq %rbp
  movq %rsp, %rbp
  subq $80, %rsp
  movq %rcx, -8(%rbp)
  movq %rdx, -16(%rbp)
  jmp .Lcerune_fn_0_block_0
.Lcerune_fn_0_block_0: # mir_block
  movq -8(%rbp), %rax
  movq %rax, -24(%rbp)
  movq -16(%rbp), %rax
  movq %rax, -32(%rbp)
  movq -32(%rbp), %rax
  movq %rax, %rcx
  movq -24(%rbp), %rax
  addq %rcx, %rax
  jno .Lcerune_fn_0_integer_ok_3
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_0(%rip), %rdx
  movl $61, %r8d
  callq _write
  movl $7, %ecx
  int $0x29
.Lcerune_fn_0_integer_ok_3:
  movq %rax, -40(%rbp)
  movq -40(%rbp), %rax
  addq $80, %rsp
  popq %rbp
  retq
.Lcerune_fn_0_block_1: # mir_block
  ud2

.p2align 4
cerune_fn_show_1:
  pushq %rbp
  movq %rsp, %rbp
  subq $48, %rsp
  movq %rcx, -8(%rbp)
  jmp .Lcerune_fn_1_block_0
.Lcerune_fn_1_block_0: # mir_block
  movq -8(%rbp), %rax
  movq %rax, -16(%rbp)
  movq -16(%rbp), %rax
  movq %rax, %rdx
  leaq .Lcerune_fmt_i64(%rip), %rcx
  callq printf
  addq $48, %rsp
  popq %rbp
  retq

.globl main
.p2align 4
main:
  pushq %rbp
  movq %rsp, %rbp
  subq $80, %rsp
  jmp .Lcerune_block_0
.Lcerune_block_0: # mir_block
  movabsq $20, %rax
  movq %rax, -8(%rbp)
  movabsq $22, %rax
  movq %rax, -16(%rbp)
  movq -8(%rbp), %rcx
  movq -16(%rbp), %rdx
  callq cerune_fn_add_0
  movq %rax, -24(%rbp)
  movq -24(%rbp), %rax
  movq %rax, -32(%rbp)
  movq -32(%rbp), %rax
  movq %rax, -40(%rbp)
  movq -40(%rbp), %rcx
  callq cerune_fn_show_1
  jmp .Lcerune_block_1
.Lcerune_block_1: # main_exit
  xorl %eax, %eax
  addq $80, %rsp
  popq %rbp
  retq

.section .rdata,"dr"
.Lcerune_failure_0:
  .asciz "cerune: runtime-v1 code=integer-overflow node=1 bytes=50..62\n"
