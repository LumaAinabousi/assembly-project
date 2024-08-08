
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h

.data
sqr db 219
color db 0Fh

white_c db 0
yellow_c db 0 
lmagneta_c db 0
lred_c db 0 
lcyan_c db 0

max_col db 80
max_row db 25

curr_col db 0
curr_row db 0

whiteMsg db "White: ",0
yellowMsg db "Yellow: ",0
lmagnetaMsg db "Light Magneta: " ,0
lredMsg db "Light Red: ",0
lcyanMsg db "Light Cyan: " ,0

tens_dig db 0
ones_dig db 0
.code
 main PROC
    mov ax,@data
    mov ds,ax
     

    Program:
      CALL printNewBox
      mov al,0
      mov ah, 00h
      int 16h
      
      cmp ah,48h  ;up arrow key
      je arrow_up
    
      cmp ah,50h  ;down arrow key
      je arrow_down
      
      cmp al,13
      je enter
      
      cmp al,32
      je end
      jmp Program
      
      arrow_up:
      CALL changeColorUp
      jmp Program
    
      arrow_down:
      CALL changeColorDown
      jmp Program
    
      enter: ;if u press enter, save ur selection (inc the colors), then modify curser, then print another box
      CALL saveColorSelection
      CALL modifyCursor
      jmp Program
      
    end:
     CALL saveColorSelection
       
     mov dl, 0Ah ;newline
     mov ah, 02h
     int 21h
        
     mov dl, 0Dh ;cr
     mov ah, 02h
     int 21h
     
     CALL printResults
     
     
    mov ah, 00h
    int 16h 
  ret
 main ENDP
 


;printing boxes
 printNewBox PROC
    
    
    mov al,sqr
    mov ah,09h
    mov bh,0
    mov bl,color
    mov cx,1
    int 10h
    

  ret  
 printNewBox ENDP


;changing the color to the next color
 changeColorUp PROC
    dec color
    cmp color, 0Ah
    jne noResetUp
    mov color, 0Fh ;reset to white once the color is light green (out of range)

    noResetUp: 
  ret
 changeColorUp ENDP


;changing the color to the prev color
 changeColorDown PROC
    inc color
    cmp color, 10h
    jne noResetDown
    mov color,0Bh  ;reset to light cyan once the color is out of my range

    noResetDown: 
  ret
 changeColorDown ENDP
 

;modify the cursor (to print a new box)
 modifyCursor PROC
    inc curr_col
    mov cl, curr_col
    cmp cl,max_col
    jl no_newline ;no need for a new line
    
    inc curr_row ;go to a new line
    mov curr_col,0 ;reset the cols
    
    no_newline:
    mov ah, 02h
    mov bh, 0
    mov dh, curr_row
    mov dl, curr_col
    int 10h
    
    mov color,0Fh ;reset to white   
  ret
 modifyCursor ENDP    
 

;modify the color counter based on the selection of the user
 saveColorSelection PROC
    cmp color, 0Fh
    je is_white
    
    cmp color, 0Eh
    je is_yellow
    
    cmp color, 0Dh
    je is_lmagneta
    
    cmp color, 0Ch 
    je is_lred
    
    is_lcyan:
    inc lcyan_c
    ret
    
    is_white:
    inc white_c
    ret
    
    is_yellow:
    inc yellow_c
    ret
    
    is_lmagneta:
    inc lmagneta_c
    ret
    
    is_lred:
    inc lred_c
    ret
      
  ret
 saveColorSelection ENDP  


;printing the results :)
 printResults PROC
    ;white results
     mov si, offset whiteMsg
     CALL printString
     mov ah,0
     mov al,white_c
     CALL printNumber
   
     mov dl, 0Ah ;newline
     mov ah, 02h
     int 21h
    
     mov dl, 0Dh ;cr
     mov ah, 02h
     int 21h
    
    ;yellow results
     mov si, offset yellowMsg
     CALL printString
     mov ah,0
     mov al,yellow_c
     CALL printNumber

     mov dl, 0Ah ;newline
     mov ah, 02h
     int 21h
        
     mov dl, 0Dh ;cr
     mov ah, 02h
     int 21h
    
    ;light magneta results 
     mov si, offset lmagnetaMsg
     CALL printString
     mov ah,0
     mov al,lmagneta_c
     CALL printNumber 
    
     mov dl, 0Ah ;newline
     mov ah, 02h
     int 21h
        
     mov dl, 0Dh ;cr
     mov ah, 02h
     int 21h
    
    ;light red results
     mov si, offset lredMsg
     CALL printString
     mov ah,0
     mov al,lred_c
     CALL printNumber 
   
     mov dl, 0Ah ;newline
     mov ah, 02h
     int 21h
       
     mov dl, 0Dh ;cr
     mov ah, 02h
     int 21h
     
    ;light cyan results
     mov si, offset lcyanMsg
     CALL printString
     mov ah,0
     mov al,lcyan_c
     CALL printNumber 
   
  ret
 printResults ENDP


;printing the messages (whiteMsg,yellowMsg,etc...)
 printString PROC
    mov dl,[si]
    mov ah, 02h
    L1:
      int 21h
      cmp dl, 0 
      je end_print
      inc si
      mov dl, [si] 
    jmp L1

    end_print:
  ret
 printString ENDP

;printing the number of boxes (assuming they are at most 2 digits numbers) 
;NOTE: the number is loaded to al before printing
 printNumber PROC
    
    mov bl, 10 ;dividor to get the tens digit
    div bl ;al is the tens digit , ah is the remainder

    mov tens_dig, al
    mov ones_dig, ah

    add tens_dig, '0'
    add ones_dig, '0'

    mov dl, tens_dig
    mov ah, 02h
    int 21h

    mov dl,ones_dig
    int 21h

    
  ret
 printNumber ENDP    