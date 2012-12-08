//
//  DockItemView.h
//

#import <UIKit/UIKit.h>
#import "CustomBadge.h"

#define DOCKITEM_FONTSIZE   11
#define DOCKITEM_LABELGAP   5
#define DOCKITEM_THUMBSIZE  55
#define DOCKITEM_INSET      5
#define DOCKITEM_WIDTH      (DOCKITEM_THUMBSIZE + DOCKITEM_INSET)
#define DOCKITEM_HEIGHT     (DOCKITEM_THUMBSIZE + DOCKITEM_INSET + DOCKITEM_LABELGAP + DOCKITEM_FONTSIZE)
#define DOCKITEM_MIRRORSIZE 30


#define kDockItemNormalShine @"dock-shine.png"
#define kDockItemGhostShine  @"dock-ghost.png"

@protocol DockItemViewDelegate<NSObject>

-(void)dockItemViewWasPressed:(id)dockItem;

@end


@interface DockItemView : UIView {
    UIButton *button;
    UIProgressView *progress;
    NSString *shineName;
    UIImageView *mirror;
    UILabel *label;
    UIView *shadowContainer;
	CustomBadge* customBadge;
    
    UIImageView *badge;
	NSString* badgeString;
	Boolean useReflection;
	id userInfo;
	id<DockItemViewDelegate> delegate;
}

-(id)initWithImage:(UIImage *)thumbnail title:(NSString *)title withShineNamed:(NSString *)shineName usingReflection:(Boolean)useReflection;
-(id)initWithImage:(UIImage *)thumbnail title:(NSString *)title withShineNamed:(NSString *)shineName usingReflection:(Boolean)useReflection usingTitleShadow:(Boolean)useTitleShadow;
-(id)initWithImage:(UIImage *)thumbnail title:(NSString *)title withShineNamed:(NSString *)shineName usingReflection:(Boolean)useReflection usingTitleShadow:(Boolean)useTitleShadow usingIconShadow:(Boolean)useIconShadow;

// Sets the button image and applies shine if set. Note that directly acccessing
// the button's image will not apply shine
-(void)setLabelColor:(UIColor*)color;
-(void)setLabelHighlightColor:(UIColor*)color;
-(void)setButtonImage:(UIImage *)anImage;
-(void)setProgress:(double)progress;
- (UIImage *)reflectedImageForLayer:(CALayer *)layer withHeight:(NSUInteger)height;
-(void)setLabelText:(NSString*)newLabel;

@property(nonatomic,readwrite,getter=isHighlighted)BOOL highlighted;
@property(nonatomic,readwrite,getter=hasAlertBadge)BOOL badgeAlert;

@property(nonatomic,readonly)UIButton *button;
@property(nonatomic,readonly)UILabel *label;
@property(nonatomic,retain) id userInfo;
@property(nonatomic,retain) id<DockItemViewDelegate> delegate;
@property(nonatomic,retain) NSString* badgeString;
@property(nonatomic,retain) CustomBadge* customBadge;

@end
