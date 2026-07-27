# mypublish-racket-turtle

**『自己相似形グラフィック入門』**（副題: Racket タートルで学ぶフラクタルと再帰）の執筆リポジトリ。

- **コード・執筆**: [Grok 4.5](https://x.ai) 協業
- **公開**: [Zenn](https://zenn.dev) 本 → 最終確認後に EPUB / Kindle
- **教材スタイル参照**: [howtocode.pages.dev](https://howtocode.pages.dev/)
- **作業計画**: [plan.md](./plan.md)
- **ライセンス**: [MIT](./LICENSE)
- **起票**: [draft-publish-books-2026#15](https://github.com/bluehive/draft-publish-books-2026/issues/15)

## この README の目次

- [本の目次](#本の目次)
- [付録](#付録)
- [言語方針 A](#言語方針-a)
- [フォルダ構成](#フォルダ構成)
- [開発フロー（Zenn → EPUB）](#開発フローzenn--epub)
- [セットアップ](#セットアップ)
- [よく使うタスク](#よく使うタスク)
- [移行元・関連](#移行元関連)

## 本の目次

**目次の正本は本 README と `books/racket-turtle-fractals/`。**  
章本文の正本は `books/racket-turtle-fractals/`。

### 序章　なぜ Racket で描くか

- 原稿: [intro.md](books/racket-turtle-fractals/intro.md)
- 0.1 自己相似形とは（フラクタル入門）
- 0.2 なぜ Racket か——構文より論理
- 0.3 DrRacket と BSL／言語レベルの見取り図
- 0.4 本書の進め方（1週間レッスンプラン）
- 各節末メモ: 三角ロジックで整理予定

### 第1章　Racket の基礎——式と関数

- 原稿: [ch01-basics.md](books/racket-turtle-fractals/ch01-basics.md)
- コード: [ch01-basics.rkt](code/ch01-basics.rkt)（`#lang htdp/bsl`）
- 1.1 式・評価・基本データ
- 1.2 定数と関数、`check-expect`
- 1.3 条件分岐（`if` / `cond`）
- 1.4 リストのさわり（コマンド列の下準備）
- 各節末メモ: 三角ロジックで整理予定

### 第2章　タートルグラフィックス入門（レッスン1–2日目）

- 原稿: [ch02-turtle.md](books/racket-turtle-fractals/ch02-turtle.md)
- コード: [ch02-turtle.rkt](code/ch02-turtle.rkt)（`#lang racket` + racket-turtle）
- 状態: ドラフト（howtocode データ駆動・CommandList / #1）
- 2.0 データ駆動の約束
- 2.1 `racket-turtle` の考え方
- 2.2 正方形・三角形・多角形
- 2.3 色・ペン・スタンプ
- 2.4 関数で図形を再利用

### 第3章　再帰への橋渡し（レッスン3日目）

- 原稿: [ch03-recursion.md](books/racket-turtle-fractals/ch03-recursion.md)
- コード: [ch03-recursion.rkt](code/ch03-recursion.rkt)
- 状態: ドラフト（テンプレート駆動・#2）
- 3.0 なぜ再帰か
- 3.1 繰り返す図形から再帰へ
- 3.2 再帰の型紙（リスト／深さ）
- 3.3 タートルと再帰の組み合わせパターン

### 第4章　フラクタルを描く（レッスン4–6日目）

- 原稿: [ch04-fractals.md](books/racket-turtle-fractals/ch04-fractals.md)
- コード: [ch04-fractals.rkt](code/ch04-fractals.rkt)
- 状態: ドラフト（Depth テンプレ・#2）
- 4.0 共通データと共通テンプレート
- 4.1 フラクタルツリー
- 4.2 コッホ曲線・コッホ雪片
- 4.3 シェルピンスキーの三角形
- 4.4 ドラゴン曲線と発展図形

### 終章　高校数学の学びは大人でも楽しい（レッスン7日目）

- 原稿: [closing.md](books/racket-turtle-fractals/closing.md)
- 5.1 フラクタルと現実世界
- 5.2 次の一歩
- 各節末メモ: 三角ロジックで整理予定

### 1週間レッスンプラン

| 日 | 章 |
|----|-----|
| 事前〜1 | 序章・第1章 |
| 1–2 | 第2章 |
| 3 | 第3章 |
| 4–6 | 第4章 |
| 7 | 終章 |

## 付録

| 付録 | 内容 | 原稿 |
|------|------|------|
| A | 完全ソース一覧 | [appendix-a-source-code.md](books/racket-turtle-fractals/appendix-a-source-code.md) |
| B | 環境構築（Racket / teachpacks） | [appendix-b-environment.md](books/racket-turtle-fractals/appendix-b-environment.md) |
| C | 復習と例題集 | [appendix-c-exercises.md](books/racket-turtle-fractals/appendix-c-exercises.md) |
| D | 参考文献 | [appendix-d-references.md](books/racket-turtle-fractals/appendix-d-references.md) |
| E | BSL と `#lang racket` の使い分け | [appendix-e-lang-policy.md](books/racket-turtle-fractals/appendix-e-lang-policy.md) |
| F | Racket Plot の基礎と Headless 画像生成 | [appendix-f-plot.md](books/racket-turtle-fractals/appendix-f-plot.md) |

## 言語方針 A

| 段階 | 言語 | 用途 |
|------|------|------|
| 序盤（〜第1章） | `#lang htdp/bsl` | 式・関数・テスト |
| 本編（第2章〜） | `#lang racket` + `teachpacks/racket-turtle` | タートル描画 |
| 詳細 | 付録 E | |

## フォルダ構成

```text
mypublish-racket-turtle/
├── books/racket-turtle-fractals/   # Zenn book 正本（config.yaml + 章 md）
├── code/                           # お手本 .rkt
├── drafts/                         # 下書き
├── manuscript/                     # combine 後の book.md
├── scripts/racket-turtle-fractals/ # combine / epub / verify
├── assets/epub/                    # EPUB CSS
├── output/                         # 生成物
├── notes/                          # メモ・SE レポート
├── mise.toml                       # タスクランナー
├── package.json                    # zenn-cli
├── LICENSE                         # MIT
└── README.md                       # 本ファイル（目次正本のひとつ）
```

`mypublish-gameoflife` を大幅に参照しています。

## 開発フロー（Zenn → EPUB）

```text
books/racket-turtle-fractals/*.md
        ↓  mise run zenn:preview  （章単位で Zenn 確認）
        ↓  公開・フィードバック
        ↓  mise run book:combine / book:epub
manuscript/ + output/*.epub
        ↓  Kindle 等
```

## セットアップ

```bash
cd ~/my-project/mypublish-racket-turtle
mise trust && mise install
npm install
# Racket 本体は OS / 公式インストーラで導入
# タートル本編: raco pkg install teachpacks
```

## よく使うタスク

| タスク | 内容 |
|--------|------|
| `mise run zenn:preview` | Zenn CLI プレビュー（localhost:8000） |
| `mise run zenn:preview-port` | ポート指定プレビュー |
| `mise run test:racket` | `code/*.rkt` を実行 |
| `mise run ci:test` | ローカル CI ゲート |
| `mise run watch:test` | 変更監視テスト |
| `mise run book:combine` | 章を `manuscript/.../book.md` に結合 |
| `mise run book:epub` | 横書き EPUB + verify |
| `mise run book:epub-vertical` | 縦書き EPUB + verify |
| `mise run wt:setup` 等 | worktree 実験（gameoflife と同型） |

## 移行元・関連

- 旧目次ドラフト: `draft-publish-books-2026` の `self-similar-graphics.md`（#15 で本リポジトリへ移行）
- タートル調査: [my-grok-task-2026#40](https://github.com/bluehive/my-grok-task-2026/issues/40)
- 姉妹編: [mypublish-gameoflife](https://github.com/bluehive/mypublish-gameoflife)

---

*初期コミット: 2026-07-25 / draft-publish-books-2026#15*
