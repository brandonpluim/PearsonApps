//
//  PAApp.m
//  PearsonApps
//
//  Created by Derrick Hathaway on 11/29/12.
//  Copyright (c) 2012 Pearson. All rights reserved.
//

#import "PAApp.h"

@implementation PAApp
- (NSString *)description
{
  return [NSString stringWithFormat:@"%@ <%@>", self.title, self.path];
}
@end
