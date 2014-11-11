//
//  PJHUnzipProgess.h
//  OUAnywhere
//
//  Created by Paul.Hogan on 31/05/2013.
//  Copyright (c) 2013 The Open University. All rights reserved.
//

#import "CkoZipProgress.h"

@protocol PJHUnzipProgressDelegate

-(void)unzipPercentageDone:(NSNumber *)percent;

@end

@interface PJHUnzipProgess : CkoZipProgress

@property (nonatomic, assign) id <PJHUnzipProgressDelegate>delegate;

@end
