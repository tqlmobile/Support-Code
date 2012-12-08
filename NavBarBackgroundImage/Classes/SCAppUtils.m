/*
 * Copyright (c) 2010-2010 Sebastian Celis
 * All rights reserved.
 */

#import "SCAppUtils.h"

@implementation SCAppUtils

+ (void)customizeNavigationController:(UINavigationController *)navController withImage:(UIImage *)image andTint:(UIColor *)color
{
    UINavigationBar *navBar = [navController navigationBar];
    [navBar setTintColor:color];
    
    if ([navBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
        [navBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    }
    else
    {
        UIImageView *imageView = (UIImageView *)[navBar viewWithTag:kSCNavigationBarBackgroundImageTag];
        if (imageView == nil)
        {
            imageView = [[UIImageView alloc] initWithImage:image];
            imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth  | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
            imageView.contentMode = UIViewContentModeScaleToFill;
            if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
            {
                CGRect frame = imageView.frame;
                frame.size.width = 768;
                imageView.frame = frame;
            }
            
            [imageView setTag:kSCNavigationBarBackgroundImageTag];
            [navBar insertSubview:imageView atIndex:0];
            [imageView release];
        }
    }
}

@end
