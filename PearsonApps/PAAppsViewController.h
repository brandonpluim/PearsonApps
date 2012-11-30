//
//  PAAppsViewController.h
//  PearsonApps
//
//  Created by Derrick Hathaway on 11/29/12.
//  Copyright (c) 2012 Pearson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PAAppsViewController : UICollectionViewController
@property (strong, nonatomic) NSString *appListTitle;
@property (strong, nonatomic) NSString *appListPath;

- (void)fetchApps;
@end
