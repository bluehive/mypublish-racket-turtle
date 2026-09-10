# 縮小・言語方針メモ（改訂 2026-09-10）

## ユーザー方針（最新）
- **第2章**: **BSL ベース**で説明（`#lang htdp/bsl` + `teachpacks/racket-turtle`）
- **第3章**: **ISL+ ベース**。**再帰ではなくループ**で複雑な図形をタートル描画
- **終章**: 薄い
- フラクタル本線・Processing・Plot は **今版外**
- タイトル: 『Racket タートルグラフィックス入門』（維持可）

## 実測（Grok）
- `#lang htdp/bsl` / `htdp/isl+` いずれも `(require teachpacks/racket-turtle)` と `CommandList` 定義は成功
- ISL+ に `for` / `for/list` は **無い**
- 本章でいう「ループ」の実装候補: タートルの **`repeat`**、および ISL+ の **`build-list` / `map` / `foldr`（+ `lambda`）**
- `map`/`build-list` でコマンドのリストを返すと **二重リスト**になりやすい → `foldr append empty` 等で平坦化する型紙が必要（Antigravity 指摘は妥当）

## 相談
### Antigravity
- 目次: 序章 / 第1章 BSL / 第2章 BSL+turtle / 第3章 ISL+ ループ図形 / 薄い終章
- 旧 ch03 再帰・ch04 フラクタルは本編外、退避または残置
- タイトル本体はそのまま、副題からフラクタル・再帰を外す
- ※提案中の `#lang htdp/isl-plus` は誤り → 正は **`#lang htdp/isl+`**
- ※「データ駆動」を序章の柱に戻す提案は、turtle 本編での手続き型寄り方針と衝突しうるため **採用しない**（用語は CommandList / 命令リストで足りる）

### Hermes
- （短評待ち／後追い追記可。方針自体はユーザー指定で確定）

### Grok 採用案
| 章 | `#lang` | 内容 |
|----|---------|------|
| 序章 | — | なぜ Racket／BSL→ISL+ の見取り図。フラクタル本線は置かない |
| 第1章 | `htdp/bsl` | 式・関数・`check-expect`・条件・リストのさわり |
| 第2章 | `htdp/bsl` + turtle | 基本コマンド・多角形・色。**今版の BSL タートル到達点** |
| 第3章 | `htdp/isl+` + turtle | `repeat` / `build-list`・`map`・平坦化で複雑な図形。**再帰は扱わない** |
| 終章 | — | 薄い振り返りと次の一歩（再帰・フラクタルは次巻候補と一言） |
| 付録 | A–E | F（Plot）は今版外 |

旧原稿 `ch03-recursion.md` / `ch04-fractals.md` / `appendix-f-plot.md` は **ファイル残置・出版 TOC 外**（第3章は後続でループ版に書き直し）。

## 本 PR の範囲
- 計画メモ・README・`config.yaml`・`plan.md`・言語方針付録 E の要約更新
- 序章の言語表を BSL / ISL+ 構成に合わせる
- **第2–3章本文の全面リライトは後続 PR**（ここでは目次・方針の確定）

## 後続 PR
- [ ] `code/ch02-turtle.rkt` を `#lang htdp/bsl` 化＋本文整合
- [ ] 新第3章（ループ）本文＋`code/ch03-loops.rkt`（`#lang htdp/isl+`）
- [ ] 旧再帰第3章のファイル名整理（`drafts/` 等）
- [ ] 終章を薄く刈る
- [ ] 付録 E・B の言語説明更新
--- Hermes ---
ch2 BSL+turtle: 否
ch3 ISL+build-list/map/repeat・再帰なし: 否
終章薄い: 是
