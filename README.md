# mypublish-racket-turtle

**『Racket タートルグラフィックス入門』**（副題: 式・関数・カメで図形を描く）の執筆リポジトリ。今版は **BSL タートル → ISL+ ループ図形** まで。明示的再帰・フラクタル・Plot・Processing は収録しない。

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

> **今版の範囲**: 序章 → 第1章（BSL）→ 第2章（BSL + turtle）→ 第3章（ISL+・ループで複雑図形）→ 薄い終章 ＋ 付録 A–E。  
> **今版外**: 明示的再帰・フラクタル本線・Plot・Processing。  
> 詳細: [縮小メモ](notes/racket-turtle-fractals/scope-reduction-turtle-only-2026-09-10.md)

### 序章　なぜ Racket で描くか

- 原稿: [intro.md](books/racket-turtle-fractals/intro.md)
- 0.1 プログラムで図形を描く楽しさ
- 0.2 なぜ Racket か
- 0.3 DrRacket と BSL／ISL+ の見取り図
- 0.4 本書の進め方

### 第1章　Racket の基礎——式と関数（BSL）

- 原稿: [ch01-basics.md](books/racket-turtle-fractals/ch01-basics.md)
- コード: [ch01-basics.rkt](code/ch01-basics.rkt)（`#lang htdp/bsl`）
- 1.1 式・評価・基本データ
- 1.2 定数と関数、`check-expect`
- 1.3 条件分岐
- 1.4 リストのさわり

### 第2章　タートル基礎（BSL + `racket-turtle`）

- 原稿: [ch02-turtle.md](books/racket-turtle-fractals/ch02-turtle.md)
- コード: [ch02-turtle.rkt](code/ch02-turtle.rkt) → **後続 PR で `#lang htdp/bsl` 化**
- 2.1 基本コマンドと命令リスト
- 2.2 正方形・多角形
- 2.3 色・ペン・スタンプ
- 2.4 関数で図形を再利用

### 第3章　ループで複雑な図形（ISL+ + turtle）

- 原稿: 現状ファイル名は [ch03-recursion.md](books/racket-turtle-fractals/ch03-recursion.md)（**内容は後続 PR でループ版へ全面書換**。旧・再帰稿は drafts へ）
- コード: 新 `code/ch03-*.rkt`（`#lang htdp/isl+`）を後続で追加
- 3.1 タートルの `repeat`
- 3.2 `build-list` / `map` で命令列をまとめて作る
- 3.3 リストの平坦化（二重リストに注意）と幾何模様
- ※ ISL+ に `for` は無い。本章の「ループ」＝ `repeat` と高階関数による反復生成

### 終章　振り返り（薄い）

- 原稿: [closing.md](books/racket-turtle-fractals/closing.md)
- 短くまとめる（後続で刈り込み）

### 未収録（リポジトリ残置）

| 内容 | 原稿 | 備考 |
|------|------|------|
| 旧・再帰第3章 | （書換前の ch03） | drafts 予定 |
| 第4章 フラクタル | [ch04-fractals.md](books/racket-turtle-fractals/ch04-fractals.md) | 今版外 |
| 付録 F Plot | [appendix-f-plot.md](books/racket-turtle-fractals/appendix-f-plot.md) | 今版外 |

### 学習の目安

| 段階 | 章 | 言語 |
|------|-----|------|
| 準備 | 序章・第1章 | BSL |
| 本編① | 第2章 | BSL + turtle |
| 本編② | 第3章 | ISL+ + turtle（ループ） |
| まとめ | 終章 | — |

## 付録

| 付録 | 内容 | 原稿 |
|------|------|------|
| A | 完全ソース一覧 | [appendix-a-source-code.md](books/racket-turtle-fractals/appendix-a-source-code.md) |
| B | 環境構築 | [appendix-b-environment.md](books/racket-turtle-fractals/appendix-b-environment.md) |
| C | 復習と例題集 | [appendix-c-exercises.md](books/racket-turtle-fractals/appendix-c-exercises.md) |
| D | 参考文献 | [appendix-d-references.md](books/racket-turtle-fractals/appendix-d-references.md) |
| E | BSL / ISL+ / turtle の使い分け | [appendix-e-lang-policy.md](books/racket-turtle-fractals/appendix-e-lang-policy.md) |

## 言語方針 A（今版）

| 段階 | 言語 | 用途 |
|------|------|------|
| 第1章 | `#lang htdp/bsl` | 式・関数・テスト |
| 第2章 | `#lang htdp/bsl` + `teachpacks/racket-turtle` | 基本タートル図形 |
| 第3章 | `#lang htdp/isl+` + `teachpacks/racket-turtle` | ループ（`repeat` / `build-list` / `map`）で複雑図形 |
| 詳細 | 付録 E | |

今版に Plot／Processing／明示的再帰／フラクタル本線は含めない。

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
