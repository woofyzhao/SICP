(load "common.scm")

(define (check-last solution)
    (define (check next last-pos k)
        (if (null? next) 
            true
            (and (!= (car next) last-pos)
                 (!= (car next) (+ last-pos k))
                 (!= (car next) (- last-pos k))
                 (check (cdr next) last-pos (+ k 1)))))
    (check (cdr solution) (car solution) 1))

(define (queens n)
    (define (queens-in-rows k)
        (if (= k 0)
            (list nil)
            (flatmap (lambda (solution)
                        (filter check-last
                                (map (lambda (i) (cons i solution))
                                     (enumerate-interval 1 n))))
                     (queens-in-rows (- k 1)))))
    (queens-in-rows n))


(queens 4)
(queens 5)
(length (queens 5))
(queens 8)
(length (queens 8))
(queens 10)
(length (queens 10)) ;724


    