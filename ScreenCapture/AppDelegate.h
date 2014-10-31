//
//  AppDelegate.h
//  ScreenCapture
//
//  Created by Olegs on 28/09/14.
//  Copyright (c) 2014 Brand New Heroes. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "StorageManager.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, NSUserNotificationCenterDelegate > {
    @protected
    StorageManager *storageManager;
    NSMutableArray *screenshotMenuItems;
    NSImage *defaultMenuIcon;
    NSImage *loadingMenuIcon;
}

@property (readwrite, retain) IBOutlet NSMenu *menu;
@property (readwrite, retain) IBOutlet NSStatusItem *statusItem;
@property (readwrite, retain) IBOutlet NSMenuItem *anchorMenuItem;

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (IBAction)screenshotAction:(id)sender;
- (IBAction)quitAction:(id)sender;

- (void)saveDBData;
- (void)showNotification:(NSString*)screenshot;
- (void)saveToClipboard:(NSString*)url;
- (void)registerGlobalHotKey;

@end

