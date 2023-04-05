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

.data	                                                             ; ��������� ���������� �����
_temp1 dd ?,0                                                        ;��������� ���� � ���'�� ��� ����� _temp1 (double word)
_temp2 dd ?,0                                                        ;��������� ���� � ���'�� ��� ����� _temp2 (double word)
_temp3 dd ?,0                                                        ;��������� ���� � ���'�� ��� ����� _temp3 (double word)
_temp4 dd ?,0                                                        ;��������� ���� � ���'�� ��� ����� _temp4 (double word)
_const1 dd 3                                                         ;��������� ����� _const1 ���� dd, ���������� �������� 3
_const2 dd 2                                                         ;��������� ����� _const2 ���� dd, ���������� �������� 2
_const3 dd 7                                                         ;��������� ����� _const7 ���� dd, ���������� �������� 7
_title db "����������� ������ �2. �������� ����������",0            ;������ ����� � ������ ��������
strbuf dw ?,0                                                        ;��������� ���� � ���'�� ��� ������ ����� (dw - double word)
_text db "masm32.  ���� ���������� ����� MessageBox:",0ah,
"y=e/3c+ac a<c",0ah,
"y=2a/7-c/7e a>=c",0ah,
"���������: %d � ���� �������",0ah, 0ah,
"��������� ���� ����",0                                              ;������ ����� � �������, ���� ���� ���������� �� �����
MsgBoxCaption   db "������� ���� �����������",0                    ;����� �������, �� ������ ��������� ���� �����������
MsgBoxText_1     db "����������  _a<_c",0                           ;����� �������, �� ������ �����, ���� ���� ���������� � ��� ����������� ��� ���������� ��������� ������
MsgBoxText_2     db "����������  _a>=_c",0                          ;����� �������, �� ������ �����, ���� ���� ���������� � ��� ����������� ��� ���������� ��������� ������

.const                                                               ;������� ������ ��������
NULL          equ  0                                                 ;��'� ���������, ��� ������� 0
MB_OK       equ  0                                                   ;��������� ���������, ��� ���������� �������� ���������

.code	                                                            ; ��������� ������� �������� ������
_start:                                                     	    ; ���� ������� �������� � ���� _start

main proc                                                           ;������� ��������� main
LOCAL _e: DWORD                                                     ;�������� ����f _e, ��� �� ��� DWORD
LOCAL _a: DWORD                                                     ;�������� ����f _a, ��� �� ��� DWORD
LOCAL _c: DWORD                                                     ;�������� ����f _c, ��� �� ��� DWORD

mov _e, sval(input("vvedit e = "))                                  ;���������� �������� ������ �������� ��� ����� _e  �� ��������� �� � ���'��
mov _a, sval(input("vvedit a = "))                                  ;���������� �������� ������ �������� ��� ����� _a  �� ��������� �� � ���'��
mov _c, sval(input("vvedit c = "))                                  ;���������� �������� ������ �������� ��� ����� _c  �� ��������� �� � ���'��

mov ebx, _a                                                        ; ���������� _a � ������ ebx
mov eax, _c                                                        ; ���������� _c � ������ eax.
sub ebx, eax                                                       ; ���������  _a>=_c

jge zero                                                           ;���������� ������� �� ���� "zero"

; zero                                                             ;��������� ������� �� ���� zero,���� ������ SF ������������. ���� �, �� ��������� ������������ ���
;y= e/3c+ac a<c
mov eax, _const1                                                   ;���������� �������� _const1 � ������ eax
mul _c                                                             ;������� �������� _const1 �� �������� _�
mov _temp1, eax                                                    ;���������� eax � ����� _temp1
mov eax, _e                                                        ;���������� �������� _� � ������ eax
div _temp1                                                         ;����� eax �� _temp1,��������� � eax
mov _temp2, eax                                                    ;���������� eax � _temp2
mov eax, _a                                                        ;���������� �������� _a � eax
mul _c                                                             ;������� eax �� _�
add _temp2, eax                                                    ;_temp2 + eax, ��������� � eax

INVOKE    MessageBoxA, NULL, ADDR MsgBoxText_1, ADDR MsgBoxCaption, MB_OK
invoke wsprintf, ADDR strbuf, ADDR _text, _temp2, _temp1 
invoke MessageBox, NULL, addr strbuf, addr _title, MB_ICONINFORMATION
invoke ExitProcess, 0

jmp lexit                                                         ;���������� �� ���� exit (GOTO exit)
zero:                                                             ;���� zero
;2a/7-c/7e a>=c
mov eax, _const2                                                  ;���������� �������� _const2 � ������ eax
mul _a                                                            ;������� _const2 �� �������� _�
div _const3                                                       ;����� eax �� _const3, ��������� � eax
mov _temp3, eax                                                   ;���������� eax � _temp3
mov eax, _const3                                                  ;���������� _const3 � eax
mul _e                                                            ;������� eax �� _�
mov _temp4, eax                                                   ;���������� eax � _temp4
mov eax, _c                                                       ;���������� _c � eax
div _temp4                                                        ;ĳ���� eax �� _temp4, ��������� � eax  
sub _temp3, eax                                                   ;������� �������� eax �� _temp3, ��������� � _temp3 


INVOKE    MessageBoxA, NULL, ADDR MsgBoxText_2, ADDR MsgBoxCaption, MB_OK   ;������ ���� ����������� � �������
invoke wsprintf, ADDR strbuf, ADDR _text, _temp3, _temp4                    ;������������ ����� �� ��������� wsprintf � ���������� ���������� � strbuf
invoke MessageBox, NULL, addr strbuf, addr _title, MB_ICONINFORMATION       ;������ MessageBox � �������������� ������ � ���������� _title, �� ������� ����������
invoke ExitProcess, 0                                                       ;���������� �������

lexit:                                                              ;���� lexit
ret                                                                 ;���������� ��������� ��
main endp                                                           ;���������� ������ � �������� ��������� �������� ����������
ret                                                                 ;���������� ��������� ��
end _start                                                          ;��������� �������� � ���� _start
