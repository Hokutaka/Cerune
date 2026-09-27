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
.p2align 4
cerune_fn_value_0:
  pushq %rbp
  movq %rsp, %rbp
  subq $48, %rsp
  movsd %xmm0, -8(%rbp)
  movsd -8(%rbp), %xmm0
  addq $48, %rsp
  popq %rbp
  retq

.globl main
.p2align 4
main:
  pushq %rbp
  movq %rsp, %rbp
  subq $224, %rsp
  movsd .Lcerune_f64_0(%rip), %xmm0
  xorpd .Lcerune_sign_f64(%rip), %xmm0
  movsd %xmm0, -8(%rbp)
  movsd -8(%rbp), %xmm0
  callq cerune_fn_value_0
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
  movq %rax, %rdx
  leaq .Lcerune_fmt_i64(%rip), %rcx
  callq printf
  movsd .Lcerune_f64_1(%rip), %xmm0
  xorpd .Lcerune_sign_f64(%rip), %xmm0
  movsd %xmm0, -8(%rbp)
  movsd -8(%rbp), %xmm0
  callq cerune_fn_value_0
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
  movq %rax, %rdx
  leaq .Lcerune_fmt_i64(%rip), %rcx
  callq printf
  movsd .Lcerune_f64_2(%rip), %xmm0
  movsd %xmm0, -8(%rbp)
  movsd -8(%rbp), %xmm0
  callq cerune_fn_value_0
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
  movq %rax, %rdx
  leaq .Lcerune_fmt_i64(%rip), %rcx
  callq printf
  movsd .Lcerune_f64_3(%rip), %xmm0
  movsd %xmm0, -8(%rbp)
  movsd -8(%rbp), %xmm0
  callq cerune_fn_value_0
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
  movq %rax, %rdx
  leaq .Lcerune_fmt_i64(%rip), %rcx
  callq printf
  movsd .Lcerune_f64_4(%rip), %xmm0
  movsd %xmm0, -8(%rbp)
  movsd -8(%rbp), %xmm0
  callq cerune_fn_value_0
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
  movq %rax, %rdx
  leaq .Lcerune_fmt_i64(%rip), %rcx
  callq printf
  movsd .Lcerune_f64_5(%rip), %xmm0
  xorpd .Lcerune_sign_f64(%rip), %xmm0
  movsd %xmm0, -8(%rbp)
  movsd -8(%rbp), %xmm0
  callq cerune_fn_value_0
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
  movq %rax, %rdx
  leaq .Lcerune_fmt_i64(%rip), %rcx
  callq printf
  movsd .Lcerune_f64_6(%rip), %xmm0
  movsd %xmm0, -8(%rbp)
  movsd -8(%rbp), %xmm0
  callq cerune_fn_value_0
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
  movq %rax, %rdx
  leaq .Lcerune_fmt_i64(%rip), %rcx
  callq printf
  movsd .Lcerune_f64_7(%rip), %xmm0
  movsd %xmm0, -8(%rbp)
  movsd -8(%rbp), %xmm0
  callq cerune_fn_value_0
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
  movq %rax, %rdx
  leaq .Lcerune_fmt_i64(%rip), %rcx
  callq printf
  movsd .Lcerune_f64_8(%rip), %xmm0
  movsd %xmm0, -8(%rbp)
  movsd -8(%rbp), %xmm0
  callq cerune_fn_value_0
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
  movq %rax, %rdx
  leaq .Lcerune_fmt_i64(%rip), %rcx
  callq printf
  movabsq $3, %rax
  movq %rax, %rdx
  leaq .Lcerune_fmt_i64(%rip), %rcx
  callq printf
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
