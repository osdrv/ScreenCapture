//
//  DropBoxStorageAgent.m
//  ScreenCapture
//
//  Created by Olegs on 05/10/14.
//  Copyright (c) 2014 Brand New Heroes. All rights reserved.
//

#import "DropBoxStorageAgent.h"

@implementation DropBoxStorageAgent

- (id)initAgentWithOptions:(NSDictionary *)options_ {
    if (self = [super initAgentWithOptions:options_]) {
        
        NSString *appKey    = [self->options valueForKey:@"AppKey"];
        NSString *appSecret = [self->options valueForKey:@"AppSecret"];
        
        DBSession *dbSession = [[DBSession alloc] initWithAppKey:appKey appSecret:appSecret root:kDBRootDropbox];
        [DBSession setSharedSession:dbSession];
        self.restClient = [[DBRestClient alloc] initWithSession:dbSession];
    }
    
    return self;
}

- (PMKPromise *)store:(Screenshot *)screenshot {
    return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
        
        if (![[DBSession sharedSession] isLinked]) {
            NSLog(@"DROPBOX IS NOT CONNECTED");
            [[DBAuthHelperOSX sharedHelper] authenticate];
        } else {
            NSLog(@"DROPBOX IS CONNECTED");
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(authHelperStateChangedNotification:) name:DBAuthHelperOSXStateChangedNotification object:[DBAuthHelperOSX sharedHelper]];

        
        fulfill(screenshot);
    }];
}

- (void)authHelperStateChangedNotification:(NSNotification *)notification {
    if ([[DBSession sharedSession] isLinked]) {
        // @TODO: implement me!
    }
}

@end
