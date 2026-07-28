---
title: "第4章　フラクタルを描く——自然の造形美に挑もう"
---

> **この章のゴール**  
> 「深さ `depth`」と「縮小サイズ `size`」を受け取る共通テンプレートを使って、フラクタルツリー・コッホ曲線・シェルピンスキーの三角形・ドラゴン曲線を自分の手で実装する。  
> **想定読者**: 夏休みにプログラミングを楽しみたい高校生  
> **付属コード**: `code/ch04-fractals.rkt` / `code/ch04-recursion-plot.rkt`

---

#### 4.0 フラクタルを描く万能テンプレート（共通型紙）

さまざまな種類のフラクタル図形がありますが、実はどれも**たった1つの共通テンプレート（骨組み）** から作られています。

```racket
(define (fractal d size)
  (cond
    [(<= d 0) (leaf size)]                     ; 基底条件: 深さ 0 なら最小パーツを描く
    [else (combine size                          ; 再帰ステップ: 縮小した自分を組み合わせて描く
                   (fractal (sub1 d) (next-size size)))]))
```

| 図形名 | 基底パーツ (`leaf`) | 再帰の呼び出し回数 | 1ステップごとのサイズ変化 (`next-size`) |
|---|---|---|---|
| **フラクタルツリー** | 短い直線1本 | **2回** (左右の枝) | `(* size 0.7)` |
| **コッホ曲線** | 直線1本 | **4回** (山型置換) | `(/ size 3)` |
| **シェルピンスキー** | 正三角形1つ | **3回** (3隅の頂点) | `(/ size 2)` |
| **ドラゴン曲線** | 直線1本 | **2回** (折りたたみ) | 固定または `(/ size (sqrt 2))` |

---

#### 4.1 フラクタルツリー（枝分かれする木）

##### 🌳 どうやって木を描くの？
1. まず幹（直線）を長さ `size` だけ前進して描きます。
2. 左へ角度 `angle` だけ向きを変え、深さ `(sub1 depth)`・長さ `(* size 0.7)` で **「小さな木」を再帰呼び出し** します。
3. 次に右へ `(* 2 angle)` だけ向きを変え、同じように **「小さな木」を再帰呼び出し** します。
4. 描き終わったら元の向きと位置に戻ります。

```racket
(define (tree depth size angle)
  (cond
    [(<= depth 0)
     (list (forward size) (forward (- size)))]   ; 基底: 往復して元の場所へ戻る
    [else
     (append
      (list (forward size))                      ; 幹を描く
      (list (turn-left angle))
      (tree (sub1 depth) (* size 0.7) angle)     ; 左の木を再帰描画
      (list (turn-right (* 2 angle)))
      (tree (sub1 depth) (* size 0.7) angle)     ; 右の木を再帰描画
      (list (turn-left angle))                   ; 向きを元に戻す
      (list (forward (- size))))]))              ; 位置を元に戻す
```

たったこれだけのコードで、`depth` を 6 や 8 に増やすと、本物の樹木のような美しい大木が描かれます！

---

#### 4.2 コッホ曲線・コッホ雪片（海岸線と雪の結晶）

##### ❄️ 直線が「山」に化ける魔法
コッホ曲線は、1本のまっすぐな線を、中央が山型に盛り上がった **4本の小さな線** に置き換える処理を繰り返すフラクタルです。

```text
【元の線 (depth 0)】     ───────────────
【1回置換 (depth 1)】    ──────/\──────
```

```racket
(define (koch-line depth size)
  (cond
    [(<= depth 0)
     (list (forward size))]                      ; 基底: 直線1本
    [else
     (define s3 (/ size 3.0))                    ; 1/3 のサイズ
     (append (koch-line (sub1 depth) s3)         ; 1本目進む
             (list (turn-left 60))
             (koch-line (sub1 depth) s3)         ; 2本目 (山の上り)
             (list (turn-right 120))
             (koch-line (sub1 depth) s3)         ; 3本目 (山の下り)
             (list (turn-left 60))
             (koch-line (sub1 depth) s3))]))     ; 4本目進む
```

正三角形の3つの辺それぞれに `koch-line` を適用すると、本物の雪の結晶のような **コッホ雪片（Koch Snowflake）** になります！

---

#### 4.3 シェルピンスキーの三角形

##### 🔺 三角形の中に無限に潜む三角形
シェルピンスキーの三角形は、大きな正三角形の各3隅の頂点に、1/2 サイズの小さな正三角形を再帰的に配置していくフラクタルです。

```racket
(define (sierpinski depth size)
  (cond
    [(<= depth 0)
     (triangle-outline size)]                    ; 基底: 一辺 size の正三角形1つ
    [else
     (define half (/ size 2.0))
     (append
      (sierpinski (sub1 depth) half)             ; 下左の小さな三角形
      (list (forward half))
      (sierpinski (sub1 depth) half)             ; 下右の小さな三角形
      (list (forward (- half)) (turn-left 60) (forward half) (turn-right 60))
      (sierpinski (sub1 depth) half)             ; 上の小さな三角形
      (list (turn-left 60) (forward (- half)) (turn-right 60)))]))
```

---

#### 4.4 ドラゴン曲線（紙折りから生まれる竜）

紙テープを何度も半分に折りたたんでから、折り目を $90^\circ$ に開いたときに現れる不思議な曲線です。左右の折り曲げ方向の符号を切り替えながら再帰呼び出しを行います。

```racket
(define (dragon depth size turn)
  (cond
    [(<= depth 0)
     (list (forward size))]
    [else
     (append (dragon (sub1 depth) size 1)
             (list (turn-left (* turn 90)))
             (dragon (sub1 depth) size -1))]))
```

---

#### 💡 コラム: Racket Plot で再帰の「ノード数爆発」を可視化する

フラクタルを描画する際、深さ `depth` が 1 増えるごとに描画ステップ数や頂点数は $2^d, 3^d, 4^d$ と指数関数的に急増します。この「構造の爆発」をタートルの線の本数だけでなく、数値やグラフで視覚的に捉えるのに最適なのが Racket 公式の **`plot`** ライブラリです。

```racket
#lang racket
(require plot)

;; 深さ d における二分木のノード数 (2^d)
(define (tree-node-count depth) (expt 2 depth))

;; ヒストグラム描画
(plot (discrete-histogram (map (lambda (d) (vector (number->string d) (tree-node-count d)))
                               '(0 1 2 3 4 5 6)))
      #:title "Binary Tree Node Count by Depth"
      #:x-label "Depth" #:y-label "Nodes")
```

（付属コード: `code/ch04-recursion-plot.rkt`）

---

💡 **ここで押さえておきたい Racket `plot` の3大魅力（売り）**

1. **関数型レンダラーの自由な重ね合わせ（Composability）**  
   `plot` に渡すのは単なる Racket のリスト `(list (discrete-histogram ...) (function ...))` です。複雑な文法ルールなしで、グラフや散布図、注釈を自由自在にレイヤー化できます。
2. **2D から 3D・等高線（Contour / Isosurface）まで標準対応**  
   外部の重いパッケージをインストールしなくても、`plot3d` や `surface3d` を呼び出すだけで、DrRacket 上でマウス操作可能な 3D サーフェスプロットが即座に動作します。
3. **対話描画 & Headless 自動生成 (`plot-file`) の二刀流**  
   DrRacket 上での対話的な確認と、スクリプトや CI、書籍ビルドでの PNG/SVG 自動ファイル保存が全く同じ描画ツリーコードでシームレスに行えます。

---

🚀 **あとは自分で勉強してみて！**  
Racket の `plot` ライブラリには、散布図や折れ線、極座標プロット（`polar-function`）、3D 曲面など、データサイエンス言語 R に匹敵する豊かな機能が詰まっています。ぜひ公式ドキュメント（[https://docs.racket-lang.org/plot/](https://docs.racket-lang.org/plot/)）を片手に、色々な関数やデータをプロットして自分で探求してみてください！ （詳細は [付録 F](appendix-f-plot.md) も参照）

#### 4.5 付属コードの実行

```bash
racket code/ch04-fractals.rkt
racket code/ch04-recursion-plot.rkt
```

構造テスト（ステップ数・リスト非空）が自動実行されます。自作したフラクタルを DrRacket で表示して楽しんでみましょう！
