(define (require p) (if (not p) (amb)))

(define (an-element-of s)
    (require (not (null? s)))
    (amb (car s) (an-element-of (cdr s))))

(define (divides? a b)
    (= (remainder b a) 0))

(define (smallest-divisor n)
    (find-divisor n 2))

(define (find-divisor n test-divisor)
    (cond ((> (square test-divisor) n) n) 
          ((divides? test-divisor n) test-divisor)
          (else (find-divisor n (+ test-divisor 1)))))

(define (prime? n)
    (and (= (smallest-divisor n) n) (!= n 1)))

(define (prime-sum-pair s1 s2)
    (let ((a (an-element-of s1))
          (b (an-element-of s2)))
        (require (prime? (+ a b)))
        (list a b)))

(let ((pairs '()))
    (if-fail (let ((p (prime-sum-pair '(1 3 5 8) '(20 35 110))))
                (permanent-set! pairs (cons p pairs))
                (amb))
             pairs))

; the first prime sum pair (3 20) ?
; =====================================
; wrong.... the (amb) above does not fail the first expression as a whole
; but to restart the expression with another choice!
; Just try it out