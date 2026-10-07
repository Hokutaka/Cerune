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
  subq $688, %rsp
  jmp .Lcerune_block_0
.Lcerune_block_0: # mir_block
  movabsq $1, %rax
  movq %rax, -8(%rbp)
  movabsq $2, %rax
  movq %rax, -16(%rbp)
  movabsq $3, %rax
  movq %rax, -24(%rbp)
  movq -8(%rbp), %rax
  movq %rax, -32(%rbp)
  movq -16(%rbp), %rax
  movq %rax, -40(%rbp)
  movq -24(%rbp), %rax
  movq %rax, -48(%rbp)
  movabsq $4, %rax
  movq %rax, -56(%rbp)
  movabsq $5, %rax
  movq %rax, -64(%rbp)
  movabsq $6, %rax
  movq %rax, -72(%rbp)
  movq -56(%rbp), %rax
  movq %rax, -80(%rbp)
  movq -64(%rbp), %rax
  movq %rax, -88(%rbp)
  movq -72(%rbp), %rax
  movq %rax, -96(%rbp)
  movq -32(%rbp), %rax
  movq %rax, -104(%rbp)
  movq -40(%rbp), %rax
  movq %rax, -112(%rbp)
  movq -48(%rbp), %rax
  movq %rax, -120(%rbp)
  movq -80(%rbp), %rax
  movq %rax, -128(%rbp)
  movq -88(%rbp), %rax
  movq %rax, -136(%rbp)
  movq -96(%rbp), %rax
  movq %rax, -144(%rbp)
  movq -104(%rbp), %rax
  movq %rax, -152(%rbp)
  movq -112(%rbp), %rax
  movq %rax, -160(%rbp)
  movq -120(%rbp), %rax
  movq %rax, -168(%rbp)
  movq -128(%rbp), %rax
  movq %rax, -176(%rbp)
  movq -136(%rbp), %rax
  movq %rax, -184(%rbp)
  movq -144(%rbp), %rax
  movq %rax, -192(%rbp)
  movq -152(%rbp), %rax
  movq %rax, -200(%rbp)
  movq -160(%rbp), %rax
  movq %rax, -208(%rbp)
  movq -168(%rbp), %rax
  movq %rax, -216(%rbp)
  movq -176(%rbp), %rax
  movq %rax, -224(%rbp)
  movq -184(%rbp), %rax
  movq %rax, -232(%rbp)
  movq -192(%rbp), %rax
  movq %rax, -240(%rbp)
  movq -200(%rbp), %rax
  movq %rax, -248(%rbp)
  movq -208(%rbp), %rax
  movq %rax, -256(%rbp)
  movq -216(%rbp), %rax
  movq %rax, -264(%rbp)
  movq -224(%rbp), %rax
  movq %rax, -272(%rbp)
  movq -232(%rbp), %rax
  movq %rax, -280(%rbp)
  movq -240(%rbp), %rax
  movq %rax, -288(%rbp)
  movabsq $7, %rax
  movq %rax, -296(%rbp)
  movabsq $8, %rax
  movq %rax, -304(%rbp)
  movabsq $9, %rax
  movq %rax, -312(%rbp)
  movq -296(%rbp), %rax
  movq %rax, -320(%rbp)
  movq -304(%rbp), %rax
  movq %rax, -328(%rbp)
  movq -312(%rbp), %rax
  movq %rax, -336(%rbp)
  movabsq $10, %rax
  movq %rax, -344(%rbp)
  movabsq $11, %rax
  movq %rax, -352(%rbp)
  movabsq $12, %rax
  movq %rax, -360(%rbp)
  movq -344(%rbp), %rax
  movq %rax, -368(%rbp)
  movq -352(%rbp), %rax
  movq %rax, -376(%rbp)
  movq -360(%rbp), %rax
  movq %rax, -384(%rbp)
  movq -320(%rbp), %rax
  movq %rax, -392(%rbp)
  movq -328(%rbp), %rax
  movq %rax, -400(%rbp)
  movq -336(%rbp), %rax
  movq %rax, -408(%rbp)
  movq -368(%rbp), %rax
  movq %rax, -416(%rbp)
  movq -376(%rbp), %rax
  movq %rax, -424(%rbp)
  movq -384(%rbp), %rax
  movq %rax, -432(%rbp)
  movq -392(%rbp), %rax
  movq %rax, -152(%rbp)
  movq -400(%rbp), %rax
  movq %rax, -160(%rbp)
  movq -408(%rbp), %rax
  movq %rax, -168(%rbp)
  movq -416(%rbp), %rax
  movq %rax, -176(%rbp)
  movq -424(%rbp), %rax
  movq %rax, -184(%rbp)
  movq -432(%rbp), %rax
  movq %rax, -192(%rbp)
  movq -248(%rbp), %rax
  movq %rax, -440(%rbp)
  movq -256(%rbp), %rax
  movq %rax, -448(%rbp)
  movq -264(%rbp), %rax
  movq %rax, -456(%rbp)
  movq -272(%rbp), %rax
  movq %rax, -464(%rbp)
  movq -280(%rbp), %rax
  movq %rax, -472(%rbp)
  movq -288(%rbp), %rax
  movq %rax, -480(%rbp)
  movabsq $1, %rax
  movq %rax, -488(%rbp)
  movq -488(%rbp), %rax
  testq %rax, %rax
  js .Lcerune_main_array_oob_2
  cmpq $2, %rax
  jge .Lcerune_main_array_oob_2
  imulq $-3, %rax
  leaq -440(%rbp,%rax,8), %rcx
  movq %rcx, -632(%rbp)
  jmp .Lcerune_main_array_done_2
.Lcerune_main_array_oob_2:
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_0(%rip), %rdx
  movl $73, %r8d
  callq _write
  movl $7, %ecx
  int $0x29
.Lcerune_main_array_done_2:
  movq -632(%rbp), %r11
  movq 0(%r11), %r10
  movq %r10, -496(%rbp)
  movq -8(%r11), %r10
  movq %r10, -504(%rbp)
  movq -16(%r11), %r10
  movq %r10, -512(%rbp)
  movabsq $2, %rax
  movq %rax, -520(%rbp)
  movq -520(%rbp), %rax
  testq %rax, %rax
  js .Lcerune_main_array_oob_3
  cmpq $3, %rax
  jge .Lcerune_main_array_oob_3
  imulq $-1, %rax
  leaq -496(%rbp,%rax,8), %rcx
  movq %rcx, -640(%rbp)
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
  movq -640(%rbp), %r11
  movq (%r11), %rax
  movq %rax, -528(%rbp)
  movq -528(%rbp), %rax
  movq %rax, %rdx
  leaq .Lcerune_fmt_i64(%rip), %rcx
  callq printf
  movq -152(%rbp), %rax
  movq %rax, -536(%rbp)
  movq -160(%rbp), %rax
  movq %rax, -544(%rbp)
  movq -168(%rbp), %rax
  movq %rax, -552(%rbp)
  movq -176(%rbp), %rax
  movq %rax, -560(%rbp)
  movq -184(%rbp), %rax
  movq %rax, -568(%rbp)
  movq -192(%rbp), %rax
  movq %rax, -576(%rbp)
  movabsq $0, %rax
  movq %rax, -584(%rbp)
  movq -584(%rbp), %rax
  testq %rax, %rax
  js .Lcerune_main_array_oob_4
  cmpq $2, %rax
  jge .Lcerune_main_array_oob_4
  imulq $-3, %rax
  leaq -536(%rbp,%rax,8), %rcx
  movq %rcx, -648(%rbp)
  jmp .Lcerune_main_array_done_4
.Lcerune_main_array_oob_4:
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_2(%rip), %rdx
  movl $73, %r8d
  callq _write
  movl $7, %ecx
  int $0x29
.Lcerune_main_array_done_4:
  movq -648(%rbp), %r11
  movq 0(%r11), %r10
  movq %r10, -592(%rbp)
  movq -8(%r11), %r10
  movq %r10, -600(%rbp)
  movq -16(%r11), %r10
  movq %r10, -608(%rbp)
  movabsq $1, %rax
  movq %rax, -616(%rbp)
  movq -616(%rbp), %rax
  testq %rax, %rax
  js .Lcerune_main_array_oob_5
  cmpq $3, %rax
  jge .Lcerune_main_array_oob_5
  imulq $-1, %rax
  leaq -592(%rbp,%rax,8), %rcx
  movq %rcx, -656(%rbp)
  jmp .Lcerune_main_array_done_5
.Lcerune_main_array_oob_5:
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_3(%rip), %rdx
  movl $73, %r8d
  callq _write
  movl $7, %ecx
  int $0x29
.Lcerune_main_array_done_5:
  movq -656(%rbp), %r11
  movq (%r11), %rax
  movq %rax, -624(%rbp)
  movq -624(%rbp), %rax
  movq %rax, %rdx
  leaq .Lcerune_fmt_i64(%rip), %rcx
  callq printf
  jmp .Lcerune_block_1
.Lcerune_block_1: # main_exit
  xorl %eax, %eax
  addq $688, %rsp
  popq %rbp
  retq

.section .rdata,"dr"
.Lcerune_failure_0:
  .asciz "cerune: runtime-v1 code=array-index-out-of-bounds node=24 bytes=125..132\n"
.Lcerune_failure_1:
  .asciz "cerune: runtime-v1 code=array-index-out-of-bounds node=23 bytes=125..135\n"
.Lcerune_failure_2:
  .asciz "cerune: runtime-v1 code=array-index-out-of-bounds node=30 bytes=144..153\n"
.Lcerune_failure_3:
  .asciz "cerune: runtime-v1 code=array-index-out-of-bounds node=29 bytes=144..156\n"
