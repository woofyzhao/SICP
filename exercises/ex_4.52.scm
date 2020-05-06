(load "evaluator-amb.scm")

(define (if-fail? exp)
    (tagged-list? exp 'if-fail))
(define (if-fail-cond exp) (cadr exp))
(define (if-fail-alt exp) (caddr exp))

(define (analyze exp)
    (cond ((self-evaluating? exp) (analyze-self-evaluating exp))
          ((variable? exp) (analyze-variable exp))
          ((quoted? exp) (analyze-quoted exp))
          ((amb? exp) (analyze-amb exp))
          ((assignment? exp) (analyze-assignment exp))
          ((if-fail? exp) (analyze-if-fail exp))
          ((definition? exp) (analyze-definition exp))
          ((let? exp) (analyze (let->combination exp)))
          ((if? exp) (analyze-if exp))
          ((lambda? exp) (analyze-lambda exp))
          ((begin? exp) (analyze-sequence (begin-actions exp)))
          ((cond? exp) (analyze-if (cond->if exp)))
          ((application? exp) (analyze-application exp))
          (else
            (error "Unknown expression type -- EVAL" exp))))

(define (analyze-if-fail exp)
    (let ((cproc (analyze (if-fail-cond exp)))
          (aproc (analyze (if-fail-alt exp))))
        (lambda (env succeed fail)
            (cproc env
                   (lambda (val fail2)
                        (succeed val fail2))
                   (lambda ()
                        (aproc env
                               (lambda (val2 fail3)
                                    (succeed val2 fail3))
                               fail))))))

====== the above is correct, but the more concise way is:

(define (analyze-if-fail exp)
    (let ((cproc (analyze (if-fail-cond exp)))
          (aproc (analyze (if-fail-alt exp))))
        (lambda (env succeed fail)
            (cproc env
                   succeed
                   (lambda ()
                        (aproc env succeed fail))))))