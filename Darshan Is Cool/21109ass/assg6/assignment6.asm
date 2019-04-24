%macro callme 4
mov eax,%1
mov ebx,%2
mov ecx,%3
mov edx,%4
int 80h
%endmacro

section .data
        realmsg db "Real Mode",10,13
        realmsglen equ $-realmsg
        protectedmsg db 10d,13d,"Protected Mode",10,13
        protectedmsglen equ $-protectedmsg
        gdtmsg db 10d,13d,"GDT Contents : "
        gdtmsglen equ $-gdtmsg
        idtmsg db 10d,13d,"IDT Contents : "
        idtmsglen equ $-idtmsg
        ldtmsg db 10d,13d,"LDT Contents : "
        ldtmsglen equ $-ldtmsg
        trmsg db 10d,13d,"Task Register : "
        trmsglen equ $-trmsg
        mswmsg db 10d,13d,"Machine Status Word : "
	col db ":" 
        mswmsglen equ $-mswmsg
        nline db 10d
        
section .bss
        cr0_data resd 1
        gdt resd 1
            resw 1
        ldt resw 1
        idt resd 1
            resw 1
        tr resw 1
        answer resb 04
section .text
        global _start
        _start:
        
        smsw eax
        mov [cr0_data],eax
        bt eax,1
        jc protected
real:        
        callme 4,1,realmsg,realmsglen
        jmp here
        
protected: 
	callme 4,1,protectedmsg,protectedmsglen
here:  
	sgdt [gdt]
        sldt [ldt]
        sidt [idt]
        str [tr]
        
        callme 4,1,gdtmsg,gdtmsglen
        mov ax,[gdt+4]
        call display
        mov ax,[gdt+2]
        call display
        callme 4,1,col,1
        mov ax,[gdt]
        call display

        callme 4,1,idtmsg,idtmsglen
        mov ax,[idt+4]
        call display
        mov ax,[idt+2]
        call display
        callme 4,1,col,1
        mov ax,[idt]
        call display

        callme 4,1,ldtmsg,ldtmsglen
        mov ax,[ldt]
        call display        
        
        callme 4,1,trmsg,trmsglen
        mov ax,[tr]
        call display 
        
        callme 4,1,mswmsg,mswmsglen
        mov ax,[cr0_data+2]
        call display
        mov ax,[cr0_data]
        call display
        
        callme 4,1,nline,1
        mov eax,1
        mov ebx,0
        int 80h


;display procedure for 32bit		
display:
	mov esi,answer+3
	mov ecx,4
	
	cnt:	mov edx,0
		mov ebx,16h
		div ebx
		cmp dl,09h
		jbe add30
		add dl,07h
	add30:	add dl,30h
		mov [esi],dl
		dec esi
		dec ecx
		jnz cnt
	callme 4,1,answer,4
ret
