//
//  StorageManager.m
//  ScreenCapture
//
//  Created by Olegs on 28/09/14.
//  Copyright (c) 2014 Brand New Heroes. All rights reserved.
//

#import "StorageManager.h"
#import "PromiseQueue.h"
#import "PrimaryStorageAgent.h"
#import "GenericStorageAgent.h"
#import "GenericStorageAgent+ViewBuilder.h"

@implementation StorageManager

- (id)initWithOptions:(NSHashTable *)options {
    
    if (self = [super init]) {
        NSDictionary * agents = [options valueForKey:@"Agents"];
        [self initAgentPoolWithOptions:agents];
    }
    
    return self;
}

- (PMKPromise *)store:(Screenshot *)screenshot {
    
    NSMutableArray *activeAgents = [[NSMutableArray alloc] init];
    
    for (GenericStorageAgent *agent in self->storageAgents) {
        if (![agent enabled]) continue;
        [activeAgents addObject:agent];
    }
    
    NSLog(@"Store file called, %@", activeAgents);
    
    PromiseQueue *pqueue = [[PromiseQueue alloc] initWithDeferreds:activeAgents];
    
    return [pqueue proceed:screenshot];
}

- (void)initAgentPoolWithOptions:(NSDictionary *)options {
    
    self->storageAgents = [[NSMutableArray alloc] init];
    
    [self->storageAgents addObject:[[PrimaryStorageAgent alloc] init]];
    
    for (NSString * className in options) {
        NSDictionary * agentOptions = [options valueForKey:className];
        if ((BOOL)[agentOptions valueForKey:@"Enabled"]) {
            Class klass = NSClassFromString(className);
            GenericStorageAgent *agent = [[klass alloc] initAgentWithOptions:agentOptions];
            [self->storageAgents addObject:agent];
        }
    }
}

- (NSArray *)buildMenuActionListViews:(NSManagedObject *)managedObject {
    NSMutableArray *actionList = [[NSMutableArray alloc] init];
    
    for (GenericStorageAgent *agent in self->storageAgents) {
        if (![agent enabled] || ![agent hasMenuAction]) continue;
        NSView *menuItem = [agent buildActionView:managedObject withBuilder:[agent getMenuItemViewBuilder]];
        if (menuItem == NULL) continue;
        [actionList addObject:menuItem];
    }
    
    return actionList;
}

@end
