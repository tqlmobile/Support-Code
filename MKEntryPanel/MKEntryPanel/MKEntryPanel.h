//
//  MKEntryPanel.h
//  HorizontalMenu
//
//  Created by Mugunth on 25/04/11.
//  Copyright 2011 Steinlogic. All rights reserved.
//  Permission granted to do anything, commercial/non-commercial with this file apart from removing the line/URL above

#import <UIKit/UIKit.h>
#import "DoubleSlider.h"
#import "MNStepper.h"

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_4_0

typedef void (^TextCloseBlock)(NSString *inputValue);
typedef void (^DoubleSliderCloseBlock)(float min, float max);
typedef void (^TextRangeCloseBlock)(NSString* lowValue, NSString* highValue);
typedef void (^StepperCloseBlock)(NSInteger value);
typedef void (^DateCloseBlock)(NSDate* chosenDate);
typedef void (^ScrollPickerCloseBlock)(NSInteger selectedIndex, NSInteger selectedComponent, NSString* selectedValue);
typedef void (^ScrollPickerEndBlock)();
typedef void (^PhoneCloseBlock)(NSString* newPhone, NSString* newExtension);
typedef void (^MKEntryCancelBlock)();

#endif

typedef enum {
	ENTRY_TYPE_TEXT,
	ENTRY_TYPE_RANGE_DOUBLE_SLIDER,
	ENTRY_TYPE_RANGE_TEXT,
	ENTRY_TYPE_STEPPER,
	ENTRY_TYPE_DATE,
	ENTRY_TYPE_SCROLL_PICKER,
	ENTRY_TYPE_PHONE
} ENTRY_TYPE;

@protocol MKEntryPanelDelegate<NSObject>

@optional

- (void)didEnterText:(NSString*)newText;
- (void)didSelectRangeWithMin:(float)min andMax:(float)max;
- (void)didSelectRangeWithTextMin:(NSString*)min andMax:(NSString*)max;
- (void)didSelectStepperValue:(NSInteger)value;
- (void)didSelectDate:(NSDate*)date;
- (void)didSelectScrollPickerIndex:(NSInteger)selectedIndex fromComponent:(NSInteger)selectedComponent withValue:(NSString*)selectedValue;
- (void)didEndScrollPicker;
- (void)didSelectPhone:(NSString*)newPhone withExtension:(NSString*)extension;
- (void)entryDidCancel;

@end

#define kAnimationDuration 0.35

@interface DimView : UIView {
    
    SEL onTapped;
    UIView *parentView;
}

- (id)initWithParent:(UIView*) aParentView onTappedSelector:(SEL) tappedSel;
@end

@interface MKEntryPanel : UIView<UIPickerViewDelegate,UIPickerViewDataSource> {
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_4_0

    TextCloseBlock _textCloseBlock;
	DoubleSliderCloseBlock _doubleSliderCloseBlock;
	TextRangeCloseBlock _textRangeCloseBlock;
	StepperCloseBlock _stepperCloseBlock;
	DateCloseBlock _dateCloseBlock;
	ScrollPickerCloseBlock _scrollPickerCloseBlock;
	ScrollPickerEndBlock _scrollPickerEndBlock;
	PhoneCloseBlock _phoneCloseBlock;
	MKEntryCancelBlock _cancelBlock;

#endif
	
    UILabel *_titleLabel;
    UITextField *_entryField;
	UILabel* _leftLabel;
	UILabel* _rightLabel;
	DoubleSlider *_doubleSlider;
	MNStepper *_stepper;
	UIDatePicker* _datePicker;
	UIPickerView* _scrollPicker;
	UITextField* textLowRange;
	UITextField* textHighRange;
	UILabel* textRangeLabel;
	UILabel* leftCurrencyLabel;
	UILabel* rightCurrencyLabel;
	UILabel* phoneLabel;
	UILabel* extLabel;
	UITextField* phone;
	UITextField* ext;

    UIImageView *_backgroundGradient;
	
	NSArray* scrollPickerData;
    
    DimView *_dimView;
	UINavigationItem* myNavItem;
	UIBarButtonItem* savedLeft;
	UIBarButtonItem* savedRight;
	UIView* savedCenter;
	ENTRY_TYPE entryType;
	
	id<MKEntryPanelDelegate> delegate;
}

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_4_0

@property (nonatomic, copy) TextCloseBlock textCloseBlock;
@property (nonatomic, copy) DoubleSliderCloseBlock doubleSliderCloseBlock;
@property (nonatomic, copy) TextRangeCloseBlock textRangeCloseBlock;
@property (nonatomic, copy) StepperCloseBlock stepperCloseBlock;
@property (nonatomic, copy) DateCloseBlock dateCloseBlock;
@property (nonatomic, copy) ScrollPickerCloseBlock scrollPickerCloseBlock;
@property (nonatomic, copy) ScrollPickerEndBlock scrollPickerEndBlock;
@property (nonatomic, copy) PhoneCloseBlock phoneCloseBlock;
@property (nonatomic, copy) MKEntryCancelBlock cancelBlock;

#endif

@property (nonatomic, assign) DimView *dimView;
@property (nonatomic, assign) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, assign) IBOutlet UIPickerView *scrollPicker;
@property (nonatomic, assign) IBOutlet UILabel *titleLabel;
@property (nonatomic, assign) IBOutlet UILabel *leftLabel;
@property (nonatomic, assign) IBOutlet UILabel *rightLabel;
@property (nonatomic, assign) IBOutlet UITextField *entryField;
@property (nonatomic, assign) IBOutlet UITextField *textLowRange;
@property (nonatomic, assign) IBOutlet UITextField *textHighRange;
@property (nonatomic, assign) IBOutlet UILabel *textRangeLabel;
@property (nonatomic, assign) IBOutlet UILabel *leftCurrencyLabel;
@property (nonatomic, assign) IBOutlet UILabel *rightCurrencyLabel;
@property (nonatomic, assign) IBOutlet UILabel *phoneLabel;
@property (nonatomic, assign) IBOutlet UILabel *extLabel;
@property (nonatomic, assign) IBOutlet UITextField *phone;
@property (nonatomic, assign) IBOutlet UITextField *ext;
@property (nonatomic, retain) DoubleSlider *doubleSlider;
@property (nonatomic, assign) IBOutlet UIImageView *backgroundGradient;
@property (nonatomic, retain) MNStepper *stepper;
@property ENTRY_TYPE entryType;
@property (nonatomic,retain) NSArray* scrollPickerData;
@property (nonatomic,retain) UINavigationItem* myNavItem;
@property (nonatomic,retain) UIBarButtonItem* savedLeft;
@property (nonatomic,retain) UIBarButtonItem* savedRight;
@property (nonatomic,retain) UIView* savedCenter;

@property (nonatomic,assign) id<MKEntryPanelDelegate> delegate;


// Global Configuration

+(void) setTitleView:(UIView*)newTitleView;
+(void) setTitleString:(NSString*)newTitleString;
+(void) setBackButtonCustomButton:(UIButton*)customButton;
+(void) setNextButtonCustomButton:(UIButton*)customButton;

// Text input

// Version with Block support.

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_4_0

+(void) showPanelWithTitle:(NSString*)title inView:(UIView*)view withNavigationItem:(UINavigationItem*)navItem withInitialText:(NSString*)text onTextEntered:(TextCloseBlock) editingEndedBlock;
+(void) showPanelWithTitle:(NSString*)title inView:(UIView*)view withNavigationItem:(UINavigationItem*)navItem withInitialText:(NSString*)text keyboardType:(UIKeyboardType)kbType  onTextEntered:(TextCloseBlock) editingEndedBlock;

+(void) showPanelWithTitle:(NSString*)title inView:(UIView*)view withNavigationItem:(UINavigationItem*)navItem withInitialText:(NSString*)text onTextEntered:(TextCloseBlock) editingEndedBlock onCancel:(MKEntryCancelBlock)didCancelBlock;
+(void) showPanelWithTitle:(NSString*)title inView:(UIView*)view withNavigationItem:(UINavigationItem*)navItem withInitialText:(NSString*)text keyboardType:(UIKeyboardType)kbType  onTextEntered:(TextCloseBlock) editingEndedBlock onCancel:(MKEntryCancelBlock)didCancelBlock;

+(void) showPanelWithTitle:(NSString*)title inView:(UIView*)view withNavigationItem:(UINavigationItem*)navItem withInitialText:(NSString*)text keyboardType:(UIKeyboardType)kbType autocapType:(UITextAutocapitalizationType)acType onTextEntered:(TextCloseBlock) editingEndedBlock onCancel:(MKEntryCancelBlock)didCancelBlock;

// Double Slider integer value input
+(void) showPanelWithTitle:(NSString*)title inView:(UIView*)view withNavigationItem:(UINavigationItem*)navItem withDoubleSliderUsingMin:(float)min andMax:(float)max  onValuesEntered:(DoubleSliderCloseBlock) editingEndedBlock;
+(void) showPanelWithTitle:(NSString*)title inView:(UIView*)view withNavigationItem:(UINavigationItem*)navItem withDoubleSliderUsingMin:(float)min andMax:(float)max  onValuesEntered:(DoubleSliderCloseBlock) editingEndedBlock onCancel:(MKEntryCancelBlock)didCancelBlock;

// Double text box integer value input
+(void) showPanelWithTitle:(NSString *)title inView:(UIView *)view withNavigationItem:(UINavigationItem*)navItem initialLowText:(NSString *)lowText initialHighText:(NSString*)highText onTextEntered:(TextRangeCloseBlock)editingEndedBlock;
+(void) showPanelWithTitle:(NSString *)title inView:(UIView *)view withNavigationItem:(UINavigationItem*)navItem initialLowText:(NSString *)lowText initialHighText:(NSString*)highText onTextEntered:(TextRangeCloseBlock)editingEndedBlock onCancel:(MKEntryCancelBlock)didCancelBlock;

// Stepper input
+(void) showPanelWithTitle:(NSString *)title inView:(UIView *)view withNavigationItem:(UINavigationItem*)navItem stepLowValue:(NSInteger)stepLow stepHighValue:(NSInteger)stepHigh stepValue:(NSInteger)stepValue initialValue:(NSInteger)initValue valueUnits:(NSString*)units onValueEntered:(StepperCloseBlock)editingEndedBlock;
+(void) showPanelWithTitle:(NSString *)title inView:(UIView *)view withNavigationItem:(UINavigationItem*)navItem stepLowValue:(NSInteger)stepLow stepHighValue:(NSInteger)stepHigh stepValue:(NSInteger)stepValue initialValue:(NSInteger)initValue valueUnits:(NSString*)units onValueEntered:(StepperCloseBlock)editingEndedBlock onCancel:(MKEntryCancelBlock)didCancelBlock;

// Scroll Picker input
+(void) showPanelWithTitle:(NSString *)title inView:(UIView *)view withNavigationItem:(UINavigationItem*)navItem withPickerData:(NSArray*)dataArray andInitialSelections:(NSArray*)selections onItemSelected:(ScrollPickerCloseBlock)itemSelectedBlock onEntryFinished:(ScrollPickerEndBlock)entryFinishedBlock;
+(void) showPanelWithTitle:(NSString *)title inView:(UIView *)view withNavigationItem:(UINavigationItem*)navItem withPickerData:(NSArray*)dataArray andInitialSelections:(NSArray*)selections onItemSelected:(ScrollPickerCloseBlock)itemSelectedBlock onEntryFinished:(ScrollPickerEndBlock)entryFinishedBlock onCancel:(MKEntryCancelBlock)didCancelBlock;

// Date input
+(void) showPanelWithTitle:(NSString *)title inView:(UIView *)view withNavigationItem:(UINavigationItem*)navItem withInitialDate:(NSDate*)initDate minDate:(NSDate*)minDate maxDate:(NSDate*)maxDate pickerMode:(UIDatePickerMode)mode intervalValue:(NSInteger)interval onDateEntered:(DateCloseBlock)editingEndedBlock;
+(void) showPanelWithTitle:(NSString *)title inView:(UIView *)view withNavigationItem:(UINavigationItem*)navItem withInitialDate:(NSDate*)initDate minDate:(NSDate*)minDate maxDate:(NSDate*)maxDate pickerMode:(UIDatePickerMode)mode intervalValue:(NSInteger)interval onDateEntered:(DateCloseBlock)editingEndedBlock onCancel:(MKEntryCancelBlock)didCancelBlock;

// Phone w/ Extension Input
+(void) showPanelWithTitle:(NSString *)title inView:(UIView *)view withNavigationItem:(UINavigationItem*)navItem withInitialPhone:(NSString *)startPhone andExtension:(NSString*)startExt onTextEntered:(PhoneCloseBlock)phoneCloseBlock;
+(void) showPanelWithTitle:(NSString *)title inView:(UIView *)view withNavigationItem:(UINavigationItem*)navItem withInitialPhone:(NSString *)startPhone andExtension:(NSString*)startExt onTextEntered:(PhoneCloseBlock)phoneCloseBlock onCancel:(MKEntryCancelBlock)didCancelBlock;

#else
// Versions with delegate support

+(void) showPanelWithTitle:(NSString*)title inView:(UIView*)view withNavigationItem:(UINavigationItem*)navItem withInitialText:(NSString*)text keyboardType:(UIKeyboardType)kbType capitalization:(UITextAutocapitalizationType)acType  andDelegate:(id<MKEntryPanelDelegate>)theDelegate;

+(void) showPanelWithTitle:(NSString*)title inView:(UIView*)view withNavigationItem:(UINavigationItem*)navItem withInitialText:(NSString*)text keyboardType:(UIKeyboardType)kbType andDelegate:(id<MKEntryPanelDelegate>)theDelegate;

// Double Slider integer value input
+(void) showPanelWithTitle:(NSString*)title inView:(UIView*)view withNavigationItem:(UINavigationItem*)navItem withDoubleSliderUsingMin:(float)min andMax:(float)max  andDelegate:(id<MKEntryPanelDelegate>)theDelegate;

// Double text box integer value input
+(void) showPanelWithTitle:(NSString *)title inView:(UIView *)view withNavigationItem:(UINavigationItem*)navItem initialLowText:(NSString *)lowText initialHighText:(NSString*)highText andDelegate:(id<MKEntryPanelDelegate>)theDelegate;

// Stepper input
+(void) showPanelWithTitle:(NSString *)title inView:(UIView *)view withNavigationItem:(UINavigationItem*)navItem stepLowValue:(NSInteger)stepLow stepHighValue:(NSInteger)stepHigh stepValue:(NSInteger)stepValue initialValue:(NSInteger)initValue valueUnits:(NSString*)units andDelegate:(id<MKEntryPanelDelegate>)theDelegate;

// Scroll Picker input
+(void) showPanelWithTitle:(NSString *)title inView:(UIView *)view withNavigationItem:(UINavigationItem*)navItem withPickerData:(NSArray*)dataArray andInitialSelections:(NSArray*)selections andDelegate:(id<MKEntryPanelDelegate>)theDelegate;

// Date input
+(void) showPanelWithTitle:(NSString *)title inView:(UIView *)view withNavigationItem:(UINavigationItem*)navItem withInitialDate:(NSDate*)initDate minDate:(NSDate*)minDate maxDate:(NSDate*)maxDate pickerMode:(UIDatePickerMode)mode intervalValue:(NSInteger)interval andDelegate:(id<MKEntryPanelDelegate>)theDelegate;

// Phone w/ Extension Input
+(void) showPanelWithTitle:(NSString *)title inView:(UIView *)view withNavigationItem:(UINavigationItem*)navItem withInitialPhone:(NSString *)startPhone andExtension:(NSString*)startExt andDelegate:(id<MKEntryPanelDelegate>)theDelegate;

#endif

- (IBAction) textFieldDidEndOnExit:(UITextField *)textField;
- (void)valueChangedForDoubleSlider:(DoubleSlider *)slider;
- (IBAction) lowTextFieldDidEndOnExit:(UITextField*)textField;
- (IBAction) highTextFieldDidEndOnExit:(UITextField*)textField;

@end
