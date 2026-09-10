---
title: "第3章　ループで複雑な図形——repeat とリスト生成"
---

> **この章のゴール**  
> 言語を Intermediate Student with lambda（`#lang htdp/isl+`）に切り替え、タートルの `repeat` と `build-list` / `map` / `foldr` で命令列をまとめて作り、変化する図形や並びを描けるようになる。**明示的な再帰は使わない。**  
> **想定読者**: プログラミングを楽しみたい人  
> **言語方針 A（今版）**: `#lang htdp/isl+` + `(require teachpacks/racket-turtle)`  
> **付属コード**: `code/ch03-loops.rkt`

---

#### 3.0 なぜ「ループ」か（第2章からの続き）

第2章では、進む・曲がるをリストにして、`repeat` で正多角形を描きました。

次に欲しくなるのは、たとえば次のような図形です。

- 1 歩ごとに **長さが少しずつ伸びる** 螺旋  
- 同じ図形を **ずらして並べる**  
- 色を変えながら同じ型紙を繰り返す  

手で `(forward …) (turn-left …)` を何十行も書くのはつらいので、**規則だけ書いてコンピュータに命令列を生成させる**のがこの章のテーマです。

本書の「ループ」は、一般の言語の `for` 文ではありません（ISL+ に `for` はありません）。次の道具を指します。

1. タートルの `(repeat k cmd-list)` — 同じ命令セットを k 回  
2. `(build-list n f)` / `map` — 番号や色ごとに命令のかたまりを作る  
3. `(foldr append empty …)` — **二重リストを平坦な CommandList に直す**

---

#### 3.1 言語を ISL+ に切り替える

第3章のファイル先頭は次のようにします。

```racket
#lang htdp/isl+
(require teachpacks/racket-turtle)
```

DrRacket では言語レベルを **Intermediate Student with lambda** に合わせます（`#lang` とメニューを食い違わせない）。

ISL+ では `lambda`（その場限りの小さな関数）や `build-list` / `map` / `foldr` が使えます。第2章の BSL より表現力は上がりますが、やることは「命令リストを組み立てて `(draw …)`」のままです。

---

#### 3.2 おさらい: `repeat` で正多角形

第2章と同じ型紙を、ISL+ でも使えます。

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

#### 3.3 `build-list` で変化する命令列を作る

`(build-list n f)` は、`0` から `n-1` までの整数 `i` について `(f i)` を並べたリストを返します。

ここで罠があります。`(f i)` が「命令のリスト」（例: `(list (forward …) (turn-left …))`）だと、結果は **リストのリスト（二重リスト）** になります。`draw` が欲しいのは平坦な CommandList なので、次の型紙でつぶします。

```racket
(foldr append empty 二重リスト)
```

##### 例: 長さが伸びながら曲がる

```racket
;; i 回目: 長さ (10 + 5*i) 進んで 90 度左へ
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

#### 3.4 螺旋（ループ版）

第2章の「同じ外角で回る」に、**長さだけ少しずつ伸ばす**と螺旋っぽくなります。回転角 `a` を閉じ込めるために、`lambda` でステップ関数を作ります。

```racket
(define (make-spiral-step a)
  (lambda (i)
    (list (forward (+ 5 (* i 2)))
          (turn-left a))))

(define (spiral-loop a times)
  (foldr append empty (build-list times (make-spiral-step a))))

;; (draw (spiral-loop 90 30))
;; (draw (list (change-bg-color "black") (spiral-loop 91 40)))
```

- `times` がステップ数（`forward` の回数）です。  
- 明示的に「自分を呼ぶ」再帰は書いていません。繰り返しの骨組みは `build-list` に任せ、こちらは「i 番目に何をするか」だけ定義します。

---

#### 3.5 `map` で色や部品を割り当てる

`map` は「リストの各要素に同じ変換を当てる」関数です。色のリストに対して「その色で多角形を描く命令列」を作ると、また二重リストになるので、同じく `foldr append empty` します。

```racket
(define COLORS (list "red" "orange" "gold" "green" "blue" "purple"))

(define (colored-poly color len n)
  (append (list (change-color color))
          (make-regular-polygon len n)))

(define (rainbow-polygons len n)
  (foldr append empty
         (map (lambda (c) (colored-poly c len n))
              COLORS)))
```

位置をずらして並べる例は、付属コードの `row-of-squares`（`pen-up` で移動してから正方形）を見てみてください。

```racket
;; (draw (row-of-squares 40 5 50))
```

---

#### 3.6 型紙まとめ（この章で覚えること）

| やりたいこと | 使う道具 |
|---|---|
| 全く同じ命令を k 回 | `(repeat k cmd-list)` |
| i 番目ごとに中身を変えたい | `(build-list n f)` または `map` |
| 命令のかたまりが入れ子になった | `(foldr append empty …)` で平坦化 |
| その場限りの小さな関数 | `lambda` |

**再帰（関数が自分を呼ぶ）は今版の第3章では使いません。** 変化や繰り返しは、上のループ型紙で表現します。

---

#### 3.7 付属コードの実行

```bash
# 定義の読み込み確認（画面は出ません）
racket code/ch03-loops.rkt
```

DrRacket で `code/ch03-loops.rkt` を開き、末尾の `(draw …)` のコメントを外して **Run** してみましょう。

**次章へ**: 今版の本編はここまでです。終章で短く振り返ります。
