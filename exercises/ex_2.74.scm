(define division type-tag)

; a
; some empty set if not exists
(define (get-record record-file name)
    ((get 'get-record (division record-file)) record-file name))

; b
(define (get-salary record)
    ((get 'get-field (division record)) record 'salary))

; c
(define (empty-record? record)
    ((get 'empty-record? (division record)) record))

(define (find-employee-record name record-file-list)
    (if (null? record-file-list)
        false
        (let ((candidate (get-record (car record-file-list) name)))
            (if (empty-record? candidate)
                (find-employee-record name (cdr record-file-list))
                candidate))))

; d
; install new company's procedures addictively
; existing generic head quater procedures need not change