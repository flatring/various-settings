'===============================================================================
'-------------------------------------------------------------------------------
' �A�v���ꊇ�N��
'-------------------------------------------------------------------------------
' �@�\���e
'   �E�l�b�g���[�N�ڑ�
'   �E�A�v���P�[�V������o�^���ɋN������
'   �E
'-------------------------------------------------------------------------------
' ���l
'   �E�w��̃A�v���P�[�V���������ɋN�����ł���Δ�΂�
'   �E
'-------------------------------------------------------------------------------
'===============================================================================
'**Start Encode**

Option Explicit

'************************************************
' �X�N���v�g�����ʕϐ�
'************************************************
Dim servList


'*******************************************************************************
' �X�^�[�g
'*******************************************************************************
' �Ǘ��҂Ƃ��Ď��s����������
'Dim app: Set app = WScript.CreateObject("Shell.Application")
'If WScript.Arguments.Count = 0 then
'  app.ShellExecute "wscript.exe", """" & WScript.ScriptFullName & """ uac", "", "runas"
'  WScript.Quit
'End If
'Set app = Nothing

Dim shell: Set shell = WScript.CreateObject("WScript.Shell")
Dim fso:   Set fso = WScript.CreateObject("Scripting.FileSystemObject")
Dim profPath: profPath = shell.ExpandEnvironmentStrings("%USERPROFILE%")
Set servList = GetObject("winmgmts:").ExecQuery("Select * From Win32_Process")
Dim res: res = Main()
Set servList = Nothing
Set fso = Nothing
Set shell = Nothing

If res <> "" Then
  WScript.Echo res
End If
WScript.Quit

'*******************************************************************************
' �@�\    �F���C��
' �@�\���e�F
' �߂�l  �F""    ����
'           <>""  �G���[���e
'*******************************************************************************
Private Function Main()
  Main = ""

  '�p�X��` -----------------------------------------------
'  ' ���h���C�u�w��Ȃ��Ńp�X��ʂ������ꍇ
  shell.Run "net use \\domainname domainname /user:username\username", 7, True

  '�A�v���N�� ---------------------------------------------

'  '�^�X�N�}�l�[�W���[
'  Main = ExecApp( _
'    "C:\Windows\System32\Taskmgr.exe", _
'    "/4", _
'    1 _
'  )
'  If Main <> "" Then Exit Function

  'Chrome
  Main = ExecApp( _
    "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe", _
    "", _
    27 _
  )
  If Main <> "" Then Exit Function

  'Slack
'  Main = ExecApp( _
'    "%USERPROFILE%\AppData\Local\slack\Update.exe", _
'    " --processStart ""slack.exe""", _
'    13 _
'  )
'  If Main <> "" Then Exit Function

'  'Vivaldi
'  Main = ExecApp( _
'    "C:\Users\ohbay\AppData\Local\Vivaldi\Application\vivaldi.exe", _
'    "", _
'    23 _
'  )
'  If Main <> "" Then Exit Function

  'KeePass.exe
'  Main = ExecApp( _
'    "C:\Program Files (x86)\KeePass Password Safe 2\KeePass.exe", _
'    "", _
'    7 _
'  )
'  If Main <> "" Then Exit Function
End Function

'*******************************************************************************
' �@�\    �F�A�v���N��
' �@�\���e�F
' ����    �Fin  aFileFullpath  �t���p�X�t�@�C����
'           in  aCommand       �R�}���h���C������
'           in  aSleep         �N����X���[�v����(1�b=1000)
' �߂�l  �F""    ����
'           <>""  �G���[���e
'*******************************************************************************
Private Function ExecApp( _
  ByVal aFileFullpath, _
  ByVal aCommand, _
  ByVal aSleepSec _
)
  On Error Resume Next

  Dim fileFullpath: fileFullpath = Replace(aFileFullpath, "%USERPROFILE%", profPath)

  ExecApp = ""
  If fso.FileExists(fileFullpath) = False Then
    ExecApp = "�G���[:�w�肳�ꂽ�p�X�ɃA�v���P�[�V���������݂��܂���B" & vbCrLf & aFileFullpath
    Exit Function
  End If

  Dim targetFile: Set targetFile = fso.GetFile(fileFullpath)
  Dim service
  For Each service In servList
    If service.Name = targetFile.Name Then
      Exit Function
    End If
  Next
  shell.CurrentDirectory = targetFile.ParentFolder
  shell.Exec(Trim(targetFile.Path & " " & aCommand))
  If Err.Number = 0 Then
    WScript.Sleep aSleepSec * 1000
  Else
    ExecApp = targetFile.Name & vbCrLf & vbCrLf & "�G���[:" & Err.Description
  End If
End Function

'*******************************************************************************
' �@�\    �F�A�v���N��
' �@�\���e�F
' ����    �Fin  aCommand       �R�}���h���C������
'           in  aSleep         �N����X���[�v����(1�b=1000)
' �߂�l  �F""    ����
'           <>""  �G���[���e
'*******************************************************************************
Private Function RunApp( _
  ByVal aCommand, _
  ByVal aSleepSec _
)
  On Error Resume Next

  RunApp = ""
  Dim ret: ret = shell.Run("cmd /c """ & aCommand & """", 7, True)
  If Err.Number = 0 Then
    WScript.Sleep aSleepSec * 1000
  Else
    RunApp = aCommand & vbCrLf & vbCrLf & "�G���[:" & Err.Description
  End If
End Function

'Run���\�b�h
' strCommand
'     ���s����R�}���h ���C��������������l�ł��B���̈����ɂ́A���s�\�t�@�C���ɓn���ׂ��p�����[�^�����ׂĊ܂߂�K�v������܂��B
' intWindowStyle
'     �ȗ��\�ł��B�v���O�����̃E�B���h�E�̊O�ς����������l�ł��B���ׂẴv���O���������̏����g�p����킯�ł͂Ȃ��̂Œ��ӂ��Ă��������B
' bWaitOnReturn
'     �ȗ��\�ł��B�X�N���v�g���̎��̃X�e�[�g�����g�ɐi�܂��Ƀv���O�����̎��s���I������܂ŃX�N���v�g��ҋ@�����邩�ǂ����������u�[���l�ł��B
'     bWaitOnReturn �� TRUE ���w�肷��ƁA�v���O�����̎��s���I������܂ŃX�N���v�g�̎��s�͒��f����A
'     Run ���\�b�h�̓A�v���P�[�V��������Ԃ����C�ӂ̃G���[ �R�[�h��Ԃ��܂��BbWaitOnReturn �� FALSE ���w�肷��ƁA
'     �v���O�������J�n����� Run ���\�b�h�͑����ɕ��A���Ď����I�� 0 ��Ԃ��܂� (������G���[ �R�[�h�Ƃ��ĉ��߂��Ȃ��ł�������)�B
'
'IntWindowStyle ���e
' 0 �E�B���h�E���\���ɂ��A�ʂ̃E�B���h�E���A�N�e�B�u�ɂ��܂��B
' 1 �E�B���h�E���A�N�e�B�u�ɂ��ĕ\�����܂��B�E�B���h�E���ŏ����܂��͍ő剻����Ă���ꍇ�́A���̃T�C�Y�ƈʒu�ɖ߂�܂��B
'   �A�v���P�[�V�����ŃE�B���h�E���ŏ��ɕ\������Ƃ��ɂ́A���̃t���O���w�肵�Ă��������B
' 2 �E�B���h�E���A�N�e�B�u�ɂ��A�ŏ����E�B���h�E�Ƃ��ĕ\�����܂��B
' 3 �E�B���h�E���A�N�e�B�u�ɂ��A�ő剻�E�B���h�E�Ƃ��ĕ\�����܂��B
' 4 �E�B���h�E���ŐV�̃T�C�Y�ƈʒu�ŕ\�����܂��B�A�N�e�B�u�ȃE�B���h�E�͐؂�ւ��܂���B
' 5 �E�B���h�E���A�N�e�B�u�ɂ��A���݂̃T�C�Y�ƈʒu�ŕ\�����܂��B
' 6 �w�肵���E�B���h�E���ŏ������AZ �I�[�_�[��Ŏ��ɏ�ʂƂȂ�E�B���h�E���A�N�e�B�u�ɂ��܂��B
' 7 �E�B���h�E���ŏ����E�B���h�E�Ƃ��ĕ\�����܂��B�A�N�e�B�u�ȃE�B���h�E�͐؂�ւ��܂���B
' 8 �E�B���h�E�����݂̏�Ԃŕ\�����܂��B�A�N�e�B�u�ȃE�B���h�E�͐؂�ւ��܂���B
' 9 �E�B���h�E���A�N�e�B�u�ɂ��ĕ\�����܂��B�E�B���h�E���ŏ����܂��͍ő剻����Ă���ꍇ�́A���̃T�C�Y�ƈʒu�ɖ߂�܂��B
'   �A�v���P�[�V�����ōŏ����E�B���h�E�𕜌�����Ƃ��ɂ́A���̃t���O���w�肵�Ă��������B
'10 �A�v���P�[�V�������N�������v���O�����̏�ԂɊ�Â��āA�\����Ԃ�ݒ肵�܂��B
