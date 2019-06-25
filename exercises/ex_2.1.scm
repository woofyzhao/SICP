(load "common.scm")

(define (make-rat-norm n d)
    (cond ((and (> n 0) (< d 0)) (cons (- n) (- d)))
          ((and (> n 0) (> d 0)) (cons n d))
          ((and (< n 0) (< d 0)) (cons (- n) (- d)))
          (else (cons n d))))    
 
(print-rat (make-rat-norm 100 200))
(print-rat (make-rat-norm -100 200))
(print-rat (make-rat-norm 100 -200))
(print-rat (make-rat-norm -100 -200))

(define (make-rat n d)
    (let ((g (gcd n d)))
        (let ((nn (/ n g))
              (dd (/ d g)))
            (make-rat-norm nn dd))))

(print-rat (make-rat 100 200))
(print-rat (make-rat -100 200))
(print-rat (make-rat 100 -200))
(print-rat (make-rat -100 -200))