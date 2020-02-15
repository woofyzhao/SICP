(load "stream_pairs.scm")

(define (triples s t u)
    (cons-stream (list (stream-car s) (stream-car t) (stream-car u))
                 (interleave (stream-map (lambda (pair) (cons (stream-car s) pair))
                                         (pairs t (stream-cdr u)))
                             (triples (stream-cdr s) (stream-cdr t) (stream-cdr u)))))

(to-slice (triples integers integers integers) 0 20)

(define pythagoras (stream-filter 
                    (lambda (triple)
                        (= (+ (square (car triple))
                              (square (cadr triple)))
                           (square (caddr triple))))
                    (triples integers 
                             integers
                             integers)))


(stream-ref pythagoras 0)
(stream-ref pythagoras 1)
(stream-ref pythagoras 2)
(stream-ref pythagoras 3)
(stream-ref pythagoras 4)
(stream-ref pythagoras 5)
;(stream-ref pythagoras 6)
;(to-slice pythagoras 0 4)