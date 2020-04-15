; a
(and (supervisor ?who (Bitdiddle Ben))
     (address ?who ?where))

; b
(and (salary ?who ?amount)
     (salary (Bitdiddle Ben) ?ben-amount)
     (lisp-value < ?amount ?ben-amount))

; c
(and (supervisor ?who ?sup)
     (not (job ?sup (computer . ?type)))
     (job ?sup ?what))