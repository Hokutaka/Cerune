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
  jmp .Lcerune_block_0
.Lcerune_block_0: # mir_block
  movabsq $-1, %rax
  movq %rax, -8(%rbp)
  movq -8(%rbp), %rax
  movq %rax, -16(%rbp)
  movq -16(%rbp), %rax
  movq %rax, -24(%rbp)
  movq -24(%rbp), %rax
  movq %rax, %rdx
  leaq .Lcerune_fmt_u64(%rip), %rcx
  callq printf
  movq -16(%rbp), %rax
  movq %rax, -32(%rbp)
  movabsq $0, %rax
  movq %rax, -40(%rbp)
  movq -40(%rbp), %rax
  movq %rax, %rcx
  movq -32(%rbp), %rax
  cmpq %rcx, %rax
  seta %al
  movzbq %al, %rax
  movq %rax, -48(%rbp)
  movq -48(%rbp), %rax
  testq %rax, %rax
  leaq .Lcerune_bool_false(%rip), %rcx
  leaq .Lcerune_bool_true(%rip), %rdx
  cmovne %rdx, %rcx
  callq puts
  movq -16(%rbp), %rax
  movq %rax, -56(%rbp)
  movabsq $2, %rax
  movq %rax, -64(%rbp)
  movq -64(%rbp), %rax
  movq %rax, %rcx
  movq -56(%rbp), %rax
  testq %rcx, %rcx
  je .Lcerune_main_u64_bad_2
  xorq %rdx, %rdx
  divq %rcx
  jmp .Lcerune_main_u64_done_2
.Lcerune_main_u64_bad_2:
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_0(%rip), %rdx
  movl $61, %r8d
  callq _write
  movl $7, %ecx
  int $0x29
.Lcerune_main_u64_done_2:
  movq %rax, -72(%rbp)
  movq -72(%rbp), %rax
  movq %rax, %rdx
  leaq .Lcerune_fmt_u64(%rip), %rcx
  callq printf
  movq -16(%rbp), %rax
  movq %rax, -80(%rbp)
  movabsq $63, %rax
  movq %rax, -88(%rbp)
  movq -88(%rbp), %rax
  movq %rax, %rcx
  movq -80(%rbp), %rax
  cmpq $64, %rcx
  jae .Lcerune_main_u64_bad_3
  shrq %cl, %rax
  jmp .Lcerune_main_u64_done_3
.Lcerune_main_u64_bad_3:
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_1(%rip), %rdx
  movl $66, %r8d
  callq _write
  movl $7, %ecx
  int $0x29
.Lcerune_main_u64_done_3:
  movq %rax, -96(%rbp)
  movq -96(%rbp), %rax
  movq %rax, %rdx
  leaq .Lcerune_fmt_u64(%rip), %rcx
  callq printf
  movabsq $42, %rax
  movq %rax, -104(%rbp)
  movq -104(%rbp), %rax
  testq %rax, %rax
  js .Lcerune_main_u64_convert_4_bad
  jmp .Lcerune_main_u64_convert_4_done
.Lcerune_main_u64_convert_4_bad:
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_2(%rip), %rdx
  movl $79, %r8d
  callq _write
  movl $7, %ecx
  int $0x29
.Lcerune_main_u64_convert_4_done:
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
  .asciz "cerune: runtime-v1 code=division-by-zero node=9 bytes=79..90\n"
.Lcerune_failure_1:
  .asciz "cerune: runtime-v1 code=invalid-shift-count node=13 bytes=99..112\n"
.Lcerune_failure_2:
  .asciz "cerune: runtime-v1 code=integer-conversion-out-of-range node=17 bytes=121..131\n"
