;XYPad.au3
Local $PadCounter = 0
Local $Pad[2][20]

Func _CreatePad($iX, $iY, $iWidth, $iHeight, $minValue = 0, $MaxValue = 127)
	$hWnd = (GUICtrlCreateLabel("", $iX, $iY, $iWidth, $iHeight))
	
	$Pad[$PadCounter][0] = _GDIPlus_GraphicsCreateFromHWND(GUICtrlGetHandle($hWnd)) ;$hGraphic
	$Pad[$PadCounter][1] = _GDIPlus_BitmapCreateFromGraphics($iWidth, $iHeight, $Pad[$PadCounter][0] )
	$Pad[$PadCounter][2] = _GDIPlus_ImageGetGraphicsContext($Pad[$PadCounter][1])
	_GDIPlus_GraphicsSetSmoothingMode($Pad[$PadCounter][2] , 2)
	
	$Pad[$PadCounter][3] = $hWnd
	$Pad[$PadCounter][4] = $iWidth
	$Pad[$PadCounter][5] = $iHeight
	$Pad[$PadCounter][6] = $iX
	$Pad[$PadCounter][7] = $iY
	
	$Pad[$PadCounter][10] = ($minValue + $maxValue) / 2;XValue
	$Pad[$PadCounter][11] = ($minValue + $maxValue) / 2;YValue
	
	$Pad[$PadCounter][12] = GUICtrlCreateLabel("X: " & $Pad[$PadCounter][10], $iX, $iY + $iHeight, 30, 15)
	$Pad[$PadCounter][13] = GUICtrlCreateLabel("Y: " & $Pad[$PadCounter][10], $iX + $iWidth - 30, $iY + $iHeight, 30, 15)
	
	$Pad[$PadCounter][14] = $minValue
	$Pad[$PadCounter][15] = $maxValue
	
	_DrawPad($PadCounter)

	$PadCounter += 1
	Return $hWnd
EndFunc

Func _DrawPad($z)
	$x = $aCursorInfo[0] - $Pad[$z][6]
	$y = $aCursorInfo[1] - $Pad[$z][7]
				
	$Pad[$z][10] = ($x / 200) *  ($Pad[$z][15])
	$Pad[$z][11] = Abs(($y / 100) *  ($Pad[$z][15]) - $Pad[$z][15])
				
	_GDIPlus_GraphicsClear($Pad[$z][2], $iGUIColorBG)
	_GDIPlus_GraphicsDrawRect($Pad[$z][2], 0, 0, $Pad[$z][4]- 1 , $Pad[$z][5]- 1, $Pen_Schwarz)
				
	_GDIPlus_GraphicsDrawLine($Pad[$z][2], $x, 0 , $x, $Pad[$z][5] - 1, $Pen_Orange)
	_GDIPlus_GraphicsDrawLine($Pad[$z][2], 0, $y, $Pad[$z][4] - 1, $y, $Pen_Orange)
				
	_GDIPlus_GraphicsDrawRect($Pad[$z][2], $aCursorInfo[0] - $Pad[$z][6]-5, $aCursorInfo[1] - $Pad[$z][7]-5, 10, 10, $Pen_Orange)
				
	_GDIPlus_GraphicsDrawImageRect($Pad[$z][0], $Pad[$z][1], 0, 0, $Pad[$z][4], $Pad[$z][5])
	
	GUICtrlSetData($Pad[$z][12], "X:" & Round($Pad[$z][10],0))
	GUICtrlSetData($Pad[$z][13], "Y:" & Round($Pad[$z][11],0))
EndFunc ;==>_DrawFrame

Func _Pad_GetIdFromHandle($Handle)
	For $a = 0 to $PadCounter - 1
		;ConsoleWrite("1:" & $Fader[$a][3] & "	,2:" & $Handle)
		If $Pad[$a][3] = ($Handle) Then Return $a
	Next
	Return -1
EndFunc

Func _Pad_GetValue($ID)
	Local $Array[2]
	$Array[0] = $Pad[$ID][10]
	$Array[1] = $Pad[$ID][11]
	Return $Array
EndFunc
