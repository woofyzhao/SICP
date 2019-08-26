(define (split main sub)
    (define (do painter n)
        (if (= n 0)
            painter
            (let ((smaller (do painter (- n 1))))
                (main painter (sub smaller smaller)))))
    do)

(define right-split (split beside below))
(define up-split (split below beside))

; what about left-split and down split?

(define (split main sub flip)
    (define (do painter n)
        (if (= n 0)
            painter
            (let ((smaller (do painter (- n 1))))
                (flip (main painter (sub smaller smaller))))))
    do)

(define right-split (split beside below identity))
(define up-split (split below beside identity))
(define left-split (split beside below flip-horiz))
(define down-split (split below beside flip-vert))

; maybe this is better
(define left-split (compose flip-horiz right-split))
(define down-split (compose flip-vert down-split))