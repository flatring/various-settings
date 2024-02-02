#Include "GetMonitors.ahk"

GetMonitorNumber(winId, monitors) {
  monitorNumber := 1
  WinGetPos(&winX, &winY, &winW, &winH, "ahk_id " winId)
  monitors := GetMonitors()
  For mon in monitors {
    if (winX >= mon.left and winX <= mon.right) {
      if (winY >= mon.top and winY <= mon.bottom) {
        monitorNumber := mon.id
        break
      }
    }
  }
  return monitorNumber
}
