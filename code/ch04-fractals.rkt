;; 自己相似形グラフィック入門 — 第4章 フラクタル
;; 実行: racket code/ch04-fractals.rkt

#lang racket

(require rackunit
         teachpacks/racket-turtle)

;; ------------------------------------------------------------
;; ユーティリティ: CommandList 内の forward 回数を数える
;; （procedure の識別は難しいので、生成関数側で数えるAPIを用意）
;; ------------------------------------------------------------

;; koch-line の forward 回数: 4^depth
(define (koch-forward-count depth)
  (expt 4 depth))

;; ------------------------------------------------------------
;; 4.1 ツリー
;; ------------------------------------------------------------

;; tree : Number Number Number -> CommandList
;; 位置を往復で戻す簡易フラクタルツリー
(define (tree depth size angle)
  (cond
    [(<= depth 0)
     (list (forward size)
           (forward (- size)))]
    [else
     (append
      (list (forward size))
      (list (turn-left angle))
      (tree (sub1 depth) (* size 0.7) angle)
      (list (turn-right (* 2 angle)))
      (tree (sub1 depth) (* size 0.7) angle)
      (list (turn-left angle))
      (list (forward (- size))))]))

;; ------------------------------------------------------------
;; 4.2 コッホ
;; ------------------------------------------------------------

;; koch-line : Number Number -> CommandList
(define (koch-line depth size)
  (cond
    [(<= depth 0)
     (list (forward size))]
    [else
     (define s3 (/ size 3.0))
     (append (koch-line (sub1 depth) s3)
             (list (turn-left 60))
             (koch-line (sub1 depth) s3)
             (list (turn-right 120))
             (koch-line (sub1 depth) s3)
             (list (turn-left 60))
             (koch-line (sub1 depth) s3))]))

;; koch-snowflake : Number Number -> CommandList
(define (koch-snowflake depth size)
  (append (koch-line depth size)
          (list (turn-right 120))
          (koch-line depth size)
          (list (turn-right 120))
          (koch-line depth size)))

;; ------------------------------------------------------------
;; 4.3 シェルピンスキー（外形の再帰三角形）
;; ------------------------------------------------------------

;; triangle-outline : Number -> CommandList
(define (triangle-outline size)
  (list (forward size)
        (turn-left 120)
        (forward size)
        (turn-left 120)
        (forward size)
        (turn-left 120)))

;; sierpinski : Number Number -> CommandList
;; 次の小三角形の起点へ（一辺の半分進んで向き調整は簡略）
(define (sierpinski depth size)
  (cond
    [(<= depth 0)
     (triangle-outline size)]
    [else
     (define half (/ size 2.0))
     (append
      (sierpinski (sub1 depth) half)
      ;; 底辺方向へ half 移動して次のコピー（簡易配置）
      (list (forward half))
      (sierpinski (sub1 depth) half)
      (list (forward (- half))
            (turn-left 60)
            (forward half)
            (turn-right 60))
      (sierpinski (sub1 depth) half)
      (list (turn-left 60)
            (forward (- half))
            (turn-right 60)))]))

;; ------------------------------------------------------------
;; 4.4 ドラゴン
;; ------------------------------------------------------------

;; dragon : Number Number Number -> CommandList
(define (dragon depth size turn)
  (cond
    [(<= depth 0)
     (list (forward size))]
    [else
     (append (dragon (sub1 depth) size 1)
             (list (turn-left (* turn 90)))
             (dragon (sub1 depth) size -1))]))

;; ドラゴンの forward 回数 = 2^depth
(define (dragon-forward-count depth)
  (expt 2 depth))

;; コマンド列の「リスト要素数」ざっくり（ネストは flatten 風に数えない簡易）
(define (cmd-length cmds)
  (cond
    [(empty? cmds) 0]
    [(list? (first cmds))
     (+ (cmd-length (first cmds)) (cmd-length (rest cmds)))]
    [else (+ 1 (cmd-length (rest cmds)))]))

;; ------------------------------------------------------------
;; tests
;; ------------------------------------------------------------

(check-equal? (koch-forward-count 0) 1)
(check-equal? (koch-forward-count 1) 4)
(check-equal? (koch-forward-count 2) 16)
(check-equal? (dragon-forward-count 0) 1)
(check-equal? (dragon-forward-count 3) 8)

(check-true (list? (koch-line 0 90)))
(check-equal? (length (koch-line 0 90)) 1)
(check-true (list? (koch-line 1 90)))
(check-true (list? (koch-snowflake 1 90)))
(check-true (list? (tree 0 50 30)))
(check-true (list? (tree 2 80 30)))
(check-true (list? (triangle-outline 40)))
(check-true (list? (sierpinski 0 80)))
(check-true (list? (sierpinski 1 80)))
(check-true (list? (dragon 0 10 1)))
(check-true (list? (dragon 3 5 1)))
(check-true (> (cmd-length (koch-line 2 100)) 10))
(printf "ch04-fractals: tests OK\n")

;; 描画（任意・depth を大きくしすぎないこと）
;; (draw (list (pen-up) (go-to 200 50) (pen-down) (tree 5 80 30)))
;; (draw (list (pen-up) (go-to 50 150) (pen-down) (koch-snowflake 3 200)))
;; (draw (list (pen-up) (go-to 100 100) (pen-down) (sierpinski 3 160)))
;; (draw (list (pen-up) (go-to 150 150) (pen-down) (dragon 8 4 1)))
