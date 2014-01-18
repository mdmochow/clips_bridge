#include "MyForm.h"
#include "clipsbridge.h"
#include "cardsontable.h"

using namespace System;
using namespace System::Windows::Forms;

[STAThread]
int main(array<String^>^ argv) {
    Application::EnableVisualStyles();
    Application::SetCompatibleTextRenderingDefault(false);

	CardsOnTable cards;
	ClipsBridge clips(&cards);

    vcpp::MyForm form(&clips);
    Application::Run(%form);
	return 0;
}
