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
| Beginning Student with List Abbreviations | `htdp/bsl+` | リストの略記が增える程度。**この章のループには足りない** |
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
```

ポイントは次の2つです。

1. `growing-step` を **名前付き** で定義している（`lambda` を使っていない）  
2. `build-list` の結果が二重リストになりうるので、`foldr append empty` で平坦化している  

---

#### 3.2 言語を ISL に切り替える

第3章のファイル先頭は次のようにします。

```racket
#lang htdp/isl
(require teachpacks/racket-turtle)
```

DrRacket では言語レベルを **Intermediate Student** に合わせます（`#lang` とメニューを食い違わせない）。  
※ 「Intermediate Student with lambda」ではないので注意してください。

---

#### 3.3 おさらい: `repeat` で正多角形

第2章と同じ型紙を、ISL でも使えます。

```racket
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

`(build-list n f)` は、`0` から `n-1` までの整数 `i` について `(f i)` を並べたリストを返します。ここで `f` は **あらかじめ define した関数** です。

罠: `(f i)` が「命令のリスト」だと、結果は **リストのリスト（二重リスト）** になります。`draw` が欲しいのは平坦な CommandList なので、次の型紙でつぶします。

```racket
(foldr append empty 二重リスト)
```

##### 例: 長さが伸びながら曲がる

```racket
(define (growing-step i)
  (list (forward (+ 10 (* i 5)))
        (turn-left 90)))

(define (growing-steps n)
  (foldr append empty (build-list n growing-step)))

;; (draw (growing-steps 8))
```

流れはこうです。

1. `build-list` が「小さな命令リスト」を n 個並べる（二重）  
2. `foldr append empty` が 1 本の CommandList に結合する  
3. `(draw …)` でカメが実行する  

---

#### 3.5 螺旋（ループ版）

長さだけ少しずつ伸ばすと螺旋っぽくなります。回転角ごとに **ステップ関数を名前付きで** 用意します。

```racket
(define (spiral-step-90 i)
  (list (forward (+ 5 (* i 2)))
        (turn-left 90)))

(define (spiral-loop-90 times)
  (foldr append empty (build-list times spiral-step-90)))

;; (draw (spiral-loop-90 30))
;; 91 度版は付属コードの spiral-loop-91 を参照
```

- `times` がステップ数（`forward` の回数）です。  
- 明示的に「自分を呼ぶ」再帰は書いていません。

---

#### 3.6 `map` で色や部品を割り当てる

`map` は「リストの各要素に同じ変換を当てる」関数です。渡す変換も **名前付き** にします。

```racket
(define COLORS (list "red" "orange" "gold" "green" "blue" "purple"))

(define (colored-poly color len n)
  (append (list (change-color color))
          (make-regular-polygon len n)))

;; map 用に、色だけを引数にする1引数関数
(define (colored-poly-60-6 color)
  (colored-poly color 60 6))

(define (rainbow-hexagons)
  (foldr append empty (map colored-poly-60-6 COLORS)))
```

横にずらして正方形を並べる例は、付属コードの `row-of-squares` / `square-at-index` を見てみてください。

```racket
;; (draw (row-of-squares 5))
```

---

#### 3.7 型紙まとめ（この章で覚えること）

| やりたいこと | 使う道具 |
|---|---|
| 全く同じ命令を k 回 | `(repeat k cmd-list)`（BSL でも可） |
| i 番目ごとに中身を変えたい | `(build-list n 名前付き関数)` または `map`（ISL） |
| 命令のかたまりが入れ子になった | `(foldr append empty …)` で平坦化 |
| 変換関数 | 必ず `define` で名前を付ける（`lambda` は使わない） |

**再帰（関数が自分を呼ぶ）は今版の第3章では使いません。**

---

#### 3.8 付属コードの実行

```bash
# 定義の読み込み確認（画面は出ません）
racket code/ch03-loops.rkt
```

DrRacket で `code/ch03-loops.rkt` を開き、言語を **Intermediate Student** にし、末尾の `(draw …)` のコメントを外して **Run** してみましょう。

**次章へ**: 今版の本編はここまでです。終章で短く振り返ります。
