#import "AppDelegate.h"

#include <signal.h>

@interface AppDelegate ()
@property (weak) IBOutlet NSButton *btn;

@property (weak) IBOutlet NSWindow *window;
//@property AppleScriptLauncher *launcher;
- (IBAction)switcher:(id)sender;
@end

BOOL active = NO;
@implementation AppDelegate

- (IBAction)switcher:(id)sender{
    
    if (active) {
        _btn.state = 1;
        active = NO;
        _btn.title = @"Stop";
    } else {
        _btn.state = 0;
        active = YES;
        _btn.title = @"Start preventing other Applications from launching";
    }
}
-(void)demoDone{
    exit(0);
}
-(void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
    active = NO;
    [self switcher:nil];
    
    
    
    [self start];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 120 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{ exit(0);});
}
- (void)applicationWillTerminate:(NSNotification *)aNotification {

}

NSNotificationCenter * notify;
- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {return YES;}

-(id) start {
    
    notify = [[NSWorkspace sharedWorkspace] notificationCenter];
    
    [notify addObserver: self selector: @selector(launchedApp:) name: @"NSWorkspaceWillLaunchApplicationNotification" object: nil];
    
    [_window setLevel:NSMainMenuWindowLevel+1];
    [_window setCollectionBehavior:NSWindowCollectionBehaviorCanJoinAllSpaces];
    return self;
}

-(void) launchedApp: (NSNotification*) notification {
    
    if (active) return;
    
    NSDictionary *userInfo = [notification userInfo];
    NSString* AppPID = [userInfo objectForKey:@"NSApplicationProcessIdentifier"];
    NSString* AppPath = [userInfo objectForKey:@"NSApplicationPath"];
    NSString* AppBundleID = [userInfo objectForKey:@"NSApplicationBundleIdentifier"];
    NSString* AppName = [userInfo objectForKey:@"NSApplicationName"];
    int res = kill(([AppPID intValue]), SIGTERM); //ABRT
    NSLog(@"\n  %@\n  %@\n  %@\n  %@: %i", AppPID, AppPath, AppBundleID, AppName, res);
}
@end
