---
title: "序章　なぜ Racket で描くか"
---

> **この章のゴール**  
> 自己相似形（フラクタル）とは何かをつかみ、なぜ Racket（BSL → racket-turtle）から学ぶかを理解し、DrRacket で式を評価できる状態になる。  
> **スタイル参照**: [howtocode introduction](https://howtocode.pages.dev/introduction) / [installation](https://howtocode.pages.dev/installation) / [expressions](https://howtocode.pages.dev/expressions)  
> **言語**: 序盤 Beginning Student（`#lang htdp/bsl`）／本編描画は `#lang racket` + `teachpacks/racket-turtle`（**方針 A**）  
> **移植元**: [mypublish-gameoflife intro](https://github.com/bluehive/mypublish-gameoflife/blob/main/books/racket-game-of-life/intro.md)（目次整合のため改定）

#### 0.1 自己相似形とは（フラクタル入門）

**自己相似**とは、図形の一部分を拡大すると、全体と同じような形が現れる性質です。雪の結晶、木の枝分かれ、海岸線の入り組み——自然にも人工にも、この性質はあちこちで顔を出します。

数学では、コッホ曲線やシェルピンスキーの三角形のように、**同じ置き換え規則を何度も繰り返す**ことで自己相似な図形を定義できます。コンピュータでは、その「繰り返し」を**再帰**という書き方でそのまま表現できます。

本書では、画面上を「亀」が進んで線を引く **タートルグラフィックス**（`teachpacks/racket-turtle`）を使い、次のような図形を描いていきます。

- 正方形・多角形・螺旋（準備運動）
- フラクタルツリー
- コッホ曲線・コッホ雪片
- シェルピンスキーの三角形
- ドラゴン曲線など発展形

高校数学の「図形と式」「数列・規則の繰り返し」と、プログラミングの「関数・再帰」が一本の線でつながるのが目標です。お手本のプログラムはリポジトリの `code/` に置き、GitHub からも参照できるようにします。

> 三角ロジックで整理予定

#### 0.2 なぜ Racket か——構文より論理

プログラミングの難しさは、変数・ループ・条件といった部品そのものより、**部品をどう組み合わせて目的を達するか**にあります。作文にたとえれば、つづりより「論旨のつなぎ」です。

Java や Python などで最初に覚えることが多いのは次のような**言語ごとの作法**です。

- セミコロンをどこに打つか
- 中括弧・インデントがスコープにどう効くか
- クラスや修飾子、`main` の書き方

これらは後から慣れますが、**論理そのものから注意を奪いやすい**、という指摘があります（howtocode: *I'm not here to waste your time on the nuances of language syntax rules*）。

本書では **Racket** を使います。教育用に絞ると、式の形はだいたい次の一形です。

```racket
(演算子 引数1 引数2 …)
(+ 1 2)    ; => 3
```

起源は LISP 系です。括弧が多いと感じる人もいますが、HTML/JSON/JS が別文法になる世界と対照すると、「同じ形で木を書く」ことの単純さが見えてきます。

本の後半では、**自己相似な図形をタートルで描く**ことを題材に、式・リスト・再帰を積み上げます。ゲーム産業での Racket 利用例（howtocode が触れる Naughty Dog 等）は興味付けに留め、本線は「書いて試して直す」練習です。

姉妹編として、同じ Racket / BSL 系列で盤面シミュレーションを扱う  
[『Racketで学ぶ生命のゲーム』](https://github.com/bluehive/mypublish-gameoflife)  
もあります。本書は「描画と再帰」、あちらは「グリッドとルール」——どちらから読んでも構いません。

> 三角ロジックで整理予定

#### 0.3 DrRacket と BSL／言語レベルの見取り図

1. [Racket をダウンロード](https://download.racket-lang.org/)してインストールする  
2. DrRacket を起動する  
3. 推奨設定（howtocode installation）:
   - `Edit → Preferences → … → Show line numbers`
   - （任意）`View → Use Horizontal Layout`
4. **言語レベル（序盤）**: 左下（または Language メニュー）で **Beginning Student** を選ぶ  
   本リポジトリの基礎ファイル先頭は次でも同じです。

```racket
#lang htdp/bsl
```

`htdp/bsl` の **HtDP** は教科書 *How to Design Programs* の略で、**BSL** はその入門用言語レベル（Beginning Student Language）です。DrRacket の「Beginning Student」と同じ系統で、構文を絞りつつ `check-expect` やデザインレシピで学べます。公式: [HtDP Languages](https://docs.racket-lang.org/htdp-langs/index.html) / [Beginning Student](https://docs.racket-lang.org/htdp-langs/beginner.html)。

5. 定義ウィンドウに式を書き **Run**。下の相互作用ウィンドウが REPL になる。

**言語方針 A（本書の約束）**

| 段階 | 言語 | 用途 |
|------|------|------|
| 序章〜第1章（基礎） | BSL（`#lang htdp/bsl`） | 式・関数・`check-expect`・リストのさわり |
| 第2章以降（タートル本編） | `#lang racket` + `teachpacks/racket-turtle` | 命令リストで図形を描く |
| 付録 E | — | BSL と `#lang racket` の使い分けの根拠 |

`racket-turtle` の導入は付録 B と第2章で扱います。

```racket
; 一行コメント
#| 複数行コメント |#
```

式の形:

```racket
(+ 2 4)   ; => 6
```

- 引数の区切りは**スペース**（カンマではない）
- 引数自身が式でもよい。評価はおおむね**左から右、内側から外側**へ値に落とす

```racket
(+ 2 4 (* 5 5) (- (+ 3 3) 2) 1)
; (* 5 5) => 25, (+ 3 3) => 6, (- 6 2) => 4
; 最終的に (+ 2 4 25 4 1) => 36
```

エラーの典型:

- `((+ 3 4))` … 外側の括弧に演算子がない
- `(3 (+ 1 6))` … `3` は演算子ではない

**開き括弧の直後は常に演算子（または特殊フォーム）**、と覚える。

非正確数: `(sqrt 2)` や `pi` は `#i…` と表示されることがある（メモリ上の近似）。

練習: 直角三角形の斜辺  
`√(3²+4²)` を BSL の式で書け → `(sqrt (+ (* 3 3) (* 4 4)))`

付録 B で Windows 11 向けの手順を厚くします。

> 三角ロジックで整理予定

#### 0.4 本書の進め方（1週間レッスンプラン）

想定読者は高校生・趣味の社会人。目安語数は約2万字。楽しいお手本と、すぐ動くコードを優先します。

| 日 | 内容 | 章 |
|----|------|-----|
| 事前〜1 | Racket / BSL の式と関数 | 序章・第1章 |
| 1–2 | タートルで基本図形 | 第2章 |
| 3 | 再帰への橋渡し | 第3章 |
| 4–6 | フラクタル本編 | 第4章 |
| 7 | 現実世界・次の一歩 | 終章 |

進め方の予告:

1. 第1章 — 構文チート（式・define・cond・関数・リスト）  
2. 第2章 — `racket-turtle` の基本操作  
3. 第3章 — 再帰の型紙とタートルの組み合わせ  
4. 第4章 — ツリー・コッホ・シェルピンスキー・ドラゴン  
5. 終章 — フラクタルと現実、姉妹編への導線  

**デザインレシピ（最短）** — howtocode / HtDP の精神を短くすると:

- **データ** — 何を表すか（記述・解釈・例・テンプレ）
- **関数** — 署名・目的・stub・例（`check-expect`）・テンプレ・本体・見直し

詳細は第1章・第3章と [htdp_templates](https://howtocode.pages.dev/htdp_templates) を参照。

> 参考文献: [howtocode.pages.dev](https://howtocode.pages.dev/)（構成と教え方を参照。文章は日本語で再執筆）  
> 三角ロジックで整理予定
