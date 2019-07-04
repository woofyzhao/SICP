(load "ch2_interval.scm")

(define (make-center-width c w)
    (make-interval (- c w) (+ c w)))

(define (center i)
    (/ (+ (lower-bound i) (upper-bound i)) 2))

(define (width i)
    (/ (- (upper-bound i) (lower-bound i)) 2))    

; ex_2.12
(define (make-center-percent c p)
    (make-center-width c (* c p)))

(define (percent i)
    (abs (/ (width i) (center i))))

; ex_2.13
; x = (a, p) * (b, q)
; center(x) = ab(1+pq)
; width(x) = ab(p+q)
; percent(x) = width / center = (p+q)/(1+pq)