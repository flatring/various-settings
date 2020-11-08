#Include GetMonitorCount.ahk

;===============================================================================
; functions
;===============================================================================
; アクティブウィンドウのサイズ変更
WinSizeChange(direction = 1) {
  ; direction : 移動先の方向(1=Up, 2=Down, 3=Left, 4=Right)。
  winIncrementSize := 100
  WinGet, winId, ID, A
  WinGetPos, winX, winY, winW, winH, ahk_id %winId%
  mntCnt := GetMonitorCount()
  winXC := winX + winW // 2
  winYC := winY + winH // 2
  loop, %mntCnt% {
    SysGet, mnt, MonitorWorkArea, %A_Index%
    if (mntTop < winYC) and (winYC < mntBottom) and (mntLeft < winXC) and (winXC < mntRight) {
      break
    }
  }

  winInc := winIncrementSize
  if (direction == 1) {
    if (IsBetween(winY, mntTop))
      winInc := winInc * -1
    winH := winH + winInc
    if (winH > mntBottom - mntTop)
      exit
    if (winY < mntTop)
      winY := mntTop
    if (winY + winH > mntBottom)
      winY := mntBottom - winH
  } else if (direction == 2) {
    if (IsBetween(winY + winH, mntBottom)) {
      winY := winY + winInc
      winInc := winInc * -1
    }
    winH := winH + winInc
    if (winH > mntBottom - mntTop)
      exit
    if (winY + winH > mntBottom)
      winY := mntBottom - winH
  } else if (direction == 3) {
    if (IsBetween(winX, mntLeft))
      winInc := winInc * -1
    winW := winW + winInc
    if (winW > mntRight - mntLeft)
      exit
    if (winX < mntLeft)
      winX := mntLeft
    if (winX + winW > mntRight)
      winX := mntRight - winW
  } else if (direction == 4) {
    if (IsBetween(winX + winW, mntRight)) {
      winX := winX + winInc
      winInc := winInc * -1
    }
    winW := winW + winInc
    if (winW > mntRight - mntLeft)
      exit
    if (winX + winW > mntRight)
      winX := mntRight - winW
  }

  WinMove, ahk_id %winId%, , %winX%, %winY%, %winW%, %winH%
}

;===============================================================================
; 範囲一致
IsBetween(target, matchRange) {
  bufRange := 2
  rngLo := matchRange + bufRange * -1
  rngHi := matchRange + bufRange
  ret := false
  if (rngLo <= target and target <= rngHi)
    ret := true
  return ret
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
#^Up::WinSizeChange(1) return
#^Down::WinSizeChange(2) return
#^Left::WinSizeChange(3) return
#^Right::WinSizeChange(4) return
