#include "MyForm.h"
#include "CLIPS/clips.h"
#include <stdio.h>


using namespace System;
using namespace System::Windows::Forms;


void UserFunctions(void);
void EnvUserFunctions(void *);


void SwapIOB(FILE *A, FILE *B) {
    FILE temp;
    // make a copy of IOB A (usually this is "stdout")
    memcpy(&temp, A, sizeof(struct _iobuf));
    // copy IOB B to A's location, now any output
    // sent to A is redirected thru B's IOB.
    memcpy(A, B, sizeof(struct _iobuf));
    // copy A into B, the swap is complete
    memcpy(B, &temp, sizeof(struct _iobuf));
}


[STAThread]
int main(array<String^>^ argv) {
    Application::EnableVisualStyles();
    Application::SetCompatibleTextRenderingDefault(false);
	
	char buffer[128];

	DATA_OBJECT facts;
	void *multifieldPtr;
	int end, i;
	long count;
	char *tempPtr;

	FILE *fp;
	fp = fopen("stdout.txt","w");
	SwapIOB(stdout, fp);
	printf("test\r\n");

	void *theEnv;
   
	theEnv = CreateEnvironment();
	InitializeEnvironment();
	Load("test.clp");
	Reset();
	sprintf(buffer,"(state %c-should-pick)",'N');
	AssertString(buffer);

	Run(-1);
	//Facts("stdout",NULL,-1,-1,-1);
	GetFactList(&facts,NULL);




	end=GetDOEnd(facts);
	multifieldPtr=GetValue(facts);
	for (i=GetDOBegin(facts);i<=end;i++) {
		//PrintAtom(theEnv,"stdout",GetMFType(multifieldPtr,i),(GetMFValue(multifieldPtr,i)));
		PrintFactWithIdentifier(theEnv,"stdout",(fact *)GetMFValue(multifieldPtr,i));
		printf("\r\n");
	}
	//if ((GetMFType(multifieldPtr,i) == STRING) || (GetMFType(multifieldPtr,i) == SYMBOL))
	//tempPtr = ValueToString(GetMFValue(multifieldPtr,i));


	printf("test\r\n");
	DeallocateEnvironmentData();
	fclose(stdout);

    vcpp::MyForm form;
    Application::Run(%form);
	return 0;
}
