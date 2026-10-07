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
cerune_fn_total_0:
  pushq %rbp
  movq %rsp, %rbp
  subq $144, %rsp
  movq 0(%rcx), %r10
  movq %r10, -8(%rbp)
  movq -8(%rcx), %r10
  movq %r10, -16(%rbp)
  jmp .Lcerune_fn_0_block_0
.Lcerune_fn_0_block_0: # mir_block
  movq -8(%rbp), %rax
  movq %rax, -24(%rbp)
  movq -16(%rbp), %rax
  movq %rax, -32(%rbp)
  movabsq $0, %rax
  movq %rax, -40(%rbp)
  movq -40(%rbp), %rax
  testq %rax, %rax
  js .Lcerune_fn_0_array_oob_3
  cmpq $2, %rax
  jge .Lcerune_fn_0_array_oob_3
  imulq $-1, %rax
  leaq -24(%rbp,%rax,8), %rcx
  movq %rcx, -96(%rbp)
  jmp .Lcerune_fn_0_array_done_3
.Lcerune_fn_0_array_oob_3:
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_0(%rip), %rdx
  movl $72, %r8d
  callq _write
  movl $7, %ecx
  int $0x29
.Lcerune_fn_0_array_done_3:
  movq -96(%rbp), %r11
  movq (%r11), %rax
  movq %rax, -48(%rbp)
  movq -8(%rbp), %rax
  movq %rax, -56(%rbp)
  movq -16(%rbp), %rax
  movq %rax, -64(%rbp)
  movabsq $1, %rax
  movq %rax, -72(%rbp)
  movq -72(%rbp), %rax
  testq %rax, %rax
  js .Lcerune_fn_0_array_oob_4
  cmpq $2, %rax
  jge .Lcerune_fn_0_array_oob_4
  imulq $-1, %rax
  leaq -56(%rbp,%rax,8), %rcx
  movq %rcx, -104(%rbp)
  jmp .Lcerune_fn_0_array_done_4
.Lcerune_fn_0_array_oob_4:
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_1(%rip), %rdx
  movl $73, %r8d
  callq _write
  movl $7, %ecx
  int $0x29
.Lcerune_fn_0_array_done_4:
  movq -104(%rbp), %r11
  movq (%r11), %rax
  movq %rax, -80(%rbp)
  movq -80(%rbp), %rax
  movq %rax, %rcx
  movq -48(%rbp), %rax
  addq %rcx, %rax
  jno .Lcerune_fn_0_integer_ok_5
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_2(%rip), %rdx
  movl $63, %r8d
  callq _write
  movl $7, %ecx
  int $0x29
.Lcerune_fn_0_integer_ok_5:
  movq %rax, -88(%rbp)
  movq -88(%rbp), %rax
  addq $144, %rsp
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
  movabsq $3, %rax
  movq %rax, -8(%rbp)
  movabsq $4, %rax
  movq %rax, -16(%rbp)
  movq -8(%rbp), %rax
  movq %rax, -24(%rbp)
  movq -16(%rbp), %rax
  movq %rax, -32(%rbp)
  movq -24(%rbp), %rax
  movq %rax, -40(%rbp)
  movq -32(%rbp), %rax
  movq %rax, -48(%rbp)
  movq -40(%rbp), %rax
  movq %rax, -56(%rbp)
  movq -48(%rbp), %rax
  movq %rax, -64(%rbp)
  leaq -56(%rbp), %rcx
  callq cerune_fn_total_0
  movq %rax, -72(%rbp)
  movq -72(%rbp), %rax
  movq %rax, %rdx
  leaq .Lcerune_fmt_i64(%rip), %rcx
  callq printf
  jmp .Lcerune_block_1
.Lcerune_block_1: # main_exit
  xorl %eax, %eax
  addq $112, %rsp
  popq %rbp
  retq

.section .rdata,"dr"
.Lcerune_failure_0:
  .asciz "cerune: runtime-v1 code=array-index-out-of-bounds node=11 bytes=97..106\n"
.Lcerune_failure_1:
  .asciz "cerune: runtime-v1 code=array-index-out-of-bounds node=14 bytes=109..118\n"
.Lcerune_failure_2:
  .asciz "cerune: runtime-v1 code=integer-overflow node=10 bytes=97..118\n"
