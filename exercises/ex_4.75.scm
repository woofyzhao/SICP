(load "evaluator-logic.scm")

(define (unique-query exps) (car exps))

(define (exactly-one-item? stream)
    (and (not (stream-null? stream))
         (stream-null? (stream-cdr stream))))

(define (uniquely-asserted operands frame-stream)
    (stream-flatmap
        (lambda (frame)
            (let ((result (qeval (unique-query operands)
                                 (singleton-stream frame))))
                (if (exactly-one-item? result)
                    result
                    the-empty-stream)))
        frame-stream))

(put 'unique 'qeval uniquely-asserted)

; (unique (job ?x (computer wizard)))
; (unique (job ?x (computer programmer)))
; (and (job ?x ?j) (unique (job ?anyone ?j)))
; (and (supervisor ?x ?y) (unique (supervisor ?anyone ?y)))