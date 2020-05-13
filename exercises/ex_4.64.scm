; outranked-by is queried with unbound pattern varialbe ?middle-manager
; recursively which is enssentially applying itself.

(assert! (rule (outranked-by ?staff-person ?boss)
            (or (supervisor ?staff-person ?boss)
                (and (outranked-by ?middle-manager ?boss)
                     (supervisor ?staff-person ?middle-manager)))))