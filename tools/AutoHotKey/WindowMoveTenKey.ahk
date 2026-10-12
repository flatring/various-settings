; 公式: https://ankscript.github.io/ja/docs/v2/index.htm
; 非公式日本語: http://ahkwiki.net/Top

#Include "GetMonitorNumber.ahk"
#Include "WindowSizeChange.ahk"
#Include "SwapCursor.ahk"

;===============================================================================
; functions
;===============================================================================
; アクティブウィンドウ次(前)に移動
MoveMonitor(next := true) {
  WinId := WinGetID("A")
  monitors := GetMonitors()
  monNum := GetMonitorNumber(WinId, monitors)
  if (next) {
    monNum := monNum + 1
    if (monNum > monitors.Length)
      monNum := 1
  } else {
    monNum := monNum - 1
    if (monNum < 1)
      monNum := monitors.Length
  }
  MoveActiveWindow(WinId, monNum)
}

; アクティブウィンドウの移動
WinMoveCorner(posiV := "center", posiH := "center") {
  winId := WinGetID("A")
  monitors := GetMonitors()
  monNum := GetMonitorNumber(WinId, monitors)
  MoveActiveWindow(winId, monNum, posiV, posiH)
}

; アクティブウィンドウの移動 & サイズ調整
MoveActiveWindow(winId, monNum, posiV := "center", posiH := "center") {
  ; 最大化・最小化時のみ復元し、復元完了(非同期)を待ってから座標を取得する
  if (WinGetMinMax("ahk_id " winId) != 0) {
    WinRestore("ahk_id " winId)
    deadline := A_TickCount + 500
    while (WinGetMinMax("ahk_id " winId) != 0 and A_TickCount < deadline)
      Sleep(10)
  }
  WinGetPos(&winX, &winY, &winW, &winH, "ahk_id " winId)
  MonitorGetWorkArea(monNum, &mntLeft, &mntTop, &mntRight, &mntBottom)

  mntW := mntRight - mntLeft
  mntH := mntBottom - mntTop

  ; 作業領域の95%を上限にサイズを制限
  maxW := Ceil(mntW * 0.95)
  if (winW > maxW) {
    winW := maxW
  }
  maxH := Ceil(mntH * 0.95)
  if (winH > maxH) {
    winH := maxH
  }

  if (posiH == "left")
    moveX := mntLeft
  else if (posiH == "center")
    moveX := (mntW - winW) / 2 + mntLeft
  else ; if (posiH == "right")
    moveX := mntRight - winW
  moveX := Round(moveX)

  if (posiV == "top")
    moveY := mntTop
  else if (posiV == "center")
    moveY := (mntH - winH) / 2 + mntTop
  else ; if (posiV == "bottom")
    moveY := mntBottom - winH
  moveY := Round(moveY)

  ; 制限後のサイズも同時に適用する
  WinMove(moveX, moveY, winW, winH, "ahk_id " winId)
}

;===============================================================================
; Symbol
;   # Win
;   ! Alt
;   ^ Control
;   + Shift
;   & 同時押し(例:Numpad0 & Numpad1)
;===============================================================================
; 前のモニターに移動 : Win + Alt + NumpadDiv(/)
#!NumpadDiv:: MoveMonitor(false)

; 次のモニターに移動 : Win + Alt + NumpadMult(*)
#!NumpadMult:: MoveMonitor(true)

; 前(次)のモニターに移動 : Win + Shift + ←(→)
;   Windows標準の Win+Shift+←/→ を上書き。移動時に最大化を解除し、
;   作業領域の95%を超えるサイズは縮めて中央に配置する(=リサイズを伴う)
;   ※ Win+Shift+↑/↓ は上書きしていない(Windows標準: 高さを画面いっぱいに伸ばす/戻す)
#+Left:: MoveMonitor(false)
#+Right:: MoveMonitor(true)

; モニター内の位置へ移動 : Win + Alt + Ten Key (テンキーの配置 = 画面の9分割位置)
#!Numpad1::WinMoveCorner("bottom", "left")
#!Numpad2::WinMoveCorner("bottom", "center")
#!Numpad3::WinMoveCorner("bottom", "right")
#!Numpad4::WinMoveCorner("center", "left")
#!Numpad5::WinMoveCorner("center", "center")
#!Numpad6::WinMoveCorner("center", "right")
#!Numpad7::WinMoveCorner("top", "left")
#!Numpad8::WinMoveCorner("top", "center")
#!Numpad9::WinMoveCorner("top", "right")
