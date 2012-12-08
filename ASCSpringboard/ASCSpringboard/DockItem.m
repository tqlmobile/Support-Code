//
//  DockItem.m
//  ASCSpringboard
//
//  Created by admin on 10/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DockItem.h"

@implementation DockItem

@synthesize title,icon,badge,userInfo;

-(void)dealloc {
    self.title = nil;
    self.icon = nil;
    self.userInfo = nil;
    [super dealloc];
}

@end
