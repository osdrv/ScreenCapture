//
//  RemoteRESTAPIStorageAgent+ViewBuilder.m
//  ScreenCapture
//
//  Created by Olegs on 30/10/14.
//  Copyright (c) 2014 Brand New Heroes. All rights reserved.
//

#import "RemoteRESTAPIStorageAgent+ViewBuilder.h"

@implementation RemoteRESTAPIStorageAgent (ViewBuilder)

- (AbstractStorageAgentViewBuilder *)getMenuItemViewBuilder {
    return [[RemoteRESTAPIMenuActionViewBuilder alloc] initWithStorageAgent:self];
}

- (RemoteRESTAPIStorageItem *)getRESTItemFromRepresentedObject:(id)sender {
    RemoteRESTAPIStorageItem *restItem = (RemoteRESTAPIStorageItem *)[(NSMenuItem*)sender representedObject];
    if (!restItem) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:[NSString stringWithFormat:@"REST item is empty for the menu item: %@", NSStringFromSelector(_cmd)]
                                     userInfo:nil];
    } else {
        return restItem;
    }
}

- (void)copyShareURL:(id)sender {
    RemoteRESTAPIStorageItem *restItem = [self getRESTItemFromRepresentedObject:sender];
    NSString *shareURL = restItem.url;
    NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
    [pasteboard declareTypes:[NSArray arrayWithObject:NSStringPboardType] owner:nil];
    [pasteboard setString:shareURL forType:NSStringPboardType];
}

- (void)uploadFile:(id)sender {

    // TODO: implement me!
    
//    RemoteRESTAPIStorageItem *restItem = [self getRESTItemFromRepresentedObject:sender];
//    PrimaryStorageItem *primaryItem = restItem.primary_storage_item;
//    
//    if (!primaryItem) {
//        @throw [NSException exceptionWithName:NSInternalInconsistencyException
//                                       reason:[NSString stringWithFormat:@"Can not retrieve primary item from REST item: %@", NSStringFromSelector(_cmd)]
//                                     userInfo:nil];
//    }
    
//    NSFileHandle *fileHandle = 
//    Screenshot *screenshot = [[Screenshot alloc] init];
//    [screenshot setValue:fileHandle
//                  forKey:@"Handle" inDomain:@"Generic"];
//    [screenshot setValue:fileName forKey:@"TmpName" inDomain:@"Generic"];
//    [screenshot setValue:self.managedObjectContext forKey:@"Context" inDomain:@"DB"];
}

- (void)reuploadFile:(id)sender {
    [self uploadFile:sender];
}

@end
