(load "common.scm")

(fold-right / 1 (list 1 2 3)) ;1.5
(fold-left / 1 (list 1 2 3)) ;1/6

(fold-right list nil (list 1 2 3)) ;(1 (2 (3 nil)))
(fold-left list nil (list 1 2 3)) ; (((nil 1) 2) 3)

; op must have the property of being associative