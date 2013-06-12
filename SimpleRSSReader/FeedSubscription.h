//
//  FeedSubscription.h
//  SimpleRSSReader
//
//  Created by Ken Zheng on 6/12/13.
//  Copyright (c) 2013 Ken Zheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FeedSubscription : NSObject {
    NSString *title;
    NSString *link;
    NSString *summary;
}

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *link;
@property (nonatomic, copy) NSString *summary;

- (id)initWithTitle:(NSString *)aTitle link:(NSString *)aLink summary:(NSString *)aSummary;

@end
