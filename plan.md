# plan.md — Racket タートルグラフィックス入門

## ステータス（2026-09-10・改訂）

| 項目 | 状態 |
|------|------|
| タイトル | 『Racket タートルグラフィックス入門』 |
| 第1章 | `#lang htdp/bsl` |
| 第2章 | `#lang htdp/bsl` + `teachpacks/racket-turtle` |
| 第3章 | `#lang htdp/isl+` + turtle。**再帰ではなくループ**（`repeat` / `build-list` / `map`） |
| 終章 | 薄い |
| 今版外 | フラクタル本線・Plot・Processing・明示的再帰 |
| 詳細メモ | [scope-reduction-turtle-only-2026-09-10.md](notes/racket-turtle-fractals/scope-reduction-turtle-only-2026-09-10.md) |

## 次の執筆タスク

1. 第2章コード／本文を BSL + turtle に寄せる
2. 第3章をループ版に書き直し（旧再帰原稿は drafts へ）
3. 終章を薄く刈る
4. 序章・付録 B/E の言語表を BSL→ISL+ に更新
5. 未収録（フラクタル・Plot）の退避判断

## 言語方針（今版）

| 段階 | 言語 | 用途 |
|------|------|------|
| 第1章 | `htdp/bsl` | 式・関数・テスト |
| 第2章 | `htdp/bsl` + turtle | 基本図形 |
| 第3章 | `htdp/isl+` + turtle | 繰り返しで複雑な図形 |
