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
  subq $208, %rsp
# cerune-origin: synthetic
  movq 0(%rcx), %r10
  movq %r10, -8(%rbp)
  movq -8(%rcx), %r10
  movq %r10, -16(%rbp)
# cerune-origin: synthetic
  movq 0(%rdx), %r10
  movq %r10, -24(%rbp)
  movq -8(%rdx), %r10
  movq %r10, -32(%rbp)
# cerune-origin: #45 bytes 70..84
cerune_origin_n45_fn_0_2:
  movabsq $0, %rax
# cerune-origin: #46 bytes 70..84
cerune_origin_n46_fn_0_3:
  movq %rax, -40(%rbp)
# cerune-origin: #65 bytes 70..84
cerune_origin_n65_fn_0_4:
.Lcerune_fn_0_block_0: # for_condition
# cerune-origin: #47 bytes 70..84
cerune_origin_n47_fn_0_5:
  movq -40(%rbp), %rax
# cerune-origin: #49 bytes 70..84
cerune_origin_n49_fn_0_6:
  movq %rax, -48(%rbp)
# cerune-origin: #48 bytes 70..84
cerune_origin_n48_fn_0_7:
  movabsq $2, %rax
# cerune-origin: #49 bytes 70..84
cerune_origin_n49_fn_0_8:
  movq %rax, %rcx
# cerune-origin: #49 bytes 70..84
cerune_origin_n49_fn_0_9:
  movq -48(%rbp), %rax
# cerune-origin: #49 bytes 70..84
cerune_origin_n49_fn_0_10:
  cmpq %rcx, %rax
  setl %al
  movzbq %al, %rax
# cerune-origin: #65 bytes 70..84
cerune_origin_n65_fn_0_11:
  testq %rax, %rax
  je .Lcerune_fn_0_block_2
# cerune-origin: #51 bytes 70..84
cerune_origin_n51_fn_0_12:
  movq -40(%rbp), %rax
# cerune-origin: #52 bytes 70..84
cerune_origin_n52_fn_0_13:
  testq %rax, %rax
  js .Lcerune_fn_0_array_oob_3
  cmpq $2, %rax
  jge .Lcerune_fn_0_array_oob_3
  negq %rax
  movq -8(%rbp,%rax,8), %rax
  jmp .Lcerune_fn_0_array_done_3
.Lcerune_fn_0_array_oob_3:
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_0(%rip), %rdx
  movl $71, %r8d
  callq _write
  ud2
.Lcerune_fn_0_array_done_3:
# cerune-origin: #56 bytes 70..84
cerune_origin_n56_fn_0_14:
  movq %rax, -48(%rbp)
# cerune-origin: #54 bytes 70..84
cerune_origin_n54_fn_0_15:
  movq -40(%rbp), %rax
# cerune-origin: #55 bytes 70..84
cerune_origin_n55_fn_0_16:
  testq %rax, %rax
  js .Lcerune_fn_0_array_oob_4
  cmpq $2, %rax
  jge .Lcerune_fn_0_array_oob_4
  negq %rax
  movq -24(%rbp,%rax,8), %rax
  jmp .Lcerune_fn_0_array_done_4
.Lcerune_fn_0_array_oob_4:
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_1(%rip), %rdx
  movl $71, %r8d
  callq _write
  ud2
.Lcerune_fn_0_array_done_4:
# cerune-origin: #56 bytes 70..84
cerune_origin_n56_fn_0_17:
  movq %rax, %rcx
# cerune-origin: #56 bytes 70..84
cerune_origin_n56_fn_0_18:
  movq -48(%rbp), %rax
# cerune-origin: #56 bytes 70..84
cerune_origin_n56_fn_0_19:
  cmpq %rcx, %rax
  sete %al
  movzbq %al, %rax
# cerune-origin: #57 bytes 70..84
cerune_origin_n57_fn_0_20:
  xorq $1, %rax
# cerune-origin: #60 bytes 70..84
cerune_origin_n60_fn_0_21:
  testq %rax, %rax
  je .Lcerune_fn_0_block_6
# cerune-origin: #58 bytes 70..84
cerune_origin_n58_fn_0_22:
  movabsq $0, %rax
# cerune-origin: #59 bytes 70..84
cerune_origin_n59_fn_0_23:
  addq $208, %rsp
  popq %rbp
  retq
# cerune-origin: #60 bytes 70..84
cerune_origin_n60_fn_0_24:
.Lcerune_fn_0_block_6: # if_end
# cerune-origin: #65 bytes 70..84
cerune_origin_n65_fn_0_25:
  jmp .Lcerune_fn_0_block_1
# cerune-origin: #65 bytes 70..84
cerune_origin_n65_fn_0_26:
.Lcerune_fn_0_block_1: # for_update
# cerune-origin: #61 bytes 70..84
cerune_origin_n61_fn_0_27:
  movq -40(%rbp), %rax
# cerune-origin: #63 bytes 70..84
cerune_origin_n63_fn_0_28:
  movq %rax, -48(%rbp)
# cerune-origin: #62 bytes 70..84
cerune_origin_n62_fn_0_29:
  movabsq $1, %rax
# cerune-origin: #63 bytes 70..84
cerune_origin_n63_fn_0_30:
  movq %rax, %rcx
# cerune-origin: #63 bytes 70..84
cerune_origin_n63_fn_0_31:
  movq -48(%rbp), %rax
# cerune-origin: #63 bytes 70..84
cerune_origin_n63_fn_0_32:
  addq %rcx, %rax
# cerune-origin: #63 bytes 70..84
cerune_origin_n63_fn_0_33:
  jno .Lcerune_fn_0_integer_ok_7
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_2(%rip), %rdx
  movl $62, %r8d
  callq _write
  ud2
.Lcerune_fn_0_integer_ok_7:
# cerune-origin: #64 bytes 70..84
cerune_origin_n64_fn_0_34:
  movq %rax, -40(%rbp)
# cerune-origin: #65 bytes 70..84
cerune_origin_n65_fn_0_35:
  jmp .Lcerune_fn_0_block_0
# cerune-origin: #65 bytes 70..84
cerune_origin_n65_fn_0_36:
.Lcerune_fn_0_block_2: # for_end
# cerune-origin: #66 bytes 70..84
cerune_origin_n66_fn_0_37:
  movabsq $1, %rax
# cerune-origin: #67 bytes 70..84
cerune_origin_n67_fn_0_38:
  addq $208, %rsp
  popq %rbp
  retq

# cerune-origin: synthetic
.p2align 4
cerune_fn__match_bind1_1:
  pushq %rbp
  movq %rsp, %rbp
  subq $96, %rsp
# cerune-origin: synthetic
  movq 0(%rcx), %r10
  movq %r10, -8(%rbp)
  movq -8(%rcx), %r10
  movq %r10, -16(%rbp)
# cerune-origin: #26 bytes 182..183
cerune_origin_n26_fn_1_1:
  movq -16(%rbp), %rax
# cerune-origin: #69 bytes 189..194
cerune_origin_n69_fn_1_2:
  movq %rax, -24(%rbp)
# cerune-origin: #29 bytes 189..190
cerune_origin_n29_fn_1_3:
  movq -24(%rbp), %rax
# cerune-origin: #28 bytes 189..194
cerune_origin_n28_fn_1_4:
  movq %rax, -32(%rbp)
# cerune-origin: #30 bytes 193..194
cerune_origin_n30_fn_1_5:
  movabsq $0, %rax
# cerune-origin: #28 bytes 189..194
cerune_origin_n28_fn_1_6:
  movq %rax, %rcx
# cerune-origin: #28 bytes 189..194
cerune_origin_n28_fn_1_7:
  movq -32(%rbp), %rax
# cerune-origin: #28 bytes 189..194
cerune_origin_n28_fn_1_8:
  cmpq %rcx, %rax
  setg %al
  movzbq %al, %rax
# cerune-origin: #70 bytes 189..194
cerune_origin_n70_fn_1_9:
  addq $96, %rsp
  popq %rbp
  retq

# cerune-origin: synthetic
.p2align 4
cerune_fn__match_bind2_2:
  pushq %rbp
  movq %rsp, %rbp
  subq $80, %rsp
# cerune-origin: synthetic
  movq 0(%rcx), %r10
  movq %r10, -8(%rbp)
  movq -8(%rcx), %r10
  movq %r10, -16(%rbp)
# cerune-origin: #32 bytes 182..183
cerune_origin_n32_fn_2_1:
  movq -16(%rbp), %rax
# cerune-origin: #73 bytes 198..199
cerune_origin_n73_fn_2_2:
  movq %rax, -24(%rbp)
# cerune-origin: #34 bytes 198..199
cerune_origin_n34_fn_2_3:
  movq -24(%rbp), %rax
# cerune-origin: #74 bytes 198..199
cerune_origin_n74_fn_2_4:
  addq $80, %rsp
  popq %rbp
  retq

# cerune-origin: synthetic
.p2align 4
cerune_fn__match_select3_3:
  pushq %rbp
  movq %rsp, %rbp
  subq $112, %rsp
# cerune-origin: synthetic
  movq 0(%rcx), %r10
  movq %r10, -8(%rbp)
  movq -8(%rcx), %r10
  movq %r10, -16(%rbp)
# cerune-origin: #37 bytes 205..216
cerune_origin_n37_fn_3_1:
  movq -8(%rbp), %rax
# cerune-origin: #36 bytes 205..216
cerune_origin_n36_fn_3_2:
  movq %rax, -24(%rbp)
# cerune-origin: #39 bytes 205..216
cerune_origin_n39_fn_3_3:
  movabsq $0, %rax
# cerune-origin: #36 bytes 205..216
cerune_origin_n36_fn_3_4:
  movq %rax, %rcx
# cerune-origin: #36 bytes 205..216
cerune_origin_n36_fn_3_5:
  movq -24(%rbp), %rax
# cerune-origin: #36 bytes 205..216
cerune_origin_n36_fn_3_6:
  cmpq %rcx, %rax
  sete %al
  movzbq %al, %rax
# cerune-origin: #79 bytes 205..216
cerune_origin_n79_fn_3_7:
  testq %rax, %rax
  je .Lcerune_fn_3_block_0
# cerune-origin: #40 bytes 229..230
cerune_origin_n40_fn_3_8:
  movabsq $0, %rax
# cerune-origin: #77 bytes 205..216
cerune_origin_n77_fn_3_9:
  addq $112, %rsp
  popq %rbp
  retq
# cerune-origin: #79 bytes 205..216
cerune_origin_n79_fn_3_10:
.Lcerune_fn_3_block_0: # if_else
# cerune-origin: #42 bytes 255..256
cerune_origin_n42_fn_3_11:
  movabsq $1, %rax
# cerune-origin: #41 bytes 254..256
cerune_origin_n41_fn_3_12:
  negq %rax
# cerune-origin: #41 bytes 254..256
cerune_origin_n41_fn_3_13:
  jno .Lcerune_fn_3_integer_ok_2
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_3(%rip), %rdx
  movl $64, %r8d
  callq _write
  ud2
.Lcerune_fn_3_integer_ok_2:
# cerune-origin: #78 bytes 205..216
cerune_origin_n78_fn_3_14:
  addq $112, %rsp
  popq %rbp
  retq

# cerune-origin: synthetic
.p2align 4
cerune_fn__match_select4_4:
  pushq %rbp
  movq %rsp, %rbp
  subq $144, %rsp
# cerune-origin: synthetic
  movq 0(%rcx), %r10
  movq %r10, -8(%rbp)
  movq -8(%rcx), %r10
  movq %r10, -16(%rbp)
# cerune-origin: #22 bytes 165..176
cerune_origin_n22_fn_4_1:
  movq -8(%rbp), %rax
# cerune-origin: #21 bytes 165..176
cerune_origin_n21_fn_4_2:
  movq %rax, -24(%rbp)
# cerune-origin: #24 bytes 165..176
cerune_origin_n24_fn_4_3:
  movabsq $0, %rax
# cerune-origin: #21 bytes 165..176
cerune_origin_n21_fn_4_4:
  movq %rax, %rcx
# cerune-origin: #21 bytes 165..176
cerune_origin_n21_fn_4_5:
  movq -24(%rbp), %rax
# cerune-origin: #21 bytes 165..176
cerune_origin_n21_fn_4_6:
  cmpq %rcx, %rax
  sete %al
  movzbq %al, %rax
# cerune-origin: #20 bytes 165..176
cerune_origin_n20_fn_4_7:
  testq %rax, %rax
  je .Lcerune_fn_4_block_0
# cerune-origin: #25 bytes 189..194
cerune_origin_n25_fn_4_8:
  leaq -8(%rbp), %rcx
  callq cerune_fn__match_bind1_1
# cerune-origin: #20 bytes 165..176
cerune_origin_n20_fn_4_9:
  jmp .Lcerune_fn_4_block_1
# cerune-origin: #20 bytes 165..176
cerune_origin_n20_fn_4_10:
.Lcerune_fn_4_block_0: # logical_false
# cerune-origin: #20 bytes 165..176
cerune_origin_n20_fn_4_11:
.Lcerune_fn_4_block_1: # logical_end
# cerune-origin: #84 bytes 165..176
cerune_origin_n84_fn_4_12:
  testq %rax, %rax
  je .Lcerune_fn_4_block_2
# cerune-origin: #31 bytes 198..199
cerune_origin_n31_fn_4_13:
  leaq -8(%rbp), %rcx
  callq cerune_fn__match_bind2_2
# cerune-origin: #82 bytes 165..176
cerune_origin_n82_fn_4_14:
  addq $144, %rsp
  popq %rbp
  retq
# cerune-origin: #84 bytes 165..176
cerune_origin_n84_fn_4_15:
.Lcerune_fn_4_block_2: # if_else
# cerune-origin: #35 bytes 205..216
cerune_origin_n35_fn_4_16:
  leaq -8(%rbp), %rcx
  callq cerune_fn__match_select3_3
# cerune-origin: #83 bytes 165..176
cerune_origin_n83_fn_4_17:
  addq $144, %rsp
  popq %rbp
  retq

# cerune-origin: synthetic
.p2align 4
cerune_fn__match_bind5_5:
  pushq %rbp
  movq %rsp, %rbp
  subq $112, %rsp
# cerune-origin: #17 bytes 137..148
cerune_origin_n17_fn_5_0:
  movabsq $0, %rax
# cerune-origin: #16 bytes 136..158
cerune_origin_n16_fn_5_1:
  movq %rax, -64(%rbp)
# cerune-origin: #18 bytes 154..155
cerune_origin_n18_fn_5_2:
  movabsq $7, %rax
# cerune-origin: #16 bytes 136..158
cerune_origin_n16_fn_5_3:
  movq %rax, -72(%rbp)
# cerune-origin: #87 bytes 130..259
cerune_origin_n87_fn_5_4:
  movq -64(%rbp), %rax
# cerune-origin: #87 bytes 130..259
cerune_origin_n87_fn_5_5:
  movq %rax, -8(%rbp)
# cerune-origin: #87 bytes 130..259
cerune_origin_n87_fn_5_6:
  movq -72(%rbp), %rax
# cerune-origin: #87 bytes 130..259
cerune_origin_n87_fn_5_7:
  movq %rax, -16(%rbp)
# cerune-origin: #19 bytes 165..176
cerune_origin_n19_fn_5_8:
  leaq -8(%rbp), %rcx
  callq cerune_fn__match_select4_4
# cerune-origin: #88 bytes 130..259
cerune_origin_n88_fn_5_9:
  addq $112, %rsp
  popq %rbp
  retq

# cerune-origin: synthetic
.p2align 4
cerune_fn__display6_6:
  pushq %rbp
  movq %rsp, %rbp
  subq $192, %rsp
# cerune-origin: synthetic
  movq 0(%rcx), %r10
  movq %r10, -8(%rbp)
  movq -8(%rcx), %r10
  movq %r10, -16(%rbp)
# cerune-origin: #91 bytes 87..115
cerune_origin_n91_fn_6_1:
  movq -8(%rbp), %rax
# cerune-origin: #93 bytes 87..115
cerune_origin_n93_fn_6_2:
  movq %rax, -24(%rbp)
# cerune-origin: #92 bytes 87..115
cerune_origin_n92_fn_6_3:
  movabsq $0, %rax
# cerune-origin: #93 bytes 87..115
cerune_origin_n93_fn_6_4:
  movq %rax, %rcx
# cerune-origin: #93 bytes 87..115
cerune_origin_n93_fn_6_5:
  movq -24(%rbp), %rax
# cerune-origin: #93 bytes 87..115
cerune_origin_n93_fn_6_6:
  cmpq %rcx, %rax
  sete %al
  movzbq %al, %rax
# cerune-origin: #105 bytes 87..115
cerune_origin_n105_fn_6_7:
  testq %rax, %rax
  je .Lcerune_fn_6_block_1
# cerune-origin: #94 bytes 87..115
cerune_origin_n94_fn_6_8:
  leaq .Lcerune_string_0(%rip), %rax
# cerune-origin: #95 bytes 87..115
cerune_origin_n95_fn_6_9:
  movq %rax, %rcx
  callq cerune_write_string
# cerune-origin: #96 bytes 87..115
cerune_origin_n96_fn_6_10:
  leaq .Lcerune_string_1(%rip), %rax
# cerune-origin: #97 bytes 87..115
cerune_origin_n97_fn_6_11:
  movq %rax, %rcx
  callq cerune_write_string
# cerune-origin: #98 bytes 87..115
cerune_origin_n98_fn_6_12:
  leaq .Lcerune_string_2(%rip), %rax
# cerune-origin: #99 bytes 87..115
cerune_origin_n99_fn_6_13:
  movq %rax, %rcx
  callq cerune_write_string
# cerune-origin: #101 bytes 87..115
cerune_origin_n101_fn_6_14:
  movq -16(%rbp), %rax
# cerune-origin: #102 bytes 87..115
cerune_origin_n102_fn_6_15:
  movq %rax, %rdx
  leaq .Lwrite_i64(%rip), %rcx
  callq printf
# cerune-origin: #103 bytes 87..115
cerune_origin_n103_fn_6_16:
  leaq .Lcerune_string_3(%rip), %rax
# cerune-origin: #104 bytes 87..115
cerune_origin_n104_fn_6_17:
  movq %rax, %rcx
  callq cerune_write_string
# cerune-origin: #105 bytes 87..115
cerune_origin_n105_fn_6_18:
  jmp .Lcerune_fn_6_block_1
# cerune-origin: #105 bytes 87..115
cerune_origin_n105_fn_6_19:
.Lcerune_fn_6_block_1: # if_end
# cerune-origin: #107 bytes 87..115
cerune_origin_n107_fn_6_20:
  movq -8(%rbp), %rax
# cerune-origin: #109 bytes 87..115
cerune_origin_n109_fn_6_21:
  movq %rax, -24(%rbp)
# cerune-origin: #108 bytes 87..115
cerune_origin_n108_fn_6_22:
  movabsq $1, %rax
# cerune-origin: #109 bytes 87..115
cerune_origin_n109_fn_6_23:
  movq %rax, %rcx
# cerune-origin: #109 bytes 87..115
cerune_origin_n109_fn_6_24:
  movq -24(%rbp), %rax
# cerune-origin: #109 bytes 87..115
cerune_origin_n109_fn_6_25:
  cmpq %rcx, %rax
  sete %al
  movzbq %al, %rax
# cerune-origin: #116 bytes 87..115
cerune_origin_n116_fn_6_26:
  testq %rax, %rax
  je .Lcerune_fn_6_block_3
# cerune-origin: #110 bytes 87..115
cerune_origin_n110_fn_6_27:
  leaq .Lcerune_string_4(%rip), %rax
# cerune-origin: #111 bytes 87..115
cerune_origin_n111_fn_6_28:
  movq %rax, %rcx
  callq cerune_write_string
# cerune-origin: #112 bytes 87..115
cerune_origin_n112_fn_6_29:
  leaq .Lcerune_string_5(%rip), %rax
# cerune-origin: #113 bytes 87..115
cerune_origin_n113_fn_6_30:
  movq %rax, %rcx
  callq cerune_write_string
# cerune-origin: #114 bytes 87..115
cerune_origin_n114_fn_6_31:
  leaq .Lcerune_string_6(%rip), %rax
# cerune-origin: #115 bytes 87..115
cerune_origin_n115_fn_6_32:
  movq %rax, %rcx
  callq cerune_write_string
# cerune-origin: #116 bytes 87..115
cerune_origin_n116_fn_6_33:
  jmp .Lcerune_fn_6_block_3
# cerune-origin: #116 bytes 87..115
cerune_origin_n116_fn_6_34:
.Lcerune_fn_6_block_3: # if_end
# cerune-origin: #117 bytes 87..115
cerune_origin_n117_fn_6_35:
  leaq .Lcerune_string_7(%rip), %rax
# cerune-origin: #118 bytes 87..115
cerune_origin_n118_fn_6_36:
  movq %rax, %rcx
  callq cerune_print_string
# cerune-origin: #119 bytes 87..115
cerune_origin_n119_fn_6_37:
  addq $192, %rsp
  popq %rbp
  retq

# cerune-origin: synthetic
.globl main
.p2align 4
main:
  pushq %rbp
  movq %rsp, %rbp
  subq $208, %rsp
  movl $1, %ecx
  movl $32768, %edx
  callq _setmode
  cmpl $-1, %eax
  jne .Lstdout_ready
  movl $1, %eax
  addq $208, %rsp
  popq %rbp
  retq
.Lstdout_ready:
# cerune-origin: #2 bytes 57..58
cerune_origin_n2_main_0:
  movabsq $1, %rax
# cerune-origin: #1 bytes 56..62
cerune_origin_n1_main_1:
  movq %rax, -136(%rbp)
# cerune-origin: #3 bytes 60..61
cerune_origin_n3_main_2:
  movabsq $2, %rax
# cerune-origin: #1 bytes 56..62
cerune_origin_n1_main_3:
  movq %rax, -144(%rbp)
# cerune-origin: #0 bytes 39..63
cerune_origin_n0_main_4:
  movq -136(%rbp), %rax
# cerune-origin: #0 bytes 39..63
cerune_origin_n0_main_5:
  movq %rax, -8(%rbp)
# cerune-origin: #0 bytes 39..63
cerune_origin_n0_main_6:
  movq -144(%rbp), %rax
# cerune-origin: #0 bytes 39..63
cerune_origin_n0_main_7:
  movq %rax, -16(%rbp)
# cerune-origin: #8 bytes 79..80
cerune_origin_n8_main_8:
  movabsq $1, %rax
# cerune-origin: #7 bytes 78..84
cerune_origin_n7_main_9:
  movq %rax, -152(%rbp)
# cerune-origin: #9 bytes 82..83
cerune_origin_n9_main_10:
  movabsq $3, %rax
# cerune-origin: #7 bytes 78..84
cerune_origin_n7_main_11:
  movq %rax, -160(%rbp)
# cerune-origin: #5 bytes 70..84
cerune_origin_n5_main_12:
  leaq -8(%rbp), %rcx
  leaq -152(%rbp), %rdx
  callq cerune_fn__equal0_0
# cerune-origin: #4 bytes 64..86
cerune_origin_n4_main_13:
  testq %rax, %rax
  leaq .Lcerune_bool_false(%rip), %rcx
  leaq .Lcerune_bool_true(%rip), %rdx
  cmovne %rdx, %rcx
  callq puts
# cerune-origin: #12 bytes 93..104
cerune_origin_n12_main_14:
  movabsq $0, %rax
# cerune-origin: #11 bytes 93..113
cerune_origin_n11_main_15:
  movq %rax, -168(%rbp)
# cerune-origin: #13 bytes 110..111
cerune_origin_n13_main_16:
  movabsq $7, %rax
# cerune-origin: #11 bytes 93..113
cerune_origin_n11_main_17:
  movq %rax, -176(%rbp)
# cerune-origin: #10 bytes 87..115
cerune_origin_n10_main_18:
  leaq -168(%rbp), %rcx
  callq cerune_fn__display6_6
# cerune-origin: #15 bytes 130..259
cerune_origin_n15_main_19:
  callq cerune_fn__match_bind5_5
# cerune-origin: #14 bytes 116..260
cerune_origin_n14_main_20:
  movq %rax, -24(%rbp)
# cerune-origin: #44 bytes 267..273
cerune_origin_n44_main_21:
  movq -24(%rbp), %rax
# cerune-origin: #43 bytes 261..275
cerune_origin_n43_main_22:
  movq %rax, %rdx
# cerune-origin: #43 bytes 261..275
cerune_origin_n43_main_23:
  leaq .Lcerune_fmt_i64(%rip), %rcx
# cerune-origin: #43 bytes 261..275
cerune_origin_n43_main_24:
  callq printf
# cerune-origin: synthetic
  xorl %eax, %eax
  addq $208, %rsp
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
