#ifndef CLIPSINTERFACE__H
#define CLIPSINTERFACE__H

#include "CLIPS/clips.h"
#include "cardsontable.h"
#include <sstream>

#define BUFFER_SIZE 256

void UserFunctions(void);
void EnvUserFunctions(void *);

void SwapIOB(FILE *A, FILE *B);

class CardsOnTable;

class ClipsBridge {
public:
	void *theEnv;
	std::string bid;
	char ourPlayer;
	CardsOnTable *cards;

	ClipsBridge(CardsOnTable *mainCards);
	~ClipsBridge();
	void ClipsBridge::PrintFacts(void);
	std::string ClipsBridge::GetCardsInStringTableForPlayer(ePlayer player);
	void ClipsBridge::IncrementBidCounter(void);
	int ClipsBridge::GetBidCounter(void);
	void ClipsBridge::ResetBidCounter(void);


	void ClipsBridge::DealCardsToPlayers(char player);
	std::string ClipsBridge::GetCardsDealtToPlayer(std::string player);
	void ClipsBridge::PlayerBids(std::string bid, char player);
	bool ClipsBridge::Bidding(void);
	std::string ClipsBridge::FindLastBid(void);

private:
	char buffer[BUFFER_SIZE];
	DATA_OBJECT multifieldDO;
	void *multifieldPtr;
	FILE *fp;
	int bidCounter;


	int ClipsBridge::GetCardNumber(std::string arg);
	char ClipsBridge::NextPlayer(char player);
	char ClipsBridge::PreviousPlayer(char player);
	std::string ClipsBridge::ReadPlayerBid(std::stringstream &sStrm);
};

#endif
