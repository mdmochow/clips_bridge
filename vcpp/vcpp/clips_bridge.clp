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






(deftemplate card
	(slot player)
	(slot suit)
	(slot name)
)


(deftemplate bid
	(slot number)
	(slot player)
	(slot type)
	(slot level)
	(slot suit)
)


(defglobal ?*dealt-cards* = 0)

(defrule pick-top-card-N
	?picked <- (state N-should-pick)
	(not(state picked-a-card))
	(state print-deck)
	?drawed-card <- (draw-pile ?name ?suit ?)
	(test (< ?*dealt-cards* 52))
=>
	(bind ?*dealt-cards* (+ ?*dealt-cards* 1))
	(assert (card (player N)(suit ?suit)(name ?name)))
	(assert (state picked-a-card))
	(retract ?drawed-card)
	(retract ?picked)
	(assert (state E-should-pick))
)

(defrule pick-top-card-E
	?picked <- (state E-should-pick)
	(not(state picked-a-card))
	(state print-deck)
	?drawed-card <- (draw-pile ?name ?suit ?)
	(test (< ?*dealt-cards* 52))
=>
	(bind ?*dealt-cards* (+ ?*dealt-cards* 1))
	(assert (card (player E)(suit ?suit)(name ?name)))
	(assert (state picked-a-card))
	(retract ?drawed-card)
	(retract ?picked)
	(assert (state S-should-pick))
)

(defrule pick-top-card-S
	?picked <- (state S-should-pick)
	(not(state picked-a-card))
	(state print-deck)
	?drawed-card <- (draw-pile ?name ?suit ?)
	(test (< ?*dealt-cards* 52))
=>
	(bind ?*dealt-cards* (+ ?*dealt-cards* 1))
	(assert (card (player S)(suit ?suit)(name ?name)))
	(assert (state picked-a-card))
	(retract ?drawed-card)
	(retract ?picked)
	(assert (state W-should-pick))
)

(defrule pick-top-card-W
	?picked <- (state W-should-pick)
	(not(state picked-a-card))
	(state print-deck)
	?drawed-card <- (draw-pile ?name ?suit ?)
	(test (< ?*dealt-cards* 52))
=>
	(bind ?*dealt-cards* (+ ?*dealt-cards* 1))
	(assert (card (player W)(suit ?suit)(name ?name)))
	(assert (state picked-a-card))
	(retract ?drawed-card)
	(retract ?picked)
	(assert (state N-should-pick))
)

(defrule picked-a-card
	?state-fact <- (state picked-a-card)
=>
	(retract ?state-fact)
)





(deffunction cardvalue(?card-name)
	(switch ?card-name
		(case ace then (return 4))
		(case king then (return 3))
		(case queen then (return 2))
		(case jack then (return 1))
		(default (return 0))
	)
	(return 0)
)

(defglobal ?*N-pc* = 0)
(defglobal ?*E-pc* = 0)
(defglobal ?*S-pc* = 0)
(defglobal ?*W-pc* = 0)

(defrule calculate-pc-N
	(card (player N)(suit ?)(name ?card-name))
=>
	(bind ?*N-pc* (+ ?*N-pc* (cardvalue ?card-name)))
	(printout t ?*N-pc* crlf)
)

(defrule calculate-pc-E
	(card (player E)(suit ?)(name ?card-name))
=>
	(bind ?*E-pc* (+ ?*E-pc* (cardvalue ?card-name)))
	(printout t ?*E-pc* crlf)
)

(defrule calculate-pc-S
	(card (player S)(suit ?)(name ?card-name))
=>
	(bind ?*S-pc* (+ ?*S-pc* (cardvalue ?card-name)))
	(printout t ?*S-pc* crlf)
)

(defrule calculate-pc-W
	(card (player W)(suit ?)(name ?card-name))
=>
	(bind ?*W-pc* (+ ?*W-pc* (cardvalue ?card-name)))
	(printout t ?*W-pc* crlf)
)

(defglobal ?*pass-count* = 0)
(defglobal ?*bids-made* = 0)


(defrule end-of-bidding
	(test (= ?*pass-count* 3))
=>
	(assert (state bidding-finished))
)

(defrule bid-pass
	(not(state bidding-finished))
	(not(state bid-made))
	;?bid-player <- (state N-should-bid)
	?bid-player <- (player ?bidder)
	(bid (number ?bid-nr)(player ?)(type ?)(level ?bid-lvl)(suit ?bid-suit))
	(test (= ?*bids-made* ?bid-nr))
=>
	;(retract ?bid-player)
	;(assert (state E-should-bid))
	(assert (state bid-made))
	(bind ?*bids-made* (+ ?*bids-made* 1))
	(assert (bid (number ?*bids-made*)(player ?bidder)(type pass)(level 0)(suit empty)))
	(retract ?bid-player)
)

(defrule made-a-bid
	?bidfact <- (state bid-made)
=>
	(retract ?bidfact)
)