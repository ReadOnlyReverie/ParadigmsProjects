#lang racket

;;Author: Daniel Easley
;;Class: CS 4337.002 (University of Texas at Dallas)
;;Due Date: 20-October-2022
;;Purpose: Implement 10 (+1 optional bonus) functions in Racket as outlined in the project assignment.

(provide (all-defined-out))

;;1. Takes an integer as an argument and returns a function that indicates whether
;;its integer argument is evenly divisible by the first.

(define (divisible-by-x? n)
  (lambda (x)
    (= (remainder x n) 0)))

;;2. Takes a function as an argument and passes the number 9 to that function.

(define function-9
  (lambda (f)
    (f 9)))

;;3. Duplicates the functionality of 'map' from the standard library.

(define my-map
  (lambda (f lst)
    (if (null? lst) ;;Base case
      empty
      
      (cons(f (first lst))(my-map f (rest lst)))))) ;;Recursive call
  
;;4. Takes two lists as arguments and returns a single list of pairs.

(define pair-up
  (lambda (lst1 lst2)
    (cond ((null? lst1) '()) ;;Base case
        ((null? lst2) '()) ;;Base case
        (else(cons (list (first lst1) (first lst2)) (pair-up (rest lst1) (rest lst2))))))) ;;Pair up first two elements, then call function recursively on rest of list

;;5. Executes a Boolean test on an atomic value and a list of elements as arguments.

;;Helper to build the true list
(define classify-true
  (lambda (f lst)
    (cond ((null? lst) '()) ;;Base case
          ((equal? (f (first lst)) #t) (cons (first lst) (classify-true f (rest lst)))) ;;Adds to list if true
          (else(classify-true f (rest lst))))))

;;Helper to build the false list
(define classify-false
  (lambda (f lst)
    (cond ((null? lst) '()) ;;Base case
          ((equal? (f (first lst)) #f) (cons (first lst) (classify-false f (rest lst)))) ;;Adds to list if false
          (else(classify-false f (rest lst))))))

;;Main function:
(define classify
  (lambda (f lst)
    (cons (classify-true f lst) (cons (classify-false f lst) '()))))

           
;;6. Takes two arguments, a list and an expression, which may be atomic or a list.
;;   Returns true (#t) if the element is a member of the list and false (#f) if it does not.

(define is-member?
  (lambda (expr lst)
    (if (null? lst) ;;Base case
        #f
        
        (if (equal? expr (first lst))
            #t
        
            (is-member? expr (rest lst))))))
                
;;7. Takes a comparison function and a list and returns a boolean indicating whether the list
;;   is sorted according to the comparison function.

;;NOTE: There is a logical error in this function. If it is sorted the opposite of the way you specified
;;      (ex: "(my-sorted? < '(34 11 9 6 5 2))") it will still say true,
;;      as the helper functions are simply checking both sorting directions without actually looking
;;      at what operator you gave it.

;;Main function:
(define my-sorted?
  (lambda (operator lst)
    (if (number? (first lst))
        (numberSorted? operator lst)
        
        (stringSorted? operator lst))))

;;Helper function to check sorting for numbers
(define numberSorted?
  (lambda (operator lst)
    (if (equal? (length lst) 1) ;;Base case
        #t
        
        (or (and (<= (first lst) (second lst)) (numberSorted? operator (rest lst)))
        (and (>= (first lst) (second lst)) (numberSorted? operator (rest lst)))))))

;;Helper function to check sorting for strings
(define stringSorted?
  (lambda (operator lst)
    (if (equal? (length lst) 1) ;;Base case
        #t
        
        (or (and (string<=? (first lst) (second lst)) (stringSorted? operator (rest lst)))
        (and (string>=? (first lst) (second lst)) (stringSorted? operator (rest lst)))))))


;;8. Duplicates the function of "flatten" from the standard library.

(define my-flatten
  (lambda (lst)
    (cond ((null? lst) '()) ;;Base case
          ((pair? (first lst)) (append (my-flatten(first lst)) (my-flatten (rest lst)))) ;;Appends recursively if first element is a pair
          (else (cons (first lst) (my-flatten (rest lst))))))) ;;Recusive call to construct flattened list

;;9. Takes two arguments, a list of numbers and a single number (the threshold).
;;   Returns a new list that has the same numbers as the input list, but with all elements
;;   greater than the threshold number removed.

(define upper-threshold
  (lambda (lst threshold)
    (cond ((null? lst) '()) ;;Base case
          ((< (first lst) threshold) (cons (first lst) (upper-threshold (rest lst) threshold))) ;;Add element to list if less than threshold
          (else (upper-threshold (rest lst) threshold))))) ;;Else recursively call rest of list
               
;;10. Duplicates the functionality of "list-ref" from the standard library.

(define my-list-ref
  (lambda (lst index)
    (cond ((null? lst) (error "ERROR: Index out of bounds")) ;;If list becomes empty before index is 0 then the index is out of bounds.
          ((= index 0) (first lst)) ;;Returns the first element of the list when index is 0.
          (else (my-list-ref (rest lst) (- index 1)))))) ;;Decrements index until 0.