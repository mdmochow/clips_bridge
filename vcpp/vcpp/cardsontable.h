#ifndef CARDSONTABLE_H
#define CARDSONTABLE_H

#include <fstream>
#include <map>
#include <boost\assign.hpp>

enum ePlayer {N=0, E, S, W};
enum eCard {two=2, three, four, five, six, seven, eight, nine, ten, jack, queen, king, ace, empty};
enum eSuit {spades=0, hearts, diamonds, clubs};

//extern std::map<std::string, ePlayer> mPlayer;
//extern std::map<std::string, eCard> mCard;
//extern std::map<std::string, eSuit> mSuit;

class CardsOnTable {
public:
	CardsOnTable::CardsOnTable();
	CardsOnTable::~CardsOnTable();
	eCard **CardsOnTable::GetCards(ePlayer player) const;
	void CardsOnTable::ResetCards(void);
	void CardsOnTable::ReadCardsFromFile(char *fileName);
private:
	eCard ***cards;
	int amountOfCards[4][4];
	
};

#endif
