Func _New_OwnTab()
	Local $oOwnTab = _AutoItObject_Create()
	_AutoItObject_AddProperty($oOwnTab, 'guiHandle')
	_AutoItObject_AddProperty($oOwnTab, 'guiWidth')
	_AutoItObject_AddProperty($oOwnTab, 'guiHeight')
	_AutoItObject_AddProperty($oOwnTab, 'icons')
	_AutoItObject_AddProperty($oOwnTab, 'iconsID')
	_AutoItObject_AddProperty($oOwnTab, 'labels')
	_AutoItObject_AddProperty($oOwnTab, 'labelsID')
	_AutoItObject_AddProperty($oOwnTab, 'itemsCount')
	_AutoItObject_AddProperty($oOwnTab, 'currentTab')
	_AutoItObject_AddProperty($oOwnTab, 'elementWidth')
	_AutoItObject_AddProperty($oOwnTab, 'hoverIndex')
	_AutoItObject_AddProperty($oOwnTab, 'curHover')
	_AutoItObject_AddProperty($oOwnTab, 'lastHover')
	_AutoItObject_AddProperty($oOwnTab, 'pHandles')

	_AutoItObject_AddMethod($oOwnTab, 'addGUI', '_ownTabAddGUI')
	_AutoItObject_AddMethod($oOwnTab, 'addIcons', '_ownTabAddIcons')
	_AutoItObject_AddMethod($oOwnTab, 'addLabels', '_ownTabAddLabel')
	_AutoItObject_AddMethod($oOwnTab, 'addEvents', '_ownTabaddEvents')
	_AutoItObject_AddMethod($oOwnTab, 'addPages', '_ownTabaddPages')
	_AutoItObject_AddMethod($oOwnTab, 'setItemCount', '_ownTabsetItemCount')
	_AutoItObject_AddMethod($oOwnTab, 'startHover', '_ownTabstartHover')
	_AutoItObject_AddMethod($oOwnTab, 'stopHover', '_ownTabstopHover')
	_AutoItObject_AddMethod($oOwnTab, 'hoverFunc', '_ownTabhoverFunc')
	_AutoItObject_AddMethod($oOwnTab, 'allWhite', '_ownTabAllWhite')
	_AutoItObject_AddMethod($oOwnTab, 'tabSwitch', '_ownTabtabSwitch')

	$oOwnTab.currentTab = 0
	$oOwnTab.elementWidth = 100
	$oOwnTab.lastHover = 999

	Return $oOwnTab
EndFunc

Func _ownTabaddPages($oSelf, $hHandles)
	$oSelf.pHandles = $hHandles
EndFunc

Func _ownTabtabSwitch($oSelf, $iID)
	Local $sHandles = $oSelf.pHandles
	Local $sLabelsID = $oSelf.labelsID

	If HWnd($sHandles[$oSelf.currentTab]) = HWnd($sHandles[$iID]) Then Return 0

	GUICtrlSetBkColor($sLabelsID[$oSelf.currentTab], 0xFFFFFF)
	GUISetState(@SW_HIDE, HWnd($sHandles[$oSelf.currentTab]))
	$oSelf.currentTab = $iID
	GUICtrlSetBkColor($sLabelsID[$iID], 0xC1D2EE)
	GUISetState(@SW_SHOW, HWnd($sHandles[$oSelf.currentTab]))
EndFunc

Func _ownTabaddEvents($oSelf, $sEvents)
	Local $sLabelsID = $oSelf.labelsID
	Local $sIconsID = $oSelf.iconsID
	For $i = 0 To $oSelf.itemsCount - 1
		GUICtrlSetOnEvent($sLabelsID[$i], $sEvents[$i])
		GUICtrlSetOnEvent($sIconsID[$i], $sEvents[$i])
	Next
EndFunc


Func _ownTabhoverFunc($oSelf)
	Local $iCursor = GUIGetCursorInfo(HWnd($oSelf.guiHandle))
	If Not IsArray($iCursor) Then Return 0

	Local $sLabelsID = $oSelf.labelsID
	Local $sIcons = $oSelf.iconsID
	Local $sHoverIndex = $oSelf.hoverIndex

	For $i = 0 To $oSelf.itemsCount - 1
		Switch $iCursor[4]
			Case $sLabelsID[$i], $sIcons[$i]
				If $oSelf.lastHover <> $i Then
					If $oSelf.lastHover < 999 Then GUICtrlSetBkColor($sLabelsID[$oSelf.lastHover], 0xFFFFFF)
					If $i <> $oSelf.currentTab Then


						GUICtrlSetBkColor($sLabelsID[$i], 0xE0E8F6)
						$oSelf.lastHover = $i
						ToolTip(@MSEC, 0, 0)
					EndIf
				EndIf
			Case Else
;~ 				GUICtrlSetBkColor($sLabelsID[$oSelf.lastHover], 0xFFFFFF)
		EndSwitch
	Next
EndFunc

Func _ownTabsetItemCount($oSelf, $iCount)
	$oSelf.itemsCount = $iCount
	Local $sIndex[$oSelf.itemsCount]
;~ 	For $i = 0 To $oSelf.itemsCount - 1
;~ 		$sIndex[$i] = False
;~ 	Next
	$oSelf.hoverIndex = $sIndex
EndFunc

Func _ownTabAllWhite($oSelf)
	For $i = 0 To $oSelf.itemsCount - 1
		If $i <> $oSelf.currentTab Then GUICtrlSetBkColor($oSelf.labelsID, 0xFFFFFF)
	Next
EndFunc

Func _ownTabAddGUI($oSelf, $hGUI)
	$oSelf.guiHandle = $hGUI
	Local $sSize = WinGetClientSize(WinGetHandle(HWnd($oSelf.guiHandle)))
	$oSelf.guiWidth = $sSize[0]
	$oSelf.guiHeight = $sSize[1]

	GUICtrlCreateGraphic(0, 0, $oSelf.guiWidth, 56)
	GUICtrlSetBkColor(-1, 0xFFFFFF)
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlCreateLabel("", 0, 56, $oSelf.guiWidth, 2, -1, $WS_EX_STATICEDGE)
EndFunc

Func _ownTabAddIcons($oSelf, $sIcons)
	Local $iColumnWidth = (($oSelf.guiWidth - $oSelf.itemsCount * $oSelf.elementWidth) / ($oSelf.itemsCount + 1))
	Local $iIDs[$oSelf.itemsCount]

	For $i = 0 To UBound($sIcons) -1
		$iIDs[$i] = GUICtrlCreatePic('', $iColumnWidth * ($i + 1) + ($oSelf.elementWidth * $i) + $oSelf.elementWidth * 32 / 100, 3, 32, 32)
		_SetBkIcon(-1, $sIcons[$i][0], $sIcons[$i][1], 32, 32)
	Next

	$oSelf.iconsID = $iIDs
EndFunc

Func _ownTabAddLabel($oSelf, $sLabels)
	Local $iColumnWidth = (($oSelf.guiWidth - $oSelf.itemsCount * $oSelf.elementWidth) / ($oSelf.itemsCount + 1))
	Local $iIDs[$oSelf.itemsCount]

	For $i = 0 To UBound($sLabels) -1
		$iIDs[$i] = GUICtrlCreateLabel(@CRLF & @CRLF & @CRLF & $sLabels[$i], $iColumnWidth * ($i + 1) + ($oSelf.elementWidth * $i), 0, $oSelf.elementWidth, 56, $SS_CENTER)
		GUICtrlSetBkColor(-1, 0xFFFFFF)
		GUICtrlSetCursor(-1, 0)
	Next

	GUICtrlSetBkColor($iIDs[$oSelf.currentTab], 0xC1D2EE)
	$oSelf.labelsID = $iIDs
EndFunc

Func _ownTabstartHover($oSelf, $sFunc, $iDelay = 20)
	AdlibRegister($sFunc, $iDelay)
EndFunc

Func _ownTabstopHover($oSelf, $sFunc)
	AdlibUnRegister($sFunc)
EndFunc

Func _SetBkIcon($BildID, $IconName, $IconID, $Width, $Height)
	$hIcon = _Icons_Icon_Extract($IconName, $IconID, $Width, $Height)
	$hBitmap = _Icons_Bitmap_CreateFromIcon($hIcon)
	_SetHImage($BildID, $hBitmap)
	_WinAPI_DeleteObject($hBitmap)
	_WinAPI_DestroyIcon($hIcon)
EndFunc   ;==>_SetBkIcon


























