---
title: "第4章　フラクタルを描く——自然の造形美に挑もう"
---

> **この章のゴール**  
> 「深さ `depth`」と「縮小サイズ `size`」を受け取る共通テンプレートを使って、フラクタルツリー・コッホ曲線・シェルピンスキーの三角形・ドラゴン曲線を自分の手で実装する。  
> **想定読者**: プログラミングを楽しみたい人  
> **付属コード**: `code/ch04-fractals.rkt` / `code/ch04-recursion-plot.rkt`

---

#### 4.0 フラクタルを描く万能テンプレート（共通型紙）

> **注意**: ここで示す `leaf` / `combine` などの名前は「考え方の型紙」です。**このままでは動きません。** 実際に動かす本体は、このあとの各節の関数（`tree` / `koch-line` など）です。

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

> **💬 第3章との対比: 「止める」の意味が違う**
>
> 第3章の `spiral` は、基底条件で `empty`（**何も描かない**）を返しました。「止める = 何もしない」です。
>
> 一方、第4章のフラクタルは、基底条件で `leaf`（**最小パーツを1つ描く**）を返します。「止める = 一番小さな部品を置く」です。
>
> どちらも「これ以上細かく分けない」という意味では同じ。違いは**「何も残さず終わる」か「最後の1個を置いて終わる」か**、です。この2つを混同すると、木が「深さ0で何も描かれない」などの謎のバグになります。

---

#### 4.1 フラクタルツリー（枝分かれする木）

##### 🌳 どうやって木を描くの？
1. まず幹（直線）を長さ `size` だけ前進して描きます。
2. 左へ角度 `angle` だけ向きを変え、深さ `(sub1 depth)`・長さ `(* size 0.7)` で **「小さな木」を再帰呼び出し** します。
3. 次に右へ `(* 2 angle)` だけ向きを変え、同じように **「小さな木」を再帰呼び出し** します。
4. 描き終わったら元の向きと位置に戻ります。

> **なぜ `forward (- size)` で戻るの？**
>
> カメは「今どこにいて、どちらを向いているか」を常に覚えています（**状態**を持っています）。再帰で左の枝を描き終えても、**カメは枝の先端にいるまま**です。右の枝を幹の付け根から生やすには、自分で幹を逆向きに歩いて戻らなければなりません。
>
> ```text
> 幹を描く → 左の小木 → （向きを調整）→ 右の小木 → 向きを戻す → 幹を後退して付け根へ
> ```
>
> `forward (- size)` は「同じ長さだけ後ろへ下がる」の意味です。戻し忘れると、次の枝が空中から生えたようにズレてしまいます。**フラクタル再帰 = 小さな自分を呼ぶ + （必要なら）位置と向きを元に戻す**、とセットで覚えましょう。

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

まず基底で使う部品 `triangle-outline` です。第2章の `regular-polygon` を「正三角形に特化」させたもの（一辺を描く→120度左→もう一辺…を3回）です。

```racket
;; triangle-outline: Number -> CommandList
;; 一辺 size の正三角形の輪郭を描く命令リスト
(define (triangle-outline size)
  (list (forward size)
        (turn-left 120)
        (forward size)
        (turn-left 120)
        (forward size)
        (turn-left 120)))
```

ここでも `turn-left 120`（内角ではなく**外角**120度）を3回使っているのがポイントです。第2章の「正多角形 = 外角 360/n を n 回」の知識が、そのままフラクタルで生きています。

次に、小さな三角形を3か所に置く本体です。イメージは次の3ステップです。

1. **下左**に小さい三角形を描く
2. 右へ半辺ぶん進んで **下右** を描く
3. 付け根へ戻る向きに歩き直してから **上** を描き、また戻る

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

> **💡 図が画面からはみ出すとき: `go-to` で場所を移動しよう**
>
> `depth` を増やすと図が大きくなり、画面の外にはみ出すことがあります。そんなときは、描画を始める前に**ペンを上げて**好きな位置へ移動してから**ペンを下ろして**描き始めます:
>
> ```racket
> (draw (list (pen-up) (go-to 200 50) (pen-down)
>             (tree 5 80 30)))
> ```
>
> - `(pen-up)` … ペンを上げる（線を描かない移動）
> - `(go-to x y)` … カメを座標 (x, y) へ移動（目安の数値。はみ出したら変えて試す。原点や軸の向きは環境により異なることがある）
> - `(pen-down)` … ペンを下ろす（ここから線を描く）
>
> `go-to` で図の開始位置を画面中央や左上に調整すると、はみ出しを避けられます。

---

#### 4.4 ドラゴン曲線（紙折りから生まれる竜）

紙テープを何度も半分に折りたたんでから、折り目を $90^\circ$ に開いたときに現れる不思議な曲線です。引数 `turn` は折りの左右で、`1` と `-1` が「どちらへ 90 度曲げるか」の符号です（呼び出しでは最初に `1` を渡すことが多いです）。

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

💡 **Racket `plot` で押さえておきたいこと（ざっくり）**

1. **グラフを重ねて描ける**  
   `plot` には普通のリストで「棒グラフ」「関数の曲線」などを並べて渡せます。
2. **2D だけでなく、興味があれば 3D も試せる**  
   標準の `plot3d` などで立体も描けます（まずは 2D で十分です）。
3. **画面表示と、画像ファイル保存の両方**  
   DrRacket で見ながら試すことも、画面を出さずに PNG/SVG へ保存することもできます（くわしくは付録 F）。

---

🚀 **あとは自分で勉強してみて！**  
Racket の `plot` ライブラリには、散布図や折れ線、極座標プロット（`polar`）、3D 曲面など、データサイエンス言語 R に匹敵する豊かな機能が詰まっています。ぜひ公式ドキュメント（[https://docs.racket-lang.org/plot/](https://docs.racket-lang.org/plot/)）を片手に、色々な関数やデータをプロットして自分で探求してみてください！ （詳細は [付録 F](appendix-f-plot.md) も参照）

#### 4.5 付属コードの実行

```bash
racket code/ch04-fractals.rkt
racket code/ch04-recursion-plot.rkt
```

構造テスト（ステップ数・リスト非空）が自動実行されます。自作したフラクタルを DrRacket で表示して楽しんでみましょう！
