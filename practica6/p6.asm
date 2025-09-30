%include "./pc_io.inc"

section .text
    global _start:

_start:
    MOV EDX, msg        ;Se pone la dirección de msg en EDX
    CALL newputs        ;Se imprime el mensaje ubicado en EDX (msg)

    MOV EDI, 0          ;Reinicio el valor de EDI
    MOV EBX, cad        ;Se pone la dirección de cad en EBX
    CALL capturar       ;Se llama capturar para poner caracteres en cad
    CALL salto

    MOV EDI, 0          ;Se reinicia EDI
    MOV EBX, cad        ;La dirección de la cadena se coloca en EBX
    CALL convertirM     ;Se llama para convertir a mayúsculas
    
    MOV EDX, cad        ;Se pone la dirección de cad en EBX
    CALL newputs        ;Se llama newputs para imprimir la cadena
    CALL salto


    CALL contarV        ;Se llama a contar vocales donde debe existir una variable 'cad' con una cadena dentro
    MOV byte[EBX], '0'  ;Se pone el valor de 0 en EBX para evitar problemas con lo que haya antes

    MOV EBX, a          ;Se pone en EBX la dirección de a
    MOV AL, [EBX]       ;En AL se pone el contenido de EBX
    CALL putchar        ;Se imprime lo que haya en 'a', lo cual es el número de veces que aparecio
    CALL salto

    MOV EBX, e          ;Se pone en EBX la dirección de a
    MOV AL, [EBX]       ;En AL se pone el contenido de EBX
    CALL putchar        ;Se imprime lo que haya en 'a', lo cual es el número de veces que aparecio
    CALL salto

    MOV EBX, i          ;Se pone en EBX la dirección de a
    MOV AL, [EBX]       ;En AL se pone el contenido de EBX
    CALL putchar        ;Se imprime lo que haya en 'a', lo cual es el número de veces que aparecio
    CALL salto

    MOV EBX, o          ;Se pone en EBX la dirección de a
    MOV AL, [EBX]       ;En AL se pone el contenido de EBX
    CALL putchar        ;Se imprime lo que haya en 'a', lo cual es el número de veces que aparecio
    CALL salto

    MOV EBX, u          ;Se pone en EBX la dirección de a
    MOV AL, [EBX]       ;En AL se pone el contenido de EBX
    CALL putchar        ;Se imprime lo que haya en 'a', lo cual es el número de veces que aparecio
    CALL salto


    MOV EDI, 0          ;Se reinician los valores de EDI y ESI
    MOV ESI, 0
    MOV EBX, cadN       ;En EBX se pone la direccion de la cadena nueva

    ;Este capturar se hace diferente ya que ahora se quiere mantener el valor de EDI para trabajar en la etiqueta invertirC
    capturarN:
        CALL getche             ;Se llama a getche el cual captura un caracter en AL y lo muestra 
        CMP AL, '*'             ;Se compara el caracter puesto para ver si no es el fin de cadena ('*')
        JE salir                ;Si se ingresó '*' salta al fin de la captura

        MOV [EBX+EDI], AL       ;Se ingresa el carácter en la posición actual ([EBX+EDI])
        INC EDI                 ;Se incrementa EDI para modificar la siguiente posición en la siguiente iteración
    JMP capturarN               ;Se regresa al inicio de capturar

    salir: 
        MOV byte[EBX+EDI], '%'  ;Se compara la posición actual del caracter dde cadN para ver si se llegó al final
        CALL salto
        CALL invertirC          ;Se llama a la etiqueta que va a invertir la cadena
        CALL salto

    MOV EAX, 1
    MOV EBX, 0
    int 80h

;======================================


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

;Reiniciar EDI, en EBX donde se quiera capturar
capturar:
    PUSHAD
    capt:
        CALL getche             ;Se llama a getche el cual captura un caracter en AL y lo muestra 
        CMP AL, '*'             ;Se compara el caracter puesto para ver si no es el fin de cadena ('*')
        JE finCapt              ;Si se ingresó '*' salta al fin de la captura

        MOV [EBX+EDI], AL       ;Se ingresa el carácter en la posición actual ([EBX+EDI])
        INC EDI                 ;Se incrementa EDI para modificar la siguiente posición en la siguiente iteración
        JMP capt                ;Se regresa al inicio de capturar
    finCapt:
        MOV byte[EBX+EDI], '%'  ;Se agrega el simbolo '%' para comprobar el final de la cadena despues
        POPAD
        RET                     ;Se regresa a cuando se llamó la etiqueta

salto:
  pushad
  mov al,13
  call putchar
  mov al,10
  call putchar
  popad
  ret

;EBX dirección de cadena a convertir
convertirM:
    PUSHAD
    convM:
        MOV AL, [EBX+EDI]       ;Se mueve el contenido de [EBX+EDI] que es la posición actual de la cadena
        CMP AL, '%'             ;Se compara con '%' para ver si se llegó al final de la cadena 
        JE finConv              ;Salta al fin de la conversión

        SUB byte[EBX+EDI], 32   ;Se le resta 32 para convertir el caracter en mayuscula 
        INC EDI                 ;Se incrementa EDI para modificar la siguiente posición
        JMP convM               ;Se regresa al inicio de la conversión
    finConv:
        POPAD
        RET                     ;Se regresa a cuando se llamó la etiqueta

contarV:
    PUSHAD

    ;Se reinician los valores de las variables a utilizar para contar y también el de ESI
    MOV EBX, a
    MOV byte[EBX], '0'
    MOV EBX, e
    MOV byte[EBX], '0'
    MOV EBX, i
    MOV byte[EBX], '0'
    MOV EBX, o
    MOV byte[EBX], '0'
    MOV EBX, u
    MOV byte[EBX], '0'

    MOV ESI, 0
    contV:
        MOV EBX, cad            ;Se mueve la dirección de la cadena a EBX
        MOV AL, [EBX+ESI]       ;a AL se mueve el contenido de EBX

        MOV EBX, a              ;Se mueve la direccion de 'a' a EBX
        CMP AL, 'A'             ;Se compara si lo que hay en AL es igual a 'A'
        JE sumar                ;Salta a la etiqueta de sumar

        MOV EBX, e              ;Se mueve la direccion de 'e' a EBX
        CMP AL, 'E'             ;Se compara si lo que hay en AL es igual a 'E'
        JE sumar                ;Salta a la etiqueta de sumar

        MOV EBX, i              ;Se mueve la direccion de 'i' a EBX
        CMP AL, 'I'             ;Se compara si lo que hay en AL es igual a 'I'
        JE sumar                ;Salta a la etiqueta de sumar

        MOV EBX, o              ;Se mueve la direccion de 'o' a EBX
        CMP AL, 'O'             ;Se compara si lo que hay en AL es igual a 'O'
        JE sumar                ;Salta a la etiqueta de sumar

        MOV EBX, u              ;Se mueve la direccion de 'u' a EBX
        CMP AL, 'U'             ;Se compara si lo que hay en AL es igual a 'U'
        JE sumar                ;Salta a la etiqueta de sumar


        CMP AL, '%'             ;Se compara si se llegó al final de la cadena ('%') para salir 
        JE finContV             ;Se salta a la etiqueta de fin del contador de vocales 

        INC ESI                 ;Si no se encontró ninguna vocal se incrementa ESI y avanza a la siguiente posición
        JMP contV               ;Se regresa al inicio del contador de vocales
    sumar:
        ADD byte[EBX], 1        ;Si se llega a encontrar una vocal (se encuentra en EBX su dirección) se le suma 1
        INC ESI                 ;Se incrementa ESI para ver la siguiente posición
        JMP contV               ;Salta al inicio del contador de vocales
    finContV:
        POPAD
        RET

;=============== Invertir Cadena ===============
invertirC:
    PUSHAD
    DEC EDI                     ;Se decrementa EDI para que apunte a la ultima posición
    MOV ESI, 0                  ;Se reinicia ESI para que apunte a la primera posición

    regreso:
        MOV AL, [EBX+ESI]       ;Mueve el contenido de [EBX+ESI] a AL
        MOV AH, [EBX+EDI]       ;Mueve el contenido de [EBX+EDI] a AH
        
        MOV [EBX+ESI], AH       ;Intercambia lo que habia en la posicion de [EBX+EDI] por la de [EBX+ESI]
        MOV [EBX+EDI], AL       ;Intercambia lo que habia en la posicion de [EBX+ESI] por la de [EBX+EDI]

        CMP ESI, EDI            ;Se compara para ver si se llegó al centro de la cadena
        JE finInv               ;Salta al fin de la inversión si se llegó al final

        INC ESI                 ;Se incrementa ESI para corroborar la siguiente posición
        CMP ESI, EDI            ;Se compara para ver si se llegó al centro de la cadena
        JE finInv               ;Salta al fin de la inversión si se llegó al final

        DEC EDI                 ;Si aún no se llega al centro se decrementa EDI
        JMP regreso             ;Se regresa al inicio de la inversion de cadena

    finInv:
        MOV EDX, cadN           ;Cuando termina de invertir pone la dirección de la cadena nueva en EDX
        CALL newputs            ;Se llama a newputs para imprimir la cadena ya invertida
        CALL salto
        POPAD
        RET                     ;Se regresa a cuando se llamó a la etiqueta


section .data
    msg: db 'Ingresa una palabra en minusculas terminando en *: %',0h

section .bss
    cad resb 256
    cadN resb 256
    temp resb 256

    a resb 2
    e resb 2
    i resb 2
    o resb 2
    u resb 2