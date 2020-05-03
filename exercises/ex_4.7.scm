(define (make-let bindings body) (cons 'let (cons bindings body))

(define (let*? exp) (tagged-list? exp 'let*))
(define (let*-bindings exp) (cadr exp))
(define (let*-body exp) (cddr exp))
(define (first-binding exp) (car exp))
(define (rest-bindings exp) (cdr exp))

(define (let*->nested-lets exp)
    (define (iter bindings)
        (if (null? bindings)
            (let*-body exp)
            (make-let (list (first-binding bindings))
                      (iter (rest-bindings bindings)))))
    (iter (let*-bindings exp)))

; it is sufficient to add (eval (let*->nested exp) env) 
; to extend the evaluator to handle let*