(load "common.scm")

(define (fringe s)
    (cond ((null? s) nil)
          ((not (pair? s)) (list s))
          (else (append (fringe (car s)) (fringe (cdr s))))))

(define (fringe_1 s)
    (define (go curr result)
        (cond ((null? curr) result)
              ((not (pair? curr)) (cons curr result))
              (else (go (cdr curr) (go (car curr) result)))))
    (reverse (go s nil)))

(fringe (list (list 1 2) (list 3 (list 7 8 9) 4)))
(fringe nil)
(fringe (list 1))
(fringe 1)

