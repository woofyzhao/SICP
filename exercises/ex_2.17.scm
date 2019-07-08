(define (last-pair s)
    (if (= (cdr s) nil)
        s
        (last-pair (cdr s))))

(last-pair (list 1 2 3 4 5))