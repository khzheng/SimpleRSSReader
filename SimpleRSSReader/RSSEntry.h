//
//  RSSEntry.h
//  SimpleRSSReader
//
//  Created by Ken Zheng on 6/5/13.
//  Copyright (c) 2013 Ken Zheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSSEntry : NSObject {
    NSString *blogTitle;
    NSString *articleTitle;
    NSString *articleUrlString;
    NSDate *articleDate;
}

@property (nonatomic, copy) NSString *blogTitle;
@property (nonatomic, copy) NSString *articleTitle;
@property (nonatomic, copy) NSString *articleUrlString;
@property (nonatomic, copy) NSDate *articleDate;

- (id)initWithBlogTitle:(NSString *)aBlogTitle
           articleTitle:(NSString *)anArticleTitle
       articleUrlString:(NSString *)anArticleUrlString
            articleDate:(NSDate *)anArticleDate;

@end
