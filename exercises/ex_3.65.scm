(load "tableau.scm")

(define (ln2-summands n)
    (cons-stream (/ 1.0 n)
                 (stream-map - (ln2-summands (+ n 1)))))

(define ln2-stream (partial-sums (ln2-summands 1)))

(to-slice ln2-stream 0 100)

(define ln2-series (accelerated-sequence euler-transform ln2-stream))

(to-slice ln2-series 0 100)