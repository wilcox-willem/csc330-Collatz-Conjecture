(defpackage :collatz
  (:use :cl :alexandria))

(in-package :collatz)

(defstruct result
  input
  output)

(defun sort-top-ten (top-results sort-type)
  (sort top-results
        (lambda (a b)
          (if sort-type
              (> (result-output a) (result-output b))
              (> (result-input a) (result-input b))))))

(defun update-top-results (top-results x y cycles)
  (let ((new-result (make-result :input x :output y))
        (new-result-fits nil)
        (output-exists-already nil)
        (min-result (copy-result (first top-results)))
        (min-index 0))

    (dotimes (i (length top-results))
      (when (> (result-output (elt top-results i)) (result-output new-result))
        (setf new-result-fits t))
      (when (and (= (result-output (elt top-results i)) (result-output new-result))
                 (> (result-input (elt top-results i)) (result-input new-result)))
        (setf output-exists-already t))
      (when (> (result-output (elt top-results i)) (result-output min-result))
        (setf min-result (copy-result (elt top-results i))
              min-index i)))

    (when (or new-result-fits (< cycles 10))
      (setf (elt top-results min-index) new-result)
      (setf top-results (sort-top-ten top-results t)))

    (when (> (length top-results) 10)
      (setf top-results (subseq top-results 0 10)))

    (result-output min-result)))

(defun print-results (top-results)
  (format t "Sorted based on sequence length~%")
  (dolist (result (reverse top-results))
    (format t "~20d~20d~%" (result-input result) (result-output result)))

  (format t "Sorted based on integer length~%")
  (setf top-results (sort-top-ten top-results nil))
  (dolist (result top-results)
    (format t "~20d~20d~%" (result-input result) (result-output result))))

(defun collatz-num-of-sequences (input step)
  (if (< input 2)
      step
      (if (evenp input)
          (collatz-num-of-sequences (/ input 2) (1+ step))
          (collatz-num-of-sequences (+ (* input 3) 1) (1+ step)))))

(defun collatz-num-of-sequences-print-top-ten (lower-limit upper-limit)
  (let* ((top-ten (make-list 10 :initial-element (make-result :input 0 :output 0)))
         (curr-min 0)
         (cycles 0))

    (loop for i from lower-limit to upper-limit do
      (let ((result (collatz-num-of-sequences i 0)))
        (when (or (> result curr-min) (< cycles 10))
          (setf curr-min (update-top-results top-ten i result cycles)))
        (incf cycles)))

    (print-results top-ten)))

(defun main ()
  (let ((lower-limit 0)
        (upper-limit 0)
        (input-limit 2100000001)
        (num-args (length *command-line-argument-list*)))

    (when (> num-args 0)
      (setf lower-limit (parse-integer (first *command-line-argument-list*))))
    (when (= num-args 2)
      (setf upper-limit (parse-integer (second *command-line-argument-list*))))

    (when (or (> lower-limit input-limit) (> upper-limit input-limit))
      (format t "Input is too large, please use a number 0 - 2.1 billion~%")
      (return-from main))

    (if (and (> lower-limit 0) (= upper-limit 0))
        (format t "~20d~20d~%" lower-limit (collatz-num-of-sequences lower-limit 0))
        (when (and (> lower-limit 0) (> upper-limit 0) (> upper-limit lower-limit))
          (collatz-num-of-sequences-print-top-ten lower-limit upper-limit)))))
