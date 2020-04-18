; common base
(rule (reverse () ()))

; attempt-1
(rule (reverse (?a . ?b) ?c)
    (and (reverse ?b ?r)
         (append-to-form ?r (?a) ?c)))

(reverse (1 2 3) ?x) ; ok
(reverse ?x (1 2 3)) ; no... infinite loop

; attempt-2
(rule (reverse (?a . ?b) ?c)
    (and (append-to-form ?r (?a) ?c)
         (reverse ?b ?r)))

(reverse (1 2 3) ?x) ; no... append-to-form fail
(reverse ?x (1 2 3)) ; ok

; attempt-3
(rule (reverse (?a . ?b) (?c . ?d))
    (and (append-to-form ?br ?a (?c . ?d))
         (reverse ?b ?br)))

(reverse (1 2 3) ?x) ; no... append-to-form fail
(reverse ?x (1 2 3)) ; ok

; attempt-4
(rule (reverse (?a . ?b) (?c . ?d))
    (and (reverse ?b ?br)
         (append-to-form ?br ?a (?c . ?d))))

(reverse (1 2 3) ?x) ; ok
(reverse ?x (1 2 3)) ; no... infinite loop




