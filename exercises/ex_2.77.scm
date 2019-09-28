(magnitude z)
(apply-generic 'magnitude z)
((get 'magnitude '(complex)) (contents z))
(magnitude (contents z))
(apply-generic 'magnitude (contents z))
((get 'magnitude '(rectangular)) (contents (contents z)))
(rectangular-magnitude (contents (contents z)))

; apply-generic invoked 2 times
; first dispatched to the generic magnitude function in the complex package
; then dispatched to the specific  mangitude function from rectangular or polar representation package