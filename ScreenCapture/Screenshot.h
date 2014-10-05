//
//  Screenshot.h
//  ScreenCapture
//
//  Created by Olegs on 05/10/14.
//  Copyright (c) 2014 Brand New Heroes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Screenshot : NSObject {
    NSMutableDictionary *domains;
}

- (void)setValue:(id)value forKey:(NSString *)key inDomain:(NSString *)domainName;

- (id)valueForKey:(NSString *)key inDomain:(NSString *)domainName;

@end
