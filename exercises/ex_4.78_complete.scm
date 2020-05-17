;;; Implement the logic language as an application program in the amb language
;;; That is, we first define our logic evaluator in the Amb driver loop
;;; Then we start our logic driver loop
;;; Then we define assertions and rules and evaluate patterns
;;; So in the end there are two driver loops at play during runtime,
;;; with the logic driver loop being nested in the Amb driver loop!

;;; REPL: Read-Eval-Print Loop (Driver Loop)

; 1. Start the amb evaluator: (Type in scheme REPL)
(load "ex_4.78_amb_evaluator.scm")
(driver-loop)

; 2. Define the dependant procedures: (Type in Amb REPL)

; common utils
(define (require p) (if (not p) (amb) 'ok))

(define (an-element-of s)
    (require (not (null? s)))
    (amb (car s) (an-element-of (cdr s))))

; 2.1 table definition (muti-dimension table from ex_3.25)
(define (assoc key records)
    (cond ((null? records) false)
          ((equal? key (caar records)) (car records))
          (else (assoc key (cdr records)))))

(define (make-table)
    (let ((local-table (list '*table*)))
        (define (assoc keys records)
            (cond ((null? records) false)
                  ((not (pair? records)) false)
                  ((not (pair? (car records))) false)
                  ((equal? (car keys) (caar records)) 
                    (if (null? (cdr keys)) 
                        (car records) 
                        (assoc (cdr keys) (cdar records))))
                  (else (assoc keys (cdr records)))))
        (define (lookup keys)
            (let ((record (assoc keys (cdr local-table))))
                (if record
                    (cdr record)
                    false)))
        (define (insert! keys value)
            (define (insert-or-update! remaining-keys table)
                (let ((subtable (assoc (list (car remaining-keys)) (cdr table))))
                    (if subtable
                        (if (null? (cdr remaining-keys))
                            (set-cdr! subtable value)
                            (insert-or-update! (cdr remaining-keys) subtable))
                        (begin
                            (let ((new-subtable (list (car remaining-keys))))
                                (set-cdr! table (cons new-subtable (cdr table)))
                                (insert-or-update! remaining-keys table))))))
            (insert-or-update! keys local-table)
            'ok)
        (define (dispatch m)
            (cond ((eq? m 'lookup) lookup)
                  ((eq? m 'insert!) insert!)
                  (else (error "Unknown table operation " m))))
        dispatch))

; 2.2 runtime table for logic language
(define runtime-table (make-table))
(define (put key1 key2 item)
    ((runtime-table 'insert!) (list key1 key2) item))
(define (get key1 key2)
    ((runtime-table 'lookup) (list key1 key2)))

; 3. Define the logic evaluator itself (Type in Amb REPL)

; The modified places of the stream approach are marked with *** below

; 3.1 Define the driver loop
(define input-prompt ";;; Logic-Query input:")
(define output-prompt ";;; Logic-Query results:")
(define (prompt-for-input string)
    (newline) (newline) (display string) (newline))

(define the-empty-frame '())

(define (query-driver-loop)
    (prompt-for-input input-prompt)
    (let ((q (query-syntax-process (read))))
        (cond ((eq? q 'try-again) (amb)) ; *** response to try-again as requested
              ((assertion-to-be-added? q)
               (add-rule-or-assertion! (add-assertion-body q))
               (newline)
               (display "Assertion added to data base.")
               (query-driver-loop))
              (else
               (newline)
               (display output-prompt)
               (newline)
               (display ; *** one instance at a time
                (instantiate q
                             (qeval q the-empty-frame)
                             (lambda (v f)
                                     (contract-question-mark v))))
               (query-driver-loop)))))

(define (instantiate exp frame unbound-var-handler)
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

; 3.2 the core procedures for logic language

; 3.2.1 the data-driven dispatcher
(define (qeval query frame)
    (let ((qproc (get (type query) 'qeval)))
        (if qproc
            (qproc (contents query) frame)
            (simple-query query frame))))

; *** match either an assertion or a rule
(define (simple-query query-pattern frame)
    (amb (find-assertions query-pattern frame)
         (apply-rules query-pattern frame)))

(define (conjoin conjuncts frame)
    (if (empty-conjunction? conjuncts)
        frame
        (conjoin (rest-conjunctions conjuncts)
                 (qeval (first-conjunction conjuncts) frame))))

(put 'and 'qeval conjoin)

; *** match any of the OR disjunct
(define (disjoin disjuncts frame)
    (qeval (an-element-of disjuncts) frame))

(put 'or 'qeval disjoin)

; *** ensure failure
(define (negate operands frame)
    (let ((result 'failed))
        (if-fail 
            (begin
                (qeval (negated-query operands) frame)
                (permanent-set! result 'success)
                (amb))  ; exhaust the alternatives in case of success matches
            'ok)
        (if (eq? result 'failed)
            frame
            (amb))))

; *** or we can use a special form require-fail dedicated for negation:
(define (negate operands frame)
    (require-fail (qeval (negated-query operands) frame))
    frame)

(put 'not 'qeval negate)

; *** using require
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

; *** Install apply, eval and user-initial-environment in the amb evaluator
; At the end of the day, we should be dealing something like:
; (apply apply (list (eval '> user-initial-environment) (list 2 1)))
; for (lisp-value > 2 1) in the logic language
(define (execute exp)
    (apply (eval (predicate exp) user-initial-environment)
           (args exp)))

(define (always-true ignore frame) frame)

(put 'always-true 'qeval always-true)

; 3.2.2 pattern matching and unification

; *** match one of the assertions
(define (find-assertions pattern frame)
    (let ((datum (an-element-of (fetch-assertions pattern frame))))
        (check-an-assertion datum pattern frame)))

(define (check-an-assertion assertion query-pat query-frame)
    (pattern-match query-pat assertion query-frame))

; *** use (amb) to fail directly instead of tagging 'failed symbol
(define (pattern-match pat dat frame)
    (cond ((equal? pat dat) frame)
          ((var? pat) (extend-if-consistent pat dat frame))
          ((and (pair? pat) (pair? dat))
           (pattern-match (cdr pat)
                          (cdr dat)
                          (pattern-match (car pat)
                                         (car dat)
                                         frame)))
          (else (amb))))

(define (extend-if-consistent var dat frame)
    (let ((binding (binding-in-frame var frame)))
        (if binding
            (pattern-match (binding-value binding) dat frame)
            (extend var dat frame))))

; *** apply one of the rules
(define (apply-rules pattern frame)
    (let ((rule (an-element-of (fetch-rules pattern frame))))
        (apply-a-rule rule pattern frame)))

; *** no need to filter 'failed tags
(define (apply-a-rule rule query-pattern query-frame)
    (let ((clean-rule (rename-variables-in rule)))
        (let ((unify-result
                (unify-match query-pattern
                             (conclusion clean-rule)
                             query-frame)))
            (qeval (rule-body clean-rule) unify-result))))

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

; *** use (amb) to fail directly 
(define (unify-match p1 p2 frame)
    (cond ((equal? p1 p2) frame)
          ((var? p1) (extend-if-possible p1 p2 frame))
          ((var? p2) (extend-if-possible p2 p1 frame))
          ((and (pair? p1) (pair? p2))
           (unify-match (cdr p1)
                        (cdr p2)
                        (unify-match (car p1)
                                     (car p2)
                                     frame)))
          (else (amb))))

; *** use (amb) to fail directly
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
               (amb))
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

; 3.3 data base organization
; *** use list instead of streams for all the following
; *** use permanent-set! instead of set! because we don't need trackback 
;     for assertion definitions

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
    (permanent-set! THE-ASSERTIONS
          (cons assertion THE-ASSERTIONS))
    'ok)

(define (add-rule! rule)
    (store-rule-in-index rule)
    (permanent-set! THE-RULES
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

; 3.4 syntax procedures

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

(define (tagged-list? exp tag)
    (if (pair? exp)
        (eq? (car exp) tag)
        false))

(define (var? exp)
    (tagged-list? exp '?))

(define (constant-symbol? exp) (symbol? exp))

; unique variable id
(define rule-counter 0)

(define (new-rule-application-id)
    (permanent-set! rule-counter (+ 1 rule-counter))
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

; 4. Finall, test our logic language implemented using amb evaluator:

; 4.1 Start the Logic REPL (Type in Amb REPL)
(query-driver-loop)

; 4.2 Test microshaft 

; Input the assertions and rules of microshaft (Type in Logic REPL)

; microshaft assertions
(assert! (address (Bitdiddle Ben) (Slumerville (Ridge Road) 10)))
(assert! (job (Bitdiddle Ben) (computer wizard)))
(assert! (salary (Bitdiddle Ben) 60000))
(assert! (supervisor (Bitdiddle Ben) (Warbucks Oliver)))

(assert! (address (Hacker Alyssa P) (Cambridge (Mass Ave) 78)))
(assert! (job (Hacker Alyssa P) (computer programmer)))
(assert! (salary (Hacker Alyssa P) 40000))
(assert! (supervisor (Hacker Alyssa P) (Bitdiddle Ben)))

(assert! (address (Fect Cy D) (Cambridge (Ames Street) 3)))
(assert! (job (Fect Cy D) (computer programmer)))
(assert! (salary (Fect Cy D) 35000))
(assert! (supervisor (Fect Cy D) (Bitdiddle Ben)))

(assert! (address (Tweakit Lem E) (Boston (Bay State Road) 22)))
(assert! (job (Tweakit Lem E) (computer technician)))
(assert! (salary (Tweakit Lem E) 25000))
(assert! (supervisor (Tweakit Lem E) (Bitdiddle Ben)))

(assert! (address (Reasoner Louis) (Slumerville (Pine Tree Road) 80)))
(assert! (job (Reasoner Louis) (computer programmer trainee)))
(assert! (salary (Reasoner Louis) 30000))
(assert! (supervisor (Reasoner Louis) (Hacker Alyssa P)))

(assert! (address (Warbucks Oliver) (Swellesley (Top Heap Road))))
(assert! (job (Warbucks Oliver) (administration big wheel)))
(assert! (salary (Warbucks Oliver) 150000))

(assert! (address (Scrooge Eben) (Weston (Shady Lane) 10)))
(assert! (job (Scrooge Eben) (accounting chief accountant)))
(assert! (salary (Scrooge Eben) 75000))
(assert! (supervisor (Scrooge Eben) (Warbucks Oliver)))

(assert! (address (Cratchet Robert) (Allston (N Harvard Street) 16)))
(assert! (job (Cratchet Robert) (accounting scrivener)))
(assert! (salary (Cratchet Robert) 18000))
(assert! (supervisor (Cratchet Robert) (Scrooge Eben)))

(assert! (address (Aull DeWitt) (Slumerville (Onion Square) 5)))
(assert! (job (Aull DeWitt) (administration secretary)))
(assert! (salary (Aull DeWitt) 25000))
(assert! (supervisor (Aull DeWitt) (Warbucks Oliver)))

(assert! (can-do-job (computer wizard) (computer programmer)))
(assert! (can-do-job (computer wizard) (computer technician)))
(assert! (can-do-job (computer programmer) (computer programmer trainee)))
(assert! (can-do-job (administration secretary) (administration big wheel)))

; microshaft rules
(assert! (rule (lives-near ?person-1 ?person-2)
            (and (address ?person-1 (?town . ?rest-1))
                 (address ?person-2 (?town . ?rest-2))
                 (not (same ?person-1 ?person-2)))))

(assert! (rule (same ?x ?x)))

(assert! (rule (wheel ?person)
            (and (supervisor ?middle-manager ?person)
                 (supervisor ?x ?middle-manager))))

(assert! (rule (outranked-by ?staff-person ?boss)
            (or (supervisor ?staff-person ?boss)
                (and (supervisor ?staff-person ?middle-manager)
                     (outranked-by ?middle-manager ?boss)))))

; test pattern
(lives-near ?x ?y)

; test output: ... (verified, just run it to see)

; 4.2 Test append rules

; Input the assertions and rules of microshaft (Type in Logic REPL)

(assert! (rule (append-to-form () ?y ?y)))
(assert! (rule (append-to-form (?u . ?v) ?y (?u . ?z))
            (append-to-form ?v ?y ?z)))

; test pattern
(append-to-form ?x ?y (a b c d))

; test otuput:
; ...
Assertion added to data base.

;;; Logic-Query input:
(append-to-form ?x ?y (a b c d))

;;; Logic-Query results:
(append-to-form (a b c d) () (a b c d))

;;; Logic-Query input:
try-again
(append-to-form (a b c) (d) (a b c d))

;;; Logic-Query input:
try-again
(append-to-form (a b) (c d) (a b c d))

;;; Logic-Query input:
try-again
(append-to-form (a) (b c d) (a b c d))

;;; Logic-Query input:
try-again
(append-to-form () (a b c d) (a b c d))

;;; Logic-Query input:
try-again

;;; There are no more values of
(query-driver-loop)

;;; Amb-Eval input: