  .MODEL SMALL
  .CODE
	ORG 100H
  START:
	JMP MAIN
	BUF  DB 512 DUP(0)
	SIDE DB ?
	SECTOR DB ?
	TRACK DB ?
  MAIN:

	mov sector,0
	mov track,0
	mov side,0
	jmp read
sdset:
	inc side
	mov track,0
	mov sector,0
	jmp read
trset:
	inc track
	mov sector,0
read:
	inc sector

	MOV AX,0201H
;	MOV CH,0        ;TRACK NUMBER
;	MOV CL,1        ;SECTOR NUMBER
;	MOV DH,0        ; SIDE #1

	MOV CH,track        ;TRACK NUMBER
	MOV CL,sector        ;SECTOR NUMBER
	MOV DH,side        ; SIDE #1


	MOV DL,0        ; 0=A , 1=B ,... (DRIVE NUMBER)
	PUSH AX         ; SAVE AX
	MOV AX,DS
	MOV ES,AX
	POP AX
	LEA BX,BUF
	INT 13H

	MOV BX,1
	MOV AH,0EH      ; WRITE CHAR.
  PRINT:
	MOV AL,BUF[BX]
	CMP AL,32
	JB SKIP
	INT 10H
	JMP CONT
  SKIP:
	MOV AL,'.'
	INT 10H
  CONT:
	INC BX
	CMP BX,513
	JNZ PRINT

	cmp sector,18
	jnz read
;	mov ah,0EH
;	mov al,track
;	int 10h
	cmp track,79
	jnz trset
	cmp side,1
	jnz sdset

	INT 20H

   END START