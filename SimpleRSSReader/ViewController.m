//
//  ViewController.m
//  SimpleRSSReader
//
//  Created by Ken Zheng on 6/5/13.
//  Copyright (c) 2013 Ken Zheng. All rights reserved.
//

#import "ViewController.h"
#import "RSSEntry.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize allEntries;
@synthesize queue;
@synthesize feeds;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self setTitle:@"Feeds"];
    allEntries = [[NSMutableArray alloc] init];
    queue = [[NSOperationQueue alloc] init];
    feeds = [NSArray arrayWithObjects:@"http://feeds.macrumors.com/MacRumors-All", @"http://feeds.feedburner.com/SlickdealsnetFP", nil];
    [self refresh];
//    [self addRows];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [allEntries release];
    [queue release];
    [feeds release];
    
    allEntries = nil;
    
    [super dealloc];
}

- (void)addRows {
    RSSEntry *entry1 = [[[RSSEntry alloc] initWithBlogTitle:@"1" articleTitle:@"1" articleUrlString:@"1" articleDate:[NSDate date]] autorelease];
    RSSEntry *entry2 = [[[RSSEntry alloc] initWithBlogTitle:@"2" articleTitle:@"2" articleUrlString:@"2" articleDate:[NSDate date]] autorelease];
    
    [allEntries addObject:entry1];
    [allEntries addObject:entry2];
}

- (void)refresh {
    for (NSString *feed in feeds) {
        NSURL *url = [NSURL URLWithString:feed];
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
        [request setDelegate:self];
        [queue addOperation:request];
    }
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [allEntries count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    RSSEntry *entry = [allEntries objectAtIndex:[indexPath row]];
    
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    NSString *articleDateString = [dateFormatter stringFromDate:[entry articleDate]];
    
    [[cell textLabel] setText:[entry articleTitle]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@", articleDateString, [entry blogTitle]];
    
    return cell;
}

#pragma mark - ASIHTTPRequestDelegate

- (void)requestFinished:(ASIHTTPRequest *)request {
    RSSEntry *entry = [[[RSSEntry alloc] initWithBlogTitle:request.url.absoluteString articleTitle:request.url.absoluteString articleUrlString:request.url.absoluteString articleDate:[NSDate date]] autorelease];
    
    int insertIndex = 0;
    [allEntries insertObject:entry atIndex:insertIndex];
    [table insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:insertIndex inSection:0]] withRowAnimation:UITableViewRowAnimationRight];
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    NSError *error = [request error];
    NSLog(@"Error: %@", error);
}

@end
