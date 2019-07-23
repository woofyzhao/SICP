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




            

