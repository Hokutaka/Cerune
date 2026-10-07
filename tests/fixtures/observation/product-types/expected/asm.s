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
  .quad 0x4000000000000000
.p2align 3
.Lcerune_f64_1:
  .quad 0x0000000000000000
.p2align 3
.Lcerune_f64_2:
  .quad 0x4010000000000000
.p2align 3
.Lcerune_f64_3:
  .quad 0x4014000000000000

.text
.globl main
.p2align 4
main:
  pushq %rbp
  movq %rsp, %rbp
  subq $400, %rsp
  jmp .Lcerune_block_0
.Lcerune_block_0: # mir_block
  movsd .Lcerune_f64_0(%rip), %xmm0
  movsd %xmm0, -8(%rbp)
  movsd .Lcerune_f64_1(%rip), %xmm0
  movsd %xmm0, -16(%rbp)
  movsd -8(%rbp), %xmm0
  movsd %xmm0, -32(%rbp)
  movsd -16(%rbp), %xmm0
  movsd %xmm0, -24(%rbp)
  movsd -24(%rbp), %xmm0
  movsd %xmm0, -40(%rbp)
  movsd -32(%rbp), %xmm0
  movsd %xmm0, -48(%rbp)
  movsd -40(%rbp), %xmm0
  movsd %xmm0, -56(%rbp)
  movsd -48(%rbp), %xmm0
  movsd %xmm0, -64(%rbp)
  movsd -56(%rbp), %xmm0
  movsd %xmm0, -72(%rbp)
  movsd -64(%rbp), %xmm0
  movsd %xmm0, -80(%rbp)
  movsd .Lcerune_f64_2(%rip), %xmm0
  movsd %xmm0, -88(%rbp)
  movsd .Lcerune_f64_3(%rip), %xmm0
  movsd %xmm0, -96(%rbp)
  movsd -88(%rbp), %xmm0
  movsd %xmm0, -104(%rbp)
  movsd -96(%rbp), %xmm0
  movsd %xmm0, -112(%rbp)
  movsd -104(%rbp), %xmm0
  movsd %xmm0, -40(%rbp)
  movsd -112(%rbp), %xmm0
  movsd %xmm0, -48(%rbp)
  movsd -72(%rbp), %xmm0
  movsd %xmm0, -120(%rbp)
  movsd -80(%rbp), %xmm0
  movsd %xmm0, -128(%rbp)
  movsd -40(%rbp), %xmm0
  movsd %xmm0, -136(%rbp)
  movsd -48(%rbp), %xmm0
  movsd %xmm0, -144(%rbp)
  movsd -120(%rbp), %xmm0
  movsd %xmm0, -152(%rbp)
  movsd -128(%rbp), %xmm0
  movsd %xmm0, -160(%rbp)
  movsd -136(%rbp), %xmm0
  movsd %xmm0, -168(%rbp)
  movsd -144(%rbp), %xmm0
  movsd %xmm0, -176(%rbp)
  movsd -152(%rbp), %xmm0
  movsd %xmm0, -184(%rbp)
  movsd -160(%rbp), %xmm0
  movsd %xmm0, -192(%rbp)
  movsd -168(%rbp), %xmm0
  movsd %xmm0, -200(%rbp)
  movsd -176(%rbp), %xmm0
  movsd %xmm0, -208(%rbp)
  movsd -72(%rbp), %xmm0
  movsd %xmm0, -216(%rbp)
  movsd -80(%rbp), %xmm0
  movsd %xmm0, -224(%rbp)
  movsd -216(%rbp), %xmm0
  movsd %xmm0, -232(%rbp)
  movsd -232(%rbp), %xmm0
  movsd %xmm0, %xmm1
  movq %xmm1, %rdx
  leaq .Lcerune_fmt_f64(%rip), %rcx
  callq printf
  movsd -72(%rbp), %xmm0
  movsd %xmm0, -240(%rbp)
  movsd -80(%rbp), %xmm0
  movsd %xmm0, -248(%rbp)
  movsd -248(%rbp), %xmm0
  movsd %xmm0, -256(%rbp)
  movsd -256(%rbp), %xmm0
  movsd %xmm0, %xmm1
  movq %xmm1, %rdx
  leaq .Lcerune_fmt_f64(%rip), %rcx
  callq printf
  movsd -184(%rbp), %xmm0
  movsd %xmm0, -264(%rbp)
  movsd -192(%rbp), %xmm0
  movsd %xmm0, -272(%rbp)
  movsd -200(%rbp), %xmm0
  movsd %xmm0, -280(%rbp)
  movsd -208(%rbp), %xmm0
  movsd %xmm0, -288(%rbp)
  movsd -264(%rbp), %xmm0
  movsd %xmm0, -296(%rbp)
  movsd -272(%rbp), %xmm0
  movsd %xmm0, -304(%rbp)
  movsd -304(%rbp), %xmm0
  movsd %xmm0, -312(%rbp)
  movsd -312(%rbp), %xmm0
  movsd %xmm0, %xmm1
  movq %xmm1, %rdx
  leaq .Lcerune_fmt_f64(%rip), %rcx
  callq printf
  movsd -184(%rbp), %xmm0
  movsd %xmm0, -320(%rbp)
  movsd -192(%rbp), %xmm0
  movsd %xmm0, -328(%rbp)
  movsd -200(%rbp), %xmm0
  movsd %xmm0, -336(%rbp)
  movsd -208(%rbp), %xmm0
  movsd %xmm0, -344(%rbp)
  movsd -336(%rbp), %xmm0
  movsd %xmm0, -352(%rbp)
  movsd -344(%rbp), %xmm0
  movsd %xmm0, -360(%rbp)
  movsd -352(%rbp), %xmm0
  movsd %xmm0, -368(%rbp)
  movsd -368(%rbp), %xmm0
  movsd %xmm0, %xmm1
  movq %xmm1, %rdx
  leaq .Lcerune_fmt_f64(%rip), %rcx
  callq printf
  jmp .Lcerune_block_1
.Lcerune_block_1: # main_exit
  xorl %eax, %eax
  addq $400, %rsp
  popq %rbp
  retq
