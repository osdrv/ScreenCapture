//
//  PrimaryStorage.h
//  ScreenCapture
//
//  Created by Olegs on 29/10/14.
//  Copyright (c) 2014 Brand New Heroes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class RemoteRESTAPIStorageItem;
@class RemoteJSRESTAPIStorageItem;
@class DropBoxStorageItem;

@interface PrimaryStorageItem : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) RemoteRESTAPIStorageItem *remote_rest_api_storage_item;
@property (nonatomic, retain) RemoteJSRESTAPIStorageItem *remote_js_rest_api_storage_item;
@property (nonatomic, retain) DropBoxStorageItem *dropbox_storage_item;


@end
