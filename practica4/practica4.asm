%include "./pc_io.inc"

section .text
  global _start:

_start:
  mov edx, msg            ;Se mueve la direccion de msg al registro ebx
  call puts               ;Se imprime el mensaje declarado en .data
  call salto

  mov eax, 0
  call getch              ;Se captura un caracter que se almacena en al
  mov ebx, num            ;Se mueve la direccion de num a ebx
  mov [ebx], al           ;El valor de al(char almacenado) se guarda en el contenido de ebx(direccion de num) 
  sub byte[ebx],'0'       ;Se le resta un '0' (48)
  mov esi, cad
  call printHex           ;Se imprime el valor hexadecimal del valor almacenado (ascii)
  call salto

  ;Se imprime el valor ya cambiado en decimal para 
  ;reflejar el cambio realizado
  mov eax, 0
  mov ebx, num
  mov al, [ebx]
  mov esi, cad
  call printHex
  call salto


  mov eax, 0
  call getch              ;Se captura un caracter que se almacena en al
  mov ebx, num2           ;Se mueve la direccion de num2 a ebx
  mov [ebx], al           ;El valor de al(char almacenado) se guarda en el contenido de ebx(direccion de num2) 
  sub byte[ebx], '0'      ;Se le resta un '0' (48)
  mov esi, cad
  call printHex           ;Se imprime el valor hexadecimal del valor almacenado (ascii)
  call salto

  ;Se imprime el valor ya cambiado en decimal para 
  ;reflejar el cambio realizado
  mov eax, 0
  mov ebx, num2
  mov al, [ebx]
  mov esi, cad
  call printHex
  call salto

  ;============== Multiplicacion ==============
  ;Se pone el numero 1 como contador 
  ;para multiplicar(sumas)
  ;cl sirve como cantidad de veces a iterar
  mov ebx, num
  mov cl, [ebx]

  ;Resultado es el valor que debe quedar al final
  mov ebx, res
  mov byte[ebx], 0        ;Se inicializa res en 0 para evitar basura

  ;En "al" actualmente está num2 que se 
  ;suma "num" cantidad de veces
  mult:
      add byte[ebx], al
  loop mult

  ;Se imprime el resultado final
  mov eax, 0
  mov ebx, res
  mov al, [ebx]
  mov esi, cad
  call printHex
  call salto
  call salto

  ;============== Division ==============
  
  mov ebx, num2
  mov byte[ebx], 0        ;se reinicia el valor de num2 a 0

  div:
    ;cantidad de restas totales
    mov ebx, num2
    add byte[ebx], 1      ;Empieza en 0 y va aumentando las veces que se pueda dividir

    ;Se imprime el valor de num2 que son las 
    ;iteraciones actuales
    mov eax, 0
    mov ebx, num2
    mov al, [ebx]
    mov esi, cad
    call printHex
    call salto


    ;Preparar la resta  poniendo la direccion de res(valor que debe llegar a 0) en 
    ;al y la de num a ebx(valor a restar)
    mov ebx, res
    mov al, [ebx]
    mov ebx, num


    ;restar hasta que res llegue a 0
    sub al, byte[ebx]     ;A al(res) se le resta el valor en ebx(num)
    mov ebx, res          ;Se pone la direccion de res en ebx
    mov [ebx], al         ;El valor de al(res restado) se regresa a el valor de ebx
                          ;que es la direccion de res
    
    ;Imprimir resultado despues de la resta
    ;para mejor visualización
    mov eax, 0
    mov ebx, res
    mov al, [ebx]
    mov esi, cad
    call printHex
    call salto

    ;Se compara si se llegó a 0 y cierra ciclo
    ;saltando a fin que imprime el resultado
    cmp al, 0
    je fin
  jmp div
  call salto

  fin:
    ;Imprimir el valor de num 2 que son las 
    ;iteraciones finales
    call salto
    mov eax, 0
    mov ebx, num2
    mov al, [ebx]
    mov esi, cad
    call printHex
    call salto

  ;============== 1-100 ==============
  call salto
  call salto

  ;Num se reinicia en 0 poniendo su direccion en ebx y 
  ;cambiar su valor desde ahi
  mov ebx, num
  mov byte[ebx], 0

  ;Se va a repetir 100 veces (cx)
  mov cx, 100
  cien:
    ;Se suma 1 y se imprimen el valor en el
    ;que se encuentra
    add byte[ebx], 1
    mov eax, 0
    mov al, [ebx]
    mov esi, cad
    call printHex
    call salto
  loop cien

  ;============== 1-100(2-2) ==============
  call salto
  call salto

  ;Se reinicia num que sera nuestro valor
  ;actual en el que está la iteracion
  mov ebx, num
  mov byte[ebx], 0

  ;Preparar contador en 0 que cambiará entre 1 y 0
  mov ebx, cont
  mov byte[ebx], 0

  ;Se hace 100 veces (cx)
  mov cx, 100
  cien2:
    ;Num se le suma 1 cada vez que pasa el loop
    mov ebx, num
    add byte[ebx], 1
    
    ;contador se pasa a "al" que compara si el cont se
    ;encuentra en 1 o 0 
    mov ebx, cont
    mov al, [ebx]
    cmp al, 1
    je contador

    ;Si no entra al cambio de valor se le suma uno
    ;y regresa al loop
    add byte[ebx], 1
    loop cien2


contador:
    ;Se le resta 1 para que vuelva a 0
    sub byte[ebx], 1

    ;Se imprime el valor actual de num que es un 
    ;valor de 2 en 2
    mov eax, 0
    mov ebx, num
    mov al, [ebx]
    mov esi, cad
    call printHex
    call salto
    loop cien2

    mov eax, 1
    mov ebx, 0
    int 80h

salto:
  pushad
  mov al,13
  call putchar
  mov al,10
  call putchar
  popad
  ret

;en eax el valor a convertir mostrar en hexadecimal
printHex:
  pushad
  mov edx, eax
  mov ebx, 0fh
  mov cl, 28
.nxt: shr eax,cl
.msk: and eax,ebx
  cmp al, 9
  jbe .menor
  add al,7
.menor:add al,'0'
  mov byte [esi],al
  inc esi
  mov eax, edx
  cmp cl, 0
  je .print
  sub cl, 4
  cmp cl, 0
  ja .nxt
  je .msk
.print: mov eax, 4
  mov ebx, 1
  sub esi, 8
  mov ecx, esi
  mov edx, 8
  int 80h
  popad
  ret

section .data
  msg: db 'Ingresa un digito (0-9)',0h
  ;len: equ $-message

section .bss
  num resb 1
  num2 resb 2
  cad resb 12
  res resb 10
  cont resb 1
