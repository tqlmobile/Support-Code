//
//  NSMutableAttributedString+Convenience.m
//  MindNodeTouch
//
//  Created by Markus Müller on 4/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NSMutableAttributedString+Convenience.h"
#import "MNCoreText.h"


@implementation NSMutableAttributedString (Convenience)

+ (id)mn_mutableAttributedStringWithString:(NSString *)string font:(UIFont *)font color:(UIColor *)color alignment:(CTTextAlignment)alignment

{
    CFMutableAttributedStringRef attrString = CFAttributedStringCreateMutable(kCFAllocatorDefault, 0);
    
    if (string != nil)
        CFAttributedStringReplaceString (attrString, CFRangeMake(0, 0), (CFStringRef)string);
    
    CFAttributedStringSetAttribute(attrString, CFRangeMake(0, CFAttributedStringGetLength(attrString)), kCTForegroundColorAttributeName, color.CGColor);
    CTFontRef theFont = MNCTFontCreateFromUIFont(font);
    CFAttributedStringSetAttribute(attrString, CFRangeMake(0, CFAttributedStringGetLength(attrString)), kCTFontAttributeName, theFont);
    CFRelease(theFont);
    
    CTParagraphStyleSetting settings[] = {kCTParagraphStyleSpecifierAlignment, sizeof(alignment), &alignment};
    CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(settings, sizeof(settings) / sizeof(settings[0]));
    CFAttributedStringSetAttribute(attrString, CFRangeMake(0, CFAttributedStringGetLength(attrString)), kCTParagraphStyleAttributeName, paragraphStyle);    
    CFRelease(paragraphStyle);
    
    
    NSMutableAttributedString *ret = (NSMutableAttributedString *)attrString;
    
    return [ret autorelease];
}

@end
