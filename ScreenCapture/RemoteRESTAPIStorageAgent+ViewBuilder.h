//
//  RemoteRESTAPIStorageAgent+ViewBuilder.h
//  ScreenCapture
//
//  Created by Olegs on 30/10/14.
//  Copyright (c) 2014 Brand New Heroes. All rights reserved.
//

#import "RemoteRESTAPIStorageAgent.h"
#import "RemoteRESTAPIMenuActionViewBuilder.h"

@interface RemoteRESTAPIStorageAgent (ViewBuilder)

- (void)copyShareURL:(id)sender;
- (void)uploadFile:(id)sender;
- (void)reuploadFile:(id)sender;

@end
