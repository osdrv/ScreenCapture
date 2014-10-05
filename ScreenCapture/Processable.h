//
//  Processable.h
//  ScreenCapture
//
//  Created by Olegs on 30/09/14.
//  Copyright (c) 2014 Brand New Heroes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PromiseKit.h>

@protocol Processable <NSObject>

@required

- (PMKPromise *)proceed:(id)arg;

@end

