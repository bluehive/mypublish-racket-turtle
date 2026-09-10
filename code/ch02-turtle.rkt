;; Racket タートルグラフィックス入門 — 第2章 タートル入門（BSL）
;; 実行: racket code/ch02-turtle.rkt
;; 描画: DrRacket で (draw (changing-square 80)) など（要: raco pkg install teachpacks）

#lang htdp/bsl

(require test-engine/racket-tests)
(require teachpacks/racket-turtle)
(require 2htdp/image)

;; ------------------------------------------------------------
;; Data: CommandList を組み立てる関数群
;; ------------------------------------------------------------

;; side: Number Number -> CommandList
;; 1辺進んで exterior-deg だけ左回転
(define (side len exterior-deg)
  (list (forward len)
        (turn-left exterior-deg)))

;; changing-side / changing-square — 公式 examples 4.4 準拠
(define (changing-side x)
  (list (forward x)
        (turn-left 90)))

(define (changing-square x)
  (repeat 4 (changing-side x)))

;; make-regular-polygon: Number Integer -> CommandList
;; 正 n 角形（n >= 3）。外角は 360/n
(define (make-regular-polygon len n)
  (repeat n (side len (/ 360 n))))

;; decorate: スタイル命令 + 図形
(define (decorate style shape-cmds)
  (append style shape-cmds))

(define (move-without-drawing dist turn-deg)
  (list (pen-up)
        (turn-right turn-deg)
        (forward dist)
        (pen-down)))

;; 2つの正方形（色違い）
(define (two-squares side-len gap)
  (append (changing-square side-len)
          (move-without-drawing gap 90)
          (list (change-color "red"))
          (changing-square side-len)))

;; 五芒星（簡易）: 外角 144°
(define (star-5 len)
  (repeat 5 (list (forward len) (turn-right 144))))

;; 色付き正方形
(define (fancy-square len)
  (decorate (list (change-bg-color "black")
                  (change-color "gold")
                  (change-pen-size 3))
            (list (changing-square len))))

;; スタンプ付き正方形（公式 4.7 系）
(define STAMP (circle 5 "solid" "red"))

(define (stamper-square len)
  (list (stamper-on STAMP)
        (pen-up)
        (changing-square len)))

;; square1 相当（展開形）
(define square1
  (list (forward 100) (turn-left 90)
        (forward 100) (turn-left 90)
        (forward 100) (turn-left 90)
        (forward 100) (turn-left 90)))

(define side100
  (list (forward 100) (turn-left 90)))

(define repeat-square
  (repeat 4 side100))

;; ------------------------------------------------------------
;; 構造テスト（draw は呼ばない — CI / headless 用）
;; ------------------------------------------------------------

(check-expect (length (side 10 90)) 2)
(check-expect (length (changing-square 30)) 8)
(check-expect (length (make-regular-polygon 40 6)) 12)
(check-expect (length (star-5 50)) 10)
(check-expect (length square1) 8)
(check-expect (length (move-without-drawing 10 90)) 4)
(check-expect (length repeat-square) 8)
(check-expect (length (decorate (list (change-color "red"))
                                (list (forward 1))))
              2)
(check-expect (length (two-squares 60 40)) 21)
(check-expect (length (fancy-square 40)) 4)

(test)

;; 描画（任意）— コメントを外して DrRacket / 手元で
;; (draw (changing-square 80))
;; (draw (make-regular-polygon 50 6))
;; (draw (fancy-square 70))
;; (draw (star-5 80))
;; (draw (stamper-square 100))
;; (draw (two-squares 60 40))
