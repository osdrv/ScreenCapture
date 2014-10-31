//
//  AppDelegate.m
//  ScreenCapture
//
//  Created by Olegs on 28/09/14.
//  Copyright (c) 2014 Brand New Heroes. All rights reserved.
//

#import "AppDelegate.h"
#import <Carbon/Carbon.h>
#import <PromiseKit/NSTask+PromiseKit.h>
#import "Screenshot.h"
#import "PrimaryStorageItem.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize managedObjectModel         = _managedObjectModel;
@synthesize managedObjectContext       = _managedObjectContext;

const int FETCH_LIMIT                  = 10;
const int MAKE_SCREENSHOT_SHORTKEY_ID  = 1;

- (IBAction)screenshotAction:(id)sender {
    [self makeScreenshot];
}

- (IBAction)quitAction:(id)sender {
    exit(0);
}

- (id)init {
    if (self = [super init]) {
        [self initStorageManager];
        self->screenshotMenuItems = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)awakeFromNib {
    _statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    defaultMenuIcon        = [NSImage imageNamed:@"Menu icon"];
    loadingMenuIcon        = [NSImage imageNamed:@"Loading icon"];
    NSImage *highlightIcon = [NSImage imageNamed:@"Menu icon"];
    [highlightIcon setTemplate:YES];
    [[self statusItem] setImage:defaultMenuIcon];
    [[self statusItem] setAlternateImage:highlightIcon];
    [[self statusItem] setMenu:[self menu]];
    [[self statusItem] setHighlightMode:YES];
    [self resetLastScreenshotList];
    [self registerGlobalHotKey];
}

- (void)registerGlobalHotKey {
    EventHotKeyRef gMyHotKeyRef;
    EventHotKeyID  gMyHotKeyID;
    EventTypeSpec  eventType;
    eventType.eventClass = kEventClassKeyboard;
    eventType.eventKind  = kEventHotKeyPressed;

    InstallApplicationEventHandler(&OnHotKeyEvent, 1, &eventType, (__bridge void*)self, NULL);
    gMyHotKeyID.signature = 'htk1';
    gMyHotKeyID.id        = MAKE_SCREENSHOT_SHORTKEY_ID;
    RegisterEventHotKey(kVK_ANSI_E, cmdKey + shiftKey, gMyHotKeyID, GetApplicationEventTarget(), 0, &gMyHotKeyRef);
}

OSStatus OnHotKeyEvent(EventHandlerCallRef nextHandler,EventRef theEvent,void *userData) {
    EventHotKeyID hkCom;
    
    GetEventParameter(theEvent, kEventParamDirectObject, typeEventHotKeyID, NULL, sizeof(hkCom), NULL, &hkCom);
    int hotkeyId = hkCom.id;
    AppDelegate *appDelegate = (__bridge AppDelegate *)userData;
    
    switch (hotkeyId) {
        case MAKE_SCREENSHOT_SHORTKEY_ID:
            [appDelegate makeScreenshot];
            break;
    }
    
    return noErr;
}


- (void)resetLastScreenshotList {
    
    [self.menu setAutoenablesItems:YES];
    
    // 1. load existing screenshots from DB
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"PrimaryStorageItem"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]];
    request.fetchLimit = FETCH_LIMIT;
    NSArray *primaryStorageItems = [self.managedObjectContext executeFetchRequest:request error:NULL];
    
    // 2. clean up existing menu
    
    if (primaryStorageItems.count) {
        self.anchorMenuItem.title = @"Recent screenshots";
    } else {
        self.anchorMenuItem.title = @"No recent screenshots";
    }
    
    for (NSMenuItem *menuItem in screenshotMenuItems) {
        [self.menu removeItem:menuItem];
    }
    
    [screenshotMenuItems removeAllObjects];
    
    NSInteger anchorIndex = [self.menu indexOfItem:self.anchorMenuItem];
    
    // 4. insert new items in the menu

    for (PrimaryStorageItem *item in primaryStorageItems) {
        NSMenuItem *menuItem = [self buildScreenshotMenuItem:item];
        [screenshotMenuItems addObject:menuItem];
        [self.menu insertItem:menuItem atIndex:(++anchorIndex)];
    }
    
}

-(NSMenuItem *)buildScreenshotMenuItem:(PrimaryStorageItem *)item {
    
    NSMenuItem *menuItem = [[NSMenuItem alloc] init];
    menuItem.title = item.name;
    
    NSArray *submenuItems = [storageManager buildMenuActionListViews:item];
    NSMenu *subMenu = [[NSMenu alloc] init];
    [subMenu setAutoenablesItems:YES];
    
    for (NSMenuItem *subMenuItem in submenuItems) {
        [subMenu addItem:subMenuItem];
    }
    
    [menuItem setSubmenu:subMenu];
    
    return menuItem;
}

- (void)makeScreenshot {
    NSTask   *screenCapture = [[NSTask alloc] init];
    NSString *imageFormat = @"png";
    NSString *tmpDir = NSTemporaryDirectory();
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
    
    [self managedObjectContext];
    
    [screenCapture promise].then(^(NSData *data) {
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:fileName];
        if (fileHandle != NULL) {
            [[self statusItem] setImage:loadingMenuIcon];
            
            Screenshot *screenshot = [[Screenshot alloc] init];
            [screenshot setValue:fileHandle
                          forKey:@"Handle" inDomain:@"Generic"];
            [screenshot setValue:fileName forKey:@"TmpName" inDomain:@"Generic"];
            [screenshot setValue:self.managedObjectContext forKey:@"Context" inDomain:@"DB"];
            
            [self storeFile:screenshot].then(^(NSData *data) {
                [self saveDBData];
                [self resetLastScreenshotList];
                NSString* url = [screenshot valueForKey:@"URL" inDomain: [self->storageManager getPrincipalAgent]];
                [self saveToClipboard: url];
                [self showNotification: url];
                [[self statusItem] setImage:defaultMenuIcon];
            });
        }
    }).catch(^(NSError *error) {
        // @TODO: Handle screencapture error
    });
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [[NSUserNotificationCenter defaultUserNotificationCenter] setDelegate:self];
}

- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center
     shouldPresentNotification:(NSUserNotification *)notification {
    return YES;
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
    [self saveDBData];
}

- (void)initStorageManager {
    NSDictionary * options = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"StorageAgents" ofType:@"plist"]];
    self->storageManager = [[StorageManager alloc] initWithOptions:options];
}

- (NSString *)mkTmpFileWithTmpl:(NSString *)fileTmpl {
    char * tmpFile = mktemp((char*)[fileTmpl UTF8String]);
    // @TODO: handle possible error here
    return [NSString stringWithFormat:@"%s", tmpFile];
}

- (PMKPromise *)storeFile:(Screenshot *)screenshot {
    return [self->storageManager store:screenshot];
}

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "brandnewheroes.com.TestCoreData" in the user's Application Support directory.
    NSURL *appSupportURL = [[[NSFileManager defaultManager] URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject];
    return [appSupportURL URLByAppendingPathComponent:@"brandnewheroes.com.TestCoreData"];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel) {
        return _managedObjectModel;
    }
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    
    NSLog(@"%@", [modelURL absoluteString]);
    
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. (The directory for the store is created, if necessary.)
    if (_persistentStoreCoordinator) {
        return _persistentStoreCoordinator;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *applicationDocumentsDirectory = [self applicationDocumentsDirectory];
    BOOL shouldFail = NO;
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    
    // Make sure the application files directory is there
    NSDictionary *properties = [applicationDocumentsDirectory resourceValuesForKeys:@[NSURLIsDirectoryKey] error:&error];
    if (properties) {
        if (![properties[NSURLIsDirectoryKey] boolValue]) {
            failureReason = [NSString stringWithFormat:@"Expected a folder to store application data, found a file (%@).", [applicationDocumentsDirectory path]];
            shouldFail = YES;
        }
    } else if ([error code] == NSFileReadNoSuchFileError) {
        error = nil;
        [fileManager createDirectoryAtPath:[applicationDocumentsDirectory path] withIntermediateDirectories:YES attributes:nil error:&error];
    }
    
    if (!shouldFail && !error) {
        NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
        NSURL *url = [applicationDocumentsDirectory URLByAppendingPathComponent:@"OSXCoreDataObjC.storedata"];
        NSLog(@"%@", [url absoluteString]);
        if (![coordinator addPersistentStoreWithType:NSXMLStoreType configuration:nil URL:url options:nil error:&error]) {
            coordinator = nil;
        }
        _persistentStoreCoordinator = coordinator;
    }
    
    if (shouldFail || error) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        if (error) {
            dict[NSUnderlyingErrorKey] = error;
        }
        error = [NSError errorWithDomain:@"ScreenCapture" code:9999 userInfo:dict];
        [[NSApplication sharedApplication] presentError:error];
    }
    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    
    return _managedObjectContext;
}

- (void)saveDBData {
    // Performs the save action for the application, which is to send the save: message to the application's managed object context. Any encountered errors are presented to the user.
    if (![[self managedObjectContext] commitEditing]) {
        NSLog(@"%@:%@ unable to commit editing before saving", [self class], NSStringFromSelector(_cmd));
    }
    
    NSError *error = nil;
    if ([[self managedObjectContext] hasChanges] && ![[self managedObjectContext] save:&error]) {
        [[NSApplication sharedApplication] presentError:error];
    }
    
    NSLog(@"Done saving to the DB");
}

- (void)showNotification:(NSString*)url {
    NSUserNotification *notification = [[NSUserNotification alloc] init];
    [notification setTitle:@"The share URL has been copied"];
    [notification setInformativeText: url];
    [notification setSoundName:NSUserNotificationDefaultSoundName];
    [[NSUserNotificationCenter defaultUserNotificationCenter] scheduleNotification:notification];
}

- (void)saveToClipboard:(NSString*)url {
    NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
    [pasteboard clearContents];
    [pasteboard setString:url forType:NSStringPboardType];
}
@end
