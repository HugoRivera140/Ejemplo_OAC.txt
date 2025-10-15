%include "./pc_io.inc"

section .text
    global _start:

_start: 
    MOV AX, 0
    MOV ESI, 0

    MOV EBX, cadenaB
    MOV byte[EBX], '0'

    capturarB:
        CALL getche
        
        CMP AL, '*'
        JE endCaptB

        MOV [EBX+ESI], AL
        INC ESI 
        JMP capturarB

        endCaptB:
            MOV byte[EBX+ESI], '%'
            CALL salto

    CALL getche
    SUB AL, '0'
    CALL salto
    CALL salto

;===========================
    MOV EDX, cadenaB
    MOV CL, AL

    pruebaCorrimientos:
        PUSH ESI

        MOV BX, [EDX+ESI]
        CMP BL, '1'
        JE flag

        MOV AH, 0
        SAHF

        mover:
            MOV BL, [EDX+ESI-2]
            MOV [EDX+ESI-1], BL
            DEC ESI
            CMP ESI, 1
            JE finMover
            JMP mover
            CALL newputs
        
        flag:
            MOV AH, 1
            SAHF
            JMP mover
        
        finMover:
            MOV byte[EDX], '0'
            POP ESI
            loop pruebaCorrimientos
    CALL newputs 
    CALL salto       

    MOV EAX, 1
    MOV EBX, 0
    int 80h

;========================================================================

;EDX pasar direccion base
newputs:
    PUSHAD
    MOV ESI, 0              ;Se reinicia el valor de ESI
    captPuts:
        MOV AL, [EDX+ESI]   ;En AL se coloca el valor de la cadena en la posición ESI
        CMP AL, '%'         ;Se compara para ver si es '%' (final de cadena)
        JE end              ;Salta a end si se encontro el simbolo '%'

        INC ESI             ;Si no se encontro se incrementa ESI 
        CALL putchar        ;Se imprime el carácter que se encuentra en la posición actual
    JMP captPuts            ;Regresa al ciclo en la siguiente posición

    end:    
        POPAD
        RET

salto:
  pushad
  mov al,13
  call putchar
  mov al,10
  call putchar
  popad
  ret

section .data
    tabla: db 1,2,4,8,16,32,64
section .bss
    corrimiento resb 20
    cadenaB resb 256
    conversionB resb 20
