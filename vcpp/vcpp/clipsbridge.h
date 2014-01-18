#ifndef CLIPSINTERFACE__H
#define CLIPSINTERFACE__H

#include "CLIPS/clips.h"
#include <sstream>

#define BUFFER_SIZE 256

void UserFunctions(void);
void EnvUserFunctions(void *);

void SwapIOB(FILE *A, FILE *B);



class ClipsBridge {
public:
	void *theEnv;
	std::string bid;
	char ourPlayer;

	ClipsBridge();
	~ClipsBridge();
	void ClipsBridge::PrintFacts(void);
	void ClipsBridge::DealCardsToPlayers(char player);
	std::string ClipsBridge::GetCardsDealtToPlayer(std::string player);
	void ClipsBridge::PlayerBids(std::string bid, char player);
	bool ClipsBridge::Bidding(void);
	void ClipsBridge::IncrementBidCounter(void);
	int ClipsBridge::GetBidCounter(void);
	void ClipsBridge::ResetBidCounter(void);
	std::string ClipsBridge::FindLastBid(void);

private:
	char buffer[BUFFER_SIZE];
	DATA_OBJECT multifieldDO;
	void *multifieldPtr;
	FILE *fp;
	int bidCounter;

	int ClipsBridge::GetCardNumber(std::string arg);
	std::string ClipsBridge::SortCards(int cards[4][14]);
	char ClipsBridge::NextPlayer(char player);
	char ClipsBridge::PreviousPlayer(char player);
	std::string ClipsBridge::ReadPlayerBid(std::stringstream &sStrm);
};

#endif
