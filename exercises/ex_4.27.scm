(define count 0)

(define (id x)
    (set! count (+ count 1))
    x)

(define (id (id 10)))

count ; 1

w ; 10

count ; 2