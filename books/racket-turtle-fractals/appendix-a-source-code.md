---
title: "付録A　完全ソース一覧"
---

> **この付録のゴール**  
> 章ごとの付属 `.rkt` と GitHub 上の場所を一覧する。今版の本線は第1–3章（第3章はループ版へ書換予定）。フラクタル・Plot 系は今版外（リポジトリ残置）。

| 章 | ファイル | 言語 | 状態 |
|----|----------|------|------|
| 第1章 | [`code/ch01-basics.rkt`](https://github.com/bluehive/mypublish-racket-turtle/blob/main/code/ch01-basics.rkt) | `#lang htdp/bsl` | 初版・テスト済 |
| 第2章 | [`code/ch02-turtle.rkt`](https://github.com/bluehive/mypublish-racket-turtle/blob/main/code/ch02-turtle.rkt) | `#lang htdp/bsl` + racket-turtle | お手本（描画は DrRacket） |
| 第3章 | [`code/ch03-recursion.rkt`](https://github.com/bluehive/mypublish-racket-turtle/blob/main/code/ch03-recursion.rkt) | 旧稿（再帰）。**ループ版へ書換予定**（`#lang htdp/isl+`） | ドラフト |
| 第4章（今版外） | [`code/ch04-fractals.rkt`](https://github.com/bluehive/mypublish-racket-turtle/blob/main/code/ch04-fractals.rkt) | 旧 `#lang racket` + turtle | ドラフト・残置 |
| 第4章コラム（今版外） | [`code/ch04-recursion-plot.rkt`](https://github.com/bluehive/mypublish-racket-turtle/blob/main/code/ch04-recursion-plot.rkt) | `#lang racket` + plot | 残置 |
| 旧終章 Plot 例（今版外） | [`code/ch05-plot-spiral.rkt`](https://github.com/bluehive/mypublish-racket-turtle/blob/main/code/ch05-plot-spiral.rkt) | `#lang racket` + plot | 残置 |
| 付録 F（今版外） | [`code/appendix-f-headless-plot.rkt`](https://github.com/bluehive/mypublish-racket-turtle/blob/main/code/appendix-f-headless-plot.rkt) | `#lang racket` + plot | 残置 |

リポジトリ: https://github.com/bluehive/mypublish-racket-turtle

```bash
# 今版の本線（手元）
racket code/ch01-basics.rkt
# 第2章は DrRacket で開いて (draw …) を試す
# racket code/ch02-turtle.rkt

# 今版外・旧稿（残置）
racket code/ch03-recursion.rkt
racket code/ch04-fractals.rkt
racket code/ch04-recursion-plot.rkt
racket code/ch05-plot-spiral.rkt
racket code/appendix-f-headless-plot.rkt
```

描画は各ファイル末尾の `(draw …)` コメントを外すか、DrRacket で評価する。

前提パッケージ:

```bash
raco pkg install teachpacks
```
