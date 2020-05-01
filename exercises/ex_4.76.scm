(load "evaluator-logic.scm")

(define (empty-frame? frame) (null? frame))
(define (next-bindings frame) (cdr frame))

(define (unify-frame f1 f2)
    (define (unify frame rest)
        (cond ((eq? frame 'failed) 'failed)
              ((empty-frame? rest) frame)
              (else
                (let ((var (binding-variable (car rest)))
                      (val (binding-value (car rest))))
                    (unify (extend-if-possible var val frame)
                           (next-bindings rest))))))
    (unify f1 f2))

(define (unify-streams-cartesian s1 s2)
    (stream-flatmap
        (lambda (f1)
            (stream-flatmap
                (lambda (f2)
                    (let ((merged (unify-frame f1 f2)))
                        (if (eq? 'failed merged)
                            the-empty-stream
                            (singleton-stream merged))))
                s2))
            s1))

; fold right, leads to "not" problems (not-query will always produce empty)
(define (conjoin conjuncts frame-stream)
    (if (empty-conjunction? conjuncts)
        frame-stream
        (unify-streams-cartesian 
            (qeval (first-conjunction conjuncts) frame-stream)
            (conjoin (rest-conjunctions conjuncts) frame-stream))))

; fold left, same problem
(define (conjoin conjuncts frame-stream)
    (fold-left unify-streams-cartesian
               (singleton-stream '())
               (map (lambda (conjunct)
                        (qeval conjunct frame-stream))
                    conjuncts)))

; fold while pass result streams along
(define (conjoin conjuncts frame-stream)
    (if (empty-conjunction? conjuncts)
        frame-stream
        (conjoin (rest-conjunctions conjuncts)
                 (unify-streams-cartesian
                    frame-stream
                    (qeval (first-conjunction conjuncts) frame-stream)))))

(put 'and 'qeval conjoin)