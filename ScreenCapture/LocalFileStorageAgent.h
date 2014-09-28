//
//  LocalFileStorageAgent.h
//  ScreenCapture
//
//  Created by Olegs on 28/09/14.
//  Copyright (c) 2014 Brand New Heroes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StorageAgent.h"

@interface LocalFileStorageAgent : NSObject <StorageAgent> {
    @protected
    NSDictionary *options;
}

@end
