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


@end

