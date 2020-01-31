(define (make-monitored f)
    (let ((cnt 0))
        (define (mf x)
            (cond ((eq? x 'how-many-calls?) cnt)
                  ((eq? x 'reset-count) (set! cnt 0) cnt)
                  (else (set! cnt (+ cnt 1)) (f x))))
        mf))
                        

(define s (make-monitored sqrt))

(s 100)
(s 50)
(s 'how-many-calls?)
(s 'reset-count)
(s 65536)
(s 'how-many-calls?)