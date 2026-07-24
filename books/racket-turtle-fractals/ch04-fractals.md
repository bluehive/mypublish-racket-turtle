---
title: "第4章　フラクタルを描く"
---

> **この章のゴール**  
> 深さ `Depth` をデータとみなし、ツリー・コッホ・シェルピンスキー・ドラゴンを**テンプレート駆動**で実装する。  
> **付属コード**: `code/ch04-fractals.rkt`  
> **レッスン**: 4–6日目  
> **howtocode**: データ定義が `cond` の枝を決める / [htdp_templates](https://howtocode.pages.dev/htdp_templates)

#### 4.0 共通データと共通テンプレート

```text
;; Depth is a Natural
;; interp. 自己相似の残り段数。0 なら「これ以上分割しない」。

;; Size is a PositiveNumber
;; interp. 今の辺・枝の長さ（ピクセル）。
```

**共通テンプレート（主張）**

```racket
(define (fractal d size)
  (cond
    [(<= d 0) (leaf size)]                 ; 基底: 最小部品
    [else (branch size                       ; 結合規則は図形ごと
                   (fractal (sub1 d) (next-size size)))]))
```

| 図形 | `leaf` | `branch` / 分割規則 | `next-size` |
|------|--------|---------------------|-------------|
| ツリー | 短い線1本 | 幹 + 左右に再帰 | `* 0.7` など |
| コッホ | 線分1本 | 1辺→4辺置換 | `/ 3` |
| シェルピンスキー | 三角形1つ | 3隅に再帰 | `/ 2` |
| ドラゴン | 線分 | 折りたたみ L/R | 固定 or `/√2` |

> **三角ロジック**: 図形の違いは「データの解釈」と「combine の中身」だけ。再帰の骨格は共通。

#### 4.1 フラクタルツリー

##### 解釈

幹を `size` だけ描き、左に `angle`、右に `-angle` だけ向きを変え、長さを縮めて同じ木を描く。描き終わったら向きを戻す（亀の状態を崩さない）。

##### デザインレシピ

1. **Signature**: `(tree depth size angle) -> CommandList`  
2. **Examples**: depth 0 → 線1本；depth 1 → 幹+左右の短い枝  
3. **Template**: `depth-temp` + 回転の前後対称  
4. **Body**:

```racket
(define (tree depth size angle)
  (cond
    [(<= depth 0)
     (list (forward size) (forward (- size)))] ; 往復で位置を戻す流儀もある
    [else
     (append
      (list (forward size))
      (list (turn-left angle))
      (tree (sub1 depth) (* size 0.7) angle)
      (list (turn-right (* 2 angle)))
      (tree (sub1 depth) (* size 0.7) angle)
      (list (turn-left angle))
      (list (forward (- size))))]))
```

実装の細部（位置を戻すか、pen-up で戻るか）は付属コードを正とする。重要なのは **depth が1減り size が縮小する**こと。

> **三角ロジック**: 木の自己相似＝「小さな木が2つ」というデータ分解。

#### 4.2 コッホ曲線・コッホ雪片

##### 動機: 海岸線の長さ

ものさしを細かくするほど海岸線は長く測れる——コッホ曲線はその理想化です。1辺を次の4辺に置換します。

```text
  ------          が次の段で
  --/\--          （中央が山型）
```

各小辺の長さは元の `1/3`。

##### データとテンプレート

```racket
;; koch-line: Depth Size -> CommandList
(define (koch-line depth size)
  (cond
    [(<= depth 0)
     (list (forward size))]
    [else
     (define s3 (/ size 3))
     (append (koch-line (sub1 depth) s3)
             (list (turn-left 60))
             (koch-line (sub1 depth) s3)
             (list (turn-right 120))
             (koch-line (sub1 depth) s3)
             (list (turn-left 60))
             (koch-line (sub1 depth) s3))]))
```

雪片: 正三角形の各辺を `koch-line` に置き換え、外角 120° でつなぐ。

```racket
(define (koch-snowflake depth size)
  (append (koch-line depth size)
          (list (turn-right 120))
          (koch-line depth size)
          (list (turn-right 120))
          (koch-line depth size)))
```

**howtocode 的チェック**: 基底は「線分1本」だけ。置換規則はデータ（depth>0）の枝にだけ書く。

> **三角ロジック**: コッホは「1辺 → 4辺」の文法。再帰はその文法の適用回数。

#### 4.3 シェルピンスキーの三角形

##### 解釈

大きな正三角形の各頂点付近に、一辺半分のシェルピンスキーを置く（または中抜き規則）。タートルでは「三角形を描く」「次の頂点へ移動」を組み合わせる。

##### テンプレート

```racket
(define (sierpinski depth size)
  (cond
    [(<= depth 0)
     (triangle-outline size)]   ; 正三角形1つ
    [else
     (define half (/ size 2))
     (append (sierpinski (sub1 depth) half)
             (move-to-next-vertex half)
             (sierpinski (sub1 depth) half)
             (move-to-next-vertex half)
             (sierpinski (sub1 depth) half))]))
```

`triangle-outline` と移動は付属コードで定義。深さ d の図は深さ d-1 の図が**3つ**——データ分解が3枝。

> **三角ロジック**: 枝の本数（2=木、3=シェルピンスキー、4=コッホ辺）が `cond` 内の再帰呼び出し回数と一致する。

#### 4.4 ドラゴン曲線と発展図形

##### ドラゴン（折り紙の折りたたみ）

古典的な定義のひとつ: 曲線を「左折り・右折り」の列で表し、次の世代は規則で伸ばす。タートル版の簡易実装は次の型紙です。

```racket
;; dragon: Depth Size TurnDir -> CommandList
;; TurnDir is +1 (左系) または -1 (右系)
(define (dragon depth size turn)
  (cond
    [(<= depth 0)
     (list (forward size))]
    [else
     (append (dragon (sub1 depth) size 1)
             (list (turn-left (* turn 90)))
             (dragon (sub1 depth) size -1))]))
```

（向きの符号の取り方は実装で調整。付属コードを正とする。）

##### 発展

- 四角形フラクタル: コッホの角を 90° 系にした変種  
- 公式の花・星螺旋（第3章）を「スタンプ＋再帰」で再訪  
- `2htdp/image` だけで組み立てる別解（終章へ）

##### 練習

1. `koch-line` の depth 0,1,2 で `forward` の回数が 1,4,16 になることをコードで確認  
2. 木の `0.7` を `0.5` に変えて見た目の違いを観察  
3. （任意）ドラゴン depth 8 以上はステップ数が爆発するので、テストは depth≤4 に限定  

> **三角ロジック**: フラクタルの「複雑さ」は深さの関数。データ（depth）を抑えれば計算も描画も有限のまま。

#### 4.5 付属コード

```bash
racket code/ch04-fractals.rkt
```

構造テスト（ステップ数・リスト非空）を自動実行。`draw` はコメントアウト既定。
