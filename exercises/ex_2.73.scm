(load "symbolic_diff.scm")

(define (deriv exp var)
    (cond ((number? exp) 0)
          ((variable? exp) (if (same-variable? exp var) 1 0))
          (else ((get 'deriv (operator exp)) (operands exp) var))))


(define (operator exp) (car exp))

(define (operands exp) (cdr exp))

; a. no explicit type tags for number and variable are available

; b.
(define (install-sum)

    (define (addend sum) (car sum))
    (define (augend sum) (cdr sum))
    (define (tag exp) (attach-tag '+ exp))
    (define (make-sum x y) (tag (cons x y)))

    (define (deriv-inner sum var)
        (make-sum (deriv (addend sum) var) (deriv (augend sum) var)))

    (put 'make '+ make-sum)
    (put 'deriv '+ deriv-inner)
    'done)

(define make-sum (get 'make '+))


(define (install-product)
    (define (multiplier product) (car product))
    (define (multiplicant product) (cdr product))
    (define (tag exp) (attach-tag '* exp))
    (define (make-product x y) (tag (cons x y)))

    (define (deriv-inner product var)
        (make-sum
              (make-product (deriv (multiplier product) var) (multiplicant product))
              (make-product (deriv (multiplicant product) var) (multiplier product))))

    (put 'make '* make-product)
    (put 'deriv '* deriv-inner)
    'done)

(define make-product (get 'make '*))


; c.
(load "ex_2.56.scm")
(define (install-exponential)
    (define (derive exp var)
          (make-product (make-product (cadr exp) (make-exponentiation 
                                                        (car exp)
                                                        (make-sum (cadr exp) -1)))
                         (deriv (car exp) var)))
    (put 'deriv '** deriv))

; d. Only need to switch the order of the argments of procedure put