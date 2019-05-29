(define (gcd a b)
    (if (= b 0)
        a
        (gcd b (remainder a b))))

(gcd 206 40)

; applicative-order evaluation
(gcd 206 40)
(gcd 40 (remainder 206 40)) ; +1
(gcd 40 6)
(gcd 6 (remainder 40 6)) ; +1
(gcd 6 4)
(gcd 4 (remainder 6 4)) ; +1
(gcd 4 2)
(gcd 2 (remainder 4 2)) ; +1
(gcd 2 0)
2

; total #remainder ops = 1 + 1 + 1 + 1 = 4

; normal-order evaluation
(gcd 206 40)
(gcd 40 (remainder 206 40))
(if (= (remainder 206 40) 0)  ; +1
    40 
    (gcd (remainder 206 40) (remainder 40 (remainder 206 40))))

; a <- (remainder 206 40)
; b <- (remainder 40 (remainder 206 40))
(gcd (remainder 206 40) (remainder 40 (remainder 206 40)))

(if (= (remainder 40 (remainder 206 40)) 0); +2
    (remainder 206 40)
    (gcd (remainder 40 (remainder 206 40)) 
         (remainder (remainder 206 40) (remainder 40 (remainder 206 40)))))

; a <- (remainder 40 (remainder 206 40)) 
; b <- (remainder (remainder 206 40) (remainder 40 (remainder 206 40)))
; + 4

; a <- (remainder (remainder 206 40) (remainder 40 (remainder 206 40))) ; 2
; b <- (remainder (remainder 40 (remainder 206 40)) 
;                 (remainder (remainder 206 40) (remainder 40 (remainder 206 40))))) ; 0
; + 7 (eval b)
; + 4 (eval a)
; 

2

(display "End")

; total #remainder ops = 1 + 2 + 4 + 7 + 4 = 18
