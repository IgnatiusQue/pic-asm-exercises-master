;-------------------------------------------------------------------------------
; Arquivos de Defini��o
;-------------------------------------------------------------------------------
#INCLUDE <P16F877A.INC>	 ;ARQUIVO PADR�O MICROCHIP PARA 16F877A
;DEFINE TODOS OS REGISTRADORES SFRs
__CONFIG _BODEN_ON & _CP_OFF & _PWRTE_ON & _WDT_OFF & _LVP_OFF & _XT_OSC

;--------------------------------------------------------------------
; Defini��o das Mem�rias
;--------------------------------------------------------------------
#DEFINE	BANK0	BCF STATUS,RP0	;SETA BANK 0 DE MEM�RIA
#DEFINE	BANK1	BSF STATUS,RP0	;SETA BANK 1 DE MAM�RIA

;--------------------------------------------------------------------
; Vari�veis
;--------------------------------------------------------------------
CBLOCK	0x20	 ;ENDERE�O INICIAL DA MEM�RIA DE USU�RIO
REG_TEMPO_1
REG_TEMPO_2
REG_TEMPO_3
ENDC	 ;FIM DO BLOCO DE MEM�RIA	

;--------------------------------------------------------------------
; Entradas
;--------------------------------------------------------------------
#DEFINE	BOTAO1	PORTA,0	;PORTA DO BOT�O 1
; 0 -> PRESSIONADO
; 1 -> LIBERADO

#DEFINE	BOTAO2	PORTA,1	;PORTA DO BOT�O 2
; 0 -> PRESSIONADO
; 1 -> LIBERADO

#DEFINE	BOTAO3	PORTA,2	;PORTA DO BOT�O 3
; 0 -> PRESSIONADO
; 1 -> LIBERADO

;----------------------------------------------------------
; Sa�das
;----------------------------------------------------------
#DEFINE	LED1	PORTB,0	;PORTB DO LED 1
; 0 -> APAGADO
; 1 -> ACESO

#DEFINE	LED2	PORTB,1	;PORTB DO LED 2
; 0 -> APAGADO
; 1 -> ACESO

#DEFINE	LED3	PORTB,2	;PORTB DO LED 3
; 0 -> APAGADO
; 1 -> ACESO

#DEFINE	LED4	PORTB,3	;PORTB DO LED 4
; 0 -> APAGADO
; 1 -> ACESO

#DEFINE	LED5	PORTB,4	;PORTB DO LED 5
; 0 -> APAGADO
; 1 -> ACESO

#DEFINE	LED6	PORTB,5	;PORTB DO LED 6
; 0 -> APAGADO
; 1 -> ACESO

#DEFINE	LED7	PORTB,6	;PORTB DO LED 7
; 0 -> APAGADO
; 1 -> ACESO

#DEFINE	LED8	PORTB,7	;PORTB DO LED 8
; 0 -> APAGADO
; 1 -> ACESO

;----------------------------------------------------------
; VETOR DE RESET
;----------------------------------------------------------
ORG	0x00	 ;ENDERE�O INICIAL DE PROCESSAMENTO VETOR RESET

GOTO	INICIO

;----------------------------------------------------------
; INICIO DE INTERRUP��O
;----------------------------------------------------------
ORG	0x04	 ;ENDERE�O INICIAL DA INTERRUP��O
RETFIE	 ;RETORNA DA INTERRUP��O
;----------------------------------------------------------
; ROTINA DE DELAY
;----------------------------------------------------------
DELAY_1s	 ;DELAY (X) SEGUNDOS
DL1
MOVWF	REG_TEMPO_3	 ;**** ---1uS
MOVLW	.100	 ;**** ---1uS
MOVWF	REG_TEMPO_1	 ;**** ---1uS
DL2
MOVWF	REG_TEMPO_2 ;---1uS (T1)
NOP	 ;---1uS (T2)	 NOP --- Gasta 1 tempo
DECFSZ	REG_TEMPO_2,F	;---1uS (T3)	((T2+T3+T4)*250) * ((T1+T5+T6)*250) * TT
GOTO	DL1	 ;---2uS (T4)	
DECFSZ	REG_TEMPO_1,F	;---1uS (T5)
GOTO	DL2	 ;---2uS (T6)
DECFSZ	REG_TEMPO_3,F	 ; TT
GOTO	DL2

RETURN

;----------------------------------------------------------
; ROTINA DE CONFIGURA��O
;----------------------------------------------------------

INICIO
CLRF	PORTA	 ;LIMPA O PORTA
CLRF	PORTB	 ;LIMPA O PORTB
CLRF	PORTC	 ;LIMPA O PORTB
CLRF	PORTD	 ;LIMPA O PORTB
CLRF	PORTE	 ;LIMPA O PORTB


BANK1	 ;ALTERA PARA O BANCO 1
MOVLW	B'00000111' ;QUANDO COLOCAR "0" INDICA SAIDA E "1" ENTRADA
MOVWF	TRISA	 ;DEFINE RA0 COMO ENTRADA E DEMAIS
;COMO SA�DAS, CONFIGURA A DIRE��O DOS PINOS DO PORT A

MOVLW	B'00000000'	;QUANDO COLOCAR "0" INDICA SAIDA E "1" ENTRADA
MOVWF	TRISB	 ;DEFINE TODO O PORTB COMO SA�DA CONFIGURA A 
;DIRE��O DOS PINOS DO PORT B

MOVLW	B'00000000'	;QUANDO COLOCAR "0" INDICA SAIDA E "1" ENTRADA
MOVWF	TRISC	 ;DEFINE TODO O PORTB COMO SA�DA CONFIGURA A 
;DIRE��O DOS PINOS DO PORT B

MOVLW	B'00000000'	;QUANDO COLOCAR "0" INDICA SAIDA E "1" ENTRADA
MOVWF	TRISD	 ;DEFINE TODO O PORTB COMO SA�DA CONFIGURA A 
;DIRE��O DOS PINOS DO PORT B

MOVLW	B'00000000'	;QUANDO COLOCAR "0" INDICA SAIDA E "1" ENTRADA
MOVWF	TRISE	 ;DEFINE TODO O PORTB COMO SA�DA CONFIGURA A 
;DIRE��O DOS PINOS DO PORT B

BANK0	 ;ALTERA PARA O BANCO 0

MOVLW	B'00000111'
MOVWF	CMCON	 ;DEFINE O MODO DE OPERA��O DO COMPARADOR ANAL�GICO
;DESLIGADOS
BANK1

MOVLW B'00000110'	;DESLIGAR CONVERSORES A/D INTERNOS
MOVWF	ADCON1

BANK0

;--------------------------------------------------------
; Rotina do Bot�o 1
;--------------------------------------------------------
BT1
BTFSS	BOTAO1	 ;O BOT�O EST� PRESSIONADO? Testa o BIT do arquivo e pula se SET (n�vel l�gico alto)
GOTO	BOTAO1_ON	;N�O, ENT�O TRATA BOT�O1 LIBERADO
GOTO	BOTAO1_OFF	;SIM, ENT�O TRATA BOT�O1 PRESSIONADO
BT2
BTFSS	BOTAO2
GOTO	BOTAO2_ON
GOTO	BOTAO2_OFF

BT3
BTFSS	BOTAO3
GOTO	BOTAO3_ON
GOTO	BOTAO3_OFF

BOTAO1_ON
BSF	 LED1 ;ACENDE O LED1
BSF	 LED2 ;ACENDE O LED2
BSF	 LED3 ;ACENDE O LED3
BSF	 LED4 ;ACENDE O LED4
BSF	 LED5 ;ACENDE O LED5
BSF	 LED6 ;ACENDE O LED6
BSF	 LED7 ;ACENDE O LED7
BSF	 LED8 ;ACENDE O LED8

GOTO BT2	 ;RETORNA AO LOOP MAIN

BOTAO1_OFF
BCF	 LED1	 ;APAGA O LED1 
BCF	 LED2	 ;APAGA O LED2
BCF	 LED3	 ;APAGA O LED3 
BCF	 LED4	 ;APAGA O LED4 
BCF	 LED5	 ;APAGA O LED5 
BCF	 LED6	 ;APAGA O LED6 
BCF	 LED7	 ;APAGA O LED7 
BCF	 LED8	 ;APAGA O LED8 

GOTO BT2	 ;RETORNA AO LOOP MAIN

BOTAO2_ON
BSF	 LED1 ;ACENDE O LED1
CALL	DELAY_1s
BCF	 LED1	 ;APAGA O LED1 

BSF	 LED2 ;ACENDE O LED2
CALL	DELAY_1s
BCF	 LED2	 ;APAGA O LED2

BSF	 LED3 ;ACENDE O LED3
CALL	DELAY_1s
BCF	 LED3	 ;APAGA O LED3 

BSF	 LED4 ;ACENDE O LED4
CALL	DELAY_1s
BCF	 LED4	 ;APAGA O LED4 

BSF	 LED5 ;ACENDE O LED5
CALL	DELAY_1s
BCF	 LED5	 ;APAGA O LED5 

BSF	 LED6 ;ACENDE O LED6
CALL	DELAY_1s
BCF	 LED6	 ;APAGA O LED6 

BSF	 LED7 ;ACENDE O LED7
CALL	DELAY_1s
BCF	 LED7	 ;APAGA O LED7 

BSF	 LED8 ;ACENDE O LED8
CALL	DELAY_1s
BCF	 LED8	 ;APAGA O LED8 

GOTO BT3	 ;RETORNA AO LOOP MAIN

BOTAO2_OFF
BCF	 LED1	 ;APAGA O LED1 
BCF	 LED2	 ;APAGA O LED2
BCF	 LED3	 ;APAGA O LED3 
BCF	 LED4	 ;APAGA O LED4 
BCF	 LED5	 ;APAGA O LED5 
BCF	 LED6	 ;APAGA O LED6 
BCF	 LED7	 ;APAGA O LED7 
BCF	 LED8	 ;APAGA O LED8 

GOTO BT3	 ;RETORNA AO LOOP MAIN

BOTAO3_ON
BSF	 LED1 ;ACENDE O LED1
CALL	DELAY_1s
BCF	 LED1	 ;APAGA O LED1 

BSF	 LED3 ;ACENDE O LED3
CALL	DELAY_1s
BCF	 LED3	 ;APAGA O LED3 

BSF	 LED5 ;ACENDE O LED5
CALL	DELAY_1s
BCF	 LED5	 ;APAGA O LED5 

BSF	 LED7 ;ACENDE O LED7
CALL	DELAY_1s
BCF	 LED7	 ;APAGA O LED7 

GOTO BT1	 ;RETORNA AO LOOP MAIN

BOTAO3_OFF
BCF	 LED1	 ;APAGA O LED1 
BCF	 LED2	 ;APAGA O LED2
BCF	 LED3	 ;APAGA O LED3 
BCF	 LED4	 ;APAGA O LED4 
BCF	 LED5	 ;APAGA O LED5 
BCF	 LED6	 ;APAGA O LED6 
BCF	 LED7	 ;APAGA O LED7 
BCF	 LED8	 ;APAGA O LED8 

GOTO BT1	 ;RETORNA AO LOOP MAIN


END	 ;OBRIGAT�RIO