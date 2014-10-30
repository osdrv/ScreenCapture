//
//  LocalFileStorageAgent+ViewBuilder.m
//  ScreenCapture
//
//  Created by Olegs on 30/10/14.
//  Copyright (c) 2014 Brand New Heroes. All rights reserved.
//

#import "LocalFileStorageAgent+ViewBuilder.h"
#import "LocalFileMenuActionViewBuilder.h"

@implementation LocalFileStorageAgent (ViewBuilder)

- (AbstractStorageAgentViewBuilder *)getMenuItemViewBuilder {
    return [[LocalFileMenuActionViewBuilder alloc] initWithStorageAgent:self];
}

- (void)revealInFinder:(id)sender {
    PrimaryStorageItem *item = (PrimaryStorageItem *)[(NSMenuItem*)sender representedObject];
    NSString *filePath = [self filePathFor:item.name];
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    NSArray *fileURLs = [NSArray arrayWithObjects:fileURL, nil];
    [[NSWorkspace sharedWorkspace] activateFileViewerSelectingURLs:fileURLs];
}

@end
