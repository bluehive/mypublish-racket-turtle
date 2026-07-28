;; 自己相似形グラフィック入門 — 終章: Racket Plot による対数螺旋プロット
;; 実行: racket code/ch05-plot-spiral.rkt

#lang racket

(require plot
         rackunit)

;; ------------------------------------------------------------
;; 対数螺旋（Logarithmic Spiral）の極座標関数
;; r(theta) = a * e^(b * theta)
;; ------------------------------------------------------------

(define (log-spiral-r theta [a 1.0] [b 0.15])
  (* a (exp (* b theta))))

;; ------------------------------------------------------------
;; テスト
;; ------------------------------------------------------------

(check-equal? (log-spiral-r 0.0) 1.0)
(check-true (> (log-spiral-r 2.0) (log-spiral-r 1.0)))

;; ------------------------------------------------------------
;; プロット呼び出し例 (DrRacket で実行)
;; ------------------------------------------------------------
;; (plot (polar (lambda (t) (log-spiral-r t 1.0 0.15)) 0 (* 4 pi))
;;       #:title "Logarithmic Spiral")

(displayln "ch05-plot-spiral.rkt: All tests passed!")
