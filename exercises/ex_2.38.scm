(load "common.scm")

(fold-right / 1 (list 1 2 3)) ;1.5
(fold-left / 1 (list 1 2 3)) ;1/6

(fold-right list nil (list 1 2 3)) ;(1 (2 (3 nil)))
(fold-left list nil (list 1 2 3)) ; (((nil 1) 2) 3)

; op must have the property of being associative
; and communicative at least on the intial value?
; consider only one element : 0 + a (foldleft) = a + 0 (foldright)

; consider matrix multiplication: (A*B)*C = A*(B*C)
; I * A = A * I however for non identity matrix B
; B * A <> A * B
; but foldleft and foldright always produce the same result
; so strict communicativity is not required