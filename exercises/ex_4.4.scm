; special forms
(define (and? exp) (tagged-list? exp 'and))
(define (and-predicates exp) (cdr exp))
(define (first-predicate seq) (car seq))
(define (rest-predicates seq) (cdr seq))
(define (no-predicate? seq) (null? seq))
(define (eval-and-predicates exps env)
    (cond ((no-predicates? exps) true)
          ((not (true? (eval (first-predicate exps)))) false)
          (else (eval-and-predicate (rest-predicates exps) env))))

(define (or? exp) (tagged-list? exp 'or))
(define (or-predicates exp) (cdr exp))
(define (eval-or-predicates exps env)
    (cond ((no-predicates? exps) false)
          ((true? (eval (first-predicate exps))) true)
          (else (eval-or-predicate (rest-predicates exps) env))))

; derived expressions
(define (and->if exp)
    (expand-and-predicates (and-predicates exp)))
(define (expand-and-predicates predicates)
    (if (no-predicates? predicates)
        'true
        (make-if (first-predicate predicates)
                 (expand-predicates (rest-predicates predicates))
                 'false)))

(define (or->if exp)
    (expand-or-predicates (or-predicates exp)))
(define (expand-or-predicates predicates)
    (if (no-predicate? predicates)
        'false
        (make-if (first-predicate predicates)
                'true
                (expand-predicates (rest-predicates predicates)))))