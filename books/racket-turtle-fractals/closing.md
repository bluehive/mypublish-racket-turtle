---
title: "終章　高校数学の学びは大人でも楽しい"
---

> **この章のゴール**  
> フラクタルと現実世界の接点を確認し、次に進むライブラリと姉妹編を知る。  
> **レッスン**: 7日目

#### 5.1 フラクタルと現実世界

- 海岸線・樹木・血管・生成デザイン  
- 「無限に細かく見える」ことと、有限の再帰深さで近似すること  

> 三角ロジックで整理予定

#### 5.2 次の一歩

##### (1) タートルから Racket Plot へのステップアップ（宣言的グラフィックス）
タートルグラフィックス（`racket-turtle`）では「タートルの移動命令（手順）」をリストにして幾何図形を組み立てましたが、Racket には公式のプロットライブラリ `plot`（`(require plot)`）も用意されています。
`plot` では「数式やデータ系列をレンダラーで宣言的に記述する」スタイルでグラフや曲線を描画できます。

- **タートル描画**: 「ペンを動かして線を描く」（手続き型・状態遷移）
- **Plot 描画**: 「関数 $r(\theta)$ やデータ系列をプロットする」（宣言型・関数型）

例えば、タートルで描いた対数螺旋（Spiral）は、`plot` の極座標関数 `polar-function` を使うと次のように宣言的に記述できます。

```racket
#lang racket
(require plot)

;; 対数螺旋 r(theta) = e^(0.15 * theta) のプロット
(plot (polar-function (lambda (theta) (exp (* 0.15 theta))) 0 (* 4 pi))
      #:title "Logarithmic Spiral")
```

（付属コード: `code/ch05-plot-spiral.rkt`）

##### (2) さらなる表現・発展ライブラリ
- `plot` — 2D/3D プロット・関数/データ可視化（詳細は [付録 F](appendix-f-plot.md) 参照）
- `2htdp/image` — 関数合成で図形を組み立てる  
- `big-bang` — アニメーション・対話  
- 姉妹編: [Racketで学ぶ生命のゲーム](https://github.com/bluehive/mypublish-gameoflife)  
- 公式: [Racket Turtle 再帰例](https://docs.racket-lang.org/racket_turtle/racket_turtle_examples_with_recursion.html)  

> 三角ロジックで整理予定

