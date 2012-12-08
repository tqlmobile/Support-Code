//
//  MNPageViewController.h
//  MindNodeTouch
//
//  Created by Markus Müller on 24.03.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MNPageViewController : UIViewController 

- (id)initWithViewControllers:(NSArray *)viewControllers;
- (IBAction)changePage:(id)sender;

@end
