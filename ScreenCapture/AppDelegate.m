//
//  AppDelegate.m
//  ScreenCapture
//
//  Created by Olegs on 28/09/14.
//  Copyright (c) 2014 Brand New Heroes. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

-(id)init {
    if (self = [super init]) {
        [self initStorageManager];
    }
    
    return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application

    [self.window orderOut:self];
    
    
    NSTask *screenCapture = [[NSTask alloc] init];
    NSString *imageFormat = @"png";
    NSString * tmpDir = NSTemporaryDirectory();
    NSString *tmpFileTemplate = [NSString stringWithFormat:@"%@XXXXXX", tmpDir];
    
    NSString *fileName = [self mkTmpFileWithTmpl:tmpFileTemplate];
    
    NSArray *launchArguments = [NSArray arrayWithObjects:
                                @"-x", // No sound
                                @"-i", // Interactive mode: keyboard keys are supported
                                [NSString stringWithFormat:@"-t%@", imageFormat], // Image format
                                fileName,
                                nil
                                ];
    
    [screenCapture setLaunchPath:@"/usr/sbin/screencapture"];
    [screenCapture setArguments:launchArguments];
    
    // Launch screencapture app
    [screenCapture launch];
    [screenCapture waitUntilExit];
    
    // @TODO: make sure file exists and non-zero
    
    // Show hidden window
    [self.window makeKeyAndOrderFront:self];
    [NSApp activateIgnoringOtherApps:YES];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

-(void)initStorageManager {
    NSDictionary * options = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"StorageAgents" ofType:@"plist"]];
    self->storageManager = [[StorageManager alloc] initWithOptions:options];
}

- (NSString*)mkTmpFileWithTmpl:(NSString *)fileTmpl {
    char * tmpFile = mktemp((char*)[fileTmpl UTF8String]);
    // @TODO: handle possible error here
    return [NSString stringWithFormat:@"%s", tmpFile];
}

@end
