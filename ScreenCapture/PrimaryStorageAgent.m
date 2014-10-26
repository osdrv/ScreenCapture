//
//  PrimaryStorageAgent.m
//  ScreenCapture
//
//  Created by Olegs on 07/10/14.
//  Copyright (c) 2014 Brand New Heroes. All rights reserved.
//

#import "PrimaryStorageAgent.h"
#import <Promise.h>
#import "Screenshot.h"

@implementation PrimaryStorageAgent

- (id)init {
    
    if (self = [super init]) {
        self->options = [[NSDictionary alloc] init];
    }
    
    return self;
}

- (PMKPromise *)store:(Screenshot *)screenshot_ {
    return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
        [screenshot_ setValue:[self generateFilenameYYYYMMDDHHIISS:screenshot_] forKey:@"FileName" inDomain:@"Generic"];
        fulfill(screenshot_);
    }];
}

- (BOOL) enabled {
    return YES;
}

- (void)setEnabled:(BOOL)enabled_ {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"PrimaryStorageAgent should never be disabled"
                                 userInfo:nil];
}

@end
