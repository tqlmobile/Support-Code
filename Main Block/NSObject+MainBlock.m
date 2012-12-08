//
//  NSObject+MainBlock.m
//  Virtuoso
//
//  Created by Josh on 3/29/11.
//  Copyright 2011 Penthera Partners, Inc. All rights reserved.
//

#import "NSObject+MainBlock.h"

@implementation NSObject (AddMainThreadBlockExecution)

- (void)fireBlock:(void(^)(void))block {
    block();
}

- (void)performBlockOnMainThread:(void (^)(void))block {
    block = [[block copy] autorelease];
    [self performSelectorOnMainThread:@selector(fireBlock:) withObject:block waitUntilDone:NO];
}

- (void)performBlockOnMainThreadAndWait:(void (^)())block {
    block = [[block copy] autorelease];
    [self performSelectorOnMainThread:@selector(fireBlock:) withObject:block waitUntilDone:YES];
}

@end
