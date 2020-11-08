; モニター数を返す
GetMonitorCount() {
  static mntCount = -1
  if (mntCount > -1) {
    return mntCount
  }
  SysGet, mntCount, 80  ;SM_CMONITORS
  return mntCount
}
