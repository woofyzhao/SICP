;a
(define outline-painter
    (lambda (frame)
        ((segments->painter 
            (list
                (make-segment (origin-frame frame) (edge1-frame frame))
                (make-segment (edge1-frame frame) (add-vect (edge1-frame frame) (edge2-frame frame)))
                (make-segment (add-vect (edge1-frame frame) (edge2-frame frame)) (edge2-frame frame))
                (make-segment (edge2-frame frame) (origin-frame frame))))
         frame)))

;b
(define x-painter
    (lambda (frame)
        ((segments->painter 
            (list
                (make-segment (origin-frame frame) (add-vect (edge1-frame frame) (edge2-frame frame)))
                (make-segment (edge1-frame frame) (edge2-frame frame))))
         frame)))

;c
(define diamond-painter
    (lambda (frame)
        ((segments->painter 
            (list
                (make-segment (origin-frame frame) (scale-vect 0.5 (edge1-frame frame)))
                (make-segment (scale-vect 0.5 (edge1-frame frame)) (add-vect (edge1-frame frame) (scale-vect 0.5 (edge2-frame frame))))
                (make-segment (add-vect (edge1-frame frame) (scale-vect 0.5 (edge2-frame frame))) (add-vect (edge2-frame frame) (scale-vect 0.5 (edge1-frame frame))))
                (make-segment (add-vect (edge2-frame frame) (scale-vect 0.5 (edge1-frame frame))) (scale-vect 0.5 (edge2-frame frame)))))
         frame)))

;d
;oops