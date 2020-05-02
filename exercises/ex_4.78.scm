(load "common.scm")
(load "table.scm")

; 2-dim table for runtime
(define runtime-table (make-table))
(define (put key1 key2 item)
    ((runtime-table 'insert!) (list key1 key2) item))
(define (get key1 key2)
    ((runtime-table 'lookup) (list key1 key2)))

; evaluator core

(define input-prompt ";;; Query input:")
(define output-prompt ";;; Query results:")
(define (prompt-for-input string)
    (newline) (newline) (display string) (newline))

(define the-empty-frame '())

(define (query-driver-loop)
    (prompt-for-input input-prompt)
    (let ((q (query-syntax-process (read))))
        (cond ((eq? q 'quit) 'bye-bye)
              ((assertion-to-be-added? q)
               (add-rule-or-assertion! (add-assertion-body q))
               (newline)
               (display "Assertion added to data base.")
               (query-driver-loop))
              (else
               (newline)
               (display output-prompt)
               (display
                (instantiate q
                             (qeval q the-empty-frame)
                             (lambda (v f)
                                     (contract-question-mark v))))
               (query-driver-loop)))))

(define (instantiate exp frame unbound-var-handler)
    (require (not (eq? 'failed frame)))
    (define (copy exp)
        (cond ((var? exp)
               (let ((binding (binding-in-frame exp frame)))
                (if binding
                    (copy (binding-value binding))
                    (unbound-var-handler exp frame))))
              ((pair? exp)
               (cons (copy (car exp)) (copy (cdr exp))))
              (else exp)))
    (copy exp))

(define (qeval query frame)
    (let ((qproc (get (type query) 'qeval)))
        (if qproc
            (qproc (contents query) frame)
            (simple-query query frame))))

(define (simple-query query-pattern frame)
    (amb (find-assertions query-pattern frame)
         (apply-rules query-pattern frame)))

(define (conjoin conjuncts frame)
    (if (empty-conjunction? conjuncts)
        frame
        (conjoin (rest-conjunctions conjuncts)
                 (qeval (first-conjunction conjuncts) frame))))

(put 'and 'qeval conjoin)

(define (disjoin disjuncts frame)
    (qeval (an-element-of disjuncts) frame))

(put 'or 'qeval disjoin)

(define (negate operands frame)
    (require
        (eq? 'failed 
             (qeval (negated-query operands) frame)))
    frame)

(put 'not 'qeval negate)

(define (lisp-value call frame)
    (require
        (execute
            (instantiate 
                call
                frame
                (lambda (v f)
                    (error "Unknown pat var -- LISP-VALUE" v)))))
    frame)

(put 'lisp-value 'qeval lisp-value)

(define (execute exp)
    (apply (eval (predicate exp) user-initial-environment)
           (args exp)))

(define (always-true ignore frame) frame)

(put 'always-true 'qeval always-true)

(define (find-assertions pattern frame)
    (let ((datum (an-element-of (fetch-assertions pattern frame))))
        (check-an-assertion datum pattern frame)))

(define (check-an-assertion assertion query-pat query-frame)
    (pattern-match query-pat assertion query-frame))

(define (pattern-match pat dat frame)
    (cond ((eq? frame 'failed) 'failed)
          ((equal? pat dat) frame)
          ((var? pat) (extend-if-consistent pat dat frame))
          ((and (pair? pat) (pair? dat))
           (pattern-match (cdr pat)
                          (cdr dat)
                          (pattern-match (car pat)
                                         (car dat)
                                         frame)))
          (else 'failed)))

(define (extend-if-consistent var dat frame)
    (let ((binding (binding-in-frame var frame)))
        (if binding
            (pattern-match (binding-value binding) dat frame)
            (extend var dat frame))))

(define (apply-rules pattern frame)
    (let ((rule (an-element-of (fetch-rules pattern frame))))
        (apply-a-rule rule pattern frame)))

(define (apply-a-rule rule query-pattern query-frame)
    (let ((clean-rule (rename-variables-in rule)))
        (let ((unify-result
                (unify-match query-pattern
                             (conclusion clean-rule)
                             query-frame)))
            (if (eq? unify-result 'failed)
                'failed
                (qeval (rule-body clean-rule) unify-result)))))

(define (rename-variables-in rule)
    (let ((rule-application-id (new-rule-application-id)))
        (define (tree-walk exp)
            (cond ((var? exp)
                   (make-new-variable exp rule-application-id))
                  ((pair? exp)
                   (cons (tree-walk (car exp))
                         (tree-walk (cdr exp))))
                  (else exp)))
        (tree-walk rule)))

(define (unify-match p1 p2 frame)
    (cond ((eq? frame 'failed) 'failed)
          ((equal? p1 p2) frame)
          ((var? p1) (extend-if-possible p1 p2 frame))
          ((var? p2) (extend-if-possible p2 p1 frame))
          ((and (pair? p1) (pair? p2))
           (unify-match (cdr p1)
                        (cdr p2)
                        (unify-match (car p1)
                                     (car p2)
                                     frame)))
          (else 'failed)))

(define (extend-if-possible var val frame)
    (let ((binding (binding-in-frame var frame)))
        (cond (binding
                (unify-match 
                    (binding-value binding) val frame))
              ((var? val)
               (let ((binding (binding-in-frame val frame)))
                (if binding
                    (unify-match
                        var (binding-value binding) frame)
                    (extend var val frame))))
              ((depends-on? val var frame)
               'failed)
              (else (extend var val frame)))))

(define (depends-on? exp var frame)
    (define (tree-walk e)
        (cond ((var? e)
               (if (equal? var e)
                   true
                   (let ((b (binding-in-frame e frame)))
                    (if b
                        (tree-walk (binding-value b))
                        false))))
              ((pair? e)
               (or (tree-walk (car e))
                   (tree-walk (cdr e))))
              (else false)))
    (tree-walk exp))

; data base organization

; assertions
(define THE-ASSERTIONS '())

(define (fetch-assertions pattern frame)
    (if (use-index? pattern)
        (get-indexed-assertions pattern)
        (get-all-assertions)))

(define (get-all-assertions) THE-ASSERTIONS)

(define (get-indexed-assertions pattern)
    (get-list (index-key-of pattern) 'assertions))

(define (get-list key1 key2)
    (let ((s (get key1 key2)))
        (if s s '())))

; rules
(define THE-RULES '())

(define (fetch-rules pattern frame)
    (if (use-index? pattern)
        (get-indexed-rules pattern)
        (get-all-rules)))

(define (get-all-rules) THE-RULES)

(define (get-indexed-rules pattern)
    (append
        (get-list (index-key-of pattern) 'rules)
        (get-list '? 'rules)))

; store procedures
(define (add-rule-or-assertion! assertion)
    (if (rule? assertion)
        (add-rule! assertion)
        (add-assertion! assertion)))

(define (add-assertion! assertion)
    (store-assertion-in-index assertion)
    (set! THE-ASSERTIONS
          (cons assertion THE-ASSERTIONS))
    'ok)

(define (add-rule! rule)
    (store-rule-in-index rule)
    (set! THE-RULES
         (cons rule THE-RULES))
    'ok)

(define (store-assertion-in-index assertion)
    (if (indexable? assertion)
        (let ((key (index-key-of assertion)))
            (let ((current-assertion-list 
                   (get-list key 'assertions)))
                (put key
                     'assertions
                     (cons assertion
                           current-assertion-list))))))

(define (store-rule-in-index rule)
    (let ((pattern (conclusion rule)))
        (newline)
        (if (indexable? pattern)
            (let ((key (index-key-of pattern)))
                (let ((current-rule-list 
                      (get-list key 'rules)))
                    (put key
                        'rules
                        (cons rule
                              current-rule-list)))))))

(define (indexable? pat)
    (or (constant-symbol? (car pat))
        (var? (car pat))))

(define (index-key-of pat)
    (let ((key (car pat)))
        (if (var? key) '? key)))

(define (use-index? pat)
    (constant-symbol? (car pat)))

; query syntax procedures
(define (type exp)
    (if (pair? exp)
        (car exp)
        (error "Unknown expresstion TYPE"  exp)))

(define (contents exp)
    (if (pair? exp)
        (cdr exp)
        (error "Unknown expresstion CONTENTS"  exp)))

; assertions
(define (assertion-to-be-added? exp)
    (eq? (type exp) 'assert!))

(define (add-assertion-body exp)
    (car (contents exp)))

; specail forms
(define (empty-conjunction? exps) (null? exps))
(define (first-conjunction exps) (car exps))
(define (rest-conjunctions exps) (cdr exps))
(define (empty-disjunction? exps) (null? exps))
(define (first-disjunction exps) (car exps))
(define (rest-disjunctions exps) (cdr exps))
(define (negated-query exps) (car exps))
(define (predicate exps) (car exps))
(define (args exps) (cdr exps))

; rules
(define (rule? statement)
    (tagged-list? statement 'rule))
(define (conclusion rule) (cadr rule))
(define (rule-body rule)
    (if (null? (cddr rule))
        '(always-true)
        (caddr rule)))

; variables
(define (query-syntax-process exp)
    (map-over-symbols expand-question-mark exp))

(define (map-over-symbols proc exp)
    (cond ((pair? exp)
           (cons (map-over-symbols proc (car exp))
                 (map-over-symbols proc (cdr exp))))
          ((symbol? exp) (proc exp))
          (else exp)))

(define (expand-question-mark symbol)
    (let ((chars (symbol->string symbol)))
        (if (string=? (substring chars 0 1) "?")
            (list '?
                  (string->symbol
                    (substring chars 1 (string-length chars))))
            symbol)))

(define (var? exp)
    (tagged-list? exp '?))

(define (constant-symbol? exp) (symbol? exp))

; unique variable id

(define rule-counter 0)

(define (new-rule-application-id)
    (set! rule-counter (+ 1 rule-counter))
    rule-counter)

(define (make-new-variable var rule-application-id)
    (cons '? (cons rule-application-id (cdr var))))

(define (contract-question-mark variable)
    (string->symbol
        (string-append "?"
            (if (number? (cadr variable))
                (string-append (symbol->string (caddr variable))
                               "-"
                               (number->string (cadr variable)))
                (symbol->string (cadr variable))))))
; frame
(define (make-binding variable value)
    (cons variable value))

(define (binding-variable binding)
    (car binding))

(define (binding-value binding)
    (cdr binding))

(define (binding-in-frame variable frame)
    (assoc variable frame))

(define (extend variable value frame)
    (cons (make-binding variable value) frame))
