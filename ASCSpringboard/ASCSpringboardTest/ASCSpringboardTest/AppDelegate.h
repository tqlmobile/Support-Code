//
//  AppDelegate.h
//  ASCSpringboardTest
//
//  Created by admin on 10/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASCSpringboardViewController.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate,ASCSpringBoardViewControllerDelegate,ASCSpringBoardViewControllerDataSource>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ASCSpringboardViewController *springboard;

@end
