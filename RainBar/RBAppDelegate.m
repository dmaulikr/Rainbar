//
//  RBAppDelegate.m
//  RainBar
//
//  Created by Lockyy on 19/11/2013.
//  Copyright (c) 2013 Daniel Lockhart. All rights reserved.
//

#import "RBAppDelegate.h"
#import <AVFoundation/AVFoundation.h>
#import <ServiceManagement/ServiceManagement.h>

@implementation RBAppDelegate

- (void) awakeFromNib
{
	statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength: NSVariableStatusItemLength];
	
	NSBundle *bundle = [NSBundle mainBundle];
	
	NSURL* musicFile = [NSURL fileURLWithPath:[bundle pathForResource:@"rainLoop"
															   ofType:@"wav"]];
	
	NSError *error;
	musicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:musicFile error:&error];
	
	// -1 makes it loop until told to stop
	musicPlayer.numberOfLoops = -1;
	
	onImage = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"on16"
																	   ofType:@"png"]];
	
	onHighlightImage = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"on16Invert"
																				ofType:@"png"]];
	
	
	offImage = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"off16"
																	   ofType:@"png"]];
	
	offHighlightImage = onHighlightImage;
	
	musicPlaying = NO;
	
	[statusItem setImage: offImage];
	[statusItem setAlternateImage: offHighlightImage];
	[statusItem setMenu: statusMenu];
	[statusItem setHighlightMode: YES];
	
	[toggleLogin setState: [self launchOnLogin]];
}

-(IBAction) toggleMusicClicked: (id) sender
{
	[self toggleMusic];
}

-(IBAction) toggleLoginLoadClicked: (id) sender
{
	if([self launchOnLogin])
	{
		[toggleLogin setState: 0];
		[self setLaunchOnLogin: NO];
	}
	else
	{
		[toggleLogin setState: 1];
		[self setLaunchOnLogin: YES];
	}
}

- (void)menuWillOpen:(NSMenu *)menu
{
	// We want to override left mouse clicks to toggle the music, not open the menu.
	// We'll leave right mouse clicks as opening the menu, for setting startup running
	// and exiting the application.
	if([[NSApp currentEvent] buttonNumber] != NSLeftMouseDown)
	{
		[self toggleMusic];
		[menu cancelTracking];
	}
}

-(void) toggleMusic
{
	if(musicPlaying == NO)
	{
		[toggleMusic setState: 1];
		[musicPlayer play];
		[statusItem setImage: onImage];
		[statusItem setAlternateImage: onHighlightImage];
		musicPlaying = YES;
	}
	else
	{
		[toggleMusic setState: 0];
		[musicPlayer stop];
		[statusItem setImage: offImage];
		[statusItem setAlternateImage: offHighlightImage];
		musicPlaying = NO;
	}
}

// Toggle the login helper running at login. (The login helper launches the main RainBar app)
// We have to do things this way because of the app sandbox.
// You can read more about this here:
// http://www.delitestudio.com/2011/10/25/start-dockless-apps-at-login-with-app-sandbox-enabled/
- (void)setLaunchOnLogin:(BOOL)value
{
	// Register the helper app
	NSURL *url = [[[NSBundle mainBundle] bundleURL] URLByAppendingPathComponent:
				  @"Contents/Library/LoginItems/RainBarLoginHelper.app"];
	
	if (LSRegisterURL((__bridge CFURLRef)url, true) != noErr) {
		NSLog(@"LSRegisterURL failed!");
	}
	
	// Set it to run on login
	if (!SMLoginItemSetEnabled((CFStringRef)@"com.lockyy.RainBarLoginHelper", value))
	{
        NSLog(@"SMLoginItemSetEnabled(..., %hhd) failed", value);
    }
}

// Returns whether the program is set to run on login or not
- (BOOL)launchOnLogin
{
	NSArray *jobs = (NSArray *)CFBridgingRelease(SMCopyAllJobDictionaries(kSMDomainUserLaunchd));
	
	if (jobs == nil)
	{
		return NO;
	}
	
	if ([jobs count] == 0)
	{
		return NO;
	}
	
	BOOL onDemand = NO;
	for (NSDictionary *job in jobs)
	{
		if ([@"com.lockyy.RainBarLoginHelper" isEqualToString:[job objectForKey:@"Label"]])
		{
			onDemand = [[job objectForKey:@"OnDemand"] boolValue];
			break;
		}
	}
	
	return onDemand;
}

@end
