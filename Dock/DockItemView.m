//
//  DockItemView.m
//

#import "DockItemView.h"
#import "CustomBadge.h"
#import <QuartzCore/QuartzCore.h>

#ifndef RGB
#define RGB(r,g,b) [UIColor colorWithRed:(r) green:(g) blue:(b) alpha:1]
#endif

static UIColor* labelColor = nil;
static UIColor* highlightLabelColor = nil;

@interface DockItemView() 

- (UIImage *)reflectedImageForLayer:(CALayer *)layer withHeight:(NSUInteger)height;
- (UIImage *)thumbNailFromImage:(UIImage *)image overlayImage:(UIImage *)overlay;

CGImageRef createGradientImage(int width, int height);

@end

@implementation DockItemView
@synthesize highlighted, button, label;
@synthesize badgeAlert;
@synthesize userInfo;
@synthesize delegate;
@synthesize badgeString;
@synthesize customBadge;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		self.badgeString = nil;
		self.customBadge = nil;
        
        if( labelColor == nil )
            labelColor = [UIColor blackColor];
            //labelColor = [RGB(0.95, 0.95, 0.95)retain];
        
        if( highlightLabelColor == nil )
            highlightLabelColor = [RGB(0.73, 0.73, 0.73)retain];
    }
    return self;
}

-(void)setLabelColor:(UIColor *)color {
    [labelColor release];
    labelColor = [color retain];
}

-(void)setLabelHighlightColor:(UIColor *)color {
    [highlightLabelColor release];
    highlightLabelColor = [color retain];
}

-(void)dockButtonPressed {
	[delegate dockItemViewWasPressed:self];
}

-(id)initWithImage:(UIImage *)thumbnail title:(NSString *)title  withShineNamed:(NSString *)aShineName usingReflection:(Boolean)_useReflection 
{
	return [self initWithImage:thumbnail title:title withShineNamed:aShineName usingReflection:_useReflection usingTitleShadow:NO];
}

-(id)initWithImage:(UIImage *)thumbnail title:(NSString *)title  withShineNamed:(NSString *)aShineName usingReflection:(Boolean)_useReflection usingTitleShadow:(Boolean)useTitleShadow
{
    return [self initWithImage:thumbnail title:title withShineNamed:aShineName usingReflection:_useReflection usingTitleShadow:useTitleShadow usingIconShadow:YES];
}

-(id)initWithImage:(UIImage *)thumbnail title:(NSString *)title  withShineNamed:(NSString *)aShineName usingReflection:(Boolean)_useReflection usingTitleShadow:(Boolean)useTitleShadow usingIconShadow:(Boolean)useIconShadow
{
    self = [self initWithFrame:CGRectMake(0, 0, DOCKITEM_WIDTH, DOCKITEM_HEIGHT)];
    if (self) {
        // Create a container for the dropshadow. We need to to this because masking
        // the button to layer bounds is needed for rounded corners which also masks 
        // away its shadow. 
        // In addition direct label shadows don't work (a rectangle shadow is shown)
		useReflection = _useReflection;
        shadowContainer = [[UIView alloc] initWithFrame:self.bounds];
        if( useIconShadow )
        {
            shadowContainer.layer.shadowOffset = CGSizeMake(0, 1);
            shadowContainer.layer.shadowRadius = 0.5;
            shadowContainer.layer.shadowOpacity = 0.8;
        }
        
        shineName = [aShineName copy];
        
        button = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        button.frame = CGRectMake(DOCKITEM_INSET, DOCKITEM_INSET, 
                                  DOCKITEM_THUMBSIZE, DOCKITEM_THUMBSIZE);
		button.backgroundColor = [UIColor clearColor];
		button.opaque = NO;
        button.layer.cornerRadius = 5.0;
        button.layer.masksToBounds = YES;
		
		[button addTarget:self action:@selector(dockButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        
        // Progress bar
        progress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
        progress.frame = CGRectMake(4, DOCKITEM_THUMBSIZE - 15,
                                    DOCKITEM_THUMBSIZE - 8, 11);
        progress.hidden = YES;
        
        // Set up reflection for button
        mirror = [[UIImageView alloc] initWithFrame:CGRectZero];
        mirror.frame = CGRectMake(DOCKITEM_INSET, CGRectGetMaxY(button.frame), 
                                  DOCKITEM_THUMBSIZE, DOCKITEM_MIRRORSIZE);
        // Set up title label 
        label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.frame = CGRectMake(DOCKITEM_INSET-25, DOCKITEM_HEIGHT - DOCKITEM_FONTSIZE - 1, 
                                 DOCKITEM_WIDTH - DOCKITEM_INSET+50, DOCKITEM_FONTSIZE);
        label.text = title;
        [label setBackgroundColor:[UIColor clearColor]];
        [label setFont:[UIFont boldSystemFontOfSize:DOCKITEM_FONTSIZE]];
        [label setTextAlignment:UITextAlignmentCenter];
        
        // Ensure that the mirror is below the shadowcontainer to get the button
        // to overlap
        [button addSubview:progress];
        [self addSubview:mirror];
        
        if( useIconShadow || useTitleShadow )
            [self addSubview:shadowContainer];
        
        if( useIconShadow )
            [shadowContainer addSubview:button];
        else
            [self addSubview:button];
        
		if( useTitleShadow )
			[shadowContainer addSubview:label];
		else
			[self addSubview:label];
        
        // Set button image with optional shine
        [self setButtonImage:thumbnail];
        // Highligh is off by default
        [self setHighlighted:NO];
    }
    return self;
}

-(void)setLabelText:(NSString *)newLabel {
    label.text = newLabel;
    [label setNeedsDisplay];
}

- (void)dealloc
{
	self.customBadge = nil;
	self.badgeString = nil;
	self.delegate = nil;
	self.userInfo = nil;
    [button release];
    [shineName release];
    [mirror release];
    [shadowContainer release];
    [badge release];
    [progress release];
    [super dealloc];
}


- (void)setHighlighted:(BOOL)bHighlighted 
{
    highlighted = bHighlighted;
    label.textColor = bHighlighted ? highlightLabelColor : labelColor;
}

- (void)setButtonImage:(UIImage *)anImage 
{
    UIImage *buttonImage = [self thumbNailFromImage:anImage 
                                       overlayImage:[UIImage imageNamed:shineName]];
    [button setImage:buttonImage forState:UIControlStateNormal];
	if( useReflection )
		mirror.image = [self reflectedImageForLayer:button.layer withHeight:DOCKITEM_MIRRORSIZE];
}

- (void)setBadgeString:(NSString *)newBadgeString {
	[badgeString release];
	badgeString = [newBadgeString retain];
	
	if( [badgeString length] > 0 )
	{
		[customBadge removeFromSuperview];
		
		self.customBadge = [CustomBadge customBadgeWithString:badgeString 
											  withStringColor:[UIColor whiteColor] 
											   withInsetColor:[UIColor redColor] 
											   withBadgeFrame:YES 
										  withBadgeFrameColor:[UIColor whiteColor] 
													withScale:1.0
												  withShining:YES];
		
		[self.customBadge setFrame:CGRectMake(self.frame.size.width-self.customBadge.frame.size.width/2, 0, self.customBadge.frame.size.width, self.customBadge.frame.size.height)];
		[self addSubview:self.customBadge];
	}
}

- (BOOL)hasAlertBadge
{
    return badge && badge.image;
}

- (void)setBadgeAlert:(BOOL)aValue
{
    UIImage *badgeImage = aValue ? [UIImage imageNamed:@"badge-alert.png"] : nil;
    if (!badge) {
        badge = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 
                                                              badgeImage.size.width, 
                                                              badgeImage.size.height)];
        badge.center = CGPointMake(CGRectGetMaxX(self.bounds) - DOCKITEM_INSET,
                                   2 * DOCKITEM_INSET);
        badge.layer.shadowOffset = CGSizeMake(0, 2);
        badge.layer.shadowRadius = 3;
        badge.layer.shadowOpacity = 0.8;

        [self addSubview:badge];
    }
    
    badge.image = badgeImage;
}

- (void)setProgress:(double)aValue
{
    progress.hidden = aValue < 0.0;
    if (progress.hidden) return;
    
    [progress setProgress:aValue];
}

#pragma mark -
#pragma mark thumbnail and reflection construction

CGImageRef createGradientImage(int width, int height)
{
	CGImageRef result = NULL;
    CGContextRef context = NULL;
    CGColorSpaceRef colorSpace;
	CGGradientRef gradient;
	
	// Our gradient is always black-white and the mask
	// must be in the gray colorspace
    colorSpace = CGColorSpaceCreateDeviceGray();
	
	// create the bitmap context
    context = CGBitmapContextCreate(NULL, width, height,
                                    8, 0, colorSpace, kCGImageAlphaNone);
	
	if (context != NULL) {
		// define the start and end grayscale values (with the alpha, even though
		// our bitmap context doesn't support alpha the gradient requires it)
		CGFloat colors[] = {0.0, 0.0, 1.0, 1.0,};
		
		// create the CGGradient and then release the gray color space
		gradient = CGGradientCreateWithColorComponents(colorSpace, colors, NULL, 2);
		
		// draw the gradient into the gray bitmap context
		CGContextDrawLinearGradient (context, gradient, 
                                     CGPointZero, CGPointMake(0, height), 
                                     kCGGradientDrawsAfterEndLocation);
		
		// clean up the gradient
		CGGradientRelease(gradient);
		
		// convert the context into a CGImageRef and release the
		// context
		result = CGBitmapContextCreateImage(context);
		CGContextRelease(context);
	}
	
	// clean up the colorspace
	CGColorSpaceRelease(colorSpace);
	
	// return the imageref containing the gradient
    return result;
}

- (UIImage *)reflectedImageForLayer:(CALayer *)layer withHeight:(NSUInteger)height
{
	CGContextRef context;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	
	// create a bitmap graphics context the size of the image
    context = CGBitmapContextCreate(NULL, layer.bounds.size.width, height, 8,0, 
                                    colorSpace, kCGImageAlphaPremultipliedLast);
	
	// free the rgb colorspace
    CGColorSpaceRelease(colorSpace);	
	
	if (context == NULL) {
		return NULL;
    }
	
	CGFloat translateVertical=layer.bounds.size.height-height;
	CGContextTranslateCTM(context,0,-translateVertical);
	
	// render the layer into the bitmap context
	[layer renderInContext:context];
	
	// translate the context back
	CGContextTranslateCTM(context,0,translateVertical);
	
	// Create CGImageRef of the main view bitmap content, and then
	// release that bitmap context
	CGImageRef contextImage=CGBitmapContextCreateImage(context);
	CGContextRelease(context);
	
	// create a 2 bit CGImage containing a gradient that will be used for masking the 
	// main view content to create the 'fade' of the reflection.  The CGImageCreateWithMask
	// function will stretch the bitmap image as required, so we can create a 1 pixel wide
	// gradient
	CGImageRef gradientMaskImage=createGradientImage(1,height);
	
	// Create an image by masking the bitmap of the mainView content with the gradient view
	// then release the  pre-masked content bitmap and the gradient bitmap
	CGImageRef reflectionImage=CGImageCreateWithMask(contextImage,gradientMaskImage);
	CGImageRelease(contextImage);
	CGImageRelease(gradientMaskImage);
	
	// convert the finished reflection image to a UIImage 
	UIImage *result=[UIImage imageWithCGImage:reflectionImage 
                                        scale:[UIScreen mainScreen].scale
                                  orientation:UIImageOrientationUp];
	
	// image is autoreleased by the constructor above so we can 
	// release the original
	CGImageRelease(reflectionImage);
	
	// return the image
	return result;
}


- (UIImage *)thumbNailFromImage:(UIImage *)image overlayImage:(UIImage *)overlay 
{
    CGRect imageRect = CGRectMake(0, 0, DOCKITEM_THUMBSIZE, DOCKITEM_THUMBSIZE);
    // Quick exit if the image is just right and there's no overlay
    if (!overlay && CGSizeEqualToSize(image.size, imageRect.size)) {
        return image;
    }
    UIGraphicsBeginImageContextWithOptions(imageRect.size, NO, [UIScreen mainScreen].scale);
    [image drawInRect:imageRect];
    if (overlay) {
        [overlay drawInRect:imageRect];
    }
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}

@end
