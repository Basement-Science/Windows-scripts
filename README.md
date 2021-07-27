# Windows-scripts
A collection of cmd- and other scripts which mostly modify OS settings, fix small problems or add functionality.

All scripts can be used independent of each other. ***See documentation inside the script files.***

## Highlights:
### Scripts to use once:
- `[Add custom SendTo functions.bat]` Add 3 entries to the SendTo dialog which make your own use and customization easier. 
- `[green cmd.reg]` make console windows higher contrast / easier to read by making it GREEN 
- `[Large Task Bar Preview.reg]` make Taskbar Preview images large enough so you can see the window properly. 
- `[Restore Sharing tab in folder Properties window.reg]` Sometimes Windows is missing the Sharing tab in file/folder properties window _for whatever reason_.
- `[Show all hidden Files and file extensions.reg]` Enables the options to show ALL files in file explorer.
- `[WHEA-Logger_notify.xml]` Depending on your System and whether you enabled the relevamt features in BIOS, Windows may raise Events when **Hardware Errors** occur or get corrected. ***Import this file as a scheduled task to get a popup message box every time this happens.*** _Note: Windows seems to stop raising these events after 2(?) occurances in a session._
- `[win10-desktopIcon-spacing like in win8--.reg]` Since Windows 10, Desktop Icon spacing seems to be random (mostly narrow) after installation with no easy way to change it. So with this **.reg** file, you can set it back to the way it was since Vista.

### Scripts to use when needed:
- `[Restart Explorer.bat]` Just restarts explorer.exe
- `[Win8+ UAC fullswitcher.bat]` Script that FULLY enables or disables `User Account Control`. This means you will not have to click any prompts whenever you install things or change system settings. Any programs that have to run as admin will "just work" _accidentally_ without you having to think about it. In Windows 7 this was one of the regular options for User account control behavior, but it was removed from the GUI settings in Win 8.  
**WARNING** When disabled, ALL programs will be run as Administrator! This can be a huge security risk! It may also confuse some programs. On older Win10 builds, ALL UWP (store) apps will also refuse to run. 