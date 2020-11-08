#Include GetMonitorCount.ahk

;===============================================================================
; functions
;===============================================================================
; アクティブウィンドウをディスプレイ間でスワップ
SwapMonitor() {
  WinGet, winId, ID, A
  WinGetPos, winX, winY, winW, winH, ahk_id %winId%
  winXC := winX + winW // 2
  winYC := winY + winH // 2
; MsgBox, winX:`t%winX%`nwinW:`t%winW%`nwinY:`t%winY%`nwinH:`t%winH%`n
  mntCnt := GetMonitorCount()
MsgBox, mntCnt:`t%mntCnt%
  loop, %mntCnt% {
    SysGet, mnt, Monitor, %A_Index%
; MsgBox, mntTop:`t%mntTop%`nmntBottom:`t%mntBottom%
; MsgBox, mntLeft:`t%mntLeft%`nmntRight:`t%mntRight%
    if (mntTop < winYC) && (winYC < mntBottom) && (mntLeft < winXC) && (winXC < mntRight) {
      actMntId := A_Index
      break
    }
  }
  mntId := (mntCnt < ++actMntId) ? 1 : actMntId
MsgBox, mntId:`t%mntId%
  SysGet, mnt, MonitorWorkArea, %mntId%
  moveX := (mntRight - mntLeft - winW) / 2 + mntLeft
  moveY := (mntBottom - mntTop - winH) / 2 + mntTop
  WinMove, ahk_id %mntId%, , %moveX%, %moveY%
}

;===============================================================================
; Symbol
;   # Win
;   ! Alt
;   ^ Control
;   + Shift
;   & 同時押し(例:Numpad0 & Numpad1)
;===============================================================================
; Win + Num5 : アクティブウィンドウをディスプレイ間でスワップ
#Numpad5::SwapMonitor()
return
