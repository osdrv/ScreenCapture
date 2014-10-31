//
//  RemoteJSRESTAPIStorageAgent+ViewBuilder.h
//  ScreenCapture
//
//  Created by Olegs on 31/10/14.
//  Copyright (c) 2014 Brand New Heroes. All rights reserved.
//

#import "RemoteJSRESTAPIStorageAgent.h"
#import "AbstractStorageAgentViewBuilder.h"
#import "RemoteJSRESTAPIMenuActionViewBuilder.h"
#import "RemoteJSRESTAPIStorageItem.h"

@interface RemoteJSRESTAPIStorageAgent (ViewBuilder)

- (void)copyShareURL:(id)sender;
- (void)uploadFile:(id)sender;
- (void)reuploadFile:(id)sender;

@end
