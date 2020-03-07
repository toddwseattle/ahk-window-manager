#InstallKeybdHook
Log(text)
{
   OutputDebug % "AHK:" text
}
PShellAndVsCode(dir)
{
  pwsh_exe:="C:\Program Files\PowerShell\7\pwsh.exe"
  Run, %pwsh_exe%
  WinWaitActive, ahk_exe pwsh.exe
  SendInput, cd %dir%`rcode .`r
  return
}
getGitProject(root)
{
  MsgBox, "Git Hub Root", %root%
  Gui, Add, ListView, r10 w300 gMyGitProjs, Name
  Loop, %root%\*.*, 2
    LV_Add("",A_LoopFileName)
  LV_ModifyCol()
  Gui, Show
  return
}
getActivateHwnd(app) 
{
  hwnd:= WinExist(app)
  return Format("ahk_id {1}",hwnd)
}
MoveIt(app, xpos, ypos, width, height) {
  hwnd:= WinExist(app)
  if hwnd {
    WinActivate, ahk_id %hwnd%
    WinRestore,
    WinMove, ahk_id %hwnd%,, xpos, ypos
    WinMove, ahk_id %hwnd%,, xpos, ypos, width, height
  }
  else
  {
    MsgBox, Not Exist %app%
  }
}
AppToMainScreenMax(app) 
{
  SysGet, NM, MonitorCount
  SysGet, PMNum, MonitorPrimary
  SysGet, PMon, MonitorWorkArea, PMNum
  If (NM>1 and PMonRight>1200)
  {
    hwnd:= WinExist(app)
    Log("appToMain")
    Log(app)
    Log(hwnd)
    WinActivate, ahk_id %hwnd%
    WinMinimize
    WinRestore 
    WinMove, 0, 0 ;ahk_id %hwnd%
    WinMaximize
  }
  return
}

AppToLeftofPriMon(app) {
  SysGet, NM, MonitorCount
  SysGet, PMNum, MonitorPrimary
  SysGet, PMon, MonitorWorkArea, PMNum
  Width:=PMonRight / 2
  Height:=PMonBottom
  MoveIt(app, 0, 0, Width, Height)
}
AppToRightofPriMon(app) {
  SysGet, NM, MonitorCount
  SysGet, PMNum, MonitorPrimary
  SysGet, PMon, MonitorWorkArea, PMNum
  Width:=PMonRight / 2
  Height:=PMonBottom
  MoveIt(app, Width, 0, Width, Height)
}

AppToLaptopLeftHalf(app) 
{
  SysGet, NM, MonitorCount
  SysGet, PMNum, MonitorPrimary
  SysGet, PMon, MonitorWorkArea, PMNum
  SysGet LapMon, MonitorWorkArea, 1
  HalfWidth:= (LapMonRight-LapMonLeft)/2
  Height:= (LapMonBottom-LapMonTop)
  MoveIt(app,LapMonLeft,LapMonTop,HalfWidth,Height)
  return
}

ApptoLaptopRightHalf(app) {
  SysGet, NM, MonitorCount
  SysGet, PMNum, MonitorPrimary
  SysGet, PMon, MonitorWorkArea, PMNum
  SysGet, LapMon, MonitorWorkArea, 1
  HalfWidth:= (LapMonRight-LapMonLeft)/2
  Height:=(LapMonBottom-LapMonTop)
  LeftX:=LapMonLeft+HalfWidth
  MoveIt(app,LeftX, LapMonTop, HalfWidth,Height)
  return
}
AppToLgRight(app) 
{
SysGet, NM, MonitorCount
  SysGet, PMNum, MonitorPrimary
  SysGet, PMon, MonitorWorkArea, PMNum
  If (NM>2 and PMonRight>1200)
   {
    SysGet, LgMon, MonitorWorkArea, 2
    HalfWidth:= (LgMonRight-LgMonLeft)/2
    Height:= (LgMonBottom-LgMonTop)
    Left := LgMonLeft+HalfWidth
    MoveIt(app, Left, LgMonTop, HalfWidth, Height)
  } ;If NM>2
  return
}
AppToLgLeft(app) 
{
SysGet, NM, MonitorCount
  SysGet, PMNum, MonitorPrimary
  SysGet, PMon, MonitorWorkArea, PMNum
  If (NM>2 and PMonRight>1200)
   {
    SysGet LgMon, MonitorWorkArea, 2
    HalfWidth:= (LgMonRight-LgMonLeft)/2
    Height:=(LgMonBottom-LgMonTop)
    ;MsgBox, , Lg Monitor, "Left: ".LgMonLeft."Top:".LgMonTop."Half Width".HalfWidth."Height".Height
    MoveIt(app, LgMonLeft, LgMonTop, HalfWidth, Height)
   } 
   return
}

AppMaxLaptop(app)
{
  SysGet, NM, MonitorCount
  SysGet, PMNum, MonitorPrimary
  SysGet, PMon, MonitorWorkArea, PMNum
  If (NM>1 and PMonRight>1200)
  {
    SysGet LapMon, MonitorWorkArea, 1
    HalfWidth:= (LapMonRight-LapMonLeft)/2
    HalfHeight:= (LapMonTop-LapMonBottom)/2
    MidMonLeft:= LapMonLeft+HalfWidth
    hwnd:= WinExist(app)
    if hwnd
    {  
    WinActivate, ahk_id %hwnd%
    WinRestore
    WinMove, ahk_id %hwnd%,, %MidMonLeft%, %LapMonTop%, %HalfWidth%, %HalfHeight%
    WinMaximize
   Log(app)
    Log(hwnd)
    }
    else 
   {
     MsgBox, Not Exist %app%
   }
  } ;If NM>1
  return
}
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
;-------------------------------- 
; Keys from here on out.  for each hot key
; Add a description to HotKeyDesc followed by a `n
; So that it can be displayed!
showhelp(){
HotKeyDesc:="Enabled:`n"
HotKeyDesc:=HotKeyDesc . "Win-U : Outlook in main window Maximized`n"
HotKeyDesc:=HotKeyDesc . "Win-J : Activate vscode and powershell on a github project"
HotKeyDesc:=HotKeyDesc . "Win-C : Activate Code on mainscreen and powershell on laptop`n"
HotKeyDesc:=HotKeyDesc . "Win-Ctrl-m : Show Monitor Config`n"
HotKeyDesc:=HotKeyDesc . "Win-Ctrl-r : Activate Sonos on Laptop Screen"
HotKeyDesc:=HotKeyDesc . "Shift+Win+c : Put vscode on the left side of the main monitor`n"
HotKeyDesc:=HotKeyDesc . "Ctrl+1 to Ctrl-6 : Put current window in Left to right halves on 3 monitors`n"
HotKeyDesc:=HotKeyDesc . "Ctrl+Win+H : Show this help popup`n"
MsgBox ,0,Hot Keys Enabled,%HotKeyDesc%,10
return
}
showhelp()
^#h::showhelp()

#u::
outlookExe:="Inbox"
if WinExist(outlookExe) 
{
   AppToMainScreenMax(outlookExe)
}
return

#j::
InputBox ghdir, Enter GitHub Directory (in c:\gh), Directory
mydir:="c:\gh\"+ghdir
PShellAndVsCode(mydir)
return

#c::
If WinExist("ahk_exe code.exe")
{
   AppToLaptopLeftHalf("ahk_class ConsoleWindowClass")
   AppToMainScreenMax("ahk_exe Code.exe")

}
else
{
   InputBox ghdir, Enter GitHub Directory (in c:\gh), Directory
   mydir:="c:\gh\"+ghdir
   PShellAndVsCode(mydir)
   AppToLaptopLeftHalf("ahk_class ConsoleWindowClass")
AppToMainScreenMax("ahk_exe Code.exe")
}
return
#^m::
SysGet, NumMons, MonitorCount

SysGet, PriMonNum, MonitorPrimary
SysGet, PriMon, Monitor, PriMonNum
MsgBox, Monitors %NumMons% -- Primary Number: %PriMonNum% -- Left: %PriMonLeft% -- Right: %PriMonRight% -- Top: %PriMonTop% -- Bottom: %PriMonBottom%
Loop %NumMons% {
   SysGet CurMon, Monitor, %A_Index%
   MsgBox, Monitor %A_Index% -- Left: %CurMonLeft% -- Right: %CurMonRight% -- Top: %CurMonTop% -- Bottom: %CurMonBottom%
}
return
#^r::
musicApp:="ahk_exe Sonos.exe"
musicRun:="C:\Program Files (x86)\Sonos\Sonos.exe"
if WinExist(musicApp) {
   AppMaxLaptop(musicApp)
}
else {
   Run, %musicRun%
   WinWaitActive, %musicApp%
   AppMaxLaptop(musicApp)
}
return
+#c::
codeApp:="ahk_exe Code.exe"   
AppToLeftofPriMon(codeApp)
return
^1::
currApp:="A"
AppToLeftofPriMon(currApp)
return
^2::
currApp:="A"
AppToRightofPriMon(currApp)
return
^3::
currApp:="A"
AppToLgLeft(currApp)
return
^4::
currApp:="A"
AppToLgRight(currApp)
return
^5::
currApp:="A"
AppToLaptopLeftHalf(currApp)
return
^6::
currApp:="A"
AppToLaptopRightHalf(currApp)
return
^8::
getGitProject("c:\gh")
return
MyGitProjs:
if(A_GuiEvent = "DoubleClick")
  {
    LV_GetText(GitProj, A_EventInfo)
    MsgBox,, Selected Project,%GitProj%
    PShellAndVsCode("c:\gh\"+GitProj)
    Gui, Cancel
    Gui, Destroy
  }
return


