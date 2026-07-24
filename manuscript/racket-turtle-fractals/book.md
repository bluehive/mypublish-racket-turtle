# 自己相似形グラフィック入門

> **副題**: Racket タートルで学ぶフラクタルと再帰  
> **著者**: 陸機雑学ファクトリー / Grok 4.5  
> **正本**: `books/racket-turtle-fractals/` (Zenn book)  

---

## 序章　なぜ Racket で描くか

> **この章のゴール**  
> 自己相似形（フラクタル）とは何かをつかみ、なぜ Racket（BSL → racket-turtle）から学ぶかを理解し、DrRacket で式を評価できる状態になる。  
> **スタイル参照**: [howtocode introduction](https://howtocode.pages.dev/introduction) / [installation](https://howtocode.pages.dev/installation) / [expressions](https://howtocode.pages.dev/expressions)  
> **言語**: 序盤 Beginning Student（`#lang htdp/bsl`）／本編描画は `#lang racket` + `teachpacks/racket-turtle`（**方針 A**）  
> **移植元**: [mypublish-gameoflife intro](https://github.com/bluehive/mypublish-gameoflife/blob/main/books/racket-game-of-life/intro.md)（目次整合のため改定）

#### 0.1 自己相似形とは（フラクタル入門）

**自己相似**とは、図形の一部分を拡大すると、全体と同じような形が現れる性質です。雪の結晶、木の枝分かれ、海岸線の入り組み——自然にも人工にも、この性質はあちこちで顔を出します。

数学では、コッホ曲線やシェルピンスキーの三角形のように、**同じ置き換え規則を何度も繰り返す**ことで自己相似な図形を定義できます。コンピュータでは、その「繰り返し」を**再帰**という書き方でそのまま表現できます。

本書では、画面上を「亀」が進んで線を引く **タートルグラフィックス**（`teachpacks/racket-turtle`）を使い、次のような図形を描いていきます。

- 正方形・多角形・螺旋（準備運動）
- フラクタルツリー
- コッホ曲線・コッホ雪片
- シェルピンスキーの三角形
- ドラゴン曲線など発展形

高校数学の「図形と式」「数列・規則の繰り返し」と、プログラミングの「関数・再帰」が一本の線でつながるのが目標です。お手本のプログラムはリポジトリの `code/` に置き、GitHub からも参照できるようにします。

> 三角ロジックで整理予定

#### 0.2 なぜ Racket か——構文より論理

プログラミングの難しさは、変数・ループ・条件といった部品そのものより、**部品をどう組み合わせて目的を達するか**にあります。作文にたとえれば、つづりより「論旨のつなぎ」です。

Java や Python などで最初に覚えることが多いのは次のような**言語ごとの作法**です。

- セミコロンをどこに打つか
- 中括弧・インデントがスコープにどう効くか
- クラスや修飾子、`main` の書き方

これらは後から慣れますが、**論理そのものから注意を奪いやすい**、という指摘があります（howtocode: *I'm not here to waste your time on the nuances of language syntax rules*）。

本書では **Racket** を使います。教育用に絞ると、式の形はだいたい次の一形です。

```racket
(演算子 引数1 引数2 …)
(+ 1 2)    ; => 3
```

起源は LISP 系です。括弧が多いと感じる人もいますが、HTML/JSON/JS が別文法になる世界と対照すると、「同じ形で木を書く」ことの単純さが見えてきます。

本の後半では、**自己相似な図形をタートルで描く**ことを題材に、式・リスト・再帰を積み上げます。ゲーム産業での Racket 利用例（howtocode が触れる Naughty Dog 等）は興味付けに留め、本線は「書いて試して直す」練習です。

姉妹編として、同じ Racket / BSL 系列で盤面シミュレーションを扱う  
[『Racketで学ぶ生命のゲーム』](https://github.com/bluehive/mypublish-gameoflife)  
もあります。本書は「描画と再帰」、あちらは「グリッドとルール」——どちらから読んでも構いません。

> 三角ロジックで整理予定

#### 0.3 DrRacket と BSL／言語レベルの見取り図

1. [Racket をダウンロード](https://download.racket-lang.org/)してインストールする  
2. DrRacket を起動する  
3. 推奨設定（howtocode installation）:
   - `Edit → Preferences → … → Show line numbers`
   - （任意）`View → Use Horizontal Layout`
4. **言語レベル（序盤）**: 左下（または Language メニュー）で **Beginning Student** を選ぶ  
   本リポジトリの基礎ファイル先頭は次でも同じです。

```racket
#lang htdp/bsl
```

`htdp/bsl` の **HtDP** は教科書 *How to Design Programs* の略で、**BSL** はその入門用言語レベル（Beginning Student Language）です。DrRacket の「Beginning Student」と同じ系統で、構文を絞りつつ `check-expect` やデザインレシピで学べます。公式: [HtDP Languages](https://docs.racket-lang.org/htdp-langs/index.html) / [Beginning Student](https://docs.racket-lang.org/htdp-langs/beginner.html)。

5. 定義ウィンドウに式を書き **Run**。下の相互作用ウィンドウが REPL になる。

**言語方針 A（本書の約束）**

| 段階 | 言語 | 用途 |
|------|------|------|
| 序章〜第1章（基礎） | BSL（`#lang htdp/bsl`） | 式・関数・`check-expect`・リストのさわり |
| 第2章以降（タートル本編） | `#lang racket` + `teachpacks/racket-turtle` | 命令リストで図形を描く |
| 付録 E | — | BSL と `#lang racket` の使い分けの根拠 |

`racket-turtle` の導入は付録 B と第2章で扱います。

```racket
; 一行コメント
#| 複数行コメント |#
```

式の形:

```racket
(+ 2 4)   ; => 6
```

- 引数の区切りは**スペース**（カンマではない）
- 引数自身が式でもよい。評価はおおむね**左から右、内側から外側**へ値に落とす

```racket
(+ 2 4 (* 5 5) (- (+ 3 3) 2) 1)
; (* 5 5) => 25, (+ 3 3) => 6, (- 6 2) => 4
; 最終的に (+ 2 4 25 4 1) => 36
```

エラーの典型:

- `((+ 3 4))` … 外側の括弧に演算子がない
- `(3 (+ 1 6))` … `3` は演算子ではない

**開き括弧の直後は常に演算子（または特殊フォーム）**、と覚える。

非正確数: `(sqrt 2)` や `pi` は `#i…` と表示されることがある（メモリ上の近似）。

練習: 直角三角形の斜辺  
`√(3²+4²)` を BSL の式で書け → `(sqrt (+ (* 3 3) (* 4 4)))`

付録 B で Windows 11 向けの手順を厚くします。

> 三角ロジックで整理予定

#### 0.4 本書の進め方（1週間レッスンプラン）

想定読者は高校生・趣味の社会人。目安語数は約2万字。楽しいお手本と、すぐ動くコードを優先します。

| 日 | 内容 | 章 |
|----|------|-----|
| 事前〜1 | Racket / BSL の式と関数 | 序章・第1章 |
| 1–2 | タートルで基本図形 | 第2章 |
| 3 | 再帰への橋渡し | 第3章 |
| 4–6 | フラクタル本編 | 第4章 |
| 7 | 現実世界・次の一歩 | 終章 |

進め方の予告:

1. 第1章 — 構文チート（式・define・cond・関数・リスト）  
2. 第2章 — `racket-turtle` の基本操作  
3. 第3章 — 再帰の型紙とタートルの組み合わせ  
4. 第4章 — ツリー・コッホ・シェルピンスキー・ドラゴン  
5. 終章 — フラクタルと現実、姉妹編への導線  

**デザインレシピ（最短）** — howtocode / HtDP の精神を短くすると:

- **データ** — 何を表すか（記述・解釈・例・テンプレ）
- **関数** — 署名・目的・stub・例（`check-expect`）・テンプレ・本体・見直し

詳細は第1章・第3章と [htdp_templates](https://howtocode.pages.dev/htdp_templates) を参照。

> 参考文献: [howtocode.pages.dev](https://howtocode.pages.dev/)（構成と教え方を参照。文章は日本語で再執筆）  
> 三角ロジックで整理予定

## 第1章　Racket の基礎——式と関数

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

## 第2章　タートルグラフィックス入門

> **この章のゴール**  
> `teachpacks/racket-turtle` で基本図形を描き、命令リストと関数化の感覚をつかむ。  
> **言語**: `#lang racket` + `(require teachpacks/racket-turtle)`（方針 A）  
> **付属コード（予定）**: `code/ch02-turtle.rkt`  
> **公式**: [Racket Turtle](https://docs.racket-lang.org/racket_turtle/index.html)  
> **レッスン**: 1–2日目

#### 2.1 `racket-turtle` の考え方

- 亀は「今いる位置」と「向き」を持ち、`forward` / `right` / `left` などで動く  
- ペンを上げ下げし、色や太さを変えられる  
- 命令は**リスト**に並べ、`draw` でまとめて実行する  

```racket
#lang racket
(require teachpacks/racket-turtle)

(define square1
  (list
   (forward 100)
   (right 90)
   (forward 100)
   (right 90)
   (forward 100)
   (right 90)
   (forward 100)))

(draw square1)
```

> 三角ロジックで整理予定

#### 2.2 正方形・三角形・多角形

- 外角と辺の数の関係（正 n 角形）  
- `repeat` や関数で繰り返しを短く書く（公式例を参照）  

> 三角ロジックで整理予定

#### 2.3 色・ペン・スタンプ

- ペンの色・スタイル・太さ  
- スタンプで線以外の画像も置ける  

> 三角ロジックで整理予定

#### 2.4 関数で図形を再利用

- 「一辺の長さ」を引数にした正方形・多角形  
- 同じ部品を平行移動・回転して合成する予告（第3章へ）  

> 三角ロジックで整理予定

## 第3章　再帰への橋渡し

> **この章のゴール**  
> 繰り返す図形から再帰の型紙へ進み、タートル命令を再帰で組み立てられるようにする。  
> **言語**: 概念は BSL でも可／描画例は `#lang racket` + racket-turtle  
> **付属コード（予定）**: `code/ch03-recursion.rkt`  
> **レッスン**: 3日目

#### 3.1 繰り返す図形から再帰へ

- 螺旋・星など「同じ操作の入れ子」  
- ループで足りる場合と、自己相似で再帰が自然な場合  

> 三角ロジックで整理予定

#### 3.2 再帰の型紙（構造的再帰の直感）

- 基底ケースと再帰ケース  
- 短い例: `factorial`、リストの `my-length`（第1章の復習）  
- HtDP テンプレートとの対応  

> 三角ロジックで整理予定

#### 3.3 タートルと再帰の組み合わせパターン

- 命令リストを再帰で伸ばす  
- 「深さ depth を1減らして自分を呼ぶ」型  
- 第4章のフラクタルへの橋  

> 三角ロジックで整理予定

## 第4章　フラクタルを描く

> **この章のゴール**  
> 代表的なフラクタルを racket-turtle（または同等の再帰描画）で実装し、自己相似を「手で動かす」。  
> **付属コード（予定）**: `code/ch04-fractals.rkt`  
> **レッスン**: 4–6日目

#### 4.1 フラクタルツリー

- 幹を描き、左右に短い枝を再帰  
- 角度・縮み率・深さのパラメータ  

> 三角ロジックで整理予定

#### 4.2 コッホ曲線・コッホ雪片

- 1辺を「出っ張り」に置換する規則  
- **海岸線の長さ**のパラドックス（測る物差しを細かくするほど長くなる）を動機に  
- 雪片は正三角形の各辺にコッホを適用  

> 三角ロジックで整理予定

#### 4.3 シェルピンスキーの三角形

- 大きな三角形の中に、相似な小さい三角形を残す／描く  
- 再帰の深さと見た目の関係  

> 三角ロジックで整理予定

#### 4.4 ドラゴン曲線と発展図形

- ドラゴン曲線の折りたたみ規則（概要）  
- 四角形フラクタルなど発展は演習または要約  
- 公式の再帰例（螺旋・花・星）へのリンク  

> 三角ロジックで整理予定

## 終章　高校数学の学びは大人でも楽しい

> **この章のゴール**  
> フラクタルと現実世界の接点を確認し、次に進むライブラリと姉妹編を知る。  
> **レッスン**: 7日目

#### 5.1 フラクタルと現実世界

- 海岸線・樹木・血管・生成デザイン  
- 「無限に細かく見える」ことと、有限の再帰深さで近似すること  

> 三角ロジックで整理予定

#### 5.2 次の一歩

- `2htdp/image` — 関数合成で図形を組み立てる  
- `big-bang` — アニメーション・対話  
- 姉妹編: [Racketで学ぶ生命のゲーム](https://github.com/bluehive/mypublish-gameoflife)  
- 公式: [Racket Turtle 再帰例](https://docs.racket-lang.org/racket_turtle/racket_turtle_examples_with_recursion.html)  

> 三角ロジックで整理予定

## 付録A　完全ソース一覧

> **この付録のゴール**  
> 章ごとの付属 `.rkt` と GitHub 上の場所を一覧する。

| 章 | ファイル | 言語 | 状態 |
|----|----------|------|------|
| 第1章 | [`code/ch01-basics.rkt`](../../code/ch01-basics.rkt) | `#lang htdp/bsl` | 初版 |
| 第2章 | `code/ch02-turtle.rkt` | `#lang racket` + racket-turtle | 予定 |
| 第3章 | `code/ch03-recursion.rkt` | 同上 | 予定 |
| 第4章 | `code/ch04-fractals.rkt` | 同上 | 予定 |

リポジトリ: https://github.com/bluehive/mypublish-racket-turtle

```bash
mise run test:racket
# または
racket code/ch01-basics.rkt
```

> 三角ロジックで整理予定

## 付録B　環境構築（Windows 11 と DrRacket）

> **この付録のゴール**  
> 高校生でも、自分の PC で Beginning Student（BSL）を動かせるようにする。  
> **参照**: [howtocode installation](https://howtocode.pages.dev/installation) / [Racket ダウンロード](https://download.racket-lang.org/)  
> **Issue**: [#環境](https://github.com/bluehive/mypublish-racket-turtle/issues/3)

#### B.1 何を入れるか

本のサンプルは次を前提にします。

- **Racket**（DrRacket 付き）  
- 言語レベル: **Beginning Student**（またはファイル先頭 `#lang htdp/bsl`）  

コマンドラインで `racket` が使えれば、付属の `check-expect` もターミナルから実行できます。

#### B.2 Windows 11 でのインストール（手順）

1. ブラウザで https://download.racket-lang.org/ を開く  
2. Windows 用インストーラを選び、ダウンロードする  
3. ダウンロードした `.exe` を実行し、画面の指示に従ってインストールする  
   - 可能なら「PATH に追加する」類の選択肢があれば有効にする  
4. スタートメニューから **DrRacket** を起動する  

インストール後、PowerShell やコマンドプロンプトで次を試し、バージョンが出れば成功です。

```text
racket --version
```

#### B.3 DrRacket の推奨設定

howtocode の installation に合わせた設定です。

1. **行番号を出す**  
   `Edit` → `Preferences` → `Editing` → `General Editing` → **Show line numbers**
2. **（任意）横並びレイアウト**  
   `View` → `Use Horizontal Layout`  
   定義ウィンドウと相互作用ウィンドウが左右に並び、余白が使いやすいことがあります。
3. **言語レベル**  
   ウィンドウ左下（または `Language` メニュー）で **Beginning Student** を選ぶ  
   本リポジトリの `.rkt` は先頭に次を書いてあるので、ファイルを開けば同じ系統になります。

```racket
#lang htdp/bsl
```

4. **（任意）自動括弧**  
   Preferences の Editing で automatic parentheses を有効にできる。便利だが、括弧の対応に慣れるまではオフでもよい。

5. **（任意）補完**  
   `File` → `Package Manager` から `drcomplete` などを入れられる（必須ではない）。

#### B.4 最初の動作確認

1. DrRacket で新しいファイルを作る  
2. 次を貼る  

```racket
#lang htdp/bsl
(+ 1 2)
```

3. **Run** を押す  
4. 相互作用ウィンドウに `3` が出れば成功  

本の付属コードなら、リポジトリをクローンまたは展開したあと:

```text
cd （リポジトリのフォルダ）
racket code/ch01-basics.rkt
```

`All … tests passed!` と出れば環境は十分です。

#### B.5 つまずきやすい点

- **言語レベルが違う**  
  Advanced や `#lang racket` のままだと、本の説明（0引数関数禁止、`map` が無い等）と動きがずれる。必ず BSL / `#lang htdp/bsl` を確認する。  
- **`racket` がコマンドに無い**  
  インストール時に PATH が通っていない。DrRacket からは Run できることが多い。PATH は Racket のインストール先の `bin` を通す。  
- **日本語パス**  
  まれにツールが困るので、学習用フォルダは英数字のパスが無難。  

#### B.6 関連リンク

- Racket 本体: https://download.racket-lang.org/  
- Beginning Student 言語: https://docs.racket-lang.org/htdp-langs/beginner.html  
- howtocode インストール: https://howtocode.pages.dev/installation  
- 本編の序章 0.3、README のセットアップ節  

Windows 以外（macOS / Linux）でも、同じダウンロードページから OS 用を入れ、言語レベルを Beginning Student にすれば同様です。

#### B.6 teachpacks（racket-turtle）の導入

第2章以降の本線描画は `teachpacks/racket-turtle` を使います（言語方針 A: 本編は `#lang racket`）。

```text
raco pkg install teachpacks
```

確認用の最小例（第2章で詳述）:

```racket
#lang racket
(require teachpacks/racket-turtle)

(define square1
  (list
   (forward 100)
   (right 90)
   (forward 100)
   (right 90)
   (forward 100)
   (right 90)
   (forward 100)))

(draw square1)
```

公式: [Racket Turtle](https://docs.racket-lang.org/racket_turtle/index.html)

> 三角ロジックで整理予定

## 付録C　復習と例題集

> **この付録のゴール**  
> 各章末の練習問題をまとめる（執筆時に拡充）。

#### C.1 第1章

- 斜辺の式、`check-expect` を2つ以上書く  
- リスト `SQUARE-STEPS` の長さを手で数え、`my-length` と比較する  

#### C.2 第2章以降

- （執筆時に追加）

> 三角ロジックで整理予定

## 付録D　参考文献・オンラインリソース

#### D.1 公式・教材

- [Racket Turtle](https://docs.racket-lang.org/racket_turtle/index.html)  
- [Beginning Student Language](https://docs.racket-lang.org/htdp-langs/beginner.html)  
- [How to Design Programs](https://htdp.org/)  
- [howtocode.pages.dev](https://howtocode.pages.dev/)  

#### D.2 関連リポジトリ

- 本リポジトリ: https://github.com/bluehive/mypublish-racket-turtle  
- 姉妹編 ライフゲーム: https://github.com/bluehive/mypublish-gameoflife  
- 目次企画（移行元）: https://github.com/bluehive/draft-publish-books-2026/issues/15  
- タートル調査: https://github.com/bluehive/my-grok-task-2026/issues/40  

#### D.3 その他

- Google Drive の Python 時代 PDF（参考・歴史資料）  
- 旧ドラフト: `draft-publish-books-2026` の `self-similar-graphics.md`（本リポジトリへ移行済み）

> 三角ロジックで整理予定

## 付録E　BSL と #lang racket の使い分け（方針 A）

> **この付録のゴール**  
> なぜ序盤だけ BSL で、タートル本編を `#lang racket` にするかを一文で説明できるようにする。

#### E.1 方針 A の要約

| 段階 | 言語 | 理由 |
|------|------|------|
| 基礎 | `#lang htdp/bsl` | 構文を絞り、`check-expect` とデザインレシピで論理を先に学ぶ |
| 描画本編 | `#lang racket` + `teachpacks/racket-turtle` | 公式 turtle teachpack の API・リスト・再帰例をそのまま使える |
| 発展（任意） | ISL+ / `2htdp/image` / `big-bang` | アニメーションや別スタイルの図形構築 |

#### E.2 BSL だけで押し切れない点（検討メモ）

- BSL はリスト操作・高階・一部構文が制限される  
- `racket-turtle` は `(require teachpacks/racket-turtle)` 前提で、公式例は Racket 系  
- 姉妹編ライフゲームも「本線 BSL、描画発展は別系統」と分離している  

#### E.3 読者への案内文（本文転用可）

> 第1章までは Beginning Student で式と関数に慣れます。第2章から亀を動かすときは、ファイル先頭を `#lang racket` に切り替え、teachpack を入れます。考え方（例を先に、再帰の型紙）は共通です。

> 三角ロジックで整理予定

