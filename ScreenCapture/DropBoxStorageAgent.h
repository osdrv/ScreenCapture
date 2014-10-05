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

@interface DropBoxStorageAgent : GenericStorageAgent <DBRestClientDelegate>

@property (nonatomic, strong) DBRestClient *restClient;

@end
