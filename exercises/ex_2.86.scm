; 1. In the complex package, make internal procedures on real/imag or mag/angle generic
; For example:

(define (install-complex-package)
    (define (add-complex z1 z2)
        (make-from-real-imag (add (real-part z1) (real-part z2))
                             (add (imag-part z1) (imag-part z2)))))
        ; here add is generic over ordinary numbers and rational numbers

; 2. In the underlying rectangle or polar representation, make similar generic changes
; For example

(define (install-polar-package)
    (define (real-part z)
        (mul (magnitude z) (cos (angle z))))
    (define (imag-part z)
        (mul (magnitude z) (sin (angle z)))))
    ; here mul , cos and sin are all generic over ordinary and rational numbers
