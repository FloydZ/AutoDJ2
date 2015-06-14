
Local $CrossCounter = 0
Local $Cross[2][20]


Func _CreateCrossFader($iX, $iY, $iWidth, $iHeight)
	$hWnd = (GUICtrlCreateLabel("", $iX, $iY, $iWidth, $iHeight))
	
	$Cross[$CrossCounter][0] = _GDIPlus_GraphicsCreateFromHWND(GUICtrlGetHandle($hWnd)) ;$hGraphic
	$Cross[$CrossCounter][1] = _GDIPlus_BitmapCreateFromGraphics($iWidth , $iHeight, $Cross[$CrossCounter][0])
	$Cross[$CrossCounter][2] = _GDIPlus_ImageGetGraphicsContext($Cross[$CrossCounter][1])
	_GDIPlus_GraphicsSetSmoothingMode($Cross[$CrossCounter][2], 2)
	_GDIPlus_GraphicsClear($Cross[$CrossCounter][2], $iGUIColorBG)
	
	$Cross[$CrossCounter][3] = $hWnd
	$Cross[$CrossCounter][4] = $iWidth
	$Cross[$CrossCounter][5] = $iHeight
	$Cross[$CrossCounter][6] = $iX
	$Cross[$CrossCounter][7] = $iY
	
	$Cross[$CrossCounter][8] = 100

	_DrawCross($CrossCounter)
	
	$CrossCounter += 1
	Return $hWnd
EndFunc

Func _DrawCross($z)
	
	_GDIPlus_GraphicsClear($Cross[$z][2], $iGUIColorBG)
	
	_GDIPlus_GraphicsFillRect($Cross[$z][2], 5, 5 , $Cross[$z][4] - 11, 5, $Brush_Grau);Oberer Grauer Balken
	_GDIPlus_GraphicsDrawRect($Cross[$z][2], 5, 5, $Cross[$z][4] - 11, 5, $Pen_Schwarz);Oberen Schwarzen Rand
	
	_GDIPlus_GraphicsFillRect($Cross[$z][2], 5, $Cross[$z][5] - 10 , $Cross[$z][4] - 11, 5, $Brush_Grau);Unteren Grauer Balken
	_GDIPlus_GraphicsDrawRect($Cross[$z][2], 5, $Cross[$z][5] - 10, $Cross[$z][4] - 11, 5, $Pen_Schwarz);Untere Schwarzen Rand

	_GDIPlus_GraphicsFillRect($Cross[$z][2], 0, 15 , $Cross[$z][4] , $Cross[$z][5] - 30, $Brush_Schwarz);Mittleren Grauen Balken
	

	;Fader
	$Cross[$z][8] = ((($aCursorInfo[0] - $Cross[$z][6]) / $Cross[$z][4]) * $Cross[$z][4]) -10
	;Linie Blau
	If $Cross[$z][8] < 0 Then $Cross[$z][8] = 0
	If $Cross[$z][8] > 179 Then $Cross[$z][8] = 179
	
	If ($Cross[$z][8] + 10) < 100 Then
		_GDIPlus_GraphicsFillRect($Cross[$z][2], $Cross[$z][8], 21, ($Cross[$z][4]/2) - $Cross[$z][8], 9, $Brush_Orange)
	ElseIf ($Cross[$z][8] + 10) > 100 Then
		_GDIPlus_GraphicsFillRect($Cross[$z][2], $Cross[$z][4]/2, 21, $Cross[$z][8] - ($Cross[$z][4] / 2), 9, $Brush_Orange)
	EndIf
	
	_GDIPlus_GraphicsFillRect($Cross[$z][2], $Cross[$z][8], 0, 20, $Cross[$z][5], $Brush_DunkelGrau);Hintergrund
	_GDIPlus_GraphicsDrawRect($Cross[$z][2], $Cross[$z][8], 0, 20, $Cross[$z][5] - 1, $Pen_Schwarz);Schwarzer Rand
	
	_GDIPlus_GraphicsFillRect($Cross[$z][2], $Cross[$z][8] + 9, 5, 2, $Cross[$z][5] - 10, $Brush_Weis)
	
	_GDIPlus_GraphicsDrawImageRect($Cross[$z][0], $Cross[$z][1], 0, 0, $Cross[$z][4], $Cross[$z][5])
	
	
EndFunc ;==>_DrawFrame

Func _Cross_GetIdFromHandle($Handle)
	For $a = 0 to $CrossCounter - 1
		If $Cross[$a][3] = ($Handle) Then Return $a
	Next
	Return -1
EndFunc

Func _Cross_GetValue($ID)
	Return 100 - ((($Cross[$ID][8]+10) / $Cross[$ID][4]) * 100)
EndFunc

Func _Cross_DeleteALL()
	For $x = 0 to $CrossCounter - 1
		GUICtrlDelete($Cross[$x][3])
	Next
	
	$CrossCounter = 0
EndFunc
	
