Option Explicit

Private Const SZpath = "C:\Program Files\7-Zip\7zG.exe"
Private Const SZoptions = "x ""%0"" -aoa -spe -o""%1"""
'-aoa Overwrite All existing files without prompt. 
'-spe Eliminate duplication of root folder for extract archive command

'�����`�F�b�N
If WScript.Arguments.Count = 0 Then WScript.Quit

Dim shell: Set shell = WScript.CreateObject("WScript.Shell")
Dim fso:   Set fso = WScript.CreateObject("Scripting.FileSystemObject")
Dim msg: msg = ""
Dim arg
For Each arg In WScript.Arguments
  If fso.FileExists(arg) = False Then
    msg = "�t�@�C����������܂���ł����B" & vbCrLf & vbCrLf & arg
    Exit For
  End If
  msg = Unfreeze(arg, fso.GetFile(arg).ParentFolder & "\" & fso.GetBaseName(arg))
  If msg <> "" Then
    Exit For
  End If
Next
Set fso = Nothing
Set shell = Nothing

If msg <> "" Then
  Call MsgBox(msg, vbExclamation + vbOkOnly)
End If
WScript.Quit

'******************************************************************************
' �@�\    �F
' �@�\���e�F
' �߂�l  �F""    ����
'           <>""  �G���[���e
'******************************************************************************
Private Function Unfreeze( _
  ByVal filePath, _
  ByVal outputPath _
)
  On Error Resume Next

  Unfreeze = ""
  shell.Exec(SZpath & " " & Printf(SZoptions, Array(filePath, outputPath)))
  If Err.Number = 0 Then Exit Function

  Unfreeze = filePath & vbCrLf & vbCrLf & "�G���[(" & Err.Number & "):" & Err.Description
End Function

'******************************************************************************
Private Function Printf(ByVal temp, ByVal args)
  Dim res: res = temp
  Dim ix
  For ix = LBound(args) To UBound(args)
    res = Replace(res, "%" & ix, args(ix))
  Next
  Printf = res
End Function
