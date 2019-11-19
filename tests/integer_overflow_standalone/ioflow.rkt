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

(define A #xFFFFFFFF)
(define B #xFFFFFFFF)
(define C #x1FFFFFFFE)

(define-symbolic x y (bitvector 32))

; racket implementation

(define (ioflow_test_1 val1 val2)
  (define r (bv 0 32))
  (set! r (bvadd val1 val2))
r)

; define the function to check

(define (check-ioflow-test-1)
  (define (val) (@test x y))
  (displayln "solving..")
  (check-unsat? (verify (bveq (ioflow_test_1 x y) val))))






; define test

(define ioflow-tests
  (test-suite+
    "Test for Integer Overflow ioflow.c"

    (test-case+ "check-ioflow_1" (check-ioflow-test-1))))

(module+ test
	 (time (run-tests ioflow-tests)))
