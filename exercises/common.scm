; ===== chapter 1 =====
(define (even? n)
    (= (remainder n 2) 0))

(define (divides? a b)
    (= (remainder b a) 0))

(define (positive? n)
    (> n 0))

(define (negative? n)
    (< n 0))

(define (average a b)
    (/ (+ a b) 2))

(define (double a)
    (+ a a))

(define (half a)
    (/ a 2))

(define (!= a b)
    (not (= a b)))

(define (sum-of-square x y) (+ (square x) (square y)))

(define (fast-expt b n)
    (cond ((= n 0) 1)
          ((even? n) (square (fast-expt b (/ n 2))))
          (else (* b (fast-expt b (- n 1))))))

(define (expmod base exp m)
    (cond ((= exp 0) 1)
          ((even? exp) 
           (remainder (square (expmod base (/ exp 2) m)) m))
          (else 
           (remainder (* base (expmod base (- exp 1) m)) m))))

(define (cube x)
    (* x x x))

(define (gcd a b)
    (if (= b 0) 
        a
        (gcd b (remainder a b))))

(define (identity x) x)

(define (inc x) (+ x 1))

(define (dec x) (- x 1))

(define tolerance 0.0000001)
(define (close-enough? a b)
    (< (abs (- a b)) tolerance))

(define pi (acos -1.0))

(define (average-damp f)
    (lambda (x) (average x (f x))))

(define (compose f g)
    (lambda (x) (f (g x))))

(define (repeated f n)
    (if (= n 0) 
        identity 
        (compose f (repeated f (- n 1)))))

; ===== chapter 2 =====
(define (make-rat n d) (cons n d))

(define (numer x) (car x))

(define (denom x) (cdr x))

(define (print-rat x)
    (newline)
    (display (numer x))
    (display "/")
    (display (denom x)))

(define (add-rat x y)
    (make-rat 
        (+ (* (numer x) (denom y)) (* (denom x) (numer y))) 
        (* ((denom x) (denom y)))))
        
(define (sub-rat x y)
    (make-rat
        (- (* (numer x) (denom y)) (* (denom x) (numer y))) 
        (* ((denom x) (denom y)))))

(define (mul-rat x y)
    (make-rat
        (* (numer x) (numer y))
        (* (denom x) (denom y))))

(define (div-rat x y)
    (make-rat
        (* (numer x) (denom y))
        (* (denom x) (numer y))))

(define (equal-rat? x y)
    (= (* (numer x) (denom y))
       (* (numer y) (denom x))))

(define nil '())