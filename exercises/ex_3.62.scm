(load "ex_3.61.scm")

(define (div-series p q)
    (let ((c (stream-car q)))
        (if (= c 0)
            (error "denominator has zero constant term -- DIV-SERIES" q)
            (mul-series (scale-stream p c)
                        (invert-unit-series (scale-stream q (/ 1 c)))))))

(define tangent (div-series sine-series cosine-series))

(to-slice tangent 0 100)