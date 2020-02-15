; guess: number of pairs from row n is roughly double the size of paris from row n+1
(load "stream_pairs.scm")

(define (count-till stream target)
    (define (iter s cnt)
        (if (equal? (stream-car s) target)
            cnt
            (iter (stream-cdr s) (+ cnt 1))))
    (iter stream 0))

(define int-pairs (pairs integers integers))

(count-till int-pairs '(1 100))
(count-till int-pairs '(2 100))
(count-till int-pairs '(3 100))
(count-till int-pairs '(99 100))
(count-till int-pairs '(100 100))


