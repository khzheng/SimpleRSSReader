//
//  WebViewController.h
//  SimpleRSSReader
//
//  Created by Ken Zheng on 6/12/13.
//  Copyright (c) 2013 Ken Zheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RSSEntry;

@interface WebViewController : UIViewController {
    UIWebView *webView;
    RSSEntry *entry;
}

@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) RSSEntry *entry;

@end
