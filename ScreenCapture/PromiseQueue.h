//
//  PromiseQueue.h
//  ScreenCapture
//
//  Created by Olegs on 30/09/14.
//  Copyright (c) 2014 Brand New Heroes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PromiseKit/Promise.h>
#import "Processable.h"

@interface PromiseQueue : NSObject <Processable> {
    NSMutableArray *processables;
}

- (id)initWithDeferreds:(NSArray *)processables_;

@end
