'===============================================================================
'-------------------------------------------------------------------------------
' ログの最終行表示
'-------------------------------------------------------------------------------
' 条件
'   ・対象のログファイルがこれを実行する前に作成されていること
'-------------------------------------------------------------------------------
' 操作１
'   1.コマンドプロンプトウィンドウを立ち上げる
'   2.カレントパスをログファイルの出力先フォルダに変更する
'   3.↓のコマンドをコマンドプロンプトウィンドウにペーストする
'     CScript.exe //NoLogo tail-f.vbs /filename:ログファイル名  /LineLastcount:最初の表示行数
'   4.中断する場合は「Ctrl + c」で停止
'
' 操作２
'   1.ログファイルをドラッグしてこのスクリプトにドロップする
'
'-------------------------------------------------------------------------------
' イマイチなところ
'   ・実行時にログファイルがすでに巨大だった場合、
'     ファイルを全読みするためにtailまでに時間がかかってしまうこと
'     →なので、実行時のログファイルサイズは小さくしておくことがオススメ
'     →一応、最終行付近まで出力しないように対応済み(負荷は減っている)
'-------------------------------------------------------------------------------
'===============================================================================
'**Start Encode**

Option Explicit

Const ForReading = 1

CompulsionCscript()

'コマンドライン引数の取得
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

'ログファイルの存在確認
Dim fso: Set fso = WScript.CreateObject("Scripting.FileSystemObject")
If fso.FileExists(fileName) = False Then
  WScript.Echo "File Nothing=" & fileName
  WScript.Quit
End If

WScript.Echo ""
WScript.Echo "<Infomation>「Ctrl+c」で処理を中断"
WScript.Echo ""


'中断されるまで永久ループ
Dim targetFile
Dim fileSize
Dim line()
Dim posi
Do
  Set targetFile = fso.OpenTextFile(fileName, ForReading, False)
  fileSize = 0

  '初回読み飛ばし
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

  'ファイルサイズが小さくなった時に抜ける
  Do
    'ログ表示
    If targetFile.AtEndOfStream = True Then
      fileSize = fso.GetFile(fileName).Size
      WScript.Sleep 1000
    Else
      WScript.Echo targetFile.ReadLine
    End If
  Loop Until fileSize > fso.GetFile(fileName).Size
  targetFile.Close

  WScript.Echo ""
  WScript.Echo "<Infomation>ファイルの再読み込み"
  WScript.Echo ""
Loop
Set targetFile = Nothing
WScript.Quit

'******************************************************************************
' 機能    ：強制CSript実行
' 機能内容：
' 引数    ：なし
'******************************************************************************
Private Sub CompulsionCscript()
  If InStr(LCase(WScript.FullName), "wscript") > 0 Then
    Dim commands: commands = Array("cmd.exe /c CScript.exe", """" & WScript.ScriptFullName & """")  '終了後にプロンプトを閉じないようにするには"/c"を"/k"に変更する
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
