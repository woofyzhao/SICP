(load "common.scm")

(define (count-leaves t)
    (accumulate + 0 (map (lambda (x) 1)
                         (enumerate-tree t))))

(define sample (list 1 2 (list 3 4 (list 5 6 7)) (list 8 9) 10 11))

(count-leaves sample)
(count-leaves (list 1))
(count-leaves nil)