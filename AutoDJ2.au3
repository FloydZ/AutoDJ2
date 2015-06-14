Opt("GUIOnEventMode", 1)

#include <Global\Global.au3>

#include <Controles\Fader.au3>
#include <Controles\CrossFader.au3>
#include <Controles\XYPad.au3>
#include <Controles\EffectSlider.au3>
#include <Controles\Poti.au3>

#include <Explorer\ExplorerEngine.au3>

#include <Forms\MainGUI\MainGUI.au3>

;AdlibRegister("_Draw", 25)
AdlibRegister("_CheckIfAudioRunning", 1000)
;_Scan_iTunes()
While 1
	Sleep(25)
	_Draw() 
	If _IsPressed("20", $vU32Dll) = 1 Then ;Modi Umschalten
		While _IsPressed("20", $vU32Dll)
            Sleep(10)
        WEnd
		_ChangeMode()	
	EndIf
WEnd

Func _ChangeMode()
	$MODE += 1
	If $MODE = 3 Then $MODE = 0

	Switch $Mode
		Case 0
			_DeleteDecks()
			ControlMove ( "", "", $hTreeView, 0, 0 , 300 , 1000)
			ControlMove ( "", "", $hListView, 300, 0, 700, 800)
		Case 1
			ControlMove ( "", "", $hTreeView, 0, 500, 300, 300)
			ControlMove ( "", "", $hListView, 300, 550, 700, 250)
			_CreateDecks()
		Case 2	
			_Cross_DeleteALL()
			ControlMove ( "", "", $hTreeView, 0, 310, 300, 490)
			ControlMove ( "", "", $hListView, 300, 310, 700, 490)
	EndSwitch
	ConsoleWrite($MODE & @LF)
EndFunc

Func _Draw()
	$aCursorInfo = GUIGetCursorInfo($MainGUI)
	If $aCursorInfo[4] <> 0 Or $bMouseClick = True Then
		;HoverFunc einbauen
		If _IsPressed("01", $vU32Dll) = 1 Then
			$bMouseClick = True
			
			$Return = _Poti_GetIdFromHandle(($aCursorInfo[4]))
			If $Return <> -1 Then 
				_DrawPoti($Return)	
				;ConsoleWrite(_Poti_GetRightValue($Return) & @CRLF)
				Return 1
			EndIf	
			
			$Return = _Fader_GetIdFromHandle(($aCursorInfo[4]))
			If $Return <> -1 Then 
				_DrawFader($Return)
				;ConsoleWrite(_Cross_GetValue($Return) & @CRLF)
				Return 1
			Endif

			
			$Return = _Cross_GetIdFromHandle(($aCursorInfo[4]))
			If $Return <> -1 Then 
				_DrawCross($Return)	
				;ConsoleWrite(_Cross_GetValue($Return) & @CRLF)
				Return 1
			EndIf
	
			
			$Return = _Pad_GetIdFromHandle(($aCursorInfo[4]))
			If $Return <> -1 Then 
				_DrawPad($Return)	
				;ConsoleWrite(_Pad_GetValue($Return) & @CRLF)
				Return 1
			EndIf		
				
				
			$Return = _ESlider_GetIdFromHandle(($aCursorInfo[4]))
			If $Return <> -1 Then 
				_DrawESlider($Return)	
				;ConsoleWrite(_ESlider_GetValue($Return) & @CRLF)
				Return 1
			EndIf	
		Else
			If $bMouseClick Then $bMouseClick = False
		EndIf
	EndIf
EndFunc

Func _CheckIfAudioRunning()
	Local Static $var = 0
	
	If ProcessExists("AutoDJ_Bass.exe") <> 0 Then
		Return 1
		GUICtrlSetColor($Label[14], 0x7DDCE3)
	Else
		If $var = 0 Then 
			GUICtrlSetColor($Label[14], 0x7DDCE3)
			$var = 1
		Else
			GUICtrlSetColor($Label[14], 0x000000)
			$var = 0
		EndIf
	EndIf
EndFunc


