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
    (define (deriv-exp terms var)
        (make-sum (deriv (car terms) var) (deriv (cadr terms) var)))
    (put 'deriv '+ (deriv-exp)))

(define (install-product)
    (define (deriv-exp terms var)
        (make-sum
              (make-product (deriv (car terms) var) (cadr terms))
              (make-product (deriv (cadr terms) var) (car terms))))
    (put 'deriv '* (deriv-exp)))

; c.
(load "ex_2.56.scm")
(define (install-exponential)
    (define (derive-exp exp var)
          (make-product (make-product (cadr exp) (make-exponentiation 
                                                        (car exp)
                                                        (make-sum (cadr exp) -1)))
                         (deriv (car exp) var)))
    (put 'deriv '** deriv-exp))

; d. Only need to switch the order of the argments of procedure put