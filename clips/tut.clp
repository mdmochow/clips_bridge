(defglobal ?*shuffleswaps* = 150)

(deffacts cards
	(card-names ace two three four five six seven eight nine ten jack queen king)
	(card-values 1 2 3 4 5 6 7 8 9 10 10 10 10)
	(card-suits hearts clubs diamonds spades)
)

(defrule go
	(initial-fact)
=>
	(assert (state create-pack))
)

(defrule create-cards
	?old-state <- (state create-pack)
	(card-names $?names)
	(card-suits $?suits)
=>
	(bind ?number 0)
	(loop-for-count (?suit 1 4) do
		(loop-for-count (?name 1 13) do
			(bind ?number (+ ?number 1))
			(assert (draw-pile (nth$ ?name ?names) (nth$ ?suit ?suits) ?number))
		)
	)
	(assert (top-card 1))
	(retract ?old-state)
	(assert (state shuffle-pack))
)

(defrule start-shuffle
	(state shuffle-pack)
	(not (swap-count ?))
=>
	(seed (round (time)))
	(assert (swap-count 1))
	(assert (swap-position1 (round (+ (* (/ (random) 32767) 51) 1))))
	(assert (swap-position2 (round (+ (* (/ (random) 32767) 51) 1))))
)

(defrule shuffle-pack
	(state shuffle-pack)
	?swapcard1 <- (swap-position1 ?cp1)
	?swapcard2 <- (swap-position2 ?cp2)
	?swapcount <- (swap-count ?cc)
	(test (< ?cc ?*shuffleswaps*))
	?card1 <- (draw-pile ?name1 ?suit1 ?cp1)
	?card2 <- (draw-pile ?name2 ?suit2 ?cp2)
=>
	(retract ?card1)
	(retract ?card2)
	(retract ?swapcount)
	(retract ?swapcard1)
	(retract ?swapcard2)
	(assert (draw-pile ?name1 ?suit1 ?cp2))
	(assert (draw-pile ?name2 ?suit2 ?cp1))
	(assert (swap-count (+ ?cc 1)))
	(assert (swap-position1 (round (+ (* (/ (random) 32767) 51) 1))))
	(assert (swap-position2 (round (+ (* (/ (random) 32767) 51) 1))))
)


(defrule pack-shuffled
	?state <- (state shuffle-pack)
	?swapcount <- (swap-count ?cc)
	(test (= ?cc ?*shuffleswaps*))
=>
	(retract ?swapcount)
	(retract ?state)
	(assert (state print-deck))
)

(deffunction card-value
	(?card-name)
	(switch ?card-name
		(case ace then (bind ?return-value 1))
		(case two then (bind ?return-value 2))
		(case three then (bind ?return-value 3))
		(case four then (bind ?return-value 4))
		(case five then (bind ?return-value 5))
		(case six then (bind ?return-value 6))
		(case seven then (bind ?return-value 7))
		(case eight then (bind ?return-value 8))
		(case nine then (bind ?return-value 9))
		(case ten then (bind ?return-value 10))
		(case jack then (bind ?return-value 10))
		(case queen then (bind ?return-value 10))
		(case king then (bind ?return-value 10))
		(default (bind ?return-value 0))
	)
	(return ?return-value)
)

(defrule start-printdeck
	(state print-deck)
	(not (next-card ?))
	(top-card ?topcard)
=>
	(assert (next-card ?topcard))
)

(defrule printdeck
	(state print-deck)
	?nextcard <- (next-card ?number)
	(draw-pile ?name ?suit ?number)
=>
	(printout t ?number ": " ?name " of " ?suit " has value " (card-value ?name) crlf)
	(retract ?nextcard)
	(assert (next-card (+ ?number 1)))
)

