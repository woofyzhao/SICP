(load "ex_2.2.scm")

; represent 1
(define (rectangle tl br) (cons tl br))
(define (topleft r) (car r))
(define (bottomright r) (cdr r))

(define (height r)
    (- (y-point (bottomright r))
       (y-point (topleft r))))

(define (width r)
    (- (x-point (bottomright r))
       (x-point (topleft r))))

; represent 2
(define (rectangle bl tr) (cons bl tr))
(define (bottomleft r) (car r))
(define (topright r) (cdr r))

(define (height r)
    (- (y-point (bottomleft r))
       (y-point (topright r))))

(define (width r)
    (- (x-point (topright r))
       (x-point (bottomleft r))))

; application 
(define (area r)
    (* (height r) (width r)))    

(define (perimeter r)
    (* 2 
       (+ (height r) (width r)))) 