;================================================================= 
;     Asignatura: Lenguajes y automatas ll

;     Maestro:    Jose leonel Pech May

;     Nombre:     Geovani Alberto Tuz Poot
;                 Lauro Garcia


;     Actividad:  Calculadora
;=================================================================
include 'emu8086.inc'

;------------------------------

mimacro macro midato;estructura del macro
        mov ah,02h
        mov dl,midato  ;entrada del dato y mover
    
        add dl,40h  ;suma para mostrar numero
        int 21h
endm
;---------------------------

org 100h 
.model medium
.stack 100
.data
     mostrarMenu db '===============.MENU.===============',13,10
                 db '1. Division',13,10
                 db '2. Resta',13,10
                 db '3. Suma',13,10
                 db '4. Multiplicacion',13,10
                 db '5. Salir',13,10,13,10
                 db 'Seleccione una Opcion --> $',13,10
                 
     textodivision db 13,10,"===============.Division.===============$",13,10
     textoresta db 13,10,"===============.Resta.===============$",13,10
     textosuma db 13,10,"===============.Suma.===============$",13,10           
     textomulti db 13,10,"===============.Multiplicacion.===============$",13,10
     textoesc db 13,10," - ESC para regresar$",13,10
    
     msj1    db 13,10,"numero 1: $",13,10
     msj2    db 13,10,"numero 2: $",13,10
     msj     db 13,10,"Resultado: $",13,10
    
     salto db 13,10," "," $"
    
     ;variables de datos
     datosuma db 100 dup(?)
     dato db 100 dup(?)
     var1 db 100 dup(?)
     var2 db 100 dup(?)
     resultado db 100 dup(?)
     cen db 0
     dece db 0
     uni db 0
     div1 db 0
     div2 db 0  
     cociente db 0
     residuo db 0
                 
.code

    Menu:
         mov ah,0
         mov al,3h ;modo texto
         int 10h ; interrupcion de video

         mov ax,0600h 
         mov bh,0fh 
         mov cx,0000h
         mov dx,184Fh
         int 10h
         mov ah,02h
         mov bh,00
         mov dh,00
         mov dl,00
         int 10h
     
         mov ah,09 ; 
         lea dx, mostrarMenu ;nombre del mensaje
         int 21h ;interrupcion de video
 
         mov ah,08 ;pausa y captura de datos 08 espera que el usuario presione una tecla
         int 21h

         cmp al,49 
         je division ; salto condicional jump equals opcion 1 saltar si es igual a la opcion 1
     
         cmp al,50
         je resta
     
         cmp al,51
         je suma
     
         cmp al,52
         je multi
     
         cmp al,53
         je Salir
         
        ;Operacion DIVICION
        division:
                call limpiar
                mov ah,09
                lea dx, textodivision ;nombre del mensaje
                int 21h ;interrupcion de video
                mov ah, 09
                lea dx, msj1
                int 21h
                mov ah, 01
                int 21h
                sub al, 30h
                mov div1,al
    
                ;solicitar del teclado numero 2
    
                mov ah, 09
                lea dx, msj2
                int 21h
                mov ah, 01
                int 21h
                sub al, 30h
                mov div2,al 
    
                mov ah,09h
                lea dx,salto ;desplegar div
                int 21h
                xor ax,ax ;limpiamos el registro ax.
                mov al,div2
                mov bl,al
                mov al,div1
                div bl ; divide AX/BX el resultado lo almacena en AX, el residuo queda en DX
                mov bl,al
                mov dl,bl
                add dl,30h
                mov ah,02h
                int 21h
    
                mov ah,09
                lea dx,textoesc
                int 21h
    
                mov ah,01;pausa y captura de datos
                int 21h
    
                cmp al,27; ascii de ESC
                je Menu
         
          ;OPERACION RESTA
          resta:
                call limpiar
                mov ah,09
                lea dx,textoresta
                int 21h
           
                ;numero 1
    
                mov ah, 09
                lea dx, msj1
                int 21h
                mov ah, 01
                int 21h
                sub al, 30h
                mov var1,al
    
                ;numero 2
    
                mov ah, 09
                lea dx, msj2
                int 21h
                mov ah, 01
                int 21h
                sub al, 30h
                mov var2,al
    
                
                mov al,var1
                sub al,var2
                mov resultado,al
    
                ;mostrando la resta
                mov ah,09
                lea dx,msj
                int 21h
                mov dl,resultado
                add dl,30h 
                mov ah,02
                int 21h
        
                mov ah,09
                lea dx,textoesc
                int 21h
       
                mov ah,01
                int 21h
    
                cmp al,27
                je Menu
    
            ;Operacion SUMA
            suma:
                call limpiar
                mov ah,09
                lea dx,textosuma
                int 21h

                Sumas proc 
                printn " "
                print "numero 1: "
                call scan_num
                mov datosuma[0],cl;en la posicion 0 de la variable se almacena el primer valor
                printn " "
                print "numero 2: "
                call scan_num
                mov datosuma[1],cl;en la posicion 1 de la variable se almacena el primer valor
                printn " "
                xor ax,ax ;suma logica exclusiva
                add al,datosuma[0]
                add al,datosuma[1]
                printn " "
                print "La suma es: "
                call print_num  
                    Sumas endp
                ;datos llamados para la suma
                define_print_string
                define_print_num
                define_print_num_uns
                define_scan_num
      
                mov ah,09
                lea dx,textoesc
                int 21h
    
                mov ah,01
                int 21h
 
                cmp al,27
                je Menu
            
           ;operacion de multiplicacion 
           multi:
                call limpiar
                mov ah,09
                lea dx,textomulti  
                int 21h
    
                lea dx, msj1
                int 21h

                mov ah,01h
                int 21h

                sub al,30h ;restar 30h para obtener el numero
                mov var1,al 

                mov ah,09h
                lea dx, msj2 
                int 21h

                mov ah,01h
                int 21h

                sub al,30h ;restar 30h para obtener segundo valor
                mov var2,al 
   
                mov ah,09
                lea dx,salto
                int 21h

                mov al,var1
                mov bl,var2
                imul bl
                mov bl,10
                div bl
                mov bx,ax
                or bx,3030h
                mov ah,02h
                Mov dl,bl
                Int 21h
                Mov ah,02h
                Mov dl,bh
                int 21h
       
    
                mov ah,09
                lea dx,textoesc
                int 21h
       
                mov ah,01
                int 21h 
        
                cmp al,27
                je Menu
    
         limpiar:
                mov ah,00h
                mov al,03h
                int 10h
                ret    
   
           Salir:
                mov ah,04ch
                int 21h
    
end