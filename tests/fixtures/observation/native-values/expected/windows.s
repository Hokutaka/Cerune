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
# cerune-mir: v1 synthetic ABI setup/exit
  movq %rcx, -8(%rbp)
# cerune-origin: synthetic
# cerune-mir: v1 synthetic ABI setup/exit
  jmp .Lcerune_fn_0_block_0
# cerune-origin: synthetic
# cerune-mir: v1 fn_0 bb0 block -> lir 2 (function-entry)
cerune_origin_mir_fn_0_bb0_block_lir2:
.Lcerune_fn_0_block_0: # mir_block
# cerune-origin: #1 bytes 36..41
cerune_origin_n1_fn_0_3:
# cerune-mir: v1 fn_0 bb0 i0 -> lir 3 (source)
cerune_origin_mir_fn_0_bb0_i0_lir3:
  movq -8(%rbp), %rax
# cerune-origin: #1 bytes 36..41
cerune_origin_n1_fn_0_4:
# cerune-mir: v1 fn_0 bb0 i0 -> lir 4 (source)
cerune_origin_mir_fn_0_bb0_i0_lir4:
  movq %rax, -16(%rbp)
# cerune-origin: #0 bytes 29..42
cerune_origin_n0_fn_0_5:
# cerune-mir: v1 fn_0 bb0 i1 -> lir 5 (source)
cerune_origin_mir_fn_0_bb0_i1_lir5:
  movq -16(%rbp), %rax
# cerune-origin: #0 bytes 29..42
cerune_origin_n0_fn_0_6:
# cerune-mir: v1 fn_0 bb0 i1 -> lir 6 (source)
cerune_origin_mir_fn_0_bb0_i1_lir6:
  addq $48, %rsp
  popq %rbp
  retq
# cerune-origin: #0 bytes 29..42
cerune_origin_n0_fn_0_7:
# cerune-mir: v1 fn_0 bb1 block -> lir 7 (after-return)
cerune_origin_mir_fn_0_bb1_block_lir7:
.Lcerune_fn_0_block_1: # mir_block
# cerune-origin: synthetic
# cerune-mir: v1 fn_0 bb1 i2 -> lir 8 (function-end)
cerune_origin_mir_fn_0_bb1_i2_lir8:
  ud2

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
# cerune-origin: synthetic
# cerune-mir: v1 synthetic ABI setup/exit
  jmp .Lcerune_block_0
# cerune-origin: synthetic
# cerune-mir: v1 main bb0 block -> lir 1 (function-entry)
cerune_origin_mir_main_bb0_block_lir1:
.Lcerune_block_0: # mir_block
# cerune-origin: #3 bytes 51..58
cerune_origin_n3_main_2:
# cerune-mir: v1 main bb0 i0 -> lir 2 (source)
cerune_origin_mir_main_bb0_i0_lir2:
  leaq .Lcerune_string_0(%rip), %rax
# cerune-origin: #3 bytes 51..58
cerune_origin_n3_main_3:
# cerune-mir: v1 main bb0 i0 -> lir 3 (source)
cerune_origin_mir_main_bb0_i0_lir3:
  movq %rax, -8(%rbp)
# cerune-origin: #2 bytes 45..60
cerune_origin_n2_main_4:
# cerune-mir: v1 main bb0 i1 -> lir 4 (source)
cerune_origin_mir_main_bb0_i1_lir4:
  movq -8(%rbp), %rax
# cerune-origin: #2 bytes 45..60
cerune_origin_n2_main_5:
# cerune-mir: v1 main bb0 i1 -> lir 5 (source)
cerune_origin_mir_main_bb0_i1_lir5:
  movq %rax, %rcx
  callq cerune_print_string
# cerune-origin: #6 bytes 72..92
cerune_origin_n6_main_6:
# cerune-mir: v1 main bb0 i2 -> lir 6 (source)
cerune_origin_mir_main_bb0_i2_lir6:
  movabsq $-1, %rax
# cerune-origin: #6 bytes 72..92
cerune_origin_n6_main_7:
# cerune-mir: v1 main bb0 i2 -> lir 7 (source)
cerune_origin_mir_main_bb0_i2_lir7:
  movq %rax, -16(%rbp)
# cerune-origin: #5 bytes 67..93
cerune_origin_n5_main_8:
# cerune-mir: v1 main bb0 i3 -> lir 8 (source)
cerune_origin_mir_main_bb0_i3_lir8:
  movq -16(%rbp), %rcx
  callq cerune_fn_echo_0
# cerune-origin: #5 bytes 67..93
cerune_origin_n5_main_9:
# cerune-mir: v1 main bb0 i3 -> lir 9 (source)
cerune_origin_mir_main_bb0_i3_lir9:
  movq %rax, -24(%rbp)
# cerune-origin: #4 bytes 61..95
cerune_origin_n4_main_10:
# cerune-mir: v1 main bb0 i4 -> lir 10 (source)
cerune_origin_mir_main_bb0_i4_lir10:
  movq -24(%rbp), %rax
# cerune-origin: #4 bytes 61..95
cerune_origin_n4_main_11:
# cerune-mir: v1 main bb0 i4 -> lir 11 (source)
cerune_origin_mir_main_bb0_i4_lir11:
  movq %rax, %rdx
  leaq .Lcerune_fmt_u64(%rip), %rcx
  callq printf
# cerune-origin: synthetic
# cerune-mir: v1 main bb0 i5 -> lir 12 (function-end)
cerune_origin_mir_main_bb0_i5_lir12:
  jmp .Lcerune_block_1
# cerune-origin: synthetic
# cerune-mir: v1 synthetic ABI setup/exit
.Lcerune_block_1: # main_exit
# cerune-origin: synthetic
  xorl %eax, %eax
  addq $64, %rsp
  popq %rbp
  retq
