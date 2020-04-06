(load "evaluator-amb.scm")

(define (shuffled s)
    (define (swap s p q)
        (let ((ps (list-starting-from s p))
              (qs (list-starting-from s q)))
            (let ((pv (car ps)))
                (set-car! ps (car qs))
                (set-car! qs pv)))) 
    (define (iter rest)
        (if (null? rest)
            s
            (let ((n (random (length rest))))
                (swap rest 0 n)
                (iter (cdr rest)))))
    (iter s))
            

(define (analyze-amb exp)
    (let ((cprocs (map analyze (amb-choices exp))))
        (lambda (env succeed fail)
            ; achieve random order by shuffling choices
            (define shuffled-cprocs (shuffled cprocs))
            (define (try-next choices)
                (if (null? choices)
                    (fail)
                    ((car choices) env
                                   succeed
                                   (lambda ()
                                    (try-next (cdr choices))))))
            (try-next shuffled-cprocs))))

;Just try it out
;对局部多样性有一定帮助, 但其实还是会陷入到最底部的某个分支出不来, 这是用户程序的递归本质决定的
;要实现真正的随机采样, 需要跨层调度