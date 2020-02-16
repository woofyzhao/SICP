
(define (random-stream random-init)
    (define random-number (cons-stream random-init
                                       (stream-map rand-update random-number)))
    random-number)

(define (random-generator request-stream random-init)
    (define (next requests randoms)
        (if (eq? 'generate (stream-car requests))
            (cons-stream (stream-car randoms)
                         (next (stream-cdr requests) (stream-cdr randoms))
            (next (stream-cdr requests) (random-stream (stream-car requests))))))
    (next request-stream (random-stream random-init)))


; following is solution from https://www.inchmeal.io/sicp/ch-3/ex-3.81.html
; seems better match what the exercise intended

(define (make-rand-gen default-seed upper-bound)
  ;Using foot-note 6 from chapter-3 to implement rand-update
  (define (rand-update x)
	(remainder (+ (* 29 x) 23) upper-bound))

  (define (gen request old-val)
	(cond ((and (pair? request) (eq? 'reset (car request))) (rand-update (cadr request)))
		  ((eq? 'reset request) (rand-update default-seed))
		  ((eq? 'generate request) (rand-update old-val))
		  (else 'invalid)
		  ))

  (define (make-rand-stream requests)
	(define s
	  (cons-stream
	   (gen (stream-car requests) default-seed)
	   (stream-map gen
				   (stream-cdr requests)
				   s)))
	s)
  make-rand-stream)
			  
