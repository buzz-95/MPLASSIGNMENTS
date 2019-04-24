%macro callme 4
	mov eax,%1
	mov ebx,%2
	mov ecx,%3
	mov edx,%4
	int 80h
%endmacro
section .data
fileinput db "Enter File Name : "
fileinputlen equ $- fileinput
menumsg db "1. Number Of Spaces 2. Number Of Lines 3. Number of Characters",10,13,"Enter A Choice : "
menumsglen equ $- menumsg
errormsg db "Error",10,13
errormsglen equ $- errormsg
chinput db "Enter The Character : "
chinputlen equ $- chinput
resultmsg db "Result : "
resultmsglen equ $- resultmsg
count db "0000"

section .bss

global buffer,filename,fileptr,len,result,chr
buffer resb 500
fileptr resb 8
len resb 8
result resb 4
choice resb 1
chr resb 1
filename resb 50

section .text
global _start
_start:
	callme 4,1,fileinput,fileinputlen
	callme 3,0,filename,50			; input file name
	dec eax
	mov byte[filename + eax],0
	callme 5,filename,0,0777		; open the file 
	mov [fileptr],eax				; mov the file descriptor 
	BT rax,63
	jnc no_errorr
errorr:
	callme 4,1,errormsg,errormsglen ; print errorr message
	callme 1,0,1,1					; exit
	
no_errorr:
	xor rax,rax
	callme 3,[fileptr],buffer,500   ; read the file
	mov [len],eax
	
menudisp:
	callme 4,1,menumsg,menumsglen
	callme 3,0,choice,1
	xor rbx,rbx
	add bl,[choice]
	sub bl,'2'
	jz lines
	js spaces
chars:
	callme 3,0,chr,1
	jmp common_
lines:
	mov byte[chr],0ah
	jmp common_
spaces:
	mov byte[chr],' '

common_:
	extern counter
	call counter
	
	xor rax,rax
	mov eax,[result]
	mov esi,count
	add esi,3
again:
	xor rbx,rbx
	xor rdx,rdx
	mov bx,0ah
	idiv bx
	add dl,'0'
	mov [esi],dl
	dec esi
	sub eax,0
	jnz again
	
	callme 4,1,count,4
	
exit:	
	callme 1,0,1,1 					; exit
