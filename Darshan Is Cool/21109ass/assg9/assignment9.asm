%macro callme 4
	mov eax,%1
	mov ebx,%2
	mov ecx,%3
	mov edx,%4
	int 80h
%endmacro
section .data
result db "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001"
reslen equ $- result

section .bss
len resb 1
n resb 4

section .text
global _start
_start:
	pop rsi
	pop rsi
	pop rsi
	xor rcx,rcx
	xor rax,rax
again:
	xor rbx,rbx
	mov bl,byte[rsi]
	xor rdx,rdx
	mov dl,bl
	sub dl,'!' ;delimtter space 
	jz done
	sub bl,'0'
	xor rdx,rdx
	add dl,0ah
	imul dl
	add al,bl
	inc rsi
	jmp again
done:
	xor rcx,rcx
	mov rcx,rax
	call fact
	callme 4,1,result,reslen
	callme 1,0,0,0
	
fact:						; function fact
	cmp cl,1
	je return_
mult:
	mov esi,result			
	add esi,reslen - 1		; to the last digit of result
	mov edi,reslen			; counter initialized to reslen
	xor rax,rax
here:
	xor rbx,rbx
	mov ebx,eax
	xor rax,rax
	mov al,byte[esi]
	sub al,'0'
	mul ecx
	add eax,ebx
wait_and_watch:
	xor rbx,rbx
	xor rdx,rdx
	add bx,0ah
	div bx
wait_here_too:
	add dl,'0'
	mov byte[esi],dl
	dec esi
	dec edi
	jnz here
	dec ecx
	call fact
return_:
	ret
