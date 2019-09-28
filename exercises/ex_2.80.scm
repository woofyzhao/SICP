(define (install-scheme-number-package)
    ; internal
    (define (=zero? x)
        (= x 0))

    ; exported
    (put '=zero? '(scheme-number) =zero?)

    'done)

(define (install-rational-package)
    ; internal
    (define (=zero? x)
        (and (= (numer x) 0)
             (not (= (denom x) 0))))

    ; exported
    (put '=zero? '(rational) =zero?)
    
    'done)

(define (install-complex-package)
    ; internal
    (define (=zero? x)
        (and (= (real-part x) 0)
             (= (imag-part x) 0)))

    ; exported
    (put '=zero? '(complex) =zero?)
    
    'done)

; generic 
(define (=zero? x) (apply-generic '=zero? x))