//
//  NSMutableAttributedString+Convenience.h
//  MindNodeTouch
//
//  Created by Markus Müller on 4/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>


@interface NSMutableAttributedString (Convenience)

+ (id)mn_mutableAttributedStringWithString:(NSString *)string font:(UIFont *)font color:(UIColor *)color alignment:(CTTextAlignment)alignment;

@end
