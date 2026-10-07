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

.text
.globl main
.p2align 4
main:
  pushq %rbp
  movq %rsp, %rbp
  subq $304, %rsp
  jmp .Lcerune_block_0
.Lcerune_block_0: # mir_block
  movabsq $2, %rax
  movq %rax, -8(%rbp)
  movabsq $4, %rax
  movq %rax, -16(%rbp)
  movabsq $6, %rax
  movq %rax, -24(%rbp)
  movq -8(%rbp), %rax
  movq %rax, -32(%rbp)
  movq -16(%rbp), %rax
  movq %rax, -40(%rbp)
  movq -24(%rbp), %rax
  movq %rax, -48(%rbp)
  movq -32(%rbp), %rax
  movq %rax, -56(%rbp)
  movq -40(%rbp), %rax
  movq %rax, -64(%rbp)
  movq -48(%rbp), %rax
  movq %rax, -72(%rbp)
  movq -56(%rbp), %rax
  movq %rax, -80(%rbp)
  movq -64(%rbp), %rax
  movq %rax, -88(%rbp)
  movq -72(%rbp), %rax
  movq %rax, -96(%rbp)
  movq -80(%rbp), %rax
  movq %rax, -104(%rbp)
  movq -88(%rbp), %rax
  movq %rax, -112(%rbp)
  movq -96(%rbp), %rax
  movq %rax, -120(%rbp)
  movabsq $1, %rax
  movq %rax, -128(%rbp)
  movabsq $3, %rax
  movq %rax, -136(%rbp)
  movabsq $5, %rax
  movq %rax, -144(%rbp)
  movq -128(%rbp), %rax
  movq %rax, -152(%rbp)
  movq -136(%rbp), %rax
  movq %rax, -160(%rbp)
  movq -144(%rbp), %rax
  movq %rax, -168(%rbp)
  movq -152(%rbp), %rax
  movq %rax, -56(%rbp)
  movq -160(%rbp), %rax
  movq %rax, -64(%rbp)
  movq -168(%rbp), %rax
  movq %rax, -72(%rbp)
  movq -104(%rbp), %rax
  movq %rax, -176(%rbp)
  movq -112(%rbp), %rax
  movq %rax, -184(%rbp)
  movq -120(%rbp), %rax
  movq %rax, -192(%rbp)
  movabsq $2, %rax
  movq %rax, -200(%rbp)
  movq -200(%rbp), %rax
  testq %rax, %rax
  js .Lcerune_main_array_oob_2
  cmpq $3, %rax
  jge .Lcerune_main_array_oob_2
  imulq $-1, %rax
  leaq -176(%rbp,%rax,8), %rcx
  movq %rcx, -256(%rbp)
  jmp .Lcerune_main_array_done_2
.Lcerune_main_array_oob_2:
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_0(%rip), %rdx
  movl $71, %r8d
  callq _write
  movl $7, %ecx
  int $0x29
.Lcerune_main_array_done_2:
  movq -256(%rbp), %r11
  movq (%r11), %rax
  movq %rax, -208(%rbp)
  movq -208(%rbp), %rax
  movq %rax, %rdx
  leaq .Lcerune_fmt_i64(%rip), %rcx
  callq printf
  movq -56(%rbp), %rax
  movq %rax, -216(%rbp)
  movq -64(%rbp), %rax
  movq %rax, -224(%rbp)
  movq -72(%rbp), %rax
  movq %rax, -232(%rbp)
  movabsq $1, %rax
  movq %rax, -240(%rbp)
  movq -240(%rbp), %rax
  testq %rax, %rax
  js .Lcerune_main_array_oob_3
  cmpq $3, %rax
  jge .Lcerune_main_array_oob_3
  imulq $-1, %rax
  leaq -216(%rbp,%rax,8), %rcx
  movq %rcx, -264(%rbp)
  jmp .Lcerune_main_array_done_3
.Lcerune_main_array_oob_3:
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_1(%rip), %rdx
  movl $73, %r8d
  callq _write
  movl $7, %ecx
  int $0x29
.Lcerune_main_array_done_3:
  movq -264(%rbp), %r11
  movq (%r11), %rax
  movq %rax, -248(%rbp)
  movq -248(%rbp), %rax
  movq %rax, %rdx
  leaq .Lcerune_fmt_i64(%rip), %rcx
  callq printf
  jmp .Lcerune_block_1
.Lcerune_block_1: # main_exit
  xorl %eax, %eax
  addq $304, %rsp
  popq %rbp
  retq

.section .rdata,"dr"
.Lcerune_failure_0:
  .asciz "cerune: runtime-v1 code=array-index-out-of-bounds node=13 bytes=85..92\n"
.Lcerune_failure_1:
  .asciz "cerune: runtime-v1 code=array-index-out-of-bounds node=17 bytes=101..110\n"
