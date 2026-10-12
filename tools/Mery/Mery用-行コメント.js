//■行コメントのオン/オフ
//・行頭にコメント文字が有れば削除し、無ければ付加する。空白行には付加しない。


//■インデントされたコメント文字も削除(true:する/false:しない) ●初期値=false
var $indent = false ? "[ \t]*" : "";

//■行コメント文字の定義。編集モードによる定義切替
var $comment;
switch (Document.Mode.toLowerCase()) {
case "bat":
  $comment = "::"; break;
case "c#":
case "c++":
case "javascript":
  $comment = "//"; break;
case "ini":
case "python":
case "ruby":
  $comment = "#"; break;
case "visualbasic":
case "vbscript":
  $comment = "'"; break;
default:
  $comment = "//";
}

with (Document.Selection) {
  var meP = mePosLogical;
  var ty = GetTopPointY(meP);
  var by = GetBottomPointY(meP);
  var bx = GetBottomPointX(meP);
  if (ty!=by && bx==1) by--;	//行選択時、次行を含めないよう対策
  SetActivePoint(meP, 1, by+1);
  SetAnchorPoint(meP, 1, ty);
  var re = new RegExp("^(?=[ \t]*$)|^("+$indent+")"+$comment); //空白行orコメント行
  var ln = Text.split("\n");
  for (var i=0; i<ln.length; i++) {
    ln[i] = ln[i].match(re)? ln[i].replace(re,"$1"): $comment+ln[i];
  }
  Text = ln.join("\n");
  SetActivePoint(meP, 1, by+1);
  SetAnchorPoint(meP, 1, ty);
}