#include "MyForm.h"
#include "clipsbridge.h"

using namespace System;
using namespace System::Windows::Forms;

[STAThread]
int main(array<String^>^ argv) {
    Application::EnableVisualStyles();
    Application::SetCompatibleTextRenderingDefault(false);

	ClipsBridge clips;

    vcpp::MyForm form(&clips);
    Application::Run(%form);
	return 0;
}
