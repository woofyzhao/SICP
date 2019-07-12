(load "common.scm")

(define (same-parity-with? a b)
    (= (remainder a 2) (remainder b 2)))

; iterative, reversed
(define (same-parity-1 . s)
    (define (iter result rest filter?)
        (cond ((null? rest) result)
              ((filter? (car rest)) (iter (cons (car rest) result) (cdr rest) filter?))
              (else (iter result (cdr rest) filter?))))
    (iter nil s (lambda (e) (same-parity-with? e (car s)))))

; recursive
(define (same-parity . s)
    (define (go a)
        (cond ((null? a) nil)
              ((same-parity-with? (car s) (car a)) (cons (car a) (go (cdr a))))
              (else (go (cdr a)))))
    (go s))

(same-parity 1 2 3 4 5 6 7)
(same-parity 2 3 4 5 6 7)