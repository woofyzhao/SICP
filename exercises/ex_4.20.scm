;a.

(define (letrec->let exp)
    (make-let 
        (map (lambda (b) (list (binding-variable b) '*unassigned*))
             (letrec-bindings exp))
        (append 
            (map (lambda (b) (make-set! (binding-variable b) (binding-value b)))
                 (letrec-bindings exp))
            (letrect-body exp)))

;b. the env of the lambda value of the bindings differs
;   in let it is the env that evaluates let where the even or odd variable is not defined 
;   hence will report unbound error.
;   while in letrec it is the env that has the extra new frame where the variables resides
;   hence works fine.