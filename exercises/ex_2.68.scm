(load "huffman.scm")

(define (encode message tree)
    (if (null? message)
        nil
        (append (encode-symbol (car message) tree)
                (encode (cdr message) tree))))

; check at every node
;(define (encode-symbol-0 symbol tree)
;    (cond ((leaf? tree) nil)
;          ((element-of-list? symbol (symbols (left-branch tree))) 
;           (cons 0 (encode-symbol-0 symbol (left-branch tree))))
;          ((element-of-list? symbol (symbols (right-branch tree)))
;           (cons 1 (encode-symbol-0 symbol (right-branch tree))))
;          (else 
;            (error "bad message symbol -- ENCODE-SYMBOL" symbol))))

; only check at the leaf, saves some intermediate checking
;(define (encode-symbol-1 symbol tree)
;    (cond ((leaf? tree)
;           (if (eq? symbol (symbol-leaf tree))
;               nil
;               (error "bad message symbol -- ENCODE-SYMBOL" symbol)))
;          ((element-of-list? symbol (symbols (left-branch tree))) 
;           (cons 0 (encode-symbol symbol (left-branch tree))))
;          (else
;           (cons 1 (encode-symbol symbol (right-branch tree))))))

; check error only once
(define (encode-symbol symbol tree)
    (define (search tree)
        (if (leaf? tree)
            '()
            (let ((left (left-branch tree))
                  (right (right-branch tree)))
                (if (member? symbol left) 
                    (cons 0 (search left))
                    (cons 1 (search right))))))
    (if (member? symbol tree)
        (search tree)
        (error "bad message symbol -- ENCODE-SYMBOL" symbol)))

(define (element-of-list? x set)
    (cond ((null? set) false)
          ((equal? x (car set)) true)
          (else (element-of-list? x (cdr set)))))

(define (member? x tree)
    (element-of-list? x (symbols tree)))

; using flatmap
(define (encode2 message tree)
    (flatmap (lambda (symbol)
                (encode-symbol symbol tree))
             message))

; test
(define sample-tree
    (make-code-tree (make-leaf 'A 4)
                    (make-code-tree
                        (make-leaf 'B 2)
                        (make-code-tree (make-leaf 'D 1)
                                        (make-leaf 'C 1)))))
(define sample-message '(A D A B B C A))
(encode sample-message sample-tree)
(encode2 sample-message sample-tree)
;(encode '(A D S B C) sample-tree)
