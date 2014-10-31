//
//  RemoteRESTAPIStorageAgent.h
//  ScreenCapture
//
//  Created by Olegs on 05/10/14.
//  Copyright (c) 2014 Brand New Heroes. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "GenericStorageAgent.h"
#import "RemoteJSRESTAPIStorageItem.h"

@interface RemoteJSRESTAPIStorageAgent : GenericStorageAgent

#define REMOTE_JS_REST_API_STATUS_OK       1
#define REMOTE_JS_REST_API_STATUS_FAILURE  0

@end
