(load "common.scm")

(define apply-in-underlying-scheme apply)
(define eval-in-underlying-scheme eval)

; eval, apply

(define (ambeval exp env succeed fail)
    ((analyze exp) env succeed fail))
    
(define (analyze exp)
    (cond ((self-evaluating? exp) (analyze-self-evaluating exp))
          ((variable? exp) (analyze-variable exp))
          ((quoted? exp) (analyze-quoted exp))
          ((amb? exp) (analyze-amb exp))
          ((assignment? exp) (analyze-assignment exp))
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

(define (analyze-self-evaluating exp)
    (lambda (env succeed fail)
        (succeed exp fail)))

(define (analyze-quoted exp)
    (let ((qval (text-of-quotation exp)))
        (lambda (env succeed fail) 
            (succeed qval fail))))

(define (analyze-variable exp)
    (lambda (env succeed fail) 
        (succeed (lookup-variable-value exp env) fail)))

(define (analyze-lambda exp)
    (let ((vars (lambda-parameters exp))
          (bproc (analyze-sequence (lambda-body exp))))
        (lambda (env succeed fail)
            (succeed (make-procedure vars bproc env) fail))))

(define (analyze-definition exp)
    (let ((var (definition-variable exp))
          (vproc (analyze (definition-value exp))))
        (lambda (env succeed fail)
            (vproc env
                   (lambda (val fail2)
                    (define-variable! var val env)
                    (succeed 'ok fail2))
                   fail))))

(define (analyze-assignment exp)
    (let ((var (assignment-variable exp))
          (vproc (analyze (assignment-value exp))))
        (lambda (env succeed fail)
            (vproc env
                   (lambda (val fail2)
                    (let ((old-value (lookup-variable-value var env)))
                        (set-variable-value! var val env)
                        (succeed 'ok
                                 (lambda ()
                                    (set-variable-value! var old-value env)
                                    (fail2)))))
                    fail))))

(define (analyze-if exp)
    (let ((pproc (analyze (if-predicate exp)))
          (cproc (analyze (if-consequent exp)))
          (aproc (analyze (if-alternative exp))))
        (lambda (env succeed fail)
            (pproc env
                   ;; success continuation for evaluating the predicate
                   ;; to obtain pred-value 
                   (lambda (pred-value fail2)
                    (if (true? pred-value)
                        (cproc env succeed fail2)
                        (aproc env succeed fail2)))
                   ;; failure continuation for evaluating the predicate
                   fail))))

(define (analyze-and exp)
    (let ((proc-left (analyze (and-left exp)))
          (proc-right (analyze (and-right exp))))
        (lambda (env succeed fail)
            (proc-left env
                       (lambda (pred-value fail2)
                        (if (true? pred-value)
                            (proc-right env succeed fail2)
                            (succeed pred-value fail2)))
                       fail))))

(define (analyze-or exp)
    (let ((proc-left (analyze (or-left exp)))
          (proc-right (analyze (or-right exp))))
        (lambda (env succeed fail)
            (proc-left env
                       (lambda (pred-value fail2)
                        (if (false? pred-value)
                            (proc-right env succeed fail2)
                            (succeed pred-value fail2)))
                       fail))))

(define (analyze-sequence exps)
    (define (sequentially a-proc b-proc)
        (lambda (env succeed fail) 
            (a-proc env
                    ;; success continuation for calling a
                    (lambda (a-value fail2)
                        (b-proc env succeed fail2))
                    ;; failure continuation for calling a
                    fail)))
    (define (loop first-proc rest-procs)
        (if (null? rest-procs)
            first-proc
            (loop (sequentially first-proc (car rest-procs))
                  (cdr rest-procs))))
    (let ((procs (map analyze exps)))
        (if (null? procs)
            (error "Empty sequence -- ANALYZE"))
        (loop (car procs) (cdr procs))))

(define (analyze-application exp)
    (let ((fproc (analyze (operator exp)))
          (aprocs (map analyze (operands exp))))
        (lambda (env succeed fail)
            (fproc env
                   (lambda (proc fail2)
                    (get-args aprocs
                              env
                              (lambda (args fail3)
                                (execute-application
                                 proc args succeed fail3))
                              fail2))
                    fail))))

(define (get-args aprocs env succeed fail)
    (if (null? aprocs)
        (succeed '() fail)
        ((car aprocs) env
                      ;; success continuation for this aproc
                      (lambda (arg fail2)
                        (get-args (cdr aprocs)
                                  env
                                  ;; success continuation for recursive
                                  ;; call to get-args
                                  (lambda (args fail3)
                                    (succeed (cons arg args) fail3))
                                  fail2))
                      fail)))

(define (execute-application proc args succeed fail)
    (cond ((primitive-procedure? proc)
           (succeed (apply-primitive-procedure proc args)
                    fail))
          ((compound-procedure? proc)
           ((procedure-body proc)
            (extend-environment
                (procedure-parameters proc)
                args
                (procedure-environment proc))
            succeed
            fail))
          (else
            (error "Unknown procedure type -- EXECUTION-APPLICATION" proc))))

(define (analyze-amb exp)
    ;right to left order
    ;(let ((cprocs (reverse (map analyze (amb-choices exp)))))
    (let ((cprocs (map analyze (amb-choices exp))))
        (lambda (env succeed fail)
            (define (try-next choices)
                (if (null? choices)
                    (fail)
                    ((car choices) env
                                   succeed
                                   (lambda ()
                                    (try-next (cdr choices))))))
            (try-next cprocs))))

; expression representation
(define (self-evaluating? exp)
    (cond ((number? exp) true)
          ((string? exp) true)
          (else false)))

(define (variable? exp) (symbol? exp))

(define (quoted? exp) (tagged-list? exp 'quote))
(define (text-of-quotation exp) (cadr exp))

(define (amb? exp) (tagged-list? exp 'amb))
(define (amb-choices exp) (cdr exp))

(define (tagged-list? exp tag)
    (if (pair? exp)
        (eq? (car exp) tag)
        false))

(define (assignment? exp)
    (tagged-list? exp 'set!))
(define (assignment-variable exp) (cadr exp))
(define (assignment-value exp) (caddr exp))

(define (definition? exp) (tagged-list? exp 'define))
(define (definition-variable exp)
    (if (symbol? (cadr exp))
        (cadr exp)
        (caadr exp)))
(define (definition-value exp)
    (if (symbol? (cadr exp))
        (caddr exp)
        (make-lambda (cdadr exp)
                     (cddr exp))))

(define (lambda? exp) (tagged-list? exp 'lambda))
(define (lambda-parameters exp) (cadr exp))
(define (lambda-body exp) (cddr exp))
(define (make-lambda parameters body) (cons 'lambda (cons parameters body)))

(define (if? exp) (tagged-list? exp 'if))
(define (if-predicate exp) (cadr exp))
(define (if-consequent exp) (caddr exp))
(define (if-alternative exp)
    (if (not (null? (cdddr exp)))
        (cadddr exp)
        'false))
(define (make-if predicate consequent alternative)
    (list 'if predicate consequent alternative))

(define (and? exp) (tagged-list? exp 'and))
(define (and-left exp) (cadr exp))
(define (and-right exp) (caddr exp))

(define (or? exp) (tagged-list? exp 'or))
(define (or-left exp) (cadr exp))
(define (or-right exp) (caddr exp))

(define (begin? exp) (tagged-list? exp 'begin))
(define (begin-actions exp) (cdr exp))
(define (last-exp? seq) (null? (cdr seq)))
(define (first-exp seq) (car seq))
(define (rest-exps seq) (cdr seq))
(define (sequence->exp seq)
    (cond ((null? seq) seq)
          ((last-exp? seq) (first-exp seq))
          (else (make-begin seq))))
(define (make-begin seq) (cons 'begin seq))

(define (application? exp) (pair? exp))
(define (operator exp) (car exp))
(define (operands exp) (cdr exp))
(define (no-operands? ops) (null? ops))
(define (first-operand ops) (car ops))
(define (rest-operands ops) (cdr ops))
(define (make-application operator operands) (cons operator operands))

(define (cond? exp) (tagged-list? exp 'cond))
(define (cond-clauses exp) (cdr exp))
(define (cond-else-clause? clause) (eq? (cond-predicate clause) 'else))
(define (cond-predicate clause) (car clause))
(define (cond-actions clause) (cdr clause))
(define (cond->if exp) (expand-clauses (cond-clauses exp)))
(define (expand-clauses clauses)
    (if (null? clauses)
        'false              ; no else clause
        (let ((first (car clauses))
              (rest (cdr clauses)))
            (if (cond-else-clause? first)
                (if (null? rest)
                    (sequence->exp (cond-actions first))
                    (error "ELSE clause isn't last -- COND->IF"))
                (make-if (cond-predicate first)
                         (sequence->exp (cond-actions first))
                         (expand-clauses rest))))))

(define (let? exp) (tagged-list? exp 'let))
(define (let-bindings exp) (cadr exp))
(define (let-body exp) (cddr exp))
(define (let-parameters exp) (map car (let-bindings exp)))
(define (let-arguments exp) (map cadr (let-bindings exp)))
(define (let->combination exp)
    (make-application (make-lambda (let-parameters exp) (let-body exp))
                      (let-arguments exp)))

; evaluator data structures

(define (true? x) (not (eq? x false)))
(define (false? x) (eq? x false))

(define (make-procedure parameters body env)
    (list 'procedure parameters body env))
(define (compound-procedure? p)
    (tagged-list? p 'procedure))
(define (procedure-parameters p) (cadr p))
(define (procedure-body p) (caddr p))
(define (procedure-environment p) (cadddr p))

(define (enclosing-environment env) (cdr env))
(define (first-frame env) (car env))
(define the-empty-environment '())

(define (make-frame variables values) (cons variables values))
(define (frame-variables frame) (car frame))
(define (frame-values frame) (cdr frame))
(define (add-binding-to-frame! var val frame)
    (set-car! frame (cons var (car frame)))
    (set-cdr! frame (cons val (cdr frame))))

(define (extend-environment vars vals base-env)
    (if (= (length vars) (length vals))
        (cons (make-frame vars vals) base-env)
        (if (< (length vars) (length vals))
            (error "Too many arguments supplied" vars vals)
            (error "Too few arguments supplied" var vals))))

(define (lookup-variable-value var env)
    (define (env-loop env)
        (define (scan vars vals)
            (cond ((null? vars) (env-loop (enclosing-environment env)))
                  ((eq? var (car vars)) (car vals))
                  (else (scan (cdr vars) (cdr vals)))))
        (if (eq? env the-empty-environment)
            (error "Unbound variable" var)
            (let ((frame (first-frame env)))
                (scan (frame-variables frame)
                      (frame-values frame)))))
    (env-loop env))
        
(define (set-variable-value! var val env)
    (define (env-loop env)
        (define (scan vars vals)
            (cond ((null? vars) (env-loop (enclosing-environment env)))
                  ((eq? var (car vars)) (set-car! vals val))
                  (else (scan (cdr vars) (cdr vals)))))
        (if (eq? env the-empty-environment)
            (error "Unbound variable" var)
            (let ((frame (first-frame env)))
                (scan (frame-variables frame)
                      (frame-values frame)))))
    (env-loop env))

(define (define-variable! var val env)
    (let ((frame (first-frame env)))
        (define (scan vars vals)
            (cond ((null? vars) (add-binding-to-frame! var val frame))
                  ((eq? var (car vars)) (set-car! vals val))
                  (else (scan (cdr vars) (cdr vals)))))
        (scan (frame-variables frame)
              (frame-values frame))))

; primitive procedures and global environment
(define (setup-environment)
    (let ((initial-env
            (extend-environment (primitive-procedure-names)
                                (primitive-procedure-objects)
                                the-empty-environment)))
        (define-variable! 'true true initial-env)
        (define-variable! 'false false initial-env)
        (define-variable! 'user-initial-environment user-initial-environment initial-env)
        initial-env))

(define primitive-procedures
    (list (list 'car car)
          (list 'cdr cdr)
          (list 'pair? pair?)
          (list 'symbol? symbol?)
          (list 'number? number?)
          (list 'cons cons)
          (list 'null? null?)
          (list 'eq? eq?)
          (list 'equal? equal?)
          (list 'even? even?)
          (list 'odd? odd?)
          (list '+ +)
          (list '- -)
          (list '* *)
          (list '/ /)
          (list '= =)
          (list '!= !=)
          (list '< <)
          (list '> >)
          (list 'not not)
          (list 'list list)
          (list 'quotient quotient)
          (list 'remainder remainder)
          (list 'set-car! set-car!)
          (list 'set-cdr! set-cdr!)
          (list 'memq memq)
          (list 'random random)
          (list 'square square)
          (list 'caar caar)
          (list 'cadr cadr)
          (list 'caddr caddr)
          (list 'cadddr cadddr)
          (list 'cddr cddr)
          (list 'cdddr cdddr)
          (list 'cdar cdar)
          (list 'newline newline)
          (list 'display display)
          (list 'read read)
          (list 'apply apply-in-underlying-scheme)
          (list 'eval eval-in-underlying-scheme)
          (list 'string=? string=?)
          (list 'string->symbol string->symbol)
          (list 'symbol->string symbol->string)
          (list 'substring substring)
          (list 'string-append string-append)
          (list 'string-length string-length)
          (list 'error error)
          (list 'append append)
          ;incorrect, from ex_4.14
          ;(list 'map map)

          ;more primitives
          ))
          
(define (primitive-procedure-names) (map car primitive-procedures))
(define (primitive-procedure-objects)
    (map (lambda (proc) (list 'primitive (cadr proc)))
         primitive-procedures))

(define (primitive-procedure? proc) (tagged-list? proc 'primitive))
(define (primitive-implementation proc) (cadr proc))

(define (apply-primitive-procedure proc args)
    (apply-in-underlying-scheme
        (primitive-implementation proc) args))

;REPL
(define input-prompt ";;; Amb-Eval input:")
(define output-prompt ";;; Amb-Eval value:")

(define (prompt-for-input string)
    (newline) (newline) (display string) (newline))
(define (announce-output string)
    (newline) (display string) (newline))
(define (user-print object)
    (if (compound-procedure? object)
        (display (list 'compound-procedure
                       (procedure-parameters object)
                       (procedure-body object)
                       '<procedure-env>))
        (display object)))

(define (driver-loop)
    (define (internal-loop try-again)
        (prompt-for-input input-prompt)
        (let ((input (read)))
            (if (eq? input 'try-again)
                (try-again)
                (begin
                    (newline)
                    (display ";;; Starting a new problem ")
                    (ambeval input
                             the-global-environment
                             ;; ambeval success
                             (lambda (val next-alternative)
                                (announce-output output-prompt)
                                (user-print val)
                                (internal-loop next-alternative))
                             ;; ambeval failure
                             (lambda ()
                                (announce-output
                                 ";;; There are no more values of")
                                 (user-print input)
                                 (driver-loop)))))))
    (internal-loop
        (lambda ()
            (newline)
            (display ";;; There is no current problem")
            (driver-loop))))

(define the-global-environment (setup-environment))