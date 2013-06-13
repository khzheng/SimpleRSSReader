//
//  SubscriptionViewController.m
//  SimpleRSSReader
//
//  Created by Ken Zheng on 6/12/13.
//  Copyright (c) 2013 Ken Zheng. All rights reserved.
//

#import "SubscriptionViewController.h"
#import "FeedSubscription.h"
#import "FeedViewController.h"

@interface SubscriptionViewController ()

@end

@implementation SubscriptionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        FeedSubscription *feed = [[[FeedSubscription alloc] initWithTitle:@"SlickDeals" link:@"http://feeds.feedburner.com/SlickdealsnetFP" summary:@""] autorelease];
        
        subscriptions = [[NSMutableArray alloc] init];
        [subscriptions addObject:feed];
        
        feedViewController = [[FeedViewController alloc] initWithNibName:@"FeedViewController" bundle:nil];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setTitle:@"Feeds"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [subscriptions release];
    
    [super dealloc];
}

#pragma mark - UITableViewDelegate 

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FeedSubscription *feed = [subscriptions objectAtIndex:[indexPath row]];
    NSLog(@"%@", [feed description]);
    
    [feedViewController setFeed:feed];
    [self.navigationController pushViewController:feedViewController animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [subscriptions count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    FeedSubscription *feed = [subscriptions objectAtIndex:[indexPath row]];
    [[cell textLabel] setText:[feed title]];
    
    return cell;
    
//    static NSString *CellIdentifier = @"Cell";
//    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
//    }
//    
//    RSSEntry *entry = [allEntries objectAtIndex:[indexPath row]];
//    
//    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
//    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
//    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
//    NSString *articleDateString = [dateFormatter stringFromDate:[entry articleDate]];
//    
//    [[cell textLabel] setText:[entry articleTitle]];
//    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@", articleDateString, [entry blogTitle]];
//    
//    return cell;
}

@end
