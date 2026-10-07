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

.text
.p2align 4
cerune_fn_report_0:
  pushq %rbp
  movq %rsp, %rbp
  subq $64, %rsp
  movq %rcx, -8(%rbp)
  jmp .Lcerune_fn_0_block_0
.Lcerune_fn_0_block_0: # mir_block
  movq -8(%rbp), %rax
  movq %rax, -16(%rbp)
  movq -16(%rbp), %rax
  testq %rax, %rax
  leaq .Lcerune_bool_false(%rip), %rcx
  leaq .Lcerune_bool_true(%rip), %rdx
  cmovne %rdx, %rcx
  callq puts
  movq -8(%rbp), %rax
  movq %rax, -24(%rbp)
  movq -24(%rbp), %rax
  addq $64, %rsp
  popq %rbp
  retq
.Lcerune_fn_0_block_1: # mir_block
  ud2

.globl main
.p2align 4
main:
  pushq %rbp
  movq %rsp, %rbp
  subq $320, %rsp
  jmp .Lcerune_block_0
.Lcerune_block_0: # mir_block
  movabsq $4, %rax
  movq %rax, -8(%rbp)
  movabsq $9, %rax
  movq %rax, -16(%rbp)
  movq -8(%rbp), %rax
  movq %rax, -24(%rbp)
  movq -16(%rbp), %rax
  movq %rax, -32(%rbp)
  movq -24(%rbp), %rax
  movq %rax, -40(%rbp)
  movq -32(%rbp), %rax
  movq %rax, -48(%rbp)
  movabsq $2, %rax
  movq %rax, -56(%rbp)
  movq -56(%rbp), %rax
  movq %rax, -64(%rbp)
  movq -64(%rbp), %rax
  movq %rax, -72(%rbp)
  movabsq $2, %rax
  movq %rax, -80(%rbp)
  movq -80(%rbp), %rax
  movq %rax, %rcx
  movq -72(%rbp), %rax
  cmpq %rcx, %rax
  setl %al
  movzbq %al, %rax
  movq %rax, -88(%rbp)
  movq -88(%rbp), %rax
  movq %rax, -96(%rbp)
  movq -88(%rbp), %rax
  testq %rax, %rax
  je .Lcerune_block_2
  jmp .Lcerune_block_1
.Lcerune_block_1: # mir_block
  movq -40(%rbp), %rax
  movq %rax, -104(%rbp)
  movq -48(%rbp), %rax
  movq %rax, -112(%rbp)
  movq -64(%rbp), %rax
  movq %rax, -120(%rbp)
  movq -120(%rbp), %rax
  testq %rax, %rax
  js .Lcerune_main_array_oob_12
  cmpq $2, %rax
  jge .Lcerune_main_array_oob_12
  imulq $-1, %rax
  leaq -104(%rbp,%rax,8), %rcx
  movq %rcx, -288(%rbp)
  jmp .Lcerune_main_array_done_12
.Lcerune_main_array_oob_12:
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_0(%rip), %rdx
  movl $73, %r8d
  callq _write
  movl $7, %ecx
  int $0x29
.Lcerune_main_array_done_12:
  movq -288(%rbp), %r11
  movq (%r11), %rax
  movq %rax, -128(%rbp)
  movabsq $0, %rax
  movq %rax, -136(%rbp)
  movq -136(%rbp), %rax
  movq %rax, %rcx
  movq -128(%rbp), %rax
  cmpq %rcx, %rax
  setg %al
  movzbq %al, %rax
  movq %rax, -144(%rbp)
  movq -144(%rbp), %rax
  movq %rax, -96(%rbp)
  jmp .Lcerune_block_2
.Lcerune_block_2: # mir_block
  movq -96(%rbp), %rax
  testq %rax, %rax
  leaq .Lcerune_bool_false(%rip), %rcx
  leaq .Lcerune_bool_true(%rip), %rdx
  cmovne %rdx, %rcx
  callq puts
  movq -64(%rbp), %rax
  movq %rax, -152(%rbp)
  movabsq $2, %rax
  movq %rax, -160(%rbp)
  movq -160(%rbp), %rax
  movq %rax, %rcx
  movq -152(%rbp), %rax
  cmpq %rcx, %rax
  sete %al
  movzbq %al, %rax
  movq %rax, -168(%rbp)
  movq -168(%rbp), %rax
  movq %rax, -176(%rbp)
  movq -168(%rbp), %rax
  testq %rax, %rax
  je .Lcerune_block_3
  jmp .Lcerune_block_4
.Lcerune_block_3: # mir_block
  movabsq $0, %rax
  movq %rax, -184(%rbp)
  movq -184(%rbp), %rcx
  callq cerune_fn_report_0
  movq %rax, -192(%rbp)
  movq -192(%rbp), %rax
  movq %rax, -176(%rbp)
  jmp .Lcerune_block_4
.Lcerune_block_4: # mir_block
  movq -176(%rbp), %rax
  testq %rax, %rax
  leaq .Lcerune_bool_false(%rip), %rcx
  leaq .Lcerune_bool_true(%rip), %rdx
  cmovne %rdx, %rcx
  callq puts
  movabsq $0, %rax
  movq %rax, -200(%rbp)
  movq -200(%rbp), %rax
  movq %rax, -208(%rbp)
  movq -200(%rbp), %rax
  testq %rax, %rax
  je .Lcerune_block_5
  jmp .Lcerune_block_6
.Lcerune_block_5: # mir_block
  movabsq $1, %rax
  movq %rax, -216(%rbp)
  movq -216(%rbp), %rcx
  callq cerune_fn_report_0
  movq %rax, -224(%rbp)
  movq -224(%rbp), %rax
  movq %rax, -232(%rbp)
  movq -224(%rbp), %rax
  testq %rax, %rax
  je .Lcerune_block_8
  jmp .Lcerune_block_7
.Lcerune_block_6: # mir_block
  movq -208(%rbp), %rax
  testq %rax, %rax
  leaq .Lcerune_bool_false(%rip), %rcx
  leaq .Lcerune_bool_true(%rip), %rdx
  cmovne %rdx, %rcx
  callq puts
  jmp .Lcerune_block_11
.Lcerune_block_7: # mir_block
  movq -64(%rbp), %rax
  movq %rax, -240(%rbp)
  movabsq $0, %rax
  movq %rax, -248(%rbp)
  movq -248(%rbp), %rax
  movq %rax, %rcx
  movq -240(%rbp), %rax
  cmpq %rcx, %rax
  setg %al
  movzbq %al, %rax
  movq %rax, -256(%rbp)
  movq -256(%rbp), %rax
  movq %rax, -264(%rbp)
  movq -256(%rbp), %rax
  testq %rax, %rax
  je .Lcerune_block_9
  jmp .Lcerune_block_10
.Lcerune_block_8: # mir_block
  movq -232(%rbp), %rax
  movq %rax, -208(%rbp)
  jmp .Lcerune_block_6
.Lcerune_block_9: # mir_block
  movabsq $0, %rax
  movq %rax, -272(%rbp)
  movq -272(%rbp), %rcx
  callq cerune_fn_report_0
  movq %rax, -280(%rbp)
  movq -280(%rbp), %rax
  movq %rax, -264(%rbp)
  jmp .Lcerune_block_10
.Lcerune_block_10: # mir_block
  movq -264(%rbp), %rax
  movq %rax, -232(%rbp)
  jmp .Lcerune_block_8
.Lcerune_block_11: # main_exit
  xorl %eax, %eax
  addq $320, %rsp
  popq %rbp
  retq

.section .rdata,"dr"
.Lcerune_failure_0:
  .asciz "cerune: runtime-v1 code=array-index-out-of-bounds node=16 bytes=134..147\n"
