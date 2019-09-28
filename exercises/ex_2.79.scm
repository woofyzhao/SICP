(define (install-scheme-number-package)
    ; internal
    (define (equ? x y)
        (= x y))

    ; exported
    (put 'equ? '(scheme-number scheme-number) equ?)

    'done)

(define (install-rational-package)
    ; internal
    (define (equ? x y)
        (= (* (numer x) (denom y))
           (* (numer y) (denom x))))

    ; exported
    (put 'equ? '(rational rational) equ?)
    
    'done)

(define (install-complex-package)
    ; internal
    (define (equ? x y)
        (and (= (real-part x) (real-part y))
             (= (imag-part x) (imag-part y))))

    ; exported
    (put 'equ? '(complex complex) equ?)
    
    'done)

; generic
(define (equ? x y) (apply-generic 'equ? x y))