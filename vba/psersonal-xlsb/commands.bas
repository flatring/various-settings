Attribute VB_Name = "commands"
Option Explicit

Public Sub �G���[�ƂȂ��Ă��閼�O��`���폜����()
  Dim ix As Long
  With ActiveWorkbook
    For ix = .Names.Count To 1 Step -1
      Do
        With Names(ix)
          If .ValidWorkbookParameter = True Then Exit Do
          If InStr(.RefersToLocal, "#REF!") = 0 Then Exit Do

          .Delete
        End With
      Loop Until True
    Next ix
  End With
End Sub

Public Sub �W���ȊO�̃Z���X�^�C�����폜()
  With ActiveWorkbook
    Dim ix As Long
    For ix = .Styles.Count To 1 Step -1
      If .Styles(ix).BuiltIn = False Then
        .Styles(ix).Delete
      End If
    Next
  End With
End Sub

Public Sub �f�t�H���g�y�[�W�ݒ�()
  Application.PrintCommunication = False
  With ActiveSheet.PageSetup
'    .PrintTitleRows = ""
'    .PrintTitleColumns = ""
    .PrintArea = ""
    .LeftHeader = "&A"
    .CenterHeader = ""
    .RightHeader = "�����:&D"
    .LeftFooter = ""
    .CenterFooter = "- &P / &N -"
    .RightFooter = ""
    .LeftMargin = Application.CentimetersToPoints(0.6)
    .RightMargin = Application.CentimetersToPoints(0.6)
    .TopMargin = Application.CentimetersToPoints(1.9)
    .BottomMargin = Application.CentimetersToPoints(1.9)
    .HeaderMargin = Application.CentimetersToPoints(0.8)
    .FooterMargin = Application.CentimetersToPoints(0.8)
    .PrintHeadings = False
    .PrintGridlines = False
    .PrintComments = xlPrintNoComments
    .PrintQuality = 600
    .CenterHorizontally = False
    .CenterVertically = False
    .Orientation = xlLandscape
    .Draft = False
    .PaperSize = xlPaperA4
    .FirstPageNumber = xlAutomatic
    .Order = xlDownThenOver
    .BlackAndWhite = False
    .Zoom = False
    .FitToPagesWide = 1
    .FitToPagesTall = 1
    .PrintErrors = xlPrintErrorsDisplayed
    .OddAndEvenPagesHeaderFooter = False
    .DifferentFirstPageHeaderFooter = False
    .ScaleWithDocHeaderFooter = True
    .AlignMarginsHeaderFooter = False
  End With
  Application.PrintCommunication = True
End Sub

' �Q�Ɛݒ�� �uMicrosoft Forms 2.0 Object Library�v���K�v�B
'   �������A�m�Q�Ɛݒ�n�_�C�A���O�{�b�N�X�̈ꗗ�ɁA���̃��C�u�����͕\������܂���B
'  1.�m�Q�Ɛݒ�n�_�C�A���O�{�b�N�X��\���B
'  2. �m�Q�Ɓn�{�^�����N���b�N���āA�uC:\Windows\System32\FM20.DLL�v�܂��́uC:\Windows\SysWOW64\FM20.DLL�v��I���B
'    �� ���C�u�����̃p�X��OS�ɂ���ĈقȂ�
Public Sub �Z���͈͂�Markdown�̃e�[�u�������ɂ��ăN���b�v�{�[�h�փR�s�[()
  If TypeName(Selection) <> "Range" Then Exit Sub
  If Selection.Areas.Count > 1 Then Exit Sub

  Dim dat As Variant: dat = Selection.Value
  Dim ces() As String: ReDim ces(LBound(dat, 2) To UBound(dat, 2))
  Dim res As New StringList
  Dim ro As Long
  For ro = LBound(dat, 1) To UBound(dat, 1)
    If ro = LBound(dat, 1) + 1 Then
      res.Add "|" & WorksheetFunction.Rept("---|", UBound(dat, 2))
    End If
    Dim co As Long
    For co = LBound(dat, 2) To UBound(dat, 2)
      ces(co) = Replace(dat(ro, co), vbLf, "<br>")
    Next co
    res.Add "| " & Join(ces, " | ") & " |"
  Next ro
  With New DataObject
    .SetText res.Join(vbCrLf)
    .PutInClipboard
  End With
  Set res = Nothing
End Sub

Public Sub �Z���͈͂�csv�ɂ��ăN���b�v�{�[�h�փR�s�[()
  If TypeName(Selection) <> "Range" Then Exit Sub
  If Selection.Areas.Count > 1 Then Exit Sub

  Dim dat As Variant: dat = Selection.Value
  Dim ces() As String: ReDim ces(LBound(dat, 2) To UBound(dat, 2))
  Dim res As New StringList
  Dim ro As Long
  For ro = LBound(dat, 1) To UBound(dat, 1)
    Dim co As Long
    For co = LBound(dat, 2) To UBound(dat, 2)
'      ces(co) = Replace(dat(ro, co), vbLf, "<br>")
      Dim wok As String: wok = Replace(dat(ro, co), vbLf, "<br>")
      Dim str As String: str = ""
      Dim ix As Long
      For ix = 1 To Len(wok)
        If Mid(wok, ix, 1) = """" Then
          str = str & """"""
        Else
          str = str & Mid(wok, ix, 1)
        End If
      Next ix
      If InStr(str, "True") > 0 Then
        str = Replace(str, "True", "true")
      End If

      If InStr(str, " ") > 0 _
      Or InStr(str, """") > 0 Then
        ces(co) = """" & str & """"
      Else
        ces(co) = str
      End If
    Next co
    res.Add Join(ces, ",")
  Next ro
  With New DataObject
    .SetText res.Join(vbCrLf)
    .PutInClipboard
  End With
  Set res = Nothing
End Sub
