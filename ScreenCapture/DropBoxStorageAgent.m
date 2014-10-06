//
//  DropBoxStorageAgent.m
//  ScreenCapture
//
//  Created by Olegs on 05/10/14.
//  Copyright (c) 2014 Brand New Heroes. All rights reserved.
//

#import "DropBoxStorageAgent.h"

@implementation DropBoxStorageAgent {
    PMKPromiseFulfiller DBAuthSuccess;
    PMKPromiseRejecter  DBAuthFail;
    Screenshot          *screenshot;
}

- (id)initAgentWithOptions:(NSDictionary *)options_ {
    if (self = [super initAgentWithOptions:options_]) {
        
        NSString *appKey    = [self->options valueForKey:@"AppKey"];
        NSString *appSecret = [self->options valueForKey:@"AppSecret"];
        
        NSDictionary *plist         = [[NSBundle mainBundle] infoDictionary];
        NSString     *actualScheme  = [[[[plist objectForKey:@"CFBundleURLTypes"] objectAtIndex:0] objectForKey:@"CFBundleURLSchemes"] objectAtIndex:0];
        NSString     *desiredScheme = [NSString stringWithFormat:@"db-%@", appKey];
        
        if (![actualScheme isEqual:desiredScheme]) {
            [NSException raise:[NSString stringWithFormat:@"Set the url scheme to %@ for the OAuth authorize page to work correctly", desiredScheme] format:@"Misconfigured application"];
        }
        
        DBSession *dbSession = [[DBSession alloc] initWithAppKey:appKey appSecret:appSecret root:kDBRootDropbox];
        [DBSession setSharedSession:dbSession];
        self.restClient = [[DBRestClient alloc] initWithSession:dbSession];
    }
    
    return self;
}

- (PMKPromise *)store:(Screenshot *)screenshot_ {
    return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(authHelperStateChangedNotification:) name:DBAuthHelperOSXStateChangedNotification object:[DBAuthHelperOSX sharedHelper]];
        
        if (![[DBSession sharedSession] isLinked]) {
            NSLog(@"DROPBOX IS NOT CONNECTED");
            self->DBAuthSuccess = fulfill;
            self->DBAuthFail = reject;
            self->screenshot = screenshot_;
            [[DBAuthHelperOSX sharedHelper] authenticate];
        } else {
            NSLog(@"DROPBOX IS CONNECTED");
            fulfill(screenshot_);
        }

    }];
}

- (void)authHelperStateChangedNotification:(NSNotification *)notification {
    if ([[DBSession sharedSession] isLinked]) {
        // @TODO: implement me!
        NSLog(@"DropBox has been connected now");
        if (self->DBAuthSuccess != nil) {
            self->DBAuthSuccess(self->screenshot);
        } else {
            self->DBAuthFail(NULL);
        }
    }
}

@end
