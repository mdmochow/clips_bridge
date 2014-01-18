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
	;(printout t ?number ": " ?name " of " ?suit " has value " (card-value ?name) crlf)
	(retract ?nextcard)
	(assert (next-card (+ ?number 1)))
)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




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


(defglobal ?*dealt-cards* = 52)


(deffacts our-card-set
	(card (player N)(suit spades)(name seven))
	(card (player N)(suit spades)(name nine)) 
	(card (player N)(suit spades)(name ten)) 
	(card (player N)(suit hearts)(name three)) 
	(card (player N)(suit hearts)(name five)) 
	(card (player N)(suit hearts)(name ten)) 
	(card (player N)(suit hearts)(name queen)) 
	(card (player N)(suit hearts)(name king)) 
	(card (player N)(suit diamonds)(name two)) 
	(card (player N)(suit diamonds)(name ace)) 
	(card (player N)(suit clubs)(name three)) 
	(card (player N)(suit clubs)(name jack)) 
	(card (player N)(suit clubs)(name king)) 
	(card (player E)(suit hearts)(name seven)) 
	(card (player E)(suit clubs)(name four)) 
	(card (player E)(suit clubs)(name ace)) 
	(card (player E)(suit clubs)(name queen)) 
	(card (player E)(suit diamonds)(name seven)) 
	(card (player E)(suit diamonds)(name four)) 
	(card (player E)(suit hearts)(name six)) 
	(card (player E)(suit diamonds)(name ten)) 
	(card (player E)(suit clubs)(name seven)) 
	(card (player E)(suit clubs)(name six)) 
	(card (player E)(suit clubs)(name eight)) 
	(card (player E)(suit diamonds)(name three)) 
	(card (player E)(suit diamonds)(name eight)) 
	(card (player S)(suit spades)(name king)) 
	(card (player S)(suit diamonds)(name queen)) 
	(card (player S)(suit clubs)(name nine)) 
	(card (player S)(suit spades)(name ace)) 
	(card (player S)(suit spades)(name eight)) 
	(card (player S)(suit hearts)(name ace)) 
	(card (player S)(suit spades)(name jack)) 
	(card (player S)(suit clubs)(name five)) 
	(card (player S)(suit spades)(name five)) 
	(card (player S)(suit diamonds)(name nine)) 
	(card (player S)(suit clubs)(name ten)) 
	(card (player S)(suit spades)(name three)) 
	(card (player S)(suit spades)(name queen)) 
	(card (player W)(suit hearts)(name two)) 
	(card (player W)(suit spades)(name two)) 
	(card (player W)(suit diamonds)(name jack)) 
	(card (player W)(suit hearts)(name nine)) 
	(card (player W)(suit spades)(name four)) 
	(card (player W)(suit diamonds)(name king)) 
	(card (player W)(suit clubs)(name two)) 
	(card (player W)(suit hearts)(name eight)) 
	(card (player W)(suit spades)(name six)) 
	(card (player W)(suit diamonds)(name five)) 
	(card (player W)(suit hearts)(name four)) 
	(card (player W)(suit hearts)(name jack)) 
	(card (player W)(suit diamonds)(name six)) 
)



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

(deftemplate points
	(slot player)
	(slot pc)
)

(deftemplate hand
	(slot player)
	(slot spades)
	(slot hearts)
	(slot diamonds)
	(slot clubs)
)
	

(deffacts pre-calc-pts
	(points (player N)(pc 0))
	(points (player E)(pc 0))
	(points (player S)(pc 0))
	(points (player W)(pc 0))
	(hand (player N)(spades 0)(hearts 0)(diamonds 0)(clubs 0))
	(hand (player E)(spades 0)(hearts 0)(diamonds 0)(clubs 0))
	(hand (player S)(spades 0)(hearts 0)(diamonds 0)(clubs 0))
	(hand (player W)(spades 0)(hearts 0)(diamonds 0)(clubs 0))
)	

(defglobal ?*N-pc* = 0)
(defglobal ?*E-pc* = 0)
(defglobal ?*S-pc* = 0)
(defglobal ?*W-pc* = 0)



(defrule calculate-pc-N
	(card (player N)(suit ?)(name ?card-name))
	?pc-fact <- (points (player N)(pc ?pts))
	(test (< ?*N-pts-calc* 13))
=>
	(bind ?*N-pts-calc* (+ ?*N-pts-calc* 1))
	(retract ?pc-fact)
	(bind ?pts (+ ?pts (cardvalue ?card-name)))
	(assert (points (player N)(pc ?pts)))
	(bind ?*N-pc* (+ ?*N-pc* (cardvalue ?card-name)))
	(printout t ?*N-pc* crlf)
)

(defrule calculate-pc-E
	?pc-fact <- (points (player E)(pc ?pts))
	(card (player E)(suit ?)(name ?card-name))
=>
	(retract ?pc-fact)
	(bind ?pts (+ ?pts (cardvalue ?card-name)))
	(assert (points (player E)(pc ?pts)))
	(bind ?*E-pc* (+ ?*E-pc* (cardvalue ?card-name)))
	;(printout t ?*E-pc* crlf)
)
 
(defrule calculate-pc-S
	?pc-fact <- (points (player S)(pc ?pts))
	(card (player S)(suit ?)(name ?card-name))
=>
	(retract ?pc-fact)
	(bind ?pts (+ ?pts (cardvalue ?card-name)))
	(assert (points (player S)(pc ?pts)))
	(bind ?*S-pc* (+ ?*S-pc* (cardvalue ?card-name)))
	;(printout t ?*S-pc* crlf)
)
 
(defrule calculate-pc-W
	?pc-fact <- (points (player W)(pc ?pts))
	(card (player W)(suit ?)(name ?card-name))
=>
	(retract ?pc-fact)
	(bind ?pts (+ ?pts (cardvalue ?card-name)))
	(assert (points (player W)(pc ?pts)))
	(bind ?*W-pc* (+ ?*W-pc* (cardvalue ?card-name)))
	;(printout t ?*W-pc* crlf)
)

;(defrule calculate-spades
; 	(card (player ?owner)(suit spades)(name ?))
; 	?hand-fact <- (hand (player ?owner)(spades ?S)(hearts ?H)(diamonds ?D)(clubs ?C))
;=>
; 	(retract ?hand-fact)
; 	(bind ?S (+ ?S 1))
; 	(assert (hand (player ?owner)(spades ?S)(hearts ?H)(diamonds ?D)(clubs ?C)))
;)
; 
;(defrule calculate-hearts
; 	(card (player ?owner)(suit hearts)(name ?))
; 	?hand-fact <- (hand (player ?owner)(spades ?S)(hearts ?H)(diamonds ?D)(clubs ?C))
;=>
; 	(retract ?hand-fact)
; 	(bind ?S (+ ?S 1))
; 	(assert (hand (player ?owner)(spades ?S)(hearts ?H)(diamonds ?D)(clubs ?C)))
;)
; 
;(defrule calculate-diamonds
; 	(card (player ?owner)(suit diamonds)(name ?))
; 	?hand-fact <- (hand (player ?owner)(spades ?S)(hearts ?H)(diamonds ?D)(clubs ?C))
;=>
; 	(retract ?hand-fact)
; 	(bind ?S (+ ?S 1))
; 	(assert (hand (player ?owner)(spades ?S)(hearts ?H)(diamonds ?D)(clubs ?C)))
;)
; 
;(defrule calculate-clubs
; 	(card (player ?owner)(suit clubs)(name ?))
; 	?hand-fact <- (hand (player ?owner)(spades ?S)(hearts ?H)(diamonds ?D)(clubs ?C))
;=>
; 	(retract ?hand-fact)
; 	(bind ?S (+ ?S 1))
; 	(assert (hand (player ?owner)(spades ?S)(hearts ?H)(diamonds ?D)(clubs ?C)))
;)

(defglobal ?*pass-count* = 0)
(defglobal ?*bids-made* = 0)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defrule made-a-bid
	?bidfact <- (state bid-made)
=>
	(retract ?bidfact)
)

(defrule bid-pass
	;(made-a-bid)
	;(not(state bid-made))
	;?bid-player <- (state N-should-bid)
	?bid-player <- (player ?bidder)
	(bid (number ?bid-nr)(player ?)(type ?)(level ?bid-lvl)(suit ?bid-suit))
	(test (= ?*bids-made* ?bid-nr))
=>
	(retract ?bid-player)
	;(assert (state E-should-bid))
	;(assert (state bid-made))
	(bind ?*bids-made* (+ ?*bids-made* 1))
	(assert (bid (number ?*bids-made*)(player ?bidder)(type pass)(level 0)(suit empty)))
)

(deffunction end-of-bidding ()
	(if (and (> ?*pass-count* 2)(> ?*bids-made* 3))
	    then
		1
	    else
		0)
)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(deffacts bidding-facts
	(bidding no-opening)
)


(deftemplate bidding-opening
	(slot player)
	(slot level)
	(slot suit)
)



(defrule bidding-ourplayer-opened
	?opening <- (bidding no-opening)
	(bid (number ?)(player ?bid-player)(type normal)(level ?bid-lvl)(suit ?bid-suit))
=>
	(retract ?opening)
	(assert (bidding-opening (player ?bid-player)(level ?bid-lvl)(suit ?bid-suit)))
)


(defrule bidding-open-one-major
	(bidding no-opening)
	?bid-player <- (player ?bidder)
	(points (player N)(pc ?pts))
	(test (>= ?pts 12))
=>
	(retract ?bid-player)
)