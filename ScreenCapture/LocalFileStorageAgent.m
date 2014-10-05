//
//  LocalFileStorageAgent.m
//  ScreenCapture
//
//  Created by Olegs on 28/09/14.
//  Copyright (c) 2014 Brand New Heroes. All rights reserved.
//

#import "LocalFileStorageAgent.h"

@implementation LocalFileStorageAgent

- (PMKPromise *)storeFile:(NSFileHandleWithName *)inputFileHandleWithName {
    
    NSLog(@"Storing file with LocalFile");
    
    return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
        
        NSFileHandle *inputFile = [inputFileHandleWithName fileHandle];
        
        NSAssert(inputFile != nil, @"Input file handle can not be nil");
        
        NSLog(@"Calling storeFile on LocalFileStorageAgent");
        
        NSString *destinationFolder = [(NSString *)[self->options valueForKey:@"StorePath"] stringByStandardizingPath];
        
        NSError *createFolderError;
        
        BOOL success = [[NSFileManager defaultManager] createDirectoryAtPath:destinationFolder withIntermediateDirectories:YES attributes:nil error:&createFolderError];
        
        if (!success || createFolderError) {
            NSLog(@"Error creating folder %@", destinationFolder);
        }
        
        NSString *fileName = [[NSString stringWithFormat:@"%@/%@",
                              destinationFolder,
                              [self generateFilenameYYYYMMDDHHIISS:inputFileHandleWithName]
                              ] stringByStandardizingPath];
        
        NSFileHandle *outputFile = [NSFileHandle fileHandleForWritingAtPath:fileName];
        
        NSLog(@"About to create a new file: %@", fileName);
        
        NSString *failedAssertMsg = [NSString stringWithFormat:@"Failed to create the destination file, %@", fileName];
        
        if (outputFile == nil) {
            [[NSFileManager defaultManager] createFileAtPath:fileName contents:nil attributes:nil];
            outputFile = [NSFileHandle fileHandleForWritingAtPath:fileName];
        }
        
        NSAssert(outputFile != nil, failedAssertMsg);
        
        NSData *buffer;
        
        @try {
            [inputFile seekToFileOffset:0];
            [outputFile seekToFileOffset:0];
            
            while ([(buffer = [inputFile readDataOfLength:1024]) length] > 0) {
                [outputFile writeData:buffer];
            }
            NSLog(@"Done copying the file");
            self->result = fileName;
            self->succeeded = YES;
        }
        @catch (NSException *exception) {
            self->result = NULL;
            self->succeeded = NO;
            @throw;
        }
        @finally {
            [inputFile seekToFileOffset:0];
            [outputFile closeFile];
            fulfill(self->result);
        }
    }];
}

@end
