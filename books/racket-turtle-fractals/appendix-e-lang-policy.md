---
title: "付録E　BSL と ISL+ の使い分け（方針 A・今版）"
---

> **この付録のゴール**  
> なぜ第1–2章は BSL、第3章は ISL+ なのかを一文で説明できるようにする。

#### E.1 方針 A（今版）の要約

| 段階 | 言語 | 理由 |
|------|------|------|
| 第1章 | `#lang htdp/bsl` | 構文を絞り、`check-expect` で論理を先に学ぶ |
| 第2章 | `#lang htdp/bsl` + `teachpacks/racket-turtle` | 同じ BSL のままカメの基本図形へ進む（teachpack 利用可を確認済み） |
| 第3章 | `#lang htdp/isl+` + turtle | `lambda`・`build-list`・`map`・`foldr` で命令列をまとめて作り、複雑な図形へ。**明示的再帰は今版では扱わない** |

#### E.2 「ループ」とは（今版の定義）

ISL+ に `for` はありません。本書の「ループ」は次を指します。

- タートルの `(repeat k cmd-list)`
- `(build-list n f)` / `map` などで命令をたくさん作り、必要なら `foldr append empty` で **平坦な CommandList** にする

再帰（関数が自分を呼ぶ）は次巻候補です。

#### E.3 今版に含めないもの

- フラクタル本線、Racket Plot、Processing 出版
- 第2章コードの BSL 化・第3章ループ本文は後続 PR

#### E.4 読者への案内文（本文転用可）

> 第1章と第2章は Beginning Student（BSL）です。第3章だけ Intermediate Student with lambda（ISL+）に切り替え、繰り返しの仕組みで模様を増やします。
