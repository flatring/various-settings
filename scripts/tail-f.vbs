'===============================================================================
'-------------------------------------------------------------------------------
' ���O�̍ŏI�s�\��
'-------------------------------------------------------------------------------
' ����
'   �E�Ώۂ̃��O�t�@�C������������s����O�ɍ쐬����Ă��邱��
'-------------------------------------------------------------------------------
' ����P
'   1.�R�}���h�v�����v�g�E�B���h�E�𗧂��グ��
'   2.�J�����g�p�X�����O�t�@�C���̏o�͐�t�H���_�ɕύX����
'   3.���̃R�}���h���R�}���h�v�����v�g�E�B���h�E�Ƀy�[�X�g����
'     CScript.exe //NoLogo tail-f.vbs /filename:���O�t�@�C����  /LineLastcount:�ŏ��̕\���s��
'   4.���f����ꍇ�́uCtrl + c�v�Œ�~
'
' ����Q
'   1.���O�t�@�C�����h���b�O���Ă��̃X�N���v�g�Ƀh���b�v����
'
'-------------------------------------------------------------------------------
' �C�}�C�`�ȂƂ���
'   �E���s���Ƀ��O�t�@�C�������łɋ��傾�����ꍇ�A
'     �t�@�C����S�ǂ݂��邽�߂�tail�܂łɎ��Ԃ��������Ă��܂�����
'     ���Ȃ̂ŁA���s���̃��O�t�@�C���T�C�Y�͏��������Ă������Ƃ��I�X�X��
'     ���ꉞ�A�ŏI�s�t�߂܂ŏo�͂��Ȃ��悤�ɑΉ��ς�(���ׂ͌����Ă���)
'-------------------------------------------------------------------------------
'===============================================================================
'**Start Encode**

Option Explicit

Const ForReading = 1

CompulsionCscript()

'�R�}���h���C�������̎擾
If WScript.Arguments.Count = 0 Then
  WScript.Echo "Argument Nothing."
  WScript.Quit
End If

Dim fileName: fileName = WScript.Arguments(0)
If WScript.Arguments.Named.Exists("filename") = True Then
  fileName = WScript.Arguments.Named.Item("filename")
End If
Dim lineLastCount: lineLastCount = 10
If WScript.Arguments.Named.Exists("LineLastCount") = True Then
  lineLastCount = WScript.Arguments.Named.Item("LineLastCount")
End If

'���O�t�@�C���̑��݊m�F
Dim fso: Set fso = WScript.CreateObject("Scripting.FileSystemObject")
If fso.FileExists(fileName) = False Then
  WScript.Echo "File Nothing=" & fileName
  WScript.Quit
End If

WScript.Echo ""
WScript.Echo "<Infomation>�uCtrl+c�v�ŏ����𒆒f"
WScript.Echo ""


'���f�����܂ŉi�v���[�v
Dim targetFile
Dim fileSize
Dim line()
Dim posi
Do
  Set targetFile = fso.OpenTextFile(fileName, ForReading, False)
  fileSize = 0

  '����ǂݔ�΂�
  Erase line
  ReDim line(lineLastCount - 1)
  posi = LBound(line)
  Do Until targetFile.AtEndOfStream = True
    line(posi) = targetFile.ReadLine
    posi = (posi + 1) Mod (UBound(line) + 1)
  Loop
  Dim ix
  For ix = LBound(line) To UBound(line)
    WScript.Echo line(posi)
    posi = (posi + 1) Mod (UBound(line) + 1)
  Next

  '�t�@�C���T�C�Y���������Ȃ������ɔ�����
  Do
    '���O�\��
    If targetFile.AtEndOfStream = True Then
      fileSize = fso.GetFile(fileName).Size
      WScript.Sleep 1000
    Else
      WScript.Echo targetFile.ReadLine
    End If
  Loop Until fileSize > fso.GetFile(fileName).Size
  targetFile.Close

  WScript.Echo ""
  WScript.Echo "<Infomation>�t�@�C���̍ēǂݍ���"
  WScript.Echo ""
Loop
Set targetFile = Nothing
WScript.Quit

'******************************************************************************
' �@�\    �F����CSript���s
' �@�\���e�F
' ����    �F�Ȃ�
'******************************************************************************
Private Sub CompulsionCscript()
  If InStr(LCase(WScript.FullName), "wscript") > 0 Then
    Dim commands: commands = Array("cmd.exe /c CScript.exe", """" & WScript.ScriptFullName & """")  '�I����Ƀv�����v�g����Ȃ��悤�ɂ���ɂ�"/c"��"/k"�ɕύX����
    Dim arg
    For Each arg In WScript.Arguments
      ReDim Preserve commands(UBound(commands) + 1)
      commands(UBound(commands)) = """" & arg & """"
    Next
    ReDim Preserve commands(UBound(commands) + 1)
    commands(UBound(commands)) = " & pause"
    WScript.Quit CreateObject("WScript.Shell").Run(Join(commands), 1, True)
  End If
End Sub
