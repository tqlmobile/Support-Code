//
//  MNStepperView.m
//  MindNodeTouch
//
//  Created by Markus Müller on 28.03.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MNStepper.h"
#import "MNCoreText.h"
#import "MNAttributedLabel.h"
#import "NSMutableAttributedString+Convenience.h"
#import <CoreText/CoreText.h>

@interface MNStepper ()

@property (readwrite, nonatomic, retain) UIButton *upButton;
@property (readwrite, nonatomic, retain) UIButton *downButton;
@property (readwrite, nonatomic, retain) MNAttributedLabel *label;
@property (readwrite, nonatomic, retain) UIImageView *upArrowView;
@property (readwrite, nonatomic, retain) UIImageView *downArrowView;
@property (readwrite, nonatomic, assign) NSTimer *continuousTimer;

@end


@implementation MNStepper


#pragma mark - Properties

@synthesize value = _value;
@synthesize minValue = _minValue;
@synthesize maxValue = _maxValue;
@synthesize stepValue = _stepValue;

@synthesize upButton = _upButton;
@synthesize downButton = _downButton;
@synthesize label = _label;
@synthesize upArrowView = _upArrowView;
@synthesize downArrowView = _downArrowView;

@synthesize continuousTimer = _continuousTimer;
@synthesize postfix=_postfix;


#pragma mark - Init

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    self.value = 0;
    self.minValue = 0;
    self.maxValue = 10;
	self.stepValue = 1;
	self.postfix = @"";
    
    self.upButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *buttonImage = [UIImage imageNamed:@"MNStepperUpDefault.png"];
    buttonImage = [buttonImage stretchableImageWithLeftCapWidth:22 topCapHeight:0];
    [self.upButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    buttonImage = [UIImage imageNamed:@"MNStepperUpPressed.png"];
    buttonImage = [buttonImage stretchableImageWithLeftCapWidth:22 topCapHeight:0];
    [self.upButton setBackgroundImage:buttonImage forState:UIControlStateHighlighted];
    [self.upButton addTarget:self action:@selector(upButtonPressed) forControlEvents:UIControlEventTouchDown];
    [self.upButton addTarget:self action:@selector(invalidateContinuousTimer) forControlEvents:UIControlEventTouchUpInside];
    [self.upButton addTarget:self action:@selector(invalidateContinuousTimer) forControlEvents:UIControlEventTouchUpOutside];
    [self addSubview:self.upButton];
    
    self.downButton = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonImage = [UIImage imageNamed:@"MNStepperDownDefault.png"];
    buttonImage = [buttonImage stretchableImageWithLeftCapWidth:22 topCapHeight:0];
    [self.downButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    buttonImage = [UIImage imageNamed:@"MNStepperDownPressed.png"];
    buttonImage = [buttonImage stretchableImageWithLeftCapWidth:22 topCapHeight:0];
    [self.downButton setBackgroundImage:buttonImage forState:UIControlStateHighlighted];
    [self.downButton addTarget:self action:@selector(downButtonPressed) forControlEvents:UIControlEventTouchDown];
    [self.downButton addTarget:self action:@selector(invalidateContinuousTimer) forControlEvents:UIControlEventTouchUpInside];
    [self.downButton addTarget:self action:@selector(invalidateContinuousTimer) forControlEvents:UIControlEventTouchUpOutside];
    [self addSubview:self.downButton];
    
    UIImage *arrowImage = [UIImage imageNamed:@"MNStepperArrowUpDefault.png"];
    UIImage *arrowImageDisabled = [UIImage imageNamed:@"MNStepperArrowUpDisabled.png"];
    self.upArrowView = [[[UIImageView alloc] initWithImage:arrowImage highlightedImage:arrowImageDisabled] autorelease];
    [self.upButton addSubview:self.upArrowView];
    
    arrowImage = [UIImage imageNamed:@"MNStepperArrowDownDefault.png"];
    arrowImageDisabled = [UIImage imageNamed:@"MNStepperArrowDownDisabled.png"];
    self.downArrowView = [[[UIImageView alloc] initWithImage:arrowImage highlightedImage:arrowImageDisabled] autorelease];
    [self.downButton addSubview:self.downArrowView];

    self.label = [[[MNAttributedLabel alloc] initWithFrame:CGRectZero] autorelease];
    self.label.backgroundColor = [UIColor clearColor];
    self.label.textAlignment = UITextAlignmentCenter;
    [self addSubview:self.label];
    
    return self;
}

- (void)dealloc
{
    MNRelease(_upButton);
    MNRelease(_downButton);
    MNRelease(_label);
    MNRelease(_upArrowView);
    MNRelease(_downArrowView);
    MNRelease(_postfix);
    [_continuousTimer invalidate], _continuousTimer = nil;
    
    [super dealloc];
}


#pragma mark - Layout 

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // buttons
    CGRect frame = self.bounds;
    frame.size.height = self.bounds.size.height/2.0f;
    self.upButton.frame = frame;
    self.upArrowView.frame = CGRectMake(CGRectGetMaxX(self.upButton.bounds) - 20, self.bounds.size.height/4.0f - 12.0f/2.0f+2.0f, 12.0f, 12.0f);
    
    frame.origin.y = self.bounds.size.height/2.0f;
    self.downButton.frame = frame;
    self.downArrowView.frame = CGRectMake(CGRectGetMaxX(self.downButton.bounds) - 20, self.bounds.size.height/4.0f - 12.0f/2.0f-2.0f, 12.0f, 12.0f);
    
    // label
    frame = CGRectMake(6, 20, frame.size.width-30, 30);
    self.label.frame = frame;
}


#pragma mark - Setter
- (void)setValue:(NSInteger)value
{
    //if (value==_value) return;
    if (value < self.minValue) value = self.minValue;
    if (value > self.maxValue) value = self.maxValue;
    
    _value = value;
    
    NSUInteger count = [[NSString stringWithFormat:@"%i",_value] length];
    NSString *string = [[NSString stringWithFormat:@"%i %@",_value,_postfix]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSMutableAttributedString *attString = [NSMutableAttributedString mn_mutableAttributedStringWithString:string font:[UIFont boldSystemFontOfSize:16] color:[UIColor colorWithRed:0.18 green:0.18 blue:0.18 alpha:1.000] alignment:kCTCenterTextAlignment];
    
    
    NSUInteger fontSize = 28;
    if (count > 2) fontSize = 24;
    if (count > 3) fontSize = 18;
    
    CTFontRef font = MNCTFontCreateFromUIFont([UIFont boldSystemFontOfSize:fontSize]);
    [attString addAttribute:(NSString *)kCTFontAttributeName value:(id)font range:NSMakeRange(0,count)];
    CFRelease(font);
    self.label.attributedText = attString;
    
    self.downArrowView.highlighted = (value <= self.minValue);
    self.downButton.enabled = !(value <= self.minValue);
    self.upArrowView.highlighted = (value >= self.maxValue);
    self.upButton.enabled = !(value >= self.maxValue);
}


#pragma mark - Actions

- (void)upButtonPressed
{
    self.value = self.value + self.stepValue;
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    if (self.continuousTimer) [self.continuousTimer invalidate];
    self.continuousTimer = [NSTimer scheduledTimerWithTimeInterval:0.25 target:self selector:@selector(upButtonTimerFired:) userInfo:nil repeats:YES];
}

- (void)upButtonTimerFired:(NSTimer *)timer 
{
    self.value = self.value + self.stepValue;
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)downButtonPressed
{
    self.value = self.value - self.stepValue;
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    if (self.continuousTimer) [self.continuousTimer invalidate];
    self.continuousTimer = [NSTimer scheduledTimerWithTimeInterval:0.25 target:self selector:@selector(downButtonTimerFired:) userInfo:nil repeats:YES];
}

- (void)downButtonTimerFired:(NSTimer *)timer 
{
    self.value = self.value - self.stepValue;
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)invalidateContinuousTimer
{
    if (self.continuousTimer) [self.continuousTimer invalidate];
    self.continuousTimer = nil;
}

@end
