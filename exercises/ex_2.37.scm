(load "common.scm")

(define (dot-product v w)
    (accumulate + 0 (map * v w)))

(define (matrix-*-vector m v)
    (map (lambda (r) (dot-product r v)) m))

(define (transpose mat)
    (accumulate-n cons nil mat))

(define (matrix-*-matrix m n)
    (let ((cols (transpose n)))
        (map (lambda (r) (matrix-*-vector cols r)) m)))

; tests
(define v (list 1 2))
(define w (list 3 4))
(define A (list v w))
(define B (list (list 5 6) (list 7 8)))

(dot-product v w) ;11
(matrix-*-vector A v) ;(5 11)
(transpose A); ((1 3) (2 4))
(matrix-*-matrix A B); ((19 22) (43 50))