(rule (big-shot ?person)
    (and (job ?person (?division . ?x))
         (not (and (job ?boss (?division . ?y))
                   (supervisor ?person ?boss)))))
