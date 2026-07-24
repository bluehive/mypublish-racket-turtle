---
title: "第2章　タートルグラフィックス入門"
---

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
