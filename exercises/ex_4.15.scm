(define (run-forever) (run-forever))

(define (try p)
    (if (halts? p p)
        (run-forever)
        'halted))

(try try)
; if (try try) halts, which means (halts? try try) evaluates to true, then it should run forever
; if (try try) doesn't halt, which means (halts try try) evaluates to false, then it should halt