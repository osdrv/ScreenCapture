//
//  LocalFileMenuActionViewBuilder.m
//  ScreenCapture
//
//  Created by Olegs on 30/10/14.
//  Copyright (c) 2014 Brand New Heroes. All rights reserved.
//

#import "LocalFileMenuActionViewBuilder.h"

@implementation LocalFileMenuActionViewBuilder

- (NSMenuItem *)buildViewForManagedObject:(PrimaryStorageItem *)item {

    NSMenuItem *menuItem = [[NSMenuItem alloc] initWithTitle:@"Reveal in Finder" action:@selector(revealInFinder:) keyEquivalent:@""];
    [menuItem setTarget:(LocalFileStorageAgent*)storageAgent];
    [menuItem setRepresentedObject:item];

    return menuItem;
}

@end
