//
//  Base64.h
//  Crypto
//
//  Created by Pascal Vantrepote on 06-06-16.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import <Foundation/NSData.h>


@interface NSData (Base64) 
		
/**
 * Create a NSData from a base 64 encoded data
 */
+(id) dataWithBase64Data:(NSData *)base64Data;

/**
 * Create a NSData from a base 64 encoded string
 */
+(id) dataWithBase64String:(NSString *)base64String;

/**
 * Init a NSData from a base 64 encoded data
 */
-(id) initWithBase64Data:(NSData *)base64Data;

/**
 * Create a NSData from a base 64 encoded string
 */
-(id) initWithBase64String:(NSString *)base64String;
 
/**
 * Get a base 64 encoded data
 */
-(NSData *)base64Data;

/**
 * Get a base 64 encoded string
 */
-(NSString *)base64String;

@end
