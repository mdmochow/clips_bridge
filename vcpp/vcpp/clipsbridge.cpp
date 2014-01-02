#include <stdio.h>
#include "clipsbridge.h"
#include <iostream>
#include <map>


void SwapIOB(FILE *A, FILE *B) {
    FILE temp;
    memcpy(&temp,A,sizeof(struct _iobuf));
    memcpy(A,B,sizeof(struct _iobuf));
    memcpy(B,&temp,sizeof(struct _iobuf));
}




ClipsBridge::ClipsBridge(): bidCounter(0) {
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
	sprintf(buffer,"(state %c-should-pick)",startPlayer);
	AssertString(buffer);
	Run(-1);
	sprintf(buffer,"(bid (number 0)(player empty)(type empty)(level 0)(suit empty))");
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




std::string ClipsBridge::SortCards(int cards[4][14]) {
	std::string cardsSorted;
	int i, j, k, tmp;

	for (i=0;i<4;++i) {
		for (j=0;j<14;++j) {
			for (k=0;k<13;++k) {
				if (cards[i][k]>cards[i][k+1]) {
					tmp=cards[i][k];
					cards[i][k]=cards[i][k+1];
					cards[i][k+1]=tmp;
				}
			}
		}
		for (j=0;j<14;++j) {
			if (cards[i][j]!=99) {
				if (cards[i][j]==11) {
					cardsSorted+="J ";
				}
				else if (cards[i][j]==12) {
					cardsSorted+="Q ";
				}
				else if (cards[i][j]==13) {
					cardsSorted+="K ";
				}
				else if (cards[i][j]==14) {
					cardsSorted+="A ";
				}
				else {
					cardsSorted+=std::to_string(cards[i][j]);
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

	retval=SortCards(cards);
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




void ClipsBridge::PlayerBids(std::string bid, char player) {
	int level;
	std::stringstream sStrm;
	char suit[3];
	++bidCounter;

	if (bid=="PASS") {
		sprintf(buffer,"(bid (number %d)(player %c)(type pass)(level 0)(suit empty))",bidCounter,player);
	}
	else if (bid=="DOUBLE") {
		sprintf(buffer,"(bid (number %d)(player %c)(type double)(level 0)(suit empty))",bidCounter,player);
	}
	else if (bid=="REDOUBLE") {
		sprintf(buffer,"(bid (number %d)(player %c)(type redouble)(level 0)(suit empty))",bidCounter,player);
	}
	else {
		sStrm << bid;
		sStrm >> level;
		sStrm >> suit;
		std::cout << "SUIT: " << suit << std::endl;
		sprintf(buffer,"(bid (number %d)(player %c)(type normal)(level %d)(suit %s))",bidCounter,player,level,suit);
	}
	AssertString(buffer);
	sprintf(buffer,"(player %c)",NextPlayer(player));
	AssertString(buffer);
	//Run(-1);
}
   

	
		//PPFact((fact *)GetMFValue(multifieldPtr,i),"stdout",0);

		//PrintAtom(theEnv,"stdout",GetMFType(multifieldPtr,i),(GetMFValue(multifieldPtr,i)));
		//PrintFactWithIdentifier(theEnv,"stdout",(fact *)GetMFValue(multifieldPtr,i));

	//if ((GetMFType(multifieldPtr,i) == STRING) || (GetMFType(multifieldPtr,i) == SYMBOL))
	//tempPtr = ValueToString(GetMFValue(multifieldPtr,i));
