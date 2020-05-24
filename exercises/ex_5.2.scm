; raw
(data-paths
    (registers
        ((name product)
         (buttons ((name mul->p) (source (operation mul)))))
        ((name counter)
         (buttons ((name add->c) (source (operation add)))))
        ((name n)
         (buttons ())))
    
    (operations
        ((name mul)
         (inputs (register product) (register counter)))
        ((name add)
         (inputs (register counter) (constant 1)))
        ((name >)
         (inputs (register counter) (register n)))))

(controller
    test-counter
        (test >)
        (branch (label factorial-done))
        (mul->p)
        (add->c)
        (goto (label test-counter))
    factorial-done)

; compressed
(controller
    test-counter
        (test (op >) (reg counter) (reg n))
        (branch (label factorial-done))
        (assign product (op mul) (reg product) (reg counter))
        (assign counter (op add) (reg counter) (const 1))
        (goto (label test-counter))
    factorial-done)