1,2,4,8,16,32...

(define (mul-stream a b) (stream-map * a b))
(define factorials (cons-stream 1 (mul-streams integers factorials)))