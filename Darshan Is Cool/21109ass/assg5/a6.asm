%macro callme 4
	mov eax,%1
	mov ebx,%2
	mov ecx,%3
	mov edx,%4
	int 80h
%endmacro
extern buffer,len,result,chr
section .data

section .bss
global counter


section .text
counter:
	mov esi,buffer
	mov edi,[len]
	xor rdx,rdx
	mov dl,byte[chr]
	xor rcx,rcx
again:
	xor rbx,rbx
	mov bl,byte[esi]
	sub bl,dl
	jnz dontcount
	inc ecx
dontcount:
	inc esi
	dec edi
	jnz again
	
	mov [result],ecx
	ret
	
