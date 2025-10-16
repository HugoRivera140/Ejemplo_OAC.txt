%include "./pc_io.inc"

section .text
    global _start:

_start: 
    MOV AX, 0               ;Se pone 0 en AX y en ESI
    MOV ESI, 0              

    capturar:
        CALL getche         ;Se captura un caracter, se muestra y se guarda en AL
        
        CMP AL, '*'         ;Se compara para ver si el caracter ingresado es el final de cadena
        JE endCapt          ;Se salta a endCapt si fue '*' el carácter ingresado

        PUSH AX             ;Se hace PUSH a AX para ir ingresando el carácter
        INC ESI             ;Se incrementa ESI que llevará la cantidad de carácteres
        JMP capturar        ;Se regresa a capturar para la siguiente posición del carácter

        endCapt: 
            CALL salto

    MOV CX, SI              ;Lo que hay en SI(ultima posición) se pone en CX para ir iterando
    imprimir:
        POP AX              ;Saca lo ultimo ingresado y lo guarda en AX
        CALL putchar        ;Se imprime lo que hay en AL (último carácter sacado)
    loop imprimir           ;Se repite para ir sacando todos los carácteres que se ingresaron

    CALL salto

;====================================
    MOV AX, 0                       ;Se pone AX en 0 otra vez
    MOV ESI, 0                      ;Se pone ESI en 0 otra vez

    MOV EBX, cadenaB                ;Se pone el inicio de dirección de la cadenaB en EBX
    MOV byte[EBX], '0'              ;Pongo un '0' en el contenido de EBX (direccion de inicio de cadenaB)

    capturarB:
        CALL getche                 ;Se captura un carácter y se guarda en AL
        
        CMP AL, '*'                 ;Se compara AL para ver si el carácter ingresado es el final de cadena ('*')
        JE endCaptB                 ;Si se ingresó el carácter salta al fin de captura binaria

        MOV [EBX+ESI], AL           ;Lo que haya en AL se mueve a la dirección [EBX+ESI] el cual es la posición actual de la cadena binaria
        INC ESI                     ;Se incrementa ESI para la siguiente posición
        JMP capturarB               ;Salta de regreso a capturar binaria

        endCaptB:
            MOV byte[EBX+ESI], '%'  ;Se agrega '%' en la posición después de lo último ingresado
            CALL salto

    CALL getche                     ;Se captura un carácter y se guarda en AL
    SUB AL, '0'                     ;Se resta '0' para que sea su valor decimal y no ascii
    CALL salto
    CALL salto

    MOV CL, AL                      ;Se pone lo que hay en AL (número de corrimientos) en CL para usar el loop siguiente


    MOV AX, 0                       ;Se pone AX en 0
    MOV EBX, cadenaB                ;Se pone la dirección de cadena binaria en EBX
    
    corrimientos:

        MOV AL, [EBX+2]             ;Lo que hay en la posición 2 de la cadena binaria se guarda en AL
        MOV byte[EBX+3], AL         ;Lo que hay en AL se pone en la posición 3 de la cadena binaria

        MOV AL, [EBX+1]             ;Lo que hay en la posición 1 de la cadena binaria se guarda en AL
        MOV byte[EBX+2], AL         ;Lo que hay en AL se pone en la posición 2 de la cadena binaria

        MOV AL, [EBX+0]             ;Lo que hay en la posición 0 de la cadena binaria se guarda en AL
        MOV byte[EBX+1], AL         ;Lo que hay en AL se pone en la posición 1 de la cadena binaria

        MOV byte[EBX+0], '0'        ;En la posición 0 de la cadena binaria se coloca un 0

        loop corrimientos           ;Se hace el loop la cantidad de corrimientos que haya ingresado el usuario


    MOV EDX, cadenaB                ;Se coloca la dirección de la cadena binaria en EDX
    CALL newputs                    ;Se pone en EDX lo que se quiera imprimir y que termine en '%'
    CALL salto


    MOV ESI, 3                      ;En ESI se coloca el 3 que es la última posición de la cadena binaria
    MOV EDI, 0                      ;Se pone EDI en 0
    MOV EAX, conversionB            ;En EAX Se coloca la dirección donde se va a guardar la conversión binaria
    MOV byte[EAX], '0'              ;Se le coloca un 0 en el contenido de EAX (dirección base de conversión binaria)

    MOV EDX, tabla                  ;En EDX se coloca la dirección de la tabla de números binarios
    MOV CX, 4                       ;En CX se coloca un 4 ya que son 4 posiciones las que se deben revisar

    conversion:
        MOV EBX, cadenaB            ;Se pone en EBX la dirección de cadena binaria en cada iteración de la conversión
        CMP byte[EBX+ESI], '1'      ;Se compara la posición ESI de la cadena binaria para ver si el carácter es un '1'
        JE sumar                    ;Si fue 1 salta para sumar dependiendo de la posición de ese 1

        seguirC:
            INC EDI                 ;Se incrementa EDI (posición de la tabla a revisar)
            DEC ESI                 ;Se decrementa ESI (posición de la cadena binaria hacia atrás)
            LOOP conversion         ;Se hace 4 veces el ciclo para cada una de las 4 posiciones de la cadena binaria

            JMP fin                 ;Al terminar el ciclo salta al fin de la subrutina

        sumar:                      ;Cuando el carácter revisado sea uno 
            MOV EBX, [EDX+EDI]      ;En EBX se coloca lo que haya en [EDX+EDI] (valor de la tabla)  
            ADD [EAX], EBX          ;Se le suma a EAX (conversion binaria) lo que haya en EBX (valor de la tabla)
            JMP seguirC             ;Salta para seguir la conversión 

    fin:
        MOV EDX, conversionB        ;Al llegar al fin se pasa el valor que se fue sumando a EDX
        MOV byte[EDX+1], '%'        ;Se le añade el carácter '%' para indicar final 
        CALL newputs                ;Se llama a newputs e imprime el valor binario ya convertido
        CALL salto


;====================================

    MOV EAX, 1
    MOV EBX, 0
    int 80h

;========================================================================

;EDX pasar direccion base que termine en '%'
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
