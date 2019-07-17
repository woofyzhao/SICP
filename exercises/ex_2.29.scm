(load "common.scm")

(define (make-mobile left right)
    (list left right))

(define (make-branch length structure)
    (list length structure))

(define (left-branch mobile)
    (car mobile))

(define (right-branch mobile)
    (car (cdr mobile)))

(define (branch-length branch)
    (car branch))

(define (branch-structure branch)
    (car (cdr branch)))

(define (branch-weight branch)
    (let ((structure (branch-structure branch)))
        (if (not (pair? structure))
            structure
            (total-weight structure))))

(define (total-weight mobile)
    (+ (branch-weight (left-branch mobile))
       (branch-weight (right-branch mobile))))

(define (balanced? mobile)
    (define (branch-balanced? branch)
        (let ((structure (branch-structure branch)))
            (if (not (pair? structure))
                true
                (balanced? structure))))
    (let ((left (left-branch mobile))
          (right (right-branch mobile)))
        (and (branch-balanced? left)
             (branch-balanced? right)
             (= (* (branch-length left) (branch-weight left))
                (* (branch-length right) (branch-weight right))))))

; test
(define sample
    (make-mobile
        (make-branch
            11
            (make-mobile
                (make-branch 4 3)
                (make-branch 
                    6
                    (make-mobile
                        (make-branch 1 1)
                        (make-branch 1 1)))))
        (make-branch
            5
            (make-mobile
                (make-branch 8 3)
                (make-branch 3 8)))))

(= (branch-weight (left-branch sample)) 5)
(= (branch-weight (right-branch sample)) 11)
(= (total-weight sample) 16)
(balanced? sample)


; switch representation      
(define (make-mobile left right)
    (cons left right))

(define (make-branch length structure)
    (cons length structure))

(define (left-branch mobile)
    (car mobile))

(define (right-branch mobile)
    (cdr mobile))

(define (branch-length branch)
    (car branch))

(define (branch-structure branch)
    (cdr branch))

; test
(define sample
    (make-mobile
        (make-branch
            11
            (make-mobile
                (make-branch 4 3)
                (make-branch 
                    6
                    (make-mobile
                        (make-branch 1 1)
                        (make-branch 1 1)))))
        (make-branch
            5
            (make-mobile
                (make-branch 8 3)
                (make-branch 3 8)))))

(= (branch-weight (left-branch sample)) 5)
(= (branch-weight (right-branch sample)) 11)
(= (total-weight sample) 16)
(balanced? sample)