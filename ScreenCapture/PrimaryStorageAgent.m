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
#import <CoreData/CoreData.h>
#import "PrimaryStorageItem.h"

@implementation PrimaryStorageAgent

- (id)init {
    
    if (self = [super init]) {
        self->options = [[NSDictionary alloc] init];
    }
    
    return self;
}

- (PMKPromise *)store:(Screenshot *)screenshot_ {
    return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
        NSString *yyyymmddName = [self generateFilenameYYYYMMDDHHIISS:screenshot_];
        [screenshot_ setValue:yyyymmddName forKey:@"FileName" inDomain:@"Generic"];
        
        NSManagedObjectContext *context = [screenshot_ valueForKey:@"Context" inDomain:@"DB"];
        
        @try {
            PrimaryStorageItem *item = [NSEntityDescription insertNewObjectForEntityForName:@"PrimaryStorageItem" inManagedObjectContext:context];
            item.date = [NSDate date];
            item.name = yyyymmddName;
            [screenshot_ setValue:item forKey:@"PrimaryStorageItem" inDomain:@"DB"];
        }
        @catch (NSException *exception) {
            NSLog(@"%@", exception);
        }
        @finally {
            fulfill(screenshot_);
        }
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
