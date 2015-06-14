Local $Counter = 0
Local $Poti[100][40]

GUIRegisterMsg(0x004E, '_POTI_NOTIFY')
;Starting Mode = 0
;Starting Mode = Negative links wird gestartet
;Starting Mode = Positiv Rechts wird gestartet
Func _CreatePoti($iX, $iY, $iRadiusButton, $iRadiusPoint, $Name = "High", $minValue = -6, $MaxValue = 6, $StartingMode = 0,$innerValues = False, $PulseValue = False)
	$hWnd = (GUICtrlCreateLabel("", $iX, $iY, ($iRadiusButton * 2) + 2, ($iRadiusButton * 2) + 2))
	
	$Poti[$Counter][0] = _GDIPlus_GraphicsCreateFromHWND(GUICtrlGetHandle($hWnd)) ;$hGraphic
	$Poti[$Counter][1] = _GDIPlus_BitmapCreateFromGraphics(($iRadiusButton * 2) + 2, ($iRadiusButton * 2) + 2, $Poti[$Counter][0])
	$Poti[$Counter][2] = _GDIPlus_ImageGetGraphicsContext($Poti[$Counter][1])
	_GDIPlus_GraphicsSetSmoothingMode($Poti[$Counter][2], 2)
	
	$Poti[$Counter][3] = $iRadiusButton
	$Poti[$Counter][4] = $iRadiusPoint
	
	$Poti[$Counter][5] = _Vector_Create($iRadiusButton, $iRadiusButton) ;$vButton_Middle
	$Poti[$Counter][6] = _Vector_Create($iRadiusPoint, $iRadiusPoint) ;$vButton_Point
	
	$Poti[$Counter][7] = _Vector_Create(0, -1) ;$vNegativeYAxis
	$Poti[$Counter][8] = 0 ;$iAngle
	
	$Poti[$Counter][11] = $iX
	$Poti[$Counter][12] = $iY
	
	$Poti[$Counter][13] = $hWnd
	$Poti[$Counter][14] = $Counter
	
	;17 missing
	$Poti[$Counter][15] = $Name
	$Poti[$Counter][16] = $StartingMode
	$Poti[$Counter][18] = $minValue
	$Poti[$Counter][19] = $MaxValue

;Entweder Inner or Pulse Values	
	If $InnerValues = True Then
		If $PulseValue = True Then Return -1
		
		;3levels
		$Poti[$Counter][20] = "Inner"
		$Poti[$Counter][21] = 0 ;Level1 = Innen
		$Poti[$Counter][22] = 0 ;Level2 = Mitte
		$Poti[$Counter][23] = 0 ;Level3 = Außen
	Else
		$Poti[$Counter][20] = False
	Endif
	
	If $PulseValue = True Then
		If $InnerValues = True Then Return -1
		
		$Poti[$Counter][20] = "Pulse"
		$Poti[$Counter][21] = 0;Value des Pulse
		$Poti[$Counter][22] = _GDIPlus_BrushCreateSolid(0xFF7DDCE3) ;Brush
		
	Else
		$Poti[$Counter][20] = False
	EndIf
	
	_DrawPoti($Counter)
	$Counter += 1
	Return $hWnd
EndFunc


Func _DrawPoti($Z)
		
	If $bMouseClick Or _PointIsInCircle($aCursorInfo[0], $aCursorInfo[1], $Poti[$Z][11] + DllStructGetData($Poti[$Z][5], "X"), $Poti[$Z][12] + DllStructGetData($Poti[$Z][5], "Y"), $Poti[$Z][3]) Then
		$vDirection = _Vector_Normalize(_Vector_Create($aCursorInfo[0] - DllStructGetData($Poti[$Z][5], "X") - $Poti[$Z][11], $aCursorInfo[1] - DllStructGetData($Poti[$Z][5], "Y") - $Poti[$Z][12]))
			
		;DllStructSetData($Poti[$Z][6], "X", DllStructGetData($Poti[$Z][5], "X") + DllStructGetData($vDirection, "X") * $Poti[$Z][4])
		;DllStructSetData($Poti[$Z][6], "Y", DllStructGetData($Poti[$Z][5], "Y") + DllStructGetData($vDirection, "Y") * $Poti[$Z][4])
			

		$Poti[$Z][8] = _Vector_GetAngle($vDirection, $Poti[$Z][7])
		If $Poti[$Z][8] > 130 Then $Poti[$Z][8] = 130
		
		If DllStructGetData($vDirection, "X") < 0 Then $Poti[$Z][8] -= (2 * $Poti[$Z][8])
			
		$bMouseClick = True
	EndIf

	_GDIPlus_GraphicsClear($Poti[$Z][2], $iGUIColorBG)
	;Normaler weißer kreis
	_GDIPlus_GraphicsDrawEllipse($Poti[$Z][2], DllStructGetData($Poti[$Z][5], "X") - $Poti[$Z][3], DllStructGetData($Poti[$Z][5], "Y") - $Poti[$Z][3], $Poti[$Z][3] * 2, $Poti[$Z][3] * 2)
	If $Poti[$Z][20] = "Inner" Then
		_GDIPlus_GraphicsFillPie($Poti[$Z][2], 0, 0, ($Poti[$Z][3] * 2) - 1, ($Poti[$Z][3] * 2) - 1, 90, $Poti[$Z][23], $Brush_Grun) ;Außen
		_GDIPlus_GraphicsFillPie($Poti[$Z][2], ($Poti[$Z][3] * 1) / 3, ($Poti[$Z][3] * 1) / 3, ($Poti[$Z][3] * 4) / 3, ($Poti[$Z][3] * 4) / 3, 90, 360, $Brush_HellGrau) ;Korrektur
		
		_GDIPlus_GraphicsFillPie($Poti[$Z][2], ($Poti[$Z][3] * 1) / 3, ($Poti[$Z][3] * 1) / 3, ($Poti[$Z][3] * 4) / 3, ($Poti[$Z][3] * 4) / 3, 90, $Poti[$Z][22], $Brush_Gelb) ;mitte
		_GDIPlus_GraphicsFillPie($Poti[$Z][2], ($Poti[$Z][3] * 2) / 3, ($Poti[$Z][3] * 2) / 3, ($Poti[$Z][3] * 2) / 3, ($Poti[$Z][3] * 2) / 3, 90, 360, $Brush_HellGrau) ;Korrektur
		
		_GDIPlus_GraphicsFillPie($Poti[$Z][2], ($Poti[$Z][3] * 2) / 3, ($Poti[$Z][3] * 2) / 3, ($Poti[$Z][3] * 2) / 3, ($Poti[$Z][3] * 2) / 3, 90, $Poti[$Z][21], $Brush_Blau) ;Innen
	ElseIf $Poti[$Z][20] = "Pulse" Then
		_GDIPlus_GraphicsFillPie($Poti[$Z][2], $Poti[$Z][3] - ($Poti[$Z][21]/2) , $Poti[$Z][3] - ($Poti[$Z][21]/2) , $Poti[$Z][21], $Poti[$Z][21], 0, 360, $Poti[$Z][22]) ;Außen 
	Endif
	;ValueKreis
	If $Poti[$Z][16] = 0 Then
		_GDIPlus_GraphicsDrawPie($Poti[$Z][2], 0, 0, $Poti[$Z][3] * 2, $Poti[$Z][3] * 2, -90, $Poti[$Z][8], $Pen_Orange)
	ElseIf $Poti[$Z][16] < 0 Then
		_GDIPlus_GraphicsDrawPie($Poti[$Z][2], 0, 0, $Poti[$Z][3] * 2, $Poti[$Z][3] * 2, 140, $Poti[$Z][8] + 120, $Pen_Orange)
	EndIf
	;punkt
	;_GDIPlus_GraphicsFillEllipse($Poti[$Z][2], DllStructGetData($Poti[$Z][6], "X") - 3, DllStructGetData($Poti[$Z][6], "Y") - 3, 6, 6, $Brush_Orange)
	
	_GDIPlus_GraphicsDrawImageRect($Poti[$Z][0], $Poti[$Z][1], 0, 0, $Poti[$Z][3] * 2, $Poti[$Z][3] * 2)
	

EndFunc ;==>_DrawFrame


Func _Poti_GetIDfromHandle($Handle)
	For $x = 0 to $Counter - 1
		If $Poti[$x][13] = $Handle Then Return $x
	Next
	Return -1
EndFunc

Func _Poti_GetRightValue($ID)
Return 0
EndFunc

Func _Poti_SetInnerRingValue($ID, $NR, $Value)
	;ValueRange 0-1
	If $Poti[$ID][20] <> "Inner" Then Return -1
	$Value *= 360
	
	Switch $NR
		Case 0
			$Poti[$ID][21] = $Value
		Case 1
			$Poti[$ID][22] = $Value
		Case 2
			$Poti[$ID][23] = $Value
	EndSwitch
	_DrawPoti($ID)
EndFunc

Func _Poti_SetPulseRingValue($ID, $Value)
	;ValueRange 0-100
	If $Poti[$ID][20] <> "Pulse" Then Return -1
	
	$New = ($Value / 100) * $Poti[$ID][3] * 2
	If $New > $Poti[$ID][21] Then $Poti[$ID][21] = $New
	
	$Poti[$ID][21] -= 1.5
	
	_DrawPoti($ID)
EndFunc

Func _Poti_DeleteALL()
	For $x = 0 to $Counter - 1
		GUICtrlDelete($Poti[$x][13])
	Next

	$Counter = 0
EndFunc
	
Func _Vector_GetAngle($vVector1, $vVector2)
	$nScalarProduct = DllStructGetData($vVector1, "X") * DllStructGetData($vVector2, "X") + DllStructGetData($vVector1, "Y") * DllStructGetData($vVector2, "Y")
	$nVector1_Length = Sqrt(DllStructGetData($vVector1, "X") ^ 2 + DllStructGetData($vVector1, "Y") ^ 2)
	$nVector2_Length = Sqrt(DllStructGetData($vVector2, "X") ^ 2 + DllStructGetData($vVector2, "Y") ^ 2)
	
	Return ACos($nScalarProduct / ($nVector1_Length * $nVector2_Length)) / $Pi_Div_180
EndFunc ;==>_Vector_GetAngle

Func _Vector_Normalize($vNorm)
	Local $vReturn = DllStructCreate("float X;float Y")
	
	$nVectorLength = Sqrt(DllStructGetData($vNorm, "X") ^ 2 + DllStructGetData($vNorm, "Y") ^ 2)
	If $nVectorLength Then
		DllStructSetData($vReturn, "X", DllStructGetData($vNorm, "X") / $nVectorLength)
		DllStructSetData($vReturn, "Y", DllStructGetData($vNorm, "Y") / $nVectorLength)
	Else
		DllStructSetData($vReturn, "X", 0)
		DllStructSetData($vReturn, "Y", 0)
	EndIf
	
	Return $vReturn
EndFunc ;==>_Vector_Normalize

Func _Vector_Create($nXValue, $nYValue)
	Local $vReturn = DllStructCreate("float X;float Y")
	
	DllStructSetData($vReturn, "X", $nXValue)
	DllStructSetData($vReturn, "Y", $nYValue)
	
	Return $vReturn
EndFunc ;==>_Vector_Create

Func _PointIsInCircle($iX_Point, $iY_Point, $iX_Circle, $iY_Circle, $iRadius_Circle)
	$iDistPoints = _GetPointsDistance($iX_Point, $iY_Point, $iX_Circle, $iY_Circle)
	If ($iRadius_Circle > 0 And $iDistPoints < $iRadius_Circle) Or ($iRadius_Circle < 0 And $iDistPoints > $iRadius_Circle) Or $iDistPoints = 0 Then Return 1
	Return 0
EndFunc ;==>_PointIsInCircle

Func _GetPointsDistance($iPointX1, $iPointY1, $iPointX2, $iPointY2)
	Return Sqrt(($iPointX1 - $iPointX2) ^ 2 + ($iPointY1 - $iPointY2) ^ 2)
EndFunc ;==>_GetPointsDistance
