(load "ex_1.22.scm")

(define (start-prime-test n start-time)
    (if (fermat-test n)
        (report-prime (- (runtime) start-time))))

;(timed-prime-test 100000007)
;(timed-prime-test 1000000007)
;(timed-prime-test 10000000019)
;(timed-prime-test 98764321261)
;(timed-prime-test 900000000013)