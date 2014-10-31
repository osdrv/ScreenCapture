//
//  RemoteJSRESTAPIStorageAgent+ViewBuilder.m
//  ScreenCapture
//
//  Created by Olegs on 31/10/14.
//  Copyright (c) 2014 Brand New Heroes. All rights reserved.
//

#import "RemoteJSRESTAPIStorageAgent+ViewBuilder.h"

@implementation RemoteJSRESTAPIStorageAgent (ViewBuilder)

- (AbstractStorageAgentViewBuilder *)getMenuItemViewBuilder {
    return [[RemoteJSRESTAPIMenuActionViewBuilder alloc] initWithStorageAgent:self];
}

- (RemoteJSRESTAPIStorageItem *)getJSRESTItemFromRepresentedObject:(id)sender {
    RemoteJSRESTAPIStorageItem *restItem = (RemoteJSRESTAPIStorageItem *)[(NSMenuItem*)sender representedObject];
    if (!restItem) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:[NSString stringWithFormat:@"REST item is empty for the menu item: %@", NSStringFromSelector(_cmd)]
                                     userInfo:nil];
    } else {
        return restItem;
    }
}

- (void)copyShareURL:(id)sender {
    RemoteJSRESTAPIStorageItem *restItem = [self getJSRESTItemFromRepresentedObject:sender];
    NSString *shareURL = restItem.url;
    NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
    [pasteboard declareTypes:[NSArray arrayWithObject:NSStringPboardType] owner:nil];
    [pasteboard setString:shareURL forType:NSStringPboardType];
}

- (void)uploadFile:(id)sender {
    // TODO: implement me!
}

- (void)reuploadFile:(id)sender {
    [self uploadFile:sender];
}


@end
