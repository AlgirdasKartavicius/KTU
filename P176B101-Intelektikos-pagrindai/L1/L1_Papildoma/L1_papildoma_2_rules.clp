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
	(fragment (from 1) (to 3) (from_street_name "\(START\) Radvilenu pl.") (to_street_name "J.Mateikos g."))
	(fragment (from 3) (to 5) (from_street_name "J.Mateikos g.") (to_street_name "J.Basanaviciaus al."))
	(fragment (from 5) (to 7) (from_street_name "J.Basanaviciaus al.") (to_street_name "S.Moniuskos g."))
	(fragment (from 7) (to 9) (from_street_name "S.Moniuskos g.") (to_street_name "M.Jankaus g."))
	(fragment (from 9) (to 11) (from_street_name "M.Jankaus g.") (to_street_name "Radvilenu pl."))
	(fragment (from 11) (to 13) (from_street_name "Radvilenu pl.") (to_street_name "\(FINISH\) Radvilenu pl."))
	; Obstacles initialization
	(obstacles (location 2) (tlights "green") (cars 2) (pedestrians 1) (spec_service 0))
	(obstacles (location 4) (tlights "green") (cars 5) (pedestrians 0) (spec_service 0))
	(obstacles (location 6) (tlights "red") (cars 3) (pedestrians 2) (spec_service 1))
	(obstacles (location 8) (tlights "green") (cars 0) (pedestrians 4) (spec_service 2))
	(obstacles (location 10) (tlights "red") (cars 2) (pedestrians 0) (spec_service 0))
	(obstacles (location 12) (tlights "yellow") (cars 1) (pedestrians 2) (spec_service 1)))

; Rules
(defrule r1 "Car movement"
	(declare (salience 10))
	?fact-id <- (car (location ?current_location))
	(fragment (from ?from) (from_street_name ?fsn) (to_street_name ?tsn))
	(obstacles (location ?obs_loc) (tlights ?tlights) (cars ?cars) (pedestrians ?pedestrians) (spec_service ?sp_serv))
	(or (test 	(or 	(= ?current_location 0)
						(= ?current_location 13) ))
		(test   (and 	(> ?obs_loc ?current_location)
						(< ?obs_loc (+ ?current_location 2))
						(eq ?tlights "green")
						(= ?cars 0)
						(= ?pedestrians 0)
						(= ?sp_serv 0)
						(= ?from ?current_location))))
	=>
	(if (= ?current_location 0) 
		then (modify ?fact-id (location 1)) (printout t "Car has started the trip." crlf)
		else (if (= ?current_location 13)
				 then (modify ?fact-id (location 14)) (printout t "Car has reached the destination." crlf)
				 else (modify ?fact-id (location (+ ?current_location 2))) (printout t "No obstacles left and traffic light (if there is one) is green. Car moves from \"" ?fsn "\" to \"" ?tsn "\"."crlf)))
)

(defrule r2 "Obstacles simulation"
	(car (location ?current_location))
	?fact-id <- (obstacles (location ?obs_loc) (tlights ?tlights) (cars ?cars) (pedestrians ?pedestrians) (spec_service ?sp_serv))
	(test (= ?obs_loc (+ ?current_location 1) ))
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