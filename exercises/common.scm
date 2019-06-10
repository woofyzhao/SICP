(define (even? n)
    (= (remainder n 2) 0))

(define (divides? a b)
    (= (remainder b a) 0))

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