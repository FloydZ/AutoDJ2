
Func _new_installMakerGUI()
	Local $oInstallMakerGUI = _AutoItObject_Create()
	_AutoItObject_AddProperty($oInstallMakerGUI, 'guiHandle') ;Dont change var-name!!!
	_AutoItObject_AddProperty($oInstallMakerGUI, 'menu')




	_AutoItObject_AddMethod($oInstallMakerGUI, 'create', '_installMakerGUIcreate')
	_AutoItObject_AddMethod($oInstallMakerGUI, 'show', '_installMakerGUIshow')
	_AutoItObject_AddMethod($oInstallMakerGUI, 'guiSetOnEvent', '_installMakerGUIguiSetOnEvent')
	_AutoItObject_AddMethod($oInstallMakerGUI, 'getGUIHandle', '_installMakerGUIgetGUIHandle')


	Local $oMenu = _AutoItObject_Create()
	_AutoItObject_AddProperty($oMenu, 'create')
	_AutoItObject_AddProperty($oMenu, 'file')
	_AutoItObject_AddProperty($oMenu, 'info')
	_AutoItObject_AddProperty($oMenu, 'help')
	_AutoItObject_AddProperty($oMenu, 'item')

	$oInstallMakerGUI.menu = $oMenu

	Local $oMenuItem = _AutoItObject_Create()
	_AutoItObject_AddProperty($oMenuItem, 'createInstaller')
	_AutoItObject_AddProperty($oMenuItem, 'createInstallerIn')
	_AutoItObject_AddProperty($oMenuItem, 'openProject')
	_AutoItObject_AddProperty($oMenuItem, 'saveProject')
	_AutoItObject_AddProperty($oMenuItem, 'saveProjectIn')
	_AutoItObject_AddProperty($oMenuItem, 'closeProgram')
	_AutoItObject_AddProperty($oMenuItem, 'about')
	_AutoItObject_AddProperty($oMenuItem, 'help')

	$oInstallMakerGUI.menu.item = $oMenuItem

	Return $oInstallMakerGUI
EndFunc   ;==>LinkedList

Func _installMakerGUIgetGUIHandle($oSelf)
	Return $oSelf.guiHandle
EndFunc

Func _installMakerGUIcreate($oSelf)
	$oSelf.guiHandle = Number(GUICreate("DeepRed92's Install Builder v" & FileGetVersion(@ScriptFullPath), 828, 514))

	GUICtrlCreateMenu('')
	GUICtrlSetState(-1, $GUI_DISABLE)
	$oSelf.menu.create = GUICtrlCreateMenu('Erstelle Installer!')
	$oSelf.menu.item.createInstaller = GUICtrlCreateMenuItem('Erstelle Installer!', $oSelf.menu.create)
	GUICtrlCreateMenuItem('', $oSelf.menu.create)
	$oSelf.menu.item.createInstallerIn = GUICtrlCreateMenuItem('Erstelle Installer unter...', $oSelf.menu.create)
	GUICtrlCreateMenu('|')
	GUICtrlSetState(-1, $GUI_DISABLE)
	$oSelf.menu.file = GUICtrlCreateMenu('Datei')
	$oSelf.menu.item.openProject = GUICtrlCreateMenuItem('Projekt öffnen...', $oSelf.menu.file)
	$oSelf.menu.item.saveProject = GUICtrlCreateMenuItem('Projekt speichern', $oSelf.menu.file)
	$oSelf.menu.item.saveProjectIn = GUICtrlCreateMenuItem('Projekt speichern unter...', $oSelf.menu.file)
	GUICtrlCreateMenuItem('', $oSelf.menu.file)
	$oSelf.menu.item.closeProgram = GUICtrlCreateMenuItem('Beenden', $oSelf.menu.file)

	$oSelf.menu.info = GUICtrlCreateMenu('Info')
	$oSelf.menu.item.about = GUICtrlCreateMenuItem('Über das Programm...', $oSelf.menu.info)
	$oSelf.menu.help = GUICtrlCreateMenu('Hilfe')
	$oSelf.menu.item.help = GUICtrlCreateMenuItem('Hilfe' & @TAB & 'F1', $oSelf.menu.help)
EndFunc

Func _installMakerGUIshow($oSelf, $bShow = True)
	If $bShow Then
		GUISetState(@SW_SHOW, HWnd($oSelf.guiHandle))
	Else
		GUISetState(@SW_HIDE, HWnd($oSelf.guiHandle))
	EndIf
EndFunc

Func _installMakerGUIguiSetOnEvent($oSelf, $sID, $sFunc)
	GUISetOnEvent($sID, $sFunc, HWnd($oSelf.guiHandle))
EndFunc










