;21109-assignment1- >(9-1-18)<-
section .data
	arr dd -1, 2, 0, 5, -6, -7
	n equ 6
	msg1 db 'Positive Numbers : '
	n1 equ $ - msg1
	msg2 db ' Negative Numbers : '
	n2 equ $ - msg2

section .bss
	positive_count resb 1 ;to store the count of positive numbers
	negative_count resb 1; to store the count of negative numbers

section .text
	global _start
	_start:
		mov esi,arr ;moving base address into source index
		mov edi,n ;moving array size into destination index 
		mov byte[positive_count],'0';
		mov byte[negative_count],'0';
	a:
		mov ebx,[esi]
	        sub eax,eax
		sub eax,ebx
		js d
		add byte[negative_count],1
		jmp c
	d:
		add byte[positive_count],1
	c:
		add esi,4
		dec edi
		jnz a
	display:
		mov eax,4
		mov ebx,1
		mov ecx,msg1
		mov edx,n1
		int 80h
		mov eax,4
		mov ebx,1
		mov ecx,positive_count
		mov edx,1
		int 80h
		mov eax,4
		mov ebx,1
		mov ecx,msg2
		mov edx,n2
		int 80h
		mov eax,4
		mov ebx,1
		mov ecx,negative_count
		mov edx,1
		int 80h
	exit:
		mov eax,1
		mov ebx,0
		int 80h	





