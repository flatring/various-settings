Attribute VB_Name = "shortcut"
Option Explicit

'************************************************
' ���W���[�����萔
'************************************************
Private Const M_ZOOM_MAX As Long = 400&
Private Const M_ZOOM_MIN As Long = 10&
Private Const M_ZOOM_SCALE As Long = 5&
Private Const M_INDENT_MAX As Long = 15&
Private Const M_INDENT_MIN As Long = 0&


'******************************************************************************
' �@�\    �F�V���[�g�J�b�g�L�[�̐ݒ�
' �@�\�����F
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
' �@�\    �F�Z���̌����A����
' �@�\�����F
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
' �@�\    �F�Y�[��
' �@�\�����F
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
' �@�\    �F�Z���̃C���f���g
' �@�\�����F
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
' �@�\    �F�I��͈͓��Œ����ƕW����؂�ւ���
' �@�\�����F
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
' �@�\    �F�ҏW�ӏ���؂�ւ���
' �@�\�����F�����o�[ or �Z��
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
' �@�\    �F�Q�ƌ`����؂�ւ���
' �@�\�����F�����o�[ or �Z��
'******************************************************************************
Private Sub ToggleReferenceStyle()
  With Application
    .ReferenceStyle = IIf(.ReferenceStyle = xlA1, xlR1C1, xlA1)
  End With
End Sub

'******************************************************************************
' �@�\    �F�S�V�[�g�̃J�[�\���ʒu��擪�ɂ���
' �@�\�����FA1 or R1C1
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
' �@�\    �F�E�B���h�E�\���ʒu������ɂ���
' �@�\�����F
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
' �@�\    �F�`�����w�肵�āc�_�C�A���O��\���ɂ���
' �@�\�����F
'******************************************************************************
Private Sub ShowDialogPasteSpecial()
  If Application.CutCopyMode = False Then Exit Sub

  Application.Dialogs(xlDialogPasteSpecial).Show
End Sub

'******************************************************************************
' �@�\    �F������W���ƕ����Ő؂�ւ���
' �@�\�����F
'******************************************************************************
Private Sub SwitchCellFormat()
  If TypeName(Selection) <> "Range" Then Exit Sub

  Application.ScreenUpdating = False
  Const nf�W�� As String = "G/�W��"
  Const nf���� As String = "@"
  With Selection
    If ActiveCell.NumberFormatLocal = nf���� Then
      .NumberFormatLocal = nf�W��
      Dim ce As Range
      For Each ce In .Cells
        ce.Value = ce.Value
      Next ce
    Else
      Selection.NumberFormatLocal = nf����
    End If
  End With
  Application.ScreenUpdating = True
End Sub

'--------------------------------------------------------------------------
' ���y�[�W�ʒu�̃Z������ʂɕ\�����āA���y�[�W�ʒu��F��������K�v������܂�
' �ȉ��̉��ꂩ�̑��삪�K�v
' �E���y�[�W����Ă���Z������ʂɕ\��
' �EZoom�ŏk���������ƌ��ɖ߂�
' �E����v���r���[�����s����
'
' ���ɉ��y�[�W���}������Ă����ԂōŌ�̃y�[�W�̃f�[�^���폜����ƁA
' �������y�[�W�����擾�ł��܂���B
' �f�[�^�̉��H�ɂ��y�[�W������������ꍇ�ɂ́A
' �蓮�ŉ��y�[�W��ݒ肵�����K�v������܂��B
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
        strLastCellAddress = .UsedRange.Address       '�Ō�̃Z���̃A�h���X���擾
        If strLastCellAddress = "$A$1" Then
          If IsEmpty(.Range(strLastCellAddress).Value) Then
            Exit Do
          End If
        End If

        lngBreakH = .HPageBreaks.Count    '���̉��y�[�W���擾
        lngBreakV = .VPageBreaks.Count    '�c�̉��y�[�W���擾
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
  Call MsgBox("����y�[�W�����F " & lngPageCount, vbInformation + vbOKOnly)
End Sub
