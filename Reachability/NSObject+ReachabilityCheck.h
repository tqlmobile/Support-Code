//
//  NSObject+MainBlock.h
//  Virtuoso
//
//  Created by Josh on 3/29/11.
//  Copyright 2011 Penthera Partners, Inc. All rights reserved.
//

@interface NSObject (AddReachabilityCheck) 

- (Boolean)checkForReachabilityAndWarn:(Boolean)showWarningAlert;
- (Boolean)checkForReachabilityAndWarnForOfflineData:(Boolean)showWarningAlert;

@end
