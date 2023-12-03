#!/usr/bin/sbcl --noinform --script

;;; Loops based factorial function
(defun factorial (n)
  "Calculates N!"
  (loop for result = 1 then (* result i)
        for i from 2 to n
        finally (return result)))

;;; Recursive factorial function
(defun rfactorial (n)
  (if (<= n 1)
      1
      (* n (rfactorial (- n 1)))))

;;; Main Program
(write (factorial 10))
(terpri)
(write (rfactorial 10))
(terpri)
 
(quit)