.686                                                                                   ;������������ ���� ���������� �� x86
.model flat, stdcall                                                                   ;������������ ������ ���'�� �� flat �� ��������� ������� �� stdcall
option casemap:none                                                                    ;������������ ��������� �� ������� ������� �� none
include \masm32\include\windows.inc                                                    ;��������� ���� � ������������ ������� �� ���� Windows API
include \masm32\include\kernel32.inc                                                   ;��������� ���� � ������������ ������� �� ���� Kernel32 API
include \masm32\include\user32.inc                                                     ;��������� ���� � ������������ ������� �� ���� User32 API
includelib \masm32\lib\user32.lib                                                      ;��������� �������� User32 API
includelib \masm32\lib\kernel32.lib                                                    ;��������� �������� Kernel32 API
firstfunc PROTO _e1:DWORD,_const1:DWORD,_b1:DWORD,_const2:DWORD,_a1:DWORD,_c1:DWORD    ;��������� �������� ������� firstfunc �� �� ���������
.data   ; e/8b + 25ac                                                                  ;�������� ���������� �����
e1 dd 32                                                                               ;��������� ����� e1 ���� ��������� ����� (double word) �� ���������� �� �������� 32
const1 dd 8                                                                            ;��������� ����� const1 ���� dd, ���������� �������� 8   
b1 dd 4                                                                                ;��������� ����� b1 ���� dd, ���������� �������� 4
const2 dd 25                                                                           ;��������� ����� const2 ���� dd, ���������� �������� 25
a1 dd 1                                                                                ;��������� ����� a1 ���� dd, ���������� �������� 1
c1 dd 2                                                                                ;��������� ����� c1 ���� dd, ���������� �������� 2
_temp1 dd ?,0                                                                          ;��������� ���� � ���'�� ��� ����� temp1 (double word)
_temp2 dd ?,0                                                                          ;��������� ���� � ���'�� ��� ����� temp2 (double word)
_title db "����������� ������ �1. �����. ��������",0                                   ;������ ����� � ������ ��������
strbuf dw ?,0                                                                          ;��������� ���� � ���'�� ��� ������ ����� (dw - double word)
_text db "masm32. ���� ���������� e/8b + 25ac ����� MessageBox:",0ah,"���������: %d � ���� �������",0ah, 0ah,
"��������� ���� ����",0                                                                ;������ ����� � �������, ���� ���� ���������� �� �����

.code                                                                                  ;�������� ����� ����
firstfunc proc _e1:DWORD,_const1:DWORD,_b1:DWORD,_const2:DWORD, _a1:DWORD,_c1:DWORD    ;��������� ��������� firstfunc � ����������� e1, const1, b1, const2, a1, c1
mov eax, _const2;                                                                      ;��������� �������� const2 � ������ eax
mul _a1                                                                                ;������� �������� a1 �� �������� � ������ eax, ��������� �������� � eax
mul _c1                                                                                ;������� �������� c1 �� �������� � ������ eax, ��������� �������� � eax
mov _temp1, eax                                                                        ;��������� ��������, �� ����������� � ������ eax, � ����� temp1
mov eax, _const1                                                                       ;��������� �������� const1 � ������ eax
mul _b1                                                                                 ;������� �������� b1 �� �������� � ������ eax, ��������� �������� � eax
mov _temp2, eax                                                                        ;��������� �������� � ������ eax � ����� temp2
mov eax, e1                                                                            ;��������� �������� e1 � ������ eax
div _temp2                                                                             ;����� �������� � ������ eax �� ��������, �� ����������� � ������ temp2, ��������� ������ ���������� � ������ eax
add _temp1, eax                                                                        ;������ ��������, �� ����������� � ������ eax, �� ��������, �� ����������� � ������ temp1, ��������� ���������� � ������ temp1
ret                                                                                    ;���������� ��������� ��
firstfunc endp                                                                         ;����� ���������� ��������� firstfunc

start:                                                                                 ;������ ��������
invoke firstfunc, e1,const1,b1,const2,a1,c1                                            ;������ ��������� firstfunc � ����������� e1,const1,b1,const2,a1,c1
invoke wsprintf, ADDR strbuf, ADDR _text, _temp1, _temp2                               ;������������ ����� �� ��������� wsprintf � ���������� ���������� � strbuf
invoke MessageBox, NULL, addr strbuf, addr _title, MB_ICONINFORMATION                  ;������ MessageBox � �������������� ������ � ���������� _title, �� ������� ����������
invoke ExitProcess, 0                                                                  ;���������� �������
END start                                                                              ;����� ��������