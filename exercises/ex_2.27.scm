(load "common.scm")

(define (deep-reverse s)
    (define (iter rest result)
        (if (null? rest)
            result
            (iter (cdr rest)
                  (cons (deep-reverse (car rest)) result))))
    (if (not (pair? s))
        s
        (iter s nil)))

(deep-reverse (list (list 1 (list 5 6 7) 2) (list 3 4)))

; solution using append 
(define (deep-reverse s) 
   (if (pair? s) 
       (append (deep-reverse (cdr x))  
               (list (deep-reverse (car x)))) 
       x)) 

; solution using map and reverse
 (define (deep-reverse s) 
   (if (pair? s) 
       (reverse (map deep-reverse s)) 
       s)) 