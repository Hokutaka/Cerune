Hello,

I am a native Japanese speaker, and I used AI assistance to help write and organize this report in English.  

Could you confirm whether the following is valid QBE IL for amd64_win? I am not assuming this is a confirmed QBE bug: I would like to check my IL usage and the supported ABI contract as well as the generated code.

I reduced an issue from a frontend to this standalone example. It has no frontend runtime, aggregates, varargs, allocation, or external calls.

```
export function w $check(l %a, l %b, l %c, l %d, s %value) {
@start
    %ok =w ceqs %value, s_1.5
    ret %ok
}
```

Versions tested (unmodified):
- v1.3: c0818978acec60ebb6167fade60fb7012cbf20ca.
- Upstream master fetched on 2026-10-03 (UTC): e786f06032fefa2e3790d6b1c9e31ed138f475a6.
- Repository: git://c9x.me/qbe.git.
- qbe-1.3.tar.xz SHA-256: d587905d620dc5e1d2bfa7c2cc642b9b837aa89a3188c6e37b53d756cf66e320.
- The results below are the same for both versions.

On Linux I built QBE using GCC 9.4.0 (`make CC=cc CFLAGS='-std=c99 -O2'`). Commands, with the snippet saved as callee-only.ssa:

```sh
qbe -t amd64_sysv -o linux.s callee-only.ssa
qbe -t amd64_win -o windows.s callee-only.ssa
cc -c linux.s -o linux.o
clang --target=x86_64-pc-windows-msvc -c windows.s -o windows.obj
qbe -t amd64_win -d PA callee-only.ssa 2> windows-lowering.txt
```

Both QBE invocations exit 0. SysV output assembles successfully and uses:

```asm
ucomiss ".Lfp0"(%rip), %xmm0
```

The relevant Windows output is:

```asm
check:
    endbr64
    movq 40(%rsp), %rax
    ucomiss "Lfp0"(%rip), %rax
    setz %al
    movzbl %al, %eax
    setnp %cl
    movzbl %cl, %ecx
    andl %ecx, %eax
    ret
```

Clang 10.0.0 on Linux (targeting COFF), llvm-mc 10.0.0 with the same triple, and native Windows Clang 22.1.8 all reject the ucomiss operand:

```
windows.s:7:24: error: invalid operand for instruction
        ucomiss "Lfp0"(%rip), %rax
                              ^~~~
```

GNU as 2.34 also reports `operand type mismatch for 'ucomiss'` with `as --64 windows.s -o syntax.o`. That last command is only an independent ELF instruction-syntax check, not a Windows object/link test. No linker is reached for the failing cases.

I also built QBE on Windows using MinGW-w64 i686 GCC 8.1.0; it emitted the same assembly after accounting for text line endings. Thus a Linux-built QBE is sufficient to reproduce the Windows-target assembly issue.

Controls and expected behavior:
- Moving the float to the fourth argument produces assembly that builds and runs successfully on both targets.
- The fifth-argument double variant (`d`, `ceqd`, `d_2.5`) produces the analogous `ucomisd ..., %rax` rejection.
- Adding a main function calling check(1,2,3,4,1.5) and returning `1 - check(...)` runs with exit code 0 on SysV. I expect the Windows-target version to assemble and likewise return 0 if this IL is valid.
- Nine floating-point arguments also work on SysV, where the ninth is stack-passed, but reproduce the Windows assembly rejection.
- A QBE caller passing a dynamically obtained fifth float/double argument to a C-compiled callee succeeds on Windows and Linux. The callee-only snippet above already reproduces without any caller.
- Equivalent C compiled by Windows Clang uses an XMM register for the comparison and exits 0.

The QBE debug dump seems to narrow the difference to callee ABI lowering:

```
After parsing:
    %value =s par
    %ok =w ceqs %value, s_1.500000

After ABI lowering:
    %value =l copy S-12
    ...
    %ok =w ceqs %value, s_1.500000
```

One possible location is the non-aggregate APS_InlineOnStack branch in amd64/winabi.c (line 679 in both revisions), which emits Ocopy with Kl. In a separate experimental copy, replacing only that Kl with instr->cls restored the floating class and made the small fourth/fifth-argument float/double controls pass on Windows. I have not validated this as a complete fix for aggregates, varargs, or the upstream test suite, and the reproduction above uses unmodified QBE.

Am I using the IL/ABI correctly here, or is an additional annotation or a different representation required? If the input is valid and supported, would the class change during amd64_win parameter lowering warrant further investigation?

Full commands for the controls are included in the repository linked below.

Full reproduction artifacts are available here:
https://github.com/Hokutaka/Cerune/tree/research/qbe-windows-abi/experiments/qbe-windows-abi

Regards,
Hokutaka