---
title: "付録B　環境構築（Windows 11 と DrRacket）"
---

> **この付録のゴール**  
> 高校生でも、自分の PC で Beginning Student（BSL）を動かせるようにする。  
> **参照**: [howtocode installation](https://howtocode.pages.dev/installation) / [Racket ダウンロード](https://download.racket-lang.org/)  
> **Issue**: [#環境](https://github.com/bluehive/mypublish-racket-turtle/issues/3)

#### B.1 何を入れるか

本のサンプルは次を前提にします。

- **Racket**（DrRacket 付き）  
- 言語レベル: **Beginning Student**（またはファイル先頭 `#lang htdp/bsl`）  

コマンドラインで `racket` が使えれば、付属の `check-expect` もターミナルから実行できます。

#### B.2 Windows 11 でのインストール（手順）

1. ブラウザで https://download.racket-lang.org/ を開く  
2. Windows 用インストーラを選び、ダウンロードする  
3. ダウンロードした `.exe` を実行し、画面の指示に従ってインストールする  
   - 可能なら「PATH に追加する」類の選択肢があれば有効にする  
4. スタートメニューから **DrRacket** を起動する  

インストール後、PowerShell やコマンドプロンプトで次を試し、バージョンが出れば成功です。

```text
racket --version
```

#### B.3 DrRacket の推奨設定

howtocode の installation に合わせた設定です。

1. **行番号を出す**  
   `Edit` → `Preferences` → `Editing` → `General Editing` → **Show line numbers**
2. **（任意）横並びレイアウト**  
   `View` → `Use Horizontal Layout`  
   定義ウィンドウと相互作用ウィンドウが左右に並び、余白が使いやすいことがあります。
3. **言語レベル**  
   ウィンドウ左下（または `Language` メニュー）で **Beginning Student** を選ぶ  
   本リポジトリの `.rkt` は先頭に次を書いてあるので、ファイルを開けば同じ系統になります。

```racket
#lang htdp/bsl
```

4. **（任意）自動括弧**  
   Preferences の Editing で automatic parentheses を有効にできる。便利だが、括弧の対応に慣れるまではオフでもよい。

5. **（任意）補完**  
   `File` → `Package Manager` から `drcomplete` などを入れられる（必須ではない）。

#### B.4 最初の動作確認

1. DrRacket で新しいファイルを作る  
2. 次を貼る  

```racket
#lang htdp/bsl
(+ 1 2)
```

3. **Run** を押す  
4. 相互作用ウィンドウに `3` が出れば成功  

本の付属コードなら、リポジトリをクローンまたは展開したあと:

```text
cd （リポジトリのフォルダ）
racket code/ch01-basics.rkt
```

`All … tests passed!` と出れば環境は十分です。

#### B.5 つまずきやすい点

- **言語レベルが違う**  
  Advanced や `#lang racket` のままだと、本の説明（0引数関数禁止、`map` が無い等）と動きがずれる。必ず BSL / `#lang htdp/bsl` を確認する。  
- **`racket` がコマンドに無い**  
  インストール時に PATH が通っていない。DrRacket からは Run できることが多い。PATH は Racket のインストール先の `bin` を通す。  
- **日本語パス**  
  まれにツールが困るので、学習用フォルダは英数字のパスが無難。  

#### B.6 関連リンク

- Racket 本体: https://download.racket-lang.org/  
- Beginning Student 言語: https://docs.racket-lang.org/htdp-langs/beginner.html  
- howtocode インストール: https://howtocode.pages.dev/installation  
- 本編の序章 0.3、README のセットアップ節  

Windows 以外（macOS / Linux）でも、同じダウンロードページから OS 用を入れ、言語レベルを Beginning Student にすれば同様です。

#### B.6 teachpacks（racket-turtle）の導入

第2章以降の本線描画は `teachpacks/racket-turtle` を使います（言語方針 A: 本編は `#lang racket`）。

```text
raco pkg install teachpacks
```

確認用の最小例（第2章で詳述）:

```racket
#lang racket
(require teachpacks/racket-turtle)

(define square1
  (list
   (forward 100)
   (right 90)
   (forward 100)
   (right 90)
   (forward 100)
   (right 90)
   (forward 100)))

(draw square1)
```

公式: [Racket Turtle](https://docs.racket-lang.org/racket_turtle/index.html)

> 三角ロジックで整理予定
