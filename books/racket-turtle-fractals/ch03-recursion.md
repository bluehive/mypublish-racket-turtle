---
title: "第3章　再帰への橋渡し"
---

> **この章のゴール**  
> howtocode / HtDP の**データ定義 → テンプレート**で再帰を書き、命令リストを再帰で組み立てられる。  
> **言語**: 概念は BSL でも可／描画例は `#lang racket` + racket-turtle  
> **付属コード**: `code/ch03-recursion.rkt`  
> **参照**: [howtocode htdp_templates](https://howtocode.pages.dev/htdp_templates) / 姉妹編 [ch02-recursion](https://github.com/bluehive/mypublish-gameoflife/blob/main/books/racket-game-of-life/ch02-recursion.md) / [公式 再帰例](https://docs.racket-lang.org/racket_turtle/racket_turtle_examples_with_recursion.html)  
> **レッスン**: 3日目

#### 3.0 なぜ再帰か（データ駆動の答え）

第2章の `repeat` は「同じ部品を k 回」に強いです。しかしフラクタルは、

- 大きな形の**中に、相似な小さな形**があり  
- 小ささの尺度（深さ・長さ）が**1段階ずつ減る**

というデータです。howtocode が言うとおり、**データの自己参照が、関数の自己呼び出し（再帰）を強制します**。

```text
  データ定義（場合分け）  →  テンプレート（cond の枝）  →  本体
```

> **三角ロジック**: 再帰は技巧ではなく、自己参照データの**型紙を埋めた結果**である。

#### 3.1 繰り返す図形から再帰へ

##### 螺旋: 「長さが増えるステップ」を n 回

公式の螺旋は、おおよそ次の形です（`times` が残り回数）。

```racket
;; spiral: Number Number Number -> CommandList
;; a = 回転角, x = 今の前進距離, times = 残りステップ
(define (spiral a x times)
  (if (< times 0)
      empty
      (append (list (forward x) (turn-left a))
              (spiral a (+ x 2) (sub1 times)))))
```

**データの見方（Interval / カウントダウン）**

```text
;; TimesLeft is an Integer
;; interp. まだ描くステップの残り。0 未満で停止。
```

**テンプレート（自然数・カウントダウン型）**

```racket
(define (times-temp n)
  (cond
    [(< n 0) (...)]           ; または (<= n 0)
    [else (... n (times-temp (sub1 n)))]))
```

`repeat` では「毎回 x が 2 増える」を表現しにくい。**状態がステップごとに変わる**ときは再帰が自然です。

星・花の螺旋（公式 5.3–5.4）も同じ型紙で、スタンプ画像のリストを再帰生成します。

> **三角ロジック**: 「変化するパラメータ」がデータなら、基底ケース（止まる条件）をデータ定義に先に書く。

#### 3.2 再帰の型紙（構造的再帰の直感）

howtocode の4パターンのうち、本章の本線は次の2つです。

##### パターン A: リストの構造的再帰（第1章の復習）

```text
;; ListOfNumber is one of:
;;  - empty
;;  - (cons Number ListOfNumber)
```

```racket
(define (list-of-number-temp lon)
  (cond
    [(empty? lon) (...)]
    [else (... (first lon)
               (list-of-number-temp (rest lon)))]))
```

例: 合計・長さ・所属判定（`contains?`）。

##### パターン B: 自然数（深さ）の再帰

```text
;; Depth is a Natural
;; interp. 再帰の残り段数。0 で葉（何もしない / 最小部品だけ）。
```

```racket
(define (depth-temp d)
  (cond
    [(zero? d) (...)]                      ; 基底
    [else (... d (depth-temp (sub1 d)))])) ; 再帰
```

##### factorial（短い例）

```racket
;; factorial: Natural -> Natural
(define (factorial n)
  (cond
    [(zero? n) 1]
    [else (* n (factorial (sub1 n)))]))
```

| 段 | 意味 |
|----|------|
| データ | Natural（0 または n+1 の形） |
| テンプレ | `zero?` / `sub1` の2枝 |
| 本体 | 基底 1、再帰 `(* n …)` |

デザインレシピ5段（howtocode）:

1. Signature / purpose / stub  
2. Examples（`check-expect` / `check-equal?`）  
3. Template（上の `depth-temp`）  
4. Body  
5. Test / review  

BSL ではテンプレ途中の `...` が許されます（第1章・姉妹編第2章）。本編の `#lang racket` では完成形を書き、テストで固めます。

> **三角ロジック**: リスト再帰＝「要素の並び」、深さ再帰＝「相似の段数」。フラクタルは後者＋図形の分割規則。

#### 3.3 タートルと再帰の組み合わせパターン

##### パターン1: 命令リストを `append` / `cons` で伸ばす

```racket
(define (spiral a x times)
  (if (< times 0)
      empty
      (append (list (forward x) (turn-left a))
              (spiral a (+ x 2) (sub1 times)))))
```

- 基底: `empty`（何も描かない）  
- 再帰: 今の1ステップ + 残りの螺旋  

##### パターン2: 「1ステップ分」を関数に切り出す（公式 spiral2）

```racket
(define (side-step x w a)
  (list (change-pen-size w)
        (forward x)
        (turn-left a)))

(define (spiral2 x w a times)
  (if (<= times 0)
      empty
      (cons (side-step x w a)
            (spiral2 (+ x 5) (+ w 1) a (sub1 times)))))
```

ネストしたリストでも `draw` は解釈できる（公式どおり）。

##### パターン3: 深さ d の図形 = 手前の作業 + 深さ d-1 の図形

第4章の木・コッホは、だいたい次の型紙です。

```racket
(define (fractal-temp d size)
  (cond
    [(<= d 0) (base-case size)]   ; 線分1本など
    [else (combine size
                   (fractal-temp (sub1 d) (smaller size)))]))
```

`combine` の中身が「コッホ置換」や「左右の枝」になる。

##### 付属コードで確かめること

- `factorial` / `list-sum` / `spiral` のステップ数  
- `command-steps` のような**純粋関数**でリスト長を数え、`rackunit`  
- `(draw …)` は任意（コメントアウト既定）

##### 練習

1. `spiral` の `times` を 10 にしたとき、`forward` は何回か（手計算 + コード）  
2. `depth-temp` を埋めて「深さ d のとき `forward` を d 回だけする」命令リストを書け  
3. 第2章の `regular-polygon` を、`repeat` ではなく再帰 `poly-rec` で書け  

> **三角ロジック**: 第4章へ進む前に、「基底・縮小・結合」の3語で自分の関数を説明できること。
