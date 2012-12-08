//
//  AppDelegate.m
//  ASCSpringboardTest
//
//  Created by admin on 10/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"
#import "DockItem.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize springboard = _springboard;

- (void)dealloc
{
    [_window release];
    [_springboard release];
    [super dealloc];
}

- (UIImage*)dockImageForRow:(NSInteger)row {
    return [UIImage imageNamed:@"dock"];
}

- (UIImage*)backgroundImage {
    return [UIImage imageNamed:@"back"];
}

- (UIImage*)logoImage {
    return [UIImage imageNamed:@"logo_no_text"];
}

- (void)springboard:(ASCSpringboardViewController*)springboard didTapDockItemAtIndexPath:(NSIndexPath*)indexPath onPage:(NSInteger)page {
    
    [[[[UIAlertView alloc]initWithTitle:@"Tapped Item" 
                                message:@"User tapped an item." 
                               delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]autorelease]show];
}

- (BOOL)springboard:(ASCSpringboardViewController*)springboard shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        return YES;
    return interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown;
}

- (DockItem*)springboard:(ASCSpringboardViewController*)springboard dockItemForIndexPath:(NSIndexPath*)indexPath onPage:(NSInteger)page {
    
    //if( page == 0 && indexPath.section == 0 )
    //{
        DockItem* newItem = [[[DockItem alloc]init]autorelease];
        switch (indexPath.row) {
            case 0:
                newItem.title = @"Study";
                newItem.badge = (indexPath.section == 0)?1:0;
                newItem.icon = [UIImage imageNamed:@"admissions"];
                break;
            case 1:
                newItem.title = @"About UD";
                newItem.badge = 0;
                newItem.icon = [UIImage imageNamed:@"about"];
                break;
            case 2:
                newItem.title = @"Dayton";
                newItem.badge = 0;
                newItem.icon = [UIImage imageNamed:@"dayton"];
                break;
            case 3:
                if( indexPath.section == 0 ) return nil;
                newItem.title = @"Graduate";
                newItem.badge = 0;
                newItem.icon = [UIImage imageNamed:@"Graduate"];
                break;
            default:
                break;
        }
        return newItem;
    //}
    //return nil;
}

- (NSInteger)numberOfPagesForSpringboard:(ASCSpringboardViewController*)springboard {
    return 1;
}

- (NSInteger)springboard:(ASCSpringboardViewController*)springboard numberOfItemsForRow:(NSInteger)row inPage:(NSInteger)page {
    if( row == 0 ) return 3;
    return 0;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    
    self.springboard = [[[ASCSpringboardViewController alloc]initWithNibName:@"ASCSpringboard" bundle:nil]autorelease];
    self.springboard.dataSource = self;
    self.springboard.delegate = self;
    
    self.window.rootViewController = self.springboard;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
