#ifndef DECK_H
#define DECK_H
#include <vector>
#include <ostream>
#include <card.h>

using namespace std;

class Deck
{
public:
    Deck();
    void printDeck(ostream &);
    vector<Card>::iterator find(eSuit, eCard);
    void remove(vector<Card>::iterator toRemove);
    vector<Card> cards;
    void shuffle();
private:
};

#endif // DECK_H
