(define (makef prod)
    (lambda (x)
        (set! prod (* prod x))
        prod))
       

(define f1 (makef 1))
(f1 0)
(f1 1)

(define f2 (makef 1))
(f2 1)
(f2 0)