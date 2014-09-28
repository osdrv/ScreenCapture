//
//  LocalFileStorageAgent.m
//  ScreenCapture
//
//  Created by Olegs on 28/09/14.
//  Copyright (c) 2014 Brand New Heroes. All rights reserved.
//

#import "LocalFileStorageAgent.h"

@implementation LocalFileStorageAgent {
    BOOL enabled;
}

-(BOOL) enabled {
    return self->enabled;
}

-(void)setEnabled:(BOOL)enabled_ {
    self->enabled = enabled_;
}

-(id)initAgentWithOptions:(NSDictionary *)options_ {
    
    if (self = [super init]) {
        self->options = options_;
        NSLog(@"%@", self->options);
    }
    
    return self;
}

-(BOOL)canStoreFile:(FILE *)file {
    return YES;
}

-(void)storeFile:(FILE *)file withCallback:(void (^)(NSData *))callback {
    NSData * data = [NSData init];
    callback(data);
}

@end
