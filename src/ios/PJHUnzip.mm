//
//  PJHUnzip.m
//  OUAnywhere
//
//  Created by Paul.Hogan on 30/05/2013.
//  Copyright (c) 2013 The Open University. All rights reserved.
//

#import "PJHUnzip.h"
#import "PJHUnzipProgess.h"
#import "CkoZip.h"

@interface PJHUnzip ()

@property (nonatomic, copy) NSString *fileToUnzip;
@property (nonatomic, copy) NSString *unzipFolder;
@property (nonatomic, strong) PJHUnzipProgess *zipProgressTracker;

@end

@implementation PJHUnzip

-(id)initWithSourceFileName:(NSString *)fileName targetFolderName:(NSString *)targetFolder andZipProgress:(PJHUnzipProgess *)zipProgress {
    
    if (self = [super init]) {

        self.fileToUnzip = fileName;
        
        self.unzipFolder = targetFolder;
        
        self.zipProgressTracker = zipProgress;
    }
    
    return self;
};

-(UnZipReturnCode)unzipFile {
	
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
	// clean up before we start, make sure any previous unzips are deleted
	
	if ([fileManager fileExistsAtPath:self.unzipFolder]) {
		
		[fileManager removeItemAtPath:self.unzipFolder error:nil];
	}
	
	// start with clean folder 
	
    NSError *error = nil;
    
	[fileManager createDirectoryAtPath:self.unzipFolder withIntermediateDirectories:YES attributes:nil error:&error];
	
    // simples...
    
    if (error) {
        
        return kZipFolderCreationFailed;
    }
    
	// create our unzipper
	
	CkoZip *zip = [[CkoZip alloc] init];
	
 
    // set the progress tracker that will feed back to delegate with progress updates
    
    [zip setEventCallbackObject:self.zipProgressTracker];
    
    
    // single developer licence registered to "p.j.hogan" The Open University
	
	if (![zip UnlockComponent: @"OPENACZIP_ngS4V8Hs4Utz"]) {
       
		return kZipUnlockFailed;
	}
	
	// try to access the zip
	
	if (![zip OpenZip:self.fileToUnzip]) {
		
		return kZipOpenFailed;
	}
		
	//  unzip into targetFolder, returns the number of files and directories unzipped
	
	if ([[zip Unzip: self.unzipFolder] intValue] < 0) {
	
        return kZipUnZipFailed;
	}
	else {
        
        [zip CloseZip];
        
        return kZipAllOK;
 	}
}

@end
