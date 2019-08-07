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

(define (total-weight mobile)
    (if (not (pair? mobile))
        mobile
        (+ (total-weight (branch-structure (left-branch mobile)))
           (total-weight (branch-structure (right-branch mobile))))))

(define (balanced? mobile)
    (if (not (pair? mobile))
        true
        (let ((left-mobile (branch-structure (left-branch mobile)))
              (right-mobile (branch-structure (right-branch mobile)))
              (left-length (branch-length (left-branch mobile)))
              (right-length (branch-length (right-branch mobile))))
        (and (balanced? left-mobile)
             (balanced? right-mobile)
             (= (* left-length (total-weight left-mobile))
                (* right-length (total-weight right-mobile)))))))

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

(= (total-weight (branch-structure (left-branch sample))) 5)
(= (total-weight (branch-structure (right-branch sample))) 11)
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

(= (total-weight (branch-structure (left-branch sample))) 5)
(= (total-weight (branch-structure (right-branch sample))) 11)
(= (total-weight sample) 16)
(balanced? sample)


;improved for structure:
(define (torque branch) 
    (* (branch-length branch) (total-weight (branch-structure branch)))) 

(define (balanced? mobile) 
    (if (not (pair? mobile)) 
        true 
        (and (= (torque (left-branch mobile)) (torque (right-branch mobile))) 
            (balanced? (branch-structure (left-branch mobile))) 
            (balanced? (branch-structure (right-branch mobile)))))) 

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

(= (total-weight (branch-structure (left-branch sample))) 5)
(= (total-weight (branch-structure (right-branch sample))) 11)
(= (total-weight sample) 16)
(balanced? sample)