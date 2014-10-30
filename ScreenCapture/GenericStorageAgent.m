//
//  GenericStorageAgent.m
//  ScreenCapture
//
//  Created by Olegs on 05/10/14.
//  Copyright (c) 2014 Brand New Heroes. All rights reserved.
//

#import "GenericStorageAgent.h"
#import <AppKit/NSMenuItem.h>

@implementation GenericStorageAgent

- (id)initAgentWithOptions:(NSDictionary *)options_ {
    
    if (self = [super init]) {
        self->options = options_;
        [self setEnabled:(BOOL)[options_ valueForKey:@"Enabled"]];
        NSLog(@"%@", self->options);
    }
    
    return self;
}

- (id)optionForKey:(NSString *)key {
    return [self->options valueForKey:key];
}

- (BOOL) enabled {
    return self->enabled;
}

- (void)setEnabled:(BOOL)enabled_ {
    self->enabled = enabled_;
}

- (BOOL)canStoreFile:(Screenshot *)screenshot {
    return YES;
}

- (PMKPromise *)store:(Screenshot *)screenshot {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (PMKPromise *)proceed:(id)arg {
    return [self store:arg];
}

- (NSString *)generateFilenameYYYYMMDDHHIISS:(Screenshot *)screenshot {
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    //@TODO: fix .png here
    NSString *fileName = [NSString stringWithFormat:@"%@.png", [dateFormatter stringFromDate:[NSDate date]]];
    return fileName;
}

- (NSString *)getDomain {
    return NSStringFromClass([self class]);
}

@end
