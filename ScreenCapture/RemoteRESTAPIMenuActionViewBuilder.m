//
//  RemoteRESTAPIMenuActionViewBuilder.m
//  ScreenCapture
//
//  Created by Olegs on 30/10/14.
//  Copyright (c) 2014 Brand New Heroes. All rights reserved.
//

#import "RemoteRESTAPIMenuActionViewBuilder.h"

@implementation RemoteRESTAPIMenuActionViewBuilder

- (NSMenuItem *)buildViewForManagedObject:(PrimaryStorageItem *)item {
    
    RemoteRESTAPIStorageItem *restItem = item.remote_rest_api_storage_item;
    
    NSString *host = [((RemoteRESTAPIStorageAgent*)storageAgent) optionForKey:@"Host"];
    NSMenuItem *menuItem;
    
    if (restItem != NULL) {
        if ([restItem.status intValue] == REMOTE_REST_API_STATUS_OK) {
            menuItem = [[NSMenuItem alloc] initWithTitle:[NSString stringWithFormat:@"Copy %@ share url", host] action:@selector(copyShareURL:) keyEquivalent:@""];
        } else {
            menuItem = [[NSMenuItem alloc] initWithTitle:[NSString stringWithFormat:@"Reupload file to %@", host] action:@selector(reuploadFile:) keyEquivalent:@""];
        }
    } else {
        menuItem = [[NSMenuItem alloc] initWithTitle:[NSString stringWithFormat:@"Upload file to %@", host] action:@selector(uploadFile:) keyEquivalent:@""];
    }
    
    [menuItem setTarget:(RemoteRESTAPIStorageAgent*)storageAgent];
    [menuItem setRepresentedObject:restItem];
    
    return menuItem;
}

@end