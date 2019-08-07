; ex_2.24
; (1 (2 (3 4)))

; ex_2.25
(define s (list 1 3 (list 5 7) 9))
s
(car (cdr (car (cdr (cdr s)))))

(define s (list (list 7)))
s
(car (car s))

(define s (list 1 (list 2 (list 3 (list 4 (list 5 (list 6 7)))))))
s
(cadr (cadr (cadr (cadr (cadr (cadr s))))))

; ex_2.26
(define x (list 1 2 3))
(define y (list 4 5 6))

(append x y)
; (1 2 3 4 5 6)

(cons x y)
; ((1 2 3) 4 5 6)

(list x y)
; ((1 2 3) (4 5 6))