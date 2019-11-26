#lang rosette

(require (except-in rackunit fail)
	 rackunit/text-ui
	 rosette/lib/roseunit
	 serval/llvm
	 serval/lib/unittest
	 serval/lib/core)

(require "generated/racket/test/ioflow.ll.rkt")

(define-symbolic x y i32)

(define (check-addition x y #:result [result (+ x y)])
  (check-equal? (@addition x y) (bv result i32)))

(define (check-symbolic-addition)
  (check-equal? (@addition x (bv 0 i32)) x)
  (check-equal? (@addition x (bv 1 i32)) (bvadd x (bv 1 i32)))
  (check-equal? (@addition x y) (bvadd x y))
  (check-equal? (asserts) null))

(define ioflow-tests
  (test-suite+
    "Test for Interger Overflow in ioflow.c"

    (parameterize ([current-machine (make-machine)])
    (test-case+ "check-ioflow" (check-symbolic-addition))))) 

(module+ test
        (time (run-tests ioflow-tests)))