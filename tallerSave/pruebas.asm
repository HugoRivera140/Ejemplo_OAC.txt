%include "./pc_io.inc"

section .text
    global _start:

_start:
    MOV EAX, num
    CALL printHex
    CALL salto


    MOV EAX, cad
    CALL printHex
    CALL salto

    MOV EAX, cad2
    CALL printHex
    CALL salto


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


;12|34|56|78|9A|BC|DE|F0h
section .data
;    num: db 12h,34h,56h,78h,9Ah,BCh,DEh,F0h



section .bss 
    num resb 8
    cad resb 1
    cad2 resb 7