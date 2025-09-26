%include "./pc_io.inc"

section .text
    global _start:

_start:
    MOV EDX, msg
    CALL puts
    CALL salto

    MOV EDI, 0
    MOV ESI, 0
    MOV EBX, cad

    capturar:
        CALL getche
        CMP AL, '*'
        JE salir

        MOV [EBX+EDI], AL
        INC EDI
    JMP capturar

    ;imprimir cadena capturada
    salir:
        MOV EBX, change
        MOV byte[EBX], '%'
        MOV AL, [EBX]

        MOV EBX, cad
        MOV [EBX+EDI], AL
        
        MOV EDX, cad
        CALL salto
        CALL puts
        CALL salto

        CALL newputs
        CALL salto

    CALL palindromo

    mov eax, 1
    mov ebx, 0
    int 80h



; edx pasar direccion base
newputs:
    pushad
    MOV ESI, 0
    captPuts:
        MOV AL, [EDX+ESI]
        CMP al, '%'
        je end

        INC ESI
        CALL putchar
    jmp captPuts

    end:    
        popad
        ret


palindromo:
    PUSHAD
    DEC EDI
    MOV ESI, 0

    regreso:
        MOV AL, [EBX+ESI]
        CMP AL, [EBX+EDI]
        JE next

        JMP noPal


    next:
        CMP ESI, EDI
        JE siPal


        INC ESI
        CMP ESI, EDI
        JE siPal

        DEC EDI
        JMP regreso

    siPal:
        MOV EDX, valido
        CALL newputs
        CALL salto
        POPAD
        RET

    noPal:
        MOV EDX, invalido
        CALL newputs
        CALL salto
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
    msg: db 'Cadena terminada en *',0h
    valido: db 'Si fue palindromo%',0h
    invalido: db 'No fue palindromo%', 0h

section .bss
    cad resb 256
    change resb 20