;; 自己相似形グラフィック入門 — 付録 F: Headless Plot 画像生成
;; 実行: racket code/appendix-f-headless-plot.rkt

#lang racket

(require plot
         rackunit)

;; ------------------------------------------------------------
;; GUIなし（Headless）環境でプロットを PNG ファイルへ直接書き出す関数
;; ------------------------------------------------------------

(define (generate-plot-png output-path)
  (plot-file
   (list (function sin (- pi) pi #:color "blue" #:label "y = sin(x)")
         (function cos (- pi) pi #:color "red" #:label "y = cos(x)"))
   output-path
   'png
   #:title "Trigonometric Functions"
   #:x-label "x"
   #:y-label "y"))

;; ------------------------------------------------------------
;; テスト: 一時ファイルを出力して生成を確認
;; ------------------------------------------------------------

(define tmp-png (build-path "output" "plot-test.png"))

(generate-plot-png tmp-png)

(check-true (file-exists? tmp-png))
(check-true (> (file-size tmp-png) 0))

;; テスト後のお掃除
(when (file-exists? tmp-png)
  (delete-file tmp-png))

(displayln "appendix-f-headless-plot.rkt: All tests passed!")
