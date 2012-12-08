//
//  RoundedRectView.h
//
//  Created by Jeff LaMarche on 11/13/08.

#import <UIKit/UIKit.h>

#define kDefaultStrokeColor         [UIColor whiteColor]
#define kDefaultRectColor           [UIColor whiteColor]
#define kDefaultStrokeWidth         1.0
#define kDefaultCornerRadius        30.0

@interface RoundedRectView : UIView {
    UIColor     *strokeColor;
    UIColor     *rectColor;
    CGFloat     strokeWidth;
    CGFloat     cornerRadius;
    Boolean     roundUpperLeft;
    Boolean     roundLowerLeft;
    Boolean     roundUpperRight;
    Boolean     roundLowerRight;
}

-(void)setAllCornersRounded:(Boolean)round;

@property (nonatomic, retain) UIColor *strokeColor;
@property (nonatomic, retain) UIColor *rectColor;
@property CGFloat strokeWidth;
@property CGFloat cornerRadius;
@property Boolean roundUpperLeft;
@property Boolean roundLowerLeft;
@property Boolean roundUpperRight;
@property Boolean roundLowerRight;

@end