  .MODEL SMALL
  .CODE
	ORG 100H
  START:
	JMP MAIN
	BUF  DB 512 DUP(0)

	filespec db 'ABC.DOC',00H
	handle dw ?

  MAIN:

	mov ax,3D00h
	mov cx,00h
	lea dx,filespec
	int 21h
	mov handle,ax
	mov ah,3Fh
	mov bx,handle
	mov cx,512
	lea dx,buf
	int 21h
	mov ah,3Eh
	mov bx,handle
	int 21h

	MOV AX,0301H
	MOV CH,0        ;TRACK NUMBER
	MOV CL,1        ;SECTOR NUMBER
	MOV DH,0        ; SIDE #1
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

	INT 20H

   END START