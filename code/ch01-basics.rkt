;; 自己相似形グラフィック入門 — 第1章 基礎
;; 実行: racket code/ch01-basics.rkt

#lang htdp/bsl

(require test-engine/racket-tests)

;; --- 定数 ---
(define WIDTH 30)
(define HEIGHT 20)
(define CELL-SIZE 15)
(define BOARD-PIXEL-WIDTH (* WIDTH CELL-SIZE))

;; --- 条件（フラクタル継続の模写） ---
(define (draw-more? depth)
  (> depth 0))

(define (branch-ok? length min-len)
  (>= length min-len))

(define (continue-fractal? depth length min-len)
  (if (draw-more? depth)
      (branch-ok? length min-len)
      false))

;; --- 関数 ---
(define (square-of x)
  (* x x))

(define (greet name)
  (string-append "Hello, " name "!"))

;; --- 構造体（教育用） ---
(define-struct turtle-state (x y heading))
(define T1 (make-turtle-state 0 0 90))
(define T2 (make-turtle-state 100 50 0))

(define SAMPLE-CELL (make-posn 3 2))

;; --- リスト ---
(define SQUARE-STEPS
  (list 100 90 100 90 100 90 100 90))

(define (my-length xs)
  (cond
    [(empty? xs) 0]
    [else (+ 1 (my-length (rest xs)))]))

(define (contains? xs x)
  (cond
    [(empty? xs) false]
    [(equal? (first xs) x) true]
    [else (contains? (rest xs) x)]))

;; --- 座標 ---
(define (shift-posn p dx dy)
  (make-posn (+ (posn-x p) dx)
             (+ (posn-y p) dy)))

(define (cardinal-points origin step)
  (list (shift-posn origin step 0)
        (shift-posn origin 0 step)
        (shift-posn origin (- step) 0)
        (shift-posn origin 0 (- step))))

;; --- tests ---
(check-expect BOARD-PIXEL-WIDTH 450)
(check-expect (draw-more? 2) true)
(check-expect (draw-more? 0) false)
(check-expect (branch-ok? 50 10) true)
(check-expect (continue-fractal? 2 50 10) true)
(check-expect (continue-fractal? 0 50 10) false)
(check-expect (square-of 8) 64)
(check-expect (greet "Racket") "Hello, Racket!")
(check-expect (turtle-state-x T1) 0)
(check-expect (turtle-state-heading T1) 90)
(check-expect (posn-x SAMPLE-CELL) 3)
(check-expect (my-length SQUARE-STEPS) 8)
(check-expect (contains? SQUARE-STEPS 90) true)
(check-expect (contains? SQUARE-STEPS 45) false)
(check-expect (my-length (cardinal-points (make-posn 0 0) 10)) 4)

(test)
