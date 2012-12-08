//
//  NSAttributedString+Convenience.m
//  MindNodeTouch
//
//  Created by Markus Müller on 11.03.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NSAttributedString+Convenience.h"
#import "MNCoreText.h"

@implementation NSAttributedString (Convenience)

- (CTFontRef)mn_fontRefOfFirstCharacter
{
    if (self.length == 0) return NULL;
    CTFontRef fontRef = (CTFontRef)[self attribute:(NSString *)kCTFontAttributeName atIndex:0 effectiveRange:NULL];
    return fontRef;
}

- (NSString *)mn_fontFullNameOfFirstCharacter
{
    if (self.length == 0) return nil;

    CTFontRef fontRef = [self mn_fontRefOfFirstCharacter];
    if (!fontRef) return nil;
    
    NSString *fontName = (NSString *) CTFontCopyFullName(fontRef);
    return [fontName autorelease];
}

- (NSString *)mn_fontFamilyNameOfFirstCharacter
{
    if (self.length == 0) return nil;
    
    CTFontRef fontRef = [self mn_fontRefOfFirstCharacter];
    if (!fontRef) return nil;
    
    NSString *fontName = (NSString *) CTFontCopyFamilyName(fontRef);
    return [fontName autorelease];
}


- (CGFloat)mn_fontSizeOfFirstCharacter
{
    if (self.length == 0) return 9;
    CTFontRef fontRef = [self mn_fontRefOfFirstCharacter];
    if (!fontRef) return 9;
    return CTFontGetSize(fontRef);
}

- (UIColor *)mn_colorOfFirstCharacter
{
    if ([self length] < 1) return [UIColor blackColor];
    
    id color = [self attribute:(NSString *)kCTForegroundColorAttributeName atIndex:0 effectiveRange:NULL];
    if (!color) return [UIColor blackColor];
    
    return [UIColor colorWithCGColor:(CGColorRef)color];
}

- (CTTextAlignment)mn_textAlignmentOfFirstParagraph
{
    if ([self length] < 1) return UITextAlignmentLeft;
    
    id paragraphStyle = [self attribute:(NSString *)kCTParagraphStyleAttributeName atIndex:0 effectiveRange:NULL];
    if (!paragraphStyle) return UITextAlignmentLeft;

    CTTextAlignment alignment = kCTLeftTextAlignment;
    CTParagraphStyleGetValueForSpecifier((CTParagraphStyleRef)paragraphStyle, kCTParagraphStyleSpecifierAlignment, sizeof(alignment), &alignment);
    
    return alignment;
}

- (BOOL)mn_firstCharacterIsUnderlined
{
    if ([self length] < 1) return NO;
    
    id underlineNumber = [self attribute:(NSString *)kCTUnderlineStyleAttributeName atIndex:0 effectiveRange:NULL];
    if (!underlineNumber) return NO;
    
    return ([underlineNumber integerValue] != kCTUnderlineStyleNone ? YES : NO);
}


- (NSAttributedString *)mn_attributedStringWithFontName:(NSString *)fontName fontSize:(CGFloat)fontSize;
{
    CTFontRef oldFont = [self mn_fontRefOfFirstCharacter];
    CTFontRef font = CTFontCreateCopyWithFamily(oldFont, fontSize, NULL, (CFStringRef)fontName);
    if (!font) {
        font = CTFontCreateWithName((CFStringRef)fontName, fontSize, NULL);
    }
    if (!font) return self;
    
    NSMutableAttributedString *attString = [self mutableCopy];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:(id)font forKey:(NSString *)kCTFontAttributeName];
    CFRelease(font);

    [attString addAttributes:attributes range:NSMakeRange(0, [attString length])];
    
    return [attString autorelease];
}

- (NSAttributedString *)mn_attributedStringWithFontSize:(CGFloat)fontSize
{
    if ([self length] < 1) return self;
    
    CTFontRef oldFont = [self mn_fontRefOfFirstCharacter];
    if (!oldFont) return self;
    
    CTFontRef font = CTFontCreateCopyWithAttributes((CTFontRef)oldFont, fontSize, NULL, NULL);
    if (!font) return self;
    
    NSMutableAttributedString *attString = [self mutableCopy];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:(id)font forKey:(NSString *)kCTFontAttributeName]; 
    CFRelease(font);

    [attString addAttributes:attributes range:NSMakeRange(0, [attString length])];
    
    return [attString autorelease];
}


- (NSAttributedString *)mn_attributedStringWithColor:(UIColor *)color
{
    NSMutableAttributedString *attString = [self mutableCopy];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:(id)color.CGColor forKey:(NSString *)kCTForegroundColorAttributeName];
    [attString addAttributes:attributes range:NSMakeRange(0, [attString length])];
    return [attString autorelease];    
}

- (NSAttributedString *)mn_attributedStringWithTextAlignment:(CTTextAlignment)alignment
{
    if ([self length] < 1) return self;
    
    CTParagraphStyleSetting settings[] =
    {
        { kCTParagraphStyleSpecifierAlignment, sizeof(alignment), &alignment },
    };
    
    CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(settings, sizeof(settings) / sizeof(settings[0]));
    
    
    NSMutableAttributedString *attString = [self mutableCopy];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:(id)paragraphStyle forKey:(NSString *)kCTParagraphStyleAttributeName]; 
    CFRelease(paragraphStyle);
    
    [attString addAttributes:attributes range:NSMakeRange(0, [attString length])];
    
    return [attString autorelease];
}

- (NSAttributedString *)mn_attributedStringInBold:(BOOL)isBold
{
    if ([self length] < 1) return self;
    
    CTFontRef font = [self mn_fontRefOfFirstCharacter];
    font = MNCTFontCreateBoldFont(font, isBold);
    if (!font) return self;
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:(id)font forKey:(NSString *)kCTFontAttributeName];  
    CFRelease(font);

    NSMutableAttributedString *attString = [self mutableCopy];
    [attString addAttributes:attributes range:NSMakeRange(0, [attString length])];
    
    return [attString autorelease];
}

- (NSAttributedString *)mn_attributedStringInItalic:(BOOL)isItalic
{
    if ([self length] < 1) return self;
    
    CTFontRef font = [self mn_fontRefOfFirstCharacter];
    font = MNCTFontCreateItalicFont(font, isItalic);
    if (!font) return self;
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:(id)font forKey:(NSString *)kCTFontAttributeName];  
    CFRelease(font);
    
    NSMutableAttributedString *attString = [self mutableCopy];
    [attString addAttributes:attributes range:NSMakeRange(0, [attString length])];
    
    return [attString autorelease];
}

- (NSAttributedString *)mn_attributedStringUnderlined:(BOOL)underlined
{
    if ([self length] < 1) return self;
    
    NSNumber *underlineStyle = [NSNumber numberWithInt:(underlined ? kCTUnderlineStyleSingle: kCTUnderlineStyleNone)];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:(id)underlineStyle forKey:(NSString *)kCTUnderlineStyleAttributeName];  
    
    NSMutableAttributedString *attString = [self mutableCopy];
    [attString addAttributes:attributes range:NSMakeRange(0, [attString length])];
    
    return [attString autorelease];
}


@end
