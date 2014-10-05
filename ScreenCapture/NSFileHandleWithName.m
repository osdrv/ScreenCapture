//
//  NSFileHandleWithName.m
//  ScreenCapture
//
//  Created by Olegs on 05/10/14.
//  Copyright (c) 2014 Brand New Heroes. All rights reserved.
//

#import "NSFileHandleWithName.h"

@implementation NSFileHandleWithName

@synthesize fileHandle;
@synthesize fileName;

- (id) initWithFileHandle:(NSFileHandle *)fileHandle_ andFilename:(NSString *)fileName_ {
    if (self = [super init]) {
        self->fileHandle = fileHandle_;
        self->fileName   = fileName_;
    }
    
    return self;
}

@end
