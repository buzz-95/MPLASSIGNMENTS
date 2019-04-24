section .data
	mystring db  'hello destination is more than source!' ; this is just for help purposes
	source_arr db 'source array'                          ; source array
	len equ $- source_arr                                   ; size of source array
	debug_msg db 'hello source is more than destination!' ; just a msg for debugging
	dlen equ $- debug_msg                         	      ; length of debug message
	offset equ +5                                         ; offset

section .bss
	temp resb 1
section .text
global _start
_start:
	mov rsi,source_arr
	mov rdi,source_arr + offset
	mov edx,len
	mov rax,rsi		       ; move source array base address
	sub rax,rdi		       ; subtract the destination address from the source address
	js d			       ; if destination address is greater than source address then jump to d
ups:
	mov ebx,[esi]                  ; load the data into accumulator
	mov [edi],ebx                  ; store data into destination index
	add esi,1                      ; increment source index by 1
	add edi,1                      ; increment destination index by 1
	dec edx                        ; decrement counter (edx)
	jnz ups			       ; jump to ups if counter != 0
	jmp exit		       ; exit
d:
	mov ecx,edx                    ; move edx into ecx
	add esi,ecx                    ; adding offset to source base address
	add edi,ecx                    ; adding offset to destination address
upd: 
	sub esi,1	               ; decrement source index by 1
	sub edi,1                      ; decrement destination index by 1
	mov eax,[esi]                  ; load the data into accumulator
	mov [edi],eax                  ; store data into destination index
	dec edx                        ; decrement counter (edx)
	jnz upd			       ; jump to up if counter != 0

exit:
	mov esi,source_arr + offset              ; verifying the transfer
	mov edi,len		       					 ; by printing the destination array
disp_ele:
	mov ebx,[esi]		       ; moving element by element 
	mov [temp],ebx		       ; value into temp
	mov eax,4		       ; and printing the
	mov ebx,1		       ; source array copied
	mov ecx,temp                   ; in the destination address
	mov edx,1
	int 80h
	add esi,1
	dec edi
	jnz disp_ele
quit:
	mov eax,1		       ; exit
	int 80h
