//
//  ViewController.h
//  SimpleRSSReader
//
//  Created by Ken Zheng on 6/5/13.
//  Copyright (c) 2013 Ken Zheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"

@class WebViewController;

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, ASIHTTPRequestDelegate> {
    NSMutableArray *allEntries;
    
    NSOperationQueue *queue;
    NSArray *feeds;
    
    WebViewController *webViewController;
    
    IBOutlet UITableView *table;
}

@property (nonatomic, retain) NSMutableArray *allEntries;
@property (nonatomic, retain) NSOperationQueue *queue;
@property (nonatomic, retain) NSArray *feeds;
@property (nonatomic, retain) WebViewController *webViewController;

@end
