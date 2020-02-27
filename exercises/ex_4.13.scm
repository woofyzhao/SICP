; only remove from the first env

(define (unbound? exp) (tagged-list? 'make-unbound!))
(define (unbound-var exp) (cadr exp))

(define (eval-unbound exp env)
    (make-unbound! (var exp) env))

(define (make-unbound! var env)
    (define (filter vars vals)
        (cond ((null? vars) (cons '() '()))
              ((eq? var (car vars)) (filter (cdr vars) (cdr vals)))
              (let ((rest (filter (cdr vars) (cdr vals))))
                (cons (cons (car vars) (car rest))
                      (cons (car vals) (cdr rest))))))
    (let ((frame (first-frame env)))
        (let ((pair (filter (frame-variables frame) (frame-values frame))))
            (set-car! env (make-frame (car pair) (cdr pair))))))