#include "MyForm.h"

using namespace System;
using namespace System::Windows::Forms;

[STAThread]
int main(array<String^>^ argv) {
    Application::EnableVisualStyles();
    Application::SetCompatibleTextRenderingDefault(false);

    vcpp::MyForm form;
    Application::Run(%form);
	return 0;
}
