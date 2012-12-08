//
//  GradientView.h
//  evilrockhopper
//
//  Created by Daniel Wichett on 10/12/2009.
//

#import <UIKit/UIKit.h>

@interface GradientView : UIView
{
    float startRed;
    float startGreen;
    float startBlue;
    
    float endRed;
    float endGreen;
    float endBlue;
    
    BOOL mirrored;
}

@property (nonatomic) BOOL mirrored;

- (void) setColoursWithCGColors:(CGColorRef)color1:(CGColorRef)color2;
- (void) setColours:(float) startRed:(float) startGreen:(float) startBlue:(float) endRed:(float) endGreen:(float)endBlue;

@end
