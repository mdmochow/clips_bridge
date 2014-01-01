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

	ClipsBridge();
	~ClipsBridge();
	void ClipsBridge::DealCardsToPlayers(char player);
	std::string ClipsBridge::GetCardsDealtToPlayer(std::string player);

private:
	char buffer[BUFFER_SIZE];
	std::stringstream sStrm;
	DATA_OBJECT multifieldDO;
	void *multifieldPtr;
	int end, i;
	FILE *fp;

	int ClipsBridge::GetCardNumber(std::string arg);
	std::string ClipsBridge::SortCards(int cards[4][14]);
};

#endif
