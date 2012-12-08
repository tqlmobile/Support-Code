//
//  MKEntryPanelDemoViewController.m
//  MKEntryPanelDemo
//
//  Created by Mugunth on 07/05/11.
//  Copyright 2011 Steinlogic. All rights reserved.
//

#import "MKEntryPanelDemoViewController.h"
#import "MKEntryPanel.h"

@implementation MKEntryPanelDemoViewController

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(IBAction) addTapped:(id) sender
{
    [MKEntryPanel showPanelWithTitle:NSLocalizedString(@"Enter a text name", @"") 
                              inView:self.view 
                       onTextEntered:^(NSString* enteredString)
     {
         NSLog(@"Entered: %@", enteredString);
     }];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
	return YES;
}

@end
