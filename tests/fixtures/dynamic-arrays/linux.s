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
.p2align 3
.Lcerune_string_0:
  .quad 1
  .byte 91
.p2align 3
.Lcerune_string_1:
  .quad 2
  .byte 44
  .byte 32
.p2align 3
.Lcerune_string_2:
  .quad 1
  .byte 93
.p2align 3
.Lcerune_string_3:
  .quad 0
.p2align 3
.Lcerune_string_4:
  .quad 1
  .byte 91
.p2align 3
.Lcerune_string_5:
  .quad 2
  .byte 44
  .byte 32
.p2align 3
.Lcerune_string_6:
  .quad 1
  .byte 93
.p2align 3
.Lcerune_string_7:
  .quad 0

.text
.section .rodata
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
  subq $8, %rsp
  cmpl $0, %edi
  je .Lescape_0
  cmpl $1, %edi
  je .Lescape_1
  cmpl $2, %edi
  je .Lescape_2
  cmpl $3, %edi
  je .Lescape_3
  cmpl $4, %edi
  je .Lescape_4
  cmpl $5, %edi
  je .Lescape_5
  cmpl $6, %edi
  je .Lescape_6
  cmpl $7, %edi
  je .Lescape_7
  cmpl $8, %edi
  je .Lescape_8
  cmpl $9, %edi
  je .Lescape_9
  cmpl $10, %edi
  je .Lescape_10
  cmpl $11, %edi
  je .Lescape_11
  cmpl $12, %edi
  je .Lescape_12
  cmpl $13, %edi
  je .Lescape_13
  cmpl $14, %edi
  je .Lescape_14
  cmpl $15, %edi
  je .Lescape_15
  cmpl $16, %edi
  je .Lescape_16
  cmpl $17, %edi
  je .Lescape_17
  cmpl $18, %edi
  je .Lescape_18
  cmpl $19, %edi
  je .Lescape_19
  cmpl $20, %edi
  je .Lescape_20
  cmpl $21, %edi
  je .Lescape_21
  cmpl $22, %edi
  je .Lescape_22
  cmpl $23, %edi
  je .Lescape_23
  cmpl $24, %edi
  je .Lescape_24
  cmpl $25, %edi
  je .Lescape_25
  cmpl $26, %edi
  je .Lescape_26
  cmpl $27, %edi
  je .Lescape_27
  cmpl $28, %edi
  je .Lescape_28
  cmpl $29, %edi
  je .Lescape_29
  cmpl $30, %edi
  je .Lescape_30
  cmpl $31, %edi
  je .Lescape_31
  cmpl $34, %edi
  je .Lescape_34
  cmpl $92, %edi
  je .Lescape_92
  cmpl $127, %edi
  je .Lescape_127
  callq putchar
  addq $8, %rsp
  retq
.Lescape_0:
  movl $92, %edi
  callq putchar
  movl $48, %edi
  callq putchar
  addq $8, %rsp
  retq
.Lescape_1:
  movl $92, %edi
  callq putchar
  movl $117, %edi
  callq putchar
  movl $123, %edi
  callq putchar
  movl $48, %edi
  callq putchar
  movl $49, %edi
  callq putchar
  movl $125, %edi
  callq putchar
  addq $8, %rsp
  retq
.Lescape_2:
  movl $92, %edi
  callq putchar
  movl $117, %edi
  callq putchar
  movl $123, %edi
  callq putchar
  movl $48, %edi
  callq putchar
  movl $50, %edi
  callq putchar
  movl $125, %edi
  callq putchar
  addq $8, %rsp
  retq
.Lescape_3:
  movl $92, %edi
  callq putchar
  movl $117, %edi
  callq putchar
  movl $123, %edi
  callq putchar
  movl $48, %edi
  callq putchar
  movl $51, %edi
  callq putchar
  movl $125, %edi
  callq putchar
  addq $8, %rsp
  retq
.Lescape_4:
  movl $92, %edi
  callq putchar
  movl $117, %edi
  callq putchar
  movl $123, %edi
  callq putchar
  movl $48, %edi
  callq putchar
  movl $52, %edi
  callq putchar
  movl $125, %edi
  callq putchar
  addq $8, %rsp
  retq
.Lescape_5:
  movl $92, %edi
  callq putchar
  movl $117, %edi
  callq putchar
  movl $123, %edi
  callq putchar
  movl $48, %edi
  callq putchar
  movl $53, %edi
  callq putchar
  movl $125, %edi
  callq putchar
  addq $8, %rsp
  retq
.Lescape_6:
  movl $92, %edi
  callq putchar
  movl $117, %edi
  callq putchar
  movl $123, %edi
  callq putchar
  movl $48, %edi
  callq putchar
  movl $54, %edi
  callq putchar
  movl $125, %edi
  callq putchar
  addq $8, %rsp
  retq
.Lescape_7:
  movl $92, %edi
  callq putchar
  movl $117, %edi
  callq putchar
  movl $123, %edi
  callq putchar
  movl $48, %edi
  callq putchar
  movl $55, %edi
  callq putchar
  movl $125, %edi
  callq putchar
  addq $8, %rsp
  retq
.Lescape_8:
  movl $92, %edi
  callq putchar
  movl $117, %edi
  callq putchar
  movl $123, %edi
  callq putchar
  movl $48, %edi
  callq putchar
  movl $56, %edi
  callq putchar
  movl $125, %edi
  callq putchar
  addq $8, %rsp
  retq
.Lescape_9:
  movl $92, %edi
  callq putchar
  movl $116, %edi
  callq putchar
  addq $8, %rsp
  retq
.Lescape_10:
  movl $92, %edi
  callq putchar
  movl $110, %edi
  callq putchar
  addq $8, %rsp
  retq
.Lescape_11:
  movl $92, %edi
  callq putchar
  movl $117, %edi
  callq putchar
  movl $123, %edi
  callq putchar
  movl $48, %edi
  callq putchar
  movl $98, %edi
  callq putchar
  movl $125, %edi
  callq putchar
  addq $8, %rsp
  retq
.Lescape_12:
  movl $92, %edi
  callq putchar
  movl $117, %edi
  callq putchar
  movl $123, %edi
  callq putchar
  movl $48, %edi
  callq putchar
  movl $99, %edi
  callq putchar
  movl $125, %edi
  callq putchar
  addq $8, %rsp
  retq
.Lescape_13:
  movl $92, %edi
  callq putchar
  movl $114, %edi
  callq putchar
  addq $8, %rsp
  retq
.Lescape_14:
  movl $92, %edi
  callq putchar
  movl $117, %edi
  callq putchar
  movl $123, %edi
  callq putchar
  movl $48, %edi
  callq putchar
  movl $101, %edi
  callq putchar
  movl $125, %edi
  callq putchar
  addq $8, %rsp
  retq
.Lescape_15:
  movl $92, %edi
  callq putchar
  movl $117, %edi
  callq putchar
  movl $123, %edi
  callq putchar
  movl $48, %edi
  callq putchar
  movl $102, %edi
  callq putchar
  movl $125, %edi
  callq putchar
  addq $8, %rsp
  retq
.Lescape_16:
  movl $92, %edi
  callq putchar
  movl $117, %edi
  callq putchar
  movl $123, %edi
  callq putchar
  movl $49, %edi
  callq putchar
  movl $48, %edi
  callq putchar
  movl $125, %edi
  callq putchar
  addq $8, %rsp
  retq
.Lescape_17:
  movl $92, %edi
  callq putchar
  movl $117, %edi
  callq putchar
  movl $123, %edi
  callq putchar
  movl $49, %edi
  callq putchar
  movl $49, %edi
  callq putchar
  movl $125, %edi
  callq putchar
  addq $8, %rsp
  retq
.Lescape_18:
  movl $92, %edi
  callq putchar
  movl $117, %edi
  callq putchar
  movl $123, %edi
  callq putchar
  movl $49, %edi
  callq putchar
  movl $50, %edi
  callq putchar
  movl $125, %edi
  callq putchar
  addq $8, %rsp
  retq
.Lescape_19:
  movl $92, %edi
  callq putchar
  movl $117, %edi
  callq putchar
  movl $123, %edi
  callq putchar
  movl $49, %edi
  callq putchar
  movl $51, %edi
  callq putchar
  movl $125, %edi
  callq putchar
  addq $8, %rsp
  retq
.Lescape_20:
  movl $92, %edi
  callq putchar
  movl $117, %edi
  callq putchar
  movl $123, %edi
  callq putchar
  movl $49, %edi
  callq putchar
  movl $52, %edi
  callq putchar
  movl $125, %edi
  callq putchar
  addq $8, %rsp
  retq
.Lescape_21:
  movl $92, %edi
  callq putchar
  movl $117, %edi
  callq putchar
  movl $123, %edi
  callq putchar
  movl $49, %edi
  callq putchar
  movl $53, %edi
  callq putchar
  movl $125, %edi
  callq putchar
  addq $8, %rsp
  retq
.Lescape_22:
  movl $92, %edi
  callq putchar
  movl $117, %edi
  callq putchar
  movl $123, %edi
  callq putchar
  movl $49, %edi
  callq putchar
  movl $54, %edi
  callq putchar
  movl $125, %edi
  callq putchar
  addq $8, %rsp
  retq
.Lescape_23:
  movl $92, %edi
  callq putchar
  movl $117, %edi
  callq putchar
  movl $123, %edi
  callq putchar
  movl $49, %edi
  callq putchar
  movl $55, %edi
  callq putchar
  movl $125, %edi
  callq putchar
  addq $8, %rsp
  retq
.Lescape_24:
  movl $92, %edi
  callq putchar
  movl $117, %edi
  callq putchar
  movl $123, %edi
  callq putchar
  movl $49, %edi
  callq putchar
  movl $56, %edi
  callq putchar
  movl $125, %edi
  callq putchar
  addq $8, %rsp
  retq
.Lescape_25:
  movl $92, %edi
  callq putchar
  movl $117, %edi
  callq putchar
  movl $123, %edi
  callq putchar
  movl $49, %edi
  callq putchar
  movl $57, %edi
  callq putchar
  movl $125, %edi
  callq putchar
  addq $8, %rsp
  retq
.Lescape_26:
  movl $92, %edi
  callq putchar
  movl $117, %edi
  callq putchar
  movl $123, %edi
  callq putchar
  movl $49, %edi
  callq putchar
  movl $97, %edi
  callq putchar
  movl $125, %edi
  callq putchar
  addq $8, %rsp
  retq
.Lescape_27:
  movl $92, %edi
  callq putchar
  movl $117, %edi
  callq putchar
  movl $123, %edi
  callq putchar
  movl $49, %edi
  callq putchar
  movl $98, %edi
  callq putchar
  movl $125, %edi
  callq putchar
  addq $8, %rsp
  retq
.Lescape_28:
  movl $92, %edi
  callq putchar
  movl $117, %edi
  callq putchar
  movl $123, %edi
  callq putchar
  movl $49, %edi
  callq putchar
  movl $99, %edi
  callq putchar
  movl $125, %edi
  callq putchar
  addq $8, %rsp
  retq
.Lescape_29:
  movl $92, %edi
  callq putchar
  movl $117, %edi
  callq putchar
  movl $123, %edi
  callq putchar
  movl $49, %edi
  callq putchar
  movl $100, %edi
  callq putchar
  movl $125, %edi
  callq putchar
  addq $8, %rsp
  retq
.Lescape_30:
  movl $92, %edi
  callq putchar
  movl $117, %edi
  callq putchar
  movl $123, %edi
  callq putchar
  movl $49, %edi
  callq putchar
  movl $101, %edi
  callq putchar
  movl $125, %edi
  callq putchar
  addq $8, %rsp
  retq
.Lescape_31:
  movl $92, %edi
  callq putchar
  movl $117, %edi
  callq putchar
  movl $123, %edi
  callq putchar
  movl $49, %edi
  callq putchar
  movl $102, %edi
  callq putchar
  movl $125, %edi
  callq putchar
  addq $8, %rsp
  retq
.Lescape_34:
  movl $92, %edi
  callq putchar
  movl $34, %edi
  callq putchar
  addq $8, %rsp
  retq
.Lescape_92:
  movl $92, %edi
  callq putchar
  movl $92, %edi
  callq putchar
  addq $8, %rsp
  retq
.Lescape_127:
  movl $92, %edi
  callq putchar
  movl $117, %edi
  callq putchar
  movl $123, %edi
  callq putchar
  movl $55, %edi
  callq putchar
  movl $102, %edi
  callq putchar
  movl $125, %edi
  callq putchar
  addq $8, %rsp
  retq
cerune_write_bool:
  subq $8, %rsp
  cmpl $0, %edi
  je .Lwrite_bool_false
  movl $116, %edi
  callq putchar
  movl $114, %edi
  callq putchar
  movl $117, %edi
  callq putchar
  movl $101, %edi
  callq putchar
  addq $8, %rsp
  retq
.Lwrite_bool_false:
  movl $102, %edi
  callq putchar
  movl $97, %edi
  callq putchar
  movl $108, %edi
  callq putchar
  movl $115, %edi
  callq putchar
  movl $101, %edi
  callq putchar
  addq $8, %rsp
  retq
cerune_write_string:
  subq $24, %rsp
  movq %rdi, 0(%rsp)
  movq $0, 8(%rsp)
.Lwrite_string_loop:
  movq 0(%rsp), %rax
  movq 8(%rsp), %rdx
  cmpq (%rax), %rdx
  je .Lwrite_string_end
  movzbl 8(%rax,%rdx), %edi
  callq putchar
  incq 8(%rsp)
  jmp .Lwrite_string_loop
.Lwrite_string_end:
  addq $24, %rsp
  retq
cerune_write_quoted:
  subq $24, %rsp
  movq %rdi, 0(%rsp)
  movq $0, 8(%rsp)
  movl $34, %edi
  callq putchar
.Lwrite_quoted_loop:
  movq 0(%rsp), %rax
  movq 8(%rsp), %rdx
  cmpq (%rax), %rdx
  je .Lwrite_quoted_end
  movzbl 8(%rax,%rdx), %edi
  callq cerune_write_escaped_byte
  incq 8(%rsp)
  jmp .Lwrite_quoted_loop
.Lwrite_quoted_end:
  movl $34, %edi
  callq putchar
  addq $24, %rsp
  retq

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


.data
.p2align 3
.Lcerune_heap_head:
  .quad 0
.Lcerune_heap_live:
  .quad 0
.Lcerune_heap_limit:
  .quad 67108864
.Lcerune_heap_max:
  .quad 9223372036854775783
.Lcerune_heap_empty:
  .quad 0
.text
cerune_string_retain:
  movq %rdi, %r10
  movq .Lcerune_heap_head(%rip), %rax
.Lcerune_heap_retain_search:
  testq %rax, %rax
  je .Lcerune_heap_retain_done
  leaq 16(%rax), %r11
  cmpq %r10, %r11
  je .Lcerune_heap_retain_found
  movq (%rax), %rax
  jmp .Lcerune_heap_retain_search
.Lcerune_heap_retain_found:
  addq $1, 8(%rax)
.Lcerune_heap_retain_done:
  retq
cerune_string_release:
  pushq %rbp
  movq %rsp, %rbp
  subq $32, %rsp
  movq %rdi, %r10
  leaq .Lcerune_heap_head(%rip), %r11
.Lcerune_heap_release_search:
  movq (%r11), %rax
  testq %rax, %rax
  je .Lcerune_heap_release_done
  leaq 16(%rax), %rcx
  cmpq %r10, %rcx
  je .Lcerune_heap_release_found
  movq %rax, %r11
  jmp .Lcerune_heap_release_search
.Lcerune_heap_release_found:
  subq $1, 8(%rax)
  jne .Lcerune_heap_release_done
  movq (%rax), %rcx
  movq %rcx, (%r11)
  movq 16(%rax), %rcx
  subq %rcx, .Lcerune_heap_live(%rip)
  movq %rax, %rdi
  callq free
.Lcerune_heap_release_done:
  addq $32, %rsp
  popq %rbp
  retq
cerune_string_concat:
  pushq %rbp
  movq %rsp, %rbp
  subq $80, %rsp
  movq %rdi, -8(%rbp)
  movq %rsi, -16(%rbp)
  movq (%rdi), %rax
  movq %rax, -32(%rbp)
  addq (%rsi), %rax
  jc .Lcerune_heap_size_fail
  cmpq .Lcerune_heap_max(%rip), %rax
  ja .Lcerune_heap_size_fail
  testq %rax, %rax
  je .Lcerune_heap_concat_empty
  movq %rax, -24(%rbp)
  movq .Lcerune_heap_limit(%rip), %rcx
  subq .Lcerune_heap_live(%rip), %rcx
  cmpq %rcx, %rax
  ja .Lcerune_heap_limit_fail
  leaq 24(%rax), %rdi
  callq malloc
  testq %rax, %rax
  je .Lcerune_heap_allocation_fail
  movq %rax, -40(%rbp)
  movq .Lcerune_heap_head(%rip), %rcx
  movq %rcx, (%rax)
  movq $1, 8(%rax)
  movq -24(%rbp), %rcx
  movq %rcx, 16(%rax)
  leaq 24(%rax), %rdi
  movq -8(%rbp), %rsi
  addq $8, %rsi
  movq -32(%rbp), %rdx
  callq memcpy
  movq -40(%rbp), %rdi
  addq $24, %rdi
  addq -32(%rbp), %rdi
  movq -16(%rbp), %rsi
  movq (%rsi), %rdx
  addq $8, %rsi
  callq memcpy
  movq -40(%rbp), %rax
  movq %rax, .Lcerune_heap_head(%rip)
  movq -24(%rbp), %rcx
  addq %rcx, .Lcerune_heap_live(%rip)
  addq $16, %rax
  xorl %edx, %edx
  jmp .Lcerune_heap_concat_done
.Lcerune_heap_concat_empty:
  leaq .Lcerune_heap_empty(%rip), %rax
  xorl %edx, %edx
  jmp .Lcerune_heap_concat_done
.Lcerune_heap_size_fail:
  movl $1, %edx
  jmp .Lcerune_heap_concat_done
.Lcerune_heap_limit_fail:
  movl $2, %edx
  jmp .Lcerune_heap_concat_done
.Lcerune_heap_allocation_fail:
  movl $3, %edx
.Lcerune_heap_concat_done:
  addq $80, %rsp
  popq %rbp
  retq

.data
.p2align 3
.Lcerune_array_live:
  .quad 0
.Lcerune_array_limit:
  .quad 67108864
.Lcerune_array_max:
  .quad 9223372036854775807
.Lcerune_array_physical_max:
  .quad 9223372036854775759
.text
cerune_array_allocate:
  pushq %rbp
  movq %rsp, %rbp
  subq $64, %rsp
  movq %rdi, %rax
  movq %rsi, %r10
  movq %rdx, %r11
  testq %rax, %rax
  js .Lcerune_array_size_fail
  je .Lcerune_array_empty
  movq %rax, -8(%rbp)
  movq %r11, -32(%rbp)
  mulq %r10
  testq %rdx, %rdx
  jne .Lcerune_array_size_fail
  cmpq .Lcerune_array_max(%rip), %rax
  ja .Lcerune_array_size_fail
  movq %rax, -16(%rbp)
  movq -8(%rbp), %rax
  mulq %r11
  testq %rdx, %rdx
  jne .Lcerune_array_size_fail
  cmpq .Lcerune_array_physical_max(%rip), %rax
  ja .Lcerune_array_size_fail
  movq %rax, -24(%rbp)
  movq .Lcerune_array_limit(%rip), %r10
  subq .Lcerune_array_live(%rip), %r10
  cmpq -16(%rbp), %r10
  jb .Lcerune_array_limit_fail
  leaq 48(%rax), %rdi
  callq malloc
  testq %rax, %rax
  je .Lcerune_array_allocation_fail
  movq -24(%rbp), %r11
  leaq 48(%rax), %r10
  testq %r11, %r11
  je .Lcerune_array_payload_ready
  subq $8, %r10
  addq %r11, %r10
.Lcerune_array_payload_ready:
  movq %r10, (%rax)
  movq -8(%rbp), %r10
  movq %r10, 8(%rax)
  movq $1, 16(%rax)
  movq -16(%rbp), %r10
  movq %r10, 24(%rax)
  addq %r10, .Lcerune_array_live(%rip)
  movq $0, 32(%rax)
  movq -32(%rbp), %r10
  movq %r10, 40(%rax)
  xorl %edx, %edx
  jmp .Lcerune_array_allocate_done
.Lcerune_array_empty:
  xorl %eax, %eax
  xorl %edx, %edx
  jmp .Lcerune_array_allocate_done
.Lcerune_array_size_fail:
  xorl %eax, %eax
  movl $1, %edx
  jmp .Lcerune_array_allocate_done
.Lcerune_array_limit_fail:
  xorl %eax, %eax
  movl $2, %edx
  jmp .Lcerune_array_allocate_done
.Lcerune_array_allocation_fail:
  movl $3, %edx
.Lcerune_array_allocate_done:
  addq $64, %rsp
  popq %rbp
  retq
cerune_array_length:
  xorl %eax, %eax
  testq %rdi, %rdi
  je .Lcerune_array_length_done
  movq 8(%rdi), %rax
.Lcerune_array_length_done:
  retq
cerune_array_init_address:
  movq %rdi, %r10
  testq %r10, %r10
  je .Lcerune_array_invalid_owner
  movq 32(%r10), %rax
  cmpq 8(%r10), %rax
  jae .Lcerune_array_invalid_owner
  imulq 40(%r10), %rax
  movq (%r10), %r11
  subq %rax, %r11
  movq %r11, %rax
  retq
cerune_array_retain:
  movq %rdi, %r10
  testq %r10, %r10
  je .Lcerune_array_retain_done
  cmpq $0, 16(%r10)
  je .Lcerune_array_invalid_owner
  cmpq $-1, 16(%r10)
  je .Lcerune_array_invalid_owner
  addq $1, 16(%r10)
.Lcerune_array_retain_done:
  retq
cerune_array_release_owner:
  movq %rdi, %r10
  xorl %eax, %eax
  testq %r10, %r10
  je .Lcerune_array_release_empty
  cmpq $0, 16(%r10)
  je .Lcerune_array_invalid_owner
  subq $1, 16(%r10)
  sete %al
  retq
.Lcerune_array_release_empty:
  movl $1, %eax
  retq
cerune_array_free:
  testq %rdi, %rdi
  je .Lcerune_array_free_empty
  cmpq $0, 16(%rdi)
  jne .Lcerune_array_invalid_owner
  pushq %rbp
  movq %rsp, %rbp
  subq $32, %rsp
  movq 24(%rdi), %r10
  subq %r10, .Lcerune_array_live(%rip)
  callq free
  addq $32, %rsp
  popq %rbp
.Lcerune_array_free_empty:
  retq
.Lcerune_array_invalid_owner:
  ud2
.p2align 4
cerune_fn__display0_0:
  pushq %rbp
  movq %rsp, %rbp
  subq $288, %rsp
  movq %rdi, -8(%rbp)
  leaq .Lcerune_string_0(%rip), %rax
  movq %rax, -16(%rbp)
  movq -16(%rbp), %rax
  movq %rax, %rdi
  callq cerune_write_string
  callq cerune_fn__ownership2_2
  movq %rax, -24(%rbp)
.Lcerune_fn_0_block_0: # for_condition
  movq -24(%rbp), %rax
  movq %rax, -88(%rbp)
  movq -8(%rbp), %rax
  movq %rax, -96(%rbp)
  movq -88(%rbp), %rdi
  movq -96(%rbp), %rsi
  callq cerune_fn__ownership3_3
  testq %rax, %rax
  je .Lcerune_fn_0_block_2
  movq -24(%rbp), %rax
  movq %rax, -88(%rbp)
  movq -88(%rbp), %rdi
  callq cerune_fn__ownership5_5
  testq %rax, %rax
  je .Lcerune_fn_0_block_4
  leaq .Lcerune_string_1(%rip), %rax
  movq %rax, -32(%rbp)
  movq -32(%rbp), %rax
  movq %rax, %rdi
  callq cerune_write_string
  jmp .Lcerune_fn_0_block_4
.Lcerune_fn_0_block_4: # if_end
  movq -8(%rbp), %rax
  movq %rax, -40(%rbp)
  movq -24(%rbp), %rax
  movq %rax, -48(%rbp)
  movq -48(%rbp), %rax
  movq %rax, -56(%rbp)
  movq -40(%rbp), %rax
  movq %rax, -272(%rbp)
  movq -56(%rbp), %rax
  movq -272(%rbp), %r10
  testq %rax, %rax
  js .Lfn_0_dynamic_index_trap_5
  testq %r10, %r10
  je .Lfn_0_dynamic_index_trap_5
  cmpq 8(%r10), %rax
  jge .Lfn_0_dynamic_index_trap_5
  cmpq 32(%r10), %rax
  jae .Lcerune_array_invalid_owner
  imulq 40(%r10), %rax
  movq (%r10), %r11
  subq %rax, %r11
  movq %r11, -280(%rbp)
  jmp .Lfn_0_dynamic_index_done_5
.Lfn_0_dynamic_index_trap_5:
  xorl %edi, %edi
  callq fflush
  movl $2, %edi
  leaq .Lcerune_failure_0(%rip), %rsi
  movl $71, %edx
  callq write
  ud2
.Lfn_0_dynamic_index_done_5:
  movq -280(%rbp), %r11
  movq (%r11), %rax
  movq %rax, -64(%rbp)
  movq -64(%rbp), %rax
  movq %rax, %rsi
  xorl %eax, %eax
  leaq .Lwrite_i64(%rip), %rdi
  callq printf
  jmp .Lcerune_fn_0_block_1
.Lcerune_fn_0_block_1: # for_update
  movq -24(%rbp), %rax
  movq %rax, -88(%rbp)
  movq -88(%rbp), %rdi
  callq cerune_fn__ownership4_4
  movq %rax, -24(%rbp)
  jmp .Lcerune_fn_0_block_0
.Lcerune_fn_0_block_2: # for_end
  leaq .Lcerune_string_2(%rip), %rax
  movq %rax, -72(%rbp)
  movq -72(%rbp), %rax
  movq %rax, %rdi
  callq cerune_write_string
  leaq .Lcerune_string_3(%rip), %rax
  movq %rax, -80(%rbp)
  movq -80(%rbp), %rax
  movq %rax, %rdi
  callq cerune_print_string
  addq $288, %rsp
  popq %rbp
  retq

.p2align 4
cerune_fn__display1_1:
  pushq %rbp
  movq %rsp, %rbp
  subq $288, %rsp
  movq %rdi, -8(%rbp)
  leaq .Lcerune_string_4(%rip), %rax
  movq %rax, -16(%rbp)
  movq -16(%rbp), %rax
  movq %rax, %rdi
  callq cerune_write_string
  callq cerune_fn__ownership6_6
  movq %rax, -24(%rbp)
.Lcerune_fn_1_block_0: # for_condition
  movq -24(%rbp), %rax
  movq %rax, -88(%rbp)
  movq -8(%rbp), %rax
  movq %rax, -96(%rbp)
  movq -88(%rbp), %rdi
  movq -96(%rbp), %rsi
  callq cerune_fn__ownership7_7
  testq %rax, %rax
  je .Lcerune_fn_1_block_2
  movq -24(%rbp), %rax
  movq %rax, -88(%rbp)
  movq -88(%rbp), %rdi
  callq cerune_fn__ownership9_9
  testq %rax, %rax
  je .Lcerune_fn_1_block_4
  leaq .Lcerune_string_5(%rip), %rax
  movq %rax, -32(%rbp)
  movq -32(%rbp), %rax
  movq %rax, %rdi
  callq cerune_write_string
  jmp .Lcerune_fn_1_block_4
.Lcerune_fn_1_block_4: # if_end
  movq -8(%rbp), %rax
  movq %rax, -40(%rbp)
  movq -24(%rbp), %rax
  movq %rax, -48(%rbp)
  movq -48(%rbp), %rax
  movq %rax, -56(%rbp)
  movq -40(%rbp), %rax
  movq %rax, -272(%rbp)
  movq -56(%rbp), %rax
  movq -272(%rbp), %r10
  testq %rax, %rax
  js .Lfn_1_dynamic_index_trap_5
  testq %r10, %r10
  je .Lfn_1_dynamic_index_trap_5
  cmpq 8(%r10), %rax
  jge .Lfn_1_dynamic_index_trap_5
  cmpq 32(%r10), %rax
  jae .Lcerune_array_invalid_owner
  imulq 40(%r10), %rax
  movq (%r10), %r11
  subq %rax, %r11
  movq %r11, -280(%rbp)
  jmp .Lfn_1_dynamic_index_done_5
.Lfn_1_dynamic_index_trap_5:
  xorl %edi, %edi
  callq fflush
  movl $2, %edi
  leaq .Lcerune_failure_1(%rip), %rsi
  movl $72, %edx
  callq write
  ud2
.Lfn_1_dynamic_index_done_5:
  movq -280(%rbp), %r11
  movq (%r11), %rax
  movq %rax, -64(%rbp)
  movq -64(%rbp), %rax
  movq %rax, %rsi
  xorl %eax, %eax
  leaq .Lwrite_i64(%rip), %rdi
  callq printf
  jmp .Lcerune_fn_1_block_1
.Lcerune_fn_1_block_1: # for_update
  movq -24(%rbp), %rax
  movq %rax, -88(%rbp)
  movq -88(%rbp), %rdi
  callq cerune_fn__ownership8_8
  movq %rax, -24(%rbp)
  jmp .Lcerune_fn_1_block_0
.Lcerune_fn_1_block_2: # for_end
  leaq .Lcerune_string_6(%rip), %rax
  movq %rax, -72(%rbp)
  movq -72(%rbp), %rax
  movq %rax, %rdi
  callq cerune_write_string
  leaq .Lcerune_string_7(%rip), %rax
  movq %rax, -80(%rbp)
  movq -80(%rbp), %rax
  movq %rax, %rdi
  callq cerune_print_string
  addq $288, %rsp
  popq %rbp
  retq

.p2align 4
cerune_fn__ownership2_2:
  pushq %rbp
  movq %rsp, %rbp
  subq $32, %rsp
  movabsq $0, %rax
  movq %rax, -8(%rbp)
  movq -8(%rbp), %rax
  addq $32, %rsp
  popq %rbp
  retq

.p2align 4
cerune_fn__ownership3_3:
  pushq %rbp
  movq %rsp, %rbp
  subq $112, %rsp
  movq %rdi, -8(%rbp)
  movq %rsi, -16(%rbp)
  movq -8(%rbp), %rax
  movq %rax, -24(%rbp)
  movq -16(%rbp), %rax
  movq %rax, -32(%rbp)
  movq -32(%rbp), %rax
  movq %rax, %rdi
  callq cerune_array_length
  movq %rax, -40(%rbp)
  movq -24(%rbp), %rax
  movq %rax, -56(%rbp)
  movq -40(%rbp), %rax
  movq %rax, %rcx
  movq -56(%rbp), %rax
  cmpq %rcx, %rax
  setl %al
  movzbq %al, %rax
  movq %rax, -48(%rbp)
  movq -48(%rbp), %rax
  addq $112, %rsp
  popq %rbp
  retq

.p2align 4
cerune_fn__ownership4_4:
  pushq %rbp
  movq %rsp, %rbp
  subq $80, %rsp
  movq %rdi, -8(%rbp)
  movq -8(%rbp), %rax
  movq %rax, -16(%rbp)
  movabsq $1, %rax
  movq %rax, -24(%rbp)
  movq -16(%rbp), %rax
  movq %rax, -40(%rbp)
  movq -24(%rbp), %rax
  movq %rax, %rcx
  movq -40(%rbp), %rax
  addq %rcx, %rax
  jno .Lcerune_fn_4_integer_ok_0
  xorl %edi, %edi
  callq fflush
  movl $2, %edi
  leaq .Lcerune_failure_2(%rip), %rsi
  movl $62, %edx
  callq write
  ud2
.Lcerune_fn_4_integer_ok_0:
  movq %rax, -32(%rbp)
  movq -32(%rbp), %rax
  addq $80, %rsp
  popq %rbp
  retq

.p2align 4
cerune_fn__ownership5_5:
  pushq %rbp
  movq %rsp, %rbp
  subq $80, %rsp
  movq %rdi, -8(%rbp)
  movq -8(%rbp), %rax
  movq %rax, -16(%rbp)
  movabsq $0, %rax
  movq %rax, -24(%rbp)
  movq -16(%rbp), %rax
  movq %rax, -40(%rbp)
  movq -24(%rbp), %rax
  movq %rax, %rcx
  movq -40(%rbp), %rax
  cmpq %rcx, %rax
  setne %al
  movzbq %al, %rax
  movq %rax, -32(%rbp)
  movq -32(%rbp), %rax
  addq $80, %rsp
  popq %rbp
  retq

.p2align 4
cerune_fn__ownership6_6:
  pushq %rbp
  movq %rsp, %rbp
  subq $32, %rsp
  movabsq $0, %rax
  movq %rax, -8(%rbp)
  movq -8(%rbp), %rax
  addq $32, %rsp
  popq %rbp
  retq

.p2align 4
cerune_fn__ownership7_7:
  pushq %rbp
  movq %rsp, %rbp
  subq $112, %rsp
  movq %rdi, -8(%rbp)
  movq %rsi, -16(%rbp)
  movq -8(%rbp), %rax
  movq %rax, -24(%rbp)
  movq -16(%rbp), %rax
  movq %rax, -32(%rbp)
  movq -32(%rbp), %rax
  movq %rax, %rdi
  callq cerune_array_length
  movq %rax, -40(%rbp)
  movq -24(%rbp), %rax
  movq %rax, -56(%rbp)
  movq -40(%rbp), %rax
  movq %rax, %rcx
  movq -56(%rbp), %rax
  cmpq %rcx, %rax
  setl %al
  movzbq %al, %rax
  movq %rax, -48(%rbp)
  movq -48(%rbp), %rax
  addq $112, %rsp
  popq %rbp
  retq

.p2align 4
cerune_fn__ownership8_8:
  pushq %rbp
  movq %rsp, %rbp
  subq $80, %rsp
  movq %rdi, -8(%rbp)
  movq -8(%rbp), %rax
  movq %rax, -16(%rbp)
  movabsq $1, %rax
  movq %rax, -24(%rbp)
  movq -16(%rbp), %rax
  movq %rax, -40(%rbp)
  movq -24(%rbp), %rax
  movq %rax, %rcx
  movq -40(%rbp), %rax
  addq %rcx, %rax
  jno .Lcerune_fn_8_integer_ok_0
  xorl %edi, %edi
  callq fflush
  movl $2, %edi
  leaq .Lcerune_failure_3(%rip), %rsi
  movl $63, %edx
  callq write
  ud2
.Lcerune_fn_8_integer_ok_0:
  movq %rax, -32(%rbp)
  movq -32(%rbp), %rax
  addq $80, %rsp
  popq %rbp
  retq

.p2align 4
cerune_fn__ownership9_9:
  pushq %rbp
  movq %rsp, %rbp
  subq $80, %rsp
  movq %rdi, -8(%rbp)
  movq -8(%rbp), %rax
  movq %rax, -16(%rbp)
  movabsq $0, %rax
  movq %rax, -24(%rbp)
  movq -16(%rbp), %rax
  movq %rax, -40(%rbp)
  movq -24(%rbp), %rax
  movq %rax, %rcx
  movq -40(%rbp), %rax
  cmpq %rcx, %rax
  setne %al
  movzbq %al, %rax
  movq %rax, -32(%rbp)
  movq -32(%rbp), %rax
  addq $80, %rsp
  popq %rbp
  retq

.p2align 4
cerune_fn__ownership10_10:
  pushq %rbp
  movq %rsp, %rbp
  subq $432, %rsp
  movabsq $1, %rax
  movq %rax, -8(%rbp)
  movabsq $2, %rax
  movq %rax, -16(%rbp)
  movq -8(%rbp), %rax
  movq %rax, -384(%rbp)
  movq -16(%rbp), %rax
  movq %rax, -392(%rbp)
  movq -384(%rbp), %rax
  movq %rax, -24(%rbp)
  movq -392(%rbp), %rax
  movq %rax, -32(%rbp)
  movabsq $2, %rax
  movq %rax, -400(%rbp)
  movabsq $0, %rax
  movq %rax, -408(%rbp)
  movabsq $2, %rax
  movq -408(%rbp), %r10
  testq %r10, %r10
  js .Lfn_10_array_range_trap_0
  cmpq %r10, %rax
  jl .Lfn_10_array_range_trap_0
  cmpq -400(%rbp), %rax
  jg .Lfn_10_array_range_trap_0
  jmp .Lfn_10_array_range_done_0
.Lfn_10_array_range_trap_0:
  xorl %edi, %edi
  callq fflush
  movl $2, %edi
  leaq .Lcerune_failure_4(%rip), %rsi
  movl $72, %edx
  callq write
  ud2
.Lfn_10_array_range_done_0:
  movabsq $2, %rax
  movq %rax, -120(%rbp)
  movabsq $0, %rax
  movq %rax, %rcx
  movq -120(%rbp), %rax
  subq %rcx, %rax
  jno .Lcerune_fn_10_integer_ok_1
  xorl %edi, %edi
  callq fflush
  movl $2, %edi
  leaq .Lcerune_failure_5(%rip), %rsi
  movl $63, %edx
  callq write
  ud2
.Lcerune_fn_10_integer_ok_1:
  movq %rax, -40(%rbp)
  movq -40(%rbp), %rax
  movq %rax, %rdi
  movabsq $8, %rsi
  movabsq $8, %rdx
  callq cerune_array_allocate
  testq %rdx, %rdx
  je .Lfn_10_array_allocated_2
  cmpq $1, %rdx
  jne .Lfn_10_array_limit_2
  xorl %edi, %edi
  callq fflush
  movl $2, %edi
  leaq .Lcerune_failure_6(%rip), %rsi
  movl $71, %edx
  callq write
  ud2
.Lfn_10_array_limit_2:
  cmpq $2, %rdx
  jne .Lfn_10_array_failed_2
  xorl %edi, %edi
  callq fflush
  movl $2, %edi
  leaq .Lcerune_failure_7(%rip), %rsi
  movl $72, %edx
  callq write
  ud2
.Lfn_10_array_failed_2:
  xorl %edi, %edi
  callq fflush
  movl $2, %edi
  leaq .Lcerune_failure_8(%rip), %rsi
  movl $64, %edx
  callq write
  ud2
.Lfn_10_array_allocated_2:
  movq %rax, -48(%rbp)
  movabsq $0, %rax
  movq %rax, -56(%rbp)
.Lcerune_fn_10_block_3: # for_condition
  movq -56(%rbp), %rax
  movq %rax, -120(%rbp)
  movq -40(%rbp), %rax
  movq %rax, %rcx
  movq -120(%rbp), %rax
  cmpq %rcx, %rax
  setl %al
  movzbq %al, %rax
  testq %rax, %rax
  je .Lcerune_fn_10_block_5
  movq -24(%rbp), %rax
  movq %rax, -64(%rbp)
  movq -32(%rbp), %rax
  movq %rax, -72(%rbp)
  movq -56(%rbp), %rax
  movq %rax, -80(%rbp)
  movabsq $0, %rax
  movq %rax, -88(%rbp)
  movq -80(%rbp), %rax
  movq %rax, -120(%rbp)
  movq -88(%rbp), %rax
  movq %rax, %rcx
  movq -120(%rbp), %rax
  addq %rcx, %rax
  jno .Lcerune_fn_10_integer_ok_6
  xorl %edi, %edi
  callq fflush
  movl $2, %edi
  leaq .Lcerune_failure_9(%rip), %rsi
  movl $63, %edx
  callq write
  ud2
.Lcerune_fn_10_integer_ok_6:
  movq %rax, -96(%rbp)
  movq -96(%rbp), %rax
  testq %rax, %rax
  js .Lcerune_fn_10_array_oob_7
  cmpq $2, %rax
  jge .Lcerune_fn_10_array_oob_7
  negq %rax
  movq -64(%rbp,%rax,8), %rax
  jmp .Lcerune_fn_10_array_done_7
.Lcerune_fn_10_array_oob_7:
  xorl %edi, %edi
  callq fflush
  movl $2, %edi
  leaq .Lcerune_failure_10(%rip), %rsi
  movl $72, %edx
  callq write
  ud2
.Lcerune_fn_10_array_done_7:
  movq %rax, -104(%rbp)
  movq -104(%rbp), %rax
  movq %rax, -112(%rbp)
  movq -48(%rbp), %rax
  movq %rax, -416(%rbp)
  movq -416(%rbp), %rdi
  callq cerune_array_init_address
  movq %rax, -424(%rbp)
  movq -112(%rbp), %rax
  movq -424(%rbp), %rcx
  movq %rax, (%rcx)
  movq -416(%rbp), %r10
  addq $1, 32(%r10)
  jmp .Lcerune_fn_10_block_4
.Lcerune_fn_10_block_4: # for_update
  movq -56(%rbp), %rax
  movq %rax, -120(%rbp)
  movabsq $1, %rax
  movq %rax, %rcx
  movq -120(%rbp), %rax
  addq %rcx, %rax
  jno .Lcerune_fn_10_integer_ok_8
  xorl %edi, %edi
  callq fflush
  movl $2, %edi
  leaq .Lcerune_failure_11(%rip), %rsi
  movl $63, %edx
  callq write
  ud2
.Lcerune_fn_10_integer_ok_8:
  movq %rax, -56(%rbp)
  jmp .Lcerune_fn_10_block_3
.Lcerune_fn_10_block_5: # for_end
  movq -48(%rbp), %rax
  addq $432, %rsp
  popq %rbp
  retq

.p2align 4
cerune_fn__ownership11_11:
  pushq %rbp
  movq %rsp, %rbp
  subq $416, %rsp
  movq %rdi, -8(%rbp)
  movq -8(%rbp), %rax
  movq %rax, -16(%rbp)
  movq -16(%rbp), %rax
  movq %rax, -24(%rbp)
  movq -24(%rbp), %rax
  movq %rax, %rdi
  callq cerune_array_length
  movq %rax, -368(%rbp)
  movabsq $0, %rax
  movq %rax, -376(%rbp)
  movq -24(%rbp), %rax
  movq %rax, %rdi
  callq cerune_array_length
  movq -376(%rbp), %r10
  testq %r10, %r10
  js .Lfn_11_array_range_trap_0
  cmpq %r10, %rax
  jl .Lfn_11_array_range_trap_0
  cmpq -368(%rbp), %rax
  jg .Lfn_11_array_range_trap_0
  jmp .Lfn_11_array_range_done_0
.Lfn_11_array_range_trap_0:
  xorl %edi, %edi
  callq fflush
  movl $2, %edi
  leaq .Lcerune_failure_12(%rip), %rsi
  movl $72, %edx
  callq write
  ud2
.Lfn_11_array_range_done_0:
  movq -24(%rbp), %rax
  movq %rax, %rdi
  callq cerune_array_length
  movq %rax, -104(%rbp)
  movabsq $0, %rax
  movq %rax, %rcx
  movq -104(%rbp), %rax
  subq %rcx, %rax
  jno .Lcerune_fn_11_integer_ok_1
  xorl %edi, %edi
  callq fflush
  movl $2, %edi
  leaq .Lcerune_failure_13(%rip), %rsi
  movl $63, %edx
  callq write
  ud2
.Lcerune_fn_11_integer_ok_1:
  movq %rax, -32(%rbp)
  movq -32(%rbp), %rax
  movq %rax, %rdi
  movabsq $8, %rsi
  movabsq $8, %rdx
  callq cerune_array_allocate
  testq %rdx, %rdx
  je .Lfn_11_array_allocated_2
  cmpq $1, %rdx
  jne .Lfn_11_array_limit_2
  xorl %edi, %edi
  callq fflush
  movl $2, %edi
  leaq .Lcerune_failure_14(%rip), %rsi
  movl $71, %edx
  callq write
  ud2
.Lfn_11_array_limit_2:
  cmpq $2, %rdx
  jne .Lfn_11_array_failed_2
  xorl %edi, %edi
  callq fflush
  movl $2, %edi
  leaq .Lcerune_failure_15(%rip), %rsi
  movl $72, %edx
  callq write
  ud2
.Lfn_11_array_failed_2:
  xorl %edi, %edi
  callq fflush
  movl $2, %edi
  leaq .Lcerune_failure_16(%rip), %rsi
  movl $64, %edx
  callq write
  ud2
.Lfn_11_array_allocated_2:
  movq %rax, -40(%rbp)
  movabsq $0, %rax
  movq %rax, -48(%rbp)
.Lcerune_fn_11_block_3: # for_condition
  movq -48(%rbp), %rax
  movq %rax, -104(%rbp)
  movq -32(%rbp), %rax
  movq %rax, %rcx
  movq -104(%rbp), %rax
  cmpq %rcx, %rax
  setl %al
  movzbq %al, %rax
  testq %rax, %rax
  je .Lcerune_fn_11_block_5
  movq -24(%rbp), %rax
  movq %rax, -56(%rbp)
  movq -48(%rbp), %rax
  movq %rax, -64(%rbp)
  movabsq $0, %rax
  movq %rax, -72(%rbp)
  movq -64(%rbp), %rax
  movq %rax, -104(%rbp)
  movq -72(%rbp), %rax
  movq %rax, %rcx
  movq -104(%rbp), %rax
  addq %rcx, %rax
  jno .Lcerune_fn_11_integer_ok_6
  xorl %edi, %edi
  callq fflush
  movl $2, %edi
  leaq .Lcerune_failure_17(%rip), %rsi
  movl $63, %edx
  callq write
  ud2
.Lcerune_fn_11_integer_ok_6:
  movq %rax, -80(%rbp)
  movq -56(%rbp), %rax
  movq %rax, -384(%rbp)
  movq -80(%rbp), %rax
  movq -384(%rbp), %r10
  testq %rax, %rax
  js .Lfn_11_dynamic_index_trap_7
  testq %r10, %r10
  je .Lfn_11_dynamic_index_trap_7
  cmpq 8(%r10), %rax
  jge .Lfn_11_dynamic_index_trap_7
  cmpq 32(%r10), %rax
  jae .Lcerune_array_invalid_owner
  imulq 40(%r10), %rax
  movq (%r10), %r11
  subq %rax, %r11
  movq %r11, -392(%rbp)
  jmp .Lfn_11_dynamic_index_done_7
.Lfn_11_dynamic_index_trap_7:
  xorl %edi, %edi
  callq fflush
  movl $2, %edi
  leaq .Lcerune_failure_18(%rip), %rsi
  movl $72, %edx
  callq write
  ud2
.Lfn_11_dynamic_index_done_7:
  movq -392(%rbp), %r11
  movq (%r11), %rax
  movq %rax, -88(%rbp)
  movq -88(%rbp), %rax
  movq %rax, -96(%rbp)
  movq -40(%rbp), %rax
  movq %rax, -400(%rbp)
  movq -400(%rbp), %rdi
  callq cerune_array_init_address
  movq %rax, -408(%rbp)
  movq -96(%rbp), %rax
  movq -408(%rbp), %rcx
  movq %rax, (%rcx)
  movq -400(%rbp), %r10
  addq $1, 32(%r10)
  jmp .Lcerune_fn_11_block_4
.Lcerune_fn_11_block_4: # for_update
  movq -48(%rbp), %rax
  movq %rax, -104(%rbp)
  movabsq $1, %rax
  movq %rax, %rcx
  movq -104(%rbp), %rax
  addq %rcx, %rax
  jno .Lcerune_fn_11_integer_ok_8
  xorl %edi, %edi
  callq fflush
  movl $2, %edi
  leaq .Lcerune_failure_19(%rip), %rsi
  movl $63, %edx
  callq write
  ud2
.Lcerune_fn_11_integer_ok_8:
  movq %rax, -48(%rbp)
  jmp .Lcerune_fn_11_block_3
.Lcerune_fn_11_block_5: # for_end
  movq -40(%rbp), %rax
  addq $416, %rsp
  popq %rbp
  retq

.p2align 4
cerune_fn__ownership12_12:
  pushq %rbp
  movq %rsp, %rbp
  subq $32, %rsp
  movabsq $0, %rax
  movq %rax, -8(%rbp)
  movq -8(%rbp), %rax
  addq $32, %rsp
  popq %rbp
  retq

.p2align 4
cerune_fn__ownership13_13:
  pushq %rbp
  movq %rsp, %rbp
  subq $32, %rsp
  movabsq $9, %rax
  movq %rax, -8(%rbp)
  movq -8(%rbp), %rax
  addq $32, %rsp
  popq %rbp
  retq

.p2align 4
cerune_fn__ownership14_14:
  pushq %rbp
  movq %rsp, %rbp
  subq $112, %rsp
  movq %rdi, -8(%rbp)
  movq -8(%rbp), %rax
  movq %rax, %rdi
  callq cerune_array_release_owner
  testq %rax, %rax
  je .Lcerune_fn_14_block_1
  movq -8(%rbp), %rax
  movq %rax, %rdi
  callq cerune_array_length
  movq %rax, -16(%rbp)
.Lcerune_fn_14_block_2: # for_condition
  movq -16(%rbp), %rax
  movq %rax, -24(%rbp)
  movabsq $0, %rax
  movq %rax, %rcx
  movq -24(%rbp), %rax
  cmpq %rcx, %rax
  setg %al
  movzbq %al, %rax
  testq %rax, %rax
  je .Lcerune_fn_14_block_4
  jmp .Lcerune_fn_14_block_3
.Lcerune_fn_14_block_3: # for_update
  movq -16(%rbp), %rax
  movq %rax, -24(%rbp)
  movabsq $1, %rax
  movq %rax, %rcx
  movq -24(%rbp), %rax
  subq %rcx, %rax
  jno .Lcerune_fn_14_integer_ok_5
  xorl %edi, %edi
  callq fflush
  movl $2, %edi
  leaq .Lcerune_failure_20(%rip), %rsi
  movl $63, %edx
  callq write
  ud2
.Lcerune_fn_14_integer_ok_5:
  movq %rax, -16(%rbp)
  jmp .Lcerune_fn_14_block_2
.Lcerune_fn_14_block_4: # for_end
  movq -8(%rbp), %rax
  movq %rax, %rdi
  callq cerune_array_free
  jmp .Lcerune_fn_14_block_1
.Lcerune_fn_14_block_1: # if_end
  addq $112, %rsp
  popq %rbp
  retq

.globl main
.p2align 4
main:
  pushq %rbp
  movq %rsp, %rbp
  subq $192, %rsp
  callq cerune_fn__ownership10_10
  movq %rax, -8(%rbp)
  movq -8(%rbp), %rax
  movq %rax, -56(%rbp)
  movq -56(%rbp), %rdi
  callq cerune_fn__ownership11_11
  movq %rax, -16(%rbp)
  callq cerune_fn__ownership12_12
  movq %rax, -24(%rbp)
  movq -8(%rbp), %rax
  movq %rax, -176(%rbp)
  movq -24(%rbp), %rax
  movq -176(%rbp), %r10
  testq %rax, %rax
  js .Lmain_dynamic_index_trap_0
  testq %r10, %r10
  je .Lmain_dynamic_index_trap_0
  cmpq 8(%r10), %rax
  jge .Lmain_dynamic_index_trap_0
  cmpq 32(%r10), %rax
  jae .Lcerune_array_invalid_owner
  imulq 40(%r10), %rax
  movq (%r10), %r11
  subq %rax, %r11
  movq %r11, -184(%rbp)
  jmp .Lmain_dynamic_index_done_0
.Lmain_dynamic_index_trap_0:
  xorl %edi, %edi
  callq fflush
  movl $2, %edi
  leaq .Lcerune_failure_21(%rip), %rsi
  movl $72, %edx
  callq write
  ud2
.Lmain_dynamic_index_done_0:
  movq -184(%rbp), %r11
  movq (%r11), %rax
  movq %rax, -32(%rbp)
  movq -24(%rbp), %rax
  movq -8(%rbp), %r10
  testq %rax, %rax
  js .Lmain_dynamic_index_trap_1
  testq %r10, %r10
  je .Lmain_dynamic_index_trap_1
  cmpq 8(%r10), %rax
  jge .Lmain_dynamic_index_trap_1
  cmpq 32(%r10), %rax
  jae .Lcerune_array_invalid_owner
  imulq 40(%r10), %rax
  movq (%r10), %r11
  subq %rax, %r11
  movq %r11, -192(%rbp)
  jmp .Lmain_dynamic_index_done_1
.Lmain_dynamic_index_trap_1:
  xorl %edi, %edi
  callq fflush
  movl $2, %edi
  leaq .Lcerune_failure_22(%rip), %rsi
  movl $70, %edx
  callq write
  ud2
.Lmain_dynamic_index_done_1:
  callq cerune_fn__ownership13_13
  movq -192(%rbp), %rcx
  movq %rax, (%rcx)
  movq -8(%rbp), %rax
  movq %rax, -40(%rbp)
  movq -40(%rbp), %rax
  movq %rax, -56(%rbp)
  movq -56(%rbp), %rdi
  callq cerune_fn__display0_0
  movq -16(%rbp), %rax
  movq %rax, -48(%rbp)
  movq -48(%rbp), %rax
  movq %rax, -56(%rbp)
  movq -56(%rbp), %rdi
  callq cerune_fn__display1_1
  movq -16(%rbp), %rax
  movq %rax, -56(%rbp)
  movq -56(%rbp), %rdi
  callq cerune_fn__ownership14_14
  movq -8(%rbp), %rax
  movq %rax, -56(%rbp)
  movq -56(%rbp), %rdi
  callq cerune_fn__ownership14_14
  xorl %eax, %eax
  addq $192, %rsp
  popq %rbp
  retq

.section .rodata
.Lcerune_failure_0:
  .asciz "cerune: runtime-v1 code=array-index-out-of-bounds node=30 bytes=78..92\n"
.Lcerune_failure_1:
  .asciz "cerune: runtime-v1 code=array-index-out-of-bounds node=59 bytes=93..106\n"
.Lcerune_failure_2:
  .asciz "cerune: runtime-v1 code=integer-overflow node=34 bytes=78..92\n"
.Lcerune_failure_3:
  .asciz "cerune: runtime-v1 code=integer-overflow node=63 bytes=93..106\n"
.Lcerune_failure_4:
  .asciz "cerune: runtime-v1 code=array-range-out-of-bounds node=219 bytes=20..38\n"
.Lcerune_failure_5:
  .asciz "cerune: runtime-v1 code=integer-overflow node=221 bytes=20..38\n"
.Lcerune_failure_6:
  .asciz "cerune: runtime-v1 code=allocation-size-overflow node=224 bytes=20..38\n"
.Lcerune_failure_7:
  .asciz "cerune: runtime-v1 code=allocation-limit-exceeded node=224 bytes=20..38\n"
.Lcerune_failure_8:
  .asciz "cerune: runtime-v1 code=allocation-failed node=224 bytes=20..38\n"
.Lcerune_failure_9:
  .asciz "cerune: runtime-v1 code=integer-overflow node=237 bytes=20..38\n"
.Lcerune_failure_10:
  .asciz "cerune: runtime-v1 code=array-index-out-of-bounds node=239 bytes=20..38\n"
.Lcerune_failure_11:
  .asciz "cerune: runtime-v1 code=integer-overflow node=233 bytes=20..38\n"
.Lcerune_failure_12:
  .asciz "cerune: runtime-v1 code=array-range-out-of-bounds node=275 bytes=55..61\n"
.Lcerune_failure_13:
  .asciz "cerune: runtime-v1 code=integer-overflow node=277 bytes=55..61\n"
.Lcerune_failure_14:
  .asciz "cerune: runtime-v1 code=allocation-size-overflow node=280 bytes=55..61\n"
.Lcerune_failure_15:
  .asciz "cerune: runtime-v1 code=allocation-limit-exceeded node=280 bytes=55..61\n"
.Lcerune_failure_16:
  .asciz "cerune: runtime-v1 code=allocation-failed node=280 bytes=55..61\n"
.Lcerune_failure_17:
  .asciz "cerune: runtime-v1 code=integer-overflow node=293 bytes=55..61\n"
.Lcerune_failure_18:
  .asciz "cerune: runtime-v1 code=array-index-out-of-bounds node=295 bytes=55..61\n"
.Lcerune_failure_19:
  .asciz "cerune: runtime-v1 code=integer-overflow node=289 bytes=55..61\n"
.Lcerune_failure_20:
  .asciz "cerune: runtime-v1 code=integer-overflow node=354 bytes=40..62\n"
.Lcerune_failure_21:
  .asciz "cerune: runtime-v1 code=array-index-out-of-bounds node=330 bytes=69..72\n"
.Lcerune_failure_22:
  .asciz "cerune: runtime-v1 code=array-index-out-of-bounds node=7 bytes=69..72\n"

.section .note.GNU-stack,"",@progbits
