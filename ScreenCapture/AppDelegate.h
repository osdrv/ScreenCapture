//
//  AppDelegate.h
//  ScreenCapture
//
//  Created by Olegs on 28/09/14.
//  Copyright (c) 2014 Brand New Heroes. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "StorageManager.h"

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    @protected
    StorageManager * storageManager;
}

@property (readwrite, retain) IBOutlet NSMenu *menu;
@property (readwrite, retain) IBOutlet NSStatusItem *statusItem;
//@property (readwrite, retain) IBOutlet NSStatusItem *screenshotStatusItem;
//@property (readwrite, retain) IBOutlet NSStatusItem *quitStatusItem;

- (IBAction)screenshotAction:(id)sender;
- (IBAction)quitAction:(id)sender;

@end

