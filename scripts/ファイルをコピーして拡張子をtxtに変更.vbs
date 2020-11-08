Option Explicit

'**Start Encode**

'*******************************************************************************
' スタート
'*******************************************************************************
'引数チェック
If WScript.Arguments.Count = 0 Then WScript.Quit

'ファイル名の取得と作成
Dim fso: Set fso = WScript.CreateObject("Scripting.FileSystemObject")
Dim names: names = ""
Dim ix
For ix = 0 To WScript.Arguments.Count - 1
  names = names & copyFIle(Wscript.Arguments(ix)) & vbLf
Next
Set fso = Nothing

Call MsgBox("ファイルをコピーしました。" & vbLf & vbLf & names, vbInformation + vbOkOnly)

Wscript.Quit

'*******************************************************************************
' 
'*******************************************************************************
Private Function copyFIle(ByVal nameFr)
  'ファイル名の作成
  Dim nameToPath: nameToPath = fso.GetParentFolderName(nameFr) & "\"
  Dim nameToBase: nameToBase = fso.GetBaseName(nameFr)
  Dim nameToExt: nameToExt = ".txt"

  fso.CopyFile nameFr, nameToPath & nameToBase & nameToExt, True

  copyFIle = fso.GetFileName(nameFr) & " → " & nameToBase & nameToExt
End Function
