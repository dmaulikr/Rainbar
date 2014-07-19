//
//  RBAppDelegate.m
//  RainBarLoginHelper
//
//  Created by Lockyy on 20/11/2013.
//  Copyright (c) 2013 Daniel Lockhart. All rights reserved.
//

#import "RBAppDelegate.h"

@implementation RBAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSString *basePath = [[NSBundle mainBundle] bundlePath];
    NSString *path = [basePath stringByDeletingLastPathComponent];
    path = [path stringByDeletingLastPathComponent];
    path = [path stringByDeletingLastPathComponent];
    path = [path stringByDeletingLastPathComponent];
	
    
    NSString *pathToExecutable = [path stringByAppendingPathComponent:@"Contents/MacOS/RainBar"];
	
    if ([[NSWorkspace sharedWorkspace] launchApplication:pathToExecutable])
	{
        NSLog(@"Launched executable succcessfully");
    }
    else if ([[NSWorkspace sharedWorkspace] launchApplication:path])
	{
        NSLog(@"Launched app succcessfully");
    }
	else
	{
        NSLog(@"Failed to launch");
    }
	
    [[NSApplication sharedApplication] terminate:self];
}

@end
