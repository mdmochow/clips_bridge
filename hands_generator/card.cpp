#include "card.h"

Card::Card(eCard c, eSuit s): figure(c), suit(s)
{

}

void Card::printSuit(ostream & strm)
{
    switch(suit)
    {
    case hearts:
        strm << "H ";
        break;
    case spades:
        strm << "S ";
        break;
    case diamonds:
        strm << "D ";
        break;
    case clubs:
        strm << "C ";
        break;
    }
}

void Card::printFigure(ostream& strm)
{
    switch(figure)
    {
    case two:
        strm << "2 ";
        break;
    case three:
        strm << "3 ";
        break;
    case four:
        strm << "4 ";
        break;
    case five:
        strm << "5 ";
        break;
    case six:
        strm << "6 ";
        break;
    case seven:
        strm << "7 ";
        break;
    case eight:
        strm << "8 ";
        break;
    case nine:
        strm << "9 ";
        break;
    case ten:
        strm << "10 ";
        break;
    case jack:
        strm << "J ";
        break;
    case queen:
        strm << "Q ";
        break;
    case king:
        strm << "K ";
        break;
    case ace:
        strm << "A ";
        break;
    }
}

void Card::print(ostream & strm)
{
    printSuit(strm);
    printFigure(strm);
    strm << endl;
}

bool Card::operator ==(Card rhs)
{
    return figure==rhs.figure && suit==rhs.suit;
}
