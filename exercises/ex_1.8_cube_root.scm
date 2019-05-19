(define (cube-root x)
    (cube-root-iter 1.0 x))
    
(define (cube-root-iter guess x)
    (if (good-enough? guess x)
        guess
        (cube-root-iter (improve guess x) 
                    x)))

(define (improve guess x)
    (/ (+ (/ x (square guess))
          (+ guess guess))
       3.0))

(define (square x)
    (* x x))

(define (good-enough? guess x)
   (< (abs (/ (- (improve guess x) guess)
               guess)) 
        0.001))

(cube-root 8)

(cube-root 1e60)

(cube-root 1e-15)


