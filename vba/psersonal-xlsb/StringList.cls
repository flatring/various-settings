VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "StringList"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
'==============================================================================
'------------------------------------------------------------------------------
' 疑似StringList
'------------------------------------------------------------------------------
' 機能内容
'   ・Indexは"0"から
'   ・
'------------------------------------------------------------------------------
' 備考
'   ・Collectionを使わないのはソートするため。
'   ・配列数を管理するのにUBound等を使わずに変数を使っているのは
'     配列数ゼロ時のアクセスエラーを回避するため。
'------------------------------------------------------------------------------
'==============================================================================
Option Explicit

'************************************************
' モジュール内共通変数
'************************************************
Private mit()  As String
Private mitCnt As Long


'******************************************************************************
' クラスイベント
'******************************************************************************
Private Sub Class_Initialize()
  Call AllDelete
End Sub

'******************************************************************************
' プロパティ
'******************************************************************************
Public Property Get Count() As Long
  Count = mitCnt
End Property

Public Property Get Item(ByVal Index As Long) As String
  If Index < 0& _
  Or Index >= mitCnt Then
    Item = ""
  Else
    Item = mit(Index)
  End If
End Property

Public Property Let Item(ByVal Index As Long, ByVal NewValue As String)
  If Index < 0& _
  Or Index >= mitCnt Then Exit Property

  mit(Index) = NewValue
End Property

Public Property Get List() As Variant
  List = mit
End Property

Public Property Let List(ByVal NewValue As Variant)
  If IsArray(NewValue) = False Then Exit Property
  On Error Resume Next
  If IsNumeric(UBound(NewValue, 2)) > 0 Then Exit Property
  If Err.Number <> 0 Then Exit Property

  mit = NewValue
End Property

'******************************************************************************
' 機能    ：レコード追加
' 機能内容：
' 戻り値  ：なし
'******************************************************************************
Public Sub Add( _
  ByVal NewValue As String, _
  Optional ByVal unique As Boolean = False _
)
  If unique Then
    If mitCnt > 0 Then
      Dim ix As Long
      For ix = LBound(mit) To UBound(mit)
        If mit(ix) = NewValue Then
          Exit Sub
        End If
      Next ix
    End If
  End If
  ReDim Preserve mit(mitCnt)
  mit(mitCnt) = NewValue
  mitCnt = mitCnt + 1&
End Sub

'******************************************************************************
' 機能    ：レコード挿入
' 機能内容：
' 戻り値  ：なし
'******************************************************************************
Public Sub Insert( _
  ByVal Index As Long, _
  ByVal NewValue As String _
)
  If Index < 0& _
  Or Index >= mitCnt + 1& Then Exit Sub

  Dim tempBox() As String
  tempBox = mit
  ReDim mit(mitCnt)
  mitCnt = mitCnt + 1&

  Dim ix As Long
  For ix = LBound(tempBox) To UBound(tempBox)
    If ix = Index Then
      mit(ix) = NewValue
    End If
    If ix < Index Then
      mit(ix) = tempBox(ix)
    Else
      mit(ix + 1) = tempBox(ix)
    End If
  Next ix
End Sub

'******************************************************************************
' 機能    ：データ検索
' 機能内容：同一なデータが見つかればそのIndexを返す(完全一致)
' 戻り値  ：-1    不一致
'           > -1  一致したIndex
'******************************************************************************
Public Function Find( _
  ByVal FindValue As String _
) As Long

  Find = -1&
  If mitCnt = 0& Then Exit Function

  Dim ix As Long
  For ix = LBound(mit) To UBound(mit)
    If mit(ix) = FindValue Then
      Find = ix
      Exit For
    End If
  Next ix
End Function

'******************************************************************************
' 機能    ：データ検索
' 機能内容：同一なデータが見つかればそのIndexを返す(部分一致)
' 戻り値  ：-1    不一致
'           > -1   一致したIndex
'******************************************************************************
Public Function InStr( _
  ByVal FindValue As String _
) As Long

  InStr = -1&
  If mitCnt = 0& Then Exit Function

  Dim ix As Long
  For ix = LBound(mit) To UBound(mit)
    If InStr(mit(ix), FindValue) > 0 Then
      InStr = ix
      Exit For
    End If
  Next ix
End Function

'******************************************************************************
' 機能    ：ソート
' 機能内容：各キー単位にシェルソートを使ってソートする
' 戻り値  ：なし
'******************************************************************************
Public Sub Sort(Optional ByVal Ascending As Boolean = True)
  If mitCnt = 0& Then Exit Sub

  Dim rowFirst As Long
  Dim rowLast  As Long
  Dim numRows  As Long
  rowFirst = LBound(mit)
  rowLast = UBound(mit)
  numRows = rowLast - rowFirst + 1&

  Dim gapSize As Long
  gapSize = 0&
  Do
    gapSize = gapSize * 3& + 1&
  Loop Until gapSize > numRows

  Dim tempValue As String
  Dim counter As Long
  Dim cursorPosi As Long
  Do
    gapSize = gapSize \ 3&
    For counter = (gapSize + rowFirst) To rowLast
      cursorPosi = counter
      tempValue = mit(counter)
      Do While CompareResultString(mit(cursorPosi - gapSize), tempValue, Ascending)
        mit(cursorPosi) = mit(cursorPosi - gapSize)
        cursorPosi = cursorPosi - gapSize
        If (cursorPosi - gapSize) < rowFirst Then Exit Do
      Loop
      mit(cursorPosi) = tempValue
    Next
  Loop Until gapSize = 1&
End Sub

'文字比較判定 -----------------------------------
Private Function CompareResultString( _
  ByVal value1 As String, _
  ByVal value2 As String, _
  Optional ByVal Ascending As Boolean = True _
) As Boolean

  CompareResultString = CBool(StrComp(value1, value2, vbTextCompare) = 1)
  CompareResultString = CompareResultString Eqv Ascending
End Function

'******************************************************************************
' 機能    ：全レコード削除
' 機能内容：
' 引数    ：なし
' 戻り値  ：なし
'******************************************************************************
Public Sub AllDelete()
  Erase mit
  mitCnt = 0&
End Sub

'******************************************************************************
' 機能    ：全要素連結
' 機能内容：配列に含まれる各要素の内部文字列を結合して作成される文字列
' 戻り値  ：連結文字列
'******************************************************************************
Public Function Join(Optional ByVal Delimiter As String = "") As String
  Join = ""
  If mitCnt = 0& Then Exit Function

  Join = Strings.Join(mit, Delimiter)
End Function

'******************************************************************************
' 機能    ：一括取込
' 機能内容：配列に値が入っていた場合は上書きされるので注意すること
' 戻り値  ：要素数
'******************************************************************************
Public Function Split(ByVal NewValues As String, Optional ByVal Delimiter As String = "") As Long
  Split = 0&
  If Len(NewValues) = 0& Then Exit Function

  mit = Strings.Split(NewValues, Delimiter)
  mitCnt = UBound(mit) + 1&
  Split = mitCnt
End Function
