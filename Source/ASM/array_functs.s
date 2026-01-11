; This file contains templates and actual functions to work on arrays in ARM assembly.
    AREA array_functs, CODE, READONLY

; ===== Bubble Sort =====
bsort PROC
    ; Bubble sort an array of 32bit integers in place
	; R0 Numero di elementi nel vettore
	; R1 Vettore da ordinare
	MOV   r12, sp
	STMFD sp!,{r4-r8,r10-r11,lr}				
	
			
	; ALGORITMO 
	MOV R5, R0
	MOV	R11, #1
				
	SUBS R0, R0, #1
	BEQ exit
					
while	
	CMP		R11, #1
	BNE		exit
				
	MOV 	R5, R0
	MOV 	R6, #0
	MOV		R7, #1
	MOV		R11, #0

for				
	LDRB	R4, [R1, R6] 
	;LDR	R4, [R1, R6, LSL#2] ;se il vettore � in word
	LDRB	R8, [R1, R7]
	;LDR	R8, [R1, R7, LSL#2] ;se il vettore � in word
	CMP		R8, R4
	;CMP	R4, R8 ;ordine Cresente
	MOVGT	R11, #1
	STRBGT	R8, [R1, R6]
	;STRGT	R8, [R1, R6, LSL#2]
	STRBGT	R4, [R1, R7]
	;STRGT	R4, [R1, R7, LSL#2]
				
	ADD 	R6, R6, #1
	ADD		R7, R7, #1
				
	SUBS 	R5, R5, #1
	BNE 	for
	BEQ		while

exit
	; restore volatile registers
	LDMFD sp!,{r4-r8,r10-r11,pc}		
	ENDP

; ===== Get MAX and its index =====
get_max FUNCTION
	;R0=Vett
	;R1=dim
	
	MOV   r12, sp
	STMFD sp!,{r4-r8,r10-r11,lr}	
	
	LDR R6, [R0], #4         ; Carica il primo elemento dell'array in R6 (massimo iniziale)
	SUBS R1, R1, #1          ; Decrementa la dimensione (R1 = dim - 1)
	MOV R5, #0				 ; Carica l'indice del primo elemento dell'array
	MOV R7, #1				 ; Indice corrente
	BLE exitMax              ; Se R1 <= 0, salta direttamente all'uscita

loopMax
	LDR R4, [R0], #4         ; Carica l'elemento corrente in R4 e avanza il puntatore R0
	CMP R4, R6               ; Confronta l'elemento corrente (R4) con il massimo attuale (R6)
	MOVGT R6, R4             ; Se R4 > R6, aggiorna il massimo in R6
	MOVGT R5, R7			 ; Aggiorna il massimo indice in R5
	ADD R7, R7, #1			 ; Aggiorna l'indice corrente
	SUBS R1, R1, #1          ; Decrementa il contatore R1
	BGT loopMax              ; Ripeti finch� R1 > 0

exitMax
	MOV R0, R6               ; Salva il massimo trovato in R0 (registro di ritorno)
	MOV R1, R5				 ; Salva il massimo indice trovato
	
	LDMFD sp!,{r4-r8,r10-r11,pc}	
	ENDFUNC

; ===== Get MIN and its index =====
get_min FUNCTION
	;R0=Vett (puntatore all'array)
	;R1=dim  (dimensione dell'array)
	
	MOV   r12, sp
	STMFD sp!,{r4-r8,r10-r11,lr} ; Salva i registri callee-saved nello stack
	
	LDR R6, [R0], #4         ; Carica il primo elemento dell'array in R6 (minimo iniziale)
	MOV R5, #0				 ; Carica l'indice del primo elemento dell'array
	MOV R7, #1				 ; Indice corrente
	SUBS R1, R1, #1          ; Decrementa la dimensione (R1 = dim - 1)
	BLE exitMin              ; Se R1 <= 0, salta direttamente all'uscita

loopMin
	LDR R4, [R0], #4         ; Carica l'elemento corrente in R4 e avanza il puntatore R0
	CMP R4, R6               ; Confronta l'elemento corrente (R4) con il minimo attuale (R6)
	MOVLT R6, R4             ; Se R4 < R6, aggiorna il minimo in R6
	MOVLT R5, R7			 ; Aggiorna il minimo indice trovato
	ADD R7, R7, #1			 ; Aggiorna l'indice corrente
	SUBS R1, R1, #1          ; Decrementa il contatore R1
	BGT loopMin              ; Ripeti finch� R1 > 0

exitMin
	MOV R0, R6               ; Salva il minimo trovato in R0 (registro di ritorno)
	MOV R1, R5				 ; Salva il minimo indice trovato
	
	LDMFD sp!,{r4-r8,r10-r11,pc} ; Ripristina i registri e ritorna
	ENDFUNC

; ===== Is monothonic increasing? =====
is_monotonic_increasing FUNCTION
    ; R0 = Vett (puntatore all'array)
    ; R1 = dim (dimensione dell'array)

    MOV   r12, sp
	STMFD sp!,{r4-r8,r10-r11,lr} ; Salva i registri callee-saved nello stack

    CMP R1, #1                  ; Verifica se il vettore ha al massimo un elemento
    BLE exitTrue                ; Un vettore con 0 o 1 elemento � monotono crescente

    LDR R4, [R0], #4            ; Carica il primo elemento dell'array in R4
    SUBS R1, R1, #1             ; Decrementa la dimensione (R1 = dim - 1)

loopCheck
    LDR R5, [R0], #4            ; Carica l'elemento successivo in R5
    CMP R4, R5                  ; Confronta l'elemento precedente (R4) con l'elemento corrente (R5)
    MOVGT R0, #0                ; Se R4 > R5, il vettore non � monotono crescente
    BGT exitFalse               ; Esce con "false" (0) se non � monotono crescente
    MOV R4, R5                  ; Aggiorna R4 con l'elemento corrente
    SUBS R1, R1, #1             ; Decrementa il contatore R1
    BGT loopCheck               ; Continua finch� ci sono elementi da verificare

exitTrue
    MOV R0, #1                  ; Imposta il risultato a "true" (1)
    B endFunction_is_monotonic_increasing               ; Salta alla fine

exitFalse
    MOV R0, #0                  ; Imposta il risultato a "false" (0)

endFunction_is_monotonic_increasing
	LDMFD sp!,{r4-r8,r10-r11,pc} ; Ripristina i registri e ritorna
    ENDFUNC

;TODO: array sum
	
;TODO: array average