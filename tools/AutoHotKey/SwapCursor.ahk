#Include GetMonitorCount.ahk

;===============================================================================
; functions
;===============================================================================
; マウスカーソルのあるモニター番号を返す
GetCursorOnActiveMonitor() {
  CoordMode, Mouse, Screen
  MouseGetPos, curX, curY
; MsgBox, curX:`t%curX%`ncurY:`t%curY%
  mntNum := GetMonitorCount()
  loop, %mntNum% {
    SysGet, mnt, Monitor, %A_Index%
; MsgBox, mntTop:`t%mntTop%`nmntBottom:`t%mntBottom%
; MsgBox, mntLeft:`t%mntLeft%`nmntRight:`t%mntRight%
    if (mntTop < curY) && (curY < mntBottom) && (mntLeft < curX) && (curX < mntRight) {
      return A_Index
    }
  }
}

;===============================================================================
; Symbol
;   # Win
;   ! Alt
;   ^ Control
;   + Shift
;   & 同時押し(例:Numpad0 & Numpad1)
;===============================================================================
; Ctrl + Q : マウスカーソルをディスプレイ間でスワップ
^q::
  mntCnt := GetMonitorCount()
  actMntId := GetCursorOnActiveMonitor()
  ; mntId := actMntId + 1
  ; if (mntCnt < mntId) {
  ;   mntId = 1
  ; }
  mntId := (mntCnt < ++actMntId) ? 1 : actMntId
; MsgBox, Monitor Count:`t%mntCnt%`nActive Monitor ID:`t%actMntId%`nMonitor ID:`t%mntId%
  SysGet, mnt, MonitorWorkArea, %mntId%
  MouseMove, mntLeft + (mntRight - mntLeft) // 2, mntTop + (mntBottom - mntTop) // 2
  ; 軌跡も無く瞬時に移動したい場合はWindowsAPIを使用
  ; DllCall("SetCursorPos", UInt,x - A_ScreenWidth, UInt,y)
  return
