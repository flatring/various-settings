#Include GetMonitorCount.ahk
#Include WindowSizeChange.ahk

;===============================================================================
; functions
;===============================================================================
; アクティブウィンドウのポジション変更
WinMoveArrow(mntIdx = 0, direction = 1, winIncrementSize = 0) {
  ; mntIdx : 異動先となるモニタ。デフォルトは0(移動しない)。
  ; direction : 移動先の方向(1=Up, 2=Down, 3=Left, 4=Right)。
  WinGet, winId, ID, A
  WinGetPos, winX, winY, winW, winH, ahk_id %winId%
  if mntIdx {
    SysGet, mnt, MonitorWorkArea, %mntIdx%
  } else {
    winXC := winX + winW // 2
    winYC := winY + winH // 2
    mntCnt := GetMonitorCount()
    loop, %mntCnt% {
      SysGet, mnt, MonitorWorkArea, %A_Index%
      if (mntTop < winYC) && (winYC < mntBottom) && (mntLeft < winXC) && (winXC < mntRight) {
        break
      }
    }
  }

  winSizeY := (MntBottom - MntTop) * 0.9
  if (winH < winSizeY) {
    winSizeY := winH
  }
  winSizeX := (MntRight - MntLeft) * 0.9
  if (winW < winSizeX) {
    winSizeX := winW
  }

  if (direction == 1 or direction == 2) {   ; in演算子はバグってて使えない。
    moveY := (mntBottom - MntTop - winSizeY) / 2 + mntTop
    if (direction == 1 and winY > mntTop) {
      moveY := mntTop
    }
    if (direction == 2 and (winY + winSizeY) < mntBottom) {
      moveY := mntBottom - winSizeY
    }
  } else {
    moveY := winY
  }

  if (direction == 3 or direction == 4) {   ; in演算子はバグってて使えない。
    moveX := (mntRight - mntLeft - winSizeX) / 2 + mntLeft
    if (direction == 3 and winX > mntLeft) {
      moveX := mntLeft
    }
    if (direction == 4 and (winX + winSizeX) < mntRight) {
      moveX := mntRight - winSizeX
    }
  } else {
    moveX := winX
  }
  WinMove, ahk_id %winId%, , %moveX%, %moveY%, %winSizeX%, %winSizeY%
}

;===============================================================================
; Symbol
;   # Win
;   ! Alt
;   ^ Control
;   + Shift
;   & 同時押し(例:Numpad0 & Numpad1)

; PCモニター Win + Arrow key
#Up::WinMoveArrow(1, 1) return
#Down::WinMoveArrow(1, 2) return
#Left::WinMoveArrow(1, 3) return
#Right::WinMoveArrow(1, 4) return

; 拡張モニター Win + Alt + Arrow key
!#Up::WinMoveArrow(2, 1) return
!#Down::WinMoveArrow(2, 2) return
!#Left::WinMoveArrow(2, 3) return
!#Right::WinMoveArrow(2, 4) return

return
