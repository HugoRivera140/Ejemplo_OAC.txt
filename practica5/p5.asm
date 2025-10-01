%include "./pc_io.inc"

section .text
    global _start:

_start:
    MOV EDX, msg           ;Se manda el inicio de la cadena a EDX
    CALL puts              ;Se llama a put e imprime la cadena
    CALL salto

    MOV EDI, 0             ;Se reinician los valores de ESI y EDI para  
    MOV ESI, 0             ;trabajar con ellos
    MOV EBX, cad           ;Se pone el inicio de la variable cad en EBX

    capturar:
        CALL getche        ;Se Captura y muestra un caracter, se guarda en AL
        CMP AL, '*'        ;Se compara el valor del caracter introducido y se sale si es '*'
        JE salir

        MOV [EBX+EDI],AL   ;Si es diferente a '*' agrega el caracter a [EBX+EDI] que es la posición de cad
        INC EDI            ;Se incrementa el valor de EDI que sirve como indice para modificar 
    JMP capturar

    ;imprimir cadena capturada
    salir:
        MOV EBX, change    ;Change es una variable temporal para cambios
        MOV byte[EBX],'%'  ;Se agrega el simbolo '%' a EBX 
        MOV AL, [EBX]      ;El valor de EBX se pasa a AL

        MOV EBX, cad       ;Se coloca la dirección de cad en EBX
        MOV [EBX+EDI], AL  ;En la posicion [EBX+EDI] (posicion donde se terminó el ciclo) 
                           ;se coloca lo que hay en AL ('%')

        MOV EDX, cad       ;Se manda la dirección de cad a EDX y se muestra al llamar a puts
        CALL salto
        CALL puts
        CALL salto

        CALL newputs       ;Se llama a newputs (nueva funcion de imprimir)
        CALL salto

    CALL palindromo        ;Se llama la funcion palindromo (en EBX la dirección de la cadena)

    mov eax, 1
    mov ebx, 0
    int 80h



; edx pasar direccion base
newputs:
    pushad
    MOV ESI, 0              ;Se reinicia el valor de ESI
    captPuts:
        MOV AL, [EDX+ESI]   ;En AL se coloca el valor de la cadena en la posición ESI
        CMP al, '%'         ;Se compara para ver si es '%' (final de cadena)
        je end              ;Salta a end si se encontro el simbolo '%'

        INC ESI             ;Si no se encontro se incrementa ESI 
        CALL putchar        ;Se imprime el carácter que se encuentra en la posición actual
    jmp captPuts            ;Regresa al ciclo en la siguiente posición

    end:    
        popad
        ret


palindromo:
    PUSHAD
    DEC EDI                 ;Se le resta uno a EDI (actualmente está en el simbolo agregado)
    MOV ESI, 0              ;Se reinicia ESI ppara usarlo

    regreso:
        MOV AL, [EBX+ESI]   ;El valor de [EBX+ESI] se coloca en AL
        CMP AL, [EBX+EDI]   ;Se compara con el valor de [EBX+EDI] 
        JE next             ;Si los carácteres son iguales sigue siendo palindromo y salta a next

        JMP noPal           ;Si fueron diferentes salta a noPal ya que no fue palindromo


    next:
        CMP ESI, EDI        ;Se comparan ESI y EDI para ver si estan en la misma posición
        JE siPal            ;Cierra el si llegó al final de las comparaciones


        INC ESI             ;Se incrementa ESI para pasar a la siguiente posición
        CMP ESI, EDI        ;Se vuelven a comparar para ver si se llegó al centro de la palabra
        JE siPal            ;Cierra el ciclo si se llegó a la mitad

        DEC EDI             ;Se le resta uno a EDI para que se comparen las siguientes posiciones
        JMP regreso         ;Se regresa al incio del ciclo

    siPal:
        MOV EDX, valido     ;Si fue palindromo se pone la dirección del mensaje 'valido' a EDX
        CALL newputs        ;Se llama a newputs y se imprime la cadena
        CALL salto
        POPAD
        RET                 ;Se regresa a cuando se llamó la etiqueta

    noPal:
        MOV EDX, invalido   ;Si no fue palindromo se pone la dirección del mensaje 'invalido' a EDX
        CALL newputs        ;Se llama a newputs y se imprime la cadena
        CALL salto
        POPAD
        RET                 ;Se regresa a cuando se llamó la etiqueta

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