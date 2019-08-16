(load "prime.scm")

(define (unique-pairs n)
    (flatmap (lambda (i) 
                (map (lambda (j) (list i j)) 
                     (enumerate-interval 1 (- i 1))))
             (enumerate-interval 1 n)))

;(unique-pairs 5)

(define (prime-sum? pair)
    (prime? (+ (car pair) (cadr pair))))

(define (make-pair-sum pair)
    (list (car pair) (cadr pair) (+ (car pair) (cadr pair))))

(define (prime-sum-pairs n)
    (map make-pair-sum
        (filter prime-sum?
                (unique-pairs n))))

(prime-sum-pairs 6)


(define (unique-triples n)
    (flatmap (lambda (i)
                (flatmap (lambda (j) 
                            (map (lambda (k) (list i j k)) 
                                 (enumerate-interval 1 (- i 1))))
                         (enumerate-interval 1 i)))
             (enumerate-interval 1 n)))