.686                                                                                   ;встановлюємо набір інструкцій на x86
.model flat, stdcall                                                                   ;встановлюємо модель пам'яті на flat та конвенцію виклику на stdcall
option casemap:none                                                                    ;встановлюємо чутливість до регістру символів на none
include \masm32\include\windows.inc                                                    ;підключаємо файл з оголошеннями функцій та типів Windows API
include \masm32\include\kernel32.inc                                                   ;підключаємо файл з оголошеннями функцій та типів Kernel32 API
include \masm32\include\user32.inc                                                     ;підключаємо файл з оголошеннями функцій та типів User32 API
includelib \masm32\lib\user32.lib                                                      ;підключаємо бібліотеку User32 API
includelib \masm32\lib\kernel32.lib                                                    ;підключаємо бібліотеку Kernel32 API
firstfunc PROTO _e1:DWORD,_const1:DWORD,_b1:DWORD,_const2:DWORD,_a1:DWORD,_c1:DWORD    ;оголошуємо прототип функції firstfunc та її параметри
.data   ; e/8b + 25ac                                                                  ;починаємо оголошення даних
e1 dd 32                                                                               ;оголошуємо змінну e1 типу двійкового слова (double word) та присвоюємо їй значення 32
const1 dd 8                                                                            ;оголошуємо змінну const1 типу dd, присвоюємо значення 8   
b1 dd 4                                                                                ;оголошуємо змінну b1 типу dd, присвоюємо значення 4
const2 dd 25                                                                           ;оголошуємо змінну const2 типу dd, присвоюємо значення 25
a1 dd 1                                                                                ;оголошуємо змінну a1 типу dd, присвоюємо значення 1
c1 dd 2                                                                                ;оголошуємо змінну c1 типу dd, присвоюємо значення 2
_temp1 dd ?,0                                                                          ;резервуємо місце в пам'яті для змінної temp1 (double word)
_temp2 dd ?,0                                                                          ;резервуємо місце в пам'яті для змінної temp2 (double word)
_title db "Лабораторна робота №1. Арифм. операції",0                                   ;задаємо рядок з назвою програми
strbuf dw ?,0                                                                          ;резервуємо місце в пам'яті для буфера рядків (dw - double word)
_text db "masm32. Вивід результата e/8b + 25ac через MessageBox:",0ah,"Результат: %d — ціла частина",0ah, 0ah,
"СТУДЕНТКА КНЕУ ІІТЕ",0                                                                ;задаємо рядок з текстом, який буде виводитись на екран

.code                                                                                  ;починаємо розділ коду
firstfunc proc _e1:DWORD,_const1:DWORD,_b1:DWORD,_const2:DWORD, _a1:DWORD,_c1:DWORD    ;оголошуємо процедуру firstfunc з параметрами e1, const1, b1, const2, a1, c1
mov eax, _const2;                                                                      ;переміщуємо значення const2 в регістр eax
mul _a1                                                                                ;множимо значення a1 на значення у регістрі eax, результат зберігаємо в eax
mul _c1                                                                                ;множимо значення c1 на значення у регістрі eax, результат зберігаємо в eax
mov _temp1, eax                                                                        ;переміщуємо значення, що знаходиться у регістрі eax, у змінну temp1
mov eax, _const1                                                                       ;переміщуємо значення const1 в регістр eax
mul _b1                                                                                 ;множимо значення b1 на значення у регістрі eax, результат зберігаємо в eax
mov _temp2, eax                                                                        ;переміщуємо значення у регістрі eax у змінну temp2
mov eax, e1                                                                            ;переміщуємо значення e1 в регістр eax
div _temp2                                                                             ;ділимо значення у регістрі eax на значення, що знаходиться у змінній temp2, результат ділення зберігається у регістрі eax
add _temp1, eax                                                                        ;додаємо значення, що знаходиться у регістрі eax, до значення, що знаходиться у змінній temp1, результат зберігається у змінній temp1
ret                                                                                    ;повернення управління ОС
firstfunc endp                                                                         ;кінець оголошення процедури firstfunc

start:                                                                                 ;запуск програми
invoke firstfunc, e1,const1,b1,const2,a1,c1                                            ;виклик процедури firstfunc з аргументами e1,const1,b1,const2,a1,c1
invoke wsprintf, ADDR strbuf, ADDR _text, _temp1, _temp2                                          ;форматування рядка за допомогою wsprintf і збереження результату у strbuf
invoke MessageBox, NULL, addr strbuf, addr _title, MB_ICONINFORMATION                  ;виклик MessageBox з відформатованим рядком і заголовком _title, та іконкою інформації
invoke ExitProcess, 0                                                                  ;завершення процесу
END start                                                                              ;кінець програми