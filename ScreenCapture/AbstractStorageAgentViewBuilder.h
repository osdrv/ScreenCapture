//
//  AbstractStorageAgentViewBuilder.h
//  ScreenCapture
//
//  Created by Olegs on 30/10/14.
//  Copyright (c) 2014 Brand New Heroes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/NSManagedObject.h>
#import "GenericStorageAgent.h"

@interface AbstractStorageAgentViewBuilder : NSObject {
    GenericStorageAgent *storageAgent;
}

- (id)initWithStorageAgent:(GenericStorageAgent *)agent;

- (NSView *)buildViewForManagedObject:(NSManagedObject *)item;

@end
