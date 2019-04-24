%macro callme 4
mov rax,%1
mov rdi,%2
mov rsi,%3
mov rdx,%4
syscall
%endmacro

section .data
	errorrmsg db "Error Opening This File",10,13
	errorrmsglen equ $- errorrmsg
	
section .bss
	fname1 resb 50
	fname2 resb 50
	filedesc1 resb 8
	filedesc2 resb 8
	buffer resb 500
	len resb 8

section .text
global _start
_start:
	pop rsi
	pop rsi
	pop rsi
	mov bl,byte[rsi]
	cmp bl,'T'
	je TYPE
	cmp bl,'C'
	je COPY
	cmp bl,'D'
	je DEL
	jmp EXIT

TYPE:
	pop rsi
	mov rdi,fname1
	mov edx,50
here1:
	mov bl,byte[rsi]
	mov byte[rdi],bl
	inc rsi
	inc rdi
	dec edx
	jnz here1
	
	callme 2,fname1,2,0777      ; opening the file
	mov [filedesc1],rax
	bt rax,63
	jnc no_error1

error1:
	mov eax,4
	mov ebx,1
	mov ecx,errorrmsg
	mov edx,errorrmsglen
	int 80h
	
	jmp EXIT

no_error1:
	callme 0,[filedesc1],buffer,500
	mov [len],rax
	
	;printing the file contents now
	
	mov eax,4
	mov ebx,1
	mov ecx,buffer
	mov edx,[len]
	int 80h
	callme 3,[filedesc1],0,0
	jmp EXIT
	
COPY:
	pop rsi
	mov rdi,fname1
	mov edx,50
here2:
	mov bl,byte[rsi]
	mov byte[rdi],bl
	inc rsi
	inc rdi
	dec edx
	jnz here2
	
	callme 2,fname1,2,0777      ; opening the file
	mov [filedesc1],rax
	bt rax,63
	jnc no_error2

error2:
	mov eax,4
	mov ebx,1
	mov ecx,errorrmsg
	mov edx,errorrmsglen
	int 80h
	jmp EXIT

no_error2:
	callme 0,[filedesc1],buffer,500
	mov [len],rax
	
	; opening the second file	
	pop rsi
	mov rdi,fname2
	mov edx,50
here3:
	mov bl,byte[rsi]
	mov byte[rdi],bl
	inc rsi
	inc rdi
	dec edx
	jnz here3
	
	;deleting the file first
	callme 87,fname2,0,0
	
	;creating a duplicate file
	callme 2,fname2,0102o,0660o
	
	callme 2,fname2,2,0777      ; opening the file
	mov [filedesc2],rax
	bt rax,63
	jnc no_error3

error3:
	mov eax,4
	mov ebx,1
	mov ecx,errorrmsg
	mov edx,errorrmsglen
	int 80h
	jmp EXIT

no_error3:
	callme 1,[filedesc2],buffer,[len]
	
	callme 3,[filedesc1],0,0
	callme 3,[filedesc2],0,0
	
	jmp EXIT
	
DEL:
	pop rsi
	mov rdi,fname1
	mov edx,50
here4:
	mov bl,byte[rsi]
	mov byte[rdi],bl
	inc rsi
	inc rdi
	dec edx
	jnz here4
	
	callme 87,fname1,0,0
	jmp EXIT

	
EXIT:
	mov rax,1
	mov rbx,0
	int 80h
