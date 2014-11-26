//
//  CDVUnzipper.m
//  OUAnywhere
//

#import "CDVUnzipper.h"
#import "PJHUnzip.h"
#import "PJHUnzipProgess.h"
#import "enums.h"

@implementation CDVUnzipper {
    CDVPluginResult *pluginResult;
    NSString *callbackID;
    NSString *epubPath;
}

-(void)test:(CDVInvokedUrlCommand *)command {
    callbackID = command.callbackId;
    
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"Unzipper"];
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

-(void)unzipFile:(CDVInvokedUrlCommand *)command {
    callbackID = command.callbackId;
    
    // the full path to the unzipped epub files
    epubPath = [[command.arguments objectAtIndex:1] stringByDeletingPathExtension];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSArray *components = [[command.arguments objectAtIndex:1] componentsSeparatedByString:@"/"];
    
    // the file name will be <module folder>/cm536356536725.epub (for example)
    NSString *fName = [NSString stringWithFormat:@"%@/%@/%@",@"uk.ac.open.ouanywhere",[components objectAtIndex:components.count-2], [components objectAtIndex:components.count-1]];
    
    // get full path to target zip(epub) file
    NSString *targetFile = [documentsDirectory stringByAppendingPathComponent:fName];
    
    // get full path to the target folder to be created for this unzipping (use file name less extension)
    NSString *targetFolder = [documentsDirectory stringByAppendingPathComponent:[fName stringByAppendingPathExtension:@"import"]];
    
    // create an instance of our zip progress tracker
    PJHUnzipProgess *zipProgress = [[PJHUnzipProgess alloc] init];
    
    // and set ourselves to receive progress
    zipProgress.delegate = self;
    
    // create an unzipper instance with required file paths and zip progress tracker
    PJHUnzip *unzipper = [[PJHUnzip alloc] initWithSourceFileName:targetFile targetFolderName:targetFolder andZipProgress:zipProgress];

    // make it so...as Jean Luc would say!
    UnZipReturnCode result = [unzipper unzipFile];
    
    // if unzip failed
    if (!result==kZipAllOK) {
        // post zero back to caller, it can decide what to do from there!
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"0"];

        [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackID];
    }
}

-(void)unzipPercentageDone:(NSNumber *)percent {
    // at 100% or no?  result will be percent value or path to epub files
    NSString *result = [percent stringValue]; // [percent intValue] == 100 ? epubPath : [percent stringValue];
    
    // setup the result callback
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:result];
    
    // keep callback open
    [pluginResult setKeepCallback:[NSNumber numberWithBool:YES]];
    
    // fire...
    [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackID];
}

@end
