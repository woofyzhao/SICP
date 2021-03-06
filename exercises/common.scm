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

; use the more general default version
;(define (map f items)
;    (if (null? items)
;        nil
;        (cons (f (car items)) (map f (cdr items)))))

(define (reverse s)
    (define (iter r next)
        (if (null? next)
            r
            (iter (cons (car next) r) (cdr next))))
    (iter nil s))

; list interfaces
(define (filter predicate seq)
    (cond ((null? seq) nil)
          ((predicate (car seq)) (cons (car seq) (filter predicate (cdr seq))))
          (else (filter predicate (cdr seq)))))

(define (accumulate op intial seq)
    (if (null? seq)
        intial
        (op (car seq) (accumulate op intial (cdr seq)))))

(define (enumerate-interval low high)
    (if (> low high)
        nil
        (cons low (enumerate-interval (+ low 1) high))))

(define (enumerate-tree tree)
    (cond ((null? tree) nil)
          ((not (pair? tree)) (list tree))
          (else (append (enumerate-tree (car tree)) 
                        (enumerate-tree (cdr tree))))))

(define (accumulate-n op init seqs)
    (if (null? (car seqs))
        nil
        (cons (accumulate op init (map car seqs))
              (accumulate-n op init (map cdr seqs)))))

(define (flatmap f seq)
    (accumulate append nil (map f seq)))

(define (length seq)
    (if (null? seq)
        0
        (+ 1 (length (cdr seq)))))

; ===== chapter 3 =====
(define (logical-not s)
    (if (= s 1)
        0
        1))
(define (logical-and a b)
    (if (and (= a 1) (= b 1))
        1
        0))
(define (logical-or a b)
    (if (or (= a 1) (= b 1))
        1
        0))

(define (stream-enumerate-interval a b)
    (if (> a b)
        the-empty-stream
        (cons-stream a (stream-enumerate-interval (+ a 1) b))))

(define (stream-ref stream n)
    (if (= n 0)
        (stream-car stream)
        (stream-ref (stream-cdr stream) (- n 1))))

(define (to-slice stream from n)
    (map (lambda (i) (stream-ref stream i))
         (enumerate-interval from (- n 1))))

(define (stream-for-each f stream)
    (if (stream-null? stream)
        'done
        (begin
            (f (stream-car stream))
            (stream-for-each f (stream-cdr stream)))))
(define (display-line x)
    (newline)
    (display x))
(define (display-stream stream)
    (stream-for-each display-line stream))


(define (stream-filter f stream)
    (cond ((stream-null? stream) the-empty-stream)
          ((f (stream-car stream))
           (cons-stream (stream-car stream)
                        (stream-filter f (stream-cdr stream))))
          (else (stream-filter f (stream-cdr stream)))))

(define (integers-starting-from n)
    (cons-stream n (integers-starting-from (+ n 1))))

(define (divisible? x y) (= (remainder x y) 0))

(define ones (cons-stream 1 ones))

(define (add-stream s1 s2) (stream-map + s1 s2))
(define (mul-stream s1 s2) (stream-map * s1 s2))
(define (div-stream s1 s2) (stream-map / s1 s2))

(define integers (cons-stream 1 (add-stream ones integers)))

(define fibs
    (cons-stream 0
        (cons-stream 1
            (add-stream fibs
                        (stream-cdr fibs)))))

(define (scale-stream stream factor)
    (stream-map (lambda (x) (* x factor)) stream))

(define (negative s) (scale-stream s -1))

(define double (cons-stream 1 (scale-stream double 2)))

(define primes
    (cons-stream 2
                 (stream-filter prime? (integers-starting-from 3))))

(define (prime? n)
    (define (iter ps)
        (cond ((> (square (stream-car ps)) n) true)
              ((divisible? n (stream-car ps)) false)
              (else (iter (stream-cdr ps)))))
    (iter primes))

(define (merge s1 s2)
    (cond ((stream-null? s1) s2)
          ((stream-null? s2) s1)
          (else
            (let ((s1car (stream-car s1))
                  (s2car (stream-car s2)))
                (cond ((< s1car s2car) 
                       (cons-stream s1car (merge (stream-cdr s1) s2)))
                      ((> s1car s2car)
                       (cons-stream s2car (merge s1 (stream-cdr s2))))
                      (else
                        (cons-stream s1car 
                                     (merge (stream-cdr s1) (stream-cdr s2)))))))))

(define (partial-sums s)
    (define sums (add-stream s (cons-stream 0 sums)))
    sums)

(define (list-ref s n)
    (if (= n 0)
        (car s)
        (list-ref (cdr s) (- n 1))))

(define (list-starting-from s n)
    (if (= n 0)
        s
        (list-starting-from (cdr s) (- n 1))))

(define (random-select s)
    (list-ref s (random (length s))))

(define (tagged-list? exp tag)
    (if (pair? exp)
        (eq? (car exp) tag)
        false))

(define (interleave s1 s2)
    (if (stream-null? s1)
        s2
        (cons-stream (stream-car s1)
                     (interleave s2 (stream-cdr s1)))))