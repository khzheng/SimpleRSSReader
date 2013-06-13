//
//  FeedViewController.m
//  SimpleRSSReader
//
//  Created by Ken Zheng on 6/12/13.
//  Copyright (c) 2013 Ken Zheng. All rights reserved.
//

#import "FeedViewController.h"
#import "FeedSubscription.h"

@interface FeedViewController ()

@end

@implementation FeedViewController

@synthesize feed;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        feed = nil;
        feedItems = [[NSMutableArray alloc] init];
        queue = [[NSOperationQueue alloc] init];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setTitle:[feed title]];
    
    [self refresh];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [feed release];
    [feedItems release];
    [queue release];
    
    [super dealloc];
}

- (void)refresh {
    NSURL *url = [NSURL URLWithString:[feed link]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [queue addOperation:request];
}

#pragma mark - ASIHTTPRequestDelegate

- (void)requestFinished:(ASIHTTPRequest *)request {
    NSLog(@"requestFinished");
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    NSLog(@"requestFailed: %@", [request error]);
}

@end
