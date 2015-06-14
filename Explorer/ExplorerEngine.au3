#Include "TVExplorer.au3"

GUIRegisterMsg($WM_GETMINMAXINFO, 'WM_GETMINMAXINFO')


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
	
	If $hItem = $hTreeView_iTunes Then 
	
	EndIf
	If $hItem = $hTreeView_DJ_Music Or $CheckFlag = 1 Then 
		_Treeview_ClickedDJMusicChild()
		$CheckFlag = 0
		;MsgBox(0,"","")
	EndIf

	
	If $sPath = $Old_Direction Then Return -1
	$Old_Direction = $sPath
	
	_GUICtrlListView_DeleteAllItems($hListView)

	$search = FileFindFirstFile($sPath & "\*.mp3")
	
	While 1
		$File = FileFindNextFile($search)
		If @error Then ExitLoop
		If @extended = 0 Then _GuiCtrlListView_AddTitle($sPath & "\" & $File)
	WEnd
	
EndFunc   ;==>_TVEvent

Func _Scan_iTunes()

	$iTunesMediathek = @UserProfileDir & "\Music\iTunes\iTunes Music Library.xml"
	_XMLFileOpen($iTunesMediathek)
	
	_XMLNodeExists("dict/Track/dict")
	If @error Then Return -1
	$get = __XMLGetNodeCount("dict/Track/dict")
	If @error Then MsgBox(0,"",@error)
	;_ArrayDisplay($get)
EndFunc
Func _Treeview_ClickedDJMusicChild()
;DJ Child
	$Sections = IniReadSectionNames($MusicList)
	;_ArrayDisplay($Sections)
	For $x =1 To $Sections[0]
		_GuiCtrlListView_AddTitle($Sections[$x])
	Next	
	
	$CheckFlag = 1
EndFunc
Func _GuiCtrlListView_AddTitle($File)
	$i = _GUICtrlListView_AddItem($hListview, "NO")
	
	_GUICtrlListView_AddSubItem($hListview, $i, "0", 3)
	_GUICtrlListView_AddSubItem($hListview, $i, $File, 6)
	
	
EndFunc
Func _AddFile2List()
	$File = FileOpenDialog("Select File", @DesktopDir, "Audio File (*.mp3; *.wav)")
	
	$Sections = IniReadSectionNames($MusicList)
	For $x = 1 To $Sections[0]
		If $File = $Sections[$x] Then Return -1
	Next
	
	IniWrite($MusicList, $File, "Name", $File)
	
	;_GUICtrlTreeView_AddChild($hTreeView, $hTreeView_DJ_Music, $File)
EndFunc
Func WM_GETMINMAXINFO($hWnd, $iMsg, $wParam, $lParam)

	Local $tMMI = DllStructCreate('long Reserved[2];long MaxSize[2];long MaxPosition[2];long MinTrackSize[2];long MaxTrackSize[2]', $lParam)

	Switch $hWnd
		Case $MainGui
			DllStructSetData($tMMI, 'MinTrackSize', 428, 1)
			DllStructSetData($tMMI, 'MinTrackSize', 450, 2)
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_GETMINMAXINFO


