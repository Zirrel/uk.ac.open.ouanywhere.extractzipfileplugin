//
//  PJHUnzipProgess.m
//  OUAnywhere
//
//  Created by Paul.Hogan on 31/05/2013.
//  Copyright (c) 2013 The Open University. All rights reserved.
//

#import "PJHUnzipProgess.h"

@implementation PJHUnzipProgess

-(void)PercentDone:(NSNumber *)pctDone abort:(BOOL *)abort {
    
    // simples...
    
    [self.delegate unzipPercentageDone:pctDone];    
}

@end
