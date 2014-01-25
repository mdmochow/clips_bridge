#include <iostream>
#include <deck.h>
#include <card.h>
#include <string>
#include <fstream>

using namespace std;

istream& operator>> (istream& strm, eSuit& suit)
{
    char tmp;
    strm >> tmp;
    switch(tmp)
    {
    case 'S':
        suit=spades;
        break;
    case 'H':
        suit=hearts;
        break;
    case 'D':
        suit=diamonds;
        break;
    case 'C':
        suit=clubs;
        break;
    }
    return strm;
}

istream& operator>> (istream& strm, eCard& fig)
{
    char tmp;
    strm >> tmp;
    switch(tmp)
    {
    case '2':
        fig=two;
        break;
    case '3':
        fig=three;
        break;
    case '4':
        fig=four;
        break;
    case '5':
        fig=five;
        break;
    case '6':
        fig=six;
        break;
    case '7':
        fig=seven;
        break;
    case '8':
        fig=eight;
        break;
    case '9':
        fig=nine;
        break;
    case '1':
        fig=ten;
        break;
    case 'J':
        fig=jack;
        break;
    case 'Q':
        fig=queen;
        break;
    case 'K':
        fig=king;
        break;
    case 'A':
        fig=ace;
        break;
    }
    return strm;
}

int main()
{
    Deck deck;
    cout << "Filename: ";
    string filename;
    cin >> filename;
    ofstream file(filename.c_str(), std::ofstream::out);
    cout << "Number of cards to pick: ";
    int cardsNum;
    cin >> cardsNum;
    for(int i=0; i<cardsNum; ++i){
        cout << "Suit: ";
        eSuit tmp_suit;
        cin >> tmp_suit;
        cout << "Card: ";
        eCard tmp_fig;
        cin >> tmp_fig;
        file << "N ";
        vector<Card>::iterator chosenCard = deck.find(tmp_suit, tmp_fig);
        chosenCard->print(file);
        deck.remove(chosenCard);
    }
    deck.shuffle();
    for(int i=cardsNum; i<13; ++i){
        file << "N ";
        deck.cards[i-cardsNum].print(file);
    }
    for(int i=0; i<13; ++i){
        file << "E ";
        deck.cards[i+13-cardsNum].print(file);
    }
    for(int i=0; i<13; ++i){
        file << "S ";
        deck.cards[i+26-cardsNum].print(file);
    }
    for(int i=0; i<13; ++i){
        file << "W ";
        deck.cards[i+39-cardsNum].print(file);
    }
    file.close();
    return 0;
}

