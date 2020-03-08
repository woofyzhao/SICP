(load "evaluator2.scm")

(define e the-global-environment)

(eval '(define (f x) (+ x 1)) e)

(user-print (lookup-variable-value 'f e))

(define exp '(f 1))

(display 'operator:)
(user-print (operator exp))

(define fproc (analyze (operator exp)))

(define proc (fproc e))

(compound-procedure? proc)
(user-print proc)

(define e1 (extend-environment '(x) '(10) e))
(user-print (procedure-body proc))

((analyze-sequence '((+ x 1))) e1) ;11

((procedure-body proc) e1)

;((procedure-body proc) 
; (extend-environment
;                (procedure-parameters proc)
;                '(10)
;                (procedure-environment proc)))

;(execute-application p '(10))

;((analyze '(f 1)) e)

