(load "ex_1.24.scm")

(define (expmod base exp m)
    (remainder (fast-expt base exp) m))

; stuck
(timed-prime-test 100000007)
(timed-prime-test 1000000007)
(timed-prime-test 10000000019)
(timed-prime-test 98764321261)
(timed-prime-test 900000000013)

