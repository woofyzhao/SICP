; Q(k): number of solutions of board size n * k
; T(k): number of steps required to calculate Q(k)

; original approach:
; T(k) = T(k-1) + n * Q(k-1)
; T(0) = 1

; louis's approach:
; T(k) = n * (T(k-1) + Q(k-1))
;      = n * T(k-1) + n * Q(k-1)
; T(0) = 1

; so louis's approach requires signifcantly more steps. How many more?
; it's tempted to say a factor of N^N due to tree recursion but it may not be the actual case
; https://wernerdegroot.wordpress.com/2015/08/01/sicp-exercise-2-43/