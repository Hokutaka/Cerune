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
  subq $80, %rsp
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
  movl $70, %r8d
  callq _write
  ud2
.Lcerune_fn_0_array_done_0:
  addq $80, %rsp
  popq %rbp
  retq

.p2align 4
cerune_fn__generic_1_first_1:
  pushq %rbp
  movq %rsp, %rbp
  subq $64, %rsp
  movq 0(%rcx), %r10
  movq %r10, -8(%rbp)
  movabsq $0, %rax
  testq %rax, %rax
  js .Lcerune_fn_1_array_oob_0
  cmpq $1, %rax
  jge .Lcerune_fn_1_array_oob_0
  negq %rax
  movq -8(%rbp,%rax,8), %rax
  jmp .Lcerune_fn_1_array_done_0
.Lcerune_fn_1_array_oob_0:
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_1(%rip), %rdx
  movl $70, %r8d
  callq _write
  ud2
.Lcerune_fn_1_array_done_0:
  addq $64, %rsp
  popq %rbp
  retq

.globl main
.p2align 4
main:
  pushq %rbp
  movq %rsp, %rbp
  subq $176, %rsp
  movabsq $-1, %rax
  movq %rax, -104(%rbp)
  movabsq $1, %rax
  movq %rax, -112(%rbp)
  leaq -104(%rbp), %rcx
  callq cerune_fn__generic_0_first_0
  movq %rax, %rdx
  leaq .Lcerune_fmt_u64(%rip), %rcx
  callq printf
  movabsq $7, %rax
  negq %rax
  jno .Lcerune_main_integer_ok_0
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_2(%rip), %rdx
  movl $64, %r8d
  callq _write
  ud2
.Lcerune_main_integer_ok_0:
  movq %rax, -120(%rbp)
  leaq -120(%rbp), %rcx
  callq cerune_fn__generic_1_first_1
  movq %rax, %rdx
  leaq .Lcerune_fmt_i64(%rip), %rcx
  callq printf
  movabsq $42, %rax
  movq %rax, -128(%rbp)
  movabsq $0, %rax
  movq %rax, -136(%rbp)
  leaq -128(%rbp), %rcx
  callq cerune_fn__generic_0_first_0
  movq %rax, %rdx
  leaq .Lcerune_fmt_u64(%rip), %rcx
  callq printf
  xorl %eax, %eax
  addq $176, %rsp
  popq %rbp
  retq

.section .rdata,"dr"
.Lcerune_failure_0:
  .asciz "cerune: runtime-v1 code=array-index-out-of-bounds node=4 bytes=60..69\n"
.Lcerune_failure_1:
  .asciz "cerune: runtime-v1 code=array-index-out-of-bounds node=8 bytes=60..69\n"
.Lcerune_failure_2:
  .asciz "cerune: runtime-v1 code=integer-overflow node=19 bytes=172..174\n"
