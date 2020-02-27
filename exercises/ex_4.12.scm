(define (tranverse var env on-find on-frame-end on-env-end)
    (define (env-loop env)
        (define (scan vars vals)
            (cond ((null? vars) (on-frame-end env))
                  ((eq? var) (on-find vals))
                  (else (scan (cdr vars) (cdr vals)))))
        (if (eq? env the-empty-environment)
            (on-env-end)
            (let ((frame (first-frame)))
                (scan (frame-variables frame)
                      (frame-values frame)))))
    (env-loop env))

(define (lookup-variable-value var env)
    (tranverse var
               env
               (lambda (vals) (car vals))
               (lambda (env) (lookup-variables-value var (enclosing-environment env)))
               (lambda () (error "Unbound variable -- lookup-variable-value " var))))

(define (set-variable-value! var val env)
   (tranverse var
              env
              (lambda (vals) (set-car! vals val))
              (lambda (env) (set-variables-value! var val (enclosing-environment env)))
              (lambda () (error "Unbound variable -- set-variable-value!" var))))

(define (define-variable! var val env)
    (tranverse var
               env
               (lambda (vals) (set-car! vals val))
               (lambda (env) (add-binding-to-frame! var val (first-frame env)))
               (lambda () (error "Empty environment -- define-variable!"))))

