(load "ch2_interval.scm")

(define (div-interval x y)
    (if (and (<= (lower-bound y) 0) (>= (upper-bound y) 0))
        (error "divider spans 0")
        (mul-interval x
            (make-interval (/ 1.0 (upper-bound y))
                           (/ 1.0 (lower-bound y))))))
(div-interval
    (make-interval 1 2)
    (make-interval -4 -1))

(div-interval
    (make-interval 1 2)
    (make-interval -4 1))