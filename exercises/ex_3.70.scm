(load "common.scm")

(define (merge-weighted s1 s2 weight)
    (cond ((stream-null? s1) s2)
          ((stream-null? s2) s1)
          (else 
            (let ((s1car (stream-car s1))
                  (s2car (stream-car s2)))
                (if (<= (weight s1car) (weight s2car))
                    (cons-stream s1car
                                (merge-weighted (stream-cdr s1) s2 weight))
                    (cons-stream s2car
                                (merge-weighted s1 (stream-cdr s2) weight)))))))

(define (pairs s t weight)
    (cons-stream (list (stream-car s) (stream-car t))
                 (merge-weighted
                    (stream-map (lambda (x) (list (stream-car s) x))
                                (stream-cdr t))
                    (pairs (stream-cdr s) (stream-cdr t) weight)
                    weight)))

; a
(define sums (pairs integers 
                    integers
                    (lambda (pair) (+ (car pair) (cadr pair)))))

(to-slice sums 0 100)

; b
(define sums (stream-filter
                (lambda (pair) 
                    (let ((i (car pair))
                          (j (cadr pair)))
                        (not (or (divisible? i 2) (divisible? i 3) (divisible? i 5)
                                 (divisible? j 2) (divisible? j 3) (divisible? j 5)))))
                (pairs integers 
                       integers
                       (lambda (pair)
                            (let ((i (car pair))
                                  (j (cadr pair)))
                                (+ (* 2 i) (* 3 j) (* 5 i j)))))))

; or filter input first
(define not235 (stream-filter 
                (lambda (x) (not (or (divisible? x 2) (divisible? x 3) (divisible? x 5))))
                integers))
(define sums (pairs not235 
                    not235
                    (lambda (pair)
                        (let ((i (car pair))
                              (j (cadr pair)))
                              (+ (* 2 i) (* 3 j) (* 5 i j))))))
(to-slice sums 0 100)