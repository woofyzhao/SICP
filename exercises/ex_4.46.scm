the maybe-extend function will recursively call itself indefinitely

===================
no, the right to left order actually works, just try it.


=========== Final:
The question is *NOT* about the particular *amb* operands' evaluation order!
It is asking the general evaluation order in all operators like (list ...):

(define (parse-noun-phrase)
    (list 'noun-phrase
          (parse-word articles)
          (parse-word nouns)))

Obviously the order of parsing article and parsing noun above 
must be from left to right because  the input *unparsed* reads from left to right