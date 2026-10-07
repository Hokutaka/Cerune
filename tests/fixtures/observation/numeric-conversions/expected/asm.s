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
  .quad 0x0000000000000000

.text
.p2align 4
cerune_fn_measure_0:
  pushq %rbp
  movq %rsp, %rbp
  subq $80, %rsp
  movq %rcx, -8(%rbp)
  jmp .Lcerune_fn_0_block_0
.Lcerune_fn_0_block_0: # mir_block
  movq -8(%rbp), %rax
  movq %rax, -16(%rbp)
  movq -16(%rbp), %rax
  movq %rax, %r10
  cvtsi2sdq %rax, %xmm0
  movapd %xmm0, %xmm2
  movabsq $4890909195324358656, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  jae .Lcerune_fn_0_convert_bad_3
  cvttsd2siq %xmm2, %rax
  cmpq %r10, %rax
  jne .Lcerune_fn_0_convert_bad_3
  jmp .Lcerune_fn_0_convert_done_3
.Lcerune_fn_0_convert_bad_3:
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_0(%rip), %rdx
  movl $63, %r8d
  callq _write
  movl $7, %ecx
  int $0x29
.Lcerune_fn_0_convert_done_3:
  movsd %xmm0, -24(%rbp)
  movabsq $2, %rax
  movq %rax, -32(%rbp)
  movq -32(%rbp), %rax
  movq %rax, %r10
  cvtsi2sdq %rax, %xmm0
  movapd %xmm0, %xmm2
  movabsq $4890909195324358656, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  jae .Lcerune_fn_0_convert_bad_4
  cvttsd2siq %xmm2, %rax
  cmpq %r10, %rax
  jne .Lcerune_fn_0_convert_bad_4
  jmp .Lcerune_fn_0_convert_done_4
.Lcerune_fn_0_convert_bad_4:
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_1(%rip), %rdx
  movl $63, %r8d
  callq _write
  movl $7, %ecx
  int $0x29
.Lcerune_fn_0_convert_done_4:
  movsd %xmm0, -40(%rbp)
  movsd -40(%rbp), %xmm0
  movapd %xmm0, %xmm1
  movsd -24(%rbp), %xmm0
  divsd %xmm1, %xmm0
  movsd %xmm0, -48(%rbp)
  movsd -48(%rbp), %xmm0
  addq $80, %rsp
  popq %rbp
  retq
.Lcerune_fn_0_block_1: # mir_block
  ud2

.globl main
.p2align 4
main:
  pushq %rbp
  movq %rsp, %rbp
  subq $208, %rsp
  jmp .Lcerune_block_0
.Lcerune_block_0: # mir_block
  movabsq $42, %rax
  movq %rax, -8(%rbp)
  movq -8(%rbp), %rax
  movq %rax, -16(%rbp)
  movq -16(%rbp), %rax
  movq %rax, -24(%rbp)
  movq -24(%rbp), %rax
  movq %rax, %r10
  cvtsi2sdq %rax, %xmm0
  movapd %xmm0, %xmm2
  movabsq $4890909195324358656, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  jae .Lcerune_main_convert_bad_2
  cvttsd2siq %xmm2, %rax
  cmpq %r10, %rax
  jne .Lcerune_main_convert_bad_2
  jmp .Lcerune_main_convert_done_2
.Lcerune_main_convert_bad_2:
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_2(%rip), %rdx
  movl $64, %r8d
  callq _write
  movl $7, %ecx
  int $0x29
.Lcerune_main_convert_done_2:
  movsd %xmm0, -32(%rbp)
  movsd -32(%rbp), %xmm0
  movsd %xmm0, -40(%rbp)
  movsd -40(%rbp), %xmm0
  movsd %xmm0, -48(%rbp)
  movsd -48(%rbp), %xmm0
  ucomisd %xmm0, %xmm0
  jp .Lcerune_main_convert_bad_3_nan
  movapd %xmm0, %xmm2
  movabsq $9218868437227405312, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  je .Lcerune_main_convert_bad_3_convert
  movabsq $-4503599627370496, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  je .Lcerune_main_convert_bad_3_convert
  movabsq $5183643170566569984, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  ja .Lcerune_main_convert_bad_3_range
  movabsq $-4039728866288205824, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  jb .Lcerune_main_convert_bad_3_range
.Lcerune_main_convert_bad_3_convert:
  cvtsd2ss %xmm0, %xmm0
  cvtss2sd %xmm0, %xmm1
  ucomisd %xmm1, %xmm2
  jne .Lcerune_main_convert_bad_3
  jmp .Lcerune_main_convert_done_3
.Lcerune_main_convert_bad_3:
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_3(%rip), %rdx
  movl $66, %r8d
  callq _write
  movl $7, %ecx
  int $0x29
.Lcerune_main_convert_bad_3_range:
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_4(%rip), %rdx
  movl $71, %r8d
  callq _write
  movl $7, %ecx
  int $0x29
.Lcerune_main_convert_bad_3_nan:
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_5(%rip), %rdx
  movl $62, %r8d
  callq _write
  movl $7, %ecx
  int $0x29
.Lcerune_main_convert_done_3:
  movss %xmm0, -56(%rbp)
  movss -56(%rbp), %xmm0
  movss %xmm0, -64(%rbp)
  movss -64(%rbp), %xmm0
  movss %xmm0, -72(%rbp)
  movss -72(%rbp), %xmm0
  cvtss2sd %xmm0, %xmm2
  ucomisd %xmm2, %xmm2
  jp .Lcerune_main_convert_bad_4_nonfinite
  movabsq $9218868437227405312, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  je .Lcerune_main_convert_bad_4_nonfinite
  movabsq $-4503599627370496, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  je .Lcerune_main_convert_bad_4_nonfinite
  movq %xmm2, %r11
  movabsq $-9223372036854775808, %r10
  cmpq %r10, %r11
  jne .Lcerune_main_convert_bad_4_finite
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_6(%rip), %rdx
  movl $72, %r8d
  callq _write
  movl $7, %ecx
  int $0x29
.Lcerune_main_convert_bad_4_nonfinite:
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_7(%rip), %rdx
  movl $69, %r8d
  callq _write
  movl $7, %ecx
  int $0x29
.Lcerune_main_convert_bad_4_finite:
  movabsq $-4548635623644200960, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  jb .Lcerune_main_convert_bad_4_range
  movabsq $4674736413210574848, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  jae .Lcerune_main_convert_bad_4_range
  cvttsd2siq %xmm2, %rax
  cvtsi2sdq %rax, %xmm1
  ucomisd %xmm1, %xmm2
  jne .Lcerune_main_convert_bad_4
  jmp .Lcerune_main_convert_done_4
.Lcerune_main_convert_bad_4:
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_8(%rip), %rdx
  movl $66, %r8d
  callq _write
  movl $7, %ecx
  int $0x29
.Lcerune_main_convert_bad_4_range:
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_9(%rip), %rdx
  movl $71, %r8d
  callq _write
  movl $7, %ecx
  int $0x29
.Lcerune_main_convert_bad_4_nan:
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_10(%rip), %rdx
  movl $62, %r8d
  callq _write
  movl $7, %ecx
  int $0x29
.Lcerune_main_convert_done_4:
  movq %rax, -80(%rbp)
  movq -80(%rbp), %rax
  movq %rax, %rdx
  leaq .Lcerune_fmt_i64(%rip), %rcx
  callq printf
  movsd -40(%rbp), %xmm0
  movsd %xmm0, -88(%rbp)
  movsd -88(%rbp), %xmm0
  movapd %xmm0, %xmm2
  ucomisd %xmm2, %xmm2
  jp .Lcerune_main_convert_bad_5_nonfinite
  movabsq $9218868437227405312, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  je .Lcerune_main_convert_bad_5_nonfinite
  movabsq $-4503599627370496, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  je .Lcerune_main_convert_bad_5_nonfinite
  movq %xmm2, %r11
  movabsq $-9223372036854775808, %r10
  cmpq %r10, %r11
  jne .Lcerune_main_convert_bad_5_finite
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_11(%rip), %rdx
  movl $72, %r8d
  callq _write
  movl $7, %ecx
  int $0x29
.Lcerune_main_convert_bad_5_nonfinite:
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_12(%rip), %rdx
  movl $69, %r8d
  callq _write
  movl $7, %ecx
  int $0x29
.Lcerune_main_convert_bad_5_finite:
  movabsq $-4332462841530417152, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  jb .Lcerune_main_convert_bad_5_range
  movabsq $4890909195324358656, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  jae .Lcerune_main_convert_bad_5_range
  cvttsd2siq %xmm2, %rax
  cvtsi2sdq %rax, %xmm1
  ucomisd %xmm1, %xmm2
  jne .Lcerune_main_convert_bad_5
  jmp .Lcerune_main_convert_done_5
.Lcerune_main_convert_bad_5:
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_13(%rip), %rdx
  movl $66, %r8d
  callq _write
  movl $7, %ecx
  int $0x29
.Lcerune_main_convert_bad_5_range:
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_14(%rip), %rdx
  movl $71, %r8d
  callq _write
  movl $7, %ecx
  int $0x29
.Lcerune_main_convert_bad_5_nan:
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_15(%rip), %rdx
  movl $62, %r8d
  callq _write
  movl $7, %ecx
  int $0x29
.Lcerune_main_convert_done_5:
  movq %rax, -96(%rbp)
  movq -96(%rbp), %rax
  movq %rax, %rdx
  leaq .Lcerune_fmt_i64(%rip), %rcx
  callq printf
  movss -64(%rbp), %xmm0
  movss %xmm0, -104(%rbp)
  movss -104(%rbp), %xmm0
  ucomiss %xmm0, %xmm0
  jp .Lcerune_main_convert_bad_6_nan
  cvtss2sd %xmm0, %xmm0
  jmp .Lcerune_main_convert_done_6
.Lcerune_main_convert_bad_6:
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_16(%rip), %rdx
  movl $66, %r8d
  callq _write
  movl $7, %ecx
  int $0x29
.Lcerune_main_convert_bad_6_range:
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_17(%rip), %rdx
  movl $71, %r8d
  callq _write
  movl $7, %ecx
  int $0x29
.Lcerune_main_convert_bad_6_nan:
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_18(%rip), %rdx
  movl $62, %r8d
  callq _write
  movl $7, %ecx
  int $0x29
.Lcerune_main_convert_done_6:
  movsd %xmm0, -112(%rbp)
  movsd -112(%rbp), %xmm0
  movsd %xmm0, %xmm1
  movq %xmm1, %rdx
  leaq .Lcerune_fmt_f64(%rip), %rcx
  callq printf
  movq -16(%rbp), %rax
  movq %rax, -120(%rbp)
  movq -120(%rbp), %rax
  movq %rax, %r10
  cvtsi2ssq %rax, %xmm0
  cvtss2sd %xmm0, %xmm2
  movabsq $4890909195324358656, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  jae .Lcerune_main_convert_bad_7
  cvttsd2siq %xmm2, %rax
  cmpq %r10, %rax
  jne .Lcerune_main_convert_bad_7
  jmp .Lcerune_main_convert_done_7
.Lcerune_main_convert_bad_7:
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_19(%rip), %rdx
  movl $66, %r8d
  callq _write
  movl $7, %ecx
  int $0x29
.Lcerune_main_convert_done_7:
  movss %xmm0, -128(%rbp)
  movss -128(%rbp), %xmm0
  cvtss2sd %xmm0, %xmm1
  movq %xmm1, %rdx
  leaq .Lcerune_fmt_f32(%rip), %rcx
  callq printf
  movabsq $3, %rax
  movq %rax, -136(%rbp)
  movq -136(%rbp), %rcx
  callq cerune_fn_measure_0
  movsd %xmm0, -144(%rbp)
  movsd -144(%rbp), %xmm0
  movsd %xmm0, %xmm1
  movq %xmm1, %rdx
  leaq .Lcerune_fmt_f64(%rip), %rcx
  callq printf
  movsd .Lcerune_f64_0(%rip), %xmm0
  movsd %xmm0, -152(%rbp)
  movsd -152(%rbp), %xmm0
  xorpd .Lcerune_sign_f64(%rip), %xmm0
  movsd %xmm0, -160(%rbp)
  movsd -160(%rbp), %xmm0
  ucomisd %xmm0, %xmm0
  jp .Lcerune_main_convert_bad_8_nan
  movapd %xmm0, %xmm2
  movabsq $9218868437227405312, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  je .Lcerune_main_convert_bad_8_convert
  movabsq $-4503599627370496, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  je .Lcerune_main_convert_bad_8_convert
  movabsq $5183643170566569984, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  ja .Lcerune_main_convert_bad_8_range
  movabsq $-4039728866288205824, %r11
  movq %r11, %xmm1
  ucomisd %xmm1, %xmm2
  jb .Lcerune_main_convert_bad_8_range
.Lcerune_main_convert_bad_8_convert:
  cvtsd2ss %xmm0, %xmm0
  cvtss2sd %xmm0, %xmm1
  ucomisd %xmm1, %xmm2
  jne .Lcerune_main_convert_bad_8
  jmp .Lcerune_main_convert_done_8
.Lcerune_main_convert_bad_8:
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_20(%rip), %rdx
  movl $66, %r8d
  callq _write
  movl $7, %ecx
  int $0x29
.Lcerune_main_convert_bad_8_range:
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_21(%rip), %rdx
  movl $71, %r8d
  callq _write
  movl $7, %ecx
  int $0x29
.Lcerune_main_convert_bad_8_nan:
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_22(%rip), %rdx
  movl $62, %r8d
  callq _write
  movl $7, %ecx
  int $0x29
.Lcerune_main_convert_done_8:
  movss %xmm0, -168(%rbp)
  movss -168(%rbp), %xmm0
  cvtss2sd %xmm0, %xmm1
  movq %xmm1, %rdx
  leaq .Lcerune_fmt_f32(%rip), %rcx
  callq printf
  jmp .Lcerune_block_1
.Lcerune_block_1: # main_exit
  xorl %eax, %eax
  addq $208, %rsp
  popq %rbp
  retq

.section .rdata,"dr"
.Lcerune_failure_0:
  .asciz "cerune: runtime-v1 code=conversion-inexact node=2 bytes=43..53\n"
.Lcerune_failure_1:
  .asciz "cerune: runtime-v1 code=conversion-inexact node=4 bytes=56..62\n"
.Lcerune_failure_2:
  .asciz "cerune: runtime-v1 code=conversion-inexact node=9 bytes=95..114\n"
.Lcerune_failure_3:
  .asciz "cerune: runtime-v1 code=conversion-inexact node=12 bytes=130..139\n"
.Lcerune_failure_4:
  .asciz "cerune: runtime-v1 code=conversion-out-of-range node=12 bytes=130..139\n"
.Lcerune_failure_5:
  .asciz "cerune: runtime-v1 code=conversion-nan node=12 bytes=130..139\n"
.Lcerune_failure_6:
  .asciz "cerune: runtime-v1 code=conversion-negative-zero node=15 bytes=147..158\n"
.Lcerune_failure_7:
  .asciz "cerune: runtime-v1 code=conversion-not-finite node=15 bytes=147..158\n"
.Lcerune_failure_8:
  .asciz "cerune: runtime-v1 code=conversion-inexact node=15 bytes=147..158\n"
.Lcerune_failure_9:
  .asciz "cerune: runtime-v1 code=conversion-out-of-range node=15 bytes=147..158\n"
.Lcerune_failure_10:
  .asciz "cerune: runtime-v1 code=conversion-nan node=15 bytes=147..158\n"
.Lcerune_failure_11:
  .asciz "cerune: runtime-v1 code=conversion-negative-zero node=18 bytes=167..176\n"
.Lcerune_failure_12:
  .asciz "cerune: runtime-v1 code=conversion-not-finite node=18 bytes=167..176\n"
.Lcerune_failure_13:
  .asciz "cerune: runtime-v1 code=conversion-inexact node=18 bytes=167..176\n"
.Lcerune_failure_14:
  .asciz "cerune: runtime-v1 code=conversion-out-of-range node=18 bytes=167..176\n"
.Lcerune_failure_15:
  .asciz "cerune: runtime-v1 code=conversion-nan node=18 bytes=167..176\n"
.Lcerune_failure_16:
  .asciz "cerune: runtime-v1 code=conversion-inexact node=21 bytes=185..196\n"
.Lcerune_failure_17:
  .asciz "cerune: runtime-v1 code=conversion-out-of-range node=21 bytes=185..196\n"
.Lcerune_failure_18:
  .asciz "cerune: runtime-v1 code=conversion-nan node=21 bytes=185..196\n"
.Lcerune_failure_19:
  .asciz "cerune: runtime-v1 code=conversion-inexact node=24 bytes=205..215\n"
.Lcerune_failure_20:
  .asciz "cerune: runtime-v1 code=conversion-inexact node=30 bytes=243..252\n"
.Lcerune_failure_21:
  .asciz "cerune: runtime-v1 code=conversion-out-of-range node=30 bytes=243..252\n"
.Lcerune_failure_22:
  .asciz "cerune: runtime-v1 code=conversion-nan node=30 bytes=243..252\n"
