//
//  MKInfoPanel.m
//  HorizontalMenu
//
//  Created by Mugunth on 25/04/11.
//  Copyright 2011 Steinlogic. All rights reserved.
//  Permission granted to do anything, commercial/non-commercial with this file apart from removing the line/URL above
//  Read my blog post at http://mk.sg/8e on how to use this code

//  As a side note on using this code, you might consider giving some credit to me by
//	1) linking my website from your app's website 
//	2) or crediting me inside the app's credits page 
//	3) or a tweet mentioning @mugunthkumar
//	4) A paypal donation to mugunth.kumar@gmail.com
//
//  A note on redistribution
//	While I'm ok with modifications to this source code, 
//	if you are re-publishing after editing, please retain the above copyright notices

#import "MKEntryPanel.h"
#import <QuartzCore/QuartzCore.h>

static NSString* customTitleString;
static UIView* customTitleView;
static UIButton* customBackButton;
static UIButton* customNextButton;

// Private Methods
// this should be added before implementation block 

@interface MKEntryPanel (PrivateMethods)

+ (MKEntryPanel*) panel;

@end


@implementation DimView

- (id)initWithParent:(UIView*) aParentView onTappedSelector:(SEL) tappedSel
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        // Initialization code
        UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
		if( orientation == UIDeviceOrientationLandscapeLeft || 
		    orientation == UIDeviceOrientationLandscapeRight ||
            orientation == UIDeviceOrientationUnknown )
		{
			CGRect frame = self.frame;
			//float tmp = frame.size.width;
			frame.size.width = frame.size.height;
			frame.size.height = frame.size.height;
			self.frame = frame;
		}
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |
								UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        parentView = aParentView;
        onTapped = tappedSel;
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.0;
    }
    return self;
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [parentView performSelector:onTapped];
}

- (void)dealloc
{
    [super dealloc];
}
@end

@implementation MKEntryPanel

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_4_0

@synthesize textCloseBlock = _textCloseBlock;
@synthesize doubleSliderCloseBlock = _doubleSliderCloseBlock;
@synthesize textRangeCloseBlock = _textRangeCloseBlock;
@synthesize stepperCloseBlock = _stepperCloseBlock;
@synthesize dateCloseBlock = _dateCloseBlock;
@synthesize scrollPickerCloseBlock = _scrollPickerCloseBlock;
@synthesize scrollPickerEndBlock = _scrollPickerEndBlock;
@synthesize phoneCloseBlock = _phoneCloseBlock;
@synthesize cancelBlock = _cancelBlock;

#endif

@synthesize titleLabel = _titleLabel;
@synthesize leftLabel = _leftLabel;
@synthesize rightLabel = _rightLabel;
@synthesize entryField = _entryField;
@synthesize textLowRange, textHighRange, textRangeLabel;
@synthesize backgroundGradient = _backgroundGradient;
@synthesize dimView = _dimView;
@synthesize doubleSlider = _doubleSlider;
@synthesize entryType;
@synthesize datePicker = _datePicker;
@synthesize scrollPicker = _scrollPicker;
@synthesize leftCurrencyLabel;
@synthesize rightCurrencyLabel;
@synthesize stepper;
@synthesize scrollPickerData;
@synthesize phoneLabel;
@synthesize extLabel;
@synthesize phone;
@synthesize ext;
@synthesize myNavItem,savedLeft,savedRight,savedCenter;
@synthesize delegate;

- (Boolean)isStringNumeric:(NSString*)test {
	for( int i = 0; i < [test length]; i++ )
	{
		unichar character = [test characterAtIndex:i];
		if( character < '0' || character > '9' )
			return NO;
	}
	return YES;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+(void) setTitleView:(UIView*)newTitleView {
	[customTitleString release]; customTitleString = nil;
	[customTitleView release]; customTitleView = nil;
	
	customTitleView = [newTitleView retain];
}

+(void) setTitleString:(NSString*)newTitleString {
	[customTitleString release]; customTitleString = nil;
	[customTitleView release]; customTitleView = nil;

	customTitleString = [newTitleString retain];
}

+(void) setBackButtonCustomButton:(UIButton*)customButton {
	[customBackButton release]; customBackButton = nil;
	
	customBackButton = [customButton retain];
}

+(void) setNextButtonCustomButton:(UIButton*)customButton {
	[customNextButton release]; customNextButton = nil;
	
	customNextButton = [customButton retain];
}

+(void)setupNavigationItem:(UINavigationItem*)navItem forEntryPanel:(MKEntryPanel*)theInstance {
	if( navItem == nil )
		return;
	
	theInstance.myNavItem = navItem;
	theInstance.savedLeft = navItem.leftBarButtonItem;
	theInstance.savedRight = navItem.rightBarButtonItem;
	theInstance.savedCenter = navItem.titleView;
	
	if( customBackButton != nil )
	{
		[customBackButton removeTarget:nil action:nil forControlEvents:UIControlEventAllEvents];
		[customBackButton addTarget:theInstance action:@selector(doCancel) forControlEvents:UIControlEventTouchUpInside];
		navItem.leftBarButtonItem = [[[UIBarButtonItem alloc]initWithCustomView:customBackButton]autorelease];
	}
	else
	{
		navItem.leftBarButtonItem = [[[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:theInstance action:@selector(doCancel)]autorelease];
	}
	
	if( customNextButton != nil )
	{
		[customNextButton removeTarget:nil action:nil forControlEvents:UIControlEventAllEvents];
		[customNextButton addTarget:theInstance action:@selector(cancelTapped:) forControlEvents:UIControlEventTouchUpInside];
		navItem.rightBarButtonItem = [[[UIBarButtonItem alloc]initWithCustomView:customNextButton]autorelease];
	}
	else
	{
		navItem.rightBarButtonItem = [[[UIBarButtonItem alloc]initWithTitle:@"Next" style:UIBarButtonItemStyleDone target:theInstance action:@selector(cancelTapped:)]autorelease];
	}
	
	if( customTitleString != nil )
	{
		navItem.titleView = nil;
		navItem.title = customTitleString;
	}
	else if( customTitleView != nil )
	{
		navItem.titleView = customTitleView;
	}
	else
	{
		navItem.titleView = nil;
	}
}

+(void)restoreNavigationItem:(UINavigationItem*)navItem forEntryPanel:(MKEntryPanel*)theInstance {
	if( navItem == nil || theInstance.myNavItem == nil )
		return;
	
	theInstance.myNavItem.leftBarButtonItem = theInstance.savedLeft;
	theInstance.myNavItem.rightBarButtonItem = theInstance.savedRight;
	theInstance.myNavItem.titleView = theInstance.savedCenter;
}

+(MKEntryPanel*) panel
{
    MKEntryPanel *panel =  nil;
	if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
	{
		panel = (MKEntryPanel*) [[[UINib nibWithNibName:@"MKEntryPanel~iPad" bundle:nil] 
								  instantiateWithOwner:self options:nil] objectAtIndex:0];
	}
	else
	{
		panel = (MKEntryPanel*) [[[UINib nibWithNibName:@"MKEntryPanel" bundle:nil] 
								  instantiateWithOwner:self options:nil] objectAtIndex:0];
	}

    panel.doubleSlider = [[[DoubleSlider alloc]initWithFrame:panel.entryField.frame minValue:0.0f maxValue:100.0f barHeight:10.0f]autorelease];
	panel.doubleSlider.hidden = YES;
	[panel.doubleSlider addTarget:panel action:@selector(valueChangedForDoubleSlider:) forControlEvents:UIControlEventValueChanged];
	[panel addSubview:panel.doubleSlider];
	[panel valueChangedForDoubleSlider:panel.doubleSlider];
	
	panel.stepper = [[[MNStepper alloc]initWithFrame:CGRectZero]autorelease];
	panel.stepper.hidden = YES;
	[panel addSubview:panel.stepper];
	
    panel.backgroundGradient.image = [[UIImage imageNamed:@"TopBar"] stretchableImageWithLeftCapWidth:1 topCapHeight:5];

    CATransition *transition = [CATransition animation];
	transition.duration = kAnimationDuration;
	transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	transition.type = kCATransitionPush;	
	transition.subtype = kCATransitionFromBottom;
	[panel.layer addAnimation:transition forKey:nil];
    
    return panel;
}

// Block versions
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_4_0

+(void) showPanelWithTitle:(NSString*)title inView:(UIView*)view withNavigationItem:(UINavigationItem*)navItem withInitialText:(NSString*)text onTextEntered:(TextCloseBlock) editingEndedBlock {
	[MKEntryPanel showPanelWithTitle:title inView:view withNavigationItem:navItem withInitialText:text keyboardType:UIKeyboardTypeDefault onTextEntered:editingEndedBlock];
}

+(void) showPanelWithTitle:(NSString*)title inView:(UIView*)view withNavigationItem:(UINavigationItem*)navItem withInitialText:(NSString*)text keyboardType:(UIKeyboardType)kbType  onTextEntered:(TextCloseBlock) editingEndedBlock {
	[MKEntryPanel showPanelWithTitle:title inView:view withNavigationItem:navItem withInitialText:text keyboardType:kbType onTextEntered:editingEndedBlock onCancel:nil];
}

+(void) showPanelWithTitle:(NSString*)title inView:(UIView*)view withNavigationItem:(UINavigationItem*)navItem withInitialText:(NSString*)text onTextEntered:(TextCloseBlock) editingEndedBlock onCancel:(MKEntryCancelBlock)didCancelBlock {
	[MKEntryPanel showPanelWithTitle:title inView:view withNavigationItem:navItem withInitialText:text keyboardType:UIKeyboardTypeDefault onTextEntered:editingEndedBlock onCancel:didCancelBlock];
}

+(void) showPanelWithTitle:(NSString*)title inView:(UIView*)view withNavigationItem:(UINavigationItem*)navItem withInitialText:(NSString*)text keyboardType:(UIKeyboardType)kbType onTextEntered:(TextCloseBlock) editingEndedBlock onCancel:(MKEntryCancelBlock)didCancelBlock
{
    [MKEntryPanel showPanelWithTitle:title inView:view withNavigationItem:navItem withInitialText:text keyboardType:kbType autocapType:UITextAutocapitalizationTypeNone onTextEntered:editingEndedBlock onCancel:didCancelBlock];
}

+(void) showPanelWithTitle:(NSString*)title inView:(UIView*)view withNavigationItem:(UINavigationItem*)navItem withInitialText:(NSString*)text keyboardType:(UIKeyboardType)kbType autocapType:(UITextAutocapitalizationType)acType onTextEntered:(TextCloseBlock) editingEndedBlock onCancel:(MKEntryCancelBlock)didCancelBlock
{	
    MKEntryPanel *panel = [MKEntryPanel panel];
	panel.entryType = ENTRY_TYPE_TEXT;
	panel.doubleSlider.hidden = YES;
	CGRect frame = panel.frame;
	frame.size.width = view.frame.size.width;
	panel.frame = frame;
    panel.textCloseBlock = editingEndedBlock;
	panel.cancelBlock = didCancelBlock;
    panel.titleLabel.text = title;
    [panel.entryField becomeFirstResponder];
	
	panel.entryField.text = (text != nil)?text:@"";
	panel.entryField.keyboardType = kbType;
    panel.entryField.autocapitalizationType = acType;
    
    panel.dimView = [[[DimView alloc] initWithParent:panel onTappedSelector:@selector(cancelTapped:)] autorelease];
    CATransition *transition = [CATransition animation];
	transition.duration = kAnimationDuration;
	transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	transition.type = kCATransitionFade;
	[panel.dimView.layer addAnimation:transition forKey:nil];
    panel.dimView.alpha = 0.8;
    [view addSubview:panel.dimView];
    [view addSubview:panel];
	
	[MKEntryPanel setupNavigationItem:navItem forEntryPanel:panel];
}

+(void) showPanelWithTitle:(NSString*)title inView:(UIView*)view withNavigationItem:(UINavigationItem*)navItem withDoubleSliderUsingMin:(float)min andMax:(float)max  onValuesEntered:(DoubleSliderCloseBlock) editingEndedBlock {
	[MKEntryPanel showPanelWithTitle:title inView:view withNavigationItem:navItem withDoubleSliderUsingMin:min andMax:max onValuesEntered:editingEndedBlock onCancel:nil];
}

+(void) showPanelWithTitle:(NSString*)title inView:(UIView*)view withNavigationItem:(UINavigationItem*)navItem withDoubleSliderUsingMin:(float)min andMax:(float)max  onValuesEntered:(DoubleSliderCloseBlock) editingEndedBlock onCancel:(MKEntryCancelBlock)didCancelBlock {
    MKEntryPanel *panel = [MKEntryPanel panel];
	panel.entryType = ENTRY_TYPE_RANGE_DOUBLE_SLIDER;
	panel.doubleSlider.hidden = NO;
	panel.entryField.hidden = YES;
	CGRect frame = panel.frame;
	frame.size.width = view.frame.size.width;
	panel.frame = frame;
    panel.doubleSliderCloseBlock = editingEndedBlock;
	panel.cancelBlock = didCancelBlock;
    panel.titleLabel.text = title;
    panel.leftLabel.hidden = NO;
	panel.rightLabel.hidden = NO;
    panel.dimView = [[[DimView alloc] initWithParent:panel onTappedSelector:@selector(cancelTapped:)] autorelease];
    CATransition *transition = [CATransition animation];
	transition.duration = kAnimationDuration;
	transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	transition.type = kCATransitionFade;
	[panel.dimView.layer addAnimation:transition forKey:nil];
    panel.dimView.alpha = 0.8;
    [view addSubview:panel.dimView];
    [view addSubview:panel];

	[MKEntryPanel setupNavigationItem:navItem forEntryPanel:panel];
}

+(void) showPanelWithTitle:(NSString *)title inView:(UIView *)view withNavigationItem:(UINavigationItem*)navItem withInitialDate:(NSDate*)initDate minDate:(NSDate*)minDate maxDate:(NSDate*)maxDate pickerMode:(UIDatePickerMode)mode intervalValue:(NSInteger)interval onDateEntered:(DateCloseBlock)editingEndedBlock {
	[MKEntryPanel showPanelWithTitle:title inView:view withNavigationItem:navItem withInitialDate:initDate minDate:minDate maxDate:maxDate pickerMode:mode intervalValue:interval onDateEntered:editingEndedBlock onCancel:nil];
}

+(void) showPanelWithTitle:(NSString *)title inView:(UIView *)view withNavigationItem:(UINavigationItem*)navItem withInitialDate:(NSDate*)initDate minDate:(NSDate*)minDate maxDate:(NSDate*)maxDate pickerMode:(UIDatePickerMode)mode intervalValue:(NSInteger)interval onDateEntered:(DateCloseBlock)editingEndedBlock onCancel:(MKEntryCancelBlock)didCancelBlock {
    MKEntryPanel *panel = [MKEntryPanel panel];
	panel.entryType = ENTRY_TYPE_DATE;
	panel.entryField.hidden = YES;
	panel.datePicker.hidden = NO;
	
	if( initDate == nil )
		initDate = [NSDate date];

	panel.datePicker.date = initDate;
	panel.datePicker.datePickerMode = mode;
	if( minDate != nil )
	{
		panel.datePicker.minimumDate = minDate;
	}
	if( maxDate != nil )
	{
		panel.datePicker.maximumDate = maxDate;
	}
	panel.datePicker.minuteInterval = interval;
	
	CGRect frame = panel.frame;
	frame.size.width = view.frame.size.width;
	frame.size.height = 246.0f;
	if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
		frame.size.height = 290.0f;
	panel.frame = frame;
    panel.dateCloseBlock = editingEndedBlock;
	panel.cancelBlock = didCancelBlock;
    panel.titleLabel.text = title;
    panel.dimView = [[[DimView alloc] initWithParent:panel onTappedSelector:@selector(cancelTapped:)] autorelease];
    CATransition *transition = [CATransition animation];
	transition.duration = kAnimationDuration;
	transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	transition.type = kCATransitionFade;
	[panel.dimView.layer addAnimation:transition forKey:nil];
    panel.dimView.alpha = 0.8;
    [view addSubview:panel.dimView];
    [view addSubview:panel];

	[MKEntryPanel setupNavigationItem:navItem forEntryPanel:panel];
}

+(void) showPanelWithTitle:(NSString *)title inView:(UIView *)view withNavigationItem:(UINavigationItem*)navItem withPickerData:(NSArray*)dataArray andInitialSelections:(NSArray*)selections onItemSelected:(ScrollPickerCloseBlock)itemSelectedBlock onEntryFinished:(ScrollPickerEndBlock)entryFinishedBlock {
	[MKEntryPanel showPanelWithTitle:title inView:view withNavigationItem:navItem withPickerData:dataArray andInitialSelections:selections onItemSelected:itemSelectedBlock onEntryFinished:entryFinishedBlock onCancel:nil];
}

+(void) showPanelWithTitle:(NSString *)title inView:(UIView *)view withNavigationItem:(UINavigationItem*)navItem withPickerData:(NSArray*)dataArray andInitialSelections:(NSArray*)selections onItemSelected:(ScrollPickerCloseBlock)itemSelectedBlock onEntryFinished:(ScrollPickerEndBlock)entryFinishedBlock onCancel:(MKEntryCancelBlock)didCancelBlock {
    MKEntryPanel *panel = [MKEntryPanel panel];
	panel.entryType = ENTRY_TYPE_SCROLL_PICKER;
	panel.entryField.hidden = YES;
	panel.scrollPicker.hidden = NO;

	panel.scrollPickerCloseBlock = itemSelectedBlock;
	panel.scrollPickerEndBlock = entryFinishedBlock;
	panel.cancelBlock = didCancelBlock;

	panel.scrollPickerData = dataArray;
	[panel.scrollPicker reloadAllComponents];
	
	for( int i = 0; i < [selections count]; i++ )
	{
		NSNumber* selection = [selections objectAtIndex:i];
		NSArray* componentData = [panel.scrollPickerData objectAtIndex:i];
		NSString* value = [componentData objectAtIndex:[selection intValue]];

		[panel.scrollPicker selectRow:[selection intValue] inComponent:i animated:NO];
		panel.scrollPickerCloseBlock([selection intValue],i,value); 
	}
	
	CGRect frame = panel.frame;
	frame.size.width = view.frame.size.width;
	frame.size.height = 246.0f;
	if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
		frame.size.height = 290.0f;
	panel.frame = frame;
		
	panel.titleLabel.text = title;
    panel.dimView = [[[DimView alloc] initWithParent:panel onTappedSelector:@selector(cancelTapped:)] autorelease];
    CATransition *transition = [CATransition animation];
	transition.duration = kAnimationDuration;
	transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	transition.type = kCATransitionFade;
	[panel.dimView.layer addAnimation:transition forKey:nil];
    panel.dimView.alpha = 0.8;
    [view addSubview:panel.dimView];
    [view addSubview:panel];

	[MKEntryPanel setupNavigationItem:navItem forEntryPanel:panel];
}

+(void) showPanelWithTitle:(NSString *)title inView:(UIView *)view withNavigationItem:(UINavigationItem*)navItem stepLowValue:(NSInteger)stepLow stepHighValue:(NSInteger)stepHigh stepValue:(NSInteger)stepValue initialValue:(NSInteger)initValue valueUnits:(NSString*)units onValueEntered:(StepperCloseBlock)editingEndedBlock {
	[MKEntryPanel showPanelWithTitle:title inView:view withNavigationItem:navItem stepLowValue:stepLow stepHighValue:stepHigh stepValue:stepValue initialValue:initValue valueUnits:units onValueEntered:editingEndedBlock onCancel:nil];
}

+(void) showPanelWithTitle:(NSString *)title inView:(UIView *)view withNavigationItem:(UINavigationItem*)navItem stepLowValue:(NSInteger)stepLow stepHighValue:(NSInteger)stepHigh stepValue:(NSInteger)stepValue initialValue:(NSInteger)initValue valueUnits:(NSString*)units onValueEntered:(StepperCloseBlock)editingEndedBlock onCancel:(MKEntryCancelBlock)didCancelBlock {
    MKEntryPanel *panel = [MKEntryPanel panel];
	panel.entryType = ENTRY_TYPE_STEPPER;
	panel.entryField.hidden = YES;
	panel.stepper.hidden = NO;
	panel.stepper.minValue = stepLow;
	panel.stepper.maxValue = stepHigh;
	panel.stepper.stepValue = stepValue;
	panel.stepper.postfix = units;
	
	if( initValue < stepLow )
		initValue = stepLow;
	if( initValue > stepHigh )
		initValue = stepHigh;
	
	[panel.stepper setValue:initValue];
	CGRect frame = CGRectMake(100.0f, 30.0f, 120.0f, 70.0f);
	panel.stepper.frame = frame;
	
	frame = panel.frame;
	frame.size.width = view.frame.size.width;
	frame.size.height = 110.0f;
	panel.frame = frame;
    panel.stepperCloseBlock = editingEndedBlock;
	panel.cancelBlock = didCancelBlock;
    panel.titleLabel.text = title;
    panel.dimView = [[[DimView alloc] initWithParent:panel onTappedSelector:@selector(cancelTapped:)] autorelease];
    CATransition *transition = [CATransition animation];
	transition.duration = kAnimationDuration;
	transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	transition.type = kCATransitionFade;
	[panel.dimView.layer addAnimation:transition forKey:nil];
    panel.dimView.alpha = 0.8;
    [view addSubview:panel.dimView];
    [view addSubview:panel];

	[MKEntryPanel setupNavigationItem:navItem forEntryPanel:panel];
}

+(void) showPanelWithTitle:(NSString *)title inView:(UIView *)view withNavigationItem:(UINavigationItem*)navItem initialLowText:(NSString *)lowText initialHighText:(NSString*)highText onTextEntered:(TextRangeCloseBlock)editingEndedBlock {
	[MKEntryPanel showPanelWithTitle:title inView:view withNavigationItem:navItem initialLowText:lowText initialHighText:highText onTextEntered:editingEndedBlock onCancel:nil];
}

+(void) showPanelWithTitle:(NSString *)title inView:(UIView *)view withNavigationItem:(UINavigationItem*)navItem initialLowText:(NSString *)lowText initialHighText:(NSString*)highText onTextEntered:(TextRangeCloseBlock)editingEndedBlock onCancel:(MKEntryCancelBlock)didCancelBlock {
    MKEntryPanel *panel = [MKEntryPanel panel];
	panel.entryType = ENTRY_TYPE_RANGE_TEXT;
	panel.doubleSlider.hidden = YES;
	panel.entryField.hidden = YES;
	panel.textLowRange.hidden = NO;
	panel.textHighRange.hidden = NO;
	panel.textRangeLabel.hidden = NO;
	panel.leftCurrencyLabel.hidden = NO;
	panel.rightCurrencyLabel.hidden = NO;
	
	NSNumberFormatter* nf = [[[NSNumberFormatter alloc]init]autorelease];
	panel.leftCurrencyLabel.text = [nf currencySymbol];
	panel.rightCurrencyLabel.text = [nf currencySymbol];
	
	panel.textLowRange.text = lowText;
	panel.textHighRange.text = highText;
	
	CGRect frame = panel.frame;
	frame.size.width = view.frame.size.width;
	panel.frame = frame;
    panel.textRangeCloseBlock = editingEndedBlock;
	panel.cancelBlock = didCancelBlock;
    panel.titleLabel.text = title;
	[panel.textLowRange becomeFirstResponder];
    panel.dimView = [[[DimView alloc] initWithParent:panel onTappedSelector:@selector(cancelTapped:)] autorelease];
    CATransition *transition = [CATransition animation];
	transition.duration = kAnimationDuration;
	transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	transition.type = kCATransitionFade;
	[panel.dimView.layer addAnimation:transition forKey:nil];
    panel.dimView.alpha = 0.8;
    [view addSubview:panel.dimView];
    [view addSubview:panel];

	[MKEntryPanel setupNavigationItem:navItem forEntryPanel:panel];
}

+(void) showPanelWithTitle:(NSString *)title inView:(UIView *)view withNavigationItem:(UINavigationItem*)navItem withInitialPhone:(NSString *)startPhone andExtension:(NSString*)startExt onTextEntered:(PhoneCloseBlock)phoneCloseBlock {
	[MKEntryPanel showPanelWithTitle:title inView:view withNavigationItem:navItem withInitialPhone:startPhone andExtension:startExt onTextEntered:phoneCloseBlock onCancel:nil];
}

+(void) showPanelWithTitle:(NSString *)title inView:(UIView *)view withNavigationItem:(UINavigationItem*)navItem withInitialPhone:(NSString *)startPhone andExtension:(NSString*)startExt onTextEntered:(PhoneCloseBlock)phoneCloseBlock onCancel:(MKEntryCancelBlock)didCancelBlock {
    MKEntryPanel *panel = [MKEntryPanel panel];
	panel.entryType = ENTRY_TYPE_PHONE;
	panel.doubleSlider.hidden = YES;
	panel.entryField.hidden = YES;
	panel.phoneLabel.hidden = NO;
	panel.extLabel.hidden = NO;
	panel.phone.hidden = NO;
	panel.ext.hidden = NO;

	panel.phone.text = startPhone;
	panel.ext.text = startExt;
	
	CGRect frame = panel.frame;
	frame.size.width = view.frame.size.width;
	panel.frame = frame;
	
    panel.phoneCloseBlock = phoneCloseBlock;
	panel.cancelBlock = didCancelBlock;
    panel.titleLabel.text = title;
	[panel.phone becomeFirstResponder];
    panel.dimView = [[[DimView alloc] initWithParent:panel onTappedSelector:@selector(cancelTapped:)] autorelease];
    CATransition *transition = [CATransition animation];
	transition.duration = kAnimationDuration;
	transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	transition.type = kCATransitionFade;
	[panel.dimView.layer addAnimation:transition forKey:nil];
    panel.dimView.alpha = 0.8;
    [view addSubview:panel.dimView];
    [view addSubview:panel];

	[MKEntryPanel setupNavigationItem:navItem forEntryPanel:panel];
}

#else

+(void) showPanelWithTitle:(NSString*)title inView:(UIView*)view withNavigationItem:(UINavigationItem*)navItem withInitialText:(NSString*)text keyboardType:(UIKeyboardType)kbType andDelegate:(id<MKEntryPanelDelegate>)theDelegate
{
    [MKEntryPanel showPanelWithTitle:title inView:view withNavigationItem:navItem 
                     withInitialText:text keyboardType:kbType capitalization:UITextAutocapitalizationTypeNone
                         andDelegate:theDelegate];
}

+(void) showPanelWithTitle:(NSString*)title inView:(UIView*)view withNavigationItem:(UINavigationItem*)navItem withInitialText:(NSString*)text keyboardType:(UIKeyboardType)kbType capitalization:(UITextAutocapitalizationType)acType  andDelegate:(id<MKEntryPanelDelegate>)theDelegate
{	
    MKEntryPanel *panel = [MKEntryPanel panel];
	panel.delegate = theDelegate;
	panel.entryType = ENTRY_TYPE_TEXT;
	panel.doubleSlider.hidden = YES;
	CGRect frame = panel.frame;
	frame.size.width = view.frame.size.width;
	panel.frame = frame;
    panel.titleLabel.text = title;
    [panel.entryField becomeFirstResponder];
	
	panel.entryField.text = (text != nil)?text:@"";
	panel.entryField.keyboardType = kbType;
    panel.entryField.autocapitalizationType = acType;
    
    panel.dimView = [[[DimView alloc] initWithParent:panel onTappedSelector:@selector(cancelTapped:)] autorelease];
    CATransition *transition = [CATransition animation];
	transition.duration = kAnimationDuration;
	transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	transition.type = kCATransitionFade;
	[panel.dimView.layer addAnimation:transition forKey:nil];
    panel.dimView.alpha = 0.8;
    [view addSubview:panel.dimView];
    [view addSubview:panel];
	
	[MKEntryPanel setupNavigationItem:navItem forEntryPanel:panel];
}

+(void) showPanelWithTitle:(NSString*)title inView:(UIView*)view withNavigationItem:(UINavigationItem*)navItem withDoubleSliderUsingMin:(float)min andMax:(float)max  andDelegate:(id<MKEntryPanelDelegate>)theDelegate {
    MKEntryPanel *panel = [MKEntryPanel panel];
	panel.delegate = theDelegate;
	panel.entryType = ENTRY_TYPE_RANGE_DOUBLE_SLIDER;
	panel.doubleSlider.hidden = NO;
	panel.entryField.hidden = YES;
	CGRect frame = panel.frame;
	frame.size.width = view.frame.size.width;
	panel.frame = frame;
    panel.titleLabel.text = title;
    panel.leftLabel.hidden = NO;
	panel.rightLabel.hidden = NO;
    panel.dimView = [[[DimView alloc] initWithParent:panel onTappedSelector:@selector(cancelTapped:)] autorelease];
    CATransition *transition = [CATransition animation];
	transition.duration = kAnimationDuration;
	transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	transition.type = kCATransitionFade;
	[panel.dimView.layer addAnimation:transition forKey:nil];
    panel.dimView.alpha = 0.8;
    [view addSubview:panel.dimView];
    [view addSubview:panel];
	
	[MKEntryPanel setupNavigationItem:navItem forEntryPanel:panel];
}

+(void) showPanelWithTitle:(NSString *)title inView:(UIView *)view withNavigationItem:(UINavigationItem*)navItem withInitialDate:(NSDate*)initDate minDate:(NSDate*)minDate maxDate:(NSDate*)maxDate pickerMode:(UIDatePickerMode)mode intervalValue:(NSInteger)interval andDelegate:(id<MKEntryPanelDelegate>)theDelegate {
    MKEntryPanel *panel = [MKEntryPanel panel];
	panel.delegate = theDelegate;
	panel.entryType = ENTRY_TYPE_DATE;
	panel.entryField.hidden = YES;
	panel.datePicker.hidden = NO;
	
	if( initDate == nil )
		initDate = [NSDate date];
	
	panel.datePicker.date = initDate;
	panel.datePicker.datePickerMode = mode;
	if( minDate != nil )
	{
		panel.datePicker.minimumDate = minDate;
	}
	if( maxDate != nil )
	{
		panel.datePicker.maximumDate = maxDate;
	}
	panel.datePicker.minuteInterval = interval;
	
	CGRect frame = panel.frame;
	frame.size.width = view.frame.size.width;
	frame.size.height = 246.0f;
	if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
		frame.size.height = 290.0f;
	panel.frame = frame;
    panel.titleLabel.text = title;
    panel.dimView = [[[DimView alloc] initWithParent:panel onTappedSelector:@selector(cancelTapped:)] autorelease];
    CATransition *transition = [CATransition animation];
	transition.duration = kAnimationDuration;
	transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	transition.type = kCATransitionFade;
	[panel.dimView.layer addAnimation:transition forKey:nil];
    panel.dimView.alpha = 0.8;
    [view addSubview:panel.dimView];
    [view addSubview:panel];
	
	[MKEntryPanel setupNavigationItem:navItem forEntryPanel:panel];
}

+(void) showPanelWithTitle:(NSString *)title inView:(UIView *)view withNavigationItem:(UINavigationItem*)navItem withPickerData:(NSArray*)dataArray andInitialSelections:(NSArray*)selections andDelegate:(id<MKEntryPanelDelegate>)theDelegate {
    MKEntryPanel *panel = [MKEntryPanel panel];
	panel.delegate = theDelegate;
	panel.entryType = ENTRY_TYPE_SCROLL_PICKER;
	panel.entryField.hidden = YES;
	panel.scrollPicker.hidden = NO;
		
	panel.scrollPickerData = dataArray;
	[panel.scrollPicker reloadAllComponents];
	
	for( int i = 0; i < [selections count]; i++ )
	{
		NSNumber* selection = [selections objectAtIndex:i];
		NSArray* componentData = [panel.scrollPickerData objectAtIndex:i];
		NSString* value = [componentData objectAtIndex:[selection intValue]];
		
		[panel.scrollPicker selectRow:[selection intValue] inComponent:i animated:NO];
		if( [panel.delegate respondsToSelector:@selector(didSelectScrollPickerIndex:fromComponent:withValue:)] )
			[panel.delegate didSelectScrollPickerIndex:[selection intValue] fromComponent:i withValue:value];
	}
	
	CGRect frame = panel.frame;
	frame.size.width = view.frame.size.width;
	frame.size.height = 246.0f;
	if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
		frame.size.height = 290.0f;
	panel.frame = frame;
	
	panel.titleLabel.text = title;
    panel.dimView = [[[DimView alloc] initWithParent:panel onTappedSelector:@selector(cancelTapped:)] autorelease];
    CATransition *transition = [CATransition animation];
	transition.duration = kAnimationDuration;
	transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	transition.type = kCATransitionFade;
	[panel.dimView.layer addAnimation:transition forKey:nil];
    panel.dimView.alpha = 0.8;
    [view addSubview:panel.dimView];
    [view addSubview:panel];
	
	[MKEntryPanel setupNavigationItem:navItem forEntryPanel:panel];
}

+(void) showPanelWithTitle:(NSString *)title inView:(UIView *)view withNavigationItem:(UINavigationItem*)navItem stepLowValue:(NSInteger)stepLow stepHighValue:(NSInteger)stepHigh stepValue:(NSInteger)stepValue initialValue:(NSInteger)initValue valueUnits:(NSString*)units andDelegate:(id<MKEntryPanelDelegate>)theDelegate {
    MKEntryPanel *panel = [MKEntryPanel panel];
	panel.delegate = theDelegate;
	panel.entryType = ENTRY_TYPE_STEPPER;
	panel.entryField.hidden = YES;
	panel.stepper.hidden = NO;
	panel.stepper.minValue = stepLow;
	panel.stepper.maxValue = stepHigh;
	panel.stepper.stepValue = stepValue;
	panel.stepper.postfix = units;
	
	if( initValue < stepLow )
		initValue = stepLow;
	if( initValue > stepHigh )
		initValue = stepHigh;
	
	[panel.stepper setValue:initValue];
	CGRect frame = CGRectMake(100.0f, 30.0f, 120.0f, 70.0f);
	panel.stepper.frame = frame;
	
	frame = panel.frame;
	frame.size.width = view.frame.size.width;
	frame.size.height = 110.0f;
	panel.frame = frame;
    panel.titleLabel.text = title;
    panel.dimView = [[[DimView alloc] initWithParent:panel onTappedSelector:@selector(cancelTapped:)] autorelease];
    CATransition *transition = [CATransition animation];
	transition.duration = kAnimationDuration;
	transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	transition.type = kCATransitionFade;
	[panel.dimView.layer addAnimation:transition forKey:nil];
    panel.dimView.alpha = 0.8;
    [view addSubview:panel.dimView];
    [view addSubview:panel];
	
	[MKEntryPanel setupNavigationItem:navItem forEntryPanel:panel];
}

+(void) showPanelWithTitle:(NSString *)title inView:(UIView *)view withNavigationItem:(UINavigationItem*)navItem initialLowText:(NSString *)lowText initialHighText:(NSString*)highText andDelegate:(id<MKEntryPanelDelegate>)theDelegate {
    MKEntryPanel *panel = [MKEntryPanel panel];
	panel.delegate = theDelegate;
	panel.entryType = ENTRY_TYPE_RANGE_TEXT;
	panel.doubleSlider.hidden = YES;
	panel.entryField.hidden = YES;
	panel.textLowRange.hidden = NO;
	panel.textHighRange.hidden = NO;
	panel.textRangeLabel.hidden = NO;
	panel.leftCurrencyLabel.hidden = NO;
	panel.rightCurrencyLabel.hidden = NO;
	
	NSNumberFormatter* nf = [[[NSNumberFormatter alloc]init]autorelease];
	panel.leftCurrencyLabel.text = [nf currencySymbol];
	panel.rightCurrencyLabel.text = [nf currencySymbol];
	
	panel.textLowRange.text = lowText;
	panel.textHighRange.text = highText;
	
	CGRect frame = panel.frame;
	frame.size.width = view.frame.size.width;
	panel.frame = frame;
    panel.titleLabel.text = title;
	[panel.textLowRange becomeFirstResponder];
    panel.dimView = [[[DimView alloc] initWithParent:panel onTappedSelector:@selector(cancelTapped:)] autorelease];
    CATransition *transition = [CATransition animation];
	transition.duration = kAnimationDuration;
	transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	transition.type = kCATransitionFade;
	[panel.dimView.layer addAnimation:transition forKey:nil];
    panel.dimView.alpha = 0.8;
    [view addSubview:panel.dimView];
    [view addSubview:panel];
	
	[MKEntryPanel setupNavigationItem:navItem forEntryPanel:panel];
}

+(void) showPanelWithTitle:(NSString *)title inView:(UIView *)view withNavigationItem:(UINavigationItem*)navItem withInitialPhone:(NSString *)startPhone andExtension:(NSString*)startExt andDelegate:(id<MKEntryPanelDelegate>)theDelegate {
    MKEntryPanel *panel = [MKEntryPanel panel];
	panel.delegate = theDelegate;
	panel.entryType = ENTRY_TYPE_PHONE;
	panel.doubleSlider.hidden = YES;
	panel.entryField.hidden = YES;
	panel.phoneLabel.hidden = NO;
	panel.extLabel.hidden = NO;
	panel.phone.hidden = NO;
	panel.ext.hidden = NO;
	
	panel.phone.text = startPhone;
	panel.ext.text = startExt;
	
	CGRect frame = panel.frame;
	frame.size.width = view.frame.size.width;
	panel.frame = frame;
	
    panel.titleLabel.text = title;
	[panel.phone becomeFirstResponder];
    panel.dimView = [[[DimView alloc] initWithParent:panel onTappedSelector:@selector(cancelTapped:)] autorelease];
    CATransition *transition = [CATransition animation];
	transition.duration = kAnimationDuration;
	transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	transition.type = kCATransitionFade;
	[panel.dimView.layer addAnimation:transition forKey:nil];
    panel.dimView.alpha = 0.8;
    [view addSubview:panel.dimView];
    [view addSubview:panel];
	
	[MKEntryPanel setupNavigationItem:navItem forEntryPanel:panel];
}

#endif

-(void) doCancel {
	[MKEntryPanel restoreNavigationItem:self.myNavItem forEntryPanel:self];

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_4_0

	if( self.cancelBlock != nil )
		self.cancelBlock();
	
#else
	
	if( [delegate respondsToSelector:@selector(entryDidCancel)] )
		[delegate entryDidCancel];
	
#endif
	
	[self performSelectorOnMainThread:@selector(hidePanel) withObject:nil waitUntilDone:NO];
}

-(void) cancelTapped:(id) sender
{
	[MKEntryPanel restoreNavigationItem:self.myNavItem forEntryPanel:self];
    [self performSelectorOnMainThread:@selector(hidePanel) withObject:nil waitUntilDone:YES];  
	
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_4_0

	if( entryType == ENTRY_TYPE_TEXT )
	{
		self.textCloseBlock(self.entryField.text);
	}
	if( entryType == ENTRY_TYPE_RANGE_DOUBLE_SLIDER )
	{
		self.doubleSliderCloseBlock(self.doubleSlider.minSelectedValue,self.doubleSlider.maxSelectedValue);
	}
	if( entryType == ENTRY_TYPE_RANGE_TEXT )
	{
		self.textRangeCloseBlock(self.textLowRange.text,self.textHighRange.text);
	}
	if( entryType == ENTRY_TYPE_STEPPER )
	{
		self.stepperCloseBlock(self.stepper.value);
	}
	if( entryType == ENTRY_TYPE_DATE )
	{
		self.dateCloseBlock(self.datePicker.date);
	}
	if( entryType == ENTRY_TYPE_SCROLL_PICKER )
	{
		self.scrollPickerEndBlock();
	}
	if( entryType == ENTRY_TYPE_PHONE )
	{
		self.phoneCloseBlock(self.phone.text,self.ext.text);
	}

#else
	
	if( entryType == ENTRY_TYPE_TEXT )
	{
		if( [delegate respondsToSelector:@selector(didEnterText:)] )
			[delegate didEnterText:self.entryField.text];
	}
	if( entryType == ENTRY_TYPE_RANGE_DOUBLE_SLIDER )
	{
		if( [delegate respondsToSelector:@selector(didSelectRangeWithMin:andMax:)] )
			[delegate didSelectRangeWithMin:self.doubleSlider.minSelectedValue andMax:self.doubleSlider.maxSelectedValue];
	}
	if( entryType == ENTRY_TYPE_RANGE_TEXT )
	{
		if( [delegate respondsToSelector:@selector(didSelectRangeWithTextMin:andMax:)] )
			[delegate didSelectRangeWithTextMin:self.textLowRange.text andMax:self.textHighRange.text];
	}
	if( entryType == ENTRY_TYPE_STEPPER )
	{
		if( [delegate respondsToSelector:@selector(didSelectStepperValue:)] )
			[delegate didSelectStepperValue:self.stepper.value];
	}
	if( entryType == ENTRY_TYPE_DATE )
	{
		if( [delegate respondsToSelector:@selector(didSelectDate:)] )
			[delegate didSelectDate:self.datePicker.date];
	}
	if( entryType == ENTRY_TYPE_SCROLL_PICKER )
	{
		if( [delegate respondsToSelector:@selector(didEndScrollPicker)] )
			[delegate didEndScrollPicker];
	}
	if( entryType == ENTRY_TYPE_PHONE )
	{
		if( [delegate respondsToSelector:@selector(didSelectPhone:withExtension:)] )
			[delegate didSelectPhone:self.phone.text withExtension:self.ext.text];
	}
	
#endif
	
}

- (void) textFieldDidEndOnExit:(UITextField *)textField {
	
	if( textField == phone )
	{
		[ext becomeFirstResponder];
		return;
	}
    [self cancelTapped:textField];
}

- (void) lowTextFieldDidEndOnExit:(UITextField*)textField {
	if( ![self isStringNumeric:self.textLowRange.text] )
	{
		[[[[UIAlertView alloc]initWithTitle:@"Error" 
									message:@"This entry must be a decimal value." 
								   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]autorelease]show];
		[self.textLowRange becomeFirstResponder];
		return;
	}
	[self.textHighRange becomeFirstResponder];
}

- (void) highTextFieldDidEndOnExit:(UITextField*)textField {
	if( ![self isStringNumeric:self.textHighRange.text] )
	{
		[[[[UIAlertView alloc]initWithTitle:@"Error" 
									message:@"This entry must be a decimal value." 
								   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]autorelease]show];
		[self.textHighRange becomeFirstResponder];
		return;
	}
	[self cancelTapped:textField];
}

- (void)valueChangedForDoubleSlider:(DoubleSlider *)slider
{
	self.leftLabel.text = [NSString stringWithFormat:@"$%d", (int)slider.minSelectedValue];
	self.rightLabel.text = [NSString stringWithFormat:@"$%d", (int)slider.maxSelectedValue];
}

-(void) hidePanel
{
    [self.entryField resignFirstResponder];
    CATransition *transition = [CATransition animation];
	transition.duration = kAnimationDuration;
	transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	transition.type = kCATransitionPush;	
	transition.subtype = kCATransitionFromTop;
	[self.layer addAnimation:transition forKey:nil];
    self.frame = CGRectMake(0, -self.frame.size.height, 320, self.frame.size.height); 
    
    transition = [CATransition animation];
	transition.duration = kAnimationDuration;
	transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	transition.type = kCATransitionFade;
	self.dimView.alpha = 0.0;
	[self.dimView.layer addAnimation:transition forKey:nil];
    
    [self.dimView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.40];
    [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.45];
}

- (void)dealloc
{
	self.scrollPickerData = nil;
	self.scrollPicker = nil;
	self.doubleSlider = nil;
	self.stepper = nil;
	self.myNavItem = nil;
	self.savedLeft = nil;
	self.savedRight = nil;
	self.savedCenter = nil;
	
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_4_0

	self.textCloseBlock = nil;
	self.doubleSliderCloseBlock = nil;
	self.textRangeCloseBlock = nil;
	self.stepperCloseBlock = nil;
	self.phoneCloseBlock = nil;
	self.cancelBlock = nil;
	self.dateCloseBlock = nil;
	self.scrollPickerCloseBlock = nil;
	self.scrollPickerEndBlock = nil;
	
#endif
	
    [super dealloc];
}

#pragma mark -
#pragma mark Picker View DataSource and Delegate Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return [self.scrollPickerData count];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	@try
	{
		NSArray* componentData = [self.scrollPickerData objectAtIndex:component];
		return [componentData count];
	}
	@catch (NSException* e) {
		return 0;
	}
	return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	@try
	{
		NSArray* componentData = [self.scrollPickerData objectAtIndex:component];
		return [componentData objectAtIndex:row];
	}
	@catch (NSException* e) {
		return @"";
	}
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	@try
	{
		NSArray* componentData = [self.scrollPickerData objectAtIndex:component];
		NSString* value = [componentData objectAtIndex:row];
		
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_4_0

		self.scrollPickerCloseBlock(row,component,value); 
		
#else
	
		if( [delegate respondsToSelector:@selector(didSelectScrollPickerIndex:fromComponent:withValue:)] )
			[delegate didSelectScrollPickerIndex:row fromComponent:component withValue:value];
		
#endif
	}
	@catch (NSException* e) {
		// Nothing to do here.
	}
}

@end


