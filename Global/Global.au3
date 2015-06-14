#include <AutoItObject.au3>
#include <GUIConstantsEx.au3>
#include <GuiImageList.au3>
#include <GuiTreeView.au3>
#include <StructureConstants.au3>
#include <TreeViewConstants.au3>
#include <WindowsConstants.au3>
#include <GuiListView.au3>
#include <Array.au3>
#include <GDIPlus.au3>
#include <GUIConstants.au3>
#include <Misc.au3>
#include <Color.au3>
#include <EditConstants.au3>
#include <StaticConstants.au3>
#include <File.au3>
#include <GuiComboBox.au3>
#include <ComboConstants.au3>
#include <icons.au3>
#include <Bass.au3>
#include <BassTAGS.au3>
#include <_XMLDomWrapper.au3>





;#include <GDIP.au3>
_GDIPlus_Startup()
_BASS_Startup()
_Bass_Tags_Startup()

Global $OptionFile = @scriptDir & "\Global\Options.ini" ;option
Global $MusicList = @scriptDir & "\Global\List.ini"
Global $MainGUI ;Main

Global $MODE = 1
;Music = Normaler Music Mode = 0
;DJ    = DJ Mode mit decks   = 1
;DJ2   = TreeviewMode        = 2



;DJ View
Global $hTreeView ;Treeview zum Ordner Browsen
Global $hListView ;Listview zum Datei Browsen
Global $ListViewButton[11] ; Die Buttons über dem Listview

Global $Label[20]

;Alles für den Explorer
Global $Old_Direction = "" ; Die alte direction gezeigt im treeview.
Global $CheckFlag = 0;Aus irgendeinem Grund wird bei einem click das event zweimal abgefeuert.



Global Const $Pi_Div_180 = ACos(-1) / 180
Global $vU32Dll = DllOpen("User32.dll")

;Brushes and Pens
Global $Brush_Grau = _GDIPlus_BrushCreateSolid(0xFF5E5E5E) ;Grau
Global $Brush_Schwarz = _GDIPlus_BrushCreateSolid(0xFF000000) ;Schwarz
Global $Brush_DunkelGrau = _GDIPlus_BrushCreateSolid(0xFF212323) ;Dubkelgrau
Global $Brush_Weis = _GDIPlus_BrushCreateSolid(0xFFFFFFFF) ;Weiß
Global $Brush_HellGrau = _GDIPlus_BrushCreateSolid(0xFF3C4041) ;Haupt
Global $Brush_Orange = _GDIPlus_BrushCreateSolid(0xFFFA8D28)

Global $Brush_Blau = _GDIPlus_BrushCreateSolid(0xFF7DDCE3) ;Level1 = Innen
Global $Brush_Gelb = _GDIPlus_BrushCreateSolid(0xFF29FC5D) ;Level2 = Mitte
Global $Brush_Grun = _GDIPlus_BrushCreateSolid(0xFFDC64FD) ;Level3 = Außen

Global $Pen_Schwarz = _GDIPlus_PenCreate(0xFF000000, 1) ;Schwarz
Global $Pen_Weis = _GDIPlus_PenCreate(0xFFFFFFFF, 2) ;Schwarz
Global $Pen_Orange = _GDIPlus_PenCreate(0xFFFA8D28, 2)

Global $FPS = 25
Global $iGUIColorBG = 0xFF3C4041
Global $bMouseClick = False; CHeckt ob Maus gedrückt gehalten wird.
Global $aCursorInfo[5];um die immerwiederkehrenden funktionsaufruf zu umgehen