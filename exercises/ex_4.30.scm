a. the arguments value of proc and items are forced in the for-each procedure and is not
different from the non lazy version of the evaluator

b.

(define (p1 x)
    (set! x (cons x '(2)))
    x)

(define (p2 x)
    (define (p e)
        e
        x)
    (p (set! x (cons x '(2)))))

original: 
    (p1 1) ; (1 2) 
    (p2 1) ; 1
Cy's version:
    (p1 1) ; (1 2)
    (p2 1) ; (1 2)

c. 
Cy's arguments does make some sense.
But the orignal version is not wrong in the normal order semantic itself.
We can choose not to do this type of programming and stick to the non-strict rule in mind.