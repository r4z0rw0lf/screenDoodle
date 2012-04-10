//
//  AppController.m
//  screenDoodle
//
//  Created by Nicholas Beeuwsaert on 4/8/12.
//  Copyright (c) 2012 Princeton High School. All rights reserved.
//

#import "AppController.h"
#import "DoodleView.h"
#import "DDHotKeyCenter.h"
@implementation AppController
@synthesize window = _window;
@synthesize statusItem;
@synthesize statusMenu;
@synthesize active;
@synthesize redMenu;
@synthesize blueMenu;
@synthesize greenMenu; 
@synthesize prefController;

- (void) awakeFromNib {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ApplePersistenceIgnoreState"];
    
    DDHotKeyCenter *hotkeyCenter = [[DDHotKeyCenter alloc]init];
    
    DDHotKeyTask activateColor0 = ^(NSEvent* event){
        [self setColor0:nil];
    };
    DDHotKeyTask activateColor1 = ^(NSEvent* event){
        [self setColor1:nil];
        
    };
    DDHotKeyTask activateColor2 = ^(NSEvent* event){
        [self setColor2:nil];
        
    };
    DDHotKeyTask toggle = ^(NSEvent* event){
        [self toggleVisibility:nil];
    };
    DDHotKeyTask clear = ^(NSEvent* event){
        [self clearDoodles:nil];
    };
    [hotkeyCenter registerHotKeyWithKeyCode:18 modifierFlags:NSControlKeyMask task:activateColor0];
    [hotkeyCenter registerHotKeyWithKeyCode:19 modifierFlags:NSControlKeyMask task:activateColor1];
    [hotkeyCenter registerHotKeyWithKeyCode:20 modifierFlags:NSControlKeyMask task:activateColor2];
    [hotkeyCenter registerHotKeyWithKeyCode:50 modifierFlags:NSControlKeyMask task:toggle];
    [hotkeyCenter registerHotKeyWithKeyCode:0x1D modifierFlags:NSControlKeyMask task:clear];
    [hotkeyCenter release];
    [_window orderOut:nil];

    statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength] retain];
    [statusItem setMenu:statusMenu];
    [statusItem setImage:
     [[NSImage alloc ]initByReferencingFile:[[NSBundle mainBundle] pathForResource:@"MenuExtra" ofType:@"png"]]];
    [statusItem setAlternateImage:
     [[NSImage alloc ]initByReferencingFile:[[NSBundle mainBundle] pathForResource:@"MenuExtra-alt" ofType:@"png"]]];
    [statusItem setHighlightMode:YES];
}
- (void)bringToFront {
    [_window makeKeyAndOrderFront:nil];
    [_window setLevel:NSMainMenuWindowLevel+1];
    [self setActive:YES];
    
}
- (IBAction) toggleVisibility:(id)sender {
    if([self active]){
        [self sendToBack];
    }else{
        [self bringToFront];
        //[self bringToFront];
    }
}
- (void) sendToBack {
    [_window orderOut:nil];
    [self setActive:NO];
}
- (IBAction)clearDoodles:(id)sender {
    [[(DoodleView*)[_window contentView] doodles] removeAllObjects];
    [[(DoodleView*)[_window contentView] bezierDoodles] removeAllObjects];
    [[_window contentView] setNeedsDisplay:YES];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    [statusItem release];
}
- (void)disableAllColors {
    [redMenu setState:NSOffState];
    [greenMenu setState:NSOffState];
    [blueMenu setState:NSOffState];
}
- (IBAction) setColor0:(id)sender {
    [[(DoodleView*)[_window contentView] currentColor] release];
    NSColor *c = [[NSUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] dataForKey:@"CustomColor00"]] retain];
    [(DoodleView*)[_window contentView] setCurrentColor:c];
    [self disableAllColors];
    [redMenu setState:NSOnState];
    
}
- (IBAction) setColor2:(id)sender {
    [[(DoodleView*)[_window contentView] currentColor] release];
    NSColor *c = [[NSUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] dataForKey:@"CustomColor02"] ]retain];
    [(DoodleView*)[_window contentView] setCurrentColor:c];
    [self disableAllColors];
    [blueMenu setState:NSOnState];
}
- (IBAction) setColor1:(id)sender {
    [[(DoodleView*)[_window contentView] currentColor] release];
    NSColor *c = [[NSUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] dataForKey:@"CustomColor01"]] retain];
    [(DoodleView*)[_window contentView] setCurrentColor:c];
    [self disableAllColors];
    [greenMenu setState:NSOnState];
}
- (IBAction) launchPreferencesPane:(id)sender {
    //[NSBundle loadNibNamed:@"Preferences" owner:[NSBundle mainBundle]];
    if (! prefController) {
        prefController = [[PrefController alloc] init];
    }
    [prefController showWindow:self];
}
@end