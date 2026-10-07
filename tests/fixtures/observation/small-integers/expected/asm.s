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
cerune_fn_average_0:
  pushq %rbp
  movq %rsp, %rbp
  subq $112, %rsp
  movq %rcx, -8(%rbp)
  movq %rdx, -16(%rbp)
  jmp .Lcerune_fn_0_block_0
.Lcerune_fn_0_block_0: # mir_block
  movq -8(%rbp), %rax
  movq %rax, -24(%rbp)
  movq -24(%rbp), %rax
  # semantic u16, storage i64
  movabsq $0, %r11
  cmpq %r11, %rax
  jl .Lcerune_fn_0_range_bad_3
  movabsq $65535, %r11
  cmpq %r11, %rax
  jle .Lcerune_fn_0_range_ok_3
.Lcerune_fn_0_range_bad_3:
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_0(%rip), %rdx
  movl $76, %r8d
  callq _write
  movl $7, %ecx
  int $0x29
.Lcerune_fn_0_range_ok_3:
  movq %rax, -32(%rbp)
  movq -16(%rbp), %rax
  movq %rax, -40(%rbp)
  movq -40(%rbp), %rax
  # semantic u16, storage i64
  movabsq $0, %r11
  cmpq %r11, %rax
  jl .Lcerune_fn_0_range_bad_4
  movabsq $65535, %r11
  cmpq %r11, %rax
  jle .Lcerune_fn_0_range_ok_4
.Lcerune_fn_0_range_bad_4:
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_1(%rip), %rdx
  movl $76, %r8d
  callq _write
  movl $7, %ecx
  int $0x29
.Lcerune_fn_0_range_ok_4:
  movq %rax, -48(%rbp)
  movq -48(%rbp), %rax
  movq %rax, %rcx
  movq -32(%rbp), %rax
  addq %rcx, %rax
  jno .Lcerune_fn_0_integer_ok_5
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_2(%rip), %rdx
  movl $61, %r8d
  callq _write
  movl $7, %ecx
  int $0x29
.Lcerune_fn_0_integer_ok_5:
  # semantic u16, storage i64
  movabsq $0, %r11
  cmpq %r11, %rax
  jl .Lcerune_fn_0_range_bad_6
  movabsq $65535, %r11
  cmpq %r11, %rax
  jle .Lcerune_fn_0_range_ok_6
.Lcerune_fn_0_range_bad_6:
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_3(%rip), %rdx
  movl $61, %r8d
  callq _write
  movl $7, %ecx
  int $0x29
.Lcerune_fn_0_range_ok_6:
  movq %rax, -56(%rbp)
  movabsq $2, %rax
  movq %rax, -64(%rbp)
  movq -64(%rbp), %rax
  movq %rax, %rcx
  movq -56(%rbp), %rax
  testq %rcx, %rcx
  je .Lcerune_fn_0_division_trap_7
  cmpq $-1, %rcx
  jne .Lcerune_fn_0_division_ok_7
  movabsq $-9223372036854775808, %rdx
  cmpq %rdx, %rax
  jne .Lcerune_fn_0_division_ok_7
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_4(%rip), %rdx
  movl $62, %r8d
  callq _write
  movl $7, %ecx
  int $0x29
.Lcerune_fn_0_division_trap_7:
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_5(%rip), %rdx
  movl $61, %r8d
  callq _write
  movl $7, %ecx
  int $0x29
.Lcerune_fn_0_division_ok_7:
  cqto
  idivq %rcx
  # semantic u16, storage i64
  movabsq $0, %r11
  cmpq %r11, %rax
  jl .Lcerune_fn_0_range_bad_8
  movabsq $65535, %r11
  cmpq %r11, %rax
  jle .Lcerune_fn_0_range_ok_8
.Lcerune_fn_0_range_bad_8:
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_6(%rip), %rdx
  movl $62, %r8d
  callq _write
  movl $7, %ecx
  int $0x29
.Lcerune_fn_0_range_ok_8:
  movq %rax, -72(%rbp)
  movq -72(%rbp), %rax
  # semantic u8, storage i64
  movabsq $0, %r11
  cmpq %r11, %rax
  jl .Lcerune_fn_0_range_bad_9
  movabsq $255, %r11
  cmpq %r11, %rax
  jle .Lcerune_fn_0_range_ok_9
.Lcerune_fn_0_range_bad_9:
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_7(%rip), %rdx
  movl $76, %r8d
  callq _write
  movl $7, %ecx
  int $0x29
.Lcerune_fn_0_range_ok_9:
  movq %rax, -80(%rbp)
  movq -80(%rbp), %rax
  addq $112, %rsp
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
  leaq .Lcerune_failure_8(%rip), %rdx
  movl $64, %r8d
  callq _write
  movl $7, %ecx
  int $0x29
.Lcerune_main_integer_ok_2:
  # semantic i8, storage i64
  movabsq $-128, %r11
  cmpq %r11, %rax
  jl .Lcerune_main_range_bad_3
  movabsq $127, %r11
  cmpq %r11, %rax
  jle .Lcerune_main_range_ok_3
.Lcerune_main_range_bad_3:
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_9(%rip), %rdx
  movl $64, %r8d
  callq _write
  movl $7, %ecx
  int $0x29
.Lcerune_main_range_ok_3:
  movq %rax, -16(%rbp)
  movq -16(%rbp), %rax
  movq %rax, -24(%rbp)
  movabsq $32000, %rax
  movq %rax, -32(%rbp)
  movq -32(%rbp), %rax
  negq %rax
  jno .Lcerune_main_integer_ok_4
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_10(%rip), %rdx
  movl $64, %r8d
  callq _write
  movl $7, %ecx
  int $0x29
.Lcerune_main_integer_ok_4:
  # semantic i16, storage i64
  movabsq $-32768, %r11
  cmpq %r11, %rax
  jl .Lcerune_main_range_bad_5
  movabsq $32767, %r11
  cmpq %r11, %rax
  jle .Lcerune_main_range_ok_5
.Lcerune_main_range_bad_5:
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_11(%rip), %rdx
  movl $64, %r8d
  callq _write
  movl $7, %ecx
  int $0x29
.Lcerune_main_range_ok_5:
  movq %rax, -40(%rbp)
  movq -40(%rbp), %rax
  movq %rax, -48(%rbp)
  movq -48(%rbp), %rax
  movq %rax, -56(%rbp)
  movq -24(%rbp), %rax
  movq %rax, -64(%rbp)
  movq -64(%rbp), %rax
  # semantic i16, storage i64
  movabsq $-32768, %r11
  cmpq %r11, %rax
  jl .Lcerune_main_range_bad_6
  movabsq $32767, %r11
  cmpq %r11, %rax
  jle .Lcerune_main_range_ok_6
.Lcerune_main_range_bad_6:
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_12(%rip), %rdx
  movl $79, %r8d
  callq _write
  movl $7, %ecx
  int $0x29
.Lcerune_main_range_ok_6:
  movq %rax, -72(%rbp)
  movq -72(%rbp), %rax
  movq %rax, %rcx
  movq -56(%rbp), %rax
  addq %rcx, %rax
  jno .Lcerune_main_integer_ok_7
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_13(%rip), %rdx
  movl $64, %r8d
  callq _write
  movl $7, %ecx
  int $0x29
.Lcerune_main_integer_ok_7:
  # semantic i16, storage i64
  movabsq $-32768, %r11
  cmpq %r11, %rax
  jl .Lcerune_main_range_bad_8
  movabsq $32767, %r11
  cmpq %r11, %rax
  jle .Lcerune_main_range_ok_8
.Lcerune_main_range_bad_8:
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_14(%rip), %rdx
  movl $64, %r8d
  callq _write
  movl $7, %ecx
  int $0x29
.Lcerune_main_range_ok_8:
  movq %rax, -80(%rbp)
  movq -80(%rbp), %rax
  movq %rax, %rdx
  leaq .Lcerune_fmt_i64(%rip), %rcx
  callq printf
  movabsq $240, %rax
  movq %rax, -88(%rbp)
  movabsq $80, %rax
  movq %rax, -96(%rbp)
  movq -88(%rbp), %rcx
  movq -96(%rbp), %rdx
  callq cerune_fn_average_0
  movq %rax, -104(%rbp)
  movq -104(%rbp), %rax
  movq %rax, %rdx
  leaq .Lcerune_fmt_i64(%rip), %rcx
  callq printf
  movabsq $127, %rax
  movq %rax, -112(%rbp)
  movabsq $-128, %rax
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
  movabsq $255, %rax
  movq %rax, -136(%rbp)
  movq -136(%rbp), %rax
  # semantic u16, storage i64
  movabsq $0, %r11
  cmpq %r11, %rax
  jl .Lcerune_main_range_bad_9
  movabsq $65535, %r11
  cmpq %r11, %rax
  jle .Lcerune_main_range_ok_9
.Lcerune_main_range_bad_9:
  xorl %ecx, %ecx
  callq fflush
  movl $2, %ecx
  leaq .Lcerune_failure_15(%rip), %rdx
  movl $79, %r8d
  callq _write
  movl $7, %ecx
  int $0x29
.Lcerune_main_range_ok_9:
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
  .asciz "cerune: runtime-v1 code=integer-conversion-out-of-range node=4 bytes=55..64\n"
.Lcerune_failure_1:
  .asciz "cerune: runtime-v1 code=integer-conversion-out-of-range node=6 bytes=67..77\n"
.Lcerune_failure_2:
  .asciz "cerune: runtime-v1 code=integer-overflow node=3 bytes=54..78\n"
.Lcerune_failure_3:
  .asciz "cerune: runtime-v1 code=integer-overflow node=3 bytes=54..78\n"
.Lcerune_failure_4:
  .asciz "cerune: runtime-v1 code=division-overflow node=2 bytes=54..82\n"
.Lcerune_failure_5:
  .asciz "cerune: runtime-v1 code=division-by-zero node=2 bytes=54..82\n"
.Lcerune_failure_6:
  .asciz "cerune: runtime-v1 code=division-overflow node=2 bytes=54..82\n"
.Lcerune_failure_7:
  .asciz "cerune: runtime-v1 code=integer-conversion-out-of-range node=1 bytes=51..83\n"
.Lcerune_failure_8:
  .asciz "cerune: runtime-v1 code=integer-overflow node=10 bytes=101..103\n"
.Lcerune_failure_9:
  .asciz "cerune: runtime-v1 code=integer-overflow node=10 bytes=101..103\n"
.Lcerune_failure_10:
  .asciz "cerune: runtime-v1 code=integer-overflow node=13 bytes=120..126\n"
.Lcerune_failure_11:
  .asciz "cerune: runtime-v1 code=integer-overflow node=13 bytes=120..126\n"
.Lcerune_failure_12:
  .asciz "cerune: runtime-v1 code=integer-conversion-out-of-range node=18 bytes=144..155\n"
.Lcerune_failure_13:
  .asciz "cerune: runtime-v1 code=integer-overflow node=16 bytes=134..155\n"
.Lcerune_failure_14:
  .asciz "cerune: runtime-v1 code=integer-overflow node=16 bytes=134..155\n"
.Lcerune_failure_15:
  .asciz "cerune: runtime-v1 code=integer-conversion-out-of-range node=29 bytes=212..231\n"
