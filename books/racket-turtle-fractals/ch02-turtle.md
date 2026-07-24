---
title: "第2章　タートルグラフィックス入門"
---

> **この章のゴール**  
> `teachpacks/racket-turtle` で命令リストを**データとして設計**し、正方形・多角形・色付き図形を描ける。  
> **言語**: `#lang racket` + `(require teachpacks/racket-turtle)`（方針 A）  
> **付属コード**: `code/ch02-turtle.rkt`  
> **公式**: [Racket Turtle](https://docs.racket-lang.org/racket_turtle/index.html) / [Commands](https://docs.racket-lang.org/racket_turtle/racket_turtle_commands.html) / [Examples](https://docs.racket-lang.org/racket_turtle/racket_turtle_examples.html)  
> **howtocode 参照**: [htdp_templates](https://howtocode.pages.dev/htdp_templates) / [cheatsheet](https://howtocode.pages.dev/cheatsheet)  
> **レッスン**: 1–2日目

#### 2.0 この章の「データ駆動」の約束

第1章では BSL で式・関数・リストのさわりを学びました。第2章から亀を動かしますが、いきなりウィンドウを開くのではなく、**まず「何をデータとみなすか」を決めます**。

howtocode / HtDP の精神を、タートル向けに言い換えると次のとおりです。

| デザインレシピ（howtocode） | タートルでの対応 |
|------------------------------|------------------|
| Data description | 命令の並びは `CommandList`（手続きのリスト） |
| Interpretation | 「亀が順番に実行する指示書」 |
| Examples | 正方形1辺100、正三角形、正六角形… |
| Template | 辺の長さ・角数など**入力の形**から関数の骨を決める |
| check-expect | 命令リストの長さ・構造を `rackunit` で確かめる（描画は目視） |

**主張（三角ロジック）**: 図形は「画面上のピクセル」ではなく、まず**命令リストというデータ**である。  
**根拠**: 同じリストを `draw` に渡すだけで何度でも再現できる。関数化・再帰（第3–4章）は「リストを組み立てる規則」の話になる。  
**事実**: 公式も正方形を `list` + `forward` + `turn-left` で定義している。

> **三角ロジック**: データ定義 → 例 → テンプレ → 本体 → テスト、の順を崩さない。

#### 2.1 `racket-turtle` の考え方

##### 環境

```bash
raco pkg install teachpacks
```

DrRacket または CLI で:

```racket
#lang racket
(require teachpacks/racket-turtle)
```

##### 中核の API（本章で使うもの）

| コマンド | 意味 |
|----------|------|
| `(forward x)` | x ピクセル前進（負なら後退） |
| `(turn-left a)` / `(turn-right a)` | a 度 左／右へ向きを変える |
| `(repeat k cmd-list)` | 命令リストを k 回分**展開したリスト**にする |
| `(pen-up)` / `(pen-down)` | 線を引かない／引く |
| `(change-color c)` | ペン色（色のリストも可） |
| `(change-pen-size w)` / `(change-pen-style s)` | 太さ・線種 |
| `(stamper-on img)` | 移動ごとにスタンプ |
| `(draw cmds)` | 命令リストを実行して描画 |

##### データ定義: `CommandList`

```text
;; A Command is a turtle procedure (forward, turn-left, … が返す値).
;; A CommandList is one of:
;;   - empty
;;   - (cons Command CommandList)
;;   - または (list …) でまとめたもの / (repeat k CommandList) を要素に含むもの
;; interp. 亀が先頭から順に実行する指示書。
```

公式の最小例（正方形）:

```racket
(define square1
  (list
   (forward 100)
   (turn-left 90)
   (forward 100)
   (turn-left 90)
   (forward 100)
   (turn-left 90)
   (forward 100)))

(draw square1)
```

**解釈**: 「100 進む → 90° 左」を4回。外角が 90° だから正方形になる。

**テンプレートの種**: 「1辺 + 1回転」を部品（`side`）に切り出し、回数で繰り返す——次節。

> **三角ロジック**: 亀は状態機械だが、学習上は**命令リスト＝値**として合成する方が、関数型の再帰とつながる。

#### 2.2 正方形・三角形・多角形

##### デザインレシピ: 正 n 角形

**1. データ（入力）**

```text
;; SideLength is a PositiveNumber  ; 1辺のピクセル長
;; NSides is an Integer >= 3      ; 角の数
```

**2. 解釈**

正 n 角形の**外角**は `360/n` 度。各ステップは「辺を1本描いて外角だけ回る」。

**3. 例**

| n | 外角 | 図形 |
|---|------|------|
| 3 | 120° | 正三角形 |
| 4 | 90° | 正方形 |
| 6 | 60° | 正六角形 |

**4. テンプレート（関数の骨）**

入力が「長さ」と「回数」なら、テンプレはだいたい次の形です（howtocode の simple data + 合成）。

```racket
;; side: SideLength Number -> CommandList
;; 1辺進んで exterior-deg だけ左に回る
(define (side len exterior-deg)
  (list (forward len)
        (turn-left exterior-deg)))

;; regular-polygon: SideLength NSides -> CommandList
(define (regular-polygon len n)
  (repeat n (side len (/ 360 n))))
```

**5. 本体はテンプレを埋めただけ**

`repeat` は「同じ `CommandList` を k 回」という意味の**ライブラリ側の繰り返し**です。第3章の再帰は、これでは足りない自己相似に使います。

正方形の公式スタイル（部品化）:

```racket
(define side100
  (list (forward 100) (turn-left 90)))

(define repeat-square
  (repeat 4 side100))
```

関数版（長さを引数に）:

```racket
(define (changing-side x)
  (list (forward x) (turn-left 90)))

(define (changing-square x)
  (repeat 4 (changing-side x)))

;; (draw (changing-square 30))
```

星（発展・簡易）: 外角を 144° にした5回の `forward` + `turn-right` で五芒星が描ける（付属コードに例）。

> **三角ロジック**: 角数 n がデータなら、外角と `repeat` の回数は**データから一意に決まる**。ここがデータ駆動。

#### 2.3 色・ペン・スタンプ

見た目のパラメータも「命令リストの先頭に載せるデータ」です。

```racket
(define COLORS
  (list "red" "blue" "green" "yellow" "purple"))

(define fancy-square
  (list (change-bg-color "black")
        (change-color "gold")
        (change-pen-size 3)
        (changing-square 80)))
```

スタンプ（公式 4.7 系）:

```racket
(require 2htdp/image)  ; circle など

(define STAMP (circle 5 "solid" "red"))

(define stamper-square
  (list (stamper-on STAMP)
        (pen-up)
        (changing-square 100)))
```

- ペンを上げたままスタンプだけ置くと「線なしの点列」になる  
- `change-color` に色リストを渡すと、線分ごとに色が巡る  

**テンプレ**: 「装飾コマンドのリスト」+「図形コマンドのリスト」を `append` でつなぐ。

```racket
;; decorate: CommandList CommandList -> CommandList
(define (decorate style shape)
  (append style shape))
```

> **三角ロジック**: スタイルも図形も同じ `CommandList` 型——合成が型安全に近い形でできる。

#### 2.4 関数で図形を再利用

##### 部品の合成

```racket
(define (move-without-drawing dist turn-deg)
  (list (pen-up)
        (turn-right turn-deg)
        (forward dist)
        (pen-down)))

(define (two-squares side-len gap)
  (append (changing-square side-len)
          (move-without-drawing gap 90)
          (list (change-color "red"))
          (changing-square side-len)))
```

##### デザインレシピの振り返り（howtocode 5段）

1. **Signature / purpose / stub** — `(regular-polygon len n)` は「正 n 角形の命令リストを返す」  
2. **Examples** — 付属コードの `check-equal?`（命令数の下限など）  
3. **Template** — `side` を先に書き、`repeat` で包む  
4. **Body** — 外角 `(/ 360 n)` を埋める  
5. **Test / review** — `rackunit` + DrRacket で `draw` して目視  

描画は副作用なので、**自動テストは「リストが空でない」「repeat の回数」など構造**に寄せ、見た目は人間が確認する、という分担が現実的です（付録 F 的なデバッグ習慣）。

##### 練習

1. 正八角形（1辺 40）の命令リストを `regular-polygon` で作れ  
2. `decorate` で背景黒・線シアンの六角形を描け  
3. （任意）`go-to` で座標指定の正方形（公式 4.5）を読め  

> **三角ロジック**: 「同じ形をパラメータで量産する」＝第3章の再帰で深さをパラメータにする準備。

#### 2.5 付属コードの実行

```bash
# リポジトリ root
racket code/ch02-turtle.rkt
```

- 既定: `rackunit` の構造テストのみ（GUI を開かない）  
- 描画したいとき: ファイル末尾のコメントを外すか、DrRacket で `(draw …)` を評価  

```bash
raco pkg install teachpacks   # 未導入なら
```
