(define (make-account balance password)

    (define (protected f)
        (lambda (pwd x)
            (if (eq? pwd password)
                (f x)
                (error "Incorrect password"))))

    (define (withdraw amount)
        (if (>= balance amount)
            (begin (set! balance (- balance amount)) balance)
            "Insufficient funds"))
    
    (define (deposit amount)
        (set! balance (+ balance amount))
        balance)

    (define (auth pwd)
        (eq? password pwd))
    
    (define (dispatch m)
        (cond ((eq? m 'withdraw) (protected withdraw))
              ((eq? m 'deposit) (protected deposit))
              ((eq? m 'auth) auth)
              (else (error "Unknown request -- MAKE-ACCOUNT" m))))
    
    dispatch)

(define (make-joint account orig-pwd joint-pwd)

    (define (protected f)
        (lambda (pwd x)
            (if (eq? pwd joint-pwd)
                (f x)
                (error "Incorrect password"))))

    (define (withdraw amount) ((account 'withdraw) orig-pwd amount))
    (define (deposit amount) ((account 'deposit) orig-pwd amount))
    (define (auth pwd) (eq? pwd joint-pwd))

    (define (dispatch m)
        (cond ((eq? m 'withdraw) (protected withdraw))
              ((eq? m 'deposit) (protected deposit))
              ((eq? m 'auth) auth)
              (else (error "Unknown request -- MAKE-ACCOUNT" m))))

    (if ((account 'auth) orig-pwd)
        dispatch
        (error "Incorrect original password of target account")))

(define peter-acc (make-account 100 'open-sesame))
(define paul-acc (make-joint peter-acc 'open-sesame 'rosebud)) ;joint account
(define woofy-acc (make-joint paul-acc 'rosebud 'longleg)) ; joint joint account

((peter-acc 'withdraw) 'open-sesame 50) ;50
((paul-acc 'withdraw) 'rosebud 10) ;40
((peter-acc 'deposit) 'open-sesame 0) ;40
((woofy-acc 'withdraw) 'longleg 33) ;7
((peter-acc 'deposit) 'open-sesame 0) ;7
