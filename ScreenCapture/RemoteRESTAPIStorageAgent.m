//
//  RemoteRESTAPIStorageAgent.m
//  ScreenCapture
//
//  Created by Olegs on 05/10/14.
//  Copyright (c) 2014 Brand New Heroes. All rights reserved.
//

#import "RemoteRESTAPIStorageAgent.h"
#import <ASIHTTPRequest/ASIFormDataRequest.h>

@implementation RemoteRESTAPIStorageAgent

- (PMKPromise *)store:(Screenshot *)screenshot {
    
    NSLog(@"Storing file with RemoteRESTAPI");
    
    NSFileHandle *inputFile = [screenshot valueForKey:@"Handle" inDomain:@"Generic"];
    
    NSAssert(inputFile != nil, @"The input file is nil");
    
    NSString *scheme = [self->options valueForKey:@"Scheme"];
    NSString *host   = [self->options valueForKey:@"Host"];
    NSString *path   = [self->options valueForKey:@"Path"];
    
    NSURL *url = [[NSURL alloc] initWithScheme:scheme host:host path:path];
    
    NSLog(@"%@", url);
    
    return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        [inputFile seekToFileOffset:0];
        NSData *fileContents = [inputFile readDataToEndOfFile];
        
        [request setData:fileContents withFileName:[self generateFilenameYYYYMMDDHHIISS:screenshot] andContentType:@"image/png" forKey:[self->options valueForKey:@"FileParamName"]];
        
        [request setCompletionBlock:^{
            
            NSString *responseString = [request responseString];
            
            NSLog(@"Response: %@, Status code: %i", responseString, [request responseStatusCode]);
            
            if ([request responseStatusCode] == 200) {
                NSURL *resultURL = [[NSURL alloc] initWithScheme:scheme host:host path:responseString];
                [screenshot setValue:[resultURL absoluteString] forKey:@"URL" inDomain:[self getDomain]];
                NSLog(@"%@", resultURL);
            } else {
            }
            
            fulfill(screenshot);
        }];
        
        [request setFailedBlock:^{
            NSError *error = [request error];
            fulfill(screenshot);
        }];
        
        [request startAsynchronous];
        [inputFile seekToFileOffset:0];
    }];
}

@end
