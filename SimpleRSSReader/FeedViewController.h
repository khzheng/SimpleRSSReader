//
//  FeedViewController.h
//  SimpleRSSReader
//
//  Created by Ken Zheng on 6/12/13.
//  Copyright (c) 2013 Ken Zheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"

@class FeedSubscription;

@interface FeedViewController : UIViewController <ASIHTTPRequestDelegate> {
    FeedSubscription *feed;
    
    NSMutableArray *feedItems;
    NSOperationQueue *queue;
}

@property (nonatomic, retain) FeedSubscription *feed;

@end
