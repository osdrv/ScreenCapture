//
//  NSFileHandleWithName.h
//  ScreenCapture
//
//  Created by Olegs on 05/10/14.
//  Copyright (c) 2014 Brand New Heroes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileHandleWithName : NSObject

@property NSFileHandle *fileHandle;
@property NSString     *fileName;

- (id)initWithFileHandle:(NSFileHandle *)fileHandle_ andFilename:(NSString *)fileName_;

@end
