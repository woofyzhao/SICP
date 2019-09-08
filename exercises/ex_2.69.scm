(load "huffman.scm")

(define (generate-huffman-tree pairs)
    (successive-merge (make-leaf-set pairs)))

(define (successive-merge set)
    (cond ((null? set) nil)
          ((= (length set) 1) (car set))
          ((> (length set) 1) (successive-merge (adjoin-set
                                                    (make-code-tree (car set)
                                                                    (cadr set))
                                                    (cddr set))))))

