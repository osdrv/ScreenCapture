//
//  GoogleDriveStorageAgent.m
//  ScreenCapture
//
//  Created by Olegs on 26/10/14.
//  Copyright (c) 2014 Brand New Heroes. All rights reserved.
//

#import "GoogleDriveStorageAgent.h"
#import <GTLUtilities.h>
#import <GTLServiceDrive.h>
#import <GTMOAuth2Authentication.h>
#import <GTMOAuth2SignIn.h>
#import <GTLDriveConstants.h>
#import <GTMOAuth2WindowController.h>

NSString *const kKeychainItemName = @"Whitebox.io Google Drive";

@implementation GoogleDriveStorageAgent {
    GTLServiceDrive         *serviceDrive;
    GTMOAuth2Authentication *authentication;
}

- (id)initAgentWithOptions:(NSDictionary *)options_ {
    if (self = [super initAgentWithOptions:options_]) {
        
//        GTLServiceDrive         *serviceDrive = [[GTLServiceDrive alloc] init];
//        NSString                *clientID     = [options_ valueForKey:@"ClientID"];
//        NSString                *clientSecret = [options_ valueForKey:@"ClientSecret"];
//        
//        serviceDrive.retryEnabled = YES;
//        self->serviceDrive = serviceDrive;
//        
//        self->authentication = [GTMOAuth2SignIn standardGoogleAuthenticationForScope:kGTLAuthScopeDriveFile clientID:clientID clientSecret:clientSecret];
    }
    
    return self;
}

- (PMKPromise *)store:(Screenshot *)screenshot {
    
    NSLog(@"Storing file with Google Drive");
    
    return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
        
        NSFileHandle *fileHandle   = [screenshot valueForKey:@"Handle" inDomain:@"Generic"];
        NSString     *fileName     = [screenshot valueForKey:@"FileName" inDomain:@"Generic"];
        NSString     *clientID     = [self->options valueForKey:@"ClientID"];
        NSString     *clientSecret = [self->options valueForKey:@"ClientSecret"];
        
        NSBundle *frameworkBundle = [NSBundle bundleForClass:[GTMOAuth2WindowController class]];
        GTMOAuth2WindowController *windowController;
        windowController = [GTMOAuth2WindowController controllerWithScope:kGTLAuthScopeDriveFile
                                                                 clientID:clientID
                                                             clientSecret:clientSecret
                                                         keychainItemName:kKeychainItemName
                                                           resourceBundle:frameworkBundle];
        
//        [windowController signInSheetModalForWindow:[[[NSApplication sharedApplication] delegate] window];
//                                  completionHandler:^(GTMOAuth2Authentication *auth,
//                                                      NSError *error) {
//            if (error == nil) {
//                self.driveService.authorizer = auth;
//                fulfill(screenshot);
//            } else {
////                _fileListFetchError = error;
//            }
//        }];
        
        
    }];
}

@end
