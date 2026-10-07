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
cerune_fn_add_0:
  pushq %rbp
  movq %rsp, %rbp
  subq $80, %rsp
  movq %rcx, -8(%rbp)
  movq %rdx, -16(%rbp)
  jmp .Lcerune_fn_0_block_0
.Lcerune_fn_0_block_0: # mir_block
  movq -8(%rbp), %rax
  movq %rax, -24(%rbp)
  movq -16(%rbp), %rax
  movq %rax, -32(%rbp)
  movq -32(%rbp), %rax
  movq %rax, %rcx
  movq -24(%rbp), %rax
  addq %rcx, %rax
  jno .Lcerune_fn_0_integer_ok_3
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_0(%rip), %rdx
  movl $61, %r8d
  callq _write
  movl $7, %ecx
  int $0x29
.Lcerune_fn_0_integer_ok_3:
  # semantic i32, storage i64
  movabsq $-2147483648, %r11
  cmpq %r11, %rax
  jl .Lcerune_fn_0_range_bad_4
  movabsq $2147483647, %r11
  cmpq %r11, %rax
  jle .Lcerune_fn_0_range_ok_4
.Lcerune_fn_0_range_bad_4:
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_1(%rip), %rdx
  movl $61, %r8d
  callq _write
  movl $7, %ecx
  int $0x29
.Lcerune_fn_0_range_ok_4:
  movq %rax, -40(%rbp)
  movq -40(%rbp), %rax
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
  subq $176, %rsp
  jmp .Lcerune_block_0
.Lcerune_block_0: # mir_block
  movabsq $3, %rax
  movq %rax, -8(%rbp)
  movq -8(%rbp), %rax
  negq %rax
  jno .Lcerune_main_integer_ok_2
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_2(%rip), %rdx
  movl $61, %r8d
  callq _write
  movl $7, %ecx
  int $0x29
.Lcerune_main_integer_ok_2:
  # semantic i32, storage i64
  movabsq $-2147483648, %r11
  cmpq %r11, %rax
  jl .Lcerune_main_range_bad_3
  movabsq $2147483647, %r11
  cmpq %r11, %rax
  jle .Lcerune_main_range_ok_3
.Lcerune_main_range_bad_3:
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_3(%rip), %rdx
  movl $61, %r8d
  callq _write
  movl $7, %ecx
  int $0x29
.Lcerune_main_range_ok_3:
  movq %rax, -16(%rbp)
  movabsq $5, %rax
  movq %rax, -24(%rbp)
  movq -16(%rbp), %rcx
  movq -24(%rbp), %rdx
  callq cerune_fn_add_0
  movq %rax, -32(%rbp)
  movq -32(%rbp), %rax
  movq %rax, -40(%rbp)
  movabsq $4294967295, %rax
  movq %rax, -48(%rbp)
  movq -48(%rbp), %rax
  movq %rax, -56(%rbp)
  movq -40(%rbp), %rax
  movq %rax, -64(%rbp)
  movq -64(%rbp), %rax
  movq %rax, %rdx
  leaq .Lcerune_fmt_i64(%rip), %rcx
  callq printf
  movq -56(%rbp), %rax
  movq %rax, -72(%rbp)
  movabsq $2, %rax
  movq %rax, -80(%rbp)
  movq -80(%rbp), %rax
  movq %rax, %rcx
  movq -72(%rbp), %rax
  testq %rcx, %rcx
  je .Lcerune_main_division_trap_4
  cmpq $-1, %rcx
  jne .Lcerune_main_division_ok_4
  movabsq $-9223372036854775808, %rdx
  cmpq %rdx, %rax
  jne .Lcerune_main_division_ok_4
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_4(%rip), %rdx
  movl $65, %r8d
  callq _write
  movl $7, %ecx
  int $0x29
.Lcerune_main_division_trap_4:
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_5(%rip), %rdx
  movl $64, %r8d
  callq _write
  movl $7, %ecx
  int $0x29
.Lcerune_main_division_ok_4:
  cqto
  idivq %rcx
  # semantic u32, storage i64
  movabsq $0, %r11
  cmpq %r11, %rax
  jl .Lcerune_main_range_bad_5
  movabsq $4294967295, %r11
  cmpq %r11, %rax
  jle .Lcerune_main_range_ok_5
.Lcerune_main_range_bad_5:
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_6(%rip), %rdx
  movl $65, %r8d
  callq _write
  movl $7, %ecx
  int $0x29
.Lcerune_main_range_ok_5:
  movq %rax, -88(%rbp)
  movq -88(%rbp), %rax
  movq %rax, %rdx
  leaq .Lcerune_fmt_i64(%rip), %rcx
  callq printf
  movq -56(%rbp), %rax
  movq %rax, -96(%rbp)
  movq -96(%rbp), %rax
  movq %rax, -104(%rbp)
  movq -104(%rbp), %rax
  movq %rax, %rdx
  leaq .Lcerune_fmt_i64(%rip), %rcx
  callq printf
  movq -56(%rbp), %rax
  movq %rax, -112(%rbp)
  movabsq $2147483648, %rax
  movq %rax, -120(%rbp)
  movq -120(%rbp), %rax
  movq %rax, %rcx
  movq -112(%rbp), %rax
  cmpq %rcx, %rax
  setg %al
  movzbq %al, %rax
  movq %rax, -128(%rbp)
  movq -128(%rbp), %rax
  testq %rax, %rax
  leaq .Lcerune_bool_false(%rip), %rcx
  leaq .Lcerune_bool_true(%rip), %rdx
  cmovne %rdx, %rcx
  callq puts
  movq -40(%rbp), %rax
  movq %rax, -136(%rbp)
  movq -136(%rbp), %rax
  # semantic u32, storage i64
  movabsq $0, %r11
  cmpq %r11, %rax
  jl .Lcerune_main_range_bad_6
  movabsq $4294967295, %r11
  cmpq %r11, %rax
  jle .Lcerune_main_range_ok_6
.Lcerune_main_range_bad_6:
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_7(%rip), %rdx
  movl $79, %r8d
  callq _write
  movl $7, %ecx
  int $0x29
.Lcerune_main_range_ok_6:
  movq %rax, -144(%rbp)
  movq -144(%rbp), %rax
  movq %rax, %rdx
  leaq .Lcerune_fmt_i64(%rip), %rcx
  callq printf
  jmp .Lcerune_block_1
.Lcerune_block_1: # main_exit
  xorl %eax, %eax
  addq $176, %rsp
  popq %rbp
  retq

.section .rdata,"dr"
.Lcerune_failure_0:
  .asciz "cerune: runtime-v1 code=integer-overflow node=1 bytes=50..62\n"
.Lcerune_failure_1:
  .asciz "cerune: runtime-v1 code=integer-overflow node=1 bytes=50..62\n"
.Lcerune_failure_2:
  .asciz "cerune: runtime-v1 code=integer-overflow node=6 bytes=83..85\n"
.Lcerune_failure_3:
  .asciz "cerune: runtime-v1 code=integer-overflow node=6 bytes=83..85\n"
.Lcerune_failure_4:
  .asciz "cerune: runtime-v1 code=division-overflow node=14 bytes=136..145\n"
.Lcerune_failure_5:
  .asciz "cerune: runtime-v1 code=division-by-zero node=14 bytes=136..145\n"
.Lcerune_failure_6:
  .asciz "cerune: runtime-v1 code=division-overflow node=14 bytes=136..145\n"
.Lcerune_failure_7:
  .asciz "cerune: runtime-v1 code=integer-conversion-out-of-range node=25 bytes=200..219\n"
