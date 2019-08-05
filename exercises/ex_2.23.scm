; works but strange
(define (for-each f items)
    (if (null? items) 
        true
        ((lambda ()
            (f (car items))
            (for-each f (cdr items))))))        

 ; http://community.schemewiki.org/?sicp-ex-2.23
 ; Simply iterate with a parameter solely for evaluating the procedure with the current argument. 
 ; In accordance with the function evaluation rule, this parameter will be evaluated each time. 
 ; The parameter is not used in the function body -- it is 'discarded'. 
 ; The initial iteration passes #t to this parameter, which has no effect. 
  
 (define (for-each procedure items) 
    (define (iter items evaluate) 
        (if (null? items) 
            true 
            (iter (cdr items) (procedure (car items))))) 
   (iter items true)) 
  

(for-each (lambda (x) (newline) (display x)) 
    (list 57 321 88))