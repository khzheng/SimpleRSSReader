//
//  FeedItem.m
//  SimpleRSSReader
//
//  Created by Ken Zheng on 6/12/13.
//  Copyright (c) 2013 Ken Zheng. All rights reserved.
//

#import "FeedItem.h"

@implementation FeedItem

@synthesize title;
@synthesize link;
@synthesize date;
@synthesize updated;
@synthesize summary;
@synthesize content;

- (id)init {
    self = [super init];
    if (self) {
        title = @"";
        link = @"";
        date = nil;
        updated= nil;
        summary = @"";
        content = @"";
    }
    
    return self;
}

- (id)initWithTitle:(NSString *)aTitle
               link:(NSString *)aLink
               date:(NSDate *)aDate
            updated:(NSDate *)anUpdated
            summary:(NSString *)aSummary
            content:(NSString *)aContent {
    self = [super init];
    if (self) {
        if (aTitle == nil) aTitle = @"";
        if (aLink == nil) aLink = @"";
        if (aSummary == nil) aSummary = @"";
        if (aContent == nil) aContent = @"";
        
        title = [aTitle copy];
        link = [aLink copy];
        date = [aDate copy];
        updated = [anUpdated copy];
        summary = [aSummary copy];
        content = [aContent copy];
    }
    
    return self;
}

- (void)dealloc {
    [title release];
    [link release];
    [date release];
    [updated release];
    [summary release];
    [content release];
    
    [super dealloc];
}

@end
