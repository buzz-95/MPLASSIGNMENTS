section .data
Minput_msg db 'Enter Hexadecimal Multiplicand : '
Milen equ $- Minput_msg
minput_msg db 'Enter Hexadecimal Multiplier : '
milen equ $- minput_msg
choice_msg db '0: Sucessive addition method',0ah,'1: Add and Shift method ',0ah
chlen equ $- choice_msg
result_msg db 'Result = '
reslen equ $- result_msg
result db '00000000',0ah

section .bss
apos resb 1
bpos resb 1
multiplicand resb 8
multiplier resb 8
a resb 1
b resb 1
temp resb 1

section .text
global _start
_start:
	mov eax,4
	mov ebx,1
	mov ecx,Minput_msg
	mov edx,Milen
	int 80h
	mov eax,3
	mov ebx,0
	mov ecx,multiplicand
	mov edx,8
	int 80h
	
	mov esi,multiplicand
	mov edi,8
	xor rcx,rcx
for:
	xor rax,rax
	mov al,[esi]
	xor rbx,rbx
	mov bl,al
	sub bl,0ah
	jz bas
	xor rbx,rbx
	mov bl,al
	sub bl,'A'
	js zero_to_nine
	add bl,0ah
	imul rcx,10h
	add rcx,rbx
	jmp common_
zero_to_nine:
	sub al,'0'
	imul rcx,10h
	add rcx,rax
common_:
	inc esi
	dec edi
	jnz for
bas:
	mov [a],rcx
	
	mov eax,4
	mov ebx,1
	mov ecx,minput_msg
	mov edx,milen
	int 80h
	mov eax,3
	mov ebx,0
	mov ecx,multiplier
	mov edx,8
	int 80h
	
	mov esi,multiplier
	mov edi,8
	xor rcx,rcx
for_1:
	xor rax,rax
	mov al,[esi]
	xor rbx,rbx
	mov bl,al
	sub bl,0ah
	jz bas_1
	xor rbx,rbx
	mov bl,al
	sub bl,'A'
	js zero_to_nine_1
	add bl,0ah
	imul rcx,10h
	add rcx,rbx
	jmp common_1
zero_to_nine_1:
	sub al,'0'
	imul rcx,10h
	add rcx,rax
common_1:
	inc esi
	dec edi
	jnz for_1
bas_1:
	mov [b],rcx

	mov eax,4
	mov ebx,1
	mov ecx,choice_msg
	mov edx,chlen
	int 80h
	
	mov eax,3
	mov ebx,0
	mov ecx,temp
	mov edx,1
	int 80h
	
	mov eax,[temp]
	sub eax,'0'
	jnz ADDANDSHIFT
	
SUCCADD:
	xor rcx,rcx ; clear the result
	xor rax,rax
	xor rbx,rbx
	mov al,[a] ; multiplicand
	mov bl,[b] ; multiplier
add_again:
	add cx,ax	
	dec ebx
	jnz add_again
	jmp print_res
	
ADDANDSHIFT:
	xor rax,rax
	xor rbx,rbx
	xor rcx,rcx
	mov al,[a]  ; multiplicant
	mov bl,[b]	; multiplier
	mov edi,8
while:
	xor rdx,rdx
	rol bx,1
	rol cx,1
	mov rdx,256
	and rdx,rbx
	sub rdx,0
	jz dontadd	
	add cx,ax
dontadd:
	dec edi
	jnz while	
	
print_res:
	mov esi,result
	add esi,8
	mov edi,8
	xor rax,rax
	add rax,rcx
again:
	xor rbx,rbx
	xor rdx,rdx
	mov bx,10h
	idiv bx
	xor rcx,rcx
	mov cl,dl
	sub cl,0ah
	js one_digit
	sub dl,0ah
	add dl,'A'
	jmp path
one_digit:
	add dl,'0'
path:	
	dec esi
	mov [esi],dl
	dec edi
	jnz again
	
	mov eax,4
	mov ebx,1
	mov ecx,result_msg
	mov edx,reslen
	int 80h
	mov eax,4
	mov ebx,1
	mov ecx,result
	mov edx,8
	int 80h
	
exit:	
	mov eax,1
	int 80h
	
		
	
	
	
	
	
	
