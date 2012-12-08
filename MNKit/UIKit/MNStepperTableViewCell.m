//
//  MNSizeSelectionTableViewCell.m
//  MindNodeTouch
//
//  Created by Markus Müller on 22.03.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MNStepperTableViewCell.h"
#import "MNStepper.h"

@interface MNStepperTableViewCell ()

@end

@implementation MNStepperTableViewCell

#pragma mark - Properties

@synthesize stepper=_stepper;

#pragma mark - Init

+ (UITableViewCellStyle)cellStyle
{
    return UITableViewCellStyleDefault;    
}

- (id)initWithCellIdentifier:(NSString *)cellID 
{
    self = [super initWithCellIdentifier:cellID];
    if (!self) return nil;

    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.stepper = [[[MNStepper alloc] initWithFrame:CGRectZero] autorelease];
    [self addSubview:self.stepper];
    
    return self;
}


- (void)dealloc 
{
    MNRelease(_stepper);
    [super dealloc];
}

#pragma mark - Layout


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect textFrame = self.textLabel.frame;
    textFrame.size.width -=110;
    self.textLabel.frame = textFrame;
    
    CGRect stepperFrame = CGRectMake(self.contentView.bounds.size.width - 94, (NSUInteger)(self.contentView.frame.size.height - 70)/2+2, 94, 70);
    self.stepper.frame = stepperFrame;
    [self.stepper setNeedsLayout];
    
}


@end
