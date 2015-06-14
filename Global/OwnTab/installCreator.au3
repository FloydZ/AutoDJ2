#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=images\icons\Sys-Installer.ico
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_Res_Description=Erstelle deinen eigenen Installer!
#AutoIt3Wrapper_Res_Fileversion=1.0.0.3
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=y
#AutoIt3Wrapper_Res_LegalCopyright=Copyright © 2012 Burak Keskin
#AutoIt3Wrapper_Res_requestedExecutionLevel=asInvoker
#AutoIt3Wrapper_Res_Field=E-Mail|burak.keskin@freenet.de
#AutoIt3Wrapper_Res_Field=CompanyName|
#AutoIt3Wrapper_Res_Field=InternalName|DeepRed92's Install Creator
#AutoIt3Wrapper_Res_Field=Comments|
#AutoIt3Wrapper_Res_Field=OriginalFilename|installCreator.exe
#AutoIt3Wrapper_Res_Field=ProductName|DeepRed92's Install Creator
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#cs ----------------------------------------------------------------------------

	AutoIt Version: 3.3.8.1
	Author:         myName

	Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

#include <WinAPI.au3>
#include <Array.au3>
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <ListViewConstants.au3>
#include <GuiMenu.au3>

#include <class\installmakergui.au3>
#include <class\owntab.au3>
#include <include\icons.au3>


Opt("GUIOnEventMode", 1)

Local Const $ScriptDir = @ScriptDir
;~ Local Const $pColor = 0xEFEFFF
Local Const $pColor = 0xDFDFEF

;InstallMakerGUI-Objekt erzeugen
Local $insmakGUI = _new_installMakerGUI()
$insmakGUI.create()
$insmakGUI.guiSetOnEvent($GUI_EVENT_CLOSE, '_Exit')


#region Tab
;Tab-Objekt erzeugen
Local $ownTab = _new_ownTab()
$ownTab.addGUI($insmakGUI.getGUIHandle())

;Anzahl der Menuitems festlegen (Tabs)
$ownTab.setItemCount(7)

;Labelbeschriftung festlegen
Local $sLabels[7] = ['Allgemein', 'Dateien', 'Oberfläche', 'Registry', 'Sonstige', 'Uninstaller', 'Sonstige']
$ownTab.addLabels($sLabels)

;Iconpfade festlegen + ID
Local $sIcons[7][2] = [['shell32.dll', -22],['shell32.dll', 54],['shell32.dll', 98],['regedit.exe', 1],['shell32.dll', -3],['shell32.dll', -28],['shell32.dll', -3]]
$ownTab.addIcons($sIcons)

;Seitenhandles hinzufügen; True = show
Local $pageHandles[7] = [_cP_Generally(True), _cP_Files(), _cP_Surface(), _cP_Registry(), _cP_MiscI(), _cP_Uninstaller(), _cP_MiscU()]
$ownTab.addPages($pageHandles)
;Events hinzufügen
Local $sEvents[7] = ['_tabGenerally', '_tabFiles', '_tabSurface', '_tabRegistry', '_tabMiscI', '_tabUninstaller', '_tabMiscU']
$ownTab.addEvents($sEvents)

;Hover-Funktion aktivieren
;~ $ownTab.startHover('_HoverFunc') ;Nicht implementiert bzw. fertig!
#endregion Tab




;GUI anzeigen
$insmakGUI.show()

While 1
	Sleep(50)
WEnd


#region TabPages
Func _cP_Generally($bShow = False)
	Local $hGenerally = GUICreate('Generally', 828, 436, 0, 58, $WS_CHILD, -1, HWnd($insmakGUI.getGUIHandle()))
	GUISetBkColor($pColor)
	GUICtrlCreateGroup("", 8, 8, 433, 49)
	GUICtrlCreateLabel("Erstellen unter:", 16, 24, 74, 17)
	$inptPath2Installer = GUICtrlCreateInput("", 104, 24, 297, 21)
	$btnSelPath2Installer = GUICtrlCreateButton("...", 408, 24, 27, 25)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	GUICtrlCreateGroup("", 8, 64, 433, 361)
	GUICtrlCreateLabel("Icon:", 16, 88, 28, 17)
	$inptPath2Icon = GUICtrlCreateInput("", 80, 80, 321, 21)
	$btnSelPath2Icon = GUICtrlCreateButton("...", 408, 80, 27, 25)
	GUICtrlCreateLabel("Typ:", 16, 136, 25, 17)
	$radio32 = GUICtrlCreateRadio("32 Bit", 80, 136, 65, 17)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$radio64 = GUICtrlCreateRadio("64 Bit", 176, 136, 57, 17)
	GUIStartGroup()
	GUICtrlCreateLabel("Upx:", 16, 160, 26, 17)
	$radioUpxYes = GUICtrlCreateRadio("Ja", 80, 160, 49, 17)
	$radioUpxNo = GUICtrlCreateRadio("Nein", 176, 160, 57, 17)
	GUICtrlSetState(-1, $GUI_CHECKED)
	GUIStartGroup()
	$comboCompressLvl = GUICtrlCreateCombo("", 400, 155, 33, 25, BitOR($CBS_DROPDOWN, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, "1|2|3|4|5", "3")
	GUICtrlCreateLabel("Kompression:", 328, 160, 67, 17)
	GUICtrlCreateLabel("", 16, 184, 412, 2, -1, $WS_EX_STATICEDGE)
	$inptComment = GUICtrlCreateInput("", 112, 200, 321, 21)
	GUICtrlCreateLabel("Kommentar:", 16, 200, 60, 17)
	GUICtrlCreateLabel("Beschreibung:", 16, 240, 72, 17)
	$inptDescription = GUICtrlCreateInput("", 112, 240, 321, 21)
	GUICtrlCreateLabel("Dateiversion:", 16, 280, 66, 17)
	$inptFileVersion = GUICtrlCreateInput("", 112, 280, 321, 21)
	GUICtrlCreateLabel("Copyright:", 16, 320, 51, 17)
	$inptCopyRight = GUICtrlCreateInput("", 112, 320, 321, 21)
	GUICtrlCreateLabel("Sprache:", 16, 360, 47, 17)
	$comboLang = GUICtrlCreateCombo("", 112, 360, 321, 25, BitOR($CBS_DROPDOWN, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, "German")
	GUICtrlCreateLabel("Ausführungslevel:", 16, 400, 88, 17)
	$radioExNone = GUICtrlCreateRadio("Keine", 112, 400, 65, 17)
	$radioExHighest = GUICtrlCreateRadio("Höchster Verfügbarer", 192, 400, 129, 17)
	$radioExAdmin = GUICtrlCreateRadio("Administrator", 344, 400, 89, 17)
	GUICtrlSetState(-1, $GUI_CHECKED)
	GUIStartGroup()
	GUICtrlCreateLabel("Installertyp:", 16, 112, 57, 17)
	$radioTypeInstaller = GUICtrlCreateRadio("Installer", 80, 112, 65, 17)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$readioTypePortable = GUICtrlCreateRadio("Portable", 176, 112, 73, 17)
	$radioTypeSel = GUICtrlCreateRadio("Auswählbar", 280, 112, 97, 17)
	GUIStartGroup()
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	GUICtrlCreateGroup("", 448, 8, 369, 417)
	$inptEMail = GUICtrlCreateInput("", 568, 24, 241, 21)
	GUICtrlCreateLabel("E-Mail:", 456, 24, 36, 17)
	GUICtrlCreateLabel("Firmen Name:", 456, 56, 69, 17)
	$inptFirmName = GUICtrlCreateInput("", 568, 56, 241, 21)
	GUICtrlCreateLabel("Interner Name", 456, 88, 71, 17)
	$inptIntName = GUICtrlCreateInput("", 568, 88, 241, 21)
	GUICtrlCreateLabel("Originaler Dateiname:", 456, 120, 105, 17)
	$inptOrigFileName = GUICtrlCreateInput("", 568, 120, 241, 21)
	GUICtrlCreateLabel("Produktname:", 456, 152, 70, 17)
	$inptProdName = GUICtrlCreateInput("", 568, 152, 241, 21)
	GUICtrlCreateLabel("Benutzerdefinierte Ressource-Felder:", 456, 192, 178, 17)
	$editUserDefRes = GUICtrlCreateEdit("", 456, 216, 353, 201, BitOR($ES_AUTOVSCROLL, $ES_AUTOHSCROLL, $ES_WANTRETURN, $WS_VSCROLL))
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	If $bShow Then GUISetState(@SW_SHOW)
	Return Number($hGenerally)
EndFunc   ;==>_cP_Generally

Func _cP_Files($bShow = False)
	Local $hFiles = GUICreate('Files', 828, 436, 0, 58, $WS_CHILD, -1, HWnd($insmakGUI.getGUIHandle()))
	GUISetBkColor($pColor)
	GUICtrlCreateGroup("", 8, 8, 481, 49)
	GUICtrlCreateLabel("Installationsverzeichnis:", 16, 28, 115, 17)
	$inptInstallPath = GUICtrlCreateInput("", 144, 24, 305, 21)
	$btnInstallPath = GUICtrlCreateButton("...", 456, 24, 27, 25)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	GUICtrlCreateGroup("", 8, 64, 809, 361)
	GUICtrlCreateLabel("Sie können einzelne Dateien, Ordner oder fertig gepackte Dateien hinzufügen. Einfach per Drag & Drop!", 16, 80, 495, 17)
	$listViewFiles = GUICtrlCreateListView("Dateiname|Typ|Dateigröße|Dateipfad", 16, 104, 794, 310)
	GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 0, 150)
	GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 1, 50)
	GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 2, 100)
	GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 3, 470)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	GUICtrlCreateGroup("", 496, 8, 321, 49)
	GUICtrlCreateLabel("Installationsverzeichnis veränderbar?", 504, 28, 178, 17)
	$radioChangeInstPathYes = GUICtrlCreateRadio("Ja", 688, 24, 41, 17)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$radioChangeInstallPathNo = GUICtrlCreateRadio("Nein", 760, 24, 49, 17)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	If $bShow Then GUISetState(@SW_SHOW)
	Return Number($hFiles)
EndFunc   ;==>_cP_Files

Func _cP_Surface($bShow = False)
	Local $hSurface = GUICreate('Surface', 828, 436, 0, 58, $WS_CHILD, -1, HWnd($insmakGUI.getGUIHandle()))
	GUISetBkColor($pColor)
	GUICtrlCreateGroup("Seiten - Installer", 8, 8, 249, 121)
	$chkWelcome = GUICtrlCreateCheckbox("Willkommen", 16, 32, 113, 17)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$chkLicence = GUICtrlCreateCheckbox("Lizenz", 16, 56, 113, 17)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$chkInstallFolder = GUICtrlCreateCheckbox("Installationsordner", 16, 80, 113, 17)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$chkInstall = GUICtrlCreateCheckbox("Installation", 16, 104, 113, 17)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$chkHints = GUICtrlCreateCheckbox("Hinweise", 152, 32, 97, 17)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$chkFinish = GUICtrlCreateCheckbox("Abgeschlossen", 152, 56, 97, 17)
	GUICtrlSetState(-1, $GUI_CHECKED)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	GUICtrlCreateGroup("Bilder", 264, 8, 553, 121)
	GUICtrlCreateLabel("Willkommens Bild:", 272, 32, 89, 17)
	$inptWelcomeImage = GUICtrlCreateInput("", 384, 32, 361, 21)
	$btnWelcomeImage = GUICtrlCreateButton("...", 752, 32, 27, 25)
	GUICtrlCreateLabel("Abgeschlossen Bild:", 272, 64, 99, 17)
	$inptFinishImage = GUICtrlCreateInput("", 384, 64, 361, 21)
	$btnFinishImage = GUICtrlCreateButton("...", 752, 64, 27, 25)
	GUICtrlCreateLabel("Kopfzeilen Icon:", 272, 96, 80, 17)
	$inptHeaderImage = GUICtrlCreateInput("", 384, 96, 361, 21)
	$btnHeaderImage = GUICtrlCreateButton("...", 752, 96, 27, 25)
	GUICtrlCreateIcon($ScriptDir & "\images\icons\Info.ico", -1, 792, 32, 16, 16)
	GUICtrlCreateIcon($ScriptDir & "\images\icons\Info.ico", -1, 792, 64, 16, 16)
	GUICtrlCreateIcon($ScriptDir & "\images\icons\Info.ico", -1, 792, 96, 16, 16)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	GUICtrlCreateGroup("Text verändern", 8, 136, 809, 289)
	$listViewChangeText = GUICtrlCreateListView("Feld", 16, 160, 386, 254)
	GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 0, 360)
	$editChangeText = GUICtrlCreateEdit("", 408, 160, 393, 225, BitOR($ES_AUTOVSCROLL, $ES_AUTOHSCROLL, $ES_WANTRETURN, $WS_VSCROLL))
	$btnChangeText = GUICtrlCreateButton("Speichern", 416, 392, 75, 25)
	$btnResetText = GUICtrlCreateButton("Feld zurücksetzen", 504, 392, 99, 25)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	If $bShow Then GUISetState(@SW_SHOW)
	Return Number($hSurface)
EndFunc   ;==>_cP_Surface

Func _cP_Registry($bShow = False)
	Local $hRegistry = GUICreate('Registry', 828, 436, 0, 58, $WS_CHILD, -1, HWnd($insmakGUI.getGUIHandle()))
	GUISetBkColor($pColor)
	GUICtrlCreateGroup("Registryeinträge", 8, 8, 809, 417)
	$listViewRegistry = GUICtrlCreateListView("", 16, 32, 794, 350)
	$btnRegistry = GUICtrlCreateButton("Hinzufügen", 704, 392, 75, 25)
	GUICtrlCreateLabel("Eintrag:", 16, 392, 40, 17)
	$inptRegistry = GUICtrlCreateInput("", 64, 392, 529, 21)
	$comboRegistry = GUICtrlCreateCombo("", 600, 392, 97, 25, BitOR($CBS_DROPDOWN, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, 'Hinzufügen|Löschen', 'Hinzufügen')
	GUICtrlCreateIcon($ScriptDir & "\images\icons\Info.ico", -1, 792, 392, 16, 16)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	If $bShow Then GUISetState(@SW_SHOW)
	Return Number($hRegistry)
EndFunc   ;==>_cP_Registry

Func _cP_MiscI($bShow = False)
	Local $hMiscI = GUICreate('MiscI', 828, 436, 0, 58, $WS_CHILD, -1, HWnd($insmakGUI.getGUIHandle()))
	GUISetBkColor($pColor)
	GUICtrlCreateGroup("RTF-Dateien", 8, 8, 809, 81)
	GUICtrlCreateLabel("Lizenzdatei:", 16, 32, 60, 17)
	GUICtrlCreateLabel("Hinweisdatei:", 16, 64, 67, 17)
	$inptLicenceFile = GUICtrlCreateInput("", 96, 24, 673, 21)
	$btnLicenceFile = GUICtrlCreateButton("...", 776, 24, 27, 25)
	$inptHintFile = GUICtrlCreateInput("", 96, 56, 673, 21)
	$btnHintFile = GUICtrlCreateButton("...", 776, 56, 27, 25)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	GUICtrlCreateGroup("Code ausführen", 8, 96, 809, 329)
	$listViewExCode = GUICtrlCreateListView("Seite", 16, 120, 306, 262)
	GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 0, 300)
	GUICtrlCreateLabel("Wann ausführen?", 336, 120, 89, 17)
	$comboExBefAf = GUICtrlCreateCombo("", 440, 116, 145, 25, BitOR($CBS_DROPDOWN, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, 'Vorher|Nachher', "Vorher")
	GUICtrlCreateLabel("", 336, 144, 460, 2, -1, $WS_EX_STATICEDGE)
	$editExCode = GUICtrlCreateEdit("", 328, 160, 473, 257, BitOR($ES_AUTOVSCROLL, $ES_AUTOHSCROLL, $ES_WANTRETURN, $WS_VSCROLL))
	GUICtrlSetData(-1, "")
	$btnSaveCode = GUICtrlCreateButton("Speichern", 16, 392, 75, 25)
	$btnDelCode = GUICtrlCreateButton("Löschen", 96, 392, 75, 25)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	If $bShow Then GUISetState(@SW_SHOW)
	Return Number($hMiscI)
EndFunc   ;==>_cP_MiscI

Func _cP_Uninstaller($bShow = False)
	Local $hUninstaller = GUICreate('Uninstaller', 828, 436, 0, 58, $WS_CHILD, -1, HWnd($insmakGUI.getGUIHandle()))
	GUISetBkColor($pColor)
	GUICtrlCreateGroup("Seiten - Uninstaller", 8, 8, 113, 121)
	$chkWelcomeU = GUICtrlCreateCheckbox("Willkommen", 16, 32, 97, 17)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$chkUninstall = GUICtrlCreateCheckbox("Deinstallation", 16, 56, 97, 17)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$chkHintsU = GUICtrlCreateCheckbox("Hinweise", 16, 80, 97, 17)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$chkFinishU = GUICtrlCreateCheckbox("Abgeschlossen", 16, 104, 97, 17)
	GUICtrlSetState(-1, $GUI_CHECKED)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	GUICtrlCreateGroup("Bilder", 128, 8, 689, 121)
	GUICtrlCreateLabel("Willkommens Bild:", 136, 32, 89, 17)
	GUICtrlCreateLabel("Abgeschlossen Bild:", 136, 64, 99, 17)
	GUICtrlCreateLabel("Kopfzeilen Icon:", 136, 96, 80, 17)
	$inptWelcomeImageU = GUICtrlCreateInput("", 248, 32, 497, 21)
	$inptFinishImageU = GUICtrlCreateInput("", 248, 64, 497, 21)
	$inptHeaderImageU = GUICtrlCreateInput("", 248, 96, 497, 21)
	$btnWelcomeImageU = GUICtrlCreateButton("...", 752, 32, 27, 25)
	$btnFinishImageU = GUICtrlCreateButton("...", 752, 64, 27, 25)
	$btnHeaderImageU = GUICtrlCreateButton("..", 752, 96, 27, 25)
	GUICtrlCreateIcon($ScriptDir & "\images\icons\Info.ico", -1, 792, 32, 16, 16)
	GUICtrlCreateIcon($ScriptDir & "\images\icons\Info.ico", -1, 792, 64, 16, 16)
	GUICtrlCreateIcon($ScriptDir & "\images\icons\Info.ico", -1, 792, 96, 16, 16)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	GUICtrlCreateGroup("Text verändern", 8, 136, 809, 289)
	$listViewChangeTextU = GUICtrlCreateListView("", 16, 160, 386, 254)
	$btnChangeTextU = GUICtrlCreateButton("Speichern", 416, 392, 75, 25)
	$btnResetTextU = GUICtrlCreateButton("Feld zurücksetzen", 504, 392, 99, 25)
	$editChangeTextU = GUICtrlCreateEdit("", 408, 160, 393, 225, BitOR($ES_AUTOVSCROLL, $ES_AUTOHSCROLL, $ES_WANTRETURN, $WS_VSCROLL))
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	If $bShow Then GUISetState(@SW_SHOW)
	Return Number($hUninstaller)
EndFunc   ;==>_cP_Uninstaller

Func _cP_MiscU($bShow = False)
	Local $hMiscU = GUICreate('MiscU', 828, 436, 0, 58, $WS_CHILD, -1, HWnd($insmakGUI.getGUIHandle()))
	GUISetBkColor($pColor)
	GUICtrlCreateGroup("RTF-Dateien", 8, 8, 809, 49)
	GUICtrlCreateLabel("Hinweisdatei:", 16, 32, 67, 17)
	$inptHintFileU = GUICtrlCreateInput("", 96, 24, 673, 21)
	$btnHintFileU = GUICtrlCreateButton("...", 776, 24, 27, 25)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	GUICtrlCreateGroup("Code ausführen", 8, 64, 809, 361)
	$listViewExCodeU = GUICtrlCreateListView("Seite", 16, 88, 306, 294)
	GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 0, 300)
	GUICtrlCreateLabel("Wann ausführen?", 336, 88, 89, 17)
	$comboExBefAfU = GUICtrlCreateCombo("", 440, 84, 145, 25, BitOR($CBS_DROPDOWN, $CBS_AUTOHSCROLL))
	GUICtrlCreateLabel("", 340, 112, 444, 2, -1, $WS_EX_STATICEDGE)
	$editExCodeU = GUICtrlCreateEdit("", 328, 128, 473, 289, BitOR($ES_AUTOVSCROLL, $ES_AUTOHSCROLL, $ES_WANTRETURN, $WS_VSCROLL))
	GUICtrlSetData(-1, "")
	$btnSaveCodeU = GUICtrlCreateButton("Speichern", 16, 392, 75, 25)
	$btnDelCodeU = GUICtrlCreateButton("Löschen", 96, 392, 75, 25)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	If $bShow Then GUISetState(@SW_SHOW)
	Return Number($hMiscU)
EndFunc   ;==>_cP_MiscU
#endregion TabPages

#region Tabs
Func _tabGenerally()
	$ownTab.tabSwitch(0)
EndFunc   ;==>_tabGenerally

Func _tabFiles()
	$ownTab.tabSwitch(1)
EndFunc   ;==>_tabFiles

Func _tabSurface()
	$ownTab.tabSwitch(2)
EndFunc   ;==>_tabSurface

Func _tabRegistry()
	$ownTab.tabSwitch(3)
EndFunc   ;==>_tabRegistry

Func _tabMiscI()
	$ownTab.tabSwitch(4)
EndFunc   ;==>_tabMiscI

Func _tabUninstaller()
	$ownTab.tabSwitch(5)
EndFunc   ;==>_tabUninstaller

Func _tabMiscU()
	$ownTab.tabSwitch(6)
EndFunc   ;==>_tabMiscU
#endregion Tabs


Func _closeProgram()
	GUIDelete(HWnd($insmakGUI.getGUIHandle()))
	Exit
EndFunc   ;==>_closeProgram

Func _HoverFunc()
	$ownTab.hoverFunc()
EndFunc   ;==>_HoverFunc
