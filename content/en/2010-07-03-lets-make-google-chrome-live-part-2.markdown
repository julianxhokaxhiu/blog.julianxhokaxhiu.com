---
layout: single
title: Let’s make Google Chrome Live! – Part 2
date: '2010-07-03 12:09:49'
tags:
- c
- win32
aliases: [/lets-make-google-chrome-live-part-2/index.html]
---

Hello again,

sorry for this late post that i've promised a month ago. But who cares, the important thing is that we're here alive and kicking again or not? :)

Today i would like to tell you how to create a GUI loader for your Google Chrome Live CD, because if you remember the last post, we had made it but only in (maybe horrible?) Console version. Before posting the code as usual i would like to tell you what you have to do before.

To make a GUI loader for a CD is just a pain in the ass (believe me) because you have to think two things: first, is for what platform you're going to develop to, and second you have to choose a method that is compatible with all the forms, versions and types of that platform. In this case i covered all the Windows platforms (from Windows 95 to Windows 7) but as you already know between them, there are so much differences in the core of the platform that made me to choose the only one that i know that it just works: i'm talking about Windows SDK.

Yeah, maybe you're thinking "wtf?" or "just crazy...why didn't you choose .NET platform?", but i can answer both of those questions with: didn't you know that Windows 95 to Windows ME do not have .NET support? And because Windows is made in Pure C, why can't we use such a great language like that one? Windows SDK was made with only one scope in mind: cover all the windows platforms, to let developers create application that just works (but they're just "much difficult" to code).

OK so, now that we know what are we going to do, before copying and compiling the source that will be posted after this, you must do two things: create an empty C++ project with Microsoft Visual C++ 2005/2008/2010 (also Express Edition works) and create a BMP image to put when our loader is working. After this remember to include that one in a file called **Resource.rc**. That is, copy and paste the code into your Main.cpp file and compile :)

Easy huh? If you're curious to know much about the code, read the comments (if you need more, just let me know) and continue to follow me as i'm going to post some nice other things, like how to fix baloon height size in Google Maps API v2.

Thanks for reading, see you in the next post.

EDIT: I've attached a simple project with all of this combined, so just download, unzip and compile. To do so, you need Microsoft Visual C++ 2010 Express Edition (otherwise you can copy and paste the code). {{< asset_link "/misc/chrome-live/MyCDLoader.zip" "Download it now!" >}}

**Main.cpp**

```cpp
#include "resource.h"
#include <direct.h> // for getcwd
#include <stdlib.h>// for MAX_PATH
#include <windows.h>
#include <windowsx.h>
#define IDT_TIMER1 1000
LRESULT CALLBACK WndProc (HWND, UINT, WPARAM, LPARAM);
HBITMAP hBitmap;
PAINTSTRUCT ps;
HDC hdc;
// Get information about Chrome
PROCESS_INFORMATION pif;  //Gives info on the thread and..
//..process for the new process
STARTUPINFO si;           //Defines how to start the program
/* Function CenterWindow(), Centers Window */
VOID CenterWindow(HWND hwnd, HWND hwndParent, int Width, int Height)
{
/* Variables */
RECT rc;
/* If Parent Window Is Set As Null, Get The Desktop Window */
if(hwndParent == NULL)
hwndParent = GetDesktopWindow();
/* Get Parent Client Area Measurements */
GetClientRect(hwndParent, &rc);
/* Center The Window */
MoveWindow(
hwnd,
(rc.right - rc.left - Width) / 2,
(rc.bottom - rc.top - Height) / 2,
Width,
Height,
TRUE
);
return;
}
int WINAPI WinMain (HINSTANCE hInstance, HINSTANCE hPrevInstance, PSTR szCmdLine, int iCmdShow)
{
static char szAppName[] = "My CD Loader" ;
HWND        hwnd ;
MSG         msg ;
WNDCLASSEX  wndclass ;
wndclass.cbSize        = sizeof (wndclass) ;
wndclass.style         = CS_HREDRAW | CS_VREDRAW ;
wndclass.lpfnWndProc   = WndProc ;
wndclass.cbClsExtra    = 0 ;
wndclass.cbWndExtra    = 0 ;
wndclass.hInstance     = hInstance ;
wndclass.hIcon         = LoadIcon (NULL, IDI_APPLICATION) ;
wndclass.hCursor       = LoadCursor (NULL, IDC_ARROW) ;
wndclass.hbrBackground = (HBRUSH) GetStockObject (WHITE_BRUSH) ;
wndclass.lpszMenuName  = NULL ;
wndclass.lpszClassName = szAppName ;
wndclass.hIconSm       = LoadIcon (NULL, IDI_APPLICATION) ;
RegisterClassEx (&wndclass) ;
hwnd = CreateWindow(szAppName,   // window class name
NULL,     // window caption
WS_POPUP,     // window style
CW_USEDEFAULT,           // initial x position
CW_USEDEFAULT,           // initial y position
367,           // initial x size
192,           // initial y size
NULL,                    // parent window handle
NULL,                    // window menu handle
hInstance,               // program instance handle
NULL) ;               // creation parameters
ShowWindow (hwnd, iCmdShow) ;
UpdateWindow (hwnd) ;
CenterWindow(hwnd, NULL, 367, 192);
SetTimer(hwnd,             // handle to main window
IDT_TIMER1,            // timer identifier
1000,                 // 10-second interval
(TIMERPROC) NULL);     // no timer callback
while (GetMessage (&msg, NULL, 0, 0))
{
TranslateMessage (&msg) ;
DispatchMessage (&msg) ;
}
return msg.wParam ;
}
LRESULT CALLBACK WndProc (HWND hwnd, UINT iMsg, WPARAM wParam, LPARAM lParam)
{
switch (iMsg)
{
case WM_CREATE :
{
// The bitmap should be stored as a resource in the exe file.
// We pass the hInstance of the application, and the ID of the
// bitmap to the LoadBitmap API function and it returns us an
// HBITMAP to a DDB created from the resource data.
HINSTANCE hInstance = GetWindowInstance(hwnd);
hBitmap = LoadBitmap(hInstance,MAKEINTRESOURCE(IDB_BITMAP1));
// Start Google Chrome
// _MAX_PATH is the maximum length allowed for a path
char CurrentPath[_MAX_PATH];
char SysLaunch[_MAX_PATH];
// use the function to get the path
_getcwd(CurrentPath, _MAX_PATH);
strcpy_s(SysLaunch, CurrentPath);
strcat_s(SysLaunch, "\\GoogleChromePortable\\GoogleChromePortable.exe --start-maximized --app=\"");
strcat_s(SysLaunch, CurrentPath);
strcat_s(SysLaunch, "\\start.html\"");
ZeroMemory(&si,sizeof(si)); //Zero the STARTUPINFO struct
si.cb = sizeof(si);         //Must set size of structure
BOOL bRet = CreateProcess(
NULL, //Path to executable file
SysLaunch,   //Command string - not needed here
NULL,   //Process handle not inherited
NULL,   //Thread handle not inherited
FALSE,  //No inheritance of handles
0,      //No special flags
NULL,   //Same environment block as this prog
NULL,   //Current directory - no separate path
&si,    //Pointer to STARTUPINFO
&pif);   //Pointer to PROCESS_INFORMATION
if(bRet == FALSE)
{
MessageBox(HWND_DESKTOP,"Cannot run Google Chrome.","",MB_OK);
PostQuitMessage (0);
}
return 0;
}
case WM_PAINT :
{
hdc = BeginPaint (hwnd, &ps);
// To paint with a DDB it first needs to be associated
// with a memory device context. We make a DC that
// is compatible with the screen by passing NULL to
// CreateCompatibleDC.
// Then we need to associate our saved bitmap with the
// device context.
HDC hdcMem = CreateCompatibleDC(NULL);
HBITMAP hbmT = SelectBitmap(hdcMem,hBitmap);
// Now, the BitBlt function is used to transfer the contents of the
// drawing surface from one DC to another. Before we can paint the
// bitmap however we need to know how big it is. We call the GDI
// function GetObject to get the relevent details.
BITMAP bm;
GetObject(hBitmap,sizeof(bm),&bm);
BitBlt(hdc,0,0,bm.bmWidth,bm.bmHeight,hdcMem,0,0,SRCCOPY);
// Now, clean up. A memory DC always has a drawing
// surface in it. It is created with a 1X1 monochrome
// bitmap that we saved earlier, and need to put back
// before we destroy it.
SelectBitmap(hdcMem,hbmT);
DeleteDC(hdcMem);
// EndPaint balances off the BeginPaint call.
EndPaint (hwnd, &ps);
return 0;
}
case WM_TIMER :
{
switch (wParam)
{
case IDT_TIMER1 :
{
if(!WaitForInputIdle(pif.hProcess, 0))
{
CloseHandle(pif.hProcess);   //Close handle to process
CloseHandle(pif.hThread);    //Close handle to thread
PostQuitMessage (0) ; // Quit from App
}
break;
}
}
break;
}
case WM_DESTROY :
PostQuitMessage (0) ;
return 0 ;
}
return DefWindowProc (hwnd, iMsg, wParam, lParam) ;
}
```

**Resource.rc**

```cpp
// Microsoft Visual C++ generated resource script.
//
#include "resource.h"
#define APSTUDIO_READONLY_SYMBOLS
/////////////////////////////////////////////////////////////////////////////
//
// Generated from the TEXTINCLUDE 2 resource.
//
#include "afxres.h"
/////////////////////////////////////////////////////////////////////////////
#undef APSTUDIO_READONLY_SYMBOLS
/////////////////////////////////////////////////////////////////////////////
// Italian (Italy) resources
#if !defined(AFX_RESOURCE_DLL) || defined(AFX_TARG_ITA)
LANGUAGE LANG_ITALIAN, SUBLANG_ITALIAN
#ifdef APSTUDIO_INVOKED
/////////////////////////////////////////////////////////////////////////////
//
// TEXTINCLUDE
//
1 TEXTINCLUDE
BEGIN
"resource.h\0"
END
2 TEXTINCLUDE
BEGIN
"#include ""afxres.h""\r\n"
"\0"
END
3 TEXTINCLUDE
BEGIN
"\r\n"
"\0"
END
#endif    // APSTUDIO_INVOKED
/////////////////////////////////////////////////////////////////////////////
//
// Bitmap
//
IDB_BITMAP1             BITMAP                  "Path\\To\\My\\File\\loading.bmp"
#endif    // Italian (Italy) resources
/////////////////////////////////////////////////////////////////////////////
#ifndef APSTUDIO_INVOKED
/////////////////////////////////////////////////////////////////////////////
//
// Generated from the TEXTINCLUDE 3 resource.
//
/////////////////////////////////////////////////////////////////////////////
#endif    // not APSTUDIO_INVOKED
```