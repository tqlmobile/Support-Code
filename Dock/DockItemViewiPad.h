//
//  DockItemView.h
//

#import <UIKit/UIKit.h>
#import "CustomBadge.h"
#import "DockItemView.h"

#define DOCKITEM_FONTSIZE_IPAD   14
#define DOCKITEM_LABELGAP_IPAD   5
#define DOCKITEM_THUMBSIZE_IPAD  72
#define DOCKITEM_INSET_IPAD      5
#define DOCKITEM_WIDTH_IPAD      (DOCKITEM_THUMBSIZE_IPAD + DOCKITEM_INSET_IPAD)
#define DOCKITEM_HEIGHT_IPAD     (DOCKITEM_THUMBSIZE_IPAD + DOCKITEM_INSET_IPAD + DOCKITEM_LABELGAP_IPAD + DOCKITEM_FONTSIZE_IPAD)
#define DOCKITEM_MIRRORSIZE_IPAD 36


@interface DockItemViewiPad : DockItemView {
}

-(id)initWithImage:(UIImage *)thumbnail title:(NSString *)title withShineNamed:(NSString *)shineName usingReflection:(Boolean)useReflection;
-(id)initWithImage:(UIImage *)thumbnail title:(NSString *)title  withShineNamed:(NSString *)aShineName usingReflection:(Boolean)_useReflection usingTitleShadow:(Boolean)useTitleShadow;
-(id)initWithImage:(UIImage *)thumbnail title:(NSString *)title  withShineNamed:(NSString *)aShineName usingReflection:(Boolean)_useReflection usingTitleShadow:(Boolean)useTitleShadow usingIconShadow:(Boolean)useIconShadow;

// Sets the button image and applies shine if set. Note that directly acccessing
// the button's image will not apply shine
-(void)setButtonImage:(UIImage *)anImage;

@end
