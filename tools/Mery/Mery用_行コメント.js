//���s�R�����g�̃I��/�I�t
//�E�s���ɃR�����g�������L��΍폜���A������Εt������B�󔒍s�ɂ͕t�����Ȃ��B


//���C���f���g���ꂽ�R�����g�������폜(true:����/false:���Ȃ�) �������l=false
var $indent = false ? "[ \t]*" : "";

//���s�R�����g�����̒�`�B�ҏW���[�h�ɂ���`�ؑ�
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
  if (ty!=by && bx==1) by--;	//�s�I�����A���s���܂߂Ȃ��悤�΍�
  SetActivePoint(meP, 1, by+1);
  SetAnchorPoint(meP, 1, ty);
  var re = new RegExp("^(?=[ \t]*$)|^("+$indent+")"+$comment); //�󔒍sor�R�����g�s
  var ln = Text.split("\n");
  for (var i=0; i<ln.length; i++) {
    ln[i] = ln[i].match(re)? ln[i].replace(re,"$1"): $comment+ln[i];
  }
  Text = ln.join("\n");
  SetActivePoint(meP, 1, by+1);
  SetAnchorPoint(meP, 1, ty);
}