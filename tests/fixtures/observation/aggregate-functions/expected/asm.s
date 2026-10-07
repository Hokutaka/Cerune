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
.p2align 4
cerune_fn_move_x_0:
  pushq %rbp
  movq %rsp, %rbp
  subq $144, %rsp
  movq 0(%rcx), %r10
  movq %r10, -8(%rbp)
  movq -8(%rcx), %r10
  movq %r10, -16(%rbp)
  movq %rdx, -24(%rbp)
  movq %rax, -112(%rbp)
  jmp .Lcerune_fn_0_block_0
.Lcerune_fn_0_block_0: # mir_block
  movq -8(%rbp), %rax
  movq %rax, -32(%rbp)
  movq -16(%rbp), %rax
  movq %rax, -40(%rbp)
  movq -32(%rbp), %rax
  movq %rax, -48(%rbp)
  movq -24(%rbp), %rax
  movq %rax, -56(%rbp)
  movq -56(%rbp), %rax
  movq %rax, %rcx
  movq -48(%rbp), %rax
  addq %rcx, %rax
  jno .Lcerune_fn_0_integer_ok_3
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_0(%rip), %rdx
  movl $63, %r8d
  callq _write
  movl $7, %ecx
  int $0x29
.Lcerune_fn_0_integer_ok_3:
  movq %rax, -64(%rbp)
  movq -8(%rbp), %rax
  movq %rax, -72(%rbp)
  movq -16(%rbp), %rax
  movq %rax, -80(%rbp)
  movq -80(%rbp), %rax
  movq %rax, -88(%rbp)
  movq -64(%rbp), %rax
  movq %rax, -96(%rbp)
  movq -88(%rbp), %rax
  movq %rax, -104(%rbp)
  movq -112(%rbp), %r11
  movq -96(%rbp), %r10
  movq %r10, 0(%r11)
  movq -104(%rbp), %r10
  movq %r10, -8(%r11)
  addq $144, %rsp
  popq %rbp
  retq
.Lcerune_fn_0_block_1: # mir_block
  ud2

.p2align 4
cerune_fn_move_twice_1:
  pushq %rbp
  movq %rsp, %rbp
  subq $128, %rsp
  movq 0(%rcx), %r10
  movq %r10, -8(%rbp)
  movq -8(%rcx), %r10
  movq %r10, -16(%rbp)
  movq %rdx, -24(%rbp)
  movq %rax, -96(%rbp)
  jmp .Lcerune_fn_1_block_0
.Lcerune_fn_1_block_0: # mir_block
  movq -8(%rbp), %rax
  movq %rax, -32(%rbp)
  movq -16(%rbp), %rax
  movq %rax, -40(%rbp)
  movq -24(%rbp), %rax
  movq %rax, -48(%rbp)
  leaq -32(%rbp), %rcx
  movq -48(%rbp), %rdx
  leaq -56(%rbp), %rax
  callq cerune_fn_move_x_0
  movq -24(%rbp), %rax
  movq %rax, -72(%rbp)
  leaq -56(%rbp), %rcx
  movq -72(%rbp), %rdx
  leaq -80(%rbp), %rax
  callq cerune_fn_move_x_0
  movq -96(%rbp), %r11
  movq -80(%rbp), %r10
  movq %r10, 0(%r11)
  movq -88(%rbp), %r10
  movq %r10, -8(%r11)
  addq $128, %rsp
  popq %rbp
  retq
.Lcerune_fn_1_block_1: # mir_block
  ud2

.p2align 4
cerune_fn_first_row_2:
  pushq %rbp
  movq %rsp, %rbp
  subq $144, %rsp
  movq 0(%rcx), %r10
  movq %r10, -8(%rbp)
  movq -8(%rcx), %r10
  movq %r10, -16(%rbp)
  movq -16(%rcx), %r10
  movq %r10, -24(%rbp)
  movq -24(%rcx), %r10
  movq %r10, -32(%rbp)
  movq %rax, -96(%rbp)
  jmp .Lcerune_fn_2_block_0
.Lcerune_fn_2_block_0: # mir_block
  movq -8(%rbp), %rax
  movq %rax, -40(%rbp)
  movq -16(%rbp), %rax
  movq %rax, -48(%rbp)
  movq -24(%rbp), %rax
  movq %rax, -56(%rbp)
  movq -32(%rbp), %rax
  movq %rax, -64(%rbp)
  movabsq $0, %rax
  movq %rax, -72(%rbp)
  movq -72(%rbp), %rax
  testq %rax, %rax
  js .Lcerune_fn_2_array_oob_3
  cmpq $2, %rax
  jge .Lcerune_fn_2_array_oob_3
  imulq $-2, %rax
  leaq -40(%rbp,%rax,8), %rcx
  movq %rcx, -104(%rbp)
  jmp .Lcerune_fn_2_array_done_3
.Lcerune_fn_2_array_oob_3:
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_1(%rip), %rdx
  movl $73, %r8d
  callq _write
  movl $7, %ecx
  int $0x29
.Lcerune_fn_2_array_done_3:
  movq -104(%rbp), %r11
  movq 0(%r11), %r10
  movq %r10, -80(%rbp)
  movq -8(%r11), %r10
  movq %r10, -88(%rbp)
  movq -96(%rbp), %r11
  movq -80(%rbp), %r10
  movq %r10, 0(%r11)
  movq -88(%rbp), %r10
  movq %r10, -8(%r11)
  addq $144, %rsp
  popq %rbp
  retq
.Lcerune_fn_2_block_1: # mir_block
  ud2

.p2align 4
cerune_fn_duplicate_3:
  pushq %rbp
  movq %rsp, %rbp
  subq $128, %rsp
  movq 0(%rcx), %r10
  movq %r10, -8(%rbp)
  movq -8(%rcx), %r10
  movq %r10, -16(%rbp)
  movq %rax, -88(%rbp)
  jmp .Lcerune_fn_3_block_0
.Lcerune_fn_3_block_0: # mir_block
  movq -8(%rbp), %rax
  movq %rax, -24(%rbp)
  movq -16(%rbp), %rax
  movq %rax, -32(%rbp)
  movq -8(%rbp), %rax
  movq %rax, -40(%rbp)
  movq -16(%rbp), %rax
  movq %rax, -48(%rbp)
  movq -24(%rbp), %rax
  movq %rax, -56(%rbp)
  movq -32(%rbp), %rax
  movq %rax, -64(%rbp)
  movq -40(%rbp), %rax
  movq %rax, -72(%rbp)
  movq -48(%rbp), %rax
  movq %rax, -80(%rbp)
  movq -88(%rbp), %r11
  movq -56(%rbp), %r10
  movq %r10, 0(%r11)
  movq -64(%rbp), %r10
  movq %r10, -8(%r11)
  movq -72(%rbp), %r10
  movq %r10, -16(%r11)
  movq -80(%rbp), %r10
  movq %r10, -24(%r11)
  addq $128, %rsp
  popq %rbp
  retq
.Lcerune_fn_3_block_1: # mir_block
  ud2

.p2align 4
cerune_fn_duplicate_first_row_4:
  pushq %rbp
  movq %rsp, %rbp
  subq $160, %rsp
  movq 0(%rcx), %r10
  movq %r10, -8(%rbp)
  movq -8(%rcx), %r10
  movq %r10, -16(%rbp)
  movq -16(%rcx), %r10
  movq %r10, -24(%rbp)
  movq -24(%rcx), %r10
  movq %r10, -32(%rbp)
  movq %rax, -120(%rbp)
  jmp .Lcerune_fn_4_block_0
.Lcerune_fn_4_block_0: # mir_block
  movq -8(%rbp), %rax
  movq %rax, -40(%rbp)
  movq -16(%rbp), %rax
  movq %rax, -48(%rbp)
  movq -24(%rbp), %rax
  movq %rax, -56(%rbp)
  movq -32(%rbp), %rax
  movq %rax, -64(%rbp)
  leaq -40(%rbp), %rcx
  leaq -72(%rbp), %rax
  callq cerune_fn_first_row_2
  leaq -72(%rbp), %rcx
  leaq -88(%rbp), %rax
  callq cerune_fn_duplicate_3
  movq -120(%rbp), %r11
  movq -88(%rbp), %r10
  movq %r10, 0(%r11)
  movq -96(%rbp), %r10
  movq %r10, -8(%r11)
  movq -104(%rbp), %r10
  movq %r10, -16(%r11)
  movq -112(%rbp), %r10
  movq %r10, -24(%r11)
  addq $160, %rsp
  popq %rbp
  retq
.Lcerune_fn_4_block_1: # mir_block
  ud2

.globl main
.p2align 4
main:
  pushq %rbp
  movq %rsp, %rbp
  subq $704, %rsp
  jmp .Lcerune_block_0
.Lcerune_block_0: # mir_block
  movabsq $2, %rax
  movq %rax, -8(%rbp)
  movabsq $3, %rax
  movq %rax, -16(%rbp)
  movq -8(%rbp), %rax
  movq %rax, -24(%rbp)
  movq -16(%rbp), %rax
  movq %rax, -32(%rbp)
  movq -24(%rbp), %rax
  movq %rax, -40(%rbp)
  movq -32(%rbp), %rax
  movq %rax, -48(%rbp)
  movq -40(%rbp), %rax
  movq %rax, -56(%rbp)
  movq -48(%rbp), %rax
  movq %rax, -64(%rbp)
  movabsq $5, %rax
  movq %rax, -72(%rbp)
  leaq -56(%rbp), %rcx
  movq -72(%rbp), %rdx
  leaq -80(%rbp), %rax
  callq cerune_fn_move_twice_1
  movq -80(%rbp), %rax
  movq %rax, -96(%rbp)
  movq -88(%rbp), %rax
  movq %rax, -104(%rbp)
  movabsq $1, %rax
  movq %rax, -112(%rbp)
  movabsq $2, %rax
  movq %rax, -120(%rbp)
  movq -112(%rbp), %rax
  movq %rax, -128(%rbp)
  movq -120(%rbp), %rax
  movq %rax, -136(%rbp)
  movabsq $3, %rax
  movq %rax, -144(%rbp)
  movabsq $4, %rax
  movq %rax, -152(%rbp)
  movq -144(%rbp), %rax
  movq %rax, -160(%rbp)
  movq -152(%rbp), %rax
  movq %rax, -168(%rbp)
  movq -128(%rbp), %rax
  movq %rax, -176(%rbp)
  movq -136(%rbp), %rax
  movq %rax, -184(%rbp)
  movq -160(%rbp), %rax
  movq %rax, -192(%rbp)
  movq -168(%rbp), %rax
  movq %rax, -200(%rbp)
  movq -176(%rbp), %rax
  movq %rax, -208(%rbp)
  movq -184(%rbp), %rax
  movq %rax, -216(%rbp)
  movq -192(%rbp), %rax
  movq %rax, -224(%rbp)
  movq -200(%rbp), %rax
  movq %rax, -232(%rbp)
  movq -208(%rbp), %rax
  movq %rax, -240(%rbp)
  movq -216(%rbp), %rax
  movq %rax, -248(%rbp)
  movq -224(%rbp), %rax
  movq %rax, -256(%rbp)
  movq -232(%rbp), %rax
  movq %rax, -264(%rbp)
  leaq -240(%rbp), %rcx
  leaq -272(%rbp), %rax
  callq cerune_fn_duplicate_first_row_4
  movq -272(%rbp), %rax
  movq %rax, -304(%rbp)
  movq -280(%rbp), %rax
  movq %rax, -312(%rbp)
  movq -288(%rbp), %rax
  movq %rax, -320(%rbp)
  movq -296(%rbp), %rax
  movq %rax, -328(%rbp)
  movq -40(%rbp), %rax
  movq %rax, -336(%rbp)
  movq -48(%rbp), %rax
  movq %rax, -344(%rbp)
  movq -336(%rbp), %rax
  movq %rax, -352(%rbp)
  movq -352(%rbp), %rax
  movq %rax, %rdx
  leaq .Lcerune_fmt_i64(%rip), %rcx
  callq printf
  movq -96(%rbp), %rax
  movq %rax, -360(%rbp)
  movq -104(%rbp), %rax
  movq %rax, -368(%rbp)
  movq -360(%rbp), %rax
  movq %rax, -376(%rbp)
  movq -376(%rbp), %rax
  movq %rax, %rdx
  leaq .Lcerune_fmt_i64(%rip), %rcx
  callq printf
  movq -96(%rbp), %rax
  movq %rax, -384(%rbp)
  movq -104(%rbp), %rax
  movq %rax, -392(%rbp)
  movq -392(%rbp), %rax
  movq %rax, -400(%rbp)
  movq -400(%rbp), %rax
  movq %rax, %rdx
  leaq .Lcerune_fmt_i64(%rip), %rcx
  callq printf
  movq -208(%rbp), %rax
  movq %rax, -408(%rbp)
  movq -216(%rbp), %rax
  movq %rax, -416(%rbp)
  movq -224(%rbp), %rax
  movq %rax, -424(%rbp)
  movq -232(%rbp), %rax
  movq %rax, -432(%rbp)
  movabsq $1, %rax
  movq %rax, -440(%rbp)
  movq -440(%rbp), %rax
  testq %rax, %rax
  js .Lcerune_main_array_oob_2
  cmpq $2, %rax
  jge .Lcerune_main_array_oob_2
  imulq $-2, %rax
  leaq -408(%rbp,%rax,8), %rcx
  movq %rcx, -624(%rbp)
  jmp .Lcerune_main_array_done_2
.Lcerune_main_array_oob_2:
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_2(%rip), %rdx
  movl $73, %r8d
  callq _write
  movl $7, %ecx
  int $0x29
.Lcerune_main_array_done_2:
  movq -624(%rbp), %r11
  movq 0(%r11), %r10
  movq %r10, -448(%rbp)
  movq -8(%r11), %r10
  movq %r10, -456(%rbp)
  movabsq $0, %rax
  movq %rax, -464(%rbp)
  movq -464(%rbp), %rax
  testq %rax, %rax
  js .Lcerune_main_array_oob_3
  cmpq $2, %rax
  jge .Lcerune_main_array_oob_3
  imulq $-1, %rax
  leaq -448(%rbp,%rax,8), %rcx
  movq %rcx, -632(%rbp)
  jmp .Lcerune_main_array_done_3
.Lcerune_main_array_oob_3:
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_3(%rip), %rdx
  movl $73, %r8d
  callq _write
  movl $7, %ecx
  int $0x29
.Lcerune_main_array_done_3:
  movq -632(%rbp), %r11
  movq (%r11), %rax
  movq %rax, -472(%rbp)
  movq -472(%rbp), %rax
  movq %rax, %rdx
  leaq .Lcerune_fmt_i64(%rip), %rcx
  callq printf
  movq -304(%rbp), %rax
  movq %rax, -480(%rbp)
  movq -312(%rbp), %rax
  movq %rax, -488(%rbp)
  movq -320(%rbp), %rax
  movq %rax, -496(%rbp)
  movq -328(%rbp), %rax
  movq %rax, -504(%rbp)
  movabsq $0, %rax
  movq %rax, -512(%rbp)
  movq -512(%rbp), %rax
  testq %rax, %rax
  js .Lcerune_main_array_oob_4
  cmpq $2, %rax
  jge .Lcerune_main_array_oob_4
  imulq $-2, %rax
  leaq -480(%rbp,%rax,8), %rcx
  movq %rcx, -640(%rbp)
  jmp .Lcerune_main_array_done_4
.Lcerune_main_array_oob_4:
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_4(%rip), %rdx
  movl $73, %r8d
  callq _write
  movl $7, %ecx
  int $0x29
.Lcerune_main_array_done_4:
  movq -640(%rbp), %r11
  movq 0(%r11), %r10
  movq %r10, -520(%rbp)
  movq -8(%r11), %r10
  movq %r10, -528(%rbp)
  movabsq $1, %rax
  movq %rax, -536(%rbp)
  movq -536(%rbp), %rax
  testq %rax, %rax
  js .Lcerune_main_array_oob_5
  cmpq $2, %rax
  jge .Lcerune_main_array_oob_5
  imulq $-1, %rax
  leaq -520(%rbp,%rax,8), %rcx
  movq %rcx, -648(%rbp)
  jmp .Lcerune_main_array_done_5
.Lcerune_main_array_oob_5:
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_5(%rip), %rdx
  movl $73, %r8d
  callq _write
  movl $7, %ecx
  int $0x29
.Lcerune_main_array_done_5:
  movq -648(%rbp), %r11
  movq (%r11), %rax
  movq %rax, -544(%rbp)
  movq -544(%rbp), %rax
  movq %rax, %rdx
  leaq .Lcerune_fmt_i64(%rip), %rcx
  callq printf
  movq -304(%rbp), %rax
  movq %rax, -552(%rbp)
  movq -312(%rbp), %rax
  movq %rax, -560(%rbp)
  movq -320(%rbp), %rax
  movq %rax, -568(%rbp)
  movq -328(%rbp), %rax
  movq %rax, -576(%rbp)
  movabsq $1, %rax
  movq %rax, -584(%rbp)
  movq -584(%rbp), %rax
  testq %rax, %rax
  js .Lcerune_main_array_oob_6
  cmpq $2, %rax
  jge .Lcerune_main_array_oob_6
  imulq $-2, %rax
  leaq -552(%rbp,%rax,8), %rcx
  movq %rcx, -656(%rbp)
  jmp .Lcerune_main_array_done_6
.Lcerune_main_array_oob_6:
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_6(%rip), %rdx
  movl $73, %r8d
  callq _write
  movl $7, %ecx
  int $0x29
.Lcerune_main_array_done_6:
  movq -656(%rbp), %r11
  movq 0(%r11), %r10
  movq %r10, -592(%rbp)
  movq -8(%r11), %r10
  movq %r10, -600(%rbp)
  movabsq $0, %rax
  movq %rax, -608(%rbp)
  movq -608(%rbp), %rax
  testq %rax, %rax
  js .Lcerune_main_array_oob_7
  cmpq $2, %rax
  jge .Lcerune_main_array_oob_7
  imulq $-1, %rax
  leaq -592(%rbp,%rax,8), %rcx
  movq %rcx, -664(%rbp)
  jmp .Lcerune_main_array_done_7
.Lcerune_main_array_oob_7:
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_7(%rip), %rdx
  movl $73, %r8d
  callq _write
  movl $7, %ecx
  int $0x29
.Lcerune_main_array_done_7:
  movq -664(%rbp), %r11
  movq (%r11), %rax
  movq %rax, -616(%rbp)
  movq -616(%rbp), %rax
  movq %rax, %rdx
  leaq .Lcerune_fmt_i64(%rip), %rcx
  callq printf
  jmp .Lcerune_block_1
.Lcerune_block_1: # main_exit
  xorl %eax, %eax
  addq $704, %rsp
  popq %rbp
  retq

.section .rdata,"dr"
.Lcerune_failure_0:
  .asciz "cerune: runtime-v1 code=integer-overflow node=2 bytes=118..134\n"
.Lcerune_failure_1:
  .asciz "cerune: runtime-v1 code=array-index-out-of-bounds node=15 bytes=332..341\n"
.Lcerune_failure_2:
  .asciz "cerune: runtime-v1 code=array-index-out-of-bounds node=56 bytes=760..769\n"
.Lcerune_failure_3:
  .asciz "cerune: runtime-v1 code=array-index-out-of-bounds node=55 bytes=760..772\n"
.Lcerune_failure_4:
  .asciz "cerune: runtime-v1 code=array-index-out-of-bounds node=62 bytes=781..788\n"
.Lcerune_failure_5:
  .asciz "cerune: runtime-v1 code=array-index-out-of-bounds node=61 bytes=781..791\n"
.Lcerune_failure_6:
  .asciz "cerune: runtime-v1 code=array-index-out-of-bounds node=68 bytes=800..807\n"
.Lcerune_failure_7:
  .asciz "cerune: runtime-v1 code=array-index-out-of-bounds node=67 bytes=800..810\n"
