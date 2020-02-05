(define (or-gate a1 a2 output)
    (let ((b1 (make-wire))
          (b2 (make-wire))
          (c (make-wire)))
        (inverter a1 b1)
        (inverter a2 b2)
        (and-gate b1 b2 c)
        (inverter c output))
        'ok)

; or-gate-delay = and-gate-delay + 2 * inverter-delay