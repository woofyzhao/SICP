(load "ex_4.63.scm")

(rule (end-with-gs (grandson)))
(rule (end-with-gs (?x . ?y) (end-wth-gs ?y)))

(rule ((great . ?rel) ?x ?y)
    (and (end-with-gs ?rel)
         (has-son ?f ?y)
         (?rel ?x ?f)))

((great grandson) ?g ?ggs)
(?relationship Adam Irad)