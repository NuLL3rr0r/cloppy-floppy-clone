  .MODEL SMALL
  .CODE
	ORG 100H
  START:
	JMP MAIN
	BUF  DB 512 DUP(0)
	SIDE DB ?
	SECTOR DB ?
	TRACK DB ?
	c db ?
  MAIN:

	mov sector,0
	mov track,0
	mov side,0
	mov c,1
	jmp read
sdset:
	inc side
	mov track,0
	mov sector,1
	jmp read
	mov c,1
trset:
	inc track
	mov sector,1
	mov c,1
read:
;	inc sector

	MOV AX,0501H
;	MOV CH,0        ;TRACK NUMBER
;	MOV CL,1        ;SECTOR NUMBER
;	MOV DH,0        ; SIDE #1

;	MOV CH,track        ;TRACK NUMBER
;	MOV CL,sector        ;SECTOR NUMBER
	MOV CH,track        ;TRACK NUMBER
	MOV CL,00        ;SECTOR NUMBER
	MOV DH,side        ; SIDE #1


	MOV DL,0        ; 0=A , 1=B ,... (DRIVE NUMBER)
	PUSH AX         ; SAVE AX
	MOV AX,DS
	MOV ES,AX
	POP AX
	LEA BX,BUF
	INT 13H

	jc fff1
	jmp eee
fff1:
	inc c
	cmp c,3
	jnz read
	jmp fff
	

;	MOV BX,1
;	MOV AH,0EH      ; WRITE CHAR.
;  PRINT:
;	MOV AL,BUF[BX]
;	CMP AL,32
;	JB SKIP
;	INT 10H
;	JMP CONT
;  SKIP:
;	MOV AL,'.'
;	INT 10H
;  CONT:
;	INC BX
;	CMP BX,513
;	JNZ PRINT

eee:
;	cmp sector,18
;	jnz read
	mov ah,0EH
	mov al,track
	int 10h
	cmp track,79
	jnz trset
	cmp side,1
	jnz sdset

fff:
	INT 20H

   END START