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

(define (check-buggy-addition)
  (define sol (verify (@addition_overflow x y)))
  (check-equal? (asserts) null)
  (check-unsat? sol))
  ;(define asserted
  ;  (with-asserts-only
  ;    (@addition x y)))
  ;(check-equal? (asserts) null)
  ;(check-equal? (length asserted) 1)
  ;(define cond (first asserted))
  ;(define sol (verify (asserted cond)))
  ;(check-sat sol))

(define ioflow-tests
  (test-suite+
    "Test for Interger Overflow in ioflow.c"

    (parameterize ([current-machine (make-machine)])
    (test-case+ "check-ioflow-sane" (check-symbolic-addition))
    (test-case+ "check-ioflow-sol" (check-buggy-addition))
    ))) 

(module+ test
        (time (run-tests ioflow-tests)))