//
//  RBAppDelegate.h
//  RainBar
//
//  Created by Lockyy on 19/11/2013.
//  Copyright (c) 2013 Daniel Lockhart. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AVFoundation/AVFoundation.h>

@interface RBAppDelegate : NSObject <NSApplicationDelegate>{
	IBOutlet NSMenu *statusMenu;
	IBOutlet NSMenuItem *toggleMusic;
	IBOutlet NSMenuItem *toggleLogin;
	NSStatusItem *statusItem;
	NSImage *onImage;
	NSImage *onHighlightImage;
	NSImage *offImage;
	NSImage *offHighlightImage;
	AVAudioPlayer *musicPlayer;
	BOOL musicPlaying;
}

-(IBAction) toggleMusicClicked: (id) sender;
-(IBAction) toggleLoginLoadClicked: (id) sender;

- (void) toggleMusic;
- (void) setLaunchOnLogin: (BOOL)value;
- (BOOL) launchOnLogin;

@property (assign) IBOutlet NSWindow *window;

@end
