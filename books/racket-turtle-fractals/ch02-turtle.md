---
title: "第2章　タートルグラフィックス入門——カメと一緒に図形を描こう"
---

> **この章のゴール**  
> カメ（タートル）を動かす命令のリスト（`CommandList`）を自分自身で設計し、正方形・正多角形・カラフルな図形を描けるようになる。  
> **想定読者**: プログラミングを楽しみたい人  
> **言語方針 A（今版）**: `#lang htdp/bsl` + `(require teachpacks/racket-turtle)`  
> **付属コード**: `code/ch02-turtle.rkt`

---

#### 2.0 タートルグラフィックスの歴史

##### 🐢 タートルグラフィックスってどこから来たの？
「画面上のカメ（タートル）を動かして図形を描く」というアイデアは、今から半世紀以上前の1960年代、マサチューセッツ工科大学（MIT）の **シーモア・パパート（Seymour Papert）教授** らによって開発された教育用言語 **Logo** で誕生しました。

パパート教授は、子どもたちが「自分がカメになったつもりで歩いてみる」という身体の感覚を使って、楽しく幾何学とプログラミングを学べるように、という願いを込めてタートルを作りました。この思想は、後の教育用プログラミング環境にも受け継がれています。

#### 2.1 `racket-turtle` の基本操作

##### 🛠️ コマンド一覧表
`racket-turtle` ライブラリで使う主な命令（コマンド）を見てみましょう。

| コマンド | 意味 |
|---|---|
| `(forward x)` | x ピクセル前進する（負の数なら後退） |
| `(turn-left a)` | a 度 左へ向く |
| `(turn-right a)` | a 度 右へ向く |
| `(repeat k cmd-list)` | 命令リスト `cmd-list` を k 回繰り返す |
| `(pen-up)` | ペンを上げる（線を引かずに移動） |
| `(pen-down)` | ペンを下ろす（線を引く） |
| `(change-color c)` | ペンの色を `c` に変更する |
| `(change-pen-size w)` | ペンの太さを `w` ピクセルにする |
| `(draw cmds)` | 命令リスト `cmds` を実行して画面に描画 |

##### 📐 正方形を描く指示書を作ってみよう
「100進んで、90度左に曲がる」を4回繰り返せば正方形になりますね。

```racket
#lang htdp/bsl
(require teachpacks/racket-turtle)

;; 正方形の指示書（CommandList）を作る
(define square1
  (list
   (forward 100) (turn-left 90)
   (forward 100) (turn-left 90)
   (forward 100) (turn-left 90)
   (forward 100) (turn-left 90)))

;; カメを走らせて描画する！
(draw square1)
```

---

#### 2.2 正方形・正三角形・正多角形をつくる関数

##### 📐 数学の復習: 正多角形と「外角（Exterior Angle）」
カメが多角形を描くとき、回転させる角度は**内角ではなく外角**です！

正 $n$ 角形を一周描いて元の向きに戻ってくるとき、カメは合計で $360^\circ$ 回転します。したがって、1回の角で曲がる外角の大きさは次の一発の公式で求まります。

$$\text{外角} = \frac{360^\circ}{n}$$

- **正三角形 ($n=3$)**: 外角 $= 360 / 3 = 120^\circ$
- **正方形 ($n=4$)**: 外角 $= 360 / 4 = 90^\circ$
- **正六角形 ($n=6$)**: 外角 $= 360 / 6 = 60^\circ$

##### ⚙️ どんな多角形も作れる関数 `make-regular-polygon`
「1辺の長さ `len`」と「角の数 `n`」を引数に受け取り、正 $n$ 角形の指示書を自動生成する関数を作ってみましょう。

```racket
;; 1辺を描いて外角だけ左に回るパーツ
(define (side len exterior-deg)
  (list (forward len)
        (turn-left exterior-deg)))

;; 正 n 角形を作る関数
(define (make-regular-polygon len n)
  (repeat n (side len (/ 360 n))))
```

たったこれだけで、正六角形も正100角形（ほとんど円！）も自由自在に描けるようになります。

```racket
;; 一辺 80 の正六角形を描く指示書
(define hexagon (make-regular-polygon 80 6))

(draw hexagon)
```

---

#### 2.3 色・ペン・スタイルの装飾

見た目を鮮やかに装飾する命令も、すべて `CommandList` の中に含めることができます。

```racket
(define fancy-polygon
  (append (list (change-bg-color "black")   ; 背景を黒にする
                (change-color "gold")       ; 線を金色にする
                (change-pen-size 4))        ; ペンを太さ 4 にする
          (make-regular-polygon 70 8)))          ; 正八角形を描く
```

（※付属コード `code/ch02-turtle.rkt` には、同じ装飾を「正方形」に施した `fancy-square` が載っています。形とペン太さが違いますが、**「装飾命令リスト + 図形命令リスト」という構造は同じ**です。ここでは説明のため正八角形で示しました。）

##### 🎨 `append` によるリストの合成
装飾の命令リストと図形の命令リストは、Racket の **`append`** 関数を使えば簡単にがっちゃんこ（連結）できます！

```racket
(define (decorate style shape)
  (append style shape))
```

命令もスタイルもどちらも「リスト（`CommandList`）」なので、レゴブロックのように好きな順番で繋ぎ合わせることができます。

---

#### 2.4 まとめと付属コードの実行

本章では、カメを動かす基本的な命令と、それらを組み合わせた正多角形の描き方を学びました。

付属コード `code/ch02-turtle.rkt` には、正多角形や星型（五芒星）を描くコードが入っています。

```bash
racket code/ch02-turtle.rkt
```

DrRacket でファイルを開き、末尾の `(draw ...)` のコメントアウト `;` を外して **Run** してみましょう。カラフルな図形が画面に表示されます！

次章では言語を ISL に切り替え、`repeat` や `build-list` / `map` などの繰り返しで、もっと複雑な図形に挑戦します（明示的な再帰は今版では扱いません）。
