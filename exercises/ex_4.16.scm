; a
(define (lookup-variable-value var env)
    (define (env-loop env)
        (define (scan vars vals)
            (cond ((null? vars) (env-loop (enclosing-environment env)))
                  ((eq? var (car vars)) 
                   (if (eq? '*unassigned* (car vals))
                       (error "Variable Unassigned -- LOOKUP-VARIABLE-VALUE" var)
                       (car vals)))
                  (else (scan (cdr vars) (cdr vals)))))
        (if (eq? env the-empty-environment)
            (error "Unbound variable" var)
            (let ((frame (first-frame env)))
                (scan (frame-variables frame)
                      (frame-values frame)))))
    (env-loop env))

; b
(define (make-let bingings body)
    (cons 'let (cons bindigs body)))

(define (make-assignment var exp)
    (list 'set! var exp))

(define (scan-out-defines body)

    (define (collect seq defs exps)
        (if (null? seq)
            (cons defs exps)
            (if (definition? (car seq))
                (collect (cdr seq) (cons (car seq) defs) exps)
                (collect (cdr seq) defs (cons (car seq) exps)))))

    (let ((pair (collect body '() '())))
        (let ((defs (car pair)) (exps (cdr pair)))
            (make-let (map (lambda (def) 
                                (list (definition-variable def) 
                                      '*unassigned*))
                           defs)
                      (append 
                        (map (lambda (def) 
                                (make-assignment (definition-variable def)
                                                 (definition-value def)))
                             defs)
                        exps)))))

; c 
; make-procedure is better because we can easily explore other transformations

(define (make-procedure parameters body env)
    (list 'procedure parameters (scan-out-defines body) env))

or 

(define (make-procedure-with-transformation transformation)
    (define (make-procedure parameters body env)
        (list 'procedure parameters (transformation body) env))
    make-procedure)