'http://www.happy2-island.com/vbs/cafe02/capter00110.shtml
Const vbNormalFocus = 1      '通常のウィンドウ、かつ最前面のウィンドウ

If Document.Selection.Text = "" Then
  Document.Selection.SelectLine
End If
txt = Replace(Trim(Document.Selection.Text), vbLf, "")
CreateObject("WScript.Shell").Run """" & txt & """", vbNormalFocus, False
