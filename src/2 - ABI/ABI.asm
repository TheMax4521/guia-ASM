extern sumar_c
extern restar_c
;########### SECCION DE DATOS
section .data

;########### SECCION DE TEXTO (PROGRAMA)
section .text

;########### LISTA DE FUNCIONES EXPORTADAS

global alternate_sum_4
global alternate_sum_4_using_c
global alternate_sum_4_using_c_alternative
global alternate_sum_8
global product_2_f
global product_9_f

;########### DEFINICION DE FUNCIONES
; uint32_t alternate_sum_4(uint32_t x1, uint32_t x2, uint32_t x3, uint32_t x4);
; parametros: 
; x1 --> EDI
; x2 --> ESI
; x3 --> EDX
; x4 --> ECX
alternate_sum_4:
  sub EDI, ESI
  add EDI, EDX
  sub EDI, ECX

  mov EAX, EDI
  ret

; uint32_t alternate_sum_4_using_c(uint32_t x1, uint32_t x2, uint32_t x3, uint32_t x4);
; parametros: 
; x1 --> EDI
; x2 --> ESI
; x3 --> EDX
; x4 --> ECX
alternate_sum_4_using_c:
  ;prologo
  push RBP ;pila alineada
  mov RBP, RSP ;strack frame armado
  push R12
  push R13	; preservo no volatiles, al ser 2 la pila queda alineada

  mov R12D, EDX ; guardo los parámetros x3 y x4 ya que están en registros volátiles
  mov R13D, ECX ; y tienen que sobrevivir al llamado a función

  call restar_c 
  ;recibe los parámetros por EDI y ESI, de acuerdo a la convención, y resulta que ya tenemos los valores en esos registros
  
  mov EDI, EAX ;tomamos el resultado del llamado anterior y lo pasamos como primer parámetro
  mov ESI, R12D
  call sumar_c

  mov EDI, EAX
  mov ESI, R13D
  call restar_c

  ;el resultado final ya está en EAX, así que no hay que hacer más nada

  ;epilogo
  pop R13 ;restauramos los registros no volátiles
  pop R12
  pop RBP ;pila desalineada, RBP restaurado, RSP apuntando a la dirección de retorno
  ret


alternate_sum_4_using_c_alternative:
  ;prologo
  push RBP ;pila alineada
  mov RBP, RSP ;strack frame armado
  sub RSP, 16 ; muevo el tope de la pila 8 bytes para guardar x4, y 8 bytes para que quede alineada

  mov [RBP-8], RCX ; guardo x4 en la pila

  push RDX  ;preservo x3 en la pila, desalineandola
  sub RSP, 8 ;alineo
  call restar_c 
  add RSP, 8 ;restauro tope
  pop RDX ;recupero x3
  
  mov EDI, EAX
  mov ESI, EDX
  call sumar_c

  mov EDI, EAX
  mov ESI, [RBP - 8] ;leo x4 de la pila
  call restar_c

  ;el resultado final ya está en EAX, así que no hay que hacer más nada

  ;epilogo
  add RSP, 16 ;restauro tope de pila
  pop RBP ;pila desalineada, RBP restaurado, RSP apuntando a la dirección de retorno
  ret


; uint32_t alternate_sum_8(uint32_t x1, uint32_t x2, uint32_t x3, uint32_t x4, uint32_t x5, uint32_t x6, uint32_t x7, uint32_t x8);
; registros y pila: x1[EDI], x2[ESI], x3[EDX], x4[ECX], x5[R8D], x6[R9D], x7[RBP + 16], x8[RBP + 24]
alternate_sum_8:
	;prologo
  push RBP ;pila alineada
  MOV RBP, RSP ;armo stackframe
  push R12 ; pila desalineada
  push R13 ; pila alineada
  push R14 ; pila desalineada
  push R15 ; pila alineada, PRESERVO NO VOLATILES

  mov R12D, EDX ; guardo x3 que está en un registro volátil
  mov R13D, ECX ; repito con x4, x5 y x6
  mov R14D, R8D
  mov R15D, R9D

  call restar_c
  ;recibe los parámetros por EDI y ESI y guarda el resultado en EAX
  mov EDI, EAX ;muevo el resultado a EDI y el x3 a ESI para usarlos en la próxima suma
  mov ESI, R12D

  call sumar_c
  mov EDI, EAX
  mov ESI, R13D

  call restar_c
  mov EDI, EAX
  mov ESI, R14D

  call sumar_c
  mov EDI, EAX
  mov ESI, R15D

  call restar_c
  ;resultado final está en EAX
  add EAX, [RBP + 16]
  sub EAX, [RBP + 24]

	;epilogo
  pop R15
  pop R14
  pop R13
  pop R12 ;restauro registros no volatiles
  pop RBP ; pila desalineada, restauro RBP
	ret


; SUGERENCIA: investigar uso de instrucciones para convertir enteros a floats y viceversa
;void product_2_f(uint32_t * destination, uint32_t x1, float f1);
;registros: destination[EDI], x1[ESI], f1[XMM0]
product_2_f:
  push rbp
  mov rbp, rsp
  cvtss2sd xmm0, xmm0
  cvtsi2sd xmm1, esi

  MULsd xmm0, xmm1
  cvttsd2si eax, xmm0
  mov [RDI], EAX
  pop rbp
	ret


;extern void product_9_f(double * destination
;, uint32_t x1, float f1, uint32_t x2, float f2, uint32_t x3, float f3, uint32_t x4, float f4
;, uint32_t x5, float f5, uint32_t x6, float f6, uint32_t x7, float f7, uint32_t x8, float f8
;, uint32_t x9, float f9);
;registros y pila: destination[rdi], x1[esi], f1[xmm0], x2[edx], f2[xmm1], x3[ecx], f3[xmm2], x4[r8d], f4[xmm3]
;	, x5[r9d], f5[xmm4], x6[rbp + 16], f6[xmm5], x7[rbp + 24], f7[xmm6], x8[rbp + 32], f8[xmm7],
;	, x9[rbp + 40], f9[rbp + 48]
product_9_f:
	;prologo
	push rbp ;pila alineada
	mov rbp, rsp

	;convertimos los flotantes de cada registro xmm en doubles
	cvtss2sd xmm0, xmm0
  cvtss2sd xmm1, xmm1
  cvtss2sd xmm2, xmm2
  cvtss2sd xmm3, xmm3
  cvtss2sd xmm4, xmm4
  cvtss2sd xmm5, xmm5
  cvtss2sd xmm6, xmm6
  cvtss2sd xmm7, xmm7

	;multiplicamos los doubles en xmm0 <- xmm0 * xmm1, xmmo * xmm2 , ...
	mulsd xmm0, xmm1  ;multiplico f1 * f2
  mulsd xmm0, xmm2  ;multiplico f1 * f2 * f3
  mulsd xmm0, xmm3  ;multiplico f1 * f2 * f3 * f4
  mulsd xmm0, xmm4  ;multiplico f1 * f2 * f3 * f4 * f5
  mulsd xmm0, xmm5  ;multiplico f1 * f2 * f3 * f4 * f5 * f6 
  mulsd xmm0, xmm6  ;multiplico f1 * f2 * f3 * f4 * f5 * f6 * f7 
  mulsd xmm0, xmm7  ;multiplico f1 * f2 * f3 * f4 * f5 * f6 * f7 * f8
  movsd xmm1, [rbp + 48] ;muevo f9 a xmm1
  cvtss2sd xmm1, xmm1 ; convierto f9 a double
  mulsd xmm0, xmm1  ;multiplico f1 * f2 * f3 * f4 * f5 * f6 * f7 * f8 * f9 y se guarda en xmm0

	; convertimos los enteros en doubles y los multiplicamos por xmm0.
	cvtsi2sd xmm1, esi  ;convierto x1 a double
  cvtsi2sd xmm2, edx  ;convierto x2 a double
  cvtsi2sd xmm3, ecx  ;convierto x3 a double
  cvtsi2sd xmm4, r8d  ;convierto x4 a double
  cvtsi2sd xmm5, r9d  ;convierto x5 a double
  mulsd xmm0, xmm1  ;multiplico xmm0 * x1
  mulsd xmm0, xmm2  ;multiplico xmm0 * x1 * x2
  mulsd xmm0, xmm3  ;multiplico xmm0 * x1 * x2 * x3
  mulsd xmm0, xmm4  ;multiplico xmm0 * x1 * x2 * x3 * x4
  mulsd xmm0, xmm5  ;multiplico xmm0 * x1 * x2 * x3 * x4 * x5
  mov esi, [rbp + 16] ;paso x6, x7, x8 y x9 a registros
  mov edx, [rbp + 24]
  mov ecx, [rbp + 32]
  mov r8d, [rbp + 40]
  cvtsi2sd xmm1, esi  ;convierto x6, x7, x8 y x9 a double
  cvtsi2sd xmm2, edx
  cvtsi2sd xmm3, ecx
  cvtsi2sd xmm4, r8d
  mulsd xmm0, xmm1  ;multiplico xmm0 * x1 * x2 * x3 * x4 * x5 * x6
  mulsd xmm0, xmm2  ;multiplico xmm0 * x1 * x2 * x3 * x4 * x5 * x6 * x7
  mulsd xmm0, xmm3  ;multiplico xmm0 * x1 * x2 * x3 * x4 * x5 * x6 * x7 * x8
  mulsd xmm0, xmm4  ;multiplico xmm0 * x1 * x2 * x3 * x4 * x5 * x6 * x7 * x8 * x9
  movsd [rdi], xmm0

	; epilogo
	pop rbp
	ret

