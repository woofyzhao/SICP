(load "common.scm")

(define (reverse seq)
    (fold-right (lambda (x y) (append y (list x))) nil seq))

(reverse (list 1 2 3 4))

(define (reverse seq)
    (fold-left (lambda (y x) (cons x y)) nil seq))

(reverse (list 1 2 3 4))