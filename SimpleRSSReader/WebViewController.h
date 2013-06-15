//
//  WebViewController.h
//  SimpleRSSReader
//
//  Created by Ken Zheng on 6/12/13.
//  Copyright (c) 2013 Ken Zheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FeedItem;

@interface WebViewController : UIViewController {
    IBOutlet UIWebView *webView;
    FeedItem *feedItem;
}

@property (nonatomic, retain) FeedItem *feedItem;

@end
