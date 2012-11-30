//
//  PAAppDelegate.m
//  PearsonApps
//
//  Created by Derrick Hathaway on 11/29/12.
//  Copyright (c) 2012 Pearson. All rights reserved.
//

#import "PAAppDelegate.h"
#import "PAAppsViewController.h"

#import "AFNetworkActivityIndicatorManager.h"

@implementation PAAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:8 * 1024 * 1024 diskCapacity:20 * 1024 * 1024 diskPath:nil];
  [NSURLCache setSharedURLCache:URLCache];
  
  [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
  
  PAAppsViewController *viewController = [[PAAppsViewController alloc] initWithCollectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
  viewController.appListPath = @"ipad_apps.html";
  viewController.appListTitle = @"Pearson Apps";
  [viewController fetchApps];
  self.navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
  
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  self.window.rootViewController = self.navigationController;
  [self.window makeKeyAndVisible];
  
  return YES;
}

@end
