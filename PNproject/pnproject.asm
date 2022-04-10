.386
.MODEL FLAT, STDCALL

include grafika.inc

CSstyle		EQU		CS_HREDRAW + CS_VREDRAW + CS_GLOBALCLASS
WNDstyle	EQU		WS_CLIPCHILDREN + WS_OVERLAPPEDWINDOW + WS_HSCROLL+WS_VSCROLL
BSstyle     EQU     BS_PUSHBUTTON + WS_VISIBLE + WS_CHILD + WS_TABSTOP
EDTstyle    EQU     WS_VISIBLE + WS_CHILD + WS_TABSTOP + WS_BORDER


SRC1_DIMM   EQU   8
SRC1_REAL   EQU   2
DEST_MEM    EQU   0
SRC2_DIMM   EQU   2048

CharToOemA PROTO :DWORD,:DWORD 
StripLF      PROTO :DWORD
FpuAtoFL    PROTO :DWORD,:DWORD,:DWORD
FpuFLtoA    PROTO :DWORD,:DWORD,:DWORD,:DWORD
ExitProcess Proto :Dword
lstrcatA PROTO :DWORD,:DWORD

RegisterClassA PROTO : DWORD
CreateWindowExA PROTO : DWORD ,: DWORD ,: DWORD ,: DWORD ,: DWORD ,: DWORD ,: DWORD ,: DWORD ,: DWORD ,: DWORD ,: DWORD ,: DWORD
ShowWindow PROTO : DWORD ,: DWORD

 
 .data 
	hinst		DWORD				    0
	handleCursor		DWORD		    0
	handleBrush		DWORD				0
	handleIcon		DWORD				0 
	msg			MSGSTRUCT			<?> 
	wndc		WNDCLASS			<?>
	
	cname		BYTE				 "Anastazja", 0
	hwnd		DWORD				0
	hdc			DWORD				0
	tytul		BYTE				"Kalkulator",0 
	naglow		BYTE			     0
	rozmN		DWORD				0
	nagl		BYTE				"A", 0
	terr		BYTE				"Error1 ", 0
	terr2		BYTE				"Error2", 0 
	
    tplus BYTE " + " , 0
	tminus BYTE " - " , 0
	tmnoz BYTE " * " , 0
	tdziel BYTE " / " , 0
    tbutt BYTE "BUTTON" , 0
    hbutt DWORD 0

	hedt DWORD 0
    tedt BYTE "EDIT" , 0
    tliczbaj BYTE  0
	tliczbad BYTE  0

	tzero BYTE " 0 " , 0
	tjeden BYTE " 1 " , 0
	tdwa BYTE " 2 " , 0
	ttrzy BYTE " 3 " , 0
	tcztery BYTE " 4 " , 0
	tpiec BYTE " 5 " , 0
	tszesc BYTE " 6 " , 0
	tsiedem BYTE " 7 " , 0
	tosiem BYTE " 8 " , 0
	tdziewiec BYTE " 9 " , 0
	tkropka   BYTE " . " , 0
	tstrzalka BYTE " -> " , 0
	tce BYTE " CE " , 0

	tstat          DB    "STATIC", 0
	tsum          BYTe      0

	plus       DD  0
	minus      DD  0
	dziel      DD  0
	mnoz       DD  0
	jeden      DD  0
	dwa        DD  0
	trzy       DD  0
	cztery     DD  0
	piec       DD  0
	szesc      DD  0
	siedem     DD  0
	osiem      DD  0
	dziewiec   DD  0
	zero       DD  0 
	kropka     DD  0 
	strzalka   DD  0 
	ce   DD  0 
	liczbj     DD  0 
	liczbd     DD  0 
	ljeden     DB      128 dup(0)
	ldwa       DB      128 dup(0)
	wynikb     DB      128 dup(0)
	buffor1    DB      128 dup(0)
	buffor2    DB      128 dup(0)
	rozmiar    DD 128
	x	REAL10	12.0
	y	REAL10	7.0
	wynik REAL10 0.0

.code 

WndProc PROC uses EBX ESI EDI windowHandle:DWORD, uMsg:DWORD, wParam:DWORD, lParam:DWORD
 
	.IF uMSG == WM_CREATE
		INVOKE CreateWindowExA , 0 , OFFSET tbutt , OFFSET tplus , BSstyle , 10 , 100 , 40 , 40 , windowHandle , 0 , hinst , 0
		mov     plus, eax 
		INVOKE CreateWindowExA , 0 , OFFSET tbutt , OFFSET tminus , BSstyle , 60 , 100 , 40 , 40 , windowHandle , 0 , hinst , 0
		mov     minus, eax 
		INVOKE CreateWindowExA , 0 , OFFSET tbutt , OFFSET tmnoz , BSstyle , 10 , 150 , 40 , 40 , windowHandle , 0 , hinst , 0
		mov     mnoz, eax 
		INVOKE CreateWindowExA , 0 , OFFSET tbutt , OFFSET tdziel , BSstyle , 60 , 150 , 40 , 40 , windowHandle , 0 , hinst , 0 
		mov     dziel, eax 
		INVOKE CreateWindowExA , 0 , OFFSET tbutt , OFFSET tce , BSstyle , 10 , 200 , 40 , 40 , windowHandle , 0 , hinst , 0 
		mov     ce, eax 
		INVOKE CreateWindowExA , 0 , OFFSET tbutt , OFFSET tzero , BSstyle , 110 , 100 , 40 , 40 , windowHandle , 0 , hinst , 0
		mov     zero, eax 
		INVOKE CreateWindowExA , 0 , OFFSET tbutt , OFFSET tjeden , BSstyle , 160 , 100 , 40 , 40 , windowHandle , 0 , hinst , 0
		mov     jeden, eax 
		INVOKE CreateWindowExA , 0 , OFFSET tbutt , OFFSET tdwa , BSstyle , 210 , 100 , 40 , 40 , windowHandle , 0 , hinst , 0
		mov     dwa, eax 
		INVOKE CreateWindowExA , 0 , OFFSET tbutt , OFFSET ttrzy , BSstyle , 260 , 100 , 40 , 40 , windowHandle , 0 , hinst , 0 
		mov     trzy, eax
		INVOKE CreateWindowExA , 0 , OFFSET tbutt , OFFSET tcztery , BSstyle , 110 , 150 , 40 , 40 , windowHandle , 0 , hinst , 0
		mov     cztery, eax 
		INVOKE CreateWindowExA , 0 , OFFSET tbutt , OFFSET tpiec , BSstyle , 160 , 150 , 40 , 40 , windowHandle , 0 , hinst , 0
		mov     piec, eax 
		INVOKE CreateWindowExA , 0 , OFFSET tbutt , OFFSET tszesc , BSstyle , 210 , 150 , 40 , 40 , windowHandle , 0 , hinst , 0
		mov     szesc, eax 
		INVOKE CreateWindowExA , 0 , OFFSET tbutt , OFFSET tsiedem , BSstyle , 260 , 150 , 40 , 40 , windowHandle , 0 , hinst , 0 
		mov     siedem, eax
		INVOKE CreateWindowExA , 0 , OFFSET tbutt , OFFSET tosiem , BSstyle , 110 , 200 , 40 , 40 , windowHandle , 0 , hinst , 0
		mov     osiem, eax 
		INVOKE CreateWindowExA , 0 , OFFSET tbutt , OFFSET tdziewiec , BSstyle , 160 , 200 , 40 , 40 , windowHandle , 0 , hinst , 0
		mov     dziewiec, eax  
		INVOKE CreateWindowExA , 0 , OFFSET tbutt , OFFSET tkropka , BSstyle , 210 , 200 , 40 , 40 , windowHandle , 0 , hinst , 0
		mov     kropka, eax  
		INVOKE CreateWindowExA , 0 , OFFSET tbutt , OFFSET tstrzalka , BSstyle , 260 , 200 , 40 , 40 , windowHandle , 0 , hinst , 0
		mov     strzalka, eax  
		INVOKE CreateWindowExA , 0 , OFFSET tedt , OFFSET tliczbaj , EDTstyle , 5 , 20 , 130 , 30 , windowHandle , 0 , hinst , 0
		mov     liczbj, eax  
		INVOKE     SendMessageA, liczbj, WM_SETTEXT, 128, ADDR tliczbaj
		INVOKE SetFocus , liczbj 
		INVOKE CreateWindowExA , 0 , OFFSET tedt , OFFSET tliczbad , EDTstyle , 140 , 20 , 130 , 30 , windowHandle , 0 , hinst , 0
		mov     liczbd, eax  
		INVOKE     SendMessageA, liczbd, WM_SETTEXT, 128, ADDR tliczbad
		INVOKE SetFocus , liczbd
			 
		jmp wndend
	.ENDIF

	.IF uMSG ==  WM_COMMAND
		mov eax, lParam
		.IF eax == plus 
			INVOKE SendMessageA , liczbj , WM_GETTEXT ,128 , OFFSET ljeden
			INVOKE SendMessageA , liczbd , WM_GETTEXT ,128 , OFFSET ldwa
	        invoke FpuAtoFL, ADDR ljeden, ADDR x, DEST_MEM
			invoke FpuAtoFL, ADDR ldwa, ADDR y, DEST_MEM
			finit
			fld x
			fld y
			faddp st(1),st(0)
			fstp wynik
			invoke FpuFLtoA, ADDR wynik, 2, ADDR wynikb, SRC1_REAL or SRC2_DIMM
			INVOKE     SendMessageA, liczbj, WM_SETTEXT, 128, ADDR wynikb
			INVOKE  SendMessageA, liczbd, WM_SETTEXT, 128, ADDR tliczbad

		.ELSEIF eax==minus
			INVOKE SendMessageA , liczbj , WM_GETTEXT ,128 , OFFSET ljeden
			INVOKE SendMessageA , liczbd , WM_GETTEXT ,128 , OFFSET ldwa
			INVOKE  SendMessageA, liczbd, WM_SETTEXT, 128, ADDR tliczbad
	        invoke FpuAtoFL, ADDR ljeden, ADDR x, DEST_MEM
			invoke FpuAtoFL, ADDR ldwa, ADDR y, DEST_MEM
			finit
			fld x
			fld y
			fsubp st(1),st(0)
			fstp wynik 
			invoke FpuFLtoA, ADDR wynik, 2, ADDR wynikb, SRC1_REAL or SRC2_DIMM
			INVOKE     SendMessageA, liczbj, WM_SETTEXT, 128, ADDR wynikb
			INVOKE  SendMessageA, liczbd, WM_SETTEXT, 128, ADDR tliczbad

		.ELSEIF eax==mnoz 
			INVOKE SendMessageA , liczbj , WM_GETTEXT ,128 , OFFSET ljeden
			INVOKE SendMessageA , liczbd , WM_GETTEXT ,128 , OFFSET ldwa
	        invoke FpuAtoFL, ADDR ljeden, ADDR x, DEST_MEM
			invoke FpuAtoFL, ADDR ldwa, ADDR y, DEST_MEM
			finit
			fld x
			fld y
			fmulp st(1),st(0)
			fstp wynik
			invoke FpuFLtoA, ADDR wynik, 2, ADDR wynikb, SRC1_REAL or SRC2_DIMM
			INVOKE     SendMessageA, liczbj, WM_SETTEXT, 128, ADDR wynikb
			INVOKE  SendMessageA, liczbd, WM_SETTEXT, 128, ADDR tliczbad

		.ELSEIF eax==dziel
			INVOKE SendMessageA , liczbj , WM_GETTEXT ,128 , OFFSET ljeden
			INVOKE SendMessageA , liczbd , WM_GETTEXT ,128 , OFFSET ldwa
	        invoke FpuAtoFL, ADDR ljeden, ADDR x, DEST_MEM
			invoke FpuAtoFL, ADDR ldwa, ADDR y, DEST_MEM
			finit
			fld x
			fld y
			fdivp st(1),st(0)
			fstp wynik
			invoke FpuFLtoA, ADDR wynik, 2, ADDR wynikb, SRC1_REAL or SRC2_DIMM
			INVOKE     SendMessageA, liczbj, WM_SETTEXT, 128, ADDR wynikb
			INVOKE  SendMessageA, liczbd, WM_SETTEXT, 128, ADDR tliczbad

	     .ELSEIF eax==jeden
		     INVOKE  SendMessageA , liczbj , WM_GETTEXT ,128 , OFFSET buffor1
			 mov al,31h
			 mov buffor2, al
			 invoke  lstrcatA,OFFSET buffor1,OFFSET buffor2   
			 INVOKE  SendMessageA, liczbj, WM_SETTEXT, 128, ADDR buffor1
	     .ELSEIF eax==dwa
		     INVOKE  SendMessageA , liczbj , WM_GETTEXT ,128 , OFFSET buffor1
			 mov al,32h
			 mov buffor2, al
			 invoke  lstrcatA,OFFSET buffor1,OFFSET buffor2   
			 INVOKE  SendMessageA, liczbj, WM_SETTEXT, 128, ADDR buffor1
         .ELSEIF eax==trzy
		     INVOKE  SendMessageA , liczbj , WM_GETTEXT ,128 , OFFSET buffor1
			 mov al,33h
			 mov buffor2, al
			 invoke  lstrcatA,OFFSET buffor1,OFFSET buffor2   
			 INVOKE  SendMessageA, liczbj, WM_SETTEXT, 128, ADDR buffor1
		 .ELSEIF eax==cztery
		     INVOKE  SendMessageA , liczbj , WM_GETTEXT ,128 , OFFSET buffor1
			 mov al,34h
			 mov buffor2, al
			 invoke  lstrcatA,OFFSET buffor1,OFFSET buffor2   
			 INVOKE  SendMessageA, liczbj, WM_SETTEXT, 128, ADDR buffor1
	     .ELSEIF eax==piec
		     INVOKE  SendMessageA , liczbj , WM_GETTEXT ,128 , OFFSET buffor1
			 mov al,35h
			 mov buffor2, al
			 invoke  lstrcatA,OFFSET buffor1,OFFSET buffor2   
			 INVOKE  SendMessageA, liczbj, WM_SETTEXT, 128, ADDR buffor1
		 .ELSEIF eax==szesc
		     INVOKE  SendMessageA , liczbj , WM_GETTEXT ,128 , OFFSET buffor1
			 mov al,36h
			 mov buffor2, al
			 invoke  lstrcatA,OFFSET buffor1,OFFSET buffor2   
			 INVOKE  SendMessageA, liczbj, WM_SETTEXT, 128, ADDR buffor1
		.ELSEIF eax==siedem
		     INVOKE  SendMessageA , liczbj , WM_GETTEXT ,128 , OFFSET buffor1
			 mov al,37h
			 mov buffor2, al
			 invoke  lstrcatA,OFFSET buffor1,OFFSET buffor2   
			 INVOKE  SendMessageA, liczbj, WM_SETTEXT, 128, ADDR buffor1
	     .ELSEIF eax==osiem
		     INVOKE  SendMessageA , liczbj , WM_GETTEXT ,128 , OFFSET buffor1
			 mov al,38h
			 mov buffor2, al
			 invoke  lstrcatA,OFFSET buffor1,OFFSET buffor2   
			 INVOKE  SendMessageA, liczbj, WM_SETTEXT, 128, ADDR buffor1
		 .ELSEIF eax==dziewiec
		     INVOKE  SendMessageA , liczbj , WM_GETTEXT ,128 , OFFSET buffor1
			 mov al,39h
			 mov buffor2, al
			 invoke  lstrcatA,OFFSET buffor1,OFFSET buffor2   
			 INVOKE  SendMessageA, liczbj, WM_SETTEXT, 128, ADDR buffor1
		 .ELSEIF eax==zero
		     INVOKE  SendMessageA , liczbj , WM_GETTEXT ,128 , OFFSET buffor1
			 mov al,30h
			 mov buffor2, al
			 invoke  lstrcatA,OFFSET buffor1,OFFSET buffor2   
			 INVOKE  SendMessageA, liczbj, WM_SETTEXT, 128, ADDR buffor1
		 .ELSEIF eax==kropka
		     INVOKE  SendMessageA , liczbj , WM_GETTEXT ,128 , OFFSET buffor1
			 mov al,2eh
			 mov buffor2, al
			 invoke  lstrcatA,OFFSET buffor1,OFFSET buffor2   
			 INVOKE  SendMessageA, liczbj, WM_SETTEXT, 128, ADDR buffor1
		 .ELSEIF eax==strzalka
		     INVOKE  SendMessageA , liczbj , WM_GETTEXT ,128 , OFFSET buffor1 
			 INVOKE  SendMessageA, liczbd, WM_SETTEXT, 128, ADDR buffor1
			 INVOKE  SendMessageA, liczbj, WM_SETTEXT, 128, ADDR tliczbaj
		 .ELSEIF eax==ce  
			 INVOKE  SendMessageA, liczbj, WM_SETTEXT, 128, ADDR tliczbaj
			 INVOKE  SendMessageA, liczbd, WM_SETTEXT, 128, ADDR tliczbad
		.ENDIF
		jmp wndend
	.ENDIF 
	 
	INVOKE DefWindowProcA, windowHandle, uMsg, wParam, lParam

	wndend:

	ret 
WndProc ENDP

main proc
	mov [wndc.clsStyle], CSstyle				
	mov [wndc.clsLpfnWndProc], OFFSET WndProc	

	INVOKE GetModuleHandleA, 0
	mov	hinst, EAX
	mov [wndc.clsHInstance], EAX
	mov [wndc.clsCbWndExtra], 0  
	mov [wndc.clsCbClsExtra], 0

	INVOKE LoadIconA , 0 , IDI_APPLICATION
    mov handleIcon , EAX  
	mov [wndc.clshIcon], EAX
	INVOKE LoadCursorA , 0 , IDC_ARROW
    mov handleCursor , EAX
	mov [wndc.clshCursor], EAX
	INVOKE GetStockObject , WHITE_BRUSH
    mov handleBrush , EAX 
	mov [wndc.clshbrBackground], EAX   
	mov [wndc.clslpszMenuName], 0  
	mov [wndc.clslpszClassName], OFFSET cname   	
	  
	INVOKE RegisterClassA , OFFSET wndc
	 .IF EAX == 0
	 	jmp err0
	 .ENDIF
	  
	INVOKE CreateWindowExA , 0 , OFFSET cname , OFFSET tytul , WNDstyle , 50 , 50 , 600 , 400 , 0 , 0 , hinst , 0
    mov hwnd , EAX
	  
	 .IF EAX == 0 
	 .ENDIF 
	 mov	hwnd, EAX
	  
	INVOKE ShowWindow , hwnd , SW_SHOWNORMAL

	INVOKE GetDC , hwnd
    mov hdc , EAX
    INVOKE lstrlenA , OFFSET naglow
    mov rozmN , EAX
    INVOKE TextOutA , hdc ,100 ,100 , OFFSET naglow , rozmN
    INVOKE UpdateWindow , hwnd
	 
	msgloop:
		INVOKE GetMessageA, OFFSET msg, 0, 0, 0
		.IF EAX == 0
			jmp	etkon
		.ENDIF
		.IF EAX == -1
			jmp	err0
		.ENDIF	
		
		INVOKE TranslateMessage, OFFSET msg
		INVOKE DispatchMessageA, OFFSET msg
	jmp	msgloop

	 
	err0:
	 INVOKE MessageBoxA,0,OFFSET terr,OFFSET nagl,0
	 jmp	etkon
	err2:
	 INVOKE MessageBoxA,0,OFFSET terr2,OFFSET nagl,0	
	etkon:

	push 0
	call ExitProcess
main endp
 

END