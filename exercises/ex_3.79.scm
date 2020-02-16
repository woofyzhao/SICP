(define (integral delayed-integrand initial-value dt)
    (define int
        (cons-stream initial-value
                     (add-stream (scale-stream (force delayed-integrand) dt)
                                 int)))
    int)
    
(define (solve-2nd f dt y0 dy0)
    (define y (integral (delay dy) y0 dt))
    (define dy (integral (delay ddy) dy0 dt))
    (define ddy (stream-map f dy y))
    y)
