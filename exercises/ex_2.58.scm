(load "symbolic_diff.scm")
(load "common.scm")

; a
(define (make-sum x y) (list x '+ y))
(define (sum? x) (and (pair? x) (eq? (cadr x) '+)))
(define (addend x) (car x))
(define (augend x) (caddr x))

(define (make-product x y) (list x '* y))
(define (product? x) (and (pair? x) (eq? (cadr x) '*)))
(define (multiplier x) (car x))
(define (multiplicant x) (caddr x))

;simplification on constructors
(define (make-sum x y)
    (cond ((=number? x 0) y)
          ((=number? y 0) x)
          ((and (number? x) (number? y)) (+ x y))
          (else (list x '+ y))))

(define (make-product x y)
    (cond ((or (=number? x 0) (=number? y 0)) 0)
          ((=number? x 1) y)
          ((=number? y 1) x)
          ((and (number? x) (number? y)) (* x y))
          (else (list x '* y))))

(deriv '(x + 3) 'x)
(deriv '(x * y) 'x)
(deriv '((x * y) * (x + 3)) 'x)

; b
; helpers
(define (contains? seq item)
    (accumulate (lambda (x res) (or res (eq? x item))) #f seq))
(define (before-part seq x)
    (if (eq? (car seq) x)
        nil
        (cons (car seq) (before-part (cdr seq) x))))
(define (after-part seq x)
    (if (eq? (car seq) x)
        (cdr seq)
        (after-part (cdr seq) x)))

; sum
(define (make-sum x y)
    (cond ((=number? x 0) y)
          ((=number? y 0) x)
          ((and (number? x) (number? y)) (+ x y))
          (else (flatmap (lambda (item) 
                            (if (pair? item) item (list item))) 
                         (list x '+ y)))))

(define (sum? x) (and (pair? x) (contains? x '+)))
(define (addend x)
    (let ((left (before-part x '+)))
        (if (and (pair? left) (null? (cdr left)))
            (car left)
            left)))
(define (augend x)
    (let ((right (after-part x '+)))
        (if (and (pair? right) (null? (cdr right)))
            (car right)
            right)))

; sum test
(make-sum 'x '(3 * (x + y + 2)))
(sum? '(x + 3 * (x + y + 2)))
(addend '(x + 3 * (x + y + 2)))
(augend '(x + 3 * (x + y + 2)))

; product
(define (make-product x y)
    (cond ((or (=number? x 0) (=number? y 0)) 0)
          ((=number? x 1) y)
          ((=number? y 1) x)
          ((and (number? x) (number? y)) (* x y))
          (else (list x '* y))))
(define (product? x) (and (pair? x) (not (sum? x)) (contains? x '*)))
(define (multiplier x)
    (let ((left (before-part x '*)))
        (if (and (pair? left) (null? (cdr left)))
            (car left)
            left)))
(define (multiplicant x)
    (let ((right (after-part x '*)))
        (if (and (pair? right) (null? (cdr right)))
            (car right)
            right)))

; product test
(product? '(x + 3 * (x + y + 2)))
(product? '((x + 3) * (x + y + 2)))
(multiplier '((x + 3) * (x + y + 2)))
(multiplicant '((x + 3) * x * (x + y + 2)))

; representation test
(deriv '(x + 3 * (x + y + 2)) 'x)
(deriv '((x + 3) * (x + y + 2)) 'x)
(deriv '((x + 3) * (x + y + 2) + x * 3 * (x + y + 2)) 'x)


; http://community.schemewiki.org/?sicp-ex-2.58
; sgm's solution is more general