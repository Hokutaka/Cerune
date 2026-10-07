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
  movabsq $1, %rax
  movq %rax, -16(%rbp)
  movabsq $2, %rax
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
  subq $288, %rsp
  jmp .Lcerune_block_0
.Lcerune_block_0: # mir_block
  leaq -8(%rbp), %rax
  callq cerune_fn_values_0
  movq -8(%rbp), %rax
  movq %rax, -24(%rbp)
  movq -16(%rbp), %rax
  movq %rax, -32(%rbp)
  movq -24(%rbp), %rax
  movq %rax, -40(%rbp)
  movq -32(%rbp), %rax
  movq %rax, -48(%rbp)
  movabsq $2, %rax
  movq %rax, -56(%rbp)
  movq -56(%rbp), %rax
  movq %rax, -64(%rbp)
  movabsq $0, %rax
  movq %rax, -72(%rbp)
  movq -72(%rbp), %rax
  movq %rax, -80(%rbp)
  jmp .Lcerune_block_1
.Lcerune_block_1: # mir_block
  movq -80(%rbp), %rax
  movq %rax, -88(%rbp)
  movq -64(%rbp), %rax
  movq %rax, -96(%rbp)
  movq -96(%rbp), %rax
  movq %rax, %rcx
  movq -88(%rbp), %rax
  cmpq %rcx, %rax
  setl %al
  movzbq %al, %rax
  movq %rax, -104(%rbp)
  movq -104(%rbp), %rax
  testq %rax, %rax
  je .Lcerune_block_3
  jmp .Lcerune_block_2
.Lcerune_block_2: # mir_block
  movq -80(%rbp), %rax
  movq %rax, -112(%rbp)
  movq -112(%rbp), %rax
  movq %rax, -120(%rbp)
  movq -24(%rbp), %rax
  movq %rax, -128(%rbp)
  movq -32(%rbp), %rax
  movq %rax, -136(%rbp)
  movq -80(%rbp), %rax
  movq %rax, -144(%rbp)
  movq -144(%rbp), %rax
  testq %rax, %rax
  js .Lcerune_main_array_oob_10
  cmpq $2, %rax
  jge .Lcerune_main_array_oob_10
  imulq $-1, %rax
  leaq -128(%rbp,%rax,8), %rcx
  movq %rcx, -248(%rbp)
  jmp .Lcerune_main_array_done_10
.Lcerune_main_array_oob_10:
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_0(%rip), %rdx
  movl $71, %r8d
  callq _write
  movl $7, %ecx
  int $0x29
.Lcerune_main_array_done_10:
  movq -248(%rbp), %r11
  movq (%r11), %rax
  movq %rax, -152(%rbp)
  movq -152(%rbp), %rax
  movq %rax, -160(%rbp)
  movq -120(%rbp), %rax
  movq %rax, -168(%rbp)
  movabsq $0, %rax
  movq %rax, -176(%rbp)
  movq -176(%rbp), %rax
  movq %rax, %rcx
  movq -168(%rbp), %rax
  cmpq %rcx, %rax
  sete %al
  movzbq %al, %rax
  movq %rax, -184(%rbp)
  movq -184(%rbp), %rax
  testq %rax, %rax
  je .Lcerune_block_6
  jmp .Lcerune_block_5
.Lcerune_block_3: # mir_block
  jmp .Lcerune_block_9
.Lcerune_block_4: # mir_block
  movq -80(%rbp), %rax
  movq %rax, -224(%rbp)
  movabsq $1, %rax
  movq %rax, -232(%rbp)
  movq -232(%rbp), %rax
  movq %rax, %rcx
  movq -224(%rbp), %rax
  addq %rcx, %rax
  jno .Lcerune_main_integer_ok_11
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_1(%rip), %rdx
  movl $62, %r8d
  callq _write
  movl $7, %ecx
  int $0x29
.Lcerune_main_integer_ok_11:
  movq %rax, -240(%rbp)
  movq -240(%rbp), %rax
  movq %rax, -80(%rbp)
  jmp .Lcerune_block_1
.Lcerune_block_5: # mir_block
  jmp .Lcerune_block_4
.Lcerune_block_6: # mir_block
  jmp .Lcerune_block_7
.Lcerune_block_7: # mir_block
  movq -160(%rbp), %rax
  movq %rax, -192(%rbp)
  movabsq $10, %rax
  movq %rax, -200(%rbp)
  movq -200(%rbp), %rax
  movq %rax, %rcx
  movq -192(%rbp), %rax
  addq %rcx, %rax
  jno .Lcerune_main_integer_ok_12
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_2(%rip), %rdx
  movl $64, %r8d
  callq _write
  movl $7, %ecx
  int $0x29
.Lcerune_main_integer_ok_12:
  movq %rax, -208(%rbp)
  movq -208(%rbp), %rax
  movq %rax, -160(%rbp)
  movq -160(%rbp), %rax
  movq %rax, -216(%rbp)
  movq -216(%rbp), %rax
  movq %rax, %rdx
  leaq .Lcerune_fmt_i64(%rip), %rcx
  callq printf
  jmp .Lcerune_block_4
.Lcerune_block_8: # mir_block
  jmp .Lcerune_block_7
.Lcerune_block_9: # main_exit
  xorl %eax, %eax
  addq $288, %rsp
  popq %rbp
  retq

.section .rdata,"dr"
.Lcerune_failure_0:
  .asciz "cerune: runtime-v1 code=array-index-out-of-bounds node=20 bytes=69..85\n"
.Lcerune_failure_1:
  .asciz "cerune: runtime-v1 code=integer-overflow node=35 bytes=54..98\n"
.Lcerune_failure_2:
  .asciz "cerune: runtime-v1 code=integer-overflow node=29 bytes=141..151\n"
