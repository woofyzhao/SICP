(load "ex_3.59.scm")

(define (mul-series s1 s2)
    (cons-stream (* (stream-car s1) (stream-car s2))
                 (add-stream (scale-stream (stream-cdr s2) (stream-car s1))
                             (mul-series (stream-cdr s1) s2))))

(define s1 (mul-series sine-series sine-series))
(define s2 (mul-series cosine-series cosine-series))

(to-slice s1 0 100)
(to-slice s2 0 100)
(to-slice (add-stream s1 s2) 0 100)


