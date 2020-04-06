; run in amb evaluator
(define (require p) (if (not p) (amb)))

(define *unparsed* '())

(define nouns '(noun student professor cat class))
(define verbs '(verb studies lectures eats sleeps))
(define articles '(article the a))
(define prepositions '(prep for to in by with))

(define (length seq)
    (if (null? seq)
        0
        (+ 1 (length (cdr seq)))))

(define (list-ref s n)
    (if (= n 0)
        (car s)
        (list-ref (cdr s) (- n 1))))

(define (random-select s)
    (list-ref s (random (length s))))

(define (gen-word word-list)
    (list (car word-list)
          (random-select (cdr word-list))))

(define (generate) (gen-sentence))

(define (gen-sentence)
    (list 'sentence
          (gen-noun-phrase)
          (gen-verb-phrase)))

(define (gen-prepositional-phrase)
    (list 'prep-phrase
          (gen-word prepositions)
          (gen-noun-phrase)))

(define (gen-simple-noun-phrase)
    (list 'simple-noun-phrase
          (gen-word articles)
          (gen-word nouns)))

(define (gen-noun-phrase)
    (define (maybe-extend noun-phrase)
        (amb noun-phrase
             (maybe-extend (list 'noun-phrase
                                 noun-phrase
                                 (gen-prepositional-phrase)))))
    (maybe-extend (gen-simple-noun-phrase)))

(define (gen-verb-phrase)
    (define (maybe-extend verb-phrase)
        (amb verb-phrase
             (maybe-extend (list 'verb-phrase
                                 verb-phrase
                                 (gen-prepositional-phrase)))))
    (maybe-extend (gen-word verbs)))

(generate)