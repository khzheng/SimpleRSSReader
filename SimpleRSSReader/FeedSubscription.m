//
//  FeedSubscription.m
//  SimpleRSSReader
//
//  Created by Ken Zheng on 6/12/13.
//  Copyright (c) 2013 Ken Zheng. All rights reserved.
//

#import "FeedSubscription.h"

@implementation FeedSubscription

@synthesize title;
@synthesize link;
@synthesize summary;

- (id)init {
    self = [super init];
    if (self) {
        title = @"";
        link = @"";
        summary = @"";
    }
    
    return self;
}

- (id)initWithTitle:(NSString *)aTitle
               link:(NSString *)aLink
            summary:(NSString *)aSummary {
    self = [super init];
    if (self) {
        title = [aTitle copy];
        link = [aLink copy];
        summary = [aSummary copy];
    }
    
    return self;
}

- (void)dealloc {
    [title release];
    [link release];
    [summary release];
    
    [super dealloc];
}

- (NSString *)description {
    NSString *description = [NSString stringWithFormat:@"\nFeed info {\n\ttitle: %@,\nlink: %@,\nsummary: %@", title, link, summary];
    return description;
}

@end
