#include <string>

std::string GetStdStr(System::String ^arg) {
	const char* chars=(const char*)(System::Runtime::InteropServices::Marshal::StringToHGlobalAnsi(arg)).ToPointer();
	System::Runtime::InteropServices::Marshal::FreeHGlobal(System::IntPtr((void*)chars));
	return chars;
}