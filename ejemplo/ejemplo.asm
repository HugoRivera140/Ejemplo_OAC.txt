%include "./pc_io.inc"

section .data
  msj: db 'Ingrese un dígito (0-9)',0x0
  ;len: equ $-msj

section .bss
  num1 resb 1
  num2 resb 2

section .text
  global _start:

_start:
  ;mov eax, 4 
  ;mov ebx, 1 
  ;mov ecx, msj 
  ;mov edx, len 
  ;int 80h 

  ;mov eax, 3 
  ;mov ebx, 0 
  ;mov ecx, num1 
  ;mov edx, 1 
  ;int 80h

  ;mov eax, 4 
  ;mov ebx, 1 
  ;mov ecx, num1 
  ;mov edx, 1 
  ;int 80h 

  ;Desplegar mensaje
  mov edx, msj 
  call puts
  call salto

  ;capturar num1
  call getch
  mov ebx, num1
  mov [ebx], al
  sub byte[ebx], '0'
  call salto

  ;imprimir caracter
  call putchar
  call salto

  ;capturar num2
  call getch
  mov ebx, num2
  sub byte[ebx], '0'
  mov [ebx], al
  call salto

  ;imprimir caracter
  call putchar
  call salto

  ;Sumarle 1 al numero
  ;mov ebx, num1 
  ;mov byte[ebx], al 
  ;add byte[ebx], 1 
  ;mov al, byte[ebx] 
  ;call putchar 
  ;call salto



  ;Sumarle num2 a num1
  mov ebx, num1 
  mov al, [ebx] 
  mov ebx, num2 
  add [ebx], al 
  mov al, byte[ebx] 
  add byte[ebx], '0'
  call putchar 
  call salto

  mov eax, 1
  mov ebx, 0
  int 80h


salto: 
  pushad
  mov al, 13 
  call putchar 
  mov al, 10 
  call putchar 
  popad
  ret 
