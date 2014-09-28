//
//  StorageAgent.h
//  ScreenCapture
//
//  Created by Olegs on 28/09/14.
//  Copyright (c) 2014 Brand New Heroes. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol StorageAgent <NSObject>

@required

-(BOOL)enabled;

-(void)setEnabled:(BOOL)enabled_;

-(id)initAgentWithOptions:(NSDictionary*)options;

-(BOOL)canStoreFile:(FILE*)file;

-(void)storeFile:(FILE*)file withCallback:(void( ^ )(NSData*))callback;

@end
