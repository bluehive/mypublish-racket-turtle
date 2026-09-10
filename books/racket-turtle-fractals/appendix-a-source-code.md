---
title: "付録A　完全ソース一覧"
---

> **この付録のゴール**  
> 章ごとの付属 `.rkt` と GitHub 上の場所を一覧する。今版の本線は第1–3章（第3章は ISL+ ループ）。

| 章 | ファイル | 言語 | 状態 |
|----|----------|------|------|
| 第1章 | [`code/ch01-basics.rkt`](https://github.com/bluehive/mypublish-racket-turtle/blob/main/code/ch01-basics.rkt) | `#lang htdp/bsl` | 初版・テスト済 |
| 第2章 | [`code/ch02-turtle.rkt`](https://github.com/bluehive/mypublish-racket-turtle/blob/main/code/ch02-turtle.rkt) | `#lang htdp/bsl` + racket-turtle | お手本（描画は DrRacket） |
| 第3章 | [`code/ch03-loops.rkt`](https://github.com/bluehive/mypublish-racket-turtle/blob/main/code/ch03-loops.rkt) | `#lang htdp/isl+` + turtle（ループ） | お手本（描画は DrRacket） |
| 第4章（参考残置） | [`code/ch04-fractals.rkt`](https://github.com/bluehive/mypublish-racket-turtle/blob/main/code/ch04-fractals.rkt) | 旧 `#lang racket` + turtle | ドラフト・残置 |

リポジトリ: https://github.com/bluehive/mypublish-racket-turtle

```bash
# 今版の本線（手元）
racket code/ch01-basics.rkt
# 第2章は DrRacket で開いて (draw …) を試す
# racket code/ch02-turtle.rkt

# 参考残置
racket code/ch03-loops.rkt
racket code/ch04-fractals.rkt
```

描画は各ファイル末尾の `(draw …)` コメントを外すか、DrRacket で評価する。

前提パッケージ:

```bash
raco pkg install teachpacks
```
