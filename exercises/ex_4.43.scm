; a. Lorna's father is Colonel Downing

; b.
(define yacht-names 
    '((Moore Lorna) 
      (Downing Melissa) 
      (Barnacle Gabrielle) 
      (Hall Rosalind)
      (Parker Mary)))

(define daddy-options
    '((Lorna (Downing Barnacle Hall Parker))
      (Melissa (Barnacle))
      (Gabrielle (Moore Downing Hall Parker))
      (Rosalind (Moore Downing Parker))
      (Mary (Moore Downing Barnacle Hall))))

(define (find-cdr kv-list k)
    (define (iter rest)
        (cond ((null? rest) false)
              ((eq? k (caar rest)) (cadar rest))
              (else (iter (cdr rest)))))
    (iter kv-list))

(define (find-car kv-list k)
    (define (iter rest)
        (cond ((null? rest) false)
              ((eq? k (cadar rest)) (caar rest))
              (else (iter (cdr rest)))))
    (iter kv-list))

(define (daddy girl set) (find-cdr set girl))
(define (daughter daddy set) (find-car set daddy))
(define (yacht daddy set) (find-cdr set daddy))

(define (no-share-daddy daddy set)
    (define (iter rest)
        (cond ((null? rest) true)
              ((eq? (cadar rest) daddy) false)
              (else (iter (cdr rest)))))
    (iter set))

(define (nice-daughters)
    (define (iter options result)
        (if (null? options)
            (begin
                (require (eq? (yacht (daddy 'Gabrielle)) (daughter 'Parker)))
                result)
            (let ((girl (caar options))
                  (daddies (cadar options)))
                (let ((daddy (a-element-of daddies)))
                    (require (no-share-daddy daddy result))
                    (iter (cdr options) (cons (list girl daddy) result))))))
    (iter daddy-options '()))