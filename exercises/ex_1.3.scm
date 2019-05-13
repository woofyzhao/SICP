(define (square x) (* x x))

(define (sum-of-square x y) (+ (square x) (square y)))

(define (square-sum-of-larger-two x y z)
    (if (> x y) 
        (if (> y z)
            (sum-of-square x y)
            (sum-of-square x z)
        )
        (if (> x z)
            (sum-of-square y x)
            (sum-of-square y z)
        )
    )
)

(square-sum-of-larger-two 5 6 5)