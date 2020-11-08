Option Explicit

If WScript.Arguments.Count = 0 Then WScript.Quit

Dim fso: Set fso = WScript.CreateObject("Scripting.FileSystemObject")
Dim arg
For Each arg In WScript.Arguments
  With fso.GetFile(arg)
    Dim toName: toName =  _
      .ParentFolder & "\" & _
      fso.GetBaseName(.Path) & _
      Format_YYYYMMDD_HHNNSS(.DateLastModified) & "." & _
      fso.GetExtensionName(.Path)
    .Copy toName
  End With
Next
Set fso = Nothing
WScript.Quit

'-------------------------------------------------------------------------------
Private Function Format_YYYYMMDD_HHNNSS(data)
  Format_YYYYMMDD_HHNNSS = _
    "_" & _
    Year(data) & _
    Right("0" & CStr(Month(data)), 2) & _
    Right("0" & CStr(Day(data)), 2) & _
    "_" & _
    Right("0" & CStr(Hour(data)), 2) & _
    Right("0" & CStr(Minute(data)), 2) & _
    Right("0" & CStr(Second(data)), 2)
End Function
