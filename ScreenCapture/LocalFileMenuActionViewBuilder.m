//
//  LocalFileMenuActionViewBuilder.m
//  ScreenCapture
//
//  Created by Olegs on 30/10/14.
//  Copyright (c) 2014 Brand New Heroes. All rights reserved.
//

#import "LocalFileMenuActionViewBuilder.h"

@implementation LocalFileMenuActionViewBuilder

- (NSMenu *)buildViewForManagedObject:(PrimaryStorageItem *)item {
    NSMenu *menu = [[NSMenu alloc] initWithTitle:@"Reveal in Finder"];
    return menu;
}

@end
