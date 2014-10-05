//
//  StorageAgent.h
//  ScreenCapture
//
//  Created by Olegs on 28/09/14.
//  Copyright (c) 2014 Brand New Heroes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PromiseKit.h>
#import "Processable.h"
#import "Screenshot.h"

@protocol StorageAgent <NSObject, Processable>

@required

- (BOOL)enabled;

- (void)setEnabled:(BOOL)enabled_;

- (id)initAgentWithOptions:(NSDictionary *)options;

- (BOOL)canStoreFile:(Screenshot *)screenshot;

- (PMKPromise *)store:(Screenshot *)screenshot;

@end
