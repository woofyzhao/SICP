(define (make-table)
    (let ((local-table (list '*table*)))
        (define (assoc keys records)
            (cond ((null? records) #f)
                  ((not (pair? records)) #f)
                  ((not (pair? (car records))) #f)
                  ((equal? (car keys) (caar records)) 
                    (if (null? (cdr keys)) 
                        (car records) 
                        (assoc (cdr keys) (cdar records))))
                  (else (assoc keys (cdr records)))))
        (define (lookup keys)
            (let ((record (assoc keys (cdr local-table))))
                (if record
                    (cdr record)
                    #f)))
        (define (insert! keys value)
            (define (insert-or-update! remaining-keys table)
                (let ((subtable (assoc (list (car remaining-keys)) (cdr table))))
                    (if subtable
                        (if (null? (cdr remaining-keys))
                            (set-cdr! subtable value)
                            (insert-or-update! (cdr remaining-keys) subtable))
                        (begin
                            (let ((new-subtable (list (car remaining-keys))))
                                (set-cdr! table (cons new-subtable (cdr table)))
                                (insert-or-update! remaining-keys table))))))
            (insert-or-update! keys local-table)
            'ok)
        (define (dispatch m)
            (cond ((eq? m 'lookup) lookup)
                  ((eq? m 'insert!) insert!)
                  (else (error "Unknown table operation " m))))
        dispatch))

(define (lookup table keys) ((table 'lookup) keys))
(define (insert! table keys value) ((table 'insert!) keys value))
        
(define t (make-table))
(insert! t '(a b c) 100)
(lookup t '(a b c)) ; 100
(insert! t '(a b c d e) 999)
(lookup t '(a b c d e)) ; 999
(lookup t '(a b c f)) ; false
(insert! t '(a b c d) 777)
(lookup t '(a b c d)) ; 777
(lookup t '(a b c d e)) ; false
(insert! t '(a b) '(1 2 3))
(lookup t '(a b c)) ; false
(lookup t '(a)) ; '((b 1 2 3))
