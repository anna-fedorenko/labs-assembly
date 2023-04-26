.686                                          ;директива визначення типу мікропроцесора
.model flat, stdcall                          ;задання лінійної моделі пам’яті і згода OC Windows
option casemap:none                           ;відмінність малих та великих букв
include C:\masm32\include\windows.inc         ;файл з оголошеннями функцій
include \masm32\macros\macros.asm             ;файл з оголошеннями функцій
include \masm32\include\masm32.inc            ;файл з оголошеннями функцій
include C:\masm32\include\kernel32.inc        ;файл з оголошеннями функцій
include C:\masm32\include\user32.inc          ;файл з оголошеннями функцій
include C:\masm32\include\gdi32.inc           ;файл з оголошеннями функцій
include c:\masm32\include\msvcrt.inc          ;файл з оголошеннями функцій
include C:\masm32\include\fpu.inc             ;файл з оголошеннями функцій
includelib C:\masm32\lib\kernel32.lib         ;підключення бібліотеки kernel32         
includelib C:\masm32\lib\user32.lib           ;підключення бібліотеки user32
includelib C:\masm32\lib\gdi32.lib            ;підключення бібліотеки gdi32
includelib C:\masm32\lib\fpu.lib              ;підключення бібліотеки fpu
includelib \masm32\lib\masm32.lib             ;підключення бібліотеки masm32
includelib C:\masm32\lib\msvcrt.lib           ;підключення бібліотеки msvcrt

.data 		                                   ;директива визначення даних                   
	_y dt 0.0                                  ;оголошення змінної _у та присвоєння їй значення 0.0
	_const1 dd 3.0                             ;оголошення константи _const1 та присвоєння їй значення 3
	_const2 dd 5.0                             ;оголошення константи _const2 та присвоєння їй значення 5
	_const3 dd 6.0                             ;оголошення константи _const3та присвоєння їй значення 6
	_temp1 dd ?,0                              ;оголошення тимчасової змінної _temp1
info db "Студентка ІІТЕ КНЕУ, каф. ІСЕ  2023 р.",10,10, 
      "Y="                                     ;задаємо рядок з текстом, який буде виводитись на екран
      _sum db 14 DUP(0),10,13                  ;оголошення масиву для збереження суми _sum
     	ttl db "Лабораторна робота №5",0       ;задаємо рядок з назвою програми 
MsgBoxCaption   db "Вікно повідомлення",0                    ;масив символів, що містить заголовок вікна повідомлення
MsgBoxText_1    db "Знаменник = 0, на нуль ділити не можна",0                           ;масив символів, що містять текст, який буде виводитися у вікні повідомлення про результати порівняння змінних

.const                                         ;початок розділу констант
NULL        equ  0                             ;ім'я константи, яка дорівнює 0
MB_OK       equ  0                             ;директива асемблера, яка встановлює значення константи

.code 		                                   ;директива початку сегмента команд
_start:  		                               ;мітка початку програми з ім’ям _start	
finit                                          ;ініціалізація FPU
main proc                                      ;початок процедури main
LOCAL _n: DWORD                                ;локальна зміннf _n, яка має тип DWORD
LOCAL _j: DWORD                                ;локальна зміннf _j, яка має тип DWORD

mov _n, sval(input("vvedit n = "))             ;інструкції зчитують введені значення для змінної _n  та зберігають їх у пам'яті
mov _j, sval(input("vvedit j = "))             ;інструкції зчитують введені значення для змінної _j  та зберігають їх у пам'яті

mov ecx, _j                      ;заносимо в регістр ecx 4
mov ebx, 0                       ;заносимо в регістр ebx 0

.IF _n == 5 || _n == 6 	 	    ; умова при якій будуть обходитись числа, при яких виникне ділення на ноль
loop m1  		                ;мітка m1
.ENDIF 			                ; кінець умови IF

sum:                            ;мітка sum
    fld _n                      ; завантажуємо значення n в стековий регістр st(0)
    fsub _const2                ; віднімаємо const2 від n і отримуємо n-5 в стековому регістрі st(0)
    fld _n                      ; завантажуємо значення n в стековий регістр st(0)
    fsub _const3                ; віднімаємо const3 від n і отримуємо n-6 в стековому регістрі st(0)
    fmul st(0), st(1)           ; множимо (n-5) на (n-6) і отримуємо (n-5)*(n-6) в стековому регістрі st(0)    fld _n                      ; завантажуємо значення n в стековий регістр st(0)
    fadd _const1                ; додаємо const1 до n і отримуємо n+3 в стековому регістрі st(0)
    fdiv st(0), st(1)           ; ділимо (n+3) на ((n-5)*(n-6)) і отримуємо (n+3)/((n-5)*(n-6)) у стековому регістрі st(2)      
    fstp _temp1                 ; зберігаємо (n+3)/((n-5)*(n-6)) у тимчасовій змінній _temp1 
    add ebx, _temp1             ; додаємо (n+3)/((n-5)*(n-6)) до ebx 
	inc _n                      ;_n=_n+1
loop sum                        ;переходимо до мітки sum
	fstp _y                     ;перенесення значення в змінну _y     
invoke FpuFLtoA, 0, 8, ADDR _sum, SRC1_FPU or SRC2_DIMM               ;конвертування _y у десятковий формат з плаваючою комою та запис його у _sum 
invoke MessageBox, 0, offset info, offset ttl, MB_ICONINFORMATION      ;виклик MessageBox
invoke ExitProcess, 0  	                                               ;завершення процесу	

jmp lexit                                                              ;перейти на мітку lexit 

m1:                                                                     ;мітка m1
invoke MessageBoxA, 0, ADDR MsgBoxText_1, ADDR MsgBoxCaption, MB_OK     ;виклик MessageBox
invoke ExitProcess, 0  	                                                ;завершення процесу	

lexit:                                                              ;мітка lexit
ret                                                                 ;повернення управління ОС
main endp                                                           ;завершення роботи і передача управління наступній інструкції
ret                                                                 ;повернення управління ОС
end _start                                                          ;закінчення програми з ім’ям _start
