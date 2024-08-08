
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h

; add your code here

.data

F db 0 ;flag
num1 db 0
num2 db 0
op db 0
result db 0
msg db 0dh,0ah,"Error"


.code
mov ax,@data
mov ds,ax

;get the operation
LL1:
  call get1 
  cmp ax,0
  je print
  cmp F,0
je LL1  

;get the 2nd number
LL2:
  call get2 
  cmp ax,0
  je print
  cmp F,1
je LL2


;calculate
Solve: 

cmp op,'+'
je addition 

cmp op,'*'
je multiply

cmp op,'%'
je modulus

;subtract
 mov bl, num1 
 sub bl,num2
 mov result,bl
jmp done
 
;addition
addition:    
 mov bl, num1
 add bl,num2
 mov result,bl
jmp done

;multiply
multiply:    
 mov cx,0
 mov cl,num2
 mov si,0
 mov bl,num1 

 mul_loop:
  add result, bl
 loop mul_loop

jmp done

;modulus
modulus:     
  mov si,0
  mov bl,num1
  
  mod_loop:

   cmp bl, num2
   jb mod_done
   sub bl, num2
   jmp mod_loop

 mod_done: 
   mov result,bl
  
jmp done


print:

mov cx,7
mov si,0
screen:
mov dl,msg[si]
mov ah,2
int 21h
inc si
loop screen


done:
   mov dl, result
   add dl, '0'
   mov ah, 2
   int 21h
ret
  

get1 proc ;gets the operation
     
    mov ah,1
    int 21h
        
    cmp al,'+'
    je L4 
    cmp al,'-'
    je L5
    cmp al,'*'
    je L6
    cmp al,'%'
    je L7
    
    sub al,30h
    
    cmp al,0
    jb L2
    cmp al,9
    ja L2
    
    mov cx,10
    mov bh,0
    L3:
    add bh,num1
    loop L3
    add bh,al
    mov num1,bh
    ret 
    
    L4:
    mov op,'+'
    mov F,1
    ret
    L5:
    mov op,'-'
    mov F,1
    ret 
    L6:
    mov op,'*'
    mov F,1
    ret 
    L7:
    mov op,'%'
    mov F,1
    ret   
    
    L2:
    mov ax,0
       
    ret
    endp

get2 proc
     
    mov ah,1
    int 21h
        
    cmp al,'='
    je L41 
    
    
    sub al,30h
    
    cmp al,0
    jb L21
    cmp al,9
    ja L21
    
    mov cx,10
    mov bh,0
    L31:
    add bh,num2
    loop L31
    add bh,al
    mov num2,bh
    ret 
    
    L41:
    mov F,2
    ret
    
    L21:
    mov ax,0
       
    ret
    endp





