//
//  DockItemViewiPad.m
//

#import "DockItemViewiPad.h"
#import "CustomBadge.h"
#import <QuartzCore/QuartzCore.h>

CGImageRef createGradientImage(int width, int height);

@interface DockItemViewiPad() 

- (UIImage *)thumbNailFromImage:(UIImage *)image overlayImage:(UIImage *)overlay;


@end

#ifndef RGB
#define RGB(r,g,b) [UIColor colorWithRed:(r) green:(g) blue:(b) alpha:1]
#endif

@implementation DockItemViewiPad

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
    self = [self initWithFrame:CGRectMake(0, 0, DOCKITEM_WIDTH_IPAD, DOCKITEM_HEIGHT_IPAD)];
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
        button.frame = CGRectMake(DOCKITEM_INSET_IPAD, DOCKITEM_INSET_IPAD, 
                                  DOCKITEM_THUMBSIZE_IPAD, DOCKITEM_THUMBSIZE_IPAD);
        button.layer.cornerRadius = 5.0;
        button.layer.masksToBounds = YES;
		button.backgroundColor = [UIColor clearColor];
		
		[button addTarget:self action:@selector(dockButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        
        // Progress bar
        progress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
        progress.frame = CGRectMake(4, DOCKITEM_THUMBSIZE_IPAD - 15,
                                    DOCKITEM_THUMBSIZE_IPAD - 8, 11);
        progress.hidden = YES;
        
        // Set up reflection for button
        mirror = [[UIImageView alloc] initWithFrame:CGRectZero];
        mirror.frame = CGRectMake(DOCKITEM_INSET_IPAD, CGRectGetMaxY(button.frame), 
                                  DOCKITEM_THUMBSIZE_IPAD, DOCKITEM_MIRRORSIZE_IPAD);
        // Set up title label 
        label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.frame = CGRectMake(DOCKITEM_INSET_IPAD-25, DOCKITEM_HEIGHT_IPAD - DOCKITEM_FONTSIZE_IPAD - 1, 
                                 DOCKITEM_WIDTH_IPAD - DOCKITEM_INSET_IPAD+50, DOCKITEM_FONTSIZE_IPAD);
        label.text = title;
        [label setBackgroundColor:[UIColor clearColor]];
        [label setFont:[UIFont boldSystemFontOfSize:DOCKITEM_FONTSIZE_IPAD]];
        [label setTextAlignment:UITextAlignmentCenter];
        
        // Ensure that the mirror is below the shadowcontainer to get the button
        // to overlap
        [button addSubview:progress];
        [self addSubview:mirror];
        [self addSubview:shadowContainer];
        [shadowContainer addSubview:button];
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

- (void)setButtonImage:(UIImage *)anImage 
{
    UIImage *buttonImage = [self thumbNailFromImage:anImage 
                                       overlayImage:[UIImage imageNamed:shineName]];
    [button setImage:buttonImage forState:UIControlStateNormal];
	if( useReflection )
		mirror.image = [(DockItemView*)self reflectedImageForLayer:button.layer withHeight:DOCKITEM_MIRRORSIZE_IPAD];
}

- (void)setBadgeAlert:(BOOL)aValue
{
    UIImage *badgeImage = aValue ? [UIImage imageNamed:@"badge-alert.png"] : nil;
    if (!badge) {
        badge = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 
                                                              badgeImage.size.width, 
                                                              badgeImage.size.height)];
        badge.center = CGPointMake(CGRectGetMaxX(self.bounds) - DOCKITEM_INSET_IPAD,
                                   2 * DOCKITEM_INSET_IPAD);
        badge.layer.shadowOffset = CGSizeMake(0, 2);
        badge.layer.shadowRadius = 3;
        badge.layer.shadowOpacity = 0.8;

        [self addSubview:badge];
    }
    
    badge.image = badgeImage;
}

#pragma mark -
#pragma mark thumbnail and reflection construction

- (UIImage *)thumbNailFromImage:(UIImage *)image overlayImage:(UIImage *)overlay 
{
    CGRect imageRect = CGRectMake(0, 0, DOCKITEM_THUMBSIZE_IPAD, DOCKITEM_THUMBSIZE_IPAD);
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
