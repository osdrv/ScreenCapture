//
//  RemoteJSRESTAPIMenuActionViewBuilder.m
//  ScreenCapture
//
//  Created by Olegs on 31/10/14.
//  Copyright (c) 2014 Brand New Heroes. All rights reserved.
//

#import "RemoteJSRESTAPIMenuActionViewBuilder.h"

@implementation RemoteJSRESTAPIMenuActionViewBuilder

- (NSMenuItem *)buildViewForManagedObject:(PrimaryStorageItem *)item {
    
    RemoteJSRESTAPIStorageItem *restItem = item.remote_js_rest_api_storage_item;
    
    RemoteJSRESTAPIStorageAgent* storageAgent_ = (RemoteJSRESTAPIStorageAgent*)storageAgent;
    
    NSString *host = [storageAgent_ optionForKey:@"LabelHost"];
    NSMenuItem *menuItem;
    
    if (restItem != NULL) {
        if ([restItem.status intValue] == REMOTE_JS_REST_API_STATUS_OK) {
            menuItem = [[NSMenuItem alloc] initWithTitle:[NSString stringWithFormat:@"Copy %@ share url", host] action:@selector(copyShareURL:) keyEquivalent:@""];
        } else {
            menuItem = [[NSMenuItem alloc] initWithTitle:[NSString stringWithFormat:@"Reupload file to %@", host] action:@selector(reuploadFile:) keyEquivalent:@""];
        }
    } else {
        menuItem = [[NSMenuItem alloc] initWithTitle:[NSString stringWithFormat:@"Upload file to %@", host] action:@selector(uploadFile:) keyEquivalent:@""];
    }
    
    [menuItem setTarget:(RemoteJSRESTAPIStorageAgent*)storageAgent];
    [menuItem setRepresentedObject:restItem];
    
    return menuItem;
}

@end
