(load "ex_2.63.scm")
(load "ex_2.64.scm")

(define (union-list set1 set2)
    (cond ((null? set1) set2)
          ((null? set2) set1)
          (else 
            (let ((x1 (car set1)) (x2 (car set2)))
                (cond ((= x1 x2) (cons x1 (union-list (cdr set1) (cdr set2))))
                      ((< x1 x2) (cons x1 (union-list (cdr set1) set2)))
                      ((< x2 x1) (cons x2 (union-list set1 (cdr set2)))))))))

(define (intersection-list set1 set2)
    (cond ((or (null? set1) (null? set2)) nil)
          ((= (car set1) (car set2)) (cons (car set1)
                                           (intersection-list (cdr set1) (cdr set2))))
          ((< (car set1) (car set2)) (intersection-list (cdr set1) set2))
          (else (intersection-list set1 (cdr set2)))))

(define (union-set set1 set2)
    (list->tree (union-list (tree->list-2 set1)
                           (tree->list-2 set2))))

(define (intersection-set set1 set2)
    (list->tree (intersection-list (tree->list-2 set1)
                                  (tree->list-2 set2))))

(define set1 '(5 (3 (1 () ()) (4 () ())) (7 () ())))
(define set2 '(6 (5 (4 () ()) ()) (8 (7 () ()) (9 () ()))))

(tree->list-2 set1)
(tree->list-2 set2)

(union-set set1 set2)
(intersection-set set1 set2)

(tree->list-2 (union-set set1 set2))
(tree->list-2 (intersection-set set1 set2))