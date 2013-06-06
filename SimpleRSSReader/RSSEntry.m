//
//  RSSEntry.m
//  SimpleRSSReader
//
//  Created by Ken Zheng on 6/5/13.
//  Copyright (c) 2013 Ken Zheng. All rights reserved.
//

#import "RSSEntry.h"

@implementation RSSEntry

@synthesize blogTitle;
@synthesize articleTitle;
@synthesize articleUrlString;
@synthesize articleDate;

- (id)initWithBlogTitle:(NSString *)aBlogTitle articleTitle:(NSString *)anArticleTitle articleUrlString:(NSString *)anArticleUrlString articleDate:(NSDate *)anArticleDate {
    self = [super init];
    if (self) {
        blogTitle = [aBlogTitle copy];
        articleTitle = [anArticleTitle copy];
        articleUrlString = [anArticleUrlString copy];
        articleDate = [anArticleDate copy];
    }
    
    return self;
}

- (void)dealloc {
    [blogTitle release];
    [articleTitle release];
    [articleUrlString release];
    [articleDate release];
    
    blogTitle = nil;
    articleTitle = nil;
    articleUrlString = nil;
    articleDate = nil;
    
    [super dealloc];
}

@end
