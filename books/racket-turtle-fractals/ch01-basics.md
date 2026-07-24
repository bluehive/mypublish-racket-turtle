---
title: "第1章　Racket の基礎——式と関数"
---

> **この章のゴール**  
> BSL の基本構文をチートシートとして一通り触れ、小さな関数と `check-expect` が書ける。  
> **参照**: [howtocode cheatsheet](https://howtocode.pages.dev/cheatsheet) / [htdp_templates](https://howtocode.pages.dev/htdp_templates)  
> **付属コード**: `code/ch01-basics.rkt`（`#lang htdp/bsl`）  
> **移植元**: [mypublish-gameoflife ch01](https://github.com/bluehive/mypublish-gameoflife/blob/main/books/racket-game-of-life/ch01-basics.md)（目次 1.1–1.4 へ整合・題材を幾何／タートル準備へ改定）  
> **目次対応**: 1.1 式・評価・基本データ／1.2 定数と関数・check-expect／1.3 条件分岐／1.4 リストのさわり

#### 1.1 式・評価・基本データ

##### 基本データ型

```racket
123
"yayy"
#true
#false
;; true / false とも書ける（BSL）
```

##### 式（前置記法）

```racket
;; 規則: (演算子 引数 …)
(+ 2 4)
(+ 2 4 (* 3 6 (+ 1 1)))
```

序章の評価規則を復習しながら、相互作用ウィンドウで試す。

#### 1.2 定数と関数、`check-expect`

##### 定数 `define`

```racket
(define WIDTH 30)
(define HEIGHT 20)
(define CELL-SIZE 15)

(define BOARD-PIXEL-WIDTH (* WIDTH CELL-SIZE))
;; => 450
```

**なぜ「引数ゼロの関数」ではなく定数か（BSL）**

他の言語では「引数なしの関数」で幅を計算したくなります。

```racket
;; Beginning Student ではこれはエラーになる
;; (define (board-pixel-width) (* WIDTH CELL-SIZE))
```

BSL（Beginning Student）では、`(define (名前 引数…) …)` の形に**少なくとも1つの引数**が必要です。引数が無い「手続き呼び出し」は、この言語レベルでは教えません。

代わりに次のどちらかにします。

1. **定数**にする（値が決まっているとき）— 上の `BOARD-PIXEL-WIDTH`  
2. **引数を取る関数**にする（入力で結果が変わるとき）— 例: `(define (scale n) (* n CELL-SIZE))`

キャンバス幅などは `WIDTH` と `CELL-SIZE`（または `STEP`）から一意に決まるので、本章では定数で十分です。タートル本編では「一歩の長さ」も定数にします。

#### 1.3 条件分岐（`if` / `cond`）

##### `if` と `cond`

```racket
(if (string=? "hi" "bye") "yarr" "meow")  ; => "meow"

(define ran-num 3)
(cond
  [(< ran-num 3) "<3"]
  [(= ran-num 3) "equal"]  ; => "equal"
  [else "other"])
```

図形の深さや再帰の打ち切り（応用）:

```racket
;; 再帰の深さ depth が残っているか（0 以下なら描画を止める）
(define (draw-more? depth)
  (> depth 0))

;; 枝の長さ length が最小長 min-len 以上なら、まだ分岐してよい
(define (branch-ok? length min-len)
  (>= length min-len))

;; 深さも長さも足りるときだけ、次の枝を描く
(define (continue-fractal? depth length min-len)
  (if (draw-more? depth)
      (branch-ok? length min-len)
      false))
```

##### 関数

ここでは「**名前を付けた計算**」の書き方を説明します。  
`(define (関数名 引数…) 本体)` は、「引数を受け取って本体の式を評価し、その値を返す」という意味です。

```racket
;; square-of: 数 x を受け取り、x の2乗を返す
(define (square-of x)
  (* x x))

;; greet: 文字列 name を受け取り、挨拶文を返す
(define (greet name)
  (string-append "Hello, " name "!"))
```

- `square-of` の本体 `(* x x)` … 掛け算の式そのものが返り値  
- `greet` の本体 `string-append` … 文字列を連結した新しい文字列が返り値  

**例を先に書く**とは、実装の細部を詰める前に、「入力がこうなら出力はこう」を先に固定することです。BSL ではそれを `check-expect` で書きます。

```racket
(check-expect (square-of 8) 64)
(check-expect (greet "Racket") "Hello, Racket!")
```

意味: 「`(square-of 8)` を評価した結果は `64` であってほしい」。Run すると自動で照合されます。

**デザインレシピ**（HtDP / howtocode）は、関数を書くときの短い手順書です。本章では次の5つを使います（詳細とデータ別の型紙は **1.10**）。

1. **データ** — 何を表すか（数、文字列、posn、リスト…）  
2. **署名・目的** — 関数名・引数・返り値を一文で  
3. **例** — `check-expect` で入出力を2つ以上  
4. **本体** — 実装する  
5. **試し・見直し** — Run してテストが通るか確認  

「例を先に」は手順 3 を、手順 4 より前にやる、という習慣です。

##### 発展: 構造体 `define-struct` と `posn`（任意）

**構造体**は、「いくつかの値をひとまとめにしたデータ」です。  
`define-struct` で型名とフィールド名を宣言すると、作る関数・取り出す関数・判定関数が自動で用意されます。

タートル本編では座標を直接いじることは少ないですが、点や「向き付きの状態」を構造体で表す練習は役立ちます。

```racket
;; TurtleState は x, y（位置）と heading（向き・度）を持つ練習用
(define-struct turtle-state (x y heading))
;; interp. 平面上の亀の状態（教育用。本線の racket-turtle はライブラリが状態を持つ）

(define T1 (make-turtle-state 0 0 90))   ; 原点、北向き
(define T2 (make-turtle-state 100 50 0)) ; 東向き

(turtle-state-x T1)       ; => 0
(turtle-state-y T1)       ; => 0
(turtle-state-heading T1) ; => 90
(turtle-state? T1)        ; => true
(turtle-state? 321)       ; => false
```

**`posn`** は BSL に最初からある「平面上の点」用の構造体です（自分で `define-struct` しなくてよい）。

- `make-posn` … x と y から点を**作る**  
- `posn-x` / `posn-y` … 点から座標を**取り出す**  
- `posn?` … それが posn かどうか  

```racket
;; x=3, y=2 の点（キャンバス上の一例）
(define SAMPLE-CELL (make-posn 3 2))
(posn-x SAMPLE-CELL)  ; => 3
(posn-y SAMPLE-CELL)  ; => 2
```

`make-posn` の第1引数が横方向、第2引数が縦方向、と決めて本では一貫して使います。  
`turtle-state` は「状態を自分で持つ」練習、`posn` は「点だけ表す」基本、と役割を分けて覚えてください。本線の描画状態は `racket-turtle` が担います。

#### 1.4 リストのさわり（コマンド列の下準備）

##### リスト（`cons` / `first` / `rest` / `empty`）

リストは「0個以上の値を順番に並べたもの」です。BSL では次が基本操作です。

- `empty` — 空のリスト（要素なし）  
- `(cons 先頭 残りリスト)` — 先頭に1つ足した**新しい**リスト  
- `(first リスト)` — 先頭の要素  
- `(rest リスト)` — 先頭を除いた残り  
- `(empty? リスト)` — 空なら true  
- `(list a b c)` — `cons` を重ねた糖衣（読み書き用）  

```racket
;; タートル命令を「数値のリスト」で模した例（本編では forward/right 等のコマンドになる）
;; 例: 正方形 = 100 進む, 90 度右, … を4回
(define SQUARE-STEPS
  (list 100 90 100 90 100 90 100 90))
;; 上はだいたい次と同じ意味:
;; (cons 100 (cons 90 (cons 100 (cons 90 (cons 100 (cons 90 (cons 100 (cons 90 empty))))))))

;; リストの長さ: 空なら 0、そうでなければ 1 + 残りの長さ
(define (my-length xs)
  (cond
    [(empty? xs) 0]
    [else (+ 1 (my-length (rest xs)))]))
```

第2章の `racket-turtle` は、まさに **命令をリストに並べて `draw` する**スタイルです。ここではリストの読み書きだけ押さえておけば十分です。

**所属判定**とは、「この値が、リストの中にあるか？」を true/false で答えることです。

**再帰**とは、関数の定義の中で**自分自身を呼び出す**書き方です。リストのように「空」か「先頭+残り」かに分かれるデータでは、残りに対して同じ問題を解けば全体が解けます。

```racket
;; contains?: リスト xs の中に x があるか
(define (contains? xs x)
  (cond
    [(empty? xs) false]                   ; もう候補がない → いない
    [(equal? (first xs) x) true]          ; 先頭が探している値 → いる
    [else (contains? (rest xs) x)]))      ; ★再帰: 残りだけで同じ判定
```

`else` 枝の `(alive? (rest cells) cell)` が再帰呼び出しです。リストが1つずつ短くなり、いつか `empty` に至って止まります。

##### 発展: 点のずらし（任意・座標練習）

座標を少し動かす練習です（本線の亀はライブラリが動かします）。

```racket
;; p を (dx, dy) だけずらした新しい posn
(define (shift-posn p dx dy)
  (make-posn (+ (posn-x p) dx)
             (+ (posn-y p) dy)))

;; 原点まわりの4方向（東・北・西・南）の点
(define (cardinal-points origin step)
  (list (shift-posn origin step 0)
        (shift-posn origin 0 step)
        (shift-posn origin (- step) 0)
        (shift-posn origin 0 (- step))))
```

##### 付属コードの `check-expect` と実行

テストは **`code/ch01-basics.rkt` の末尾**にまとまっています（本文の断片ではなく、ファイル全体を Run する想定）。  
ここまでの本文に沿った例だけを挙げます（`average` など本文未出の関数は載せません）。

```racket
;; 定数
(check-expect BOARD-PIXEL-WIDTH 450)

;; 1.3 if / フラクタル継続判定
(check-expect (draw-more? 2) true)
(check-expect (draw-more? 0) false)
(check-expect (branch-ok? 50 10) true)
(check-expect (continue-fractal? 2 50 10) true)
(check-expect (continue-fractal? 0 50 10) false)

;; 関数
(check-expect (square-of 8) 64)
(check-expect (greet "Racket") "Hello, Racket!")

;; 構造体 turtle-state と posn
(check-expect (turtle-state-x T1) 0)
(check-expect (turtle-state-heading T1) 90)
(check-expect (posn-x SAMPLE-CELL) 3)

;; リスト・所属・再帰
(check-expect (my-length SQUARE-STEPS) 8)
(check-expect (contains? SQUARE-STEPS 90) true)
(check-expect (contains? SQUARE-STEPS 45) false)

;; 座標のずらし
(check-expect (my-length (cardinal-points (make-posn 0 0) 10)) 4)

(test)  ; CLI で結果を表示するための呼び出し
```

```bash
racket code/ch01-basics.rkt
```

DrRacket なら同ファイルを開いて Run。すべて通れば、1.1〜1.4 の核はクリアです。  
デザインレシピの考え方と、データ種別ごとの型紙は次節でまとめます。

##### デザインレシピとデータパターン（howtocode 準拠）

1.5 で触れたデザインレシピを、もう少し丁寧に整理します。  
内容は [howtocode の htdp_templates](https://howtocode.pages.dev/htdp_templates) に沿った解説です（三角ロジック＝主張・根拠・事実の整理で読みます）。

##### 1.10.1 全体の設計思想

**事実（何が示されているか）**

プログラムが扱うデータの性質に応じて、次の4パターンについて、データ定義・関数のテンプレート（骨組み）・実装例が用意されています。

1. シンプルな基本データ（Simple Base Data）  
2. 列挙型（Enum）  
3. 範囲（Intervals）  
4. 共用体（Union / 異種データの混在）  

**論拠（なぜ先にデータとテンプレートか）**

- バグの多くは、「入力のすべての可能性を網羅しきれていないこと」や「向かない型への処理」から起きる。  
- HtDP のデザインレシピは、**データ構造が関数の構造を決める（データ駆動）**という原則に立つ。  
- 例: データが「信号の3色」なら、関数はだいたい **3枝の `cond`** になる。データが「真偽と数のどちらか」なら、**`boolean?` / `number?` などの型判定による分岐**になる。  
- データの形が決まれば関数の骨組みも機械的に導けるので、勘だけに頼らず、漏れの少ないプログラムを組み立てやすい。  

**主張（この節の結論）**

扱うデータの構造を正しく定義できれば、それに対応する関数の骨組み（テンプレート）はほぼ決まる。以下のパターンはその型紙である。

##### 1.10.2 パターン別の型紙

**パターン1: シンプルな基本データ**

- **意味**: 分解しない単一の値（数や文字列そのもの）をそのまま処理する。  
- **テンプレート**: `(define (関数名 引数) (... 引数))`  
- **例**:

```racket
; double: (Number -> Number)
; 与えられた数値を2倍にする
(check-expect (double 2) 4)
(define (double n)
  (* n 2))  ; テンプレートの「...」を具体的な計算に置き換える
```

本章の `square-of` や `greet` も、このパターンに近いです。

**パターン2: 列挙型（Enum）**

- **意味**: 取りうる値が、有限個の決まった候補だけである場合。  
- **テンプレート**: 候補の個数と同じ本数の `cond` 枝を用意する。  
- **例**: 信号 `"red"` / `"green"` / `"yellow"` なら、テンプレートの時点で枝は3本と決まる。

```racket
(define (traffic-light-next st)
  (cond
    [(string=? "red" st) "green"]
    [(string=? "green" st) "yellow"]
    [(string=? "yellow" st) "red"]))
```

本章の `draw-more?` のように真偽で切る場合も、「場合の数に合わせて枝を用意する」点では同じ考え方です。

**パターン3: 範囲（インターバル / Intervals）**

- **意味**: 情報が、ある範囲の数である場合。数学の区間を条件式で表す。  
- **判定のルール**:  
  - 角括弧 `[` `]`（境界を含む）→ 不等号に `=` を付ける（`>=` / `<=`）  
  - 丸括弧 `(` `)`（境界を含まない）→ `=` を付けない（`>` / `<`）  
- **例**:  
  - `[0, 100]`（0以上100以下）→ `(and (>= n 0) (<= n 100))`  
  - `(80, 100]`（80より大きく100以下）→ `(and (> num 80) (<= num 100))`  

再帰の深さや枝の長さのような整数も、「範囲や帯」として `cond` に落とす練習が第3章以降で出てきます。

**パターン4: 共用体（Union / 異種データの混在）**

- **意味**: 異なる型（例: Boolean と Number）が混ざりうる場合。  
- **テンプレート**: 各型の述語（`boolean?` / `number?` など）で `cond` 分岐する。  
- **例**: 有効な ID は「無しを表す `#false`」か「番号を表す Number」のどちらか。

```racket
(define (pull-over-id-check? x)
  (cond
    [(boolean? x) #false]  ; Boolean（#false）なら無効
    [(number? x)  #true])) ; Number（ID番号）なら有効
```

##### 1.10.3 手順の再掲

データの種類によらず、デザインレシピではだいたい次の順で進みます。

1. データ定義  
2. シグネチャと目的  
3. テスト（`check-expect`）  
4. テンプレート作成  
5. 実装  

「例を先に」は、上の 3 を 5 より前にやる、という意味です。第3章では再帰とテンプレートを中心に、この手順をさらに練習します。

> 三角ロジックで整理予定（1.1–1.4 各節の主張・根拠・事実を執筆時に再配置）

##### 参考文献

- [howtocode — Syntax Cheat Sheet](https://howtocode.pages.dev/cheatsheet)  
- [howtocode — Templates](https://howtocode.pages.dev/htdp_templates)  
- [BSL ドキュメント](https://docs.racket-lang.org/htdp-langs/beginner.html)  
