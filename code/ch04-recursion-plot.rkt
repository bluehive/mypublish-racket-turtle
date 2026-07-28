;; 自己相似形グラフィック入門 — 第4章 フラクタル: 再帰計算量のプロット
;; 実行: racket code/ch04-recursion-plot.rkt

#lang racket

(require plot
         rackunit)

;; ------------------------------------------------------------
;; 再帰深さ d におけるステップ数・頂点数の計算関数
;; ------------------------------------------------------------

;; 二分木（フラクタルツリー）のノード数: 2^d
(define (tree-node-count depth)
  (expt 2 depth))

;; コッホ曲線の線分（ステップ）数: 4^d
(define (koch-step-count depth)
  (expt 4 depth))

;; シェルピンスキーの三角形の小三角形数: 3^d
(define (sierpinski-count depth)
  (expt 3 depth))

;; ------------------------------------------------------------
;; データ系列生成ユーティリティ
;; ------------------------------------------------------------

;; (vector depth count) のリストを作成する（discrete-histogram用）
(define (make-histogram-data count-fn max-depth)
  (for/list ([d (in-range (add1 max-depth))])
    (vector (number->string d) (count-fn d))))

;; ------------------------------------------------------------
;; テスト
;; ------------------------------------------------------------

(check-equal? (tree-node-count 0) 1)
(check-equal? (tree-node-count 3) 8)
(check-equal? (koch-step-count 2) 16)
(check-equal? (sierpinski-count 3) 27)

(check-equal? (make-histogram-data tree-node-count 2)
              (list (vector "0" 1) (vector "1" 2) (vector "2" 4)))

(displayln "ch04-recursion-plot.rkt: All tests passed!")
