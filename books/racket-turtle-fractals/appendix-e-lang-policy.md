---
title: "付録E　BSL と #lang racket の使い分け（方針 A）"
---

> **この付録のゴール**  
> なぜ序盤だけ BSL で、タートル本編を `#lang racket` にするかを一文で説明できるようにする。

#### E.1 方針 A の要約

| 段階 | 言語 | 理由 |
|------|------|------|
| 基礎 | `#lang htdp/bsl` | 構文を絞り、`check-expect` とデザインレシピで論理を先に学ぶ |
| 描画本編 | `#lang racket` + `teachpacks/racket-turtle` | 公式 turtle teachpack の API・リスト・再帰例をそのまま使える |
| 発展（任意） | ISL+ / `2htdp/image` / `big-bang` | アニメーションや別スタイルの図形構築 |

#### E.2 BSL だけで押し切れない点（検討メモ）

- BSL はリスト操作・高階・一部構文が制限される  
- `racket-turtle` は `(require teachpacks/racket-turtle)` 前提で、公式例は Racket 系  
- 姉妹編ライフゲームも「本線 BSL、描画発展は別系統」と分離している  

#### E.3 読者への案内文（本文転用可）

> 第1章までは Beginning Student で式と関数に慣れます。第2章から亀を動かすときは、ファイル先頭を `#lang racket` に切り替え、teachpack を入れます。考え方（例を先に、再帰の型紙）は共通です。

> 三角ロジックで整理予定
