// generated by Fast Light User Interface Designer (fluid) version 1.0108

#ifndef ctrl_window_h
#define ctrl_window_h

#include <FL/Fl.H>
#include <stdio.h>
#include <stdlib.h>
#include <FL/Fl_Window.H>
#include <FL/Fl_Input.H>
#include <FL/Fl_Output.H>
#include <FL/fl_draw.H>
#include <FL/Fl_Timer.H>
#include <FL/Fl_Button.H>
#include <string.h>
#include <FL/Fl_Multiline_Output.H>
#include <FL/Fl_Choice.H>


extern "C"{
#include "scicos/scicos_block4.h"
}
//using namespace std;

struct Pid_Parameters
{
	double Kp;
	double Ti;
	double Td;
};

#ifdef ROLLER_LIB_EXPORTS
#define ROLLER_LIB_API	__declspec(dllexport) 
#else
#define ROLLER_LIB_API	__declspec(dllimport) 
#endif

ROLLER_LIB_API void EvidenceAmazingRollers(scicos_block*,int);
void EvidenceGetData(Pid_Parameters*, Pid_Parameters*);
void EvidenceCloseRoller(void);
int EvidenceOpenRoller(void);
unsigned char EvidenceReturnErrorRoller(void);
unsigned char EvidenceSetRollerParameters(double* vet);
void InitRollerParameters(scicos_block*,double*);
void Choice_CB(Fl_Menu_*, void*);

//-----------------------------------
static void Properties_CB(Fl_Widget*,void*); 
static void Settings_CB(Fl_Widget*,void*); 
static void Parameters_CB(Fl_Widget*,void*); 
static void About_CB(Fl_Widget*,void*); 
static void Button_CB(Fl_Widget*,void* userdata); 
static void WinQuit_CB(Fl_Widget*,void*); 
//-----------------------------------

class SettingsWindow {
public:
  Fl_Input *actual_portname; 
  Fl_Input *actual_baudrate; 
  Fl_Button *button_open; 
  Fl_Button *button_close; 
  Fl_Window *fig; 
  SettingsWindow(int x = 300, int y = 100, int w = 225, int h = 200, const char* t="Settings");
  ~SettingsWindow();
  const char* return_value(const char* s);
};

class PropertiesWindow {
public:
  Fl_Window *fig; 
  Fl_Output *actual_mode; 
  Fl_Output*actual_state; 
  Fl_Output *actual_portname; 
  Fl_Output *actual_baudrate; 
  Fl_Output *actual_data; 
  Fl_Output *actual_error; 
  PropertiesWindow(int x = 100,int y = 100,int w = 225, int h = 225, const char* t = "Properties");
  ~PropertiesWindow();
  void update(void);
  void mode(const char* s);
  void state(const char* s);
  void error(const char*s);
};

class ParametersWindow {
public:
  Fl_Window *fig; 
  ParametersWindow(int w=300, int h=105, const char* t="Parameters");
  ~ParametersWindow();
};

class AboutWindow {
public:
  Fl_Window *fig;
  Fl_Multiline_Output *text_about;
  AboutWindow(int w=300, int h=105, const char* t="Info");
  ~AboutWindow();
};
//-----------------------------------
char text_string[1000]; 
extern volatile unsigned char START_FLAG; 
extern volatile unsigned char CMD_FLAG; 
extern volatile unsigned char MODE_FLAG; 
extern volatile unsigned char UPDATE_FLAG; 
extern volatile unsigned char RESET_FLAG; 
extern volatile unsigned char SEND_FLAG; 
extern volatile int timer_counter; 
extern volatile int packet_id; 
extern volatile int packet_counter; 
extern SettingsWindow st; 
extern PropertiesWindow pr; 
extern ParametersWindow par; 
extern AboutWindow about; 
//double TIMEOUT_PERIOD; 
//-----------------------------------
#include <FL/Fl_Double_Window.H>
extern void WinQuit_CB(Fl_Double_Window*, void*);
#include <FL/Fl_Menu_Bar.H>
extern void Properties_CB(Fl_Menu_*, void*);
extern void WinQuit_CB(Fl_Menu_*, void*);
extern void Settings_CB(Fl_Menu_*, void*);
extern void Parameters_CB(Fl_Menu_*, void*);
extern void About_CB(Fl_Menu_*, void*);
#include <FL/Fl_Roller.H>
#include <FL/Fl_Button.H>
extern void Button_CB(Fl_Button*, void*);
extern Fl_Button *Button_Update;
extern Fl_Menu_Item menu_[];
#define SerialConfiguration (menu_+5)
#define CtrlConfiguration (menu_+6)
//-----------------------------------
void Properties_CB(Fl_Widget*, void*);
void Settings_CB(Fl_Widget*, void*);
void Parameters_CB(Fl_Widget*, void*);
void About_CB(Fl_Widget*, void*);
void Button_CB(Fl_Widget*, void* userdata);
void WinQuit_CB(Fl_Widget*, void*);
//-----------------------------------
#endif
