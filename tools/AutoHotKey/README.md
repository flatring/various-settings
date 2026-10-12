# AutoHotKey

ウィンドウ移動・リサイズ、マウスカーソルのモニター間移動を行うスクリプト(AutoHotkey v2)。

## 起動
- エントリーポイントは `WindowMoveTenKey.ahk`。他のファイルは `#Include` で読み込まれる
- スタートアップフォルダのショートカット `WindowMoveTenKey.lnk` から、このフォルダのファイルを直接起動している
- スクリプト修正後はタスクトレイのアイコンから Reload Script で反映
- モニター構成はキャッシュしているため、モニターの接続・解除後も Reload Script が必要

## ファイル構成
| ファイル | 概要 |
|---|---|
| `WindowMoveTenKey.ahk` | エントリーポイント。ウィンドウのモニター間移動・9分割位置への移動 |
| `WindowSizeChange.ahk` | アクティブウィンドウのサイズ変更 |
| `SwapCursor.ahk` | マウスカーソルを次のモニターの中央へ移動 |
| `GetMonitorNumber.ahk` | ウィンドウ中心点がどのモニター上にあるかを返す |
| `GetMonitors.ahk` | モニター一覧(座標)を取得 |

## ホットキー
| キー | 動作 |
|---|---|
| Win + Alt + NumpadDiv(/) | アクティブウィンドウを前のモニターへ移動 |
| Win + Alt + NumpadMult(*) | アクティブウィンドウを次のモニターへ移動 |
| Win + Shift + ← / → | 前 / 次のモニターへ移動(Windows 標準を上書き) |
| Win + Alt + Numpad1〜9 | モニター内の9分割位置へ移動(テンキーの配置 = 画面上の位置) |
| Win + Alt + ↑ / ↓ | 高さを縮小 / 拡大 |
| Win + Alt + ← / → | 幅を縮小 / 拡大 |
| NumLock | マウスカーソルを次のモニターの中央へ移動 |

- モニター移動・9分割移動では、最大化を解除し、作業領域の95%を超えるサイズは縮める
- サイズ変更は 240px 刻み、最小 640px、最大はモニターの作業領域まで
- NumLock をカーソル移動に使うため、NumLock 状態は常に ON に固定される(テンキーは常に数字入力)
- Win + Shift + ↑ / ↓ は上書きしていない(Windows 標準: 高さを画面いっぱいに伸ばす / 戻す)

## 参考
1. [Wiki](http://ahkwiki.net/Top)
1. [公式 v2](https://www.autohotkey.com/docs/v2/)
