(define (list-of-values-left-to-right exps env)
    (if (no-operands? exps)
        '()
        (let ((left (eval (first-operand exps) env)))
            (cons left
                  (list-of-values (rest-operands exps) env)))))

(define (list-of-values-left-to-right exps env)
    (if (no-operands? exps)
        '()
        (let ((right (list-of-values (rest-operands exps) env)))
            (cons (eval (first-operand exps) env)
                  right))))