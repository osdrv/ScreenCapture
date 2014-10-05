//
//  StorageManager.m
//  ScreenCapture
//
//  Created by Olegs on 28/09/14.
//  Copyright (c) 2014 Brand New Heroes. All rights reserved.
//

#import "StorageManager.h"
#import "StorageAgent.h"
#import "PromiseQueue.h"

@implementation StorageManager

- (id)initWithOptions:(NSHashTable *)options {
    
    if (self = [super init]) {
        NSDictionary * agents = [options valueForKey:@"Agents"];
        [self initAgentPoolWithOptions:agents];
    }
    
    return self;
}

- (PMKPromise *)storeFile:(NSFileHandle *)filePtr {
    NSMutableArray *activeAgents = [[NSMutableArray alloc] init];
    for (id<StorageAgent> agent in self->storageAgents) {
        if (![agent enabled]) continue;
        [activeAgents addObject:agent];
    }
    NSLog(@"Store file called, %@", activeAgents);
    PromiseQueue *pqueue = [[PromiseQueue alloc] initWithDeferreds:activeAgents];
    return [pqueue proceed:filePtr];
}

- (void)initAgentPoolWithOptions:(NSDictionary *)options {
    self->storageAgents = [[NSMutableArray alloc] init];
    for (NSString * className in options) {
        NSDictionary * agentOptions = [options valueForKey:className];
        Class klass = NSClassFromString(className);
        id<StorageAgent> agent = [[klass alloc] initAgentWithOptions:agentOptions];
        [self->storageAgents addObject:agent];
    }
}

@end
