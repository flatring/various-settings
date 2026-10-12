#Include "GetMonitors.ahk"

; NumLock キーはカーソルスワップに使うため、テンキーは常に数字扱いに固定する
SetNumLockState("AlwaysOn")

;===============================================================================
; functions
;===============================================================================
; マウスカーソルのあるモニター番号を返す
GetCursorOnActiveMonitor() {
  CoordMode("Mouse", "Screen")
  MouseGetPos(&curX, &curY)
  For mon in GetMonitors() {
    ; 右端・下端は半開区間で扱い、モニタ境界上での二重マッチを防ぐ
    if (curX >= mon.left and curX < mon.right and curY >= mon.top and curY < mon.bottom)
      return mon.id
  }
  return 1
}

; マウスカーソルを次のディスプレイの中央へ移動
SwapCursor() {
  monitors := GetMonitors()
  mntId := GetCursorOnActiveMonitor() + 1
  if (mntId > monitors.Length)
    mntId := 1
  MonitorGetWorkArea(mntId, &mntLeft, &mntTop, &mntRight, &mntBottom)
  MouseMove(mntLeft + (mntRight - mntLeft) // 2, mntTop + (mntBottom - mntTop) // 2)
  ; 軌跡も無く瞬時に移動したい場合はWindowsAPIを使用
  ; DllCall("SetCursorPos", "Int", x, "Int", y)
}

;===============================================================================
; Symbol
;   # Win
;   ! Alt
;   ^ Control
;   + Shift
;   & 同時押し(例:Numpad0 & Numpad1)
;===============================================================================
; NumLock : マウスカーソルをディスプレイ間でスワップ
NumLock:: SwapCursor()
