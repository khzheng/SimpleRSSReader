//
//  GDataXMLElement-Extras.h
//  SimpleRSSReader
//
//  Created by Ken Zheng on 6/7/13.
//  Copyright (c) 2013 Ken Zheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"

@interface GDataXMLElement (Extras)

- (GDataXMLElement *)elementForChild:(NSString *)childName;
- (NSString *)valueForChild:(NSString *)childName;

@end
