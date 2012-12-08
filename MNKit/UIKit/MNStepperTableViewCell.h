//
//  MNSizeSelectionTableViewCell.h
//  MindNodeTouch
//
//  Created by Markus Müller on 22.03.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MNTableViewCell.h"
@class MNStepper;

@interface MNStepperTableViewCell : MNTableViewCell 

@property (nonatomic, retain) MNStepper *stepper;

@end
