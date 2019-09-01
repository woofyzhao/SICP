
(list 'a 'b 'c); (a b c)
(list (list 'george)); ((george))
(cdr '((x1 x2) (y1 y2))); ((y1 y2))
(cadr '((x1 x2) (y1 y2))); (y1 y2)
(pair? (car '(a short list))); #f
(memq 'red '((red shoes) (blue socks))); #f
(memq 'red '(red shoes blue socks)); (red shoes blue socks)

; are numbers equvalant to their symbol form? seems yes in mit-scheme
(define a 100)
(= a 100)
(= a '100)
(= 100 '100)
(eq? 100 '100)
(eq? a 100)

; number in symbol form is number
(number? '100)
(number? a)

; but number in symbol form is not symbol
(symbol? '100); false

; so numbers in symbol form are just numbers?

; can the = operate on symbol?
(= 'a 'a); no
