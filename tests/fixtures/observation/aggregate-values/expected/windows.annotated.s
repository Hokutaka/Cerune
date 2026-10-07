# cerune-asm-origins v1: UTF-8 byte ranges, end exclusive
# cerune-origin: synthetic
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
.p2align 3
.Lcerune_string_0:
  .quad 5
  .byte 86
  .byte 97
  .byte 108
  .byte 117
  .byte 101
.p2align 3
.Lcerune_string_1:
  .quad 1
  .byte 123
.p2align 3
.Lcerune_string_2:
  .quad 3
  .byte 110
  .byte 58
  .byte 32
.p2align 3
.Lcerune_string_3:
  .quad 1
  .byte 125
.p2align 3
.Lcerune_string_4:
  .quad 5
  .byte 69
  .byte 109
  .byte 112
  .byte 116
  .byte 121
.p2align 3
.Lcerune_string_5:
  .quad 1
  .byte 123
.p2align 3
.Lcerune_string_6:
  .quad 1
  .byte 125
.p2align 3
.Lcerune_string_7:
  .quad 0

.text
.section .rdata,"dr"
.Lwrite_i64:
  .asciz "%lld"
.Lwrite_u64:
  .asciz "%llu"
.Lwrite_f32:
  .asciz "%.9g"
.Lwrite_f64:
  .asciz "%.17g"
.Lwrite_true:
  .asciz "true"
.Lwrite_false:
  .asciz "false"
.Lwrite_bool:
  .asciz "%s"
.text
cerune_write_escaped_byte:
  subq $40, %rsp
  cmpl $0, %ecx
  je .Lescape_0
  cmpl $1, %ecx
  je .Lescape_1
  cmpl $2, %ecx
  je .Lescape_2
  cmpl $3, %ecx
  je .Lescape_3
  cmpl $4, %ecx
  je .Lescape_4
  cmpl $5, %ecx
  je .Lescape_5
  cmpl $6, %ecx
  je .Lescape_6
  cmpl $7, %ecx
  je .Lescape_7
  cmpl $8, %ecx
  je .Lescape_8
  cmpl $9, %ecx
  je .Lescape_9
  cmpl $10, %ecx
  je .Lescape_10
  cmpl $11, %ecx
  je .Lescape_11
  cmpl $12, %ecx
  je .Lescape_12
  cmpl $13, %ecx
  je .Lescape_13
  cmpl $14, %ecx
  je .Lescape_14
  cmpl $15, %ecx
  je .Lescape_15
  cmpl $16, %ecx
  je .Lescape_16
  cmpl $17, %ecx
  je .Lescape_17
  cmpl $18, %ecx
  je .Lescape_18
  cmpl $19, %ecx
  je .Lescape_19
  cmpl $20, %ecx
  je .Lescape_20
  cmpl $21, %ecx
  je .Lescape_21
  cmpl $22, %ecx
  je .Lescape_22
  cmpl $23, %ecx
  je .Lescape_23
  cmpl $24, %ecx
  je .Lescape_24
  cmpl $25, %ecx
  je .Lescape_25
  cmpl $26, %ecx
  je .Lescape_26
  cmpl $27, %ecx
  je .Lescape_27
  cmpl $28, %ecx
  je .Lescape_28
  cmpl $29, %ecx
  je .Lescape_29
  cmpl $30, %ecx
  je .Lescape_30
  cmpl $31, %ecx
  je .Lescape_31
  cmpl $34, %ecx
  je .Lescape_34
  cmpl $92, %ecx
  je .Lescape_92
  cmpl $127, %ecx
  je .Lescape_127
  callq putchar
  addq $40, %rsp
  retq
.Lescape_0:
  movl $92, %ecx
  callq putchar
  movl $48, %ecx
  callq putchar
  addq $40, %rsp
  retq
.Lescape_1:
  movl $92, %ecx
  callq putchar
  movl $117, %ecx
  callq putchar
  movl $123, %ecx
  callq putchar
  movl $48, %ecx
  callq putchar
  movl $49, %ecx
  callq putchar
  movl $125, %ecx
  callq putchar
  addq $40, %rsp
  retq
.Lescape_2:
  movl $92, %ecx
  callq putchar
  movl $117, %ecx
  callq putchar
  movl $123, %ecx
  callq putchar
  movl $48, %ecx
  callq putchar
  movl $50, %ecx
  callq putchar
  movl $125, %ecx
  callq putchar
  addq $40, %rsp
  retq
.Lescape_3:
  movl $92, %ecx
  callq putchar
  movl $117, %ecx
  callq putchar
  movl $123, %ecx
  callq putchar
  movl $48, %ecx
  callq putchar
  movl $51, %ecx
  callq putchar
  movl $125, %ecx
  callq putchar
  addq $40, %rsp
  retq
.Lescape_4:
  movl $92, %ecx
  callq putchar
  movl $117, %ecx
  callq putchar
  movl $123, %ecx
  callq putchar
  movl $48, %ecx
  callq putchar
  movl $52, %ecx
  callq putchar
  movl $125, %ecx
  callq putchar
  addq $40, %rsp
  retq
.Lescape_5:
  movl $92, %ecx
  callq putchar
  movl $117, %ecx
  callq putchar
  movl $123, %ecx
  callq putchar
  movl $48, %ecx
  callq putchar
  movl $53, %ecx
  callq putchar
  movl $125, %ecx
  callq putchar
  addq $40, %rsp
  retq
.Lescape_6:
  movl $92, %ecx
  callq putchar
  movl $117, %ecx
  callq putchar
  movl $123, %ecx
  callq putchar
  movl $48, %ecx
  callq putchar
  movl $54, %ecx
  callq putchar
  movl $125, %ecx
  callq putchar
  addq $40, %rsp
  retq
.Lescape_7:
  movl $92, %ecx
  callq putchar
  movl $117, %ecx
  callq putchar
  movl $123, %ecx
  callq putchar
  movl $48, %ecx
  callq putchar
  movl $55, %ecx
  callq putchar
  movl $125, %ecx
  callq putchar
  addq $40, %rsp
  retq
.Lescape_8:
  movl $92, %ecx
  callq putchar
  movl $117, %ecx
  callq putchar
  movl $123, %ecx
  callq putchar
  movl $48, %ecx
  callq putchar
  movl $56, %ecx
  callq putchar
  movl $125, %ecx
  callq putchar
  addq $40, %rsp
  retq
.Lescape_9:
  movl $92, %ecx
  callq putchar
  movl $116, %ecx
  callq putchar
  addq $40, %rsp
  retq
.Lescape_10:
  movl $92, %ecx
  callq putchar
  movl $110, %ecx
  callq putchar
  addq $40, %rsp
  retq
.Lescape_11:
  movl $92, %ecx
  callq putchar
  movl $117, %ecx
  callq putchar
  movl $123, %ecx
  callq putchar
  movl $48, %ecx
  callq putchar
  movl $98, %ecx
  callq putchar
  movl $125, %ecx
  callq putchar
  addq $40, %rsp
  retq
.Lescape_12:
  movl $92, %ecx
  callq putchar
  movl $117, %ecx
  callq putchar
  movl $123, %ecx
  callq putchar
  movl $48, %ecx
  callq putchar
  movl $99, %ecx
  callq putchar
  movl $125, %ecx
  callq putchar
  addq $40, %rsp
  retq
.Lescape_13:
  movl $92, %ecx
  callq putchar
  movl $114, %ecx
  callq putchar
  addq $40, %rsp
  retq
.Lescape_14:
  movl $92, %ecx
  callq putchar
  movl $117, %ecx
  callq putchar
  movl $123, %ecx
  callq putchar
  movl $48, %ecx
  callq putchar
  movl $101, %ecx
  callq putchar
  movl $125, %ecx
  callq putchar
  addq $40, %rsp
  retq
.Lescape_15:
  movl $92, %ecx
  callq putchar
  movl $117, %ecx
  callq putchar
  movl $123, %ecx
  callq putchar
  movl $48, %ecx
  callq putchar
  movl $102, %ecx
  callq putchar
  movl $125, %ecx
  callq putchar
  addq $40, %rsp
  retq
.Lescape_16:
  movl $92, %ecx
  callq putchar
  movl $117, %ecx
  callq putchar
  movl $123, %ecx
  callq putchar
  movl $49, %ecx
  callq putchar
  movl $48, %ecx
  callq putchar
  movl $125, %ecx
  callq putchar
  addq $40, %rsp
  retq
.Lescape_17:
  movl $92, %ecx
  callq putchar
  movl $117, %ecx
  callq putchar
  movl $123, %ecx
  callq putchar
  movl $49, %ecx
  callq putchar
  movl $49, %ecx
  callq putchar
  movl $125, %ecx
  callq putchar
  addq $40, %rsp
  retq
.Lescape_18:
  movl $92, %ecx
  callq putchar
  movl $117, %ecx
  callq putchar
  movl $123, %ecx
  callq putchar
  movl $49, %ecx
  callq putchar
  movl $50, %ecx
  callq putchar
  movl $125, %ecx
  callq putchar
  addq $40, %rsp
  retq
.Lescape_19:
  movl $92, %ecx
  callq putchar
  movl $117, %ecx
  callq putchar
  movl $123, %ecx
  callq putchar
  movl $49, %ecx
  callq putchar
  movl $51, %ecx
  callq putchar
  movl $125, %ecx
  callq putchar
  addq $40, %rsp
  retq
.Lescape_20:
  movl $92, %ecx
  callq putchar
  movl $117, %ecx
  callq putchar
  movl $123, %ecx
  callq putchar
  movl $49, %ecx
  callq putchar
  movl $52, %ecx
  callq putchar
  movl $125, %ecx
  callq putchar
  addq $40, %rsp
  retq
.Lescape_21:
  movl $92, %ecx
  callq putchar
  movl $117, %ecx
  callq putchar
  movl $123, %ecx
  callq putchar
  movl $49, %ecx
  callq putchar
  movl $53, %ecx
  callq putchar
  movl $125, %ecx
  callq putchar
  addq $40, %rsp
  retq
.Lescape_22:
  movl $92, %ecx
  callq putchar
  movl $117, %ecx
  callq putchar
  movl $123, %ecx
  callq putchar
  movl $49, %ecx
  callq putchar
  movl $54, %ecx
  callq putchar
  movl $125, %ecx
  callq putchar
  addq $40, %rsp
  retq
.Lescape_23:
  movl $92, %ecx
  callq putchar
  movl $117, %ecx
  callq putchar
  movl $123, %ecx
  callq putchar
  movl $49, %ecx
  callq putchar
  movl $55, %ecx
  callq putchar
  movl $125, %ecx
  callq putchar
  addq $40, %rsp
  retq
.Lescape_24:
  movl $92, %ecx
  callq putchar
  movl $117, %ecx
  callq putchar
  movl $123, %ecx
  callq putchar
  movl $49, %ecx
  callq putchar
  movl $56, %ecx
  callq putchar
  movl $125, %ecx
  callq putchar
  addq $40, %rsp
  retq
.Lescape_25:
  movl $92, %ecx
  callq putchar
  movl $117, %ecx
  callq putchar
  movl $123, %ecx
  callq putchar
  movl $49, %ecx
  callq putchar
  movl $57, %ecx
  callq putchar
  movl $125, %ecx
  callq putchar
  addq $40, %rsp
  retq
.Lescape_26:
  movl $92, %ecx
  callq putchar
  movl $117, %ecx
  callq putchar
  movl $123, %ecx
  callq putchar
  movl $49, %ecx
  callq putchar
  movl $97, %ecx
  callq putchar
  movl $125, %ecx
  callq putchar
  addq $40, %rsp
  retq
.Lescape_27:
  movl $92, %ecx
  callq putchar
  movl $117, %ecx
  callq putchar
  movl $123, %ecx
  callq putchar
  movl $49, %ecx
  callq putchar
  movl $98, %ecx
  callq putchar
  movl $125, %ecx
  callq putchar
  addq $40, %rsp
  retq
.Lescape_28:
  movl $92, %ecx
  callq putchar
  movl $117, %ecx
  callq putchar
  movl $123, %ecx
  callq putchar
  movl $49, %ecx
  callq putchar
  movl $99, %ecx
  callq putchar
  movl $125, %ecx
  callq putchar
  addq $40, %rsp
  retq
.Lescape_29:
  movl $92, %ecx
  callq putchar
  movl $117, %ecx
  callq putchar
  movl $123, %ecx
  callq putchar
  movl $49, %ecx
  callq putchar
  movl $100, %ecx
  callq putchar
  movl $125, %ecx
  callq putchar
  addq $40, %rsp
  retq
.Lescape_30:
  movl $92, %ecx
  callq putchar
  movl $117, %ecx
  callq putchar
  movl $123, %ecx
  callq putchar
  movl $49, %ecx
  callq putchar
  movl $101, %ecx
  callq putchar
  movl $125, %ecx
  callq putchar
  addq $40, %rsp
  retq
.Lescape_31:
  movl $92, %ecx
  callq putchar
  movl $117, %ecx
  callq putchar
  movl $123, %ecx
  callq putchar
  movl $49, %ecx
  callq putchar
  movl $102, %ecx
  callq putchar
  movl $125, %ecx
  callq putchar
  addq $40, %rsp
  retq
.Lescape_34:
  movl $92, %ecx
  callq putchar
  movl $34, %ecx
  callq putchar
  addq $40, %rsp
  retq
.Lescape_92:
  movl $92, %ecx
  callq putchar
  movl $92, %ecx
  callq putchar
  addq $40, %rsp
  retq
.Lescape_127:
  movl $92, %ecx
  callq putchar
  movl $117, %ecx
  callq putchar
  movl $123, %ecx
  callq putchar
  movl $55, %ecx
  callq putchar
  movl $102, %ecx
  callq putchar
  movl $125, %ecx
  callq putchar
  addq $40, %rsp
  retq
cerune_write_bool:
  subq $40, %rsp
  cmpl $0, %ecx
  je .Lwrite_bool_false
  movl $116, %ecx
  callq putchar
  movl $114, %ecx
  callq putchar
  movl $117, %ecx
  callq putchar
  movl $101, %ecx
  callq putchar
  addq $40, %rsp
  retq
.Lwrite_bool_false:
  movl $102, %ecx
  callq putchar
  movl $97, %ecx
  callq putchar
  movl $108, %ecx
  callq putchar
  movl $115, %ecx
  callq putchar
  movl $101, %ecx
  callq putchar
  addq $40, %rsp
  retq
cerune_write_string:
  subq $56, %rsp
  movq %rcx, 32(%rsp)
  movq $0, 40(%rsp)
.Lwrite_string_loop:
  movq 32(%rsp), %rax
  movq 40(%rsp), %rdx
  cmpq (%rax), %rdx
  je .Lwrite_string_end
  movzbl 8(%rax,%rdx), %ecx
  callq putchar
  incq 40(%rsp)
  jmp .Lwrite_string_loop
.Lwrite_string_end:
  addq $56, %rsp
  retq
cerune_write_quoted:
  subq $56, %rsp
  movq %rcx, 32(%rsp)
  movq $0, 40(%rsp)
  movl $34, %ecx
  callq putchar
.Lwrite_quoted_loop:
  movq 32(%rsp), %rax
  movq 40(%rsp), %rdx
  cmpq (%rax), %rdx
  je .Lwrite_quoted_end
  movzbl 8(%rax,%rdx), %ecx
  callq cerune_write_escaped_byte
  incq 40(%rsp)
  jmp .Lwrite_quoted_loop
.Lwrite_quoted_end:
  movl $34, %ecx
  callq putchar
  addq $56, %rsp
  retq

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
cerune_fn__equal0_0:
  pushq %rbp
  movq %rsp, %rbp
  subq $240, %rsp
# cerune-origin: synthetic
# cerune-mir: v1 synthetic ABI setup/exit
  movq 0(%rcx), %r10
  movq %r10, -8(%rbp)
  movq -8(%rcx), %r10
  movq %r10, -16(%rbp)
# cerune-origin: synthetic
# cerune-mir: v1 synthetic ABI setup/exit
  movq 0(%rdx), %r10
  movq %r10, -24(%rbp)
  movq -8(%rdx), %r10
  movq %r10, -32(%rbp)
# cerune-origin: synthetic
# cerune-mir: v1 synthetic ABI setup/exit
  jmp .Lcerune_fn_0_block_0
# cerune-origin: synthetic
# cerune-mir: v1 fn_0 bb0 block -> lir 3 (function-entry)
cerune_origin_mir_fn_0_bb0_block_lir3:
.Lcerune_fn_0_block_0: # mir_block
# cerune-origin: #45 bytes 70..84
cerune_origin_n45_fn_0_4:
# cerune-mir: v1 fn_0 bb0 i0 -> lir 4 (source)
cerune_origin_mir_fn_0_bb0_i0_lir4:
  movabsq $0, %rax
# cerune-origin: #45 bytes 70..84
cerune_origin_n45_fn_0_5:
# cerune-mir: v1 fn_0 bb0 i0 -> lir 5 (source)
cerune_origin_mir_fn_0_bb0_i0_lir5:
  movq %rax, -40(%rbp)
# cerune-origin: #46 bytes 70..84
cerune_origin_n46_fn_0_6:
# cerune-mir: v1 fn_0 bb0 i1 -> lir 6 (source)
cerune_origin_mir_fn_0_bb0_i1_lir6:
  movq -40(%rbp), %rax
# cerune-origin: #46 bytes 70..84
cerune_origin_n46_fn_0_7:
# cerune-mir: v1 fn_0 bb0 i1 -> lir 7 (source)
cerune_origin_mir_fn_0_bb0_i1_lir7:
  movq %rax, -48(%rbp)
# cerune-origin: #65 bytes 70..84
cerune_origin_n65_fn_0_8:
# cerune-mir: v1 fn_0 bb0 i2 -> lir 8 (loop-entry)
cerune_origin_mir_fn_0_bb0_i2_lir8:
  jmp .Lcerune_fn_0_block_1
# cerune-origin: #65 bytes 70..84
cerune_origin_n65_fn_0_9:
# cerune-mir: v1 fn_0 bb1 block -> lir 9 (loop-condition)
cerune_origin_mir_fn_0_bb1_block_lir9:
.Lcerune_fn_0_block_1: # mir_block
# cerune-origin: #47 bytes 70..84
cerune_origin_n47_fn_0_10:
# cerune-mir: v1 fn_0 bb1 i3 -> lir 10 (source)
cerune_origin_mir_fn_0_bb1_i3_lir10:
  movq -48(%rbp), %rax
# cerune-origin: #47 bytes 70..84
cerune_origin_n47_fn_0_11:
# cerune-mir: v1 fn_0 bb1 i3 -> lir 11 (source)
cerune_origin_mir_fn_0_bb1_i3_lir11:
  movq %rax, -56(%rbp)
# cerune-origin: #48 bytes 70..84
cerune_origin_n48_fn_0_12:
# cerune-mir: v1 fn_0 bb1 i4 -> lir 12 (source)
cerune_origin_mir_fn_0_bb1_i4_lir12:
  movabsq $2, %rax
# cerune-origin: #48 bytes 70..84
cerune_origin_n48_fn_0_13:
# cerune-mir: v1 fn_0 bb1 i4 -> lir 13 (source)
cerune_origin_mir_fn_0_bb1_i4_lir13:
  movq %rax, -64(%rbp)
# cerune-origin: #49 bytes 70..84
cerune_origin_n49_fn_0_14:
# cerune-mir: v1 fn_0 bb1 i5 -> lir 14 (source)
cerune_origin_mir_fn_0_bb1_i5_lir14:
  movq -64(%rbp), %rax
# cerune-origin: #49 bytes 70..84
cerune_origin_n49_fn_0_15:
# cerune-mir: v1 fn_0 bb1 i5 -> lir 15 (source)
cerune_origin_mir_fn_0_bb1_i5_lir15:
  movq %rax, %rcx
# cerune-origin: #49 bytes 70..84
cerune_origin_n49_fn_0_16:
# cerune-mir: v1 fn_0 bb1 i5 -> lir 16 (source)
cerune_origin_mir_fn_0_bb1_i5_lir16:
  movq -56(%rbp), %rax
# cerune-origin: #49 bytes 70..84
cerune_origin_n49_fn_0_17:
# cerune-mir: v1 fn_0 bb1 i5 -> lir 17 (source)
cerune_origin_mir_fn_0_bb1_i5_lir17:
  cmpq %rcx, %rax
  setl %al
  movzbq %al, %rax
# cerune-origin: #49 bytes 70..84
cerune_origin_n49_fn_0_18:
# cerune-mir: v1 fn_0 bb1 i5 -> lir 18 (source)
cerune_origin_mir_fn_0_bb1_i5_lir18:
  movq %rax, -72(%rbp)
# cerune-origin: #65 bytes 70..84
cerune_origin_n65_fn_0_19:
# cerune-mir: v1 fn_0 bb1 i6 -> lir 19 (source)
cerune_origin_mir_fn_0_bb1_i6_lir19:
  movq -72(%rbp), %rax
# cerune-origin: #65 bytes 70..84
cerune_origin_n65_fn_0_20:
# cerune-mir: v1 fn_0 bb1 i6 -> lir 20 (source)
cerune_origin_mir_fn_0_bb1_i6_lir20:
  testq %rax, %rax
  je .Lcerune_fn_0_block_3
# cerune-origin: #65 bytes 70..84
cerune_origin_n65_fn_0_21:
# cerune-mir: v1 fn_0 bb1 i6 -> lir 21 (source)
cerune_origin_mir_fn_0_bb1_i6_lir21:
  jmp .Lcerune_fn_0_block_2
# cerune-origin: #65 bytes 70..84
cerune_origin_n65_fn_0_22:
# cerune-mir: v1 fn_0 bb2 block -> lir 22 (loop-body)
cerune_origin_mir_fn_0_bb2_block_lir22:
.Lcerune_fn_0_block_2: # mir_block
# cerune-origin: #50 bytes 70..84
cerune_origin_n50_fn_0_23:
# cerune-mir: v1 fn_0 bb2 i7 -> lir 23 (source)
cerune_origin_mir_fn_0_bb2_i7_lir23:
  movq -8(%rbp), %rax
# cerune-origin: #50 bytes 70..84
cerune_origin_n50_fn_0_24:
# cerune-mir: v1 fn_0 bb2 i7 -> lir 24 (source)
cerune_origin_mir_fn_0_bb2_i7_lir24:
  movq %rax, -80(%rbp)
# cerune-origin: #50 bytes 70..84
cerune_origin_n50_fn_0_25:
# cerune-mir: v1 fn_0 bb2 i7 -> lir 25 (source)
cerune_origin_mir_fn_0_bb2_i7_lir25:
  movq -16(%rbp), %rax
# cerune-origin: #50 bytes 70..84
cerune_origin_n50_fn_0_26:
# cerune-mir: v1 fn_0 bb2 i7 -> lir 26 (source)
cerune_origin_mir_fn_0_bb2_i7_lir26:
  movq %rax, -88(%rbp)
# cerune-origin: #51 bytes 70..84
cerune_origin_n51_fn_0_27:
# cerune-mir: v1 fn_0 bb2 i8 -> lir 27 (source)
cerune_origin_mir_fn_0_bb2_i8_lir27:
  movq -48(%rbp), %rax
# cerune-origin: #51 bytes 70..84
cerune_origin_n51_fn_0_28:
# cerune-mir: v1 fn_0 bb2 i8 -> lir 28 (source)
cerune_origin_mir_fn_0_bb2_i8_lir28:
  movq %rax, -96(%rbp)
# cerune-origin: #52 bytes 70..84
cerune_origin_n52_fn_0_29:
# cerune-mir: v1 fn_0 bb2 i9 -> lir 29 (source)
cerune_origin_mir_fn_0_bb2_i9_lir29:
  movq -96(%rbp), %rax
# cerune-origin: #52 bytes 70..84
cerune_origin_n52_fn_0_30:
# cerune-mir: v1 fn_0 bb2 i9 -> lir 30 (source)
cerune_origin_mir_fn_0_bb2_i9_lir30:
  testq %rax, %rax
  js .Lcerune_fn_0_array_oob_11
  cmpq $2, %rax
  jge .Lcerune_fn_0_array_oob_11
  imulq $-1, %rax
  leaq -80(%rbp,%rax,8), %rcx
  movq %rcx, -200(%rbp)
  jmp .Lcerune_fn_0_array_done_11
.Lcerune_fn_0_array_oob_11:
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_0(%rip), %rdx
  movl $71, %r8d
  callq _write
  movl $7, %ecx
  int $0x29
.Lcerune_fn_0_array_done_11:
# cerune-origin: #52 bytes 70..84
cerune_origin_n52_fn_0_31:
# cerune-mir: v1 fn_0 bb2 i9 -> lir 31 (source)
cerune_origin_mir_fn_0_bb2_i9_lir31:
  movq -200(%rbp), %r11
  movq (%r11), %rax
# cerune-origin: #52 bytes 70..84
cerune_origin_n52_fn_0_32:
# cerune-mir: v1 fn_0 bb2 i9 -> lir 32 (source)
cerune_origin_mir_fn_0_bb2_i9_lir32:
  movq %rax, -104(%rbp)
# cerune-origin: #53 bytes 70..84
cerune_origin_n53_fn_0_33:
# cerune-mir: v1 fn_0 bb2 i10 -> lir 33 (source)
cerune_origin_mir_fn_0_bb2_i10_lir33:
  movq -24(%rbp), %rax
# cerune-origin: #53 bytes 70..84
cerune_origin_n53_fn_0_34:
# cerune-mir: v1 fn_0 bb2 i10 -> lir 34 (source)
cerune_origin_mir_fn_0_bb2_i10_lir34:
  movq %rax, -112(%rbp)
# cerune-origin: #53 bytes 70..84
cerune_origin_n53_fn_0_35:
# cerune-mir: v1 fn_0 bb2 i10 -> lir 35 (source)
cerune_origin_mir_fn_0_bb2_i10_lir35:
  movq -32(%rbp), %rax
# cerune-origin: #53 bytes 70..84
cerune_origin_n53_fn_0_36:
# cerune-mir: v1 fn_0 bb2 i10 -> lir 36 (source)
cerune_origin_mir_fn_0_bb2_i10_lir36:
  movq %rax, -120(%rbp)
# cerune-origin: #54 bytes 70..84
cerune_origin_n54_fn_0_37:
# cerune-mir: v1 fn_0 bb2 i11 -> lir 37 (source)
cerune_origin_mir_fn_0_bb2_i11_lir37:
  movq -48(%rbp), %rax
# cerune-origin: #54 bytes 70..84
cerune_origin_n54_fn_0_38:
# cerune-mir: v1 fn_0 bb2 i11 -> lir 38 (source)
cerune_origin_mir_fn_0_bb2_i11_lir38:
  movq %rax, -128(%rbp)
# cerune-origin: #55 bytes 70..84
cerune_origin_n55_fn_0_39:
# cerune-mir: v1 fn_0 bb2 i12 -> lir 39 (source)
cerune_origin_mir_fn_0_bb2_i12_lir39:
  movq -128(%rbp), %rax
# cerune-origin: #55 bytes 70..84
cerune_origin_n55_fn_0_40:
# cerune-mir: v1 fn_0 bb2 i12 -> lir 40 (source)
cerune_origin_mir_fn_0_bb2_i12_lir40:
  testq %rax, %rax
  js .Lcerune_fn_0_array_oob_12
  cmpq $2, %rax
  jge .Lcerune_fn_0_array_oob_12
  imulq $-1, %rax
  leaq -112(%rbp,%rax,8), %rcx
  movq %rcx, -208(%rbp)
  jmp .Lcerune_fn_0_array_done_12
.Lcerune_fn_0_array_oob_12:
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_1(%rip), %rdx
  movl $71, %r8d
  callq _write
  movl $7, %ecx
  int $0x29
.Lcerune_fn_0_array_done_12:
# cerune-origin: #55 bytes 70..84
cerune_origin_n55_fn_0_41:
# cerune-mir: v1 fn_0 bb2 i12 -> lir 41 (source)
cerune_origin_mir_fn_0_bb2_i12_lir41:
  movq -208(%rbp), %r11
  movq (%r11), %rax
# cerune-origin: #55 bytes 70..84
cerune_origin_n55_fn_0_42:
# cerune-mir: v1 fn_0 bb2 i12 -> lir 42 (source)
cerune_origin_mir_fn_0_bb2_i12_lir42:
  movq %rax, -136(%rbp)
# cerune-origin: #56 bytes 70..84
cerune_origin_n56_fn_0_43:
# cerune-mir: v1 fn_0 bb2 i13 -> lir 43 (source)
cerune_origin_mir_fn_0_bb2_i13_lir43:
  movq -136(%rbp), %rax
# cerune-origin: #56 bytes 70..84
cerune_origin_n56_fn_0_44:
# cerune-mir: v1 fn_0 bb2 i13 -> lir 44 (source)
cerune_origin_mir_fn_0_bb2_i13_lir44:
  movq %rax, %rcx
# cerune-origin: #56 bytes 70..84
cerune_origin_n56_fn_0_45:
# cerune-mir: v1 fn_0 bb2 i13 -> lir 45 (source)
cerune_origin_mir_fn_0_bb2_i13_lir45:
  movq -104(%rbp), %rax
# cerune-origin: #56 bytes 70..84
cerune_origin_n56_fn_0_46:
# cerune-mir: v1 fn_0 bb2 i13 -> lir 46 (source)
cerune_origin_mir_fn_0_bb2_i13_lir46:
  cmpq %rcx, %rax
  sete %al
  movzbq %al, %rax
# cerune-origin: #56 bytes 70..84
cerune_origin_n56_fn_0_47:
# cerune-mir: v1 fn_0 bb2 i13 -> lir 47 (source)
cerune_origin_mir_fn_0_bb2_i13_lir47:
  movq %rax, -144(%rbp)
# cerune-origin: #57 bytes 70..84
cerune_origin_n57_fn_0_48:
# cerune-mir: v1 fn_0 bb2 i14 -> lir 48 (source)
cerune_origin_mir_fn_0_bb2_i14_lir48:
  movq -144(%rbp), %rax
# cerune-origin: #57 bytes 70..84
cerune_origin_n57_fn_0_49:
# cerune-mir: v1 fn_0 bb2 i14 -> lir 49 (source)
cerune_origin_mir_fn_0_bb2_i14_lir49:
  xorq $1, %rax
# cerune-origin: #57 bytes 70..84
cerune_origin_n57_fn_0_50:
# cerune-mir: v1 fn_0 bb2 i14 -> lir 50 (source)
cerune_origin_mir_fn_0_bb2_i14_lir50:
  movq %rax, -152(%rbp)
# cerune-origin: #60 bytes 70..84
cerune_origin_n60_fn_0_51:
# cerune-mir: v1 fn_0 bb2 i15 -> lir 51 (source)
cerune_origin_mir_fn_0_bb2_i15_lir51:
  movq -152(%rbp), %rax
# cerune-origin: #60 bytes 70..84
cerune_origin_n60_fn_0_52:
# cerune-mir: v1 fn_0 bb2 i15 -> lir 52 (source)
cerune_origin_mir_fn_0_bb2_i15_lir52:
  testq %rax, %rax
  je .Lcerune_fn_0_block_6
# cerune-origin: #60 bytes 70..84
cerune_origin_n60_fn_0_53:
# cerune-mir: v1 fn_0 bb2 i15 -> lir 53 (source)
cerune_origin_mir_fn_0_bb2_i15_lir53:
  jmp .Lcerune_fn_0_block_5
# cerune-origin: #65 bytes 70..84
cerune_origin_n65_fn_0_54:
# cerune-mir: v1 fn_0 bb3 block -> lir 54 (loop-exit)
cerune_origin_mir_fn_0_bb3_block_lir54:
.Lcerune_fn_0_block_3: # mir_block
# cerune-origin: #66 bytes 70..84
cerune_origin_n66_fn_0_55:
# cerune-mir: v1 fn_0 bb3 i26 -> lir 55 (source)
cerune_origin_mir_fn_0_bb3_i26_lir55:
  movabsq $1, %rax
# cerune-origin: #66 bytes 70..84
cerune_origin_n66_fn_0_56:
# cerune-mir: v1 fn_0 bb3 i26 -> lir 56 (source)
cerune_origin_mir_fn_0_bb3_i26_lir56:
  movq %rax, -192(%rbp)
# cerune-origin: #67 bytes 70..84
cerune_origin_n67_fn_0_57:
# cerune-mir: v1 fn_0 bb3 i27 -> lir 57 (source)
cerune_origin_mir_fn_0_bb3_i27_lir57:
  movq -192(%rbp), %rax
# cerune-origin: #67 bytes 70..84
cerune_origin_n67_fn_0_58:
# cerune-mir: v1 fn_0 bb3 i27 -> lir 58 (source)
cerune_origin_mir_fn_0_bb3_i27_lir58:
  addq $240, %rsp
  popq %rbp
  retq
# cerune-origin: #65 bytes 70..84
cerune_origin_n65_fn_0_59:
# cerune-mir: v1 fn_0 bb4 block -> lir 59 (for-update)
cerune_origin_mir_fn_0_bb4_block_lir59:
.Lcerune_fn_0_block_4: # mir_block
# cerune-origin: #61 bytes 70..84
cerune_origin_n61_fn_0_60:
# cerune-mir: v1 fn_0 bb4 i21 -> lir 60 (source)
cerune_origin_mir_fn_0_bb4_i21_lir60:
  movq -48(%rbp), %rax
# cerune-origin: #61 bytes 70..84
cerune_origin_n61_fn_0_61:
# cerune-mir: v1 fn_0 bb4 i21 -> lir 61 (source)
cerune_origin_mir_fn_0_bb4_i21_lir61:
  movq %rax, -168(%rbp)
# cerune-origin: #62 bytes 70..84
cerune_origin_n62_fn_0_62:
# cerune-mir: v1 fn_0 bb4 i22 -> lir 62 (source)
cerune_origin_mir_fn_0_bb4_i22_lir62:
  movabsq $1, %rax
# cerune-origin: #62 bytes 70..84
cerune_origin_n62_fn_0_63:
# cerune-mir: v1 fn_0 bb4 i22 -> lir 63 (source)
cerune_origin_mir_fn_0_bb4_i22_lir63:
  movq %rax, -176(%rbp)
# cerune-origin: #63 bytes 70..84
cerune_origin_n63_fn_0_64:
# cerune-mir: v1 fn_0 bb4 i23 -> lir 64 (source)
cerune_origin_mir_fn_0_bb4_i23_lir64:
  movq -176(%rbp), %rax
# cerune-origin: #63 bytes 70..84
cerune_origin_n63_fn_0_65:
# cerune-mir: v1 fn_0 bb4 i23 -> lir 65 (source)
cerune_origin_mir_fn_0_bb4_i23_lir65:
  movq %rax, %rcx
# cerune-origin: #63 bytes 70..84
cerune_origin_n63_fn_0_66:
# cerune-mir: v1 fn_0 bb4 i23 -> lir 66 (source)
cerune_origin_mir_fn_0_bb4_i23_lir66:
  movq -168(%rbp), %rax
# cerune-origin: #63 bytes 70..84
cerune_origin_n63_fn_0_67:
# cerune-mir: v1 fn_0 bb4 i23 -> lir 67 (source)
cerune_origin_mir_fn_0_bb4_i23_lir67:
  addq %rcx, %rax
# cerune-origin: #63 bytes 70..84
cerune_origin_n63_fn_0_68:
# cerune-mir: v1 fn_0 bb4 i23 -> lir 68 (source)
cerune_origin_mir_fn_0_bb4_i23_lir68:
  jno .Lcerune_fn_0_integer_ok_13
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_2(%rip), %rdx
  movl $62, %r8d
  callq _write
  movl $7, %ecx
  int $0x29
.Lcerune_fn_0_integer_ok_13:
# cerune-origin: #63 bytes 70..84
cerune_origin_n63_fn_0_69:
# cerune-mir: v1 fn_0 bb4 i23 -> lir 69 (source)
cerune_origin_mir_fn_0_bb4_i23_lir69:
  movq %rax, -184(%rbp)
# cerune-origin: #64 bytes 70..84
cerune_origin_n64_fn_0_70:
# cerune-mir: v1 fn_0 bb4 i24 -> lir 70 (source)
cerune_origin_mir_fn_0_bb4_i24_lir70:
  movq -184(%rbp), %rax
# cerune-origin: #64 bytes 70..84
cerune_origin_n64_fn_0_71:
# cerune-mir: v1 fn_0 bb4 i24 -> lir 71 (source)
cerune_origin_mir_fn_0_bb4_i24_lir71:
  movq %rax, -48(%rbp)
# cerune-origin: #65 bytes 70..84
cerune_origin_n65_fn_0_72:
# cerune-mir: v1 fn_0 bb4 i25 -> lir 72 (loop-back)
cerune_origin_mir_fn_0_bb4_i25_lir72:
  jmp .Lcerune_fn_0_block_1
# cerune-origin: #60 bytes 70..84
cerune_origin_n60_fn_0_73:
# cerune-mir: v1 fn_0 bb5 block -> lir 73 (if-then)
cerune_origin_mir_fn_0_bb5_block_lir73:
.Lcerune_fn_0_block_5: # mir_block
# cerune-origin: #58 bytes 70..84
cerune_origin_n58_fn_0_74:
# cerune-mir: v1 fn_0 bb5 i16 -> lir 74 (source)
cerune_origin_mir_fn_0_bb5_i16_lir74:
  movabsq $0, %rax
# cerune-origin: #58 bytes 70..84
cerune_origin_n58_fn_0_75:
# cerune-mir: v1 fn_0 bb5 i16 -> lir 75 (source)
cerune_origin_mir_fn_0_bb5_i16_lir75:
  movq %rax, -160(%rbp)
# cerune-origin: #59 bytes 70..84
cerune_origin_n59_fn_0_76:
# cerune-mir: v1 fn_0 bb5 i17 -> lir 76 (source)
cerune_origin_mir_fn_0_bb5_i17_lir76:
  movq -160(%rbp), %rax
# cerune-origin: #59 bytes 70..84
cerune_origin_n59_fn_0_77:
# cerune-mir: v1 fn_0 bb5 i17 -> lir 77 (source)
cerune_origin_mir_fn_0_bb5_i17_lir77:
  addq $240, %rsp
  popq %rbp
  retq
# cerune-origin: #60 bytes 70..84
cerune_origin_n60_fn_0_78:
# cerune-mir: v1 fn_0 bb6 block -> lir 78 (if-else)
cerune_origin_mir_fn_0_bb6_block_lir78:
.Lcerune_fn_0_block_6: # mir_block
# cerune-origin: #60 bytes 70..84
cerune_origin_n60_fn_0_79:
# cerune-mir: v1 fn_0 bb6 i19 -> lir 79 (if-join)
cerune_origin_mir_fn_0_bb6_i19_lir79:
  jmp .Lcerune_fn_0_block_7
# cerune-origin: #60 bytes 70..84
cerune_origin_n60_fn_0_80:
# cerune-mir: v1 fn_0 bb7 block -> lir 80 (if-join)
cerune_origin_mir_fn_0_bb7_block_lir80:
.Lcerune_fn_0_block_7: # mir_block
# cerune-origin: #65 bytes 70..84
cerune_origin_n65_fn_0_81:
# cerune-mir: v1 fn_0 bb7 i20 -> lir 81 (loop-back)
cerune_origin_mir_fn_0_bb7_i20_lir81:
  jmp .Lcerune_fn_0_block_4
# cerune-origin: #59 bytes 70..84
cerune_origin_n59_fn_0_82:
# cerune-mir: v1 fn_0 bb8 block -> lir 82 (after-return)
cerune_origin_mir_fn_0_bb8_block_lir82:
.Lcerune_fn_0_block_8: # mir_block
# cerune-origin: #60 bytes 70..84
cerune_origin_n60_fn_0_83:
# cerune-mir: v1 fn_0 bb8 i18 -> lir 83 (if-join)
cerune_origin_mir_fn_0_bb8_i18_lir83:
  jmp .Lcerune_fn_0_block_7
# cerune-origin: #67 bytes 70..84
cerune_origin_n67_fn_0_84:
# cerune-mir: v1 fn_0 bb9 block -> lir 84 (after-return)
cerune_origin_mir_fn_0_bb9_block_lir84:
.Lcerune_fn_0_block_9: # mir_block
# cerune-origin: synthetic
# cerune-mir: v1 fn_0 bb9 i28 -> lir 85 (function-end)
cerune_origin_mir_fn_0_bb9_i28_lir85:
  ud2

# cerune-origin: synthetic
.p2align 4
cerune_fn__match_bind1_1:
  pushq %rbp
  movq %rsp, %rbp
  subq $112, %rsp
# cerune-origin: synthetic
# cerune-mir: v1 synthetic ABI setup/exit
  movq 0(%rcx), %r10
  movq %r10, -8(%rbp)
  movq -8(%rcx), %r10
  movq %r10, -16(%rbp)
# cerune-origin: synthetic
# cerune-mir: v1 synthetic ABI setup/exit
  jmp .Lcerune_fn_1_block_0
# cerune-origin: synthetic
# cerune-mir: v1 fn_1 bb0 block -> lir 2 (function-entry)
cerune_origin_mir_fn_1_bb0_block_lir2:
.Lcerune_fn_1_block_0: # mir_block
# cerune-origin: #27 bytes 182..183
cerune_origin_n27_fn_1_3:
# cerune-mir: v1 fn_1 bb0 i0 -> lir 3 (source)
cerune_origin_mir_fn_1_bb0_i0_lir3:
  movq -8(%rbp), %rax
# cerune-origin: #27 bytes 182..183
cerune_origin_n27_fn_1_4:
# cerune-mir: v1 fn_1 bb0 i0 -> lir 4 (source)
cerune_origin_mir_fn_1_bb0_i0_lir4:
  movq %rax, -24(%rbp)
# cerune-origin: #27 bytes 182..183
cerune_origin_n27_fn_1_5:
# cerune-mir: v1 fn_1 bb0 i0 -> lir 5 (source)
cerune_origin_mir_fn_1_bb0_i0_lir5:
  movq -16(%rbp), %rax
# cerune-origin: #27 bytes 182..183
cerune_origin_n27_fn_1_6:
# cerune-mir: v1 fn_1 bb0 i0 -> lir 6 (source)
cerune_origin_mir_fn_1_bb0_i0_lir6:
  movq %rax, -32(%rbp)
# cerune-origin: #26 bytes 182..183
cerune_origin_n26_fn_1_7:
# cerune-mir: v1 fn_1 bb0 i1 -> lir 7 (source)
cerune_origin_mir_fn_1_bb0_i1_lir7:
  movq -32(%rbp), %rax
# cerune-origin: #26 bytes 182..183
cerune_origin_n26_fn_1_8:
# cerune-mir: v1 fn_1 bb0 i1 -> lir 8 (source)
cerune_origin_mir_fn_1_bb0_i1_lir8:
  movq %rax, -40(%rbp)
# cerune-origin: #69 bytes 189..194
cerune_origin_n69_fn_1_9:
# cerune-mir: v1 fn_1 bb0 i2 -> lir 9 (source)
cerune_origin_mir_fn_1_bb0_i2_lir9:
  movq -40(%rbp), %rax
# cerune-origin: #69 bytes 189..194
cerune_origin_n69_fn_1_10:
# cerune-mir: v1 fn_1 bb0 i2 -> lir 10 (source)
cerune_origin_mir_fn_1_bb0_i2_lir10:
  movq %rax, -48(%rbp)
# cerune-origin: #29 bytes 189..190
cerune_origin_n29_fn_1_11:
# cerune-mir: v1 fn_1 bb0 i3 -> lir 11 (source)
cerune_origin_mir_fn_1_bb0_i3_lir11:
  movq -48(%rbp), %rax
# cerune-origin: #29 bytes 189..190
cerune_origin_n29_fn_1_12:
# cerune-mir: v1 fn_1 bb0 i3 -> lir 12 (source)
cerune_origin_mir_fn_1_bb0_i3_lir12:
  movq %rax, -56(%rbp)
# cerune-origin: #30 bytes 193..194
cerune_origin_n30_fn_1_13:
# cerune-mir: v1 fn_1 bb0 i4 -> lir 13 (source)
cerune_origin_mir_fn_1_bb0_i4_lir13:
  movabsq $0, %rax
# cerune-origin: #30 bytes 193..194
cerune_origin_n30_fn_1_14:
# cerune-mir: v1 fn_1 bb0 i4 -> lir 14 (source)
cerune_origin_mir_fn_1_bb0_i4_lir14:
  movq %rax, -64(%rbp)
# cerune-origin: #28 bytes 189..194
cerune_origin_n28_fn_1_15:
# cerune-mir: v1 fn_1 bb0 i5 -> lir 15 (source)
cerune_origin_mir_fn_1_bb0_i5_lir15:
  movq -64(%rbp), %rax
# cerune-origin: #28 bytes 189..194
cerune_origin_n28_fn_1_16:
# cerune-mir: v1 fn_1 bb0 i5 -> lir 16 (source)
cerune_origin_mir_fn_1_bb0_i5_lir16:
  movq %rax, %rcx
# cerune-origin: #28 bytes 189..194
cerune_origin_n28_fn_1_17:
# cerune-mir: v1 fn_1 bb0 i5 -> lir 17 (source)
cerune_origin_mir_fn_1_bb0_i5_lir17:
  movq -56(%rbp), %rax
# cerune-origin: #28 bytes 189..194
cerune_origin_n28_fn_1_18:
# cerune-mir: v1 fn_1 bb0 i5 -> lir 18 (source)
cerune_origin_mir_fn_1_bb0_i5_lir18:
  cmpq %rcx, %rax
  setg %al
  movzbq %al, %rax
# cerune-origin: #28 bytes 189..194
cerune_origin_n28_fn_1_19:
# cerune-mir: v1 fn_1 bb0 i5 -> lir 19 (source)
cerune_origin_mir_fn_1_bb0_i5_lir19:
  movq %rax, -72(%rbp)
# cerune-origin: #70 bytes 189..194
cerune_origin_n70_fn_1_20:
# cerune-mir: v1 fn_1 bb0 i6 -> lir 20 (source)
cerune_origin_mir_fn_1_bb0_i6_lir20:
  movq -72(%rbp), %rax
# cerune-origin: #70 bytes 189..194
cerune_origin_n70_fn_1_21:
# cerune-mir: v1 fn_1 bb0 i6 -> lir 21 (source)
cerune_origin_mir_fn_1_bb0_i6_lir21:
  addq $112, %rsp
  popq %rbp
  retq
# cerune-origin: #70 bytes 189..194
cerune_origin_n70_fn_1_22:
# cerune-mir: v1 fn_1 bb1 block -> lir 22 (after-return)
cerune_origin_mir_fn_1_bb1_block_lir22:
.Lcerune_fn_1_block_1: # mir_block
# cerune-origin: synthetic
# cerune-mir: v1 fn_1 bb1 i7 -> lir 23 (function-end)
cerune_origin_mir_fn_1_bb1_i7_lir23:
  ud2

# cerune-origin: synthetic
.p2align 4
cerune_fn__match_bind2_2:
  pushq %rbp
  movq %rsp, %rbp
  subq $96, %rsp
# cerune-origin: synthetic
# cerune-mir: v1 synthetic ABI setup/exit
  movq 0(%rcx), %r10
  movq %r10, -8(%rbp)
  movq -8(%rcx), %r10
  movq %r10, -16(%rbp)
# cerune-origin: synthetic
# cerune-mir: v1 synthetic ABI setup/exit
  jmp .Lcerune_fn_2_block_0
# cerune-origin: synthetic
# cerune-mir: v1 fn_2 bb0 block -> lir 2 (function-entry)
cerune_origin_mir_fn_2_bb0_block_lir2:
.Lcerune_fn_2_block_0: # mir_block
# cerune-origin: #33 bytes 182..183
cerune_origin_n33_fn_2_3:
# cerune-mir: v1 fn_2 bb0 i0 -> lir 3 (source)
cerune_origin_mir_fn_2_bb0_i0_lir3:
  movq -8(%rbp), %rax
# cerune-origin: #33 bytes 182..183
cerune_origin_n33_fn_2_4:
# cerune-mir: v1 fn_2 bb0 i0 -> lir 4 (source)
cerune_origin_mir_fn_2_bb0_i0_lir4:
  movq %rax, -24(%rbp)
# cerune-origin: #33 bytes 182..183
cerune_origin_n33_fn_2_5:
# cerune-mir: v1 fn_2 bb0 i0 -> lir 5 (source)
cerune_origin_mir_fn_2_bb0_i0_lir5:
  movq -16(%rbp), %rax
# cerune-origin: #33 bytes 182..183
cerune_origin_n33_fn_2_6:
# cerune-mir: v1 fn_2 bb0 i0 -> lir 6 (source)
cerune_origin_mir_fn_2_bb0_i0_lir6:
  movq %rax, -32(%rbp)
# cerune-origin: #32 bytes 182..183
cerune_origin_n32_fn_2_7:
# cerune-mir: v1 fn_2 bb0 i1 -> lir 7 (source)
cerune_origin_mir_fn_2_bb0_i1_lir7:
  movq -32(%rbp), %rax
# cerune-origin: #32 bytes 182..183
cerune_origin_n32_fn_2_8:
# cerune-mir: v1 fn_2 bb0 i1 -> lir 8 (source)
cerune_origin_mir_fn_2_bb0_i1_lir8:
  movq %rax, -40(%rbp)
# cerune-origin: #73 bytes 198..199
cerune_origin_n73_fn_2_9:
# cerune-mir: v1 fn_2 bb0 i2 -> lir 9 (source)
cerune_origin_mir_fn_2_bb0_i2_lir9:
  movq -40(%rbp), %rax
# cerune-origin: #73 bytes 198..199
cerune_origin_n73_fn_2_10:
# cerune-mir: v1 fn_2 bb0 i2 -> lir 10 (source)
cerune_origin_mir_fn_2_bb0_i2_lir10:
  movq %rax, -48(%rbp)
# cerune-origin: #34 bytes 198..199
cerune_origin_n34_fn_2_11:
# cerune-mir: v1 fn_2 bb0 i3 -> lir 11 (source)
cerune_origin_mir_fn_2_bb0_i3_lir11:
  movq -48(%rbp), %rax
# cerune-origin: #34 bytes 198..199
cerune_origin_n34_fn_2_12:
# cerune-mir: v1 fn_2 bb0 i3 -> lir 12 (source)
cerune_origin_mir_fn_2_bb0_i3_lir12:
  movq %rax, -56(%rbp)
# cerune-origin: #74 bytes 198..199
cerune_origin_n74_fn_2_13:
# cerune-mir: v1 fn_2 bb0 i4 -> lir 13 (source)
cerune_origin_mir_fn_2_bb0_i4_lir13:
  movq -56(%rbp), %rax
# cerune-origin: #74 bytes 198..199
cerune_origin_n74_fn_2_14:
# cerune-mir: v1 fn_2 bb0 i4 -> lir 14 (source)
cerune_origin_mir_fn_2_bb0_i4_lir14:
  addq $96, %rsp
  popq %rbp
  retq
# cerune-origin: #74 bytes 198..199
cerune_origin_n74_fn_2_15:
# cerune-mir: v1 fn_2 bb1 block -> lir 15 (after-return)
cerune_origin_mir_fn_2_bb1_block_lir15:
.Lcerune_fn_2_block_1: # mir_block
# cerune-origin: synthetic
# cerune-mir: v1 fn_2 bb1 i5 -> lir 16 (function-end)
cerune_origin_mir_fn_2_bb1_i5_lir16:
  ud2

# cerune-origin: synthetic
.p2align 4
cerune_fn__match_select3_3:
  pushq %rbp
  movq %rsp, %rbp
  subq $112, %rsp
# cerune-origin: synthetic
# cerune-mir: v1 synthetic ABI setup/exit
  movq 0(%rcx), %r10
  movq %r10, -8(%rbp)
  movq -8(%rcx), %r10
  movq %r10, -16(%rbp)
# cerune-origin: synthetic
# cerune-mir: v1 synthetic ABI setup/exit
  jmp .Lcerune_fn_3_block_0
# cerune-origin: synthetic
# cerune-mir: v1 fn_3 bb0 block -> lir 2 (function-entry)
cerune_origin_mir_fn_3_bb0_block_lir2:
.Lcerune_fn_3_block_0: # mir_block
# cerune-origin: #38 bytes 205..216
cerune_origin_n38_fn_3_3:
# cerune-mir: v1 fn_3 bb0 i0 -> lir 3 (source)
cerune_origin_mir_fn_3_bb0_i0_lir3:
  movq -8(%rbp), %rax
# cerune-origin: #38 bytes 205..216
cerune_origin_n38_fn_3_4:
# cerune-mir: v1 fn_3 bb0 i0 -> lir 4 (source)
cerune_origin_mir_fn_3_bb0_i0_lir4:
  movq %rax, -24(%rbp)
# cerune-origin: #38 bytes 205..216
cerune_origin_n38_fn_3_5:
# cerune-mir: v1 fn_3 bb0 i0 -> lir 5 (source)
cerune_origin_mir_fn_3_bb0_i0_lir5:
  movq -16(%rbp), %rax
# cerune-origin: #38 bytes 205..216
cerune_origin_n38_fn_3_6:
# cerune-mir: v1 fn_3 bb0 i0 -> lir 6 (source)
cerune_origin_mir_fn_3_bb0_i0_lir6:
  movq %rax, -32(%rbp)
# cerune-origin: #37 bytes 205..216
cerune_origin_n37_fn_3_7:
# cerune-mir: v1 fn_3 bb0 i1 -> lir 7 (source)
cerune_origin_mir_fn_3_bb0_i1_lir7:
  movq -24(%rbp), %rax
# cerune-origin: #37 bytes 205..216
cerune_origin_n37_fn_3_8:
# cerune-mir: v1 fn_3 bb0 i1 -> lir 8 (source)
cerune_origin_mir_fn_3_bb0_i1_lir8:
  movq %rax, -40(%rbp)
# cerune-origin: #39 bytes 205..216
cerune_origin_n39_fn_3_9:
# cerune-mir: v1 fn_3 bb0 i2 -> lir 9 (source)
cerune_origin_mir_fn_3_bb0_i2_lir9:
  movabsq $0, %rax
# cerune-origin: #39 bytes 205..216
cerune_origin_n39_fn_3_10:
# cerune-mir: v1 fn_3 bb0 i2 -> lir 10 (source)
cerune_origin_mir_fn_3_bb0_i2_lir10:
  movq %rax, -48(%rbp)
# cerune-origin: #36 bytes 205..216
cerune_origin_n36_fn_3_11:
# cerune-mir: v1 fn_3 bb0 i3 -> lir 11 (source)
cerune_origin_mir_fn_3_bb0_i3_lir11:
  movq -48(%rbp), %rax
# cerune-origin: #36 bytes 205..216
cerune_origin_n36_fn_3_12:
# cerune-mir: v1 fn_3 bb0 i3 -> lir 12 (source)
cerune_origin_mir_fn_3_bb0_i3_lir12:
  movq %rax, %rcx
# cerune-origin: #36 bytes 205..216
cerune_origin_n36_fn_3_13:
# cerune-mir: v1 fn_3 bb0 i3 -> lir 13 (source)
cerune_origin_mir_fn_3_bb0_i3_lir13:
  movq -40(%rbp), %rax
# cerune-origin: #36 bytes 205..216
cerune_origin_n36_fn_3_14:
# cerune-mir: v1 fn_3 bb0 i3 -> lir 14 (source)
cerune_origin_mir_fn_3_bb0_i3_lir14:
  cmpq %rcx, %rax
  sete %al
  movzbq %al, %rax
# cerune-origin: #36 bytes 205..216
cerune_origin_n36_fn_3_15:
# cerune-mir: v1 fn_3 bb0 i3 -> lir 15 (source)
cerune_origin_mir_fn_3_bb0_i3_lir15:
  movq %rax, -56(%rbp)
# cerune-origin: #79 bytes 205..216
cerune_origin_n79_fn_3_16:
# cerune-mir: v1 fn_3 bb0 i4 -> lir 16 (source)
cerune_origin_mir_fn_3_bb0_i4_lir16:
  movq -56(%rbp), %rax
# cerune-origin: #79 bytes 205..216
cerune_origin_n79_fn_3_17:
# cerune-mir: v1 fn_3 bb0 i4 -> lir 17 (source)
cerune_origin_mir_fn_3_bb0_i4_lir17:
  testq %rax, %rax
  je .Lcerune_fn_3_block_2
# cerune-origin: #79 bytes 205..216
cerune_origin_n79_fn_3_18:
# cerune-mir: v1 fn_3 bb0 i4 -> lir 18 (source)
cerune_origin_mir_fn_3_bb0_i4_lir18:
  jmp .Lcerune_fn_3_block_1
# cerune-origin: #79 bytes 205..216
cerune_origin_n79_fn_3_19:
# cerune-mir: v1 fn_3 bb1 block -> lir 19 (if-then)
cerune_origin_mir_fn_3_bb1_block_lir19:
.Lcerune_fn_3_block_1: # mir_block
# cerune-origin: #40 bytes 229..230
cerune_origin_n40_fn_3_20:
# cerune-mir: v1 fn_3 bb1 i5 -> lir 20 (source)
cerune_origin_mir_fn_3_bb1_i5_lir20:
  movabsq $0, %rax
# cerune-origin: #40 bytes 229..230
cerune_origin_n40_fn_3_21:
# cerune-mir: v1 fn_3 bb1 i5 -> lir 21 (source)
cerune_origin_mir_fn_3_bb1_i5_lir21:
  movq %rax, -64(%rbp)
# cerune-origin: #77 bytes 205..216
cerune_origin_n77_fn_3_22:
# cerune-mir: v1 fn_3 bb1 i6 -> lir 22 (source)
cerune_origin_mir_fn_3_bb1_i6_lir22:
  movq -64(%rbp), %rax
# cerune-origin: #77 bytes 205..216
cerune_origin_n77_fn_3_23:
# cerune-mir: v1 fn_3 bb1 i6 -> lir 23 (source)
cerune_origin_mir_fn_3_bb1_i6_lir23:
  addq $112, %rsp
  popq %rbp
  retq
# cerune-origin: #79 bytes 205..216
cerune_origin_n79_fn_3_24:
# cerune-mir: v1 fn_3 bb2 block -> lir 24 (if-else)
cerune_origin_mir_fn_3_bb2_block_lir24:
.Lcerune_fn_3_block_2: # mir_block
# cerune-origin: #42 bytes 255..256
cerune_origin_n42_fn_3_25:
# cerune-mir: v1 fn_3 bb2 i8 -> lir 25 (source)
cerune_origin_mir_fn_3_bb2_i8_lir25:
  movabsq $1, %rax
# cerune-origin: #42 bytes 255..256
cerune_origin_n42_fn_3_26:
# cerune-mir: v1 fn_3 bb2 i8 -> lir 26 (source)
cerune_origin_mir_fn_3_bb2_i8_lir26:
  movq %rax, -72(%rbp)
# cerune-origin: #41 bytes 254..256
cerune_origin_n41_fn_3_27:
# cerune-mir: v1 fn_3 bb2 i9 -> lir 27 (source)
cerune_origin_mir_fn_3_bb2_i9_lir27:
  movq -72(%rbp), %rax
# cerune-origin: #41 bytes 254..256
cerune_origin_n41_fn_3_28:
# cerune-mir: v1 fn_3 bb2 i9 -> lir 28 (source)
cerune_origin_mir_fn_3_bb2_i9_lir28:
  negq %rax
# cerune-origin: #41 bytes 254..256
cerune_origin_n41_fn_3_29:
# cerune-mir: v1 fn_3 bb2 i9 -> lir 29 (source)
cerune_origin_mir_fn_3_bb2_i9_lir29:
  jno .Lcerune_fn_3_integer_ok_7
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_3(%rip), %rdx
  movl $64, %r8d
  callq _write
  movl $7, %ecx
  int $0x29
.Lcerune_fn_3_integer_ok_7:
# cerune-origin: #41 bytes 254..256
cerune_origin_n41_fn_3_30:
# cerune-mir: v1 fn_3 bb2 i9 -> lir 30 (source)
cerune_origin_mir_fn_3_bb2_i9_lir30:
  movq %rax, -80(%rbp)
# cerune-origin: #78 bytes 205..216
cerune_origin_n78_fn_3_31:
# cerune-mir: v1 fn_3 bb2 i10 -> lir 31 (source)
cerune_origin_mir_fn_3_bb2_i10_lir31:
  movq -80(%rbp), %rax
# cerune-origin: #78 bytes 205..216
cerune_origin_n78_fn_3_32:
# cerune-mir: v1 fn_3 bb2 i10 -> lir 32 (source)
cerune_origin_mir_fn_3_bb2_i10_lir32:
  addq $112, %rsp
  popq %rbp
  retq
# cerune-origin: #79 bytes 205..216
cerune_origin_n79_fn_3_33:
# cerune-mir: v1 fn_3 bb3 block -> lir 33 (if-join)
cerune_origin_mir_fn_3_bb3_block_lir33:
.Lcerune_fn_3_block_3: # mir_block
# cerune-origin: synthetic
# cerune-mir: v1 fn_3 bb3 i12 -> lir 34 (function-end)
cerune_origin_mir_fn_3_bb3_i12_lir34:
  ud2
# cerune-origin: #77 bytes 205..216
cerune_origin_n77_fn_3_35:
# cerune-mir: v1 fn_3 bb4 block -> lir 35 (after-return)
cerune_origin_mir_fn_3_bb4_block_lir35:
.Lcerune_fn_3_block_4: # mir_block
# cerune-origin: #79 bytes 205..216
cerune_origin_n79_fn_3_36:
# cerune-mir: v1 fn_3 bb4 i7 -> lir 36 (if-join)
cerune_origin_mir_fn_3_bb4_i7_lir36:
  jmp .Lcerune_fn_3_block_3
# cerune-origin: #78 bytes 205..216
cerune_origin_n78_fn_3_37:
# cerune-mir: v1 fn_3 bb5 block -> lir 37 (after-return)
cerune_origin_mir_fn_3_bb5_block_lir37:
.Lcerune_fn_3_block_5: # mir_block
# cerune-origin: #79 bytes 205..216
cerune_origin_n79_fn_3_38:
# cerune-mir: v1 fn_3 bb5 i11 -> lir 38 (if-join)
cerune_origin_mir_fn_3_bb5_i11_lir38:
  jmp .Lcerune_fn_3_block_3

# cerune-origin: synthetic
.p2align 4
cerune_fn__match_select4_4:
  pushq %rbp
  movq %rsp, %rbp
  subq $176, %rsp
# cerune-origin: synthetic
# cerune-mir: v1 synthetic ABI setup/exit
  movq 0(%rcx), %r10
  movq %r10, -8(%rbp)
  movq -8(%rcx), %r10
  movq %r10, -16(%rbp)
# cerune-origin: synthetic
# cerune-mir: v1 synthetic ABI setup/exit
  jmp .Lcerune_fn_4_block_0
# cerune-origin: synthetic
# cerune-mir: v1 fn_4 bb0 block -> lir 2 (function-entry)
cerune_origin_mir_fn_4_bb0_block_lir2:
.Lcerune_fn_4_block_0: # mir_block
# cerune-origin: #23 bytes 165..176
cerune_origin_n23_fn_4_3:
# cerune-mir: v1 fn_4 bb0 i0 -> lir 3 (source)
cerune_origin_mir_fn_4_bb0_i0_lir3:
  movq -8(%rbp), %rax
# cerune-origin: #23 bytes 165..176
cerune_origin_n23_fn_4_4:
# cerune-mir: v1 fn_4 bb0 i0 -> lir 4 (source)
cerune_origin_mir_fn_4_bb0_i0_lir4:
  movq %rax, -24(%rbp)
# cerune-origin: #23 bytes 165..176
cerune_origin_n23_fn_4_5:
# cerune-mir: v1 fn_4 bb0 i0 -> lir 5 (source)
cerune_origin_mir_fn_4_bb0_i0_lir5:
  movq -16(%rbp), %rax
# cerune-origin: #23 bytes 165..176
cerune_origin_n23_fn_4_6:
# cerune-mir: v1 fn_4 bb0 i0 -> lir 6 (source)
cerune_origin_mir_fn_4_bb0_i0_lir6:
  movq %rax, -32(%rbp)
# cerune-origin: #22 bytes 165..176
cerune_origin_n22_fn_4_7:
# cerune-mir: v1 fn_4 bb0 i1 -> lir 7 (source)
cerune_origin_mir_fn_4_bb0_i1_lir7:
  movq -24(%rbp), %rax
# cerune-origin: #22 bytes 165..176
cerune_origin_n22_fn_4_8:
# cerune-mir: v1 fn_4 bb0 i1 -> lir 8 (source)
cerune_origin_mir_fn_4_bb0_i1_lir8:
  movq %rax, -40(%rbp)
# cerune-origin: #24 bytes 165..176
cerune_origin_n24_fn_4_9:
# cerune-mir: v1 fn_4 bb0 i2 -> lir 9 (source)
cerune_origin_mir_fn_4_bb0_i2_lir9:
  movabsq $0, %rax
# cerune-origin: #24 bytes 165..176
cerune_origin_n24_fn_4_10:
# cerune-mir: v1 fn_4 bb0 i2 -> lir 10 (source)
cerune_origin_mir_fn_4_bb0_i2_lir10:
  movq %rax, -48(%rbp)
# cerune-origin: #21 bytes 165..176
cerune_origin_n21_fn_4_11:
# cerune-mir: v1 fn_4 bb0 i3 -> lir 11 (source)
cerune_origin_mir_fn_4_bb0_i3_lir11:
  movq -48(%rbp), %rax
# cerune-origin: #21 bytes 165..176
cerune_origin_n21_fn_4_12:
# cerune-mir: v1 fn_4 bb0 i3 -> lir 12 (source)
cerune_origin_mir_fn_4_bb0_i3_lir12:
  movq %rax, %rcx
# cerune-origin: #21 bytes 165..176
cerune_origin_n21_fn_4_13:
# cerune-mir: v1 fn_4 bb0 i3 -> lir 13 (source)
cerune_origin_mir_fn_4_bb0_i3_lir13:
  movq -40(%rbp), %rax
# cerune-origin: #21 bytes 165..176
cerune_origin_n21_fn_4_14:
# cerune-mir: v1 fn_4 bb0 i3 -> lir 14 (source)
cerune_origin_mir_fn_4_bb0_i3_lir14:
  cmpq %rcx, %rax
  sete %al
  movzbq %al, %rax
# cerune-origin: #21 bytes 165..176
cerune_origin_n21_fn_4_15:
# cerune-mir: v1 fn_4 bb0 i3 -> lir 15 (source)
cerune_origin_mir_fn_4_bb0_i3_lir15:
  movq %rax, -56(%rbp)
# cerune-origin: #20 bytes 165..176
cerune_origin_n20_fn_4_16:
# cerune-mir: v1 fn_4 bb0 i4 -> lir 16 (short-circuit-result)
cerune_origin_mir_fn_4_bb0_i4_lir16:
  movq -56(%rbp), %rax
# cerune-origin: #20 bytes 165..176
cerune_origin_n20_fn_4_17:
# cerune-mir: v1 fn_4 bb0 i4 -> lir 17 (short-circuit-result)
cerune_origin_mir_fn_4_bb0_i4_lir17:
  movq %rax, -64(%rbp)
# cerune-origin: #20 bytes 165..176
cerune_origin_n20_fn_4_18:
# cerune-mir: v1 fn_4 bb0 i5 -> lir 18 (source)
cerune_origin_mir_fn_4_bb0_i5_lir18:
  movq -56(%rbp), %rax
# cerune-origin: #20 bytes 165..176
cerune_origin_n20_fn_4_19:
# cerune-mir: v1 fn_4 bb0 i5 -> lir 19 (source)
cerune_origin_mir_fn_4_bb0_i5_lir19:
  testq %rax, %rax
  je .Lcerune_fn_4_block_2
# cerune-origin: #20 bytes 165..176
cerune_origin_n20_fn_4_20:
# cerune-mir: v1 fn_4 bb0 i5 -> lir 20 (source)
cerune_origin_mir_fn_4_bb0_i5_lir20:
  jmp .Lcerune_fn_4_block_1
# cerune-origin: #20 bytes 165..176
cerune_origin_n20_fn_4_21:
# cerune-mir: v1 fn_4 bb1 block -> lir 21 (short-circuit-rhs)
cerune_origin_mir_fn_4_bb1_block_lir21:
.Lcerune_fn_4_block_1: # mir_block
# cerune-origin: #71 bytes 182..183
cerune_origin_n71_fn_4_22:
# cerune-mir: v1 fn_4 bb1 i6 -> lir 22 (source)
cerune_origin_mir_fn_4_bb1_i6_lir22:
  movq -8(%rbp), %rax
# cerune-origin: #71 bytes 182..183
cerune_origin_n71_fn_4_23:
# cerune-mir: v1 fn_4 bb1 i6 -> lir 23 (source)
cerune_origin_mir_fn_4_bb1_i6_lir23:
  movq %rax, -72(%rbp)
# cerune-origin: #71 bytes 182..183
cerune_origin_n71_fn_4_24:
# cerune-mir: v1 fn_4 bb1 i6 -> lir 24 (source)
cerune_origin_mir_fn_4_bb1_i6_lir24:
  movq -16(%rbp), %rax
# cerune-origin: #71 bytes 182..183
cerune_origin_n71_fn_4_25:
# cerune-mir: v1 fn_4 bb1 i6 -> lir 25 (source)
cerune_origin_mir_fn_4_bb1_i6_lir25:
  movq %rax, -80(%rbp)
# cerune-origin: #25 bytes 189..194
cerune_origin_n25_fn_4_26:
# cerune-mir: v1 fn_4 bb1 i7 -> lir 26 (source)
cerune_origin_mir_fn_4_bb1_i7_lir26:
  leaq -72(%rbp), %rcx
  callq cerune_fn__match_bind1_1
# cerune-origin: #25 bytes 189..194
cerune_origin_n25_fn_4_27:
# cerune-mir: v1 fn_4 bb1 i7 -> lir 27 (source)
cerune_origin_mir_fn_4_bb1_i7_lir27:
  movq %rax, -88(%rbp)
# cerune-origin: #20 bytes 165..176
cerune_origin_n20_fn_4_28:
# cerune-mir: v1 fn_4 bb1 i8 -> lir 28 (short-circuit-result)
cerune_origin_mir_fn_4_bb1_i8_lir28:
  movq -88(%rbp), %rax
# cerune-origin: #20 bytes 165..176
cerune_origin_n20_fn_4_29:
# cerune-mir: v1 fn_4 bb1 i8 -> lir 29 (short-circuit-result)
cerune_origin_mir_fn_4_bb1_i8_lir29:
  movq %rax, -64(%rbp)
# cerune-origin: #20 bytes 165..176
cerune_origin_n20_fn_4_30:
# cerune-mir: v1 fn_4 bb1 i9 -> lir 30 (short-circuit-join)
cerune_origin_mir_fn_4_bb1_i9_lir30:
  jmp .Lcerune_fn_4_block_2
# cerune-origin: #20 bytes 165..176
cerune_origin_n20_fn_4_31:
# cerune-mir: v1 fn_4 bb2 block -> lir 31 (short-circuit-join)
cerune_origin_mir_fn_4_bb2_block_lir31:
.Lcerune_fn_4_block_2: # mir_block
# cerune-origin: #84 bytes 165..176
cerune_origin_n84_fn_4_32:
# cerune-mir: v1 fn_4 bb2 i10 -> lir 32 (source)
cerune_origin_mir_fn_4_bb2_i10_lir32:
  movq -64(%rbp), %rax
# cerune-origin: #84 bytes 165..176
cerune_origin_n84_fn_4_33:
# cerune-mir: v1 fn_4 bb2 i10 -> lir 33 (source)
cerune_origin_mir_fn_4_bb2_i10_lir33:
  testq %rax, %rax
  je .Lcerune_fn_4_block_4
# cerune-origin: #84 bytes 165..176
cerune_origin_n84_fn_4_34:
# cerune-mir: v1 fn_4 bb2 i10 -> lir 34 (source)
cerune_origin_mir_fn_4_bb2_i10_lir34:
  jmp .Lcerune_fn_4_block_3
# cerune-origin: #84 bytes 165..176
cerune_origin_n84_fn_4_35:
# cerune-mir: v1 fn_4 bb3 block -> lir 35 (if-then)
cerune_origin_mir_fn_4_bb3_block_lir35:
.Lcerune_fn_4_block_3: # mir_block
# cerune-origin: #75 bytes 182..183
cerune_origin_n75_fn_4_36:
# cerune-mir: v1 fn_4 bb3 i11 -> lir 36 (source)
cerune_origin_mir_fn_4_bb3_i11_lir36:
  movq -8(%rbp), %rax
# cerune-origin: #75 bytes 182..183
cerune_origin_n75_fn_4_37:
# cerune-mir: v1 fn_4 bb3 i11 -> lir 37 (source)
cerune_origin_mir_fn_4_bb3_i11_lir37:
  movq %rax, -96(%rbp)
# cerune-origin: #75 bytes 182..183
cerune_origin_n75_fn_4_38:
# cerune-mir: v1 fn_4 bb3 i11 -> lir 38 (source)
cerune_origin_mir_fn_4_bb3_i11_lir38:
  movq -16(%rbp), %rax
# cerune-origin: #75 bytes 182..183
cerune_origin_n75_fn_4_39:
# cerune-mir: v1 fn_4 bb3 i11 -> lir 39 (source)
cerune_origin_mir_fn_4_bb3_i11_lir39:
  movq %rax, -104(%rbp)
# cerune-origin: #31 bytes 198..199
cerune_origin_n31_fn_4_40:
# cerune-mir: v1 fn_4 bb3 i12 -> lir 40 (source)
cerune_origin_mir_fn_4_bb3_i12_lir40:
  leaq -96(%rbp), %rcx
  callq cerune_fn__match_bind2_2
# cerune-origin: #31 bytes 198..199
cerune_origin_n31_fn_4_41:
# cerune-mir: v1 fn_4 bb3 i12 -> lir 41 (source)
cerune_origin_mir_fn_4_bb3_i12_lir41:
  movq %rax, -112(%rbp)
# cerune-origin: #82 bytes 165..176
cerune_origin_n82_fn_4_42:
# cerune-mir: v1 fn_4 bb3 i13 -> lir 42 (source)
cerune_origin_mir_fn_4_bb3_i13_lir42:
  movq -112(%rbp), %rax
# cerune-origin: #82 bytes 165..176
cerune_origin_n82_fn_4_43:
# cerune-mir: v1 fn_4 bb3 i13 -> lir 43 (source)
cerune_origin_mir_fn_4_bb3_i13_lir43:
  addq $176, %rsp
  popq %rbp
  retq
# cerune-origin: #84 bytes 165..176
cerune_origin_n84_fn_4_44:
# cerune-mir: v1 fn_4 bb4 block -> lir 44 (if-else)
cerune_origin_mir_fn_4_bb4_block_lir44:
.Lcerune_fn_4_block_4: # mir_block
# cerune-origin: #80 bytes 205..216
cerune_origin_n80_fn_4_45:
# cerune-mir: v1 fn_4 bb4 i15 -> lir 45 (source)
cerune_origin_mir_fn_4_bb4_i15_lir45:
  movq -8(%rbp), %rax
# cerune-origin: #80 bytes 205..216
cerune_origin_n80_fn_4_46:
# cerune-mir: v1 fn_4 bb4 i15 -> lir 46 (source)
cerune_origin_mir_fn_4_bb4_i15_lir46:
  movq %rax, -120(%rbp)
# cerune-origin: #80 bytes 205..216
cerune_origin_n80_fn_4_47:
# cerune-mir: v1 fn_4 bb4 i15 -> lir 47 (source)
cerune_origin_mir_fn_4_bb4_i15_lir47:
  movq -16(%rbp), %rax
# cerune-origin: #80 bytes 205..216
cerune_origin_n80_fn_4_48:
# cerune-mir: v1 fn_4 bb4 i15 -> lir 48 (source)
cerune_origin_mir_fn_4_bb4_i15_lir48:
  movq %rax, -128(%rbp)
# cerune-origin: #35 bytes 205..216
cerune_origin_n35_fn_4_49:
# cerune-mir: v1 fn_4 bb4 i16 -> lir 49 (source)
cerune_origin_mir_fn_4_bb4_i16_lir49:
  leaq -120(%rbp), %rcx
  callq cerune_fn__match_select3_3
# cerune-origin: #35 bytes 205..216
cerune_origin_n35_fn_4_50:
# cerune-mir: v1 fn_4 bb4 i16 -> lir 50 (source)
cerune_origin_mir_fn_4_bb4_i16_lir50:
  movq %rax, -136(%rbp)
# cerune-origin: #83 bytes 165..176
cerune_origin_n83_fn_4_51:
# cerune-mir: v1 fn_4 bb4 i17 -> lir 51 (source)
cerune_origin_mir_fn_4_bb4_i17_lir51:
  movq -136(%rbp), %rax
# cerune-origin: #83 bytes 165..176
cerune_origin_n83_fn_4_52:
# cerune-mir: v1 fn_4 bb4 i17 -> lir 52 (source)
cerune_origin_mir_fn_4_bb4_i17_lir52:
  addq $176, %rsp
  popq %rbp
  retq
# cerune-origin: #84 bytes 165..176
cerune_origin_n84_fn_4_53:
# cerune-mir: v1 fn_4 bb5 block -> lir 53 (if-join)
cerune_origin_mir_fn_4_bb5_block_lir53:
.Lcerune_fn_4_block_5: # mir_block
# cerune-origin: synthetic
# cerune-mir: v1 fn_4 bb5 i19 -> lir 54 (function-end)
cerune_origin_mir_fn_4_bb5_i19_lir54:
  ud2
# cerune-origin: #82 bytes 165..176
cerune_origin_n82_fn_4_55:
# cerune-mir: v1 fn_4 bb6 block -> lir 55 (after-return)
cerune_origin_mir_fn_4_bb6_block_lir55:
.Lcerune_fn_4_block_6: # mir_block
# cerune-origin: #84 bytes 165..176
cerune_origin_n84_fn_4_56:
# cerune-mir: v1 fn_4 bb6 i14 -> lir 56 (if-join)
cerune_origin_mir_fn_4_bb6_i14_lir56:
  jmp .Lcerune_fn_4_block_5
# cerune-origin: #83 bytes 165..176
cerune_origin_n83_fn_4_57:
# cerune-mir: v1 fn_4 bb7 block -> lir 57 (after-return)
cerune_origin_mir_fn_4_bb7_block_lir57:
.Lcerune_fn_4_block_7: # mir_block
# cerune-origin: #84 bytes 165..176
cerune_origin_n84_fn_4_58:
# cerune-mir: v1 fn_4 bb7 i18 -> lir 58 (if-join)
cerune_origin_mir_fn_4_bb7_i18_lir58:
  jmp .Lcerune_fn_4_block_5

# cerune-origin: synthetic
.p2align 4
cerune_fn__match_bind5_5:
  pushq %rbp
  movq %rsp, %rbp
  subq $112, %rsp
# cerune-origin: synthetic
# cerune-mir: v1 synthetic ABI setup/exit
  jmp .Lcerune_fn_5_block_0
# cerune-origin: synthetic
# cerune-mir: v1 fn_5 bb0 block -> lir 1 (function-entry)
cerune_origin_mir_fn_5_bb0_block_lir1:
.Lcerune_fn_5_block_0: # mir_block
# cerune-origin: #17 bytes 137..148
cerune_origin_n17_fn_5_2:
# cerune-mir: v1 fn_5 bb0 i0 -> lir 2 (source)
cerune_origin_mir_fn_5_bb0_i0_lir2:
  movabsq $0, %rax
# cerune-origin: #17 bytes 137..148
cerune_origin_n17_fn_5_3:
# cerune-mir: v1 fn_5 bb0 i0 -> lir 3 (source)
cerune_origin_mir_fn_5_bb0_i0_lir3:
  movq %rax, -8(%rbp)
# cerune-origin: #18 bytes 154..155
cerune_origin_n18_fn_5_4:
# cerune-mir: v1 fn_5 bb0 i1 -> lir 4 (source)
cerune_origin_mir_fn_5_bb0_i1_lir4:
  movabsq $7, %rax
# cerune-origin: #18 bytes 154..155
cerune_origin_n18_fn_5_5:
# cerune-mir: v1 fn_5 bb0 i1 -> lir 5 (source)
cerune_origin_mir_fn_5_bb0_i1_lir5:
  movq %rax, -16(%rbp)
# cerune-origin: #16 bytes 136..158
cerune_origin_n16_fn_5_6:
# cerune-mir: v1 fn_5 bb0 i2 -> lir 6 (source)
cerune_origin_mir_fn_5_bb0_i2_lir6:
  movq -8(%rbp), %rax
# cerune-origin: #16 bytes 136..158
cerune_origin_n16_fn_5_7:
# cerune-mir: v1 fn_5 bb0 i2 -> lir 7 (source)
cerune_origin_mir_fn_5_bb0_i2_lir7:
  movq %rax, -24(%rbp)
# cerune-origin: #16 bytes 136..158
cerune_origin_n16_fn_5_8:
# cerune-mir: v1 fn_5 bb0 i2 -> lir 8 (source)
cerune_origin_mir_fn_5_bb0_i2_lir8:
  movq -16(%rbp), %rax
# cerune-origin: #16 bytes 136..158
cerune_origin_n16_fn_5_9:
# cerune-mir: v1 fn_5 bb0 i2 -> lir 9 (source)
cerune_origin_mir_fn_5_bb0_i2_lir9:
  movq %rax, -32(%rbp)
# cerune-origin: #87 bytes 130..259
cerune_origin_n87_fn_5_10:
# cerune-mir: v1 fn_5 bb0 i3 -> lir 10 (source)
cerune_origin_mir_fn_5_bb0_i3_lir10:
  movq -24(%rbp), %rax
# cerune-origin: #87 bytes 130..259
cerune_origin_n87_fn_5_11:
# cerune-mir: v1 fn_5 bb0 i3 -> lir 11 (source)
cerune_origin_mir_fn_5_bb0_i3_lir11:
  movq %rax, -40(%rbp)
# cerune-origin: #87 bytes 130..259
cerune_origin_n87_fn_5_12:
# cerune-mir: v1 fn_5 bb0 i3 -> lir 12 (source)
cerune_origin_mir_fn_5_bb0_i3_lir12:
  movq -32(%rbp), %rax
# cerune-origin: #87 bytes 130..259
cerune_origin_n87_fn_5_13:
# cerune-mir: v1 fn_5 bb0 i3 -> lir 13 (source)
cerune_origin_mir_fn_5_bb0_i3_lir13:
  movq %rax, -48(%rbp)
# cerune-origin: #85 bytes 165..176
cerune_origin_n85_fn_5_14:
# cerune-mir: v1 fn_5 bb0 i4 -> lir 14 (source)
cerune_origin_mir_fn_5_bb0_i4_lir14:
  movq -40(%rbp), %rax
# cerune-origin: #85 bytes 165..176
cerune_origin_n85_fn_5_15:
# cerune-mir: v1 fn_5 bb0 i4 -> lir 15 (source)
cerune_origin_mir_fn_5_bb0_i4_lir15:
  movq %rax, -56(%rbp)
# cerune-origin: #85 bytes 165..176
cerune_origin_n85_fn_5_16:
# cerune-mir: v1 fn_5 bb0 i4 -> lir 16 (source)
cerune_origin_mir_fn_5_bb0_i4_lir16:
  movq -48(%rbp), %rax
# cerune-origin: #85 bytes 165..176
cerune_origin_n85_fn_5_17:
# cerune-mir: v1 fn_5 bb0 i4 -> lir 17 (source)
cerune_origin_mir_fn_5_bb0_i4_lir17:
  movq %rax, -64(%rbp)
# cerune-origin: #19 bytes 165..176
cerune_origin_n19_fn_5_18:
# cerune-mir: v1 fn_5 bb0 i5 -> lir 18 (source)
cerune_origin_mir_fn_5_bb0_i5_lir18:
  leaq -56(%rbp), %rcx
  callq cerune_fn__match_select4_4
# cerune-origin: #19 bytes 165..176
cerune_origin_n19_fn_5_19:
# cerune-mir: v1 fn_5 bb0 i5 -> lir 19 (source)
cerune_origin_mir_fn_5_bb0_i5_lir19:
  movq %rax, -72(%rbp)
# cerune-origin: #88 bytes 130..259
cerune_origin_n88_fn_5_20:
# cerune-mir: v1 fn_5 bb0 i6 -> lir 20 (source)
cerune_origin_mir_fn_5_bb0_i6_lir20:
  movq -72(%rbp), %rax
# cerune-origin: #88 bytes 130..259
cerune_origin_n88_fn_5_21:
# cerune-mir: v1 fn_5 bb0 i6 -> lir 21 (source)
cerune_origin_mir_fn_5_bb0_i6_lir21:
  addq $112, %rsp
  popq %rbp
  retq
# cerune-origin: #88 bytes 130..259
cerune_origin_n88_fn_5_22:
# cerune-mir: v1 fn_5 bb1 block -> lir 22 (after-return)
cerune_origin_mir_fn_5_bb1_block_lir22:
.Lcerune_fn_5_block_1: # mir_block
# cerune-origin: synthetic
# cerune-mir: v1 fn_5 bb1 i7 -> lir 23 (function-end)
cerune_origin_mir_fn_5_bb1_i7_lir23:
  ud2

# cerune-origin: synthetic
.p2align 4
cerune_fn__display6_6:
  pushq %rbp
  movq %rsp, %rbp
  subq $224, %rsp
# cerune-origin: synthetic
# cerune-mir: v1 synthetic ABI setup/exit
  movq 0(%rcx), %r10
  movq %r10, -8(%rbp)
  movq -8(%rcx), %r10
  movq %r10, -16(%rbp)
# cerune-origin: synthetic
# cerune-mir: v1 synthetic ABI setup/exit
  jmp .Lcerune_fn_6_block_0
# cerune-origin: synthetic
# cerune-mir: v1 fn_6 bb0 block -> lir 2 (function-entry)
cerune_origin_mir_fn_6_bb0_block_lir2:
.Lcerune_fn_6_block_0: # mir_block
# cerune-origin: #90 bytes 87..115
cerune_origin_n90_fn_6_3:
# cerune-mir: v1 fn_6 bb0 i0 -> lir 3 (source)
cerune_origin_mir_fn_6_bb0_i0_lir3:
  movq -8(%rbp), %rax
# cerune-origin: #90 bytes 87..115
cerune_origin_n90_fn_6_4:
# cerune-mir: v1 fn_6 bb0 i0 -> lir 4 (source)
cerune_origin_mir_fn_6_bb0_i0_lir4:
  movq %rax, -24(%rbp)
# cerune-origin: #90 bytes 87..115
cerune_origin_n90_fn_6_5:
# cerune-mir: v1 fn_6 bb0 i0 -> lir 5 (source)
cerune_origin_mir_fn_6_bb0_i0_lir5:
  movq -16(%rbp), %rax
# cerune-origin: #90 bytes 87..115
cerune_origin_n90_fn_6_6:
# cerune-mir: v1 fn_6 bb0 i0 -> lir 6 (source)
cerune_origin_mir_fn_6_bb0_i0_lir6:
  movq %rax, -32(%rbp)
# cerune-origin: #91 bytes 87..115
cerune_origin_n91_fn_6_7:
# cerune-mir: v1 fn_6 bb0 i1 -> lir 7 (source)
cerune_origin_mir_fn_6_bb0_i1_lir7:
  movq -24(%rbp), %rax
# cerune-origin: #91 bytes 87..115
cerune_origin_n91_fn_6_8:
# cerune-mir: v1 fn_6 bb0 i1 -> lir 8 (source)
cerune_origin_mir_fn_6_bb0_i1_lir8:
  movq %rax, -40(%rbp)
# cerune-origin: #92 bytes 87..115
cerune_origin_n92_fn_6_9:
# cerune-mir: v1 fn_6 bb0 i2 -> lir 9 (source)
cerune_origin_mir_fn_6_bb0_i2_lir9:
  movabsq $0, %rax
# cerune-origin: #92 bytes 87..115
cerune_origin_n92_fn_6_10:
# cerune-mir: v1 fn_6 bb0 i2 -> lir 10 (source)
cerune_origin_mir_fn_6_bb0_i2_lir10:
  movq %rax, -48(%rbp)
# cerune-origin: #93 bytes 87..115
cerune_origin_n93_fn_6_11:
# cerune-mir: v1 fn_6 bb0 i3 -> lir 11 (source)
cerune_origin_mir_fn_6_bb0_i3_lir11:
  movq -48(%rbp), %rax
# cerune-origin: #93 bytes 87..115
cerune_origin_n93_fn_6_12:
# cerune-mir: v1 fn_6 bb0 i3 -> lir 12 (source)
cerune_origin_mir_fn_6_bb0_i3_lir12:
  movq %rax, %rcx
# cerune-origin: #93 bytes 87..115
cerune_origin_n93_fn_6_13:
# cerune-mir: v1 fn_6 bb0 i3 -> lir 13 (source)
cerune_origin_mir_fn_6_bb0_i3_lir13:
  movq -40(%rbp), %rax
# cerune-origin: #93 bytes 87..115
cerune_origin_n93_fn_6_14:
# cerune-mir: v1 fn_6 bb0 i3 -> lir 14 (source)
cerune_origin_mir_fn_6_bb0_i3_lir14:
  cmpq %rcx, %rax
  sete %al
  movzbq %al, %rax
# cerune-origin: #93 bytes 87..115
cerune_origin_n93_fn_6_15:
# cerune-mir: v1 fn_6 bb0 i3 -> lir 15 (source)
cerune_origin_mir_fn_6_bb0_i3_lir15:
  movq %rax, -56(%rbp)
# cerune-origin: #105 bytes 87..115
cerune_origin_n105_fn_6_16:
# cerune-mir: v1 fn_6 bb0 i4 -> lir 16 (source)
cerune_origin_mir_fn_6_bb0_i4_lir16:
  movq -56(%rbp), %rax
# cerune-origin: #105 bytes 87..115
cerune_origin_n105_fn_6_17:
# cerune-mir: v1 fn_6 bb0 i4 -> lir 17 (source)
cerune_origin_mir_fn_6_bb0_i4_lir17:
  testq %rax, %rax
  je .Lcerune_fn_6_block_2
# cerune-origin: #105 bytes 87..115
cerune_origin_n105_fn_6_18:
# cerune-mir: v1 fn_6 bb0 i4 -> lir 18 (source)
cerune_origin_mir_fn_6_bb0_i4_lir18:
  jmp .Lcerune_fn_6_block_1
# cerune-origin: #105 bytes 87..115
cerune_origin_n105_fn_6_19:
# cerune-mir: v1 fn_6 bb1 block -> lir 19 (if-then)
cerune_origin_mir_fn_6_bb1_block_lir19:
.Lcerune_fn_6_block_1: # mir_block
# cerune-origin: #94 bytes 87..115
cerune_origin_n94_fn_6_20:
# cerune-mir: v1 fn_6 bb1 i5 -> lir 20 (source)
cerune_origin_mir_fn_6_bb1_i5_lir20:
  leaq .Lcerune_string_0(%rip), %rax
# cerune-origin: #94 bytes 87..115
cerune_origin_n94_fn_6_21:
# cerune-mir: v1 fn_6 bb1 i5 -> lir 21 (source)
cerune_origin_mir_fn_6_bb1_i5_lir21:
  movq %rax, -64(%rbp)
# cerune-origin: #95 bytes 87..115
cerune_origin_n95_fn_6_22:
# cerune-mir: v1 fn_6 bb1 i6 -> lir 22 (source)
cerune_origin_mir_fn_6_bb1_i6_lir22:
  movq -64(%rbp), %rax
# cerune-origin: #95 bytes 87..115
cerune_origin_n95_fn_6_23:
# cerune-mir: v1 fn_6 bb1 i6 -> lir 23 (source)
cerune_origin_mir_fn_6_bb1_i6_lir23:
  movq %rax, %rcx
  callq cerune_write_string
# cerune-origin: #96 bytes 87..115
cerune_origin_n96_fn_6_24:
# cerune-mir: v1 fn_6 bb1 i7 -> lir 24 (source)
cerune_origin_mir_fn_6_bb1_i7_lir24:
  leaq .Lcerune_string_1(%rip), %rax
# cerune-origin: #96 bytes 87..115
cerune_origin_n96_fn_6_25:
# cerune-mir: v1 fn_6 bb1 i7 -> lir 25 (source)
cerune_origin_mir_fn_6_bb1_i7_lir25:
  movq %rax, -72(%rbp)
# cerune-origin: #97 bytes 87..115
cerune_origin_n97_fn_6_26:
# cerune-mir: v1 fn_6 bb1 i8 -> lir 26 (source)
cerune_origin_mir_fn_6_bb1_i8_lir26:
  movq -72(%rbp), %rax
# cerune-origin: #97 bytes 87..115
cerune_origin_n97_fn_6_27:
# cerune-mir: v1 fn_6 bb1 i8 -> lir 27 (source)
cerune_origin_mir_fn_6_bb1_i8_lir27:
  movq %rax, %rcx
  callq cerune_write_string
# cerune-origin: #98 bytes 87..115
cerune_origin_n98_fn_6_28:
# cerune-mir: v1 fn_6 bb1 i9 -> lir 28 (source)
cerune_origin_mir_fn_6_bb1_i9_lir28:
  leaq .Lcerune_string_2(%rip), %rax
# cerune-origin: #98 bytes 87..115
cerune_origin_n98_fn_6_29:
# cerune-mir: v1 fn_6 bb1 i9 -> lir 29 (source)
cerune_origin_mir_fn_6_bb1_i9_lir29:
  movq %rax, -80(%rbp)
# cerune-origin: #99 bytes 87..115
cerune_origin_n99_fn_6_30:
# cerune-mir: v1 fn_6 bb1 i10 -> lir 30 (source)
cerune_origin_mir_fn_6_bb1_i10_lir30:
  movq -80(%rbp), %rax
# cerune-origin: #99 bytes 87..115
cerune_origin_n99_fn_6_31:
# cerune-mir: v1 fn_6 bb1 i10 -> lir 31 (source)
cerune_origin_mir_fn_6_bb1_i10_lir31:
  movq %rax, %rcx
  callq cerune_write_string
# cerune-origin: #100 bytes 87..115
cerune_origin_n100_fn_6_32:
# cerune-mir: v1 fn_6 bb1 i11 -> lir 32 (source)
cerune_origin_mir_fn_6_bb1_i11_lir32:
  movq -8(%rbp), %rax
# cerune-origin: #100 bytes 87..115
cerune_origin_n100_fn_6_33:
# cerune-mir: v1 fn_6 bb1 i11 -> lir 33 (source)
cerune_origin_mir_fn_6_bb1_i11_lir33:
  movq %rax, -88(%rbp)
# cerune-origin: #100 bytes 87..115
cerune_origin_n100_fn_6_34:
# cerune-mir: v1 fn_6 bb1 i11 -> lir 34 (source)
cerune_origin_mir_fn_6_bb1_i11_lir34:
  movq -16(%rbp), %rax
# cerune-origin: #100 bytes 87..115
cerune_origin_n100_fn_6_35:
# cerune-mir: v1 fn_6 bb1 i11 -> lir 35 (source)
cerune_origin_mir_fn_6_bb1_i11_lir35:
  movq %rax, -96(%rbp)
# cerune-origin: #101 bytes 87..115
cerune_origin_n101_fn_6_36:
# cerune-mir: v1 fn_6 bb1 i12 -> lir 36 (source)
cerune_origin_mir_fn_6_bb1_i12_lir36:
  movq -96(%rbp), %rax
# cerune-origin: #101 bytes 87..115
cerune_origin_n101_fn_6_37:
# cerune-mir: v1 fn_6 bb1 i12 -> lir 37 (source)
cerune_origin_mir_fn_6_bb1_i12_lir37:
  movq %rax, -104(%rbp)
# cerune-origin: #102 bytes 87..115
cerune_origin_n102_fn_6_38:
# cerune-mir: v1 fn_6 bb1 i13 -> lir 38 (source)
cerune_origin_mir_fn_6_bb1_i13_lir38:
  movq -104(%rbp), %rax
# cerune-origin: #102 bytes 87..115
cerune_origin_n102_fn_6_39:
# cerune-mir: v1 fn_6 bb1 i13 -> lir 39 (source)
cerune_origin_mir_fn_6_bb1_i13_lir39:
  movq %rax, %rdx
  leaq .Lwrite_i64(%rip), %rcx
  callq printf
# cerune-origin: #103 bytes 87..115
cerune_origin_n103_fn_6_40:
# cerune-mir: v1 fn_6 bb1 i14 -> lir 40 (source)
cerune_origin_mir_fn_6_bb1_i14_lir40:
  leaq .Lcerune_string_3(%rip), %rax
# cerune-origin: #103 bytes 87..115
cerune_origin_n103_fn_6_41:
# cerune-mir: v1 fn_6 bb1 i14 -> lir 41 (source)
cerune_origin_mir_fn_6_bb1_i14_lir41:
  movq %rax, -112(%rbp)
# cerune-origin: #104 bytes 87..115
cerune_origin_n104_fn_6_42:
# cerune-mir: v1 fn_6 bb1 i15 -> lir 42 (source)
cerune_origin_mir_fn_6_bb1_i15_lir42:
  movq -112(%rbp), %rax
# cerune-origin: #104 bytes 87..115
cerune_origin_n104_fn_6_43:
# cerune-mir: v1 fn_6 bb1 i15 -> lir 43 (source)
cerune_origin_mir_fn_6_bb1_i15_lir43:
  movq %rax, %rcx
  callq cerune_write_string
# cerune-origin: #105 bytes 87..115
cerune_origin_n105_fn_6_44:
# cerune-mir: v1 fn_6 bb1 i16 -> lir 44 (if-join)
cerune_origin_mir_fn_6_bb1_i16_lir44:
  jmp .Lcerune_fn_6_block_3
# cerune-origin: #105 bytes 87..115
cerune_origin_n105_fn_6_45:
# cerune-mir: v1 fn_6 bb2 block -> lir 45 (if-else)
cerune_origin_mir_fn_6_bb2_block_lir45:
.Lcerune_fn_6_block_2: # mir_block
# cerune-origin: #105 bytes 87..115
cerune_origin_n105_fn_6_46:
# cerune-mir: v1 fn_6 bb2 i17 -> lir 46 (if-join)
cerune_origin_mir_fn_6_bb2_i17_lir46:
  jmp .Lcerune_fn_6_block_3
# cerune-origin: #105 bytes 87..115
cerune_origin_n105_fn_6_47:
# cerune-mir: v1 fn_6 bb3 block -> lir 47 (if-join)
cerune_origin_mir_fn_6_bb3_block_lir47:
.Lcerune_fn_6_block_3: # mir_block
# cerune-origin: #106 bytes 87..115
cerune_origin_n106_fn_6_48:
# cerune-mir: v1 fn_6 bb3 i18 -> lir 48 (source)
cerune_origin_mir_fn_6_bb3_i18_lir48:
  movq -8(%rbp), %rax
# cerune-origin: #106 bytes 87..115
cerune_origin_n106_fn_6_49:
# cerune-mir: v1 fn_6 bb3 i18 -> lir 49 (source)
cerune_origin_mir_fn_6_bb3_i18_lir49:
  movq %rax, -120(%rbp)
# cerune-origin: #106 bytes 87..115
cerune_origin_n106_fn_6_50:
# cerune-mir: v1 fn_6 bb3 i18 -> lir 50 (source)
cerune_origin_mir_fn_6_bb3_i18_lir50:
  movq -16(%rbp), %rax
# cerune-origin: #106 bytes 87..115
cerune_origin_n106_fn_6_51:
# cerune-mir: v1 fn_6 bb3 i18 -> lir 51 (source)
cerune_origin_mir_fn_6_bb3_i18_lir51:
  movq %rax, -128(%rbp)
# cerune-origin: #107 bytes 87..115
cerune_origin_n107_fn_6_52:
# cerune-mir: v1 fn_6 bb3 i19 -> lir 52 (source)
cerune_origin_mir_fn_6_bb3_i19_lir52:
  movq -120(%rbp), %rax
# cerune-origin: #107 bytes 87..115
cerune_origin_n107_fn_6_53:
# cerune-mir: v1 fn_6 bb3 i19 -> lir 53 (source)
cerune_origin_mir_fn_6_bb3_i19_lir53:
  movq %rax, -136(%rbp)
# cerune-origin: #108 bytes 87..115
cerune_origin_n108_fn_6_54:
# cerune-mir: v1 fn_6 bb3 i20 -> lir 54 (source)
cerune_origin_mir_fn_6_bb3_i20_lir54:
  movabsq $1, %rax
# cerune-origin: #108 bytes 87..115
cerune_origin_n108_fn_6_55:
# cerune-mir: v1 fn_6 bb3 i20 -> lir 55 (source)
cerune_origin_mir_fn_6_bb3_i20_lir55:
  movq %rax, -144(%rbp)
# cerune-origin: #109 bytes 87..115
cerune_origin_n109_fn_6_56:
# cerune-mir: v1 fn_6 bb3 i21 -> lir 56 (source)
cerune_origin_mir_fn_6_bb3_i21_lir56:
  movq -144(%rbp), %rax
# cerune-origin: #109 bytes 87..115
cerune_origin_n109_fn_6_57:
# cerune-mir: v1 fn_6 bb3 i21 -> lir 57 (source)
cerune_origin_mir_fn_6_bb3_i21_lir57:
  movq %rax, %rcx
# cerune-origin: #109 bytes 87..115
cerune_origin_n109_fn_6_58:
# cerune-mir: v1 fn_6 bb3 i21 -> lir 58 (source)
cerune_origin_mir_fn_6_bb3_i21_lir58:
  movq -136(%rbp), %rax
# cerune-origin: #109 bytes 87..115
cerune_origin_n109_fn_6_59:
# cerune-mir: v1 fn_6 bb3 i21 -> lir 59 (source)
cerune_origin_mir_fn_6_bb3_i21_lir59:
  cmpq %rcx, %rax
  sete %al
  movzbq %al, %rax
# cerune-origin: #109 bytes 87..115
cerune_origin_n109_fn_6_60:
# cerune-mir: v1 fn_6 bb3 i21 -> lir 60 (source)
cerune_origin_mir_fn_6_bb3_i21_lir60:
  movq %rax, -152(%rbp)
# cerune-origin: #116 bytes 87..115
cerune_origin_n116_fn_6_61:
# cerune-mir: v1 fn_6 bb3 i22 -> lir 61 (source)
cerune_origin_mir_fn_6_bb3_i22_lir61:
  movq -152(%rbp), %rax
# cerune-origin: #116 bytes 87..115
cerune_origin_n116_fn_6_62:
# cerune-mir: v1 fn_6 bb3 i22 -> lir 62 (source)
cerune_origin_mir_fn_6_bb3_i22_lir62:
  testq %rax, %rax
  je .Lcerune_fn_6_block_5
# cerune-origin: #116 bytes 87..115
cerune_origin_n116_fn_6_63:
# cerune-mir: v1 fn_6 bb3 i22 -> lir 63 (source)
cerune_origin_mir_fn_6_bb3_i22_lir63:
  jmp .Lcerune_fn_6_block_4
# cerune-origin: #116 bytes 87..115
cerune_origin_n116_fn_6_64:
# cerune-mir: v1 fn_6 bb4 block -> lir 64 (if-then)
cerune_origin_mir_fn_6_bb4_block_lir64:
.Lcerune_fn_6_block_4: # mir_block
# cerune-origin: #110 bytes 87..115
cerune_origin_n110_fn_6_65:
# cerune-mir: v1 fn_6 bb4 i23 -> lir 65 (source)
cerune_origin_mir_fn_6_bb4_i23_lir65:
  leaq .Lcerune_string_4(%rip), %rax
# cerune-origin: #110 bytes 87..115
cerune_origin_n110_fn_6_66:
# cerune-mir: v1 fn_6 bb4 i23 -> lir 66 (source)
cerune_origin_mir_fn_6_bb4_i23_lir66:
  movq %rax, -160(%rbp)
# cerune-origin: #111 bytes 87..115
cerune_origin_n111_fn_6_67:
# cerune-mir: v1 fn_6 bb4 i24 -> lir 67 (source)
cerune_origin_mir_fn_6_bb4_i24_lir67:
  movq -160(%rbp), %rax
# cerune-origin: #111 bytes 87..115
cerune_origin_n111_fn_6_68:
# cerune-mir: v1 fn_6 bb4 i24 -> lir 68 (source)
cerune_origin_mir_fn_6_bb4_i24_lir68:
  movq %rax, %rcx
  callq cerune_write_string
# cerune-origin: #112 bytes 87..115
cerune_origin_n112_fn_6_69:
# cerune-mir: v1 fn_6 bb4 i25 -> lir 69 (source)
cerune_origin_mir_fn_6_bb4_i25_lir69:
  leaq .Lcerune_string_5(%rip), %rax
# cerune-origin: #112 bytes 87..115
cerune_origin_n112_fn_6_70:
# cerune-mir: v1 fn_6 bb4 i25 -> lir 70 (source)
cerune_origin_mir_fn_6_bb4_i25_lir70:
  movq %rax, -168(%rbp)
# cerune-origin: #113 bytes 87..115
cerune_origin_n113_fn_6_71:
# cerune-mir: v1 fn_6 bb4 i26 -> lir 71 (source)
cerune_origin_mir_fn_6_bb4_i26_lir71:
  movq -168(%rbp), %rax
# cerune-origin: #113 bytes 87..115
cerune_origin_n113_fn_6_72:
# cerune-mir: v1 fn_6 bb4 i26 -> lir 72 (source)
cerune_origin_mir_fn_6_bb4_i26_lir72:
  movq %rax, %rcx
  callq cerune_write_string
# cerune-origin: #114 bytes 87..115
cerune_origin_n114_fn_6_73:
# cerune-mir: v1 fn_6 bb4 i27 -> lir 73 (source)
cerune_origin_mir_fn_6_bb4_i27_lir73:
  leaq .Lcerune_string_6(%rip), %rax
# cerune-origin: #114 bytes 87..115
cerune_origin_n114_fn_6_74:
# cerune-mir: v1 fn_6 bb4 i27 -> lir 74 (source)
cerune_origin_mir_fn_6_bb4_i27_lir74:
  movq %rax, -176(%rbp)
# cerune-origin: #115 bytes 87..115
cerune_origin_n115_fn_6_75:
# cerune-mir: v1 fn_6 bb4 i28 -> lir 75 (source)
cerune_origin_mir_fn_6_bb4_i28_lir75:
  movq -176(%rbp), %rax
# cerune-origin: #115 bytes 87..115
cerune_origin_n115_fn_6_76:
# cerune-mir: v1 fn_6 bb4 i28 -> lir 76 (source)
cerune_origin_mir_fn_6_bb4_i28_lir76:
  movq %rax, %rcx
  callq cerune_write_string
# cerune-origin: #116 bytes 87..115
cerune_origin_n116_fn_6_77:
# cerune-mir: v1 fn_6 bb4 i29 -> lir 77 (if-join)
cerune_origin_mir_fn_6_bb4_i29_lir77:
  jmp .Lcerune_fn_6_block_6
# cerune-origin: #116 bytes 87..115
cerune_origin_n116_fn_6_78:
# cerune-mir: v1 fn_6 bb5 block -> lir 78 (if-else)
cerune_origin_mir_fn_6_bb5_block_lir78:
.Lcerune_fn_6_block_5: # mir_block
# cerune-origin: #116 bytes 87..115
cerune_origin_n116_fn_6_79:
# cerune-mir: v1 fn_6 bb5 i30 -> lir 79 (if-join)
cerune_origin_mir_fn_6_bb5_i30_lir79:
  jmp .Lcerune_fn_6_block_6
# cerune-origin: #116 bytes 87..115
cerune_origin_n116_fn_6_80:
# cerune-mir: v1 fn_6 bb6 block -> lir 80 (if-join)
cerune_origin_mir_fn_6_bb6_block_lir80:
.Lcerune_fn_6_block_6: # mir_block
# cerune-origin: #117 bytes 87..115
cerune_origin_n117_fn_6_81:
# cerune-mir: v1 fn_6 bb6 i31 -> lir 81 (source)
cerune_origin_mir_fn_6_bb6_i31_lir81:
  leaq .Lcerune_string_7(%rip), %rax
# cerune-origin: #117 bytes 87..115
cerune_origin_n117_fn_6_82:
# cerune-mir: v1 fn_6 bb6 i31 -> lir 82 (source)
cerune_origin_mir_fn_6_bb6_i31_lir82:
  movq %rax, -184(%rbp)
# cerune-origin: #118 bytes 87..115
cerune_origin_n118_fn_6_83:
# cerune-mir: v1 fn_6 bb6 i32 -> lir 83 (source)
cerune_origin_mir_fn_6_bb6_i32_lir83:
  movq -184(%rbp), %rax
# cerune-origin: #118 bytes 87..115
cerune_origin_n118_fn_6_84:
# cerune-mir: v1 fn_6 bb6 i32 -> lir 84 (source)
cerune_origin_mir_fn_6_bb6_i32_lir84:
  movq %rax, %rcx
  callq cerune_print_string
# cerune-origin: #119 bytes 87..115
cerune_origin_n119_fn_6_85:
# cerune-mir: v1 fn_6 bb6 i33 -> lir 85 (source)
cerune_origin_mir_fn_6_bb6_i33_lir85:
  addq $224, %rsp
  popq %rbp
  retq
# cerune-origin: #119 bytes 87..115
cerune_origin_n119_fn_6_86:
# cerune-mir: v1 fn_6 bb7 block -> lir 86 (after-return)
cerune_origin_mir_fn_6_bb7_block_lir86:
.Lcerune_fn_6_block_7: # mir_block
# cerune-origin: synthetic
# cerune-mir: v1 fn_6 bb7 i34 -> lir 87 (function-end)
cerune_origin_mir_fn_6_bb7_i34_lir87:
  addq $224, %rsp
  popq %rbp
  retq

# cerune-origin: synthetic
.globl main
.p2align 4
main:
  pushq %rbp
  movq %rsp, %rbp
  subq $192, %rsp
  movl $1, %ecx
  movl $32768, %edx
  callq _setmode
  cmpl $-1, %eax
  jne .Lstdout_ready
  movl $1, %eax
  addq $192, %rsp
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
# cerune-origin: #2 bytes 57..58
cerune_origin_n2_main_2:
# cerune-mir: v1 main bb0 i0 -> lir 2 (source)
cerune_origin_mir_main_bb0_i0_lir2:
  movabsq $1, %rax
# cerune-origin: #2 bytes 57..58
cerune_origin_n2_main_3:
# cerune-mir: v1 main bb0 i0 -> lir 3 (source)
cerune_origin_mir_main_bb0_i0_lir3:
  movq %rax, -8(%rbp)
# cerune-origin: #3 bytes 60..61
cerune_origin_n3_main_4:
# cerune-mir: v1 main bb0 i1 -> lir 4 (source)
cerune_origin_mir_main_bb0_i1_lir4:
  movabsq $2, %rax
# cerune-origin: #3 bytes 60..61
cerune_origin_n3_main_5:
# cerune-mir: v1 main bb0 i1 -> lir 5 (source)
cerune_origin_mir_main_bb0_i1_lir5:
  movq %rax, -16(%rbp)
# cerune-origin: #1 bytes 56..62
cerune_origin_n1_main_6:
# cerune-mir: v1 main bb0 i2 -> lir 6 (source)
cerune_origin_mir_main_bb0_i2_lir6:
  movq -8(%rbp), %rax
# cerune-origin: #1 bytes 56..62
cerune_origin_n1_main_7:
# cerune-mir: v1 main bb0 i2 -> lir 7 (source)
cerune_origin_mir_main_bb0_i2_lir7:
  movq %rax, -24(%rbp)
# cerune-origin: #1 bytes 56..62
cerune_origin_n1_main_8:
# cerune-mir: v1 main bb0 i2 -> lir 8 (source)
cerune_origin_mir_main_bb0_i2_lir8:
  movq -16(%rbp), %rax
# cerune-origin: #1 bytes 56..62
cerune_origin_n1_main_9:
# cerune-mir: v1 main bb0 i2 -> lir 9 (source)
cerune_origin_mir_main_bb0_i2_lir9:
  movq %rax, -32(%rbp)
# cerune-origin: #0 bytes 39..63
cerune_origin_n0_main_10:
# cerune-mir: v1 main bb0 i3 -> lir 10 (source)
cerune_origin_mir_main_bb0_i3_lir10:
  movq -24(%rbp), %rax
# cerune-origin: #0 bytes 39..63
cerune_origin_n0_main_11:
# cerune-mir: v1 main bb0 i3 -> lir 11 (source)
cerune_origin_mir_main_bb0_i3_lir11:
  movq %rax, -40(%rbp)
# cerune-origin: #0 bytes 39..63
cerune_origin_n0_main_12:
# cerune-mir: v1 main bb0 i3 -> lir 12 (source)
cerune_origin_mir_main_bb0_i3_lir12:
  movq -32(%rbp), %rax
# cerune-origin: #0 bytes 39..63
cerune_origin_n0_main_13:
# cerune-mir: v1 main bb0 i3 -> lir 13 (source)
cerune_origin_mir_main_bb0_i3_lir13:
  movq %rax, -48(%rbp)
# cerune-origin: #6 bytes 70..74
cerune_origin_n6_main_14:
# cerune-mir: v1 main bb0 i4 -> lir 14 (source)
cerune_origin_mir_main_bb0_i4_lir14:
  movq -40(%rbp), %rax
# cerune-origin: #6 bytes 70..74
cerune_origin_n6_main_15:
# cerune-mir: v1 main bb0 i4 -> lir 15 (source)
cerune_origin_mir_main_bb0_i4_lir15:
  movq %rax, -56(%rbp)
# cerune-origin: #6 bytes 70..74
cerune_origin_n6_main_16:
# cerune-mir: v1 main bb0 i4 -> lir 16 (source)
cerune_origin_mir_main_bb0_i4_lir16:
  movq -48(%rbp), %rax
# cerune-origin: #6 bytes 70..74
cerune_origin_n6_main_17:
# cerune-mir: v1 main bb0 i4 -> lir 17 (source)
cerune_origin_mir_main_bb0_i4_lir17:
  movq %rax, -64(%rbp)
# cerune-origin: #8 bytes 79..80
cerune_origin_n8_main_18:
# cerune-mir: v1 main bb0 i5 -> lir 18 (source)
cerune_origin_mir_main_bb0_i5_lir18:
  movabsq $1, %rax
# cerune-origin: #8 bytes 79..80
cerune_origin_n8_main_19:
# cerune-mir: v1 main bb0 i5 -> lir 19 (source)
cerune_origin_mir_main_bb0_i5_lir19:
  movq %rax, -72(%rbp)
# cerune-origin: #9 bytes 82..83
cerune_origin_n9_main_20:
# cerune-mir: v1 main bb0 i6 -> lir 20 (source)
cerune_origin_mir_main_bb0_i6_lir20:
  movabsq $3, %rax
# cerune-origin: #9 bytes 82..83
cerune_origin_n9_main_21:
# cerune-mir: v1 main bb0 i6 -> lir 21 (source)
cerune_origin_mir_main_bb0_i6_lir21:
  movq %rax, -80(%rbp)
# cerune-origin: #7 bytes 78..84
cerune_origin_n7_main_22:
# cerune-mir: v1 main bb0 i7 -> lir 22 (source)
cerune_origin_mir_main_bb0_i7_lir22:
  movq -72(%rbp), %rax
# cerune-origin: #7 bytes 78..84
cerune_origin_n7_main_23:
# cerune-mir: v1 main bb0 i7 -> lir 23 (source)
cerune_origin_mir_main_bb0_i7_lir23:
  movq %rax, -88(%rbp)
# cerune-origin: #7 bytes 78..84
cerune_origin_n7_main_24:
# cerune-mir: v1 main bb0 i7 -> lir 24 (source)
cerune_origin_mir_main_bb0_i7_lir24:
  movq -80(%rbp), %rax
# cerune-origin: #7 bytes 78..84
cerune_origin_n7_main_25:
# cerune-mir: v1 main bb0 i7 -> lir 25 (source)
cerune_origin_mir_main_bb0_i7_lir25:
  movq %rax, -96(%rbp)
# cerune-origin: #5 bytes 70..84
cerune_origin_n5_main_26:
# cerune-mir: v1 main bb0 i8 -> lir 26 (source)
cerune_origin_mir_main_bb0_i8_lir26:
  leaq -56(%rbp), %rcx
  leaq -88(%rbp), %rdx
  callq cerune_fn__equal0_0
# cerune-origin: #5 bytes 70..84
cerune_origin_n5_main_27:
# cerune-mir: v1 main bb0 i8 -> lir 27 (source)
cerune_origin_mir_main_bb0_i8_lir27:
  movq %rax, -104(%rbp)
# cerune-origin: #4 bytes 64..86
cerune_origin_n4_main_28:
# cerune-mir: v1 main bb0 i9 -> lir 28 (source)
cerune_origin_mir_main_bb0_i9_lir28:
  movq -104(%rbp), %rax
# cerune-origin: #4 bytes 64..86
cerune_origin_n4_main_29:
# cerune-mir: v1 main bb0 i9 -> lir 29 (source)
cerune_origin_mir_main_bb0_i9_lir29:
  testq %rax, %rax
  leaq .Lcerune_bool_false(%rip), %rcx
  leaq .Lcerune_bool_true(%rip), %rdx
  cmovne %rdx, %rcx
  callq puts
# cerune-origin: #12 bytes 93..104
cerune_origin_n12_main_30:
# cerune-mir: v1 main bb0 i10 -> lir 30 (source)
cerune_origin_mir_main_bb0_i10_lir30:
  movabsq $0, %rax
# cerune-origin: #12 bytes 93..104
cerune_origin_n12_main_31:
# cerune-mir: v1 main bb0 i10 -> lir 31 (source)
cerune_origin_mir_main_bb0_i10_lir31:
  movq %rax, -112(%rbp)
# cerune-origin: #13 bytes 110..111
cerune_origin_n13_main_32:
# cerune-mir: v1 main bb0 i11 -> lir 32 (source)
cerune_origin_mir_main_bb0_i11_lir32:
  movabsq $7, %rax
# cerune-origin: #13 bytes 110..111
cerune_origin_n13_main_33:
# cerune-mir: v1 main bb0 i11 -> lir 33 (source)
cerune_origin_mir_main_bb0_i11_lir33:
  movq %rax, -120(%rbp)
# cerune-origin: #11 bytes 93..113
cerune_origin_n11_main_34:
# cerune-mir: v1 main bb0 i12 -> lir 34 (source)
cerune_origin_mir_main_bb0_i12_lir34:
  movq -112(%rbp), %rax
# cerune-origin: #11 bytes 93..113
cerune_origin_n11_main_35:
# cerune-mir: v1 main bb0 i12 -> lir 35 (source)
cerune_origin_mir_main_bb0_i12_lir35:
  movq %rax, -128(%rbp)
# cerune-origin: #11 bytes 93..113
cerune_origin_n11_main_36:
# cerune-mir: v1 main bb0 i12 -> lir 36 (source)
cerune_origin_mir_main_bb0_i12_lir36:
  movq -120(%rbp), %rax
# cerune-origin: #11 bytes 93..113
cerune_origin_n11_main_37:
# cerune-mir: v1 main bb0 i12 -> lir 37 (source)
cerune_origin_mir_main_bb0_i12_lir37:
  movq %rax, -136(%rbp)
# cerune-origin: #10 bytes 87..115
cerune_origin_n10_main_38:
# cerune-mir: v1 main bb0 i13 -> lir 38 (source)
cerune_origin_mir_main_bb0_i13_lir38:
  leaq -128(%rbp), %rcx
  callq cerune_fn__display6_6
# cerune-origin: #15 bytes 130..259
cerune_origin_n15_main_39:
# cerune-mir: v1 main bb0 i14 -> lir 39 (source)
cerune_origin_mir_main_bb0_i14_lir39:
  callq cerune_fn__match_bind5_5
# cerune-origin: #15 bytes 130..259
cerune_origin_n15_main_40:
# cerune-mir: v1 main bb0 i14 -> lir 40 (source)
cerune_origin_mir_main_bb0_i14_lir40:
  movq %rax, -144(%rbp)
# cerune-origin: #14 bytes 116..260
cerune_origin_n14_main_41:
# cerune-mir: v1 main bb0 i15 -> lir 41 (source)
cerune_origin_mir_main_bb0_i15_lir41:
  movq -144(%rbp), %rax
# cerune-origin: #14 bytes 116..260
cerune_origin_n14_main_42:
# cerune-mir: v1 main bb0 i15 -> lir 42 (source)
cerune_origin_mir_main_bb0_i15_lir42:
  movq %rax, -152(%rbp)
# cerune-origin: #44 bytes 267..273
cerune_origin_n44_main_43:
# cerune-mir: v1 main bb0 i16 -> lir 43 (source)
cerune_origin_mir_main_bb0_i16_lir43:
  movq -152(%rbp), %rax
# cerune-origin: #44 bytes 267..273
cerune_origin_n44_main_44:
# cerune-mir: v1 main bb0 i16 -> lir 44 (source)
cerune_origin_mir_main_bb0_i16_lir44:
  movq %rax, -160(%rbp)
# cerune-origin: #43 bytes 261..275
cerune_origin_n43_main_45:
# cerune-mir: v1 main bb0 i17 -> lir 45 (source)
cerune_origin_mir_main_bb0_i17_lir45:
  movq -160(%rbp), %rax
# cerune-origin: #43 bytes 261..275
cerune_origin_n43_main_46:
# cerune-mir: v1 main bb0 i17 -> lir 46 (source)
cerune_origin_mir_main_bb0_i17_lir46:
  movq %rax, %rdx
# cerune-origin: #43 bytes 261..275
cerune_origin_n43_main_47:
# cerune-mir: v1 main bb0 i17 -> lir 47 (source)
cerune_origin_mir_main_bb0_i17_lir47:
  leaq .Lcerune_fmt_i64(%rip), %rcx
# cerune-origin: #43 bytes 261..275
cerune_origin_n43_main_48:
# cerune-mir: v1 main bb0 i17 -> lir 48 (source)
cerune_origin_mir_main_bb0_i17_lir48:
  callq printf
# cerune-origin: synthetic
# cerune-mir: v1 main bb0 i18 -> lir 49 (function-end)
cerune_origin_mir_main_bb0_i18_lir49:
  jmp .Lcerune_block_1
# cerune-origin: synthetic
# cerune-mir: v1 synthetic ABI setup/exit
.Lcerune_block_1: # main_exit
# cerune-origin: synthetic
  xorl %eax, %eax
  addq $192, %rsp
  popq %rbp
  retq

.section .rdata,"dr"
.Lcerune_failure_0:
  .asciz "cerune: runtime-v1 code=array-index-out-of-bounds node=52 bytes=70..84\n"
.Lcerune_failure_1:
  .asciz "cerune: runtime-v1 code=array-index-out-of-bounds node=55 bytes=70..84\n"
.Lcerune_failure_2:
  .asciz "cerune: runtime-v1 code=integer-overflow node=63 bytes=70..84\n"
.Lcerune_failure_3:
  .asciz "cerune: runtime-v1 code=integer-overflow node=41 bytes=254..256\n"
