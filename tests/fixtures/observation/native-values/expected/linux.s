# cerune-asm-origins v1: UTF-8 byte ranges, end exclusive
# cerune-origin: synthetic
# target: x86_64-unknown-linux-gnu
.section .rodata
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
  movq (%rdi), %rdx
  cmpq (%rsi), %rdx
  jne .Lstring_different
  xorq %r8, %r8
.Lstring_compare:
  cmpq %rdx, %r8
  je .Lstring_equal
  movzbl 8(%rdi,%r8), %eax
  cmpb 8(%rsi,%r8), %al
  jne .Lstring_different
  incq %r8
  jmp .Lstring_compare
.Lstring_equal:
  movl $1, %eax
  retq
.Lstring_different:
  xorl %eax, %eax
  retq

.p2align 4
cerune_print_string:
  subq $24, %rsp
  movq %rdi, (%rsp)
  movq $0, 8(%rsp)
.Lstring_write:
  movq (%rsp), %rax
  movq 8(%rsp), %rdx
  cmpq (%rax), %rdx
  je .Lstring_newline
  movzbl 8(%rax,%rdx), %edi
  callq putchar
  incq 8(%rsp)
  jmp .Lstring_write
.Lstring_newline:
  movl $10, %edi
  callq putchar
  addq $24, %rsp
  retq

# cerune-origin: synthetic
.p2align 4
cerune_fn_echo_0:
  pushq %rbp
  movq %rsp, %rbp
  subq $16, %rsp
# cerune-origin: synthetic
  movq %rdi, -8(%rbp)
# cerune-origin: #1 bytes 36..41
cerune_origin_n1_fn_0_1:
  movq -8(%rbp), %rax
# cerune-origin: #0 bytes 29..42
cerune_origin_n0_fn_0_2:
  addq $16, %rsp
  popq %rbp
  retq

# cerune-origin: synthetic
.globl main
.p2align 4
main:
  pushq %rbp
  movq %rsp, %rbp
  subq $32, %rsp
# cerune-origin: #3 bytes 51..58
cerune_origin_n3_main_0:
  leaq .Lcerune_string_0(%rip), %rax
# cerune-origin: #2 bytes 45..60
cerune_origin_n2_main_1:
  movq %rax, %rdi
  callq cerune_print_string
# cerune-origin: #6 bytes 72..92
cerune_origin_n6_main_2:
  movabsq $-1, %rax
# cerune-origin: #5 bytes 67..93
cerune_origin_n5_main_3:
  movq %rax, -8(%rbp)
# cerune-origin: #5 bytes 67..93
cerune_origin_n5_main_4:
  movq -8(%rbp), %rdi
  callq cerune_fn_echo_0
# cerune-origin: #4 bytes 61..95
cerune_origin_n4_main_5:
  movq %rax, %rsi
  leaq .Lcerune_fmt_u64(%rip), %rdi
  xorl %eax, %eax
  callq printf
# cerune-origin: synthetic
  xorl %eax, %eax
  addq $32, %rsp
  popq %rbp
  retq

.section .note.GNU-stack,"",@progbits
