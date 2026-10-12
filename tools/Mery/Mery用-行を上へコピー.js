//■行を上へコピー（VSCode の Shift+Alt+↑ 風）
//・カーソル行、または選択範囲を含む行全体が対象。選択範囲は移動後も保持する。

//動作の定義(上へ:true/下へ:false、移動:false/コピー:true)
var $up = true;
var $copy = true;

with (Document.Selection) {
  var meP = mePosLogical;
  var ax = GetAnchorPointX(meP), ay = GetAnchorPointY(meP);
  var cx = GetActivePointX(meP), cy = GetActivePointY(meP);
  var ty = GetTopPointY(meP);
  var by = GetBottomPointY(meP);
  if (ty!=by && GetBottomPointX(meP)==1) by--;	//行選択時、改行の次の行を含めないよう対策
  var n = Document.GetLines();
  var cnt = by - ty + 1;

  var ln = [];
  for (var y=ty; y<=by; y++) ln.push(Document.GetLine(y));
  var block = ln.join("\n");

  var d;	//処理後に選択範囲をずらす行数
  if ($copy) {
    if ($up) {
      SetActivePoint(meP, 1, ty);
      Text = block + "\n";
      d = 0;
    } else {
      SetActivePoint(meP, Document.GetLine(by).length+1, by);
      Text = "\n" + block;
      d = cnt;
    }
  } else if ($up) {
    if (ty <= 1) Quit();
    var above = Document.GetLine(ty-1);
    SetActivePoint(meP, 1, ty-1);
    SetActivePoint(meP, Document.GetLine(by).length+1, by, true);
    Text = block + "\n" + above;
    d = -1;
  } else {
    if (by >= n) Quit();
    var below = Document.GetLine(by+1);
    SetActivePoint(meP, 1, ty);
    SetActivePoint(meP, below.length+1, by+1, true);
    Text = below + "\n" + block;
    d = 1;
  }

  SetActivePoint(meP, ax, ay+d);
  SetActivePoint(meP, cx, cy+d, true);
}
