(load "common.scm")

(define empty-board nil)

(define (adjoin-position row n rest-of-queens)
    (cons row rest-of-queens))

(define (safe? n positions)
    (define (check? row-pos next k)
        (if (null? next)
            true
            (and (!= (car next) row-pos)
                 (!= (car next) (- row-pos k))
                 (!= (car next) (+ row-pos k))
                 (check? row-pos (cdr next) (+ k 1)))))
    (check? (car positions) (cdr positions) 1))

(define (queens board-size)
    (define (queen-cols k)
        (if (= k 0)
            (list empty-board)
            (filter 
                (lambda (positions) (safe? k positions))
                (flatmap
                    (lambda (rest-of-queens)
                        (map (lambda (new-row)
                                (adjoin-position new-row k rest-of-queens))
                             (enumerate-interval 1 board-size)))
                    (queen-cols (- k 1))))))
    (queen-cols board-size))


(queens 4)
(queens 5)
(length (queens 5))
(queens 8)
(length (queens 8))
(queens 10)
(length (queens 10)) ;724


