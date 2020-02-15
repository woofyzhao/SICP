(define (smooth s1)
    (stream-map average s1 (stream-cdr s1)))

(define zero-crossings (make-zero-crossings (smooth sense-data) 0))