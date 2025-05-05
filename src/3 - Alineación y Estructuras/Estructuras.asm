

;########### ESTOS SON LOS OFFSETS Y TAMAÑO DE LOS STRUCTS
; Completar las definiciones (serán revisadas por ABI enforcer):
NODO_OFFSET_NEXT EQU 0
NODO_OFFSET_CATEGORIA EQU 8
NODO_OFFSET_ARREGLO EQU 16
NODO_OFFSET_LONGITUD EQU 24
NODO_SIZE EQU 32
PACKED_NODO_OFFSET_NEXT EQU 0
PACKED_NODO_OFFSET_CATEGORIA EQU 8
PACKED_NODO_OFFSET_ARREGLO EQU 9
PACKED_NODO_OFFSET_LONGITUD EQU 17
PACKED_NODO_SIZE EQU 21
LISTA_OFFSET_HEAD EQU 0
LISTA_SIZE EQU 8
PACKED_LISTA_OFFSET_HEAD EQU 0
PACKED_LISTA_SIZE EQU 8

;########### SECCION DE DATOS
section .data

;########### SECCION DE TEXTO (PROGRAMA)
section .text

;########### LISTA DE FUNCIONES EXPORTADAS
global cantidad_total_de_elementos
global cantidad_total_de_elementos_packed

;########### DEFINICION DE FUNCIONES
;extern uint32_t cantidad_total_de_elementos(lista_t* lista);
;registros: lista[rdi]
cantidad_total_de_elementos:
	push rbp
	mov rbp, rsp
	push r12
	push r13
	push r14
	mov rax, [rdi + LISTA_OFFSET_HEAD] ; rax  = nodo actual
	xor ecx, ecx ; contrador total de elementos
.bucle:
	cmp rax, 0
	je .fin
	mov edx, dword [rax + NODO_OFFSET_LONGITUD]; edx = longitrud del arreglo actual
	add ecx, edx
	mov r12, [rax + NODO_OFFSET_NEXT]
	mov rax, r12
	jmp .bucle
.fin:
	mov eax, ecx
	pop r14
	pop r13
	pop r12
	pop rbp
	ret

;extern uint32_t cantidad_total_de_elementos_packed(packed_lista_t* lista);
;registros: lista[?]
cantidad_total_de_elementos_packed:
	push rbp
	mov rbp, rsp
	push r12
	push r13
	push r14
	mov rax, [rdi + PACKED_LISTA_OFFSET_HEAD] ; rax  = nodo actual
	xor ecx, ecx ; contrador total de elementos
.bucle:
	cmp rax, 0
	je .fin
	mov edx, dword [rax + PACKED_NODO_OFFSET_LONGITUD]; edx = longitrud del arreglo actual
	add ecx, edx
	mov r12, [rax + PACKED_NODO_OFFSET_NEXT]
	mov rax, r12
	jmp .bucle
.fin:
	mov eax, ecx
	pop r14
	pop r13
	pop r12
	pop rbp
	ret
	ret

