(define (require p) (if (not p) (amb)))

(define (an-element-of s)
    (require (not (null? s)))
    (amb (car s) (an-element-of (cdr s))))

(if-fail (let ((x (an-element-of '(1 3 5))))
            (require (even? x))
            x)
         'all-odd)

(if-fail (let ((x (an-element-of '(1 3 5 8))))
            (require (even? x))
            x)
         'all-odd)