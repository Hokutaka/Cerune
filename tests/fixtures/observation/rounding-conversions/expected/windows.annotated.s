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
  movsd %xmm0, -8(%rbp)
# cerune-origin: #5 bytes 68..69
cerune_origin_n5_fn_0_1:
  movsd -8(%rbp), %xmm0
# cerune-origin: #4 bytes 61..70
cerune_origin_n4_fn_0_2:
  addq $48, %rsp
  popq %rbp
  retq

# cerune-origin: synthetic
.globl main
.p2align 4
main:
  pushq %rbp
  movq %rsp, %rbp
  subq $224, %rsp
# cerune-origin: #10 bytes 97..100
cerune_origin_n10_main_0:
  movsd .Lcerune_f64_0(%rip), %xmm0
# cerune-origin: #9 bytes 96..100
cerune_origin_n9_main_1:
  xorpd .Lcerune_sign_f64(%rip), %xmm0
# cerune-origin: #8 bytes 90..101
cerune_origin_n8_main_2:
  movsd %xmm0, -8(%rbp)
# cerune-origin: #8 bytes 90..101
cerune_origin_n8_main_3:
  movsd -8(%rbp), %xmm0
  callq cerune_fn_value_0
# cerune-origin: #7 bytes 79..102
cerune_origin_n7_main_4:
  # policy: floor
  movapd %xmm0, %xmm2
  ucomisd %xmm2, %xmm2
  jp .Lcerune_main_floor_0_nonfinite
  movabsq $9218868437227405312, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  je .Lcerune_main_floor_0_nonfinite
  movabsq $-4503599627370496, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  je .Lcerune_main_floor_0_nonfinite
  # round finite input; large values are already integral
  movabsq $4841369599423283200, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  jae .Lcerune_main_floor_0_bounds
  movabsq $-4382002437431492608, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  jbe .Lcerune_main_floor_0_bounds
  cvttsd2siq %xmm2, %rax
  cvtsi2sdq %rax, %xmm3
  subsd %xmm3, %xmm2
  movabsq $0, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  jb .Lcerune_main_floor_0_down
  jmp .Lcerune_main_floor_0_rounded
.Lcerune_main_floor_0_up:
  addq $1, %rax
  jmp .Lcerune_main_floor_0_rounded
.Lcerune_main_floor_0_down:
  subq $1, %rax
.Lcerune_main_floor_0_rounded:
  cvtsi2sdq %rax, %xmm2
.Lcerune_main_floor_0_bounds:
  # range policy after rounding, then convert
  movabsq $-4332462841530417152, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  jb .Lcerune_main_floor_0_minimum
  movabsq $4890909195324358656, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  jae .Lcerune_main_floor_0_maximum
  cvttsd2siq %xmm2, %rax
  jmp .Lcerune_main_floor_0_done
.Lcerune_main_floor_0_nonfinite:
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_0(%rip), %rdx
  movl $67, %r8d
  callq _write
  ud2
.Lcerune_main_floor_0_minimum:
.Lcerune_main_floor_0_maximum:
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_1(%rip), %rdx
  movl $69, %r8d
  callq _write
  ud2
.Lcerune_main_floor_0_done:
# cerune-origin: #6 bytes 73..104
cerune_origin_n6_main_5:
  movq %rax, %rdx
# cerune-origin: #6 bytes 73..104
cerune_origin_n6_main_6:
  leaq .Lcerune_fmt_i64(%rip), %rcx
# cerune-origin: #6 bytes 73..104
cerune_origin_n6_main_7:
  callq printf
# cerune-origin: #15 bytes 128..131
cerune_origin_n15_main_8:
  movsd .Lcerune_f64_1(%rip), %xmm0
# cerune-origin: #14 bytes 127..131
cerune_origin_n14_main_9:
  xorpd .Lcerune_sign_f64(%rip), %xmm0
# cerune-origin: #13 bytes 121..132
cerune_origin_n13_main_10:
  movsd %xmm0, -8(%rbp)
# cerune-origin: #13 bytes 121..132
cerune_origin_n13_main_11:
  movsd -8(%rbp), %xmm0
  callq cerune_fn_value_0
# cerune-origin: #12 bytes 111..133
cerune_origin_n12_main_12:
  # policy: ceil
  movapd %xmm0, %xmm2
  ucomisd %xmm2, %xmm2
  jp .Lcerune_main_ceil_1_nonfinite
  movabsq $9218868437227405312, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  je .Lcerune_main_ceil_1_nonfinite
  movabsq $-4503599627370496, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  je .Lcerune_main_ceil_1_nonfinite
  # round finite input; large values are already integral
  movabsq $4841369599423283200, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  jae .Lcerune_main_ceil_1_bounds
  movabsq $-4382002437431492608, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  jbe .Lcerune_main_ceil_1_bounds
  cvttsd2siq %xmm2, %rax
  cvtsi2sdq %rax, %xmm3
  subsd %xmm3, %xmm2
  movabsq $0, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  ja .Lcerune_main_ceil_1_up
  jmp .Lcerune_main_ceil_1_rounded
.Lcerune_main_ceil_1_up:
  addq $1, %rax
  jmp .Lcerune_main_ceil_1_rounded
.Lcerune_main_ceil_1_down:
  subq $1, %rax
.Lcerune_main_ceil_1_rounded:
  cvtsi2sdq %rax, %xmm2
.Lcerune_main_ceil_1_bounds:
  # range policy after rounding, then convert
  movabsq $-4332462841530417152, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  jb .Lcerune_main_ceil_1_minimum
  movabsq $4890909195324358656, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  jae .Lcerune_main_ceil_1_maximum
  cvttsd2siq %xmm2, %rax
  jmp .Lcerune_main_ceil_1_done
.Lcerune_main_ceil_1_nonfinite:
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_2(%rip), %rdx
  movl $69, %r8d
  callq _write
  ud2
.Lcerune_main_ceil_1_minimum:
.Lcerune_main_ceil_1_maximum:
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_3(%rip), %rdx
  movl $71, %r8d
  callq _write
  ud2
.Lcerune_main_ceil_1_done:
# cerune-origin: #11 bytes 105..135
cerune_origin_n11_main_13:
  movq %rax, %rdx
# cerune-origin: #11 bytes 105..135
cerune_origin_n11_main_14:
  leaq .Lcerune_fmt_i64(%rip), %rcx
# cerune-origin: #11 bytes 105..135
cerune_origin_n11_main_15:
  callq printf
# cerune-origin: #19 bytes 159..162
cerune_origin_n19_main_16:
  movsd .Lcerune_f64_2(%rip), %xmm0
# cerune-origin: #18 bytes 153..163
cerune_origin_n18_main_17:
  movsd %xmm0, -8(%rbp)
# cerune-origin: #18 bytes 153..163
cerune_origin_n18_main_18:
  movsd -8(%rbp), %xmm0
  callq cerune_fn_value_0
# cerune-origin: #17 bytes 142..164
cerune_origin_n17_main_19:
  # policy: round
  movapd %xmm0, %xmm2
  ucomisd %xmm2, %xmm2
  jp .Lcerune_main_round_2_nonfinite
  movabsq $9218868437227405312, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  je .Lcerune_main_round_2_nonfinite
  movabsq $-4503599627370496, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  je .Lcerune_main_round_2_nonfinite
  # round finite input; large values are already integral
  movabsq $4841369599423283200, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  jae .Lcerune_main_round_2_bounds
  movabsq $-4382002437431492608, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  jbe .Lcerune_main_round_2_bounds
  cvttsd2siq %xmm2, %rax
  cvtsi2sdq %rax, %xmm3
  subsd %xmm3, %xmm2
  movabsq $4602678819172646912, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  jae .Lcerune_main_round_2_up
  movabsq $-4620693217682128896, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  jbe .Lcerune_main_round_2_down
  jmp .Lcerune_main_round_2_rounded
.Lcerune_main_round_2_up:
  addq $1, %rax
  jmp .Lcerune_main_round_2_rounded
.Lcerune_main_round_2_down:
  subq $1, %rax
.Lcerune_main_round_2_rounded:
  cvtsi2sdq %rax, %xmm2
.Lcerune_main_round_2_bounds:
  # range policy after rounding, then convert
  movabsq $-4332462841530417152, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  jb .Lcerune_main_round_2_minimum
  movabsq $4890909195324358656, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  jae .Lcerune_main_round_2_maximum
  cvttsd2siq %xmm2, %rax
  jmp .Lcerune_main_round_2_done
.Lcerune_main_round_2_nonfinite:
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_4(%rip), %rdx
  movl $69, %r8d
  callq _write
  ud2
.Lcerune_main_round_2_minimum:
.Lcerune_main_round_2_maximum:
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_5(%rip), %rdx
  movl $71, %r8d
  callq _write
  ud2
.Lcerune_main_round_2_done:
# cerune-origin: #16 bytes 136..166
cerune_origin_n16_main_20:
  movq %rax, %rdx
# cerune-origin: #16 bytes 136..166
cerune_origin_n16_main_21:
  leaq .Lcerune_fmt_i64(%rip), %rcx
# cerune-origin: #16 bytes 136..166
cerune_origin_n16_main_22:
  callq printf
# cerune-origin: #23 bytes 200..203
cerune_origin_n23_main_23:
  movsd .Lcerune_f64_3(%rip), %xmm0
# cerune-origin: #22 bytes 194..204
cerune_origin_n22_main_24:
  movsd %xmm0, -8(%rbp)
# cerune-origin: #22 bytes 194..204
cerune_origin_n22_main_25:
  movsd -8(%rbp), %xmm0
  callq cerune_fn_value_0
# cerune-origin: #21 bytes 173..205
cerune_origin_n21_main_26:
  # policy: round_ties_even
  movapd %xmm0, %xmm2
  ucomisd %xmm2, %xmm2
  jp .Lcerune_main_round_ties_even_3_nonfinite
  movabsq $9218868437227405312, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  je .Lcerune_main_round_ties_even_3_nonfinite
  movabsq $-4503599627370496, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  je .Lcerune_main_round_ties_even_3_nonfinite
  # round finite input; large values are already integral
  movabsq $4841369599423283200, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  jae .Lcerune_main_round_ties_even_3_bounds
  movabsq $-4382002437431492608, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  jbe .Lcerune_main_round_ties_even_3_bounds
  cvttsd2siq %xmm2, %rax
  cvtsi2sdq %rax, %xmm3
  subsd %xmm3, %xmm2
  movabsq $4602678819172646912, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  ja .Lcerune_main_round_ties_even_3_up
  je .Lcerune_main_round_ties_even_3_tie
  movabsq $-4620693217682128896, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  jb .Lcerune_main_round_ties_even_3_down
  jne .Lcerune_main_round_ties_even_3_rounded
.Lcerune_main_round_ties_even_3_tie:
  testq $1, %rax
  je .Lcerune_main_round_ties_even_3_rounded
  movabsq $0, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  ja .Lcerune_main_round_ties_even_3_up
  jmp .Lcerune_main_round_ties_even_3_down
  jmp .Lcerune_main_round_ties_even_3_rounded
.Lcerune_main_round_ties_even_3_up:
  addq $1, %rax
  jmp .Lcerune_main_round_ties_even_3_rounded
.Lcerune_main_round_ties_even_3_down:
  subq $1, %rax
.Lcerune_main_round_ties_even_3_rounded:
  cvtsi2sdq %rax, %xmm2
.Lcerune_main_round_ties_even_3_bounds:
  # range policy after rounding, then convert
  movabsq $-4332462841530417152, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  jb .Lcerune_main_round_ties_even_3_minimum
  movabsq $4890909195324358656, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  jae .Lcerune_main_round_ties_even_3_maximum
  cvttsd2siq %xmm2, %rax
  jmp .Lcerune_main_round_ties_even_3_done
.Lcerune_main_round_ties_even_3_nonfinite:
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_6(%rip), %rdx
  movl $69, %r8d
  callq _write
  ud2
.Lcerune_main_round_ties_even_3_minimum:
.Lcerune_main_round_ties_even_3_maximum:
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_7(%rip), %rdx
  movl $71, %r8d
  callq _write
  ud2
.Lcerune_main_round_ties_even_3_done:
# cerune-origin: #20 bytes 167..207
cerune_origin_n20_main_27:
  movq %rax, %rdx
# cerune-origin: #20 bytes 167..207
cerune_origin_n20_main_28:
  leaq .Lcerune_fmt_i64(%rip), %rcx
# cerune-origin: #20 bytes 167..207
cerune_origin_n20_main_29:
  callq printf
# cerune-origin: #27 bytes 241..246
cerune_origin_n27_main_30:
  movsd .Lcerune_f64_4(%rip), %xmm0
# cerune-origin: #26 bytes 235..247
cerune_origin_n26_main_31:
  movsd %xmm0, -8(%rbp)
# cerune-origin: #26 bytes 235..247
cerune_origin_n26_main_32:
  movsd -8(%rbp), %xmm0
  callq cerune_fn_value_0
# cerune-origin: #25 bytes 214..248
cerune_origin_n25_main_33:
  # policy: saturating_trunc
  movapd %xmm0, %xmm2
  ucomisd %xmm2, %xmm2
  jp .Lcerune_main_saturating_trunc_4_nonfinite
  movabsq $9218868437227405312, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  je .Lcerune_main_saturating_trunc_4_nonfinite
  movabsq $-4503599627370496, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  je .Lcerune_main_saturating_trunc_4_nonfinite
  # round finite input; large values are already integral
  movabsq $4841369599423283200, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  jae .Lcerune_main_saturating_trunc_4_bounds
  movabsq $-4382002437431492608, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  jbe .Lcerune_main_saturating_trunc_4_bounds
  cvttsd2siq %xmm2, %rax
  cvtsi2sdq %rax, %xmm3
  subsd %xmm3, %xmm2
  jmp .Lcerune_main_saturating_trunc_4_rounded
.Lcerune_main_saturating_trunc_4_up:
  addq $1, %rax
  jmp .Lcerune_main_saturating_trunc_4_rounded
.Lcerune_main_saturating_trunc_4_down:
  subq $1, %rax
.Lcerune_main_saturating_trunc_4_rounded:
  cvtsi2sdq %rax, %xmm2
.Lcerune_main_saturating_trunc_4_bounds:
  # range policy after rounding, then convert
  movabsq $0, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  jb .Lcerune_main_saturating_trunc_4_minimum
  movabsq $4643211215818981376, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  jae .Lcerune_main_saturating_trunc_4_maximum
  cvttsd2siq %xmm2, %rax
  jmp .Lcerune_main_saturating_trunc_4_done
.Lcerune_main_saturating_trunc_4_nonfinite:
  ucomisd %xmm2, %xmm2
  jp .Lcerune_main_saturating_trunc_4_zero
  movabsq $0, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  ja .Lcerune_main_saturating_trunc_4_maximum
  jmp .Lcerune_main_saturating_trunc_4_minimum
.Lcerune_main_saturating_trunc_4_zero:
  xorq %rax, %rax
  jmp .Lcerune_main_saturating_trunc_4_done
.Lcerune_main_saturating_trunc_4_minimum:
  movabsq $0, %rax
  jmp .Lcerune_main_saturating_trunc_4_done
.Lcerune_main_saturating_trunc_4_maximum:
  movabsq $255, %rax
.Lcerune_main_saturating_trunc_4_done:
# cerune-origin: #24 bytes 208..250
cerune_origin_n24_main_34:
  movq %rax, %rdx
# cerune-origin: #24 bytes 208..250
cerune_origin_n24_main_35:
  leaq .Lcerune_fmt_i64(%rip), %rcx
# cerune-origin: #24 bytes 208..250
cerune_origin_n24_main_36:
  callq printf
# cerune-origin: #32 bytes 285..288
cerune_origin_n32_main_37:
  movsd .Lcerune_f64_5(%rip), %xmm0
# cerune-origin: #31 bytes 284..288
cerune_origin_n31_main_38:
  xorpd .Lcerune_sign_f64(%rip), %xmm0
# cerune-origin: #30 bytes 278..289
cerune_origin_n30_main_39:
  movsd %xmm0, -8(%rbp)
# cerune-origin: #30 bytes 278..289
cerune_origin_n30_main_40:
  movsd -8(%rbp), %xmm0
  callq cerune_fn_value_0
# cerune-origin: #29 bytes 257..290
cerune_origin_n29_main_41:
  # policy: saturating_floor
  movapd %xmm0, %xmm2
  ucomisd %xmm2, %xmm2
  jp .Lcerune_main_saturating_floor_5_nonfinite
  movabsq $9218868437227405312, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  je .Lcerune_main_saturating_floor_5_nonfinite
  movabsq $-4503599627370496, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  je .Lcerune_main_saturating_floor_5_nonfinite
  # round finite input; large values are already integral
  movabsq $4841369599423283200, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  jae .Lcerune_main_saturating_floor_5_bounds
  movabsq $-4382002437431492608, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  jbe .Lcerune_main_saturating_floor_5_bounds
  cvttsd2siq %xmm2, %rax
  cvtsi2sdq %rax, %xmm3
  subsd %xmm3, %xmm2
  movabsq $0, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  jb .Lcerune_main_saturating_floor_5_down
  jmp .Lcerune_main_saturating_floor_5_rounded
.Lcerune_main_saturating_floor_5_up:
  addq $1, %rax
  jmp .Lcerune_main_saturating_floor_5_rounded
.Lcerune_main_saturating_floor_5_down:
  subq $1, %rax
.Lcerune_main_saturating_floor_5_rounded:
  cvtsi2sdq %rax, %xmm2
.Lcerune_main_saturating_floor_5_bounds:
  # range policy after rounding, then convert
  movabsq $0, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  jb .Lcerune_main_saturating_floor_5_minimum
  movabsq $4643211215818981376, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  jae .Lcerune_main_saturating_floor_5_maximum
  cvttsd2siq %xmm2, %rax
  jmp .Lcerune_main_saturating_floor_5_done
.Lcerune_main_saturating_floor_5_nonfinite:
  ucomisd %xmm2, %xmm2
  jp .Lcerune_main_saturating_floor_5_zero
  movabsq $0, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  ja .Lcerune_main_saturating_floor_5_maximum
  jmp .Lcerune_main_saturating_floor_5_minimum
.Lcerune_main_saturating_floor_5_zero:
  xorq %rax, %rax
  jmp .Lcerune_main_saturating_floor_5_done
.Lcerune_main_saturating_floor_5_minimum:
  movabsq $0, %rax
  jmp .Lcerune_main_saturating_floor_5_done
.Lcerune_main_saturating_floor_5_maximum:
  movabsq $255, %rax
.Lcerune_main_saturating_floor_5_done:
# cerune-origin: #28 bytes 251..292
cerune_origin_n28_main_42:
  movq %rax, %rdx
# cerune-origin: #28 bytes 251..292
cerune_origin_n28_main_43:
  leaq .Lcerune_fmt_i64(%rip), %rcx
# cerune-origin: #28 bytes 251..292
cerune_origin_n28_main_44:
  callq printf
# cerune-origin: #36 bytes 325..330
cerune_origin_n36_main_45:
  movsd .Lcerune_f64_6(%rip), %xmm0
# cerune-origin: #35 bytes 319..331
cerune_origin_n35_main_46:
  movsd %xmm0, -8(%rbp)
# cerune-origin: #35 bytes 319..331
cerune_origin_n35_main_47:
  movsd -8(%rbp), %xmm0
  callq cerune_fn_value_0
# cerune-origin: #34 bytes 299..332
cerune_origin_n34_main_48:
  # policy: saturating_ceil
  movapd %xmm0, %xmm2
  ucomisd %xmm2, %xmm2
  jp .Lcerune_main_saturating_ceil_6_nonfinite
  movabsq $9218868437227405312, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  je .Lcerune_main_saturating_ceil_6_nonfinite
  movabsq $-4503599627370496, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  je .Lcerune_main_saturating_ceil_6_nonfinite
  # round finite input; large values are already integral
  movabsq $4841369599423283200, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  jae .Lcerune_main_saturating_ceil_6_bounds
  movabsq $-4382002437431492608, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  jbe .Lcerune_main_saturating_ceil_6_bounds
  cvttsd2siq %xmm2, %rax
  cvtsi2sdq %rax, %xmm3
  subsd %xmm3, %xmm2
  movabsq $0, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  ja .Lcerune_main_saturating_ceil_6_up
  jmp .Lcerune_main_saturating_ceil_6_rounded
.Lcerune_main_saturating_ceil_6_up:
  addq $1, %rax
  jmp .Lcerune_main_saturating_ceil_6_rounded
.Lcerune_main_saturating_ceil_6_down:
  subq $1, %rax
.Lcerune_main_saturating_ceil_6_rounded:
  cvtsi2sdq %rax, %xmm2
.Lcerune_main_saturating_ceil_6_bounds:
  # range policy after rounding, then convert
  movabsq $0, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  jb .Lcerune_main_saturating_ceil_6_minimum
  movabsq $4643211215818981376, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  jae .Lcerune_main_saturating_ceil_6_maximum
  cvttsd2siq %xmm2, %rax
  jmp .Lcerune_main_saturating_ceil_6_done
.Lcerune_main_saturating_ceil_6_nonfinite:
  ucomisd %xmm2, %xmm2
  jp .Lcerune_main_saturating_ceil_6_zero
  movabsq $0, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  ja .Lcerune_main_saturating_ceil_6_maximum
  jmp .Lcerune_main_saturating_ceil_6_minimum
.Lcerune_main_saturating_ceil_6_zero:
  xorq %rax, %rax
  jmp .Lcerune_main_saturating_ceil_6_done
.Lcerune_main_saturating_ceil_6_minimum:
  movabsq $0, %rax
  jmp .Lcerune_main_saturating_ceil_6_done
.Lcerune_main_saturating_ceil_6_maximum:
  movabsq $255, %rax
.Lcerune_main_saturating_ceil_6_done:
# cerune-origin: #33 bytes 293..334
cerune_origin_n33_main_49:
  movq %rax, %rdx
# cerune-origin: #33 bytes 293..334
cerune_origin_n33_main_50:
  leaq .Lcerune_fmt_i64(%rip), %rcx
# cerune-origin: #33 bytes 293..334
cerune_origin_n33_main_51:
  callq printf
# cerune-origin: #40 bytes 368..373
cerune_origin_n40_main_52:
  movsd .Lcerune_f64_7(%rip), %xmm0
# cerune-origin: #39 bytes 362..374
cerune_origin_n39_main_53:
  movsd %xmm0, -8(%rbp)
# cerune-origin: #39 bytes 362..374
cerune_origin_n39_main_54:
  movsd -8(%rbp), %xmm0
  callq cerune_fn_value_0
# cerune-origin: #38 bytes 341..375
cerune_origin_n38_main_55:
  # policy: saturating_round
  movapd %xmm0, %xmm2
  ucomisd %xmm2, %xmm2
  jp .Lcerune_main_saturating_round_7_nonfinite
  movabsq $9218868437227405312, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  je .Lcerune_main_saturating_round_7_nonfinite
  movabsq $-4503599627370496, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  je .Lcerune_main_saturating_round_7_nonfinite
  # round finite input; large values are already integral
  movabsq $4841369599423283200, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  jae .Lcerune_main_saturating_round_7_bounds
  movabsq $-4382002437431492608, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  jbe .Lcerune_main_saturating_round_7_bounds
  cvttsd2siq %xmm2, %rax
  cvtsi2sdq %rax, %xmm3
  subsd %xmm3, %xmm2
  movabsq $4602678819172646912, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  jae .Lcerune_main_saturating_round_7_up
  movabsq $-4620693217682128896, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  jbe .Lcerune_main_saturating_round_7_down
  jmp .Lcerune_main_saturating_round_7_rounded
.Lcerune_main_saturating_round_7_up:
  addq $1, %rax
  jmp .Lcerune_main_saturating_round_7_rounded
.Lcerune_main_saturating_round_7_down:
  subq $1, %rax
.Lcerune_main_saturating_round_7_rounded:
  cvtsi2sdq %rax, %xmm2
.Lcerune_main_saturating_round_7_bounds:
  # range policy after rounding, then convert
  movabsq $0, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  jb .Lcerune_main_saturating_round_7_minimum
  movabsq $4643211215818981376, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  jae .Lcerune_main_saturating_round_7_maximum
  cvttsd2siq %xmm2, %rax
  jmp .Lcerune_main_saturating_round_7_done
.Lcerune_main_saturating_round_7_nonfinite:
  ucomisd %xmm2, %xmm2
  jp .Lcerune_main_saturating_round_7_zero
  movabsq $0, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  ja .Lcerune_main_saturating_round_7_maximum
  jmp .Lcerune_main_saturating_round_7_minimum
.Lcerune_main_saturating_round_7_zero:
  xorq %rax, %rax
  jmp .Lcerune_main_saturating_round_7_done
.Lcerune_main_saturating_round_7_minimum:
  movabsq $0, %rax
  jmp .Lcerune_main_saturating_round_7_done
.Lcerune_main_saturating_round_7_maximum:
  movabsq $255, %rax
.Lcerune_main_saturating_round_7_done:
# cerune-origin: #37 bytes 335..377
cerune_origin_n37_main_56:
  movq %rax, %rdx
# cerune-origin: #37 bytes 335..377
cerune_origin_n37_main_57:
  leaq .Lcerune_fmt_i64(%rip), %rcx
# cerune-origin: #37 bytes 335..377
cerune_origin_n37_main_58:
  callq printf
# cerune-origin: #44 bytes 421..426
cerune_origin_n44_main_59:
  movsd .Lcerune_f64_8(%rip), %xmm0
# cerune-origin: #43 bytes 415..427
cerune_origin_n43_main_60:
  movsd %xmm0, -8(%rbp)
# cerune-origin: #43 bytes 415..427
cerune_origin_n43_main_61:
  movsd -8(%rbp), %xmm0
  callq cerune_fn_value_0
# cerune-origin: #42 bytes 384..428
cerune_origin_n42_main_62:
  # policy: saturating_round_ties_even
  movapd %xmm0, %xmm2
  ucomisd %xmm2, %xmm2
  jp .Lcerune_main_saturating_round_ties_even_8_nonfinite
  movabsq $9218868437227405312, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  je .Lcerune_main_saturating_round_ties_even_8_nonfinite
  movabsq $-4503599627370496, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  je .Lcerune_main_saturating_round_ties_even_8_nonfinite
  # round finite input; large values are already integral
  movabsq $4841369599423283200, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  jae .Lcerune_main_saturating_round_ties_even_8_bounds
  movabsq $-4382002437431492608, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  jbe .Lcerune_main_saturating_round_ties_even_8_bounds
  cvttsd2siq %xmm2, %rax
  cvtsi2sdq %rax, %xmm3
  subsd %xmm3, %xmm2
  movabsq $4602678819172646912, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  ja .Lcerune_main_saturating_round_ties_even_8_up
  je .Lcerune_main_saturating_round_ties_even_8_tie
  movabsq $-4620693217682128896, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  jb .Lcerune_main_saturating_round_ties_even_8_down
  jne .Lcerune_main_saturating_round_ties_even_8_rounded
.Lcerune_main_saturating_round_ties_even_8_tie:
  testq $1, %rax
  je .Lcerune_main_saturating_round_ties_even_8_rounded
  movabsq $0, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  ja .Lcerune_main_saturating_round_ties_even_8_up
  jmp .Lcerune_main_saturating_round_ties_even_8_down
  jmp .Lcerune_main_saturating_round_ties_even_8_rounded
.Lcerune_main_saturating_round_ties_even_8_up:
  addq $1, %rax
  jmp .Lcerune_main_saturating_round_ties_even_8_rounded
.Lcerune_main_saturating_round_ties_even_8_down:
  subq $1, %rax
.Lcerune_main_saturating_round_ties_even_8_rounded:
  cvtsi2sdq %rax, %xmm2
.Lcerune_main_saturating_round_ties_even_8_bounds:
  # range policy after rounding, then convert
  movabsq $0, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  jb .Lcerune_main_saturating_round_ties_even_8_minimum
  movabsq $4643211215818981376, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  jae .Lcerune_main_saturating_round_ties_even_8_maximum
  cvttsd2siq %xmm2, %rax
  jmp .Lcerune_main_saturating_round_ties_even_8_done
.Lcerune_main_saturating_round_ties_even_8_nonfinite:
  ucomisd %xmm2, %xmm2
  jp .Lcerune_main_saturating_round_ties_even_8_zero
  movabsq $0, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  ja .Lcerune_main_saturating_round_ties_even_8_maximum
  jmp .Lcerune_main_saturating_round_ties_even_8_minimum
.Lcerune_main_saturating_round_ties_even_8_zero:
  xorq %rax, %rax
  jmp .Lcerune_main_saturating_round_ties_even_8_done
.Lcerune_main_saturating_round_ties_even_8_minimum:
  movabsq $0, %rax
  jmp .Lcerune_main_saturating_round_ties_even_8_done
.Lcerune_main_saturating_round_ties_even_8_maximum:
  movabsq $255, %rax
.Lcerune_main_saturating_round_ties_even_8_done:
# cerune-origin: #41 bytes 378..430
cerune_origin_n41_main_63:
  movq %rax, %rdx
# cerune-origin: #41 bytes 378..430
cerune_origin_n41_main_64:
  leaq .Lcerune_fmt_i64(%rip), %rcx
# cerune-origin: #41 bytes 378..430
cerune_origin_n41_main_65:
  callq printf
# cerune-origin: #47 bytes 437..442
cerune_origin_n47_main_66:
  movabsq $3, %rax
# cerune-origin: #45 bytes 431..444
cerune_origin_n45_main_67:
  movq %rax, %rdx
# cerune-origin: #45 bytes 431..444
cerune_origin_n45_main_68:
  leaq .Lcerune_fmt_i64(%rip), %rcx
# cerune-origin: #45 bytes 431..444
cerune_origin_n45_main_69:
  callq printf
# cerune-origin: synthetic
  xorl %eax, %eax
  addq $224, %rsp
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
