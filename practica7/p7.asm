%include "./pc_io.inc"

section .text
    global _start:

_start:
;=====================

    MOV EDX, msg        ;Se pone la dirección de msg en EDX
    CALL newputs        ;Se llama a newputs para imprimir lo que haya en EDX (msg)

;=====================

    MOV EBX, cad        ;Se pone la dirección de cad en EBX
    MOV EDI, 0          ;Se reinicia EDI
    CALL capturar       ;Se llama a capturar para guardar caracteres en la dirección que tenga EBX
    CALL salto

;=====================

    MOV EDX, msg2       ;Se pone la dirección de msg2 en EDX
    CALL newputs        ;Se llama a newputs para imprimir lo que haya en EDX (msg2)

;=====================

    CALL getche         ;Se captura un carácter que será el que se contará en la cadena capturada
    MOV EBX, caracter   ;Se pone la dirección de carácter en EBX
    MOV byte[EBX], AL   ;Lo que haya en AL (carácter capturado) se mueve a lo que haya en EBX (direccion de carácter)

;=====================

    CALL contarC        ;Se llama a contar carácter, donde se ocupa tener la cadena y carácter guardados
    CALL salto

;=====================

    MOV EDX, msg3       ;Se pone la dirección de msg3 en EDX
    CALL newputs        ;Se llama a newputs para imprimir lo que haya en EDX (msg3)

    MOV EBX, contador   ;Se pone la dirección de contador en EBX
    MOV AL, [EBX]       ;Lo que haya en EBX (dirección de contador) se pasa a AL
    MOV EBX, tabla      ;Se pasa la dirección de 'tabla' a EBX
    
    XLAT                ;XLAT usa la dirección de lo que haya en EBX (inicio de tabla) y suma lo que haya 
                        ;en AL (contador de cuantas veces se repitió el carácter) y con eso accede a la dirección
                        ;de lo que haya en el valor de esa suma en la tabla y guarda lo obtenido en AL
    
    CALL putchar        ;Imprime lo que haya en AL (el valor de la tabla dependiendo del conteo de caracteres) 
    CALL salto

;=====================

    CALL convertirB     ;Se llama a convertir binario
    CALL salto

;=====================

    MOV EAX, 1
    MOV EBX, 0
    int 80h

;==========================================================================


;================ Procedimiento para imprimir cadena terminada en '%' ================

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

;================ Procedimiento para capturar ================

;Reiniciar EDI, en EBX donde se quiera capturar
capturar:
    PUSHAD
    capt:
        CALL getche             ;Se llama a getche el cual captura un carácter en AL y lo muestra 
        CMP AL, '*'             ;Se compara el carácter puesto para ver si no es el fin de cadena ('*')
        JE finCapt              ;Si se ingresó '*' salta al fin de la captura

        MOV [EBX+EDI], AL       ;Se ingresa el carácter en la posición actual ([EBX+EDI])
        INC EDI                 ;Se incrementa EDI para modificar la siguiente posición en la siguiente iteración
        JMP capt                ;Se regresa al inicio de capturar
    finCapt:
        MOV byte[EBX+EDI], '%'  ;Se agrega el simbolo '%' para comprobar el final de la cadena despues
        POPAD
        RET                     ;Se regresa a cuando se llamó la etiqueta

;=====================================

salto:
  pushad
  mov al,13
  call putchar
  mov al,10
  call putchar
  popad
  ret

;================ Contar caracteres en una cadena ================

contarC:
    PUSHAD
    MOV ESI, 0
    contC:
        MOV EBX, cad            ;Se mueve la dirección de la cadena a EBX
        MOV AL, [EBX+ESI]       ;a AL se mueve el contenido de EBX+ESI (posiciones de la cadena)

        MOV EBX, caracter       ;Se pone la dirección de carácter en EBX
        CMP AL, [EBX]           ;Se compara si lo que hay en AL es igual al carácter que se busca
        JE sumar                ;Salta a la etiqueta de sumar si fue el carácter

        CMP AL, '%'             ;Se compara si se llegó al final de la cadena ('%') para salir 
        JE finContC             ;Se salta a la etiqueta de fin del contador de carácter 

        INC ESI                 ;Si no se encontró el carácter se incrementa ESI y avanza a la siguiente posición
        JMP contC               ;Se regresa al inicio del contador de carácter
    sumar:
        INC ECX                 ;Si se llega a encontrar el carácter se le suma 1 a ECX
        INC ESI                 ;Se incrementa ESI para ver la siguiente posición
        JMP contC               ;Salta al inicio del contador de carácter
    finContC:
        MOV EBX, contador       ;Al llegar al final se pone la dirección de contador en EBX
        MOV dword[EBX], ECX     ;Lo que haya en ECX (conteo del carácter) se pone en el contenido de EBX (dirección de contador)
        POPAD
        RET

;================ Decimales a binario ================

convertirB:
    PUSHAD
    MOV ECX, 16         ;En ECX se pone un 16 que será las veces que se repetirá el ciclo
    MOV EDX, binario    ;En EDX se pone la dirección de la tabla de binarios
    MOV ESI, 0          ;Se reinician ESI y EDI para evitar usar valores basura
    MOV EDI, 0

    convB:
        CALL newputs2   ;Se llama a newputs2 que está hecho para imprimir la tabla dependiendo
                        ;de la posición que se le mande  
        CALL salto

        INC ESI         ;Se incrementa ESI para imprimir la siguiente posición
        INC EDI         ;Se incrementa EDI que es el desface de la tabla
        LOOP convB      ;Loop para las veces que se repetirá el ciclo
    POPAD
    RET   

;================ newputs para la tabla de binarios ================

;EDX pasar direccion base
;En ESI el indice a mostrar
newputs2:
    PUSHAD
    ADD EDX, EDI            ;Se le añade el desface de la tabla de binarios
    MOV EDI, 0              ;Se reinicia el valor de EDI
    captPuts2:
        ADD EDX, EDI        ;Se le añade al inicio de la tabla EDI que es la posición de lo que se quiere imprimir
        
        MOV AL, [EDX+ESI*4] ;Cálculo que dependiendo de la posición a imprimir se multiplica por 4 para el número
                            ;binario correcto más el desface, con EDI se ve la posición de la cadena binaria
                            ;y cada 4 posiciones hay un '%' para indicar el fin de ese número

        CMP AL, '%'         ;Se compara para ver si es '%' (final de cadena binaria)
        JE end2             ;Salta a end si se encontró el simbolo '%'

        SUB EDX, EDI        ;Se le resta EDI antes de hacer el incremento para evitar que se sumen valores incorrectos
        INC EDI             ;Se incrementa EDI para imprimir la siguiente posición del número binario
        CALL putchar        ;Se imprime el carácter que se encuentra en la posición actual
    JMP captPuts2           ;Regresa al ciclo en la siguiente posición

    end2:    
        POPAD
        RET

;==========================================================================

section .data
    msg: db 'Ingresa una palabra terminando en *: %', 0h
    msg2: db 'Ingresa el caracter a buscar: %', 0h
    msg3: db 'El caracter buscado aparecio estas veces: %', 0h
    tabla: db '0','1','2','3','4','5','6','7','8','9'
    binario: db '0000','%','0001','%','0010','%','0011','%','0100','%','0101','%','0110','%','0111','%','1000','%','1001','%','1010','%','1011','%','1100','%','1101','%','1110','%','1111','%'
    
section .bss
    cad resb 256
    caracter resb 2
    contador resb 2
    temp resb 2
    