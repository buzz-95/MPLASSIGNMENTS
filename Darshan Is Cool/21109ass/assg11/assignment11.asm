%macro callme 4
	mov rax,%1
	mov rdi,%2
	mov rsi,%3
	mov rdx,%4
	syscall
%endmacro
section .data
array : dq 11.11,22.22,33.33,44.44,55.55
arraycnt:dw 5
point : db '.'
meanmsg:db 0x0A,"Mean : ",0x0A
lenm: equ $-meanmsg
varmsg : db 0x0A,"Variance : ",0x0A
lenv: equ $-varmsg
stdmsg:db 0x0A,"standard Deviation : ",0x0A
len: equ $-stdmsg
hundred:dq 100
d: db 0x0A
fout db "%lf",10,0

section .bss
cnt :resb 2
cnt1 : resb 2
mean :resq 1
std : resq 1
variance : resq 1

section .text
global main
extern printf
main:
meancalc:
	mov rsi,array
	mov byte[cnt],5
	finit
	fldz
up:
	fadd qword[rsi]
	add rsi,8
	dec byte[cnt]
	jnz up
	fidiv word[arraycnt]
	fst qword[mean]

variance_calc:
	mov qword[variance],00
	fldz
	mov rsi,array
	mov byte[cnt],5
here:
	fld qword[rsi]
	fsub qword[mean]
	fst st1
	fmul st0,st1
	fadd qword[variance]
	fst qword[variance]
	add rsi,8
	dec byte[cnt]
	jnz here
	fld qword[variance]
	fidiv word[arraycnt]
	fst qword[variance]

	mov rax,qword[variance]
	
stddev_calc:
	fsqrt
	fstp qword[std]

display_mean:
	callme 1,1,meanmsg,lenm
	
	mov rdi,fout
	sub rsp,8
	mov rax,1
	movsd xmm0,qword[mean]
	call printf
	add rsp,8
display_variance:
	callme 1,1,varmsg,lenv
	
	mov rdi,fout
	sub rsp,8
	mov rax,1
	movsd xmm0,qword[variance]
	call printf
	add rsp,8
display_stddev:
	callme 1,1,stdmsg,len
	
	mov rdi,fout
	sub rsp,8
	mov rax,1
	movsd xmm0,qword[std]
	call printf
	add rsp,8
	
exit:
	callme 60,0,0,0
