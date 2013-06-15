//
//  FeedItem.h
//  SimpleRSSReader
//
//  Created by Ken Zheng on 6/12/13.
//  Copyright (c) 2013 Ken Zheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FeedItem : NSObject {
    NSString *title;
    NSString *link;
    NSDate *date;       // date the item was published
    NSDate *updated;    // date the item was updated (if available)
    NSString *summary;
    NSString *content;  // More detailed content (if available)
}

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *link;
@property (nonatomic, copy) NSDate *date;
@property (nonatomic, copy) NSDate *updated;
@property (nonatomic, copy) NSString *summary;
@property (nonatomic, copy) NSString *content;

- (id)initWithTitle:(NSString *)aTitle
               link:(NSString *)aLink
               date:(NSDate *)aDate
            updated:(NSDate *)anUpdated
            summary:(NSString *)aSummary
            content:(NSString *)aContent;

@end
