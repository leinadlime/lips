(test "numbers: operation without args"
      (lambda (t)
        (t.is (+) 0)
        (t.is (*) 1)
        (t.is (-) -1)))

(test "numbers: rational"
      (lambda (t)
        (let* ((a 1/2) (b 1/4) (a+b (+ a b)))
          (t.is (= a+b 3/4) true)
          (t.is (number->string a+b) "3/4")
          (t.is (number->string (+ 1/2 1/2)) "1")
          (t.is (number->string (+ 1/2 1/2 1.0)) "2.0")
          (t.is (number->string (+ 1/2 1/2 1/2)) "3/2"))))

(test "numbers: complex rational"
      (lambda (t)

        (t.is  (/ (make-rectangular 1 2) (make-rectangular 2 10))
               (/ 1+2i 2+10i))))

(test "numbers: not numbers"
      (lambda (t)
        (t.is (. (lips.parse "0.1/0.1") 0) '0.1/0.1)
        (t.is (. (lips.parse "#i1/2i+0.1+0.1") 0) '(vector i1/2i+0.1+0.1))
        (t.is (. (lips.parse "1/2i+0.1+0.1") 0) '1/2i+0.1+0.1)
        (t.is (. (lips.parse "1/2/3") 0) '1/2/3)
        (t.is (. (lips.parse "/2/3") 0) '/2/3) ;; not regex
        (t.is (. (lips.parse "#e0.1/0.1") 0) '(vector e0.1/0.1))))

(test "numbers: literals"
      (lambda (t)

        (t.is (number->string (. (lips.parse "#i1e10") 0)) "10000000000.0")
        (t.is (number->string (. (lips.parse "#i1e+10") 0)) "10000000000.0")
        (t.is (number->string (. (lips.parse "1e10") 0)) "10000000000")
        (t.is (number->string (. (lips.parse "#e1e10") 0)) "10000000000")
        (t.is (number->string (. (lips.parse "#e1e+10") 0)) "10000000000")
        (t.is (number->string (. (lips.parse "1.2e+20") 0)) "120000000000000000000")
        (t.is (number->string (. (lips.parse "1.2e+100") 0)) "12000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000")
        (t.is (number->string (. (lips.parse "#e1.2e+100") 0)) "12000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000")
        (t.is (number->string (. (lips.parse "#e1.9999999999999999999e-10") 0)) "19999999999999999999/100000000000000000000000000000")
        (t.is (number->string (. (lips.parse "#i1e+100") 0)) "1.0e+100")
        (t.is (number->string (. (lips.parse "#i1e-100") 0)) "1.0e-100")
        (t.is (number->string (. (lips.parse "1.2e-100") 0)) "1.2e-100")
        (t.is (number->string (. (lips.parse "#i1e-10000000") 0)) "0.0")
        (t.is (number->string (. (lips.parse "1e-1000") 0)) "0.0")
        (t.is (number->string (. (lips.parse "#e1.2e-100") 0)) "3/25000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000")
        (t.is (number->string (. (lips.parse "#e1e-1000") 0)) "1/10000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000")
        (t.is (number->string (. (lips.parse "#e1e-2") 0)) "1/100")
        (t.is (number->string (. (lips.parse "1e-2") 0)) "0.01")
        (t.is (number->string (. (lips.parse "#i1e-2") 0)) "0.01")
        (t.is (number->string (. (lips.parse "1.2e1") 0)) "12")
        (t.is (number->string (. (lips.parse "1.2e100") 0)) "12000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000")

        (t.is (number->string (. (lips.parse "#i100") 0)) "100.0")
        (t.is (number->string (. (lips.parse "#i100i") 0)) "+100.0i")

        (t.is (number->string (. (lips.parse "#i1/0") 0)) "Infinity")
        (t.is (number->string (. (lips.parse "#i-1/0") 0)) "-Infinity")

        (t.is #b100+100i 4+4i)
        (t.is (number->string 100) "100")
        (t.is (number->string -100) "-100")
        (t.is (number->string #e100.0) "100")
        (t.is (number->string #e0.01) "1/100")
        (t.is (number->string #i100) "100.0")
        (t.is (number->string #i-100) "-100.0")

        (t.is (number->string #o#i100) "64.0")
        (t.is (number->string #i#o100) "64.0")
        (t.is (number->string #i#o-100) "-64.0")

        (t.is (number->string #x100) "256")
        (t.is (number->string #x#i100) "256.0")
        (t.is (number->string #x#i-100) "-256.0")
        (t.is (number->string #i#x100) "256.0")
        (t.is (number->string #i#x-100) "-256.0")

        (t.is (number->string #b100) "4")
        (t.is (number->string #b#i100) "4.0")
        (t.is (number->string #i#b100) "4.0")
        (t.is (number->string #i#b-100) "-4.0")

        (t.is (number->string 1/100) "1/100")
        (t.is (number->string -1/100) "-1/100")
        (t.is (number->string #i1/100) "0.01")
        (t.is (number->string #i-1/100) "-0.01")

        (t.is (number->string #o1/100) "1/64")
        (t.is (number->string #o-1/100) "-1/64")
        (t.is (number->string #o#i1/100) "0.015625")
        (t.is (number->string #o#i-1/100) "-0.015625")
        (t.is (number->string #i#o1/100) "0.015625")
        (t.is (number->string #i#o-1/100) "-0.015625")

        (t.is (number->string #b1/100) "1/4")
        (t.is (number->string #b-1/100) "-1/4")
        (t.is (number->string #b#i1/100) "0.25")
        (t.is (number->string #b#i-1/100) "-0.25")
        (t.is (number->string #i#b1/100) "0.25")
        (t.is (number->string #i#b-1/100) "-0.25")

        (t.is (number->string #x1/100) "1/256")
        (t.is (number->string #x-1/100) "-1/256")
        (t.is (number->string #x#i1/F) "0.06666666666666667")
        (t.is (number->string #x#i-1/F) "-0.06666666666666667")
        (t.is (number->string #i#x1/F) "0.06666666666666667")
        (t.is (number->string #i#x-1/F) "-0.06666666666666667")

        (t.is (number->string 10e+1) "100")
        (t.is (number->string -10e+1) "-100")
        (t.is (number->string #i10e+1) "100.0")
        (t.is (number->string #i-10e+1) "-100.0")

        (t.is (number->string 1.0i) "+1.0i")
        (t.is (number->string -1.0i) "-1.0i")
        (t.is (number->string #e-1.0i) "-1i")
        (t.is (number->string 100i) "+100i")
        (t.is (number->string #i100i) "+100.0i")
        (t.is (number->string #i#b100i) "+4.0i")

        (t.is (number->string #xA+Ai) "10+10i")

        ;; uppercase
        (t.is (number->string #E0.1) "1/10")
        (t.is (number->string #I10) "10.0")
        (t.is (number->string #I#B10) "2.0")
        (t.is (number->string #X#IA) "10.0")
        (t.is (number->string #XA) "10")
        (t.is (number->string #XAa) "170")
        (t.is (number->string #O#I77) "63.0")
        (t.is (number->string #O77) "63")

        (t.is (number->string #e0.1+0.1i) "1/10+1/10i")
        (t.is (number->string #b100+100i) "4+4i")
        (t.is (number->string #b#i100+100i) "4.0+4.0i")
        (t.is (number->string #i#b100+100i) "4.0+4.0i")
        (t.is (number->string #i#b-100-100i) "-4.0-4.0i")
        (t.is (number->string #b#i-100-100i) "-4.0-4.0i")
        (t.is (number->string #b-100i) "-4i")
        (t.is (number->string #i#b+100i) "+4.0i")
        (t.is (number->string #b#i-100i) "-4.0i")
        (t.is (number->string #i#b+1/10i) "+0.5i")
        (t.is (number->string #i#b1/10i) "+0.5i")
        ;; mixed
        (t.is (number->string 1/2+10i) "1/2+10i")
        (t.is (number->string -1/2+10i) "-1/2+10i")
        (t.is (number->string -1/2-10i) "-1/2-10i")
        (t.is (number->string +10+1/2i) "10+1/2i")
        (t.is (number->string +10-1/2i) "10-1/2i")
        (t.is (number->string -10+1/2i) "-10+1/2i")
        (t.is (number->string -10-1/2i) "-10-1/2i")

        (t.is (number->string 1/2+0.01i) "1/2+0.01i")
        (t.is (number->string 0.01+1/2i) "0.01+1/2i")
        (t.is (number->string 0.01+10i) "0.01+10i")
        (t.is (number->string 0.01+1/10i) "0.01+1/10i")

        ;; just i
        (t.is (number->string +i) "+1i")
        (t.is (number->string -i) "-1i")
        (t.is (number->string 10+i) "10+1i")

        (t.is (number->string 10-i) "10-1i")
        (t.is (number->string -10-i) "-10-1i")
        (t.is (number->string -10+i) "-10+1i")

        (t.is (number->string 1/2+i) "1/2+1i")
        (t.is (number->string 1/2-i) "1/2-1i")
        (t.is (number->string +1/2+i) "1/2+1i")
        (t.is (number->string +1/2-i) "1/2-1i")
        (t.is (number->string -1/2+i) "-1/2+1i")
        (t.is (number->string -1/2-i) "-1/2-1i")

        ;; re rational+binary
        (t.is (number->string #b1/10-i) "1/2-1i")
        (t.is (number->string #b1/10+i) "1/2+1i")
        (t.is (number->string #b-1/10-i) "-1/2-1i")
        (t.is (number->string #b-1/10+i) "-1/2+1i")

        ;; inexact+rational+binary
        (t.is (number->string #i#b1/10-i) "0.5-1.0i")
        (t.is (number->string #i#b1/10+i) "0.5+1.0i")
        (t.is (number->string #i#b-1/10-i) "-0.5-1.0i")
        (t.is (number->string #i#b-1/10+i) "-0.5+1.0i")

        ;; reversed mnemonics
        (t.is (number->string #b#i1/10-i) "0.5-1.0i")
        (t.is (number->string #b#i1/10+i) "0.5+1.0i")
        (t.is (number->string #b#i-1/10-i) "-0.5-1.0i")
        (t.is (number->string #b#i-1/10+i) "-0.5+1.0i")

        ;; re int+binary
        (t.is (number->string #b10-i) "2-1i")
        (t.is (number->string #b10+i) "2+1i")
        (t.is (number->string #b-10-i) "-2-1i")
        (t.is (number->string #b-10+i) "-2+1i")

        (t.is (number->string #i#b1/100+1/100i) "0.25+0.25i")
        (t.is (number->string #i#b-1/100+1/100i) "-0.25+0.25i")
        (t.is (number->string #b#i1/100+1/100i) "0.25+0.25i")
        (t.is (number->string #b#i-1/100+1/100i) "-0.25+0.25i")))

(test "numbers: string->number"
      (lambda (t)
        ;; edge cases - big nums and hex
        (t.is (string->number "1e2" 16) 482)
        (t.is (string->number "1e2") 100)

        ;; accept radix
        (t.is (string->number "A" 16) 10)
        (t.is (string->number "10" 8) 8)
        (t.is (string->number "10" 2) 2)

        (t.is (string->number "1/A" 16) 1/10)
        (t.is (string->number "1/10" 8) 1/8)
        (t.is (string->number "1/10" 2) 1/2)

        (t.is (string->number "A+Ai" 16) 10+10i)
        (t.is (string->number "10+10i" 8) 8+8i)
        (t.is (string->number "10+10i" 2) 2+2i)

        ;; reject radix
        (t.is (string->number "#x10" 10) #x10)
        (t.is (string->number "#o10" 10) #o10)
        (t.is (string->number "#b10" 10) #b10)

        (t.is (string->number "#x1/10" 10) 1/16)
        (t.is (string->number "#o1/10" 10) 1/8)
        (t.is (string->number "#b1/10" 10) 1/2)

        (t.is (string->number "#x10+10i" 10) 16+16i)
        (t.is (string->number "#o10+10i" 10) 8+8i)
        (t.is (string->number "#b10+10i" 10) 2+2i)))

(test "numbers: complex"
      (lambda (t)
        (t.is (sqrt -1) +1.0i)
        (t.is (sqrt 0.5) 0.7071067811865476)
        (t.is (sqrt -0.5) +0.7071067811865476i)
        (t.is (number->string 1e+1i) "+10.0i")
        (t.is (number->string .1i) "+0.1i")
        (t.is (number->string (/ 10+1i +10i)) "1/10-1i")
        (t.is (number->string (make-rectangular 1/2 2/4)) "1/2+1/2i")
        (t.is (/ (make-rectangular 1 2) (make-rectangular 2 10)) 11/52-3/52i)
        (t.is (number->string #e0.5+0.5i) "1/2+1/2i")
        (t.is (number->string #i1/2+2/4i) "0.5+0.5i")
        (t.is (number->string #e0.5+0.1i) "1/2+1/10i")
        (t.is (< 0.1i 0.2i) true)
        (t.is (> 0.1i 0.2i) false)))

(test "numbers: modulo functions"
      (lambda (t)
        (t.is (modulo 13 4) 1)
        (t.is (remainder 13 4) 1)

        (t.is (modulo -13 4) 3)
        (t.is (remainder -13 4) -1)

        (t.is (modulo 13 -4) -3)
        (t.is (remainder 13 -4) 1)

        (t.is (modulo -13 -4) -1)
        (t.is (remainder -13 -4) -1)

        (t.is (remainder -13 -4.0) -1.0)))

(test "numbers: operators +"
  (lambda (t)
    (t.is (+ 1 1.0 1/10) 2.1)
    (t.is (number->string (+ 1/2 1/2 1.0)) "2.0")

    (t.is (number->string (+ 1 1)) "2")

    (t.is (number->string (+ 1 1.1)) "2.1")
    (t.is (number->string (+ 1.1 1)) "2.1")

    (t.is (number->string (+ 1/2 1/3)) "5/6")
    (t.is (number->string (+ 1 1/2)) "3/2")
    (t.is (number->string (+ 1/2 1)) "3/2")

    (t.is (number->string (+ 1.1 1/2)) "1.6")
    (t.is (number->string (+ 1/2 1.1)) "1.6")

    ;; TODO: handle mixed types as in Kawa
    (t.is (+ 0.1 10i) 0.1+10i)
    (t.is (+ 10 0.01i) 10+0.01i)
    (t.is (+ 1/10 0.01i) 1/10+0.01i)
    (t.is (+ 0.01 1/10i) 0.01+1/10i)
    (t.is (+ 1/10 #b100i) 1/10+4i)
    (t.is (+ #b100 1/10i) 4+1/10i)

    ;; reversed
    (t.is (+ 10i 0.1) 0.1+10i)
    (t.is (+ 0.01i 10) 10+0.01i)
    (t.is (+ 0.01i 1/10) 1/10+0.01i)
    (t.is (+ 1/10i 0.01) 0.01+1/10i)
    (t.is (+ #b100i 1/10) 1/10+4i)
    (t.is (+ 1/10i #b100) 4+1/10i)

    (t.is (+ 10i 10i) 20i)
    (t.is (+ 10 10i) 10+10i)
    (t.is (+ 10i 10) 10+10i)))

(test "numbers: operators /"
      (lambda (t)
        (t.is (/ 10 10) 1)
        (t.is (/ 10 1/10) 100)
        (t.is (/ 10 2) 5)
        (t.is (/ 10 3) 10/3)
        (t.is (/ 10 2.0) 5.0)

        (t.is (/ 1 10+10i) 1/20-1/20i)
        (t.is (/ 1 10+10.0i) 0.05-0.05i)
        (t.is (/ 1 10+1/10i) 1000/10001-10/10001i)

        (t.is (/ 1 1.0+1.0i) 0.5-0.5i)
        (t.is (/ 1 1.0+1i) 0.5-0.5i)
        (t.is (/ 1 1.0+1/2i) 0.8-0.4i)

        (t.is (/ 1 1/10+1/10i) 5-5i)
        (t.is (/ 1 1/10+1i) 10/101-100/101i)
        (t.is (/ 1 1/2+1.0i) 0.4-0.8i)

        (t.is (/ 1/2 10) 1/20)
        (t.is (/ 1/2 10.0) 0.05)
        (t.is (/ 1/2 1/2) 1)

        (t.is (/ 1/2 10+10i) 1/40-1/40i)
        (t.is (/ 1/2 1+2.0i) 0.1-0.2i)
        (t.is (/ 1/2 1+1/2i) 2/5-1/5i)

        (t.is (/ 1/2 10.0+10.0i) 0.025-0.025i)
        (t.is (/ 1/2 10.0+10i) 0.025-0.025i)
        (t.is (/ 1/2 1.0+1/2i) 0.4-0.2i)

        (t.is (/ 1/2 1/20+1/20i) 5-5i)
        (t.is (/ 1/2 1/2+1i) 1/5-2/5i)
        (t.is (/ 1/2 1/2+1.0i) 0.2-0.4i)

        (t.is (/ 1.0 1.0) 1.0)
        (t.is (/ 1.0 2) 0.5)
        (t.is (/ 1.0 1/10) 10.0)

        (t.is (/ 1.0 1+1i) 0.5-0.5i)
        (t.is (/ 1.0 1+1.0i) 0.5-0.5i)
        (t.is (/ 1.0 1+1/2i) 0.8-0.4i)

        (t.is (/ 1.0 1.0+1.0i) 0.5-0.5i)
        (t.is (/ 1.0 1.0+1i) 0.5-0.5i)
        (t.is (/ 1.0 1.0+1/2i) 0.8-0.4i)

        (t.is (/ 1.0 1/2+1/2i) 1.0-1.0i)
        (t.is (/ 1.0 1/2+1.0i) 0.4-0.8i)
        (t.is (/ 1.0 1/2+1i) 0.4-0.8i)))

(test "numbers: sqrt"
      (lambda (t)
        (for-each (lambda (x)
                    (t.is (sqrt (* x x)) x))
                  '(5 5+2i 1/5+1/2i 1/2 5.0 8/9))

        (for-each (lambda (pair)
                    (let ((x (car pair)))
                      (t.is (sqrt (* x x)) (cdr pair))))
                  '((2.0+1/2i . 2+0.5i)))

        (for-each (lambda (pair)
                    (let ((x (car pair)))
                      (t.is (sqrt (* x x)) (cdr pair))))
                  '((2+1/2i . 2+0.5i)
                    (2+0.5i . 2+0.5i)

                    (1/2+2.0i . 0.5+2i)
                    (1/2+2i . 0.5+2i)

                    (0.5+2i . 0.5+2i)
                    (0.5+1/2i . 0.5+0.5i)))

        (t.is (sqrt -9) 3i)))

(test "numbers: eq?"
      (lambda (t)

        ;; eq? on numbers is unspecifed - in lisp if two numbers are the same
        ;; but not the same object they are equal

        (t.is (eq? 10.0i 10i) #f)
        (t.is (eq? 10i 10i) #t)
        (t.is (eq? 10.0 10) #f)

        (t.is (let ((ret (/ 10i 10.0)))
                (list (inexact? ret) (= ret 1.0i) (not (eq? ret 1i))))
              '(#t #t #t))

        (t.is (let ((ret (/ 10i 10)))
                (list (exact? ret) (= ret 1i) (not (eq? ret 1i))))
              '(#t #t #f))))

(test "numbers: bignum"
      (lambda (t)

        (define (! n) (apply * (cdr (range (+ n 1)))))

        (t.snapshot (! 10))
        (t.snapshot (--> (! 8000) (toString)))))
