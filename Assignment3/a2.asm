org 100h
jmp start

titlemsg db ' FAST TEXT VIEWPORT '
line1 db 'FAST University Lahore',0
line2 db 'Welcome to the COAL assignment',0
line3 db 'FAST students learn assembly',0
line4 db 'This program uses video memory',0
line5 db 'The FAST viewport is active',0
line6 db 'Scrolling moves text upward',0
line7 db 'FAST provides computing education',0
line8 db 'String instructions are useful',0
line9 db 'We are learning 8086 assembly',0
line10 db 'FAST keyword highlighting works',0
line11 db 'The window has fixed borders',0
line12 db 'This is a sample document',0
line13 db 'FAST appears multiple times',0
line14 db 'Stack frames use BP register',0
line15 db 'MOVSW moves screen characters',0
line16 db 'CMPSB compares string bytes',0
lines dw line1,line2,line3,line4,line5,line6,line7,line8
      dw line9,line10,line11,line12,line13,line14,line15,line16
keyword db 'FAST'
statusmsg db 'Total Matches Found: ',0
activemsg db ' | Viewport Status: ACTIVE',0
matchcount dw 0
scrollcount dw 0
scratch times 61 db 0

start:
    push cs
    pop ds
    mov ax,0b800h
    mov es,ax
    call clearscreen
    mov ax,3
    push ax
    mov ax,8
    push ax
    mov ax,21
    push ax
    mov ax,72
    push ax
    call draw_window
    call drawtitle
    call displaytext
    call refreshscreen
keyboardloop:
    mov ah,0
    int 16h
    cmp al,27
    je exitprogram
    cmp al,'s'
    je scrollagain
    cmp al,'S'
    jne keyboardloop
scrollagain:
    cmp word [scrollcount],16
    jae keyboardloop
    call doscroll
    call refreshscreen
    jmp keyboardloop
exitprogram:
    mov ax,4c00h
    int 21h

doscroll:
    push bp
    mov bp,sp
    push ax
    mov ax,4
    push ax
    mov ax,10
    push ax
    mov ax,20
    push ax
    mov ax,70
    push ax
    mov ax,2
    push ax
    call scroll_window_up
    add word [scrollcount],2
    pop ax
    pop bp
    ret

clearscreen:
    push bp
    mov bp,sp
    push ax
    push cx
    push di
    xor di,di
    mov ax,0720h
    mov cx,2000
    cld
    rep stosw
    pop di
    pop cx
    pop ax
    pop bp
    ret

draw_window:
    push bp
    mov bp,sp
    sub sp,2
    push ax
    push bx
    push cx
    push di
    mov ax,[bp+10]
    mov bx,160
    mul bx
    mov bx,[bp+8]
    shl bx,1
    add ax,bx
    mov di,ax
    mov ax,1ec9h
    cld
    stosw
    mov cx,[bp+4]
    sub cx,[bp+8]
    dec cx
    mov ax,1ecdh
    rep stosw
    mov ax,1ebbh
    stosw
    mov ax,[bp+10]
    inc ax
    mov [bp-2],ax
drawsides:
    mov ax,[bp-2]
    cmp ax,[bp+6]
    jge drawbottom
    mov bx,160
    mul bx
    mov bx,[bp+8]
    shl bx,1
    add ax,bx
    mov di,ax
    mov ax,1ebah
    mov [es:di],ax
    mov ax,[bp-2]
    mov bx,160
    mul bx
    mov bx,[bp+4]
    shl bx,1
    add ax,bx
    mov di,ax
    mov ax,1ebah
    mov [es:di],ax
    inc word [bp-2]
    jmp drawsides
drawbottom:
    mov ax,[bp+6]
    mov bx,160
    mul bx
    mov bx,[bp+8]
    shl bx,1
    add ax,bx
    mov di,ax
    mov ax,1ec8h
    cld
    stosw
    mov cx,[bp+4]
    sub cx,[bp+8]
    dec cx
    mov ax,1ecdh
    rep stosw
    mov ax,1ebch
    stosw
    pop di
    pop cx
    pop bx
    pop ax
    mov sp,bp
    pop bp
    ret 8

drawtitle:
    push bp
    mov bp,sp
    push ax
    push cx
    push si
    push di
    mov si,titlemsg
    mov di,540
    mov cx,20
    mov ah,1eh
    cld
titleloop:
    lodsb
    stosw
    loop titleloop
    pop di
    pop si
    pop cx
    pop ax
    pop bp
    ret

displaytext:
    push bp
    mov bp,sp
    sub sp,4
    push ax
    push bx
    push cx
    push si
    push di
    mov word [bp-2],0
    mov word [bp-4],4
nextline:
    cmp word [bp-2],16
    jge displaydone
    mov bx,[bp-2]
    shl bx,1
    mov si,[lines+bx]
    mov ax,[bp-4]
    mov bx,160
    mul bx
    add ax,20
    mov di,ax
    mov cx,61
    mov ah,07h
    cld
printline:
    lodsb
    cmp al,0
    je linecomplete
    stosw
    loop printline
linecomplete:
    inc word [bp-2]
    inc word [bp-4]
    jmp nextline
displaydone:
    pop di
    pop si
    pop cx
    pop bx
    pop ax
    mov sp,bp
    pop bp
    ret

; Parameters: top, left, bottom, right, number_of_lines
scroll_window_up:
    push bp
    mov bp,sp
    sub sp,4
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    push ds
    push es
    mov ax,0b800h
    mov ds,ax
    mov es,ax
    mov ax,[bp+12]
    mov [bp-2],ax
scrollnext:
    mov ax,[bp-2]
    add ax,[bp+4]
    cmp ax,[bp+8]
    jg clearbottom
    mov bx,160
    mul bx
    mov bx,[bp+10]
    shl bx,1
    add ax,bx
    mov si,ax
    mov ax,[bp-2]
    mov bx,160
    mul bx
    mov bx,[bp+10]
    shl bx,1
    add ax,bx
    mov di,ax
    mov cx,[bp+6]
    sub cx,[bp+10]
    inc cx
    cld
    rep movsw
    inc word [bp-2]
    jmp scrollnext
clearbottom:
    mov ax,[bp+8]
    sub ax,[bp+4]
    inc ax
    mov [bp-4],ax
clearnext:
    mov ax,[bp-4]
    cmp ax,[bp+8]
    jg scrollfinished
    mov bx,160
    mul bx
    mov bx,[bp+10]
    shl bx,1
    add ax,bx
    mov di,ax
    mov cx,[bp+6]
    sub cx,[bp+10]
    inc cx
    mov ax,0720h
    cld
    rep stosw
    inc word [bp-4]
    jmp clearnext
scrollfinished:
    pop es
    pop ds
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    mov sp,bp
    pop bp
    ret 10

refreshscreen:
    push bp
    mov bp,sp
    push ax
    call resetattributes
    mov ax,keyword
    push ax
    mov ax,4
    push ax
    mov ax,0ceh
    push ax
    mov ax,4
    push ax
    mov ax,10
    push ax
    mov ax,20
    push ax
    mov ax,70
    push ax
    call find_and_highlight
    call statusbar
    pop ax
    pop bp
    ret

resetattributes:
    push bp
    mov bp,sp
    sub sp,2
    push ax
    push bx
    push cx
    push di
    mov word [bp-2],4
resetrow:
    cmp word [bp-2],20
    jg resetdone
    mov ax,[bp-2]
    mov bx,160
    mul bx
    add ax,21
    mov di,ax
    mov cx,61
resetcolumn:
    mov byte [es:di],07h
    add di,2
    loop resetcolumn
    inc word [bp-2]
    jmp resetrow
resetdone:
    pop di
    pop cx
    pop bx
    pop ax
    mov sp,bp
    pop bp
    ret

; Parameters: keyword_offset, keyword_length, attribute, top, left, bottom, right
find_and_highlight:
    push bp
    mov bp,sp
    sub sp,8
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    push ds
    push es
    mov word [matchcount],0
    mov ax,[bp+4]
    sub ax,[bp+8]
    inc ax
    mov [bp-8],ax
    cmp ax,61
    ja searchdone
    mov ax,[bp+14]
    cmp ax,0
    je searchdone
    cmp ax,[bp-8]
    ja searchdone
    mov ax,[bp+10]
    mov [bp-2],ax
searchrow:
    mov ax,[bp-2]
    cmp ax,[bp+6]
    jg searchdone
    mov bx,160
    mul bx
    mov bx,[bp+8]
    shl bx,1
    add ax,bx
    mov [bp-6],ax
    mov si,ax
    mov di,scratch
    mov cx,[bp-8]
    push ds
    push es
    push cs
    pop es
    mov ax,0b800h
    mov ds,ax
    cld
copycharacters:
    lodsw
    stosb
    loop copycharacters
    pop es
    pop ds
    mov word [bp-4],0
searchcolumn:
    mov ax,[bp-8]
    sub ax,[bp+14]
    cmp word [bp-4],ax
    jg nextsearchrow
    mov bx,[bp+16]
    mov al,[bx]
    mov di,scratch
    add di,[bp-4]
    push es
    push ds
    pop es
    cld
    scasb
    pop es
    jne nomatch
    mov si,scratch
    add si,[bp-4]
    mov di,[bp+16]
    mov cx,[bp+14]
    push es
    push ds
    pop es
    cld
    repe cmpsb
    pop es
    jne nomatch
    inc word [matchcount]
    mov ax,[bp-4]
    shl ax,1
    add ax,[bp-6]
    mov di,ax
    inc di
    mov cx,[bp+14]
    mov al,byte [bp+12]
highlightloop:
    mov [es:di],al
    add di,2
    loop highlightloop
nomatch:
    inc word [bp-4]
    jmp searchcolumn
nextsearchrow:
    inc word [bp-2]
    jmp searchrow
searchdone:
    pop es
    pop ds
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    mov sp,bp
    pop bp
    ret 14

statusbar:
    push bp
    mov bp,sp
    sub sp,2
    push ax
    push bx
    push cx
    push si
    push di
    mov ax,23
    mov bx,160
    mul bx
    mov di,ax
    mov ax,1f20h
    mov cx,80
    cld
    rep stosw
    mov ax,23
    mov bx,160
    mul bx
    mov di,ax
    mov si,statusmsg
    mov ah,1fh
statusfirst:
    lodsb
    cmp al,0
    je statusnumber
    stosw
    jmp statusfirst
statusnumber:
    mov [bp-2],di
    mov ax,[matchcount]
    push ax
    mov ax,bp
    sub ax,2
    push ax
    call printnum
    mov di,[bp-2]
    mov si,activemsg
    mov ah,1fh
statussecond:
    lodsb
    cmp al,0
    je statusdone
    stosw
    jmp statussecond
statusdone:
    pop di
    pop si
    pop cx
    pop bx
    pop ax
    mov sp,bp
    pop bp
    ret

; Parameters: number, pointer_to_output_offset (in caller's SS)
printnum:
    push bp
    mov bp,sp
    sub sp,2
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    mov ax,[bp+6]
    mov si,[bp+4]
    mov di,[ss:si]
    mov bx,10
    mov word [bp-2],0
    cmp ax,0
    jne dividedigits
    mov ax,1f30h
    stosw
    jmp numberdone
dividedigits:
    xor dx,dx
    div bx
    push dx
    inc word [bp-2]
    cmp ax,0
    jne dividedigits
printdigits:
    pop dx
    add dl,30h
    mov dh,1fh
    mov [es:di],dx
    add di,2
    dec word [bp-2]
    jnz printdigits
numberdone:
    mov [ss:si],di
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    mov sp,bp
    pop bp
    ret 4
