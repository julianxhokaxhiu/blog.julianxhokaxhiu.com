---
layout: single
title: Let’s make Google Chrome Live!
date: '2010-06-05 00:07:06'
tags:
- c
- batch
---

Hi there,

Today (or maybe tonight here...) i would like to share with you a personal success: i've made a portable Google Chrome Live to run from CD with a site preloaded as an application, to start when insert a CD inside your tray (sorry Windows only, Linux and Mac OS X does not support autorun!). But how did i do it? Let's see it together :)

First, you'll need a portable version of Google Chrome (let's say to use the latest Dev build from [PortableApps.com](http://www.portableapps.com "Portable Apps")) that you can get [here](http://portableapps.com/apps/internet/google_chrome_portable "Download Google Chrome Portable"). When you'll finish the download, double click on it and decide to extract it wherever you want, let's say

```
C:\Users\Julian\Desktop\GoogleChromePortableDev
```

After that copy the **GoogleChromePortable.ini** that you will find into `.\Other\Source\` and open it with your favourite editor. Inside change the line 24 from

```
RunLocally=false
```

to

```
RunLocally=true
```

and save it. Until now, you will have in your hand a Portable Google Chrome Live that you can burn and you can use where you want. It will find automatically your plugins in your computer if they're installed and will load any content just like it was installed in your computer :) [But if you're searching for more, continue reading this article.]

So, now we have to find the way to launch it with our preferred site :) To do that i've found that Google Chrome accept the **--app** parameter that is defined like this:

```
chrome.exe --app="MyWebSiteHere_Or_MyLocalFileHere"
```

which an example would be like this:

```
[chrome.exe --app="http://www.julianxhokaxhiu.com"] Or [chrome.exe --app="file://C:\Users\Julian\Desktop\index.html"]
```

Well, Google Chrome team create a switch for us that will lead us to deploy a "Web Application" like a normal application. Notice that the path to an HTML file MUST BE ABSOLUTE and IT CANNOT BE RELATIVE (or maybe until the date of the creation of this article) so we have to deal with it.

Doing it would be easy to deploy as stealing a lollipop to a kid (just kidding =P). To do so let's make a little wrapper by ourselves with a little know of C and Win32 SDK. If you're going to stop reading this article now, i've a little "bad" news for you, i'll post the code just after the break :)

```cpp
#include <direct.h> // for getcwd
#include <stdio.h>
#include <stdlib.h>// for MAX_PATH
#include <strings.h>
#include <windows.h>
int main(void)
{
// _MAX_PATH is the maximum length allowed for a path
char CurrentPath[_MAX_PATH];
char SysLaunch[_MAX_PATH];
char ArgLaunch[_MAX_PATH];
// use the function to get the path
getcwd(CurrentPath, _MAX_PATH);
strcpy(SysLaunch, CurrentPath);
strcat(SysLaunch, "\\GoogleChromePortable\\GoogleChromePortable.exe --start-maximized --app=\"");
strcat(SysLaunch, CurrentPath);
strcat(SysLaunch, "\\start.html\"");
printf("Starting Google Chrome...this may take a while...");
PROCESS_INFORMATION pif;  //Gives info on the thread and..
//..process for the new process
STARTUPINFO si;          //Defines how to start the program
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
MessageBox(HWND_DESKTOP,"Error: Unable to start Google Chrome.","",MB_OK);
return 1;
}
WaitForInputIdle(pif.hProcess, INFINITE);
CloseHandle(pif.hProcess);   //Close handle to process
CloseHandle(pif.hThread);    //Close handle to thread
return 0;
}
```

Ok now that we have the code, tested and working, and informing the user that something is loading (will also close when the Chrome will finish loading itself and will get the current path where the .exe is starting), just copy-paste it and compile it with your favourite compiler (or just with [Code::Blocks](http://www.codeblocks.org/ "Code::Blocks"), a really good Open Source C++ IDE). Remember to compile it as a C source, NOT A C++ SOURCE!! After that, you'll get a little .exe near to your C code that will do the work.

Finally, let's create our **Autorun.inf** that will do the job to autostart our "start.exe" that will load the chrome with our site preloaded in it:

```
[autorun]
shellexecute=start.exe
icon=CDIcon.ico
label=Our Live CD
```

After that we have created it, we're ready to burn our CD. Remember to put all this things inside the CD like this tree structure:

```
\
|- GoogleChromePortable\
|- OurSite\
|- start.exe
|- CDIcon.ico
|- start.html
(which will redirect the browser inside the folder "OurSite")
|- autorun.inf
```

When you're ready, create the ISO with your preferred CD/DVD Burning application and try it before burning into a real CD/DVD (like with [Daemon Tools](http://www.daemon-tools.cc/ "Daemon Tools")).

I hope you enjoyed this tutorial and i hope you'll come here to watch also the source code to a GUI launcher with an image, into the next post.

Until then, thanks for reading and don't forget to leave a comment :)