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
.Lcerune_f64_0:
  .quad 0x4004000000000000
.p2align 3
.Lcerune_f64_1:
  .quad 0x4004000000000000
.p2align 3
.Lcerune_f64_2:
  .quad 0x4004000000000000
.p2align 3
.Lcerune_f64_3:
  .quad 0x4004000000000000
.p2align 3
.Lcerune_f64_4:
  .quad 0x4072C00000000000
.p2align 3
.Lcerune_f64_5:
  .quad 0x3FB999999999999A
.p2align 3
.Lcerune_f64_6:
  .quad 0x406FE33333333333
.p2align 3
.Lcerune_f64_7:
  .quad 0x406FF00000000000
.p2align 3
.Lcerune_f64_8:
  .quad 0x406FD00000000000

.text
# cerune-origin: synthetic
.p2align 4
cerune_fn_value_0:
  pushq %rbp
  movq %rsp, %rbp
  subq $48, %rsp
# cerune-origin: synthetic
# cerune-mir: v1 synthetic ABI setup/exit
  movsd %xmm0, -8(%rbp)
# cerune-origin: synthetic
# cerune-mir: v1 synthetic ABI setup/exit
  jmp .Lcerune_fn_0_block_0
# cerune-origin: synthetic
# cerune-mir: v1 fn_0 bb0 block -> lir 2 (function-entry)
cerune_origin_mir_fn_0_bb0_block_lir2:
.Lcerune_fn_0_block_0: # mir_block
# cerune-origin: #5 bytes 68..69
cerune_origin_n5_fn_0_3:
# cerune-mir: v1 fn_0 bb0 i0 -> lir 3 (source)
cerune_origin_mir_fn_0_bb0_i0_lir3:
  movsd -8(%rbp), %xmm0
# cerune-origin: #5 bytes 68..69
cerune_origin_n5_fn_0_4:
# cerune-mir: v1 fn_0 bb0 i0 -> lir 4 (source)
cerune_origin_mir_fn_0_bb0_i0_lir4:
  movsd %xmm0, -16(%rbp)
# cerune-origin: #4 bytes 61..70
cerune_origin_n4_fn_0_5:
# cerune-mir: v1 fn_0 bb0 i1 -> lir 5 (source)
cerune_origin_mir_fn_0_bb0_i1_lir5:
  movsd -16(%rbp), %xmm0
# cerune-origin: #4 bytes 61..70
cerune_origin_n4_fn_0_6:
# cerune-mir: v1 fn_0 bb0 i1 -> lir 6 (source)
cerune_origin_mir_fn_0_bb0_i1_lir6:
  addq $48, %rsp
  popq %rbp
  retq
# cerune-origin: #4 bytes 61..70
cerune_origin_n4_fn_0_7:
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
  subq $288, %rsp
# cerune-origin: synthetic
# cerune-mir: v1 synthetic ABI setup/exit
  jmp .Lcerune_block_0
# cerune-origin: synthetic
# cerune-mir: v1 main bb0 block -> lir 1 (function-entry)
cerune_origin_mir_main_bb0_block_lir1:
.Lcerune_block_0: # mir_block
# cerune-origin: #10 bytes 97..100
cerune_origin_n10_main_2:
# cerune-mir: v1 main bb0 i0 -> lir 2 (source)
cerune_origin_mir_main_bb0_i0_lir2:
  movsd .Lcerune_f64_0(%rip), %xmm0
# cerune-origin: #10 bytes 97..100
cerune_origin_n10_main_3:
# cerune-mir: v1 main bb0 i0 -> lir 3 (source)
cerune_origin_mir_main_bb0_i0_lir3:
  movsd %xmm0, -8(%rbp)
# cerune-origin: #9 bytes 96..100
cerune_origin_n9_main_4:
# cerune-mir: v1 main bb0 i1 -> lir 4 (source)
cerune_origin_mir_main_bb0_i1_lir4:
  movsd -8(%rbp), %xmm0
# cerune-origin: #9 bytes 96..100
cerune_origin_n9_main_5:
# cerune-mir: v1 main bb0 i1 -> lir 5 (source)
cerune_origin_mir_main_bb0_i1_lir5:
  xorpd .Lcerune_sign_f64(%rip), %xmm0
# cerune-origin: #9 bytes 96..100
cerune_origin_n9_main_6:
# cerune-mir: v1 main bb0 i1 -> lir 6 (source)
cerune_origin_mir_main_bb0_i1_lir6:
  movsd %xmm0, -16(%rbp)
# cerune-origin: #8 bytes 90..101
cerune_origin_n8_main_7:
# cerune-mir: v1 main bb0 i2 -> lir 7 (source)
cerune_origin_mir_main_bb0_i2_lir7:
  movsd -16(%rbp), %xmm0
  callq cerune_fn_value_0
# cerune-origin: #8 bytes 90..101
cerune_origin_n8_main_8:
# cerune-mir: v1 main bb0 i2 -> lir 8 (source)
cerune_origin_mir_main_bb0_i2_lir8:
  movsd %xmm0, -24(%rbp)
# cerune-origin: #7 bytes 79..102
cerune_origin_n7_main_9:
# cerune-mir: v1 main bb0 i3 -> lir 9 (source)
cerune_origin_mir_main_bb0_i3_lir9:
  movsd -24(%rbp), %xmm0
# cerune-origin: #7 bytes 79..102
cerune_origin_n7_main_10:
# cerune-mir: v1 main bb0 i3 -> lir 10 (source)
cerune_origin_mir_main_bb0_i3_lir10:
  # policy: floor
  movapd %xmm0, %xmm2
  ucomisd %xmm2, %xmm2
  jp .Lcerune_main_floor_2_nonfinite
  movabsq $9218868437227405312, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  je .Lcerune_main_floor_2_nonfinite
  movabsq $-4503599627370496, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  je .Lcerune_main_floor_2_nonfinite
  # round finite input; large values are already integral
  movabsq $4841369599423283200, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  jae .Lcerune_main_floor_2_bounds
  movabsq $-4382002437431492608, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  jbe .Lcerune_main_floor_2_bounds
  cvttsd2siq %xmm2, %rax
  cvtsi2sdq %rax, %xmm3
  subsd %xmm3, %xmm2
  movabsq $0, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  jb .Lcerune_main_floor_2_down
  jmp .Lcerune_main_floor_2_rounded
.Lcerune_main_floor_2_up:
  addq $1, %rax
  jmp .Lcerune_main_floor_2_rounded
.Lcerune_main_floor_2_down:
  subq $1, %rax
.Lcerune_main_floor_2_rounded:
  cvtsi2sdq %rax, %xmm2
.Lcerune_main_floor_2_bounds:
  # range policy after rounding, then convert
  movabsq $-4332462841530417152, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  jb .Lcerune_main_floor_2_minimum
  movabsq $4890909195324358656, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  jae .Lcerune_main_floor_2_maximum
  cvttsd2siq %xmm2, %rax
  jmp .Lcerune_main_floor_2_done
.Lcerune_main_floor_2_nonfinite:
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_0(%rip), %rdx
  movl $67, %r8d
  callq _write
  movl $7, %ecx
  int $0x29
.Lcerune_main_floor_2_minimum:
.Lcerune_main_floor_2_maximum:
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_1(%rip), %rdx
  movl $69, %r8d
  callq _write
  movl $7, %ecx
  int $0x29
.Lcerune_main_floor_2_done:
# cerune-origin: #7 bytes 79..102
cerune_origin_n7_main_11:
# cerune-mir: v1 main bb0 i3 -> lir 11 (source)
cerune_origin_mir_main_bb0_i3_lir11:
  movq %rax, -32(%rbp)
# cerune-origin: #6 bytes 73..104
cerune_origin_n6_main_12:
# cerune-mir: v1 main bb0 i4 -> lir 12 (source)
cerune_origin_mir_main_bb0_i4_lir12:
  movq -32(%rbp), %rax
# cerune-origin: #6 bytes 73..104
cerune_origin_n6_main_13:
# cerune-mir: v1 main bb0 i4 -> lir 13 (source)
cerune_origin_mir_main_bb0_i4_lir13:
  movq %rax, %rdx
# cerune-origin: #6 bytes 73..104
cerune_origin_n6_main_14:
# cerune-mir: v1 main bb0 i4 -> lir 14 (source)
cerune_origin_mir_main_bb0_i4_lir14:
  leaq .Lcerune_fmt_i64(%rip), %rcx
# cerune-origin: #6 bytes 73..104
cerune_origin_n6_main_15:
# cerune-mir: v1 main bb0 i4 -> lir 15 (source)
cerune_origin_mir_main_bb0_i4_lir15:
  callq printf
# cerune-origin: #15 bytes 128..131
cerune_origin_n15_main_16:
# cerune-mir: v1 main bb0 i5 -> lir 16 (source)
cerune_origin_mir_main_bb0_i5_lir16:
  movsd .Lcerune_f64_1(%rip), %xmm0
# cerune-origin: #15 bytes 128..131
cerune_origin_n15_main_17:
# cerune-mir: v1 main bb0 i5 -> lir 17 (source)
cerune_origin_mir_main_bb0_i5_lir17:
  movsd %xmm0, -40(%rbp)
# cerune-origin: #14 bytes 127..131
cerune_origin_n14_main_18:
# cerune-mir: v1 main bb0 i6 -> lir 18 (source)
cerune_origin_mir_main_bb0_i6_lir18:
  movsd -40(%rbp), %xmm0
# cerune-origin: #14 bytes 127..131
cerune_origin_n14_main_19:
# cerune-mir: v1 main bb0 i6 -> lir 19 (source)
cerune_origin_mir_main_bb0_i6_lir19:
  xorpd .Lcerune_sign_f64(%rip), %xmm0
# cerune-origin: #14 bytes 127..131
cerune_origin_n14_main_20:
# cerune-mir: v1 main bb0 i6 -> lir 20 (source)
cerune_origin_mir_main_bb0_i6_lir20:
  movsd %xmm0, -48(%rbp)
# cerune-origin: #13 bytes 121..132
cerune_origin_n13_main_21:
# cerune-mir: v1 main bb0 i7 -> lir 21 (source)
cerune_origin_mir_main_bb0_i7_lir21:
  movsd -48(%rbp), %xmm0
  callq cerune_fn_value_0
# cerune-origin: #13 bytes 121..132
cerune_origin_n13_main_22:
# cerune-mir: v1 main bb0 i7 -> lir 22 (source)
cerune_origin_mir_main_bb0_i7_lir22:
  movsd %xmm0, -56(%rbp)
# cerune-origin: #12 bytes 111..133
cerune_origin_n12_main_23:
# cerune-mir: v1 main bb0 i8 -> lir 23 (source)
cerune_origin_mir_main_bb0_i8_lir23:
  movsd -56(%rbp), %xmm0
# cerune-origin: #12 bytes 111..133
cerune_origin_n12_main_24:
# cerune-mir: v1 main bb0 i8 -> lir 24 (source)
cerune_origin_mir_main_bb0_i8_lir24:
  # policy: ceil
  movapd %xmm0, %xmm2
  ucomisd %xmm2, %xmm2
  jp .Lcerune_main_ceil_3_nonfinite
  movabsq $9218868437227405312, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  je .Lcerune_main_ceil_3_nonfinite
  movabsq $-4503599627370496, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  je .Lcerune_main_ceil_3_nonfinite
  # round finite input; large values are already integral
  movabsq $4841369599423283200, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  jae .Lcerune_main_ceil_3_bounds
  movabsq $-4382002437431492608, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  jbe .Lcerune_main_ceil_3_bounds
  cvttsd2siq %xmm2, %rax
  cvtsi2sdq %rax, %xmm3
  subsd %xmm3, %xmm2
  movabsq $0, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  ja .Lcerune_main_ceil_3_up
  jmp .Lcerune_main_ceil_3_rounded
.Lcerune_main_ceil_3_up:
  addq $1, %rax
  jmp .Lcerune_main_ceil_3_rounded
.Lcerune_main_ceil_3_down:
  subq $1, %rax
.Lcerune_main_ceil_3_rounded:
  cvtsi2sdq %rax, %xmm2
.Lcerune_main_ceil_3_bounds:
  # range policy after rounding, then convert
  movabsq $-4332462841530417152, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  jb .Lcerune_main_ceil_3_minimum
  movabsq $4890909195324358656, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  jae .Lcerune_main_ceil_3_maximum
  cvttsd2siq %xmm2, %rax
  jmp .Lcerune_main_ceil_3_done
.Lcerune_main_ceil_3_nonfinite:
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_2(%rip), %rdx
  movl $69, %r8d
  callq _write
  movl $7, %ecx
  int $0x29
.Lcerune_main_ceil_3_minimum:
.Lcerune_main_ceil_3_maximum:
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_3(%rip), %rdx
  movl $71, %r8d
  callq _write
  movl $7, %ecx
  int $0x29
.Lcerune_main_ceil_3_done:
# cerune-origin: #12 bytes 111..133
cerune_origin_n12_main_25:
# cerune-mir: v1 main bb0 i8 -> lir 25 (source)
cerune_origin_mir_main_bb0_i8_lir25:
  movq %rax, -64(%rbp)
# cerune-origin: #11 bytes 105..135
cerune_origin_n11_main_26:
# cerune-mir: v1 main bb0 i9 -> lir 26 (source)
cerune_origin_mir_main_bb0_i9_lir26:
  movq -64(%rbp), %rax
# cerune-origin: #11 bytes 105..135
cerune_origin_n11_main_27:
# cerune-mir: v1 main bb0 i9 -> lir 27 (source)
cerune_origin_mir_main_bb0_i9_lir27:
  movq %rax, %rdx
# cerune-origin: #11 bytes 105..135
cerune_origin_n11_main_28:
# cerune-mir: v1 main bb0 i9 -> lir 28 (source)
cerune_origin_mir_main_bb0_i9_lir28:
  leaq .Lcerune_fmt_i64(%rip), %rcx
# cerune-origin: #11 bytes 105..135
cerune_origin_n11_main_29:
# cerune-mir: v1 main bb0 i9 -> lir 29 (source)
cerune_origin_mir_main_bb0_i9_lir29:
  callq printf
# cerune-origin: #19 bytes 159..162
cerune_origin_n19_main_30:
# cerune-mir: v1 main bb0 i10 -> lir 30 (source)
cerune_origin_mir_main_bb0_i10_lir30:
  movsd .Lcerune_f64_2(%rip), %xmm0
# cerune-origin: #19 bytes 159..162
cerune_origin_n19_main_31:
# cerune-mir: v1 main bb0 i10 -> lir 31 (source)
cerune_origin_mir_main_bb0_i10_lir31:
  movsd %xmm0, -72(%rbp)
# cerune-origin: #18 bytes 153..163
cerune_origin_n18_main_32:
# cerune-mir: v1 main bb0 i11 -> lir 32 (source)
cerune_origin_mir_main_bb0_i11_lir32:
  movsd -72(%rbp), %xmm0
  callq cerune_fn_value_0
# cerune-origin: #18 bytes 153..163
cerune_origin_n18_main_33:
# cerune-mir: v1 main bb0 i11 -> lir 33 (source)
cerune_origin_mir_main_bb0_i11_lir33:
  movsd %xmm0, -80(%rbp)
# cerune-origin: #17 bytes 142..164
cerune_origin_n17_main_34:
# cerune-mir: v1 main bb0 i12 -> lir 34 (source)
cerune_origin_mir_main_bb0_i12_lir34:
  movsd -80(%rbp), %xmm0
# cerune-origin: #17 bytes 142..164
cerune_origin_n17_main_35:
# cerune-mir: v1 main bb0 i12 -> lir 35 (source)
cerune_origin_mir_main_bb0_i12_lir35:
  # policy: round
  movapd %xmm0, %xmm2
  ucomisd %xmm2, %xmm2
  jp .Lcerune_main_round_4_nonfinite
  movabsq $9218868437227405312, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  je .Lcerune_main_round_4_nonfinite
  movabsq $-4503599627370496, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  je .Lcerune_main_round_4_nonfinite
  # round finite input; large values are already integral
  movabsq $4841369599423283200, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  jae .Lcerune_main_round_4_bounds
  movabsq $-4382002437431492608, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  jbe .Lcerune_main_round_4_bounds
  cvttsd2siq %xmm2, %rax
  cvtsi2sdq %rax, %xmm3
  subsd %xmm3, %xmm2
  movabsq $4602678819172646912, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  jae .Lcerune_main_round_4_up
  movabsq $-4620693217682128896, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  jbe .Lcerune_main_round_4_down
  jmp .Lcerune_main_round_4_rounded
.Lcerune_main_round_4_up:
  addq $1, %rax
  jmp .Lcerune_main_round_4_rounded
.Lcerune_main_round_4_down:
  subq $1, %rax
.Lcerune_main_round_4_rounded:
  cvtsi2sdq %rax, %xmm2
.Lcerune_main_round_4_bounds:
  # range policy after rounding, then convert
  movabsq $-4332462841530417152, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  jb .Lcerune_main_round_4_minimum
  movabsq $4890909195324358656, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  jae .Lcerune_main_round_4_maximum
  cvttsd2siq %xmm2, %rax
  jmp .Lcerune_main_round_4_done
.Lcerune_main_round_4_nonfinite:
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_4(%rip), %rdx
  movl $69, %r8d
  callq _write
  movl $7, %ecx
  int $0x29
.Lcerune_main_round_4_minimum:
.Lcerune_main_round_4_maximum:
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_5(%rip), %rdx
  movl $71, %r8d
  callq _write
  movl $7, %ecx
  int $0x29
.Lcerune_main_round_4_done:
# cerune-origin: #17 bytes 142..164
cerune_origin_n17_main_36:
# cerune-mir: v1 main bb0 i12 -> lir 36 (source)
cerune_origin_mir_main_bb0_i12_lir36:
  movq %rax, -88(%rbp)
# cerune-origin: #16 bytes 136..166
cerune_origin_n16_main_37:
# cerune-mir: v1 main bb0 i13 -> lir 37 (source)
cerune_origin_mir_main_bb0_i13_lir37:
  movq -88(%rbp), %rax
# cerune-origin: #16 bytes 136..166
cerune_origin_n16_main_38:
# cerune-mir: v1 main bb0 i13 -> lir 38 (source)
cerune_origin_mir_main_bb0_i13_lir38:
  movq %rax, %rdx
# cerune-origin: #16 bytes 136..166
cerune_origin_n16_main_39:
# cerune-mir: v1 main bb0 i13 -> lir 39 (source)
cerune_origin_mir_main_bb0_i13_lir39:
  leaq .Lcerune_fmt_i64(%rip), %rcx
# cerune-origin: #16 bytes 136..166
cerune_origin_n16_main_40:
# cerune-mir: v1 main bb0 i13 -> lir 40 (source)
cerune_origin_mir_main_bb0_i13_lir40:
  callq printf
# cerune-origin: #23 bytes 200..203
cerune_origin_n23_main_41:
# cerune-mir: v1 main bb0 i14 -> lir 41 (source)
cerune_origin_mir_main_bb0_i14_lir41:
  movsd .Lcerune_f64_3(%rip), %xmm0
# cerune-origin: #23 bytes 200..203
cerune_origin_n23_main_42:
# cerune-mir: v1 main bb0 i14 -> lir 42 (source)
cerune_origin_mir_main_bb0_i14_lir42:
  movsd %xmm0, -96(%rbp)
# cerune-origin: #22 bytes 194..204
cerune_origin_n22_main_43:
# cerune-mir: v1 main bb0 i15 -> lir 43 (source)
cerune_origin_mir_main_bb0_i15_lir43:
  movsd -96(%rbp), %xmm0
  callq cerune_fn_value_0
# cerune-origin: #22 bytes 194..204
cerune_origin_n22_main_44:
# cerune-mir: v1 main bb0 i15 -> lir 44 (source)
cerune_origin_mir_main_bb0_i15_lir44:
  movsd %xmm0, -104(%rbp)
# cerune-origin: #21 bytes 173..205
cerune_origin_n21_main_45:
# cerune-mir: v1 main bb0 i16 -> lir 45 (source)
cerune_origin_mir_main_bb0_i16_lir45:
  movsd -104(%rbp), %xmm0
# cerune-origin: #21 bytes 173..205
cerune_origin_n21_main_46:
# cerune-mir: v1 main bb0 i16 -> lir 46 (source)
cerune_origin_mir_main_bb0_i16_lir46:
  # policy: round_ties_even
  movapd %xmm0, %xmm2
  ucomisd %xmm2, %xmm2
  jp .Lcerune_main_round_ties_even_5_nonfinite
  movabsq $9218868437227405312, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  je .Lcerune_main_round_ties_even_5_nonfinite
  movabsq $-4503599627370496, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  je .Lcerune_main_round_ties_even_5_nonfinite
  # round finite input; large values are already integral
  movabsq $4841369599423283200, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  jae .Lcerune_main_round_ties_even_5_bounds
  movabsq $-4382002437431492608, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  jbe .Lcerune_main_round_ties_even_5_bounds
  cvttsd2siq %xmm2, %rax
  cvtsi2sdq %rax, %xmm3
  subsd %xmm3, %xmm2
  movabsq $4602678819172646912, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  ja .Lcerune_main_round_ties_even_5_up
  je .Lcerune_main_round_ties_even_5_tie
  movabsq $-4620693217682128896, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  jb .Lcerune_main_round_ties_even_5_down
  jne .Lcerune_main_round_ties_even_5_rounded
.Lcerune_main_round_ties_even_5_tie:
  testq $1, %rax
  je .Lcerune_main_round_ties_even_5_rounded
  movabsq $0, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  ja .Lcerune_main_round_ties_even_5_up
  jmp .Lcerune_main_round_ties_even_5_down
  jmp .Lcerune_main_round_ties_even_5_rounded
.Lcerune_main_round_ties_even_5_up:
  addq $1, %rax
  jmp .Lcerune_main_round_ties_even_5_rounded
.Lcerune_main_round_ties_even_5_down:
  subq $1, %rax
.Lcerune_main_round_ties_even_5_rounded:
  cvtsi2sdq %rax, %xmm2
.Lcerune_main_round_ties_even_5_bounds:
  # range policy after rounding, then convert
  movabsq $-4332462841530417152, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  jb .Lcerune_main_round_ties_even_5_minimum
  movabsq $4890909195324358656, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  jae .Lcerune_main_round_ties_even_5_maximum
  cvttsd2siq %xmm2, %rax
  jmp .Lcerune_main_round_ties_even_5_done
.Lcerune_main_round_ties_even_5_nonfinite:
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_6(%rip), %rdx
  movl $69, %r8d
  callq _write
  movl $7, %ecx
  int $0x29
.Lcerune_main_round_ties_even_5_minimum:
.Lcerune_main_round_ties_even_5_maximum:
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_7(%rip), %rdx
  movl $71, %r8d
  callq _write
  movl $7, %ecx
  int $0x29
.Lcerune_main_round_ties_even_5_done:
# cerune-origin: #21 bytes 173..205
cerune_origin_n21_main_47:
# cerune-mir: v1 main bb0 i16 -> lir 47 (source)
cerune_origin_mir_main_bb0_i16_lir47:
  movq %rax, -112(%rbp)
# cerune-origin: #20 bytes 167..207
cerune_origin_n20_main_48:
# cerune-mir: v1 main bb0 i17 -> lir 48 (source)
cerune_origin_mir_main_bb0_i17_lir48:
  movq -112(%rbp), %rax
# cerune-origin: #20 bytes 167..207
cerune_origin_n20_main_49:
# cerune-mir: v1 main bb0 i17 -> lir 49 (source)
cerune_origin_mir_main_bb0_i17_lir49:
  movq %rax, %rdx
# cerune-origin: #20 bytes 167..207
cerune_origin_n20_main_50:
# cerune-mir: v1 main bb0 i17 -> lir 50 (source)
cerune_origin_mir_main_bb0_i17_lir50:
  leaq .Lcerune_fmt_i64(%rip), %rcx
# cerune-origin: #20 bytes 167..207
cerune_origin_n20_main_51:
# cerune-mir: v1 main bb0 i17 -> lir 51 (source)
cerune_origin_mir_main_bb0_i17_lir51:
  callq printf
# cerune-origin: #27 bytes 241..246
cerune_origin_n27_main_52:
# cerune-mir: v1 main bb0 i18 -> lir 52 (source)
cerune_origin_mir_main_bb0_i18_lir52:
  movsd .Lcerune_f64_4(%rip), %xmm0
# cerune-origin: #27 bytes 241..246
cerune_origin_n27_main_53:
# cerune-mir: v1 main bb0 i18 -> lir 53 (source)
cerune_origin_mir_main_bb0_i18_lir53:
  movsd %xmm0, -120(%rbp)
# cerune-origin: #26 bytes 235..247
cerune_origin_n26_main_54:
# cerune-mir: v1 main bb0 i19 -> lir 54 (source)
cerune_origin_mir_main_bb0_i19_lir54:
  movsd -120(%rbp), %xmm0
  callq cerune_fn_value_0
# cerune-origin: #26 bytes 235..247
cerune_origin_n26_main_55:
# cerune-mir: v1 main bb0 i19 -> lir 55 (source)
cerune_origin_mir_main_bb0_i19_lir55:
  movsd %xmm0, -128(%rbp)
# cerune-origin: #25 bytes 214..248
cerune_origin_n25_main_56:
# cerune-mir: v1 main bb0 i20 -> lir 56 (source)
cerune_origin_mir_main_bb0_i20_lir56:
  movsd -128(%rbp), %xmm0
# cerune-origin: #25 bytes 214..248
cerune_origin_n25_main_57:
# cerune-mir: v1 main bb0 i20 -> lir 57 (source)
cerune_origin_mir_main_bb0_i20_lir57:
  # policy: saturating_trunc
  movapd %xmm0, %xmm2
  ucomisd %xmm2, %xmm2
  jp .Lcerune_main_saturating_trunc_6_nonfinite
  movabsq $9218868437227405312, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  je .Lcerune_main_saturating_trunc_6_nonfinite
  movabsq $-4503599627370496, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  je .Lcerune_main_saturating_trunc_6_nonfinite
  # round finite input; large values are already integral
  movabsq $4841369599423283200, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  jae .Lcerune_main_saturating_trunc_6_bounds
  movabsq $-4382002437431492608, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  jbe .Lcerune_main_saturating_trunc_6_bounds
  cvttsd2siq %xmm2, %rax
  cvtsi2sdq %rax, %xmm3
  subsd %xmm3, %xmm2
  jmp .Lcerune_main_saturating_trunc_6_rounded
.Lcerune_main_saturating_trunc_6_up:
  addq $1, %rax
  jmp .Lcerune_main_saturating_trunc_6_rounded
.Lcerune_main_saturating_trunc_6_down:
  subq $1, %rax
.Lcerune_main_saturating_trunc_6_rounded:
  cvtsi2sdq %rax, %xmm2
.Lcerune_main_saturating_trunc_6_bounds:
  # range policy after rounding, then convert
  movabsq $0, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  jb .Lcerune_main_saturating_trunc_6_minimum
  movabsq $4643211215818981376, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  jae .Lcerune_main_saturating_trunc_6_maximum
  cvttsd2siq %xmm2, %rax
  jmp .Lcerune_main_saturating_trunc_6_done
.Lcerune_main_saturating_trunc_6_nonfinite:
  ucomisd %xmm2, %xmm2
  jp .Lcerune_main_saturating_trunc_6_zero
  movabsq $0, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  ja .Lcerune_main_saturating_trunc_6_maximum
  jmp .Lcerune_main_saturating_trunc_6_minimum
.Lcerune_main_saturating_trunc_6_zero:
  xorq %rax, %rax
  jmp .Lcerune_main_saturating_trunc_6_done
.Lcerune_main_saturating_trunc_6_minimum:
  movabsq $0, %rax
  jmp .Lcerune_main_saturating_trunc_6_done
.Lcerune_main_saturating_trunc_6_maximum:
  movabsq $255, %rax
.Lcerune_main_saturating_trunc_6_done:
# cerune-origin: #25 bytes 214..248
cerune_origin_n25_main_58:
# cerune-mir: v1 main bb0 i20 -> lir 58 (source)
cerune_origin_mir_main_bb0_i20_lir58:
  movq %rax, -136(%rbp)
# cerune-origin: #24 bytes 208..250
cerune_origin_n24_main_59:
# cerune-mir: v1 main bb0 i21 -> lir 59 (source)
cerune_origin_mir_main_bb0_i21_lir59:
  movq -136(%rbp), %rax
# cerune-origin: #24 bytes 208..250
cerune_origin_n24_main_60:
# cerune-mir: v1 main bb0 i21 -> lir 60 (source)
cerune_origin_mir_main_bb0_i21_lir60:
  movq %rax, %rdx
# cerune-origin: #24 bytes 208..250
cerune_origin_n24_main_61:
# cerune-mir: v1 main bb0 i21 -> lir 61 (source)
cerune_origin_mir_main_bb0_i21_lir61:
  leaq .Lcerune_fmt_i64(%rip), %rcx
# cerune-origin: #24 bytes 208..250
cerune_origin_n24_main_62:
# cerune-mir: v1 main bb0 i21 -> lir 62 (source)
cerune_origin_mir_main_bb0_i21_lir62:
  callq printf
# cerune-origin: #32 bytes 285..288
cerune_origin_n32_main_63:
# cerune-mir: v1 main bb0 i22 -> lir 63 (source)
cerune_origin_mir_main_bb0_i22_lir63:
  movsd .Lcerune_f64_5(%rip), %xmm0
# cerune-origin: #32 bytes 285..288
cerune_origin_n32_main_64:
# cerune-mir: v1 main bb0 i22 -> lir 64 (source)
cerune_origin_mir_main_bb0_i22_lir64:
  movsd %xmm0, -144(%rbp)
# cerune-origin: #31 bytes 284..288
cerune_origin_n31_main_65:
# cerune-mir: v1 main bb0 i23 -> lir 65 (source)
cerune_origin_mir_main_bb0_i23_lir65:
  movsd -144(%rbp), %xmm0
# cerune-origin: #31 bytes 284..288
cerune_origin_n31_main_66:
# cerune-mir: v1 main bb0 i23 -> lir 66 (source)
cerune_origin_mir_main_bb0_i23_lir66:
  xorpd .Lcerune_sign_f64(%rip), %xmm0
# cerune-origin: #31 bytes 284..288
cerune_origin_n31_main_67:
# cerune-mir: v1 main bb0 i23 -> lir 67 (source)
cerune_origin_mir_main_bb0_i23_lir67:
  movsd %xmm0, -152(%rbp)
# cerune-origin: #30 bytes 278..289
cerune_origin_n30_main_68:
# cerune-mir: v1 main bb0 i24 -> lir 68 (source)
cerune_origin_mir_main_bb0_i24_lir68:
  movsd -152(%rbp), %xmm0
  callq cerune_fn_value_0
# cerune-origin: #30 bytes 278..289
cerune_origin_n30_main_69:
# cerune-mir: v1 main bb0 i24 -> lir 69 (source)
cerune_origin_mir_main_bb0_i24_lir69:
  movsd %xmm0, -160(%rbp)
# cerune-origin: #29 bytes 257..290
cerune_origin_n29_main_70:
# cerune-mir: v1 main bb0 i25 -> lir 70 (source)
cerune_origin_mir_main_bb0_i25_lir70:
  movsd -160(%rbp), %xmm0
# cerune-origin: #29 bytes 257..290
cerune_origin_n29_main_71:
# cerune-mir: v1 main bb0 i25 -> lir 71 (source)
cerune_origin_mir_main_bb0_i25_lir71:
  # policy: saturating_floor
  movapd %xmm0, %xmm2
  ucomisd %xmm2, %xmm2
  jp .Lcerune_main_saturating_floor_7_nonfinite
  movabsq $9218868437227405312, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  je .Lcerune_main_saturating_floor_7_nonfinite
  movabsq $-4503599627370496, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  je .Lcerune_main_saturating_floor_7_nonfinite
  # round finite input; large values are already integral
  movabsq $4841369599423283200, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  jae .Lcerune_main_saturating_floor_7_bounds
  movabsq $-4382002437431492608, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  jbe .Lcerune_main_saturating_floor_7_bounds
  cvttsd2siq %xmm2, %rax
  cvtsi2sdq %rax, %xmm3
  subsd %xmm3, %xmm2
  movabsq $0, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  jb .Lcerune_main_saturating_floor_7_down
  jmp .Lcerune_main_saturating_floor_7_rounded
.Lcerune_main_saturating_floor_7_up:
  addq $1, %rax
  jmp .Lcerune_main_saturating_floor_7_rounded
.Lcerune_main_saturating_floor_7_down:
  subq $1, %rax
.Lcerune_main_saturating_floor_7_rounded:
  cvtsi2sdq %rax, %xmm2
.Lcerune_main_saturating_floor_7_bounds:
  # range policy after rounding, then convert
  movabsq $0, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  jb .Lcerune_main_saturating_floor_7_minimum
  movabsq $4643211215818981376, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  jae .Lcerune_main_saturating_floor_7_maximum
  cvttsd2siq %xmm2, %rax
  jmp .Lcerune_main_saturating_floor_7_done
.Lcerune_main_saturating_floor_7_nonfinite:
  ucomisd %xmm2, %xmm2
  jp .Lcerune_main_saturating_floor_7_zero
  movabsq $0, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  ja .Lcerune_main_saturating_floor_7_maximum
  jmp .Lcerune_main_saturating_floor_7_minimum
.Lcerune_main_saturating_floor_7_zero:
  xorq %rax, %rax
  jmp .Lcerune_main_saturating_floor_7_done
.Lcerune_main_saturating_floor_7_minimum:
  movabsq $0, %rax
  jmp .Lcerune_main_saturating_floor_7_done
.Lcerune_main_saturating_floor_7_maximum:
  movabsq $255, %rax
.Lcerune_main_saturating_floor_7_done:
# cerune-origin: #29 bytes 257..290
cerune_origin_n29_main_72:
# cerune-mir: v1 main bb0 i25 -> lir 72 (source)
cerune_origin_mir_main_bb0_i25_lir72:
  movq %rax, -168(%rbp)
# cerune-origin: #28 bytes 251..292
cerune_origin_n28_main_73:
# cerune-mir: v1 main bb0 i26 -> lir 73 (source)
cerune_origin_mir_main_bb0_i26_lir73:
  movq -168(%rbp), %rax
# cerune-origin: #28 bytes 251..292
cerune_origin_n28_main_74:
# cerune-mir: v1 main bb0 i26 -> lir 74 (source)
cerune_origin_mir_main_bb0_i26_lir74:
  movq %rax, %rdx
# cerune-origin: #28 bytes 251..292
cerune_origin_n28_main_75:
# cerune-mir: v1 main bb0 i26 -> lir 75 (source)
cerune_origin_mir_main_bb0_i26_lir75:
  leaq .Lcerune_fmt_i64(%rip), %rcx
# cerune-origin: #28 bytes 251..292
cerune_origin_n28_main_76:
# cerune-mir: v1 main bb0 i26 -> lir 76 (source)
cerune_origin_mir_main_bb0_i26_lir76:
  callq printf
# cerune-origin: #36 bytes 325..330
cerune_origin_n36_main_77:
# cerune-mir: v1 main bb0 i27 -> lir 77 (source)
cerune_origin_mir_main_bb0_i27_lir77:
  movsd .Lcerune_f64_6(%rip), %xmm0
# cerune-origin: #36 bytes 325..330
cerune_origin_n36_main_78:
# cerune-mir: v1 main bb0 i27 -> lir 78 (source)
cerune_origin_mir_main_bb0_i27_lir78:
  movsd %xmm0, -176(%rbp)
# cerune-origin: #35 bytes 319..331
cerune_origin_n35_main_79:
# cerune-mir: v1 main bb0 i28 -> lir 79 (source)
cerune_origin_mir_main_bb0_i28_lir79:
  movsd -176(%rbp), %xmm0
  callq cerune_fn_value_0
# cerune-origin: #35 bytes 319..331
cerune_origin_n35_main_80:
# cerune-mir: v1 main bb0 i28 -> lir 80 (source)
cerune_origin_mir_main_bb0_i28_lir80:
  movsd %xmm0, -184(%rbp)
# cerune-origin: #34 bytes 299..332
cerune_origin_n34_main_81:
# cerune-mir: v1 main bb0 i29 -> lir 81 (source)
cerune_origin_mir_main_bb0_i29_lir81:
  movsd -184(%rbp), %xmm0
# cerune-origin: #34 bytes 299..332
cerune_origin_n34_main_82:
# cerune-mir: v1 main bb0 i29 -> lir 82 (source)
cerune_origin_mir_main_bb0_i29_lir82:
  # policy: saturating_ceil
  movapd %xmm0, %xmm2
  ucomisd %xmm2, %xmm2
  jp .Lcerune_main_saturating_ceil_8_nonfinite
  movabsq $9218868437227405312, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  je .Lcerune_main_saturating_ceil_8_nonfinite
  movabsq $-4503599627370496, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  je .Lcerune_main_saturating_ceil_8_nonfinite
  # round finite input; large values are already integral
  movabsq $4841369599423283200, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  jae .Lcerune_main_saturating_ceil_8_bounds
  movabsq $-4382002437431492608, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  jbe .Lcerune_main_saturating_ceil_8_bounds
  cvttsd2siq %xmm2, %rax
  cvtsi2sdq %rax, %xmm3
  subsd %xmm3, %xmm2
  movabsq $0, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  ja .Lcerune_main_saturating_ceil_8_up
  jmp .Lcerune_main_saturating_ceil_8_rounded
.Lcerune_main_saturating_ceil_8_up:
  addq $1, %rax
  jmp .Lcerune_main_saturating_ceil_8_rounded
.Lcerune_main_saturating_ceil_8_down:
  subq $1, %rax
.Lcerune_main_saturating_ceil_8_rounded:
  cvtsi2sdq %rax, %xmm2
.Lcerune_main_saturating_ceil_8_bounds:
  # range policy after rounding, then convert
  movabsq $0, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  jb .Lcerune_main_saturating_ceil_8_minimum
  movabsq $4643211215818981376, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  jae .Lcerune_main_saturating_ceil_8_maximum
  cvttsd2siq %xmm2, %rax
  jmp .Lcerune_main_saturating_ceil_8_done
.Lcerune_main_saturating_ceil_8_nonfinite:
  ucomisd %xmm2, %xmm2
  jp .Lcerune_main_saturating_ceil_8_zero
  movabsq $0, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  ja .Lcerune_main_saturating_ceil_8_maximum
  jmp .Lcerune_main_saturating_ceil_8_minimum
.Lcerune_main_saturating_ceil_8_zero:
  xorq %rax, %rax
  jmp .Lcerune_main_saturating_ceil_8_done
.Lcerune_main_saturating_ceil_8_minimum:
  movabsq $0, %rax
  jmp .Lcerune_main_saturating_ceil_8_done
.Lcerune_main_saturating_ceil_8_maximum:
  movabsq $255, %rax
.Lcerune_main_saturating_ceil_8_done:
# cerune-origin: #34 bytes 299..332
cerune_origin_n34_main_83:
# cerune-mir: v1 main bb0 i29 -> lir 83 (source)
cerune_origin_mir_main_bb0_i29_lir83:
  movq %rax, -192(%rbp)
# cerune-origin: #33 bytes 293..334
cerune_origin_n33_main_84:
# cerune-mir: v1 main bb0 i30 -> lir 84 (source)
cerune_origin_mir_main_bb0_i30_lir84:
  movq -192(%rbp), %rax
# cerune-origin: #33 bytes 293..334
cerune_origin_n33_main_85:
# cerune-mir: v1 main bb0 i30 -> lir 85 (source)
cerune_origin_mir_main_bb0_i30_lir85:
  movq %rax, %rdx
# cerune-origin: #33 bytes 293..334
cerune_origin_n33_main_86:
# cerune-mir: v1 main bb0 i30 -> lir 86 (source)
cerune_origin_mir_main_bb0_i30_lir86:
  leaq .Lcerune_fmt_i64(%rip), %rcx
# cerune-origin: #33 bytes 293..334
cerune_origin_n33_main_87:
# cerune-mir: v1 main bb0 i30 -> lir 87 (source)
cerune_origin_mir_main_bb0_i30_lir87:
  callq printf
# cerune-origin: #40 bytes 368..373
cerune_origin_n40_main_88:
# cerune-mir: v1 main bb0 i31 -> lir 88 (source)
cerune_origin_mir_main_bb0_i31_lir88:
  movsd .Lcerune_f64_7(%rip), %xmm0
# cerune-origin: #40 bytes 368..373
cerune_origin_n40_main_89:
# cerune-mir: v1 main bb0 i31 -> lir 89 (source)
cerune_origin_mir_main_bb0_i31_lir89:
  movsd %xmm0, -200(%rbp)
# cerune-origin: #39 bytes 362..374
cerune_origin_n39_main_90:
# cerune-mir: v1 main bb0 i32 -> lir 90 (source)
cerune_origin_mir_main_bb0_i32_lir90:
  movsd -200(%rbp), %xmm0
  callq cerune_fn_value_0
# cerune-origin: #39 bytes 362..374
cerune_origin_n39_main_91:
# cerune-mir: v1 main bb0 i32 -> lir 91 (source)
cerune_origin_mir_main_bb0_i32_lir91:
  movsd %xmm0, -208(%rbp)
# cerune-origin: #38 bytes 341..375
cerune_origin_n38_main_92:
# cerune-mir: v1 main bb0 i33 -> lir 92 (source)
cerune_origin_mir_main_bb0_i33_lir92:
  movsd -208(%rbp), %xmm0
# cerune-origin: #38 bytes 341..375
cerune_origin_n38_main_93:
# cerune-mir: v1 main bb0 i33 -> lir 93 (source)
cerune_origin_mir_main_bb0_i33_lir93:
  # policy: saturating_round
  movapd %xmm0, %xmm2
  ucomisd %xmm2, %xmm2
  jp .Lcerune_main_saturating_round_9_nonfinite
  movabsq $9218868437227405312, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  je .Lcerune_main_saturating_round_9_nonfinite
  movabsq $-4503599627370496, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  je .Lcerune_main_saturating_round_9_nonfinite
  # round finite input; large values are already integral
  movabsq $4841369599423283200, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  jae .Lcerune_main_saturating_round_9_bounds
  movabsq $-4382002437431492608, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  jbe .Lcerune_main_saturating_round_9_bounds
  cvttsd2siq %xmm2, %rax
  cvtsi2sdq %rax, %xmm3
  subsd %xmm3, %xmm2
  movabsq $4602678819172646912, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  jae .Lcerune_main_saturating_round_9_up
  movabsq $-4620693217682128896, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  jbe .Lcerune_main_saturating_round_9_down
  jmp .Lcerune_main_saturating_round_9_rounded
.Lcerune_main_saturating_round_9_up:
  addq $1, %rax
  jmp .Lcerune_main_saturating_round_9_rounded
.Lcerune_main_saturating_round_9_down:
  subq $1, %rax
.Lcerune_main_saturating_round_9_rounded:
  cvtsi2sdq %rax, %xmm2
.Lcerune_main_saturating_round_9_bounds:
  # range policy after rounding, then convert
  movabsq $0, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  jb .Lcerune_main_saturating_round_9_minimum
  movabsq $4643211215818981376, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  jae .Lcerune_main_saturating_round_9_maximum
  cvttsd2siq %xmm2, %rax
  jmp .Lcerune_main_saturating_round_9_done
.Lcerune_main_saturating_round_9_nonfinite:
  ucomisd %xmm2, %xmm2
  jp .Lcerune_main_saturating_round_9_zero
  movabsq $0, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  ja .Lcerune_main_saturating_round_9_maximum
  jmp .Lcerune_main_saturating_round_9_minimum
.Lcerune_main_saturating_round_9_zero:
  xorq %rax, %rax
  jmp .Lcerune_main_saturating_round_9_done
.Lcerune_main_saturating_round_9_minimum:
  movabsq $0, %rax
  jmp .Lcerune_main_saturating_round_9_done
.Lcerune_main_saturating_round_9_maximum:
  movabsq $255, %rax
.Lcerune_main_saturating_round_9_done:
# cerune-origin: #38 bytes 341..375
cerune_origin_n38_main_94:
# cerune-mir: v1 main bb0 i33 -> lir 94 (source)
cerune_origin_mir_main_bb0_i33_lir94:
  movq %rax, -216(%rbp)
# cerune-origin: #37 bytes 335..377
cerune_origin_n37_main_95:
# cerune-mir: v1 main bb0 i34 -> lir 95 (source)
cerune_origin_mir_main_bb0_i34_lir95:
  movq -216(%rbp), %rax
# cerune-origin: #37 bytes 335..377
cerune_origin_n37_main_96:
# cerune-mir: v1 main bb0 i34 -> lir 96 (source)
cerune_origin_mir_main_bb0_i34_lir96:
  movq %rax, %rdx
# cerune-origin: #37 bytes 335..377
cerune_origin_n37_main_97:
# cerune-mir: v1 main bb0 i34 -> lir 97 (source)
cerune_origin_mir_main_bb0_i34_lir97:
  leaq .Lcerune_fmt_i64(%rip), %rcx
# cerune-origin: #37 bytes 335..377
cerune_origin_n37_main_98:
# cerune-mir: v1 main bb0 i34 -> lir 98 (source)
cerune_origin_mir_main_bb0_i34_lir98:
  callq printf
# cerune-origin: #44 bytes 421..426
cerune_origin_n44_main_99:
# cerune-mir: v1 main bb0 i35 -> lir 99 (source)
cerune_origin_mir_main_bb0_i35_lir99:
  movsd .Lcerune_f64_8(%rip), %xmm0
# cerune-origin: #44 bytes 421..426
cerune_origin_n44_main_100:
# cerune-mir: v1 main bb0 i35 -> lir 100 (source)
cerune_origin_mir_main_bb0_i35_lir100:
  movsd %xmm0, -224(%rbp)
# cerune-origin: #43 bytes 415..427
cerune_origin_n43_main_101:
# cerune-mir: v1 main bb0 i36 -> lir 101 (source)
cerune_origin_mir_main_bb0_i36_lir101:
  movsd -224(%rbp), %xmm0
  callq cerune_fn_value_0
# cerune-origin: #43 bytes 415..427
cerune_origin_n43_main_102:
# cerune-mir: v1 main bb0 i36 -> lir 102 (source)
cerune_origin_mir_main_bb0_i36_lir102:
  movsd %xmm0, -232(%rbp)
# cerune-origin: #42 bytes 384..428
cerune_origin_n42_main_103:
# cerune-mir: v1 main bb0 i37 -> lir 103 (source)
cerune_origin_mir_main_bb0_i37_lir103:
  movsd -232(%rbp), %xmm0
# cerune-origin: #42 bytes 384..428
cerune_origin_n42_main_104:
# cerune-mir: v1 main bb0 i37 -> lir 104 (source)
cerune_origin_mir_main_bb0_i37_lir104:
  # policy: saturating_round_ties_even
  movapd %xmm0, %xmm2
  ucomisd %xmm2, %xmm2
  jp .Lcerune_main_saturating_round_ties_even_10_nonfinite
  movabsq $9218868437227405312, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  je .Lcerune_main_saturating_round_ties_even_10_nonfinite
  movabsq $-4503599627370496, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  je .Lcerune_main_saturating_round_ties_even_10_nonfinite
  # round finite input; large values are already integral
  movabsq $4841369599423283200, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  jae .Lcerune_main_saturating_round_ties_even_10_bounds
  movabsq $-4382002437431492608, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  jbe .Lcerune_main_saturating_round_ties_even_10_bounds
  cvttsd2siq %xmm2, %rax
  cvtsi2sdq %rax, %xmm3
  subsd %xmm3, %xmm2
  movabsq $4602678819172646912, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  ja .Lcerune_main_saturating_round_ties_even_10_up
  je .Lcerune_main_saturating_round_ties_even_10_tie
  movabsq $-4620693217682128896, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  jb .Lcerune_main_saturating_round_ties_even_10_down
  jne .Lcerune_main_saturating_round_ties_even_10_rounded
.Lcerune_main_saturating_round_ties_even_10_tie:
  testq $1, %rax
  je .Lcerune_main_saturating_round_ties_even_10_rounded
  movabsq $0, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  ja .Lcerune_main_saturating_round_ties_even_10_up
  jmp .Lcerune_main_saturating_round_ties_even_10_down
  jmp .Lcerune_main_saturating_round_ties_even_10_rounded
.Lcerune_main_saturating_round_ties_even_10_up:
  addq $1, %rax
  jmp .Lcerune_main_saturating_round_ties_even_10_rounded
.Lcerune_main_saturating_round_ties_even_10_down:
  subq $1, %rax
.Lcerune_main_saturating_round_ties_even_10_rounded:
  cvtsi2sdq %rax, %xmm2
.Lcerune_main_saturating_round_ties_even_10_bounds:
  # range policy after rounding, then convert
  movabsq $0, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  jb .Lcerune_main_saturating_round_ties_even_10_minimum
  movabsq $4643211215818981376, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  jae .Lcerune_main_saturating_round_ties_even_10_maximum
  cvttsd2siq %xmm2, %rax
  jmp .Lcerune_main_saturating_round_ties_even_10_done
.Lcerune_main_saturating_round_ties_even_10_nonfinite:
  ucomisd %xmm2, %xmm2
  jp .Lcerune_main_saturating_round_ties_even_10_zero
  movabsq $0, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  ja .Lcerune_main_saturating_round_ties_even_10_maximum
  jmp .Lcerune_main_saturating_round_ties_even_10_minimum
.Lcerune_main_saturating_round_ties_even_10_zero:
  xorq %rax, %rax
  jmp .Lcerune_main_saturating_round_ties_even_10_done
.Lcerune_main_saturating_round_ties_even_10_minimum:
  movabsq $0, %rax
  jmp .Lcerune_main_saturating_round_ties_even_10_done
.Lcerune_main_saturating_round_ties_even_10_maximum:
  movabsq $255, %rax
.Lcerune_main_saturating_round_ties_even_10_done:
# cerune-origin: #42 bytes 384..428
cerune_origin_n42_main_105:
# cerune-mir: v1 main bb0 i37 -> lir 105 (source)
cerune_origin_mir_main_bb0_i37_lir105:
  movq %rax, -240(%rbp)
# cerune-origin: #41 bytes 378..430
cerune_origin_n41_main_106:
# cerune-mir: v1 main bb0 i38 -> lir 106 (source)
cerune_origin_mir_main_bb0_i38_lir106:
  movq -240(%rbp), %rax
# cerune-origin: #41 bytes 378..430
cerune_origin_n41_main_107:
# cerune-mir: v1 main bb0 i38 -> lir 107 (source)
cerune_origin_mir_main_bb0_i38_lir107:
  movq %rax, %rdx
# cerune-origin: #41 bytes 378..430
cerune_origin_n41_main_108:
# cerune-mir: v1 main bb0 i38 -> lir 108 (source)
cerune_origin_mir_main_bb0_i38_lir108:
  leaq .Lcerune_fmt_i64(%rip), %rcx
# cerune-origin: #41 bytes 378..430
cerune_origin_n41_main_109:
# cerune-mir: v1 main bb0 i38 -> lir 109 (source)
cerune_origin_mir_main_bb0_i38_lir109:
  callq printf
# cerune-origin: #47 bytes 437..442
cerune_origin_n47_main_110:
# cerune-mir: v1 main bb0 i39 -> lir 110 (source)
cerune_origin_mir_main_bb0_i39_lir110:
  movabsq $3, %rax
# cerune-origin: #47 bytes 437..442
cerune_origin_n47_main_111:
# cerune-mir: v1 main bb0 i39 -> lir 111 (source)
cerune_origin_mir_main_bb0_i39_lir111:
  movq %rax, -248(%rbp)
# cerune-origin: #46 bytes 437..442
cerune_origin_n46_main_112:
# cerune-mir: v1 main bb0 i40 -> lir 112 (source)
cerune_origin_mir_main_bb0_i40_lir112:
  movq -248(%rbp), %rax
# cerune-origin: #46 bytes 437..442
cerune_origin_n46_main_113:
# cerune-mir: v1 main bb0 i40 -> lir 113 (source)
cerune_origin_mir_main_bb0_i40_lir113:
  movq %rax, -256(%rbp)
# cerune-origin: #45 bytes 431..444
cerune_origin_n45_main_114:
# cerune-mir: v1 main bb0 i41 -> lir 114 (source)
cerune_origin_mir_main_bb0_i41_lir114:
  movq -256(%rbp), %rax
# cerune-origin: #45 bytes 431..444
cerune_origin_n45_main_115:
# cerune-mir: v1 main bb0 i41 -> lir 115 (source)
cerune_origin_mir_main_bb0_i41_lir115:
  movq %rax, %rdx
# cerune-origin: #45 bytes 431..444
cerune_origin_n45_main_116:
# cerune-mir: v1 main bb0 i41 -> lir 116 (source)
cerune_origin_mir_main_bb0_i41_lir116:
  leaq .Lcerune_fmt_i64(%rip), %rcx
# cerune-origin: #45 bytes 431..444
cerune_origin_n45_main_117:
# cerune-mir: v1 main bb0 i41 -> lir 117 (source)
cerune_origin_mir_main_bb0_i41_lir117:
  callq printf
# cerune-origin: synthetic
# cerune-mir: v1 main bb0 i42 -> lir 118 (function-end)
cerune_origin_mir_main_bb0_i42_lir118:
  jmp .Lcerune_block_1
# cerune-origin: synthetic
# cerune-mir: v1 synthetic ABI setup/exit
.Lcerune_block_1: # main_exit
# cerune-origin: synthetic
  xorl %eax, %eax
  addq $288, %rsp
  popq %rbp
  retq

.section .rdata,"dr"
.Lcerune_failure_0:
  .asciz "cerune: runtime-v1 code=conversion-not-finite node=7 bytes=79..102\n"
.Lcerune_failure_1:
  .asciz "cerune: runtime-v1 code=conversion-out-of-range node=7 bytes=79..102\n"
.Lcerune_failure_2:
  .asciz "cerune: runtime-v1 code=conversion-not-finite node=12 bytes=111..133\n"
.Lcerune_failure_3:
  .asciz "cerune: runtime-v1 code=conversion-out-of-range node=12 bytes=111..133\n"
.Lcerune_failure_4:
  .asciz "cerune: runtime-v1 code=conversion-not-finite node=17 bytes=142..164\n"
.Lcerune_failure_5:
  .asciz "cerune: runtime-v1 code=conversion-out-of-range node=17 bytes=142..164\n"
.Lcerune_failure_6:
  .asciz "cerune: runtime-v1 code=conversion-not-finite node=21 bytes=173..205\n"
.Lcerune_failure_7:
  .asciz "cerune: runtime-v1 code=conversion-out-of-range node=21 bytes=173..205\n"
