(load "common.scm")

(define (unique-pairs a b)
    (flatmap (lambda (i) 
                (map (lambda (j) (list i j)) 
                     (enumerate-interval a (- i 1))))
             (enumerate-interval a b)))

(unique-pairs 1 4)

(define (triple-add s)
    (+ (car s) (cadr s) (caddr s)))

(triple-add (list 1 2 3))

(define (triples-of-sum s n)
    (filter (lambda (t) (= (triple-add t) s))
            (flatmap (lambda (i) 
                        (map (lambda (pair) (cons i pair)) (unique-pairs 1 (- i 1))))
                     (enumerate-interval 1 n))))

(triples-of-sum 100 100)


; much better:

(define (unique-triples n)
    (flatmap (lambda (i)
                (flatmap (lambda (j)
                            (map (lambda (k) (list i j k))
                                 (enumerate-interval 1 (- j 1))))
                         (enumerate-interval 1 (- i 1))))
             (enumerate-interval 1 n)))


(define (triples-of-sum s n)
    (filter (lambda (seq) (= (accumulate + 0 seq) s))
            (unique-triples n)))
(triples-of-sum 50 30)

; generalize to k-tuples of 1..n
(define (unique-tuples n k)
    (if (or (< n k) (= k 0))
        (list nil)
        (filter (lambda (item) (not (null? item)))
                (append (map (lambda (tuple) (cons n tuple))
                            (unique-tuples (- n 1) (- k 1)))
                        (unique-tuples (- n 1) k)))))

;(unique-tuples 20 3)

(define (triples-of-sum s n)
    (filter (lambda (seq) (= (accumulate + 0 seq) s))
            (unique-tuples n 3)))
(triples-of-sum 50 30)



            

