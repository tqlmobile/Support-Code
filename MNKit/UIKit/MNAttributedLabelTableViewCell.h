//
//  MNAttributedLabelTableViewCell.h
//  MindNodeTouch
//
//  Created by Markus Müller on 27.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MNTableViewCell.h"
#import "MNAttributedLabel.h"

@interface MNAttributedLabelTableViewCell : MNTableViewCell 

@property (nonatomic,readonly,retain) MNAttributedLabel *attributedLabel;

@end
