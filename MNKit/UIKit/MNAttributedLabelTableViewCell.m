//
//  MNAttributedLabelTableViewCell.m
//  MindNodeTouch
//
//  Created by Markus Müller on 27.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MNAttributedLabelTableViewCell.h"
#import "MNAttributedLabel.h"

@interface MNAttributedLabelTableViewCell ()

@property (nonatomic,readwrite,retain) MNAttributedLabel *attributedLabel;

@end

@implementation MNAttributedLabelTableViewCell


+ (UITableViewCellStyle)cellStyle
{
    return UITableViewCellStyleValue1;
}

- (id)initWithCellIdentifier:(NSString *)cellID 
{
    self = [super initWithCellIdentifier:cellID];
    if (!self) return nil;
        
    self.attributedLabel = [[[MNAttributedLabel alloc] initWithFrame:CGRectZero] autorelease];
    self.attributedLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
    self.attributedLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.attributedLabel];
    
    return self;
}


@synthesize attributedLabel=_attributedLabel;

- (void)dealloc 
{
    MNRelease(_attributedLabel);
    [super dealloc];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect frame = CGRectMake(10, 10, self.contentView.bounds.size.width-20.f, self.contentView.bounds.size.height-20.f);
    self.attributedLabel.frame = frame;
    
}


@end
