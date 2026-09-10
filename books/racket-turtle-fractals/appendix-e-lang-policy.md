---
title: "付録E　BSL と ISL の使い分け（方針 A・今版）"
---

> **この付録のゴール**  
> なぜ第1–2章は BSL、第3章は ISL なのかを一文で説明できるようにする。

#### E.1 方針 A（今版）の要約

| 段階 | 言語 | 理由 |
|------|------|------|
| 第1章 | `#lang htdp/bsl` | 構文を絞り、`check-expect` で論理を先に学ぶ |
| 第2章 | `#lang htdp/bsl` + `teachpacks/racket-turtle` | 同じ BSL のままカメの基本図形へ進む |
| 第3章 | `#lang htdp/isl` + turtle | `build-list`・`map`・`foldr` で命令列をまとめて作り、複雑な図形へ。**`lambda` は使わず名前付き関数で渡す。明示的再帰は扱わない** |

#### E.2 「ループ」とは（今版の定義）

ISL に `for` はありません。本書の「ループ」は次を指します。

- タートルの `(repeat k cmd-list)`（これは BSL でも可）
- `(build-list n f)` / `map` などで命令をたくさん作り、必要なら `foldr append empty` で **平坦な CommandList** にする（ここから ISL）

`f` は必ず `define` した名前付き関数です（ISL に `lambda` は無い／今版では ISL+ に上げない）。

再帰（関数が自分を呼ぶ）は次巻候補です。

#### E.3 今版に含めないもの

- フラクタル本線、Processing 出版
- 第2章コードは `#lang htdp/bsl`、第3章コードは `#lang htdp/isl`（ループ）

#### E.4 読者への案内文（本文転用可）

> 第1章と第2章は Beginning Student（BSL）です。第3章だけ Intermediate Student（ISL）に切り替え、繰り返しの仕組みで模様を増やします。`lambda` は使いません。
