(load "common.scm")

(define (tree-map f tree)
    (map (lambda (child)
            (if (pair? child)
                (tree-map f child)
                (f child)))
        tree))
    
(define (square-tree tree)
    (tree-map square tree))

(define tree (list 1 (list 2 (list 3 4) 5) (list 6 7)))

(square-tree tree)