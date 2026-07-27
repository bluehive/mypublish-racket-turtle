---
title: "付録 F　Racket Plot の基礎と Headless 画像生成"
---

> **この付録のゴール**  
> Racket 公式 `plot` ライブラリの基礎構造、宣言的ビジュアライゼーション手法、および GUI なしの環境（CI・書籍ビルド等）における Headless 画像出力 (`plot/bitmap`, `plot-file`) を習得する。  
> **付属コード**: `code/appendix-f-headless-plot.rkt`

#### F.1 Racket Plot ライブラリの概要

Racket には公式で強力な 2D/3D プロットライブラリ `plot` が標準搭載されています。  
タートルグラフィックス（`racket-turtle`）が **手順型・状態遷移的** に描画するのに対し、`plot` は数式やデータ系列を **宣言的・関数型** に記述してレンダラー（`renderer`）のリストとして合成します。

```racket
#lang racket
(require plot)

;; 基本的な2D関数プロット
(plot (function sin (- pi) pi #:color "blue"))
```

#### F.2 レンダラーの組み合わせ

`plot` 関数はレンダラーのリストを受け取るため、複数のグラフや散布図、注釈を簡単に重ね合わせることができます。

```racket
(plot (list (points (list (vector 1 2) (vector 3 4) (vector 5 1)) #:color "red")
            (function (lambda (x) (* 0.5 x)) 0 6 #:color "blue")))
```

##### 主なレンダラー一覧

| レンダラー | 用途 | 例 |
|---|---|---|
| `function` | 連続関数のグラフ描画 | `(function sin 0 (* 2 pi))` |
| `points` | 散布図データ | `(points (list (vector x y) ...))` |
| `lines` | 折れ線グラフ | `(lines (list (vector x y) ...))` |
| `discrete-histogram` | 離散ヒストグラム（棒グラフ） | `(discrete-histogram (list (vector 'a 10) ...))` |
| `polar-function` | 極座標関数（らせん・花弁等） | `(polar-function (lambda (t) t) 0 (* 4 pi))` |

#### F.3 Headless 環境（GUIなし）での画像生成 (`plot-file` / `plot-bitmap`)

DrRacket 上では `plot` の呼び出しによって対話的な描画ウィンドウが表示されますが、Zenn や EPUB の書籍執筆、CI などのスクリプト環境では **Headless（非対話的）に画像ファイル（PNG/SVG）として保存** することが一般的です。

##### `plot-file` によるファイル直接書き出し

```racket
#lang racket
(require plot)

(plot-file
 (list (function sin (- pi) pi #:color "blue" #:label "y = sin(x)")
       (function cos (- pi) pi #:color "red" #:label "y = cos(x)"))
 "output/trig-plot.png"
 'png
 #:title "三角関数のプロット"
 #:x-label "x"
 #:y-label "y")
```

##### `plot-bitmap` によるビットマップオブジェクトの取得

```racket
(define bm (plot-bitmap (function sin 0 (* 2 pi))))
;; bm は 2htdp/image や racket/draw と互換性のある bitmap% オブジェクト
```

#### F.4 まとめ

タートルグラフィックスによる動的な軌跡描画と、`plot` による宣言的なデータ・関数ビジュアライゼーションを組み合わせることで、Racket の豊かな表現力を最大限に活かすことができます。
