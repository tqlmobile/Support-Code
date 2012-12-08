//
//  NSAttributedString+Convenience.h
//  MindNodeTouch
//
//  Created by Markus Müller on 11.03.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>

@interface NSAttributedString (Convenience)

- (CTFontRef)mn_fontRefOfFirstCharacter;
- (NSString *)mn_fontFullNameOfFirstCharacter;
- (NSString *)mn_fontFamilyNameOfFirstCharacter;
- (CGFloat)mn_fontSizeOfFirstCharacter;
- (UIColor *)mn_colorOfFirstCharacter;
- (CTTextAlignment)mn_textAlignmentOfFirstParagraph;
- (BOOL)mn_firstCharacterIsUnderlined;

- (NSAttributedString *)mn_attributedStringWithFontName:(NSString *)fontName fontSize:(CGFloat)fontSize;
- (NSAttributedString *)mn_attributedStringWithFontSize:(CGFloat)fontSize;
- (NSAttributedString *)mn_attributedStringWithColor:(UIColor *)color;
- (NSAttributedString *)mn_attributedStringWithTextAlignment:(CTTextAlignment)alignment;
- (NSAttributedString *)mn_attributedStringInBold:(BOOL)isBold;
- (NSAttributedString *)mn_attributedStringInItalic:(BOOL)isItalic;
- (NSAttributedString *)mn_attributedStringUnderlined:(BOOL)underlined;
@end
