(load "common.scm")

(define (integrate-series s)
    (div-stream s integers))

(define exp-series
    (cons-stream 1 (integrate-series exp-series)))

(define cosine-series
    (cons-stream 1 (integrate-series (negative sine-series))))

(define sine-series
    (cons-stream 0 (integrate-series cosine-series)))

(to-slice sine-series 0 10)