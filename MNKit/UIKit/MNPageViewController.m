//
//  MNPageViewController.m
//  MindNodeTouch
//
//  Created by Markus Müller on 24.03.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MNPageViewController.h"

@interface MNPageViewController () <UIScrollViewDelegate>

@property (nonatomic, retain) NSArray *viewControllers;
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UIPageControl *pageControl;
@property (nonatomic) BOOL pageControlUsed;

- (void)_loadScrollViewWithPage:(NSUInteger)page;

@end

@implementation MNPageViewController

#pragma mark - Properties

@synthesize viewControllers = _viewControllers;
@synthesize scrollView = _scrollView;
@synthesize pageControl = _pageControl;
@synthesize pageControlUsed = _pageControlUsed;

#pragma mark - Init

- (id)initWithViewControllers:(NSArray *)viewControllers;
{
    self = [super initWithNibName:nil bundle:nil];
    if (!self) return nil;
    
    self.viewControllers = viewControllers;
    self.pageControlUsed = NO;
        
   return self;
}


- (void)dealloc
{
    MNRelease(_viewControllers);
    MNRelease(_scrollView);
    MNRelease(_pageControl);
    
    [super dealloc];
}


#pragma mark - View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    self.view = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;

    self.scrollView = [[[UIScrollView alloc] initWithFrame:CGRectZero] autorelease];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.scrollsToTop = NO;
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    [self.view addSubview:self.scrollView];
    
    self.pageControl = [[[UIPageControl alloc] initWithFrame:CGRectZero] autorelease];
    self.pageControl.numberOfPages = [self.viewControllers count];
    self.pageControl.currentPage = 0;
    self.pageControl.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [self.pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.pageControl];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.view.backgroundColor = [UIColor colorWithWhite:0.82f alpha:1.0f];
    } else {
        self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.view = nil;
    self.scrollView = nil;
    self.pageControl = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    static CGFloat pageControlHeight = 18;
    CGRect frame = self.view.bounds;
    frame.size.height -= pageControlHeight;
    self.scrollView.frame = frame;
    self.scrollView.contentSize = CGSizeMake(frame.size.width * [self.viewControllers count], frame.size.height);
    
    frame.origin.y = frame.size.height;
    frame.size.height = pageControlHeight;
    self.pageControl.frame = frame;

    [self _loadScrollViewWithPage:0];
    [self _loadScrollViewWithPage:1];
    
    self.title = [[self.viewControllers objectAtIndex:0] title];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Internal

- (void)_loadScrollViewWithPage:(NSUInteger)page
{
    if (page >= [self.viewControllers count])
        return;
    
    // replace the placeholder if necessary
    UIViewController *controller = [self.viewControllers objectAtIndex:page];
    
    // add the controller's view to the scroll view
    [controller viewWillAppear:NO];
    if (controller.view.superview != nil) {
        [controller viewDidAppear:NO];
        return;
    }
    CGRect frame = self.scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    controller.view.frame = frame;
    [self.scrollView addSubview:controller.view];
    [controller viewDidAppear:NO];

}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    if (self.pageControlUsed) {
        // do nothing - the scroll was initiated from the page control, not the user dragging
        return;
    }
	
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = self.scrollView.frame.size.width;
    NSUInteger page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
    
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self _loadScrollViewWithPage:page - 1];
    [self _loadScrollViewWithPage:page];
    [self _loadScrollViewWithPage:page + 1];
    
    // A possible optimization would be to unload the views+controllers which are no longer visible
    
    if (page < [self.viewControllers count]) {
        self.title = [[self.viewControllers objectAtIndex:page] title];
    }
}

// At the begin of scroll dragging, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.pageControlUsed = NO;
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.pageControlUsed = NO;
}

- (IBAction)changePage:(id)sender
{
    NSUInteger page = self.pageControl.currentPage;
	
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self _loadScrollViewWithPage:page - 1];
    [self _loadScrollViewWithPage:page];
    [[self.viewControllers objectAtIndex:page] viewWillAppear:YES];
    [[self.viewControllers objectAtIndex:page] viewDidAppear:YES];
    [self _loadScrollViewWithPage:page + 1];
    
	// update the scroll view to the appropriate page
    CGRect frame = self.scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [self.scrollView scrollRectToVisible:frame animated:YES];
    
	// Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
    self.pageControlUsed = YES;
    
    if (page < [self.viewControllers count]) {
        self.title = [[self.viewControllers objectAtIndex:0] title];
    }

}

@end
