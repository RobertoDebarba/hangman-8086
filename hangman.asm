; Roberto Luiz Debarba <roberto.debarba@gmail.com> 2015
; 8086 Assembly, emu8086

data segment
    welcome_message db "HANGMAN (Jogo da Forca) by Roberto Luiz Debarba!$"
    type_message db "Type a letter: $"
    new_line db 13, 10, "$"
    win_message db "YOU WIN!$"
    lose_message db "YOU LOSE!$" 
      
    word db "roberto$"
    discovered_word db 7 dup("-"), "$"
    word_size db 7  
    lives db 5                   
    hits db 0
    errors db 0

ends

stack segment
    dw   128  dup(?)
ends         

extra segment
    
ends

code segment
start:
    ; set segment registers:
    mov     ax, data
    mov     ds, ax
    mov     ax, extra
    mov     es, ax

    ; add your code here           
main_loop:
    lea     dx, welcome_message
    call    print  
    lea     dx, new_line
    call    print  
    call    print
    lea     dx, discovered_word
    call    print  
    
    lea     dx, new_line
    call    print    
    call    print
    
    call    check
    
    lea     dx, type_message
    call    print
    
    call    read_keyboard   
    call    update
    
    
       
    call    clear_screen     
    loop    main_loop 
          
          
check:                   
    mov     bl, ds:[lives]
    mov     bh, ds:[errors]
    cmp     bl, bh
    je      game_over
    
    mov     bl, ds:[word_size]
    mov     bh, ds:[hits]
    cmp     bl, bh
    je      game_win
    
    ret          
    
    
update:  
    lea     si, word
    lea     di, discovered_word     
    mov     bx, 0
        
    update_loop:
    cmp     ds:[si], "$"
    je      end_word
    
    ; check if letter is already taken
    cmp     ds:[di], al
    je      increment
    
    ; check if letter is on the word    
    cmp     ds:[si], al
    je      equals
                 
    increment:
    inc     si
    inc     di   
    jmp     update_loop    
                 
    equals:
    mov     ds:[di], al
    inc     hits
    mov     bx, 1
    jmp     increment             
    
    end_word:  
    cmp     bx, 1
    je      end_update
    
    inc     errors      
    
    end_update:
    ret


game_over: 
    lea     dx, lose_message
    call    print
    
    jmp     fim


game_win:
    lea     dx, win_message
    call    print
    
    jmp     fim
  
  
clear_screen:   ; get and set video mode
    mov     ah, 0fh
    int     10h   
    
    mov     ah, 0
    int     10h
    
    ret
        
    
read_keyboard:  ; read keyborad and return in al
    mov     ah, 1
    int     21h
    
    ret
    

print:
    mov     ah, 9
    int     21h
    
    ret

    
FIM:
    jmp     fim         
      
code ends

end start
