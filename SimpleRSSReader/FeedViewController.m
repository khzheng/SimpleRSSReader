//
//  FeedViewController.m
//  SimpleRSSReader
//
//  Created by Ken Zheng on 6/12/13.
//  Copyright (c) 2013 Ken Zheng. All rights reserved.
//

#import "FeedViewController.h"
#import "FeedSubscription.h"
#import "FeedItem.h"

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

#pragma mark - UITableViewDataSource

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [feedItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifer = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifer] autorelease];
    }
    
    FeedItem *feedItem = [feedItems objectAtIndex:[indexPath row]];
    
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    NSString *dateString = [dateFormatter stringFromDate:[feedItem date]];
    
    [[cell textLabel] setText:[feedItem title]];
    [[cell detailTextLabel] setText:dateString];
    
    return cell;
}

#pragma mark - ASIHTTPRequestDelegate

- (void)requestFinished:(ASIHTTPRequest *)request {
    NSLog(@"requestFinished");
    
    FeedItem *feedItem = [[[FeedItem alloc] initWithTitle:@"title" link:@"link" date:nil updated:nil summary:nil content:nil] autorelease];
    [feedItems insertObject:feedItem atIndex:0];
    
    [table insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationRight];
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    NSLog(@"requestFailed: %@", [request error]);
}

@end
