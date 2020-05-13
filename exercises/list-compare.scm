(define s1 '(this is a list))
(define s2 '(this too is a list))

(define (list->string s)
  (fold-right
	string-append
	""
    (map symbol->string s)))

(define (list-compare s1 s2)
	(string<? s1 s2))

(define (list-compare s1 s2)
	(define (list->string s)
		(fold-right
			string-append
			""
			(map symbol->string s)))
    (string<? (list->string s1) (list->string s2)))





	
