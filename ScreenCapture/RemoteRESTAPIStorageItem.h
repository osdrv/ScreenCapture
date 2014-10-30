//
//  RemoteRESTAPIStorage.h
//  ScreenCapture
//
//  Created by Olegs on 29/10/14.
//  Copyright (c) 2014 Brand New Heroes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface RemoteRESTAPIStorageItem : NSManagedObject

@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSManagedObject *primary_storage_items;

@end
