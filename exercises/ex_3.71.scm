(load "ex_3.70.scm")

(define (cube-sum pair)
    (+ (cube (car pair))
       (cube (cadr pair))))

(define rama-pairs (pairs integers integers cube-sum))

; not generalized, specific for rama problem
(define (consecutive stream weight)
    (define (iter s)
        (let ((a (stream-car s))
              (b (stream-car (stream-cdr s))))
            (if (= (weight a) (weight b))
                (cons-stream (list (weight a) a b)
                             (iter (stream-cdr (stream-cdr s))))
                (iter (stream-cdr s)))))
    (iter stream))

; more generalized
; return stream of (weight, (item1, item2, ...))* 
(define (consecutive stream n weight)
    (define (eager-iter s w items)
        (if (= w (weight (stream-car s)))
            (eager-iter (stream-cdr s) w (cons (stream-car s) items))
            (list s items)))
    (let ((next (eager-iter stream (weight (stream-car stream)) '())))
        (let ((stream-rest (car next))
              (items (cadr next)))
            (if (>= (length items) n)
                (cons-stream (list (weight (stream-car stream)) items)
                             (consecutive stream-rest n weight))
                (consecutive stream-rest n weight)))))

(define rama-nums (consecutive rama-pairs 2 cube-sum))

(to-slice rama-nums 0 20)