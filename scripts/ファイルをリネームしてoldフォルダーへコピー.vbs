Option Explicit

'************************************************************
' ���W���[�����萔
'************************************************************
Private Const TO_FOLDER = "old"

'**Start Encode**
'************************************************************
' �C���N���[�h�t�@�C��
'************************************************************
#Include FileSystemObject.vbi

'*******************************************************************************
' �X�^�[�g
'*******************************************************************************
'�����`�F�b�N
If WScript.Arguments.Count = 0 Then WScript.Quit

'�R�s�[��t�H���_�[�̑��݊m�F
Dim fso
Set fso = WScript.CreateObject("Scripting.FileSystemObject")
If fso.FolderExists(fso.GetParentFolderName(Wscript.Arguments(0)) & "\" & TO_FOLDER) = False Then
  Call MsgBox("�R�s�[��t�H���_�[�u" & TO_FOLDER & "�v��������܂���ł����B", vbExclamation + vbOkOnly)
  Set fso = Nothing
  Wscript.Quit
End If

'�t�@�C�����̎擾�ƍ쐬
Dim names
names = ""
Dim ix
For ix 0 To Wscript.Arguments.Count - 1
  names = names & makeBackupFile(Wscript.Arguments(ix)) & vbLf
Next
Set fso = Nothing

Call MsgBox("�ȉ��̃t�@�C�����u" & TO_FOLDER & "�v�փR�s�[���܂����B" & vbLf & vbLf & names, vbInformation + vbOkOnly)

Wscript.Quit

'*******************************************************************************
' �X�^�[�g
'*******************************************************************************
Private Function makeBackupFIle(ByVal nameFr)
  '�t�@�C�����̍쐬
  Dim nameToPath
  Dim nameToBase
  Dim nameToExt
  nameToPath = fso.GetParentFolderName(nameFr) & "\" & TO_FOLDER & "\"
  nameToBase = fso.GetBaseName(nameFr) & _
    Right("0000" & Year(fso.GetFile(nameFr).DatelastModified), 4) & _
    Right("00" & Month(fFso.GetFile(nameFr).DatelastModified), 2) & _
    Right("00" & Day(fso.GetFile(nameFr).DatelastModified), 2)
  nameToExt = "." & fso.GetExtensionName(nameFr)

  '�t�@�C�������݂��Ă�����"a"�̕����ǉ�
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

  '�u���t�H���_�[ + ���v�Ƀt�@�C���R�s�[
  fso.CopyFile nameFr, nameToPath & nameToBase & nameToExt
  fso.GetFile(nameToPath & nameToBase & nameToExt).Attributes = 1   '�ǂݎ���p

  makeBackupFile = fso.GetFileName(nameFr) & " �� " & nameToBase & nameToExt
End Function
