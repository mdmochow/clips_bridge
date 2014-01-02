#pragma once
#include <string>

namespace vcpp {

	using namespace System;
	using namespace System::ComponentModel;
	using namespace System::Collections;
	using namespace System::Windows::Forms;
	using namespace System::Data;
	using namespace System::Drawing;

	/// <summary>
	/// Summary for DialogBox
	/// </summary>
	public ref class DialogBox : public System::Windows::Forms::Form
	{
	public:
		DialogBox(System::Windows::Forms::Label ^lab)
		{
			InitializeComponent();
			bid=gcnew String("PASS");
			_lab=lab;
			//
			//TODO: Add the constructor code here
			//
		}

	protected:
		/// <summary>
		/// Clean up any resources being used.
		/// </summary>
		~DialogBox()
		{
			if (components)
			{
				delete components;
			}
		}
	private: System::Windows::Forms::RadioButton^  radioButton1;
	private: System::Windows::Forms::RadioButton^  radioButton2;
	private: System::Windows::Forms::RadioButton^  radioButton3;
	private: System::Windows::Forms::RadioButton^  radioButton4;
	private: System::Windows::Forms::RadioButton^  radioButton5;
	private: System::Windows::Forms::RadioButton^  radioButton36;
	private: System::Windows::Forms::RadioButton^  radioButton37;
	private: System::Windows::Forms::RadioButton^  radioButton38;
	private: System::Windows::Forms::Button^  button1;
	private: System::Windows::Forms::RadioButton^  radioButton6;
	private: System::Windows::Forms::RadioButton^  radioButton7;
	private: System::Windows::Forms::RadioButton^  radioButton8;
	private: System::Windows::Forms::RadioButton^  radioButton9;
	private: System::Windows::Forms::RadioButton^  radioButton10;
	private: System::Windows::Forms::RadioButton^  radioButton11;
	private: System::Windows::Forms::RadioButton^  radioButton12;
	private: System::Windows::Forms::RadioButton^  radioButton13;
	private: System::Windows::Forms::RadioButton^  radioButton14;
	private: System::Windows::Forms::RadioButton^  radioButton15;
	private: System::Windows::Forms::RadioButton^  radioButton16;
	private: System::Windows::Forms::RadioButton^  radioButton17;
	private: System::Windows::Forms::RadioButton^  radioButton18;
	private: System::Windows::Forms::RadioButton^  radioButton19;
	private: System::Windows::Forms::RadioButton^  radioButton20;
	private: System::Windows::Forms::RadioButton^  radioButton21;
	private: System::Windows::Forms::RadioButton^  radioButton22;
	private: System::Windows::Forms::RadioButton^  radioButton23;
	private: System::Windows::Forms::RadioButton^  radioButton24;
	private: System::Windows::Forms::RadioButton^  radioButton25;
	private: System::Windows::Forms::RadioButton^  radioButton26;
	private: System::Windows::Forms::RadioButton^  radioButton27;
	private: System::Windows::Forms::RadioButton^  radioButton28;
	private: System::Windows::Forms::RadioButton^  radioButton29;
	private: System::Windows::Forms::RadioButton^  radioButton30;
	private: System::Windows::Forms::RadioButton^  radioButton31;
	private: System::Windows::Forms::RadioButton^  radioButton32;
	private: System::Windows::Forms::RadioButton^  radioButton33;
	private: System::Windows::Forms::RadioButton^  radioButton34;
	private: System::Windows::Forms::RadioButton^  radioButton35;
	protected: 

	private:
		/// <summary>
		/// Required designer variable.
		/// </summary>
		System::ComponentModel::Container ^components;
		String ^bid;
		System::Windows::Forms::Label ^_lab;

#pragma region Windows Form Designer generated code
		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		void InitializeComponent(void)
		{
			this->radioButton1 = (gcnew System::Windows::Forms::RadioButton());
			this->radioButton2 = (gcnew System::Windows::Forms::RadioButton());
			this->radioButton3 = (gcnew System::Windows::Forms::RadioButton());
			this->radioButton4 = (gcnew System::Windows::Forms::RadioButton());
			this->radioButton5 = (gcnew System::Windows::Forms::RadioButton());
			this->radioButton36 = (gcnew System::Windows::Forms::RadioButton());
			this->radioButton37 = (gcnew System::Windows::Forms::RadioButton());
			this->radioButton38 = (gcnew System::Windows::Forms::RadioButton());
			this->button1 = (gcnew System::Windows::Forms::Button());
			this->radioButton6 = (gcnew System::Windows::Forms::RadioButton());
			this->radioButton7 = (gcnew System::Windows::Forms::RadioButton());
			this->radioButton8 = (gcnew System::Windows::Forms::RadioButton());
			this->radioButton9 = (gcnew System::Windows::Forms::RadioButton());
			this->radioButton10 = (gcnew System::Windows::Forms::RadioButton());
			this->radioButton11 = (gcnew System::Windows::Forms::RadioButton());
			this->radioButton12 = (gcnew System::Windows::Forms::RadioButton());
			this->radioButton13 = (gcnew System::Windows::Forms::RadioButton());
			this->radioButton14 = (gcnew System::Windows::Forms::RadioButton());
			this->radioButton15 = (gcnew System::Windows::Forms::RadioButton());
			this->radioButton16 = (gcnew System::Windows::Forms::RadioButton());
			this->radioButton17 = (gcnew System::Windows::Forms::RadioButton());
			this->radioButton18 = (gcnew System::Windows::Forms::RadioButton());
			this->radioButton19 = (gcnew System::Windows::Forms::RadioButton());
			this->radioButton20 = (gcnew System::Windows::Forms::RadioButton());
			this->radioButton21 = (gcnew System::Windows::Forms::RadioButton());
			this->radioButton22 = (gcnew System::Windows::Forms::RadioButton());
			this->radioButton23 = (gcnew System::Windows::Forms::RadioButton());
			this->radioButton24 = (gcnew System::Windows::Forms::RadioButton());
			this->radioButton25 = (gcnew System::Windows::Forms::RadioButton());
			this->radioButton26 = (gcnew System::Windows::Forms::RadioButton());
			this->radioButton27 = (gcnew System::Windows::Forms::RadioButton());
			this->radioButton28 = (gcnew System::Windows::Forms::RadioButton());
			this->radioButton29 = (gcnew System::Windows::Forms::RadioButton());
			this->radioButton30 = (gcnew System::Windows::Forms::RadioButton());
			this->radioButton31 = (gcnew System::Windows::Forms::RadioButton());
			this->radioButton32 = (gcnew System::Windows::Forms::RadioButton());
			this->radioButton33 = (gcnew System::Windows::Forms::RadioButton());
			this->radioButton34 = (gcnew System::Windows::Forms::RadioButton());
			this->radioButton35 = (gcnew System::Windows::Forms::RadioButton());
			this->SuspendLayout();
			// 
			// radioButton1
			// 
			this->radioButton1->AutoSize = true;
			this->radioButton1->Location = System::Drawing::Point(12, 12);
			this->radioButton1->Name = L"radioButton1";
			this->radioButton1->Size = System::Drawing::Size(38, 17);
			this->radioButton1->TabIndex = 0;
			this->radioButton1->Text = L"1C";
			this->radioButton1->UseVisualStyleBackColor = true;
			this->radioButton1->CheckedChanged += gcnew System::EventHandler(this, &DialogBox::radioButton1_CheckedChanged);
			// 
			// radioButton2
			// 
			this->radioButton2->AutoSize = true;
			this->radioButton2->Location = System::Drawing::Point(64, 12);
			this->radioButton2->Name = L"radioButton2";
			this->radioButton2->Size = System::Drawing::Size(39, 17);
			this->radioButton2->TabIndex = 0;
			this->radioButton2->Text = L"1D";
			this->radioButton2->UseVisualStyleBackColor = true;
			this->radioButton2->CheckedChanged += gcnew System::EventHandler(this, &DialogBox::radioButton2_CheckedChanged);
			// 
			// radioButton3
			// 
			this->radioButton3->AutoSize = true;
			this->radioButton3->Location = System::Drawing::Point(117, 12);
			this->radioButton3->Name = L"radioButton3";
			this->radioButton3->Size = System::Drawing::Size(39, 17);
			this->radioButton3->TabIndex = 0;
			this->radioButton3->Text = L"1H";
			this->radioButton3->UseVisualStyleBackColor = true;
			this->radioButton3->CheckedChanged += gcnew System::EventHandler(this, &DialogBox::radioButton3_CheckedChanged);
			// 
			// radioButton4
			// 
			this->radioButton4->AutoSize = true;
			this->radioButton4->Location = System::Drawing::Point(170, 12);
			this->radioButton4->Name = L"radioButton4";
			this->radioButton4->Size = System::Drawing::Size(38, 17);
			this->radioButton4->TabIndex = 0;
			this->radioButton4->Text = L"1S";
			this->radioButton4->UseVisualStyleBackColor = true;
			this->radioButton4->CheckedChanged += gcnew System::EventHandler(this, &DialogBox::radioButton4_CheckedChanged);
			// 
			// radioButton5
			// 
			this->radioButton5->AutoSize = true;
			this->radioButton5->Location = System::Drawing::Point(222, 12);
			this->radioButton5->Name = L"radioButton5";
			this->radioButton5->Size = System::Drawing::Size(46, 17);
			this->radioButton5->TabIndex = 0;
			this->radioButton5->Text = L"1NT";
			this->radioButton5->UseVisualStyleBackColor = true;
			this->radioButton5->CheckedChanged += gcnew System::EventHandler(this, &DialogBox::radioButton5_CheckedChanged);
			// 
			// radioButton36
			// 
			this->radioButton36->AutoSize = true;
			this->radioButton36->Checked = true;
			this->radioButton36->Location = System::Drawing::Point(12, 173);
			this->radioButton36->Name = L"radioButton36";
			this->radioButton36->Size = System::Drawing::Size(53, 17);
			this->radioButton36->TabIndex = 0;
			this->radioButton36->TabStop = true;
			this->radioButton36->Text = L"PASS";
			this->radioButton36->UseVisualStyleBackColor = true;
			this->radioButton36->CheckedChanged += gcnew System::EventHandler(this, &DialogBox::radioButton36_CheckedChanged);
			// 
			// radioButton37
			// 
			this->radioButton37->AutoSize = true;
			this->radioButton37->Location = System::Drawing::Point(90, 173);
			this->radioButton37->Name = L"radioButton37";
			this->radioButton37->Size = System::Drawing::Size(69, 17);
			this->radioButton37->TabIndex = 0;
			this->radioButton37->Text = L"DOUBLE";
			this->radioButton37->UseVisualStyleBackColor = true;
			this->radioButton37->CheckedChanged += gcnew System::EventHandler(this, &DialogBox::radioButton37_CheckedChanged);
			// 
			// radioButton38
			// 
			this->radioButton38->AutoSize = true;
			this->radioButton38->Location = System::Drawing::Point(184, 173);
			this->radioButton38->Name = L"radioButton38";
			this->radioButton38->Size = System::Drawing::Size(84, 17);
			this->radioButton38->TabIndex = 0;
			this->radioButton38->Text = L"REDOUBLE";
			this->radioButton38->UseVisualStyleBackColor = true;
			this->radioButton38->CheckedChanged += gcnew System::EventHandler(this, &DialogBox::radioButton38_CheckedChanged);
			// 
			// button1
			// 
			this->button1->Location = System::Drawing::Point(103, 207);
			this->button1->Name = L"button1";
			this->button1->Size = System::Drawing::Size(75, 23);
			this->button1->TabIndex = 1;
			this->button1->Text = L"Submit";
			this->button1->UseVisualStyleBackColor = true;
			this->button1->Click += gcnew System::EventHandler(this, &DialogBox::button1_Click);
			// 
			// radioButton6
			// 
			this->radioButton6->AutoSize = true;
			this->radioButton6->Location = System::Drawing::Point(12, 35);
			this->radioButton6->Name = L"radioButton6";
			this->radioButton6->Size = System::Drawing::Size(38, 17);
			this->radioButton6->TabIndex = 0;
			this->radioButton6->Text = L"2C";
			this->radioButton6->UseVisualStyleBackColor = true;
			this->radioButton6->CheckedChanged += gcnew System::EventHandler(this, &DialogBox::radioButton6_CheckedChanged);
			// 
			// radioButton7
			// 
			this->radioButton7->AutoSize = true;
			this->radioButton7->Location = System::Drawing::Point(64, 35);
			this->radioButton7->Name = L"radioButton7";
			this->radioButton7->Size = System::Drawing::Size(39, 17);
			this->radioButton7->TabIndex = 0;
			this->radioButton7->Text = L"2D";
			this->radioButton7->UseVisualStyleBackColor = true;
			this->radioButton7->CheckedChanged += gcnew System::EventHandler(this, &DialogBox::radioButton7_CheckedChanged_1);
			// 
			// radioButton8
			// 
			this->radioButton8->AutoSize = true;
			this->radioButton8->Location = System::Drawing::Point(117, 35);
			this->radioButton8->Name = L"radioButton8";
			this->radioButton8->Size = System::Drawing::Size(39, 17);
			this->radioButton8->TabIndex = 0;
			this->radioButton8->Text = L"2H";
			this->radioButton8->UseVisualStyleBackColor = true;
			this->radioButton8->CheckedChanged += gcnew System::EventHandler(this, &DialogBox::radioButton8_CheckedChanged_1);
			// 
			// radioButton9
			// 
			this->radioButton9->AutoSize = true;
			this->radioButton9->Location = System::Drawing::Point(170, 35);
			this->radioButton9->Name = L"radioButton9";
			this->radioButton9->Size = System::Drawing::Size(38, 17);
			this->radioButton9->TabIndex = 0;
			this->radioButton9->Text = L"2S";
			this->radioButton9->UseVisualStyleBackColor = true;
			this->radioButton9->CheckedChanged += gcnew System::EventHandler(this, &DialogBox::radioButton9_CheckedChanged_1);
			// 
			// radioButton10
			// 
			this->radioButton10->AutoSize = true;
			this->radioButton10->Location = System::Drawing::Point(222, 35);
			this->radioButton10->Name = L"radioButton10";
			this->radioButton10->Size = System::Drawing::Size(46, 17);
			this->radioButton10->TabIndex = 0;
			this->radioButton10->Text = L"2NT";
			this->radioButton10->UseVisualStyleBackColor = true;
			this->radioButton10->CheckedChanged += gcnew System::EventHandler(this, &DialogBox::radioButton10_CheckedChanged);
			// 
			// radioButton11
			// 
			this->radioButton11->AutoSize = true;
			this->radioButton11->Location = System::Drawing::Point(12, 58);
			this->radioButton11->Name = L"radioButton11";
			this->radioButton11->Size = System::Drawing::Size(38, 17);
			this->radioButton11->TabIndex = 0;
			this->radioButton11->Text = L"3C";
			this->radioButton11->UseVisualStyleBackColor = true;
			this->radioButton11->CheckedChanged += gcnew System::EventHandler(this, &DialogBox::radioButton11_CheckedChanged);
			// 
			// radioButton12
			// 
			this->radioButton12->AutoSize = true;
			this->radioButton12->Location = System::Drawing::Point(64, 58);
			this->radioButton12->Name = L"radioButton12";
			this->radioButton12->Size = System::Drawing::Size(39, 17);
			this->radioButton12->TabIndex = 0;
			this->radioButton12->Text = L"3D";
			this->radioButton12->UseVisualStyleBackColor = true;
			this->radioButton12->CheckedChanged += gcnew System::EventHandler(this, &DialogBox::radioButton12_CheckedChanged_1);
			// 
			// radioButton13
			// 
			this->radioButton13->AutoSize = true;
			this->radioButton13->Location = System::Drawing::Point(117, 58);
			this->radioButton13->Name = L"radioButton13";
			this->radioButton13->Size = System::Drawing::Size(39, 17);
			this->radioButton13->TabIndex = 0;
			this->radioButton13->Text = L"3H";
			this->radioButton13->UseVisualStyleBackColor = true;
			this->radioButton13->CheckedChanged += gcnew System::EventHandler(this, &DialogBox::radioButton13_CheckedChanged_1);
			// 
			// radioButton14
			// 
			this->radioButton14->AutoSize = true;
			this->radioButton14->Location = System::Drawing::Point(170, 58);
			this->radioButton14->Name = L"radioButton14";
			this->radioButton14->Size = System::Drawing::Size(38, 17);
			this->radioButton14->TabIndex = 0;
			this->radioButton14->Text = L"3S";
			this->radioButton14->UseVisualStyleBackColor = true;
			this->radioButton14->CheckedChanged += gcnew System::EventHandler(this, &DialogBox::radioButton14_CheckedChanged_1);
			// 
			// radioButton15
			// 
			this->radioButton15->AutoSize = true;
			this->radioButton15->Location = System::Drawing::Point(222, 58);
			this->radioButton15->Name = L"radioButton15";
			this->radioButton15->Size = System::Drawing::Size(46, 17);
			this->radioButton15->TabIndex = 0;
			this->radioButton15->Text = L"3NT";
			this->radioButton15->UseVisualStyleBackColor = true;
			this->radioButton15->CheckedChanged += gcnew System::EventHandler(this, &DialogBox::radioButton15_CheckedChanged);
			// 
			// radioButton16
			// 
			this->radioButton16->AutoSize = true;
			this->radioButton16->Location = System::Drawing::Point(12, 81);
			this->radioButton16->Name = L"radioButton16";
			this->radioButton16->Size = System::Drawing::Size(38, 17);
			this->radioButton16->TabIndex = 0;
			this->radioButton16->Text = L"4C";
			this->radioButton16->UseVisualStyleBackColor = true;
			this->radioButton16->CheckedChanged += gcnew System::EventHandler(this, &DialogBox::radioButton16_CheckedChanged_1);
			// 
			// radioButton17
			// 
			this->radioButton17->AutoSize = true;
			this->radioButton17->Location = System::Drawing::Point(64, 81);
			this->radioButton17->Name = L"radioButton17";
			this->radioButton17->Size = System::Drawing::Size(39, 17);
			this->radioButton17->TabIndex = 0;
			this->radioButton17->Text = L"4D";
			this->radioButton17->UseVisualStyleBackColor = true;
			this->radioButton17->CheckedChanged += gcnew System::EventHandler(this, &DialogBox::radioButton17_CheckedChanged_1);
			// 
			// radioButton18
			// 
			this->radioButton18->AutoSize = true;
			this->radioButton18->Location = System::Drawing::Point(117, 81);
			this->radioButton18->Name = L"radioButton18";
			this->radioButton18->Size = System::Drawing::Size(39, 17);
			this->radioButton18->TabIndex = 0;
			this->radioButton18->Text = L"4H";
			this->radioButton18->UseVisualStyleBackColor = true;
			this->radioButton18->CheckedChanged += gcnew System::EventHandler(this, &DialogBox::radioButton18_CheckedChanged);
			// 
			// radioButton19
			// 
			this->radioButton19->AutoSize = true;
			this->radioButton19->Location = System::Drawing::Point(170, 81);
			this->radioButton19->Name = L"radioButton19";
			this->radioButton19->Size = System::Drawing::Size(38, 17);
			this->radioButton19->TabIndex = 0;
			this->radioButton19->Text = L"4S";
			this->radioButton19->UseVisualStyleBackColor = true;
			this->radioButton19->CheckedChanged += gcnew System::EventHandler(this, &DialogBox::radioButton19_CheckedChanged);
			// 
			// radioButton20
			// 
			this->radioButton20->AutoSize = true;
			this->radioButton20->Location = System::Drawing::Point(222, 81);
			this->radioButton20->Name = L"radioButton20";
			this->radioButton20->Size = System::Drawing::Size(46, 17);
			this->radioButton20->TabIndex = 0;
			this->radioButton20->Text = L"4NT";
			this->radioButton20->UseVisualStyleBackColor = true;
			this->radioButton20->CheckedChanged += gcnew System::EventHandler(this, &DialogBox::radioButton20_CheckedChanged);
			// 
			// radioButton21
			// 
			this->radioButton21->AutoSize = true;
			this->radioButton21->Location = System::Drawing::Point(12, 104);
			this->radioButton21->Name = L"radioButton21";
			this->radioButton21->Size = System::Drawing::Size(38, 17);
			this->radioButton21->TabIndex = 0;
			this->radioButton21->Text = L"5C";
			this->radioButton21->UseVisualStyleBackColor = true;
			this->radioButton21->CheckedChanged += gcnew System::EventHandler(this, &DialogBox::radioButton21_CheckedChanged);
			// 
			// radioButton22
			// 
			this->radioButton22->AutoSize = true;
			this->radioButton22->Location = System::Drawing::Point(64, 104);
			this->radioButton22->Name = L"radioButton22";
			this->radioButton22->Size = System::Drawing::Size(39, 17);
			this->radioButton22->TabIndex = 0;
			this->radioButton22->Text = L"5D";
			this->radioButton22->UseVisualStyleBackColor = true;
			this->radioButton22->CheckedChanged += gcnew System::EventHandler(this, &DialogBox::radioButton22_CheckedChanged);
			// 
			// radioButton23
			// 
			this->radioButton23->AutoSize = true;
			this->radioButton23->Location = System::Drawing::Point(117, 104);
			this->radioButton23->Name = L"radioButton23";
			this->radioButton23->Size = System::Drawing::Size(39, 17);
			this->radioButton23->TabIndex = 0;
			this->radioButton23->Text = L"5H";
			this->radioButton23->UseVisualStyleBackColor = true;
			this->radioButton23->CheckedChanged += gcnew System::EventHandler(this, &DialogBox::radioButton23_CheckedChanged);
			// 
			// radioButton24
			// 
			this->radioButton24->AutoSize = true;
			this->radioButton24->Location = System::Drawing::Point(170, 104);
			this->radioButton24->Name = L"radioButton24";
			this->radioButton24->Size = System::Drawing::Size(38, 17);
			this->radioButton24->TabIndex = 0;
			this->radioButton24->Text = L"5S";
			this->radioButton24->UseVisualStyleBackColor = true;
			this->radioButton24->CheckedChanged += gcnew System::EventHandler(this, &DialogBox::radioButton24_CheckedChanged);
			// 
			// radioButton25
			// 
			this->radioButton25->AutoSize = true;
			this->radioButton25->Location = System::Drawing::Point(222, 104);
			this->radioButton25->Name = L"radioButton25";
			this->radioButton25->Size = System::Drawing::Size(46, 17);
			this->radioButton25->TabIndex = 0;
			this->radioButton25->Text = L"5NT";
			this->radioButton25->UseVisualStyleBackColor = true;
			this->radioButton25->CheckedChanged += gcnew System::EventHandler(this, &DialogBox::radioButton25_CheckedChanged);
			// 
			// radioButton26
			// 
			this->radioButton26->AutoSize = true;
			this->radioButton26->Location = System::Drawing::Point(12, 127);
			this->radioButton26->Name = L"radioButton26";
			this->radioButton26->Size = System::Drawing::Size(38, 17);
			this->radioButton26->TabIndex = 0;
			this->radioButton26->Text = L"6C";
			this->radioButton26->UseVisualStyleBackColor = true;
			this->radioButton26->CheckedChanged += gcnew System::EventHandler(this, &DialogBox::radioButton26_CheckedChanged);
			// 
			// radioButton27
			// 
			this->radioButton27->AutoSize = true;
			this->radioButton27->Location = System::Drawing::Point(64, 127);
			this->radioButton27->Name = L"radioButton27";
			this->radioButton27->Size = System::Drawing::Size(39, 17);
			this->radioButton27->TabIndex = 0;
			this->radioButton27->Text = L"6D";
			this->radioButton27->UseVisualStyleBackColor = true;
			this->radioButton27->CheckedChanged += gcnew System::EventHandler(this, &DialogBox::radioButton27_CheckedChanged);
			// 
			// radioButton28
			// 
			this->radioButton28->AutoSize = true;
			this->radioButton28->Location = System::Drawing::Point(117, 127);
			this->radioButton28->Name = L"radioButton28";
			this->radioButton28->Size = System::Drawing::Size(39, 17);
			this->radioButton28->TabIndex = 0;
			this->radioButton28->Text = L"6H";
			this->radioButton28->UseVisualStyleBackColor = true;
			this->radioButton28->CheckedChanged += gcnew System::EventHandler(this, &DialogBox::radioButton28_CheckedChanged);
			// 
			// radioButton29
			// 
			this->radioButton29->AutoSize = true;
			this->radioButton29->Location = System::Drawing::Point(170, 127);
			this->radioButton29->Name = L"radioButton29";
			this->radioButton29->Size = System::Drawing::Size(38, 17);
			this->radioButton29->TabIndex = 0;
			this->radioButton29->Text = L"6S";
			this->radioButton29->UseVisualStyleBackColor = true;
			this->radioButton29->CheckedChanged += gcnew System::EventHandler(this, &DialogBox::radioButton29_CheckedChanged);
			// 
			// radioButton30
			// 
			this->radioButton30->AutoSize = true;
			this->radioButton30->Location = System::Drawing::Point(222, 127);
			this->radioButton30->Name = L"radioButton30";
			this->radioButton30->Size = System::Drawing::Size(46, 17);
			this->radioButton30->TabIndex = 0;
			this->radioButton30->Text = L"6NT";
			this->radioButton30->UseVisualStyleBackColor = true;
			this->radioButton30->CheckedChanged += gcnew System::EventHandler(this, &DialogBox::radioButton30_CheckedChanged);
			// 
			// radioButton31
			// 
			this->radioButton31->AutoSize = true;
			this->radioButton31->Location = System::Drawing::Point(12, 150);
			this->radioButton31->Name = L"radioButton31";
			this->radioButton31->Size = System::Drawing::Size(38, 17);
			this->radioButton31->TabIndex = 0;
			this->radioButton31->Text = L"7C";
			this->radioButton31->UseVisualStyleBackColor = true;
			this->radioButton31->CheckedChanged += gcnew System::EventHandler(this, &DialogBox::radioButton31_CheckedChanged);
			// 
			// radioButton32
			// 
			this->radioButton32->AutoSize = true;
			this->radioButton32->Location = System::Drawing::Point(64, 150);
			this->radioButton32->Name = L"radioButton32";
			this->radioButton32->Size = System::Drawing::Size(39, 17);
			this->radioButton32->TabIndex = 0;
			this->radioButton32->Text = L"7D";
			this->radioButton32->UseVisualStyleBackColor = true;
			this->radioButton32->CheckedChanged += gcnew System::EventHandler(this, &DialogBox::radioButton32_CheckedChanged);
			// 
			// radioButton33
			// 
			this->radioButton33->AutoSize = true;
			this->radioButton33->Location = System::Drawing::Point(117, 150);
			this->radioButton33->Name = L"radioButton33";
			this->radioButton33->Size = System::Drawing::Size(39, 17);
			this->radioButton33->TabIndex = 0;
			this->radioButton33->Text = L"7H";
			this->radioButton33->UseVisualStyleBackColor = true;
			this->radioButton33->CheckedChanged += gcnew System::EventHandler(this, &DialogBox::radioButton33_CheckedChanged);
			// 
			// radioButton34
			// 
			this->radioButton34->AutoSize = true;
			this->radioButton34->Location = System::Drawing::Point(170, 150);
			this->radioButton34->Name = L"radioButton34";
			this->radioButton34->Size = System::Drawing::Size(38, 17);
			this->radioButton34->TabIndex = 0;
			this->radioButton34->Text = L"7S";
			this->radioButton34->UseVisualStyleBackColor = true;
			this->radioButton34->CheckedChanged += gcnew System::EventHandler(this, &DialogBox::radioButton34_CheckedChanged);
			// 
			// radioButton35
			// 
			this->radioButton35->AutoSize = true;
			this->radioButton35->Location = System::Drawing::Point(222, 150);
			this->radioButton35->Name = L"radioButton35";
			this->radioButton35->Size = System::Drawing::Size(46, 17);
			this->radioButton35->TabIndex = 0;
			this->radioButton35->Text = L"7NT";
			this->radioButton35->UseVisualStyleBackColor = true;
			this->radioButton35->CheckedChanged += gcnew System::EventHandler(this, &DialogBox::radioButton35_CheckedChanged);
			// 
			// DialogBox
			// 
			this->AutoScaleDimensions = System::Drawing::SizeF(6, 13);
			this->AutoScaleMode = System::Windows::Forms::AutoScaleMode::Font;
			this->ClientSize = System::Drawing::Size(281, 242);
			this->Controls->Add(this->button1);
			this->Controls->Add(this->radioButton35);
			this->Controls->Add(this->radioButton30);
			this->Controls->Add(this->radioButton25);
			this->Controls->Add(this->radioButton20);
			this->Controls->Add(this->radioButton15);
			this->Controls->Add(this->radioButton10);
			this->Controls->Add(this->radioButton5);
			this->Controls->Add(this->radioButton34);
			this->Controls->Add(this->radioButton29);
			this->Controls->Add(this->radioButton24);
			this->Controls->Add(this->radioButton19);
			this->Controls->Add(this->radioButton14);
			this->Controls->Add(this->radioButton9);
			this->Controls->Add(this->radioButton4);
			this->Controls->Add(this->radioButton33);
			this->Controls->Add(this->radioButton28);
			this->Controls->Add(this->radioButton23);
			this->Controls->Add(this->radioButton18);
			this->Controls->Add(this->radioButton13);
			this->Controls->Add(this->radioButton8);
			this->Controls->Add(this->radioButton3);
			this->Controls->Add(this->radioButton32);
			this->Controls->Add(this->radioButton27);
			this->Controls->Add(this->radioButton22);
			this->Controls->Add(this->radioButton17);
			this->Controls->Add(this->radioButton12);
			this->Controls->Add(this->radioButton7);
			this->Controls->Add(this->radioButton2);
			this->Controls->Add(this->radioButton38);
			this->Controls->Add(this->radioButton37);
			this->Controls->Add(this->radioButton31);
			this->Controls->Add(this->radioButton26);
			this->Controls->Add(this->radioButton21);
			this->Controls->Add(this->radioButton16);
			this->Controls->Add(this->radioButton11);
			this->Controls->Add(this->radioButton6);
			this->Controls->Add(this->radioButton36);
			this->Controls->Add(this->radioButton1);
			this->Name = L"DialogBox";
			this->Text = L"DialogBox";
			this->ResumeLayout(false);
			this->PerformLayout();

		}
#pragma endregion
private: System::Void radioButton5_CheckedChanged(System::Object^  sender, System::EventArgs^  e) {
bid="1 NT";		 }
private: System::Void radioButton1_CheckedChanged(System::Object^  sender, System::EventArgs^  e) {
			 //String^ StrVal=gcnew String(cardsSorted.c_str());
		bid="1 C";
		 }
private: System::Void radioButton2_CheckedChanged(System::Object^  sender, System::EventArgs^  e) {
		 bid="1 D";
		 }
private: System::Void radioButton3_CheckedChanged(System::Object^  sender, System::EventArgs^  e) {
			 bid="1 H";
		 }
private: System::Void radioButton4_CheckedChanged(System::Object^  sender, System::EventArgs^  e) {
			 bid="1 S";
		 }
private: System::Void radioButton6_CheckedChanged(System::Object^  sender, System::EventArgs^  e) {
			 bid="2 C";
		 }

private: System::Void radioButton10_CheckedChanged(System::Object^  sender, System::EventArgs^  e) {
			 bid="2 NT";
		 }
private: System::Void radioButton11_CheckedChanged(System::Object^  sender, System::EventArgs^  e) {
		  bid="3 C";
		 }

private: System::Void radioButton15_CheckedChanged(System::Object^  sender, System::EventArgs^  e) {
		 bid="3 NT";
		 }

private: System::Void radioButton18_CheckedChanged(System::Object^  sender, System::EventArgs^  e) {
		 bid="4 H";}
private: System::Void radioButton19_CheckedChanged(System::Object^  sender, System::EventArgs^  e) {
		 bid="4 S";}
private: System::Void radioButton20_CheckedChanged(System::Object^  sender, System::EventArgs^  e) {
		 bid="4 NT";}
private: System::Void radioButton21_CheckedChanged(System::Object^  sender, System::EventArgs^  e) {
		 bid="5 C";}
private: System::Void radioButton22_CheckedChanged(System::Object^  sender, System::EventArgs^  e) {
		 bid="5 D";}
private: System::Void radioButton23_CheckedChanged(System::Object^  sender, System::EventArgs^  e) {
		 bid="5 H";}
private: System::Void radioButton24_CheckedChanged(System::Object^  sender, System::EventArgs^  e) {
		 bid="5 S";}
private: System::Void radioButton25_CheckedChanged(System::Object^  sender, System::EventArgs^  e) {
		 bid="5 NT";}
private: System::Void radioButton26_CheckedChanged(System::Object^  sender, System::EventArgs^  e) {
		 bid="6 C";}
private: System::Void radioButton27_CheckedChanged(System::Object^  sender, System::EventArgs^  e) {
		 bid="6 D";}
private: System::Void radioButton28_CheckedChanged(System::Object^  sender, System::EventArgs^  e) {
		 bid="6 H";}
private: System::Void radioButton29_CheckedChanged(System::Object^  sender, System::EventArgs^  e) {
		 bid="6 S";}
private: System::Void radioButton30_CheckedChanged(System::Object^  sender, System::EventArgs^  e) {
		 bid="6 NT";}
private: System::Void radioButton31_CheckedChanged(System::Object^  sender, System::EventArgs^  e) {
		 bid="7 C";}
private: System::Void radioButton32_CheckedChanged(System::Object^  sender, System::EventArgs^  e) {
		 bid="7 D";}
private: System::Void radioButton33_CheckedChanged(System::Object^  sender, System::EventArgs^  e) {
		 bid="7 H";}
private: System::Void radioButton34_CheckedChanged(System::Object^  sender, System::EventArgs^  e) {
		 bid="7 S";}
private: System::Void radioButton35_CheckedChanged(System::Object^  sender, System::EventArgs^  e) {
		 bid="7 NT";}
private: System::Void radioButton36_CheckedChanged(System::Object^  sender, System::EventArgs^  e) {
		 bid="PASS";}
private: System::Void radioButton37_CheckedChanged(System::Object^  sender, System::EventArgs^  e) {
		 bid="DOUBLE";}
private: System::Void radioButton38_CheckedChanged(System::Object^  sender, System::EventArgs^  e) {
		 bid="REDOUBLE";}
private: System::Void button1_Click(System::Object^  sender, System::EventArgs^  e) {
		_lab->Text=bid;
		this->Close();
	}
private: System::Void radioButton7_CheckedChanged_1(System::Object^  sender, System::EventArgs^  e) {
			 bid="2 D";
		 }
private: System::Void radioButton8_CheckedChanged_1(System::Object^  sender, System::EventArgs^  e) {
			 bid="2 H";
		 }
private: System::Void radioButton9_CheckedChanged_1(System::Object^  sender, System::EventArgs^  e) {
			 bid="2 S";
		 }
private: System::Void radioButton12_CheckedChanged_1(System::Object^  sender, System::EventArgs^  e) {
			 bid="3 D";
		 }
private: System::Void radioButton13_CheckedChanged_1(System::Object^  sender, System::EventArgs^  e) {
			 bid="3 H";
		 }
private: System::Void radioButton14_CheckedChanged_1(System::Object^  sender, System::EventArgs^  e) {
			 bid="3 S";
		 }
private: System::Void radioButton16_CheckedChanged_1(System::Object^  sender, System::EventArgs^  e) {
			 bid="4 C";
		 }
private: System::Void radioButton17_CheckedChanged_1(System::Object^  sender, System::EventArgs^  e) {
			 bid="4 D";
		 }
};
}
