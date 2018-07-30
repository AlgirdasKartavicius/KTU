; JESS aplinkoje komentarus pasalinkite
;
; (clear)

(deftemplate pele (slot spalva) (slot kiekis) )
(deftemplate katino (slot busena) (slot suvalgyta_peliu) (slot bado_dienos))

(deffacts faktu-inicializavimas
  (pele (spalva pilka) (kiekis 5))
  (pele (spalva balta) (kiekis 3))
  (katino (busena "alkanas") (suvalgyta_peliu 0) (bado_dienos 0))
)

(defrule r1 "Kai katinas alkanas, jis nori valgyti"
  ?fact-id <- (katino (busena ?busena))  
  (test (eq ?busena "alkanas"))
  =>
  (modify ?fact-id (busena "nori valgyti"))
)
(defrule r2 "Kai katinas nori valgyti ir yra peliu, jis valgo peles"
  ?fact-id1 <- (katino (busena "nori valgyti") (suvalgyta_peliu ?suvalgyta))
  ?fact-id2 <- (pele (spalva ?spalva) (kiekis ?kiekis))
  (test (> ?kiekis 0))
  =>
  
  (if (eq ?spalva balta) then (printout t "py-py!" crlf)
                         else (printout t "pyyyyy" crlf))
  (modify ?fact-id2 (kiekis (- ?kiekis 1))  )
  
  (modify ?fact-id1 (suvalgyta_peliu (+ ?suvalgyta 1)) ) 
  (printout t "miau" crlf)
)

(defrule r3 "kai katinas suvalgo 5 peles, jis tampa storu katinu"
  (declare (salience 10))
  ?fact-id1 <- (katino (busena "nori valgyti") (suvalgyta_peliu ?suvalgyta))
  (test (= ?suvalgyta 5)) 
  
=>
  (modify ?fact-id1 (busena "storas"))
)

(defrule r4 "Kai katinas storas, jis nori miego"
	?fact-id <- (katino (busena ?busena))  
	(test (eq ?busena "storas"))
	=>
	(modify ?fact-id (busena "nori miego"))
)

(defrule r5 "Kai katinas nori miego, jis miega"
	?fact-id <- (katino (busena ?busena))  
	(test (eq ?busena "nori miego"))
	=>
	(modify ?fact-id (busena "eina miegoti"))
)

(defrule r6 "Kai katinas miega, po to jis keliasi"
	?fact-id <- (katino (busena ?busena))  
	(test (eq ?busena "eina miegoti"))
	=>
	(modify ?fact-id (busena "keliasi"))
)

(defrule r7 "Kai katinas keliasi, jis yra alkanas"
	?fact-id1 <- (katino (busena ?busena))
	(test (eq ?busena "keliasi"))
	=>
	(modify ?fact-id1 (busena "alkanas")(suvalgyta_peliu 0))
)

(defrule r8 "Jei nera peliu, katinas badauja"
	?fact-id <- (katino (busena "nori valgyti")(bado_dienos ?badauja))
	(pele (spalva balta)(kiekis 0))
	(pele (spalva pilka)(kiekis 0))
	=>
	(modify ?fact-id (bado_dienos (+ ?badauja 1)) ) 
)

(defrule r9 "Jei katinas badauja 7 dienas, jis mirsta"
	(declare (salience 10))
	?fact-id <- (katino (busena "nori valgyti")(bado_dienos ?badauja))
	(test (= ?badauja 7))
	=>
	(modify ?fact-id (busena "mirsta"))
)

; JESS aplinkoje komentarus pasalinkite
;
; (reset)
; (facts)
; (watch all)
; (run)
