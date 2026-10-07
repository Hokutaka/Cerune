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

.p2align 4
cerune_fn__equal0_0:
  pushq %rbp
  movq %rsp, %rbp
  subq $240, %rsp
  movq 0(%rcx), %r10
  movq %r10, -8(%rbp)
  movq -8(%rcx), %r10
  movq %r10, -16(%rbp)
  movq 0(%rdx), %r10
  movq %r10, -24(%rbp)
  movq -8(%rdx), %r10
  movq %r10, -32(%rbp)
  jmp .Lcerune_fn_0_block_0
.Lcerune_fn_0_block_0: # mir_block
  movabsq $0, %rax
  movq %rax, -40(%rbp)
  movq -40(%rbp), %rax
  movq %rax, -48(%rbp)
  jmp .Lcerune_fn_0_block_1
.Lcerune_fn_0_block_1: # mir_block
  movq -48(%rbp), %rax
  movq %rax, -56(%rbp)
  movabsq $2, %rax
  movq %rax, -64(%rbp)
  movq -64(%rbp), %rax
  movq %rax, %rcx
  movq -56(%rbp), %rax
  cmpq %rcx, %rax
  setl %al
  movzbq %al, %rax
  movq %rax, -72(%rbp)
  movq -72(%rbp), %rax
  testq %rax, %rax
  je .Lcerune_fn_0_block_3
  jmp .Lcerune_fn_0_block_2
.Lcerune_fn_0_block_2: # mir_block
  movq -8(%rbp), %rax
  movq %rax, -80(%rbp)
  movq -16(%rbp), %rax
  movq %rax, -88(%rbp)
  movq -48(%rbp), %rax
  movq %rax, -96(%rbp)
  movq -96(%rbp), %rax
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
  movq -200(%rbp), %r11
  movq (%r11), %rax
  movq %rax, -104(%rbp)
  movq -24(%rbp), %rax
  movq %rax, -112(%rbp)
  movq -32(%rbp), %rax
  movq %rax, -120(%rbp)
  movq -48(%rbp), %rax
  movq %rax, -128(%rbp)
  movq -128(%rbp), %rax
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
  movq -208(%rbp), %r11
  movq (%r11), %rax
  movq %rax, -136(%rbp)
  movq -136(%rbp), %rax
  movq %rax, %rcx
  movq -104(%rbp), %rax
  cmpq %rcx, %rax
  sete %al
  movzbq %al, %rax
  movq %rax, -144(%rbp)
  movq -144(%rbp), %rax
  xorq $1, %rax
  movq %rax, -152(%rbp)
  movq -152(%rbp), %rax
  testq %rax, %rax
  je .Lcerune_fn_0_block_6
  jmp .Lcerune_fn_0_block_5
.Lcerune_fn_0_block_3: # mir_block
  movabsq $1, %rax
  movq %rax, -192(%rbp)
  movq -192(%rbp), %rax
  addq $240, %rsp
  popq %rbp
  retq
.Lcerune_fn_0_block_4: # mir_block
  movq -48(%rbp), %rax
  movq %rax, -168(%rbp)
  movabsq $1, %rax
  movq %rax, -176(%rbp)
  movq -176(%rbp), %rax
  movq %rax, %rcx
  movq -168(%rbp), %rax
  addq %rcx, %rax
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
  movq %rax, -184(%rbp)
  movq -184(%rbp), %rax
  movq %rax, -48(%rbp)
  jmp .Lcerune_fn_0_block_1
.Lcerune_fn_0_block_5: # mir_block
  movabsq $0, %rax
  movq %rax, -160(%rbp)
  movq -160(%rbp), %rax
  addq $240, %rsp
  popq %rbp
  retq
.Lcerune_fn_0_block_6: # mir_block
  jmp .Lcerune_fn_0_block_7
.Lcerune_fn_0_block_7: # mir_block
  jmp .Lcerune_fn_0_block_4
.Lcerune_fn_0_block_8: # mir_block
  jmp .Lcerune_fn_0_block_7
.Lcerune_fn_0_block_9: # mir_block
  ud2

.p2align 4
cerune_fn__match_bind1_1:
  pushq %rbp
  movq %rsp, %rbp
  subq $112, %rsp
  movq 0(%rcx), %r10
  movq %r10, -8(%rbp)
  movq -8(%rcx), %r10
  movq %r10, -16(%rbp)
  jmp .Lcerune_fn_1_block_0
.Lcerune_fn_1_block_0: # mir_block
  movq -8(%rbp), %rax
  movq %rax, -24(%rbp)
  movq -16(%rbp), %rax
  movq %rax, -32(%rbp)
  movq -32(%rbp), %rax
  movq %rax, -40(%rbp)
  movq -40(%rbp), %rax
  movq %rax, -48(%rbp)
  movq -48(%rbp), %rax
  movq %rax, -56(%rbp)
  movabsq $0, %rax
  movq %rax, -64(%rbp)
  movq -64(%rbp), %rax
  movq %rax, %rcx
  movq -56(%rbp), %rax
  cmpq %rcx, %rax
  setg %al
  movzbq %al, %rax
  movq %rax, -72(%rbp)
  movq -72(%rbp), %rax
  addq $112, %rsp
  popq %rbp
  retq
.Lcerune_fn_1_block_1: # mir_block
  ud2

.p2align 4
cerune_fn__match_bind2_2:
  pushq %rbp
  movq %rsp, %rbp
  subq $96, %rsp
  movq 0(%rcx), %r10
  movq %r10, -8(%rbp)
  movq -8(%rcx), %r10
  movq %r10, -16(%rbp)
  jmp .Lcerune_fn_2_block_0
.Lcerune_fn_2_block_0: # mir_block
  movq -8(%rbp), %rax
  movq %rax, -24(%rbp)
  movq -16(%rbp), %rax
  movq %rax, -32(%rbp)
  movq -32(%rbp), %rax
  movq %rax, -40(%rbp)
  movq -40(%rbp), %rax
  movq %rax, -48(%rbp)
  movq -48(%rbp), %rax
  movq %rax, -56(%rbp)
  movq -56(%rbp), %rax
  addq $96, %rsp
  popq %rbp
  retq
.Lcerune_fn_2_block_1: # mir_block
  ud2

.p2align 4
cerune_fn__match_select3_3:
  pushq %rbp
  movq %rsp, %rbp
  subq $112, %rsp
  movq 0(%rcx), %r10
  movq %r10, -8(%rbp)
  movq -8(%rcx), %r10
  movq %r10, -16(%rbp)
  jmp .Lcerune_fn_3_block_0
.Lcerune_fn_3_block_0: # mir_block
  movq -8(%rbp), %rax
  movq %rax, -24(%rbp)
  movq -16(%rbp), %rax
  movq %rax, -32(%rbp)
  movq -24(%rbp), %rax
  movq %rax, -40(%rbp)
  movabsq $0, %rax
  movq %rax, -48(%rbp)
  movq -48(%rbp), %rax
  movq %rax, %rcx
  movq -40(%rbp), %rax
  cmpq %rcx, %rax
  sete %al
  movzbq %al, %rax
  movq %rax, -56(%rbp)
  movq -56(%rbp), %rax
  testq %rax, %rax
  je .Lcerune_fn_3_block_2
  jmp .Lcerune_fn_3_block_1
.Lcerune_fn_3_block_1: # mir_block
  movabsq $0, %rax
  movq %rax, -64(%rbp)
  movq -64(%rbp), %rax
  addq $112, %rsp
  popq %rbp
  retq
.Lcerune_fn_3_block_2: # mir_block
  movabsq $1, %rax
  movq %rax, -72(%rbp)
  movq -72(%rbp), %rax
  negq %rax
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
  movq %rax, -80(%rbp)
  movq -80(%rbp), %rax
  addq $112, %rsp
  popq %rbp
  retq
.Lcerune_fn_3_block_3: # mir_block
  ud2
.Lcerune_fn_3_block_4: # mir_block
  jmp .Lcerune_fn_3_block_3
.Lcerune_fn_3_block_5: # mir_block
  jmp .Lcerune_fn_3_block_3

.p2align 4
cerune_fn__match_select4_4:
  pushq %rbp
  movq %rsp, %rbp
  subq $176, %rsp
  movq 0(%rcx), %r10
  movq %r10, -8(%rbp)
  movq -8(%rcx), %r10
  movq %r10, -16(%rbp)
  jmp .Lcerune_fn_4_block_0
.Lcerune_fn_4_block_0: # mir_block
  movq -8(%rbp), %rax
  movq %rax, -24(%rbp)
  movq -16(%rbp), %rax
  movq %rax, -32(%rbp)
  movq -24(%rbp), %rax
  movq %rax, -40(%rbp)
  movabsq $0, %rax
  movq %rax, -48(%rbp)
  movq -48(%rbp), %rax
  movq %rax, %rcx
  movq -40(%rbp), %rax
  cmpq %rcx, %rax
  sete %al
  movzbq %al, %rax
  movq %rax, -56(%rbp)
  movq -56(%rbp), %rax
  movq %rax, -64(%rbp)
  movq -56(%rbp), %rax
  testq %rax, %rax
  je .Lcerune_fn_4_block_2
  jmp .Lcerune_fn_4_block_1
.Lcerune_fn_4_block_1: # mir_block
  movq -8(%rbp), %rax
  movq %rax, -72(%rbp)
  movq -16(%rbp), %rax
  movq %rax, -80(%rbp)
  leaq -72(%rbp), %rcx
  callq cerune_fn__match_bind1_1
  movq %rax, -88(%rbp)
  movq -88(%rbp), %rax
  movq %rax, -64(%rbp)
  jmp .Lcerune_fn_4_block_2
.Lcerune_fn_4_block_2: # mir_block
  movq -64(%rbp), %rax
  testq %rax, %rax
  je .Lcerune_fn_4_block_4
  jmp .Lcerune_fn_4_block_3
.Lcerune_fn_4_block_3: # mir_block
  movq -8(%rbp), %rax
  movq %rax, -96(%rbp)
  movq -16(%rbp), %rax
  movq %rax, -104(%rbp)
  leaq -96(%rbp), %rcx
  callq cerune_fn__match_bind2_2
  movq %rax, -112(%rbp)
  movq -112(%rbp), %rax
  addq $176, %rsp
  popq %rbp
  retq
.Lcerune_fn_4_block_4: # mir_block
  movq -8(%rbp), %rax
  movq %rax, -120(%rbp)
  movq -16(%rbp), %rax
  movq %rax, -128(%rbp)
  leaq -120(%rbp), %rcx
  callq cerune_fn__match_select3_3
  movq %rax, -136(%rbp)
  movq -136(%rbp), %rax
  addq $176, %rsp
  popq %rbp
  retq
.Lcerune_fn_4_block_5: # mir_block
  ud2
.Lcerune_fn_4_block_6: # mir_block
  jmp .Lcerune_fn_4_block_5
.Lcerune_fn_4_block_7: # mir_block
  jmp .Lcerune_fn_4_block_5

.p2align 4
cerune_fn__match_bind5_5:
  pushq %rbp
  movq %rsp, %rbp
  subq $112, %rsp
  jmp .Lcerune_fn_5_block_0
.Lcerune_fn_5_block_0: # mir_block
  movabsq $0, %rax
  movq %rax, -8(%rbp)
  movabsq $7, %rax
  movq %rax, -16(%rbp)
  movq -8(%rbp), %rax
  movq %rax, -24(%rbp)
  movq -16(%rbp), %rax
  movq %rax, -32(%rbp)
  movq -24(%rbp), %rax
  movq %rax, -40(%rbp)
  movq -32(%rbp), %rax
  movq %rax, -48(%rbp)
  movq -40(%rbp), %rax
  movq %rax, -56(%rbp)
  movq -48(%rbp), %rax
  movq %rax, -64(%rbp)
  leaq -56(%rbp), %rcx
  callq cerune_fn__match_select4_4
  movq %rax, -72(%rbp)
  movq -72(%rbp), %rax
  addq $112, %rsp
  popq %rbp
  retq
.Lcerune_fn_5_block_1: # mir_block
  ud2

.p2align 4
cerune_fn__display6_6:
  pushq %rbp
  movq %rsp, %rbp
  subq $224, %rsp
  movq 0(%rcx), %r10
  movq %r10, -8(%rbp)
  movq -8(%rcx), %r10
  movq %r10, -16(%rbp)
  jmp .Lcerune_fn_6_block_0
.Lcerune_fn_6_block_0: # mir_block
  movq -8(%rbp), %rax
  movq %rax, -24(%rbp)
  movq -16(%rbp), %rax
  movq %rax, -32(%rbp)
  movq -24(%rbp), %rax
  movq %rax, -40(%rbp)
  movabsq $0, %rax
  movq %rax, -48(%rbp)
  movq -48(%rbp), %rax
  movq %rax, %rcx
  movq -40(%rbp), %rax
  cmpq %rcx, %rax
  sete %al
  movzbq %al, %rax
  movq %rax, -56(%rbp)
  movq -56(%rbp), %rax
  testq %rax, %rax
  je .Lcerune_fn_6_block_2
  jmp .Lcerune_fn_6_block_1
.Lcerune_fn_6_block_1: # mir_block
  leaq .Lcerune_string_0(%rip), %rax
  movq %rax, -64(%rbp)
  movq -64(%rbp), %rax
  movq %rax, %rcx
  callq cerune_write_string
  leaq .Lcerune_string_1(%rip), %rax
  movq %rax, -72(%rbp)
  movq -72(%rbp), %rax
  movq %rax, %rcx
  callq cerune_write_string
  leaq .Lcerune_string_2(%rip), %rax
  movq %rax, -80(%rbp)
  movq -80(%rbp), %rax
  movq %rax, %rcx
  callq cerune_write_string
  movq -8(%rbp), %rax
  movq %rax, -88(%rbp)
  movq -16(%rbp), %rax
  movq %rax, -96(%rbp)
  movq -96(%rbp), %rax
  movq %rax, -104(%rbp)
  movq -104(%rbp), %rax
  movq %rax, %rdx
  leaq .Lwrite_i64(%rip), %rcx
  callq printf
  leaq .Lcerune_string_3(%rip), %rax
  movq %rax, -112(%rbp)
  movq -112(%rbp), %rax
  movq %rax, %rcx
  callq cerune_write_string
  jmp .Lcerune_fn_6_block_3
.Lcerune_fn_6_block_2: # mir_block
  jmp .Lcerune_fn_6_block_3
.Lcerune_fn_6_block_3: # mir_block
  movq -8(%rbp), %rax
  movq %rax, -120(%rbp)
  movq -16(%rbp), %rax
  movq %rax, -128(%rbp)
  movq -120(%rbp), %rax
  movq %rax, -136(%rbp)
  movabsq $1, %rax
  movq %rax, -144(%rbp)
  movq -144(%rbp), %rax
  movq %rax, %rcx
  movq -136(%rbp), %rax
  cmpq %rcx, %rax
  sete %al
  movzbq %al, %rax
  movq %rax, -152(%rbp)
  movq -152(%rbp), %rax
  testq %rax, %rax
  je .Lcerune_fn_6_block_5
  jmp .Lcerune_fn_6_block_4
.Lcerune_fn_6_block_4: # mir_block
  leaq .Lcerune_string_4(%rip), %rax
  movq %rax, -160(%rbp)
  movq -160(%rbp), %rax
  movq %rax, %rcx
  callq cerune_write_string
  leaq .Lcerune_string_5(%rip), %rax
  movq %rax, -168(%rbp)
  movq -168(%rbp), %rax
  movq %rax, %rcx
  callq cerune_write_string
  leaq .Lcerune_string_6(%rip), %rax
  movq %rax, -176(%rbp)
  movq -176(%rbp), %rax
  movq %rax, %rcx
  callq cerune_write_string
  jmp .Lcerune_fn_6_block_6
.Lcerune_fn_6_block_5: # mir_block
  jmp .Lcerune_fn_6_block_6
.Lcerune_fn_6_block_6: # mir_block
  leaq .Lcerune_string_7(%rip), %rax
  movq %rax, -184(%rbp)
  movq -184(%rbp), %rax
  movq %rax, %rcx
  callq cerune_print_string
  addq $224, %rsp
  popq %rbp
  retq
.Lcerune_fn_6_block_7: # mir_block
  addq $224, %rsp
  popq %rbp
  retq

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
  jmp .Lcerune_block_0
.Lcerune_block_0: # mir_block
  movabsq $1, %rax
  movq %rax, -8(%rbp)
  movabsq $2, %rax
  movq %rax, -16(%rbp)
  movq -8(%rbp), %rax
  movq %rax, -24(%rbp)
  movq -16(%rbp), %rax
  movq %rax, -32(%rbp)
  movq -24(%rbp), %rax
  movq %rax, -40(%rbp)
  movq -32(%rbp), %rax
  movq %rax, -48(%rbp)
  movq -40(%rbp), %rax
  movq %rax, -56(%rbp)
  movq -48(%rbp), %rax
  movq %rax, -64(%rbp)
  movabsq $1, %rax
  movq %rax, -72(%rbp)
  movabsq $3, %rax
  movq %rax, -80(%rbp)
  movq -72(%rbp), %rax
  movq %rax, -88(%rbp)
  movq -80(%rbp), %rax
  movq %rax, -96(%rbp)
  leaq -56(%rbp), %rcx
  leaq -88(%rbp), %rdx
  callq cerune_fn__equal0_0
  movq %rax, -104(%rbp)
  movq -104(%rbp), %rax
  testq %rax, %rax
  leaq .Lcerune_bool_false(%rip), %rcx
  leaq .Lcerune_bool_true(%rip), %rdx
  cmovne %rdx, %rcx
  callq puts
  movabsq $0, %rax
  movq %rax, -112(%rbp)
  movabsq $7, %rax
  movq %rax, -120(%rbp)
  movq -112(%rbp), %rax
  movq %rax, -128(%rbp)
  movq -120(%rbp), %rax
  movq %rax, -136(%rbp)
  leaq -128(%rbp), %rcx
  callq cerune_fn__display6_6
  callq cerune_fn__match_bind5_5
  movq %rax, -144(%rbp)
  movq -144(%rbp), %rax
  movq %rax, -152(%rbp)
  movq -152(%rbp), %rax
  movq %rax, -160(%rbp)
  movq -160(%rbp), %rax
  movq %rax, %rdx
  leaq .Lcerune_fmt_i64(%rip), %rcx
  callq printf
  jmp .Lcerune_block_1
.Lcerune_block_1: # main_exit
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
