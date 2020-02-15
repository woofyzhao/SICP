(load "common.scm")

(define (interleave s1 s2)
    (if (stream-null? s1)
        s2
        (cons-stream (stream-car s1)
                     (interleave s2 (stream-cdr s1)))))

(define (pairs s t)
    (cons-stream (list (stream-car s) (stream-car t))
                 (interleave
                    (interleave
                        (stream-map (lambda (x) (list (stream-car s) x)) (stream-cdr t))
                        (stream-map (lambda (x) (list x (stream-car t))) (stream-cdr s)))
                    (pairs (stream-cdr s) (stream-cdr t)))))

(define prime-sums
        (stream-filter (lambda (pair)
                            (prime? (+ (car pair) (cadr pair))))
                       (pairs integers integers)))

(to-slice (pairs integers integers) 0 1000)