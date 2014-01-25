#include "deck.h"
#include "card.h"
#include <boost/foreach.hpp>
#include <algorithm>

Deck::Deck()
{
    for(int i=0; i<4; ++i)
        for(int j=2; j<15; ++j){
            eCard fig = static_cast<eCard>(j);
            eSuit suit = static_cast<eSuit>(i);
            cards.push_back(Card(fig, suit));
        }
}

void Deck::printDeck(ostream & strm)
{
    BOOST_FOREACH(Card card, cards)
    {
        card.print(strm);
    }
}

vector<Card>::iterator Deck::find(eSuit s, eCard c)
{
    return std::find(cards.begin(), cards.end(), Card(c, s));
}

void Deck::remove(vector<Card>::iterator toRemove)
{
    cards.erase(toRemove);
}

void Deck::shuffle()
{
    std::random_shuffle(cards.begin(), cards.end());
}
