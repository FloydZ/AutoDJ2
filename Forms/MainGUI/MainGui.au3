; -- Erstellt mit ISN Form Studio -- ;

$MainGUI = GUICreate("",1000,800,-1,-1)
GUISetBkColor(0x3C4041)
GUISetOnEvent($GUI_EVENT_CLOSE, "_Exit")

Global $FileMenu = GUICtrlCreateMenu("&File")
Global $FileMenu_Open = GUICtrlCreateMenu("Add", $FileMenu, 1)
Global $FileMenu_Open_File = GUICtrlCreateMenuItem("File", $FileMenu_Open)
GUICtrlSetOnEvent($FileMenu_Open_File ,"_AddFile2List")

$hTreeView = _GUICtrlTVExplorer_Create('',0,500,300,300, -1, $WS_EX_CLIENTEDGE, $TV_FLAG_SHOWLIKEEXPLORER + $TV_FLAG_SHOWFOLDERICON , '_TVEvent')
_GUICtrlTreeView_SetBkColor($hTreeView, 0x3C4041)
_GUICtrlTreeView_SetTextColor($hTreeView, 0x000000)

Global $hTreeView_DJ = _GUICtrlTreeView_Add($hTreeView, 1, "DJ")
Global $hTreeView_DJ_Music = _GUICtrlTreeView_AddChild($hTreeView, $hTreeView_DJ,"Music")
Global $hTreeView_DJ_Wiedergabenlisten = _GUICtrlTreeView_AddChild($hTreeView, $hTreeView_DJ, "Listen")
 
Global $hTreeView_iTunes = _GUICtrlTreeView_Add($hTreeView, 1, "iTunes")
_Scan_iTunes()

$hListView = Guictrlgethandle(GUICtrlCreatelistview("Status|Picture|Song Title|Artist|Length|BPM|Direction",300,550,700,250))
_GUICtrlListView_SetExtendedListViewStyle($hListView,BitOR($LVS_EX_SUBITEMIMAGES ,$LVS_EX_FULLROWSELECT))
_GUICtrlListView_SetBkColor($hListView, 0x3C4041)
_GUICtrlListView_SetTextBkColor($hListView, 0x3C4041)
_GUICtrlListView_SetTextColor($hListView, 0x000000)

GUISetState(@SW_SHOW,$MainGUI)

_CreateDecks()


Func _CreateDecks()
;Oben==================================================================================
	$Label[9] = GUICtrlCreateLabel("",438,0  ,2   ,50 ,$SS_BLACKRECT)
	$Label[10] = GUICtrlCreateLabel("",562,0  ,2   ,50 ,$SS_BLACKRECT)
	
	$Label[12] = GUICtrlCreateLabel("MAIN",489,0 ,50   ,15)
	GUICtrlSetColor(-1, 0x7DDCE3)
	GUICtrlSetFont(-1 , Default, 1.5)
	
	$Label[13] = GUICtrlCreateLabel("CTRL",440,15 ,50   ,15)
	;GUICtrlSetColor(-1, 0x7DDCE3)
	GUICtrlSetFont(-1 , Default, 1.5)

	$Label[14] = GUICtrlCreateLabel("AUDIO",440,30 ,50   ,15)
	;GUICtrlSetColor(-1, 0x7DDCE3)
	GUICtrlSetFont(-1 , Default, 1.5)
		
;Mitte=================================================================================
	$Label[0] = GUICtrlCreateLabel("",500,50 ,1   ,250,$SS_GRAYFRAME)
	$Label[1] = GUICtrlCreateLabel("",0  ,300,1000,1  ,$SS_GRAYFRAME)
	$Label[2] = GUICtrlCreateLabel("",0  ,500,1000,1  ,$SS_GRAYFRAME)
	_CreateCrossFader(400, 310, 200, 50)


;Links=================================================================================
	;EffektSektion
	$Label[3] = GUICtrlCreateLabel("FX:",10, 15,40,15);Obern

	
	;Schwarze Balken zwischen den Potis
	$Label[4] = GUICtrlCreateLabel("",380,50,120,2   ,$SS_BLACKRECT);Obern
	$Label[5] = GUICtrlCreateLabel("",380,248,120,2   ,$SS_BLACKRECT);Unten
	$Label[6] = GUICtrlCreateLabel("",438,50,2,200   ,$SS_BLACKRECT);Mitte

	$Label[7] = GUICtrlCreateLabel("",438,50,2,200   ,$SS_BLACKRECT);Mitte


	;Großes Label für das Spektrometer.
	$Label[8] = GUICtrlCreateLabel("",0,50,380,200,$SS_GRAYFRAME)
	_CreateFader(445,60 ,50,180)
	_CreatePoti (389,60 ,20,20 ,"High")
	_CreatePoti (389,122,20,20 ,"Mid" )
	_CreatePoti (389,185,20,20 ,"Low" )

;Rechts===================================================================================
	$Label[11] = GUICtrlCreateLabel("",500,50 ,120   ,2 ,$SS_BLACKRECT)
EndFunc

Func _DeleteDecks()
	For $x = 0 to UBound($Label) - 1
		GUICtrlDelete($Label[$x])
	Next
	_Fader_DeleteALL()
	_Cross_DeleteALL()
	_Poti_DeleteALL()
EndFunc

Func _Exit()
	;ProcessClose("AutoDJ_Bass.exe")
	Exit
EndFunc