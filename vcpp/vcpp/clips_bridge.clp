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

 
(deffunction return-bid-level(?bid-level ?bid-suit ?new-bid)
	(if (= (str-compare ?bid-suit NT) 0)
		then
			(+ ?bid-level 1)
		else
			(if (= (str-compare ?bid-suit spades) 0)
				then
					(if (= (str-compare ?new-bid NT) 0)
						then
							?bid-level
						else
							(+ ?bid-level 1)
					)
				else
					(if (= (str-compare ?bid-suit hearts) 0)
						then
							(if (or (= (str-compare ?new-bid spades) 0) (= (str-compare ?new-bid NT) 0))
								   then
									?bid-level
								else
									(+ ?bid-level 1)
							)
						else
							(if (= (str-compare ?bid-suit diamonds) 0)
								then
									(if (or (= (str-compare ?new-bid NT) 0) (= (str-compare ?new-bid spades) 0) (= (str-compare ?new-bid hearts) 0))
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
)


(deffunction check-if-bid-valid(?previous-level ?previous-suit ?bid-level ?bid-suit)
	(if (= (str-compare ?bid-suit empty) 0)
	       then
			TRUE
		else
			(if (>= ?bid-level (return-bid-level ?previous-level ?previous-suit ?bid-suit))
			       then
					TRUE
				else
					FALSE
			)
	)
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


(defrule bidding-block
	?bidfact <- (bidding our-player-should-bid)
	?opening <- (bidding-opening (player ?opener)(level ?bid-lvl)(suit ?)(forcing ?))
	(test (>= ?*pc* 6))
	(test (<= ?*pc* 10))
	(or (test (>= ?*spades* 6)) (test (>= ?*hearts* 6)) (test (>= ?*diamonds* 6)) (test (>= ?*clubs* 7)))
	(test (< (+ ?bid-lvl 1) (determine-block-level)))
	(not (test (= (str-compare ?opener ?*partner*) 0)))
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

(deffunction check-if-less-than-in-major-suits(?amount)
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


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; responses to 1CDHS openings
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


(deffunction got-required-support-after-rebid(?suit)
	(if (or (= (str-compare ?suit spades) 0)(= (str-compare ?suit hearts) 0))
	       then
			(>= (return-cards-in-colour ?suit) 2)
		else
			(if (= (str-compare ?suit diamonds) 0)
			       then
					(>= (return-cards-in-colour ?suit) 3)
				else
					(>= (return-cards-in-colour ?suit) 4)
					
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
	(bid (number ?bid-nr)(player ?)(type pass)(level ?previous-level)(suit ?previous-suit))
	(test (= ?bid-nr ?*bids-made*))
	(test (check-if-bid-valid ?previous-level ?previous-suit 2 ?bid-suit))
=>
	(retract ?bidfact)
	(bind ?*pass-count* 0)
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
	(bid (number ?bid-nr)(player ?)(type pass)(level ?previous-level)(suit ?previous-suit))
	(test (= ?bid-nr ?*bids-made*))
	(test (check-if-bid-valid ?previous-level ?previous-suit (return-bid-level 1 ?bid-suit (get-longest-suit)) (get-longest-suit)))
=>
	(retract ?bidfact)
	(bind ?*pass-count* 0)
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
	(bid (number ?bid-nr)(player ?)(type pass)(level ?previous-level)(suit ?previous-suit))
	(test (= ?bid-nr ?*bids-made*))
	(test (check-if-bid-valid ?previous-level ?previous-suit 1 NT))
=>
	(retract ?bidfact)
	(bind ?*pass-count* 0)
	(bind ?*bids-made* (+ ?*bids-made* 1))
	(assert (bid (number ?*bids-made*)(player ?*ourplayer*)(type normal)(level 1)(suit NT)))
)   


(defrule respond-to-opening-1-in-new-suit-very-high-pts
	(declare (salience 100))
	?bidfact <- (bidding our-player-should-bid)
	(test (>= ?*pc* 17))
	(bidding-opening (player ?bid-player)(level 1)(suit ?bid-suit)(forcing ?))
	(test (= (str-compare ?bid-player ?*partner*) 0))
	(not (test (= (str-compare ?bid-suit NT) 0)))
	(test (>= (get-longest-suit) 5))
	(bid (number ?bid-nr)(player ?)(type pass)(level ?previous-level)(suit ?previous-suit))
	(test (= ?bid-nr ?*bids-made*))
	(test (check-if-bid-valid ?previous-level ?previous-suit (return-bid-level-jump 1 ?bid-suit (get-longest-suit)) (get-longest-suit)))
=>
	(retract ?bidfact)
	(bind ?*pass-count* 0)
	(bind ?*bids-made* (+ ?*bids-made* 1))
	(assert (bid (number ?*bids-made*)(player ?*ourplayer*)(type normal)(level (return-bid-level-jump 1 ?bid-suit (get-longest-suit)))(suit (get-longest-suit))))
) 


(defrule respond-to-opening-1CD-in-new-suit-2NT
	(declare (salience 1))
	?bidfact <- (bidding our-player-should-bid)
	(test (>= ?*pc* 11))
	(test (<= ?*pc* 12))
	(bidding-opening (player ?bid-player)(level 1)(suit ?bid-suit)(forcing ?))
	(or (test (= (str-compare ?bid-suit diamonds) 0)) (test (= (str-compare ?bid-suit clubs) 0)))
	(test (= (str-compare ?bid-player ?*partner*) 0))
	(test (check-if-less-than-in-major-suits 5))
	(bid (number ?bid-nr)(player ?)(type pass)(level ?previous-level)(suit ?previous-suit))
	(test (= ?bid-nr ?*bids-made*))
	(test (check-if-bid-valid ?previous-level ?previous-suit 2 NT))
=>
	(retract ?bidfact)
	(bind ?*pass-count* 0)
	(bind ?*bids-made* (+ ?*bids-made* 1))
	(assert (bid (number ?*bids-made*)(player ?*ourplayer*)(type normal)(level 2)(suit NT)))
)


(defrule respond-to-opening-1CD-in-new-suit-3NT
	(declare (salience 1))
	?bidfact <- (bidding our-player-should-bid)
	(test (>= ?*pc* 13))
	(test (<= ?*pc* 15))
	(bidding-opening (player ?bid-player)(level 1)(suit ?bid-suit)(forcing ?))
	(or (test (= (str-compare ?bid-suit diamonds) 0)) (test (= (str-compare ?bid-suit clubs) 0)))
	(test (= (str-compare ?bid-player ?*partner*) 0))
	(test (check-if-less-than-in-major-suits 5))
	(bid (number ?bid-nr)(player ?)(type pass)(level ?previous-level)(suit ?previous-suit))
	(test (= ?bid-nr ?*bids-made*))
	(test (check-if-bid-valid ?previous-level ?previous-suit 3 NT))
=>
	(retract ?bidfact)
	(bind ?*pass-count* 0)
	(bind ?*bids-made* (+ ?*bids-made* 1))
	(assert (bid (number ?*bids-made*)(player ?*ourplayer*)(type normal)(level 3)(suit NT)))
) 
 
 
(defrule respond-to-opening-1-in-same-colour-jacoby
	(declare (salience 10))
	?bidfact <- (bidding our-player-should-bid)
	(test (>= ?*pc* 13))
	(bidding-opening (player ?bid-player)(level 1)(suit ?bid-suit)(forcing ?))
	(or (test (= (str-compare ?bid-suit spades) 0)) (test (= (str-compare ?bid-suit hearts) 0)))
	(test (= (str-compare ?bid-player ?*partner*) 0))
	(test (>= (return-cards-in-colour ?bid-suit) 4))
	(bid (number ?bid-nr)(player ?)(type pass)(level ?previous-level)(suit ?previous-suit))
	(test (= ?bid-nr ?*bids-made*))
	(test (check-if-bid-valid ?previous-level ?previous-suit 2 NT))
=>
	(retract ?bidfact)
	(bind ?*pass-count* 0)
	(bind ?*bids-made* (+ ?*bids-made* 1))
	(assert (bid (number ?*bids-made*)(player ?*ourplayer*)(type normal)(level 2)(suit NT)))
)
 
 
(defrule respond-to-opening-1-in-same-colour-high
	?bidfact <- (bidding our-player-should-bid)
	(test (>= ?*pc* 11))
	(test (<= ?*pc* 12))
	(bidding-opening (player ?bid-player)(level 1)(suit ?bid-suit)(forcing ?))
	(test (= (str-compare ?bid-player ?*partner*) 0))
	(not (test (= (str-compare ?bid-suit NT) 0)))
	(test (got-required-support ?bid-suit))
	(bid (number ?bid-nr)(player ?)(type pass)(level ?previous-level)(suit ?previous-suit))
	(test (= ?bid-nr ?*bids-made*))
	(test (check-if-bid-valid ?previous-level ?previous-suit (return-bid-level-jump 1 ?bid-suit ?bid-suit) ?bid-suit))
=>
	(retract ?bidfact)
	(bind ?*pass-count* 0)
	(bind ?*bids-made* (+ ?*bids-made* 1))
	(assert (bid (number ?*bids-made*)(player ?*ourplayer*)(type normal)(level (return-bid-level-jump 1 ?bid-suit ?bid-suit))(suit ?bid-suit)))
) 


(defrule respond-to-opening-1-in-new-suit-high
	?bidfact <- (bidding our-player-should-bid)
	(test (>= ?*pc* 11))
	(bidding-opening (player ?bid-player)(level 1)(suit ?bid-suit)(forcing ?))
	(test (= (str-compare ?bid-player ?*partner*) 0))
	(not (test (= (str-compare ?bid-suit NT) 0)))
	(bid (number ?bid-nr)(player ?)(type pass)(level ?previous-level)(suit ?previous-suit))
	(test (= ?bid-nr ?*bids-made*))
	(test (check-if-bid-valid ?previous-level ?previous-suit 2 (get-longest-suit)))
=>
	(retract ?bidfact)
	(bind ?*pass-count* 0)
	(bind ?*bids-made* (+ ?*bids-made* 1))
	(assert (bid (number ?*bids-made*)(player ?*ourplayer*)(type normal)(level (return-bid-level 1 ?bid-suit (get-longest-suit)))(suit (get-longest-suit))))
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; responses to 1NT opening
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(deffunction get-texas-suit(?suit)
	(if (= (str-compare ?suit hearts) 0)
		then
			diamonds
		else
			hearts	
	)
)


(deffunction revert-texas-suit(?suit)
	(if (= (str-compare ?suit hearts) 0)
		then
			spades
		else
			hearts	
	)
)


(defrule respond-to-opening-1NT-2NT
	?bidfact <- (bidding our-player-should-bid)
	(test (>= ?*pc* 10))
	(test (<= ?*pc* 11))
	(bidding-opening (player ?bid-player)(level ?bid-lvl)(suit NT)(forcing ?))
	(test (= (str-compare ?bid-player ?*partner*) 0))
	(or (and (test (check-if-less-than-in-suits 5)) (test (check-if-more-than-in-suits 1))) (test (check-if-balanced-hand-with-one-five)))
	(bid (number ?bid-nr)(player ?)(type pass)(level ?previous-level)(suit ?previous-suit))
	(test (= ?bid-nr ?*bids-made*))
	(test (check-if-bid-valid ?previous-level ?previous-suit 2 NT))
=>
	(retract ?bidfact)
	(bind ?*pass-count* 0)
	(bind ?*bids-made* (+ ?*bids-made* 1))
	(assert (bid (number ?*bids-made*)(player ?*ourplayer*)(type normal)(level 2)(suit NT)))
)


(defrule respond-to-opening-1NT-3NT
	?bidfact <- (bidding our-player-should-bid)
	(test (>= ?*pc* 12))
	(bidding-opening (player ?bid-player)(level 1)(suit NT)(forcing ?))
	(test (= (str-compare ?bid-player ?*partner*) 0))
	(or (and (test (check-if-less-than-in-suits 5)) (test (check-if-more-than-in-suits 1))) (test (check-if-balanced-hand-with-one-five)))
	(bid (number ?bid-nr)(player ?)(type pass)(level ?previous-level)(suit ?previous-suit))
	(test (= ?bid-nr ?*bids-made*))
	(test (check-if-bid-valid ?previous-level ?previous-suit 3 NT))
=>
	(retract ?bidfact)
	(bind ?*pass-count* 0)
	(bind ?*bids-made* (+ ?*bids-made* 1))
	(assert (bid (number ?*bids-made*)(player ?*ourplayer*)(type normal)(level 3)(suit NT)))
)


(defrule respond-to-opening-1NT-colour-transfer
	?bidfact <- (bidding our-player-should-bid)
	(test (>= ?*pc* 6))
	(bidding-opening (player ?bid-player)(level 1)(suit NT)(forcing ?))
	(test (= (str-compare ?bid-player ?*partner*) 0))
	(not (or (and (test (check-if-less-than-in-suits 5)) (test (check-if-more-than-in-suits 1))) (test (check-if-balanced-hand-with-one-five))))
	(or (test (>= ?*spades* 5)) (test (>= ?*hearts* 5)))
	(bid (number ?bid-nr)(player ?)(type pass)(level ?previous-level)(suit ?previous-suit))
	(test (= ?bid-nr ?*bids-made*))
	(test (check-if-bid-valid ?previous-level ?previous-suit 2 (get-texas-suit (get-five-plus-in-major-suit))))
=>
	(retract ?bidfact)
	(bind ?*pass-count* 0)
	(bind ?*bids-made* (+ ?*bids-made* 1))
	(assert (bid (number ?*bids-made*)(player ?*ourplayer*)(type normal)(level 2)(suit (get-texas-suit (get-five-plus-in-major-suit)))))
)


(defrule respond-to-opening-1NT-colour-no-majors
	?bidfact <- (bidding our-player-should-bid)
	(test (>= ?*pc* 10))
	(bidding-opening (player ?bid-player)(level 1)(suit NT)(forcing ?))
	(test (= (str-compare ?bid-player ?*partner*) 0))
	(not (or (and (test (check-if-less-than-in-suits 5)) (test (check-if-more-than-in-suits 1))) (test (check-if-balanced-hand-with-one-five))))
	(or (test (>= ?*diamonds* 5)) (test (>= ?*clubs* 5)))
	(bid (number ?bid-nr)(player ?)(type pass)(level ?previous-level)(suit ?previous-suit))
	(test (= ?bid-nr ?*bids-made*))
	(test (check-if-bid-valid ?previous-level ?previous-suit 3 (get-minor-suit)))
=>
	(retract ?bidfact)
	(bind ?*pass-count* 0)
	(bind ?*bids-made* (+ ?*bids-made* 1))
	(assert (bid (number ?*bids-made*)(player ?*ourplayer*)(type normal)(level 3)(suit (get-minor-suit))))
)


(defrule respond-to-opening-1NT-pass
	?bidfact <- (bidding our-player-should-bid)
	(test (<= ?*pc* 5))
	(bidding-opening (player ?bid-player)(level 1)(suit NT)(forcing ?))
	(test (= (str-compare ?bid-player ?*partner*) 0))
	(not (or (and (test (check-if-less-than-in-suits 5)) (test (check-if-more-than-in-suits 1))) (test (check-if-balanced-hand-with-one-five))))
	(not (or (test (>= ?*spades* 5)) (test (>= ?*hearts* 5))))
	(bid (number ?bid-nr)(player ?)(type pass)(level ?previous-level)(suit ?previous-suit))
	(test (= ?bid-nr ?*bids-made*))
=>
	(retract ?bidfact)
	(bind ?*pass-count* (+ ?*pass-count* 1))
	(bind ?*bids-made* (+ ?*bids-made* 1))
	(assert (bid (number ?*bids-made*)(player ?*ourplayer*)(type pass)(level ?previous-level)(suit ?previous-suit)))
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; responses to blocking openings
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule respond-to-blocking-opening-higher
	?bidfact <- (bidding our-player-should-bid)
	(bidding-opening (player ?bid-player)(level ?bid-lvl)(suit ?bid-suit)(forcing no))
	(test (= (str-compare ?bid-player ?*partner*) 0))
	(test (<= ?*pc* 15))
	(bid (number ?bid-nr)(player ?)(type normal)(level ?previous-level)(suit ?previous-suit))
	(or (test (= ?bid-nr ?*bids-made*)) (test (= ?bid-nr (- ?*bids-made* 2))))
	(test (>= (return-cards-in-colour ?bid-suit) 3))
	(test (check-if-bid-valid ?previous-level ?previous-suit (return-bid-level ?previous-level ?previous-suit ?bid-suit) ?bid-suit))
=>
	(retract ?bidfact)
	(bind ?*pass-count* 0)
	(bind ?*bids-made* (+ ?*bids-made* 1))
	(assert (bid (number ?*bids-made*)(player ?*ourplayer*)(type normal)(level (return-bid-level ?previous-level ?previous-suit ?bid-suit))(suit ?bid-suit)))
)


(defrule respond-to-blocking-opening-3NT
	?bidfact <- (bidding our-player-should-bid)
	(bidding-opening (player ?bid-player)(level ?bid-lvl)(suit ?bid-suit)(forcing no))
	(test (= (str-compare ?bid-player ?*partner*) 0))
	(test (>= ?*pc* 16))
	(bid (number ?bid-nr)(player ?)(type ?)(level ?previous-level)(suit ?previous-suit))
	(test (= ?bid-nr ?*bids-made*))
	(test (>= (return-cards-in-colour ?bid-suit) 2))
	(or (and (test (check-if-less-than-in-suits 5)) (test (check-if-more-than-in-suits 1))) (test (check-if-balanced-hand-with-one-five)))
	(test (check-if-bid-valid ?previous-level ?previous-suit 3 NT))
=>
	(retract ?bidfact)
	(bind ?*pass-count* 0)
	(bind ?*bids-made* (+ ?*bids-made* 1))
	(assert (bid (number ?*bids-made*)(player ?*ourplayer*)(type normal)(level 3)(suit NT)))
)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; responses to acol
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule respond-to-acol-opening-low
	?bidfact <- (bidding our-player-should-bid)
	(test (<= ?*pc* 7))
	(bidding-opening (player ?bid-player)(level 2)(suit clubs)(forcing yes))
	(test (= (str-compare ?bid-player ?*partner*) 0))
	(bid (number ?bid-nr)(player ?)(type pass)(level ?previous-level)(suit ?previous-suit))
	(test (= ?bid-nr ?*bids-made*))
	(test (check-if-bid-valid ?previous-level ?previous-suit 2 diamonds))
=>
	(retract ?bidfact)
	(bind ?*pass-count* 0)
	(bind ?*bids-made* (+ ?*bids-made* 1))
	(assert (bid (number ?*bids-made*)(player ?*ourplayer*)(type normal)(level 2)(suit diamonds)))
)


(defrule respond-to-acol-opening-2NT
	?bidfact <- (bidding our-player-should-bid)
	(test (>= ?*pc* 8))
	(bidding-opening (player ?bid-player)(level 2)(suit clubs)(forcing yes))
	(test (= (str-compare ?bid-player ?*partner*) 0))
	(or (and (test (check-if-less-than-in-suits 5)) (test (check-if-more-than-in-suits 1))) (test (check-if-balanced-hand-with-one-five)))
	(bid (number ?bid-nr)(player ?)(type pass)(level ?previous-level)(suit ?previous-suit))
	(test (= ?bid-nr ?*bids-made*))
	(test (check-if-bid-valid ?previous-level ?previous-suit 2 NT))
=>
	(retract ?bidfact)
	(bind ?*pass-count* 0)
	(bind ?*bids-made* (+ ?*bids-made* 1))
	(assert (bid (number ?*bids-made*)(player ?*ourplayer*)(type normal)(level 2)(suit NT)))
)


(defrule respond-to-acol-opening-2-colour
	?bidfact <- (bidding our-player-should-bid)
	(test (>= ?*pc* 8))
	(bidding-opening (player ?bid-player)(level 2)(suit clubs)(forcing yes))
	(test (= (str-compare ?bid-player ?*partner*) 0))
	(and (not (test (check-if-balanced-hand-with-one-five))) (not (test (check-if-less-than-in-suits 5))))
	(bid (number ?bid-nr)(player ?)(type pass)(level ?previous-level)(suit ?previous-suit))
	(test (= ?bid-nr ?*bids-made*))
	(test (check-if-bid-valid ?previous-level ?previous-suit 2 (get-longest-suit)))
=>
	(retract ?bidfact)
	(bind ?*pass-count* 0)
	(bind ?*bids-made* (+ ?*bids-made* 1))
	(assert (bid (number ?*bids-made*)(player ?*ourplayer*)(type normal)(level 2)(suit (get-longest-suit))))
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
; rebids on our opening
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule rebid-open-1C-NT
	?bidfact <- (bidding our-player-should-bid)
	(test (>= ?*pc* 18))
	(test (<= ?*pc* 19))
	(or (and (test (check-if-less-than-in-suits 5)) (test (check-if-more-than-in-suits 1))) (test (check-if-balanced-hand-with-one-five)))
	?rebid-fact <- (bidding ourplayer-should-rebid-NT 1)
	(bid (number ?bid-nr)(player ?)(type pass)(level ?previous-level)(suit ?previous-suit))
	(test (= ?bid-nr ?*bids-made*))
	(test (check-if-bid-valid ?previous-level ?previous-suit 2 NT))
=>
	(retract ?bidfact)
	(bind ?*bids-made* (+ ?*bids-made* 1))
	(bind ?*pass-count* 0)
	(assert (bid (number ?*bids-made*)(player ?*ourplayer*)(type normal)(level 2)(suit NT)))
	(retract ?rebid-fact)
)
	
 
(defrule rebid-open-2C-2NT
	?bidfact <- (bidding our-player-should-bid)
	(test (>= ?*pc* 22))
	(test (<= ?*pc* 24))
	(or (and (test (check-if-less-than-in-suits 5)) (test (check-if-more-than-in-suits 1))) (test (check-if-balanced-hand-with-one-five)))
	?rebid-fact <- (bidding ourplayer-should-rebid-NT 2)
	(bid (number ?bid-nr)(player ?)(type pass)(level ?previous-level)(suit ?previous-suit))
	(test (= ?bid-nr ?*bids-made*))
	(test (check-if-bid-valid ?previous-level ?previous-suit 2 NT))
=>
	(retract ?bidfact)
	(bind ?*bids-made* (+ ?*bids-made* 1))
	(bind ?*pass-count* 0)
	(assert (bid (number ?*bids-made*)(player ?*ourplayer*)(type normal)(level 2)(suit NT)))
	(retract ?rebid-fact)
 )
	
 
(defrule rebid-open-2C-3NT
	?bidfact <- (bidding our-player-should-bid)
	(test (>= ?*pc* 25))
	(test (<= ?*pc* 27))
	(or (and (test (check-if-less-than-in-suits 5)) (test (check-if-more-than-in-suits 1))) (test (check-if-balanced-hand-with-one-five)))
	?rebid-fact <- (bidding ourplayer-should-rebid-NT 3)
	(bid (number ?bid-nr)(player ?)(type pass)(level ?previous-level)(suit ?previous-suit))
	(test (= ?bid-nr ?*bids-made*))
	(test (check-if-bid-valid ?previous-level ?previous-suit 3 NT))
=>
	(retract ?bidfact)
	(bind ?*bids-made* (+ ?*bids-made* 1))
	(bind ?*pass-count* 0)
	(assert (bid (number ?*bids-made*)(player ?*ourplayer*)(type normal)(level 3)(suit NT)))
	(retract ?rebid-fact)
 )
 
 
(defrule rebid-my-suit-not-NT
	?bidfact <- (bidding our-player-should-bid)
	(test (>= ?*pc* 12))
	(test (<= ?*pc* 15))
	(bidding-opening (player ?bid-player)(level 1)(suit ?my-suit)(forcing no))
	(test (= (str-compare ?bid-player ?*ourplayer*) 0))
	(bid (number ?)(player ?bid-player-2)(type normal)(level 2)(suit ?my-suit))
	(test (= (str-compare ?bid-player-2 ?*partner*) 0))
	(bid (number ?bid-nr)(player ?)(type ?)(level ?previous-level)(suit ?previous-suit))
	(test (= ?bid-nr ?*bids-made*))
	(test (check-if-bid-valid ?previous-level ?previous-suit 3 ?my-suit))
	(not (test (= (str-compare ?my-suit NT) 0)))
=>
	(retract ?bidfact)
	(bind ?*bids-made* (+ ?*bids-made* 1))
	(bind ?*pass-count* 0)
	(assert (bid (number ?*bids-made*)(player ?*ourplayer*)(type normal)(level 3)(suit ?my-suit)))
 )
 
 
(defrule rebid-suit-major-finish
	?bidfact <- (bidding our-player-should-bid)
	(test (>= ?*pc* 16))
	(bidding-opening (player ?bid-player)(level 1)(suit ?my-suit)(forcing no))
	(test (= (str-compare ?bid-player ?*ourplayer*) 0))
	(bid (number ?)(player ?bid-player-2)(type normal)(level 2)(suit ?my-suit))
	(test (= (str-compare ?bid-player-2 ?*partner*) 0))
	(bid (number ?bid-nr)(player ?)(type ?)(level ?previous-level)(suit ?previous-suit))
	(test (= ?bid-nr ?*bids-made*))
	(test (check-if-bid-valid ?previous-level ?previous-suit 4 ?my-suit))
	(or (test (= (str-compare ?my-suit spades) 0)) (test (= (str-compare ?my-suit hearts) 0)))
=>
	(retract ?bidfact)
	(bind ?*bids-made* (+ ?*bids-made* 1))
	(bind ?*pass-count* 0)
	(assert (bid (number ?*bids-made*)(player ?*ourplayer*)(type normal)(level 4)(suit ?my-suit)))
)
 
 
(defrule rebid-partner-suit-not-NT
 	?bidfact <- (bidding our-player-should-bid)
 	(test (>= ?*pc* 12))
 	(test (<= ?*pc* 15))
 	(bidding-opening (player ?bid-player)(level ?)(suit ?my-suit)(forcing no))
 	(test (= (str-compare ?bid-player ?*ourplayer*) 0))
 	(bid (number ?)(player ?bid-player-2)(type normal)(level ?partner-level)(suit ?partner-suit))
 	(test (= (str-compare ?bid-player-2 ?*partner*) 0))
 	(not (test (= (str-compare ?my-suit ?partner-suit) 0)))
 	(bid (number ?bid-nr)(player ?)(type ?)(level ?previous-level)(suit ?previous-suit))
 	(test (= ?bid-nr ?*bids-made*))
 	(test (check-if-bid-valid ?previous-level ?previous-suit 3 ?partner-suit))
 	(not (test (= (str-compare ?my-suit NT) 0)))
 	(not (test (= (str-compare ?partner-suit NT) 0)))
 	(test (>= (return-cards-in-colour ?partner-suit) 4))
=>
 	(retract ?bidfact)
 	(bind ?*bids-made* (+ ?*bids-made* 1))
 	(bind ?*pass-count* 0)
 	(assert (bid (number ?*bids-made*)(player ?*ourplayer*)(type normal)(level (return-bid-level ?previous-level ?previous-suit ?partner-suit))(suit ?partner-suit)))
)
 
 
(defrule rebid-partner-suit-not-NT-major-finish
 	?bidfact <- (bidding our-player-should-bid)
 	(test (>= ?*pc* 16))
 	(bidding-opening (player ?bid-player)(level ?)(suit ?my-suit)(forcing no))
 	(test (= (str-compare ?bid-player ?*ourplayer*) 0))
 	(bid (number ?)(player ?bid-player-2)(type normal)(level ?partner-level)(suit ?partner-suit))
 	(test (= (str-compare ?bid-player-2 ?*partner*) 0))
 	(not (test (= (str-compare ?my-suit ?partner-suit) 0)))
 	(bid (number ?bid-nr)(player ?)(type ?)(level ?previous-level)(suit ?previous-suit))
 	(test (= ?bid-nr ?*bids-made*))
 	(test (check-if-bid-valid ?previous-level ?previous-suit 4 ?partner-suit))
 	(not (test (= (str-compare ?my-suit NT) 0)))
 	(not (test (= (str-compare ?partner-suit NT) 0)))
 	(test (>= (return-cards-in-colour ?partner-suit) 4))
 	(or (test (= (str-compare ?partner-suit spades) 0)) (test (= (str-compare ?partner-suit hearts) 0)))
=>
 	(retract ?bidfact)
 	(bind ?*bids-made* (+ ?*bids-made* 1))
 	(bind ?*pass-count* 0)
 	(assert (bid (number ?*bids-made*)(player ?*ourplayer*)(type normal)(level 4)(suit ?partner-suit)))
)
 
 
(defrule rebid-suit-finish-NT
 	?bidfact <- (bidding our-player-should-bid)
 	(test (>= ?*pc* 17))
 	(bidding-opening (player ?bid-player)(level ?my-suit)(suit ?)(forcing no))
 	(test (= (str-compare ?bid-player ?*ourplayer*) 0))
 	(bid (number ?)(player ?bid-player-2)(type normal)(level ?)(suit NT))
 	(test (= (str-compare ?bid-player-2 ?*partner*) 0))
 	(bid (number ?bid-nr)(player ?)(type ?)(level ?previous-level)(suit ?previous-suit))
 	(test (= ?bid-nr ?*bids-made*))
 	(test (check-if-bid-valid ?previous-level ?previous-suit 3 NT))
 	(test (= (str-compare ?my-suit NT) 0))
=>
 	(retract ?bidfact)
 	(bind ?*bids-made* (+ ?*bids-made* 1))
 	(bind ?*pass-count* 0)
 	(assert (bid (number ?*bids-made*)(player ?*ourplayer*)(type normal)(level 3)(suit NT)))
)
 
 
(defrule rebid-transfer
 	?bidfact <- (bidding our-player-should-bid)
 	(bidding-opening (player ?bid-player)(level ?bid-level)(suit NT)(forcing no))
 	(test (= (str-compare ?bid-player ?*ourplayer*) 0))
 	(bid (number ?)(player ?bid-player-2)(type normal)(level ?)(suit ?texas))
 	(test (= (str-compare ?bid-player-2 ?*partner*) 0))
 	(bid (number ?bid-nr)(player ?)(type ?)(level ?previous-level)(suit ?previous-suit))
 	(test (= ?bid-nr ?*bids-made*))
 	(test (check-if-bid-valid ?previous-level ?previous-suit ?bid-level (revert-texas-suit ?texas)))
=>
 	(retract ?bidfact)
 	(bind ?*bids-made* (+ ?*bids-made* 1))
 	(bind ?*pass-count* 0)
 	(assert (bid (number ?*bids-made*)(player ?*ourplayer*)(type normal)(level ?bid-level)(suit (revert-texas-suit ?texas))))
)
 
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; rebids on partner's opening
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
(defrule rebid-p-suit-not-NT
	?bidfact <- (bidding our-player-should-bid)
	(test (>= ?*pc* 10))
	(bidding-opening (player ?bid-player)(level 1)(suit ?partner-suit)(forcing no))
	(test (= (str-compare ?bid-player ?*partner*) 0))
	(bid (number ?nr1)(player ?bid-player-2)(type normal)(level ?)(suit ?partner-suit))
	(test (= (str-compare ?bid-player-2 ?*ourplayer*) 0))
	(bid (number ?nr2)(player ?bid-player-3)(type normal)(level ?)(suit ?partner-suit))
	(test (= (str-compare ?bid-player-3 ?*partner*) 0))
	(test (> ?nr2 ?nr1))
	(bid (number ?bid-nr)(player ?)(type ?)(level ?previous-level)(suit ?previous-suit))
	(test (= ?bid-nr ?*bids-made*))
	(test (check-if-bid-valid ?previous-level ?previous-suit 4 ?partner-suit))
	(not (test (= (str-compare ?partner-suit NT) 0)))
=>
	(retract ?bidfact)
	(bind ?*bids-made* (+ ?*bids-made* 1))
	(bind ?*pass-count* 0)
	(assert (bid (number ?*bids-made*)(player ?*ourplayer*)(type normal)(level 4)(suit ?partner-suit)))
)
 
 
(defrule rebid-p-suit-not-NT-low
	?bidfact <- (bidding our-player-should-bid)
	(test (>= ?*pc* 8))
	(test (<= ?*pc* 9))
	(bidding-opening (player ?bid-player)(level 1)(suit ?partner-suit)(forcing no))
	(test (= (str-compare ?bid-player ?*partner*) 0))
	(bid (number ?nr1)(player ?bid-player-2)(type normal)(level 2)(suit ?partner-suit))
	(test (= (str-compare ?bid-player-2 ?*ourplayer*) 0))
	(bid (number ?nr2)(player ?bid-player-3)(type normal)(level 3)(suit ?partner-suit))
	(test (= (str-compare ?bid-player-3 ?*partner*) 0))
	(test (> ?nr2 ?nr1))
	(bid (number ?bid-nr)(player ?)(type ?)(level ?previous-level)(suit ?previous-suit))
	(test (= ?bid-nr ?*bids-made*))
	(test (check-if-bid-valid ?previous-level ?previous-suit 3 ?partner-suit))
	(not (test (= (str-compare ?partner-suit NT) 0)))
=>
	(retract ?bidfact)
	(bind ?*bids-made* (+ ?*bids-made* 1))
	(bind ?*pass-count* 0)
	(assert (bid (number ?*bids-made*)(player ?*ourplayer*)(type normal)(level 3)(suit ?partner-suit)))
)
 
 
(defrule rebid-no-fit-NT-finish
	?bidfact <- (bidding our-player-should-bid)
	(test (>= ?*pc* 14))
	(bidding-opening (player ?bid-player)(level ?)(suit ?partner-suit)(forcing no))
	(test (= (str-compare ?bid-player ?*partner*) 0))
	(bid (number ?nr1)(player ?bid-player-2)(type normal)(level ?)(suit ?my-suit))
	(test (= (str-compare ?bid-player-2 ?*ourplayer*) 0))
	(bid (number ?nr2)(player ?bid-player-3)(type normal)(level ?)(suit ?partner-suit-2))
	(test (= (str-compare ?bid-player-3 ?*partner*) 0))
	(test (> ?nr2 ?nr1))
	(not (test (= (str-compare ?my-suit ?partner-suit) 0)))
	(not (test (= (str-compare ?partner-suit ?partner-suit-2) 0)))
	(not (test (= (str-compare ?my-suit ?partner-suit-2) 0)))
	(bid (number ?bid-nr)(player ?)(type ?)(level ?previous-level)(suit ?previous-suit))
	(test (= ?bid-nr ?*bids-made*))
	(test (check-if-bid-valid ?previous-level ?previous-suit 3 NT))
	(not (test (= (str-compare ?my-suit NT) 0)))
	(not (test (= (str-compare ?partner-suit NT) 0)))
	(not (test (= (str-compare ?partner-suit-2 NT) 0)))
=>
	(retract ?bidfact)
	(bind ?*bids-made* (+ ?*bids-made* 1))
	(bind ?*pass-count* 0)
	(assert (bid (number ?*bids-made*)(player ?*ourplayer*)(type normal)(level 3)(suit NT)))
)
 
 
(defrule rebid-support-longer-colour
	?bidfact <- (bidding our-player-should-bid)
	(test (>= ?*pc* 10))
	(bidding-opening (player ?bid-player)(level ?)(suit ?partner-suit)(forcing no))
	(test (= (str-compare ?bid-player ?*partner*) 0))
	(bid (number ?nr1)(player ?bid-player-2)(type normal)(level ?)(suit ?my-suit))
	(test (= (str-compare ?bid-player-2 ?*ourplayer*) 0))
	(bid (number ?nr2)(player ?bid-player-3)(type normal)(level ?)(suit ?partner-suit))
	(test (= (str-compare ?bid-player-3 ?*partner*) 0))
	(test (> ?nr2 ?nr1))
	(not (test (= (str-compare ?my-suit ?partner-suit) 0)))
	(bid (number ?bid-nr)(player ?)(type ?)(level ?previous-level)(suit ?previous-suit))
	(test (= ?bid-nr ?*bids-made*))
	(test (check-if-bid-valid ?previous-level ?previous-suit 4 ?partner-suit))
	(not (test (= (str-compare ?my-suit NT) 0)))
	(not (test (= (str-compare ?partner-suit NT) 0)))
	(got-required-support-after-rebid ?partner-suit)
=>
	(retract ?bidfact)
	(bind ?*bids-made* (+ ?*bids-made* 1))
	(bind ?*pass-count* 0)
	(assert (bid (number ?*bids-made*)(player ?*ourplayer*)(type normal)(level 4)(suit ?partner-suit)))
)
 
 
(defrule rebid-support-previous-colour
	?bidfact <- (bidding our-player-should-bid)
	(test (>= ?*pc* 10))
	(bidding-opening (player ?bid-player)(level ?)(suit ?partner-suit)(forcing no))
	(test (= (str-compare ?bid-player ?*partner*) 0))
	(bid (number ?nr1)(player ?bid-player-2)(type normal)(level ?)(suit ?my-suit))
	(test (= (str-compare ?bid-player-2 ?*ourplayer*) 0))
	(bid (number ?nr2)(player ?bid-player-3)(type normal)(level ?)(suit ?partner-suit-2))
	(test (= (str-compare ?bid-player-3 ?*partner*) 0))
	(test (> ?nr2 ?nr1))
	(not (test (= (str-compare ?my-suit ?partner-suit) 0)))
	(not (test (= (str-compare ?my-suit ?partner-suit-2) 0)))
	(bid (number ?bid-nr)(player ?)(type ?)(level ?previous-level)(suit ?previous-suit))
	(test (= ?bid-nr ?*bids-made*))
	(test (check-if-bid-valid ?previous-level ?previous-suit 4 ?partner-suit))
	(not (test (= (str-compare ?my-suit NT) 0)))
	(not (test (= (str-compare ?partner-suit NT) 0)))
	(got-required-support ?partner-suit)
=>
	(retract ?bidfact)
	(bind ?*bids-made* (+ ?*bids-made* 1))
	(bind ?*pass-count* 0)
	(assert (bid (number ?*bids-made*)(player ?*ourplayer*)(type normal)(level 4)(suit ?partner-suit)))
)
 
 
(defrule rebid-support-new-colour
	?bidfact <- (bidding our-player-should-bid)
	(test (>= ?*pc* 10))
	(bidding-opening (player ?bid-player)(level ?)(suit ?partner-suit)(forcing no))
	(test (= (str-compare ?bid-player ?*partner*) 0))
	(bid (number ?nr1)(player ?bid-player-2)(type normal)(level ?)(suit ?my-suit))
	(test (= (str-compare ?bid-player-2 ?*ourplayer*) 0))
	(bid (number ?nr2)(player ?bid-player-3)(type normal)(level ?)(suit ?partner-suit-2))
	(test (= (str-compare ?bid-player-3 ?*partner*) 0))
	(test (> ?nr2 ?nr1))
	(not (test (= (str-compare ?my-suit ?partner-suit) 0)))
	(not (test (= (str-compare ?my-suit ?partner-suit-2) 0)))
	(bid (number ?bid-nr)(player ?)(type ?)(level ?previous-level)(suit ?previous-suit))
	(test (= ?bid-nr ?*bids-made*))
	(test (check-if-bid-valid ?previous-level ?previous-suit 4 ?partner-suit))
	(not (test (= (str-compare ?my-suit NT) 0)))
	(not (test (= (str-compare ?partner-suit NT) 0)))
	(not (test (= (str-compare ?partner-suit-2 NT) 0)))
	(got-required-support ?partner-suit-2)
=>
	(retract ?bidfact)
	(bind ?*bids-made* (+ ?*bids-made* 1))
	(bind ?*pass-count* 0)
	(assert (bid (number ?*bids-made*)(player ?*ourplayer*)(type normal)(level 4)(suit ?partner-suit-2)))
)
 
 
(defrule rebid-low-texas
	?bidfact <- (bidding our-player-should-bid)
	(test (>= ?*pc* 7))
	(test (<= ?*pc* 8))
	(bidding-opening (player ?bid-player)(level ?)(suit NT)(forcing no))
	(test (= (str-compare ?bid-player ?*partner*) 0))
	(bid (number ?nr1)(player ?bid-player-2)(type normal)(level ?)(suit ?))
	(test (= (str-compare ?bid-player-2 ?*ourplayer*) 0))
	(bid (number ?nr2)(player ?bid-player-3)(type normal)(level ?bid-lvl)(suit ?my-texas))
	(test (= (str-compare ?bid-player-3 ?*partner*) 0))
	(test (> ?nr2 ?nr1))
	(bid (number ?bid-nr)(player ?)(type ?)(level ?previous-level)(suit ?previous-suit))
	(test (= ?bid-nr ?*bids-made*))
	(test (check-if-bid-valid ?previous-level ?previous-suit 3 ?my-texas))
=>
	(retract ?bidfact)
	(bind ?*bids-made* (+ ?*bids-made* 1))
	(bind ?*pass-count* 0)
	(assert (bid (number ?*bids-made*)(player ?*ourplayer*)(type normal)(level 3)(suit ?my-texas)))
)
 
 
(defrule rebid-finish-texas
	?bidfact <- (bidding our-player-should-bid)
	(test (>= ?*pc* 9))
	(bidding-opening (player ?bid-player)(level ?)(suit NT)(forcing no))
	(test (= (str-compare ?bid-player ?*partner*) 0))
	(bid (number ?nr1)(player ?bid-player-2)(type normal)(level ?)(suit ?))
	(test (= (str-compare ?bid-player-2 ?*ourplayer*) 0))
	(bid (number ?nr2)(player ?bid-player-3)(type normal)(level ?bid-lvl)(suit ?my-texas))
	(test (= (str-compare ?bid-player-3 ?*partner*) 0))
	(test (> ?nr2 ?nr1))
	(bid (number ?bid-nr)(player ?)(type ?)(level ?previous-level)(suit ?previous-suit))
	(test (= ?bid-nr ?*bids-made*))
	(test (check-if-bid-valid ?previous-level ?previous-suit 4 ?my-texas))
=>
	(retract ?bidfact)
	(bind ?*bids-made* (+ ?*bids-made* 1))
	(bind ?*pass-count* 0)
	(assert (bid (number ?*bids-made*)(player ?*ourplayer*)(type normal)(level 4)(suit ?my-texas)))
)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; pass
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule pass
	(declare (salience -10000))
	?bidfact <- (bidding our-player-should-bid)
	(bid (number ?bid-nr)(player ?)(type pass)(level ?bid-lvl)(suit ?bid-suit))
	(test (= ?bid-nr ?*bids-made*))
=>
	(retract ?bidfact)
	(bind ?*bids-made* (+ ?*bids-made* 1))
	(bind ?*pass-count* (+ ?*pass-count* 1))
	(assert (bid (number ?*bids-made*)(player ?*ourplayer*)(type pass)(level ?bid-lvl)(suit ?bid-suit)))
)
