;; 自己相似形グラフィック入門 — 第3章 再帰
;; 実行: racket code/ch03-recursion.rkt

#lang racket

(require rackunit
         teachpacks/racket-turtle)

;; ------------------------------------------------------------
;; パターン A: リスト構造再帰
;; ------------------------------------------------------------

;; list-sum: (listof number) -> number
(define (list-sum lon)
  (cond
    [(empty? lon) 0]
    [else (+ (first lon) (list-sum (rest lon)))]))

;; my-length
(define (my-length xs)
  (cond
    [(empty? xs) 0]
    [else (+ 1 (my-length (rest xs)))]))

;; ------------------------------------------------------------
;; パターン B: 自然数（深さ）再帰
;; ------------------------------------------------------------

(define (factorial n)
  (cond
    [(zero? n) 1]
    [else (* n (factorial (sub1 n)))]))

;; depth-forwards: 深さ d だけ forward 1 を並べる（教材用）
(define (depth-forwards d)
  (cond
    [(<= d 0) empty]
    [else (cons (forward 1) (depth-forwards (sub1 d)))]))

;; ------------------------------------------------------------
;; タートル: 螺旋（公式 5.1 系）
;; ------------------------------------------------------------

(define (spiral a x times)
  (if (<= times 0)
      empty
      (append (list (forward x) (turn-left a))
              (spiral a (+ x 2) (sub1 times)))))

(define (side-step x w a)
  (list (change-pen-size w)
        (forward x)
        (turn-left a)))

(define (spiral2 x w a times)
  (if (<= times 0)
      empty
      (cons (side-step x w a)
            (spiral2 (+ x 5) (+ w 1) a (sub1 times)))))

;; poly-rec: regular-polygon を再帰で（repeat 不使用）
(define (poly-rec len n remaining exterior)
  (cond
    [(<= remaining 0) empty]
    [else (append (list (forward len) (turn-left exterior))
                  (poly-rec len n (sub1 remaining) exterior))]))

(define (regular-polygon-rec len n)
  (poly-rec len n n (/ 360.0 n)))

;; 螺旋の forward 回数 = times 回
;; 実装は times から 1 まで（<= times 0 で停止）なので、times 回 forward する
(define (spiral-forward-count times)
  (if (<= times 0) 0 times))

;; ------------------------------------------------------------
;; tests
;; ------------------------------------------------------------

(check-equal? (list-sum empty) 0)
(check-equal? (list-sum (list 1 2 3)) 6)
(check-equal? (my-length (list 'a 'b)) 2)
(check-equal? (factorial 0) 1)
(check-equal? (factorial 5) 120)
(check-equal? (length (depth-forwards 0)) 0)
(check-equal? (length (depth-forwards 4)) 4)
(check-equal? (spiral-forward-count -1) 0)
(check-equal? (spiral-forward-count 0) 0)
(check-equal? (spiral-forward-count 10) 10)
(check-equal? (length (spiral 90 1 2)) 4) ; 2 steps * 2 cmds
(check-true (list? (spiral2 1 1 45 3)))
(check-equal? (length (regular-polygon-rec 10 4)) 8)
(printf "ch03-recursion: tests OK\n")

;; 描画（任意）
;; (draw (list (change-bg-color "black")
;;             (change-color (list "red" "green" "yellow" "purple"))
;;             (spiral 91 1 40)))
