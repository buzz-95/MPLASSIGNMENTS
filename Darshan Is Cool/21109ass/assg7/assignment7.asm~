%macro callmetoo 4
	mov rax,%1
	mov rdi,%2
	mov rsi,%3
	mov rdx,%4
	syscall
%endmacro

section .data
fileinput db "Enter File Name : "
fileinputlen equ $- fileinput
warn db "Error Opening The File!",10,13
warnlen equ $- warn

section .bss
buffer resb 500
len resb 8
fileptr resb 8
filename resb 50

section .text
global _start
_start:
	mov eax,4
	mov ebx,1
	mov ecx,fileinput
	mov edx,fileinputlen
	int 80h
	mov eax,3
	mov ebx,0
	mov ecx,filename
	mov edx,50
	int 80h
	dec eax
	mov byte[filename + eax],0
	callmetoo 2,filename,2,0777 ; open the file
	mov [fileptr],eax
	BT rax,63
	jnc no_errorr 					; jump to errorr if no error found 
errorr:	
	mov eax,4
	mov ebx,1
	mov ecx,warn
	mov edx,warnlen
	int 80h
	mov eax,1
	mov ebx,0
	int 80h
no_errorr:
	xor rax,rax
	callmetoo 0,[fileptr],buffer,500 ; read the contents of te file
	mov [len],eax					 ; store the file size in len
init:
	mov edi,[len]
	dec edi

while:
	mov esi,buffer
	mov edx,edi
again:
	mov bl,byte[esi]
	inc esi
	mov cl,byte[esi]
	sub cl,bl
	jns noswap
	mov cl,byte[esi]
	mov byte[esi],bl
	dec esi
	mov byte[esi],cl
	inc esi
noswap:
	dec edx
	jnz again

	dec edi
	jnz while
	callmetoo 3,[fileptr],0,0 		   ; close the file

	callmetoo 2,filename,2,0777 	   ; open the file

	callmetoo 1,[fileptr],buffer,[len] ; write into file

	mov eax,1
	mov ebx,0
	int 80h
