(define (call-the-cops . args)
    (display "Cops comming!"))

(define (make-account balance password)

    (define (withdraw amount)
        (if (>= balance amount)
            (begin (set! balance (- balance amount)) balance)
            "Insufficient funds"))
    
    (define (deposit amount)
        (set! balance (+ balance amount))
        balance)
    
    (let ((incorrect-cnt 0))
        (define (dispatch pwd m)
            (cond ((eq? pwd password)
                   (set! incorrect-cnt 0)
                   (cond ((eq? m 'withdraw) withdraw)
                          ((eq? m 'deposit) deposit)
                          (else (error "Unknown request -- MAKE-ACCOUNT" m))))
                  (else
                   (set! incorrect-cnt (+ incorrect-cnt 1))
                   (if (> incorrect-cnt 7)
                       call-the-cops
                       (error "Incorrect password")))))
        dispatch))

(define acc (make-account 100 'woofylove))

((acc 'woofylove 'withdraw) 40)

((acc 'woofylove 'deposit) 5)

((acc 'woofyhate 'withdraw) 60)
((acc 'woofyhate 'withdraw) 60)
((acc 'woofyhate 'withdraw) 60)
((acc 'woofyhate 'withdraw) 60)
((acc 'woofyhate 'withdraw) 60)
((acc 'woofyhate 'withdraw) 60)
((acc 'woofyhate 'withdraw) 60)
((acc 'woofyhate 'withdraw) 60)

((acc 'woofyhate 'withdraw) 60)

((acc 'woofylove 'deposit) 5)
((acc 'woofylove'withdraw) 60)