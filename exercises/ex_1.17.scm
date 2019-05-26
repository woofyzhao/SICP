(load "common.scm")

(define (* a b)
    (cond ((= b 0) 0)
          ((even? b) (double (* a (half b))))
          (else (+ (double (* a (half (- b 1)))) a))))

(* 100 199)