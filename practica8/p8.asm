%include "./pc_io.inc"

section .text
    global _start:

_start: 
    MOV AX, 0
    MOV ESI, 0

    capturar:
        CALL getche
        
        CMP AL, '*'
        JE endCapt

        PUSH AX
        INC ESI 
        JMP capturar

        endCapt: 
            CALL salto

    MOV CX, SI
    imprimir:
        POP AX
        CALL putchar
    loop imprimir

    CALL salto

;====================================
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

    MOV CL, AL


    MOV AX, 0
    MOV EBX, cadenaB
    
    corrimientos:

        MOV AL, [EBX+2] 
        MOV byte[EBX+3], AL

        MOV AL, [EBX+1]
        MOV byte[EBX+2], AL

        MOV AL, [EBX+0]
        MOV byte[EBX+1], AL

        MOV byte[EBX+0], '0'

        loop corrimientos


    MOV EDX, cadenaB
    CALL newputs
    CALL salto


    MOV ESI, 3
    MOV EDI, 0
    MOV EAX, conversionB
    MOV byte[EAX], '0'

    MOV EDX, tabla
    MOV CX, 4

    conversion:
        MOV EBX, cadenaB
        CMP byte[EBX+ESI], '1'
        JE sumar

        seguirC:

        INC EDI
        DEC ESI
        LOOP conversion

        JMP fin

        sumar: 
            MOV EBX, [EDX+EDI]
            ADD [EAX], EBX
            JMP seguirC

    fin:
        MOV EDX, conversionB
        MOV byte[EDX+1], '%'
        CALL newputs
        CALL salto


;====================================

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
