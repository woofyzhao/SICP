(define (named-let? exp) (variable? (cadr exp)))
(define (named-let-name exp) (cadr exp))
(define (named-let-parameters exp) (map car (caddr exp)))
(define (named-let-parameters exp) (map car (caddr exp)))
(define (named-let-body exp) (cdddr exp))

(define (make-procedure-definition name parameters body)
    (cons 'define (cons (cons name parameters) body)))
(define (make-procedure-application procedure-name arguments)
    (cons procedure-name arguments))
(define (make-lambda-application lambda arguments)
    (cons lambda arguments))

(define (let->combination exp)
    (if (named-let? exp)
        (make-lambda-application
            (make-lambda '() 
                         (list (make-procedure-definition 
                                    (named-let-name exp)
                                    (named-let-parameters exp)
                                    (named-let-body exp))
                                (make-procedure-application 
                                    (named-let-name exp)
                                    (named-let-arguments exp))))
            '())
        (cons (make-lambda (let-parameters exp)
                           (let-body exp))
              (let-arguments exp))))
