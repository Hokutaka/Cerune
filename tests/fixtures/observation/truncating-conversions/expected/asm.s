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
.Lcerune_fmt_u64:
  .asciz "%llu\n"
.p2align 3
.Lcerune_f64_0:
  .quad 0x400D99999999999A
.p2align 3
.Lcerune_f64_1:
  .quad 0x406FFCCCCCCCCCCD
.p2align 3
.Lcerune_f64_2:
  .quad 0x3FECCCCCCCCCCCCD
.p2align 3
.Lcerune_f64_3:
  .quad 0x4000000000000000

.text
.globl main
.p2align 4
main:
  pushq %rbp
  movq %rsp, %rbp
  subq $80, %rsp
  movsd .Lcerune_f64_0(%rip), %xmm0
  xorpd .Lcerune_sign_f64(%rip), %xmm0
  movapd %xmm0, %xmm2
  ucomisd %xmm2, %xmm2
  jp .Lcerune_main_trunc_0_nonfinite
  movabsq $9218868437227405312, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  je .Lcerune_main_trunc_0_nonfinite
  movabsq $-4503599627370496, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  je .Lcerune_main_trunc_0_nonfinite
  movabsq $-4332462841530417152, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  jb .Lcerune_main_trunc_0_range
  movabsq $4890909195324358656, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  jae .Lcerune_main_trunc_0_range
  cvttsd2siq %xmm2, %rax
  jmp .Lcerune_main_trunc_0_done
.Lcerune_main_trunc_0_nonfinite:
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_0(%rip), %rdx
  movl $65, %r8d
  callq _write
  ud2
.Lcerune_main_trunc_0_range:
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_1(%rip), %rdx
  movl $67, %r8d
  callq _write
  ud2
.Lcerune_main_trunc_0_done:
  movq %rax, %rdx
  leaq .Lcerune_fmt_i64(%rip), %rcx
  callq printf
  movsd .Lcerune_f64_1(%rip), %xmm0
  movapd %xmm0, %xmm2
  ucomisd %xmm2, %xmm2
  jp .Lcerune_main_trunc_1_nonfinite
  movabsq $9218868437227405312, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  je .Lcerune_main_trunc_1_nonfinite
  movabsq $-4503599627370496, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  je .Lcerune_main_trunc_1_nonfinite
  movabsq $-4616189618054758400, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  jbe .Lcerune_main_trunc_1_range
  movabsq $4643211215818981376, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  jae .Lcerune_main_trunc_1_range
  cvttsd2siq %xmm2, %rax
  jmp .Lcerune_main_trunc_1_done
.Lcerune_main_trunc_1_nonfinite:
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_2(%rip), %rdx
  movl $66, %r8d
  callq _write
  ud2
.Lcerune_main_trunc_1_range:
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_3(%rip), %rdx
  movl $68, %r8d
  callq _write
  ud2
.Lcerune_main_trunc_1_done:
  movq %rax, %rdx
  leaq .Lcerune_fmt_i64(%rip), %rcx
  callq printf
  movsd .Lcerune_f64_2(%rip), %xmm0
  xorpd .Lcerune_sign_f64(%rip), %xmm0
  movapd %xmm0, %xmm2
  ucomisd %xmm2, %xmm2
  jp .Lcerune_main_trunc_2_nonfinite
  movabsq $9218868437227405312, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  je .Lcerune_main_trunc_2_nonfinite
  movabsq $-4503599627370496, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  je .Lcerune_main_trunc_2_nonfinite
  movabsq $-4616189618054758400, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  jbe .Lcerune_main_trunc_2_range
  movabsq $4895412794951729152, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  jae .Lcerune_main_trunc_2_range
  movabsq $4890909195324358656, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  jb .Lcerune_main_trunc_2_small
  movapd %xmm2, %xmm3
  subsd %xmm1, %xmm3
  cvttsd2siq %xmm3, %rax
  btcq $63, %rax
  jmp .Lcerune_main_trunc_2_done
.Lcerune_main_trunc_2_small:
  cvttsd2siq %xmm2, %rax
  jmp .Lcerune_main_trunc_2_done
.Lcerune_main_trunc_2_nonfinite:
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_4(%rip), %rdx
  movl $66, %r8d
  callq _write
  ud2
.Lcerune_main_trunc_2_range:
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_5(%rip), %rdx
  movl $68, %r8d
  callq _write
  ud2
.Lcerune_main_trunc_2_done:
  movq %rax, %rdx
  leaq .Lcerune_fmt_u64(%rip), %rcx
  callq printf
  movsd .Lcerune_f64_3(%rip), %xmm0
  movapd %xmm0, %xmm2
  ucomisd %xmm2, %xmm2
  jp .Lcerune_main_convert_bad_3_nonfinite
  movabsq $9218868437227405312, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  je .Lcerune_main_convert_bad_3_nonfinite
  movabsq $-4503599627370496, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  je .Lcerune_main_convert_bad_3_nonfinite
  movq %xmm2, %r11
  movabsq $-9223372036854775808, %r10
  cmpq %r10, %r11
  jne .Lcerune_main_convert_bad_3_finite
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_6(%rip), %rdx
  movl $70, %r8d
  callq _write
  ud2
.Lcerune_main_convert_bad_3_nonfinite:
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_7(%rip), %rdx
  movl $67, %r8d
  callq _write
  ud2
.Lcerune_main_convert_bad_3_finite:
  movabsq $-4332462841530417152, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  jb .Lcerune_main_convert_bad_3_range
  movabsq $4890909195324358656, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  jae .Lcerune_main_convert_bad_3_range
  cvttsd2siq %xmm2, %rax
  cvtsi2sdq %rax, %xmm1
  ucomisd %xmm1, %xmm2
  jne .Lcerune_main_convert_bad_3
  jmp .Lcerune_main_convert_done_3
.Lcerune_main_convert_bad_3:
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_8(%rip), %rdx
  movl $64, %r8d
  callq _write
  ud2
.Lcerune_main_convert_bad_3_range:
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_9(%rip), %rdx
  movl $69, %r8d
  callq _write
  ud2
.Lcerune_main_convert_bad_3_nan:
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_10(%rip), %rdx
  movl $60, %r8d
  callq _write
  ud2
.Lcerune_main_convert_done_3:
  movq %rax, %rdx
  leaq .Lcerune_fmt_i64(%rip), %rcx
  callq printf
  xorl %eax, %eax
  addq $80, %rsp
  popq %rbp
  retq

.section .rdata,"dr"
.Lcerune_failure_0:
  .asciz "cerune: runtime-v1 code=conversion-not-finite node=1 bytes=6..22\n"
.Lcerune_failure_1:
  .asciz "cerune: runtime-v1 code=conversion-out-of-range node=1 bytes=6..22\n"
.Lcerune_failure_2:
  .asciz "cerune: runtime-v1 code=conversion-not-finite node=5 bytes=31..47\n"
.Lcerune_failure_3:
  .asciz "cerune: runtime-v1 code=conversion-out-of-range node=5 bytes=31..47\n"
.Lcerune_failure_4:
  .asciz "cerune: runtime-v1 code=conversion-not-finite node=8 bytes=56..72\n"
.Lcerune_failure_5:
  .asciz "cerune: runtime-v1 code=conversion-out-of-range node=8 bytes=56..72\n"
.Lcerune_failure_6:
  .asciz "cerune: runtime-v1 code=conversion-negative-zero node=12 bytes=81..98\n"
.Lcerune_failure_7:
  .asciz "cerune: runtime-v1 code=conversion-not-finite node=12 bytes=81..98\n"
.Lcerune_failure_8:
  .asciz "cerune: runtime-v1 code=conversion-inexact node=12 bytes=81..98\n"
.Lcerune_failure_9:
  .asciz "cerune: runtime-v1 code=conversion-out-of-range node=12 bytes=81..98\n"
.Lcerune_failure_10:
  .asciz "cerune: runtime-v1 code=conversion-nan node=12 bytes=81..98\n"
