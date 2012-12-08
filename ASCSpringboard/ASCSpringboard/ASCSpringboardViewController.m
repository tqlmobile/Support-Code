//
//  ASCSpringboard.m
//  ASCSpringboard
//
//  Created by admin on 10/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ASCSpringboardViewController.h"

// --------------------------------------//
const static int kRowZeroY = 377;
const static int kRowOneY = 283;
const static int kRowTwoY = 202;
const static int kRowThreeY = 130;

const static int kColumnZeroX = 20;
const static int kColumnOneX = 94;
const static int kColumnTwoX = 166;
const static int kColumnThreeX = 245;

const static int kOneItemRowZeroColumnZeroX = 132;

const static int kTwoItemRowZeroColumnZeroX = 78;
const static int kTwoItemRowZeroColumnOneX = 186;

const static int kThreeItemRowZeroColumnZeroX = 46;
const static int kThreeItemRowZeroColumnOneX = 132;
const static int kThreeItemRowZeroColumnTwoX = 218;

// --------------------------------------//
const static int kRowZeroY_iPad = 897;
const static int kRowOneY_iPad = 676;
const static int kRowTwoY_iPad = 485;
const static int kRowThreeY_iPad = 293;

const static int kColumnZeroX_iPad = 80;
const static int kColumnOneX_iPad = 250;
const static int kColumnTwoX_iPad = 440;
const static int kColumnThreeX_iPad = 620;

const static int kOneItemRowZeroColumnZeroX_iPad = 345;

const static int kTwoItemRowZeroColumnZeroX_iPad = 205;
const static int kTwoItemRowZeroColumnOneX_iPad = 486;

const static int kThreeItemRowZeroColumnZeroX_iPad = 157;
const static int kThreeItemRowZeroColumnOneX_iPad = 347;
const static int kThreeItemRowZeroColumnTwoX_iPad = 544;
// --------------------------------------//

@interface ASCSpringboardViewController() {
    NSMutableArray* dockItems;
}

@property (nonatomic,retain) NSMutableArray* dockItems;

@end

@implementation ASCSpringboardViewController

@synthesize dataSource,delegate,dockItems;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc {
    self.dockItems = nil;
    self.dataSource = nil;
    self.delegate = nil;
    [super dealloc];
}

-(void)viewDidLoad {
    [super viewDidLoad];
    self.dockItems = [[[NSMutableArray alloc]init]autorelease];    
}

-(void)dockItemViewWasPressed:(id)dockItem {
    for( int page = 0; page < [dockItems count]; page++ )
    {
        //NSLog(@"Looking at page(%d)...",page);
        NSDictionary* rows = [dockItems objectAtIndex:page];
        for( int row = 0; row < [[rows allKeys]count]; row++ )
        {
            NSNumber* rowNum = [[rows allKeys]objectAtIndex:row];
            //NSLog(@"Looking at page(%d),row(%d)...",page,[rowNum intValue]);
            NSDictionary* columns = [rows objectForKey:rowNum];
            for( int column = 0; column < [[columns allKeys]count]; column++ )
            {
                NSNumber* colNum = [[columns allKeys]objectAtIndex:column];
                //NSLog(@"Looking at page(%d),row(%d),column(%d)...",page,[rowNum intValue],[colNum intValue]);
                if( [[columns objectForKey:colNum]isEqual:dockItem] )
                {
                    [delegate springboard:self didTapDockItemAtIndexPath:[NSIndexPath indexPathForRow:[colNum intValue] inSection:[rowNum intValue]] onPage:page];
                    break;
                }
            }
        }
    }
    //NSLog(@"Dock item not found");
}

- (DockItemView*)currentDockItemViewForIndexPath:(NSIndexPath*)indexPath onPage:(NSInteger)page {
    DockItemView* ret = nil;
    @try {
        NSDictionary* rows = [dockItems objectAtIndex:page];
        NSDictionary* row = [rows objectForKey:[NSNumber numberWithInt:indexPath.section]];
        ret = [row objectForKey:[NSNumber numberWithInt:indexPath.row]];
    }
    @catch (NSException *exception) {
        ret = nil;
    }
    return ret;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    //NSLog(@"should rotate?");
    return [delegate springboard:self shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

- (void)reloadData {
	
    dockView0.image = [delegate dockImageForRow:0];
    dockView1.image = [delegate dockImageForRow:1];
    dockView2.image = [delegate dockImageForRow:2];
    dockView3.image = [delegate dockImageForRow:3];
    
    background.image = [delegate backgroundImage];
    logo.image = [delegate logoImage];
    
	CGSize size = theScrollView.contentSize;
	size.width = theScrollView.frame.size.width * [dataSource numberOfPagesForSpringboard:self];
	theScrollView.contentSize = size;
    
	for( UIView* oldView in theScrollView.subviews )
	{
		if( [oldView isKindOfClass:[DockItemView class]] )
			[oldView removeFromSuperview];
	}
	for( UIView* oldView in self.view.subviews )
	{
		if( [oldView isKindOfClass:[DockItemView class]] )
			[oldView removeFromSuperview];
	}
	[self.dockItems removeAllObjects];
	
    int totalItems = 0;
    int numPages = [dataSource numberOfPagesForSpringboard:self];
    for( int i = 0; i < numPages; i++ )
    {
        [dockItems addObject:[[[NSMutableDictionary alloc]init]autorelease]];
        for( int j = 0; j < 4; j++ )
        {
            totalItems += [dataSource springboard:self numberOfItemsForRow:j inPage:i];
        }
    }
    
	if( totalItems > 0 )
	{
		if( numPages > 1 )
		{
			pageControl.hidden = NO;
			[pageControl setNumberOfPages:numPages];
			pageControl.currentPage = 0;
		}
		else
		{
			[pageControl setNumberOfPages:1];
			pageControl.currentPage = 0;
			pageControl.hidden = YES;
		}
        
		for( int page = 0; page < numPages; page++ )
		{
            for( int row = 0; row < 4; row++ )
            {
                int numItems = [dataSource springboard:self numberOfItemsForRow:row inPage:page];
                for( int column = 0; column < 4; column++ )
                {
                    DockItem* item  = [dataSource springboard:self 
                                         dockItemForIndexPath:[NSIndexPath indexPathForRow:column inSection:row]
                                                       onPage:page];
                                                       
                    if( item != nil )
                    {
                        int x = -100;
                        int y = -100;
                        switch (row) {
                            case 0:
                                y = (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)?kRowZeroY_iPad:kRowZeroY;
                                switch (numItems) {
                                    case 1:
                                        x = (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)?kOneItemRowZeroColumnZeroX_iPad:kOneItemRowZeroColumnZeroX;
                                        break;
                                    case 2:
                                        switch (column) {
                                            case 0:
                                                x = (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)?kTwoItemRowZeroColumnZeroX_iPad:kTwoItemRowZeroColumnZeroX;
                                                break;
                                            case 1:
                                                x = (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)?kTwoItemRowZeroColumnOneX_iPad:kTwoItemRowZeroColumnOneX;
                                                break;
                                            default:
                                                break;
                                        }
                                        break;
                                    case 3:
                                        switch (column) {
                                            case 0:
                                                x = (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)?kThreeItemRowZeroColumnZeroX_iPad:kThreeItemRowZeroColumnZeroX;
                                                break;
                                            case 1:
                                                x = (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)?kThreeItemRowZeroColumnOneX_iPad:kThreeItemRowZeroColumnOneX;
                                                break;
                                            case 2:
                                                x = (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)?kThreeItemRowZeroColumnTwoX_iPad:kThreeItemRowZeroColumnTwoX;
                                            default:
                                                break;
                                        }
                                        break;
                                    case 4:
                                    default:
                                        switch (column) {
                                            case 0:
                                                x = (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)?kColumnZeroX_iPad:kColumnZeroX;
                                                break;
                                            case 1:
                                                x = (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)?kColumnOneX_iPad:kColumnOneX;
                                                break;
                                            case 2:
                                                x = (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)?kColumnTwoX_iPad:kColumnTwoX;
                                                break;
                                            case 3:
                                                x = (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)?kColumnThreeX_iPad:kColumnThreeX;
                                                break;
                                            default:
                                                break;
                                        }
                                        break;
                                }
                                break;
                            case 1:
                                y = (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)?kRowOneY_iPad:kRowOneY;
                                switch (numItems) {
                                    case 1:
                                        x = (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)?kOneItemRowZeroColumnZeroX_iPad:kOneItemRowZeroColumnZeroX;
                                        break;
                                    case 2:
                                        switch (column) {
                                            case 0:
                                                x = (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)?kTwoItemRowZeroColumnZeroX_iPad:kTwoItemRowZeroColumnZeroX;
                                                break;
                                            case 1:
                                                x = (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)?kTwoItemRowZeroColumnOneX_iPad:kTwoItemRowZeroColumnOneX;
                                                break;
                                            default:
                                                break;
                                        }
                                        break;
                                    case 3:
                                        switch (column) {
                                            case 0:
                                                x = (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)?kThreeItemRowZeroColumnZeroX_iPad:kThreeItemRowZeroColumnZeroX;
                                                break;
                                            case 1:
                                                x = (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)?kThreeItemRowZeroColumnOneX_iPad:kThreeItemRowZeroColumnOneX;
                                                break;
                                            case 2:
                                                x = (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)?kThreeItemRowZeroColumnTwoX_iPad:kThreeItemRowZeroColumnTwoX;
                                            default:
                                                break;
                                        }
                                        break;
                                    case 4:
                                    default:
                                        switch (column) {
                                            case 0:
                                                x = (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)?kColumnZeroX_iPad:kColumnZeroX;
                                                break;
                                            case 1:
                                                x = (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)?kColumnOneX_iPad:kColumnOneX;
                                                break;
                                            case 2:
                                                x = (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)?kColumnTwoX_iPad:kColumnTwoX;
                                                break;
                                            case 3:
                                                x = (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)?kColumnThreeX_iPad:kColumnThreeX;
                                                break;
                                            default:
                                                break;
                                        }
                                        break;
                                }
                                break;
                            case 2:
                                y = (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)?kRowTwoY_iPad:kRowTwoY;
                                switch (numItems) {
                                    case 1:
                                        x = (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)?kOneItemRowZeroColumnZeroX_iPad:kOneItemRowZeroColumnZeroX;
                                        break;
                                    case 2:
                                        switch (column) {
                                            case 0:
                                                x = (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)?kTwoItemRowZeroColumnZeroX_iPad:kTwoItemRowZeroColumnZeroX;
                                                break;
                                            case 1:
                                                x = (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)?kTwoItemRowZeroColumnOneX_iPad:kTwoItemRowZeroColumnOneX;
                                                break;
                                            default:
                                                break;
                                        }
                                        break;
                                    case 3:
                                        switch (column) {
                                            case 0:
                                                x = (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)?kThreeItemRowZeroColumnZeroX_iPad:kThreeItemRowZeroColumnZeroX;
                                                break;
                                            case 1:
                                                x = (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)?kThreeItemRowZeroColumnOneX_iPad:kThreeItemRowZeroColumnOneX;
                                                break;
                                            case 2:
                                                x = (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)?kThreeItemRowZeroColumnTwoX_iPad:kThreeItemRowZeroColumnTwoX;
                                            default:
                                                break;
                                        }
                                        break;
                                    case 4:
                                    default:
                                        switch (column) {
                                            case 0:
                                                x = (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)?kColumnZeroX_iPad:kColumnZeroX;
                                                break;
                                            case 1:
                                                x = (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)?kColumnOneX_iPad:kColumnOneX;
                                                break;
                                            case 2:
                                                x = (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)?kColumnTwoX_iPad:kColumnTwoX;
                                                break;
                                            case 3:
                                                x = (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)?kColumnThreeX_iPad:kColumnThreeX;
                                                break;
                                            default:
                                                break;
                                        }
                                        break;
                                }
                                break;
                            case 3:
                                y = ((UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)?kRowThreeY_iPad:kRowThreeY);
                                switch (numItems) {
                                    case 1:
                                        x = (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)?kOneItemRowZeroColumnZeroX_iPad:kOneItemRowZeroColumnZeroX;
                                        break;
                                    case 2:
                                        switch (column) {
                                            case 0:
                                                x = (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)?kTwoItemRowZeroColumnZeroX_iPad:kTwoItemRowZeroColumnZeroX;
                                                break;
                                            case 1:
                                                x = (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)?kTwoItemRowZeroColumnOneX_iPad:kTwoItemRowZeroColumnOneX;
                                                break;
                                            default:
                                                break;
                                        }
                                        break;
                                    case 3:
                                        switch (column) {
                                            case 0:
                                                x = (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)?kThreeItemRowZeroColumnZeroX_iPad:kThreeItemRowZeroColumnZeroX;
                                                break;
                                            case 1:
                                                x = (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)?kThreeItemRowZeroColumnOneX_iPad:kThreeItemRowZeroColumnOneX;
                                                break;
                                            case 2:
                                                x = (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)?kThreeItemRowZeroColumnTwoX_iPad:kThreeItemRowZeroColumnTwoX;
                                            default:
                                                break;
                                        }
                                        break;
                                    case 4:
                                    default:
                                        switch (column) {
                                            case 0:
                                                x = (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)?kColumnZeroX_iPad:kColumnZeroX;
                                                break;
                                            case 1:
                                                x = (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)?kColumnOneX_iPad:kColumnOneX;
                                                break;
                                            case 2:
                                                x = (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)?kColumnTwoX_iPad:kColumnTwoX;
                                                break;
                                            case 3:
                                                x = (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)?kColumnThreeX_iPad:kColumnThreeX;
                                                break;
                                            default:
                                                break;
                                        }
                                        break;
                                }
                                break;
                            default:
                                break;
                        }
                        
                        Boolean useReflection = NO;
                        if( row == 0 )
                            if( dockView0.image != nil ) useReflection = YES;
                        if( row == 1 )
                            if( dockView1.image != nil ) useReflection = YES;
                        if( row == 2 )
                            if( dockView2.image != nil ) useReflection = YES;
                        if( row == 3 )
                            if( dockView3.image != nil ) useReflection = YES;
                        
                        DockItemView* newDockItem = [[[(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)?[DockItemViewiPad class]:[DockItemView class] alloc]
                                                      initWithImage:item.icon
                                                              title:item.title 
                                                     withShineNamed:nil 
                                                    usingReflection:useReflection 
                                                   usingTitleShadow:NO]autorelease];
                        
                        newDockItem.delegate = self;
                        
                        newDockItem.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;

                        if( item.badge > 0 )
                            [newDockItem setBadgeString:[NSString stringWithFormat:@"%d",item.badge]];
                        
                        newDockItem.frame = 
                            CGRectMake(x, 
                                       y, 
                                       (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)?110:55, 
                                       (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)?110:55);
                        
                        newDockItem.userInfo = item.userInfo;
                        if( y == kRowZeroY || y == kRowZeroY_iPad )
                        {
                            [self.view addSubview:newDockItem];
                        }
                        else
                        {
                            [theScrollView addSubview:newDockItem];
                        }
                        
                        NSMutableDictionary* pages = [dockItems objectAtIndex:page];
                        NSMutableDictionary* columns = [pages objectForKey:[NSNumber numberWithInt:row]];
                        if( columns == nil )
                            columns = [[[NSMutableDictionary alloc]init]autorelease];
                        
                        [columns setObject:newDockItem forKey:[NSNumber numberWithInt:column]];
                        [pages setObject:columns forKey:[NSNumber numberWithInt:row]];
                        [dockItems replaceObjectAtIndex:page withObject:pages];
                    }
               }
            }

		}
	}
	else
	{
		pageControl.hidden = YES;
	}
}

- (void)reloadDataForIndexPath:(NSIndexPath *)indexPath onPage:(NSInteger)page {
    DockItem* item = [dataSource springboard:self dockItemForIndexPath:indexPath onPage:page];
    
    DockItemView* itemView = [[[dockItems objectAtIndex:page]objectForKey:[NSNumber numberWithInt:indexPath.section]]objectForKey:[NSNumber numberWithInt:indexPath.row]];
    
    [itemView setLabelText:item.title];
    [itemView setButtonImage:item.icon];
    if( item.badge > 0 )
        [itemView setBadgeString:[NSString stringWithFormat:@"%d",item.badge]];
    else
        [itemView setBadgeString:nil];

    [itemView setNeedsDisplay];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadData];
}

@end
