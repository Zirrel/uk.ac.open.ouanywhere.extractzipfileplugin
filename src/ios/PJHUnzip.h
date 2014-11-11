//
//  PJHUnzip.h
//  OUAnywhere
//
//  Created by Paul.Hogan on 30/05/2013.
//  Copyright (c) 2013 The Open University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PJHUnzipProgess.h"
#import "enums.h"

@interface PJHUnzip : NSObject

-(id)initWithSourceFileName:(NSString *)fileName targetFolderName:(NSString *)targetFolder andZipProgress:(PJHUnzipProgess *)zipProgress;
-(UnZipReturnCode)unzipFile;

@end
