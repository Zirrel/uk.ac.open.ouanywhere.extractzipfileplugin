//
//  CDVUnzipper.h
//  OUAnywhere
//

#import <Cordova/CDV.h>
#import "PJHUnzipProgess.h"

@interface CDVUnzipper : CDVPlugin <PJHUnzipProgressDelegate>

-(void)unzipFile:(CDVInvokedUrlCommand *)command;

@end
