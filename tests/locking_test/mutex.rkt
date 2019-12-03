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

(define (check-global-val x)
  (parameterize ([current-machine (make-machine symbols globals)])
    (define exp (bv x i32))
    (check-not-equal? (@get_count_value) exp)
    (@set_count_value exp)
    (define act (@get_count_value))
    (check-equal? act exp)
    (check-not-equal? (@get_lock_value) exp)
    (@set_lock_value exp)
    (define lock_act (@get_lock_value))
    (check-equal? lock_act exp)
    
))

(define (check-global-concrete)
  (check-global-val 1)
  (check-global-val 0)
  (check-equal? (asserts) null)
)

(define (impl-inv)
  ;(bvult (mblock-iload (symbol->block 'count) null) (bv COUNT 0)))
  (parameterize ([current-machine (make-machine symbols globals)])
  (@set_lock_value (bv 0 i32))
  (@set_count_value (bv 1 i32))))

(define (check-mutex)
  ;(displayln "1")
  (parameterize ([current-machine (make-machine symbols globals)])
    (define pre-inv (impl-inv))
    ;(displayln "2")
    ;(@set_lock_value (bv 0 i32))
    ;(@set_count_value (bv 0 i32))
    ;(displayln "3")
    (define-symbolic* x i32)
    ;(displayln "4")
    (choose* (@increment_count x) (@get_count))
    ;(displayln "5")
    (define inc-thread (thread (lambda() (@increment_count x))))
    ; making a inherently infinite loop 
    ;(define inc-thread (thread (lambda() 
    ;  (let loop()
    ;    (@increment_count x)
    ;    (sleep 0.5)
    ;    (loop)))))
    ; making a inherently infinite loop 
    ;(define get-thread  (thread (lambda() 
    ;  (let loop() 
    ;    (@get_count x) 
    ;    (sleep 0.7)
    ;    (loop)))))
    (define get-thread (thread (lambda() (@get_count))))
    ;(thread-send inc-thread 'done)
    ;(thread-send get-thread 'done)
    ;(displayln "threads sent")
    (for-each thread-wait (list inc-thread get-thread))
    ;(thread-wait get-thread)
    ;(displayln "thread recieved")
    ;(for-each thread-wait
    ;        (list (check-equal? (thread-send inc-thread 'done) 0) (check-equal? (thread-send get-thread 'done) 0)))
    ;(displayln "6")
    (displayln "Current thread is ")
    (displayln current-thread)
    ;(displayln "7")
    ;(for-each thread-wait
    ;        (list (inc-thread) (get-thread)))
    ;(check-equal? (inc-thread) 0)
    ;(check-equal? (get-thread) -1)
    ;(displayln "8")
    ;(call-in-nested-thread (inc-thread) (get-thread))
))

(define mutex-tests
  (test-suite+
    "Test for Mutex Lock in mutex.c"

    (parameterize ([current-machine (make-machine)])
    (test-case+ "check-global-values-concerete" (check-global-concrete))
    (test-case+ "check-mutex" (check-mutex))
    )))

(module+ test
        (time (run-tests mutex-tests)))