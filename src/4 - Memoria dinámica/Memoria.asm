extern malloc
extern free
extern fprintf

section .data

section .text

global strCmp
global strClone
global strDelete
global strPrint
global strLen

; ** String **

; int32_t strCmp(char* a, char* b)
;a [rdi], b [rsi]
strCmp:
	push rbp
	mov rbp, rsp
	push r12
	push r13
	xor rax, rax
	xor rcx, rcx

	.comparacion:
	mov r12b, [rdi + rcx]
	mov r13b, [rsi + rcx]
	cmp r12b, r13b
	je .no_se_si_es_null
	cmp r12b, r13b
	jl .es_menor
	cmp r12b, r13b
	jg .es_mayor

	.no_se_si_es_null:
	inc rcx
	cmp byte r12b, 0
	je .es_null
	jmp .comparacion

	.es_mayor:
	mov eax, -1
	jmp .fin

	.es_menor:
	mov eax, 1
	jmp .fin

	.es_null:
	mov eax, 0

	.fin:
	pop r13
	pop r12
	pop rbp
	ret

; char* strClone(char* a)
strClone:
	ret

; void strDelete(char* a)
strDelete:
	ret

; void strPrint(char* a, FILE* pFile)
strPrint:
	ret

; uint32_t strLen(char* a)
; a [rdi]
strLen:
	push rbp
	mov rbp, rsp
	xor rax, rax
	.loop:
	cmp byte [rdi + rax], 0
	je .fin_loop
	inc rax
	jmp .loop

	.fin_loop:
	pop rbp

	ret


