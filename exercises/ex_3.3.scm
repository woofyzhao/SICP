(define (make-account balance password)

    (define (withdraw amount)
        (if (>= balance amount)
            (begin (set! balance (- balance amount)) balance)
            "Insufficient funds"))
    
    (define (deposit amount)
        (set! balance (+ balance amount))
        balance)
    
    (define (dispatch pwd m)
        (if (eq? pwd password)
            (cond ((eq? m 'withdraw) withdraw)
                  ((eq? m 'deposit) deposit)
                  (else (error "Unknown request -- MAKE-ACCOUNT" m)))
            (error "Incorrect password")))
    
    dispatch)

(define acc (make-account 100 'woofylove))

((acc 'woofylove 'withdraw) 40)

((acc 'woofylove 'deposit) 5)

((acc 'woofyhate 'withdraw) 60)