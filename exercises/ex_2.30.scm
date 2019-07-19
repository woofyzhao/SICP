(load "common.scm")

(define (square-tree tree)
    (cond ((null? tree) nil)
          ((pair? tree) (cons (square-tree (car tree)) (square-tree (cdr tree))))
          (else (square tree))))

(define tree (list 1 (list 2 (list 3 4) 5) (list 6 7)))

(square-tree tree)

; using  map
(define (square-tree tree)
    (map (lambda (child) 
            (if (pair? child)
                (square-tree child)
                (square child)))
        tree))

(square-tree tree)