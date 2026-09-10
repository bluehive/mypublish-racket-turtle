# 解析: Scratch 比較の本文露出除去（序章は残す）

- **解析・改訂**: 校正github-chan
- **日付**: 2026-09-10
- **方針参照**: bluehive/mypublish-gameoflife#22
- **ユーザー決定**: 序章だけ残し、本編・付録から Scratch 比較を除去
- **ベース**: docs/proofread-racket-turtle-fractals
- **ブランチ**: docs/remove-scratch-bridge-turtle-fractals

## 完了条件
`rg -n 'Scratch|スクラッチ' books/racket-turtle-fractals --glob '!intro.md'` が空。自己マージしない。
