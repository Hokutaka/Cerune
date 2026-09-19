# cerune-asm-origins v1: UTF-8 byte ranges, end exclusive
# cerune-origin: synthetic
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
.p2align 3
.Lcerune_string_0:
  .quad 4
  .byte 230
  .byte 151
  .byte 165
  .byte 0

.text

.p2align 4
cerune_string_equal:
  movq (%rcx), %r8
  cmpq (%rdx), %r8
  jne .Lstring_different
  xorq %r9, %r9
.Lstring_compare:
  cmpq %r8, %r9
  je .Lstring_equal
  movzbl 8(%rcx,%r9), %eax
  cmpb 8(%rdx,%r9), %al
  jne .Lstring_different
  incq %r9
  jmp .Lstring_compare
.Lstring_equal:
  movl $1, %eax
  retq
.Lstring_different:
  xorl %eax, %eax
  retq

.p2align 4
cerune_print_string:
  subq $56, %rsp
  movq %rcx, 32(%rsp)
  movq $0, 40(%rsp)
.Lstring_write:
  movq 32(%rsp), %rax
  movq 40(%rsp), %rdx
  cmpq (%rax), %rdx
  je .Lstring_newline
  movzbl 8(%rax,%rdx), %ecx
  callq putchar
  incq 40(%rsp)
  jmp .Lstring_write
.Lstring_newline:
  movl $10, %ecx
  callq putchar
  addq $56, %rsp
  retq

# cerune-origin: synthetic
.p2align 4
cerune_fn_echo_0:
  pushq %rbp
  movq %rsp, %rbp
  subq $48, %rsp
# cerune-origin: synthetic
  movq %rcx, -8(%rbp)
# cerune-origin: #1 bytes 36..41
cerune_origin_n1_fn_0_1:
  movq -8(%rbp), %rax
# cerune-origin: #0 bytes 29..42
cerune_origin_n0_fn_0_2:
  addq $48, %rsp
  popq %rbp
  retq

# cerune-origin: synthetic
.globl main
.p2align 4
main:
  pushq %rbp
  movq %rsp, %rbp
  subq $64, %rsp
  movl $1, %ecx
  movl $32768, %edx
  callq _setmode
  cmpl $-1, %eax
  jne .Lstdout_ready
  movl $1, %eax
  addq $64, %rsp
  popq %rbp
  retq
.Lstdout_ready:
# cerune-origin: #3 bytes 51..58
cerune_origin_n3_main_0:
  leaq .Lcerune_string_0(%rip), %rax
# cerune-origin: #2 bytes 45..60
cerune_origin_n2_main_1:
  movq %rax, %rcx
  callq cerune_print_string
# cerune-origin: #6 bytes 72..92
cerune_origin_n6_main_2:
  movabsq $-1, %rax
# cerune-origin: #5 bytes 67..93
cerune_origin_n5_main_3:
  movq %rax, -8(%rbp)
# cerune-origin: #5 bytes 67..93
cerune_origin_n5_main_4:
  movq -8(%rbp), %rcx
  callq cerune_fn_echo_0
# cerune-origin: #4 bytes 61..95
cerune_origin_n4_main_5:
  movq %rax, %rdx
  leaq .Lcerune_fmt_u64(%rip), %rcx
  callq printf
# cerune-origin: synthetic
  xorl %eax, %eax
  addq $64, %rsp
  popq %rbp
  retq
