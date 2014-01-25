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


;(deffacts our-card-set
; 	(card (suit spades)(name seven))
; 	(card (suit spades)(name nine)) 
; 	(card (suit spades)(name ten)) 
; 	(card (suit hearts)(name three)) 
; 	(card (suit hearts)(name five)) 
; 	(card (suit hearts)(name ten))
; 	(card (suit hearts)(name queen))
; 	(card (suit hearts)(name king))
; 	(card (suit diamonds)(name two))
; 	(card (suit diamonds)(name ace))
; 	(card (suit clubs)(name three))
; 	(card (suit clubs)(name jack))
; 	(card (suit clubs)(name king))
;)


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
(defglobal ?*pass-count* = 0)
(defglobal ?*bids-made* = 0)
(defglobal ?*ourplayer* = N)
(defglobal ?*partner* = S)


(defrule calculate-pc
	(card (suit ?)(name ?card-name))
=>
	(bind ?*pc* (+ ?*pc* (cardvalue ?card-name)))
)


(defrule calculate-S
	(card (suit spades)(name ?))
=>
	(bind ?*spades* (+ ?*spades* 1))
)


(defrule calculate-H
	(card (suit hearts)(name ?))
=>
	(bind ?*hearts* (+ ?*hearts* 1))
)


(defrule calculate-D
	(card (suit diamonds)(name ?))
=>
	(bind ?*diamonds* (+ ?*diamonds* 1))
)


(defrule calculate-C
	(card (suit clubs)(name ?))
=>
	(bind ?*clubs* (+ ?*clubs* 1))
)


(deffunction end-of-bidding ()
	(if (and (> ?*pass-count* 2)(> ?*bids-made* 3))
	    then
		1
	    else
		0)
)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(deffacts bidding-facts
	(bidding no-opening)
)


(deftemplate bidding-opening
	(slot player)
	(slot level)
	(slot suit)
	(slot forcing)
)



(defrule bidding-find-forcing-opening
	?opening <- (bidding no-opening)
	(bid (number ?)(player ?bid-player)(type normal)(level 2)(suit clubs))
=>
	(retract ?opening)
	(assert (bidding-opening (player ?bid-player)(level 2)(suit clubs)(forcing yes)))
)


(defrule bidding-find-opening
	?opening <- (bidding no-opening)
	(not (bid (number ?)(player ?bid-player)(type normal)(level 2)(suit clubs)))
	(bid (number ?)(player ?bid-player)(type normal)(level ?bid-lvl)(suit ?bid-suit))
	(not (test (= ?bid-lvl 2)))
=>
	(retract ?opening)
	(assert (bidding-opening (player ?bid-player)(level ?bid-lvl)(suit ?bid-suit)(forcing no)))
)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; blocking openings (2/3, 6-10 pc)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(deffunction get-six-plus-in-suit()
	(if (>= ?*spades* 6)
	    	then
			spades
		else
			(if (>= ?*hearts* 6)
			    	then
					hearts
				else
					(if (>= ?*diamonds* 6)
					    	then
							diamonds
						else
							(if (>= ?*clubs* 7)
							    	then
									clubs
							)
					)
			)
	)
)


(deffunction determine-block-level()
	(if (>= ?*spades* 7)
	    	then
			3
		else
			(if (>= ?*hearts* 7)
			    	then
					3
				else
					(if (>= ?*diamonds* 7)
					    	then
							3
						else
							(if (>= ?*clubs* 7)
							    	then
									3
								else
									2
							)
					)
			)
	)
)


(defrule bidding-open-blocking
	?bidfact <- (bidding our-player-should-bid)
	?opening <- (bidding no-opening)
	(test (>= ?*pc* 6))
	(test (<= ?*pc* 10))
	(or (test (>= ?*spades* 6)) (test (>= ?*hearts* 6)) (test (>= ?*diamonds* 6)) (test (>= ?*clubs* 7)))
=>
	(retract ?bidfact)
	(bind ?*bids-made* (+ ?*bids-made* 1))
	(bind ?*pass-count* 0)
	(assert (bid (number ?*bids-made*)(player ?*ourplayer*)(type normal)(level (determine-block-level))(suit (get-six-plus-in-suit))))
	(assert (bidding made-a-bid))
	(retract ?opening)
	(assert (bidding-opening (player ?*ourplayer*)(level (determine-block-level))(suit (get-six-plus-in-suit))(forcing no)))
)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; strong opening (acol, 22+ pc)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule bidding-open-acol
	(declare (salience -1))
	?bidfact <- (bidding our-player-should-bid)
	?opening <- (bidding no-opening)
	(test (>= ?*pc* 22))
=>
	(retract ?bidfact)
	(bind ?*bids-made* (+ ?*bids-made* 1))
	(bind ?*pass-count* 0)
	(assert (bid (number ?*bids-made*)(player ?*ourplayer*)(type normal)(level 2)(suit clubs)))
	(assert (bidding made-a-bid))
	(retract ?opening)
	(assert (bidding-opening (player ?*ourplayer*)(level 2)(suit clubs)(forcing yes)))
)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; NT openings (1NT, 15-17 pc / 1C+NT, 18-19 pc / 2NT, 20-21 pc / 2C+2NT, 22-24 pc / 2C+3NT, 25-27 pc)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(deffunction check-if-less-than-in-suits(?amount)
	(if (>= ?*spades* ?amount)
	    	then
			FALSE
		else
			(if (>= ?*hearts* ?amount)
			    	then
					FALSE
				else
					(if (>= ?*diamonds* ?amount)
					    	then
							FALSE
						else
							(if (>= ?*clubs* ?amount)
							    	then
									FALSE
								else
									TRUE
							)
					)
			)
	)
)

(deffunction check-if-less-than-in-majors(?amount)
	(if (>= ?*spades* ?amount)
	    	then
			FALSE
		else
			(if (>= ?*hearts* ?amount)
			    	then
					FALSE
				else
					TRUE
			)
	)
)

(deffunction check-if-more-than-in-suits(?amount)
	(if (<= ?*spades* ?amount)
	    	then
			FALSE
		else
			(if (<= ?*hearts* ?amount)
			    	then
					FALSE
				else
					(if (<= ?*diamonds* ?amount)
					    	then
							FALSE
						else
							(if (<= ?*clubs* ?amount)
							    	then
									FALSE
								else
									TRUE
							)
					)
			)
	)
)


(deffunction check-if-balanced-hand-with-one-five()
	(if (= ?*spades* 5)
		then
			(if (or (< ?*hearts* 2) (> ?*hearts* 3))
				then
					FALSE
				else
					(if (or (< ?*diamonds* 2) (> ?*diamonds* 3))
						then
							FALSE
						else
							(if (or (< ?*clubs* 2) (> ?*clubs* 3))
								then
									FALSE
								else
									TRUE
							)
					)
			)		
		else
	 	 	(if (= ?*hearts* 5)
	 	 	    	then
	 	 			(if (or (< ?*spades* 2) (> ?*spades* 3))
	 	 			    	then
	 	 					FALSE
	 	 				else
	 	 					(if (or (< ?*diamonds* 2) (> ?*diamonds* 3))
	 	 			    			then
	 	 							FALSE
	 	 						else
	 	 							(if (or (< ?*clubs* 2) (> ?*clubs* 3))
	 	 					    		    	then
	 	 									FALSE
	 	 								else
	 	 									TRUE
	 	 							)
	 	 					)
	 	 			)
	 			else
	 				(if (= ?*diamonds* 5)
	 					then
	 						(if (or (< ?*spades* 2) (> ?*spades* 3))
	 							then
	 								FALSE
	 							else
	 								(if (or (< ?*hearts* 2) (> ?*hearts* 3))
	 									then
	 										FALSE
	 									else
	 										(if (or (< ?*clubs* 2) (> ?*clubs* 3))
	 											then
	 												FALSE
	 											else
	 												TRUE
	 										)
	 								)
	 						)
	 					else
	 						(if (= ?*clubs* 5)
	 	 						then
	 	 							(if (or (< ?*spades* 2) (> ?*spades* 3))
	 	 								then
	 	 									FALSE
	 	 								else
	 	 									(if (or (< ?*hearts* 2) (> ?*hearts* 3))
	 	 										then
	 	 											FALSE
	 	 										else
	 	 											(if (or (< ?*diamonds* 2) (> ?*diamonds* 3))
	 	 												then
	 	 													FALSE
	 	 												else
	 	 													TRUE
	 	 											)
	 	 									)
	 	 							)
	 	 					)
	 				)
	 		)
	)
)
	

(defrule bidding-open-1NT
	?bidfact <- (bidding our-player-should-bid)
	?opening <- (bidding no-opening)
	(test (>= ?*pc* 15))
	(test (<= ?*pc* 17))
	(or (and (test (check-if-less-than-in-suits 5)) (test (check-if-more-than-in-suits 1))) (test (check-if-balanced-hand-with-one-five)))
=>
	(retract ?bidfact)
	(bind ?*bids-made* (+ ?*bids-made* 1))
	(bind ?*pass-count* 0)
	(assert (bid (number ?*bids-made*)(player ?*ourplayer*)(type normal)(level 1)(suit NT)))
	(retract ?opening)
	(assert (bidding-opening (player ?*ourplayer*)(level 1)(suit NT)(forcing no)))
)
	

(defrule bidding-open-1C-NT
	?bidfact <- (bidding our-player-should-bid)
	?opening <- (bidding no-opening)
	(test (>= ?*pc* 18))
	(test (<= ?*pc* 19))
	(or (and (test (check-if-less-than-in-suits 5)) (test (check-if-more-than-in-suits 1))) (test (check-if-balanced-hand-with-one-five)))
=>
	(retract ?bidfact)
	(bind ?*bids-made* (+ ?*bids-made* 1))
	(bind ?*pass-count* 0)
	(assert (bid (number ?*bids-made*)(player ?*ourplayer*)(type normal)(level 1)(suit clubs)))
	(retract ?opening)
	(assert (bidding-opening (player ?*ourplayer*)(level 1)(suit clubs)(forcing no)))
	(assert (bidding ourplayer-should-rebid-NT 1))
)
	

(defrule bidding-open-2NT
	?bidfact <- (bidding our-player-should-bid)
	?opening <- (bidding no-opening)
	(test (>= ?*pc* 20))
	(test (<= ?*pc* 21))
	(or (and (test (check-if-less-than-in-suits 5)) (test (check-if-more-than-in-suits 1))) (test (check-if-balanced-hand-with-one-five)))
=>
	(retract ?bidfact)
	(bind ?*bids-made* (+ ?*bids-made* 1))
	(bind ?*pass-count* 0)
	(assert (bid (number ?*bids-made*)(player ?*ourplayer*)(type normal)(level 2)(suit NT)))
	(retract ?opening)
	(assert (bidding-opening (player ?*ourplayer*)(level 2)(suit NT)(forcing no)))
)
	

(defrule bidding-open-2C-2NT
	?bidfact <- (bidding our-player-should-bid)
	?opening <- (bidding no-opening)
	(test (>= ?*pc* 22))
	(test (<= ?*pc* 24))
	(or (and (test (check-if-less-than-in-suits 5)) (test (check-if-more-than-in-suits 1))) (test (check-if-balanced-hand-with-one-five)))
=>
	(retract ?bidfact)
	(bind ?*bids-made* (+ ?*bids-made* 1))
	(bind ?*pass-count* 0)
	(assert (bid (number ?*bids-made*)(player ?*ourplayer*)(type normal)(level 2)(suit clubs)))
	(retract ?opening)
	(assert (bidding-opening (player ?*ourplayer*)(level 2)(suit clubs)(forcing yes)))
	(assert (bidding ourplayer-should-rebid-NT 2))
)
	

(defrule bidding-open-2C-3NT
	?bidfact <- (bidding our-player-should-bid)
	?opening <- (bidding no-opening)
	(test (>= ?*pc* 25))
	(test (<= ?*pc* 27))
	(or (and (test (check-if-less-than-in-suits 5)) (test (check-if-more-than-in-suits 1))) (test (check-if-balanced-hand-with-one-five)))
=>
	(retract ?bidfact)
	(bind ?*bids-made* (+ ?*bids-made* 1))
	(bind ?*pass-count* 0)
	(assert (bid (number ?*bids-made*)(player ?*ourplayer*)(type normal)(level 2)(suit clubs)))
	(retract ?opening)
	(assert (bidding-opening (player ?*ourplayer*)(level 2)(suit clubs)(forcing yes)))
	(assert (bidding ourplayer-should-rebid-NT 3))
)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; other openings (12+ pc)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(deffunction get-five-plus-in-major-suit()
	(if (> ?*hearts* ?*spades*)
	        then
			hearts
		else
			spades
	)
)

(defrule bidding-open-1-major
	(declare (salience -100))
	?bidfact <- (bidding our-player-should-bid)
	?opening <- (bidding no-opening)
	(test (>= ?*pc* 12))
	(or (test (>= ?*spades* 5)) (test (>= ?*hearts* 5)))
=>
	(retract ?bidfact)
	(bind ?*bids-made* (+ ?*bids-made* 1))
	(bind ?*pass-count* 0)
	(assert (bid (number ?*bids-made*)(player ?*ourplayer*)(type normal)(level 1)(suit (get-five-plus-in-major-suit))))
	(retract ?opening)
	(assert (bidding-opening (player ?*ourplayer*)(level 1)(suit (get-five-plus-in-major-suit))(forcing no)))
)

(deffunction get-minor-suit()
	(if (= ?*diamonds* 3)
	        then
			(if (>= ?*clubs* ?*diamonds*)
			    	then
					clubs
				else
					diamonds
			)
		else
			(if (> ?*clubs* ?*diamonds*)
			       	then
					clubs
				else
					diamonds
			)
	)
)

(defrule bidding-open-1-minor
	(declare (salience -100))
	?bidfact <- (bidding our-player-should-bid)
	?opening <- (bidding no-opening)
	(test (>= ?*pc* 12))
	(not (or (test (>= ?*spades* 5)) (test (>= ?*hearts* 5))))
=>
	(retract ?bidfact)
	(bind ?*bids-made* (+ ?*bids-made* 1))
	(bind ?*pass-count* 0)
	(assert (bid (number ?*bids-made*)(player ?*ourplayer*)(type normal)(level 1)(suit (get-minor-suit))))
	(retract ?opening)
	(assert (bidding-opening (player ?*ourplayer*)(level 1)(suit (get-minor-suit))(forcing no)))
	(assert (bidding ourplayer-should-not-bid-over-1NT))
)


(defrule bid-pass
	(declare (salience -10000))
	?bidfact <- (bidding our-player-should-bid)
=>
	(retract ?bidfact)
	(bind ?*bids-made* (+ ?*bids-made* 1))
	(assert (bid (number ?*bids-made*)(player ?*ourplayer*)(type pass)(level 0)(suit empty)))
	(assert (bidding made-a-bid))
)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; responses to openings
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(deffunction return-cards-in-colour(?bid-suit)
	(if (= (str-compare ?bid-suit spades) 0)
	       then
			?*spades*
		else
			(if (= (str-compare ?bid-suit hearts) 0)
			       then
					?*hearts*
				else
					(if (= (str-compare ?bid-suit diamonds) 0)
					       then
							?*diamonds*
						else
							?*clubs*
					)
			)
	)
)
 
(deffunction return-bid-level(?bid-level ?bid-suit ?new-bid)
	(if (= (str-compare ?bid-suit spades) 0)
	       then
			(+ ?bid-level 1)
		else
			(if (= (str-compare ?bid-suit hearts) 0)
			       then
					(if (= (str-compare ?new-bid spades) 0)
					       then
							?bid-level
						else
							(+ ?bid-level 1)
					)
				else
					(if (= (str-compare ?bid-suit diamonds) 0)
					       then
							(if (or (= (str-compare ?new-bid spades) 0) (= (str-compare ?new-bid hearts) 0))
								then
									?bid-level
								else
									(+ ?bid-level 1)
							)
						else
							(if (= (str-compare ?new-bid clubs) 0)
								then
									(+ ?bid-level 1)
								else
									?bid-level
							)
					)
			)
	)
)
 
(deffunction return-bid-level-jump(?bid-level ?bid-suit ?new-bid)
	(+ (return-bid-level ?bid-level ?bid-suit ?new-bid) 1)
)
 
 
(deffunction get-longest-suit()
	(if (and (>= ?*spades* ?*hearts*) (>= ?*spades* ?*diamonds*) (>= ?*spades* ?*clubs*))
		then
			spades
		else
			(if (and (>= ?*hearts* ?*diamonds*) (>= ?*hearts* ?*clubs*))
				 then
					hearts
				else
					(if (>= ?*diamonds* ?*clubs*)
						 then
							diamonds
						else
							clubs
					)
			)
	)
)


(deffunction got-required-support(?suit)
	(if (or (= (str-compare ?suit spades) 0)(= (str-compare ?suit hearts) 0))
	       then
			(>= (return-cards-in-colour ?suit) 3)
		else
			(if (= (str-compare ?suit diamonds) 0)
			       then
					(>= (return-cards-in-colour ?suit) 4)
				else
					(>= (return-cards-in-colour ?suit) 5)
					
			)
	)
) 
 
 
(defrule respond-to-opening-1-in-same-colour
	?bidfact <- (bidding our-player-should-bid)
	(test (>= ?*pc* 6))
	(test (<= ?*pc* 10))
	(bidding-opening (player ?bid-player)(level 1)(suit ?bid-suit)(forcing ?))
	(test (= (str-compare ?bid-player ?*partner*) 0))
	(not (test (= (str-compare ?bid-suit NT) 0)))
	(test (got-required-support ?bid-suit))
	(test (not (= (return-bid-level 1 ?bid-suit (get-longest-suit)) 1)))
=>
	(retract ?bidfact)
	(bind ?*bids-made* (+ ?*bids-made* 1))
	(assert (bid (number ?*bids-made*)(player ?*ourplayer*)(type normal)(level 2)(suit ?bid-suit)))
)
 
 
(defrule respond-to-opening-1-in-new-suit
	?bidfact <- (bidding our-player-should-bid)
	(test (>= ?*pc* 6))
	(test (<= ?*pc* 10))
	(bidding-opening (player ?bid-player)(level 1)(suit ?bid-suit)(forcing ?))
	(test (= (str-compare ?bid-player ?*partner*) 0))
	(not (test (= (str-compare ?bid-suit NT) 0)))
	(test (= (return-bid-level 1 ?bid-suit (get-longest-suit)) 1))
=>
	(retract ?bidfact)
	(bind ?*bids-made* (+ ?*bids-made* 1))
	(assert (bid (number ?*bids-made*)(player ?*ourplayer*)(type normal)(level (return-bid-level 1 ?bid-suit (get-longest-suit)))(suit (get-longest-suit))))
)
 
 
(defrule respond-to-opening-1-in-new-suit-1NT
	?bidfact <- (bidding our-player-should-bid)
	(test (>= ?*pc* 6))
	(test (<= ?*pc* 10))
	(bidding-opening (player ?bid-player)(level 1)(suit ?bid-suit)(forcing ?))
	(test (= (str-compare ?bid-player ?*partner*) 0))
	(not (test (= (str-compare ?bid-suit NT) 0)))
	(test (> (return-bid-level 1 ?bid-suit (get-longest-suit)) 1))
	(test (< (return-cards-in-colour ?bid-suit) 3))
	(test (not (= (return-bid-level 1 ?bid-suit (get-longest-suit)) 1)))
=>
	(retract ?bidfact)
	(bind ?*bids-made* (+ ?*bids-made* 1))
	(assert (bid (number ?*bids-made*)(player ?*ourplayer*)(type normal)(level 1)(suit NT)))
)   


(defrule respond-to-opening-1-in-new-suit-very-high-pts
	?bidfact <- (bidding our-player-should-bid)
	(test (>= ?*pc* 17))
	(bidding-opening (player ?bid-player)(level 1)(suit ?bid-suit)(forcing ?))
	(test (= (str-compare ?bid-player ?*partner*) 0))
	(not (test (= (str-compare ?bid-suit NT) 0)))
	(test (>= (get-longest-suit) 5))
=>
	(retract ?bidfact)
	(bind ?*bids-made* (+ ?*bids-made* 1))
	(assert (bid (number ?*bids-made*)(player ?*ourplayer*)(type normal)(level (return-bid-level 1 ?bid-suit (get-longest-suit)))(suit (get-longest-suit))))
) 


(defrule respond-to-opening-1-in-new-suit-high
	?bidfact <- (bidding our-player-should-bid)
	(test (>= ?*pc* 10))
	(bidding-opening (player ?bid-player)(level 1)(suit ?bid-suit)(forcing ?))
	(test (= (str-compare ?bid-player ?*partner*) 0))
	(not (test (= (str-compare ?bid-suit NT) 0)))
	(test (= (return-bid-level 1 ?bid-suit (get-longest-suit)) 1))
=>
	(retract ?bidfact)
	(bind ?*bids-made* (+ ?*bids-made* 1))
	(assert (bid (number ?*bids-made*)(player ?*ourplayer*)(type normal)(level (return-bid-level 1 ?bid-suit (get-longest-suit)))(suit (get-longest-suit))))
)
 
 
(defrule respond-to-opening-1-in-same-colour-high
	?bidfact <- (bidding our-player-should-bid)
	(test (>= ?*pc* 11))
	(test (<= ?*pc* 10))
	(bidding-opening (player ?bid-player)(level 1)(suit ?bid-suit)(forcing ?))
	(test (= (str-compare ?bid-player ?*partner*) 0))
	(not (test (= (str-compare ?bid-suit NT) 0)))
	(test (got-required-support ?bid-suit))
	(test (not (= (return-bid-level 1 ?bid-suit (get-longest-suit)) 1)))
=>
	(retract ?bidfact)
	(bind ?*bids-made* (+ ?*bids-made* 1))
	(assert (bid (number ?*bids-made*)(player ?*ourplayer*)(type normal)(level 2)(suit ?bid-suit)))
)
 
 
(defrule respond-to-forcing-opening-low
	?bidfact <- (bidding our-player-should-bid)
	(test (<= ?*pc* 7))
	(bidding-opening (player ?bid-player)(level 2)(suit clubs)(forcing yes))
	(test (= (str-compare ?bid-player ?*partner*) 0))
=>
	(retract ?bidfact)
	(bind ?*bids-made* (+ ?*bids-made* 1))
	(assert (bid (number ?*bids-made*)(player ?*ourplayer*)(type normal)(level 2)(suit diamonds)))
)
 
 
;(defrule respond-to-forcing-opening
;	?bidfact <- (bidding our-player-should-bid)
;	(test (>= ?*pc* 8))
;	(bidding-opening (player ?*partner*)(level 2)(suit clubs)(forcing yes))
;=>
;	(retract ?bidfact)
;	(bind ?*bids-made* (+ ?*bids-made* 1))
;	(assert (bid (number ?*bids-made*)(player ?*ourplayer*)(type normal)(level 2)(suit diamonds)))
;)
 
 
(defrule pass-in-response
	(declare (salience -1000))
	?bidfact <- (bidding our-player-should-bid)
	(bidding-opening (player ?bid-player)(level ?)(suit ?)(forcing no))
	(test (= (str-compare ?bid-player ?*partner*) 0))
=>
	(retract ?bidfact)
	(bind ?*bids-made* (+ ?*bids-made* 1))
	(assert (bid (number ?*bids-made*)(player ?*ourplayer*)(type pass)(level 0)(suit empty)))
)
