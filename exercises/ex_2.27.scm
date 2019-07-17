(load "common.scm")

(define (deep-reverse s)
    (define (iter rest result)
        (if (null? rest)
            result
            (iter (cdr rest)
                  (cons (deep-reverse (car rest)) result))))
    (if (not (pair? s))
        s
        (iter s nil)))

(deep-reverse (list (list 1 (list 5 6 7) 2) (list 3 4)))

