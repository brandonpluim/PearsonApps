//
//  PAAppCell.m
//  PearsonApps
//
//  Created by Derrick Hathaway on 11/29/12.
//  Copyright (c) 2012 Pearson. All rights reserved.
//

#import "PAAppCell.h"

@implementation PAAppCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      self.iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, 72.f, 72.f)];
      self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 72.f, 72.f, 22.f)];
      self.titleLabel.backgroundColor = [UIColor clearColor];
      self.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:11.f];
      self.titleLabel.textColor = [UIColor whiteColor];
      self.titleLabel.shadowColor = [UIColor blackColor];
      self.titleLabel.shadowOffset = CGSizeMake(0.f, 1.f);
      self.titleLabel.textAlignment = NSTextAlignmentCenter;
      [self addSubview:self.iconView];
      [self addSubview:self.titleLabel];
    }
    return self;
}

@end
