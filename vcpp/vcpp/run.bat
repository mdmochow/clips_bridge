(clear)
(load clips_bridge.clp)
(reset)
(run)
(assert (bid (number 0)(player empty)(type empty)(level 0)(suit empty)))
(assert (bidding our-player-should-bid))
(run)
(facts)
(show-defglobals)