//
//  GenericStorageAgent+ViewBuilder.m
//  ScreenCapture
//
//  Created by Olegs on 30/10/14.
//  Copyright (c) 2014 Brand New Heroes. All rights reserved.
//

#import "GenericStorageAgent+ViewBuilder.h"

@implementation GenericStorageAgent (ViewBuilder)

- (NSView *)buildActionView:(id)managedObject withBuilder:(AbstractStorageAgentViewBuilder *)builder {
    return [builder buildViewForManagedObject:managedObject];
}

- (AbstractStorageAgentViewBuilder *)getMenuItemViewBuilder {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (BOOL)hasMenuAction {
    return (BOOL)([options valueForKey:@"HasMenuAction"]) || NO;
}

@end
