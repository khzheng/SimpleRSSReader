//
//  ViewController.m
//  SimpleRSSReader
//
//  Created by Ken Zheng on 6/5/13.
//  Copyright (c) 2013 Ken Zheng. All rights reserved.
//

#import "ViewController.h"
#import "RSSEntry.h"
#import "GDataXMLNode.h"
#import "GDataXMLElement-Extras.h"
#import "NSDate+InternetDateTime.h"
#import "NSArray+Extras.h"
#import "WebViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize allEntries;
@synthesize queue;
@synthesize feeds;
@synthesize webViewController;

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

- (void)parseFeed:(GDataXMLElement *)rootElement entries:(NSMutableArray *)entries {
    if ([rootElement.name compare:@"rss"] == NSOrderedSame) {
        [self parseRss:rootElement entries:entries];
    } else if ([rootElement.name compare:@"feed"] == NSOrderedSame) {
        [self parseAtom:rootElement entries:entries];
    } else {
        NSLog(@"Unsupported root element: %@", rootElement.name);
    }
}

- (void)parseRss:(GDataXMLElement *)rootElement entries:(NSMutableArray *)entries {
    NSArray *channels = [rootElement elementsForName:@"channel"];
    for (GDataXMLElement *channel in channels) {
        NSString *blogTitle = [channel valueForChild:@"title"];
        
        NSArray *items = [channel elementsForName:@"item"];
        for (GDataXMLElement *item in items) {
            NSString *articleTitle = [item valueForChild:@"title"];
            NSString *articleUrlString = [item valueForChild:@"link"];
            NSString *articleDateString = [item valueForChild:@"pubDate"];
            NSDate *articleDate = [NSDate dateFromInternetDateTimeString:articleDateString formatHint:DateFormatHintRFC822];
            
            RSSEntry *entry = [[[RSSEntry alloc] initWithBlogTitle:blogTitle articleTitle:articleTitle articleUrlString:articleUrlString articleDate:articleDate] autorelease];
            [entries addObject:entry];
        }
    }
}

- (void)parseAtom:(GDataXMLElement *)rootElement entries:(NSMutableArray *)entries {
    NSString *blogTitle = [rootElement valueForChild:@"title"];
    
    NSArray *items = [rootElement elementsForName:@"entry"];
    for (GDataXMLElement *item in items) {
        NSString *articleTitle = [item valueForChild:@"title"];
        NSString *articleUrlString = nil;
        NSArray *links = [item elementsForName:@"link"];
        for (GDataXMLElement *link in links) {
            NSString *rel = [[link attributeForName:@"rel"] stringValue];
            NSString *type = [[link attributeForName:@"type"] stringValue];
            if ([rel compare:@"alternate"] == NSOrderedSame && [type compare:@"text/html"] == NSOrderedSame) {
                articleUrlString = [[link attributeForName:@"href"] stringValue];
            }
        }
        
        NSString *articleDateString = [item valueForChild:@"updated"];
        NSDate *articleDate = [NSDate dateFromInternetDateTimeString:articleDateString formatHint:DateFormatHintRFC3339];
        
        RSSEntry *entry = [[[RSSEntry alloc] initWithBlogTitle:blogTitle articleTitle:articleTitle articleUrlString:articleUrlString articleDate:articleDate] autorelease];
        [entries addObject:entry];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (webViewController == nil) {
        webViewController = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:[NSBundle mainBundle]];
    }
    
    RSSEntry *entry = [allEntries objectAtIndex:[indexPath row]];
    [webViewController setEntry:entry];
    [self.navigationController pushViewController:webViewController animated:YES];
}

#pragma mark - ASIHTTPRequestDelegate

- (void)requestFinished:(ASIHTTPRequest *)request {
//    RSSEntry *entry = [[[RSSEntry alloc] initWithBlogTitle:request.url.absoluteString articleTitle:request.url.absoluteString articleUrlString:request.url.absoluteString articleDate:[NSDate date]] autorelease];
//    
//    int insertIndex = 0;
//    [allEntries insertObject:entry atIndex:insertIndex];
//    [table insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:insertIndex inSection:0]] withRowAnimation:UITableViewRowAnimationRight];
    
    [queue addOperationWithBlock: ^{
        NSError *error;
        GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:[request responseData] options:0 error:&error];
        
        if (doc == nil) {
            NSLog(@"Failed to parse %@", [request url]);
        } else {
            NSMutableArray *entries = [NSMutableArray array];
            [self parseFeed:doc.rootElement entries:entries];
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                for (RSSEntry *entry in entries) {
                    int insertIndex = [allEntries indexForInsertingObject:entry sortedUsingBlock:^(id a, id b) {
                        RSSEntry *entry1 = (RSSEntry *)a;
                        RSSEntry *entry2 = (RSSEntry *)b;
                        return [entry1.articleDate compare:entry2.articleDate];
                    }];
                    [allEntries insertObject:entry atIndex:insertIndex];
                    [table insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:insertIndex inSection:0]] withRowAnimation:UITableViewRowAnimationRight];
                }
            }];
        }
    }];
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    NSError *error = [request error];
    NSLog(@"Error: %@", error);
}

@end
