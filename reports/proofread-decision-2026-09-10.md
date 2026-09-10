# 校正採否メモ（racket-turtle-fractals / 2026-09-10）

入力:
- reports/antigravity-proofread-2026-09-10.md
- reports/grok-independent-proofread-2026-09-10.md

## 採用（本PR）
- 付録B: `(right 90)` → `(turn-left 90)`、正方形が閉じるよう4回目の回転を追加
- 付録B: 重複見出し `B.6` → 後段を `B.7`
- 付録B/D/E: 「三角ロジックで整理予定」削除
- 付録E: 「亀」→「カメ」
- 序章: 行番号設定を付録Bと同じ `Editing → General Editing` に統一、「書き保存」→「書いて保存」
- 第3章: 「パターンは次の3つ」→「2つ」
- 第2章: `fancy-polygon` を `append` で平坦な CommandList に
- 第1章: 「90度右」→「左」（後続の turn-left と整合）、「本当/嘘」→「真/偽」、「かっこ」→「括弧」
- 終章: 節番号 `5.x` → `終.x`
- 付録C: 本編に無い「斜辺の式」課題を第1章向けの表現に変更

## 却下
- Antigravity「intro の『のデータことを』」… **現行 origin/main に該当文言なし**（既修正または誤検知）

## 保留（著者判断・別PR）
- Scratch 再帰の難易度説明のトーン（作業ツリー側に既に追記がある旨を独立メモに記載）
- ドラゴン表のサイズ記述 vs 固定 size 実装の注釈強化
- 口語（がっちゃんこ、一発の公式）の全面トーン調整
