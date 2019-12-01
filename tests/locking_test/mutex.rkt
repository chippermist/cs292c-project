#lang rosette

(require (except-in rackunit fail)
         rackunit/text-ui
         racket/trace
         rosette/lib/roseunit
         rosette/lib/angelic
         serval/llvm
         serval/lib/unittest
         serval/lib/core
         "generated/racket/test/mutex.globals.rkt"
         "generated/racket/test/mutex.map.rkt")
         
(require "generated/racket/test/mutex.ll.rkt")

(define COUNT 0)

(define-symbolic count (bitvector 64))

(define (impl-inv)
  (bvult (mblock-iload (symbol->block 'count) null) (bv COUNT 0)))

(define (check-mutex)
  (define pre-inv (impl-inv))
  (define-symbolic* x i32)
  (choose* (@increment_count x) (@get_count x))
  (define inc-thread (thread @increment_count x))
  (define get-thread  (thread @get_count x))
  (for-each thread-wait
          (list (check-equal? (inc-thread) 0) (check-equal? (get-thread) 0)))
  (displayln "Current thread is " current-thread)
  (for-each thread-wait
          (list (inc-thread) (get-thread)))
  (check-equal? (inc-thread) 0)
  (check-equal? (get-thread) -1)
)

(define mutex-tests
  (test-suite+
    "Test for Mutex Lock in mutex.c"

    (parameterize ([current-machine (make-machine)])
    (test-case+ "check-mutex" (check-mutex))
    )))

(module+ test
        (time run-tests mutex-tests))