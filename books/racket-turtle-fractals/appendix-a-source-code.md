---
title: "付録A　完全ソース一覧"
---

> **この付録のゴール**  
> 章ごとの付属 `.rkt` と GitHub 上の場所を一覧する。

| 章 | ファイル | 言語 | 状態 |
|----|----------|------|------|
| 第1章 | [`code/ch01-basics.rkt`](../../code/ch01-basics.rkt) | `#lang htdp/bsl` | 初版・テスト済 |
| 第2章 | [`code/ch02-turtle.rkt`](../../code/ch02-turtle.rkt) | `#lang racket` + racket-turtle | ドラフト・構造テスト |
| 第3章 | [`code/ch03-recursion.rkt`](../../code/ch03-recursion.rkt) | 同上 | ドラフト・テスト済 |
| 第4章 | [`code/ch04-fractals.rkt`](../../code/ch04-fractals.rkt) | 同上 | ドラフト・テスト済 |

リポジトリ: https://github.com/bluehive/mypublish-racket-turtle

```bash
mise run test:racket
# または
racket code/ch01-basics.rkt
racket code/ch02-turtle.rkt
racket code/ch03-recursion.rkt
racket code/ch04-fractals.rkt
```

描画は各ファイル末尾の `(draw …)` コメントを外すか、DrRacket で評価する。

前提パッケージ:

```bash
raco pkg install teachpacks
```
