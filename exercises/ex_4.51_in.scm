(define count 0)

(define (require p) (if (not p) (amb)))

(define (an-element-of s)
    (require (not (null? s)))
    (amb (car s) (an-element-of (cdr s))))

(let ((x (an-element-of '(a b c)))
      (y (an-element-of '(a b c))))
    (permanent-set! count (+ count 1))
    (require (not (eq? x y)))
    (list x y count))

; using ordinary set, count will always be one
(let ((x (an-element-of '(a b c)))
      (y (an-element-of '(a b c))))
    (set! count (+ count 1))
    (require (not (eq? x y)))
    (list x y count))

