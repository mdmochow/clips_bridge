#include <string>
#include <map>
#include <boost\assign.hpp>
#include "cardsontable.h"

std::map<std::string, ePlayer> mPlayer = boost::assign::map_list_of ("N", N) ("E", E) ("S", S) ("W", W);
std::map<std::string, eCard> mCard = boost::assign::map_list_of ("2", two) ("3", three) ("4", four) ("5", five) 
																("6", six) ("7", seven) ("8", eight) ("9", nine)
																("10", ten) ("J", jack) ("Q", queen) ("K", king) ("A", ace);
std::map<std::string, eSuit> mSuit = boost::assign::map_list_of ("S", spades) ("H", hearts) ("D", diamonds) ("C", clubs);


class CardsOnTable;

CardsOnTable::CardsOnTable() {
	cards=new eCard**[4];
	for (int i=0;i<4;++i) {
		cards[i]=new eCard*[4];
		for (int j=0;j<4;++j) {
			cards[i][j]=new eCard[14];
		}
	}
	ResetCards();
}


CardsOnTable::~CardsOnTable() {
	for (int i=0;i<4;++i) {
		for (int j=0;j<4;++j) {
			delete [] cards[i][j];
		}
		delete [] cards[i];
	}
	delete [] cards;
}


eCard **CardsOnTable::GetCards(ePlayer player) const {
	return cards[player];
}


void CardsOnTable::ResetCards(void) {
	for (int i=0;i<4;++i) {
		for (int j=0;j<4;++j) {
			for (int k=0;k<14;++k) {
				cards[i][j][k]=empty;
			}
			amountOfCards[i][j]=0;
		}
	}
}


void CardsOnTable::ReadCardsFromFile(char *fileName) {
	std::ifstream file(fileName);
	std::string temp;
	ePlayer player;
	eCard card;
	eSuit suit;
	while (!file.eof()) {
		file >> temp;
		player=mPlayer[temp];
		file >> temp;
		suit=mSuit[temp];
		file >> temp;
		card=mCard[temp];
		if (file.eof()) {
			break;
		}
		int idx=amountOfCards[player][suit]++;
		cards[player][suit][idx]=card;
	}
	file.close();
	for (int i=0;i<4;++i) {
		for (int j=0;j<4;++j) {
			std::sort(cards[i][j],cards[i][j]+14);
		}
	}
}
