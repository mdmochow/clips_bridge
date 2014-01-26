#include <stdio.h>
#include "clipsbridge.h"
#include <iostream>
#include <boost/algorithm/string.hpp>

#pragma warning(disable: 4996)


extern std::map<ePlayer, std::string> mPlayer2clp;
extern std::map<eSuit, std::string> mSuit2clp;
extern std::map<eCard, std::string> mCard2clp;
extern std::map<std::string, ePlayer> mPlayer;
extern std::map<std::string, eCard> mCard;
extern std::map<std::string, eSuit> mSuit;




void SwapIOB(FILE *A, FILE *B) {
    FILE temp;
    memcpy(&temp,A,sizeof(struct _iobuf));
    memcpy(A,B,sizeof(struct _iobuf));
    memcpy(B,&temp,sizeof(struct _iobuf));
}




ClipsBridge::ClipsBridge(CardsOnTable *mainCards): bidCounter(0), ourPlayer(N) {
	cards=mainCards;

	fp=fopen("clips_bridge.log","w");
	SwapIOB(stdout,fp);

	theEnv=CreateEnvironment();
	InitializeEnvironment();
	Load("clips_bridge.clp");
}




ClipsBridge::~ClipsBridge() {
	DestroyEnvironment(theEnv);
	fclose(stdout);
}




void ClipsBridge::PrintFacts(void) {
	int i, end;
	GetFactList(&multifieldDO,NULL);
	end=GetDOEnd(multifieldDO);
	multifieldPtr=GetValue(multifieldDO);
	std::cout << std::endl << std::endl;
	for (i=GetDOBegin(multifieldDO);i<=end;i++) {
		PPFact((fact *)GetMFValue(multifieldPtr,i),"stdout",0);
	}
	std::cout << std::endl << std::endl;
}





void ClipsBridge::DealCardsToPlayers(char startPlayer) {
	Reset();
	sprintf_s(buffer,"(state %c-should-pick)",startPlayer);
	AssertString(buffer);
	Run(-1);
	sprintf_s(buffer,"(bid (number 0)(player empty)(type empty)(level 0)(suit empty))");
	AssertString(buffer);
}




int ClipsBridge::GetCardNumber(std::string arg) {
	if (arg=="two))") {
		return 2;
	}
	else if (arg=="three))") {
		return 3;
	}
	else if (arg=="four))") {
		return 4;
	}
	else if (arg=="five))") {
		return 5;
	}
	else if (arg=="six))") {
		return 6;
	}
	else if (arg=="seven))") {
		return 7;
	}
	else if (arg=="eight))") {
		return 8;
	}
	else if (arg=="nine))") {
		return 9;
	}
	else if (arg=="ten))") {
		return 10;
	}
	else if (arg=="jack))") {
		return 11;
	}
	else if (arg=="queen))") {
		return 12;
	}
	else if (arg=="king))") {
		return 13;
	}
	return 14;
}




std::string ClipsBridge::GetCardsInStringTableForPlayer(ePlayer player) {
	std::string cardsSorted;
	int i, j;
	
	eCard **pCards=cards->GetCards(player);
	for (i=0;i<4;++i) {
		for (j=0;j<14;++j) {
			if (pCards[i][j]!=empty) {
				if (pCards[i][j]==jack) {
					cardsSorted+="J ";
				}
				else if (pCards[i][j]==queen) {
					cardsSorted+="Q ";
				}
				else if (pCards[i][j]==king) {
					cardsSorted+="K ";
				}
				else if (pCards[i][j]==ace) {
					cardsSorted+="A ";
				}
				else {
					cardsSorted+=std::to_string(pCards[i][j]);
					cardsSorted+=" ";
				}
			}
			else {
				cardsSorted+="\r\n\r\n";
				break;
			}
		}
	}
	return cardsSorted;
}




std::string ClipsBridge::GetCardsDealtToPlayer(std::string player) {
	std::string temp, retval;
	std::stringstream sStrm;
	int idxS=0, idxH=0, idxD=0, idxC=0, i, j, end, cards[4][14];

	for (i=0;i<4;++i) {
		for (j=0;j<14;++j) {
			cards[i][j]=99;
		}
	}
	
	GetFactList(&multifieldDO,NULL);
	end=GetDOEnd(multifieldDO);
	multifieldPtr=GetValue(multifieldDO);
	for (i=GetDOBegin(multifieldDO);i<=end;i++) {
		GetFactPPForm(buffer,BUFFER_SIZE,(fact *)GetMFValue(multifieldPtr,i));
		//std::cout << buffer << std::endl;
		sStrm << buffer;
		sStrm >> temp; // fact number
		sStrm >> temp; // "(card"
		if (temp=="(card") {
			sStrm >> temp; // "(player"
			sStrm >> temp; // "N) / S) / E) / W)"
			if (temp==player) {
				sStrm >> temp; // "(suit"
				sStrm >> temp; // card suit
				if (temp=="spades)") {
					sStrm >> temp; // "(name"
					sStrm >> temp; // card nr
					cards[0][idxS++]=GetCardNumber(temp);
				}
				else if (temp=="hearts)") {
					sStrm >> temp; // "(name"
					sStrm >> temp; // card nr
					cards[1][idxH++]=GetCardNumber(temp);
				}
				else if (temp=="diamonds)") {
					sStrm >> temp; // "(name"
					sStrm >> temp; // card nr
					cards[2][idxD++]=GetCardNumber(temp);
				}
				else if (temp=="clubs)") {
					sStrm >> temp; // "(name"
					sStrm >> temp; // card nr
					cards[3][idxC++]=GetCardNumber(temp);
				}
				
			} // temp==player
		} // temp=="(card"
		while (!sStrm.eof()) {
			sStrm >> temp;
		}
		sStrm.clear();
	}

	//retval=SortCards(cards);
	return retval;
}




char ClipsBridge::NextPlayer(char player) {
	const char players[5]={'N','E','S','W','N'};
	int i;
	for (i=0;i<4;++i) {
		if (players[i]==player) {
			break;
		}
	}
	return players[i+1];
}




char ClipsBridge::PreviousPlayer(char player) {
	const char players[5]={'W','N','E','S','W'};
	int i;
	for (i=1;i<5;++i) {
		if (players[i]==player) {
			break;
		}
	}
	return players[i-1];
}




void ClipsBridge::PlayerBids(std::string bid, char player, int lastBidLevel, std::string lastBidSuit) {
	int level;
	std::stringstream sStrm;
	char suit[3];
	DATA_OBJECT tempDO;

	IncrementBidCounter();
	
	Eval("(bind ?*bids-made* (+ ?*bids-made* 1))",&tempDO);

	if (bid=="PASS") {
		sprintf_s(buffer,"(bid (number %d)(player %c)(type pass)(level %d)(suit %s))",bidCounter,player,lastBidLevel,lastBidSuit.c_str());
		Eval("(bind ?*pass-count* (+ ?*pass-count* 1))",&tempDO);
	}
	else if (bid=="X") {
		sprintf_s(buffer,"(bid (number %d)(player %c)(type double)(level %d)(suit %s))",bidCounter,player,lastBidLevel,lastBidSuit.c_str());
		Eval("(bind ?*pass-count* 0)",&tempDO);
	}
	else if (bid=="XX") {
		sprintf_s(buffer,"(bid (number %d)(player %c)(type redouble)(level %d)(suit %s))",bidCounter,player,lastBidLevel,lastBidSuit.c_str());
		Eval("(bind ?*pass-count* 0)",&tempDO);
	}
	else {
		sStrm << bid;
		sStrm >> level;
		sStrm >> suit;
		sprintf_s(buffer,"(bid (number %d)(player %c)(type normal)(level %d)(suit %s))",bidCounter,player,level,suit);
		Eval("(bind ?*pass-count* 0)",&tempDO);
	}
	//std::cout << "ASSERTING: " << buffer << std::endl;
	AssertString(buffer);
}
   



bool ClipsBridge::Bidding(void) {
	DATA_OBJECT rtn;

	FunctionCall("end-of-bidding","",&rtn);
	if (DOToInteger(rtn)) {
		return false;
	}
	return true;
}




void ClipsBridge::IncrementBidCounter(void) {
	bidCounter++;
}




int ClipsBridge::GetBidCounter(void) {
	return bidCounter;
}




void ClipsBridge::ResetBidCounter(void) {
	bidCounter=0;
}




std::string ClipsBridge::FindLastBid(void) {
	std::string temp, bidNr, ourPlayerStr=mPlayer2clp[ourPlayer];
	std::stringstream sStrm;
	int i, end;

	bidNr=std::to_string(bidCounter);
	bidNr+=")";
	ourPlayerStr+=")";

	GetFactList(&multifieldDO,NULL);
	end=GetDOEnd(multifieldDO);
	multifieldPtr=GetValue(multifieldDO);
	for (i=GetDOBegin(multifieldDO);i<=end;i++) {
		GetFactPPForm(buffer,BUFFER_SIZE,(fact *)GetMFValue(multifieldPtr,i));
		//std::cout << buffer << std::endl;
		sStrm << buffer;
		sStrm >> temp; // fact number
		sStrm >> temp; // "(bid"
		if (temp=="(bid") {
			sStrm >> temp; // "(number"
			sStrm >> temp; // "%d)"
			if (temp==bidNr) {
				sStrm >> temp; // "(player"
				sStrm >> temp; // player who made the bid
				if (temp==ourPlayerStr) {
					return ReadPlayerBid(sStrm);
				}
				
			} // temp==player
		} // temp=="(card"
		while (!sStrm.eof()) {
			sStrm >> temp;
		}
		sStrm.clear();
	}
	return "BNF";
}




int ClipsBridge::FindLastBidLevel(void) {
	std::string temp, bidNr;
	std::stringstream sStrm;
	int i, end;
	std::string level;

	bidNr=std::to_string(bidCounter);
	bidNr+=")";

	GetFactList(&multifieldDO,NULL);
	end=GetDOEnd(multifieldDO);
	multifieldPtr=GetValue(multifieldDO);
	for (i=GetDOBegin(multifieldDO);i<=end;i++) {
		GetFactPPForm(buffer,BUFFER_SIZE,(fact *)GetMFValue(multifieldPtr,i));
		//std::cout << buffer << std::endl;
		sStrm << buffer;
		sStrm >> temp; // fact number
		sStrm >> temp; // "(bid"
		if (temp=="(bid") {
			sStrm >> temp; // "(number"
			sStrm >> temp; // "%d)"
			if (temp==bidNr) {
				sStrm >> temp; // "(player"
				sStrm >> temp; // player who made the bid
				sStrm >> temp; // "(type
				sStrm >> temp; // card nr
				sStrm >> temp; // (level
				sStrm >> level;
				return std::stoi(level);
			} // temp==bidNr
		}
		while (!sStrm.eof()) {
			sStrm >> temp;
		}
		sStrm.clear();
	}
	return 0;
}




std::string ClipsBridge::FindLastBidSuit(void) {
	std::string temp, bidNr;
	std::stringstream sStrm;
	int i, end;
	std::string suit;

	bidNr=std::to_string(bidCounter);
	bidNr+=")";

	GetFactList(&multifieldDO,NULL);
	end=GetDOEnd(multifieldDO);
	multifieldPtr=GetValue(multifieldDO);
	for (i=GetDOBegin(multifieldDO);i<=end;i++) {
		GetFactPPForm(buffer,BUFFER_SIZE,(fact *)GetMFValue(multifieldPtr,i));
		//std::cout << buffer << std::endl;
		sStrm << buffer;
		sStrm >> temp; // fact number
		sStrm >> temp; // "(bid"
		if (temp=="(bid") {
			sStrm >> temp; // "(number"
			sStrm >> temp; // "%d)"
			if (temp==bidNr) {
				sStrm >> temp; // "(player"
				sStrm >> temp; // player who made the bid
				sStrm >> temp; // "(type
				sStrm >> temp; // card nr
				sStrm >> temp; // "(level"
				sStrm >> temp; // bid level
				sStrm >> temp; // "(suit"
				sStrm >> suit; // suit))
				int size=suit.size();
				suit.resize(size-2);
				return suit;
			} // temp==bidNr
		}
		while (!sStrm.eof()) {
			sStrm >> temp;
		}
		sStrm.clear();
	}
	return "";
}





std::string ClipsBridge::ReadPlayerBid(std::stringstream &sStrm) {
	std::string temp;
	std::string number, player, type, level, suit;
	sStrm >> temp; // "(type
	sStrm >> type; // card nr
	if(type == "normal)"){
		sStrm >> temp; // (level
		sStrm >> level;
		sStrm >> temp; // (suit
		sStrm >> suit;
		if(suit == "NT))")
			return std::string(1, level.at(0)) + " NT";
		return std::string(1, level.at(0)) + " " + boost::to_upper_copy(std::string(1, suit.at(0)));
	}
	if(type == "pass)")
		return "PASS";
	if(type == "double)")
		return "X";
	if(type == "redouble)")
		return "XX";
	return "WB";
	//(bid (number %d)(player %c)(type normal)(level %d)(suit %s))
}




void ClipsBridge::RetractFactByName(std::string factStr) {
	std::string tempClips, tempCpp;
	bool factFound=false;
	int i, end;

	GetFactList(&multifieldDO,NULL);
	end=GetDOEnd(multifieldDO);
	multifieldPtr=GetValue(multifieldDO);
	for (i=GetDOBegin(multifieldDO);i<=end;i++) {
		std::stringstream sStrmClips, sStrmCpp;
		GetFactPPForm(buffer,BUFFER_SIZE,(fact *)GetMFValue(multifieldPtr,i));
		sStrmClips << buffer;
		sStrmClips >> tempClips; // fact nr
		sStrmCpp << factStr;
		while (!sStrmClips.eof()) {
			sStrmClips >> tempClips;
			sStrmCpp >> tempCpp;
			//std::cout << "comparing: " << tempClips << ", " << tempCpp << std::endl;
			if (tempClips!=tempCpp) {
				//std::cout << "That's not it." << std::endl;
				factFound=false;
				break;
			}
			factFound=true;
		}
		if (factFound) {
			//std::cout << "Fount it!" << std::endl;
			Retract((fact *)GetMFValue(multifieldPtr,i));
			break;
		}
	}	
}
