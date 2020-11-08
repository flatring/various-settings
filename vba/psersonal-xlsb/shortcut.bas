Attribute VB_Name = "shortcut"
Option Explicit

'************************************************
' モジュール内定数
'************************************************
Private Const M_ZOOM_MAX As Long = 400&
Private Const M_ZOOM_MIN As Long = 10&
Private Const M_ZOOM_SCALE As Long = 5&
Private Const M_INDENT_MAX As Long = 15&
Private Const M_INDENT_MIN As Long = 0&


'******************************************************************************
' 機能    ：ショートカットキーの設定
' 機能説明：
'******************************************************************************
Public Function SetOnkey(ByVal dummy As Boolean) As Boolean
  SetOnkey = False
  With Application
    ' Ctrl  ^
    ' Shift +
    ' Alt   %
    .OnKey "^m", "CellMarge"
    .OnKey "^+m", "CellUnmarge"

    .OnKey "%z", "ZoomUp"
    .OnKey "+%z", "ZoomDown"

    .OnKey "+%{RIGHT}", "CellIndent"
    .OnKey "+%{LEFT}", "CellUnindent"

    .OnKey "^t", "ToggleCellAcross"

    .OnKey "^r", "ToggleReferenceStyle"

    .OnKey "^+r", "CursorReset"

    .OnKey "^+t", "TopLeft0"

    .OnKey "%u", "ToggleEditDirectlyInCell"

    .OnKey "%s", "ShowDialogPasteSpecial"

    .OnKey "^+q", "SwitchCellFormat"
  End With
  Debug.Print Format(Now, "yyyy/mm/dd hh:nn:ss") & "[     ]SetOnkey success!"
  SetOnkey = True
End Function

'******************************************************************************
' 機能    ：セルの結合、解除
' 機能説明：
'******************************************************************************
Private Sub CellMarge()
  If TypeName(Selection) <> "Range" Then Exit Sub

  With Selection
    If .MergeCells = True Then
      .WrapText = Not .WrapText
    Else
      If .Parent.Parent.MultiUserEditing = True Then Exit Sub
      If .Areas.Count > 1& Then Exit Sub
      If .Cells.Count = 1& Then Exit Sub

      .MergeCells = True
    End If
  End With
End Sub

Private Sub CellUnmarge()
  If TypeName(Selection) <> "Range" Then Exit Sub

  With Selection
    If .MergeCells = False Then
      .WrapText = Not .Cells(1).WrapText
      If .WrapText = False Then
        .ShrinkToFit = False
      End If
    End If
    If .Parent.Parent.MultiUserEditing = True Then Exit Sub
    If .Cells.Count = 1& Then Exit Sub

    .MergeCells = False
  End With
End Sub

'******************************************************************************
' 機能    ：ズーム
' 機能説明：
'******************************************************************************
Private Sub ZoomUp()
  With Selection
    If TypeName(Selection) = "Range" Then
      If .Cells.Count <> .Cells(1).MergeArea.Count Then
        .Parent.Parent.Windows(1).Zoom = True
        Exit Sub
      End If
    End If
    If .Parent.Parent.Windows(1).Zoom >= M_ZOOM_MAX Then Exit Sub

    Dim zm As Long: zm = .Parent.Parent.Windows(1).Zoom + M_ZOOM_SCALE - (.Parent.Parent.Windows(1).Zoom Mod M_ZOOM_SCALE)
    .Parent.Parent.Windows(1).Zoom = IIf(zm > M_ZOOM_MAX, M_ZOOM_MAX, zm)
  End With
End Sub

Private Sub ZoomDown()
  With Selection
    If .Parent.Parent.Windows(1).Zoom <= M_ZOOM_MIN Then Exit Sub

    Dim zm As Long: zm = .Parent.Parent.Windows(1).Zoom - M_ZOOM_SCALE - (.Parent.Parent.Windows(1).Zoom Mod M_ZOOM_SCALE)
    .Parent.Parent.Windows(1).Zoom = IIf(zm < M_ZOOM_MIN, M_ZOOM_MIN, zm)
  End With
End Sub

'******************************************************************************
' 機能    ：セルのインデント
' 機能説明：
'******************************************************************************
Private Sub CellIndent()
  With Selection
    If .IndentLevel >= M_INDENT_MAX Then Exit Sub

    .IndentLevel = .IndentLevel + 1&
  End With
End Sub

Private Sub CellUnindent()
  With Selection
    If .IndentLevel <= M_INDENT_MIN Then Exit Sub

    .IndentLevel = .IndentLevel - 1&
  End With
End Sub

'******************************************************************************
' 機能    ：選択範囲内で中央と標準を切り替える
' 機能説明：
'******************************************************************************
Private Sub ToggleCellAcross()
  With Selection
    If .HorizontalAlignment = xlCenterAcrossSelection Then
      .HorizontalAlignment = xlGeneral
    Else
      .Font.Color = .Cells(1).Font.Color
      .Interior.Color = .Cells(1).Interior.Color
      .Borders(xlInsideVertical).LineStyle = xlNone
      .HorizontalAlignment = xlCenterAcrossSelection
    End If
  End With
End Sub

'******************************************************************************
' 機能    ：編集箇所を切り替える
' 機能説明：数式バー or セル
'******************************************************************************
Private Sub ToggleEditDirectlyInCell()
  Const sizeMin As Long = 2
  Const sizeMax As Long = 10
  If TypeName(Selection) <> "Range" Then Exit Sub

  Application.EditDirectlyInCell = Not Application.EditDirectlyInCell
  With ActiveCell
    Dim size As Long: size = Len(.FormulaLocal) - Len(Replace(.FormulaLocal, vbLf, "")) + 1
    size = IIf(size <= sizeMin, sizeMin, size)
    size = IIf(size >= sizeMax, sizeMax, size)
  End With
  Application.FormulaBarHeight = IIf(Application.EditDirectlyInCell, 1, size)
End Sub

'******************************************************************************
' 機能    ：参照形式を切り替える
' 機能説明：数式バー or セル
'******************************************************************************
Private Sub ToggleReferenceStyle()
  With Application
    .ReferenceStyle = IIf(.ReferenceStyle = xlA1, xlR1C1, xlA1)
  End With
End Sub

'******************************************************************************
' 機能    ：全シートのカーソル位置を先頭にする
' 機能説明：A1 or R1C1
'******************************************************************************
Private Sub CursorReset()
  Application.ScreenUpdating = False
  With ActiveWorkbook
    Dim ix As Long
    For ix = .Worksheets.Count To 1& Step -1&
      If .Worksheets(ix).Visible = True Then
        .Worksheets(ix).Activate
        If Worksheets(ix).ProtectContents = True Then
          .Worksheets(ix).Cells(1).Select
        Else
          .Worksheets(ix).Cells.SpecialCells(xlCellTypeVisible).Cells(1).Select
        End If
        .Windows(1).ActivePane.ScrollRow = 1
        .Windows(1).ActivePane.ScrollColumn = 1
      End If
    Next ix
  End With
  Application.ScreenUpdating = True
End Sub

'******************************************************************************
' 機能    ：ウィンドウ表示位置を左上にする
' 機能説明：
'******************************************************************************
Private Sub TopLeft0()
  Const goldenRatio As Double = 1.6180339887

  Application.ScreenUpdating = False
  With ActiveWorkbook.Windows(1)
    Dim stat As Long
    stat = .WindowState
    .WindowState = xlNormal
    .Top = 0
    .Left = 0
    If Application.UsableHeight * goldenRatio > Application.UsableWidth Then
      .Width = Application.UsableWidth
      .Height = .Width * (goldenRatio - 1#)
    Else
      .Height = Application.UsableHeight
      .Width = .Height * goldenRatio
    End If
    .WindowState = stat
  End With
  Application.ScreenUpdating = True
End Sub

'******************************************************************************
' 機能    ：形式を指定して…ダイアログを表示にする
' 機能説明：
'******************************************************************************
Private Sub ShowDialogPasteSpecial()
  If Application.CutCopyMode = False Then Exit Sub

  Application.Dialogs(xlDialogPasteSpecial).Show
End Sub

'******************************************************************************
' 機能    ：書式を標準と文字で切り替える
' 機能説明：
'******************************************************************************
Private Sub SwitchCellFormat()
  If TypeName(Selection) <> "Range" Then Exit Sub

  Application.ScreenUpdating = False
  Const nf標準 As String = "G/標準"
  Const nf文字 As String = "@"
  With Selection
    If ActiveCell.NumberFormatLocal = nf文字 Then
      .NumberFormatLocal = nf標準
      Dim ce As Range
      For Each ce In .Cells
        ce.Value = ce.Value
      Next ce
    Else
      Selection.NumberFormatLocal = nf文字
    End If
  End With
  Application.ScreenUpdating = True
End Sub

'--------------------------------------------------------------------------
' 改ページ位置のセルを画面に表示して、改ページ位置を認識させる必要があります
' 以下の何れかの操作が必要
' ・改ページされているセルを画面に表示
' ・Zoomで縮小したあと元に戻す
' ・印刷プレビューを実行する
'
' 既に改ページが挿入されている状態で最後のページのデータを削除すると、
' 正しいページ数が取得できません。
' データの加工によりページ数が減少する場合には、
' 手動で改ページを設定し直す必要があります。
'--------------------------------------------------------------------------
Private Sub GetPrintPageCount()
  Dim shtTarget     As Worksheet
  Dim lngBreakH     As Long
  Dim lngBreakV     As Long
  Dim lngPageCount  As Long
  Dim strLastCellAddress As String


  lngPageCount = 0&
  For Each shtTarget In ActiveWindow.SelectedSheets
    Do
      With shtTarget
        strLastCellAddress = .UsedRange.Address       '最後のセルのアドレスを取得
        If strLastCellAddress = "$A$1" Then
          If IsEmpty(.Range(strLastCellAddress).Value) Then
            Exit Do
          End If
        End If

        lngBreakH = .HPageBreaks.Count    '横の改ページ数取得
        lngBreakV = .VPageBreaks.Count    '縦の改ページ数取得
        If lngBreakH = 0& Then
          lngPageCount = lngPageCount + lngBreakV + 1&
        ElseIf lngBreakV = 0& Then
          lngPageCount = lngPageCount + lngBreakH + 1&
        Else
          lngBreakH = lngBreakH + 1&
          lngBreakV = lngBreakV + 1&
          lngPageCount = lngPageCount + lngBreakH * lngBreakV
        End If
      End With
    Loop While False
  Next shtTarget
  Call MsgBox("印刷ページ総数： " & lngPageCount, vbInformation + vbOKOnly)
End Sub
