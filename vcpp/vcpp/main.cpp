#include "MyForm.h"
#include "clipscpp.h"
#include "stdio.h"

using namespace System;
using namespace System::Windows::Forms;


 #define OUT_BUFF_SIZE 512

[STAThread]
int main(array<String^>^ argv) {
    Application::EnableVisualStyles();
    Application::SetCompatibleTextRenderingDefault(false);
	
	CLIPS::CLIPSCPPEnv theEnv;

	freopen("stdout.txt","w",stdout);

	theEnv.Load("test.clp");
	theEnv.Reset();
	theEnv.Run(-1);

	fclose(stdout);

    vcpp::MyForm form;
    Application::Run(%form);
	return 0;
}
