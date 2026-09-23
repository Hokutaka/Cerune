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
  subq $112, %rsp
  movq 0(%rcx), %r10
  movq %r10, -8(%rbp)
  movq -8(%rcx), %r10
  movq %r10, -16(%rbp)
  movabsq $0, %rax
  testq %rax, %rax
  js .Lcerune_fn_0_array_oob_0
  cmpq $2, %rax
  jge .Lcerune_fn_0_array_oob_0
  negq %rax
  movq -8(%rbp,%rax,8), %rax
  jmp .Lcerune_fn_0_array_done_0
.Lcerune_fn_0_array_oob_0:
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_0(%rip), %rdx
  movl $72, %r8d
  callq _write
  ud2
.Lcerune_fn_0_array_done_0:
  movq %rax, -24(%rbp)
  movabsq $1, %rax
  testq %rax, %rax
  js .Lcerune_fn_0_array_oob_1
  cmpq $2, %rax
  jge .Lcerune_fn_0_array_oob_1
  negq %rax
  movq -8(%rbp,%rax,8), %rax
  jmp .Lcerune_fn_0_array_done_1
.Lcerune_fn_0_array_oob_1:
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_1(%rip), %rdx
  movl $73, %r8d
  callq _write
  ud2
.Lcerune_fn_0_array_done_1:
  movq %rax, %rcx
  movq -24(%rbp), %rax
  addq %rcx, %rax
  jno .Lcerune_fn_0_integer_ok_2
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_2(%rip), %rdx
  movl $63, %r8d
  callq _write
  ud2
.Lcerune_fn_0_integer_ok_2:
  addq $112, %rsp
  popq %rbp
  retq

.globl main
.p2align 4
main:
  pushq %rbp
  movq %rsp, %rbp
  subq $112, %rsp
  movabsq $3, %rax
  movq %rax, -64(%rbp)
  movabsq $4, %rax
  movq %rax, -72(%rbp)
  movq -64(%rbp), %rax
  movq %rax, -8(%rbp)
  movq -72(%rbp), %rax
  movq %rax, -16(%rbp)
  leaq -8(%rbp), %rcx
  callq cerune_fn_total_0
  movq %rax, %rdx
  leaq .Lcerune_fmt_i64(%rip), %rcx
  callq printf
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
