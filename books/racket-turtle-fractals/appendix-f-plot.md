---
title: "付録 F　Racket Plot の基礎と Headless 画像生成"
---

> **この付録のゴール**  
> Racket 公式 `plot` ライブラリの背景、R 言語に勝るとも劣らない柔軟な設計思想、および GUI なしの環境（CI・書籍ビルド等）における Headless 画像出力 (`plot/bitmap`, `plot-file`) を習得する。  
> **付属コード**: `code/appendix-f-headless-plot.rkt`

#### F.1 R言語のプロット思想と Racket Plot の誕生

統計解析・データサイエンスの世界において、**R 言語**（特に `base plot` や `ggplot2` パッケージ）は「数式やデータを即座に美しいグラフとして可視化できる機能」で世界中の研究者やエンジニアに愛されてきました。

Racket の公式 `plot` ライブラリは、この R 言語の優れたビジュアライゼーション思想を取り入れつつ、**Racket の関数型プログラミング言語としての柔軟性** を融合させて再構築された本格的なプロットライブラリです。

#### F.2 なぜ Racket の `plot` は柔軟で強力なのか？

R の `ggplot2` のように「特別な記法や文法（`+` 演算子によるレイヤー加算）」を覚える必要はありません。Racket の `plot` には以下のような独自の強力な強みがあります。

1. **第一級オブジェクト（関数・リスト）による宣言的な合成（Composability）**  
   - レンダラー（`function`, `points`, `lines`, `contour-intervals` など）はすべて通常の Racket の値・関数です。  
   - 単に Racket のリスト `(list renderer1 renderer2 ...)` を作成して `plot` に渡すだけで、散布図・折れ線・関数グラフ・領域ハッチングなどを自由自在に重ね合わせることができます。
   - `sin` や `(lambda (x) ...)` などの Racket 関数をそのまま引数として直感的に描画できます。

2. **追加ライブラリなしで 3D・等高線（Contour）・曲面（Isosurface）に対応**  
   - 多くのプロットライブラリでは 3D 描画にサードパーティ製の重いパッケージが必要ですが、Racket では標準で `plot3d` や `surface3d`、`isosurface3d`（3次元空間内の等値面）が提供されています。
   - DrRacket 上では、描画された 3D グラフをマウスで直感的にドラッグ＆回転して視点を変えることができます。

3. **完全な視覚的独立性と二刀流出力 (`plot` と `plot-file`)**  
   - 描画ツリー（レンダラーのリスト）はデータとして完全に独立しているため、対話的な画面表示（DrRacket）も、GUI なし環境でのファイル出力（PNG/SVG/PDF/PS）も、**まったく同じ定義コードを使いまわす** ことができます。

```racket
#lang racket
(require plot)

;; (1) 2D関数の重ね合わせと範囲指定
(plot (list (function sin (- pi) pi #:color "blue" #:label "sin(x)")
            (function cos (- pi) pi #:color "red" #:label "cos(x)"))
      #:title "2D Trigonometric Plot")

;; (2) 3D 曲面の直感的プロット
(plot3d (surface3d (lambda (x y) (real-part (expt (+ x (* 0+1i y)) 3))) -2 2 -2 2)
        #:title "3D Surface Plot")
```

#### F.3 レンダラーの主要ラインナップ

| レンダラー | 役割 | コード例 |
|---|---|---|
| `function` | 1変数連続関数のグラフ | `(function sin 0 (* 2 pi))` |
| `points` | 散布図データ | `(points (list (vector 1 2) (vector 3 4)))` |
| `lines` | 頂点を結ぶ折れ線データ | `(lines (list (vector 0 0) (vector 1 1)))` |
| `discrete-histogram` | 離散ヒストグラム（棒グラフ） | `(discrete-histogram (list (vector 'A 10) ...))` |
| `polar-function` | 極座標関数（らせん・極方程式） | `(polar-function (lambda (t) t) 0 (* 4 pi))` |
| `contour-intervals` | 2変数関数の等高線帯表示 | `(contour-intervals (lambda (x y) (+ (* x x) (* y y))))` |
| `surface3d` | 3次元立体曲面 | `(surface3d (lambda (x y) (* (sin x) (cos y))) -pi pi -pi pi)` |

#### F.4 Headless 環境（GUIなし）での画像生成 (`plot-file` / `plot-bitmap`)

Zenn のプレビューや EPUB 書籍の作成、CI（継続的インテグレーション）などの自動化環境では、対話的な画面表示を行わずに **Headless で画像（PNG/SVG）に出力** する必要があります。

##### `plot-file` による直接書き出し
`plot` を `plot-file` に置き換え、ファイルパスと形式を指定するだけで自動的に画像が保存されます。

```racket
#lang racket
(require plot)

(plot-file
 (list (function sin (- pi) pi #:color "blue" #:label "y = sin(x)")
       (function cos (- pi) pi #:color "red" #:label "y = cos(x)"))
 "output/trig-plot.png"
 'png
 #:title "三角関数のプロット"
 #:x-label "x" #:y-label "y")
```

##### `plot-bitmap` によるビットマップ取得
プログラム中で直接画像データとして扱いたい場合は `plot-bitmap` を使用します。得られるオブジェクトは `2htdp/image` や `racket/draw` の `bitmap%` と互換性があります。

```racket
(define bm (plot-bitmap (function sin 0 (* 2 pi))))
```

#### F.5 まとめと自学への誘導

タートルグラフィックス（`racket-turtle`）による命令型の軌跡描画と、`plot` による関数型・宣言的なデータ可視化を組み合わせることで、グラフィックスプログラミングの視野は大きく広がります。

さらに高度なグラフ表現（アニメーション、カスタムレンダラーの作成、カラーマップの調整など）に挑戦したい方は、ぜひ公式ドキュメントを片手に色々試してみてください！

- **公式ドキュメント**: [Racket Plot: Graph Plotting](https://docs.racket-lang.org/plot/)
