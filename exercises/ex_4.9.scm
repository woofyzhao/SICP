; (while <predicate> <body>)
; for example: (while (< i 100) (display i) (set! i (+ i 1))) is transformed to:
; (define (while-procedure)
;    (if (< i 100)
;        (begin
;            (display i)
;            (set! (+ i 1)
;            (while-procedure)))))

(define (while? exp) (tagged-list? exp 'while))
(define (while-predicate exp) (cadr exp))
(define (while-body exp) (cddr exp))

(define (make-procedure-definition name parameters body)
    (cons 'define  (cons (cons name parameters) body)))
(define (make-procedure-application procedure arguments)
    (cons procedure arguments))

; wrap the procedure definition in a lambda to contrain its scope
(define (while->application exp)

    (define (while->procedure-def procedure-name)
        (make-procedure-definition 
            procedure-name
            '()
            (make-if
                (while-predicate exp)
                (sequence->exp
                    (append (while-body exp)
                            (make-procedure-application procedure-name '()))))))

    (make-procedure-application
        (make-lambda 
            '()
            (list (while->procedure-def 'while-procedure)
                  (make-procedure-application 'while-procedure '())))
        '()))


; the whole thing will be look like:

((lambda ()
    (define (while-procedure)
        (if (< i 100)
            (begin
                (display i)
                (set! (+ i 1)
                (while-procedure)))))
    (while-procedure)))