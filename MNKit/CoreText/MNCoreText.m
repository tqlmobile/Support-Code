//
//  MNCoreText.c
//  MindNodeTouch
//
//  Created by Markus Müller on 28.02.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MNCoreText.h"

static dispatch_queue_t MNCoreTextWorkingQueue = NULL;
dispatch_queue_t MNGetCoreTextWorkingQueue(void)
{
    static dispatch_once_t queueCreationPredicate = 0;
    dispatch_once(&queueCreationPredicate, ^{
        MNCoreTextWorkingQueue = dispatch_queue_create("com.mindnode.coreTextWorkingQueue", 0);
    });
    return MNCoreTextWorkingQueue;
}


CTFontRef MNCTFontCreateFromUIFont(UIFont *font)
{
    CTFontRef ctFont = CTFontCreateWithName((CFStringRef)font.fontName, font.pointSize, NULL);
    return ctFont;
}



BOOL MNCTFontIsBold(CTFontRef font)
{
    return ((CTFontGetSymbolicTraits(font) & kCTFontBoldTrait) != 0);
}

CTFontRef MNCTFontCreateBoldFont(CTFontRef font, BOOL bold)
{
    CTFontSymbolicTraits desiredTrait = 0;
    CTFontSymbolicTraits traitMask;
    
    if (bold) desiredTrait = kCTFontBoldTrait;
    
    // Mask off the bold trait to indicate that it is the only trait
    // desired to be modified. As CTFontSymbolicTraits is a bit field,
    // we could choose to change multiple traits if we desired.
    traitMask = kCTFontBoldTrait;
    
    // Create a copy of the original font with the masked trait set to the
    // desired value. If the font family does not have the appropriate style,
    // this will return NULL.
    
    return CTFontCreateCopyWithSymbolicTraits(font, 0.0, NULL, desiredTrait, traitMask);
}


BOOL MNCTFontIsItalic(CTFontRef font)
{
    return ((CTFontGetSymbolicTraits(font) & kCTFontItalicTrait) != 0);
}

CTFontRef MNCTFontCreateItalicFont(CTFontRef font, BOOL italic)
{
    CTFontSymbolicTraits desiredTrait = 0;
    CTFontSymbolicTraits traitMask;
    
    if (italic) desiredTrait = kCTFontItalicTrait;
    
    // Mask off the bold trait to indicate that it is the only trait
    // desired to be modified. As CTFontSymbolicTraits is a bit field,
    // we could choose to change multiple traits if we desired.
    traitMask = kCTFontItalicTrait;
    
    // Create a copy of the original font with the masked trait set to the
    // desired value. If the font family does not have the appropriate style,
    // this will return NULL.
    
    return CTFontCreateCopyWithSymbolicTraits(font, 0.0, NULL, desiredTrait, traitMask);
}

UITextAlignment MNUITextAlignmentFromCTTextAlignment(CTTextAlignment alignment)
{
    switch (alignment) {
        case kCTLeftTextAlignment:
            return UITextAlignmentLeft;
        case kCTRightTextAlignment:
            return UITextAlignmentRight;
        case kCTCenterTextAlignment:
            return UITextAlignmentCenter;
        case kCTJustifiedTextAlignment:
        case kCTNaturalTextAlignment:
            return UITextAlignmentLeft;
    }
    return UITextAlignmentLeft;
}
