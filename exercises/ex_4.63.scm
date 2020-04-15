(rule (son-w ?m ?s)
    (and (son ?w ?s)
         (wife ?m ?w)))

(rule (has-son ?x ?y)
    (or (son ?x ?y)
        (son-w ?x ?y)))

(rule (grandson ?g ?s)
    (and (has-son ?g ?f)
         (has-son ?f ?s)))

; the grandson of Cain
(grandson Cain ?x)

; the sons of Lamech
(has-son Lamech ?x)

; the grandsons of Methushael
(grandson Methushael ?x)

