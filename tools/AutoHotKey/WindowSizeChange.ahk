#Include "GetMonitorNumber.ahk"

;===============================================================================
; functions
;===============================================================================
; アクティブウィンドウのサイズ変更
WinSizeChange(direction := "H", action := "+") {
  winLimit := 640
  winIncrementSize := 240
  winId := WinGetID("A")
  WinGetPos(&winX, &winY, &winW, &winH, "ahk_id " winId)
  monitors := GetMonitors()
  monNum := GetMonitorNumber(winId, monitors)
  MonitorGetWorkArea(monNum, &mntLeft, &mntTop, &mntRight, &mntBottom)

  winInc := winIncrementSize * (action == "+" ? 1 : -1)
  if (direction == "H") {
    winH := winH + winInc
    if (winH < winLimit)
      winH := winLimit
    if (winH > (mntBottom - mntTop))
      winH := mntBottom - mntTop
  } else if (direction == "W") {
    winW := winW + winInc
    ; 修正箇所: 幅を最小値と最大値で制限
    if (winW < winLimit)
      winW := winLimit
    if (winW > (mntRight - mntLeft)) ; モニターの幅を超えないように制限
      winW := mntRight - mntLeft
  }

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
