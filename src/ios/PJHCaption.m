//
//  PJHCaption.m
//  OUAnywhere
//
//  Created by Paul.Hogan on 15/08/2013.
//
//

#import "PJHCaption.h"

@implementation PJHCaption

-(id)initWithBegin:(NSTimeInterval)begin end:(NSTimeInterval)end text:(NSString *)text {
    
    if(self = [super init]) {
        
        self.begin = begin;
        self.end = end;
        self.text = text;
    }
    
    return self;
}

@end
