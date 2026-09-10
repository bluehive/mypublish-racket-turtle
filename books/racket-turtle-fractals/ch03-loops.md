---
title: "第3章　ループで複雑な図形——repeat とリスト生成"
---

> **この章のゴール**  
> 言語を Intermediate Student（`#lang htdp/isl`）に切り替え、タートルの `repeat` と `build-list` / `map` / `foldr` で命令列をまとめて作り、変化する図形や並びを描けるようになる。**明示的な再帰は使わない。** `lambda` も使わない（名前付きの関数で渡す）。  
> **想定読者**: プログラミングを楽しみたい人  
> **言語方針 A（今版）**: `#lang htdp/isl` + `(require teachpacks/racket-turtle)`  
> **付属コード**: `code/ch03-loops.rkt`

---

#### 3.0 なぜ「ループ」か（第2章からの続き）

第2章では、進む・曲がるをリストにして、`repeat` で正多角形を描きました。

次に欲しくなるのは、たとえば次のような図形です。

- 1 歩ごとに **長さが少しずつ伸びる** 螺旋  
- 同じ図形を **ずらして並べる**  
- 色を変えながら同じ型紙を繰り返す  

手で `(forward …) (turn-left …)` を何十行も書くのはつらいので、**規則だけ書いてコンピュータに命令列を生成させる**のがこの章のテーマです。

本書の「ループ」は、一般の言語の `for` 文ではありません（ISL にも `for` はありません）。次の道具を指します。

1. タートルの `(repeat k cmd-list)` — 同じ命令セットを k 回  
2. `(build-list n f)` / `map` — 番号や色ごとに命令のかたまりを作る  
3. `(foldr append empty …)` — **二重リストを平坦な CommandList に直す**

---

#### 3.1 第2章の BSL と、この章の ISL はどう違うか

第1–2章は Beginning Student（`#lang htdp/bsl`）でした。第3章だけ Intermediate Student（`#lang htdp/isl`）に上げます。ここで「何が増えて、何はまだ無いか」を丁寧に押さえておきましょう。

##### 🎓 言語レベルの位置づけ（ざっくり）

| レベル | `#lang` | この本での役割 |
|---|---|---|
| Beginning Student | `htdp/bsl` | 第1–2章。式・関数・`list`・turtle の基本 |
| Beginning Student with List Abbreviations | `htdp/bsl+` | リストの略記が増える程度。**この章のループには足りない** |
| Intermediate Student | `htdp/isl` | **第3章（今版）**。`map` / `build-list` / `foldr` など |
| Intermediate Student with lambda | `htdp/isl+` | `lambda` が使える。今版の第3章では使わない |

##### ✅ BSL のままできること（第2章まで）

- 名前付きの関数を `define` する  
- `list` / `first` / `rest` / `empty?` / `append`  
- 条件分岐 `cond` / `if`  
- タートルの `(forward …)` や **`(repeat k cmd-list)`**  

つまり「同じ動きをそのまま回数分くり返す」は、すでに BSL + turtle で書けます。

##### 🆕 ISL で新しく使えること（この章の本体）

- **`build-list`**: `0` … `n-1` のそれぞれについて、関数を当てた結果のリストを作る  
- **`map`**: すでにあるリストの各要素に、同じ変換を当てる  
- **`foldr` / `foldl`**: リストを右（または左）からたたみ込む。ここでは **`foldr append empty` で平坦化**に使う  

これで「i 番目だけ長さを変える」「色のリストの分だけ図形を増やす」といった **変化するくり返し** が書けます。

##### ⚠️ ISL でもまだ無いもの（混乱しやすい点）

- **`lambda`（無名関数）は ISL にはありません。**  
  `map` や `build-list` に渡す関数は、必ず先に `(define (名前 …) …)` で名前を付けます。  
  （`lambda` が使えるのは ISL+ です。今版の第3章は ISL に揃えます。）
- **`for` 文もありません。** 「ループ」＝上の表の道具、と読み替えてください。
- **明示的な再帰**（関数が自分を呼ぶ）は、今版の第3章では扱いません。

##### 🔁 同じ意図を BSL と ISL で見比べる

**BSL（第2章）**: 同じ辺を `repeat` するだけならこれで十分です。

```racket
#lang htdp/bsl
(require teachpacks/racket-turtle)

(define (side len)
  (list (forward len) (turn-left 90)))

(define (square len)
  (repeat 4 (side len)))

;; 例: 一辺 40 の正方形
;; (draw (square 40))
```

**ISL（第3章）**: 「回数ごとに長さを変えたい」ときは `build-list` で命令列を生成します。

```racket
#lang htdp/isl
(require teachpacks/racket-turtle)

(define (growing-step i)
  (list (forward (+ 10 (* i 5)))
        (turn-left 90)))

(define (growing-steps n)
  (foldr append empty (build-list n growing-step)))

;; 例: 長さが伸びながら曲がる（8 ステップ）
;; (draw (growing-steps 8))
```

ポイントは次の2つです（いまは名前だけ覚えてください）。

1. `growing-step` を **名前付き** で定義している（`lambda` を使っていない）  
2. `build-list` のあとに `foldr append empty` と書いている  

2 が何をしているかは、**§3.4** で数字の例 → 二重リスト → `append` → 型紙、の順にゆっくり説明します。ここでは「そういう型紙がある」で先に進んで大丈夫です。

---

#### 3.2 言語を ISL に切り替える

第3章のファイル先頭は次のようにします。

```racket
#lang htdp/isl
(require teachpacks/racket-turtle)
```

DrRacket では言語レベルを **Intermediate Student** に合わせます（`#lang` とメニューを食い違わせない）。  
※ 「Intermediate Student with lambda」ではないので注意してください。

このあとのコード例は、**そのままコピーして DrRacket の定義ウィンドウに貼れる**ように、毎回 `#lang` と `require` を付けています。試すときは、末尾の `;; (draw …)` のコメント（先頭の `;` 2つ）を外して **Run** してください。

---

#### 3.3 おさらい: `repeat` で正多角形

第2章と同じ型紙を、ISL でも使えます。

```racket
#lang htdp/isl
(require teachpacks/racket-turtle)

(define (side len exterior-deg)
  (list (forward len)
        (turn-left exterior-deg)))

(define (make-regular-polygon len n)
  (repeat n (side len (/ 360 n))))

;; 例: 正六角形
;; (draw (make-regular-polygon 60 6))
```

`repeat` は「同じ動きをそのまま回数分」に向きます。長さや色が **毎回変わる** ときは、次の節の `build-list` が向きます。

---

#### 3.4 `build-list` で変化する命令列を作る

この節がいちばんつまずきやすいところです。一度に全部理解しようとせず、次の順でゆっくり進みます。

1. まずタートルなしで、`build-list` が何をするか見る  
2. カメが欲しがる「平らな命令リスト」を思い出す  
3. 「1 歩分」を小さなリストで書く  
4. それを `build-list` すると **二重リスト** になる理由を見る  
5. `append` でつなぎ、最後に `foldr append empty` という型紙にまとめる  

---

##### 3.4.1 ウォーミングアップ: 数字だけで `build-list` を見る

`(build-list n f)` は、だいたい次の意味です。

> 「`0` から `n-1` までの整数を順番に取り、それぞれに関数 `f` を当てて、結果をリストに並べる」

ここで `f` は、**あらかじめ `define` した 1 引数の関数** です（ISL には `lambda` が無いので）。

数字だけの例です（タートルはまだ使いません）。

```racket
#lang htdp/isl

;; 引数を 2 倍する関数
(define (double x)
  (* 2 x))

;; build-list に渡すと:
(build-list 4 double)
;; => (list 0 2 4 6)
;; つまり (list (double 0) (double 1) (double 2) (double 3))
```

もうひとつ。

```racket
#lang htdp/isl

(define (plus-ten i)
  (+ i 10))

(build-list 3 plus-ten)
;; => (list 10 11 12)
```

ここまでなら、結果は普通の「数字のリスト」です。入れ子にはなりません。  
**入れ子になるのは、`f` 自身がリストを返すとき** です。次からそこを丁寧に見ます。

---

##### 3.4.2 カメが欲しがるもの: 平らな CommandList

第2章で見た通り、`(draw …)` に渡すのは、だいたい次のような **1 本の平らなリスト** です。

```racket
(list (forward 10) (turn-left 90)
      (forward 15) (turn-left 90)
      (forward 20) (turn-left 90))
```

イメージすると、引き出しに命令カードが横一列に並んでいる感じです。

```text
[ forward 10 | turn-left 90 | forward 15 | turn-left 90 | forward 20 | turn-left 90 ]
```

この「横一列」を、本書では **CommandList**（命令リスト）と呼びます。  
`draw` は、この横一列を左から順に実行します。

---

##### 3.4.3 やりたいこと: 歩ごとに長さを変えたい

手で書くとこうなります（3 歩だけ）。

```racket
(list (forward 10) (turn-left 90)
      (forward 15) (turn-left 90)
      (forward 20) (turn-left 90))
```

規則は次のとおりです。

- 0 歩目の長さは `10 + 5*0 = 10`  
- 1 歩目の長さは `10 + 5*1 = 15`  
- 2 歩目の長さは `10 + 5*2 = 20`  
- 毎回あとで左に 90 度回る  

歩数が 8 や 30 になると手書きはつらいので、**「i 歩目の小さなかたまり」を関数にして、コンピュータに並べてもらう** のが目標です。

---

##### 3.4.4 「1 歩分」を小さなリストにする

1 歩分は「進む＋曲がる」の 2 命令です。これを小さなリストで書きます。

```racket
#lang htdp/isl
(require teachpacks/racket-turtle)

;; i 歩目の小さな命令リストを返す
(define (growing-step i)
  (list (forward (+ 10 (* i 5)))
        (turn-left 90)))
```

Interactions ウィンドウで、一歩ずつ確かめてみましょう（イメージ）。

```racket
(growing-step 0)
;; => (list (forward 10) (turn-left 90))

(growing-step 1)
;; => (list (forward 15) (turn-left 90))

(growing-step 2)
;; => (list (forward 20) (turn-left 90))
```

ここまでは問題ありません。それぞれが「小さな横一列」（長さ 2 の CommandList）です。

```text
i=0: [ forward 10 | turn-left 90 ]
i=1: [ forward 15 | turn-left 90 ]
i=2: [ forward 20 | turn-left 90 ]
```

---

##### 3.4.5 `build-list` すると「箱の中に箱」になる

では、この `growing-step` を `build-list` に渡します。

```racket
(build-list 3 growing-step)
```

`build-list` は、いつもどおり次のリストを返します。

```racket
(list (growing-step 0)
      (growing-step 1)
      (growing-step 2))
```

ただし、各 `(growing-step i)` 自体がすでにリストなので、中身を展開して書くとこうなります。

```racket
(list
  (list (forward 10) (turn-left 90))
  (list (forward 15) (turn-left 90))
  (list (forward 20) (turn-left 90)))
```

図にすると、次のような **入れ子** です。

```text
外側のリスト（大きな箱）
┌──────────────────────────────────────────────┐
│  ┌──────────────────┐                        │
│  │ forward 10       │  ← 0 歩目の小さな箱    │
│  │ turn-left 90     │                        │
│  └──────────────────┘                        │
│  ┌──────────────────┐                        │
│  │ forward 15       │  ← 1 歩目の小さな箱    │
│  │ turn-left 90     │                        │
│  └──────────────────┘                        │
│  ┌──────────────────┐                        │
│  │ forward 20       │  ← 2 歩目の小さな箱    │
│  │ turn-left 90     │                        │
│  └──────────────────┘                        │
└──────────────────────────────────────────────┘
```

これが **リストのリスト（二重リスト）** です。

- 外側のリストの要素は「小さなリスト」  
- 小さなリストの要素が、本物の命令（`forward` や `turn-left`）  

数字のときの `(build-list 4 double)` が `(list 0 2 4 6)` だったのと対比してください。  
あのときは `double` が **数** を返したので、外側は「数のリスト」でした。  
今は `growing-step` が **リスト** を返すので、外側は「リストのリスト」になります。

---

##### 3.4.6 なぜそのままだと困るのか

`draw` が欲しがるのは、さっきの「横一列」です。

```text
[ forward 10 | turn-left 90 | forward 15 | turn-left 90 | forward 20 | turn-left 90 ]
```

二重リストのままだと、いちばん外側の要素は「命令」ではなく「小さなリスト」です。  
カメは「リストそのものを実行する」ようにはできていないので、**このまま `(draw 二重リスト)` しても期待どおり動きません**（型が合わない、というイメージで十分です）。

だから必要な作業は、はっきりしています。

> 小さな箱を開けて、中の命令カードを **1 本の横一列に並べ直す**（平坦化する）

---

##### 3.4.7 まず `append` だけでつなぐ

`(append リストA リストB)` は、2 本のリストを **端と端でつなぎ、1 本にする** 関数です。  
まず数字で感覚をつかみます。

```racket
#lang htdp/isl

(append (list 1 2) (list 3 4))
;; => (list 1 2 3 4)
```

命令でも同じです。

```racket
(append (list (forward 10) (turn-left 90))
        (list (forward 15) (turn-left 90)))
;; => (list (forward 10) (turn-left 90) (forward 15) (turn-left 90))
```

3 歩分なら、手でこうつなげます。

```racket
(append
  (list (forward 10) (turn-left 90))
  (append
    (list (forward 15) (turn-left 90))
    (list (forward 20) (turn-left 90))))
```

あるいは、空リスト `empty`（中身ゼロのリスト）を右端の出発点にして、左へ向かって順につないでも同じ結果になります。

```racket
(append (list (forward 10) (turn-left 90))
        (append (list (forward 15) (turn-left 90))
                (append (list (forward 20) (turn-left 90))
                        empty)))
```

どちらも結果は、平らな CommandList です。

```text
[ forward 10 | turn-left 90 | forward 15 | turn-left 90 | forward 20 | turn-left 90 ]
```

歩数が増えると、この入れ子の `append` を手で書くのはしんどいです。  
そこで出てくるのが、次の型紙です。

---

##### 3.4.8 型紙: `(foldr append empty 二重リスト)`

`(foldr append empty 二重リスト)` は、上で手書きした「右端を `empty` にして、左へ向かって `append` でつなぐ」作業を、**まとめてやってくれる** 書き方です。

この章では、`foldr` の一般論（「右畳み込みとは何か」）までは深入りしません。覚えるのは次の 1 行だけで十分です。

```racket
(foldr append empty 二重リスト)
```

読み方のコツはこうです。

- `二重リスト` … `build-list`（や後述の `map`）が出した「箱の中に箱」  
- `append` … 小さな箱どうしをつなぐのり  
- `empty` … つなぎ始めの空のリスト  
- `foldr` … それらを右から順に適用する道具（今は「そういう関数がある」でよい）  

`build-list` とセットで書くと、こうなります。

```racket
(foldr append empty (build-list 3 growing-step))
```

これは、だいたい次と同じ結果を返します。

```racket
(list (forward 10) (turn-left 90)
      (forward 15) (turn-left 90)
      (forward 20) (turn-left 90))
```


ここまでの話を、**実際に `n = 3` で動かす流れ**として、もう一度ゆっくりたどります。  
（短い箇条書きだけだと飛びやすいので、途中結果を全部書きます。）

---

##### 3.4.9 流れをゆっくりたどる（`n = 3`）

完成コードはこうでした。

```racket
#lang htdp/isl
(require teachpacks/racket-turtle)

(define (growing-step i)
  (list (forward (+ 10 (* i 5)))
        (turn-left 90)))

(define (growing-steps n)
  (foldr append empty (build-list n growing-step)))

;; 例: 3 ステップで途中を見る／8 ステップで描く
;; (growing-steps 3)
;; (draw (growing-steps 8))
```

これから説明するのは、次の 1 行が裏でやっていることです。

```racket
(growing-steps 3)
; 中身は (foldr append empty (build-list 3 growing-step))
```

###### ステップ1: `build-list` が「小さな命令リスト」を 3 個並べる（二重）

まず内側だけ見ます。

```racket
(build-list 3 growing-step)
```

これは、次の式と同じ意味です。

```racket
(list (growing-step 0)
      (growing-step 1)
      (growing-step 2))
```

各呼び出しを、一つずつ展開します。

```racket
(growing-step 0)
;; => (list (forward 10) (turn-left 90))

(growing-step 1)
;; => (list (forward 15) (turn-left 90))

(growing-step 2)
;; => (list (forward 20) (turn-left 90))
```

だから `(build-list 3 growing-step)` の結果は、次の **二重リスト** です。

```racket
(list
  (list (forward 10) (turn-left 90))
  (list (forward 15) (turn-left 90))
  (list (forward 20) (turn-left 90)))
```

図にするとこうです（大きな箱の中に、小さな箱が 3 つ）。

```text
外側: 長さ 3 のリスト（要素は「リスト」）
  [0] = (list (forward 10) (turn-left 90))
  [1] = (list (forward 15) (turn-left 90))
  [2] = (list (forward 20) (turn-left 90))
```

ここで一度止まりましょう。  
この時点では、まだ `draw` に渡せる形ではありません。理由はシンプルで、外側の要素が「命令」ではなく「命令のリスト」だからです。

###### ステップ2: `foldr append empty` が 1 本の CommandList に結合する

次に、外側の式全体を見ます。

```racket
(foldr append empty (build-list 3 growing-step))
```

ステップ1の結果を `二重` と置くと、次と同じです。

```racket
(foldr append empty 二重)
```

`foldr append empty` がやっていることを、手作業に翻訳するとだいたい次です（右端からつなぐイメージ）。

```racket
(append
  (list (forward 10) (turn-left 90))
  (append
    (list (forward 15) (turn-left 90))
    (append
      (list (forward 20) (turn-left 90))
      empty)))
```

いちばん内側から計算します。

```racket
(append (list (forward 20) (turn-left 90)) empty)
;; => (list (forward 20) (turn-left 90))
```

次。

```racket
(append (list (forward 15) (turn-left 90))
        (list (forward 20) (turn-left 90)))
;; => (list (forward 15) (turn-left 90)
;;          (forward 20) (turn-left 90))
```

最後。

```racket
(append (list (forward 10) (turn-left 90))
        (list (forward 15) (turn-left 90)
              (forward 20) (turn-left 90)))
;; => (list (forward 10) (turn-left 90)
;;          (forward 15) (turn-left 90)
;;          (forward 20) (turn-left 90))
```

これで **平らな CommandList**（命令が横一列）になりました。

```text
[ forward 10 | turn-left 90 | forward 15 | turn-left 90 | forward 20 | turn-left 90 ]
```

数え方の確認です。

- 歩数 `n = 3`  
- 1 歩あたり命令 2 個（`forward` と `turn-left`）  
- だから平らなリストの長さは `3 × 2 = 6`  

`(growing-steps 3)` は、まさにこの長さ 6 のリストを返します。

###### ステップ3: `(draw …)` でカメが実行する

最後に描画します。

```racket
(draw (growing-steps 3))
```

`draw` は、平らなリストを **左から右へ** 読みます。カメの動きは次のとおりです。

1. `forward 10` … 長さ 10 進む  
2. `turn-left 90` … 左に 90 度向く  
3. `forward 15` … 長さ 15 進む  
4. `turn-left 90` … また左に 90 度  
5. `forward 20` … 長さ 20 進む  
6. `turn-left 90` … また左に 90 度  

画面には、だんだん長くなる折れ線（この例では直角に曲がる）が残ります。  
`n` を 8 や 30 に増やしても、流れは同じです。変わるのは「小さな箱の個数」と、平坦化のあとの命令の個数だけです。

```racket
;; 例: 8 ステップ（命令は 16 個）
;; (draw (growing-steps 8))
```

###### 3 ステップを一文でつなぐと

1. **`build-list`** … 「i 歩目の小さなリスト」を n 個作って、外側のリストに入れる（二重になる）  
2. **`foldr append empty`** … 小さなリストを端と端でつなぎ、命令だけの 1 本にする  
3. **`draw`** … その 1 本を左から実行して絵を描く  

`(growing-steps n)` の中身は、1 と 2 をまとめたものです。`draw` はいつも、その外側に付けます。

```racket
(draw (growing-steps n))
;     └─ 1 と 2 がここで終わる（平らな CommandList）
; └─ 3 がここで始まる
```

---

##### 3.4.10 完成形（コピペして試す）

DrRacket にそのまま貼れる形です。途中結果を見たいときは、下のコメントのうち途中の式の `;` を外して **Run** してください（`draw` と同時にたくさん外すと、最後の結果だけが見えるので、一つずつがおすすめです）。

```racket
#lang htdp/isl
(require teachpacks/racket-turtle)

;; i 歩目: 長さ (10 + 5*i) 進んで、左に 90 度
(define (growing-step i)
  (list (forward (+ 10 (* i 5)))
        (turn-left 90)))

;; n 歩分をまとめて平らな CommandList にする
(define (growing-steps n)
  (foldr append empty (build-list n growing-step)))

;; --- 途中結果を見る（どれか一つだけコメントを外す）---
;; (growing-step 0)
;; (build-list 3 growing-step)
;; (growing-steps 3)

;; --- 描画 ---
;; 例: 8 ステップ
;; (draw (growing-steps 8))
```

Interactions での期待イメージです。

```racket
(growing-step 0)
;; => (list (forward 10) (turn-left 90))
;;    小さなリスト 1 本

(build-list 3 growing-step)
;; => (list (list (forward 10) (turn-left 90))
;;          (list (forward 15) (turn-left 90))
;;          (list (forward 20) (turn-left 90)))
;;    二重リスト（小さなリストが 3 本並ぶ）

(growing-steps 3)
;; => (list (forward 10) (turn-left 90)
;;          (forward 15) (turn-left 90)
;;          (forward 20) (turn-left 90))
;;    平らな CommandList（命令が 6 個 = 3 歩 × 2 命令）
```

---

---

##### 3.4.11 この節のチェックリスト

次が言えれば、この節はクリアです。

1. `build-list` は「`0` … `n-1` のそれぞれに関数を当てた結果を並べる」  
2. その関数が **リストを返す** と、結果は **二重リスト** になる  
3. `draw` が欲しいのは **平らな** CommandList  
4. 平らにする定番の型紙は `(foldr append empty 二重リスト)`  
5. 渡す関数は、ISL では必ず `define` で名前を付ける  

「罠」と言っていたのは、要するに **2 → 3 のギャップ** だけです。ギャップを埋めるのりが `foldr append empty` です。

---

#### 3.5 螺旋（ループ版）

§3.4 の `growing-steps` とほぼ同じ型紙で、螺旋っぽい図が描けます。違いは長さの式だけです。

- §3.4: `(+ 10 (* i 5))` … 10, 15, 20, …  
- ここ: `(+ 5 (* i 2))` … 5, 7, 9, …（ゆるやかに伸びる）

回転角ごとに **ステップ関数を名前付きで** 用意します（90 度版と、付属コードの 91 度版）。

```racket
#lang htdp/isl
(require teachpacks/racket-turtle)

(define (spiral-step-90 i)
  (list (forward (+ 5 (* i 2)))
        (turn-left 90)))

(define (spiral-loop-90 times)
  (foldr append empty (build-list times spiral-step-90)))

;; 例: 90 度螺旋（30 ステップ）
;; (draw (spiral-loop-90 30))

;; 91 度版は付属コードの spiral-loop-91 を参照
;; (draw (list (change-bg-color "black") (spiral-loop-91 40)))
```

##### `times` は何を表す引数か

`(spiral-loop-90 times)` の `times` は、「何回くり返すか」の回数です。もう少し正確に言うと、

> **`forward`（進む）を何回実行するか** ＝ 螺旋の「歩数」

です。

理由は、`spiral-step-90` が 1 回あたりちょうど 1 本の `forward` を含むからです。

```racket
(define (spiral-step-90 i)
  (list (forward (+ 5 (* i 2)))   ; ← 進むのはここが 1 回
        (turn-left 90)))          ; ← あとは向きを変えるだけ
```

`build-list` は `i = 0` から `i = times-1` まで、この小さなリストを `times` 個作ります。  
したがって、

- `(spiral-loop-90 30)` → `forward` が 30 回（＋ `turn-left` も 30 回）  
- 平らにしたあとの CommandList の長さは、だいたい `30 × 2 = 60`  

「30 度回る」や「30 秒かかる」といった意味では **ありません**。あくまで **ステップ数（歩数）** です。

試し方の目安です。

- 小さい数（`(spiral-loop-90 5)`）で形を確認する  
- 気に入ったら 30 や 40 に増やす  
- 大きくしすぎると線が長くなり、キャンバスからはみ出しやすくなります  

ここでも §3.4 と同じく、「二重リスト → `foldr append empty`」の型紙はそのままです。`times` が `build-list` の第 1 引数に渡っている、と読めば十分です。

##### 「再帰は書いていない」とはどういう意味か

プログラミングの本では、くり返しを次の 2 通りで書くことがあります。

1. **明示的な再帰** … 関数の本体の中で、**同じ関数をもう一度呼ぶ**  
2. **ループ用の道具** … `build-list` / `map` / `repeat` などに「何回・何を」を渡す  

今版の第3章が選んでいるのは 2 です。たとえば、次のような書き方は **していません**。

```racket
;; ※ 今版では書かない例（イメージ）
;; (define (spiral-rec i times)
;;   (if (>= i times)
;;       empty
;;       (append (spiral-step-90 i)
;;               (spiral-rec (+ i 1) times))))
```

上の想像例では、`spiral-rec` が自分自身（`spiral-rec`）を呼んでいます。これが「明示的な再帰」です。

一方、本書の螺旋はこうです。

```racket
(define (spiral-loop-90 times)
  (foldr append empty (build-list times spiral-step-90)))
```

ここには「`spiral-loop-90` が `spiral-loop-90` を呼ぶ」行がありません。くり返しの仕事は `build-list` に任せています。

なぜこの注記を置くかというと、

- 螺旋やフラクタルの話題では、すぐに再帰の話になりやすい  
- 今版の方針は「ISL のリスト生成で十分」なので、**自分で自分を呼ぶ定義はまだ出さない**  

と明確にするためです。見た目はくり返していますが、書き方の種類としては「再帰関数」ではなく「`build-list` による生成」です。

---

#### 3.6 `map` で色や部品を割り当てる

##### 高階関数とは何か

これまでの関数の多くは、数や文字列を受け取って、数やリストを返していました。  
一方、`build-list` や `map` は、**別の関数を引数として受け取る** 関数です。

```racket
(build-list 3 growing-step)   ; growing-step という「関数」を渡している
(map colored-poly-60-6 COLORS) ; colored-poly-60-6 という「関数」を渡している
```

このように、「関数を受け取ったり、関数を返したりする関数」を **高階関数**（こうかい関数）と呼びます。  
ISL では、渡す側の関数は必ず先に `define` で名前を付けます（`lambda` は ISL にはありません）。

高階関数を使う利点は、「くり返しの枠」と「1 回分の仕事」を分けて書けることです。

- 枠: `map` や `build-list` が「何個・どの順で当てるか」を担当する  
- 1 回分: あなたが `define` した関数が「各要素をどう変換するか」を担当する  

##### `map` は何をするか

`map` は次の意味の高階関数です。

> すでにあるリストの **各要素** に、同じ変換関数を当てて、結果を新しいリストに並べる

数字の例です。

```racket
#lang htdp/isl

(define (double x)
  (* 2 x))

(map double (list 1 2 3 4))
;; => (list 2 4 6 8)
;; つまり (list (double 1) (double 2) (double 3) (double 4))
```

`build-list` との違いを一文で言うと、こうです。

- `build-list` … **自分で 0 … n-1 を用意して**、それぞれに関数を当てる  
- `map` … **すでにあるリスト**（色のリストなど）の各要素に関数を当てる  

タートルでは、「色のリストの分だけ、同じ図形を色違いで作りたい」ときに `map` が向きます。  
渡す変換も **名前付き** にします。そして、各要素の結果が「命令のリスト」だと §3.4 と同じく **二重リスト** になるので、また `(foldr append empty …)` で平らにします。

```racket
#lang htdp/isl
(require teachpacks/racket-turtle)

(define (side len exterior-deg)
  (list (forward len)
        (turn-left exterior-deg)))

(define (make-regular-polygon len n)
  (repeat n (side len (/ 360 n))))

(define COLORS (list "red" "orange" "gold" "green" "blue" "purple"))

(define (colored-poly color len n)
  (append (list (change-color color))
          (make-regular-polygon len n)))

;; map 用に、色だけを引数にする1引数関数
(define (colored-poly-60-6 color)
  (colored-poly color 60 6))

(define (rainbow-hexagons)
  (foldr append empty (map colored-poly-60-6 COLORS)))

;; 例: 色を変えながら正六角形
;; (draw (rainbow-hexagons))
```

横にずらして正方形を並べる例は、付属コードの `row-of-squares` / `square-at-index` を見てみてください。

```racket
#lang htdp/isl
(require teachpacks/racket-turtle)

;; 付属コード code/ch03-loops.rkt を読み込んだうえで:
;; (draw (row-of-squares 5))
```

（`row-of-squares` 一式は長いので、本文では省略しています。コピペで全部試すなら付属 `.rkt` を開くのが確実です。）

---

#### 3.7 型紙まとめ（この章で覚えること）

| やりたいこと | 使う道具 |
|---|---|
| 全く同じ命令を k 回 | `(repeat k cmd-list)`（BSL でも可） |
| i 番目ごとに中身を変えたい | `(build-list n 名前付き関数)` または `map`（ISL） |
| 命令のかたまりが入れ子になった | `(foldr append empty …)` で平坦化 |
| 変換関数 | 必ず `define` で名前を付ける（`lambda` は使わない） |

**再帰（関数が自分を呼ぶ）は今版の第3章では使いません。**

二重リストの型紙をもう一度だけ。

```racket
;; build-list や map のあとに書く「おまじない」
(foldr append empty 二重リスト)
```

---

#### 3.8 付属コードの実行

```bash
# 定義の読み込み確認（画面は出ません）
racket code/ch03-loops.rkt
```

DrRacket で `code/ch03-loops.rkt` を開き、言語を **Intermediate Student** にし、末尾の `(draw …)` のコメントを外して **Run** してみましょう。

**次章へ**: 今版の本編はここまでです。終章で短く振り返ります。
