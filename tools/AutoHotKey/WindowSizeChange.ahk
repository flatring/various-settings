#Include "GetMonitorNumber.ahk"

;===============================================================================
; functions
;===============================================================================
; アクティブウィンドウのサイズ変更
WinSizeChange(direction := "H", action := "+") {
  winLimit := 500
  winIncrementSize := 100
  winId := WinGetID("A")
  WinGetPos(&winX, &winY, &winW, &winH, "ahk_id " winId)
  monitors := GetMonitors()
  monNum := GetMonitorNumber(winId, monitors)
  MonitorGetWorkArea(monNum, &mntLeft, &mntTop, &mntRight, &mntBottom)

  winInc := winIncrementSize * (action == "+" ? 1 : -1)
  if (direction == "H") {
    winH := winH + winInc
  } else if (direction == "W") {
    winW := winW + winInc
  }
  if (winH < winLimit)
    winH := winLimit
  if (winW < winLimit)
    winW := winLimit
  if (winY + winH > mntBottom)
    winY := mntBottom - winH
  if (winX + winW > mntRight)
    winX := mntRight - winW

  WinMove(winX, winY, winW, winH, "ahk_id " winId)
}

;===============================================================================
; Symbol
;   # Win
;   ! Alt
;   ^ Control
;   + Shift
;   & 同時押し(例:Numpad0 & Numpad1)
;===============================================================================
; アクティブウィンドウのサイズ変更 Win + Ctrl + Arrow key
#!Up::WinSizeChange("H", "-")
#!Down::WinSizeChange("H", "+")
#!Left::WinSizeChange("W", "-")
#!Right::WinSizeChange("W", "+")
