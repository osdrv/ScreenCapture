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
    NSMenuItem *menuItem = [[NSMenuItem alloc] init];
    menuItem.title = @"Reveal in Finder";
    
    return menuItem;
}

@end
