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
.p2align 3
.Lcerune_string_0:
  .quad 3
  .byte 230
  .byte 151
  .byte 165
.p2align 3
.Lcerune_string_1:
  .quad 3
  .byte 230
  .byte 156
  .byte 172
.p2align 3
.Lcerune_string_2:
  .quad 1
  .byte 33

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
  movq %rcx, %r10
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
  movq %rcx, %r10
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
  movq %rax, %rcx
  callq free
.Lcerune_heap_release_done:
  addq $32, %rsp
  popq %rbp
  retq
cerune_string_concat:
  pushq %rbp
  movq %rsp, %rbp
  subq $80, %rsp
  movq %rcx, -8(%rbp)
  movq %rdx, -16(%rbp)
  movq (%rcx), %rax
  movq %rax, -32(%rbp)
  addq (%rdx), %rax
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
  leaq 24(%rax), %rcx
  callq malloc
  testq %rax, %rax
  je .Lcerune_heap_allocation_fail
  movq %rax, -40(%rbp)
  movq .Lcerune_heap_head(%rip), %rcx
  movq %rcx, (%rax)
  movq $1, 8(%rax)
  movq -24(%rbp), %rcx
  movq %rcx, 16(%rax)
  leaq 24(%rax), %rcx
  movq -8(%rbp), %rdx
  addq $8, %rdx
  movq -32(%rbp), %r8
  callq memcpy
  movq -40(%rbp), %rcx
  addq $24, %rcx
  addq -32(%rbp), %rcx
  movq -16(%rbp), %rdx
  movq (%rdx), %r8
  addq $8, %rdx
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
.p2align 4
cerune_fn__ownership0_0:
  pushq %rbp
  movq %rsp, %rbp
  subq $112, %rsp
  leaq .Lcerune_string_0(%rip), %rax
  movq %rax, -8(%rbp)
  leaq .Lcerune_string_1(%rip), %rax
  movq %rax, -16(%rbp)
  movq -8(%rbp), %rax
  movq %rax, -32(%rbp)
  movq -16(%rbp), %rax
  movq %rax, %rdx
  movq -32(%rbp), %rcx
  callq cerune_string_concat
  testq %rdx, %rdx
  je .Lfn_0_concat_ok_0
  cmpq $1, %rdx
  jne .Lfn_0_concat_limit_0
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_0(%rip), %rdx
  movl $69, %r8d
  callq _write
  ud2
.Lfn_0_concat_limit_0:
  cmpq $2, %rdx
  jne .Lfn_0_concat_failed_0
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_1(%rip), %rdx
  movl $70, %r8d
  callq _write
  ud2
.Lfn_0_concat_failed_0:
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_2(%rip), %rdx
  movl $62, %r8d
  callq _write
  ud2
.Lfn_0_concat_ok_0:
  movq %rax, -24(%rbp)
  movq -24(%rbp), %rax
  addq $112, %rsp
  popq %rbp
  retq

.p2align 4
cerune_fn__ownership1_1:
  pushq %rbp
  movq %rsp, %rbp
  subq $96, %rsp
  movq %rcx, -8(%rbp)
  movq -8(%rbp), %rax
  movq %rax, -16(%rbp)
  movq -16(%rbp), %rax
  movq %rax, -24(%rbp)
  movq -24(%rbp), %rax
  movq %rax, %rcx
  callq cerune_string_retain
  movq -24(%rbp), %rax
  addq $96, %rsp
  popq %rbp
  retq

.p2align 4
cerune_fn__ownership2_2:
  pushq %rbp
  movq %rsp, %rbp
  subq $112, %rsp
  movq %rcx, -8(%rbp)
  movq -8(%rbp), %rax
  movq %rax, -16(%rbp)
  leaq .Lcerune_string_2(%rip), %rax
  movq %rax, -24(%rbp)
  movq -16(%rbp), %rax
  movq %rax, -40(%rbp)
  movq -24(%rbp), %rax
  movq %rax, %rdx
  movq -40(%rbp), %rcx
  callq cerune_string_concat
  testq %rdx, %rdx
  je .Lfn_2_concat_ok_0
  cmpq $1, %rdx
  jne .Lfn_2_concat_limit_0
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_3(%rip), %rdx
  movl $69, %r8d
  callq _write
  ud2
.Lfn_2_concat_limit_0:
  cmpq $2, %rdx
  jne .Lfn_2_concat_failed_0
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_4(%rip), %rdx
  movl $70, %r8d
  callq _write
  ud2
.Lfn_2_concat_failed_0:
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_5(%rip), %rdx
  movl $62, %r8d
  callq _write
  ud2
.Lfn_2_concat_ok_0:
  movq %rax, -32(%rbp)
  movq -32(%rbp), %rax
  addq $112, %rsp
  popq %rbp
  retq

.p2align 4
cerune_fn__ownership3_3:
  pushq %rbp
  movq %rsp, %rbp
  subq $64, %rsp
  movq %rcx, -8(%rbp)
  movq %rdx, -16(%rbp)
  movq -8(%rbp), %rax
  movq %rax, %rcx
  callq cerune_string_release
  movq -16(%rbp), %rax
  addq $64, %rsp
  popq %rbp
  retq

.globl main
.p2align 4
main:
  pushq %rbp
  movq %rsp, %rbp
  subq $176, %rsp
  movl $1, %ecx
  movl $32768, %edx
  callq _setmode
  cmpl $-1, %eax
  jne .Lstdout_ready
  movl $1, %eax
  addq $176, %rsp
  popq %rbp
  retq
.Lstdout_ready:
  callq cerune_fn__ownership0_0
  movq %rax, -8(%rbp)
  movq -8(%rbp), %rax
  movq %rax, -40(%rbp)
  movq -40(%rbp), %rcx
  callq cerune_fn__ownership1_1
  movq %rax, -16(%rbp)
  movq -8(%rbp), %rax
  movq %rax, -40(%rbp)
  movq -8(%rbp), %rax
  movq %rax, -72(%rbp)
  movq -72(%rbp), %rcx
  callq cerune_fn__ownership2_2
  movq %rax, -48(%rbp)
  movq -40(%rbp), %rcx
  movq -48(%rbp), %rdx
  callq cerune_fn__ownership3_3
  movq %rax, -8(%rbp)
  movq -16(%rbp), %rax
  movq %rax, -24(%rbp)
  movq -24(%rbp), %rax
  movq %rax, %rcx
  callq cerune_print_string
  movq -8(%rbp), %rax
  movq %rax, -32(%rbp)
  movq -32(%rbp), %rax
  movq %rax, %rcx
  callq cerune_print_string
  movq -16(%rbp), %rax
  movq %rax, %rcx
  callq cerune_string_release
  movq -8(%rbp), %rax
  movq %rax, %rcx
  callq cerune_string_release
  xorl %eax, %eax
  addq $176, %rsp
  popq %rbp
  retq

.section .rdata,"dr"
.Lcerune_failure_0:
  .asciz "cerune: runtime-v1 code=allocation-size-overflow node=1 bytes=19..39\n"
.Lcerune_failure_1:
  .asciz "cerune: runtime-v1 code=allocation-limit-exceeded node=1 bytes=19..39\n"
.Lcerune_failure_2:
  .asciz "cerune: runtime-v1 code=allocation-failed node=1 bytes=19..39\n"
.Lcerune_failure_3:
  .asciz "cerune: runtime-v1 code=allocation-size-overflow node=7 bytes=70..87\n"
.Lcerune_failure_4:
  .asciz "cerune: runtime-v1 code=allocation-limit-exceeded node=7 bytes=70..87\n"
.Lcerune_failure_5:
  .asciz "cerune: runtime-v1 code=allocation-failed node=7 bytes=70..87\n"
