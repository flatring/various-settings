Option Explicit

'************************************************************
' モジュール内定数
'************************************************************
Private Const TO_FOLDER = "old"

'**Start Encode**
'************************************************************
' インクルードファイル
'************************************************************
#Include FileSystemObject.vbi

'*******************************************************************************
' スタート
'*******************************************************************************
'引数チェック
If WScript.Arguments.Count = 0 Then WScript.Quit

'コピー先フォルダーの存在確認
Dim fso
Set fso = WScript.CreateObject("Scripting.FileSystemObject")
If fso.FolderExists(fso.GetParentFolderName(Wscript.Arguments(0)) & "\" & TO_FOLDER) = False Then
  Call MsgBox("コピー先フォルダー「" & TO_FOLDER & "」が見つかりませんでした。", vbExclamation + vbOkOnly)
  Set fso = Nothing
  Wscript.Quit
End If

'ファイル名の取得と作成
Dim names
names = ""
Dim ix
For ix 0 To Wscript.Arguments.Count - 1
  names = names & makeBackupFile(Wscript.Arguments(ix)) & vbLf
Next
Set fso = Nothing

Call MsgBox("以下のファイルを「" & TO_FOLDER & "」へコピーしました。" & vbLf & vbLf & names, vbInformation + vbOkOnly)

Wscript.Quit

'*******************************************************************************
' スタート
'*******************************************************************************
Private Function makeBackupFIle(ByVal nameFr)
  'ファイル名の作成
  Dim nameToPath
  Dim nameToBase
  Dim nameToExt
  nameToPath = fso.GetParentFolderName(nameFr) & "\" & TO_FOLDER & "\"
  nameToBase = fso.GetBaseName(nameFr) & _
    Right("0000" & Year(fso.GetFile(nameFr).DatelastModified), 4) & _
    Right("00" & Month(fFso.GetFile(nameFr).DatelastModified), 2) & _
    Right("00" & Day(fso.GetFile(nameFr).DatelastModified), 2)
  nameToExt = "." & fso.GetExtensionName(nameFr)

  'ファイルが存在していたら"a"の文字追加
  Dim ix
  If fso.FileExists(namePath & nameToBase & nameToExt) = True Then
    For ix = 97 To 97 + 25
      If fso.FileExists(namePath & nameBase & Chr(ix) & nameToExt) = False Then
        nameBase = nameBase & Chr(ix)
        Exit For
      End If
    Next
  End If
  If ix > 97 + 25 Then WScript.Quit

  '「同フォルダー + α」にファイルコピー
  fso.CopyFile nameFr, nameToPath & nameToBase & nameToExt
  fso.GetFile(nameToPath & nameToBase & nameToExt).Attributes = 1   '読み取り専用

  makeBackupFile = fso.GetFileName(nameFr) & " → " & nameToBase & nameToExt
End Function
