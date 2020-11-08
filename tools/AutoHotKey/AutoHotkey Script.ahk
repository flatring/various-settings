WinMoveG9(MntIdx = 0, MoveArea = 7) {
/*
　MntIdx : 異動先となるモニタ。デフォルトは0（移動しない）。
　MoveArea : 移動先となるグリッド（位置はテンキー参照）。デフォルトは7（左上）。
*/
  WinGet,WinId, ID, A
  WinGetPos, WinX, WinY, WinW, WinH, ahk_id %WinId%
  if MntIdx
    SysGet, Mnt, MonitorWorkArea, %MntIdx%
  else {
    WinYC := WinH // 2 + WinY, WinXC := WinW // 2 + WinX
    MntNum := 2 ; 有効なモニタ数（頻繁に変更するなら↓をアンコメント）
    ;~ SysGet, MntNum, 80
    Loop, %MntNum%
    {
      SysGet, Mnt, MonitorWorkArea, %A_Index%
      if (MntTop < WinYC) && (WinYC < MntBottom) && (MntLeft < WinXC) && (WinXC < MntRight)
        break
    }
  }

  if (7 == MoveArea || 4 == MoveArea || 1 == MoveArea)
    MoveX := MntLeft
  else if (8 == MoveArea || 5 == MoveArea || 2 == MoveArea)
    MoveX := (MntRight - MntLeft - WinW) / 2 + MntLeft
  else  ; if (9 == MoveArea || 6 == MoveArea || 3 == MoveArea)
    MoveX := MntRight - WinW

  if (7 == MoveArea || 8 == MoveArea || 9 == MoveArea)
    MoveY := MntTop
  else if (4 == MoveArea || 5 == MoveArea || 6 == MoveArea)
    MoveY := (MntBottom - MntTop - WinH) / 2 + MntTop
  else ; if (1 == MoveArea || 2 == MoveArea || 3 == MoveArea)
    MoveY := MntBottom - WinH

  WinMove, ahk_id %WinId%, , %MoveX%, %MoveY%
}

#Numpad1::WinMoveG9(0, 1)
#Numpad2::WinMoveG9(0, 2)
#Numpad3::WinMoveG9(0, 3)
#Numpad4::WinMoveG9(0, 4)
#Numpad5::WinMoveG9(0, 5)
#Numpad6::WinMoveG9(0, 6)
#Numpad7::WinMoveG9(0, 7)
#Numpad8::WinMoveG9(0, 8)
#Numpad9::WinMoveG9(0, 9)

#1::
  WinMoveG9(2)
return
#2::
  WinMoveG9(1)
return

#c::
  WinMoveG9(0, 5)
return