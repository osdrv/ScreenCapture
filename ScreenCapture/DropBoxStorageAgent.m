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
    void                (^DBFileUploadHandler)(void);
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
        
        DBSession *dbSession = [[DBSession alloc] initWithAppKey:appKey appSecret:appSecret root:kDBRootAppFolder];
        [DBSession setSharedSession:dbSession];
        self.restClient = [[DBRestClient alloc] initWithSession:dbSession];
        self.restClient.delegate = self;
    }
    
    return self;
}

- (PMKPromise *)store:(Screenshot *)screenshot_ {
    return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
        
        self->screenshot = screenshot_;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(authHelperStateChangedNotification:) name:DBAuthHelperOSXStateChangedNotification object:[DBAuthHelperOSX sharedHelper]];
        
        [self authorize].then(^(NSData *data) {
            
            NSLog(@"YYYYMMDD file name: %@", [screenshot_ valueForKey:@"FileName" inDomain:@"Generic"]);
            
            NSString    *fileName   = [screenshot_ valueForKey:@"FileName" inDomain:@"Generic"];
            NSString    *destDir    = [self->options valueForKey:@"Destination"];
            NSString    *tmpName    = [screenshot_ valueForKey:@"TmpName" inDomain:@"Generic"];
            
            [self.restClient uploadFile:fileName toPath:destDir withParentRev:nil fromPath:tmpName];
            self->DBFileUploadHandler = ^{
                fulfill(screenshot_);
            };
        }).catch(^(NSError *error) {
            reject(error);
        });
    }];
}

- (PMKPromise *)authorize {
    return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
        if (![[DBSession sharedSession] isLinked]) {
            NSLog(@"DROPBOX IS NOT CONNECTED");
            self->DBAuthSuccess = fulfill;
            self->DBAuthFail = reject;
            NSLog(@"Authenticating Dropbox now");
            [[DBAuthHelperOSX sharedHelper] authenticate];
        } else {
            NSLog(@"DROPBOX IS CONNECTED");
            fulfill(NULL);
        }
    }];
}

- (void)authHelperStateChangedNotification:(NSNotification *)notification {
    if ([[DBSession sharedSession] isLinked]) {
        NSLog(@"DropBox has been connected now");
        if (self->DBAuthSuccess != nil) {
            self->DBAuthSuccess(self->screenshot);
        } else if (self->DBAuthFail != nil) {
            self->DBAuthFail(NULL);
        }
    }
}

- (void)restClient:(DBRestClient *)client uploadedFile:(NSString *)destPath
              from:(NSString *)srcPath metadata:(DBMetadata *)metadata {
    NSLog(@"File uploaded successfully to path: %@", metadata.path);

    [[self restClient] loadSharableLinkForFile:destPath];
}

- (void)restClient:(DBRestClient *)client uploadFileFailedWithError:(NSError *)error {
    NSLog(@"File upload failed with error: %@", error);
    if (self->DBFileUploadHandler) {
        self->DBFileUploadHandler();
    }
}

- (void)restClient:(DBRestClient*)restClient loadedSharableLink:(NSString*)link forFile:(NSString*)path {
    NSLog(@"Share url: %@", link);
    if (self->DBFileUploadHandler) {
        self->DBFileUploadHandler();
    }
}

- (void)restClient:(DBRestClient*)restClient loadSharableLinkFailedWithError:(NSError*)error
{
    NSLog(@"Error %@", error);
    
    if (self->DBFileUploadHandler) {
        self->DBFileUploadHandler();
    }
}

@end
