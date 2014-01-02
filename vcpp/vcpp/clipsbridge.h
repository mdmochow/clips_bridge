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

	ClipsBridge();
	~ClipsBridge();
	void ClipsBridge::PrintFacts(void);
	void ClipsBridge::DealCardsToPlayers(char player);
	std::string ClipsBridge::GetCardsDealtToPlayer(std::string player);
	void ClipsBridge::PlayerBids(std::string bid, char player);
	bool ClipsBridge::Bidding(void);

private:
	char buffer[BUFFER_SIZE];
	DATA_OBJECT multifieldDO;
	void *multifieldPtr;
	FILE *fp;
	int bidCounter;
	long tmp, bidCnt, zero;

	int ClipsBridge::GetCardNumber(std::string arg);
	std::string ClipsBridge::SortCards(int cards[4][14]);
	char ClipsBridge::NextPlayer(char player);
};

#endif
