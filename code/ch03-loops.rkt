;; Racket タートルグラフィックス入門 — 第3章 ループで複雑な図形（ISL）
;; 実行: DrRacket で開くか `racket code/ch03-loops.rkt`
;; 描画: (draw …) のコメントを外す（要: raco pkg install teachpacks）

#lang htdp/isl

(require teachpacks/racket-turtle)

;; ------------------------------------------------------------
;; 3.2 おさらい: turtle の repeat
;; ------------------------------------------------------------

;; side: Number Number -> CommandList
(define (side len exterior-deg)
  (list (forward len)
        (turn-left exterior-deg)))

;; make-regular-polygon: Number Integer -> CommandList
(define (make-regular-polygon len n)
  (repeat n (side len (/ 360 n))))

;; ------------------------------------------------------------
;; 3.3 build-list で「変化する」命令列をまとめて作る
;; ------------------------------------------------------------
;; 注意: build-list / map が「命令のリスト」を返すと二重リストになる。
;; foldr append empty で平坦な CommandList にする。
;; ISL には lambda が無いので、ステップ関数はすべて define で名前を付ける。

;; growing-step: Integer -> CommandList
;; i 回目: 長さ (10 + 5*i) 進んで 90 度左へ
(define (growing-step i)
  (list (forward (+ 10 (* i 5)))
        (turn-left 90)))

;; growing-steps: Integer -> CommandList
(define (growing-steps n)
  (foldr append empty (build-list n growing-step)))

;; ------------------------------------------------------------
;; 3.4 螺旋（ループ版）— 長さが少しずつ伸びる
;; ------------------------------------------------------------
;; 回転角 a を変えたいときは、角度ごとに名前付きステップを用意する。
;; （ISL+ なら lambda で閉じ込められるが、今版は ISL）

;; spiral-step-90: Integer -> CommandList
(define (spiral-step-90 i)
  (list (forward (+ 5 (* i 2)))
        (turn-left 90)))

;; spiral-step-91: Integer -> CommandList
;; 91 度にすると、少しずつ向きがずれて模様が豊かになる
(define (spiral-step-91 i)
  (list (forward (+ 5 (* i 2)))
        (turn-left 91)))

;; spiral-loop-90: Integer -> CommandList
(define (spiral-loop-90 times)
  (foldr append empty (build-list times spiral-step-90)))

;; spiral-loop-91: Integer -> CommandList
(define (spiral-loop-91 times)
  (foldr append empty (build-list times spiral-step-91)))

;; ------------------------------------------------------------
;; 3.5 色を変えながら／ずらして並べる（map + flatten）
;; ------------------------------------------------------------

(define COLORS (list "red" "orange" "gold" "green" "blue" "purple"))

;; colored-poly: String Number Integer -> CommandList
(define (colored-poly color len n)
  (append (list (change-color color))
          (make-regular-polygon len n)))

;; colored-poly-60-6: String -> CommandList
;; map に渡すため、色以外を固定した1引数関数
(define (colored-poly-60-6 color)
  (colored-poly color 60 6))

;; rainbow-hexagons: -> CommandList
(define (rainbow-hexagons)
  (foldr append empty (map colored-poly-60-6 COLORS)))

;; shift-then: Number Number CommandList -> CommandList
(define (shift-then dx dy cmds)
  (append (list (pen-up)
                (forward dx)
                (turn-left 90)
                (forward dy)
                (turn-right 90)
                (pen-down))
          cmds))

;; square-at-index: Integer -> CommandList
;; i 番目の正方形（横に gap=50 ずつずらす、大きさ 40）
(define (square-at-index i)
  (shift-then (* i 50) 0 (make-regular-polygon 40 4)))

;; row-of-squares: Integer -> CommandList
(define (row-of-squares count)
  (foldr append empty (build-list count square-at-index)))

;; ------------------------------------------------------------
;; 描画（任意）— コメントを外して DrRacket で
;; ------------------------------------------------------------
;; (draw (make-regular-polygon 60 6))
;; (draw (growing-steps 8))
;; (draw (spiral-loop-90 30))
;; (draw (list (change-bg-color "black") (spiral-loop-91 40)))
;; (draw (row-of-squares 5))
;; (draw (rainbow-hexagons))
