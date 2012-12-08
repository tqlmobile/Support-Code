//
//  DockItem.h
//  ASCSpringboard
//
//  Created by Josh Pressnell on 10/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface DockItem : NSObject
{
    NSString* title;
    UIImage* icon;
    NSInteger badge;
    NSDictionary* userInfo;
}

@property (nonatomic,copy) NSString* title;
@property (nonatomic,retain) UIImage* icon;
@property (nonatomic,assign) NSInteger badge;
@property (nonatomic,copy) NSDictionary* userInfo;

@end
