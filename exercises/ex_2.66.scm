(define (lookup given-key treeset)
    (if (null? treeset) 
        false
        (let ((record (entry treeset)))
            (cond ((= given-key (key record)) record)
                  ((< given-key (key record)) (lookup given-key (left-branch treeset)))
                  (else (lookup given-key (right-branch treeset)))))))