//
//  SubscriptionViewController.h
//  SimpleRSSReader
//
//  Created by Ken Zheng on 6/12/13.
//  Copyright (c) 2013 Ken Zheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubscriptionViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    NSMutableArray *subscriptions;
    
    IBOutlet UITableView *table;
}

@end
