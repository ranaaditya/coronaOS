global _start, _kmain
extern kmain, start_ctors, end_ctors, start_dtors, end_dtors

    
%define MULTIBOOT_HEADER_MAGIC  0x1BADB002
%define MULTIBOOT_HEADER_FLAGS	0x00000003
%define CHECKSUM -(MULTIBOOT_HEADER_MAGIC + MULTIBOOT_HEADER_FLAGS)

;-- ENTRY POINT
_start:
	jmp start

;-- Multiboot header --
align 4

multiboot_header:
dd MULTIBOOT_HEADER_MAGIC
dd MULTIBOOT_HEADER_FLAGS
dd CHECKSUM    

;--/MULTIBOOT HEADER --

start:
	push ebx
	 
static_ctors_loop:
   mov ebx, start_ctors
   jmp .test
.body:
   call [ebx]
   add ebx,4
.test:
   cmp ebx, end_ctors
   jb .body
 
   call kmain    ; CALL KERNEL PROPER
 
static_dtors_loop:
   mov ebx, start_dtors
   jmp .test
.body:
   call [ebx]
   add ebx,4
.test:
   cmp ebx, end_dtors
   jb .body
	
	cli       ; STOP INTERRUPTS
	hlt       ; HALT THE CPU
