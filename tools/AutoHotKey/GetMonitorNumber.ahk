#Include "GetMonitors.ahk"

GetMonitorNumber(winId, monitors) {
  monitorNumber := 1
  WinGetPos(&winX, &winY, &winW, &winH, "ahk_id " winId)
  ; ウィンドウ中心点で判定(画面端に寄せたウィンドウが隣モニタ扱いになるのを防ぐ)
  centerX := winX + winW // 2
  centerY := winY + winH // 2
  For mon in monitors {
    ; 右端・下端は半開区間で扱い、モニタ境界上での二重マッチを防ぐ
    if (centerX >= mon.left and centerX < mon.right) {
      if (centerY >= mon.top and centerY < mon.bottom) {
        monitorNumber := mon.id
        break
      }
    }
  }
  return monitorNumber
}
