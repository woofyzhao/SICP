; a
(meeting ?who (Friday ?when))

; b
(rule (meeting-time ?person ?day-and-time)
    (or (meeting whole-company ?day-and-time)
        (and (job ?person (?division ?x))
             (meeting ?division ?day-and-time))))

; c
(meeting-time (Hacker Alyssa P) (Wednesday ?when))