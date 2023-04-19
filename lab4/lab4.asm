.686                                                            ;директива визначення типу мікропроцесора
.model flat, stdcall                                            ;задання лінійної моделі пам’яті і згода OC Windows
option casemap:none                                             ;відмінність малих та великих букв
include C:\masm32\include\windows.inc                           ;файл з оголошеннями функцій
include \masm32\macros\macros.asm                               ;файл з оголошенням macros
include C:\masm32\include\kernel32.inc                          ;файл з оголошеннями функцій
include \masm32\include\masm32.inc                              ;файл з оголошенням masm.inc
include \masm32\include\gdi32.inc                               ;файл з оголошенням gdi32.inc
include C:\masm32\include\user32.inc                            ;файл з оголошеннями функцій
include C:\masm32\include\fpu.inc                               ;файл з оголошеннями функцій
include c:\masm32\include\msvcrt.inc                            ;connecting the msvcrt.inc program file
includelib c:\masm32\lib\msvcrt.lib                             ;підключення бібліотеки msvcrt
includelib \masm32\lib\masm32.lib                               ;підключення бібліотеки masm32
includelib \masm32\lib\gdi32.lib                                ;підключення бібліотеки gdi32
includelib C:\masm32\lib\kernel32.lib                           ;підключення бібліотеки kernel32
includelib C:\masm32\lib\user32.lib                             ;підключення бібліотеки user32
includelib C:\masm32\lib\fpu.lib                                ;підключення бібліотеки fpu

.data                                                           ;директива визначення даних
	_const1 DWORD 0.3                                           ;оголошення константи _const1 та присвоєння їй значення 0.3
	_const2 DWORD 0.11                                          ;оголошення константи _const2 та присвоєння їй значення 0.11
	op1 DWORD -2.0                                              ;оголошення ор1 та присвоєння їй значення -2.0
	op2 DWORD 2.0                                               ;оголошення ор2 та присвоєння їй значення 2.0
	_title db "Лабораторна робота №2. операції порівнняння",0   ;задаємо рядок з назвою програми
	strbuf dw ?,0                                               ;резервуємо місце в пам'яті для буфера рядків
	_text db "masm32. Вивід результата через MessageBox:", 10,
		"x=y+arctgy y<=-2.0", 10,
		"x=arcSin(0.3y+0.11) -2.0<=y<=2.0", 10,
		"x=ln(y+sqrt(y)) 2.0<y", 10,
		"Результат: "                                           ;задаємо рядок з текстом, який буде виводитись на екран
	_res db 10 DUP(0),10,13                                     ;оголошення масиву для збереження результату _res
	MsgBoxCaption db "Результат порівняння:",0                  ;масив символів, що містить заголовок вікна повідомлення
	MsgBoxText_1 db "y<=-2.0",0                                 ;масив символів, що містять текст, який буде виводитися у вікні повідомлення про результати порівняння змінних 
	MsgBoxText_2 db "-2.0<=y<=2.0", 0                           ;масив символів, що містять текст, який буде виводитися у вікні повідомлення про результати порівняння змінних
	MsgBoxText_3 db "2.0<y", 0                                  ;масив символів, що містять текст, який буде виводитися у вікні повідомлення про результати порівняння змінних
.const                                                          ;початок розділу констант
	NULL equ 0                                                  ;ім'я константи, яка дорівнює 0
	MB_OK equ 0                                                 ;директива асемблера, яка встановлює значення константи

.code                                                           ;директива початку сегмента команд
_start:	                                                        ;мітка початку програми з ім’ям _start	
	
	main proc                                                   ;початок процедури main
	LOCAL _y: DWORD                                             ;локальна зміннf _y, яка має тип DWORD
	mov _y, sval(input("Vvedit y: "))                           ;інструкції зчитують введені значення для змінної _e  та зберігають їх у пам'яті

	finit   				 									;ініціалізація FPU
	fild _y                                                     ;_y (st(0))
	fstp _y                                            			;перенесення значення з вершини стеку FPU у змінну _y
	fld op1                                                     ;op1 (st(0)) --> op1 (st(1))
	fld _y                                                      ;_y (st(0))
	fcompp                                                      ;порівнюємо _y та op1 
	fstsw ax                                                    ;зберігаємо слово стану в регістр ах
	sahf                                                        ;завантажуємо прапорці стану з АН
	jbe m1                                                      ;перейти на мітку m1 , якщо нижче або дорівнює (_y<=-2)
	fld op2                                                     ;op2 (st(0)) --> op2 (st(1))
	fld _y                                                      ;_y (st(0))
	fcompp                                                      ;порівнюємо _y та op2
	fstsw ax                                                    ;зберігаємо слово стану в регістр ах
	sahf                                                        ;завантажуємо прапорці стану з АН
	ja m2                                                       ;перейти на мітку m2 , якщо вище (_y>2.0)
		;-3.0<=x<=4.0
		;x=arcSin(0.3y+0.11)
		fld _y                                                 ;_y (st(0))
		fmul _const1                                           ;0.3*_y (st(0))
		fadd _const2                                           ; 0.3*_y + 0.11 (st(0))
		fst st(0)                                              ;зберігаємо результат в st(0)
		fld st(0)                                              ;дублюємо результат
		fmul                                                   ;(0.3*_y+0.11)**2
		fld st(0)                                              ;дублюємо результат 
		fld1                                                   ;1-(0.3*_y+0.11)**2.
		fsubr                                                  ;віднімання 
		fdiv                                                   ;(0.3*_y+0.11)**2/(1-(0.3*_y+0.11)**2).
		fsqrt                                                  ;sqrt((0.3*_y+0.11)**2/(1-(0.3*_y+0.11)**2)).
		fld1                                                   ;обчислюємо
		fpatan                                                 ;повний арктангенс
		invoke MessageBoxA, NULL, ADDR MsgBoxText_2, ADDR MsgBoxCaption, MB_OK  ;виклик вікна повідомлення з текстом
		invoke FpuFLtoA, 0, 10, ADDR _res, SRC1_FPU or SRC2_DIMM                ;конвертування результату у десятковий формат з плаваючою комою та запис його у _res  
		invoke MessageBox, 0, offset _text, offset _title, MB_ICONINFORMATION   ;виклик MessageBox
		invoke ExitProcess, 0                                                   ;завершення процесу	
		jmp lexit                                                               ;перехід на мітку lexit
	
	m1:                                                        ;мітка m1
		;y<=-2.0
		;x=y+arctgy
		fld _y                   ;змінна _y в st(0)
		fld1	                 ;завантаження 1 в стек FPU
		fptan                    ;arctg_y
		fadd st(0), st(1)        ;додавання arctg(y) до y
		fstp st(2)               ;перенесення значення з вершини стеку FPU в st(2)
		fld _y                   ;переносимо значення _y в st(0)
		fadd                     ;arctg_y + _y, результат в st(0)
		invoke MessageBoxA, NULL, ADDR MsgBoxText_1, ADDR MsgBoxCaption, MB_OK  ;виклик вікна повідомлення з текстом
		invoke FpuFLtoA, 0, 10, ADDR _res, SRC1_FPU or SRC2_DIMM                ;конвертування результату у десятковий формат з плаваючою комою та запис його у _res
		invoke MessageBox, 0, offset _text, offset _title, MB_ICONINFORMATION   ;виклик MessageBox
		invoke ExitProcess, 0                                                   ;завершення процесу	
		jmp lexit                                                               ;перехід на мітку lexit

	m2:                            ;мітка m1
	    ;2.0<y
		;x=ln(y+sqrt(y)) 
		fld _y                     ;змінна _y в st(0) 
		fsqrt                      ;sqrt(_y) в st(0) --> st(1)
		fld _y                     ;_y в st(0)
		fadd                       ;sqrt(_y)+_y в st(0)
		fstp st(2)                 ;sqrt(_y)+_y в st(2)
		fldln2                     ;ln(_y+sqrt_y)
		fld st(2)                  ;дублюємо результат
		fyl2x                      ;обчислюємо логарифм
		invoke MessageBoxA, NULL, ADDR MsgBoxText_3, ADDR MsgBoxCaption, MB_OK  ;виклик вікна повідомлення з текстом
		invoke FpuFLtoA, 0, 10, ADDR _res, SRC1_FPU or SRC2_DIMM                ;конвертування результату у десятковий формат з плаваючою комою та запис його у _res
		invoke MessageBox, 0, offset _text, offset _title, MB_ICONINFORMATION   ;виклик MessageBox
		invoke ExitProcess, 0                                                   ;завершення процесу	
		jmp lexit                                                               ;перехід на мітку lexit

	lexit:                        ;мітка lexit                                             
		ret                       ;повернення управління ОС
		main endp                 ;завершення роботи і передача управління наступній інструкції
		ret                       ;повернення управління ОС
	
end _start                        ;закінчення програми з ім’ям _start