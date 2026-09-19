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
.Lcerune_fmt_u64:
  .asciz "%llu\n"

.text
.globl main
.p2align 4
main:
  pushq %rbp
  movq %rsp, %rbp
  subq $144, %rsp
  movabsq $-1, %rax
  movq %rax, -8(%rbp)
  movq -8(%rbp), %rax
  movq %rax, %rdx
  leaq .Lcerune_fmt_u64(%rip), %rcx
  callq printf
  movq -8(%rbp), %rax
  movq %rax, -16(%rbp)
  movabsq $0, %rax
  movq %rax, %rcx
  movq -16(%rbp), %rax
  cmpq %rcx, %rax
  seta %al
  movzbq %al, %rax
  testq %rax, %rax
  leaq .Lcerune_bool_false(%rip), %rcx
  leaq .Lcerune_bool_true(%rip), %rdx
  cmovne %rdx, %rcx
  callq puts
  movq -8(%rbp), %rax
  movq %rax, -16(%rbp)
  movabsq $2, %rax
  movq %rax, %rcx
  movq -16(%rbp), %rax
  testq %rcx, %rcx
  je .Lcerune_main_u64_bad_0
  xorq %rdx, %rdx
  divq %rcx
  jmp .Lcerune_main_u64_done_0
.Lcerune_main_u64_bad_0:
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_0(%rip), %rdx
  movl $61, %r8d
  callq _write
  ud2
.Lcerune_main_u64_done_0:
  movq %rax, %rdx
  leaq .Lcerune_fmt_u64(%rip), %rcx
  callq printf
  movq -8(%rbp), %rax
  movq %rax, -16(%rbp)
  movabsq $63, %rax
  movq %rax, %rcx
  movq -16(%rbp), %rax
  cmpq $64, %rcx
  jae .Lcerune_main_u64_bad_1
  shrq %cl, %rax
  jmp .Lcerune_main_u64_done_1
.Lcerune_main_u64_bad_1:
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_1(%rip), %rdx
  movl $66, %r8d
  callq _write
  ud2
.Lcerune_main_u64_done_1:
  movq %rax, %rdx
  leaq .Lcerune_fmt_u64(%rip), %rcx
  callq printf
  movabsq $42, %rax
  testq %rax, %rax
  js .Lcerune_main_u64_convert_2_bad
  jmp .Lcerune_main_u64_convert_2_done
.Lcerune_main_u64_convert_2_bad:
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_2(%rip), %rdx
  movl $79, %r8d
  callq _write
  ud2
.Lcerune_main_u64_convert_2_done:
  movq %rax, %rdx
  leaq .Lcerune_fmt_u64(%rip), %rcx
  callq printf
  xorl %eax, %eax
  addq $144, %rsp
  popq %rbp
  retq

.section .rdata,"dr"
.Lcerune_failure_0:
  .asciz "cerune: runtime-v1 code=division-by-zero node=9 bytes=79..90\n"
.Lcerune_failure_1:
  .asciz "cerune: runtime-v1 code=invalid-shift-count node=13 bytes=99..112\n"
.Lcerune_failure_2:
  .asciz "cerune: runtime-v1 code=integer-conversion-out-of-range node=17 bytes=121..131\n"
