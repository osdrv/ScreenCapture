//
//  Screenshot.m
//  ScreenCapture
//
//  Created by Olegs on 05/10/14.
//  Copyright (c) 2014 Brand New Heroes. All rights reserved.
//

#import "Screenshot.h"

@implementation Screenshot

- (id)init {
    if (self = [super init]) {
        self->domains = [[NSMutableDictionary alloc] init];
        [self setValue:NO forKey:@"Empty" inDomain:@"Generic"];
    }
    
    return self;
}

- (void)setValue:(id)value forKey:(NSString *)key inDomain:(NSString *)domainName {
    NSMutableDictionary *domain = [self->domains valueForKey:domainName];
    if (domain == nil) {
        domain = [[NSMutableDictionary alloc] init];
        [self->domains setValue:domain forKey:domainName];
    }
    [domain setValue:value forKey:key];
}

- (id)valueForKey:(NSString *)key inDomain:(NSString *)domainName {
    NSMutableDictionary *domain;
    if ((domain = [self->domains valueForKey:domainName])) {
        return [domain valueForKey:key];
    } else {
        return NULL;
    }
}

@end
