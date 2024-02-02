GetMonitors() {
  static monitors := []
  if (monitors.Length == 0) {
    monitorCount := MonitorGetCount()
    Loop monitorCount {
      MonitorGet A_Index, &mL, &mT, &mR, &mB
      monitors.Push({id: A_Index, left: mL, right: mR, top: mT, bottom: mB})
    }
  }
  return monitors
}
