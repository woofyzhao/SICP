; unless as a special from

(unless condition usual-value exceptional-value)
->
(cond (condition exceptional-value)
      (else usual-value))

; use in a higher-order procedure
; only trigger permitted action 
(map unless permission-list action-list default-list)


