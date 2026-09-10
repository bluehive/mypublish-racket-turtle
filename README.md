# mypublish-racket-turtle

**『Racket タートルグラフィックス入門』**（副題: 式・関数・カメで図形を描く）の執筆リポジトリ。今版は **タートルライブラリまで**。再帰・フラクタル・Plot・Processing は収録しない。

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

> **今版の範囲**: 序章 → 第1章 → 第2章（`racket-turtle`）→ 終章 ＋ 付録 A–E。  
> 第3章再帰・第4章フラクタル・付録 F Plot はリポジトリに残すが **今版の出版目次外**（次巻候補）。Processing は今回出版しない。

### 序章　なぜ Racket で描くか

- 原稿: [intro.md](books/racket-turtle-fractals/intro.md)
- 0.1 図形をプログラムで描く楽しさ（旧: 自己相似／フラクタル導入 → 後続でリライト）
- 0.2 なぜ Racket か——構文より論理
- 0.3 DrRacket と BSL／言語レベルの見取り図
- 0.4 本書の進め方

### 第1章　Racket の基礎——式と関数

- 原稿: [ch01-basics.md](books/racket-turtle-fractals/ch01-basics.md)
- コード: [ch01-basics.rkt](code/ch01-basics.rkt)（`#lang htdp/bsl`）
- 1.1 式・評価・基本データ
- 1.2 定数と関数、`check-expect`
- 1.3 条件分岐（`if` / `cond`）
- 1.4 リストのさわり（コマンド列の下準備）

### 第2章　タートルグラフィックス入門（今版のゴール）

- 原稿: [ch02-turtle.md](books/racket-turtle-fractals/ch02-turtle.md)
- コード: [ch02-turtle.rkt](code/ch02-turtle.rkt)（`#lang racket` + racket-turtle）
- 2.0 タートルグラフィックスの歴史
- 2.1 `racket-turtle` の基本操作
- 2.2 正方形・三角形・多角形
- 2.3 色・ペン・スタンプ
- 2.4 関数で図形を再利用

### 終章　振り返りと次の一歩

- 原稿: [closing.md](books/racket-turtle-fractals/closing.md)
- タートルまでの学びの整理、次巻（再帰・フラクタル）や他教材への案内（本文は後続で短縮予定）

### 未収録（リポジトリ残置・次巻候補）

| 章 | 原稿 | 備考 |
|----|------|------|
| 第3章 再帰 | [ch03-recursion.md](books/racket-turtle-fractals/ch03-recursion.md) | 今版 TOC 外 |
| 第4章 フラクタル | [ch04-fractals.md](books/racket-turtle-fractals/ch04-fractals.md) | 今版 TOC 外 |
| 付録 F Plot | [appendix-f-plot.md](books/racket-turtle-fractals/appendix-f-plot.md) | 今版 TOC 外 |

### 学習の目安（短縮版）

| 段階 | 章 |
|------|-----|
| 準備 | 序章・第1章 |
| 本編 | 第2章（タートル） |
| まとめ | 終章 |

## 付録

| 付録 | 内容 | 原稿 |
|------|------|------|
| A | 完全ソース一覧 | [appendix-a-source-code.md](books/racket-turtle-fractals/appendix-a-source-code.md) |
| B | 環境構築（Racket / teachpacks） | [appendix-b-environment.md](books/racket-turtle-fractals/appendix-b-environment.md) |
| C | 復習と例題集 | [appendix-c-exercises.md](books/racket-turtle-fractals/appendix-c-exercises.md) |
| D | 参考文献 | [appendix-d-references.md](books/racket-turtle-fractals/appendix-d-references.md) |
| E | BSL と `#lang racket` の使い分け | [appendix-e-lang-policy.md](books/racket-turtle-fractals/appendix-e-lang-policy.md) |

## 言語方針 A

| 段階 | 言語 | 用途 |
|------|------|------|
| 序盤（〜第1章） | `#lang htdp/bsl` | 式・関数・テスト |
| 本編（第2章） | `#lang racket` + `teachpacks/racket-turtle` | タートル描画（今版の終点） |
| 詳細 | 付録 E | |

今版に Plot／Processing は含めない。

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
