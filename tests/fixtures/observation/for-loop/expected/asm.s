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
  subq $176, %rsp
  movabsq $0, %rax
  movq %rax, -8(%rbp)
  movabsq $0, %rax
  movq %rax, -16(%rbp)
.Lcerune_block_0: # for_condition
  movq -16(%rbp), %rax
  movq %rax, -24(%rbp)
  movabsq $6, %rax
  movq %rax, %rcx
  movq -24(%rbp), %rax
  cmpq %rcx, %rax
  setl %al
  movzbq %al, %rax
  testq %rax, %rax
  je .Lcerune_block_2
  movq -16(%rbp), %rax
  movq %rax, -24(%rbp)
  movabsq $2, %rax
  movq %rax, %rcx
  movq -24(%rbp), %rax
  cmpq %rcx, %rax
  setl %al
  movzbq %al, %rax
  testq %rax, %rax
  je .Lcerune_block_4
  jmp .Lcerune_block_1
.Lcerune_block_4: # if_end
  movq -8(%rbp), %rax
  movq %rax, -24(%rbp)
  movq -16(%rbp), %rax
  movq %rax, %rcx
  movq -24(%rbp), %rax
  addq %rcx, %rax
  jno .Lcerune_main_integer_ok_5
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_0(%rip), %rdx
  movl $64, %r8d
  callq _write
  ud2
.Lcerune_main_integer_ok_5:
  movq %rax, -8(%rbp)
  jmp .Lcerune_block_1
.Lcerune_block_1: # for_update
  movq -16(%rbp), %rax
  movq %rax, -24(%rbp)
  movabsq $1, %rax
  movq %rax, %rcx
  movq -24(%rbp), %rax
  addq %rcx, %rax
  jno .Lcerune_main_integer_ok_6
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_1(%rip), %rdx
  movl $62, %r8d
  callq _write
  ud2
.Lcerune_main_integer_ok_6:
  movq %rax, -16(%rbp)
  jmp .Lcerune_block_0
.Lcerune_block_2: # for_end
  movq -8(%rbp), %rax
  movq %rax, %rdx
  leaq .Lcerune_fmt_i64(%rip), %rcx
  callq printf
  xorl %eax, %eax
  addq $176, %rsp
  popq %rbp
  retq

.section .rdata,"dr"
.Lcerune_failure_0:
  .asciz "cerune: runtime-v1 code=integer-overflow node=14 bytes=110..117\n"
.Lcerune_failure_1:
  .asciz "cerune: runtime-v1 code=integer-overflow node=18 bytes=51..56\n"
