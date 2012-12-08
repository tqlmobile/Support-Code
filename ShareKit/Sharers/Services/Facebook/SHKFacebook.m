//
//  SHKFacebook.m
//  ShareKit
//
//  Created by Nathan Weiner on 6/18/10.

//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//
//

#import "SHKFacebook.h"

@implementation SHKFacebook

@synthesize pendingFacebookAction;
@synthesize login;
@synthesize facebook;

- (void)dealloc
{
	[facebook release]; facebook = nil;
	[login release];
	[super dealloc];
}


#pragma mark -
#pragma mark Configuration : Service Defination

+ (NSString *)sharerTitle
{
	return @"Facebook";
}

+ (BOOL)canShareURL
{
	return YES;
}

+ (BOOL)canShareText
{
	return YES;
}

+ (BOOL)canShareImage
{
	return NO;
}

+ (BOOL)canShareOffline
{
	return NO; // TODO - would love to make this work
}

#pragma mark -
#pragma mark Configuration : Dynamic Enable

- (BOOL)shouldAutoShare
{
	return YES; // FBConnect presents its own dialog
}

#pragma mark -
#pragma mark Authentication

- (BOOL)isAuthorized
{	
	if( facebook == nil )
		facebook = [[Facebook alloc]initWithAppId:SHKFacebookAppID];
	return [facebook isSessionValid];
}

- (void)promptAuthorization
{
	self.pendingFacebookAction = SHKFacebookPendingLogin;
	[facebook authorize:[NSArray arrayWithObjects:@"read_stream", @"publish_stream", @"offline_access",nil] delegate:self];
}

- (void)authFinished:(SHKRequest *)request
{		
	
}

- (void)logout
{
	[facebook logout:self];
}

#pragma mark -
#pragma mark Share API Methods

- (BOOL)send
{			
	SBJSON *jsonWriter = [[SBJSON new] autorelease];
	NSDictionary* actionLinks = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:
														   SHKEncode(SHKMyAppName),
														   @"text",
														   SHKEncode(SHKMyAppURL),
														   @"href", nil], nil];
	
	NSString *actionLinksStr = [jsonWriter stringWithObject:actionLinks];

	if (item.shareType == SHKShareTypeURL)
	{
		self.pendingFacebookAction = SHKFacebookPendingStatus;

		
		NSMutableDictionary* attachment = [NSMutableDictionary dictionaryWithObjectsAndKeys:
									item.title == nil ? [item.URL absoluteString] : item.title, @"caption",
									SHKEncodeURL(item.URL), @"link",nil];
		
		
		[facebook dialog:@"feed"
				andParams:attachment
			  andDelegate:self];
	}
	
	else if (item.shareType == SHKShareTypeText)
	{
		self.pendingFacebookAction = SHKFacebookPendingStatus;
		
		NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
									   item.text, @"name",
									   actionLinksStr, @"action_links",
									   nil];
		
		
		[facebook dialog:@"feed"
			   andParams:params
			 andDelegate:self];		
	}
	
	
	return YES;
}

- (void)dialogDidSucceed:(FBDialog*)dialog
{
	
	// TODO - the dialog has a SKIP button.  Skipping still calls this even though it doesn't appear to post.
	//		- need to intercept the skip and handle it as a cancel?
	if (pendingFacebookAction == SHKFacebookPendingStatus)
		[self sendDidFinish];
}

- (void)dialogDidCancel:(FBDialog*)dialog
{
	if (pendingFacebookAction == SHKFacebookPendingStatus)
		[self sendDidCancel];
}

- (BOOL)dialog:(FBDialog*)dialog shouldOpenURLInExternalBrowser:(NSURL*)url
{
	return NO;
}


#pragma mark FBSessionDelegate methods

- (void)fbDidLogin 
{
	// Try to share again
	if (pendingFacebookAction == SHKFacebookPendingLogin)
	{
		self.pendingFacebookAction = SHKFacebookPendingNone;
		[self share];
	}
}

- (void)fbWillLogout:(BOOL)cancelled
{
	// Not handling this
}


#pragma mark FBRequestDelegate methods

- (void)request:(FBRequest*)aRequest didLoad:(id)result 
{
}

- (void)request:(FBRequest*)aRequest didFailWithError:(NSError*)error 
{
	[self sendDidFailWithError:error];
}



@end
