//
//  NSObject+MainBlock.h
//  Virtuoso
//
//  Created by Josh on 3/29/11.
//  Copyright 2011 Penthera Partners, Inc. All rights reserved.
//

@interface NSObject (AddMainThreadBlockExecution) 

- (void)fireBlock:(void(^)(void))block;
- (void)performBlockOnMainThread:(void (^)(void))block;
- (void)performBlockOnMainThreadAndWait:(void (^)())block;

@end
