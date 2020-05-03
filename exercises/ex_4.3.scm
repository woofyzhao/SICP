(define (eval-compound exp env) (apply-generic 'eval exp env))
(define (eval exp env)
    (cond ((self-evaluating? exp) exp)
          ((variable? exp) (lookup-variable-value exp env))
          (else (eval-compound exp env))))

(define (install-if)
    (define (eval exp env)
        (if (true? (eval (if-predicate exp) env))
            (eval (if-consequent exp) env)
            (eval (if-alternative exp) env)))
    (put 'eval 'if eval))


; solution from http://community.schemewiki.org/?sicp-ex-4.3
; better structured and correctly deal with application:
 (define operation-table make-table) 
 (define get (operation-table 'lookup-proc)) 
 (define put (operation-table 'insert-proc)) 
  
 (put 'eval 'quote text-of-quotation) 
 (put 'eval 'set! eval-assignment) 
 (put 'eval 'define eval-definition) 
 (put 'eval 'if eval-if) 
 (put 'eval 'lambda (lambda (exp env) (make-procedure (lambda-parameters exp) (lambda-body exp) env))) 
 (put 'eval 'begin (lambda (exp env) (eval-sequence (begin-sequence exp) env))) 
 (put 'eval 'cond (lambda (exp env) (eval (cond->if exp) env))) 
  
 (define (eval exp env) 
         (cond ((self-evaluating? exp) exp) 
               ((variable? exp) (lookup-variable-value exp env)) 
               ((get 'eval (car exp)) ((get 'eval (car exp)) exp env)) 
               ((application? exp)  
                (apply (eval (operator exp) env)  
                       (list-of-values (operands exp) env))) 
               (else (error "Unknown expression type -- EVAL" exp))))  