#pragma once
#include <string>
#include "clipsbridge.h"
#include "DialogBox.h"
#include <iostream>
#include "stringconversion.h"
#include "cardsontable.h"
#include <boost\assign.hpp>

namespace {
std::map<ePlayer, std::string> mPlayer2clp = boost::assign::map_list_of (N, "N") (E, "E") (S, "S") (W, "W");
std::map<eSuit, std::string> mSuit2clp = boost::assign::map_list_of (spades, "spades") (hearts, "hearts") (diamonds, "diamonds") (clubs, "clubs");
std::map<eCard, std::string> mCard2clp = boost::assign::map_list_of (two, "two") (three, "three") (four, "four") (five, "five") 
								(six, "six") (seven, "seven") (eight, "eight") (nine, "nine")
								(ten, "ten") (jack, "jack") (queen, "queen") (king, "king") (ace, "ace");

};

namespace vcpp {

	using namespace System;
	using namespace System::ComponentModel;
	using namespace System::Collections;
	using namespace System::Windows::Forms;
	using namespace System::Data;
	using namespace System::Drawing;

	/// <summary>
	/// Summary for MyForm
	/// </summary>
	public ref class MyForm : public System::Windows::Forms::Form
	{
	private: 
		System::ComponentModel::Container ^components;
		ClipsBridge *clips;
		String ^bid;
		int currentBidder;
		int dealMark;
	private: System::Windows::Forms::TextBox^  bidBoxN;

	public: System::Windows::Forms::Label^  label6;
	private: System::Windows::Forms::TextBox^  bidBoxE;
	public: 

	public: 
	public: System::Windows::Forms::Label^  label7;
	private: System::Windows::Forms::TextBox^  bidBoxS;
	public: 
	private: 

	public: 
	public: System::Windows::Forms::Label^  label8;
	private: System::Windows::Forms::TextBox^  bidBoxW;
	public: 
	private: 

	public: 
	public: System::Windows::Forms::Label^  label9;
	private: 
	private: 
	public: System::Windows::Forms::Label^  label5;
	public:
		MyForm(ClipsBridge *clipsMain)
		{
			InitializeComponent();
			dealMark=0;
			currentBidder=0;
			clips=clipsMain;
			bid=gcnew String("");
			label5->Text=bid;
			//
			//TODO: Add the constructor code here
			//
		}

	protected:
		/// <summary>
		/// Clean up any resources being used.
		/// </summary>
		~MyForm()
		{
			if (components)
			{
				delete components;
			}
		}
	private: System::Windows::Forms::TextBox^  tbxPlayerN;
	private: System::Windows::Forms::Button^  btnDisplay;
	protected: 

	protected: 

	private: System::Windows::Forms::MenuStrip^  menuStrip1;
	private: System::Windows::Forms::ToolStripMenuItem^  fileToolStripMenuItem;
	private: System::Windows::Forms::ToolStripMenuItem^  aboutToolStripMenuItem;


	private: System::Windows::Forms::PictureBox^  pictureBox1;
	private: System::Windows::Forms::PictureBox^  pictureBox2;
	private: System::Windows::Forms::PictureBox^  pictureBox3;
	private: System::Windows::Forms::PictureBox^  pictureBox4;
	private: System::Windows::Forms::Label^  label1;
	private: System::Windows::Forms::Label^  label2;
	private: System::Windows::Forms::PictureBox^  pictureBox5;
	private: System::Windows::Forms::PictureBox^  pictureBox6;
	private: System::Windows::Forms::PictureBox^  pictureBox7;
	private: System::Windows::Forms::PictureBox^  pictureBox8;
	private: System::Windows::Forms::TextBox^  tbxPlayerS;

	private: System::Windows::Forms::Label^  label3;
	private: System::Windows::Forms::PictureBox^  pictureBox9;
	private: System::Windows::Forms::PictureBox^  pictureBox10;
	private: System::Windows::Forms::PictureBox^  pictureBox11;
	private: System::Windows::Forms::PictureBox^  pictureBox12;
	private: System::Windows::Forms::TextBox^  tbxPlayerW;

	private: System::Windows::Forms::Label^  label4;
	private: System::Windows::Forms::PictureBox^  pictureBox13;
	private: System::Windows::Forms::PictureBox^  pictureBox14;
	private: System::Windows::Forms::PictureBox^  pictureBox15;
	private: System::Windows::Forms::PictureBox^  pictureBox16;
	private: System::Windows::Forms::TextBox^  tbxPlayerE;













	private:
		/// <summary>
		/// Required designer variable.
		/// </summary>



#pragma region Windows Form Designer generated code
		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		void InitializeComponent(void)
		{
			System::ComponentModel::ComponentResourceManager^  resources = (gcnew System::ComponentModel::ComponentResourceManager(MyForm::typeid));
			this->tbxPlayerN = (gcnew System::Windows::Forms::TextBox());
			this->btnDisplay = (gcnew System::Windows::Forms::Button());
			this->menuStrip1 = (gcnew System::Windows::Forms::MenuStrip());
			this->fileToolStripMenuItem = (gcnew System::Windows::Forms::ToolStripMenuItem());
			this->aboutToolStripMenuItem = (gcnew System::Windows::Forms::ToolStripMenuItem());
			this->pictureBox1 = (gcnew System::Windows::Forms::PictureBox());
			this->pictureBox2 = (gcnew System::Windows::Forms::PictureBox());
			this->pictureBox3 = (gcnew System::Windows::Forms::PictureBox());
			this->pictureBox4 = (gcnew System::Windows::Forms::PictureBox());
			this->label1 = (gcnew System::Windows::Forms::Label());
			this->label2 = (gcnew System::Windows::Forms::Label());
			this->pictureBox5 = (gcnew System::Windows::Forms::PictureBox());
			this->pictureBox6 = (gcnew System::Windows::Forms::PictureBox());
			this->pictureBox7 = (gcnew System::Windows::Forms::PictureBox());
			this->pictureBox8 = (gcnew System::Windows::Forms::PictureBox());
			this->tbxPlayerS = (gcnew System::Windows::Forms::TextBox());
			this->label3 = (gcnew System::Windows::Forms::Label());
			this->pictureBox9 = (gcnew System::Windows::Forms::PictureBox());
			this->pictureBox10 = (gcnew System::Windows::Forms::PictureBox());
			this->pictureBox11 = (gcnew System::Windows::Forms::PictureBox());
			this->pictureBox12 = (gcnew System::Windows::Forms::PictureBox());
			this->tbxPlayerW = (gcnew System::Windows::Forms::TextBox());
			this->label4 = (gcnew System::Windows::Forms::Label());
			this->pictureBox13 = (gcnew System::Windows::Forms::PictureBox());
			this->pictureBox14 = (gcnew System::Windows::Forms::PictureBox());
			this->pictureBox15 = (gcnew System::Windows::Forms::PictureBox());
			this->pictureBox16 = (gcnew System::Windows::Forms::PictureBox());
			this->tbxPlayerE = (gcnew System::Windows::Forms::TextBox());
			this->label5 = (gcnew System::Windows::Forms::Label());
			this->bidBoxN = (gcnew System::Windows::Forms::TextBox());
			this->label6 = (gcnew System::Windows::Forms::Label());
			this->bidBoxE = (gcnew System::Windows::Forms::TextBox());
			this->label7 = (gcnew System::Windows::Forms::Label());
			this->bidBoxS = (gcnew System::Windows::Forms::TextBox());
			this->label8 = (gcnew System::Windows::Forms::Label());
			this->bidBoxW = (gcnew System::Windows::Forms::TextBox());
			this->label9 = (gcnew System::Windows::Forms::Label());
			this->menuStrip1->SuspendLayout();
			(cli::safe_cast<System::ComponentModel::ISupportInitialize^  >(this->pictureBox1))->BeginInit();
			(cli::safe_cast<System::ComponentModel::ISupportInitialize^  >(this->pictureBox2))->BeginInit();
			(cli::safe_cast<System::ComponentModel::ISupportInitialize^  >(this->pictureBox3))->BeginInit();
			(cli::safe_cast<System::ComponentModel::ISupportInitialize^  >(this->pictureBox4))->BeginInit();
			(cli::safe_cast<System::ComponentModel::ISupportInitialize^  >(this->pictureBox5))->BeginInit();
			(cli::safe_cast<System::ComponentModel::ISupportInitialize^  >(this->pictureBox6))->BeginInit();
			(cli::safe_cast<System::ComponentModel::ISupportInitialize^  >(this->pictureBox7))->BeginInit();
			(cli::safe_cast<System::ComponentModel::ISupportInitialize^  >(this->pictureBox8))->BeginInit();
			(cli::safe_cast<System::ComponentModel::ISupportInitialize^  >(this->pictureBox9))->BeginInit();
			(cli::safe_cast<System::ComponentModel::ISupportInitialize^  >(this->pictureBox10))->BeginInit();
			(cli::safe_cast<System::ComponentModel::ISupportInitialize^  >(this->pictureBox11))->BeginInit();
			(cli::safe_cast<System::ComponentModel::ISupportInitialize^  >(this->pictureBox12))->BeginInit();
			(cli::safe_cast<System::ComponentModel::ISupportInitialize^  >(this->pictureBox13))->BeginInit();
			(cli::safe_cast<System::ComponentModel::ISupportInitialize^  >(this->pictureBox14))->BeginInit();
			(cli::safe_cast<System::ComponentModel::ISupportInitialize^  >(this->pictureBox15))->BeginInit();
			(cli::safe_cast<System::ComponentModel::ISupportInitialize^  >(this->pictureBox16))->BeginInit();
			this->SuspendLayout();
			// 
			// tbxPlayerN
			// 
			this->tbxPlayerN->AccessibleName = L"tbxPlayerN";
			this->tbxPlayerN->BackColor = System::Drawing::SystemColors::GradientInactiveCaption;
			this->tbxPlayerN->Font = (gcnew System::Drawing::Font(L"Microsoft Sans Serif", 9.75F, System::Drawing::FontStyle::Bold, System::Drawing::GraphicsUnit::Point, 
				static_cast<System::Byte>(0)));
			this->tbxPlayerN->Location = System::Drawing::Point(292, 54);
			this->tbxPlayerN->Multiline = true;
			this->tbxPlayerN->Name = L"tbxPlayerN";
			this->tbxPlayerN->ReadOnly = true;
			this->tbxPlayerN->Size = System::Drawing::Size(180, 125);
			this->tbxPlayerN->TabIndex = 0;
			this->tbxPlayerN->TextAlign = System::Windows::Forms::HorizontalAlignment::Right;
			// 
			// btnDisplay
			// 
			this->btnDisplay->AccessibleName = L"btnDisplay";
			this->btnDisplay->Location = System::Drawing::Point(12, 30);
			this->btnDisplay->Name = L"btnDisplay";
			this->btnDisplay->Size = System::Drawing::Size(75, 23);
			this->btnDisplay->TabIndex = 1;
			this->btnDisplay->Text = L"Play";
			this->btnDisplay->UseVisualStyleBackColor = true;
			this->btnDisplay->Click += gcnew System::EventHandler(this, &MyForm::button1_Click);
			// 
			// menuStrip1
			// 
			this->menuStrip1->Items->AddRange(gcnew cli::array< System::Windows::Forms::ToolStripItem^  >(1) {this->fileToolStripMenuItem});
			this->menuStrip1->Location = System::Drawing::Point(0, 0);
			this->menuStrip1->Name = L"menuStrip1";
			this->menuStrip1->Size = System::Drawing::Size(794, 24);
			this->menuStrip1->TabIndex = 2;
			this->menuStrip1->Text = L"menuStrip1";
			// 
			// fileToolStripMenuItem
			// 
			this->fileToolStripMenuItem->DropDownItems->AddRange(gcnew cli::array< System::Windows::Forms::ToolStripItem^  >(1) {this->aboutToolStripMenuItem});
			this->fileToolStripMenuItem->Name = L"fileToolStripMenuItem";
			this->fileToolStripMenuItem->Size = System::Drawing::Size(37, 20);
			this->fileToolStripMenuItem->Text = L"File";
			// 
			// aboutToolStripMenuItem
			// 
			this->aboutToolStripMenuItem->AccessibleName = L"menuFileAbout";
			this->aboutToolStripMenuItem->Name = L"aboutToolStripMenuItem";
			this->aboutToolStripMenuItem->Size = System::Drawing::Size(116, 22);
			this->aboutToolStripMenuItem->Text = L"About...";
			// 
			// pictureBox1
			// 
			this->pictureBox1->Image = (cli::safe_cast<System::Drawing::Image^  >(resources->GetObject(L"pictureBox1.Image")));
			this->pictureBox1->Location = System::Drawing::Point(478, 54);
			this->pictureBox1->Name = L"pictureBox1";
			this->pictureBox1->Size = System::Drawing::Size(26, 26);
			this->pictureBox1->TabIndex = 9;
			this->pictureBox1->TabStop = false;
			// 
			// pictureBox2
			// 
			this->pictureBox2->Image = (cli::safe_cast<System::Drawing::Image^  >(resources->GetObject(L"pictureBox2.Image")));
			this->pictureBox2->Location = System::Drawing::Point(478, 86);
			this->pictureBox2->Name = L"pictureBox2";
			this->pictureBox2->Size = System::Drawing::Size(26, 26);
			this->pictureBox2->TabIndex = 10;
			this->pictureBox2->TabStop = false;
			// 
			// pictureBox3
			// 
			this->pictureBox3->Image = (cli::safe_cast<System::Drawing::Image^  >(resources->GetObject(L"pictureBox3.Image")));
			this->pictureBox3->Location = System::Drawing::Point(478, 118);
			this->pictureBox3->Name = L"pictureBox3";
			this->pictureBox3->Size = System::Drawing::Size(26, 26);
			this->pictureBox3->TabIndex = 11;
			this->pictureBox3->TabStop = false;
			// 
			// pictureBox4
			// 
			this->pictureBox4->Image = (cli::safe_cast<System::Drawing::Image^  >(resources->GetObject(L"pictureBox4.Image")));
			this->pictureBox4->Location = System::Drawing::Point(478, 150);
			this->pictureBox4->Name = L"pictureBox4";
			this->pictureBox4->Size = System::Drawing::Size(26, 26);
			this->pictureBox4->TabIndex = 12;
			this->pictureBox4->TabStop = false;
			// 
			// label1
			// 
			this->label1->AutoSize = true;
			this->label1->Font = (gcnew System::Drawing::Font(L"Microsoft Sans Serif", 14.25F, System::Drawing::FontStyle::Bold, System::Drawing::GraphicsUnit::Point, 
				static_cast<System::Byte>(0)));
			this->label1->Location = System::Drawing::Point(352, 27);
			this->label1->Name = L"label1";
			this->label1->Size = System::Drawing::Size(61, 24);
			this->label1->TabIndex = 13;
			this->label1->Text = L"North";
			// 
			// label2
			// 
			this->label2->AutoSize = true;
			this->label2->Font = (gcnew System::Drawing::Font(L"Microsoft Sans Serif", 14.25F, System::Drawing::FontStyle::Bold, System::Drawing::GraphicsUnit::Point, 
				static_cast<System::Byte>(0)));
			this->label2->Location = System::Drawing::Point(351, 562);
			this->label2->Name = L"label2";
			this->label2->Size = System::Drawing::Size(64, 24);
			this->label2->TabIndex = 19;
			this->label2->Text = L"South";
			// 
			// pictureBox5
			// 
			this->pictureBox5->Image = (cli::safe_cast<System::Drawing::Image^  >(resources->GetObject(L"pictureBox5.Image")));
			this->pictureBox5->Location = System::Drawing::Point(478, 530);
			this->pictureBox5->Name = L"pictureBox5";
			this->pictureBox5->Size = System::Drawing::Size(26, 26);
			this->pictureBox5->TabIndex = 18;
			this->pictureBox5->TabStop = false;
			// 
			// pictureBox6
			// 
			this->pictureBox6->Image = (cli::safe_cast<System::Drawing::Image^  >(resources->GetObject(L"pictureBox6.Image")));
			this->pictureBox6->Location = System::Drawing::Point(478, 498);
			this->pictureBox6->Name = L"pictureBox6";
			this->pictureBox6->Size = System::Drawing::Size(26, 26);
			this->pictureBox6->TabIndex = 17;
			this->pictureBox6->TabStop = false;
			// 
			// pictureBox7
			// 
			this->pictureBox7->Image = (cli::safe_cast<System::Drawing::Image^  >(resources->GetObject(L"pictureBox7.Image")));
			this->pictureBox7->Location = System::Drawing::Point(478, 466);
			this->pictureBox7->Name = L"pictureBox7";
			this->pictureBox7->Size = System::Drawing::Size(26, 26);
			this->pictureBox7->TabIndex = 16;
			this->pictureBox7->TabStop = false;
			// 
			// pictureBox8
			// 
			this->pictureBox8->Image = (cli::safe_cast<System::Drawing::Image^  >(resources->GetObject(L"pictureBox8.Image")));
			this->pictureBox8->Location = System::Drawing::Point(478, 434);
			this->pictureBox8->Name = L"pictureBox8";
			this->pictureBox8->Size = System::Drawing::Size(26, 26);
			this->pictureBox8->TabIndex = 15;
			this->pictureBox8->TabStop = false;
			// 
			// tbxPlayerS
			// 
			this->tbxPlayerS->AccessibleName = L"tbxPlayerS";
			this->tbxPlayerS->BackColor = System::Drawing::SystemColors::GradientInactiveCaption;
			this->tbxPlayerS->Font = (gcnew System::Drawing::Font(L"Microsoft Sans Serif", 9.75F, System::Drawing::FontStyle::Bold, System::Drawing::GraphicsUnit::Point, 
				static_cast<System::Byte>(0)));
			this->tbxPlayerS->Location = System::Drawing::Point(292, 434);
			this->tbxPlayerS->Multiline = true;
			this->tbxPlayerS->Name = L"tbxPlayerS";
			this->tbxPlayerS->ReadOnly = true;
			this->tbxPlayerS->Size = System::Drawing::Size(180, 125);
			this->tbxPlayerS->TabIndex = 14;
			this->tbxPlayerS->TextAlign = System::Windows::Forms::HorizontalAlignment::Right;
			// 
			// label3
			// 
			this->label3->AutoSize = true;
			this->label3->Font = (gcnew System::Drawing::Font(L"Microsoft Sans Serif", 14.25F, System::Drawing::FontStyle::Bold, System::Drawing::GraphicsUnit::Point, 
				static_cast<System::Byte>(0)));
			this->label3->Location = System::Drawing::Point(74, 217);
			this->label3->Name = L"label3";
			this->label3->Size = System::Drawing::Size(56, 24);
			this->label3->TabIndex = 25;
			this->label3->Text = L"West";
			// 
			// pictureBox9
			// 
			this->pictureBox9->Image = (cli::safe_cast<System::Drawing::Image^  >(resources->GetObject(L"pictureBox9.Image")));
			this->pictureBox9->Location = System::Drawing::Point(198, 340);
			this->pictureBox9->Name = L"pictureBox9";
			this->pictureBox9->Size = System::Drawing::Size(26, 26);
			this->pictureBox9->TabIndex = 24;
			this->pictureBox9->TabStop = false;
			// 
			// pictureBox10
			// 
			this->pictureBox10->Image = (cli::safe_cast<System::Drawing::Image^  >(resources->GetObject(L"pictureBox10.Image")));
			this->pictureBox10->Location = System::Drawing::Point(198, 308);
			this->pictureBox10->Name = L"pictureBox10";
			this->pictureBox10->Size = System::Drawing::Size(26, 26);
			this->pictureBox10->TabIndex = 23;
			this->pictureBox10->TabStop = false;
			// 
			// pictureBox11
			// 
			this->pictureBox11->Image = (cli::safe_cast<System::Drawing::Image^  >(resources->GetObject(L"pictureBox11.Image")));
			this->pictureBox11->Location = System::Drawing::Point(198, 276);
			this->pictureBox11->Name = L"pictureBox11";
			this->pictureBox11->Size = System::Drawing::Size(26, 26);
			this->pictureBox11->TabIndex = 22;
			this->pictureBox11->TabStop = false;
			// 
			// pictureBox12
			// 
			this->pictureBox12->Image = (cli::safe_cast<System::Drawing::Image^  >(resources->GetObject(L"pictureBox12.Image")));
			this->pictureBox12->Location = System::Drawing::Point(198, 244);
			this->pictureBox12->Name = L"pictureBox12";
			this->pictureBox12->Size = System::Drawing::Size(26, 26);
			this->pictureBox12->TabIndex = 21;
			this->pictureBox12->TabStop = false;
			// 
			// tbxPlayerW
			// 
			this->tbxPlayerW->AccessibleName = L"tbxPlayerW";
			this->tbxPlayerW->BackColor = System::Drawing::SystemColors::GradientInactiveCaption;
			this->tbxPlayerW->Font = (gcnew System::Drawing::Font(L"Microsoft Sans Serif", 9.75F, System::Drawing::FontStyle::Bold, System::Drawing::GraphicsUnit::Point, 
				static_cast<System::Byte>(0)));
			this->tbxPlayerW->Location = System::Drawing::Point(12, 244);
			this->tbxPlayerW->Multiline = true;
			this->tbxPlayerW->Name = L"tbxPlayerW";
			this->tbxPlayerW->ReadOnly = true;
			this->tbxPlayerW->Size = System::Drawing::Size(180, 125);
			this->tbxPlayerW->TabIndex = 20;
			this->tbxPlayerW->TextAlign = System::Windows::Forms::HorizontalAlignment::Right;
			// 
			// label4
			// 
			this->label4->AutoSize = true;
			this->label4->Font = (gcnew System::Drawing::Font(L"Microsoft Sans Serif", 14.25F, System::Drawing::FontStyle::Bold, System::Drawing::GraphicsUnit::Point, 
				static_cast<System::Byte>(0)));
			this->label4->Location = System::Drawing::Point(636, 214);
			this->label4->Name = L"label4";
			this->label4->Size = System::Drawing::Size(50, 24);
			this->label4->TabIndex = 31;
			this->label4->Text = L"East";
			// 
			// pictureBox13
			// 
			this->pictureBox13->Image = (cli::safe_cast<System::Drawing::Image^  >(resources->GetObject(L"pictureBox13.Image")));
			this->pictureBox13->Location = System::Drawing::Point(757, 337);
			this->pictureBox13->Name = L"pictureBox13";
			this->pictureBox13->Size = System::Drawing::Size(26, 26);
			this->pictureBox13->TabIndex = 30;
			this->pictureBox13->TabStop = false;
			// 
			// pictureBox14
			// 
			this->pictureBox14->Image = (cli::safe_cast<System::Drawing::Image^  >(resources->GetObject(L"pictureBox14.Image")));
			this->pictureBox14->Location = System::Drawing::Point(757, 305);
			this->pictureBox14->Name = L"pictureBox14";
			this->pictureBox14->Size = System::Drawing::Size(26, 26);
			this->pictureBox14->TabIndex = 29;
			this->pictureBox14->TabStop = false;
			// 
			// pictureBox15
			// 
			this->pictureBox15->Image = (cli::safe_cast<System::Drawing::Image^  >(resources->GetObject(L"pictureBox15.Image")));
			this->pictureBox15->Location = System::Drawing::Point(757, 273);
			this->pictureBox15->Name = L"pictureBox15";
			this->pictureBox15->Size = System::Drawing::Size(26, 26);
			this->pictureBox15->TabIndex = 28;
			this->pictureBox15->TabStop = false;
			// 
			// pictureBox16
			// 
			this->pictureBox16->Image = (cli::safe_cast<System::Drawing::Image^  >(resources->GetObject(L"pictureBox16.Image")));
			this->pictureBox16->Location = System::Drawing::Point(757, 241);
			this->pictureBox16->Name = L"pictureBox16";
			this->pictureBox16->Size = System::Drawing::Size(26, 26);
			this->pictureBox16->TabIndex = 27;
			this->pictureBox16->TabStop = false;
			// 
			// tbxPlayerE
			// 
			this->tbxPlayerE->AccessibleName = L"tbxPlayerE";
			this->tbxPlayerE->BackColor = System::Drawing::SystemColors::GradientInactiveCaption;
			this->tbxPlayerE->Font = (gcnew System::Drawing::Font(L"Microsoft Sans Serif", 9.75F, System::Drawing::FontStyle::Bold, System::Drawing::GraphicsUnit::Point, 
				static_cast<System::Byte>(0)));
			this->tbxPlayerE->Location = System::Drawing::Point(571, 241);
			this->tbxPlayerE->Multiline = true;
			this->tbxPlayerE->Name = L"tbxPlayerE";
			this->tbxPlayerE->ReadOnly = true;
			this->tbxPlayerE->Size = System::Drawing::Size(180, 125);
			this->tbxPlayerE->TabIndex = 26;
			this->tbxPlayerE->TextAlign = System::Windows::Forms::HorizontalAlignment::Right;
			// 
			// label5
			// 
			this->label5->AutoSize = true;
			this->label5->Location = System::Drawing::Point(683, 24);
			this->label5->Name = L"label5";
			this->label5->Size = System::Drawing::Size(100, 13);
			this->label5->TabIndex = 34;
			this->label5->Text = L"DO_NOT_DELETE";
			this->label5->Visible = false;
			// 
			// bidBoxN
			// 
			this->bidBoxN->Location = System::Drawing::Point(291, 202);
			this->bidBoxN->Multiline = true;
			this->bidBoxN->Name = L"bidBoxN";
			this->bidBoxN->ReadOnly = true;
			this->bidBoxN->Size = System::Drawing::Size(49, 215);
			this->bidBoxN->TabIndex = 35;
			// 
			// label6
			// 
			this->label6->AutoSize = true;
			this->label6->Location = System::Drawing::Point(288, 186);
			this->label6->Name = L"label6";
			this->label6->Size = System::Drawing::Size(15, 13);
			this->label6->TabIndex = 36;
			this->label6->Text = L"N";
			// 
			// bidBoxE
			// 
			this->bidBoxE->Location = System::Drawing::Point(346, 202);
			this->bidBoxE->Multiline = true;
			this->bidBoxE->Name = L"bidBoxE";
			this->bidBoxE->ReadOnly = true;
			this->bidBoxE->Size = System::Drawing::Size(49, 215);
			this->bidBoxE->TabIndex = 35;
			// 
			// label7
			// 
			this->label7->AutoSize = true;
			this->label7->Location = System::Drawing::Point(343, 186);
			this->label7->Name = L"label7";
			this->label7->Size = System::Drawing::Size(14, 13);
			this->label7->TabIndex = 36;
			this->label7->Text = L"E";
			// 
			// bidBoxS
			// 
			this->bidBoxS->Location = System::Drawing::Point(401, 202);
			this->bidBoxS->Multiline = true;
			this->bidBoxS->Name = L"bidBoxS";
			this->bidBoxS->ReadOnly = true;
			this->bidBoxS->Size = System::Drawing::Size(49, 215);
			this->bidBoxS->TabIndex = 35;
			// 
			// label8
			// 
			this->label8->AutoSize = true;
			this->label8->Location = System::Drawing::Point(398, 186);
			this->label8->Name = L"label8";
			this->label8->Size = System::Drawing::Size(14, 13);
			this->label8->TabIndex = 36;
			this->label8->Text = L"S";
			// 
			// bidBoxW
			// 
			this->bidBoxW->Location = System::Drawing::Point(456, 202);
			this->bidBoxW->Multiline = true;
			this->bidBoxW->Name = L"bidBoxW";
			this->bidBoxW->ReadOnly = true;
			this->bidBoxW->Size = System::Drawing::Size(49, 215);
			this->bidBoxW->TabIndex = 35;
			// 
			// label9
			// 
			this->label9->AutoSize = true;
			this->label9->Location = System::Drawing::Point(453, 186);
			this->label9->Name = L"label9";
			this->label9->Size = System::Drawing::Size(18, 13);
			this->label9->TabIndex = 36;
			this->label9->Text = L"W";
			// 
			// MyForm
			// 
			this->AutoScaleDimensions = System::Drawing::SizeF(6, 13);
			this->AutoScaleMode = System::Windows::Forms::AutoScaleMode::Font;
			this->ClientSize = System::Drawing::Size(794, 591);
			this->Controls->Add(this->label9);
			this->Controls->Add(this->label8);
			this->Controls->Add(this->label7);
			this->Controls->Add(this->label6);
			this->Controls->Add(this->bidBoxW);
			this->Controls->Add(this->bidBoxS);
			this->Controls->Add(this->bidBoxE);
			this->Controls->Add(this->bidBoxN);
			this->Controls->Add(this->label5);
			this->Controls->Add(this->label4);
			this->Controls->Add(this->pictureBox13);
			this->Controls->Add(this->pictureBox14);
			this->Controls->Add(this->pictureBox15);
			this->Controls->Add(this->pictureBox16);
			this->Controls->Add(this->tbxPlayerE);
			this->Controls->Add(this->label3);
			this->Controls->Add(this->pictureBox9);
			this->Controls->Add(this->pictureBox10);
			this->Controls->Add(this->pictureBox11);
			this->Controls->Add(this->pictureBox12);
			this->Controls->Add(this->tbxPlayerW);
			this->Controls->Add(this->label2);
			this->Controls->Add(this->pictureBox5);
			this->Controls->Add(this->pictureBox6);
			this->Controls->Add(this->pictureBox7);
			this->Controls->Add(this->pictureBox8);
			this->Controls->Add(this->tbxPlayerS);
			this->Controls->Add(this->label1);
			this->Controls->Add(this->pictureBox4);
			this->Controls->Add(this->pictureBox3);
			this->Controls->Add(this->pictureBox2);
			this->Controls->Add(this->pictureBox1);
			this->Controls->Add(this->btnDisplay);
			this->Controls->Add(this->tbxPlayerN);
			this->Controls->Add(this->menuStrip1);
			this->MainMenuStrip = this->menuStrip1;
			this->Name = L"MyForm";
			this->Text = L"MyForm";
			this->menuStrip1->ResumeLayout(false);
			this->menuStrip1->PerformLayout();
			(cli::safe_cast<System::ComponentModel::ISupportInitialize^  >(this->pictureBox1))->EndInit();
			(cli::safe_cast<System::ComponentModel::ISupportInitialize^  >(this->pictureBox2))->EndInit();
			(cli::safe_cast<System::ComponentModel::ISupportInitialize^  >(this->pictureBox3))->EndInit();
			(cli::safe_cast<System::ComponentModel::ISupportInitialize^  >(this->pictureBox4))->EndInit();
			(cli::safe_cast<System::ComponentModel::ISupportInitialize^  >(this->pictureBox5))->EndInit();
			(cli::safe_cast<System::ComponentModel::ISupportInitialize^  >(this->pictureBox6))->EndInit();
			(cli::safe_cast<System::ComponentModel::ISupportInitialize^  >(this->pictureBox7))->EndInit();
			(cli::safe_cast<System::ComponentModel::ISupportInitialize^  >(this->pictureBox8))->EndInit();
			(cli::safe_cast<System::ComponentModel::ISupportInitialize^  >(this->pictureBox9))->EndInit();
			(cli::safe_cast<System::ComponentModel::ISupportInitialize^  >(this->pictureBox10))->EndInit();
			(cli::safe_cast<System::ComponentModel::ISupportInitialize^  >(this->pictureBox11))->EndInit();
			(cli::safe_cast<System::ComponentModel::ISupportInitialize^  >(this->pictureBox12))->EndInit();
			(cli::safe_cast<System::ComponentModel::ISupportInitialize^  >(this->pictureBox13))->EndInit();
			(cli::safe_cast<System::ComponentModel::ISupportInitialize^  >(this->pictureBox14))->EndInit();
			(cli::safe_cast<System::ComponentModel::ISupportInitialize^  >(this->pictureBox15))->EndInit();
			(cli::safe_cast<System::ComponentModel::ISupportInitialize^  >(this->pictureBox16))->EndInit();
			this->ResumeLayout(false);
			this->PerformLayout();

		}
#pragma endregion
private: 

	void InitGame(void) {
		clips->cards->ResetCards();
		Reset();
		clips->ResetBidCounter();
		bidBoxN->Clear();
		bidBoxE->Clear();
		bidBoxS->Clear();
		bidBoxW->Clear();
		if (++dealMark>3) {
			dealMark=0;
		}
		currentBidder=dealMark-1;
		if (currentBidder<0) {
			currentBidder=3;
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

		Run(-1);
	}



	void DisplayCards(void) {
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
	


	void AssertCards(void) {
		char buffer[80];
		eCard **pCards=clips->cards->GetCards(static_cast<ePlayer>(clips->ourPlayer));
		for (int i=0;i<4;++i) {
			for (int j=0;j<14;++j) {
				if (pCards[i][j]!=empty) {
					sprintf_s(buffer,"(card (suit %s)(name %s)",mCard2clp[pCards[i][j]],mSuit2clp[static_cast<eSuit>(i)]);
					AssertString(buffer);
				}
				else {
					break;
				}
			}
		}
	}


	System::Void button1_Click(System::Object^  sender, System::EventArgs^  e) {
		const std::string playersStr[4]={"N)","E)","S)","W)"};
		const char players[4]={'N','E','S','W'};
		
		InitGame();
		// trzeba zrobić coś, co powpisuje karty do cards[][]
		clips->cards->ReadCardsFromFile("3C3D_16pc.txt");

		DisplayCards();

		//AssertCards();

		/*if (players[currentBidder]==clips->ourPlayer) {
			char buffer[15];
			sprintf_s(buffer,"(player %c)",clips->ourPlayer);
			AssertString(buffer);
			R
		}*/
		ShowDefglobals("stdout",NULL);
		clips->PrintFacts();

		while (clips->Bidding()) {
			if (players[currentBidder]==clips->ourPlayer) {
				AssertString("(bidding our-player-should-bid)");
				clips->RetractFactByName("(bidding made-a-bid)");
				Run(-1);
		ShowDefglobals("stdout",NULL);
		clips->PrintFacts();
				clips->IncrementBidCounter();
				String^ StrVal=gcnew String(clips->FindLastBid().c_str());
				bidBoxN->Text+=StrVal;
				bidBoxN->Text+="\r\n";
				if (++currentBidder>3) {
					currentBidder=0;
				}
			}
			else {
				DialogBox ^wnd = gcnew DialogBox(label5);
				
				wnd->ShowDialog();
				String^ StrVal=gcnew String(label5->Text);
				if (currentBidder==0) {
					bidBoxN->Text+=StrVal;
					bidBoxN->Text+="\r\n";
				}
				else if (currentBidder==1) {
					bidBoxE->Text+=StrVal;
					bidBoxE->Text+="\r\n";
				}
				else if (currentBidder==2) {
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
				clips->PlayerBids(charBid, players[currentBidder]);
				if (++currentBidder>3) {
					currentBidder=0;
				}
				System::Runtime::InteropServices::Marshal::FreeHGlobal(System::IntPtr((void*)charBid));
				//clips->PrintFacts();
			} // else
		} // while (clips->Bidding())
		ShowDefglobals("stdout",NULL);
		clips->PrintFacts();
	} // button1_Click
};

} // namespace vcpp