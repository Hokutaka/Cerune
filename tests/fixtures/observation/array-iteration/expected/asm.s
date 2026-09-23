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
cerune_fn_values_0:
  pushq %rbp
  movq %rsp, %rbp
  subq $96, %rsp
  movq %rax, -40(%rbp)
  movabsq $42, %rax
  movq %rax, %rdx
  leaq .Lcerune_fmt_i64(%rip), %rcx
  callq printf
  movabsq $1, %rax
  movq %rax, -48(%rbp)
  movabsq $2, %rax
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
  subq $272, %rsp
  leaq -224(%rbp), %rax
  callq cerune_fn_values_0
  movq -224(%rbp), %rax
  movq %rax, -8(%rbp)
  movq -232(%rbp), %rax
  movq %rax, -16(%rbp)
  movabsq $2, %rax
  movq %rax, -24(%rbp)
  movabsq $0, %rax
  movq %rax, -32(%rbp)
.Lcerune_block_0: # for_condition
  movq -32(%rbp), %rax
  movq %rax, -56(%rbp)
  movq -24(%rbp), %rax
  movq %rax, %rcx
  movq -56(%rbp), %rax
  cmpq %rcx, %rax
  setl %al
  movzbq %al, %rax
  testq %rax, %rax
  je .Lcerune_block_2
  movq -32(%rbp), %rax
  movq %rax, -40(%rbp)
  movq -32(%rbp), %rax
  testq %rax, %rax
  js .Lcerune_main_array_oob_3
  cmpq $2, %rax
  jge .Lcerune_main_array_oob_3
  negq %rax
  movq -8(%rbp,%rax,8), %rax
  jmp .Lcerune_main_array_done_3
.Lcerune_main_array_oob_3:
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_0(%rip), %rdx
  movl $71, %r8d
  callq _write
  ud2
.Lcerune_main_array_done_3:
  movq %rax, -48(%rbp)
  movq -40(%rbp), %rax
  movq %rax, -56(%rbp)
  movabsq $0, %rax
  movq %rax, %rcx
  movq -56(%rbp), %rax
  cmpq %rcx, %rax
  sete %al
  movzbq %al, %rax
  testq %rax, %rax
  je .Lcerune_block_5
  jmp .Lcerune_block_1
.Lcerune_block_5: # if_end
  movq -48(%rbp), %rax
  movq %rax, -56(%rbp)
  movabsq $10, %rax
  movq %rax, %rcx
  movq -56(%rbp), %rax
  addq %rcx, %rax
  jno .Lcerune_main_integer_ok_6
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_1(%rip), %rdx
  movl $64, %r8d
  callq _write
  ud2
.Lcerune_main_integer_ok_6:
  movq %rax, -48(%rbp)
  movq -48(%rbp), %rax
  movq %rax, %rdx
  leaq .Lcerune_fmt_i64(%rip), %rcx
  callq printf
  jmp .Lcerune_block_1
.Lcerune_block_1: # for_update
  movq -32(%rbp), %rax
  movq %rax, -56(%rbp)
  movabsq $1, %rax
  movq %rax, %rcx
  movq -56(%rbp), %rax
  addq %rcx, %rax
  jno .Lcerune_main_integer_ok_7
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_2(%rip), %rdx
  movl $62, %r8d
  callq _write
  ud2
.Lcerune_main_integer_ok_7:
  movq %rax, -32(%rbp)
  jmp .Lcerune_block_0
.Lcerune_block_2: # for_end
  xorl %eax, %eax
  addq $272, %rsp
  popq %rbp
  retq

.section .rdata,"dr"
.Lcerune_failure_0:
  .asciz "cerune: runtime-v1 code=array-index-out-of-bounds node=20 bytes=69..85\n"
.Lcerune_failure_1:
  .asciz "cerune: runtime-v1 code=integer-overflow node=29 bytes=141..151\n"
.Lcerune_failure_2:
  .asciz "cerune: runtime-v1 code=integer-overflow node=35 bytes=54..98\n"
