//
//  MNCoreText.h
//  MindNodeTouch
//
//  Created by Markus Müller on 28.02.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <dispatch/dispatch.h>
#import <CoreText/CoreText.h>

dispatch_queue_t MNGetCoreTextWorkingQueue(void);
CTFontRef MNCTFontCreateFromUIFont(UIFont *font);


BOOL MNCTFontIsBold(CTFontRef font);
CTFontRef MNCTFontCreateBoldFont(CTFontRef font, BOOL bold);
BOOL MNCTFontIsItalic(CTFontRef font);
CTFontRef MNCTFontCreateItalicFont(CTFontRef font, BOOL italic);
UITextAlignment MNUITextAlignmentFromCTTextAlignment(CTTextAlignment alignment);
