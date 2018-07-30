; JESS aplinkoje komentarus pasalinkite
;
; (clear)

; Templates
(deftemplate fragment
	(slot from) (slot to) (slot from_street_name) (slot to_street_name))

(deftemplate car
	(slot location))

(deftemplate obstacles
	(slot location) (slot tlights) (slot cars) (slot pedestrians) (slot spec_service))

; Facts
(deffacts facts-initialization
	; Car initialization
	(car (location 0))
	; Route initialization
	(fragment (from 1) (to 3) (from_street_name "Radvilenu pl.") (to_street_name "J.Mateikos g."))
	(fragment (from 3) (to 5) (from_street_name "J.Mateikos g.") (to_street_name "J.Basanaviciaus al."))
	(fragment (from 5) (to 7) (from_street_name "J.Basanaviciaus al.") (to_street_name "S.Moniuskos g."))
	(fragment (from 7) (to 9) (from_street_name "S.Moniuskos g.") (to_street_name "M.Jankaus g."))
	(fragment (from 9) (to 11) (from_street_name "M.Jankaus g.") (to_street_name "Radvilenu pl."))
	(fragment (from 11) (to 13) (from_street_name "Radvilenu pl.") (to_street_name "Radvilenu pl."))
	; Obstacles initialization
	(obstacles (location 2) (tlights "green") (cars 2) (pedestrians 1) (spec_service 0))
	(obstacles (location 4) (tlights "green") (cars 5) (pedestrians 0) (spec_service 0))
	(obstacles (location 6) (tlights "red") (cars 3) (pedestrians 2) (spec_service 1))
	(obstacles (location 8) (tlights "green") (cars 0) (pedestrians 4) (spec_service 2))
	(obstacles (location 10) (tlights "red") (cars 2) (pedestrians 0) (spec_service 0))
	(obstacles (location 12) (tlights "yellow") (cars 1) (pedestrians 2) (spec_service 1)))

; Rules
(defrule r1 "Start and finish of the trip"
	?fact-id <- (car (location ?current_location))
	(fragment (to ?to1))
	(not (fragment (to ?to2&:(> ?to2 ?to1))))	; Searching for the fact "fragment" which has maximum slot "to" value among facts
	(test 
		(or
			(= ?current_location 0)		; Location - start
			(= ?current_location ?to1)	; Location - finish
		)
	)
	=>
	(if (= ?current_location 0)
		then (modify ?fact-id (location 1)) (printout t "Car has started the trip." crlf)
		else (modify ?fact-id (location (+ ?to1 1))) (printout t "Car has reached the destination." crlf)
	)
)

(defrule r2 "Car movement"
	?fact-id <- (car (location ?current_location))
	(fragment (from ?from) (to ?to) (from_street_name ?fsn) (to_street_name ?tsn))
	(obstacles (location ?obs_loc) (tlights ?tlights) (cars ?cars) (pedestrians ?pedestrians) (spec_service ?sp_serv))
	(test
		; No obstacles in front of the car
		(and
			(> ?obs_loc ?current_location)
			(< ?obs_loc (+ ?current_location 2))
			(eq ?tlights "green")
			(= ?cars 0)
			(= ?pedestrians 0)
			(= ?sp_serv 0)
			(= ?from ?current_location)
		)
	)
	=>
	(modify ?fact-id (location (+ ?current_location 2))) 
	(printout t "No obstacles left in path No. " ?obs_loc " and traffic light (if there is one) is green. Car moves from \"\(" ?from "\) " ?fsn "\" to \"\(" ?to "\) " ?tsn "\"." crlf)
)

(defrule r3 "Obstacles simulation"
	(car (location ?current_location))
	?fact-id <- (obstacles (location ?obs_loc) (tlights ?tlights) (cars ?cars) (pedestrians ?pedestrians) (spec_service ?sp_serv))
	(test 
		(and
			(= ?obs_loc (+ ?current_location 1) )
			(or
				(neq ?tlights "green")
				(!= ?cars 0)
				(!= ?pedestrians 0)
				(!= ?sp_serv 0)
			)
		)
	)
	=>
	(if (> ?sp_serv 0)
		then (modify ?fact-id (spec_service (- ?sp_serv 1))) (printout t "Car lets special service car through." crlf)
		else (if (> ?pedestrians 0)
				 then (modify ?fact-id (pedestrians (- ?pedestrians 1))) (printout t "Car lets pedestrians through." crlf) 
				 else (if (> ?cars 0)
							then (modify ?fact-id (cars (- ?cars 1))) (printout t "Car lets another car through." crlf)
							else (if (eq ?tlights "red")
										then (modify ?fact-id (tlights "yellow")) (printout t "Traffic light is red at the moment. Car is waiting for the traffic light to change to yellow." crlf)
										else (if (eq ?tlights "yellow")
													then (modify ?fact-id (tlights "green")) (printout t "Traffic light is yellow at the moment. Car is waiting for the traffic light to change to green." crlf))))))
)

; JESS aplinkoje komentarus pasalinkite
;
; (reset)
; (facts)
; (watch all)
; (run)