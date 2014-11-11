//
//  PJHNetworkAvailability.m
//  OUAnywhere
//
//  Created by Paul Hogan on 23/08/2012.
//  Copyright (c) 2012 The Open University. All rights reserved.
//

#import "PJHNetworkAvailability.h"

// 3rd party library framework(s)

#import "Reachability.h"

@implementation PJHNetworkAvailability

// shared instance ensures we have a singleton of this object

+(id)sharedInstance {
 
	static dispatch_once_t once;
    
	static PJHNetworkAvailability *sharedInstance;
    
	dispatch_once(&once, ^{
    
		sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

-(Boolean)isConnectionAvailable {
	
	// simples...Reachability stock method for connectivity test
	
	// assume no network
	
	Boolean ret = FALSE;
    
	// try to connect to google
	
    Reachability *r = [Reachability reachabilityWithHostName:@"www.google.com"];
	
	// grab out the status of the connection
	
	NetworkStatus internetStatus = [r currentReachabilityStatus];
    
	// if status is either WiFi or 3G
	
    if ((internetStatus == ReachableViaWiFi) || (internetStatus == ReachableViaWWAN)) {
	
		// good to go
		
		ret = TRUE;
    }
    
    return ret;
}

-(Boolean)is3GOnly {
	
	// simples...
    
    Reachability *r = [Reachability reachabilityWithHostName:@"www.google.com"];
	
	NetworkStatus internetStatus = [r currentReachabilityStatus];
    
	// if true then 3G only
	
    return internetStatus == ReachableViaWWAN;
}


@end
