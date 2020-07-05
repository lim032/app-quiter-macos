# app-quiter-macos.app
##### v 0.92
### Simple macos application for preventing other apps from launching/opening
- Single button toggles on/off
- App uses Cocoa's ```NSWorkspaceWillLaunchApplicationNotification``` from ```NSWorkspace``` for getting info on launched applications in userspace. It only works for applications having ```"LSUIElement" = true``` so those are not appearing in Dock.
- Does not require admin priveleges
- Uses POSIX API to terminate applications.

Project created with Xcode 7 and build with Xcode 11.5.
Tested on mac versions 10.11-10.15
