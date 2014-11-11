//
//  PJHCaption.h
//  OUAnywhere
//
//  Created by Paul.Hogan on 15/08/2013.
//
//

#import <Foundation/Foundation.h>

@interface PJHCaption : NSObject

@property NSTimeInterval begin;
@property NSTimeInterval end;
@property (nonatomic, copy) NSString *text;

-(id)initWithBegin:(NSTimeInterval)begin end:(NSTimeInterval)end text:(NSString *)text;

@end
