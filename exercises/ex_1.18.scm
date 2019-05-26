(load "common.scm")

(define (* a b)
    (mul-iter a b 0))

(define (mul-iter a b x)
    (cond ((= b 0) x)
          ((even? b) (mul-iter (double a) (half b) x))
          (else (mul-iter (double a) (half (- b 1)) (+ x a)))))

(* 100 199)