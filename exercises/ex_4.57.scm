(rule (can-replace ?person1 ?person2)
    (and (job ?person1 ?job1)
         (or (job ?person2 ?job1)
             (and (job ?person2 ?job2)
                  (can-do-job ?job1 ?job2)))
         (not (same ?person1 ?person2))))
; a
(can-replace ?x (Fect Cy D))

; b
(and (can-replace ?a ?b)
     (salary ?a ?as)
     (salary ?b ?bs)
     (lisp-value < ?as ?bs))

