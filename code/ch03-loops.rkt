;; Racket タートルグラフィックス入門 — 第3章 ループで複雑な図形（ISL+）
;; 実行: DrRacket で開くか `racket code/ch03-loops.rkt`
;; 描画: (draw …) のコメントを外す（要: raco pkg install teachpacks）

#lang htdp/isl+

(require teachpacks/racket-turtle)

;; ------------------------------------------------------------
;; 3.1 おさらい: turtle の repeat
;; ------------------------------------------------------------

;; side: Number Number -> CommandList
(define (side len exterior-deg)
  (list (forward len)
        (turn-left exterior-deg)))

;; make-regular-polygon: Number Integer -> CommandList
(define (make-regular-polygon len n)
  (repeat n (side len (/ 360 n))))

;; ------------------------------------------------------------
;; 3.2 build-list で「変化する」命令列をまとめて作る
;; ------------------------------------------------------------

;; 注意: build-list / map が「命令のリスト」を返すと二重リストになる。
;; foldr append empty で平坦な CommandList にする。

;; growing-step: Integer -> CommandList
;; i 回目: 長さ (10 + 5*i) 進んで 90 度左へ
(define (growing-step i)
  (list (forward (+ 10 (* i 5)))
        (turn-left 90)))

;; growing-square-ish: Integer -> CommandList
;; n ステップ分を平坦な命令リストにまとめる
(define (growing-steps n)
  (foldr append empty (build-list n growing-step)))

;; ------------------------------------------------------------
;; 3.3 螺旋（ループ版）— 長さが少しずつ伸びる
;; ------------------------------------------------------------

;; spiral-step: Number Integer -> (Integer -> CommandList)
;; 回転角 a を閉じ込めたステップ関数を返す
(define (make-spiral-step a)
  (lambda (i)
    (list (forward (+ 5 (* i 2)))
          (turn-left a))))

;; spiral-loop: Number Integer -> CommandList
(define (spiral-loop a times)
  (foldr append empty (build-list times (make-spiral-step a))))

;; ------------------------------------------------------------
;; 3.4 色を変えながら多角形を並べる（map + flatten）
;; ------------------------------------------------------------

(define COLORS (list "red" "orange" "gold" "green" "blue" "purple"))

;; colored-poly: String Number Integer -> CommandList
(define (colored-poly color len n)
  (append (list (change-color color))
          (make-regular-polygon len n)))

;; rainbow-polygons: Number Integer -> CommandList
;; 各色で正 n 角形を1つずつ（位置は同じ場所に重なるので、見本は色の切替確認用）
(define (rainbow-polygons len n)
  (foldr append empty
         (map (lambda (c) (colored-poly c len n))
              COLORS)))

;; shift-then: Number Number CommandList -> CommandList
;; ペンを上げてずらしてから図形を描く
(define (shift-then dx dy cmds)
  (append (list (pen-up)
                (forward dx)
                (turn-left 90)
                (forward dy)
                (turn-right 90)
                (pen-down))
          cmds))

;; row-of-squares: Number Integer -> CommandList
;; gap ずつずらして正方形を並べる
(define (row-of-squares size count gap)
  (foldr append empty
         (build-list count
                     (lambda (i)
                       (shift-then (* i gap) 0
                                   (make-regular-polygon size 4))))))

;; ------------------------------------------------------------
;; 描画（任意）— コメントを外して DrRacket で
;; ------------------------------------------------------------
;; (draw (make-regular-polygon 60 6))
;; (draw (growing-steps 8))
;; (draw (spiral-loop 90 30))
;; (draw (list (change-bg-color "black") (spiral-loop 91 40)))
;; (draw (row-of-squares 40 5 50))
