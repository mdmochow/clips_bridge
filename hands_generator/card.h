#ifndef CARD_H
#define CARD_H

#include <ostream>

using namespace std;

enum eCard {two=2, three, four, five, six, seven, eight, nine, ten, jack, queen, king, ace, empty};
enum eSuit {spades=0, hearts, diamonds, clubs};

class Card
{
public:
    Card(eCard, eSuit);
    void print(ostream &strm);
    bool operator ==(Card rhs);

private:
    void printSuit(ostream &strm);
    void printFigure(ostream& strm);
    eCard figure;
    eSuit suit;
};

#endif // CARD_H
