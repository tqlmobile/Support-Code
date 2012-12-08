//
//  MNStepperView.h
//  MindNodeTouch
//
//  Created by Markus Müller on 28.03.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MNStepper : UIControl

@property (nonatomic) NSInteger value;
@property (nonatomic, copy) NSString *postfix; // currently ignored
@property (nonatomic) NSInteger minValue;
@property (nonatomic) NSInteger maxValue;
@property (nonatomic) NSInteger stepValue;

@end
