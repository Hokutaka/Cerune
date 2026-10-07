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
# cerune-origin: synthetic
.p2align 4
cerune_fn__ownership0_0:
  pushq %rbp
  movq %rsp, %rbp
  subq $112, %rsp
# cerune-origin: synthetic
# cerune-mir: v1 synthetic ABI setup/exit
  jmp .Lcerune_fn_0_block_0
# cerune-origin: synthetic
# cerune-mir: v1 fn_0 bb0 block -> lir 1 (function-entry)
cerune_origin_mir_fn_0_bb0_block_lir1:
.Lcerune_fn_0_block_0: # mir_block
# cerune-origin: #2 bytes 26..31
cerune_origin_n2_fn_0_2:
# cerune-mir: v1 fn_0 bb0 i0 -> lir 2 (source)
cerune_origin_mir_fn_0_bb0_i0_lir2:
  leaq .Lcerune_string_0(%rip), %rax
# cerune-origin: #2 bytes 26..31
cerune_origin_n2_fn_0_3:
# cerune-mir: v1 fn_0 bb0 i0 -> lir 3 (source)
cerune_origin_mir_fn_0_bb0_i0_lir3:
  movq %rax, -8(%rbp)
# cerune-origin: #14 bytes 26..31
cerune_origin_n14_fn_0_4:
# cerune-mir: v1 fn_0 bb0 i1 -> lir 4 (source)
cerune_origin_mir_fn_0_bb0_i1_lir4:
  movq -8(%rbp), %rax
# cerune-origin: #14 bytes 26..31
cerune_origin_n14_fn_0_5:
# cerune-mir: v1 fn_0 bb0 i1 -> lir 5 (source)
cerune_origin_mir_fn_0_bb0_i1_lir5:
  movq %rax, -16(%rbp)
# cerune-origin: #3 bytes 33..38
cerune_origin_n3_fn_0_6:
# cerune-mir: v1 fn_0 bb0 i2 -> lir 6 (source)
cerune_origin_mir_fn_0_bb0_i2_lir6:
  leaq .Lcerune_string_1(%rip), %rax
# cerune-origin: #3 bytes 33..38
cerune_origin_n3_fn_0_7:
# cerune-mir: v1 fn_0 bb0 i2 -> lir 7 (source)
cerune_origin_mir_fn_0_bb0_i2_lir7:
  movq %rax, -24(%rbp)
# cerune-origin: #16 bytes 33..38
cerune_origin_n16_fn_0_8:
# cerune-mir: v1 fn_0 bb0 i3 -> lir 8 (source)
cerune_origin_mir_fn_0_bb0_i3_lir8:
  movq -24(%rbp), %rax
# cerune-origin: #16 bytes 33..38
cerune_origin_n16_fn_0_9:
# cerune-mir: v1 fn_0 bb0 i3 -> lir 9 (source)
cerune_origin_mir_fn_0_bb0_i3_lir9:
  movq %rax, -32(%rbp)
# cerune-origin: #15 bytes 26..31
cerune_origin_n15_fn_0_10:
# cerune-mir: v1 fn_0 bb0 i4 -> lir 10 (source)
cerune_origin_mir_fn_0_bb0_i4_lir10:
  movq -16(%rbp), %rax
# cerune-origin: #15 bytes 26..31
cerune_origin_n15_fn_0_11:
# cerune-mir: v1 fn_0 bb0 i4 -> lir 11 (source)
cerune_origin_mir_fn_0_bb0_i4_lir11:
  movq %rax, -40(%rbp)
# cerune-origin: #17 bytes 33..38
cerune_origin_n17_fn_0_12:
# cerune-mir: v1 fn_0 bb0 i5 -> lir 12 (source)
cerune_origin_mir_fn_0_bb0_i5_lir12:
  movq -32(%rbp), %rax
# cerune-origin: #17 bytes 33..38
cerune_origin_n17_fn_0_13:
# cerune-mir: v1 fn_0 bb0 i5 -> lir 13 (source)
cerune_origin_mir_fn_0_bb0_i5_lir13:
  movq %rax, -48(%rbp)
# cerune-origin: #1 bytes 19..39
cerune_origin_n1_fn_0_14:
# cerune-mir: v1 fn_0 bb0 i6 -> lir 14 (source)
cerune_origin_mir_fn_0_bb0_i6_lir14:
  movq -48(%rbp), %rax
# cerune-origin: #1 bytes 19..39
cerune_origin_n1_fn_0_15:
# cerune-mir: v1 fn_0 bb0 i6 -> lir 15 (source)
cerune_origin_mir_fn_0_bb0_i6_lir15:
  movq %rax, %rdx
  movq -40(%rbp), %rcx
  callq cerune_string_concat
  testq %rdx, %rdx
  je .Lfn_0_concat_ok_3
  cmpq $1, %rdx
  jne .Lfn_0_concat_limit_3
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_0(%rip), %rdx
  movl $69, %r8d
  callq _write
  movl $7, %ecx
  int $0x29
.Lfn_0_concat_limit_3:
  cmpq $2, %rdx
  jne .Lfn_0_concat_failed_3
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_1(%rip), %rdx
  movl $70, %r8d
  callq _write
  movl $7, %ecx
  int $0x29
.Lfn_0_concat_failed_3:
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_2(%rip), %rdx
  movl $62, %r8d
  callq _write
  movl $7, %ecx
  int $0x29
.Lfn_0_concat_ok_3:
# cerune-origin: #1 bytes 19..39
cerune_origin_n1_fn_0_16:
# cerune-mir: v1 fn_0 bb0 i6 -> lir 16 (source)
cerune_origin_mir_fn_0_bb0_i6_lir16:
  movq %rax, -56(%rbp)
# cerune-origin: #18 bytes 19..39
cerune_origin_n18_fn_0_17:
# cerune-mir: v1 fn_0 bb0 i7 -> lir 17 (source)
cerune_origin_mir_fn_0_bb0_i7_lir17:
  movq -56(%rbp), %rax
# cerune-origin: #18 bytes 19..39
cerune_origin_n18_fn_0_18:
# cerune-mir: v1 fn_0 bb0 i7 -> lir 18 (source)
cerune_origin_mir_fn_0_bb0_i7_lir18:
  movq %rax, -64(%rbp)
# cerune-origin: #19 bytes 19..39
cerune_origin_n19_fn_0_19:
# cerune-mir: v1 fn_0 bb0 i8 -> lir 19 (source)
cerune_origin_mir_fn_0_bb0_i8_lir19:
  movq -64(%rbp), %rax
# cerune-origin: #19 bytes 19..39
cerune_origin_n19_fn_0_20:
# cerune-mir: v1 fn_0 bb0 i8 -> lir 20 (source)
cerune_origin_mir_fn_0_bb0_i8_lir20:
  movq %rax, -72(%rbp)
# cerune-origin: #20 bytes 19..39
cerune_origin_n20_fn_0_21:
# cerune-mir: v1 fn_0 bb0 i9 -> lir 21 (source)
cerune_origin_mir_fn_0_bb0_i9_lir21:
  movq -72(%rbp), %rax
# cerune-origin: #20 bytes 19..39
cerune_origin_n20_fn_0_22:
# cerune-mir: v1 fn_0 bb0 i9 -> lir 22 (source)
cerune_origin_mir_fn_0_bb0_i9_lir22:
  addq $112, %rsp
  popq %rbp
  retq
# cerune-origin: #20 bytes 19..39
cerune_origin_n20_fn_0_23:
# cerune-mir: v1 fn_0 bb1 block -> lir 23 (after-return)
cerune_origin_mir_fn_0_bb1_block_lir23:
.Lcerune_fn_0_block_1: # mir_block
# cerune-origin: synthetic
# cerune-mir: v1 fn_0 bb1 i10 -> lir 24 (function-end)
cerune_origin_mir_fn_0_bb1_i10_lir24:
  ud2

# cerune-origin: synthetic
.p2align 4
cerune_fn__ownership1_1:
  pushq %rbp
  movq %rsp, %rbp
  subq $96, %rsp
# cerune-origin: synthetic
# cerune-mir: v1 synthetic ABI setup/exit
  movq %rcx, -8(%rbp)
# cerune-origin: synthetic
# cerune-mir: v1 synthetic ABI setup/exit
  jmp .Lcerune_fn_1_block_0
# cerune-origin: synthetic
# cerune-mir: v1 fn_1 bb0 block -> lir 2 (function-entry)
cerune_origin_mir_fn_1_bb0_block_lir2:
.Lcerune_fn_1_block_0: # mir_block
# cerune-origin: #5 bytes 57..61
cerune_origin_n5_fn_1_3:
# cerune-mir: v1 fn_1 bb0 i0 -> lir 3 (source)
cerune_origin_mir_fn_1_bb0_i0_lir3:
  movq -8(%rbp), %rax
# cerune-origin: #5 bytes 57..61
cerune_origin_n5_fn_1_4:
# cerune-mir: v1 fn_1 bb0 i0 -> lir 4 (source)
cerune_origin_mir_fn_1_bb0_i0_lir4:
  movq %rax, -16(%rbp)
# cerune-origin: #22 bytes 57..61
cerune_origin_n22_fn_1_5:
# cerune-mir: v1 fn_1 bb0 i1 -> lir 5 (source)
cerune_origin_mir_fn_1_bb0_i1_lir5:
  movq -16(%rbp), %rax
# cerune-origin: #22 bytes 57..61
cerune_origin_n22_fn_1_6:
# cerune-mir: v1 fn_1 bb0 i1 -> lir 6 (source)
cerune_origin_mir_fn_1_bb0_i1_lir6:
  movq %rax, -24(%rbp)
# cerune-origin: #23 bytes 57..61
cerune_origin_n23_fn_1_7:
# cerune-mir: v1 fn_1 bb0 i2 -> lir 7 (source)
cerune_origin_mir_fn_1_bb0_i2_lir7:
  movq -24(%rbp), %rax
# cerune-origin: #23 bytes 57..61
cerune_origin_n23_fn_1_8:
# cerune-mir: v1 fn_1 bb0 i2 -> lir 8 (source)
cerune_origin_mir_fn_1_bb0_i2_lir8:
  movq %rax, -32(%rbp)
# cerune-origin: #24 bytes 57..61
cerune_origin_n24_fn_1_9:
# cerune-mir: v1 fn_1 bb0 i3 -> lir 9 (source)
cerune_origin_mir_fn_1_bb0_i3_lir9:
  movq -32(%rbp), %rax
# cerune-origin: #24 bytes 57..61
cerune_origin_n24_fn_1_10:
# cerune-mir: v1 fn_1 bb0 i3 -> lir 10 (source)
cerune_origin_mir_fn_1_bb0_i3_lir10:
  movq %rax, -40(%rbp)
# cerune-origin: #25 bytes 57..61
cerune_origin_n25_fn_1_11:
# cerune-mir: v1 fn_1 bb0 i4 -> lir 11 (source)
cerune_origin_mir_fn_1_bb0_i4_lir11:
  movq -40(%rbp), %rax
# cerune-origin: #25 bytes 57..61
cerune_origin_n25_fn_1_12:
# cerune-mir: v1 fn_1 bb0 i4 -> lir 12 (source)
cerune_origin_mir_fn_1_bb0_i4_lir12:
  movq %rax, -48(%rbp)
# cerune-origin: #26 bytes 57..61
cerune_origin_n26_fn_1_13:
# cerune-mir: v1 fn_1 bb0 i5 -> lir 13 (source)
cerune_origin_mir_fn_1_bb0_i5_lir13:
  movq -48(%rbp), %rax
# cerune-origin: #26 bytes 57..61
cerune_origin_n26_fn_1_14:
# cerune-mir: v1 fn_1 bb0 i5 -> lir 14 (source)
cerune_origin_mir_fn_1_bb0_i5_lir14:
  movq %rax, %rcx
  callq cerune_string_retain
# cerune-origin: #27 bytes 57..61
cerune_origin_n27_fn_1_15:
# cerune-mir: v1 fn_1 bb0 i6 -> lir 15 (source)
cerune_origin_mir_fn_1_bb0_i6_lir15:
  movq -40(%rbp), %rax
# cerune-origin: #27 bytes 57..61
cerune_origin_n27_fn_1_16:
# cerune-mir: v1 fn_1 bb0 i6 -> lir 16 (source)
cerune_origin_mir_fn_1_bb0_i6_lir16:
  movq %rax, -56(%rbp)
# cerune-origin: #28 bytes 57..61
cerune_origin_n28_fn_1_17:
# cerune-mir: v1 fn_1 bb0 i7 -> lir 17 (source)
cerune_origin_mir_fn_1_bb0_i7_lir17:
  movq -56(%rbp), %rax
# cerune-origin: #28 bytes 57..61
cerune_origin_n28_fn_1_18:
# cerune-mir: v1 fn_1 bb0 i7 -> lir 18 (source)
cerune_origin_mir_fn_1_bb0_i7_lir18:
  addq $96, %rsp
  popq %rbp
  retq
# cerune-origin: #28 bytes 57..61
cerune_origin_n28_fn_1_19:
# cerune-mir: v1 fn_1 bb1 block -> lir 19 (after-return)
cerune_origin_mir_fn_1_bb1_block_lir19:
.Lcerune_fn_1_block_1: # mir_block
# cerune-origin: synthetic
# cerune-mir: v1 fn_1 bb1 i8 -> lir 20 (function-end)
cerune_origin_mir_fn_1_bb1_i8_lir20:
  ud2

# cerune-origin: synthetic
.p2align 4
cerune_fn__ownership2_2:
  pushq %rbp
  movq %rsp, %rbp
  subq $112, %rsp
# cerune-origin: synthetic
# cerune-mir: v1 synthetic ABI setup/exit
  movq %rcx, -8(%rbp)
# cerune-origin: synthetic
# cerune-mir: v1 synthetic ABI setup/exit
  jmp .Lcerune_fn_2_block_0
# cerune-origin: synthetic
# cerune-mir: v1 fn_2 bb0 block -> lir 2 (function-entry)
cerune_origin_mir_fn_2_bb0_block_lir2:
.Lcerune_fn_2_block_0: # mir_block
# cerune-origin: #8 bytes 77..81
cerune_origin_n8_fn_2_3:
# cerune-mir: v1 fn_2 bb0 i0 -> lir 3 (source)
cerune_origin_mir_fn_2_bb0_i0_lir3:
  movq -8(%rbp), %rax
# cerune-origin: #8 bytes 77..81
cerune_origin_n8_fn_2_4:
# cerune-mir: v1 fn_2 bb0 i0 -> lir 4 (source)
cerune_origin_mir_fn_2_bb0_i0_lir4:
  movq %rax, -16(%rbp)
# cerune-origin: #32 bytes 77..81
cerune_origin_n32_fn_2_5:
# cerune-mir: v1 fn_2 bb0 i1 -> lir 5 (source)
cerune_origin_mir_fn_2_bb0_i1_lir5:
  movq -16(%rbp), %rax
# cerune-origin: #32 bytes 77..81
cerune_origin_n32_fn_2_6:
# cerune-mir: v1 fn_2 bb0 i1 -> lir 6 (source)
cerune_origin_mir_fn_2_bb0_i1_lir6:
  movq %rax, -24(%rbp)
# cerune-origin: #9 bytes 83..86
cerune_origin_n9_fn_2_7:
# cerune-mir: v1 fn_2 bb0 i2 -> lir 7 (source)
cerune_origin_mir_fn_2_bb0_i2_lir7:
  leaq .Lcerune_string_2(%rip), %rax
# cerune-origin: #9 bytes 83..86
cerune_origin_n9_fn_2_8:
# cerune-mir: v1 fn_2 bb0 i2 -> lir 8 (source)
cerune_origin_mir_fn_2_bb0_i2_lir8:
  movq %rax, -32(%rbp)
# cerune-origin: #34 bytes 83..86
cerune_origin_n34_fn_2_9:
# cerune-mir: v1 fn_2 bb0 i3 -> lir 9 (source)
cerune_origin_mir_fn_2_bb0_i3_lir9:
  movq -32(%rbp), %rax
# cerune-origin: #34 bytes 83..86
cerune_origin_n34_fn_2_10:
# cerune-mir: v1 fn_2 bb0 i3 -> lir 10 (source)
cerune_origin_mir_fn_2_bb0_i3_lir10:
  movq %rax, -40(%rbp)
# cerune-origin: #33 bytes 77..81
cerune_origin_n33_fn_2_11:
# cerune-mir: v1 fn_2 bb0 i4 -> lir 11 (source)
cerune_origin_mir_fn_2_bb0_i4_lir11:
  movq -24(%rbp), %rax
# cerune-origin: #33 bytes 77..81
cerune_origin_n33_fn_2_12:
# cerune-mir: v1 fn_2 bb0 i4 -> lir 12 (source)
cerune_origin_mir_fn_2_bb0_i4_lir12:
  movq %rax, -48(%rbp)
# cerune-origin: #35 bytes 83..86
cerune_origin_n35_fn_2_13:
# cerune-mir: v1 fn_2 bb0 i5 -> lir 13 (source)
cerune_origin_mir_fn_2_bb0_i5_lir13:
  movq -40(%rbp), %rax
# cerune-origin: #35 bytes 83..86
cerune_origin_n35_fn_2_14:
# cerune-mir: v1 fn_2 bb0 i5 -> lir 14 (source)
cerune_origin_mir_fn_2_bb0_i5_lir14:
  movq %rax, -56(%rbp)
# cerune-origin: #7 bytes 70..87
cerune_origin_n7_fn_2_15:
# cerune-mir: v1 fn_2 bb0 i6 -> lir 15 (source)
cerune_origin_mir_fn_2_bb0_i6_lir15:
  movq -56(%rbp), %rax
# cerune-origin: #7 bytes 70..87
cerune_origin_n7_fn_2_16:
# cerune-mir: v1 fn_2 bb0 i6 -> lir 16 (source)
cerune_origin_mir_fn_2_bb0_i6_lir16:
  movq %rax, %rdx
  movq -48(%rbp), %rcx
  callq cerune_string_concat
  testq %rdx, %rdx
  je .Lfn_2_concat_ok_3
  cmpq $1, %rdx
  jne .Lfn_2_concat_limit_3
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_3(%rip), %rdx
  movl $69, %r8d
  callq _write
  movl $7, %ecx
  int $0x29
.Lfn_2_concat_limit_3:
  cmpq $2, %rdx
  jne .Lfn_2_concat_failed_3
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_4(%rip), %rdx
  movl $70, %r8d
  callq _write
  movl $7, %ecx
  int $0x29
.Lfn_2_concat_failed_3:
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_5(%rip), %rdx
  movl $62, %r8d
  callq _write
  movl $7, %ecx
  int $0x29
.Lfn_2_concat_ok_3:
# cerune-origin: #7 bytes 70..87
cerune_origin_n7_fn_2_17:
# cerune-mir: v1 fn_2 bb0 i6 -> lir 17 (source)
cerune_origin_mir_fn_2_bb0_i6_lir17:
  movq %rax, -64(%rbp)
# cerune-origin: #36 bytes 70..87
cerune_origin_n36_fn_2_18:
# cerune-mir: v1 fn_2 bb0 i7 -> lir 18 (source)
cerune_origin_mir_fn_2_bb0_i7_lir18:
  movq -64(%rbp), %rax
# cerune-origin: #36 bytes 70..87
cerune_origin_n36_fn_2_19:
# cerune-mir: v1 fn_2 bb0 i7 -> lir 19 (source)
cerune_origin_mir_fn_2_bb0_i7_lir19:
  movq %rax, -72(%rbp)
# cerune-origin: #37 bytes 70..87
cerune_origin_n37_fn_2_20:
# cerune-mir: v1 fn_2 bb0 i8 -> lir 20 (source)
cerune_origin_mir_fn_2_bb0_i8_lir20:
  movq -72(%rbp), %rax
# cerune-origin: #37 bytes 70..87
cerune_origin_n37_fn_2_21:
# cerune-mir: v1 fn_2 bb0 i8 -> lir 21 (source)
cerune_origin_mir_fn_2_bb0_i8_lir21:
  movq %rax, -80(%rbp)
# cerune-origin: #38 bytes 70..87
cerune_origin_n38_fn_2_22:
# cerune-mir: v1 fn_2 bb0 i9 -> lir 22 (source)
cerune_origin_mir_fn_2_bb0_i9_lir22:
  movq -80(%rbp), %rax
# cerune-origin: #38 bytes 70..87
cerune_origin_n38_fn_2_23:
# cerune-mir: v1 fn_2 bb0 i9 -> lir 23 (source)
cerune_origin_mir_fn_2_bb0_i9_lir23:
  addq $112, %rsp
  popq %rbp
  retq
# cerune-origin: #38 bytes 70..87
cerune_origin_n38_fn_2_24:
# cerune-mir: v1 fn_2 bb1 block -> lir 24 (after-return)
cerune_origin_mir_fn_2_bb1_block_lir24:
.Lcerune_fn_2_block_1: # mir_block
# cerune-origin: synthetic
# cerune-mir: v1 fn_2 bb1 i10 -> lir 25 (function-end)
cerune_origin_mir_fn_2_bb1_i10_lir25:
  ud2

# cerune-origin: synthetic
.p2align 4
cerune_fn__ownership3_3:
  pushq %rbp
  movq %rsp, %rbp
  subq $64, %rsp
# cerune-origin: synthetic
# cerune-mir: v1 synthetic ABI setup/exit
  movq %rcx, -8(%rbp)
# cerune-origin: synthetic
# cerune-mir: v1 synthetic ABI setup/exit
  movq %rdx, -16(%rbp)
# cerune-origin: synthetic
# cerune-mir: v1 synthetic ABI setup/exit
  jmp .Lcerune_fn_3_block_0
# cerune-origin: synthetic
# cerune-mir: v1 fn_3 bb0 block -> lir 3 (function-entry)
cerune_origin_mir_fn_3_bb0_block_lir3:
.Lcerune_fn_3_block_0: # mir_block
# cerune-origin: #41 bytes 70..87
cerune_origin_n41_fn_3_4:
# cerune-mir: v1 fn_3 bb0 i0 -> lir 4 (source)
cerune_origin_mir_fn_3_bb0_i0_lir4:
  movq -8(%rbp), %rax
# cerune-origin: #41 bytes 70..87
cerune_origin_n41_fn_3_5:
# cerune-mir: v1 fn_3 bb0 i0 -> lir 5 (source)
cerune_origin_mir_fn_3_bb0_i0_lir5:
  movq %rax, -24(%rbp)
# cerune-origin: #42 bytes 70..87
cerune_origin_n42_fn_3_6:
# cerune-mir: v1 fn_3 bb0 i1 -> lir 6 (source)
cerune_origin_mir_fn_3_bb0_i1_lir6:
  movq -24(%rbp), %rax
# cerune-origin: #42 bytes 70..87
cerune_origin_n42_fn_3_7:
# cerune-mir: v1 fn_3 bb0 i1 -> lir 7 (source)
cerune_origin_mir_fn_3_bb0_i1_lir7:
  movq %rax, %rcx
  callq cerune_string_release
# cerune-origin: #43 bytes 70..87
cerune_origin_n43_fn_3_8:
# cerune-mir: v1 fn_3 bb0 i2 -> lir 8 (source)
cerune_origin_mir_fn_3_bb0_i2_lir8:
  movq -16(%rbp), %rax
# cerune-origin: #43 bytes 70..87
cerune_origin_n43_fn_3_9:
# cerune-mir: v1 fn_3 bb0 i2 -> lir 9 (source)
cerune_origin_mir_fn_3_bb0_i2_lir9:
  movq %rax, -32(%rbp)
# cerune-origin: #44 bytes 70..87
cerune_origin_n44_fn_3_10:
# cerune-mir: v1 fn_3 bb0 i3 -> lir 10 (source)
cerune_origin_mir_fn_3_bb0_i3_lir10:
  movq -32(%rbp), %rax
# cerune-origin: #44 bytes 70..87
cerune_origin_n44_fn_3_11:
# cerune-mir: v1 fn_3 bb0 i3 -> lir 11 (source)
cerune_origin_mir_fn_3_bb0_i3_lir11:
  addq $64, %rsp
  popq %rbp
  retq
# cerune-origin: #44 bytes 70..87
cerune_origin_n44_fn_3_12:
# cerune-mir: v1 fn_3 bb1 block -> lir 12 (after-return)
cerune_origin_mir_fn_3_bb1_block_lir12:
.Lcerune_fn_3_block_1: # mir_block
# cerune-origin: synthetic
# cerune-mir: v1 fn_3 bb1 i4 -> lir 13 (function-end)
cerune_origin_mir_fn_3_bb1_i4_lir13:
  ud2

# cerune-origin: synthetic
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
# cerune-origin: synthetic
# cerune-mir: v1 synthetic ABI setup/exit
  jmp .Lcerune_block_0
# cerune-origin: synthetic
# cerune-mir: v1 main bb0 block -> lir 1 (function-entry)
cerune_origin_mir_main_bb0_block_lir1:
.Lcerune_block_0: # mir_block
# cerune-origin: #21 bytes 19..39
cerune_origin_n21_main_2:
# cerune-mir: v1 main bb0 i0 -> lir 2 (source)
cerune_origin_mir_main_bb0_i0_lir2:
  callq cerune_fn__ownership0_0
# cerune-origin: #21 bytes 19..39
cerune_origin_n21_main_3:
# cerune-mir: v1 main bb0 i0 -> lir 3 (source)
cerune_origin_mir_main_bb0_i0_lir3:
  movq %rax, -8(%rbp)
# cerune-origin: #0 bytes 0..40
cerune_origin_n0_main_4:
# cerune-mir: v1 main bb0 i1 -> lir 4 (source)
cerune_origin_mir_main_bb0_i1_lir4:
  movq -8(%rbp), %rax
# cerune-origin: #0 bytes 0..40
cerune_origin_n0_main_5:
# cerune-mir: v1 main bb0 i1 -> lir 5 (source)
cerune_origin_mir_main_bb0_i1_lir5:
  movq %rax, -16(%rbp)
# cerune-origin: #29 bytes 57..61
cerune_origin_n29_main_6:
# cerune-mir: v1 main bb0 i2 -> lir 6 (source)
cerune_origin_mir_main_bb0_i2_lir6:
  movq -16(%rbp), %rax
# cerune-origin: #29 bytes 57..61
cerune_origin_n29_main_7:
# cerune-mir: v1 main bb0 i2 -> lir 7 (source)
cerune_origin_mir_main_bb0_i2_lir7:
  movq %rax, -24(%rbp)
# cerune-origin: #30 bytes 57..61
cerune_origin_n30_main_8:
# cerune-mir: v1 main bb0 i3 -> lir 8 (source)
cerune_origin_mir_main_bb0_i3_lir8:
  movq -24(%rbp), %rcx
  callq cerune_fn__ownership1_1
# cerune-origin: #30 bytes 57..61
cerune_origin_n30_main_9:
# cerune-mir: v1 main bb0 i3 -> lir 9 (source)
cerune_origin_mir_main_bb0_i3_lir9:
  movq %rax, -32(%rbp)
# cerune-origin: #4 bytes 41..62
cerune_origin_n4_main_10:
# cerune-mir: v1 main bb0 i4 -> lir 10 (source)
cerune_origin_mir_main_bb0_i4_lir10:
  movq -32(%rbp), %rax
# cerune-origin: #4 bytes 41..62
cerune_origin_n4_main_11:
# cerune-mir: v1 main bb0 i4 -> lir 11 (source)
cerune_origin_mir_main_bb0_i4_lir11:
  movq %rax, -40(%rbp)
# cerune-origin: #31 bytes 63..88
cerune_origin_n31_main_12:
# cerune-mir: v1 main bb0 i5 -> lir 12 (source)
cerune_origin_mir_main_bb0_i5_lir12:
  movq -16(%rbp), %rax
# cerune-origin: #31 bytes 63..88
cerune_origin_n31_main_13:
# cerune-mir: v1 main bb0 i5 -> lir 13 (source)
cerune_origin_mir_main_bb0_i5_lir13:
  movq %rax, -48(%rbp)
# cerune-origin: #39 bytes 77..81
cerune_origin_n39_main_14:
# cerune-mir: v1 main bb0 i6 -> lir 14 (source)
cerune_origin_mir_main_bb0_i6_lir14:
  movq -16(%rbp), %rax
# cerune-origin: #39 bytes 77..81
cerune_origin_n39_main_15:
# cerune-mir: v1 main bb0 i6 -> lir 15 (source)
cerune_origin_mir_main_bb0_i6_lir15:
  movq %rax, -56(%rbp)
# cerune-origin: #40 bytes 70..87
cerune_origin_n40_main_16:
# cerune-mir: v1 main bb0 i7 -> lir 16 (source)
cerune_origin_mir_main_bb0_i7_lir16:
  movq -56(%rbp), %rcx
  callq cerune_fn__ownership2_2
# cerune-origin: #40 bytes 70..87
cerune_origin_n40_main_17:
# cerune-mir: v1 main bb0 i7 -> lir 17 (source)
cerune_origin_mir_main_bb0_i7_lir17:
  movq %rax, -64(%rbp)
# cerune-origin: #45 bytes 70..87
cerune_origin_n45_main_18:
# cerune-mir: v1 main bb0 i8 -> lir 18 (source)
cerune_origin_mir_main_bb0_i8_lir18:
  movq -48(%rbp), %rcx
  movq -64(%rbp), %rdx
  callq cerune_fn__ownership3_3
# cerune-origin: #45 bytes 70..87
cerune_origin_n45_main_19:
# cerune-mir: v1 main bb0 i8 -> lir 19 (source)
cerune_origin_mir_main_bb0_i8_lir19:
  movq %rax, -72(%rbp)
# cerune-origin: #6 bytes 63..88
cerune_origin_n6_main_20:
# cerune-mir: v1 main bb0 i9 -> lir 20 (source)
cerune_origin_mir_main_bb0_i9_lir20:
  movq -72(%rbp), %rax
# cerune-origin: #6 bytes 63..88
cerune_origin_n6_main_21:
# cerune-mir: v1 main bb0 i9 -> lir 21 (source)
cerune_origin_mir_main_bb0_i9_lir21:
  movq %rax, -16(%rbp)
# cerune-origin: #11 bytes 95..100
cerune_origin_n11_main_22:
# cerune-mir: v1 main bb0 i10 -> lir 22 (source)
cerune_origin_mir_main_bb0_i10_lir22:
  movq -40(%rbp), %rax
# cerune-origin: #11 bytes 95..100
cerune_origin_n11_main_23:
# cerune-mir: v1 main bb0 i10 -> lir 23 (source)
cerune_origin_mir_main_bb0_i10_lir23:
  movq %rax, -80(%rbp)
# cerune-origin: #46 bytes 95..100
cerune_origin_n46_main_24:
# cerune-mir: v1 main bb0 i11 -> lir 24 (source)
cerune_origin_mir_main_bb0_i11_lir24:
  movq -80(%rbp), %rax
# cerune-origin: #46 bytes 95..100
cerune_origin_n46_main_25:
# cerune-mir: v1 main bb0 i11 -> lir 25 (source)
cerune_origin_mir_main_bb0_i11_lir25:
  movq %rax, -88(%rbp)
# cerune-origin: #48 bytes 95..100
cerune_origin_n48_main_26:
# cerune-mir: v1 main bb0 i12 -> lir 26 (source)
cerune_origin_mir_main_bb0_i12_lir26:
  movq -88(%rbp), %rax
# cerune-origin: #48 bytes 95..100
cerune_origin_n48_main_27:
# cerune-mir: v1 main bb0 i12 -> lir 27 (source)
cerune_origin_mir_main_bb0_i12_lir27:
  movq %rax, -96(%rbp)
# cerune-origin: #10 bytes 89..102
cerune_origin_n10_main_28:
# cerune-mir: v1 main bb0 i13 -> lir 28 (source)
cerune_origin_mir_main_bb0_i13_lir28:
  movq -96(%rbp), %rax
# cerune-origin: #10 bytes 89..102
cerune_origin_n10_main_29:
# cerune-mir: v1 main bb0 i13 -> lir 29 (source)
cerune_origin_mir_main_bb0_i13_lir29:
  movq %rax, %rcx
  callq cerune_print_string
# cerune-origin: #13 bytes 109..113
cerune_origin_n13_main_30:
# cerune-mir: v1 main bb0 i14 -> lir 30 (source)
cerune_origin_mir_main_bb0_i14_lir30:
  movq -16(%rbp), %rax
# cerune-origin: #13 bytes 109..113
cerune_origin_n13_main_31:
# cerune-mir: v1 main bb0 i14 -> lir 31 (source)
cerune_origin_mir_main_bb0_i14_lir31:
  movq %rax, -104(%rbp)
# cerune-origin: #49 bytes 109..113
cerune_origin_n49_main_32:
# cerune-mir: v1 main bb0 i15 -> lir 32 (source)
cerune_origin_mir_main_bb0_i15_lir32:
  movq -104(%rbp), %rax
# cerune-origin: #49 bytes 109..113
cerune_origin_n49_main_33:
# cerune-mir: v1 main bb0 i15 -> lir 33 (source)
cerune_origin_mir_main_bb0_i15_lir33:
  movq %rax, -112(%rbp)
# cerune-origin: #51 bytes 109..113
cerune_origin_n51_main_34:
# cerune-mir: v1 main bb0 i16 -> lir 34 (source)
cerune_origin_mir_main_bb0_i16_lir34:
  movq -112(%rbp), %rax
# cerune-origin: #51 bytes 109..113
cerune_origin_n51_main_35:
# cerune-mir: v1 main bb0 i16 -> lir 35 (source)
cerune_origin_mir_main_bb0_i16_lir35:
  movq %rax, -120(%rbp)
# cerune-origin: #12 bytes 103..115
cerune_origin_n12_main_36:
# cerune-mir: v1 main bb0 i17 -> lir 36 (source)
cerune_origin_mir_main_bb0_i17_lir36:
  movq -120(%rbp), %rax
# cerune-origin: #12 bytes 103..115
cerune_origin_n12_main_37:
# cerune-mir: v1 main bb0 i17 -> lir 37 (source)
cerune_origin_mir_main_bb0_i17_lir37:
  movq %rax, %rcx
  callq cerune_print_string
# cerune-origin: #52 bytes 41..62
cerune_origin_n52_main_38:
# cerune-mir: v1 main bb0 i18 -> lir 38 (source)
cerune_origin_mir_main_bb0_i18_lir38:
  movq -40(%rbp), %rax
# cerune-origin: #52 bytes 41..62
cerune_origin_n52_main_39:
# cerune-mir: v1 main bb0 i18 -> lir 39 (source)
cerune_origin_mir_main_bb0_i18_lir39:
  movq %rax, -128(%rbp)
# cerune-origin: #53 bytes 41..62
cerune_origin_n53_main_40:
# cerune-mir: v1 main bb0 i19 -> lir 40 (source)
cerune_origin_mir_main_bb0_i19_lir40:
  movq -128(%rbp), %rax
# cerune-origin: #53 bytes 41..62
cerune_origin_n53_main_41:
# cerune-mir: v1 main bb0 i19 -> lir 41 (source)
cerune_origin_mir_main_bb0_i19_lir41:
  movq %rax, %rcx
  callq cerune_string_release
# cerune-origin: #54 bytes 0..40
cerune_origin_n54_main_42:
# cerune-mir: v1 main bb0 i20 -> lir 42 (source)
cerune_origin_mir_main_bb0_i20_lir42:
  movq -16(%rbp), %rax
# cerune-origin: #54 bytes 0..40
cerune_origin_n54_main_43:
# cerune-mir: v1 main bb0 i20 -> lir 43 (source)
cerune_origin_mir_main_bb0_i20_lir43:
  movq %rax, -136(%rbp)
# cerune-origin: #55 bytes 0..40
cerune_origin_n55_main_44:
# cerune-mir: v1 main bb0 i21 -> lir 44 (source)
cerune_origin_mir_main_bb0_i21_lir44:
  movq -136(%rbp), %rax
# cerune-origin: #55 bytes 0..40
cerune_origin_n55_main_45:
# cerune-mir: v1 main bb0 i21 -> lir 45 (source)
cerune_origin_mir_main_bb0_i21_lir45:
  movq %rax, %rcx
  callq cerune_string_release
# cerune-origin: synthetic
# cerune-mir: v1 main bb0 i22 -> lir 46 (function-end)
cerune_origin_mir_main_bb0_i22_lir46:
  jmp .Lcerune_block_1
# cerune-origin: synthetic
# cerune-mir: v1 synthetic ABI setup/exit
.Lcerune_block_1: # main_exit
# cerune-origin: synthetic
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
