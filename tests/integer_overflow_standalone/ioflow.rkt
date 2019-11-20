#lang rosette

(require (except-in rackunit fail)
         rackunit/text-ui
         rosette/lib/roseunit
         serval/llvm
         serval/lib/unittest
         serval/lib/core)

(require "generated/racket/test/ioflow.globals.rkt"
         "generated/racket/test/ioflow.map.rkt")

(require "generated/racket/test/ioflow.ll.rkt")

;(define A (bv #xFFFFFFFF 32))
;(define B (bv #xFFFFFFFF 32))
(define C (bv #x1FFFFFFFE 32))
(define A (bv 5 32))
(define B (bv 4 32))

;(define-symbolic x y (bitvector 32))

; racket implementation
(define (ioflow_test_1 val1 val2)
  (displayln "Starting native test...")
  (define r (bv 0 32))
  (set! r (bvadd (bv 2 32) (bv 3 32)))
  (displayln "Setting r to (bvadd x y)...")
r)

; define the function to check
(define (check-ioflow-test-1)
  (displayln "Starting test...")
  (define-symbolic x (bitvector 32))
  (define-symbolic y (bitvector 32))
  (define pre (ioflow_test_1 x y))
  (displayln "Defined pre...")
;  (define (val) (@test (bv 3 32) (bv 4 32)))
  (define (val) (@test x y))
  (val)
  (displayln "Defined asserted...")
  (define post (ioflow_test_1 x y))
  (displayln "Defined post...")
  ;(for-each (lambda (A B) (check-unsat? (verify (assert A B)))) asserted)
  (check-unsat? (verify (assert (implies pre post))))
  (displayln "Passed assert (pre == post)...")
  (displayln "Solving...")
  (check-unsat? (verify (assert (equal? (ioflow_test_1 A B) (val))))))


; define test
(define ioflow-tests
  (test-suite+
    "Test for Integer Overflow ioflow.c"

    (test-case+ "check-ioflow_1" (check-ioflow-test-1))))

(module+ test
	 (time (run-tests ioflow-tests)))
