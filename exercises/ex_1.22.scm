(load "prime.scm")

(define (timed-prime-test n)
    (newline)
    (display n)
    (start-prime-test n (runtime)))

(define (start-prime-test n start-time)
    (if (prime? n)
        (report-prime (- (runtime) start-time))))

(define (report-prime elapsed-time)
    (display " *** ")
    (display (* elapsed-time 1000))) ; in ms

(timed-prime-test 98764321261)


(define (search-for-primes a b)
    (define (search-next n)
        (timed-prime-test n)
        (if (< n b) (search-next (+ n 1))))
    (search-next a))

;(search-for-primes 100000000 100001000) ; 10ms
;(search-for-primes 1000000000 1000001000) ; 40ms
;(search-for-primes 10000000000 10000001000) ; 120ms

