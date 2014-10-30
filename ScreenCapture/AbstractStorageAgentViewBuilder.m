//
//  AbstractStorageAgentViewBuilder.m
//  ScreenCapture
//
//  Created by Olegs on 30/10/14.
//  Copyright (c) 2014 Brand New Heroes. All rights reserved.
//

#import "AbstractStorageAgentViewBuilder.h"

@implementation AbstractStorageAgentViewBuilder

- (id) initWithStorageAgent:(GenericStorageAgent *)agent {
    if (self = [super init]) {
        self->storageAgent = agent;
    }
    
    return self;
}

- (NSView *)buildViewForManagedObject:(NSManagedObject *)item {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

@end
