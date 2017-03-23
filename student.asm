.386
DATA SEGMENT USE16
	N EQU 3
	BUF DB 'zhangsan',0,0
		DB 87,85,80,?
		DB 'lisi',6 DUP(0)
		DB 65,70,70,?
		DB 'shizhao',0,0,0
		DB 94,90,100,?
	in_name DB 11
			DB ?
			DB 11 DUP(0)
	print1 DB 0AH,0DH,'Please input the name:$'
	print2 DB 0AH,0DH,'This student do not exist!$'
	print3 DB 0AH,0DH,'This student have found!$'
	POIN DW 0
	ascore DB 0AH,0DH,'The score is A.$'
	bscore DB 0AH,0DH,'The score is B.$'
	cscore DB 0AH,0DH,'The score is C.$'
	dscore DB 0AH,0DH,'The score is D.$'
	fscore DB 0AH,0DH,'The score is F.$'
DATA ENDS

STACK SEGMENT USE16 STACK
	DB 200 DUP(0)
STACK ENDS

CODE SEGMENT USE16
	ASSUME CS:CODE,DS:DATA,SS:STACK
	
BEGIN:  MOV AX,DATA
		MOV DS,AX
FIRST:	LEA DX,print1
		MOV AH,9
		INT 21H
		
		LEA DX,in_name
		MOV AH,10
		INT 21H
		
		MOV BL,in_name+1
		MOV BH,0
		
		CMP BX,0
		JE FIRST
		
		CMP BX,1
		JE QUIT
		
		MOV CX,0
		MOV BX,0
		MOV DL,0
		MOV AL,BYTE PTR in_name+1
LOOPA:  
		MOV BP,2
		MOV SI,0
		LOOPB : MOV AH,BYTE PTR BUF[BX+SI]
				CMP AH,BYTE PTR in_name[BP+SI]
				JNE NEXT
				INC SI
				INC DL
				CMP DL,AL
				JNE LOOPB
				MOV AH,BYTE PTR BUF[BX+SI]
				CMP AH,0
				JE EXIST
				STC
				JC NEXIST
				
		
		
		
NEXT:	ADD BX,14
		INC CX
		CMP CX,N
		JNE LOOPA
		STC
		JC NEXIST
		
EXIST:  MOV AX,OFFSET BUF
		ADD AX,BX
		ADD AX,10
		MOV POIN,AX
		LEA DX,print3
		MOV AH,9
		INT 21H
		STC
		JC THIRD
		
NEXIST: LEA DX,print2
		MOV AH,9
		INT 21H
		STC
		JC FIRST
		
		
THIRD:  MOV SI,10
		MOV DI,1

LOOPC:	MOV AX,0
		MOV BX,0
		MOV CX,0
		MOV CL,BYTE PTR BUF[SI]     ;A
		MOV BL,BYTE PTR BUF[SI+1]   ;B
		MOV AL,BYTE PTR BUF[SI+2]   ;C
		IMUL CX,2
		MOV BP,2
		MOV DX,0
		IDIV WORD PTR BP
		ADD AX,CX
		ADD AX,BX
		IMUL AX,2
		MOV BP,7
		MOV DX,0
		IDIV WORD PTR BP
		MOV BYTE PTR BUF[SI+3],AL
		
		INC DI
		ADD SI,14
		CMP DI,4
		JNE LOOPC
		STC
		JC FOURTH
		
FOURTH: MOV BX,POIN
		MOV AX,0
		MOV AL,BYTE PTR BUF[BX+3]
		
		CMP AL,90
		JGE LA
		CMP AL,80
		JGE LB
		CMP AL,70
		JGE LC
		CMP AL,60
		JGE LD
		STC
		JC LF
		
LA:     LEA DX,ascore
		MOV AH,9
		INT 21H
		STC
		JC FIRST
		
LB:     LEA DX,bscore
		MOV AH,9
		INT 21H
		STC
		JC FIRST
		
LC:     LEA DX,cscore
		MOV AH,9
		INT 21H
		STC
		JC FIRST
		
LD:     LEA DX,dscore
		MOV AH,9
		INT 21H
		STC
		JC FIRST
		
LF:     LEA DX,fscore
		MOV AH,9
		INT 21H
		STC
		JC FIRST
		
QUIT:	MOV AH,4CH
		INT 21H
CODE ENDS
	END BEGIN