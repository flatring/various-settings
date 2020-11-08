Attribute VB_Name = "functions"
Option Explicit

Public Function sprintf(ByVal temp As String, ParamArray args() As Variant) As String
  Dim res As String: res = temp
  Dim ix As Long
  For ix = LBound(args) To UBound(args)
    res = Replace(res, "%" & ix, args(ix))
  Next ix
  Printf = res
End Function
