//
//  DropBoxMenuActionViewBuilder.m
//  ScreenCapture
//
//  Created by Olegs on 30/10/14.
//  Copyright (c) 2014 Brand New Heroes. All rights reserved.
//

#import "DropBoxMenuActionViewBuilder.h"

@implementation DropBoxMenuActionViewBuilder

- (NSMenuItem *)buildViewForManagedObject:(PrimaryStorageItem *)item {
    
    DropBoxStorageItem *dbItem = item.dropbox_storage_item;
    
    NSString *host = @"Dropbox";
    NSMenuItem *menuItem;
    
    if (dbItem != NULL) {
        if ([dbItem.status intValue] == DROP_BOX_STATUS_OK) {
            menuItem = [[NSMenuItem alloc] initWithTitle:[NSString stringWithFormat:@"Copy %@ share url", host] action:@selector(copyShareURL:) keyEquivalent:@""];
        } else {
            menuItem = [[NSMenuItem alloc] initWithTitle:[NSString stringWithFormat:@"Reupload file to %@", host] action:@selector(reuploadFile:) keyEquivalent:@""];
        }
    } else {
        menuItem = [[NSMenuItem alloc] initWithTitle:[NSString stringWithFormat:@"Upload file to %@", host] action:@selector(uploadFile:) keyEquivalent:@""];
    }
    
    [menuItem setTarget:(DropBoxStorageAgent*)storageAgent];
    [menuItem setRepresentedObject:dbItem];
    
    return menuItem;
}

@end
