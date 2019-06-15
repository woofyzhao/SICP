(load "newton.scm")

(define (cubic a b c)
    (lambda (x) (+ (cube x)
                   (* a (square x))
                   (* b x)
                   c)))

(newtons-method (cubic 3 4 5) 1)