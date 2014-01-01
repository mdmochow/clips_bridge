#include <stdio.h>
#include "clipsbridge.h"
#include <iostream>
//#include <string>


void SwapIOB(FILE *A, FILE *B) {
    FILE temp;
    memcpy(&temp,A,sizeof(struct _iobuf));
    memcpy(A,B,sizeof(struct _iobuf));
    memcpy(B,&temp,sizeof(struct _iobuf));
}




ClipsBridge::ClipsBridge() {
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




void ClipsBridge::DealCardsToPlayers(char startPlayer) {
	Reset();
	sprintf(buffer,"(state %c-should-pick)",startPlayer);
	AssertString(buffer);
	Run(-1);
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
	int idxS=0, idxH=0, idxD=0, idxC=0, i, j, cards[4][14];

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
		std::cout << buffer << std::endl;
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
   

	
		//PPFact((fact *)GetMFValue(multifieldPtr,i),"stdout",0);

		//PrintAtom(theEnv,"stdout",GetMFType(multifieldPtr,i),(GetMFValue(multifieldPtr,i)));
		//PrintFactWithIdentifier(theEnv,"stdout",(fact *)GetMFValue(multifieldPtr,i));

	//if ((GetMFType(multifieldPtr,i) == STRING) || (GetMFType(multifieldPtr,i) == SYMBOL))
	//tempPtr = ValueToString(GetMFValue(multifieldPtr,i));
