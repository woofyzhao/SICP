(define (f n)
    (if (< n 3)
        n
        (+ (f (- n 1))
           (* 2 (f (- n 2)))
           (* 3 (f (- n 3))))))

(f 3)
(f 4)
(f 5)
(f 10)
(f 13)
(f 15)
(f 20)

(define (f-iter a b c cnt)
    (if (= cnt 0)
        c
        (f-iter (+ a (* 2 b) (* 3 c))
                a
                b
                (- cnt 1))))

(define (f n)
    (f-iter 2 1 0 n))

(f 3)
(f 4)
(f 5)
(f 10)
(f 13)
(f 15)
(f 20)