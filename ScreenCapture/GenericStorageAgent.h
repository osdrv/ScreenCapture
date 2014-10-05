//
//  GenericStorageAgent.h
//  ScreenCapture
//
//  Created by Olegs on 05/10/14.
//  Copyright (c) 2014 Brand New Heroes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StorageAgent.h"

@interface GenericStorageAgent : NSObject <StorageAgent> {
@protected
    NSDictionary *options;
    NSString *result;
    BOOL enabled;
    BOOL succeeded;
}

@end
