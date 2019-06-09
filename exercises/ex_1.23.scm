(load "ex_1.22.scm")

(define (next test-divisor)
    (if (= test-divisor 2) 
        3 
        (+ test-divisor 2)))

(define (find-divisor n test-divisor)
    (cond ((> (square test-divisor) n) n) 
          ((divides? test-divisor n) test-divisor)
          (else (find-divisor n (next test-divisor)))))

(timed-prime-test 100000007); 10ms
(timed-prime-test 1000000007); 20ms
(timed-prime-test 10000000019); 70ms
(timed-prime-test 98764321261); 220ms
; about 2/3 time
; 1.5 speedup other than 2, due to the extra if test in next 

(timed-prime-test 900000000013); 660ms
; about 1/2 time
