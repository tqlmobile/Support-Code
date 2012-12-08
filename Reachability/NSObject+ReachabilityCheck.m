//
//  NSObject+MainBlock.m
//  Virtuoso
//
//  Created by Josh on 3/29/11.
//  Copyright 2011 Penthera Partners, Inc. All rights reserved.
//

#import "NSObject+ReachabilityCheck.h"
#import "Reachability.h"

@implementation NSObject (AddReachabilityCheck)

- (Boolean)checkForReachabilityAndWarn:(Boolean)showWarningAlert {
	if( [[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable )
	{
		if( showWarningAlert )
		{
			[[[[UIAlertView alloc]initWithTitle:@"No Internet" 
										message:@"You must be online to perform this action.  Please try again after network connection has been restored." 
									   delegate:nil 
							  cancelButtonTitle:@"OK" otherButtonTitles:nil]autorelease]show];
		}
		return NO;
	}
	return YES;
}

- (Boolean)checkForReachabilityAndWarnForOfflineData:(Boolean)showWarningAlert {
	if( [[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable )
	{
		if( showWarningAlert )
		{
			[[[[UIAlertView alloc]initWithTitle:@"No Internet" 
										message:@"You do not currently have a network connection.  Your changes have been stored on the device and will be sent the next time a connection is available.  Please note that AskSunday must be running for data to be sent." 
									   delegate:nil 
							  cancelButtonTitle:@"OK" otherButtonTitles:nil]autorelease]show];
		}
		return NO;
	}
	return YES;
}

@end
