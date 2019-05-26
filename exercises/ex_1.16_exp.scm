(define (even? n)
    (= (remainder n 2) 0))

(define (expt b n)
    (expt-iter b n 1))

(define (expt-iter b n a)
    (cond ((= n 0) a)
          ((even? n) (expt-iter (square b) (/ n 2) a))
          (else (expt-iter (square b) (/ (- n 1) 2) (* a b)))))

(expt 2 32)
(expt 2 64)
(expt 10 100)
(= (expt 3333 1000) (expt (* 3333 3333) 500))
