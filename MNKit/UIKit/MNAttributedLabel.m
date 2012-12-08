
#import "MNAttributedLabel.h"
#import <CoreText/CoreText.h>


@implementation MNAttributedLabel

@synthesize attributedText = _attributedText;
@synthesize textAlignment = _textAlignment;

- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (!self) return nil;

    self.userInteractionEnabled = NO;
    self.textAlignment = UITextAlignmentLeft;
    self.contentMode = UIViewContentModeRedraw;
    
    return self;
}

- (void)dealloc 
{
    MNRelease(_attributedText);
    [super dealloc];
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    
    if (_attributedText == attributedText) return;
        
    [_attributedText release];
    _attributedText = [attributedText copy];
    [self setNeedsDisplay];  
}

- (void)drawRect:(CGRect)rect 
{
	if (self.attributedText == nil) return;
    
	CGContextRef context = UIGraphicsGetCurrentContext(); 	
	
	CGContextSaveGState(context);
    
	CGContextTranslateCTM(context, 0, self.bounds.size.height);
	CGContextScaleCTM(context, 1.0, -1.0);
    
	
    CTLineRef line = CTLineCreateWithAttributedString((CFAttributedStringRef)self.attributedText);
    
    
    CGFloat flush = 0.0f;
    switch (self.textAlignment) {
        case UITextAlignmentRight:
            flush = 1.0f;
            break;
        case UITextAlignmentCenter:
            flush = 0.5f;
            break;
        default:
            flush = 0.0f;
            break;
    }
    
    CGFloat penOffset = CTLineGetPenOffsetForFlush(line, flush, self.bounds.size.width);
    
    // Move the given text drawing position by the calculated offset and draw the line.
    CGContextSetTextPosition(context, penOffset, 5);
    CTLineDraw(line, context);
    
	CGContextRestoreGState(context);	
	CFRelease(line);	
}
    

@end
