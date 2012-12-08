//
//  ASCSpringboard.h
//  ASCSpringboard
//
//  Created by admin on 10/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DockItemView.h"
#import "DockItemViewiPad.h"
#import "DockItem.h"

@class ASCSpringboardViewController;

@protocol ASCSpringBoardViewControllerDelegate <NSObject>

- (UIImage*)dockImageForRow:(NSInteger)row;
- (UIImage*)backgroundImage;
- (UIImage*)logoImage;

- (BOOL)springboard:(ASCSpringboardViewController*)springboard shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;

- (void)springboard:(ASCSpringboardViewController*)springboard didTapDockItemAtIndexPath:(NSIndexPath*)indexPath onPage:(NSInteger)page;

@end

@protocol ASCSpringBoardViewControllerDataSource <NSObject>

- (DockItem*)springboard:(ASCSpringboardViewController*)springboard dockItemForIndexPath:(NSIndexPath*)indexPath onPage:(NSInteger)page;

- (NSInteger)numberOfPagesForSpringboard:(ASCSpringboardViewController*)springboard;
- (NSInteger)springboard:(ASCSpringboardViewController*)springboard numberOfItemsForRow:(NSInteger)row inPage:(NSInteger)page;

@end

@interface ASCSpringboardViewController : UIViewController<DockItemViewDelegate,UIScrollViewDelegate> {

@private
    IBOutlet UIPageControl* pageControl;
	IBOutlet UIScrollView* theScrollView;
	IBOutlet UIImageView* dockView0;
    IBOutlet UIImageView* dockView1;
    IBOutlet UIImageView* dockView2;
    IBOutlet UIImageView* dockView3;
    IBOutlet UIImageView* background;
    IBOutlet UIImageView* logo;
    
    id<ASCSpringBoardViewControllerDelegate> delegate;
    id<ASCSpringBoardViewControllerDataSource> dataSource;
}

- (void)reloadData;
- (void)reloadDataForIndexPath:(NSIndexPath*)indexPath onPage:(NSInteger)page;
- (DockItemView*)currentDockItemViewForIndexPath:(NSIndexPath*)indexPath onPage:(NSInteger)page;

@property (nonatomic,assign) id<ASCSpringBoardViewControllerDelegate> delegate;
@property (nonatomic,assign) id<ASCSpringBoardViewControllerDataSource> dataSource;

@end

