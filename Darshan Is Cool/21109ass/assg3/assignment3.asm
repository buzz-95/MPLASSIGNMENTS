section .data
ans db '00000000'
len equ 8
n equ 10
msg db '1. HEXTOBCD 2. BCDTOHEX 3.EXIT',0ah
mlen equ $- msg
ihexmsg db 'Enter A Hexadecimal Number : ',0ah
ihlen equ $- ihexmsg
ibcdmsg db 'Enter A BCD Number : ',0ah
iblen equ $- ibcdmsg
		
section .bss	
arr resb 10
choice resb 1

section .text
global  _start
_start:
	mov eax,4
	mov ebx,1
	mov ecx,msg
	mov edx,mlen
	int 80h
	
	mov eax,3
	mov ebx,0
	mov ecx,choice
	mov edx,1
	int 80h
	
	xor rcx,rcx
	mov ecx,[choice]
	sub ecx,'3'
	jz exit
	mov ecx,[choice]
	sub ecx,'2'
	jz BCDTOHEX
	
HEXTOBCD:
	mov eax,4
	mov ebx,1
	mov ecx,ihexmsg
	mov edx,ihlen
	int 80h
	mov eax,3
	mov ebx,0
	mov ecx,arr
	mov edx,n
	int 80h
	mov eax,3
	mov ebx,0
	mov ecx,arr
	mov edx,n
	int 80h
					;ascii ko badla hexadecimal mein
	xor rcx,rcx
	mov esi,arr
	mov edi,0ah
for:
	xor rax,rax
	mov al,[esi]
	xor rbx,rbx
	mov bl,al
	sub bl,0ah
	jz here
	xor rbx,rbx
	mov ebx,eax
	sub ebx,'A'
	js zero_to_nine
	xor rbx,rbx
	mov ebx,eax
	sub ebx,'a'
	js A_to_F
	sub eax,'a'
	add eax,10
	jmp common_
A_to_F:
	sub eax,'A'
	add eax,10
	jmp common_
zero_to_nine:
	sub eax,'0'
common_:
	imul ecx,10h
	add ecx,eax
	inc esi
	dec edi
	jnz for
here:	
	xor rax,rax
	add eax,ecx
	mov esi,ans
	add esi,7
print_bcd:
	xor rdx,rdx
	xor rbx,rbx
	mov bx,0ah
	idiv bx
	add dl,'0'
	mov [esi],dl
	dec esi
	sub eax,0
	jnz print_bcd 
	jmp exit
	
BCDTOHEX:
	mov eax,4
	mov ebx,1
	mov ecx,ibcdmsg
	mov edx,iblen
	int 80h
	mov eax,3
	mov ebx,0
	mov ecx,arr
	mov edx,n
	int 80h
	mov eax,3
	mov ebx,0
	mov ecx,arr
	mov edx,n
	int 80h
					;ascii ko badla hexadecimal mein
	xor rcx,rcx
	mov esi,arr
	mov edi,0ah
for1:	
	xor rax,rax
	mov al,[esi]
	xor rbx,rbx
	mov bl,al
	sub bl,0ah
	jz there
	sub eax,'0'
	imul ecx,0ah
	add ecx,eax
	inc esi
	dec edi
	jnz for1
there:
	xor rax,rax
	mov eax,ecx
	mov esi,ans
	add esi,7
	
print_hex:
	xor rdx,rdx
	xor rbx,rbx
	mov bx,10h
	idiv bx
debug_ptr:
	xor rcx,rcx
	mov cl,dl
	sub cl,0ah
	js zero_To_nine1
	sub dl,0ah
	add dl,'A'
	mov [esi],dl
	jmp ek_hi_rasta	
zero_To_nine1:
	add dl,'0'
	mov [esi],dl
ek_hi_rasta:	
	dec esi
	sub eax,0
	jnz print_hex 
exit:
	mov eax,4
	mov ebx,1
	mov ecx,ans
	mov edx,8
	int 80h
	mov eax,4
	mov ebx,1
	mov ecx,0ah
	mov edx,1
	int 80h
	mov eax,1
	int 80h
	
