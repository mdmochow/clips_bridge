#include "MyForm.h"

using namespace vcpp;

void MyForm::InitGame(void) {
	clips->cards->ResetCards();
	Reset();
	clips->ResetBidCounter();
	bidBoxN->Clear();
	bidBoxE->Clear();
	bidBoxS->Clear();
	bidBoxW->Clear();
	if ((dealMark+1)>3) {
		dealMark=N;
		currentBidder=W;
	}
	else {
		dealMark=static_cast<ePlayer>(dealMark+1);
		currentBidder=static_cast<ePlayer>(dealMark-1);
	}
	if (currentBidder>0) {
		bidBoxN->Text+="\r\n";
		if (currentBidder>1) {
			bidBoxE->Text+="\r\n";
			if (currentBidder>2) {
				bidBoxS->Text+="\r\n";
			}
		}
	}

	AssertString("(bid (number 0)(player empty)(type empty)(level 0)(suit empty))");
}




void MyForm::DisplayCards(void) {
	std::string cardsSorted;
	for (int i=0;i<4;++i) {
		cardsSorted=clips->GetCardsInStringTableForPlayer(static_cast<ePlayer>(i));
		String^ StrVal=gcnew String(cardsSorted.c_str());
		if (i==0) {
			tbxPlayerN->Text=StrVal;
		}
		else if (i==1) {
			tbxPlayerE->Text=StrVal;
		}
		else if (i==2) {
			tbxPlayerS->Text=StrVal;
		}
		else {
			tbxPlayerW->Text=StrVal;
		}
	}
}




void MyForm::AssertCards(void) {
	eCard **pCards=clips->cards->GetCards(clips->ourPlayer);
	for (int i=0;i<4;++i) {
		for (int j=0;j<14;++j) {
			if (pCards[i][j]!=empty) {
				std::string buffer="(card (suit ";
				buffer+=mSuit2clp[static_cast<eSuit>(i)];
				buffer+=")(name ";
				buffer+=mCard2clp[pCards[i][j]];
				buffer+="))";
				//std::cout << buffer << std::endl;
				AssertString(const_cast<char *>(buffer.c_str()));
			}
			else {
				break;
			}
		}
	}
	Run(-1);
}




void MyForm::IncrementCurrentBidder(void) {
	if ((currentBidder+1)>3) {
		currentBidder=N;
	}
	else {
		currentBidder=static_cast<ePlayer>(currentBidder+1);
	}
}




System::Void MyForm::button1_Click(System::Object^  sender, System::EventArgs^  e) {
	//const std::string playersStr[4]={"N)","E)","S)","W)"};
	const char players[4]={'N','E','S','W'};
		
	InitGame();

	char* fileName=(char*)(System::Runtime::InteropServices::Marshal::StringToHGlobalAnsi(textBox1->Text)).ToPointer();
	std::string fullFN=fileName;
	if (fullFN=="") {
		fullFN="table";
	}
	fullFN+=".txt";
	clips->cards->ReadCardsFromFile(const_cast<char *>(fullFN.c_str()));
	System::Runtime::InteropServices::Marshal::FreeHGlobal(System::IntPtr((void*)fileName));

	DisplayCards();

	AssertCards();

	//ShowDefglobals("stdout",NULL);
	//clips->PrintFacts();

	while (clips->Bidding()) {
		//std::cout << std::endl << "beginning of loop: " << std::endl;
		//ShowDefglobals("stdout",NULL);
		if (currentBidder==clips->ourPlayer) {
			AssertString("(bidding our-player-should-bid)");
			clips->RetractFactByName("(bidding made-a-bid)");
			Run(-1);
			//ShowDefglobals("stdout",NULL);
			//clips->PrintFacts();
			clips->IncrementBidCounter();
			String^ StrVal=gcnew String(clips->FindLastBid().c_str());
			bidBoxN->Text+=StrVal;
			bidBoxN->Text+="\r\n";
			IncrementCurrentBidder();
		}
		else {
			DialogBox ^wnd = gcnew DialogBox(label5);
				
			wnd->ShowDialog();
			String^ StrVal=gcnew String(label5->Text);
			if (currentBidder==N) {
				bidBoxN->Text+=StrVal;
				bidBoxN->Text+="\r\n";
			}
			else if (currentBidder==E) {
				bidBoxE->Text+=StrVal;
				bidBoxE->Text+="\r\n";
			}
			else if (currentBidder==S) {
				bidBoxS->Text+=StrVal;
				bidBoxS->Text+="\r\n";
			}
			else {
				bidBoxW->Text+=StrVal;
				bidBoxW->Text+="\r\n";
			}
			bid=label5->Text;
			const char* charBid=(const char*)(System::Runtime::InteropServices::Marshal::StringToHGlobalAnsi(bid)).ToPointer();
			//std::cout << "bid: " << charBid << std::endl;
			clips->PlayerBids(charBid, players[static_cast<int>(currentBidder)], clips->FindLastBidLevel(), clips->FindLastBidSuit());
			Run(-1);
			//ShowDefglobals("stdout",NULL);
			IncrementCurrentBidder();
			System::Runtime::InteropServices::Marshal::FreeHGlobal(System::IntPtr((void*)charBid));
			//clips->PrintFacts();
		} // else
		//std::cout << "end of loop: " << std::endl;
		//ShowDefglobals("stdout",NULL);
	} // while (clips->Bidding())
	//ShowDefglobals("stdout",NULL);
	//clips->PrintFacts();
} // button1_Click
