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
.p2align 2
.Lcerune_f32_0:
  .long 0x3DCCCCCD
.p2align 2
.Lcerune_f32_1:
  .long 0x3E4CCCCD
.p2align 3
.Lcerune_f64_2:
  .quad 0x3FB999999999999A
.p2align 3
.Lcerune_f64_3:
  .quad 0x3FC999999999999A
.p2align 3
.Lcerune_f64_4:
  .quad 0x3FB999999999999A
.p2align 3
.Lcerune_f64_5:
  .quad 0x3FC999999999999A
.p2align 2
.Lcerune_f32_6:
  .long 0x3DCCCCCD
.p2align 2
.Lcerune_f32_7:
  .long 0x3E4CCCCD

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
  movss .Lcerune_f32_1(%rip), %xmm0
  movss %xmm0, -16(%rbp)
  movss -16(%rbp), %xmm0
  movaps %xmm0, %xmm1
  movss -8(%rbp), %xmm0
  addss %xmm1, %xmm0
  movss %xmm0, -24(%rbp)
  movss -24(%rbp), %xmm0
  movss %xmm0, -32(%rbp)
  movsd .Lcerune_f64_2(%rip), %xmm0
  movsd %xmm0, -40(%rbp)
  movsd .Lcerune_f64_3(%rip), %xmm0
  movsd %xmm0, -48(%rbp)
  movsd -48(%rbp), %xmm0
  movapd %xmm0, %xmm1
  movsd -40(%rbp), %xmm0
  addsd %xmm1, %xmm0
  movsd %xmm0, -56(%rbp)
  movsd -56(%rbp), %xmm0
  movsd %xmm0, -64(%rbp)
  movsd .Lcerune_f64_4(%rip), %xmm0
  movsd %xmm0, -72(%rbp)
  movsd .Lcerune_f64_5(%rip), %xmm0
  movsd %xmm0, -80(%rbp)
  movsd -80(%rbp), %xmm0
  movapd %xmm0, %xmm1
  movsd -72(%rbp), %xmm0
  addsd %xmm1, %xmm0
  movsd %xmm0, -88(%rbp)
  movsd -88(%rbp), %xmm0
  movsd %xmm0, -96(%rbp)
  movss .Lcerune_f32_6(%rip), %xmm0
  movss %xmm0, -104(%rbp)
  movss .Lcerune_f32_7(%rip), %xmm0
  movss %xmm0, -112(%rbp)
  movss -112(%rbp), %xmm0
  movaps %xmm0, %xmm1
  movss -104(%rbp), %xmm0
  addss %xmm1, %xmm0
  movss %xmm0, -120(%rbp)
  movss -120(%rbp), %xmm0
  movss %xmm0, -128(%rbp)
  movss -32(%rbp), %xmm0
  movss %xmm0, -136(%rbp)
  movss -136(%rbp), %xmm0
  cvtss2sd %xmm0, %xmm1
  movq %xmm1, %rdx
  leaq .Lcerune_fmt_f32(%rip), %rcx
  callq printf
  movsd -64(%rbp), %xmm0
  movsd %xmm0, -144(%rbp)
  movsd -144(%rbp), %xmm0
  movsd %xmm0, %xmm1
  movq %xmm1, %rdx
  leaq .Lcerune_fmt_f64(%rip), %rcx
  callq printf
  movsd -96(%rbp), %xmm0
  movsd %xmm0, -152(%rbp)
  movsd -152(%rbp), %xmm0
  movsd %xmm0, %xmm1
  movq %xmm1, %rdx
  leaq .Lcerune_fmt_f64(%rip), %rcx
  callq printf
  movss -128(%rbp), %xmm0
  movss %xmm0, -160(%rbp)
  movss -160(%rbp), %xmm0
  cvtss2sd %xmm0, %xmm1
  movq %xmm1, %rdx
  leaq .Lcerune_fmt_f32(%rip), %rcx
  callq printf
  jmp .Lcerune_block_1
.Lcerune_block_1: # main_exit
  xorl %eax, %eax
  addq $192, %rsp
  popq %rbp
  retq
