(deftemplate card
	(slot name)
	(slot suit)
	(slot player)
)

(deffunction card-value(?card-name)
	(switch ?card-name
		(case ace then (return 4))
		(case king then (return 3))
		(case queen then (return 2))
		(case jack then (return 1))
		(default (return 0))
	)
	(return 0)
)

(deffacts cards
	(card (name ace)(suit spades)(player me))
	(card (name king)(suit spades)(player me))
	(card (name queen)(suit spades)(player me))
	(card (name jack)(suit spades)(player me))
	(card (name ten)(suit spades)(player me))
	(card (name nine)(suit spades)(player me))
	(card (name eight)(suit spades)(player me))
	(card (name ace)(suit hearts)(player me))
	(card (name six)(suit spades)(player me))
	(card (name five)(suit spades)(player me))
	(card (name four)(suit spades)(player me))
	(card (name three)(suit spades)(player me))
	(card (name two)(suit spades)(player me))
)

(defglobal ?*my-pc* = 0)

(defrule calculate-pc
	(card (name ?card-name)(suit ?)(player me))
=>
	(bind ?*my-pc* (+ ?*my-pc* (card-value ?card-name)))
	(printout t ?*my-pc* crlf)
)
	