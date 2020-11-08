#Include GetMonitorCount.ahk
#Include WindowSizeChange.ahk

;===============================================================================
; functions
;===============================================================================
; アクティブウィンドウの移動
WinMoveG9(mntIdx = 0, moveArea = 7) {
  ; mntIdx : 異動先となるモニタ。デフォルトは0(移動しない)。
  ; moveArea : 移動先となるグリッド(位置はテンキー参照。デフォルトは7(左上)。
  WinGet, winId, ID, A
  WinGet, procNm, ProcessName, A

  WinRestore, ahk_id %winId%
  WinActivate, ahk_id %winId%

  WinGetPos, winX, winY, winW, winH, ahk_id %winId%
  if mntIdx {
    SysGet, mnt, MonitorWorkArea, %mntIdx%
; MsgBox, mntIdx: %mntIdx%`n mntT: %mntTop%`n mntB: %mntBottom%`n mntL: %mntLeft%`n mntR: %mntRight%
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

  mntSizeX := Ceil((mntRight - mntLeft) * 0.95)
  if (winW > mntSizeX) {
    winW := mntSizeX
  }
  mntSizeY := Ceil((mntBottom - mntTop) * 0.95)
  if (winH > mntSizeY) {
    winH := mntSizeY
  }

  if (moveArea == 1 || moveArea == 4 || moveArea == 7)
    moveX := mntLeft
  else if (moveArea == 2 || moveArea == 5 || moveArea == 8)
    moveX := (mntSizeX - winW) / 2 + mntLeft
  else ; if (moveArea == 3 || moveArea == 6 || moveArea == 9)
    moveX := mntRight - winW
  moveX := Round(moveX)

  if (moveArea == 7 || moveArea == 8 || moveArea == 9)
    moveY := mntTop
  else if (moveArea == 4 || moveArea == 5 || moveArea == 6)
    moveY := (mntSizeY - winH) / 2 + mntTop
  else ; if (moveArea == 1 || moveArea == 2 || moveArea == 3)
    moveY := mntBottom - winH
 moveY := Round(moveY)

  ; WinMove, ahk_id %winId%, , %moveX%, %moveY%, %winW%, %winH%
  WinMove, ahk_id %winId%, , %moveX%, %moveY%
  WinMove, ahk_id %winId%, , , , %winW%, %winH%
; MsgBox, mntIdx: %mntIdx%`n mntT: %mntTop%`n mntB: %mntBottom%`n mntL: %mntLeft%`n mntR: %mntRight%`n`nwinId: %winId% - %procNm%`n moveX: %moveX%`n winW: %winW%`n moveY: %moveY%`n winH: %winH%
}

;===============================================================================
; Symbol
;   # Win
;   ! Alt
;   ^ Control
;   + Shift
;   & 同時押し(例:Numpad0 & Numpad1)
;===============================================================================
; PCモニター Win + Ten Key
#Numpad1::WinMoveG9(1, 1) return
#Numpad2::WinMoveG9(1, 2) return
#Numpad3::WinMoveG9(1, 3) return
#Numpad4::WinMoveG9(1, 4) return
#Numpad5::WinMoveG9(1, 5) return
#Numpad6::WinMoveG9(1, 6) return
#Numpad7::WinMoveG9(1, 7) return
#Numpad8::WinMoveG9(1, 8) return
#Numpad9::WinMoveG9(1, 9) return

; 拡張モニター Win + Alt + Ten Key
#!Numpad1::WinMoveG9(2, 1) return
#!Numpad2::WinMoveG9(2, 2) return
#!Numpad3::WinMoveG9(2, 3) return
#!Numpad4::WinMoveG9(2, 4) return
#!Numpad5::WinMoveG9(2, 5) return
#!Numpad6::WinMoveG9(2, 6) return
#!Numpad7::WinMoveG9(2, 7) return
#!Numpad8::WinMoveG9(2, 8) return
#!Numpad9::WinMoveG9(2, 9) return
