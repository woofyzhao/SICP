(load "evaluator-amb.scm")

; if-fail extension from ex_4.52
(define (if-fail? exp)
    (tagged-list? exp 'if-fail))
(define (if-fail-cond exp) (cadr exp))
(define (if-fail-alt exp) (caddr exp))

(define (analyze-if-fail exp)
    (let ((cproc (analyze (if-fail-cond exp)))
          (aproc (analyze (if-fail-alt exp))))
        (lambda (env succeed fail)
            (cproc env
                   succeed
                   (lambda ()
                        (aproc env succeed fail))))))

; permanent set from ex_4.51 
(define (perm-assignment? exp)
    (tagged-list? exp 'permanent-set!))
(define (perm-assignment-variable exp) (cadr exp))
(define (perm-assignment-value exp) (caddr exp))

(define (analyze-perm-assignment exp)
    (let ((var (perm-assignment-variable exp))
          (vproc (analyze (perm-assignment-value exp))))
        (lambda (env succeed fail)
            (vproc env
                   (lambda (val fail2)
                        (set-variable-value! var val env)
                        (succeed 'ok fail2))
                    fail))))

; special form to ensure failure
(define (require-fail? exp) (tagged-list? exp 'require-fail))
(define (require-fail-exp exp) (cadr exp))

(define (analyze-require-fail exp)
    (let ((proc (analyze (require-fail-exp exp))))
        (lambda (env succeed fail)
            (proc env
                  (lambda (value fail2) (fail))
                  (lambda () (succeed 'ok fail))))))

(define (analyze exp)
    (cond ((self-evaluating? exp) (analyze-self-evaluating exp))
          ((variable? exp) (analyze-variable exp))
          ((quoted? exp) (analyze-quoted exp))
          ((amb? exp) (analyze-amb exp))
          ((assignment? exp) (analyze-assignment exp))
          ((perm-assignment? exp) (analyze-perm-assignment exp))
          ((if-fail? exp) (analyze-if-fail exp))
          ((require-fail? exp) (analyze-require-fail exp))
          ((definition? exp) (analyze-definition exp))
          ((let? exp) (analyze (let->combination exp)))
          ((if? exp) (analyze-if exp))
          ((and? exp) (analyze-and exp))
          ((or? exp) (analyze-or exp))
          ((lambda? exp) (analyze-lambda exp))
          ((begin? exp) (analyze-sequence (begin-actions exp)))
          ((cond? exp) (analyze-if (cond->if exp)))
          ((application? exp) (analyze-application exp))
          (else
            (error "Unknown expression type -- EVAL" exp))))

