'===============================================================================
'-------------------------------------------------------------------------------
' アプリ一括起動
'-------------------------------------------------------------------------------
' 機能内容
'   ・ネットワーク接続
'   ・アプリケーションを登録順に起動する
'   ・
'-------------------------------------------------------------------------------
' 備考
'   ・指定のアプリケーションが既に起動中であれば飛ばす
'   ・
'-------------------------------------------------------------------------------
'===============================================================================
'**Start Encode**

Option Explicit

'************************************************
' スクリプト内共通変数
'************************************************
Dim servList


'*******************************************************************************
' スタート
'*******************************************************************************
' 管理者として実行を強制する
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
' 機能    ：メイン
' 機能内容：
' 戻り値  ：""    正常
'           <>""  エラー内容
'*******************************************************************************
Private Function Main()
  Main = ""

  'パス定義 -----------------------------------------------
'  ' ※ドライブ指定なしでパスを通したい場合
  shell.Run "net use \\domainname domainname /user:username\username", 7, True

  'アプリ起動 ---------------------------------------------

'  'タスクマネージャー
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
' 機能    ：アプリ起動
' 機能内容：
' 引数    ：in  aFileFullpath  フルパスファイル名
'           in  aCommand       コマンドライン引数
'           in  aSleep         起動後スリープ時間(1秒=1000)
' 戻り値  ：""    正常
'           <>""  エラー内容
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
    ExecApp = "エラー:指定されたパスにアプリケーションが存在しません。" & vbCrLf & aFileFullpath
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
    ExecApp = targetFile.Name & vbCrLf & vbCrLf & "エラー:" & Err.Description
  End If
End Function

'*******************************************************************************
' 機能    ：アプリ起動
' 機能内容：
' 引数    ：in  aCommand       コマンドライン引数
'           in  aSleep         起動後スリープ時間(1秒=1000)
' 戻り値  ：""    正常
'           <>""  エラー内容
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
    RunApp = aCommand & vbCrLf & vbCrLf & "エラー:" & Err.Description
  End If
End Function

'Runメソッド
' strCommand
'     実行するコマンド ラインを示す文字列値です。この引数には、実行可能ファイルに渡すべきパラメータをすべて含める必要があります。
' intWindowStyle
'     省略可能です。プログラムのウィンドウの外観を示す整数値です。すべてのプログラムがこの情報を使用するわけではないので注意してください。
' bWaitOnReturn
'     省略可能です。スクリプト内の次のステートメントに進まずにプログラムの実行が終了するまでスクリプトを待機させるかどうかを示すブール値です。
'     bWaitOnReturn に TRUE を指定すると、プログラムの実行が終了するまでスクリプトの実行は中断され、
'     Run メソッドはアプリケーションから返される任意のエラー コードを返します。bWaitOnReturn に FALSE を指定すると、
'     プログラムが開始すると Run メソッドは即座に復帰して自動的に 0 を返します (これをエラー コードとして解釈しないでください)。
'
'IntWindowStyle 内容
' 0 ウィンドウを非表示にし、別のウィンドウをアクティブにします。
' 1 ウィンドウをアクティブにして表示します。ウィンドウが最小化または最大化されている場合は、元のサイズと位置に戻ります。
'   アプリケーションでウィンドウを最初に表示するときには、このフラグを指定してください。
' 2 ウィンドウをアクティブにし、最小化ウィンドウとして表示します。
' 3 ウィンドウをアクティブにし、最大化ウィンドウとして表示します。
' 4 ウィンドウを最新のサイズと位置で表示します。アクティブなウィンドウは切り替わりません。
' 5 ウィンドウをアクティブにし、現在のサイズと位置で表示します。
' 6 指定したウィンドウを最小化し、Z オーダー上で次に上位となるウィンドウをアクティブにします。
' 7 ウィンドウを最小化ウィンドウとして表示します。アクティブなウィンドウは切り替わりません。
' 8 ウィンドウを現在の状態で表示します。アクティブなウィンドウは切り替わりません。
' 9 ウィンドウをアクティブにして表示します。ウィンドウが最小化または最大化されている場合は、元のサイズと位置に戻ります。
'   アプリケーションで最小化ウィンドウを復元するときには、このフラグを指定してください。
'10 アプリケーションを起動したプログラムの状態に基づいて、表示状態を設定します。
