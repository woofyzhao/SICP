;; original solution ,not ok
(define (level-of type)
    (cond ((eq? type 'complex) 10)
          ((eq? type 'real) 9)
          ((eq? type 'rational) 8)
          ((eq? type 'integer 7))
          (else (error "invalid type" type))))

(define (apply-generic op . args)
    (let ((type-tags (map type-tag args)))
        (let ((proc (get op type-tags)))
            (if proc
                (apply proc (map contents args))
                (if (= (length args) 2)
                    (let ((type1 (car type-tags))
                          (type2 (cadr type-tags))
                          (a1 (car args))
                          (a2 (cadr args)))
                        (cond ((< (level-of type1) (level-of type2)) (apply-generic op (raise a1) a2))
                              ((> (level-of type1) (level-of type2)) (apply-generic op a1 (raise a2)))
                              (else (error "No method for these types " (list op type-tags)))))
                    (error "No method for these types " (list op tppe-tags)))))))

;; the level system above will lead problems in adding new levels to the tower
;; thus not "compatible" with the rest of the system
;; see meteorgan's solution from http://community.schemewiki.org/?sicp-ex-2.84

 ;; assuming that the types are arranged in a simple tower shape. 
 (define (apply-generic op . args) 
   ;; raise s into t, if success, return s; else return #f 
   (define (raise-into s t) 
         (let ((s-type (type-tag s)) 
               (t-type (type-tag t))) 
           (cond ((equal? s-type t-type) s) 
                 ((get 'raise (list s-type))  
                  (raise-into ((get 'raise (list s-type)) (contents s)) t)) 
                 (else #f)))) 
  
   (let ((type-tags (map type-tag args))) 
         (let ((proc (get op type-tags))) 
           (if proc 
             (apply proc (map contents args)) 
             (if (= (length args) 2) 
               (let ((a1 (car args)) 
                    (a2 (cadr args))) 
                 (cond  
                   ((raise-into a1 a2) 
                    (apply-generic op (raise-into a1 a2) a2)) 
                   ((raise-into a2 a1) 
                    (apply-generic op a1 (raise-into a2 a1))) 
                   (else (error "No method for these types" 
                         (list op type-tags))))) 
            (error "No method for these types" 
                   (list op type-tags))))))) 