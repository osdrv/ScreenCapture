//
//  StorageManager.m
//  ScreenCapture
//
//  Created by Olegs on 28/09/14.
//  Copyright (c) 2014 Brand New Heroes. All rights reserved.
//

#import "StorageManager.h"
#import "StorageAgent.h"

@implementation StorageManager

-(id)initWithOptions:(NSHashTable *)options {
    
    if (self = [super init]) {
        // @TODO: Init agents
        NSDictionary * agents = [options valueForKey:@"Agents"];
        [self initAgentPoolWithOptions:agents];
    }
    
    return self;
}

-(int)storeFile:(FILE *)filePtr {
    // @TODO: implement me!
    
    return 0;
}

-(void)initAgentPoolWithOptions:(NSDictionary*)options {
    self->storageAgents = [[NSMutableArray alloc] init];
    for (NSString * className in options) {
        NSDictionary * agentOptions = [options valueForKey:className];
        Class klass = NSClassFromString(className);
        id<StorageAgent> agent = [[klass alloc] initAgentWithOptions:agentOptions];
        [self->storageAgents addObject:agent];
    }
}

@end
