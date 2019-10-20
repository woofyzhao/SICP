(load "bstree.scm")

(define (tree->list-1 tree)
    (if (null? tree)
        nil
        (append (tree->list-1 (left-branch tree))
                (cons (entry tree)
                    (tree->list-1 (right-branch tree))))))

(define (tree->list-2 tree)
    (define (copy-to-list tree result-list)
        (if (null? tree)
            result-list
            (copy-to-list (left-branch tree)
                          (cons (entry tree) (copy-to-list (right-branch tree) result-list)))))
    (copy-to-list tree nil))

; a. same result (1 3 5 7 9 11)

(define tree '(7 (3 (1 () ()) (5 () ())) (9 () (11 () ()))))
(tree->list-1 tree)
(tree->list-2 tree)

; b. tree->list-1 grows more slowly 
; tree-list->1 is O(nlogn) on balanced tree while tree->list-2 is O(n) on any tree