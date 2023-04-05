.486                                                                ; create 32 bit code
.model flat, stdcall                                                ; 32 bit memory model
option casemap :none                                                ; case sensitive
include \masm32\include\windows.inc                                 ; always first
include \masm32\macros\macros.asm                                   ; MASM support macros
; -----------------------------------------------------------------
; include files that have MASM format prototypes for function calls
; -----------------------------------------------------------------
include \masm32\include\masm32.inc
include \masm32\include\gdi32.inc
include \masm32\include\user32.inc
include \masm32\include\kernel32.inc
include c:\masm32\include\msvcrt.inc
includelib c:\masm32\lib\msvcrt.lib
; ------------------------------------------------
; Library files that have definitions for function
; exports and tested reliable prebuilt code.
; ------------------------------------------------
includelib \masm32\lib\masm32.lib
includelib \masm32\lib\gdi32.lib
includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib

.data	                                                             ; директива визначення даних
_temp1 dd ?,0                                                        ;резервуємо місце в пам'яті для змінної _temp1 (double word)
_temp2 dd ?,0                                                        ;резервуємо місце в пам'яті для змінної _temp2 (double word)
_temp3 dd ?,0                                                        ;резервуємо місце в пам'яті для змінної _temp3 (double word)
_temp4 dd ?,0                                                        ;резервуємо місце в пам'яті для змінної _temp4 (double word)
_const1 dd 3                                                         ;оголошуємо змінну _const1 типу dd, присвоюємо значення 3
_const2 dd 2                                                         ;оголошуємо змінну _const2 типу dd, присвоюємо значення 2
_const3 dd 7                                                         ;оголошуємо змінну _const7 типу dd, присвоюємо значення 7
_title db "Лабораторна робота №2. операції порівнняння",0            ;задаємо рядок з назвою програми
strbuf dw ?,0                                                        ;резервуємо місце в пам'яті для буфера рядків (dw - double word)
_text db "masm32.  Вивід результата через MessageBox:",0ah,
"y=e/3c+ac a<c",0ah,
"y=2a/7-c/7e a>=c",0ah,
"Результат: %d — ціла частина",0ah, 0ah,
"СТУДЕНТКА КНЕУ ІІТЕ",0                                              ;задаємо рядок з текстом, який буде виводитись на екран
MsgBoxCaption   db "Приклад вікна повідомлення",0                    ;масив символів, що містить заголовок вікна повідомлення
MsgBoxText_1     db "порівнняння  _a<_c",0                           ;масив символів, що містять текст, який буде виводитися у вікні повідомлення про результати порівняння змінних
MsgBoxText_2     db "порівнняння  _a>=_c",0                          ;масив символів, що містять текст, який буде виводитися у вікні повідомлення про результати порівняння змінних

.const                                                               ;початок розділу констант
NULL          equ  0                                                 ;ім'я константи, яка дорівнює 0
MB_OK       equ  0                                                   ;директива асемблера, яка встановлює значення константи

.code	                                                            ; директива початку сегмента команд
_start:                                                     	    ; мітка початку програми з ім’ям _start

main proc                                                           ;початок процедури main
LOCAL _e: DWORD                                                     ;локальна зміннf _e, яка має тип DWORD
LOCAL _a: DWORD                                                     ;локальна зміннf _a, яка має тип DWORD
LOCAL _c: DWORD                                                     ;локальна зміннf _c, яка має тип DWORD

mov _e, sval(input("vvedit e = "))                                  ;інструкції зчитують введені значення для змінної _e  та зберігають їх у пам'яті
mov _a, sval(input("vvedit a = "))                                  ;інструкції зчитують введені значення для змінної _a  та зберігають їх у пам'яті
mov _c, sval(input("vvedit c = "))                                  ;інструкції зчитують введені значення для змінної _c  та зберігають їх у пам'яті

mov ebx, _a                                                        ; переносимо _a в регістр ebx
mov eax, _c                                                        ; переносимо _c в регістр eax.
sub ebx, eax                                                       ; порівняння  _a>=_c

jge zero                                                           ;безумовний перехід до мітки "zero"

; zero                                                             ;здійснюємо перехід на мітку zero,якщо прапор SF встановлений. якщо ні, то виконання продовжиться далі
;y= e/3c+ac a<c
mov eax, _const1                                                   ;переносимо значення _const1 в регістр eax
mul _c                                                             ;множимо значення _const1 на значення _с
mov _temp1, eax                                                    ;переносимо eax в змінну _temp1
mov eax, _e                                                        ;переносимо значення _е в регістр eax
div _temp1                                                         ;ділимо eax на _temp1,результат в eax
mov _temp2, eax                                                    ;переносимо eax в _temp2
mov eax, _a                                                        ;переносимо значення _a в eax
mul _c                                                             ;множимо eax на _с
add _temp2, eax                                                    ;_temp2 + eax, результат в eax

INVOKE    MessageBoxA, NULL, ADDR MsgBoxText_1, ADDR MsgBoxCaption, MB_OK
invoke wsprintf, ADDR strbuf, ADDR _text, _temp2, _temp1 
invoke MessageBox, NULL, addr strbuf, addr _title, MB_ICONINFORMATION
invoke ExitProcess, 0

jmp lexit                                                         ;переходимо на мітку exit (GOTO exit)
zero:                                                             ;мітка zero
;2a/7-c/7e a>=c
mov eax, _const2                                                  ;переносимо значення _const2 в регістр eax
mul _a                                                            ;множимо _const2 на значення _а
div _const3                                                       ;ділимо eax на _const3, результат в eax
mov _temp3, eax                                                   ;переносимо eax в _temp3
mov eax, _const3                                                  ;переносимо _const3 в eax
mul _e                                                            ;множимо eax на _е
mov _temp4, eax                                                   ;переносимо eax в _temp4
mov eax, _c                                                       ;переносимо _c в eax
div _temp4                                                        ;Ділимо eax на _temp4, результат в eax  
sub _temp3, eax                                                   ;віднімаємо значення eax від _temp3, результат в _temp3 


INVOKE    MessageBoxA, NULL, ADDR MsgBoxText_2, ADDR MsgBoxCaption, MB_OK   ;виклик вікна повідомлення з текстом
invoke wsprintf, ADDR strbuf, ADDR _text, _temp3, _temp4                    ;форматування рядка за допомогою wsprintf і збереження результату у strbuf
invoke MessageBox, NULL, addr strbuf, addr _title, MB_ICONINFORMATION       ;виклик MessageBox з відформатованим рядком і заголовком _title, та іконкою інформації
invoke ExitProcess, 0                                                       ;завершення процесу

lexit:                                                              ;мітка lexit
ret                                                                 ;повернення управління ОС
main endp                                                           ;завершення роботи і передача управління наступній інструкції
ret                                                                 ;повернення управління ОС
end _start                                                          ;закінчення програми з ім’ям _start
