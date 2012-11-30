//
//  PAAppsViewController.m
//  PearsonApps
//
//  Created by Derrick Hathaway on 11/29/12.
//  Copyright (c) 2012 Pearson. All rights reserved.
//

#import "PAAppsViewController.h"
#import <AFNetworking/AFHTTPClient.h>
#import "HTMLParser.h"
#import "PAApp.h"
#import "PAAppCell.h"

@interface PAAppsViewController ()
@property (strong, nonatomic) NSMutableArray *apps;
@property (strong, nonatomic) AFHTTPClient *client;
@end

@implementation PAAppsViewController

- (void)parseHTMLData:(NSData *)data
{
  NSError *err = nil;
  HTMLParser *parser = [[HTMLParser alloc] initWithData:data error:&err];
  if (!parser || err) {
    [[[UIAlertView alloc] initWithTitle:@"Parsing Error" message:[NSString stringWithFormat:@"Unable to read the list of apps from %@", [self.client.baseURL URLByAppendingPathComponent:self.appListPath]] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil] show];
    return;
  }
  
  HTMLNode *bodyNode = [parser body];
  
  NSArray *appNodes = [bodyNode findChildTags:@"p"];
  
  for (HTMLNode *pNode in appNodes) {
    if ([[pNode getAttributeNamed:@"class"] isEqualToString:@"apptext"]) {
      PAApp *app = [[PAApp alloc] init];
      HTMLNode *aNode = [pNode findChildTag:@"a"];
      app.title = [aNode allContents];
      app.path = [aNode getAttributeNamed:@"href"];
      
      NSString *imagePath = [[aNode findChildTag:@"img"] getAttributeNamed:@"src"];
      [self.client getPath:imagePath parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        app.image = [[UIImage alloc] initWithData:responseObject];
        NSUInteger newIndex = [self.apps indexOfObject:app inSortedRange:NSMakeRange(0, [self.apps count]) options:NSBinarySearchingInsertionIndex usingComparator:^NSComparisonResult(id obj1, id obj2) {
          NSString *title1 = [obj1 title];
          NSString *title2 = [obj2 title];
          return [title1 compare:title2 options:NSCaseInsensitiveSearch];
        }];
        
        [self.apps insertObject:app atIndex:newIndex];
        [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:newIndex inSection:0]]];
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[[UIAlertView alloc] initWithTitle:@"Download Error" message:[NSString stringWithFormat:@"Failed to download the app icon for %@", app.title] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil] show];
      }];
    }
  }
}

- (void)fetchApps
{
  self.apps = [NSMutableArray array];
  self.client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://www.pearsoned.com/apps/"]];
  [self.client getPath:self.appListPath parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    [self parseHTMLData:responseObject];
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    [[[UIAlertView alloc] initWithTitle:@"Connection Error" message:[NSString stringWithFormat:@"Unable to load the list of apps from %@", [self.client.baseURL URLByAppendingPathComponent:self.appListPath]] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil] show];
  }];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  [self.collectionView registerClass:[PAAppCell class] forCellWithReuseIdentifier:@"AppCell"];
  
  UICollectionViewFlowLayout *flow = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
  flow.itemSize = CGSizeMake(72.f, 94.f);
  flow.minimumInteritemSpacing = 104.f;
  flow.minimumLineSpacing = 45.f;
  flow.sectionInset = UIEdgeInsetsMake(75.f, 82.f, 75.f, 82.f);
}

- (void)viewWillAppear:(BOOL)animated
{
  self.navigationItem.title = self.appListTitle;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
  return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
  return [self.apps count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  PAAppCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AppCell" forIndexPath:indexPath];
  
  PAApp *app = [self.apps objectAtIndex:indexPath.item];
  cell.iconView.image = app.image;
  cell.titleLabel.text = app.title;
  
//  NSLog(@"item at index %u: %@", indexPath.item, app );
  
  return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
  PAApp *app = [self.apps objectAtIndex:indexPath.item];
  NSLog(@"tapped item at index %u: %@", indexPath.item, app);
  
  if ([app.path rangeOfString:@"http" options:NSAnchoredSearch | NSCaseInsensitiveSearch].location != NSNotFound) {
    NSURL *url = [NSURL URLWithString:app.path];
    if ([app.path rangeOfString:@"itunes.apple.com" options:NSCaseInsensitiveSearch].location != NSNotFound) {
      url = [NSURL URLWithString:[app.path stringByReplacingOccurrencesOfString:@"http" withString:@"itms-apps" options:NSAnchoredSearch range:NSMakeRange(0, [app.path length])]];
    }
    [[UIApplication sharedApplication] openURL:url];
  } else {
    PAAppsViewController *nextApps = [[PAAppsViewController alloc] initWithCollectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
    nextApps.appListPath = app.path;
    nextApps.appListTitle = app.title;
    [nextApps fetchApps];
    [self.navigationController pushViewController:nextApps animated:YES];
  }
}

@end
