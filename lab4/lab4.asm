.686                                                            ;��������� ���������� ���� �������������
.model flat, stdcall                                            ;������� ����� ����� ����� � ����� OC Windows
option casemap:none                                             ;�������� ����� �� ������� ����
include C:\masm32\include\windows.inc                           ;���� � ������������ �������
include \masm32\macros\macros.asm                               ;���� � ����������� macros
include C:\masm32\include\kernel32.inc                          ;���� � ������������ �������
include \masm32\include\masm32.inc                              ;���� � ����������� masm.inc
include \masm32\include\gdi32.inc                               ;���� � ����������� gdi32.inc
include C:\masm32\include\user32.inc                            ;���� � ������������ �������
include C:\masm32\include\fpu.inc                               ;���� � ������������ �������
include c:\masm32\include\msvcrt.inc                            ;connecting the msvcrt.inc program file
includelib c:\masm32\lib\msvcrt.lib                             ;���������� �������� msvcrt
includelib \masm32\lib\masm32.lib                               ;���������� �������� masm32
includelib \masm32\lib\gdi32.lib                                ;���������� �������� gdi32
includelib C:\masm32\lib\kernel32.lib                           ;���������� �������� kernel32
includelib C:\masm32\lib\user32.lib                             ;���������� �������� user32
includelib C:\masm32\lib\fpu.lib                                ;���������� �������� fpu

.data                                                           ;��������� ���������� �����
	_const1 DWORD 0.3                                           ;���������� ��������� _const1 �� ��������� �� �������� 0.3
	_const2 DWORD 0.11                                          ;���������� ��������� _const2 �� ��������� �� �������� 0.11
	op1 DWORD -2.0                                              ;���������� ��1 �� ��������� �� �������� -2.0
	op2 DWORD 2.0                                               ;���������� ��2 �� ��������� �� �������� 2.0
	_title db "����������� ������ �2. �������� ����������",0   ;������ ����� � ������ ��������
	strbuf dw ?,0                                               ;��������� ���� � ���'�� ��� ������ �����
	_text db "masm32. ���� ���������� ����� MessageBox:", 10,
		"x=y+arctgy y<=-2.0", 10,
		"x=arcSin(0.3y+0.11) -2.0<=y<=2.0", 10,
		"x=ln(y+sqrt(y)) 2.0<y", 10,
		"���������: "                                           ;������ ����� � �������, ���� ���� ���������� �� �����
	_res db 10 DUP(0),10,13                                     ;���������� ������ ��� ���������� ���������� _res
	MsgBoxCaption db "��������� ���������:",0                  ;����� �������, �� ������ ��������� ���� �����������
	MsgBoxText_1 db "y<=-2.0",0                                 ;����� �������, �� ������ �����, ���� ���� ���������� � ��� ����������� ��� ���������� ��������� ������ 
	MsgBoxText_2 db "-2.0<=y<=2.0", 0                           ;����� �������, �� ������ �����, ���� ���� ���������� � ��� ����������� ��� ���������� ��������� ������
	MsgBoxText_3 db "2.0<y", 0                                  ;����� �������, �� ������ �����, ���� ���� ���������� � ��� ����������� ��� ���������� ��������� ������
.const                                                          ;������� ������ ��������
	NULL equ 0                                                  ;��'� ���������, ��� ������� 0
	MB_OK equ 0                                                 ;��������� ���������, ��� ���������� �������� ���������

.code                                                           ;��������� ������� �������� ������
_start:	                                                        ;���� ������� �������� � ���� _start	
	
	main proc                                                   ;������� ��������� main
	LOCAL _y: DWORD                                             ;�������� ����f _y, ��� �� ��� DWORD
	mov _y, sval(input("Vvedit y: "))                           ;���������� �������� ������ �������� ��� ����� _e  �� ��������� �� � ���'��

	finit   				 									;����������� FPU
	fild _y                                                     ;_y (st(0))
	fstp _y                                            			;����������� �������� � ������� ����� FPU � ����� _y
	fld op1                                                     ;op1 (st(0)) --> op1 (st(1))
	fld _y                                                      ;_y (st(0))
	fcompp                                                      ;��������� _y �� op1 
	fstsw ax                                                    ;�������� ����� ����� � ������ ��
	sahf                                                        ;����������� �������� ����� � ��
	jbe m1                                                      ;������� �� ���� m1 , ���� ����� ��� ������� (_y<=-2)
	fld op2                                                     ;op2 (st(0)) --> op2 (st(1))
	fld _y                                                      ;_y (st(0))
	fcompp                                                      ;��������� _y �� op2
	fstsw ax                                                    ;�������� ����� ����� � ������ ��
	sahf                                                        ;����������� �������� ����� � ��
	ja m2                                                       ;������� �� ���� m2 , ���� ���� (_y>2.0)
		;-3.0<=x<=4.0
		;x=arcSin(0.3y+0.11)
		fld _y                                                 ;_y (st(0))
		fmul _const1                                           ;0.3*_y (st(0))
		fadd _const2                                           ; 0.3*_y + 0.11 (st(0))
		fst st(0)                                              ;�������� ��������� � st(0)
		fld st(0)                                              ;�������� ���������
		fmul                                                   ;(0.3*_y+0.11)**2
		fld st(0)                                              ;�������� ��������� 
		fld1                                                   ;1-(0.3*_y+0.11)**2.
		fsubr                                                  ;�������� 
		fdiv                                                   ;(0.3*_y+0.11)**2/(1-(0.3*_y+0.11)**2).
		fsqrt                                                  ;sqrt((0.3*_y+0.11)**2/(1-(0.3*_y+0.11)**2)).
		fld1                                                   ;����������
		fpatan                                                 ;������ ����������
		invoke MessageBoxA, NULL, ADDR MsgBoxText_2, ADDR MsgBoxCaption, MB_OK  ;������ ���� ����������� � �������
		invoke FpuFLtoA, 0, 10, ADDR _res, SRC1_FPU or SRC2_DIMM                ;������������� ���������� � ���������� ������ � ��������� ����� �� ����� ���� � _res  
		invoke MessageBox, 0, offset _text, offset _title, MB_ICONINFORMATION   ;������ MessageBox
		invoke ExitProcess, 0                                                   ;���������� �������	
		jmp lexit                                                               ;������� �� ���� lexit
	
	m1:                                                        ;���� m1
		;y<=-2.0
		;x=y+arctgy
		fld _y                   ;����� _y � st(0)
		fld1	                 ;������������ 1 � ���� FPU
		fptan                    ;arctg_y
		fadd st(0), st(1)        ;��������� arctg(y) �� y
		fstp st(2)               ;����������� �������� � ������� ����� FPU � st(2)
		fld _y                   ;���������� �������� _y � st(0)
		fadd                     ;arctg_y + _y, ��������� � st(0)
		invoke MessageBoxA, NULL, ADDR MsgBoxText_1, ADDR MsgBoxCaption, MB_OK  ;������ ���� ����������� � �������
		invoke FpuFLtoA, 0, 10, ADDR _res, SRC1_FPU or SRC2_DIMM                ;������������� ���������� � ���������� ������ � ��������� ����� �� ����� ���� � _res
		invoke MessageBox, 0, offset _text, offset _title, MB_ICONINFORMATION   ;������ MessageBox
		invoke ExitProcess, 0                                                   ;���������� �������	
		jmp lexit                                                               ;������� �� ���� lexit

	m2:                            ;���� m1
	    ;2.0<y
		;x=ln(y+sqrt(y)) 
		fld _y                     ;����� _y � st(0) 
		fsqrt                      ;sqrt(_y) � st(0) --> st(1)
		fld _y                     ;_y � st(0)
		fadd                       ;sqrt(_y)+_y � st(0)
		fstp st(2)                 ;sqrt(_y)+_y � st(2)
		fldln2                     ;ln(_y+sqrt_y)
		fld st(2)                  ;�������� ���������
		fyl2x                      ;���������� ��������
		invoke MessageBoxA, NULL, ADDR MsgBoxText_3, ADDR MsgBoxCaption, MB_OK  ;������ ���� ����������� � �������
		invoke FpuFLtoA, 0, 10, ADDR _res, SRC1_FPU or SRC2_DIMM                ;������������� ���������� � ���������� ������ � ��������� ����� �� ����� ���� � _res
		invoke MessageBox, 0, offset _text, offset _title, MB_ICONINFORMATION   ;������ MessageBox
		invoke ExitProcess, 0                                                   ;���������� �������	
		jmp lexit                                                               ;������� �� ���� lexit

	lexit:                        ;���� lexit                                             
		ret                       ;���������� ��������� ��
		main endp                 ;���������� ������ � �������� ��������� �������� ����������
		ret                       ;���������� ��������� ��
	
end _start                        ;��������� �������� � ���� _start