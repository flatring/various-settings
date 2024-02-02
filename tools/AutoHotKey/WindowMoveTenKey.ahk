; 公式: https://ankscript.github.io/ja/docs/v2/index.htm
; 非公式日本語: http://ahkwiki.net/Top

#Include "GetMonitorNumber.ahk"
#Include "WindowSizeChange.ahk"

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
MoveActiveWindow(WinId, monNum, posiV := "center", posiH := "center") {
  WinRestore("ahk_id " winId)
  WinGetPos(&winX, &winY, &winW, &winH, "ahk_id " winId)
  MonitorGetWorkArea(monNum, &mntLeft, &mntTop, &mntRight, &mntBottom)

  mntSizeX := Ceil((mntRight - mntLeft) * 0.95)
  if (winW > mntSizeX) {
    winW := mntSizeX
  }
  mntSizeY := Ceil((mntBottom - mntTop) * 0.95)
  if (winH > mntSizeY) {
    winH := mntSizeY
  }

  if (posiH == "left")
    moveX := mntLeft
  else if (posiH == "center")
    moveX := (mntSizeX - winW) / 2 + mntLeft
  else ; if (posiH == "right")
    moveX := mntRight - winW
  moveX := Round(moveX)

  if (posiV == "top")
    moveY := mntTop
  else if (posiV == "center")
    moveY := (mntSizeY - winH) / 2 + mntTop
  else ; if (posiV == "bottom")
    moveY := mntBottom - winH
  moveY := Round(moveY)

  WinMove(moveX, moveY, , , winId)
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

; モニター移動 : Win + Alt + Ten Key
#!Numpad1::WinMoveCorner("bottom", "left")
#!Numpad2::WinMoveCorner("bottom", "center")
#!Numpad3::WinMoveCorner("bottom", "right")
#!Numpad4::WinMoveCorner("center", "left")
#!Numpad5::WinMoveCorner("center", "center")
#!Numpad6::WinMoveCorner("center", "right")
#!Numpad7::WinMoveCorner("top", "left")
#!Numpad8::WinMoveCorner("top", "center")
#!Numpad9::WinMoveCorner("top", "right")
