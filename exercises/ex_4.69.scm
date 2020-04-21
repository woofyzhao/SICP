(load "ex_4.63.scm")

(rule (end-with-gs (grandson)))
(rule (end-with-gs (?x . ?y)) (end-wth-gs ?y))
(rule ((grandson) ?x ?y) (grandson ?x ?y))

; the end-with-gs predicate has to be in last order!!!
(rule ((great . ?rel) ?x ?y)
    (and (has-son ?f ?y)
         (?rel ?x ?f)
         (end-with-gs ?rel)))

((great grandson) ?g ?ggs)
(?relationship Adam Irad)

(?relationship Adam Jabal)