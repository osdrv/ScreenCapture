//
//  DropBoxStorageAgent.h
//  ScreenCapture
//
//  Created by Olegs on 05/10/14.
//  Copyright (c) 2014 Brand New Heroes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GenericStorageAgent.h"
#import <DropboxOSX/DropboxOSX.h>
#import "PrimaryStorageItem.h"
#import "DropBoxStorageItem.h"

#define DROP_BOX_STATUS_OK       1
#define DROP_BOX_STATUS_FAILURE  0

@interface DropBoxStorageAgent : GenericStorageAgent <DBRestClientDelegate>

@property (nonatomic, strong) DBRestClient *restClient;

@end
