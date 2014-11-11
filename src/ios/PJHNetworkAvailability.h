//
//  PJHNetworkAvailability.h
//  OUAnywhere
//
//  Created by Paul Hogan on 23/08/2012.
//  Copyright (c) 2012 The Open University. All rights reserved.
//

/*
 
this class hooks into Apple's stock Reachability class to determine network status of device
 
*/

#import <Foundation/Foundation.h>

@interface PJHNetworkAvailability : NSObject

+ (id)sharedInstance;

// returns true is device has either a WiFi or 3G connection

-(Boolean)isConnectionAvailable;

// returns true if device is connected to internet on 3G only

-(Boolean)is3GOnly;

@end
