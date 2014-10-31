//
//  RemoteRESTAPIStorageAgent.m
//  ScreenCapture
//
//  Created by Olegs on 05/10/14.
//  Copyright (c) 2014 Brand New Heroes. All rights reserved.
//

#import "RemoteJSRESTAPIStorageAgent.h"
#import "LocalFileMenuActionViewBuilder.h"
#import <ASIHTTPRequest/ASIFormDataRequest.h>

@implementation RemoteJSRESTAPIStorageAgent

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
            NSLog(@"Status code: %i", [request responseStatusCode]);
            
            
            if ([request responseStatusCode] == 200) {
                NSError *error = nil;
                NSData *jsonData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
                NSMutableDictionary *responseOnbject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
                NSString *url = responseOnbject[@"url"];

                NSURL *resultURL = [[NSURL alloc] initWithString:url];
                
                [screenshot setValue:[resultURL absoluteString] forKey:@"URL" inDomain:[self getDomain]];
                NSLog(@"Result URL: %@", resultURL);
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

- (AbstractStorageAgentViewBuilder *)getMenuItemViewBuilder {
    return [[LocalFileMenuActionViewBuilder alloc] init];
}
@end
