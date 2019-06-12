(define (cont-frac n d k)
    (define (calc i)
        (if (> i k)
            0
            (/ (n i) (+ (d i) (calc (+ i 1))))))
    (calc 1)
)

(cont-frac (lambda (i) 1.0)
           (lambda (i) 1.0)
           12)

(define (cont-frac-iter n d k)
    (define (iter i result)
        (if (= i 0)
            result
            (iter (- i 1) (/ (n i) (+ (d i) result)))))
    (iter k 0)
)

(cont-frac-iter (lambda (i) 1.0)
                (lambda (i) 1.0)
                12)