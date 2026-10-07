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
  jmp .Lcerune_fn_0_block_0
.Lcerune_fn_0_block_0: # mir_block
  movsd -8(%rbp), %xmm0
  movsd %xmm0, -16(%rbp)
  movsd -16(%rbp), %xmm0
  addq $48, %rsp
  popq %rbp
  retq
.Lcerune_fn_0_block_1: # mir_block
  ud2

.globl main
.p2align 4
main:
  pushq %rbp
  movq %rsp, %rbp
  subq $288, %rsp
  jmp .Lcerune_block_0
.Lcerune_block_0: # mir_block
  movsd .Lcerune_f64_0(%rip), %xmm0
  movsd %xmm0, -8(%rbp)
  movsd -8(%rbp), %xmm0
  xorpd .Lcerune_sign_f64(%rip), %xmm0
  movsd %xmm0, -16(%rbp)
  movsd -16(%rbp), %xmm0
  callq cerune_fn_value_0
  movsd %xmm0, -24(%rbp)
  movsd -24(%rbp), %xmm0
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
  movq %rax, -32(%rbp)
  movq -32(%rbp), %rax
  movq %rax, %rdx
  leaq .Lcerune_fmt_i64(%rip), %rcx
  callq printf
  movsd .Lcerune_f64_1(%rip), %xmm0
  movsd %xmm0, -40(%rbp)
  movsd -40(%rbp), %xmm0
  xorpd .Lcerune_sign_f64(%rip), %xmm0
  movsd %xmm0, -48(%rbp)
  movsd -48(%rbp), %xmm0
  callq cerune_fn_value_0
  movsd %xmm0, -56(%rbp)
  movsd -56(%rbp), %xmm0
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
  movq %rax, -64(%rbp)
  movq -64(%rbp), %rax
  movq %rax, %rdx
  leaq .Lcerune_fmt_i64(%rip), %rcx
  callq printf
  movsd .Lcerune_f64_2(%rip), %xmm0
  movsd %xmm0, -72(%rbp)
  movsd -72(%rbp), %xmm0
  callq cerune_fn_value_0
  movsd %xmm0, -80(%rbp)
  movsd -80(%rbp), %xmm0
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
  movq %rax, -88(%rbp)
  movq -88(%rbp), %rax
  movq %rax, %rdx
  leaq .Lcerune_fmt_i64(%rip), %rcx
  callq printf
  movsd .Lcerune_f64_3(%rip), %xmm0
  movsd %xmm0, -96(%rbp)
  movsd -96(%rbp), %xmm0
  callq cerune_fn_value_0
  movsd %xmm0, -104(%rbp)
  movsd -104(%rbp), %xmm0
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
  movq %rax, -112(%rbp)
  movq -112(%rbp), %rax
  movq %rax, %rdx
  leaq .Lcerune_fmt_i64(%rip), %rcx
  callq printf
  movsd .Lcerune_f64_4(%rip), %xmm0
  movsd %xmm0, -120(%rbp)
  movsd -120(%rbp), %xmm0
  callq cerune_fn_value_0
  movsd %xmm0, -128(%rbp)
  movsd -128(%rbp), %xmm0
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
  movq %rax, -136(%rbp)
  movq -136(%rbp), %rax
  movq %rax, %rdx
  leaq .Lcerune_fmt_i64(%rip), %rcx
  callq printf
  movsd .Lcerune_f64_5(%rip), %xmm0
  movsd %xmm0, -144(%rbp)
  movsd -144(%rbp), %xmm0
  xorpd .Lcerune_sign_f64(%rip), %xmm0
  movsd %xmm0, -152(%rbp)
  movsd -152(%rbp), %xmm0
  callq cerune_fn_value_0
  movsd %xmm0, -160(%rbp)
  movsd -160(%rbp), %xmm0
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
  movq %rax, -168(%rbp)
  movq -168(%rbp), %rax
  movq %rax, %rdx
  leaq .Lcerune_fmt_i64(%rip), %rcx
  callq printf
  movsd .Lcerune_f64_6(%rip), %xmm0
  movsd %xmm0, -176(%rbp)
  movsd -176(%rbp), %xmm0
  callq cerune_fn_value_0
  movsd %xmm0, -184(%rbp)
  movsd -184(%rbp), %xmm0
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
  movq %rax, -192(%rbp)
  movq -192(%rbp), %rax
  movq %rax, %rdx
  leaq .Lcerune_fmt_i64(%rip), %rcx
  callq printf
  movsd .Lcerune_f64_7(%rip), %xmm0
  movsd %xmm0, -200(%rbp)
  movsd -200(%rbp), %xmm0
  callq cerune_fn_value_0
  movsd %xmm0, -208(%rbp)
  movsd -208(%rbp), %xmm0
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
  movq %rax, -216(%rbp)
  movq -216(%rbp), %rax
  movq %rax, %rdx
  leaq .Lcerune_fmt_i64(%rip), %rcx
  callq printf
  movsd .Lcerune_f64_8(%rip), %xmm0
  movsd %xmm0, -224(%rbp)
  movsd -224(%rbp), %xmm0
  callq cerune_fn_value_0
  movsd %xmm0, -232(%rbp)
  movsd -232(%rbp), %xmm0
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
  movq %rax, -240(%rbp)
  movq -240(%rbp), %rax
  movq %rax, %rdx
  leaq .Lcerune_fmt_i64(%rip), %rcx
  callq printf
  movabsq $3, %rax
  movq %rax, -248(%rbp)
  movq -248(%rbp), %rax
  movq %rax, -256(%rbp)
  movq -256(%rbp), %rax
  movq %rax, %rdx
  leaq .Lcerune_fmt_i64(%rip), %rcx
  callq printf
  jmp .Lcerune_block_1
.Lcerune_block_1: # main_exit
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
