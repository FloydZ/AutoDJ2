#Include <GUIConstantsEx.au3>
#Include <GUITreeView.au3>
#Include <TVExplorer.au3>
#Include <TreeViewConstants.au3>
#Include <WindowsConstants.au3>


Opt('MustDeclareVars', 1)

Global $hForm, $hTV[3], $Input[3], $hFocus = 0, $Dummy, $Path, $Style

If Not _WinAPI_DwmIsCompositionEnabled() Then
	$Style = $WS_EX_COMPOSITED
Else
	$Style = -1
EndIf
$hForm = GUICreate('TVExplorer UDF Example', 700, 736, -1, -1, BitOR($GUI_SS_DEFAULT_GUI, $WS_MAXIMIZEBOX, $WS_SIZEBOX), $Style)
GUISetIcon(@WindowsDir & '\explorer.exe')

$hTV[2] = _GUICtrlTVExplorer_Create('', 20, 406, 660, 310, -1, $WS_EX_CLIENTEDGE, -1, '_TVEvent')
For $i = 0 To 2
	_TVSetPath($Input[$i], _GUICtrlTVExplorer_GetSelected($hTV[$i]))
	_GUICtrlTVExplorer_SetExplorerStyle($hTV[$i])
Next
$Dummy = GUICtrlCreateDummy()
GUIRegisterMsg($WM_GETMINMAXINFO, 'WM_GETMINMAXINFO')
GUIRegisterMsg($WM_SIZE, 'WM_SIZE')
HotKeySet('{F5}', '_TVRefresh')
GUISetState()

_GUICtrlTVExplorer_Expand($hTV[0], @ProgramFilesDir & '\AutoIt3')
_GUICtrlTVExplorer_Expand($hTV[1])

While 1
	Switch _GUICtrlTVExplorer_GetMsg()
		Case $GUI_EVENT_CLOSE
			GUIDelete()
			_GUICtrlTVExplorer_DestroyAll()
			Exit
		Case $Dummy
			$Path = _GUICtrlTVExplorer_GetSelected($hFocus)
			_GUICtrlTVExplorer_AttachFolder($hFocus)
			_GUICtrlTVExplorer_Expand($hFocus, $Path, 0)
			$hFocus = 0
	EndSwitch
WEnd

Func _TVEvent($hWnd, $iMsg, $sPath, $hItem)
	Switch $iMsg
		Case $TV_NOTIFY_BEGINUPDATE
			GUISetCursor(1, 1)
		Case $TV_NOTIFY_ENDUPDATE
			GUISetCursor(2)
		Case $TV_NOTIFY_SELCHANGED

		Case $TV_NOTIFY_DBLCLK
			; Nothing
		Case $TV_NOTIFY_RCLICK
			; Nothing
		Case $TV_NOTIFY_DELETINGITEM
			; Nothing
		Case $TV_NOTIFY_DISKMOUNTED
			; Nothing
		Case $TV_NOTIFY_DISKUNMOUNTED
			; Nothing
	EndSwitch
EndFunc   ;==>_TVEvent

Func _TVSetPath($iInput, $sPath)

	Local $Text = _WinAPI_PathCompactPath(GUICtrlGetHandle($iInput), $sPath, -2)

	If GUICtrlRead($iInput) <> $Text Then
		GUICtrlSetData($iInput, $Text)
	EndIf
EndFunc   ;==>_TVSetPath

Func _TVRefresh()

	Local $hWnd = _WinAPI_GetFocus()

	For $i = 0 To 2
		If $hTV[$i] = $hWnd Then
			If Not $hFocus Then
				$hFocus = $hWnd
				GUICtrlSendToDummy($Dummy)
			EndIf
			Return
		EndIf
	Next
	HotKeySet('{F5}')
	Send('{F5}')
	HotKeySet('{F5}', '_TVRefresh')
EndFunc   ;==>_TVRefresh

Func WM_GETMINMAXINFO($hWnd, $iMsg, $wParam, $lParam)

	Local $tMMI = DllStructCreate('long Reserved[2];long MaxSize[2];long MaxPosition[2];long MinTrackSize[2];long MaxTrackSize[2]', $lParam)

	Switch $hWnd
		Case $hForm
			DllStructSetData($tMMI, 'MinTrackSize', 428, 1)
			DllStructSetData($tMMI, 'MinTrackSize', 450, 2)
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_GETMINMAXINFO

Func WM_SIZE($hWnd, $iMsg, $wParam, $lParam)

	Local $WC, $HC, $WT, $HT

	Switch $hWnd
		Case $hForm
			$WC = _WinAPI_LoWord($lParam)
			$HC = _WinAPI_HiWord($lParam)
			$WT = Floor(($WC - 60) / 2)
			$HT = Floor(($HC - 116) / 2)
			GUICtrlSetPos(_WinAPI_GetDlgCtrlID($hTV[0]), 20, 48, $WT, $HT)
			GUICtrlSetPos(_WinAPI_GetDlgCtrlID($hTV[1]), $WT + 40, 48, $WC - $WT - 60, $HT)
			GUICtrlSetPos(_WinAPI_GetDlgCtrlID($hTV[2]), 20, $HT + 96, $WC - 40, $HC - $HT - 116)
			GUICtrlSetPos($Input[0], 20, 20, $WT)
			GUICtrlSetPos($Input[1], $WT + 40, 20, $WC - $WT - 60)
			GUICtrlSetPos($Input[2], 20, $HT + 68, $WC - 40)
			For $i = 0 To 2
				_TVSetPath($Input[$i], _GUICtrlTVExplorer_GetSelected($hTV[$i]))
			Next
			Return 0
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_SIZE
