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

#import "GDataXMLNode.h"
#import "GDataXMLElement-Extras.h"
#import "NSDate+InternetDateTime.h"
#import "NSArray+Extras.h"

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
    
    [queue addOperationWithBlock:^{
        NSError *error;
        GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:[request responseData] options:0 error:&error];
        
        if (doc == nil) {
            NSLog(@"Failed to parse %@", [request url]);
        } else {
            NSMutableArray *tempFeedItems = [NSMutableArray array];
            [self parseFeed:doc.rootElement entries:tempFeedItems];
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                for (FeedItem *feedItem in tempFeedItems) {
                    int insertIndex = [feedItems indexForInsertingObject:feedItem sortedUsingBlock:^(id a, id b) {
                        FeedItem *feedItem1 = (FeedItem *)a;
                        FeedItem *feedItem2 = (FeedItem *)b;
                        return [[feedItem1 date] compare:[feedItem2 date]];
                    }];
                    [feedItems insertObject:feedItem atIndex:insertIndex];
                    [table insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:insertIndex inSection:0]] withRowAnimation:UITableViewRowAnimationRight];
                }
            }];
        }
    }];
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    NSLog(@"requestFailed: %@", [request error]);
}

#pragma mark - Parsing

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
            NSString *articleUrl = [item valueForChild:@"link"];
            NSString *articleDateString = [item valueForChild:@"pubDate"];
            NSDate *articleDate = [NSDate dateFromInternetDateTimeString:articleDateString formatHint:DateFormatHintRFC822];
            
            FeedItem *feedItem = [[[FeedItem alloc] initWithTitle:articleTitle link:articleUrl date:articleDate updated:nil summary:nil content:nil] autorelease];
            [entries addObject:feedItem];
        }
    }
    
}

- (void)parseAtom:(GDataXMLElement *)rootElement entries:(NSMutableArray *)entries {
    
    NSString *blogTitle = [rootElement valueForChild:@"title"];
    
    NSArray *items = [rootElement elementsForName:@"entry"];
    for (GDataXMLElement *item in items) {
        
        NSString *articleTitle = [item valueForChild:@"title"];
        NSString *articleUrl = nil;
        NSArray *links = [item elementsForName:@"link"];
        for(GDataXMLElement *link in links) {
            NSString *rel = [[link attributeForName:@"rel"] stringValue];
            NSString *type = [[link attributeForName:@"type"] stringValue];
            if ([rel compare:@"alternate"] == NSOrderedSame &&
                [type compare:@"text/html"] == NSOrderedSame) {
                articleUrl = [[link attributeForName:@"href"] stringValue];
            }
        }
        
        NSString *articleDateString = [item valueForChild:@"updated"];
        NSDate *articleDate = [NSDate dateFromInternetDateTimeString:articleDateString formatHint:DateFormatHintRFC3339];
        
        FeedItem *feedItem = [[[FeedItem alloc] initWithTitle:articleTitle link:articleUrl date:articleDate updated:nil summary:nil content:nil] autorelease];
        [entries addObject:feedItem];
    }      
    
}

@end
