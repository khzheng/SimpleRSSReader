//
//  AppDelegate.h
//  SimpleRSSReader
//
//  Created by Ken Zheng on 6/5/13.
//  Copyright (c) 2013 Ken Zheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SubscriptionViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) SubscriptionViewController *subscriptionViewController;

@property (strong, nonatomic) UINavigationController *navigationController;

@end
