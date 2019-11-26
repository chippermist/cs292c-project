#lang rosette

(require (except-in rackunit fail)
         rackunit/text-ui
         racket/trace
         rosette/lib/roseunit
         serval/llvm
         serval/lib/unittest
         serval/lib/core)

(require "generated/racket/test/locks.ll.rkt")

(define A (bv 2 i32))
(define B (bv 3 i32))


;(define-symbolic x y (bitvector 32))

; racket implementation

(define (mutex_lock_test val1 val2)
  (define L 0)
  (displayln "checking if zero")
  (check-equal? L 0 "L is not zero")
  (displayln "adding one")
  (set! L (+ L 1))
  (displayln "checking if one")
  (check-equal? L 1 "L is not one")
  (define r 0)
  (displayln "Define r as 0")
  (set! r (bvadd val1 val2))
  (displayln "subtracting one")
  (set! L (- L 1))
  (displayln "checking if zero again")
  (check-equal? L 0)
r)

; define the function to check

(define (check-mutex-lock-1)
  (displayln " Inside check-mutex-lock-1 testing code")
  (define-symbolic x i32)
  (displayln "Defined x")
  (define-symbolic y i32)
  (displayln "Defined y")
  (define res (mutex_lock_test A B))
  (displayln "WHYNOWORK!!")
  ;(define val (@test_lock (bv 2 i32) (bv 2 i32)))
  ;(val)
  (displayln "Got test-lock value")
	(displayln "solving..")
  ;(check-unsat? (verify (assert (equal? (mutex_lock_test (bv 2 i32) (bv 2 i32)) (@test_lock (bv 2 i32) (bv 2 i32))))))
  (check-equal? (@test_lock x y) (mutex_lock_test x y)))
; define test

(define lock-tests
  (test-suite+
    "Test for Mutex Lock in locks.c"

    (parameterize ([current-machine (make-machine)])
    (test-case+ "check-mutex-lock-1" (check-mutex-lock-1)))))

(trace mutex_lock_test)
(module+ test
        (time (run-tests lock-tests)))

