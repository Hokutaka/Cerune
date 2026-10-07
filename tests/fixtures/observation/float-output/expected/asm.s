.section .rdata,"dr"
.Lcerune_fmt_i64:
  .asciz "%lld\n"
.Lcerune_fmt_f32:
  .asciz "%.9g\n"
.Lcerune_fmt_f64:
  .asciz "%.17g\n"
.Lcerune_bool_false:
  .asciz "false"
.Lcerune_bool_true:
  .asciz "true"
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
.p2align 2
.Lcerune_f32_0:
  .long 0x1E3CE508
.p2align 3
.Lcerune_f64_1:
  .quad 0x3BC79CA10C924223
.p2align 3
.Lcerune_f64_2:
  .quad 0x3BC79CA10C924223
.p2align 3
.Lcerune_f64_3:
  .quad 0x0000000000000000
.p2align 2
.Lcerune_f32_4:
  .long 0x00000001
.p2align 3
.Lcerune_f64_5:
  .quad 0x0000000000000001
.p2align 2
.Lcerune_f32_6:
  .long 0x7F7FFFFF
.p2align 3
.Lcerune_f64_7:
  .quad 0x7FEFFFFFFFFFFFFF
.p2align 2
.Lcerune_f32_8:
  .long 0x00000000
.p2align 3
.Lcerune_f64_9:
  .quad 0x0000000000000000
.p2align 2
.Lcerune_f32_10:
  .long 0x00000000
.p2align 3
.Lcerune_f64_11:
  .quad 0x0000000000000000
.p2align 2
.Lcerune_f32_12:
  .long 0x38D1B717
.p2align 3
.Lcerune_f64_13:
  .quad 0x3F1A36E2EB1C432D
.p2align 2
.Lcerune_f32_14:
  .long 0x4E6E6B28
.p2align 3
.Lcerune_f64_15:
  .quad 0x4376345785D8A000

.text
.globl main
.p2align 4
main:
  pushq %rbp
  movq %rsp, %rbp
  subq $192, %rsp
  jmp .Lcerune_block_0
.Lcerune_block_0: # mir_block
  movss .Lcerune_f32_0(%rip), %xmm0
  movss %xmm0, -8(%rbp)
  movss -8(%rbp), %xmm0
  cvtss2sd %xmm0, %xmm1
  movq %xmm1, %rdx
  leaq .Lcerune_fmt_f32(%rip), %rcx
  callq printf
  movsd .Lcerune_f64_1(%rip), %xmm0
  movsd %xmm0, -16(%rbp)
  movsd -16(%rbp), %xmm0
  movsd %xmm0, %xmm1
  movq %xmm1, %rdx
  leaq .Lcerune_fmt_f64(%rip), %rcx
  callq printf
  movsd .Lcerune_f64_2(%rip), %xmm0
  movsd %xmm0, -24(%rbp)
  movsd .Lcerune_f64_3(%rip), %xmm0
  movsd %xmm0, -32(%rbp)
  movsd -32(%rbp), %xmm0
  movapd %xmm0, %xmm1
  movsd -24(%rbp), %xmm0
  ucomisd %xmm1, %xmm0
  setne %al
  setp %cl
  orb %cl, %al
  movzbq %al, %rax
  movq %rax, -40(%rbp)
  movq -40(%rbp), %rax
  testq %rax, %rax
  leaq .Lcerune_bool_false(%rip), %rcx
  leaq .Lcerune_bool_true(%rip), %rdx
  cmovne %rdx, %rcx
  callq puts
  movss .Lcerune_f32_4(%rip), %xmm0
  movss %xmm0, -48(%rbp)
  movss -48(%rbp), %xmm0
  cvtss2sd %xmm0, %xmm1
  movq %xmm1, %rdx
  leaq .Lcerune_fmt_f32(%rip), %rcx
  callq printf
  movsd .Lcerune_f64_5(%rip), %xmm0
  movsd %xmm0, -56(%rbp)
  movsd -56(%rbp), %xmm0
  movsd %xmm0, %xmm1
  movq %xmm1, %rdx
  leaq .Lcerune_fmt_f64(%rip), %rcx
  callq printf
  movss .Lcerune_f32_6(%rip), %xmm0
  movss %xmm0, -64(%rbp)
  movss -64(%rbp), %xmm0
  cvtss2sd %xmm0, %xmm1
  movq %xmm1, %rdx
  leaq .Lcerune_fmt_f32(%rip), %rcx
  callq printf
  movsd .Lcerune_f64_7(%rip), %xmm0
  movsd %xmm0, -72(%rbp)
  movsd -72(%rbp), %xmm0
  movsd %xmm0, %xmm1
  movq %xmm1, %rdx
  leaq .Lcerune_fmt_f64(%rip), %rcx
  callq printf
  movss .Lcerune_f32_8(%rip), %xmm0
  movss %xmm0, -80(%rbp)
  movss -80(%rbp), %xmm0
  xorps .Lcerune_sign_f32(%rip), %xmm0
  movss %xmm0, -88(%rbp)
  movss -88(%rbp), %xmm0
  cvtss2sd %xmm0, %xmm1
  movq %xmm1, %rdx
  leaq .Lcerune_fmt_f32(%rip), %rcx
  callq printf
  movsd .Lcerune_f64_9(%rip), %xmm0
  movsd %xmm0, -96(%rbp)
  movsd -96(%rbp), %xmm0
  xorpd .Lcerune_sign_f64(%rip), %xmm0
  movsd %xmm0, -104(%rbp)
  movsd -104(%rbp), %xmm0
  movsd %xmm0, %xmm1
  movq %xmm1, %rdx
  leaq .Lcerune_fmt_f64(%rip), %rcx
  callq printf
  movss .Lcerune_f32_10(%rip), %xmm0
  movss %xmm0, -112(%rbp)
  movss -112(%rbp), %xmm0
  cvtss2sd %xmm0, %xmm1
  movq %xmm1, %rdx
  leaq .Lcerune_fmt_f32(%rip), %rcx
  callq printf
  movsd .Lcerune_f64_11(%rip), %xmm0
  movsd %xmm0, -120(%rbp)
  movsd -120(%rbp), %xmm0
  movsd %xmm0, %xmm1
  movq %xmm1, %rdx
  leaq .Lcerune_fmt_f64(%rip), %rcx
  callq printf
  movss .Lcerune_f32_12(%rip), %xmm0
  movss %xmm0, -128(%rbp)
  movss -128(%rbp), %xmm0
  cvtss2sd %xmm0, %xmm1
  movq %xmm1, %rdx
  leaq .Lcerune_fmt_f32(%rip), %rcx
  callq printf
  movsd .Lcerune_f64_13(%rip), %xmm0
  movsd %xmm0, -136(%rbp)
  movsd -136(%rbp), %xmm0
  movsd %xmm0, %xmm1
  movq %xmm1, %rdx
  leaq .Lcerune_fmt_f64(%rip), %rcx
  callq printf
  movss .Lcerune_f32_14(%rip), %xmm0
  movss %xmm0, -144(%rbp)
  movss -144(%rbp), %xmm0
  cvtss2sd %xmm0, %xmm1
  movq %xmm1, %rdx
  leaq .Lcerune_fmt_f32(%rip), %rcx
  callq printf
  movsd .Lcerune_f64_15(%rip), %xmm0
  movsd %xmm0, -152(%rbp)
  movsd -152(%rbp), %xmm0
  movsd %xmm0, %xmm1
  movq %xmm1, %rdx
  leaq .Lcerune_fmt_f64(%rip), %rcx
  callq printf
  jmp .Lcerune_block_1
.Lcerune_block_1: # main_exit
  xorl %eax, %eax
  addq $192, %rsp
  popq %rbp
  retq
