(load "prime.scm")


(define (nontrival-sqrt? a n)
    (cond ((= a 1) false)
          ((= a (- n 1)) false)
          (else (= (remainder (square a) n) 1))))

(define (expmod-mr base exp m)
    (cond ((= exp 0) 1)
          ((even? exp) 
             (let ((exproot (expmod-mr base (/ exp 2) m)))
                (if (nontrival-sqrt? exproot m)
                    0
                    (remainder (square exproot) m))))
          (else (remainder (* base (expmod-mr base (- exp 1) m)) m))))

(define (miller-rabin-test n)
    (define (try-it a)
        (= (expmod-mr a (- n 1) n) 1))
    (try-it (+ 1 (random (- n 1)))))

(define (mr-fast-prime? n times)
    (cond ((= times 0) true)
          ((miller-rabin-test n) (fast-prime? n (- times 1)))
          (else false)))

(fermat-test 997427)
(fermat-test 98764321261)
(miller-rabin-test 997427)
(miller-rabin-test 98764321261)

(mr-fast-prime? 997427 2000)
(mr-fast-prime? 98764321261 2000)

; carmichaels
(display "fermat: ")
(fast-prime? 561 561)
(fast-prime? 1105 1105)
(fast-prime? 1729 1729)
(fast-prime? 2465 2465)
(fast-prime? 2821 2821)
(fast-prime? 6601 6601)
(display "miller-rabin: ")
(mr-fast-prime? 561 561)
(mr-fast-prime? 1105 1105)
(mr-fast-prime? 1729 1729)
(mr-fast-prime? 2465 2465)
(mr-fast-prime? 2821 2821)
(mr-fast-prime? 6601 6601)