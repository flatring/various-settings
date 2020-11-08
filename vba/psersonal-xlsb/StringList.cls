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
' �^��StringList
'------------------------------------------------------------------------------
' �@�\���e
'   �EIndex��"0"����
'   �E
'------------------------------------------------------------------------------
' ���l
'   �ECollection���g��Ȃ��̂̓\�[�g���邽�߁B
'   �E�z�񐔂��Ǘ�����̂�UBound�����g�킸�ɕϐ����g���Ă���̂�
'     �z�񐔃[�����̃A�N�Z�X�G���[��������邽�߁B
'------------------------------------------------------------------------------
'==============================================================================
Option Explicit

'************************************************
' ���W���[�������ʕϐ�
'************************************************
Private mit()  As String
Private mitCnt As Long


'******************************************************************************
' �N���X�C�x���g
'******************************************************************************
Private Sub Class_Initialize()
  Call AllDelete
End Sub

'******************************************************************************
' �v���p�e�B
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
' �@�\    �F���R�[�h�ǉ�
' �@�\���e�F
' �߂�l  �F�Ȃ�
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
' �@�\    �F���R�[�h�}��
' �@�\���e�F
' �߂�l  �F�Ȃ�
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
' �@�\    �F�f�[�^����
' �@�\���e�F����ȃf�[�^��������΂���Index��Ԃ�(���S��v)
' �߂�l  �F-1    �s��v
'           > -1  ��v����Index
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
' �@�\    �F�f�[�^����
' �@�\���e�F����ȃf�[�^��������΂���Index��Ԃ�(������v)
' �߂�l  �F-1    �s��v
'           > -1   ��v����Index
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
' �@�\    �F�\�[�g
' �@�\���e�F�e�L�[�P�ʂɃV�F���\�[�g���g���ă\�[�g����
' �߂�l  �F�Ȃ�
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

'������r���� -----------------------------------
Private Function CompareResultString( _
  ByVal value1 As String, _
  ByVal value2 As String, _
  Optional ByVal Ascending As Boolean = True _
) As Boolean

  CompareResultString = CBool(StrComp(value1, value2, vbTextCompare) = 1)
  CompareResultString = CompareResultString Eqv Ascending
End Function

'******************************************************************************
' �@�\    �F�S���R�[�h�폜
' �@�\���e�F
' ����    �F�Ȃ�
' �߂�l  �F�Ȃ�
'******************************************************************************
Public Sub AllDelete()
  Erase mit
  mitCnt = 0&
End Sub

'******************************************************************************
' �@�\    �F�S�v�f�A��
' �@�\���e�F�z��Ɋ܂܂��e�v�f�̓�����������������č쐬����镶����
' �߂�l  �F�A��������
'******************************************************************************
Public Function Join(Optional ByVal Delimiter As String = "") As String
  Join = ""
  If mitCnt = 0& Then Exit Function

  Join = Strings.Join(mit, Delimiter)
End Function

'******************************************************************************
' �@�\    �F�ꊇ�捞
' �@�\���e�F�z��ɒl�������Ă����ꍇ�͏㏑�������̂Œ��ӂ��邱��
' �߂�l  �F�v�f��
'******************************************************************************
Public Function Split(ByVal NewValues As String, Optional ByVal Delimiter As String = "") As Long
  Split = 0&
  If Len(NewValues) = 0& Then Exit Function

  mit = Strings.Split(NewValues, Delimiter)
  mitCnt = UBound(mit) + 1&
  Split = mitCnt
End Function