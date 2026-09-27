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
  subq $144, %rsp
# cerune-origin: #2 bytes 26..31
cerune_origin_n2_fn_0_0:
  leaq .Lcerune_string_0(%rip), %rax
# cerune-origin: #14 bytes 26..31
cerune_origin_n14_fn_0_1:
  movq %rax, -8(%rbp)
# cerune-origin: #15 bytes 26..31
cerune_origin_n15_fn_0_2:
  movq -8(%rbp), %rax
# cerune-origin: #16 bytes 26..31
cerune_origin_n16_fn_0_3:
  movq %rax, %rcx
  callq cerune_string_retain
# cerune-origin: #3 bytes 33..38
cerune_origin_n3_fn_0_4:
  leaq .Lcerune_string_1(%rip), %rax
# cerune-origin: #19 bytes 33..38
cerune_origin_n19_fn_0_5:
  movq %rax, -16(%rbp)
# cerune-origin: #20 bytes 33..38
cerune_origin_n20_fn_0_6:
  movq -16(%rbp), %rax
# cerune-origin: #21 bytes 33..38
cerune_origin_n21_fn_0_7:
  movq %rax, %rcx
  callq cerune_string_retain
# cerune-origin: #17 bytes 26..31
cerune_origin_n17_fn_0_8:
  movq -8(%rbp), %rax
# cerune-origin: #1 bytes 19..39
cerune_origin_n1_fn_0_9:
  movq %rax, -32(%rbp)
# cerune-origin: #22 bytes 33..38
cerune_origin_n22_fn_0_10:
  movq -16(%rbp), %rax
# cerune-origin: #1 bytes 19..39
cerune_origin_n1_fn_0_11:
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
# cerune-origin: #24 bytes 19..39
cerune_origin_n24_fn_0_12:
  movq %rax, -24(%rbp)
# cerune-origin: #23 bytes 33..38
cerune_origin_n23_fn_0_13:
  movq -16(%rbp), %rax
# cerune-origin: #25 bytes 33..38
cerune_origin_n25_fn_0_14:
  movq %rax, %rcx
  callq cerune_string_release
# cerune-origin: #18 bytes 26..31
cerune_origin_n18_fn_0_15:
  movq -8(%rbp), %rax
# cerune-origin: #26 bytes 26..31
cerune_origin_n26_fn_0_16:
  movq %rax, %rcx
  callq cerune_string_release
# cerune-origin: #27 bytes 19..39
cerune_origin_n27_fn_0_17:
  movq -24(%rbp), %rax
# cerune-origin: #28 bytes 19..39
cerune_origin_n28_fn_0_18:
  addq $144, %rsp
  popq %rbp
  retq

# cerune-origin: synthetic
.p2align 4
cerune_fn__ownership1_1:
  pushq %rbp
  movq %rsp, %rbp
  subq $80, %rsp
# cerune-origin: synthetic
  movq %rcx, -8(%rbp)
# cerune-origin: #5 bytes 57..61
cerune_origin_n5_fn_1_1:
  movq -8(%rbp), %rax
# cerune-origin: #30 bytes 57..61
cerune_origin_n30_fn_1_2:
  movq %rax, -16(%rbp)
# cerune-origin: #31 bytes 57..61
cerune_origin_n31_fn_1_3:
  movq -16(%rbp), %rax
# cerune-origin: #32 bytes 57..61
cerune_origin_n32_fn_1_4:
  movq %rax, %rcx
  callq cerune_string_retain
# cerune-origin: #33 bytes 57..61
cerune_origin_n33_fn_1_5:
  movq -16(%rbp), %rax
# cerune-origin: #34 bytes 57..61
cerune_origin_n34_fn_1_6:
  addq $80, %rsp
  popq %rbp
  retq

# cerune-origin: synthetic
.p2align 4
cerune_fn__ownership2_2:
  pushq %rbp
  movq %rsp, %rbp
  subq $144, %rsp
# cerune-origin: synthetic
  movq %rcx, -8(%rbp)
# cerune-origin: #8 bytes 77..81
cerune_origin_n8_fn_2_1:
  movq -8(%rbp), %rax
# cerune-origin: #38 bytes 77..81
cerune_origin_n38_fn_2_2:
  movq %rax, -16(%rbp)
# cerune-origin: #39 bytes 77..81
cerune_origin_n39_fn_2_3:
  movq -16(%rbp), %rax
# cerune-origin: #40 bytes 77..81
cerune_origin_n40_fn_2_4:
  movq %rax, %rcx
  callq cerune_string_retain
# cerune-origin: #9 bytes 83..86
cerune_origin_n9_fn_2_5:
  leaq .Lcerune_string_2(%rip), %rax
# cerune-origin: #43 bytes 83..86
cerune_origin_n43_fn_2_6:
  movq %rax, -24(%rbp)
# cerune-origin: #44 bytes 83..86
cerune_origin_n44_fn_2_7:
  movq -24(%rbp), %rax
# cerune-origin: #45 bytes 83..86
cerune_origin_n45_fn_2_8:
  movq %rax, %rcx
  callq cerune_string_retain
# cerune-origin: #41 bytes 77..81
cerune_origin_n41_fn_2_9:
  movq -16(%rbp), %rax
# cerune-origin: #7 bytes 70..87
cerune_origin_n7_fn_2_10:
  movq %rax, -40(%rbp)
# cerune-origin: #46 bytes 83..86
cerune_origin_n46_fn_2_11:
  movq -24(%rbp), %rax
# cerune-origin: #7 bytes 70..87
cerune_origin_n7_fn_2_12:
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
# cerune-origin: #48 bytes 70..87
cerune_origin_n48_fn_2_13:
  movq %rax, -32(%rbp)
# cerune-origin: #47 bytes 83..86
cerune_origin_n47_fn_2_14:
  movq -24(%rbp), %rax
# cerune-origin: #49 bytes 83..86
cerune_origin_n49_fn_2_15:
  movq %rax, %rcx
  callq cerune_string_release
# cerune-origin: #42 bytes 77..81
cerune_origin_n42_fn_2_16:
  movq -16(%rbp), %rax
# cerune-origin: #50 bytes 77..81
cerune_origin_n50_fn_2_17:
  movq %rax, %rcx
  callq cerune_string_release
# cerune-origin: #51 bytes 70..87
cerune_origin_n51_fn_2_18:
  movq -32(%rbp), %rax
# cerune-origin: #52 bytes 70..87
cerune_origin_n52_fn_2_19:
  addq $144, %rsp
  popq %rbp
  retq

# cerune-origin: synthetic
.p2align 4
cerune_fn__ownership3_3:
  pushq %rbp
  movq %rsp, %rbp
  subq $64, %rsp
# cerune-origin: synthetic
  movq %rcx, -8(%rbp)
# cerune-origin: synthetic
  movq %rdx, -16(%rbp)
# cerune-origin: #55 bytes 70..87
cerune_origin_n55_fn_3_2:
  movq -8(%rbp), %rax
# cerune-origin: #56 bytes 70..87
cerune_origin_n56_fn_3_3:
  movq %rax, %rcx
  callq cerune_string_release
# cerune-origin: #57 bytes 70..87
cerune_origin_n57_fn_3_4:
  movq -16(%rbp), %rax
# cerune-origin: #58 bytes 70..87
cerune_origin_n58_fn_3_5:
  addq $64, %rsp
  popq %rbp
  retq

# cerune-origin: synthetic
.p2align 4
cerune_fn__ownership4_4:
  pushq %rbp
  movq %rsp, %rbp
  subq $80, %rsp
# cerune-origin: synthetic
  movq %rcx, -8(%rbp)
# cerune-origin: #11 bytes 95..100
cerune_origin_n11_fn_4_1:
  movq -8(%rbp), %rax
# cerune-origin: #60 bytes 95..100
cerune_origin_n60_fn_4_2:
  movq %rax, -16(%rbp)
# cerune-origin: #61 bytes 95..100
cerune_origin_n61_fn_4_3:
  movq -16(%rbp), %rax
# cerune-origin: #62 bytes 95..100
cerune_origin_n62_fn_4_4:
  movq %rax, %rcx
  callq cerune_string_retain
# cerune-origin: #63 bytes 95..100
cerune_origin_n63_fn_4_5:
  movq -16(%rbp), %rax
# cerune-origin: #64 bytes 95..100
cerune_origin_n64_fn_4_6:
  addq $80, %rsp
  popq %rbp
  retq

# cerune-origin: synthetic
.p2align 4
cerune_fn__ownership5_5:
  pushq %rbp
  movq %rsp, %rbp
  subq $80, %rsp
# cerune-origin: synthetic
  movq %rcx, -8(%rbp)
# cerune-origin: #13 bytes 109..113
cerune_origin_n13_fn_5_1:
  movq -8(%rbp), %rax
# cerune-origin: #71 bytes 109..113
cerune_origin_n71_fn_5_2:
  movq %rax, -16(%rbp)
# cerune-origin: #72 bytes 109..113
cerune_origin_n72_fn_5_3:
  movq -16(%rbp), %rax
# cerune-origin: #73 bytes 109..113
cerune_origin_n73_fn_5_4:
  movq %rax, %rcx
  callq cerune_string_retain
# cerune-origin: #74 bytes 109..113
cerune_origin_n74_fn_5_5:
  movq -16(%rbp), %rax
# cerune-origin: #75 bytes 109..113
cerune_origin_n75_fn_5_6:
  addq $80, %rsp
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
# cerune-origin: #29 bytes 19..39
cerune_origin_n29_main_0:
  callq cerune_fn__ownership0_0
# cerune-origin: #0 bytes 0..40
cerune_origin_n0_main_1:
  movq %rax, -8(%rbp)
# cerune-origin: #35 bytes 57..61
cerune_origin_n35_main_2:
  movq -8(%rbp), %rax
# cerune-origin: #36 bytes 57..61
cerune_origin_n36_main_3:
  movq %rax, -40(%rbp)
# cerune-origin: #36 bytes 57..61
cerune_origin_n36_main_4:
  movq -40(%rbp), %rcx
  callq cerune_fn__ownership1_1
# cerune-origin: #4 bytes 41..62
cerune_origin_n4_main_5:
  movq %rax, -16(%rbp)
# cerune-origin: #37 bytes 63..88
cerune_origin_n37_main_6:
  movq -8(%rbp), %rax
# cerune-origin: #59 bytes 70..87
cerune_origin_n59_main_7:
  movq %rax, -40(%rbp)
# cerune-origin: #53 bytes 77..81
cerune_origin_n53_main_8:
  movq -8(%rbp), %rax
# cerune-origin: #54 bytes 70..87
cerune_origin_n54_main_9:
  movq %rax, -72(%rbp)
# cerune-origin: #54 bytes 70..87
cerune_origin_n54_main_10:
  movq -72(%rbp), %rcx
  callq cerune_fn__ownership2_2
# cerune-origin: #59 bytes 70..87
cerune_origin_n59_main_11:
  movq %rax, -48(%rbp)
# cerune-origin: #59 bytes 70..87
cerune_origin_n59_main_12:
  movq -40(%rbp), %rcx
  movq -48(%rbp), %rdx
  callq cerune_fn__ownership3_3
# cerune-origin: #6 bytes 63..88
cerune_origin_n6_main_13:
  movq %rax, -8(%rbp)
# cerune-origin: #65 bytes 95..100
cerune_origin_n65_main_14:
  movq -16(%rbp), %rax
# cerune-origin: #66 bytes 95..100
cerune_origin_n66_main_15:
  movq %rax, -40(%rbp)
# cerune-origin: #66 bytes 95..100
cerune_origin_n66_main_16:
  movq -40(%rbp), %rcx
  callq cerune_fn__ownership4_4
# cerune-origin: #67 bytes 95..100
cerune_origin_n67_main_17:
  movq %rax, -24(%rbp)
# cerune-origin: #68 bytes 95..100
cerune_origin_n68_main_18:
  movq -24(%rbp), %rax
# cerune-origin: #10 bytes 89..102
cerune_origin_n10_main_19:
  movq %rax, %rcx
  callq cerune_print_string
# cerune-origin: #69 bytes 95..100
cerune_origin_n69_main_20:
  movq -24(%rbp), %rax
# cerune-origin: #70 bytes 95..100
cerune_origin_n70_main_21:
  movq %rax, %rcx
  callq cerune_string_release
# cerune-origin: #76 bytes 109..113
cerune_origin_n76_main_22:
  movq -8(%rbp), %rax
# cerune-origin: #77 bytes 109..113
cerune_origin_n77_main_23:
  movq %rax, -40(%rbp)
# cerune-origin: #77 bytes 109..113
cerune_origin_n77_main_24:
  movq -40(%rbp), %rcx
  callq cerune_fn__ownership5_5
# cerune-origin: #78 bytes 109..113
cerune_origin_n78_main_25:
  movq %rax, -32(%rbp)
# cerune-origin: #79 bytes 109..113
cerune_origin_n79_main_26:
  movq -32(%rbp), %rax
# cerune-origin: #12 bytes 103..115
cerune_origin_n12_main_27:
  movq %rax, %rcx
  callq cerune_print_string
# cerune-origin: #80 bytes 109..113
cerune_origin_n80_main_28:
  movq -32(%rbp), %rax
# cerune-origin: #81 bytes 109..113
cerune_origin_n81_main_29:
  movq %rax, %rcx
  callq cerune_string_release
# cerune-origin: #82 bytes 41..62
cerune_origin_n82_main_30:
  movq -16(%rbp), %rax
# cerune-origin: #83 bytes 41..62
cerune_origin_n83_main_31:
  movq %rax, %rcx
  callq cerune_string_release
# cerune-origin: #84 bytes 0..40
cerune_origin_n84_main_32:
  movq -8(%rbp), %rax
# cerune-origin: #85 bytes 0..40
cerune_origin_n85_main_33:
  movq %rax, %rcx
  callq cerune_string_release
# cerune-origin: synthetic
  xorl %eax, %eax
  addq $208, %rsp
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
