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
cerune_fn_report_0:
  pushq %rbp
  movq %rsp, %rbp
  subq $64, %rsp
  movq %rcx, -8(%rbp)
  movq -8(%rbp), %rax
  testq %rax, %rax
  leaq .Lcerune_bool_false(%rip), %rcx
  leaq .Lcerune_bool_true(%rip), %rdx
  cmovne %rdx, %rcx
  callq puts
  movq -8(%rbp), %rax
  addq $64, %rsp
  popq %rbp
  retq

.globl main
.p2align 4
main:
  pushq %rbp
  movq %rsp, %rbp
  subq $320, %rsp
  movabsq $4, %rax
  movq %rax, -272(%rbp)
  movabsq $9, %rax
  movq %rax, -280(%rbp)
  movq -272(%rbp), %rax
  movq %rax, -8(%rbp)
  movq -280(%rbp), %rax
  movq %rax, -16(%rbp)
  movabsq $2, %rax
  movq %rax, -24(%rbp)
  movq -24(%rbp), %rax
  movq %rax, -32(%rbp)
  movabsq $2, %rax
  movq %rax, %rcx
  movq -32(%rbp), %rax
  cmpq %rcx, %rax
  setl %al
  movzbq %al, %rax
  testq %rax, %rax
  je .Lcerune_block_0
  movq -24(%rbp), %rax
  testq %rax, %rax
  js .Lcerune_main_array_oob_2
  cmpq $2, %rax
  jge .Lcerune_main_array_oob_2
  negq %rax
  movq -8(%rbp,%rax,8), %rax
  jmp .Lcerune_main_array_done_2
.Lcerune_main_array_oob_2:
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_0(%rip), %rdx
  movl $73, %r8d
  callq _write
  ud2
.Lcerune_main_array_done_2:
  movq %rax, -32(%rbp)
  movabsq $0, %rax
  movq %rax, %rcx
  movq -32(%rbp), %rax
  cmpq %rcx, %rax
  setg %al
  movzbq %al, %rax
  jmp .Lcerune_block_1
.Lcerune_block_0: # logical_false
.Lcerune_block_1: # logical_end
  testq %rax, %rax
  leaq .Lcerune_bool_false(%rip), %rcx
  leaq .Lcerune_bool_true(%rip), %rdx
  cmovne %rdx, %rcx
  callq puts
  movq -24(%rbp), %rax
  movq %rax, -32(%rbp)
  movabsq $2, %rax
  movq %rax, %rcx
  movq -32(%rbp), %rax
  cmpq %rcx, %rax
  sete %al
  movzbq %al, %rax
  testq %rax, %rax
  je .Lcerune_block_3
  jmp .Lcerune_block_4
.Lcerune_block_3: # logical_false
  movabsq $0, %rax
  movq %rax, -32(%rbp)
  movq -32(%rbp), %rcx
  callq cerune_fn_report_0
.Lcerune_block_4: # logical_end
  testq %rax, %rax
  leaq .Lcerune_bool_false(%rip), %rcx
  leaq .Lcerune_bool_true(%rip), %rdx
  cmovne %rdx, %rcx
  callq puts
  movabsq $0, %rax
  testq %rax, %rax
  je .Lcerune_block_5
  jmp .Lcerune_block_6
.Lcerune_block_5: # logical_false
  movabsq $1, %rax
  movq %rax, -32(%rbp)
  movq -32(%rbp), %rcx
  callq cerune_fn_report_0
  testq %rax, %rax
  je .Lcerune_block_7
  movq -24(%rbp), %rax
  movq %rax, -32(%rbp)
  movabsq $0, %rax
  movq %rax, %rcx
  movq -32(%rbp), %rax
  cmpq %rcx, %rax
  setg %al
  movzbq %al, %rax
  testq %rax, %rax
  je .Lcerune_block_9
  jmp .Lcerune_block_10
.Lcerune_block_9: # logical_false
  movabsq $0, %rax
  movq %rax, -32(%rbp)
  movq -32(%rbp), %rcx
  callq cerune_fn_report_0
.Lcerune_block_10: # logical_end
  jmp .Lcerune_block_8
.Lcerune_block_7: # logical_false
.Lcerune_block_8: # logical_end
.Lcerune_block_6: # logical_end
  testq %rax, %rax
  leaq .Lcerune_bool_false(%rip), %rcx
  leaq .Lcerune_bool_true(%rip), %rdx
  cmovne %rdx, %rcx
  callq puts
  xorl %eax, %eax
  addq $320, %rsp
  popq %rbp
  retq

.section .rdata,"dr"
.Lcerune_failure_0:
  .asciz "cerune: runtime-v1 code=array-index-out-of-bounds node=16 bytes=134..147\n"
