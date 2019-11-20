#lang rosette

(require (except-in rackunit fail)
	 rackunit/text-ui
	 rosette/lib/roseunit
	 serval/llvm
	 serval/lib/unittest
	 serval/lib/core)

(require "generated/racket/test/divzero.ll.rkt")

(define-symbolic x y i32)

(define (check-div x y #:result [result (/ x y)])
  (check-equal? (@division (bv x i32) (bv y i32)) (bv result i32)))

(define (check-symbolic-division)
  (check-equal? (@division x (bv 0 i32)) (bv 0 i32))
  (check-equal? (@division x (bv 1 i32)) x)
  (check-equal? (@division (bv 0 i32) y) (bv 0 i32))
  (check-equal? (asserts) null))

(define (check-buggy-div)
  (define asserted
    (with-asserts-only
      (@division_bug x y)))
  (check-equal? (asserts) null)
  (check-equal? (length asserted) 1)
  (define cond (first asserted))
  (define sol (verify (asserted cond)))
  (check-sat sol))

(define divzero-tests
  (test-suite+
    "Tests for divzero.c"

    (parameterize ([current-machine (make-machine)])
	(test-case+ "division-symbolic" (check-symbolic-division))
	(test-case+ "division-buggy" (check-buggy-div)))))

(module+ test
	 (time run-tests divzero-tests))
