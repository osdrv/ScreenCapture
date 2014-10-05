//
//  GenericStorageAgent.m
//  ScreenCapture
//
//  Created by Olegs on 05/10/14.
//  Copyright (c) 2014 Brand New Heroes. All rights reserved.
//

#import "GenericStorageAgent.h"

@implementation GenericStorageAgent

- (id)initAgentWithOptions:(NSDictionary *)options_ {
    
    if (self = [super init]) {
        self->options = options_;
        [self setEnabled:(BOOL)[options_ valueForKey:@"Enabled"]];
        NSLog(@"%@", self->options);
    }
    
    return self;
}

- (BOOL) enabled {
    return self->enabled;
}

- (void)setEnabled:(BOOL)enabled_ {
    self->enabled = enabled_;
}

- (BOOL)canStoreFile:(NSFileHandle *)file {
    return YES;
}

- (PMKPromise *)storeFile:(NSFileHandleWithName *)inputFile {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (PMKPromise *)proceed:(id)arg {
    return [self storeFile:arg];
}

- (NSString *)generateFilenameYYYYMMDDHHIISS:(NSFileHandleWithName *)file {
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    //@TODO: fix .png here
    NSString *fileName = [NSString stringWithFormat:@"%@.png", [dateFormatter stringFromDate:[NSDate date]]];
    return fileName;
}

@end
