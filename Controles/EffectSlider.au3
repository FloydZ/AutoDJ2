Local $ESliderCounter = 0
Local $ESlider[4][20]

Func _CreateESlider($iX, $iY, $iWidth, $iHeight)
	$hWnd = (GUICtrlCreateLabel("", $iX, $iY, $iWidth, $iHeight))
	
	$ESlider[$ESliderCounter][0] = _GDIPlus_GraphicsCreateFromHWND(GUICtrlGetHandle($hWnd))
	$ESlider[$ESliderCounter][1] = _GDIPlus_BitmapCreateFromGraphics($iWidth, $iHeight, $ESlider[$ESliderCounter][0])
	$ESlider[$ESliderCounter][2] = _GDIPlus_ImageGetGraphicsContext($ESlider[$ESliderCounter][1])
	_GDIPlus_GraphicsSetSmoothingMode($ESlider[$ESliderCounter][2] , 2)
	
	$ESlider[$ESliderCounter][3] = $hWnd
	$ESlider[$ESliderCounter][4] = $iWidth
	$ESlider[$ESliderCounter][5] = $iHeight
	$ESlider[$ESliderCounter][6] = $iX
	$ESlider[$ESliderCounter][7] = $iY
	
	
	$ESlider[$ESliderCounter][8] = 0;Value
	
	_DrawESlider($ESliderCounter)
	$ESliderCounter += 1
	Return $hWnd
EndFunc

Func _DrawESlider($z)
	
	_GDIPlus_GraphicsClear($ESlider[$z][2], $iGUIColorBG)
	
	_GDIPlus_GraphicsFillRect($ESlider[$z][2], 0, 0, $ESlider[$z][4], $ESlider[$z][5] , $Brush_Schwarz);Hintergrund
				
	$Value = $aCursorInfo[0] - $ESlider[$z][6]
	$ESlider[$z][8] = ($Value / $ESlider[$z][4]) * 100
				
	_GDIPlus_GraphicsFillRect($ESlider[$z][2], 0, 0, $Value , $ESlider[$z][5] , $Brush_Grau);Ladebalken
	_GDIPlus_GraphicsFillRect($ESlider[$z][2], $Value - 5 , 0,  5 , $ESlider[$z][5] , $Brush_Weis);Slelection Balken
				
	_GDIPlus_GraphicsDrawRect($ESlider[$z][2], 0, 0, $ESlider[$z][4] - 1, $ESlider[$z][5] - 1, $Pen_Schwarz);Rand

	_GDIPlus_GraphicsDrawImageRect($ESlider[$z][0], $ESlider[$z][1], 0, 0, $ESlider[$z][4], $ESlider[$z][5])

EndFunc ;==>_DrawFrame

Func _ESlider_GetIdFromHandle($Handle)
	For $a = 0 to $ESliderCounter - 1
		;ConsoleWrite("1:" & $Fader[$a][3] & "	,2:" & $Handle)
		If $ESlider[$a][3] = ($Handle) Then Return $a
	Next
	Return -1
EndFunc

Func _ESlider_GetValue($ID)
	Return $ESlider[$ID][8]
EndFunc