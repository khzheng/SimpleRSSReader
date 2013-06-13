//
//  SubscriptionViewController.h
//  SimpleRSSReader
//
//  Created by Ken Zheng on 6/12/13.
//  Copyright (c) 2013 Ken Zheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FeedViewController;

@interface SubscriptionViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    NSMutableArray *subscriptions;
    FeedViewController *feedViewController;
    
    IBOutlet UITableView *table;
}

@end
