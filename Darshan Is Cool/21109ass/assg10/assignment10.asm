%macro callme 4
mov eax,%1
mov ebx,%2
mov ecx,%3
mov edx,%4
int 80h
%endmacro

section .data
nline db 10,13
nlinelen equ $- nline
quadmsg db "Quadratic Equation : ax^2 + bx + c = 0",10,13
quadmsglen equ $- quadmsg
ainput db "Enter Coefficient Of x^2 : a = "
ainputlen equ $- ainput
binput db "Enter Coefficient Of x : b = "
binputlen equ $- binput
cinput db "Enter Constant : c = "
cinputlen equ $- cinput
errorrmsg db "Error : a cannot be zero",10,13
errorrmsglen equ $- errorrmsg
fin db "%lf",0
format db "Root 1 = %lf Root 2 = %lf",10,0
formatin db "Root 1 = %lf - %lf i",10,13,0
formatip db "Root 2 = %lf + %lf i",10,13,0
imsg db "i",10,13
imsglen equ $- imsg
four dq 4
two dq 2

section .bss
a resq 1
b resq 1
c resq 1
bsquare resq 1
fourac resq 1
delta resq 1       ; delta = b * b - 4 * a * c
rootdelta resq 1
root1 resq 1
root2 resq 1
twoa resq 1
bbytwoa resq 1
zero resq 1
deltabytwoa resq 1

section .text
global main
extern printf
extern scanf

main:
	callme 4,1,quadmsg,quadmsglen
	callme 4,1,ainput,ainputlen
									;input a
	mov rdi,fin
	mov rax,0
	sub rsp,8
	mov rsi,rsp
	call scanf
	mov r8,qword[rsp]
	mov qword[a],r8
	add rsp,8

									;input b
	callme 4,1,nline,nlinelen
	callme 4,1,binput,binputlen

	mov rdi,fin
	mov rax,0
	sub rsp,8
	mov rsi,rsp
	call scanf
	mov r8,qword[rsp]
	mov qword[b],r8
	add rsp,8
									;input c
	callme 4,1,nline,nlinelen
	callme 4,1,nline,nlinelen
	callme 4,1,cinput,cinputlen

	mov rdi,fin
	mov rax,0
	sub rsp,8
	mov rsi,rsp
	call scanf
	mov r8,qword[rsp]
	mov qword[c],r8
	add rsp,8

	callme 4,1,nline,nlinelen
	finit
	fldz
	fstp qword[zero]
	mov rax,qword[zero]
	cmp rax,qword[a]
	je errorr

									;calculating discriminant delta and b / (2 * a)
	fld qword[b]
	fmul qword[b]
	fstp qword[bsquare]

	fild qword[four]
	fmul qword[a]
	fmul qword[c]
	fstp qword[fourac]
	
	fild qword[two]
	fmul qword[a]
	fstp qword[twoa]
	
	fld qword[b]
	fdiv qword[twoa]
	fstp qword[bbytwoa]

	fld qword[bsquare]
	fsub qword[fourac]
	fstp qword[delta]
break_here:
										;check if delta is positive or negative
	btr qword[delta],63
	jc imaginary

real:
										;calculating sqrt(delta)
	fld qword[delta]
	fsqrt
	fstp qword[rootdelta]
										;calculating D / (2 * a)
	fld qword[delta]
	fdiv qword[twoa]
	fstp qword[deltabytwoa]
										;calculating the roots 
	fld qword[bbytwoa]
	fsub qword[deltabytwoa]
	fstp qword[root1]
	
	fld qword[bbytwoa]
	fadd qword[deltabytwoa]
	fstp qword[root2]
	
print_real_roots:
	mov rdi,format
	sub rsp,8
	mov rax,2							;number of math co-processor registers used
	movsd xmm0,qword[root1]
	movsd xmm1,qword[root2]
	call printf
	add rsp,8
	
	jmp exit
	
imaginary:
										;calculating sqrt(delta)
	fld qword[delta]
	fsqrt
	fstp qword[rootdelta]
										;calculating D / (2 * a)
	fld qword[rootdelta]
	fdiv qword[twoa]
	fstp qword[deltabytwoa]

printing_imaginary_roots:
	mov rdi,formatin
	sub rsp,8
	mov rax,2							;number of math co-processor registers used
	movsd xmm0,[bbytwoa]
	movsd xmm1,[deltabytwoa]
	call printf
	add rsp,8
	
	mov rdi,formatip
	sub rsp,8
	mov rax,2							;number of math co-processor registers used
	movsd xmm0,[bbytwoa]
	movsd xmm1,[deltabytwoa]
	call printf
	add rsp,8

	jmp exit

errorr:
	callme 4,1,errorrmsg,errorrmsglen
	jmp exit
	
exit:
	callme 1,0,1,1
