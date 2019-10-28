(load "ex_2.68.scm")
(load "ex_2.69.scm")

(define pairs '((A 2) (BOOM 1) (GET 2) (JOB 2) (NA 16) (SHA 3) (YIP 9) (WAH 1)))

(define huffman-tree (generate-huffman-tree pairs))
huffman-tree

(define lyrics '(Get a job Sha na na na na na na na na Get a job Sha na na na na na na na na Wah yip yip yip yip yip yip yip yip yip Sha boom))
(define encoded (encode lyrics huffman-tree))

encoded 

; verify
(decode encoded huffman-tree)

; # of bits required
(length encoded)

; # of bits required if using fixed length encoding
(* (length lyrics) 3)