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
.Lcerune_fmt_u64:
  .asciz "%llu\n"

.text
.p2align 4
cerune_fn__generic_0_first_0:
  pushq %rbp
  movq %rsp, %rbp
  subq $96, %rsp
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
  movq %rcx, -56(%rbp)
  jmp .Lcerune_fn_0_array_done_3
.Lcerune_fn_0_array_oob_3:
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_0(%rip), %rdx
  movl $70, %r8d
  callq _write
  movl $7, %ecx
  int $0x29
.Lcerune_fn_0_array_done_3:
  movq -56(%rbp), %r11
  movq (%r11), %rax
  movq %rax, -48(%rbp)
  movq -48(%rbp), %rax
  addq $96, %rsp
  popq %rbp
  retq
.Lcerune_fn_0_block_1: # mir_block
  ud2

.p2align 4
cerune_fn__generic_1_first_1:
  pushq %rbp
  movq %rsp, %rbp
  subq $80, %rsp
  movq 0(%rcx), %r10
  movq %r10, -8(%rbp)
  jmp .Lcerune_fn_1_block_0
.Lcerune_fn_1_block_0: # mir_block
  movq -8(%rbp), %rax
  movq %rax, -16(%rbp)
  movabsq $0, %rax
  movq %rax, -24(%rbp)
  movq -24(%rbp), %rax
  testq %rax, %rax
  js .Lcerune_fn_1_array_oob_3
  cmpq $1, %rax
  jge .Lcerune_fn_1_array_oob_3
  imulq $-1, %rax
  leaq -16(%rbp,%rax,8), %rcx
  movq %rcx, -40(%rbp)
  jmp .Lcerune_fn_1_array_done_3
.Lcerune_fn_1_array_oob_3:
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_1(%rip), %rdx
  movl $70, %r8d
  callq _write
  movl $7, %ecx
  int $0x29
.Lcerune_fn_1_array_done_3:
  movq -40(%rbp), %r11
  movq (%r11), %rax
  movq %rax, -32(%rbp)
  movq -32(%rbp), %rax
  addq $80, %rsp
  popq %rbp
  retq
.Lcerune_fn_1_block_1: # mir_block
  ud2

.globl main
.p2align 4
main:
  pushq %rbp
  movq %rsp, %rbp
  subq $144, %rsp
  jmp .Lcerune_block_0
.Lcerune_block_0: # mir_block
  movabsq $-1, %rax
  movq %rax, -8(%rbp)
  movabsq $1, %rax
  movq %rax, -16(%rbp)
  movq -8(%rbp), %rax
  movq %rax, -24(%rbp)
  movq -16(%rbp), %rax
  movq %rax, -32(%rbp)
  leaq -24(%rbp), %rcx
  callq cerune_fn__generic_0_first_0
  movq %rax, -40(%rbp)
  movq -40(%rbp), %rax
  movq %rax, %rdx
  leaq .Lcerune_fmt_u64(%rip), %rcx
  callq printf
  movabsq $7, %rax
  movq %rax, -48(%rbp)
  movq -48(%rbp), %rax
  negq %rax
  jno .Lcerune_main_integer_ok_2
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_2(%rip), %rdx
  movl $64, %r8d
  callq _write
  movl $7, %ecx
  int $0x29
.Lcerune_main_integer_ok_2:
  movq %rax, -56(%rbp)
  movq -56(%rbp), %rax
  movq %rax, -64(%rbp)
  leaq -64(%rbp), %rcx
  callq cerune_fn__generic_1_first_1
  movq %rax, -72(%rbp)
  movq -72(%rbp), %rax
  movq %rax, %rdx
  leaq .Lcerune_fmt_i64(%rip), %rcx
  callq printf
  movabsq $42, %rax
  movq %rax, -80(%rbp)
  movabsq $0, %rax
  movq %rax, -88(%rbp)
  movq -80(%rbp), %rax
  movq %rax, -96(%rbp)
  movq -88(%rbp), %rax
  movq %rax, -104(%rbp)
  leaq -96(%rbp), %rcx
  callq cerune_fn__generic_0_first_0
  movq %rax, -112(%rbp)
  movq -112(%rbp), %rax
  movq %rax, %rdx
  leaq .Lcerune_fmt_u64(%rip), %rcx
  callq printf
  jmp .Lcerune_block_1
.Lcerune_block_1: # main_exit
  xorl %eax, %eax
  addq $144, %rsp
  popq %rbp
  retq

.section .rdata,"dr"
.Lcerune_failure_0:
  .asciz "cerune: runtime-v1 code=array-index-out-of-bounds node=4 bytes=60..69\n"
.Lcerune_failure_1:
  .asciz "cerune: runtime-v1 code=array-index-out-of-bounds node=8 bytes=60..69\n"
.Lcerune_failure_2:
  .asciz "cerune: runtime-v1 code=integer-overflow node=19 bytes=172..174\n"
