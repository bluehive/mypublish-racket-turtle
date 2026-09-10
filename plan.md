# plan.md — Racket タートルグラフィックス入門

## ステータス（2026-09-10・縮小方針）

| 項目 | 状態 |
|------|------|
| 今版スコープ | **タートルライブラリまで**（序章・第1・第2・終章＋付録 A–E） |
| タイトル | 『Racket タートルグラフィックス入門』 |
| 外す（今版） | 第3章再帰・第4章フラクタル・付録 F Plot、Processing 出版 |
| 詳細メモ | [notes/.../scope-reduction-turtle-only-2026-09-10.md](notes/racket-turtle-fractals/scope-reduction-turtle-only-2026-09-10.md) |
| Zenn | `config.yaml` の chapters を今版構成に合わせる |
| EPUB | スクリプト移植済・要 pandoc（章セット変更後に再確認） |

## 次の執筆タスク

1. 序章のフラクタル本線を「図形描画入門」へリライト
2. 終章をタートル振り返り中心へ短縮
3. 第1章・付録 C の前方参照（第3–4章）整理
4. 未収録ファイルの退避／削除判断
5. ディレクトリ名 `racket-turtle-fractals` の改名検討

## 言語方針

**A**: 序盤 BSL / 本編 `#lang racket` + `teachpacks/racket-turtle`（付録 E）  
今版に Plot（付録 F）は含めない。

## 参照

- 縮小メモ: `notes/racket-turtle-fractals/scope-reduction-turtle-only-2026-09-10.md`
- https://github.com/bluehive/draft-publish-books-2026/issues/15
