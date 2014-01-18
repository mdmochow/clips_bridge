(deftemplate card
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


(deffacts our-card-set
	(card (suit spades)(name seven))
	(card (suit spades)(name nine)) 
	(card (suit spades)(name ten)) 
	(card (suit hearts)(name three)) 
	(card (suit hearts)(name five)) 
	(card (suit hearts)(name ten))
	(card (suit hearts)(name queen))
	(card (suit hearts)(name king))
	(card (suit diamonds)(name two))
	(card (suit diamonds)(name ace))
	(card (suit clubs)(name three))
	(card (suit clubs)(name jack))
	(card (suit clubs)(name king))
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


(defglobal ?*pc* = 0)
(defglobal ?*spades* = 0)
(defglobal ?*hearts* = 0)
(defglobal ?*diamonds* = 0)
(defglobal ?*clubs* = 0)


(defrule calculate-pc
	(card (suit ?)(name ?card-name))
=>
	(bind ?*pc* (+ ?*pc* (cardvalue ?card-name)))
	(printout t ?*pc* crlf)
)


(defrule calculate-S
	(card (suit spades)(name ?))
=>
	(bind ?*spades* (+ ?*spades* 1))
	(printout t ?*spades* crlf)
)


(defrule calculate-H
	(card (suit hearts)(name ?))
=>
	(bind ?*hearts* (+ ?*hearts* 1))
	(printout t ?*hearts* crlf)
)


(defrule calculate-D
	(card (suit diamonds)(name ?))
=>
	(bind ?*diamonds* (+ ?*diamonds* 1))
	(printout t ?*diamonds* crlf)
)


(defrule calculate-C
	(card (suit clubs)(name ?))
=>
	(bind ?*clubs* (+ ?*clubs* 1))
	(printout t ?*clubs* crlf)
)


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