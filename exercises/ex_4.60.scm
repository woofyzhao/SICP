; don't think there is a way
; p1 and p2 is indistinguishable by the definition of (live-near ?p1 ?p2)

; ============================
; change the definition then
; like (live-near-ordered ?p1 ?p2)

; a version that actually works with the book's implementation:

(assert! (rule (before ?x ?y)
            (lisp-value
                (lambda (s1 s2)
                    (define (list->string s)
                        (fold-right
                            string-append
                            ""
                            (map symbol->string s)))
                    (string<? (list->string s1) (list->string s2)))
                ?x
                ?y)))

(assert! (rule (lives-near ?person-1 ?person-2)
            (and (address ?person-1 (?town . ?rest-1))
                 (address ?person-2 (?town . ?rest-2))
                 (before ?person-1 ?person-2))))

;;; Query input:
(lives-near ?x ?y)

;;; Query results:
(lives-near (aull dewitt) (reasoner louis))
(lives-near (aull dewitt) (bitdiddle ben))
(lives-near (fect cy d) (hacker alyssa p))
(lives-near (bitdiddle ben) (reasoner louis))

