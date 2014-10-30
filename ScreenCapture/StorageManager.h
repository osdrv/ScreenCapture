//
//  StorageManager.h
//  ScreenCapture
//
//  Created by Olegs on 28/09/14.
//  Copyright (c) 2014 Brand New Heroes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PromiseKit.h>
#import "Screenshot.h"
#import "PrimaryStorageItem.h"

@interface StorageManager : NSObject {
    NSMutableArray *storageAgents;
}

- (id)initWithOptions:(NSDictionary *)options;

- (PMKPromise *)store:(Screenshot *)screenshot;

- (NSArray *)buildMenuActionListViews:(NSManagedObject *)managedObject;

@end
