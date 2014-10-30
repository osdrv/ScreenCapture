//
//  DropBoxStorageAgent+ViewBuilder.m
//  ScreenCapture
//
//  Created by Olegs on 30/10/14.
//  Copyright (c) 2014 Brand New Heroes. All rights reserved.
//

#import "DropBoxStorageAgent+ViewBuilder.h"

@implementation DropBoxStorageAgent (ViewBuilder)

- (AbstractStorageAgentViewBuilder *)getMenuItemViewBuilder {
    return [[DropBoxMenuActionViewBuilder alloc] initWithStorageAgent:self];
}

- (DropBoxStorageItem *)getDBItemFromRepresentedObject:(id)sender {
    DropBoxStorageItem *dbItem = (DropBoxStorageItem *)[(NSMenuItem*)sender representedObject];
    if (!dbItem) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:[NSString stringWithFormat:@"Dropbox item is empty for the menu item: %@", NSStringFromSelector(_cmd)]
                                     userInfo:nil];
    } else {
        return dbItem;
    }
}

- (void)copyShareURL:(id)sender {
    DropBoxStorageItem *dbItem = [self getDBItemFromRepresentedObject:sender];
    NSString *shareURL = dbItem.url;
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
