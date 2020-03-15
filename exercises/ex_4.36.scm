(define (a-pythagorean-triple-end-with k)
    (let ((i (an-integer-between 1 k)))
        (let ((j (an-integer-between i k)))
            (require (= (+ (* i i) (* j j)) (* k k)))
            (list i j k))))

(define (a-pythagorean-triple)
    (let ((k (an-integer-starting-from 1)))
        (a-pythagorean-triple-end-with k)))
    