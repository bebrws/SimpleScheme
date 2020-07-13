//
//  HelpView.swift
//  SimpleScheme
//
//  Created by Bradley Barrows on 7/12/20.
//  Copyright © 2020 Bradley Barrows. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

let tokensPage = """
This is a list of tokens used:
define
define-syntax-rule
begin
let
set!
lambda
λ
if
+
-
*
/
<
>
=
and
or
null?
list
car
cdr
cons
append
quote
quasiquote
error
apply
eval
write
display
displayln
print
newline
call/cc
define-syntax-rule
"""

let outputPage = """
(displayln 1)
(displayln "hey"

Will print out:
1
hey

"""

let firstPage = """
SimpleScheme supports the R5RS Scheme spcification("with a bit of racket thrown in")

It is using the Scheme interpreter from this project:

https://github.com/kenpratt/rusty_scheme/

This repo also has some helpful examples to get started.
Continue along with the slider to view more information about using this interpreter.
"""

let printingPage = """
(define (dump what s)
  (displayln what)
  (write s)
  (newline)
  (display s)
  (newline)
  (print s)
  (newline)
  (newline))

(dump "symbol" 'blah)
(dump "int" 23)
(dump "bool" #t)
(dump "string" "blah")
(dump "list" '(blah 23 #t "blah" (blah 23 #t "blah")))
(dump "proc" dump)

;;
;; Expected output:
;;
;; symbol
;; blah
;; blah
;; 'blah
;;
;; int
;; 23
;; 23
;; 23
;;
;; bool
;; #t
;; #t
;; #t
;;
;; string
;; "blah"
;; blah
;; "blah"
;;
;; list
;; (blah 23 #t "blah" (blah 23 #t "blah"))
;; (blah 23 #t blah (blah 23 #t blah))
;; '(blah 23 #t "blah" (blah 23 #t "blah"))
;;
;; proc
;; #<procedure:dump>
;; #<procedure:dump>
;; #<procedure:dump>

"""

let tailPage = """
(define (tco-test)
  (define (f i)
    (if (= i 100000)
        (displayln "made it to 100000")
        (f (+ i 1))))
  (f 1)
  (displayln "done"))

(tco-test)

"""

let threadPage = """
;; FIFO queue.
(define thread-pool '())

;; Push to end of queue.
(define (push-thread t)
  (set! thread-pool (append thread-pool (list t))))

;; Pop from front of queue.
(define (pop-thread)
  (if (null? thread-pool)
      '()
      (let ((t (car thread-pool)))
        (set! thread-pool (cdr thread-pool))
        t)))

;; To start, set the exit function to the point.
(define (start)
  (call/cc
   (lambda (cc)
     (set! exit cc)
     (run-next-thread))))

;; Exit point will be defined when start is run.
(define exit '())

;; Run the next thread in line. If no more, call exit.
(define (run-next-thread)
  (let ((t (pop-thread)))
    (if (null? t)
        (exit)
        (t))))

;; Create a new thread
(define (spawn fn)
  (push-thread
   (lambda ()
     (fn)
     (run-next-thread))))

;; Yield saves the running state of the current thread,
;; and then runs the next one.
(define (yield)
  (call/cc
   (lambda (cc)
     (push-thread cc)
     (run-next-thread))))

(spawn
 (lambda ()
   (displayln "Hello from thread #1")
   (yield)
   (displayln "Hello again from thread #1")
   (yield)
   (displayln "Hello once more from thread #1")))

(spawn
 (lambda ()
   (displayln "Hello from thread #2")
   (yield)
   (displayln "Hello again from thread #2")
   (yield)
   (displayln "Hello once more from thread #2")))

(displayln "Starting...")
(start)
(displayln "Done")

"""


struct HelpView: SwiftUI.View {
    @State var settings:UserSettings
    @State private var page:Double = 0.0
    var body: some SwiftUI.View {
        VStack {
            Text("Help")
            Spacer()
            if (self.page == 0.0) {
                Text("General Information")
                TextView(text: firstPage)
            }
            if (self.page == 1.0) {
                Text("Print to stdout(displayed in the console):")
                TextView(text: outputPage)
            }
            if (self.page == 2.0) {
                Text("Tokens:")
                TextView(text: tokensPage)
            }
            if (self.page == 3.0) {
                Text("Example (printing):")
                TextView(text: printingPage)
            }
            if (self.page == 4.0) {
                Text("Example (printing):")
                TextView(text: tailPage)
            }
            if (self.page == 5.0) {
                Text("Example (printing):")
                TextView(text: threadPage)
            }
            Spacer()
            VStack {
                Text("Help Page: " + String(Int(self.page)))
                Slider(value: self.$page, in: 0...5.0, step: 1.0)
            }
        }
    }
}
