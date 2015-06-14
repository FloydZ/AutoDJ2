
;XYFader.au3
Local $FaderCounter = 0
Local $Fader[4][20]

Func _CreateFader($iX, $iY, $iWidth, $iHeight, $minValue = 0, $MaxValue = 127)
	$hWnd = (GUICtrlCreateLabel("", $iX, $iY, $iWidth, $iHeight))
	
	$Fader[$FaderCounter][0] = _GDIPlus_GraphicsCreateFromHWND(GUICtrlGetHandle($hWnd)) ;$hGraphic
	$Fader[$FaderCounter][1] = _GDIPlus_BitmapCreateFromGraphics($iWidth, $iHeight, $Fader[$FaderCounter][0])
	$Fader[$FaderCounter][2] = _GDIPlus_ImageGetGraphicsContext($Fader[$FaderCounter][1])
	_GDIPlus_GraphicsSetSmoothingMode($Fader[$FaderCounter][2], 2)
	
	$Fader[$FaderCounter][3] = $hWnd
	$Fader[$FaderCounter][4] = $iWidth
	$Fader[$FaderCounter][5] = $iHeight
	$Fader[$FaderCounter][6] = $iX
	$Fader[$FaderCounter][7] = $iY
	
	$Fader[$FaderCounter][8] = 0;FaderValue
	
	$Fader[$FaderCounter][9] = 0;MeterValue Links
	$Fader[$FaderCounter][10] = 0;MeterValue Rechts
	
	_DrawFader($FaderCounter)
	
	$FaderCounter += 1
	;ConsoleWrite($FaderCounter)
	Return $hWnd
EndFunc

Func _DrawFader($z)
	_GDIPlus_GraphicsClear($Fader[$z][2], $iGUIColorBG)
	
	_GDIPlus_GraphicsFillRect($Fader[$z][2], 5, 5, 5, $Fader[$z][5] - 10, $Brush_Grau) ;Hintergrund Linker Balken
	_GDIPlus_GraphicsDrawRect($Fader[$z][2], 5, 5, 5, $Fader[$z][5] - 11, $Pen_Schwarz) ;Linker Balken Rand
	
	_GDIPlus_GraphicsFillRect($Fader[$z][2], $Fader[$z][4] - 11, 5, 5, $Fader[$z][5] - 10, $Brush_Grau) ;Hintergrund Rechter Balken
	_GDIPlus_GraphicsDrawRect($Fader[$z][2], $Fader[$z][4] - 11, 5, 5, $Fader[$z][5] - 11, $Pen_Schwarz) ;Rechter Balken Rand
	;Die sind alle in jeder richtung um 5 nach innen gerückt worden
	
	_GDIPlus_GraphicsFillRect($Fader[$z][2], 15, 0, $Fader[$z][4] - 31, $Fader[$z][5] - 1, $Brush_Schwarz) ;Mittlerer Schwarzer Balkenzz
	
	;Meter
	
	$Value = $Fader[$z][9] / 100 * $Fader[$z][5]
	_GDIPlus_GraphicsFillRect($Fader[$z][2], 18, $Fader[$z][5] - $Value, 5,  $Value, $Brush_Blau) ;Links
	$Value = $Fader[$z][10] / 100 * $Fader[$z][5]
	_GDIPlus_GraphicsFillRect($Fader[$z][2], 27, $Fader[$z][5] - $Value, 5, $Value, $Brush_Blau) ;Rechts
	;Strichellinie
	For $x = 6 To $Fader[$z][5] Step Round($Fader[$z][5] / 50, 1)
		_GDIPlus_GraphicsFillRect($Fader[$z][2], 17, $x, 5, 2, $Brush_Grau)
		_GDIPlus_GraphicsFillRect($Fader[$z][2], 27, $x, 5, 2, $Brush_Grau)
	Next
	
	$Fader[$z][8] = ((($aCursorInfo[1] - $Fader[$z][7]) / $Fader[$z][5]) * $Fader[$z][5])
	
	If $Fader[$z][8] < 8 Then $Fader[$z][8] = 8
	If $Fader[$z][8] > 172 Then $Fader[$z][8] = 172
	
	_GDIPlus_GraphicsFillRect($Fader[$z][2], 0, $Fader[$z][8] - 7.5, $Fader[$z][4], 15, $Brush_DunkelGrau) ;
	_GDIPlus_GraphicsDrawRect($Fader[$z][2], 0, $Fader[$z][8] - 7.5, $Fader[$z][4] - 1, 15, $Pen_Schwarz) ;
	
	_GDIPlus_GraphicsFillRect($Fader[$z][2], 5, $Fader[$z][8] - 1, $Fader[$z][4] - 10, 2, $Brush_Weis)
	
	_GDIPlus_GraphicsDrawImageRect($Fader[$z][0], $Fader[$z][1], 0, 0, $Fader[$z][4], $Fader[$z][5])
	
EndFunc ;==>_DrawFrame

Func _Fader_GetIdFromHandle($Handle)
	For $a = 0 to $FaderCounter - 1
		;ConsoleWrite("1:" & $Fader[$a][3] & "	,2:" & $Handle)
		If $Fader[$a][3] = ($Handle) Then Return $a
	Next
	Return -1
EndFunc

Func _Fader_GetValue($ID)
	Return 100 - (($Fader[$ID][8] / $Fader[$ID][5]) * 100)
EndFunc

Func _Fader_SetMeterValue($ID, $Value)
	;$Value Range 0-100
	
	;Links
	If $Value[0] > $Fader[$ID][9] Then $Fader[$ID][9] = $Value[0]
	$Fader[$ID][9] -= 2
	;Rechts
	If $Value[1] > $Fader[$ID][10] Then $Fader[$ID][10] = $Value[1]
	$Fader[$ID][10] -= 2
	
	_DrawFader($ID)
EndFunc
Func _Fader_DeleteALL()
	For $x = 0 to $FaderCounter - 1
		GUICtrlDelete($Fader[$x][3])
	Next
	
	$FaderCounter = 0
EndFunc
;Fader.au3
#cs
Local $FaderCounter = 0
Local $Fader[2][20]

Func _CreateFader($iX, $iY, $iWidth, $iHeight)
	$hWnd = GUICtrlGetHandle(GUICtrlCreateLabel("", $iX, $iY, $iWidth, $iHeight))

	$Fader[$FaderCounter][0] = _GDIPlus_GraphicsCreateFromHWND($hWnd) ;$hGraphic
	$Fader[$FaderCounter][1] = _GDIPlus_BitmapCreateFromGraphics($iWidth, $iHeight, $Fader[$FaderCounter][0] )
	$Fader[$FaderCounter][2] = _GDIPlus_ImageGetGraphicsContext($Fader[$FaderCounter][1])
	_GDIPlus_GraphicsSetSmoothingMode($Fader[$FaderCounter][2] , 2)
	_GDIPlus_GraphicsClear($Fader[$FaderCounter][2], $iGUIColorBG)

	$Fader[$FaderCounter][3] = $hWnd
	$Fader[$FaderCounter][4] = $iWidth
	$Fader[$FaderCounter][5] = $iHeight
	$Fader[$FaderCounter][6] = $iX
	$Fader[$FaderCounter][7] = $iY

	_GDIPlus_GraphicsFillRect($Fader[$FaderCounter][2], $iX + 5, $iY + 5, 5, $iHeight - 10 , $Brush_Grau);Hintergrund Linker Balken
	_GDIPlus_GraphicsDrawRect($Fader[$FaderCounter][2], $iX + 5, $iY + 5, 5, $iHeight - 11, $Pen_Schwarz);Linker Balken Rand

	_GDIPlus_GraphicsFillRect($Fader[$FaderCounter][2], $iX + $iWidth - 11, $iY + 5, 5, $iHeight - 10 , $Brush_Grau);Hintergrund Rechter Balken
	_GDIPlus_GraphicsDrawRect($Fader[$FaderCounter][2], $iX + $iWidth - 11, $iY + 5, 5, $iHeight - 11, $Pen_Schwarz);Rechter Balken Rand
	;Die sind alle in jeder richtung um 5 nach innen gerückt worden

	_GDIPlus_GraphicsFillRect($Fader[$FaderCounter][2], $iX + 15, $iY, $iWidth - 31 , $iHeight - 1, $Brush_Schwarz );Mittlerer Schwarzer Balkenzz

	;Strichellinie
	$Fader[$FaderCounter][8] = Round($iHeight / 50, 1)
	For $x = 6 To $iHeight Step $Fader[$FaderCounter][8]
		_GDIPlus_GraphicsFillRect($Fader[$FaderCounter][2], $iX + 17, $x, 5 , 2, $Brush_Grau)
		_GDIPlus_GraphicsFillRect($Fader[$FaderCounter][2], $iX + 27, $x, 5 , 2, $Brush_Grau)
	Next

	;Fader + ValueLinien
	$Fader[$FaderCounter][9]  = 50
	$Value = (($Fader[$FaderCounter][9] / 100) * $iHeight)

	;_GDIPlus_GraphicsFillRect($Fader[$FaderCounter][2], $iX + 17, $Value, 5 , $iHeight - $Value, $Brush_Orange)
	;_GDIPlus_GraphicsFillRect($Fader[$FaderCounter][2], $iX + 27, $Value, 5 , $iHeight - $Value, $Brush_Orange)

	_GDIPlus_GraphicsFillRect($Fader[$FaderCounter][2], 0, $Value - 7.5, $iWidth, 15, $Brush_DunkelGrau);Hintergrund Rechter Balken
	_GDIPlus_GraphicsDrawRect($Fader[$FaderCounter][2], 0, $Value - 7.5, $iWidth - 1, 15, $Pen_Schwarz);
	#cs
	;links
	_GDIPlus_GraphicsFillRect($Fader[$FaderCounter][2], 5, $Value - 7.5, 5, 15, $Brush_Weis)
	_GDIPlus_GraphicsDrawLine($Fader[$FaderCounter][2], 5, $Value - 7.5, 5, $Value + 7.5)
	_GDIPlus_GraphicsDrawLine($Fader[$FaderCounter][2], 10, $Value - 7.5, 10, $Value + 7.5)
	;rechts
	_GDIPlus_GraphicsFillRect($Fader[$FaderCounter][2], $iX + $iWidth - 11, $Value - 7.5, 5, 15, $Brush_Weis)
	_GDIPlus_GraphicsDrawLine($Fader[$FaderCounter][2], $iX + $iWidth - 11, $Value - 7.5, $iX + $iWidth - 11, $Value + 7.5)
	_GDIPlus_GraphicsDrawLine($Fader[$FaderCounter][2], $iX + $iWidth - 6, $Value - 7.5, $iX + $iWidth - 6, $Value + 7.5)
	#ce

	_GDIPlus_GraphicsFillRect($Fader[$FaderCounter][2], 5, $Value - 1,$iWidth - 10 , 2, $Brush_Weis)

	;_GDIPlus_GraphicsDrawRect($Fader[$FaderCounter][2], $iX, $iY, $iWidth - 1, $iHeight - 1, $Fader[$FaderCounter][9]);Haupt Rand

	AdlibRegister("_DrawFader", Round(1000 / $FPS))
	$FaderCounter += 1

	_GDIPlus_GraphicsDrawImageRect($Fader[$FaderCounter][0], $Fader[$FaderCounter][1], 0, 0, $iWidth, $iHeight)
	Return $hWnd
EndFunc

Func _DrawFader()
	If _IsPressed("01", $vU32Dll) Then
		$aCursorInfo = GUIGetCursorInfo($MainGUI)
		For $z = 0 To $FaderCounter - 1
			If GUICtrlGetHandle($aCursorInfo[4]) = $Fader[$z][3] Then

				_GDIPlus_GraphicsClear($Fader[$z][2], $iGUIColorBG)

				_GDIPlus_GraphicsFillRect($Fader[$z][2], $Fader[$z][6] + 5, $Fader[$z][7] + 5, 5, $Fader[$z][5] - 10 , $Brush_Grau);Hintergrund Linker Balken
				_GDIPlus_GraphicsDrawRect($Fader[$z][2], $Fader[$z][6] + 5, $Fader[$z][7] + 5, 5, $Fader[$z][5] - 11, $Pen_Schwarz);Linker Balken Rand

				_GDIPlus_GraphicsFillRect($Fader[$z][2], $Fader[$z][6] + $Fader[$z][4] - 11, $Fader[$z][7] + 5, 5, $Fader[$z][5] - 10 , $Brush_Grau);Hintergrund Rechter Balken
				_GDIPlus_GraphicsDrawRect($Fader[$z][2], $Fader[$z][6] + $Fader[$z][4] - 11, $Fader[$z][7]+ 5, 5, $Fader[$z][5] - 11, $Pen_Schwarz);Rechter Balken Rand
				;Die sind alle in jeder richtung um 5 nach innen gerückt worden

				_GDIPlus_GraphicsFillRect($Fader[$z][2], $Fader[$z][6] + 15, $Fader[$z][7], $Fader[$z][4] - 31 , $Fader[$z][5] - 1, $Brush_Schwarz );Mittlerer Schwarzer Balken
				;Strichellinie
				For $x = 6 To $Fader[$z][5] Step $Fader[$z][8]
					_GDIPlus_GraphicsFillRect($Fader[$z][2], $Fader[$z][6] + 17, $x, 5 , 2, $Brush_Grau)
					_GDIPlus_GraphicsFillRect($Fader[$z][2], $Fader[$z][6] + 27, $x, 5 , 2, $Brush_Grau)
				Next

				;Fader + ValueLinien
				$Value = $aCursorInfo[1] - $Fader[$z][7]
				$Fader[$z][9] = 100 - (($Value / $Fader[$z][5]) * 100)

				_GDIPlus_GraphicsFillRect($Fader[$z][2], 0, $Value - 7.5, $Fader[$z][4], 15, $Brush_DunkelGrau);Hintergrund Rechter Balken
				_GDIPlus_GraphicsDrawRect($Fader[$z][2], 0, $Value - 7.5, $Fader[$z][4] - 1, 15, $Pen_Schwarz);

				_GDIPlus_GraphicsFillRect($Fader[$z][2], 5, $Value - 1,$Fader[$z][4] - 10 , 2, $Brush_Weis)

				_GDIPlus_GraphicsDrawImageRect($Fader[$z][0], $Fader[$z][1], 0, 0, $Fader[$z][4], $Fader[$z][5])

			EndIf
		Next
	Endif
EndFunc ;==>_DrawFrame

Func _Fader_GetValue($Handle)
	For $x = 0 to $FaderCounter - 1
		If $Handle = $Fader[$x][3] Then
			Return $Fader[$x][9]
		EndIf
	Next
EndFunc

Func _Fader_SetValue($Handle, $Value)
	For $z = 0 to $FaderCounter - 1
		If $Handle = $Fader[$z][3] Then
				_GDIPlus_GraphicsClear($Fader[$z][2], $iGUIColorBG)

				_GDIPlus_GraphicsFillRect($Fader[$z][2], $Fader[$z][6] + 5, $Fader[$z][7] + 5, 5, $Fader[$z][5] - 10 , $Brush_Grau);Hintergrund Linker Balken
				_GDIPlus_GraphicsDrawRect($Fader[$z][2], $Fader[$z][6] + 5, $Fader[$z][7] + 5, 5, $Fader[$z][5] - 11, $Pen_Schwarz);Linker Balken Rand

				_GDIPlus_GraphicsFillRect($Fader[$z][2], $Fader[$z][6] + $Fader[$z][4] - 11, $Fader[$z][7] + 5, 5, $Fader[$z][5] - 10 , $Brush_Grau);Hintergrund Rechter Balken
				_GDIPlus_GraphicsDrawRect($Fader[$z][2], $Fader[$z][6] + $Fader[$z][4] - 11, $Fader[$z][7]+ 5, 5, $Fader[$z][5] - 11, $Pen_Schwarz);Rechter Balken Rand
				;Die sind alle in jeder richtung um 5 nach innen gerückt worden

				_GDIPlus_GraphicsFillRect($Fader[$z][2], $Fader[$z][6] + 15, $Fader[$z][7], $Fader[$z][4] - 31 , $Fader[$z][5] - 1, $Brush_Schwarz );Mittlerer Schwarzer Balken

				;Strichellinie
				For $x = 6 To $Fader[$z][5] Step $Fader[$z][8]
					_GDIPlus_GraphicsFillRect($Fader[$z][2], $Fader[$z][6] + 17, $x, 5 , 2, $Brush_Grau)
					_GDIPlus_GraphicsFillRect($Fader[$z][2], $Fader[$z][6] + 27, $x, 5 , 2, $Brush_Grau)
				Next

				;Fader + ValueLinien
				$Fader[$z][9] = $Value
				$Value =  $Fader[$z][5] - (($Fader[$z][9] / 100) * $Fader[$z][5])

				_GDIPlus_GraphicsFillRect($Fader[$z][2], 0, $Value - 7.5, $Fader[$z][4], 15, $Brush_DunkelGrau);Hintergrund Rechter Balken
				_GDIPlus_GraphicsDrawRect($Fader[$z][2], 0, $Value - 7.5, $Fader[$z][4] - 1, 15, $Pen_Schwarz);

				_GDIPlus_GraphicsFillRect($Fader[$z][2], 5, $Value - 1,$Fader[$z][4] - 10 , 2, $Brush_Weis)

				_GDIPlus_GraphicsDrawImageRect($Fader[$z][0], $Fader[$z][1], 0, 0, $Fader[$z][4], $Fader[$z][5])
		EndIf
	Next
EndFunc
#ce

