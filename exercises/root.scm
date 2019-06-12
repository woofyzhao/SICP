(load "common.scm")

(define tolerance 0.0000001)

(define (search f neg-point pos-point)
    (let ((midpoint (average neg-point pos-point)))
        (if (close-enough? neg-point pos-point)
            midpoint
            (let ((test-value (f midpoint)))
                (cond ((positive? test-value) (search f neg-point midpoint))
                      ((negative? test-value) (search f midpoint pos-point))
                      (else midpoint))))))

(define (half-interval-method f a b)
    (let ((a-value (f a))
          (b-value (f b)))
        (cond ((and (negative? a-value) (positive? b-value))
               (search f a b))
              ((and (positive? a-value) (negative? b-value))
               (search f b a))
              (else 
                (error "Values are not of opposite sign" a b)))))

(half-interval-method sin 2.0 4.0)
(half-interval-method (lambda (x) (- (cube x) (* 2 x) 3)) 1.0 2.0)