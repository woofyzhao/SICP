(define (named-let? exp) (variable? (cadr exp)))
(define (named-let-name exp) (cadr exp))
(define (named-let-parameters exp) (map car (caddr exp)))
(define (named-let-parameters exp) (map car (caddr exp)))
(define (named-let-body exp) (cdddr exp))

(define (make-procedure-definition name parameters body)
    (cons 'define (cons (cons name parameters) body)))
(define (make-procedure-application procedure arguments)
    (cons procedure arguments))

; approach 1: using anonymous lambda to constrain scope
(define (let->combination exp)
    (if (named-let? exp)
        (make-procedure-application
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

; approach 2: using sequence block to constrain scope
; might *NOT* work in this particular evaluator because 
; the block structure (begin ...) doesn't actually 
; construct a new environment only procedure application does (approach 1)
(define (let->combination exp)
    (if (named-let? exp)
        (sequence->exp
            (list (make-procedure-definition 
                    (named-let-name exp)
                    (named-let-parameters exp)
                    (named-let-body exp))
                  (make-procedure-application 
                    (named-let-name exp)
                    (named-let-arguments exp))))
        (make-procedure-application 
            (make-lambda (let-parameters exp) (let-body exp))
            (let-arguments exp))))