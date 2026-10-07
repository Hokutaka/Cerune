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
.globl main
.p2align 4
main:
  pushq %rbp
  movq %rsp, %rbp
  subq $192, %rsp
  jmp .Lcerune_block_0
.Lcerune_block_0: # mir_block
  movabsq $0, %rax
  movq %rax, -8(%rbp)
  movq -8(%rbp), %rax
  movq %rax, -16(%rbp)
  movabsq $0, %rax
  movq %rax, -24(%rbp)
  movq -24(%rbp), %rax
  movq %rax, -32(%rbp)
  jmp .Lcerune_block_1
.Lcerune_block_1: # mir_block
  movq -16(%rbp), %rax
  movq %rax, -40(%rbp)
  movabsq $4, %rax
  movq %rax, -48(%rbp)
  movq -48(%rbp), %rax
  movq %rax, %rcx
  movq -40(%rbp), %rax
  cmpq %rcx, %rax
  setl %al
  movzbq %al, %rax
  movq %rax, -56(%rbp)
  movq -56(%rbp), %rax
  testq %rax, %rax
  je .Lcerune_block_3
  jmp .Lcerune_block_2
.Lcerune_block_2: # mir_block
  movq -32(%rbp), %rax
  movq %rax, -64(%rbp)
  movq -16(%rbp), %rax
  movq %rax, -72(%rbp)
  movq -72(%rbp), %rax
  movq %rax, %rcx
  movq -64(%rbp), %rax
  addq %rcx, %rax
  jno .Lcerune_main_integer_ok_8
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_0(%rip), %rdx
  movl $61, %r8d
  callq _write
  movl $7, %ecx
  int $0x29
.Lcerune_main_integer_ok_8:
  movq %rax, -80(%rbp)
  movq -80(%rbp), %rax
  movq %rax, -32(%rbp)
  movq -16(%rbp), %rax
  movq %rax, -88(%rbp)
  movabsq $2, %rax
  movq %rax, -96(%rbp)
  movq -96(%rbp), %rax
  movq %rax, %rcx
  movq -88(%rbp), %rax
  cmpq %rcx, %rax
  sete %al
  movzbq %al, %rax
  movq %rax, -104(%rbp)
  movq -104(%rbp), %rax
  testq %rax, %rax
  je .Lcerune_block_5
  jmp .Lcerune_block_4
.Lcerune_block_3: # mir_block
  movq -32(%rbp), %rax
  movq %rax, -160(%rbp)
  movq -160(%rbp), %rax
  movq %rax, %rdx
  leaq .Lcerune_fmt_i64(%rip), %rcx
  callq printf
  jmp .Lcerune_block_7
.Lcerune_block_4: # mir_block
  movabsq $1, %rax
  movq %rax, -112(%rbp)
  movq -112(%rbp), %rax
  movq %rax, -120(%rbp)
  movq -120(%rbp), %rax
  movq %rax, -128(%rbp)
  movq -128(%rbp), %rax
  testq %rax, %rax
  leaq .Lcerune_bool_false(%rip), %rcx
  leaq .Lcerune_bool_true(%rip), %rdx
  cmovne %rdx, %rcx
  callq puts
  jmp .Lcerune_block_6
.Lcerune_block_5: # mir_block
  jmp .Lcerune_block_6
.Lcerune_block_6: # mir_block
  movq -16(%rbp), %rax
  movq %rax, -136(%rbp)
  movabsq $1, %rax
  movq %rax, -144(%rbp)
  movq -144(%rbp), %rax
  movq %rax, %rcx
  movq -136(%rbp), %rax
  addq %rcx, %rax
  jno .Lcerune_main_integer_ok_9
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_1(%rip), %rdx
  movl $64, %r8d
  callq _write
  movl $7, %ecx
  int $0x29
.Lcerune_main_integer_ok_9:
  movq %rax, -152(%rbp)
  movq -152(%rbp), %rax
  movq %rax, -16(%rbp)
  jmp .Lcerune_block_1
.Lcerune_block_7: # main_exit
  xorl %eax, %eax
  addq $192, %rsp
  popq %rbp
  retq

.section .rdata,"dr"
.Lcerune_failure_0:
  .asciz "cerune: runtime-v1 code=integer-overflow node=9 bytes=67..78\n"
.Lcerune_failure_1:
  .asciz "cerune: runtime-v1 code=integer-overflow node=21 bytes=172..181\n"
